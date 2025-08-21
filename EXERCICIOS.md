# Exercícios do Laboratório 2 - Instruções

Este arquivo contém instruções detalhadas para cada exercício. Siga os passos na ordem para completar o laboratório.

## Preparação Inicial

### 1. Verificar Ferramentas

```bash
# Verificar se tudo está instalado
gcc --version
strace --version
make --version
```

### 2. Sobre a Compilação

**⚠️ IMPORTANTE:** O comando `make all` NÃO funcionará no início porque os exercícios contêm TODOs que você precisa completar primeiro.

**Compile exercícios individuais conforme for completando:**

```bash
# Exercícios 1a e 1b (já estão prontos)
make ex1
# ou manualmente:
gcc src/ex1a_printf.c -o ex1a_printf
gcc src/ex1b_write.c -o ex1b_write

# Exercício 2 (após completar os TODOs)
make ex2
# ou manualmente:
gcc src/ex2_leitura.c -o ex2_leitura

# Exercício 3 (após completar os TODOs)
make ex3

# Exercício 4 (após completar os TODOs)  
make ex4
```

**Use `make help` para ver todos os comandos disponíveis.**

---

## Exercício 1a - Observando printf()

**Objetivo:** Descobrir o que printf() faz "por baixo dos panos".

**Contexto:** Você sempre usou printf(), mas sabia que por trás ele usa outra função chamada write()?

### Passo 1: Compilar
```bash
gcc src/ex1a_printf.c -o ex1a_printf
```

### Passo 2: Executar Normalmente

```bash
./ex1a_printf
```

### Passo 3: Executar com strace

```bash
strace -e write ./ex1a_printf
```

**O que observar:**
- Quantas chamadas `write()` aparecem no strace?
- printf() não é uma syscall direta - ela usa write() internamente
- O comportamento pode ser diferente do que você espera!

### Passo 4: Salvar Trace

```bash
strace -e write -o traces/ex1a_trace.txt ./ex1a_printf
```

---

## Exercício 1b - Observando write()

**Objetivo:** Conhecer write() - a função "crua" que printf() usa.

**Contexto:** write() é uma syscall (system call) - uma função que vai direto para o kernel do sistema operacional.

### Passo 1: Compilar
```bash
gcc src/ex1b_write.c -o ex1b_write
```

### Passo 2: Executar Normalmente

```bash
./ex1b_write
```

### Passo 3: Executar com strace

```bash
strace -e write ./ex1b_write
```

**O que observar:**
- Cada write() gera **exatamente uma syscall**
- O file descriptor especificado é o 1 = stdout (saída padrão)
- write() é **direto**: não há "surpresas" internamente

### Passo 4: Salvar Trace

```bash
strace -e write -o traces/ex1b_trace.txt ./ex1b_write
```

### Comparação 1a vs 1b:

1. **Quantas syscalls cada método gerou?** *(responda no RELATORIO.md)*
2. **Por que há diferença?** *(responda no RELATORIO.md)*
3. **Qual é mais previsível?** *(responda no RELATORIO.md)*

**📖 Para entender melhor:** Leia `docs/printf_vs_write.md` - tem uma explicação com analogia simples sobre a diferença entre essas duas funções.

---

## Exercício 2 - Leitura Básica de Arquivo

**Objetivo:** Implementar leitura de arquivo usando syscalls.

### Passo 1: Analisar o Código

1. Abra `src/ex2_leitura.c`
2. Leia os comentários e identifique os TODOs
3. Entenda o que cada TODO deve fazer

### Passo 2: Completar os TODOs

**TODO 1:** Abrir arquivo
```c
/* TODO: use open() com O_RDONLY */
```

**TODO 2:** Verificar erro de abertura
```c
/* TODO: verificar se fd < 0 */
```

**TODO 3:** Ler dados
```c
/* TODO: use read() para ler até (BUFFER_SIZE - 1) bytes */
```

**TODO 4:** Verificar erro de leitura
```c
/* TODO: verificar se bytes_lidos < 0 */
```

**TODO 5:** Adicionar terminador
```c
/* TODO: adicionar '\0' para tratar como string */
```

**TODO 6:** Fechar arquivo
```c
/* TODO: use close() e verifique erro */
```

### Passo 3: Compilar e Testar

```bash
gcc -Wall -g src/ex2_leitura.c -o ex2_leitura
./ex2_leitura
```

**Deve mostrar:**
- File descriptor usado
- Número de bytes lidos
- Conteúdo do arquivo

### Passo 4: Observar com strace

