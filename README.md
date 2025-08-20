[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/feVfUfyC)
# Laboratório 2 - Chamadas de Sistema

## Objetivos de Aprendizagem

Ao final deste laboratório, você será capaz de:
- Compreender como aplicações se comunicam com o kernel através de chamadas de sistema
- Observar a execução de syscalls usando a ferramenta `strace`
- Implementar programas simples usando syscalls básicas de I/O (open, read, write, close)
- Analisar a diferença entre funções da biblioteca C e chamadas diretas ao sistema
- Entender conceitos de file descriptors e gerenciamento de arquivos pelo kernel

## Pré-requisitos do Sistema

- Sistema Linux (Ubuntu, Debian, ou similar)
- Compilador GCC instalado
- Ferramenta `strace` disponível
- Acesso ao terminal

### Verificando as ferramentas:
```bash
# Verificar se o GCC está instalado
gcc --version

# Verificar se o strace está disponível
strace --version
```

## Como Clonar este Repositório

Este laboratório utiliza o GitHub Classroom. Siga os passos:

1. **Aceite o convite** através do link fornecido pelo professor
2. **Clone seu repositório** (substitua `SEU_USUARIO` pelo seu usuário do GitHub):
```bash
git clone https://github.com/fci-sisop20252/lab2-syscalls-SEU_USUARIO.git
cd lab2-syscalls-SEU_USUARIO
```

## Compilação

Para compilar os programas, você pode usar `gcc` diretamente:

```bash
# Compilar um exercício específico
gcc src/ex1a_printf.c -o ex1a_printf

# Compilar com flags de debug e warnings (opcional, ajuda a identificar problemas)
gcc -Wall -g src/ex2_leitura.c -o ex2_leitura
```

**Ou use o Makefile** (opcional, para facilitar):
```bash
# Compilar todos os exercícios (depois de implementados)
make all

# Compilar exercícios específicos
make ex1a
make ex1b

# Limpar arquivos compilados
make clean
```

## Introdução ao strace

O `strace` é uma ferramenta que intercepta e mostra todas as chamadas de sistema feitas por um programa. É fundamental para entender como seu código interage com o kernel. Mais detalhes em [`docs/guia_strace.md`](docs/guia_strace.md).

### Comandos básicos:
```bash
# Rastrear todas as syscalls
strace ./programa

# Rastrear apenas syscalls específicas
strace -e open,read,write,close ./programa

# Contar quantidade de cada syscall
strace -c ./programa

# Salvar saída em arquivo
strace -o trace.txt ./programa
```


## Estrutura dos Exercícios

Os exercícios vão seguir uma progressão gradual:

1. **Exercício 1a**: Observar o comportamento do printf() com `strace`
2. **Exercício 1b**: Observar o comportamento da chamada write() com `strace`
3. **Exercício 2**: Completar os TODOs no código
4. **Exercício 3**: Implementar um loop de leitura de um arquivo
5. **Exercício 4**: Implementar um programa de cópia de arquivos (como o cp)


## Conceitos Essenciais

Este laboratório conecta teoria e prática, abordando conceitos fundamentais de sistemas operacionais:

- **Modo Kernel vs Modo Usuário**: Observar como syscalls fazem a transição do **modo usuário** para **modo kernel**
- **Chamadas de Sistema**: Ver na prática como `open()`, `read()`, `write()` funcionam
- **File Descriptors**: Entender como o kernel gerencia arquivos abertos através de **file descriptors**
- **Buffers e Performance**: Impacto do tamanho de buffer nas syscalls. Cada syscall tem um **overhead**, por isso o tamanho do buffer importa.

### Terminologia
**Buffer**: Área de memória temporária para armazenar dados durante operações de I/O. Tamanho do buffer afeta performance - buffers maiores reduzem número de syscalls mas usam mais memória. 

**File Descriptor**: Número inteiro que o kernel usa para identificar arquivos abertos. Alguns fds são reservados para entradas e saídas padrão: 0=stdin, 1=stdout, 2=stderr. Novos arquivos recebem números sequenciais (3, 4, 5...).

