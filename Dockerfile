FROM debian:jessie
MAINTAINER Naoaki Obiki
RUN apt-get update && apt-get install -y sudo git
ARG username="9zilla"
ARG password="9zilla"
RUN mkdir /home/$username
RUN useradd -s /bin/bash -d /home/$username $username && echo "$username:$password" | chpasswd
RUN echo ${username}' ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/$username
RUN mkdir -p /home/$username/ci
RUN chown -R $username:$username /home/$username
RUN apt-get install -y make gcc g++ vim tig dbus bash-completion supervisor bzip2 unzip tree sed pandoc locales dialog chrony openssl curl wget expect cron dnsutils procps siege htop inetutils-traceroute iftop bmon iptraf nload slurm sl toilet lolcat lsb-release
RUN locale-gen ja_JP.UTF-8 && localedef -f UTF-8 -i ja_JP ja_JP
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:jp
ENV LC_ALL ja_JP.UTF-8
RUN cp -p /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN sed -ri "s/^server 0.debian.pool.ntp.org/#server 0.debian.pool.ntp.org/" /etc/chrony/chrony.conf
RUN sed -ri "s/^server 1.debian.pool.ntp.org/#server 1.debian.pool.ntp.org/" /etc/chrony/chrony.conf
RUN sed -ri "s/^server 2.debian.pool.ntp.org/#server 2.debian.pool.ntp.org/" /etc/chrony/chrony.conf
RUN sed -ri "s/^server 3.debian.pool.ntp.org/#server 3.debian.pool.ntp.org/" /etc/chrony/chrony.conf
RUN echo "server ntp0.jst.mfeed.ad.jp" >> /etc/chrony/chrony.conf
RUN echo "server ntp1.jst.mfeed.ad.jp" >> /etc/chrony/chrony.conf
RUN echo "server ntp2.jst.mfeed.ad.jp" >> /etc/chrony/chrony.conf
RUN echo "allow 172.18/12" >> /etc/chrony/chrony.conf
RUN systemctl enable chrony
RUN sudo -u $username mkdir -p /home/$username/gitwork/bitbucket/dotfiles/
RUN sudo -u $username git clone "https://nobiki@bitbucket.org/nobiki/dotfiles.git" /home/$username/gitwork/bitbucket/dotfiles/
RUN sudo -u $username cp /etc/bash.bashrc /home/$username/.bashrc
RUN sudo -u $username cp /home/$username/gitwork/bitbucket/dotfiles/.bash_profile /home/$username/.bash_profile
RUN sudo -u $username cp /home/$username/gitwork/bitbucket/dotfiles/.gitconfig /home/$username/.gitconfig
RUN sudo -u $username mkdir -p /home/$username/.ssh/
RUN sudo -u $username cp /home/$username/gitwork/bitbucket/dotfiles/.ssh/config /home/$username/.ssh/config
RUN echo "export LANG=ja_JP.UTF-8" >> /home/$username/.bash_profile
RUN echo "export LANGUAGE=ja_JP:jp" >> /home/$username/.bash_profile
RUN echo "export LC_ALL=ja_JP.UTF-8" >> /home/$username/.bash_profile
RUN curl -o /usr/local/bin/hcat "https://raw.githubusercontent.com/nobiki/bash-hcat/master/hcat" && chmod +x /usr/local/bin/hcat
RUN curl -o /usr/local/bin/jq "http://stedolan.github.io/jq/download/linux64/jq" && chmod +x /usr/local/bin/jq
RUN echo 'if [ -e $HOME/.anyenv/bin ]; then' >> /home/$username/.bash_profile
RUN echo '  export PATH="$HOME/.anyenv/bin:$PATH"' >> /home/$username/.bash_profile
RUN echo '  eval "$(anyenv init -)"' >> /home/$username/.bash_profile
RUN echo 'fi' >> /home/$username/.bash_profile
RUN apt-get install -y direnv
RUN echo 'eval "$(direnv hook bash)"' >> /home/$username/.bash_profile
