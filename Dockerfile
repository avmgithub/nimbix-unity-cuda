FROM nvidia/cuda:8.0-cudnn7-devel-ubuntu16.04

RUN apt-get -y update && \
    apt-get -y install curl && \
    curl -H 'Cache-Control: no-cache' \
        https://raw.githubusercontent.com/nimbix/image-common/master/install-nimbix.sh \
        | bash -s -- --setup-nimbix-desktop

RUN apt-get install -y libnspr4 libnss3 libpango1.0-0  xdg-utils libpq5 npm
RUN curl http://beta.unity3d.com/download/ad31c9083c46/unity-editor_amd64-2017.2.0f1.deb --output unity-editor_amd64-2017.2.0f1.deb
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash 
RUN apt-get install git-lfs && sudo git lfs install

# Expose port 22 for local JARVICE emulation in docker
EXPOSE 22

# for standalone use
EXPOSE 5901
EXPOSE 443

# Install CUDA samples
RUN apt-get -y install cuda-samples-8-0

# Fix VirtualGL for sudo
RUN chmod u+s /usr/lib/libdlfaker.so /usr/lib/libvglfaker.so

# Metadata
COPY NAE/AppDef.json.8.0-cudnn7-devel-ubuntu16.04 /etc/NAE/AppDef.json
RUN curl --fail -X POST -d @/etc/NAE/AppDef.json https://api.jarvice.com/jarvice/validate
