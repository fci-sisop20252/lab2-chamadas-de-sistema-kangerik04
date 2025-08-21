# Diretório de Traces

Este diretório armazena as saídas do `strace` geradas durante os exercícios.

## Comandos para Gerar Traces (Para Entrega)

Execute estes comandos na ordem para gerar todos os traces necessários:

```bash
# Exercício 1a - printf()
strace -e write -o traces/ex1a_trace.txt ./ex1a_printf

# Exercício 1b - write()
strace -e write -o traces/ex1b_trace.txt ./ex1b_write

# Exercício 2 - Leitura
strace -o traces/ex2_trace.txt ./ex2_leitura

# Exercício 3 - Contador
strace -c -o traces/ex3_stats.txt ./ex3_contador

# Exercício 4 - Cópia
strace -o traces/ex4_trace.txt ./ex4_copia
```

## Arquivos Esperados

- `ex1a_trace.txt` - Syscalls write() do printf
- `ex1b_trace.txt` - Syscalls write() direto
- `ex2_trace.txt` - Operações de leitura de arquivo
- `ex3_stats.txt` - Estatísticas do contador com loop
- `ex4_trace.txt` - Operações de cópia completas

## Como Analisar os Traces

### Interpretar Linhas do strace
Veja mais detalhes em [Guia do strace](guia_strace.md).

Formato geral:
```
syscall(parâmetros) = valor_retorno [comentário]
```

Exemplo:
```
openat(AT_FDCWD, "dados/teste1.txt", O_RDONLY) = 3
read(3, "conteúdo do arquivo...", 127) = 45
close(3) = 0
```

### Comandos Úteis para Análise dos Traces Salvos

```bash
# Contar syscalls write nos exercícios 1a vs 1b
grep -c "write(" traces/ex1a_trace.txt
grep -c "write(" traces/ex1b_trace.txt

# Analisar operações de arquivo no exercício 2
grep -E "(openat|read|close)" traces/ex2_trace.txt

# Ver estatísticas detalhadas do exercício 3
cat traces/ex3_stats.txt

# Contar operações read/write no exercício 4
grep -c "read(" traces/ex4_trace.txt
grep -c "write(" traces/ex4_trace.txt
```

## Importância dos Traces

Os traces são evidências importantes porque mostram:

1. **Sequência exata de syscalls** executadas pelo programa
2. **Parâmetros passados** para cada syscall
3. **Valores de retorno** e códigos de erro
4. **Timing** das operações (se usado -T)
5. **Padrões de I/O** (como read/write em loops)

## Para o Relatório

Use os traces para responder perguntas como:

- Quantas syscalls foram necessárias?
- Qual foi a sequência de operações?
- Houve erros durante a execução?
- Como o tamanho do buffer afetou o número de syscalls?
- Qual foi o padrão de leitura/escrita observado?

## Verificação Final

```bash
# Verificar se todos os traces foram gerados
ls -la traces/
# Deve mostrar: ex1a_trace.txt, ex1b_trace.txt, ex2_trace.txt, ex3_stats.txt, ex4_trace.txt

# Verificar tamanhos (todos devem ter conteúdo)
wc -l traces/*.txt
```

## Limpeza

Para limpar traces antigos:
```bash
# Remover todos os traces
rm traces/*.txt

# Ou usar o Makefile
make distclean
```

**Importante:** Certifique-se de salvar traces importantes antes de limpar, pois eles são necessários para o relatório final!