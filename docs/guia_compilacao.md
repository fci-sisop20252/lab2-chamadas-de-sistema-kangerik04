# 🔨 Guia de Compilação com GCC

Este breve guia ensina como usar o compilador GCC para compilar os exercícios do laboratório.

## 🤔 O que é o GCC?

GCC (GNU Compiler Collection) é o compilador padrão para C em sistemas Linux. Ele transforma seu código fonte (`.c`) em um programa executável.

## ✔️ Verificando se o GCC está Instalado

```bash
# Verificar versão
gcc --version

# Se não estiver instalado (Ubuntu/Debian)
sudo apt update
sudo apt install gcc
```

## 📦 Compilação Básica

### 📝 Sintaxe Simples
```bash
gcc arquivo_fonte.c -o nome_do_executável
```

### 💻 Exemplo
```bash
# Compilando o exercício 0
gcc src/ex1a_printf.c -o ex1a_printf

# Executar
./ex1a_printf
```

## 🚩 Flags Úteis do GCC

### ⭐ Flags Básicas Recomendadas

```bash
# Compilação com warnings e debug
gcc -Wall -g src/ex1_leitura.c -o ex1_leitura
```

**Explicação das flags:**
- `-Wall`: Mostra todos os warnings importantes
- `-g`: Inclui informações de debug (útil para encontrar erros e usar outros programas de depuração)

### 🔧 Outras Flags Úteis

```bash
# Compilação com otimização
gcc -O2 src/ex2_contador.c -o ex2_contador

# Compilação pedante (com mais warnings ainda, alguns irrelevantes para nosso contexto)
gcc -Wall -Wextra -pedantic src/ex3_copia.c -o ex3_copia

# Especificar padrão C
gcc -std=c99 src/ex1_leitura.c -o ex1_leitura
```

## 🎯 Exemplos para Cada Exercício

### 0️⃣ Exercício 1a - Observar printf
```bash
# Compilar
gcc src/ex1a_printf.c -o ex1a_printf

# Executar normalmente
./ex1a_printf

# Executar com strace
strace ./ex1a_printf
```

### 1️⃣ Exercício 1b - Observar write
```bash
# Compilar com debug e warnings
gcc -Wall -g src/ex1b_write.c -o ex1b_write

# Testar se compila sem erros
./ex1b_write

# Se der erro, verificar warnings de compilação
```

### 2️⃣ Exercício 2 - Leitura de Arquivo
Primeiro preencha todos os TODOs antes de compilar.

```bash
# Compilar
gcc -Wall -g src/ex2_leitura.c -o ex2_leitura

# Testar
./ex2_leitura

# Observar com strace
strace -c ./ex2_leitura
```

### 3️⃣ Exercício 3 - Contador
Primeiro preencha todos os TODOs antes de compilar.

```bash
# Compilar
gcc -Wall -g src/ex3_contador.c -o ex3_contador

# Testar
./ex3_contador
```

### 4️⃣ Exercício 4 - Copiar Arquivo
Primeiro preencha todos os TODOs antes de compilar.

```bash
# Compilar
gcc -Wall -g src/ex4_copia.c -o ex4_copia

# Testar
./ex4_copia

# Verificar se o arquivo foi copiado
ls -la /dados
```

## ⚠️ Lidando com Erros de Compilação

### 📁 Erro: "No such file or directory"
```bash
# Verifique se o arquivo existe
ls src/ex1a_printf.c

# Verifique se está no diretório correto
pwd
ls
```

### 🔗 Erro: "undefined reference"
Geralmente significa que você esqueceu de incluir uma biblioteca:
```c
// Adicione os includes necessários (nesse lab não deve ocorrer)
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
```

### 💡 Warnings de Compilação
Sempre corrija os warnings:
```bash
# Exemplo de warning comum
src/ex1a_printf.c:15: warning: unused variable 'buffer'

# Solução: use a variável ou remova se não precisar
```

## 🤔 Makefile vs GCC Direto

### 🌟 Usando GCC Diretamente (Recomendado por ora)
```bash
gcc -Wall -g src/ex1_leitura.c -o ex1_leitura
```

**Vantagens:**
- Você vê exatamente o que está acontecendo
- Aprende os comandos de compilação
- Sem dependências de Makefile

### 📜 Usando Makefile (Opcional)

```bash
# Se preferir automação
make all

# O make all só irá funcionar se você tiver completado todos os TODOs
```

**Vantagens:**
- Compilação automática
- Facilita quando há muitos arquivos

## 🔄 Fluxo de Trabalho Recomendado

```bash
# 1. Editar código
vim src/ex2_leitura.c

# 2. Compilar com warnings
gcc -Wall -g src/ex2_leitura.c -o ex2_leitura

# 3. Se houver erros, corrigir e repetir passo 2

# 4. Testar programa
./ex2_leitura

# 5. Se funcionar, testar com strace
strace ./ex2_leitura

# 6. Continuar com próximo exercício
```

### 🧹 Limpeza
```bash
# Remover executáveis antigos com nome errado
rm ex0_observar ex1_leitura ex2_contador ex3_copia

# Ou com padrão
rm ex*
```

## 💡 Dicas Importantes

### 1️⃣ Sempre Use Flags de Warning (-Wall)
```bash
gcc -Wall -g src/ex2_leitura.c -o ex2_leitura
```

### 2️⃣ Nome do Executável
```bash
# Bom (nome claro)
gcc src/ex2_leitura.c -o ex2_leitura

# Ruim (nome genérico)
gcc src/ex2_leitura.c -o a.out
```

### 3️⃣ Teste Imediatamente
```bash
# Compile e teste logo
gcc -Wall -g src/ex2_leitura.c -o ex2_leitura && ./ex2_leitura
```

### 4️⃣ Verifique Arquivos Necessários
```bash
# Antes de executar exercícios que usam arquivos
ls dados/teste1.txt
```

## 🔧 Problemas Comuns

### 🔒 "Permission denied"
```bash
# Dar permissão de execução
chmod +x ex2_leitura
```

### ❌ "Command not found"
```bash
# Usar ./
./ex2_leitura

# Não apenas
ex2_leitura
```

### 😶 Programa não faz nada
```bash
# Verificar se há arquivos de entrada necessários
ls dados/
```

## 📝 Resumo dos Comandos

| Comando | O que faz |
|---------|-----------|
| `gcc arquivo.c -o programa` | Compilação básica |
| `gcc -Wall -g arquivo.c -o programa` | Compilação com warnings e debug |
| `./programa` | Executar programa |
| `chmod +x programa` | Dar permissão de execução |
| `ls -la programa` | Verificar se arquivo existe |

**Lembre-se:** Compile sempre com `-Wall -g` para pegar problemas cedo!