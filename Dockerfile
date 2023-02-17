FROM photon:4.0

ENV TERM=linux-basic
ENV PORT=8080

RUN echo "/usr/bin/pwsh" >> /etc/shells
RUN echo "/bin/pwsh" >> /etc/shells
RUN POWERSHELL_VERSION=7.2.7-2.ph4 ICU_VERSION=70.1-3.ph4 CURL_VERSION=7.86.0-3.ph4 RPM_LIBS=4.16.1.3-14.ph4 && \
    tdnf install -y powershell-${POWERSHELL_VERSION} icu-${ICU_VERSION} curl-${CURL_VERSION} rpm-libs-${RPM_LIBS} 
RUN tdnf clean all

RUN pwsh -c "Set-PSRepository -Name PSGallery -InstallationPolicy Trusted"
RUN THREADJOB_VERSION=2.0.3 CLOUDEVENTS_SDK_VERSION=0.3.3 && \
    pwsh -c "Install-Module ThreadJob -Force -Confirm:\$false -RequiredVersion ${THREADJOB_VERSION}" && \
    pwsh -c "Install-Module -Name CloudEvents.Sdk -RequiredVersion ${CLOUDEVENTS_SDK_VERSION}" 

RUN find / -name "net45" | xargs rm -rf

RUN mkdir -p /root/.config/powershell
RUN echo '$ProgressPreference = "SilentlyContinue"' > /root/.config/powershell/Microsoft.PowerShell_profile.ps1

RUN POWERCLI_VERSION=13.0.0.20829139 && \
    pwsh -c "Install-Module VMware.PowerCLI -RequiredVersion ${POWERCLI_VERSION}"
RUN pwsh -c 'Set-PowerCLIConfiguration -ParticipateInCEIP $true -confirm:$false'

COPY server.ps1 ./
