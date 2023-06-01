# Use an appropriate base image for Windows
FROM mcr.microsoft.com/windows/server:ltsc2022
# Set shell to PowerShell
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# # Install Git
RUN Invoke-WebRequest -Uri https://github.com/git-for-windows/git/releases/download/v2.40.1.windows.1/MinGit-2.40.1-64-bit.zip -OutFile git.zip; \
    Expand-Archive -Path git.zip -DestinationPath C:\git; \
    Remove-Item -Path git.zip -Force; \
    Remove-Item -Path C:\git\etc\profile.d\*.exe -Force; \
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -Name Path -Value $('C:\git\cmd;{0}' -f $env:Path)


# # Set Git and PowerShell environment variables
RUN [System.Environment]::SetEnvironmentVariable('path', "C:\git\cmd;" + [System.Environment]::GetEnvironmentVariable('path', "Machine"), "Machine"); \
[System.Environment]::SetEnvironmentVariable('path', "C:\git\cmd;" + [System.Environment]::GetEnvironmentVariable('path', "User"), "User"); \
[Environment]::SetEnvironmentVariable('path', "C:\git\cmd;" + [Environment]::GetEnvironmentVariable('path', "Machine"), "Machine"); \
[Environment]::SetEnvironmentVariable('path', "C:\git\cmd;" + [Environment]::GetEnvironmentVariable('path', "User"), "User"); 
# # Verify installation


# RUN winget install --id=Git.MinGit  -e

# Start a shell session