**stdout**: Saída padrão do programa (file descriptor 1). Onde `printf()` e `write(1, ...)` enviam dados por padrão. A saída padrão normalmente é o terminal, mas pode ser redirecionada para arquivos ou outros dispositivos.

**ssize_t**: Tipo de dado para valores de retorno de `read()` e `write()`. Pode ser positivo (bytes transferidos) ou -1 (erro).

## Arquivos do Laboratório

```
lab2-syscalls-SEU-USUARIO/
├── README.md                 # Descrição principal do projeto
├── EXERCICIOS.md             # Instruções detalhadas para os exercícios
├── RELATORIO_TEMPLATE.md     # Template para o relatório de entrega
├── src/                      # Código fonte dos exercícios
│   ├── ex1a_printf.c
│   ├── ex1b_write.c
│   ├── ex2_leitura.c
│   ├── ex3_contador.c
│   └── ex4_copia.c
├── dados/                    # Arquivos de entrada para os exercícios
│   ├── teste1.txt
│   ├── teste2.txt
│   └── origem.txt
├── docs/                     # Documentação de apoio
│   ├── guia_git.md           # Guia sobre como usar o Git
│   ├── guia_compilacao.md    # Guia sobre compilação com GCC
│   └── guia_strace.md        # Guia sobre como usar o strace
├── traces/                   # Diretório para salvar as saídas do strace
│   └── README.md
└── Makefile                  # Script para compilação automática
```

## Como Executar os Exercícios

1. **Leia** o arquivo `EXERCICIOS.md` para instruções detalhadas sobre cada exercício
2. **Compile** o exercício: `gcc src/ex1a_printf.c -o ex1a_printf`
3. **Execute** o programa compilado: `./ex1a_printf`
4. **Observe** as chamadas de sistema com strace: `strace -e write ./ex1a_printf`
5. **Analise** a saída e responda às perguntas do relatório
6. **Salve** os traces importantes na pasta `traces/`

## Entrega

### O que entregar:

1. **Códigos fonte completos** (todos os TODOs implementados):
   - `src/ex2_leitura.c`
   - `src/ex3_contador.c`
   - `src/ex4_copia.c`

2. **Traces salvos** na pasta `traces/`:
   - `traces/ex1a_trace.txt` - Trace do printf
   - `traces/ex1b_trace.txt` - Trace do write
   - `traces/ex2_trace.txt` - Trace da leitura
   - `traces/ex3_trace.txt` - Trace do contador
   - `traces/ex4_trace.txt` - Trace da cópia

3. **Relatório preenchido**: `RELATORIO.md` (pode editar o template e remover o sufixo _TEMPLATE)

### Como gerar e salvar os traces no local correto:

```bash
# Exercício 1a
strace -e write -o traces/ex1a_trace.txt ./ex1a_printf

# Exercício 1b
strace -e write -o traces/ex1b_trace.txt ./ex1b_write

# Exercício 2
strace -e open,read,close -o traces/ex2_trace.txt ./ex2_leitura

# Exercício 3
strace -c -o traces/ex3_trace.txt ./ex3_contador

# Exercício 4
strace -e open,read,write,close -o traces/ex4_trace.txt ./ex4_copia
```

### Submissão final:

```bash
# Verificar que todos os arquivos estão prontos
ls src/ex*.c
ls traces/*.txt
ls RELATORIO.md

# Adicionar tudo ao git
git add .

# Fazer commit final
git commit -m "Entrega do laboratório 2 - Chamadas de Sistema"

# Enviar para o GitHub
git push
```

## Documentação Auxiliar

- [`docs/guia_git.md`](docs/guia_git.md) - Comandos básicos do Git
- [`docs/guia_compilacao.md`](docs/guia_compilacao.md) - Como usar o GCC
- [`docs/guia_strace.md`](docs/guia_strace.md) - Exemplos práticos do strace

## Dúvidas Frequentes

**Não consigo compilar. O que fazer?**
Verifique se tem GCC instalado: `sudo apt install gcc`

**O strace não funciona.**
Instale com: `sudo apt install strace`

**Como sei se completei o lab corretamente?**
Seu programa deve compilar sem erros e funcionar conforme esperado nos testes.
