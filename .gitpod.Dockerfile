FROM archlinux

RUN pacman -Syu --noprogressbar --noconfirm --needed \
    git \
    git-lfs \
    docker \
    sudo \
    base-devel \
    fish \
    neovim \
    zip \
    unzip \
    wget nodejs npm vim

#### Taken From gitpod/workspace-base with slight modifications
### Gitpod user ###
RUN useradd -l -u 33333 -G wheel -md /home/gitpod -s /bin/bash -p gitpod gitpod \
    && echo '%wheel   ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/no_password_sudo \
    # To emulate the workspace-session behavior within dazzle build env
    && mkdir /workspace && chown -hR gitpod:gitpod /workspace

ENV HOME=/home/gitpod
WORKDIR $HOME

### Gitpod user (2) ###
USER gitpod
# use sudo so that user does not get sudo usage info on (the first) login
RUN sudo echo "Running 'sudo' for Gitpod: success"
RUN mkdir /home/gitpod/.bashrc.d
RUN (echo; echo "for i in \$(ls \$HOME/.bashrc.d/*); do source \$i; done"; echo) >> /home/gitpod/.bashrc

RUN sudo git lfs install --system
# add aur
RUN sudo su gitpod -c cd /tmp && \
    git clone https://aur.archlinux.org/yay-bin && \
    cd yay-bin && \
    makepkg -si --noconfirm

#install zulu first so gradle does not install jdk-18
RUN yay -Sy --noconfirm --removemake zulu-17-bin
RUN yay -Sy --noconfirm --removemake metals bloop scala-dotty gradle

WORKDIR /tmp
RUN bash -c "git clone https://github.com/offbeat-stuff/gitpod-dotfiles dotfiles && cd dotfiles && ./install.sh"

USER gitpod
WORKDIR /workspace
