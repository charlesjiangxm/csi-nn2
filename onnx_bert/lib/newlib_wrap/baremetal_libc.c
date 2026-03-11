/*
 * baremetal_libc.c - bare-metal support for the onnx_bert demo.
 *
 * The bare-metal build links with -nostdlib, so it needs a small libc surface
 * for CSI-NN2 plus a UART-backed stdout path.
 */

#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "uart.h"

extern char __heap_start;
extern char __heap_end;

typedef struct baremetal_block {
    size_t size;
    int free;
    struct baremetal_block *next;
} baremetal_block_t;

__thread int errno;
static FILE _stdin_file;
static FILE _stdout_file;
static FILE _stderr_file;
static baremetal_block_t *g_heap_head;
static int g_uart_ready;
static t_ck_uart_device g_uart_device = {0};
static const t_ck_uart_cfig g_uart_config = {
    .baudrate = BAUD,
    .stopbit = STOPBIT_1,
    .parity = PARITY_NONE,
    .wordsize = WORDSIZE_8,
    .rxmode = DISABLE,
    .txmode = ENABLE,
};

FILE *stdin = &_stdin_file;
FILE *stdout = &_stdout_file;
FILE *stderr = &_stderr_file;

static size_t align_up(size_t value)
{
    return (value + sizeof(uintptr_t) - 1) & ~(sizeof(uintptr_t) - 1);
}

static void uart_init_once(void)
{
    if (g_uart_ready) {
        return;
    }
    g_uart_device.uart_id = 0xffff;
    ck_uart_open(&g_uart_device, 0);
    ck_uart_init(&g_uart_device, (p_ck_uart_cfig)&g_uart_config);
    g_uart_ready = 1;
}

static void baremetal_heap_init(void)
{
    if (g_heap_head != NULL) {
        return;
    }

    uintptr_t heap_start = (uintptr_t)&__heap_start;
    uintptr_t heap_end = (uintptr_t)&__heap_end;
    size_t heap_size = heap_end - heap_start;

    if (heap_size <= sizeof(baremetal_block_t)) {
        g_heap_head = NULL;
        return;
    }

    g_heap_head = (baremetal_block_t *)heap_start;
    g_heap_head->size = heap_size - sizeof(baremetal_block_t);
    g_heap_head->free = 1;
    g_heap_head->next = NULL;
}

static void split_block(baremetal_block_t *block, size_t size)
{
    size_t aligned_size = align_up(size);
    if (block->size <= aligned_size + sizeof(baremetal_block_t) + sizeof(uintptr_t)) {
        return;
    }

    baremetal_block_t *next = (baremetal_block_t *)((uint8_t *)(block + 1) + aligned_size);
    next->size = block->size - aligned_size - sizeof(baremetal_block_t);
    next->free = 1;
    next->next = block->next;

    block->size = aligned_size;
    block->next = next;
}

static void coalesce_blocks(void)
{
    baremetal_block_t *block = g_heap_head;
    while (block && block->next) {
        if (block->free && block->next->free) {
            block->size += sizeof(baremetal_block_t) + block->next->size;
            block->next = block->next->next;
            continue;
        }
        block = block->next;
    }
}

int *__errno_location(void) { return &errno; }

void *memcpy(void *dest, const void *src, size_t n)
{
    unsigned char *d = (unsigned char *)dest;
    const unsigned char *s = (const unsigned char *)src;
    while (n--) {
        *d++ = *s++;
    }
    return dest;
}

void *memmove(void *dest, const void *src, size_t n)
{
    unsigned char *d = (unsigned char *)dest;
    const unsigned char *s = (const unsigned char *)src;
    if (d < s) {
        while (n--) {
            *d++ = *s++;
        }
    } else {
        d += n;
        s += n;
        while (n--) {
            *--d = *--s;
        }
    }
    return dest;
}

void *memset(void *s, int c, size_t n)
{
    unsigned char *p = (unsigned char *)s;
    while (n--) {
        *p++ = (unsigned char)c;
    }
    return s;
}

int memcmp(const void *s1, const void *s2, size_t n)
{
    const unsigned char *p1 = (const unsigned char *)s1;
    const unsigned char *p2 = (const unsigned char *)s2;
    while (n--) {
        if (*p1 != *p2) {
            return (int)*p1 - (int)*p2;
        }
        p1++;
        p2++;
    }
    return 0;
}

size_t strlen(const char *s)
{
    const char *p = s;
    while (*p) {
        p++;
    }
    return (size_t)(p - s);
}

char *strchr(const char *s, int c)
{
    while (*s) {
        if (*s == (char)c) {
            return (char *)s;
        }
        s++;
    }
    return (c == '\0') ? (char *)s : NULL;
}

char *strrchr(const char *s, int c)
{
    const char *match = NULL;
    while (*s) {
        if (*s == (char)c) {
            match = s;
        }
        s++;
    }
    if (c == '\0') {
        return (char *)s;
    }
    return (char *)match;
}

char *strcpy(char *dest, const char *src)
{
    char *d = dest;
    while ((*d++ = *src++)) {
    }
    return dest;
}

char *strncpy(char *dest, const char *src, size_t n)
{
    size_t i = 0;
    for (; i < n && src[i] != '\0'; i++) {
        dest[i] = src[i];
    }
    for (; i < n; i++) {
        dest[i] = '\0';
    }
    return dest;
}

