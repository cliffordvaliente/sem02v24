FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
&& apt-get dist-upgrade -y \
&& apt-get autoremove -y \
&& apt-get autoclean -y \
&& apt-get install -y \
sudo \
nano \
wget \
curl \
git \
build-essential \
gcc \
openjdk-21-jdk \
mono-complete \
python3 \
strace \
valgrind

RUN useradd -G sudo -m -d /home/cliffordvaliente -s /bin/bash -p "$(openssl passwd -1 cliffordvaliente)" cliffordvaliente
USER cliffordvaliente
WORKDIR /home/cliffordvaliente
RUN mkdir hacking \
&& cd hacking \
&& curl -SL https://raw.githubusercontent.com/uia-worker/is105misc/master/sem01v24/pawned.sh > pawned.sh \
&& chmod 764 pawned.sh \
&& cd ..
RUN git config --global user.email "cliffyxvaliente@icloud.com"\
&& git config --global user.name "cliffordvaliente" \
&& git config --global url."https:/@github.com/".insteadOf "https://github.com" \
&& mkdir -p github.com/cliffordvaliente
USER root
RUN curl -SL https://go.dev/dl/go1.21.7.linux-arm64.tar.gz \
| tar xvz -C /usr/local
USER cliffordvaliente
SHELL ["/bin/bash", "-c"]
RUN mkdir -p $HOME/go/{src,bin}
ENV GOPATH="/home/cliffordvaliente/go"
ENV PATH="${PATH}:${GOPATH}/bin:/usr/local/go/bin"

RUN curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf \
| sh -s -- -y
ENV PATH="${PATH}:${HOME}/.cargo/bin"