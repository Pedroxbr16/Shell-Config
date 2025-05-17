#!/bin/bash

set -e

echo "🔄 Atualizando repositórios e pacotes..."
sudo apt update && sudo apt upgrade -y

echo "🧰 Instalando ferramentas básicas..."
sudo apt install -y build-essential curl wget git unzip vim tmux software-properties-common apt-transport-https ca-certificates gnupg lsb-release

echo "🐍 Instalando Python 3, pip e venv..."
sudo apt install -y python3 python3-pip python3-venv

echo "🔧 Instalando dependências do pyenv..."
sudo apt install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev libffi-dev liblzma-dev python3-openssl git

# ===== OPCIONAL: Ferramentas úteis para dev =====
echo "📦 Instalando utilitários extras..."
sudo apt install -y htop ncdu net-tools neofetch

# ===== OPCIONAL: Instalar Zsh + Oh My Zsh =====
echo "💻 Instalando Zsh e Oh My Zsh..."
sudo apt install -y zsh
chsh -s $(which zsh)

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
fi

# ===== OPCIONAL: Adicionar neofetch ao terminal =====
echo -e '\n# Exibir info do sistema\nneofetch' >> ~/.bashrc

# ===== Git config =====
echo "🔧 Configurando Git global..."

read -rp "Digite seu nome para o Git (ex: Luiz Fernando): " git_user
read -rp "Digite seu email para o Git (ex: seuemail@exemplo.com): " git_email

git config --global user.name "$git_user"
git config --global user.email "$git_email"

# Aliases úteis
git config --global alias.s status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.cm commit
git config --global alias.lg "log --oneline --graph --all"

# ===== Instalar Node.js via NVM (mais flexível) =====
echo "⬇️ Instalando NVM (Node Version Manager)..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc

echo "💡 Após rodar: source ~/.bashrc && nvm install --lts"

# ===== MySQL =====
echo "🗄️ Instalando MySQL Server..."
sudo apt install -y mysql-server
sudo systemctl enable mysql
sudo systemctl start mysql

# ===== phpMyAdmin =====
echo "🌐 Instalando phpMyAdmin..."
sudo apt install -y phpmyadmin php-mbstring php-zip php-gd php-json php-curl
sudo phpenmod mbstring
sudo systemctl restart apache2 || true

# ===== MongoDB =====
echo "🗃️ Instalando MongoDB..."

wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-archive-keyring.gpg
echo "deb [ arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/mongodb-archive-keyring.gpg ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

sudo apt update
sudo apt install -y mongodb-org
sudo systemctl enable mongod
sudo systemctl start mongod

# ===== Mongo Express =====
echo "💻 Instalando Mongo Express globalmente..."
sudo npm install -g mongo-express

# ===== Docker =====
echo "🐳 Instalando Docker..."

sudo apt remove -y docker docker-engine docker.io containerd runc || true
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "🔐 Adicionando usuário ao grupo docker..."
sudo usermod -aG docker $USER
newgrp docker

# ===== pyenv =====
echo "⬇️ Instalando pyenv..."

if command -v curl >/dev/null 2>&1; then
  curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash || {
    echo "❌ Falhou com curl, tentando com wget..."
    wget https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer -O pyenv-installer
    bash pyenv-installer
  }
else
  wget https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer -O pyenv-installer
  bash pyenv-installer
fi

echo "🔧 Adicionando pyenv ao ~/.bashrc..."

if ! grep -q 'PYENV_ROOT' ~/.bashrc; then
  echo -e '\n# pyenv config' >> ~/.bashrc
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
  echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
  echo 'if command -v pyenv 1>/dev/null 2>&1; then' >> ~/.bashrc
  echo '  eval "$(pyenv init --path)"' >> ~/.bashrc
  echo 'fi' >> ~/.bashrc
fi

echo "✅ Setup finalizado!"
echo "🔄 Rode: source ~/.bashrc ou reinicie o WSL para aplicar as configurações."

# ===== Zsh Configuração com Powerlevel10k e Plugins =====
echo "🎨 Configurando Zsh com Powerlevel10k e plugins..."

# Clonar tema Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k

# Definir tema no ~/.zshrc
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\\/powerlevel10k"/' ~/.zshrc

# Clonar plugins adicionais
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Garantir que ~/.zshrc existe
touch ~/.zshrc

# Adicionar plugins ao .zshrc
if grep -q "^plugins=" ~/.zshrc; then
  sed -i '/^plugins=/c\\plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' ~/.zshrc
else
  echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' >> ~/.zshrc
fi



# Ativar Powerlevel10k se não estiver ativado
if ! grep -q 'source ~/.p10k.zsh' ~/.zshrc; then
  echo -e '\n[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc
fi

echo "✅ Zsh configurado com sucesso!"
echo "💡 ATENÇÃO: Para ver os ícones corretamente, instale a fonte MesloLGS NF no Windows e selecione ela no Windows Terminal:"
echo "👉 https://github.com/romkatv/powerlevel10k#manual-font-installation"