int strcmp(const char *s1, const char *s2)
{
    while (*s1 && (*s1 == *s2)) {
        s1++;
        s2++;
    }
    return (unsigned char)*s1 - (unsigned char)*s2;
}

int strncmp(const char *s1, const char *s2, size_t n)
{
    while (n && *s1 && (*s1 == *s2)) {
        s1++;
        s2++;
        n--;
    }
    if (n == 0) {
        return 0;
    }
    return (unsigned char)*s1 - (unsigned char)*s2;
}

static int _isspace(int c)
{
    return c == ' ' || c == '\t' || c == '\n' || c == '\r' || c == '\f' || c == '\v';
}

static int _digitval(int c)
{
    if (c >= '0' && c <= '9') return c - '0';
    if (c >= 'a' && c <= 'z') return c - 'a' + 10;
    if (c >= 'A' && c <= 'Z') return c - 'A' + 10;
    return -1;
}

unsigned long strtoul(const char *nptr, char **endptr, int base)
{
    const char *s = nptr;
    unsigned long result = 0;
    int neg = 0;

    while (_isspace(*s)) s++;

    if (*s == '-') {
        neg = 1;
        s++;
    } else if (*s == '+') {
        s++;
    }

    if (base == 0) {
        if (*s == '0') {
            s++;
            if (*s == 'x' || *s == 'X') {
                base = 16;
                s++;
            } else {
                base = 8;
            }
        } else {
            base = 10;
        }
    } else if (base == 16 && *s == '0' && (s[1] == 'x' || s[1] == 'X')) {
        s += 2;
    }

    while (1) {
        int d = _digitval(*s);
        if (d < 0 || d >= base) break;
        result = result * base + d;
        s++;
    }

    if (endptr) *endptr = (char *)s;
    return neg ? (unsigned long)(-(long)result) : result;
}

long strtol(const char *nptr, char **endptr, int base) { return (long)strtoul(nptr, endptr, base); }

char *strerror(int errnum)
{
    (void)errnum;
    return (char *)"error";
}

static void swap_bytes(unsigned char *lhs, unsigned char *rhs, size_t size)
{
    while (size--) {
        unsigned char tmp = *lhs;
        *lhs++ = *rhs;
        *rhs++ = tmp;
    }
}

void qsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))
{
    if (base == NULL || compar == NULL || nmemb < 2 || size == 0) {
        return;
    }

    unsigned char *items = (unsigned char *)base;
    for (size_t i = 0; i + 1 < nmemb; i++) {
        size_t min_index = i;
        for (size_t j = i + 1; j < nmemb; j++) {
            if (compar(items + j * size, items + min_index * size) < 0) {
                min_index = j;
            }
        }
        if (min_index != i) {
            swap_bytes(items + i * size, items + min_index * size, size);
        }
    }
}

void *malloc(size_t size)
{
    baremetal_heap_init();
    if (g_heap_head == NULL || size == 0) {
        return NULL;
    }

    size_t aligned_size = align_up(size);
    baremetal_block_t *block = g_heap_head;
    while (block) {
        if (block->free && block->size >= aligned_size) {
            split_block(block, aligned_size);
            block->free = 0;
            return (void *)(block + 1);
        }
        block = block->next;
    }
    return NULL;
}

void *calloc(size_t nmemb, size_t size)
{
    size_t total = nmemb * size;
    void *ptr = malloc(total);
    if (ptr) {
        memset(ptr, 0, total);
    }
    return ptr;
}

void free(void *ptr)
{
    if (ptr == NULL) {
        return;
    }

    baremetal_block_t *block = ((baremetal_block_t *)ptr) - 1;
    block->free = 1;
    coalesce_blocks();
}

void *realloc(void *ptr, size_t size)
{
    if (ptr == NULL) {
        return malloc(size);
    }
    if (size == 0) {
        free(ptr);
        return NULL;
    }

    baremetal_block_t *block = ((baremetal_block_t *)ptr) - 1;
    if (block->size >= size) {
        split_block(block, size);
        return ptr;
    }

    void *new_ptr = malloc(size);
    if (new_ptr == NULL) {
        return NULL;
    }
    memcpy(new_ptr, ptr, block->size);
    free(ptr);
    return new_ptr;
}

int fputc(int c, FILE *stream)
{
    (void)stream;
    uart_init_once();
    if (c == '\n') {
        ck_uart_putc(&g_uart_device, '\r');
    }
    ck_uart_putc(&g_uart_device, (uint8_t)c);
    return c;
}

int fgetc(FILE *stream)
{
    (void)stream;
    return -1;
}

size_t fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream)
{
    const unsigned char *p = (const unsigned char *)ptr;
    size_t total = size * nmemb;
    size_t i;
    for (i = 0; i < total; i++) {
        fputc(p[i], stream);
    }
    return nmemb;
}

FILE *fopen(const char *path, const char *mode)
{
    (void)path;
    (void)mode;
    return NULL;
}

int fclose(FILE *stream)
{
    (void)stream;
    return 0;
}

int fseek(FILE *stream, long offset, int whence)
{
    (void)stream;
    (void)offset;
    (void)whence;
    return -1;
}

long ftell(FILE *stream)
{
    (void)stream;
    return -1;
}

void rewind(FILE *stream) { (void)stream; }

size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream)
{
    (void)ptr;
    (void)size;
    (void)nmemb;
    (void)stream;
    return 0;
}
