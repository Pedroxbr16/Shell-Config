#!/bin/bash

set -e

echo "Atualizando repositórios e pacotes..."
sudo apt update && sudo apt upgrade -y

echo "Instalando ferramentas básicas..."
sudo apt install -y build-essential curl wget git unzip vim tmux software-properties-common apt-transport-https ca-certificates gnupg lsb-release

echo "Instalando Python 3, pip e venv (necessários para pyenv)..."
sudo apt install -y python3 python3-pip python3-venv

echo "Instalando dependências necessárias para pyenv..."
sudo apt install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev libffi-dev liblzma-dev python3-openssl git

echo "Instalando Node.js LTS (via Nodesource)..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

echo "Instalando MySQL Server..."
sudo apt install -y mysql-server
sudo systemctl enable mysql
sudo systemctl start mysql
echo "MySQL instalado e iniciado."

echo "Instalando phpMyAdmin..."
sudo apt install -y phpmyadmin php-mbstring php-zip php-gd php-json php-curl
sudo phpenmod mbstring
sudo systemctl restart apache2 || true
echo "phpMyAdmin instalado. Você pode acessar via Apache (configure seu servidor web)."

echo "Instalando MongoDB..."

wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-archive-keyring.gpg

echo "deb [ arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/mongodb-archive-keyring.gpg ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

sudo apt update
sudo apt install -y mongodb-org
sudo systemctl enable mongod
sudo systemctl start mongod
echo "MongoDB instalado e iniciado."

echo "Instalando Mongo Express globalmente via npm..."
sudo npm install -g mongo-express
echo "Mongo Express instalado. Para rodar, execute: mongo-express"

echo "Instalando Docker..."
sudo apt remove -y docker docker-engine docker.io containerd runc || true

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "Adicionando seu usuário ao grupo docker para evitar usar sudo (reinicie o WSL depois)..."
sudo usermod -aG docker $USER

echo "Configurando usuário e email global do Git..."

read -rp "Digite seu nome para o Git (ex: Luiz Fernando): " git_user
read -rp "Digite seu email para o Git (ex: seuemail@exemplo.com): " git_email

git config --global user.name "$git_user"
git config --global user.email "$git_email"

echo "Configuração do Git aplicada:"
echo "  user.name  = $(git config --global user.name)"
echo "  user.email = $(git config --global user.email)"

echo "Instalando pyenv..."

if command -v curl >/dev/null 2>&1; then
  echo "Tentando instalar pyenv via curl..."
  curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash || {
    echo "Falha no curl. Tentando instalar via wget..."
    wget https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer -O pyenv-installer
    bash pyenv-installer
  }
else
  echo "curl não encontrado. Instalando via wget..."
  wget https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer -O pyenv-installer
  bash pyenv-installer
fi

echo "Configurando variáveis de ambiente do pyenv no ~/.bashrc..."

if ! grep -q 'PYENV_ROOT' ~/.bashrc; then
  echo -e '\n# Configuração do pyenv' >> ~/.bashrc
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
  echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
  echo 'if command -v pyenv 1>/dev/null 2>&1; then' >> ~/.bashrc
  echo '  eval "$(pyenv init --path)"' >> ~/.bashrc
  echo 'fi' >> ~/.bashrc
fi

echo "Script finalizado! Reinicie o WSL ou execute 'source ~/.bashrc' para aplicar as configurações do pyenv e do grupo docker."
