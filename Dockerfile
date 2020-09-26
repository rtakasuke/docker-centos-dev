FROM centos:7
ADD . .

RUN yum install -y http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-1.noarch.rpm
RUN yum install -y git
RUN [".dotfiles/bin/init.sh"]
