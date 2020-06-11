#!/bin/bash
# export https_proxy=http://192.168.203.1:7890
# check git
ret=`git --version`
if [[ $? -eq 0 &&  $ret =~ "git version" ]] 
then 
    echo "git installed. "
else 
    sudo apt-get install -y git
fi
# check curl
ret=`curl --version`
if [[ $? -eq 0 &&  $ret =~ "curl" ]] 
then 
    echo "curl installed. "
else 
    sudo apt-get install -y curl
fi
# check zsh
ret=`zsh --version`
if [[ $? -eq 0 &&  $ret =~ "zsh" ]] 
then 
    echo "zsh installed. "
else 
    sudo apt-get install -y zsh
fi

if [[ ! -e install.sh ]]
then 
    echo "download intsall.sh"
    curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o install.sh
fi
if [[ ! -e install.sh ]]
then 
    echo "download faild"
    exit
fi

# check directory
if [ -e $HOME/.oh-my-zsh ]
then
    echo "directory .oh-my-zsh exist"
    OPTIONS="skip reinstall quit"
    select opt in $OPTIONS
    do
    if [ "$opt" = "quit" ]
    then
        echo done
        exit
    elif [ "$opt" = "reinstall" ]
    then
        echo "delete directory .oh-my-zsh"
        rm -rf $HOME/.oh-my-zsh
        rm -rf $HOME/.zshrc
        sh install.sh <<INPUT
Y
INPUT
        if [[ ! -e $HOME/.zshrc || ! -e $HOME/.oh-my-zsh ]]; then
            echo "install faild"
            exit
        else
            echo "exec zsh" >> ~/.bashrc
        fi
        break
    elif [ "$opt" = "skip" ]
    then
        break
    else
        echo bad option
        exit
    fi
    done
else
    sh install.sh <<INPUT
Y
INPUT
    if [[ ! -e $HOME/.zshrc || ! -e $HOME/.oh-my-zsh ]]; then
        echo "install faild"
        exit
    else
        echo "exec zsh" >> ~/.bashrc
    fi
fi

if [[ ! -e $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting ]]; then
    echo "install zsh-syntax-highlighting"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting
fi
if [[ ! -e $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting ]]; then
    echo "install zsh-syntax-highlighting faild"
fi

if [[ ! -e $HOME/.oh-my-zsh/plugins/zsh-autosuggestions ]]; then
    echo "install zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/plugins/zsh-autosuggestions
fi
if [[ ! -e $HOME/.oh-my-zsh/plugins/zsh-autosuggestions ]]; then
    echo "install zsh-autosuggestions faild"
fi


if [[ -e $HOME/.oh-my-zsh/plugins/zsh-autosuggestions && -e $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting ]]; then
    sed 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc > tmp
    mv tmp ~/.zshrc
    zsh
fi
