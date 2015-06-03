#docker-rtorrent-rutorrent [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/Micka33/docker-rtorrent-rutorrent?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

[![Join the chat at https://gitter.im/Micka33/docker-rtorrent-rutorrent](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/Micka33/docker-rtorrent-rutorrent?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

a docker containing ruTorrent ready to use.

## Dependency

- [Docker](https://www.docker.com/)  
  - [Mac OS X](https://docs.docker.com/installation/mac/)  
  - [Ubuntu](https://docs.docker.com/installation/ubuntulinux/)  
  - [Red Hat Enterprise Linux](https://docs.docker.com/installation/rhel/)
  - [CentOS](https://docs.docker.com/installation/centos/)
  - [Debian](https://docs.docker.com/installation/debian/)
  - [Gentoo](https://docs.docker.com/installation/gentoolinux/)
  - [Google Cloud Platform](https://docs.docker.com/installation/google/)
  - [Rackspace Cloud](https://docs.docker.com/installation/rackspace/)
  - [Amazon EC2](https://docs.docker.com/installation/amazon/)
  - [IBM Softlayer](https://docs.docker.com/installation/softlayer/)
  - [Arch Linux](https://docs.docker.com/installation/archlinux/)
  - [FrugalWare](https://docs.docker.com/installation/frugalware/)
  - [Fedora](https://docs.docker.com/installation/fedora/)
  - [openSUSE](https://docs.docker.com/installation/openSUSE/)
  - [CRUX Linux](https://docs.docker.com/installation/cruxlinux/)
  - [Microsoft Windows](https://docs.docker.com/installation/windows/)


## Install it

```bash
git https://github.com/Micka33/docker-rtorrent-rutorrent.git
cd docker-rtorrent-rutorrent
sudo docker build -t rutorrent_image ./docker_files
```

## Run it

```bash
sudo docker run --name rutorrent -d -p 80:80 -p 0.0.0.0:63256:63256 -v `pwd`/mounted:/root/mounted rutorrent_image
```
