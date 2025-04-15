#include <stdio.h>
#include <pthread.h>
#include <time.h>

int shared_resource = 0;

#define NUM_ITERS 10000
#define NUM_THREADS 10000

typedef struct {
    volatile int flag;
} spinlock_t;

spinlock_t spinlock = {0}; // 전역 락 변수

void lock(spinlock_t *lock) {
    __asm__ volatile (
        "1:\n\t"
        "movl $1, %%eax\n\t"     // eax = 1
        "xchg %%eax, %0\n\t"     // atomic exchange lock->flag and eax
        "test %%eax, %%eax\n\t"  // test if the old value of flag was 0
        "jnz 1b\n\t"             // if it was not 0, jump back to 1
        : "=m"(lock->flag)
        : "m"(lock->flag)
        : "eax", "memory"
    );
}

void unlock(spinlock_t *lock) {
    __asm__ volatile (
        "movl $0, %0\n\t"
        : "=m"(lock->flag)
        :
        : "memory"
    );
}

void* thread_func(void* arg) {
        lock(&spinlock);      
    for(int i = 0; i < NUM_ITERS; i++) {
        shared_resource++;      
    }
        unlock(&spinlock);     

    return NULL;
}

int main() {
    time_t rawtime;
    struct tm * timeinfo;
    char buffer[80];

    time(&rawtime);

    timeinfo = localtime(&rawtime);

    strftime(buffer, sizeof(buffer), "%Y-%m-%d %H:%M:%S", timeinfo);

    printf("현재 시간: %s\n", buffer);

    pthread_t threads[NUM_THREADS];
    printf("NUM_ITERS = %d\n", NUM_ITERS);
    printf("NUM_THREADS = %d\n", NUM_THREADS);

    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_create(&threads[i], NULL, thread_func, NULL);
    }

    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);
    }

    printf("shared_resource: %d\n", shared_resource);

    return 0;
}
