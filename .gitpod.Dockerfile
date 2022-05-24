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

RUN mkdir /home/gitpod/.bashrc.d
RUN (echo; echo "for i in \$(ls \$HOME/.bashrc.d/*); do source \$i; done"; echo) >> /home/gitpod/.bashrc

USER root
# configure git-lfs
RUN git lfs install --system
####
RUN pacman -Sy --noconfirm fish neovim wget unzip nodejs

USER gitpod
WORKDIR /tmp
RUN bash -c "git clone https://github.com/offbeat-stuff/gitpod-dotfiles ~/dotfiles && cd ~/dotfiles && chmod +x ./install.{fish,sh} && ./install.sh"

WORKDIR /workspace
CMD ["bash"]
