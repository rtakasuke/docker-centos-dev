FROM centos:7
ENV HOME /root

# for japanese language
RUN localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

# import GPG keys for prevent warnings
RUN rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7
RUN rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
RUN rpm --import https://download.copr.fedorainfracloud.org/results/dperson/neovim/pubkey.gpg

# install yum packages
RUN yum update -y && yum clean all
RUN yum install -y epel-release && yum clean all
RUN yum install -y zsh sudo zlib zlib-devel make gcc gcc-c++ \
                   bzip2 bzip2-devel readline readline-devel sqlite sqlite-devel openssl openssl-devel libffi-devel \
                   unzip wget git tig curl tree zsh python36 python36-libs python36-devel python36-pip \
                   && yum clean all
RUN curl -o /etc/yum.repos.d/dperson-neovim-epel-7.repo https://copr.fedorainfracloud.org/coprs/dperson/neovim/repo/epel-7/dperson-neovim-epel-7.repo
RUN yum install -y neovim && yum clean all

# install pyenv
RUN curl https://bootstrap.pypa.io/get-pip.py | python3
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/bin:$PATH

# init dotfiles
WORKDIR $HOME
COPY .dotfiles .dotfiles
RUN pwd && ls -l
RUN .dotfiles/bin/init.sh

CMD ["/bin/zsh"]
