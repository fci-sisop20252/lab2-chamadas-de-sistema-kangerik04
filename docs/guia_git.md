# 🌳 Guia Básico do Git

Este guia apresenta os comandos essenciais do Git para completar o laboratório.

## 🤔 O que é Git?

Git é um sistema de controle de versão que permite:
- Salvar diferentes versões do seu código
- Sincronizar trabalho com repositórios remotos (como GitHub)
- Colaborar com outras pessoas em projetos

## 📖 Conceitos Básicos

### 📁 Working Directory (Diretório de Trabalho)
É onde você edita seus arquivos. As mudanças aqui ainda não foram salvas no Git.

### 📦 Staging Area (Área de Preparação) 
Local temporário onde você prepara quais mudanças quer salvar. Use `git add` para mover arquivos para aqui.

### 🗄️ Repository (Repositório)
Onde o Git armazena todas as versões salvas do seu projeto. Use `git commit` para salvar mudanças definitivamente.

### ☁️ Envio para o GitHub
Depois de salvar suas mudanças com o `git commit`, você envia para o repositório remoto no GitHub com `git push`. Assim você mantém seu repositório remoto atualizado com suas alterações locais e pode acessá-lo de qualquer lugar.

## 🔧 Comandos Essenciais

### 1️⃣ Clonar o Repositório

No GitHub Classroom, você receberá um link. Depois de aceitar, clone assim:

```bash
# Substitua SEU_USUARIO pelo seu usuário do GitHub
git clone https://github.com/fci-sisop20252/lab2-syscalls-SEU_USUARIO.git

# Entre no diretório
cd lab2-syscalls-SEU_USUARIO
```

**Obs.:** Se você utilizar o Github Codespaces não é necessário clonar o repositório, pois ele já estará disponível no ambiente.

### 2️⃣ Verificar Status

Sempre verifique o status antes de fazer qualquer operação:

```bash
# Ver quais arquivos foram modificados
git status
```

**Exemplo de saída:**
```
On branch main
Changes not staged for commit:
  modified:   src/ex2_leitura.c

Untracked files:
  traces/ex2_trace.txt
```

### 3️⃣ Adicionar Arquivos (Staging)

Adicione os arquivos que você quer salvar:

```bash
# Adicionar arquivo específico
git add src/ex2_leitura.c

# Adicionar todos os arquivos modificados
git add .

# Adicionar todos os arquivos de uma pasta
git add traces/
```

### 4️⃣ Fazer Commit (Salvar)

Salve suas mudanças com uma mensagem descritiva do que você fez:

```bash
# Commit com mensagem
git commit -m "Completei o exercício 2"

# Se quiser usar uma mensagem mais detalhada (use Shift + Enter para nova linha)
git commit -m "Completei o exercício 2
- Adicionada verificação de erro
- Implementado loop de leitura
- Traces salvos"
```

### 5️⃣ Enviar para o GitHub (Push)

Envie suas mudanças para o repositório remoto:

```bash
# Enviar para branch main
git push origin main

# Ou simplesmente (depois da primeira vez)
git push
```

## 🔄 Fluxo do Laboratório

Aqui está o fluxo típico que você seguirá:

```bash
# 1. Clone (só uma vez, no início) - Não precisa fazer no Codespaces
git clone https://github.com/fci-sisop20252/lab2-syscalls-SEU_USUARIO.git
cd lab2-syscalls-SEU_USUARIO

# 2. Trabalhe nos exercícios
# (edite arquivos, compile, teste)

# 3. Veja o que mudou
git status

# 4. Adicione suas mudanças (o . vai adicionar todas as mudancas no staging)
git add .

# 5. Faça commit
git commit -m "Completar exercícios 1 e 2"

# 6. Envie para o GitHub
git push

# Repita passos 2-6 conforme necessário
```

## 💻 Exemplo Prático

Vamos simular o fluxo de completar o exercício 2:

```bash
# Ver estado atual
git status

# Editar o arquivo (usando seu editor preferido) - Se estiver no Codespaces você pode trabalhar diretamente no editor integrado
vim src/ex2_leitura.c
code .

# Compilar e testar
gcc src/ex2a_print.c -o ex2_leitura
./ex2_leitura

# Gerar trace
strace -o traces/ex2_trace.txt ./ex2_leitura

# Ver o que mudou
git status
# Saída: modified: src/ex2_leitura.c
#        untracked: traces/ex2_trace.txt

# Adicionar mudanças (voce pode usar git add . para adicionar todas as mudancas)
git add src/ex2_leitura.c
git add traces/ex2_trace.txt

# Verificar que está pronto para commit
git status
# Saída: Changes to be committed:
#          modified: src/ex2_leitura.c
#          new file: traces/ex2_trace.txt

# Fazer commit
git commit -m "Implementar exercício 2 - leitura de arquivo"

# Enviar
git push
```

## ✨ Comandos Úteis Extras

### 📊 Ver Histórico de Commits
```bash
# Ver últimos commits
git log --oneline

# Ver com detalhes
git log
```

### 🔍 Ver Diferenças
```bash
# Ver o que mudou em arquivos modificados
git diff

# Ver diferenças de arquivo específico
git diff src/ex2_leitura.c
```

### ⚠️ Desfazer Mudanças (CUIDADO!)
```bash
# Desfazer mudanças em arquivo específico (perde trabalho!)
git checkout -- src/ex2_leitura.c

# Remover arquivo do staging
git reset src/ex2_leitura.c
```

## 🔧 Problemas Comuns

### 🔒 "Permission denied" no push
Se você não conseguir fazer push, verifique se:
1. Aceitou o convite do GitHub Classroom
2. Está usando a URL correta do seu repositório
3. Está logado no GitHub (pode precisar configurar SSH ou token caso esteja na sua máquina pessoal).

### 💭 "Nothing to commit"
Se aparecer esta mensagem:
1. Verifique se salvou os arquivos editados
2. Use `git status` para ver se há mudanças
3. Use `git add` para adicionar arquivos ao staging

### 📝 Mensagem de commit obrigatória
Se esquecer da mensagem:
```bash
# Git vai abrir um editor. Digite a mensagem, salve e feche
git commit

# Ou sempre use -m
git commit -m "Sua mensagem aqui"
```

## ⚙️ Configuração Inicial (Opcional)

Se for a primeira vez usando Git na sua máquina pessoal:

```bash
# Configurar nome e email (aparece nos commits)
git config --global user.name "Seu Nome"
git config --global user.email "seu.email@exemplo.com"

# Editor padrão (opcional)
git config --global core.editor code
```

## 📝 Resumo dos Comandos

| Comando | O que faz |
|---------|-----------|
| `git clone <url>` | Baixa repositório do GitHub |
| `git status` | Mostra estado atual |
| `git add <arquivo>` | Adiciona arquivo ao staging |
| `git add .` | Adiciona todos os arquivos |
| `git commit -m "msg"` | Salva mudanças com mensagem |
| `git push` | Envia para GitHub |
| `git log` | Mostra histórico |
| `git diff` | Mostra diferenças |

## 📚 Para Saber Mais

- [Git - Guia Prático](https://rogerdudler.github.io/git-guide/index.pt_BR.html)
- [GitHub Docs](https://docs.github.com/pt)
- [Atlassian Git Tutorial](https://www.atlassian.com/git/tutorials)
- [Configuração da autenticação no Github na máquina pessoal](docs/configuracao_git_maquina_pessoal.md)


**Lembre-se:** No laboratório, você só precisa dos comandos básicos: `status`, `add`, `commit`, `push`. Não precisa complicar!