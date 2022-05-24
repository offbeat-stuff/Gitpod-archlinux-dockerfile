FROM archlinux

RUN pacman -Syu --noconfirm --needed \
    git \
    git-lfs \
    docker \
    sudo \
    base-devel

#### Taken From gitpod/workspace-base with slight modifications
### Gitpod user ###
RUN useradd -l -u 33333 -G wheel -md /home/gitpod -s /bin/bash -p gitpod gitpod
RUN sed -i.bkp -e 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers 

ENV HOME=/home/gitpod
WORKDIR $HOME

### Gitpod user (2) ###
USER gitpod
# use sudo so that user does not get sudo usage info on (the first) login
RUN sudo echo "Running 'sudo' for Gitpod: success"
RUN mkdir /home/gitpod/.bashrc.d
RUN (echo; echo "for i in \$(ls \$HOME/.bashrc.d/*); do source \$i; done"; echo) >> /home/gitpod/.bashrc

# configure git-lfs
RUN sudo git lfs install --system
####

# add yay for aur
RUN sudo su gitpod -c cd /tmp && \
    git clone https://aur.archlinux.org/yay-bin && \
    cd yay-bin && \
    makepkg -si --noconfirm
RUN sudo su gitpod -c "yay -Syu --noconfirm neofetch"
RUN sudo su gitpod -c "git clone https://github.com/offbeat-stuff/gitpod-dotfiles ~/dotfiles && cd ~/dotfiles && chmod +x ./install.{fish,sh} && ./install.sh"
