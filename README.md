# 🛠️ Dotfiles & System Config

Repositório com minhas configurações pessoais.

Cada programa tem sua própria branch, para manter a organização e facilitar a migração para outras máquinas.

---

## 📂 Estrutura

Cada branch contém as configurações de um programa específico:

- `i3` → Configuração do window manager i3
- `i3blocks` → Configuração da status bar i3blocks
- `kitty` → Configuração do terminal Kitty
- `nvim` → Configuração do Neovim
- `scripts` → Scripts bash reutilizáveis no sistema

---

## 🔀 Como usar

Clone apenas a branch desejada para a pasta correspondente:

```bash
git clone --branch nvim --single-branch \
https://github.com/Fillipe143/SystemConfig.git \
nvim
