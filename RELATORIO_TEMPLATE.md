# 📝 Relatório do Laboratório 2 - Chamadas de Sistema

---

## 1️⃣ Exercício 1a - Observação printf() vs 1b - write()

### 💻 Comandos executados:
```bash
strace -e write ./ex1a_printf
strace -e write ./ex1b_write
```

### 🔍 Análise

**1. Quantas syscalls write() cada programa gerou?**
- ex1a_printf: 7 syscalls
- ex1b_write: 7 syscalls

**2. Por que há diferença entre os dois métodos? Consulte o docs/printf_vs_write.md**

```
No ex1a_printf, chamamos a função de biblioteca printf(), que usa bufferização (line-buffered no terminal).
Mesmo assim, cada chamada de printf terminou em '\n', então a libc acabou fazendo 1 write() por printf.
Já no ex1b_write, usamos diretamente a syscall write(): cada chamada do código vira exatamente uma
syscall write(), sem bufferização da libc, ou seja, os mecanismos são diferentes (biblioteca vs syscall direta), mas neste caso específico o número de write() coincidiu porque cada printf gerou um flush ao encontrar '\n'.

```

**3. Qual método é mais previsível? Por quê você acha isso?**

```
write() é mais previsível: cada chamada no código corresponde a uma syscall.
printf() pode agrupar ou atrasar saídas dependendo do modo de bufferização (terminal vs arquivo,
presença de '\n', etc.), então o mapeamento "1 chamada C → 1 syscall" não é garantido.

```

---

## 2️⃣ Exercício 2 - Leitura de Arquivo

### 📊 Resultados da execução:
- File descriptor: 3
- Bytes lidos: Até 127 bytes.

### 🔧 Comando strace:
```bash
strace -e openat,read,close ./ex2_leitura
```

### 🔍 Análise

**1. Qual file descriptor foi usado? Por que não começou em 0, 1 ou 2?**

```
Foi usado o fd 3, porque 0, 1 e 2 já estão ocupados por stdin, stdout e stderr.
O próximo fd livre costuma ser 3.

```

**2. Como você sabe que o arquivo foi lido completamente?**

```
Para uma única chamada read() como no código, sabemos que:
- Se o arquivo tem ≤ 127 bytes, read() retorna o tamanho total do arquivo.
- Se o arquivo for maior que 127 bytes, o programa lê apenas a primeira “página”.
Em geral, o EOF é indicado quando read() retorna 0 (em um loop). Aqui não há loop, então lê-se
no máximo 127 bytes.

```

**3. Por que verificar retorno de cada syscall?**

```
Porque syscalls podem falhar (arquivo inexistente, permissão negada, I/O error, interrupções).
Verificar o retorno permite tratar erros (exibir perror, liberar recursos, encerrar corretamente)
e evita usar dados inválidos (ex.: usar bytes_lidos negativos).

```

---

## 3️⃣ Exercício 3 - Contador com Loop

### 📋 Resultados (BUFFER_SIZE = 64):
- Linhas: 25 (esperado: 25)
- Caracteres: 1300
- Chamadas read(): 21
- Tempo: 0.000084 segundos

### 🧪 Experimentos com buffer:

| Buffer Size | Chamadas read() | Tempo (s) |
|-------------|-----------------|-----------|
| 16          |                 |           |
| 64          |                 |           |
| 256         |                 |           |
| 1024        |                 |           |

### 🔍 Análise

**1. Como o tamanho do buffer afeta o número de syscalls?**

```
Buffers maiores ⇒ menos chamadas read() para cobrir o mesmo arquivo.
Buffers menores ⇒ mais chamadas read(), pois precisamos de mais “pedacinhos” para ler tudo.

```

**2. Todas as chamadas read() retornaram BUFFER_SIZE bytes? Discorra brevemente sobre**

```
Não necessariamente. read() pode retornar:
- Menos que BUFFER_SIZE no último bloco (EOF).
- Menos que BUFFER_SIZE mesmo no meio (não é garantido encher o buffer).
- 0 quando atinge EOF.
O código soma bytes_lidos a cada iteração para obter o total real.

```

