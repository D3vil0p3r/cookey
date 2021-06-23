function Show-ChoicesMenu ()
{
$cookies = New-Object System.Management.Automation.Host.ChoiceDescription '&Cookies', "Get browser's cookies"
$import = New-Object System.Management.Automation.Host.ChoiceDescription '&Import', "Import an external cookies DB to a browser's cookies DB"

$options = [System.Management.Automation.Host.ChoiceDescription[]]($cookies, $import)

$title = 'Cookey menu'
$message = 'Which activity do you want to cookey?'
$result = $host.ui.PromptForChoice($title, $message, $options, 0)

return $result
}

function Show-CookeyMenu ()
{

$chrome = New-Object System.Management.Automation.Host.ChoiceDescription '&Chrome', 'Target browser: Google Chrome'
$firefox = New-Object System.Management.Automation.Host.ChoiceDescription '&Firefox', 'Target browser: Mozilla Firefox'
$edge = New-Object System.Management.Automation.Host.ChoiceDescription '&Edge', 'Target browser: Microsoft Edge'

$options = [System.Management.Automation.Host.ChoiceDescription[]]($chrome, $firefox, $edge)

$title = 'Target browser'
$message = 'Which browser do you want to cookey?'
$result = $host.ui.PromptForChoice($title, $message, $options, 0)

return $result

}

function Show-HostMenu ()
{
$all_host = New-Object System.Management.Automation.Host.ChoiceDescription '&All', 'All hosts'
$specified_host = New-Object System.Management.Automation.Host.ChoiceDescription '&Choose', 'Choose host'

$options = [System.Management.Automation.Host.ChoiceDescription[]]($all_host, $specified_host)

$title = 'Specify hosts'
$message = 'Which host do you want to show?'
$result = $host.ui.PromptForChoice($title, $message, $options, 0)

return $result
}

function Show-CookieNameMenu ()
{
$all_cookie = New-Object System.Management.Automation.Host.ChoiceDescription '&All', 'All cookies'
$specified_cookie = New-Object System.Management.Automation.Host.ChoiceDescription '&Choose', 'Choose cookie'

$options = [System.Management.Automation.Host.ChoiceDescription[]]($all_cookie, $specified_cookie)

$title = 'Specify cookies'
$message = 'Which cookie do you want to show?'
$result = $host.ui.PromptForChoice($title, $message, $options, 0)

return $result
}

function Show-SendEmail ()
{
$Conf = New-Object System.Management.Automation.Host.ChoiceDescription '&Yes', 'Send email'
$Disc = New-Object System.Management.Automation.Host.ChoiceDescription '&No', "Don't send email"

$options = [System.Management.Automation.Host.ChoiceDescription[]]($Conf, $Disc)

$title = 'Send mail'
$message = 'Do you want to send this information to an email address?'
$result = $host.ui.PromptForChoice($title, $message, $options, 1)

return $result
}