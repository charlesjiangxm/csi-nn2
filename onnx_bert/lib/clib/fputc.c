#include <stdio.h>

#define C9xx_LOG_PRINT_ADDR  ((int *)0x1900d000)

int fputc(int ch, FILE *stream)
{
  volatile int* addr_ptr;
  addr_ptr = C9xx_LOG_PRINT_ADDR;
  *(addr_ptr) = ch;

  // asm volatile (
  //     "li   x13, 0x01fffff0 \n\t" 
  //     "sw   %0, 0(x13) \n\t"
  //     : :"r" (ch): "x13", "memory");
}

void os_critical_enter(void)
{
}

void os_critical_exit(void)
{
}