**3. Qual é a relação entre syscalls e performance?**

```
Cada syscall implica troca de modo usuário→kernel, que tem custo fixo.
Mais syscalls (buffers pequenos) tendem a piorar performance.
Buffers maiores reduzem o overhead de syscalls e geralmente melhoram o tempo total, até um ponto
de retornos decrescentes (muito grande pode aumentar cache-misses/cópias).

```

---

## 4️⃣ Exercício 4 - Cópia de Arquivo

### 📈 Resultados:
- Bytes copiados: 1364
- Operações: 6
- Tempo: 0.000160 segundos
- Throughput: 8325.20 KB/s

### ✅ Verificação:
```bash
diff dados/origem.txt dados/destino.txt
```
Resultado: [X] Idênticos [ ] Diferentes

### 🔍 Análise

**1. Por que devemos verificar que bytes_escritos == bytes_lidos?**

```
Porque write() pode escrever menos bytes do que pedimos (escrita parcial). Precisamos garantir
que todo o bloco lido foi efetivamente gravado; caso contrário, o destino fica truncado/corrompido.

```

**2. Que flags são essenciais no open() do destino?**

```
- O_WRONLY: abrir para escrita
- O_CREAT: criar se não existir
- O_TRUNC: zerar o arquivo se já existir (cópia “limpa”)

```

**3. O número de reads e writes é igual? Por quê?**

```
No código dado, sim: 1 write por read. Mas em casos reais pode haver writes adicionais se for
preciso tratar escritas parciais.

```

**4. Como você saberia se o disco ficou cheio?**

```
write() retornará -1 e errno indicará erro. Também pode ocorrer escrita parcial. O código deve checar o retorno e tratar o erro.

```

**5. O que acontece se esquecer de fechar os arquivos?**

```
Pode haver perda de dados pendentes no buffer de kernel/FS, descritores ficam abertos,
limites de fd podem ser atingidos e metadados podem não ser atualizados imediatamente.

```

---

## 🎯 Análise Geral

### 📖 Conceitos Fundamentais

**1. Como as syscalls demonstram a transição usuário → kernel?**

```
Cada chamada muda o contexto do processo do modo usuário para o modo
kernel, onde o SO valida parâmetros, acessa dispositivos/FS e retorna o resultado ao usuário.
Essa transição tem custo (overhead) e define a “fronteira” de privilégio.

```

**2. Qual é o seu entendimento sobre a importância dos file descriptors?**

```
FDs são inteiros que identificam recursos abertos.
0/1/2 são stdin/stdout/stderr; novos open() normalmente começam em 3.
Eles permitem que as syscalls manipulem recursos de forma uniforme e abstrata.

```

**3. Discorra sobre a relação entre o tamanho do buffer e performance:**

```
Buffers maiores reduzem o número de syscalls e costumam aumentar o throughput.
Porém, há trade-offs: cópias maiores, uso de cache e possíveis retornos decrescentes.
Ajustar BUFFER_SIZE busca um ponto de bom custo/benefício para o workload e o sistema.

```

### ⚡ Comparação de Performance

```bash
# Teste seu programa vs cp do sistema
time ./ex4_copia
time cp dados/origem.txt dados/destino_cp.txt
```

**Qual foi mais rápido?** cp

**Por que você acha que foi mais rápido?**

```
cp é altamente otimizado: usa syscalls eficientes, buffers adaptativos, loops que tratam escritas parciais e heurísticas do kernel/FS.
Nosso programa educacional usa um loop simples com read/write e buffer fixo.

```

---

## 📤 Entrega
Certifique-se de ter:
- [ ] Todos os códigos com TODOs completados
- [ ] Traces salvos em `traces/`
- [ ] Este relatório preenchido como `RELATORIO.md`

```bash
strace -e write -o traces/ex1a_trace.txt ./ex1a_printf
strace -e write -o traces/ex1b_trace.txt ./ex1b_write
strace -o traces/ex2_trace.txt ./ex2_leitura
strace -c -o traces/ex3_stats.txt ./ex3_contador
strace -o traces/ex4_trace.txt ./ex4_copia
```
# Bom trabalho!
