function Set-Constant {

  Set-Variable chromeName -Option ReadOnly -Value "Chrome" -Scope Global -Force
  Set-Variable edgeName -Option ReadOnly -Value "Microsoft Edge" -Scope Global -Force
  Set-Variable firefoxName -Option ReadOnly -Value "Firefox" -Scope Global -Force

  Set-Variable chromeProfilePath -Option ReadOnly -Value "$($env:LOCALAPPDATA)\Google\Chrome\User Data\" -Scope Global -Force
  Set-Variable edgeProfilePath -Option ReadOnly -Value "$($env:LOCALAPPDATA)\Microsoft\Edge\User Data\" -Scope Global -Force
  Set-Variable firefoxProfilePath -Option ReadOnly -Value "$($env:APPDATA)\Mozilla\Firefox\Profiles\" -Scope Global -Force

  Set-Variable chromeKeyPath -Option ReadOnly -Value "$($chromeProfilePath)Local State" -Scope Global -Force
  Set-Variable edgeKeyPath -Option ReadOnly -Value "$($edgeProfilePath)Local State" -Scope Global -Force
  #Set-Variable firefoxKeyPath -Option ReadOnly -Value "$($firefoxProfilePath)Local State" -Scope Global -Force

  Set-Variable chromeCookiePath -Option ReadOnly -Value "$($chromeProfilePath)Default\Cookies" -Scope Global -Force
  Set-Variable edgeCookiePath -Option ReadOnly -Value "$($edgeProfilePath)Default\Cookies" -Scope Global -Force
  Set-Variable firefoxCookiePath -Option ReadOnly -Value "$($firefoxProfilePath)$(Get-ChildItem -Path "$($env:APPDATA)\Mozilla\Firefox\Profiles\" | Select-String -Pattern '.default-release')\cookies.sqlite" -Scope Global -Force

}