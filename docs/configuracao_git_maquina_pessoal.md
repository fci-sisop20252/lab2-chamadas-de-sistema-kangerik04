# Guia de Configuração do Git com GitHub Personal Access Token

## 🎯 Objetivo

Este guia ajuda você a configurar o Git em sua **máquina pessoal** para trabalhar com repositórios privados do GitHub usando um Personal Access Token (PAT).

## ⚠️ AVISOS IMPORTANTES DE SEGURANÇA

### ❌ NUNCA execute este script em:
- Computadores do laboratório da universidade
- Computadores compartilhados
- Computadores públicos
- Máquinas de outras pessoas

### ✅ EXECUTE APENAS em:
- Seu computador pessoal
- Sua máquina virtual pessoal
- Seu notebook pessoal

### 🔐 Sobre o Token:
- O token dá acesso total aos seus repositórios
- NUNCA compartilhe seu token com ninguém
- NUNCA poste seu token em fóruns ou grupos
- NUNCA commite seu token em repositórios

## 📋 Pré-requisitos

1. **Conta no GitHub**: Você precisa ter uma conta ativa
2. **Git instalado**: O Git deve estar instalado em sua máquina
   ```bash
   # Verificar se o Git está instalado
   git --version
   
   # Se não estiver instalado:
   # Ubuntu/Debian:
   sudo apt install git
   
   # Fedora:
   sudo dnf install git
   
   # macOS:
   brew install git
   
   # Windows:
   # Baixe de https://git-scm.com/download/win
   ```

## 🚀 Como Usar o Script

### Passo 1: Baixar o Script

```bash
# Opção 1: Se você já tem o repositório clonado
cd lab2-syscalls
chmod +x setup_github_token.sh

# Opção 2: Baixar apenas o script
wget https://raw.githubusercontent.com/disciplina-so/lab2-syscalls/main/setup_github_token.sh
chmod +x setup_github_token.sh
```

### Passo 2: Executar o Script

```bash
./setup_github_token.sh
```

### Passo 3: Seguir as Instruções Interativas

O script irá guiá-lo através de 5 etapas:

#### Etapa 1: Confirmação de Segurança
- Digite `sim` para confirmar que está em sua máquina pessoal

#### Etapa 2: Configuração do Git
- O script verificará/configurará seu nome e email
- Use o mesmo email da sua conta GitHub

#### Etapa 3: Criar o Token no GitHub
O script mostrará instruções detalhadas:

1. **Abra o link** fornecido no navegador
2. **Faça login** no GitHub
3. **Configure o token**:
   - Nome: `Git Lab SO 2025`
   - Expiração: `90 days`
   - Escopo: Marque apenas `☑️ repo`
4. **Gere o token** clicando em "Generate token"
5. **COPIE O TOKEN IMEDIATAMENTE** (começa com `ghp_`)

#### Etapa 4: Inserir o Token
- Cole o token quando solicitado
- O token não aparecerá na tela (segurança)

#### Etapa 5: Teste Automático
- O script testará a conexão
- Mostrará seu username do GitHub se tudo estiver OK

## 🎉 Após a Configuração

### Você poderá:
- Clonar repositórios privados sem pedir senha
- Fazer push/pull sem autenticação adicional
- Usar todos os comandos Git normalmente

### Exemplo de uso:
```bash
# Clonar seu repositório do laboratório
git clone https://github.com/disciplina-so/lab2-syscalls-SEU_USUARIO.git

# Fazer suas alterações
cd lab2-syscalls-SEU_USUARIO
# ... editar arquivos ...

# Enviar para o GitHub
git add .
git commit -m "Implementar exercícios"
git push
```

## 🔧 Solução de Problemas

### Erro: "Token inválido"
- Verifique se copiou o token completo
- O token deve começar com `ghp_`
- Certifique-se de que marcou o escopo `repo`

### Erro: "Permission denied" ao fazer push
- Execute o script novamente
- Gere um novo token se necessário
- Verifique se o token não expirou

### Como verificar se está configurado:
```bash
# Ver configuração atual
git config --global --list | grep url

# Deve mostrar algo como:
# url.https://ghp_XXXXX@github.com/.insteadof=https://github.com/
```

## 🗑️ Como Remover/Revogar o Token

### No GitHub:
1. Acesse: https://github.com/settings/tokens
2. Encontre o token "Git Lab SO 2025"
3. Clique em "Delete"

### Na sua máquina:
```bash
# Remover configuração do token
git config --global --unset url."https://github.com/".insteadOf

# Limpar credenciais salvas
rm ~/.git-credentials

# Verificar que foi removido
git config --global --list | grep url
```

## 📅 Renovação do Token

Tokens expiram após o período configurado (recomendamos 90 dias).

### Quando renovar:
- Antes do token expirar
- Se receber erro de autenticação
- No início de um novo semestre

### Como renovar:
1. Revogue o token antigo no GitHub
2. Execute o script novamente
3. Crie um novo token

## 🆘 Suporte

### Documentação Adicional:
- [Documentação oficial do GitHub sobre PATs](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
- [Guia do Git](docs/guia_git.md)

### Problemas Comuns:

**P: Posso usar o mesmo token em múltiplas máquinas?**
R: Tecnicamente sim, mas não é recomendado por segurança. Crie um token para cada máquina.

**P: O que fazer se perdi meu token?**
R: Tokens não podem ser recuperados. Revogue o antigo e crie um novo.

**P: É seguro salvar o token no Git config?**
R: Sim, quando usado apenas em sua máquina pessoal. O token fica em arquivos de configuração locais com permissões restritas.

**P: Posso usar SSH em vez de token?**
R: Sim, SSH é uma alternativa. Veja a documentação do GitHub sobre configuração de chaves SSH.

## ⚡ Método Alternativo (Manual)

Se preferir não usar o script, configure manualmente:

```bash
# 1. Configure nome e email
git config --global user.name "Seu Nome"
git config --global user.email "seu.email@exemplo.com"

# 2. Crie o token no GitHub (seguindo as instruções acima)

# 3. Configure o credential helper
git config --global credential.helper store

# 4. Configure a URL com token
git config --global url."https://SEU_TOKEN@github.com/".insteadOf "https://github.com/"

# 5. Teste clonando um repositório privado
git clone https://github.com/disciplina-so/lab2-syscalls-SEU_USUARIO.git
```

## 📝 Notas Finais

- O script cria um backup das configurações em `~/.git-config-backup-[timestamp].txt`
- O token é salvo em `~/.git-credentials` (nunca compartilhe este arquivo)
- As configurações são globais e afetam todos os repositórios Git em sua máquina
- Para configurações específicas de um repositório, use comandos sem `--global`

---

**Lembre-se**: A segurança do seu token é sua responsabilidade. Trate-o como uma senha!