# Sets up powershell for deployment

Set-PSRepository PSGallery -InstallationPolicy Trusted
Install-Module -Name PSToml -Scope CurrentUser