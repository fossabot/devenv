FROM ruby:2.6-slim-buster

# Locales
ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8

# Better terminal support
ENV TERM screen-256color
ENV DEBIAN_FRONTEND noninteractive

# Common packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
	curl \
  fzf \
  git  \
  libevent-dev \
	locales \
	python3-dev \
  python3-pip \
  python3-neovim \
  rubygems \
  silversearcher-ag \
  software-properties-common \
  tzdata \
  zsh \
  silversearcher-ag && \
	locale-gen en_US.UTF-8 && \
	chsh -s /usr/bin/zsh && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip3 install --user neovim
RUN pip3 install pynvim

########################################
# Personalizations
########################################
# Setup non root user
RUN groupadd -g 1000 blijblijblij
RUN useradd -m -d /home/blijblijblij -s /bin/bash -g blijblijblij -u 1000 blijblijblij
USER blijblijblij

# Add nvim config. Put this last since it changes often
RUN mkdir -p /home/blijblijblij/.config/nvim
RUN curl -fLo /home/blijblijblij/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
COPY --chown=blijblijblij init.vim /home/blijblijblij/.config/nvim

# Install neovim plugins
RUN vim +PlugInstall +qall > /dev/null

# Install some usefull gems
RUN gem install rails \
  rubocop \
  rubocop-performance \
  rubocop-rails \
  rubocop-rspec

# Set the workdir
WORKDIR /src

