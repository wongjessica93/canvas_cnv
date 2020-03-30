## Dockerfile skeleton

FROM ubuntu:18.04
LABEL maintainer="Miguel Brown (brownm28@email.chop.edu)"
LABEL developer="Jessica Wong wongj4@email.chop.edu"

ENV CANVAS_VERSION=1.40.0.1613
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y wget build-essential curl sudo  vim && \
wget https://download.visualstudio.microsoft.com/download/pr/1ac0b9ff-cfb8-4ccc-a2e8-81188af12b54/c94d82d604ac0d16b26843f8fdade618/dotnet-sdk-2.1.700-linux-x64.tar.gz && \
ln -s /dotnet /usr/local/bin/ && \
tar -xzf dotnet-sdk-2.1.700-linux-x64.tar.gz && rm dotnet-sdk-2.1.700-linux-x64.tar.gz && \
wget https://github.com/Illumina/canvas/releases/download/${CANVAS_VERSION}%2Bmaster/Canvas-${CANVAS_VERSION}.master_x64.tar.gz && \
tar -xzf Canvas-${CANVAS_VERSION}.master_x64.tar.gz && rm Canvas-${CANVAS_VERSION}.master_x64.tar.gz && cd Canvas-${CANVAS_VERSION}+master_x64/ 



############################################################################
# v1.11

FROM ubuntu:18.04
LABEL maintainer="Miguel Brown (brownm28@email.chop.edu)"
LABEL developer="Jessica Wong wongj4@email.chop.edu"

ENV DEBIAN_FRONTEND=noninteractive
ENV CANVAS_VERSION=1.11.0

RUN apt update && apt install -y wget build-essential curl sudo zip vim && \
wget https://github.com/Illumina/canvas/releases/download/v${CANVAS_VERSION}/Canvas-${CANVAS_VERSION}_x64.zip && \
unzip Canvas-${CANVAS_VERSION}_x64.zip && \
rm Canvas-${CANVAS_VERSION}_x64.zip && \
apt install -y  gnupg ca-certificates && \
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list && \
apt -y install mono-devel
RUN apt -y install mono-complete mono-dbg ca-certificates-mono mono-xsp4



############################################################################
## building docker

docker build -t wongj4/canvas:1.40.0.1613 ./docker
docker run -it wongj4/canvas:1.40.0.1613
docker run -it --mount type=bind,source=/home/ubuntu/volume/canvas,target=/TEST kfdrc/canvas:1.11.0
wongj4/canvas:1.11.0

# docker run -it --volume=/home/ubuntu/volume/canvas:/tmp/mount:rw wongj4/canvas:1.40.0.1613 

save docker file `dirname/Dockerfile`



# test that it is working
dotnet Canvas.dll Tumor-normal-enrichment \
 -b cfea8017-9fda-42ec-a500-50d6c80f61bd.bam --normal-bam=a4e3a9af-e8a9-4eca-ba43-3bf1a6de32ae.bam \
 --manifest=chr_list.txt --reference=Homo_sapiens_assembly38.fasta \
 -n P-05 -o P-05_CNVtest -g /home/ubuntu/volume/canvas/TEST

