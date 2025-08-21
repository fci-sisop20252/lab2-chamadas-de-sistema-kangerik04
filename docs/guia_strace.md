# 🔍 Guia Prático do strace

O `strace` é uma ferramenta essencial para este laboratório. Ele intercepta e mostra todas as chamadas de sistema que seu programa faz, permitindo ver "por baixo dos panos" como a aplicação se comunica com o kernel.

## 🤔 O que é o strace?

O strace é um depurador que:
- Intercepta syscalls (chamadas de sistema) 
- Mostra parâmetros passados para as syscalls
- Exibe valores de retorno
- Permite filtrar syscalls específicas
- Ajuda a entender o comportamento de programas

## 📦 Instalação

```bash
# Ubuntu/Debian
sudo apt install strace

# Red Hat/CentOS  
sudo yum install strace

# Verificar instalação
strace --version
```

## 💻 Comandos Básicos

### 1️⃣ Rastreamento Simples

```bash
# Rastrear todas as syscalls
strace ./programa
```

**Exemplo com ls:**
```bash
strace ls
```

**Saída típica:**
```
execve("/bin/ls", ["ls"], [/* 25 vars */]) = 0
brk(NULL)                               = 0x55c8b9c1d000
access("/etc/ld.so.nohwcap", F_OK)     = -1 ENOENT (No such file or directory)
...
```

### 2️⃣ Filtrar Syscalls Específicas

```bash
# Rastrear apenas syscalls de arquivo
strace -e openat,read,write,close ./programa

# Rastrear apenas write
strace -e write ./programa

# Rastrear family de syscalls
strace -e file ./programa    # operações de arquivo
strace -e process ./programa # operações de processo
```

### 3️⃣ Contar Syscalls

```bash
# Mostrar estatísticas de uso
strace -c ./programa
```

**Exemplo de saída:**
```
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 68.75    0.000055           7         8           write
 18.75    0.000015           8         2           read
  6.25    0.000005           5         1           open
  6.25    0.000005           5         1           close
------ ----------- ----------- --------- --------- ----------------
100.00    0.000080                    12           total
```

### 4️⃣ Salvar Saída em Arquivo

```bash
# Salvar trace completo
strace -o trace.txt ./programa

# Salvar apenas syscalls específicas
strace -e openat,read,write,close -o file_ops.txt ./programa

# Salvar estatísticas
strace -c -o stats.txt ./programa
```

## 📊 Interpretando a Saída do strace

### ⚠️ IMPORTANTE: Por que usar filtros?

**AVISO:** Executar `strace ./programa` sem filtros mostra MUITAS syscalls de preparação que não são relevantes para os exercícios:
- Alocação de memória (brk, mmap)
- Carregamento de bibliotecas (openat, read de arquivos .so)
- Configuração do ambiente (arch_prctl, set_tid_address)
- Verificações de segurança (access, stat)

**SEMPRE use `-e` para filtrar as syscalls que você quer observar!**

```bash
#mostra apenas o que importa
strace -e write ./programa

#mostra centenas de linhas
strace ./programa
```

### 🔄 Nota Importante: open() vs openat()

**Você verá `openat()` em vez de `open()` nos traces!**

- **Seu código:** `open("arquivo.txt", O_RDONLY)`
- **No strace:** `openat(AT_FDCWD, "arquivo.txt", O_RDONLY)`

**Por quê?** A biblioteca C moderna (glibc) automaticamente converte `open()` em `openat()` por segurança. O comportamento é idêntico quando o primeiro parâmetro é `AT_FDCWD` (diretório atual).

**Para filtros strace:** Use `-e openat` em vez de `-e open`

### 📋 Formato da Linha

```
syscall(parâmetros) = valor_retorno [comentário]
```

**Componentes:**
- **syscall**: Nome da chamada de sistema (openat, read, write, etc.)
- **parâmetros**: Argumentos passados (strings entre aspas, números, flags)
- **valor_retorno**: Resultado da operação
  - Números positivos: sucesso (ex: file descriptor, bytes transferidos)
  - -1: erro (sempre acompanhado de explicação)
  - 0: pode indicar fim de arquivo (em read) ou sucesso (em close)
- **comentário**: Informação adicional sobre erros

### 🔎 Exemplo Detalhado

```bash
openat(AT_FDCWD, "dados/teste1.txt", O_RDONLY) = 3
```

**Explicação:**
- `openat`: nome da syscall
- `AT_FDCWD`: primeiro parâmetro (usar diretório atual)
- `"dados/teste1.txt"`: segundo parâmetro (nome do arquivo)
- `O_RDONLY`: terceiro parâmetro (modo de abertura)
- `= 3`: valor de retorno (file descriptor)

### ❌ Exemplo com Erro

```bash
open("arquivo_inexistente.txt", O_RDONLY) = -1 ENOENT (No such file or directory)
```

**Explicação:**
- `= -1`: erro (syscalls retornam -1 em erro)
- `ENOENT`: código do erro
- `(No such file...)`: descrição do erro

## 🎯 Exemplos Práticos para o Laboratório

### 📝 Exercício 1a - Observar printf

```bash
# Compilar
gcc src/ex1a_printf.c -o ex1a_printf

# Executar normalmente
./ex1a_printf

# Rastrear apenas write
strace -e write ./ex1a_printf
```

**O que observar:**
- printf() pode gerar uma ou múltiplas chamadas write()
- Bufferização da biblioteca C agrupa dados

### ✏️ Exercício 1b - Observar write

```bash
# Compilar
gcc src/ex1b_write.c -o ex1b_write

# Rastrear
strace -e write ./ex1b_write
```