```bash
# Ver syscalls de arquivo
strace -e openat,read,close ./ex2_leitura

# Salvar trace completo
strace -o traces/ex2_trace.txt ./ex2_leitura
```

### Passo 5: Experimentos

1. **Mudar tamanho do buffer:**
   - Mude `BUFFER_SIZE` para 10
   - Recompile e execute
   - O que acontece com arquivos maiores que o buffer?

2. **Arquivo inexistente:**
   - Mude o nome do arquivo para algo que não existe
   - Observe as mensagens de erro

### Perguntas para Reflexão:

1. **Qual file descriptor foi usado? Por que não 0, 1 ou 2?** *(responda no RELATORIO.md)*
2. **Como você sabe que o arquivo foi lido completamente?** *(responda no RELATORIO.md)*
3. **Por que devemos verificar retorno de cada syscall?** *(responda no RELATORIO.md)*

---

## Exercício 3 - Contador de Linhas com Loop

**Objetivo:** Implementar loop de leitura e analisar múltiplas syscalls.

### Passo 1: Analisar o Código

1. Abra `src/ex3_contador.c`
2. Note que o `BUFFER_SIZE` é pequeno (64 bytes)
3. Isto força múltiplas chamadas `read()`

### Passo 2: Completar os TODOs

**TODO 1:** Condição do loop
```c
/* TODO: loop enquanto read() retornar > 0 */
```

**TODO 2:** Contar quebras de linha
```c
/* TODO: percorrer buffer e contar '\n' */
```

**TODO 3:** Somar caracteres
```c
/* TODO: somar bytes_lidos ao total */
```

**TODO 4:** Verificar erro
```c
/* TODO: verificar se bytes_lidos < 0 após o loop */
```

### Passo 3: Compilar e Testar

```bash
gcc -Wall -g src/ex3_contador.c -o ex3_contador
./ex3_contador
```

**Deve mostrar:**
- Número de linhas (deve ser 25)
- Total de caracteres
- Número de chamadas read()
- Tempo de execução

### Passo 4: Análise com strace

```bash
# Contar syscalls
strace -c ./ex3_contador

# Ver detalhes dos reads
strace -e read ./ex3_contador

# Salvar estatísticas
strace -c -o traces/ex3_stats.txt ./ex3_contador
```

### Passo 5: Experimentos com Buffer

Teste diferentes tamanhos editando manualmente o arquivo:

1. **Abra `src/ex3_contador.c`**
2. **Mude a linha:** `#define BUFFER_SIZE 64`
3. **Teste os valores:** 16, 64, 256, 1024
4. **Para cada tamanho:**
   - Salve o arquivo
   - Recompile: `make ex3`
   - Execute: `./ex3_contador`
   - Conte syscalls: `strace -c ./ex3_contador`
   - Anote os resultados na tabela no RELATORIO.md

### Tabela de Análise:

| Buffer Size | Syscalls read() | Tempo (s) | Chars/seg |
|-------------|-----------------|-----------|-----------|
| 16          | ?               | ?         | ?         |
| 64          | ?               | ?         | ?         |
| 256         | ?               | ?         | ?         |
| 1024        | ?               | ?         | ?         |

### Perguntas para Análise:

1. **Como o tamanho do buffer afeta o número de syscalls?** *(responda no RELATORIO.md)*
2. **Como você detecta o fim do arquivo?** *(responda no RELATORIO.md)*
3. **Todas as chamadas read() retornaram BUFFER_SIZE bytes?** *(responda no RELATORIO.md)*
4. **Qual é a relação entre syscalls e performance?** *(responda no RELATORIO.md)*

---

## Exercício 4 - Cópia de Arquivo

**Objetivo:** Implementar programa para realizar uma cópia de arquivo.

### Passo 1: Entender o Código

Este exercício envolve:
- Abrir arquivo para leitura E escrita
- Loop read/write intercalado
- Tratamento de erros em múltiplas etapas
- Verificação de integridade

### Passo 2: Completar os TODOs (Principais)

**TODO 1:** Abrir origem
```c
/* TODO: abrir dados/origem.txt para leitura */
```

**TODO 2:** Criar destino
```c
/* TODO: criar dados/destino.txt com flags apropriadas */
```

**TODO 3:** Loop de cópia
```c
/* TODO: loop enquanto read() > 0 */
```

**TODO 4:** Escrever dados
```c
/* TODO: use write() para escrever os dados lidos */
```

**TODO 5:** Verificar escrita
```c
/* TODO: verificar se bytes_escritos == bytes_lidos */
```

