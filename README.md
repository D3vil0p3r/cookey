# cookey
 cookey is an open source tool born for helping security professionals to understand the impacts related to the misuse of cookies. The purpose of the project is to raise awareness about the consequences on a malicious usage of these security elements and help security architects to implement proper mitigations.

 Currently, the project is in alpha phase.

 If you are interested and would like to contribute, feel free to join us ^^!

Screenshot
--
![Screenshot](https://github.com/D3vil0per/cookey/blob/main/images/screenshot.png)

Installing
--
You can download the latest archive by clicking [here](https://github.com/D3vil0per/cookey/archive/refs/heads/main.zip).

Preferably, you can download sqlmap by cloning the [Git](https://github.com/sqlmapproject/sqlmap) repository:

    gh repo clone D3vil0per/cookey

cookey works out of the box with [PowerShell](https://docs.microsoft.com/en-us/powershell/) version **5.1**.

cookey requires PSSQLite PowerShell module from PSGallery repository to work correctly.
Open a PowerShell terminal as Administrator and type:

```powershell
Install-Module PSSQLite
```
Usage
----
    PS C:\<path>\> .\cookey.ps1

Keep attention!
----
The "Import" features does still not work. Some browsers store cookies in encrypted ways so the results will be encrypted but the user can search for online programs to encrypt them.