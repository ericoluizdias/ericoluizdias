Set-ExecutionPolicy Bypass -Scope Process

# PRe RESTART
Echo "Desinstalando Client do SCCM"

C:\Windows\ccmsetup\ccmsetup.exe /uninstall

Start-Sleep -Seconds 10

#######
Echo "Removendo do Dominio"

cmd /c start /B /W wmic.exe /interactive:off ComputerSystem Where "Name='%computername%'" Call UnJoinDomainOrWorkgroup FUnjoinOptions=0

Start-Sleep -Seconds 10

########
"Hostname: $env:computername" | Out-File -FilePath c:\Hostname.txt -Append

####
Echo "Alterando nome do WorkGroup"

cmd /c start /B /W wmic.exe /interactive:off ComputerSystem Where "Name='%computername%'" Call JoinDomainOrWorkgroup name="VALID"

Start-Sleep -Seconds 10

#######
cmd.exe --% /c icacls "C:\Users" /grant Todos:(OI)(CI)F /T

Echo "Inicio da copia dos perfis"

$profiles = Get-ChildItem C:\Users -Directory

cmd.exe /c net user admwks Art.dot-202445

Echo "Instalando Pacote de Provisionamento"

Install-ProvisioningPackage -PackagePath C:\users\Public\Valid_BRNCSPXXXX.ppkg -QuietInstall

Install-ProvisioningPackage -PackagePath C:\users\Public\Valid_BRNCSPXXXX.ppkg -QuietInstall -ForceInstall

#shutdown.exe /r /t 60 /f