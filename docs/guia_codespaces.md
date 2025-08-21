# ☁️ Guia do GitHub Codespaces

## 🤔 O que é GitHub Codespaces?

GitHub Codespaces é um ambiente de desenvolvimento baseado em nuvem que permite programar diretamente no navegador. É ideal para este laboratório pois resolve algumas limitações técnicas dos laboratórios da FCI em relação ao acesso ao GitHub e garante que todos tenham acesso às mesmas ferramentas.

## 📊 Limites da Versão Gratuita

- **120 core hours por mês**: Equivale a 60 horas em uma máquina de 2 cores
- **15 GB de armazenamento**: Suficiente para este laboratório e todos os labs futuros
- **Renovação mensal**: Os limites resetam no início de cada mês

## 🚀 Iniciando com Codespaces

### 🏭 Criando seu Codespace

1. Acesse o repositório do laboratório no GitHub
2. Clique no botão verde **Code**
3. Selecione a aba **Codespaces**
4. Clique em **Create codespace on main**
5. Aguarde o ambiente ser provisionado (1-2 minutos)

O Codespace virá automaticamente configurado com:
- GCC (compilador C)
- strace (rastreamento de syscalls)
- make (automação de compilação)
- git (controle de versão)

## 🔄 Fluxo de Desenvolvimento

### 🖥️ Interface do VS Code

O Codespaces usa uma versão web do VS Code com:
- **Explorer** (esquerda): Navegação de arquivos
- **Editor** (centro): Edição de código
- **Terminal** (inferior): Execução de comandos
- **Source Control** (esquerda): Gerenciamento do Git

### 🔨 Compilando Programas

No terminal integrado, use os comandos GCC normalmente:

```bash
# Compilar um programa
gcc -o programa programa.c

# Compilar com warnings
gcc -Wall -o programa programa.c

# Executar
./programa
```

### 🔍 Usando strace

O strace funciona normalmente no Codespaces:

```bash
# Rastrear syscalls
strace ./programa

# Salvar trace em arquivo
strace -o trace.txt ./programa

# Filtrar syscalls específicas
strace -e openat,read,write,close ./programa
```

## 📁 Gerenciamento de Arquivos

### 📂 Estrutura de Diretórios

```
lab2-syscalls/
├── src/          # Seus programas .c
├── traces/       # Destino dos arquivos de trace do strace
├── docs/         # Documentações
└── EXERCICIOS.md # Instruções dos exercícios
```

### 📝 Criando e Organizando Arquivos

1. **Criar arquivo**: Clique direito na pasta → New File
2. **Criar pasta**: Clique direito → New Folder
3. **Upload de arquivo**: Arraste e solte no Explorer
4. **Download**: Clique direito no arquivo → Download

### 💾 Salvando Traces

Sempre salve os traces na pasta `traces/`:

```bash
# Criar pasta se não existir
mkdir -p traces

# Salvar trace
strace -o traces/ex1_trace.txt ./cp1 origem.txt destino.txt
```

## 🌳 Operações Git no Codespaces

### 🎨 Usando a Interface Gráfica

1. **Source Control** (ícone de branch na barra lateral)
2. Adicione os arquivos no staging clicando no **+**
3. Digite a mensagem de commit
4. Clique no **✓** para commitar
5. Use **...** → Push para enviar para o repositório remoto

### 💻 Usando o Terminal

```bash
# Verificar status
git status

# Adicionar arquivos
git add src/programa.c
git add traces/

# Commitar
git commit -m "Implementa exercício 1"

# Enviar para GitHub
git push
```

Para comandos Git detalhados, consulte o [Guia Git](guia_git.md).

## ✅ Boas Práticas

### ⏱️ Economizando Core Hours

1. **Pare o Codespace quando não estiver usando**:
   - Codespaces → ⋮ → Stop codespace
   - Ou deixe parar automaticamente após 30 min de inatividade

2. **Verifique seu uso**:
   - Settings → Billing → Codespaces
   - Monitore suas core hours restantes

### 💾 **Commite e push frequentemente**
- O Codespace pode ser interrompido e você não quer perder progresso.

### ⚡ Performance

- Use máquina de **2 cores** para este lab (padrão)
- Evite abrir múltiplos Codespaces simultaneamente
- Feche abas desnecessárias no navegador

## 🔧 Troubleshooting

### ⚠️ Problemas Comuns

**Codespace não inicia:**
- Verifique se não excedeu o limite mensal
- Tente deletar e recriar o Codespace

**Comando não encontrado:**
- O ambiente pode ainda estar carregando
- Tente: `sudo apt update && sudo apt install [pacote]`

**Permissão negada:**
- Use `chmod +x programa` para tornar executável
- Para traces: verifique se a pasta existe

**Git push falha:**
- Verifique se está autenticado
- Use o terminal se a interface gráfica falhar

### 🔄 Reinstalando Ferramentas

Se alguma ferramenta estiver faltando:

```bash
# Atualizar pacotes
sudo apt update

# Instalar GCC
sudo apt install build-essential

# Instalar strace
sudo apt install strace

# Instalar make
sudo apt install make
```

## 🔄 Alternativa ao Codespaces

Se atingir o limite mensal, considere um **desenvolvimento local**. Veja como configurar na sua máquina pessoal [aqui](docs/configuracao_git_maquina_pessoal.md)

## 📚 Recursos Adicionais

- [Documentação oficial do Codespaces](https://docs.github.com/en/codespaces)
- [Atalhos de teclado do VS Code](https://code.visualstudio.com/shortcuts/keyboard-shortcuts-linux.pdf)
- [Guia de Git](guia_git.md) para comandos detalhados

## ✔️ Checklist Rápido

Antes de começar os exercícios:
- [ ] Codespace criado e rodando
- [ ] Terminal aberto e funcionando
- [ ] `gcc --version` mostra o compilador
- [ ] `strace -V` mostra a versão
- [ ] Pasta `traces/` criada
- [ ] Git configurado (nome e email)