#!/usr/bin/env bash
set -euo pipefail

# Pede interativamente nome e e-mail para o Git
read -p "Digite seu nome de usuário Git: " GIT_NAME
read -p "Digite seu e-mail do Git: " GIT_EMAIL

echo "🔄 Atualizando repositórios e pacotes..."
sudo apt update && sudo apt upgrade -y

echo "🧰 Instalando ferramentas básicas..."
sudo apt install -y \
  build-essential curl wget git unzip vim tmux \
  software-properties-common apt-transport-https \
  ca-certificates gnupg lsb-release

echo "🐍 Instalando Python 3, pip e venv..."
sudo apt install -y python3 python3-pip python3-venv

echo "🔧 Instalando dependências do pyenv..."
sudo apt install -y make build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
  libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev \
  liblzma-dev python3-openssl

echo "📦 Instalando utilitários extras..."
sudo apt install -y htop ncdu net-tools neofetch

echo "💻 Instalando Zsh e Oh My Zsh..."
sudo apt install -y zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

grep -qxF 'neofetch' ~/.bashrc  || echo -e '\n# Mostrar info do sistema\nneofetch' >> ~/.bashrc
grep -qxF 'neofetch' ~/.zshrc   || echo -e '\n# Mostrar info do sistema\nneofetch' >> ~/.zshrc

echo "⚙️ Configurando Git..."
git config --global user.name  "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global alias.s  status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.cm commit
git config --global alias.lg "log --oneline --graph --all"

echo "⬇️ Instalando NVM (Node Version Manager)…"
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ]     && \. "$NVM_DIR/nvm.sh"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

echo "⬇️ Instalando Node.js 20.14 e definindo como padrão..."
nvm install 20.14.0
nvm alias default 20.14.0

echo "🗄️ Instalando MySQL Server..."
sudo DEBIAN_FRONTEND=noninteractive apt install -y mysql-server
sudo systemctl enable mysql
sudo systemctl start mysql

echo "🔐 Rodando mysql_secure_installation (interativo)…"
sudo mysql_secure_installation

echo "🌐 Instalando Apache2 e phpMyAdmin…"
sudo apt install -y apache2
sudo DEBIAN_FRONTEND=noninteractive apt install -y \
  phpmyadmin php-mbstring php-zip php-gd php-json php-curl
sudo phpenmod mbstring
sudo a2enconf phpmyadmin
sudo systemctl reload apache2

echo "🗃️ Instalando MongoDB 6.0…"
sudo mkdir -p /etc/apt/keyrings
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc \
  | sudo gpg --dearmor -o /etc/apt/keyrings/mongodb-archive-keyring.gpg
echo "deb [ arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/mongodb-archive-keyring.gpg ] \
  https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/6.0 multiverse" \
  | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt update
sudo apt install -y mongodb-org
sudo systemctl enable mongod
sudo systemctl start mongod

echo "💻 Instalando mongo-express globalmente…"
sudo npm install -g mongo-express

echo "🐳 Instalando Docker e Docker Compose…"
sudo apt remove -y docker docker-engine docker.io containerd runc || true
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "🔐 Adicionando usuário ao grupo docker..."
sudo usermod -aG docker "$(whoami)"
echo "💡 Você precisará relogar ou rodar 'newgrp docker' para aplicar permissão."

echo "⬇️ Instalando pyenv…"
if command -v curl >/dev/null; then
  curl -fsSL https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
else
  wget -qO- https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
fi

if ! grep -q 'PYENV_ROOT' ~/.zshrc; then
  cat << 'EOF' >> ~/.zshrc

# Configuração do pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
fi
EOF
fi

echo "🎨 Instalando Powerlevel10k e plugins Zsh…"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
  git clone https://github.com/zsh-users/$plugin.git \
    "$HOME/.oh-my-zsh/custom/plugins/$plugin" || true
done
sed -i '/^plugins=/c\plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' ~/.zshrc

echo "🐳 Instalando Docker Compose manualmente (v2.11.2)…"
mkdir -p ~/.docker/cli-plugins
curl -fsSL \
  https://github.com/docker/compose/releases/download/v2.11.2/docker-compose-linux-x86_64 \
  -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose

echo "✅ Setup concluído!"
echo "🔄 Execute um 'source ~/.bashrc' ou 'source ~/.zshrc', ou reinicie a sessão para aplicar tudo."
echo "💡 Instale a fonte MesloLGS NF no Windows e selecione-a no seu terminal para Powerlevel10k."
