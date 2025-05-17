
# Setup de Ambiente para Programação no WSL

Este script automatiza a instalação e configuração das ferramentas mais comuns para programação no WSL Ubuntu, incluindo:

- Atualização do sistema
- Git (com configuração global de usuário e e-mail)
- Node.js LTS + npm
- Python 3 + pip + pyenv (com instalação e configuração no `.bashrc`)
- Docker (com adição do usuário ao grupo docker)
- MySQL Server
- phpMyAdmin
- MongoDB (servidor)
- Mongo Express (interface web para MongoDB via npm)
- Ferramentas básicas (build-essential, curl, wget, vim, tmux, etc)

---

## Como usar

1. Faça download do script `setup-wsl.sh`.

2. Dê permissão para execução:

   ```bash
   chmod +x setup-wsl.sh
   ```

3. Execute o script:

   ```bash
   ./setup-wsl.sh
   ```

4. Durante a execução, informe seu nome e e-mail para configurar o Git.

5. Ao final, **reinicie o WSL** para que as configurações do grupo `docker` e do `pyenv` entrem em vigor.

6. Opcionalmente, você pode rodar:

   ```bash
   source ~/.bashrc
   ```

   para aplicar as configurações do pyenv sem reiniciar.

---

## Observações

- O script instala o phpMyAdmin mas não configura o servidor web. Você precisará configurar Apache ou Nginx para servir o phpMyAdmin em seu ambiente.

- O Mongo Express é instalado globalmente via npm. Para iniciar, basta rodar:

  ```bash
  mongo-express
  ```

- O Docker está instalado e seu usuário foi adicionado ao grupo `docker` para que você possa rodar comandos sem `sudo`.

---

## Suporte

Caso tenha dúvidas ou precise de ajuda para customizar o script, configurar servidores web ou outras ferramentas, abra uma issue ou entre em contato.

---

## Licença

Este script é gratuito e livre para uso pessoal e comercial.