**O que observar:**
- write() vai direto ao kernel
- Cada write() gera exatamente uma syscall

### 📖 Exercício 2 - Leitura de Arquivo

```bash
# Compilar
gcc src/ex2_leitura.c -o ex2_leitura

# Rastrear operações de arquivo
strace -e openat,read,close ./ex2_leitura
```

**O que observar:**
```
openat(AT_FDCWD, "dados/teste1.txt", O_RDONLY) = 3
read(3, "Conteúdo do arquivo...", 127) = 45
close(3) = 0
```

**Análise:**
- `openat()` retorna file descriptor 3
- `read()` lê do fd 3, mostra quantos bytes foram lidos
- `close()` fecha o fd 3

### 🔄 Exercício 3 - Contador com Loop

```bash
# Compilar
gcc src/ex3_contador.c -o ex3_contador

# Contar syscalls
strace -c ./ex3_contador

# Ver detalhes das leituras
strace -e read ./ex3_contador
```

**O que observar:**
- Múltiplas chamadas `read()` se o arquivo for maior que o buffer
- Cada `read()` pode retornar um número diferente de bytes
- Última `read()` retorna 0 (fim do arquivo)

### 📋 Exercício 4 - Cópia de Arquivo

```bash
# Compilar  
gcc src/ex4_copia.c -o ex4_copia

# Rastrear I/O
strace -e openat,read,write,close ./ex4_copia

# Com timestamps
strace -t -e read,write ./ex4_copia
```

**O que observar:**
- Padrão: `read()` seguido de `write()`
- Tamanhos de buffer nos parâmetros
- Valores de retorno indicando bytes transferidos

## 🔧 Opções Úteis do strace

### ⏰ Timestamps

```bash
# Timestamp relativo
strace -r ./programa

# Timestamp absoluto
strace -t ./programa

# Timestamp com microssegundos
strace -tt ./programa
```

### 🔍 Detalhamento

```bash
# Mostrar argumentos de string completos
strace -s 200 ./programa

# Mostrar conteúdo de buffers
strace -x ./programa

# Seguir forks (processos filhos)
strace -f ./programa
```

### 🎯 Filtros Avançados

```bash
# Syscalls que começam com 'read'
strace -e trace=read* ./programa

# Excluir syscalls específicas  
strace -e trace='!write' ./programa

# Só syscalls que acessam arquivo específico
strace -P dados/teste1.txt ./programa
```

## 💾 Salvando Traces para o Relatório

### 📁 Para Cada Exercício

```bash
# Exercício 1a
strace -e write -o traces/ex1a_trace.txt ./ex1a_printf

# Exercício 1b
strace -e write -o traces/ex1b_trace.txt ./ex1b_write

# Exercício 2  
strace -e openat,read,close -o traces/ex2_trace.txt ./ex2_leitura

# Exercício 3
strace -c -o traces/ex3_stats.txt ./ex3_contador
strace -e read -o traces/ex3_reads.txt ./ex3_contador

# Exercício 4
strace -e openat,read,write,close -o traces/ex4_trace.txt ./ex4_copia
```

### 📈 Analisando os Traces Salvos

```bash
# Ver trace salvo
cat traces/ex1_trace.txt

# Contar linhas (número de syscalls)
wc -l traces/ex1_trace.txt

# Filtrar apenas reads
grep "read(" traces/ex3_trace.txt
```

## ❓ Perguntas para Análise

Ao observar os traces, pergunte-se:

### 📝 Para os Exercícios 1a e 1b:
1. Quantas chamadas `write()` cada método gerou?
2. Os tamanhos dos buffers são diferentes?
3. Por que essa diferença?

### 📖 Para o Exercício 2:
1. Qual file descriptor foi usado?
2. Quantos bytes foram lidos de uma vez?
3. O arquivo foi aberto e fechado corretamente?

### 🔄 Para o Exercício 3:
1. Quantas chamadas `read()` foram necessárias?
2. Todas retornaram o mesmo número de bytes?
3. Como você sabe que chegou no fim do arquivo?

### 📋 Para o Exercício 4:
1. As operações seguem o padrão read→write?
2. Os tamanhos de leitura e escrita são iguais?
3. Há diferença na performance entre buffers pequenos e grandes?

## ⚠️ Problemas Comuns

### 🔒 strace "permission denied"
```bash
# Pode precisar de permissões especiais
sudo strace ./programa

# Ou verificar se o executável tem permissão
chmod +x ./programa
```

### 📃 Muita informação na tela
```bash
# Sempre salve em arquivo para análise
strace -o trace.txt ./programa

# Ou filtre syscalls
strace -e openat,read,write,close ./programa
```

### ❌ Programa não aparece no trace
```bash
# Verificar se o programa executa normalmente primeiro
./programa

# Depois usar strace
strace ./programa
```

## 📝 Comandos Resumidos

| Comando | O que faz |
|---------|-----------|
| `strace ./prog` | Rastreia todas as syscalls |
| `strace -e openat,read ./prog` | Filtra syscalls específicas |
| `strace -c ./prog` | Conta syscalls |
| `strace -o file.txt ./prog` | Salva em arquivo |
| `strace -t ./prog` | Adiciona timestamps |
| `strace -s 200 ./prog` | Strings completas |

## 🌐 Conectando com a Teoria

Lembre-se dos conceitos da aula:

- **Modo Usuário → Modo Kernel**: Cada linha do strace mostra uma transição
- **Performance**: Menos syscalls = melhor performance

O strace torna visível a comunicação entre sua aplicação e o kernel, mostrando na prática os conceitos teóricos sobre chamadas de sistema!