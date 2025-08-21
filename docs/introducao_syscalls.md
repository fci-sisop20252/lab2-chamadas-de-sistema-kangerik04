# 📞 Introdução às System Calls

## 🤔 O que são System Calls?

System calls (syscalls) são a interface fundamental entre programas de usuário e o kernel do sistema operacional. Quando um programa precisa realizar operações privilegiadas - como ler um arquivo, escrever na tela, ou alocar memória - ele deve solicitar ao kernel através de syscalls.

### 🔐 User Mode vs Kernel Mode

O processador opera em dois modos principais:
- **User Mode**: Onde aplicações normais executam com privilégios limitados
- **Kernel Mode**: Onde o kernel opera com acesso total ao hardware

As syscalls são o mecanismo seguro para transitar entre esses modos, permitindo que programas solicitem serviços do kernel sem comprometer a segurança do sistema.

## 📂 File Descriptors

File descriptors são números inteiros que o kernel usa para rastrear arquivos abertos por um processo. São como "identificadores" ou "handles" para recursos do sistema.

### 📌 Descritores Padrão
Todo processo inicia com três file descriptors pré-definidos:
- **0 (stdin)**: Entrada padrão - normalmente o teclado
- **1 (stdout)**: Saída padrão - normalmente o terminal
- **2 (stderr)**: Saída de erro padrão - também o terminal

## 🔧 Syscalls de Interação com Arquivos

### 1️⃣ open() - Abrindo Arquivos

```c
int open(const char *pathname, int flags, mode_t mode);
```

**Parâmetros:**
- `pathname`: Caminho do arquivo a abrir
- `flags`: Modo de abertura (combinação de flags)
- `mode`: Permissões do arquivo (usado apenas com O_CREAT)

**Flags Comuns:**
- `O_RDONLY`: Abrir apenas para leitura
- `O_WRONLY`: Abrir apenas para escrita
- `O_RDWR`: Abrir para leitura e escrita
- `O_CREAT`: Criar arquivo se não existir
- `O_TRUNC`: Truncar arquivo existente (limpa o arquivo)
- `O_APPEND`: Anexar ao final do arquivo

**Observação**
- Você pode agrupar várias flags separando com `|`. Ex: `O_WRONLY | O_CREAT | O_TRUNC`

**Retorno:**
- Sucesso: File descriptor (número inteiro ≥ 0)
- Erro: -1 (e errno é definido)

**Exemplo:**
```c
int fd = open("arquivo.txt", O_RDONLY);
if (fd == -1) {
    // Erro ao abrir arquivo
    perror("open");
    return -1;
}
```

### 2️⃣ read() - Lendo Dados

```c
ssize_t read(int fd, void *buf, size_t count);
```

**Parâmetros:**
- `fd`: File descriptor de onde ler
- `buf`: Buffer onde armazenar os dados lidos
- `count`: Número máximo de bytes a ler

**Retorno:**
- Sucesso: Número de bytes lidos (0 indica EOF)
- Erro: -1 (e errno é definido)

**Características Importantes:**
- Pode ler menos bytes que o solicitado
- Retornar 0 significa fim do arquivo (EOF)
- O buffer deve ter espaço suficiente alocado

**Exemplo:**
```c
char buffer[1024];
ssize_t bytes_lidos = read(fd, buffer, sizeof(buffer));
if (bytes_lidos == -1) {
    perror("read");
    return -1;
} else if (bytes_lidos == 0) {
    // Fim do arquivo
}
```

### 3️⃣ write() - Escrevendo Dados

```c
ssize_t write(int fd, const void *buf, size_t count);
```

**Parâmetros:**
- `fd`: File descriptor onde escrever
- `buf`: Buffer contendo os dados a escrever
- `count`: Número de bytes a escrever

**Retorno:**
- Sucesso: Número de bytes escritos
- Erro: -1 (e errno é definido)

**Características Importantes:**
- Pode escrever menos bytes que o solicitado
- Para stdout (fd=1), geralmente é line-buffered, ou seja, os dados são enviados ao terminal quando uma nova linha é encontrada (\n) ou o buffer fique cheio
- Para arquivos regulares, geralmente escreve todos os bytes

**Exemplo:**
```c
const char *mensagem = "Hello, World!\n";
ssize_t bytes_escritos = write(1, mensagem, strlen(mensagem));
if (bytes_escritos == -1) {
    perror("write");
    return -1;
}
```

### 4️⃣ close() - Fechando Arquivos

```c
int close(int fd);
```

**Parâmetros:**
- `fd`: File descriptor a fechar

**Retorno:**
- Sucesso: 0
- Erro: -1 (e errno é definido)

**Importância:**
- Libera recursos do sistema
- Garante que dados em buffer sejam escritos
- Número limitado de file descriptors por processo. Normalmente limitado em 1024 pelo kernel, mas pode ser aumentado com `ulimit -n`

**Exemplo:**
```c
if (close(fd) == -1) {
    perror("close");
    return -1;
}
```

## ⚠️ Tratamento de Erros

### ✅ Boas Práticas

1. **Sempre verifique valores de retorno:**
```c
int fd = open("arquivo.txt", O_RDONLY);
if (fd == -1) {
    perror("Erro ao abrir arquivo");
    exit(EXIT_FAILURE);
}
```

2. **Use perror() ou strerror() para mensagens de erro:**
```c
if (write(fd, buffer, size) == -1) {
    fprintf(stderr, "Erro na escrita: %s\n", strerror(errno));
}
```

3. **Feche file descriptors mesmo em caso de erro:**
```c
int fd = open(arquivo, O_RDONLY);
if (fd == -1) return -1;

if (algum_erro) {
    close(fd);  // Importante!
    return -1;
}
```

## 💻 Exemplo: Copiando um Arquivo

```c
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

int main() {
    int fd_origem, fd_destino;
    char buffer[4096];
    ssize_t bytes_lidos, bytes_escritos;
    
    // Abrir arquivo de origem
    fd_origem = open("origem.txt", O_RDONLY);
    if (fd_origem == -1) {
        perror("Erro ao abrir origem");
        exit(EXIT_FAILURE);
    }
    
    // Criar arquivo de destino
    fd_destino = open("destino.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (fd_destino == -1) {
        perror("Erro ao criar destino");
        close(fd_origem);
        exit(EXIT_FAILURE);
    }
    
    // Copiar dados
    while ((bytes_lidos = read(fd_origem, buffer, sizeof(buffer))) > 0) {
        bytes_escritos = write(fd_destino, buffer, bytes_lidos);
        if (bytes_escritos != bytes_lidos) {
            perror("Erro na escrita");
            break;
        }
    }
    
    if (bytes_lidos == -1) {
        perror("Erro na leitura");
    }
    
    // Fechar arquivos
    close(fd_origem);
    close(fd_destino);
    
    return 0;
}
```

## ➡️ Próximos Passos

1. Leia os [Exercícios Detalhados](../EXERCICIOS.md) para começar a implementação
2. Para observar syscalls em execução, consulte o [Guia do strace](guia_strace.md).
3. Use o [Guia de Compilação](guia_compilacao.md) para compilar seus programas
4. Utilize o [strace](guia_strace.md) para verificar as syscalls sendo executadas
5. Para entender a diferença entre funções de biblioteca (como printf) e syscalls diretas (como write), veja [printf vs write](printf_vs_write.md).