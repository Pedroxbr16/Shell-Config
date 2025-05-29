# ⚙️ Setup de Ambiente para Programação no WSL (Ubuntu)

Este script automatiza a instalação e configuração das ferramentas mais comuns para desenvolvimento em **WSL Ubuntu**, incluindo:

### 🚀 Funcionalidades:

* ✅ Atualização do sistema
* ✅ Git com configuração global (nome, e-mail e aliases úteis)
* ✅ Node.js via `nvm` (Node Version Manager) configurado no Zsh
* ✅ Python 3 + pip + venv + pyenv configurado no Zsh
* ✅ Docker e Docker Compose (usuário no grupo docker)
* ✅ LazyDocker para gerenciamento de containers de forma visual e interativa
* ✅ MySQL Server
* ✅ phpMyAdmin
* ✅ MongoDB + Mongo Express
* ✅ Zsh + Oh My Zsh com tema Powerlevel10k e plugins
* ✅ Ferramentas de monitoramento e utilitários (`htop`, `neofetch`, `ncdu`, etc.)
* ✅ Exibição automática de informações do sistema ao abrir o terminal (`neofetch`)

---

## 🧪 Como usar

1. Faça o download do script:

   ```bash
   wget https://raw.githubusercontent.com/Pedroxbr16/Shell-Config/main/config.sh
   ```

2. Dê permissão de execução:

   ```bash
   chmod +x config.sh
   ```

3. Execute:

   ```bash
   ./config.sh
   ```

4. Ao final, recarregue seu shell:

   ```bash
   source ~/.zshrc
   ```

5. Para iniciar o LazyDocker (alias configurado `lzd`):

   ```bash
   lzd
   ```

---

## ⚠️ Atenção Importante

* **Não esqueça de alterar as variáveis `GIT_NAME` e `GIT_EMAIL` no script antes de rodar, ou editar depois para refletir seu nome e email reais!**

* Se quiser usar outra versão do Node.js, após a instalação rode:

  ```bash
  nvm install <versão>
  nvm alias default <versão>
  ```

* Para personalizar o script, você pode editar diretamente variáveis e comandos dentro dele, conforme suas necessidades (ex: instalar pacotes extras, configurar outras ferramentas).

---

## 💡 Dicas pós-instalação

* O script configura o **pyenv** e o **nvm** para carregarem no **Zsh** (`~/.zshrc`).

* Para que o terminal carregue as configurações corretamente, sempre use o **Zsh** como shell padrão:

  ```bash
  chsh -s $(which zsh)
  exec zsh
  ```

* Para usar o Mongo Express (interface web para o MongoDB):

  ```bash
  mongo-express
  ```

* Para configurar o tema Powerlevel10k:

  ```bash
  p10k configure
  ```

---

## 🔤 Fontes MesloLGS NF (Powerlevel10k)

Para que os ícones e espaçamentos do prompt do Powerlevel10k funcionem corretamente, instale as seguintes fontes no seu **Windows**:

📥 [MesloLGS NF Regular.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf)
📥 [MesloLGS NF Bold.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf)
📥 [MesloLGS NF Italic.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf)
📥 [MesloLGS NF Bold Italic.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf)

Após instalar, configure seu terminal (ex: Windows Terminal) para usar a fonte:

```
MesloLGS NF
```

---

## ⚠️ Observações

* O phpMyAdmin é instalado, mas você precisa configurar o Apache ou Nginx para acessá-lo via navegador.
* O MongoDB e o MySQL são iniciados automaticamente como serviços.
* O Docker é instalado e configurado para rodar **sem sudo**, mas é necessário reiniciar ou rodar `newgrp docker` após o script.
* O LazyDocker é instalado e movido para `/usr/local/bin`, e o alias `lzd` é configurado no `~/.zshrc`.
* O `neofetch` está configurado para exibir automaticamente tanto no Bash (`~/.bashrc`) quanto no Zsh (`~/.zshrc`).
* O pyenv e nvm estão configurados no `~/.zshrc`, pois o Zsh é o shell padrão após o script.

---

## 🛠 Aliases Git criados

| Comando  | Equivale a                        |
| -------- | --------------------------------- |
| `git s`  | `git status`                      |
| `git co` | `git checkout`                    |
| `git br` | `git branch`                      |
| `git cm` | `git commit`                      |
| `git lg` | `git log --oneline --graph --all` |

---

## 🧩 Ferramentas instaladas

* Git
* Curl / Wget / Vim / Tmux / unzip
* Python 3 / pip / venv / pyenv
* Node.js via `nvm` (versão 20.14 instalada por padrão)
* MySQL + phpMyAdmin
* MongoDB + Mongo Express
* Docker + Docker Compose
* LazyDocker (alias `lzd`)
* Zsh + Oh My Zsh + Powerlevel10k
* Utilitários: `htop`, `ncdu`, `net-tools`, `neofetch`

---

## 📬 Suporte

Abra uma issue no repositório ou entre em contato para sugestões e melhorias.

---

## 📄 Licença

Este script é gratuito e livre para uso pessoal e comercial.