**TODO 6:** Atualizar contador
```c
/* TODO: somar bytes_escritos ao total */
```

**TODO 7:** Verificar erro de leitura
```c
/* TODO: verificar erro após o loop */
```

**TODO 8:** Fechar arquivos
```c
/* TODO: fechar ambos os file descriptors */
```

### Passo 3: Compilar e Testar

```bash
gcc -Wall -g src/ex4_copia.c -o ex4_copia
./ex4_copia
```

### Passo 4: Verificar Integridade

```bash
# Verificar se a cópia foi perfeita
diff dados/origem.txt dados/destino.txt

# Se não houver saída, a cópia foi bem-sucedida!

# Comparar tamanhos
ls -la dados/origem.txt dados/destino.txt
```

### Passo 5: Análise Detalhada com strace

```bash
# Ver padrão read/write
strace -e openat,read,write,close ./ex4_copia

# Com timestamps para ver performance
strace -T -e read,write ./ex4_copia

# Salvar trace completo
strace -o traces/ex4_trace.txt ./ex4_copia
```

### Passo 6: Experimentos de Performance

Teste diferentes tamanhos de buffer:

1. **Abra `src/ex4_copia.c`**
2. **Edite a linha:** `#define BUFFER_SIZE 256`
3. **Teste diferentes valores:** 64, 256, 1024, 4096
4. **Para cada valor:**
   - Salve o arquivo
   - Recompile: `make ex4`
   - Execute e meça tempo: `time ./ex4_copia`
   - Compare os resultados

### Análise do Trace

Examine `traces/ex4_trace.txt` e procure:

1. **Sequência de abertura:**
```
openat(AT_FDCWD, "dados/origem.txt", O_RDONLY) = 3
openat(AT_FDCWD, "dados/destino.txt", O_WRONLY|O_CREAT|O_TRUNC, 0644) = 4
```

2. **Padrão read/write:**
```
read(3, "conteudo...", 256) = 256
write(4, "conteudo...", 256) = 256
read(3, "mais conteudo...", 256) = 180
write(4, "mais conteudo...", 180) = 180
read(3, "", 256) = 0 # fim do arquivo
```

3. **Fechamento:**
```
close(3) = 0
close(4) = 0
```

### Perguntas para Análise:

1. **Por que devemos verificar que bytes_escritos == bytes_lidos?** *(responda no RELATORIO.md)*
2. **Que flags são essenciais no open() do destino?** *(responda no RELATORIO.md)*
3. **O número de reads e writes é igual? Por quê?** *(responda no RELATORIO.md)*
4. **Como você saberia se o disco ficou cheio?** *(responda no RELATORIO.md)*
5. **O que acontece se você esquecer de fechar os arquivos?** *(responda no RELATORIO.md)*

---

## Análise Final e Relatório

### Compilar Todos os Traces

Certifique-se de ter salvado traces de todos os exercícios:

```bash
ls traces/
# Deve mostrar:
# ex1a_trace.txt
# ex1b_trace.txt
# ex2_trace.txt  
# ex3_stats.txt
# ex4_trace.txt
```
Relacione suas observações com os conceitos da aula:

- **Modo Usuário vs Kernel:** Cada linha do strace é uma transição
- **File Descriptors:** Como o kernel gerencia um recurso (nesse caso, arquivos)
- **Performance:** Overhead de syscalls

### Preparar Entrega

1. **Código completo** (todos os TODOs preenchidos)
2. **Traces salvos** na pasta `traces/`
3. **Relatório (RELATORIO.md)** preenchido com análises
4. **Commit no Git** com todas as modificações

```bash
git add .
git commit -m "Completei todos os exercícios do laboratório"
git push
```

## Problemas Comuns e Soluções

### Erro de Compilação

```bash
# Se der erro de biblioteca não encontrada
sudo apt install libc6-dev

# Se der erro de permissão
chmod +x ex2_leitura
```

### Erro de Arquivo Não Encontrado

```bash
# Verificar se arquivos de teste existem
ls dados/
# Se não existirem:
make dados
```

### strace Não Funciona

```bash
# Instalar strace
sudo apt install strace

# Se ainda não funcionar, pode ser restrição de segurança
sudo strace ./programa
```

### Programa Não Executa

```bash
# Verificar permissões
ls -la ex2_leitura
# Se necessário:
chmod +x ex2_leitura

# Verificar dependências
ldd ex2_leitura
```

**Lembre-se:** Se tiver dúvidas, consulte a documentação em `docs/` e use `make help` para ver os comandos disponíveis! Aproveite o momento da aula para tirar dúvidas com o professor também.