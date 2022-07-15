#!/bin/bash

#安装环境

sudo apt upgrade && sudo apt install m4 g++ flex bison make gcc git curl wget lzip vim util-linux -y

#安装GO

if ! [ -x "$(command -v go)" ]; then
  ver="1.16.5"
  cd $HOME
  wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
  rm "go$ver.linux-amd64.tar.gz"
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
  source ~/.bash_profile
fi
go version

#安装PBC库

sudo wget https://gmplib.org/download/gmp/gmp-6.2.1.tar.lz

sudo lzip -d gmp-6.2.1.tar.lz

sudo tar -xvf gmp-6.2.1.tar

cd gmp-6.2.1/

sudo chmod +x ./configure

sudo ./configure --enable-cxx

sudo make

sudo make check

sudo make install

cd $HOME

sudo wget https://crypto.stanford.edu/pbc/files/pbc-0.5.14.tar.gz

sudo tar -zxvf pbc-0.5.14.tar.gz

cd pbc-0.5.14/

sudo chmod +x ./configure

sudo ./configure

sudo make

sudo make install

sudo touch /etc/ld.so.conf.d/libpbc.conf

sudo echo "/usr/local/lib" >> /etc/ld.so.conf.d/libpbc.conf

sudo ldconfig

cd $HOME

#安装存储库

cd $HOME
rm cess-bucket -rf
git clone https://github.com/CESSProject/cess-bucket.git
cd cess-bucket
git checkout -b v0.4.3 v0.4.3
go build -o bucket cmd/main/main.go
chmod +x bucket && sudo ./bucket default && mv config_template.toml conf.toml


#修改配置

MountedPath="/"
StorageSpace=6144
ServicePort=15001
IncomeAcc="cXjZmp4pR6N9roaszNDiCB5gD7rvrAo9cdvWzbjySq7eP35Bg"


sed -i -e "s/^MountedPath *=.*/MountedPath = \"$MountedPath\"/" $HOME/cess-bucket/conf.toml
sed -i -e "s/^StorageSpace *=.*/StorageSpace = \"$StorageSpace\"/" $HOME/cess-bucket/conf.toml
sed -i -e "s/^ServicePort *=.*/ServicePort = \"$ServicePort\"/" $HOME/cess-bucket/conf.toml
sed -i -e "s/^IncomeAcc *=.*/IncomeAcc = \"$IncomeAcc\"/" $HOME/cess-bucket/conf.toml
sed -i.bak -e "s%^RpcAddr = \"\"%RpcAddr = \"wss://testnet-rpc0.cess.cloud/ws/\"%" $HOME/cess-bucket/conf.toml


