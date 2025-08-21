/*
 * Exercício 1a - Observando printf()
 * 
 * OBJETIVO: Entender como printf() se comporta com strace
 * 
 * TAREFA: Este código está completo. Você só precisa:
 * 1. Compilar: gcc src/ex1a_printf.c -o ex1a_printf
 * 2. Executar: ./ex1a_printf
 * 3. Observar com strace: strace -e write ./ex1a_printf
 */

#include <stdio.h>

int main() {
    printf("=== Demonstração: printf() ===\n\n");
    
    // printf() é uma função da biblioteca C
    // Ela usa buffering interno para otimizar I/O
    printf("Primeira mensagem via printf\n");
    printf("Segunda mensagem via printf\n");
    printf("Terceira mensagem via printf\n");
    
    printf("\n=== Análise ===\n");
    printf("Execute: strace -e write ./ex1a_printf\n");
    printf("Observe: Quantas chamadas write() aparecem?\n");
    
    return 0;
}

/*
 * CONCEITOS:
 * - printf() é função de biblioteca (não uma syscall direta)
 * - Usa stdout (file descriptor 1) para saída
 * - O printf() pode usar buffering para agrupar dados
 * - Porém com um \n duplo, o buffer é forçado a ser enviado com um unico byte, o que pode resultar em mais chamadas write()
 */