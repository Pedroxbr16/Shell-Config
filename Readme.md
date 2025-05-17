# ⚙️ Setup de Ambiente para Programação no WSL (Ubuntu)

Este script automatiza a instalação e configuração das ferramentas mais comuns para desenvolvimento em **WSL Ubuntu**, incluindo:

### 🚀 Funcionalidades:

- ✅ Atualização do sistema
- ✅ Git com configuração global (nome, e-mail e aliases úteis)
- ✅ Node.js via `nvm` (Node Version Manager)
- ✅ Python 3 + pip + venv + pyenv com configuração no `.bashrc`
- ✅ Docker e Docker Compose (usuário no grupo docker)
- ✅ MySQL Server
- ✅ phpMyAdmin
- ✅ MongoDB + Mongo Express
- ✅ Zsh + Oh My Zsh
- ✅ Ferramentas de monitoramento e utilitários (`htop`, `neofetch`, `ncdu`, etc.)
- ✅ Exibição automática de informações do sistema ao abrir o terminal (`neofetch`)

---

## 🧪 Como usar

1. Faça o download do script: 

   ```bash
   wget https://raw.githubusercontent.com/Pedroxbr16/Shell-Config/main/setup-wsl-dev.sh
   ```

2. Dê permissão de execução:

   ```bash
   chmod +x config.sh
   ```

3. Execute:

   ```bash
   ./config.sh
   ```

4. Insira seu **nome** e **e-mail** quando solicitado para configurar o Git.

5. Ao final, execute:

   ```bash
   source ~/.bashrc
   ```

   ou reinicie o WSL para aplicar todas as configurações (docker, pyenv, nvm, zsh etc).

---

## 💡 Dicas pós-instalação

- Para instalar o Node LTS:
  ```bash
  nvm install --lts
  ```

- Para usar o Mongo Express (interface web para o MongoDB):
  ```bash
  mongo-express
  ```

- Se o Zsh não for ativado automaticamente:
  ```bash
  chsh -s $(which zsh)
  exec zsh
  ```

---

## ⚠️ Observações

- O phpMyAdmin é instalado, mas você precisa configurar o Apache ou Nginx para acessá-lo via navegador.
- O MongoDB e o MySQL são iniciados automaticamente como serviços.
- O Docker é instalado e configurado para rodar **sem sudo**, mas é necessário reiniciar ou rodar `newgrp docker` após o script.

---

## 🛠 Aliases Git criados

| Comando     | Equivale a              |
|-------------|-------------------------|
| `git s`     | `git status`            |
| `git co`    | `git checkout`          |
| `git br`    | `git branch`            |
| `git cm`    | `git commit`            |
| `git lg`    | `git log --oneline --graph --all` |

---

## 🧩 Ferramentas instaladas

- Git
- Curl / Wget / Vim / Tmux / unzip
- Python 3 / pip / venv / pyenv
- Node.js via `nvm`
- MySQL + phpMyAdmin
- MongoDB + Mongo Express
- Docker + docker-compose
- Zsh + Oh My Zsh
- Utilitários: `htop`, `ncdu`, `net-tools`, `neofetch`

---

## 📬 Suporte

Abra uma issue no repositório ou entre em contato para sugestões e melhorias.

---

## 📄 Licença

Este script é gratuito e livre para uso pessoal e comercial.
