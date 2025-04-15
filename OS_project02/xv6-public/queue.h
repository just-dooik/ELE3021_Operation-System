#ifndef QUEUE_H
#define QUEUE_H

#include "proc.h"
#include "defs.h"
#include "param.h"

struct queue {
    struct proc* proc[NPROC]; 
    int front;
    int rear;
};

void
initqueue(struct queue* q)
{
    q->front = 0;
    q->rear = 0;
}

int
sizeofqueue(struct queue* q)
{
    return (q->rear - q->front + NPROC) % NPROC;
}

int
isfullqueue(struct queue* q)
{
    if(q->front == 0 && q->rear == NPROC - 1)
        return 1;
    if(q->front == (q->rear + 1) % NPROC)
        return 1;
    return 0;
} 

int isemptyqueue(struct queue* q)
{
    if(q->front % NPROC == q->rear % NPROC)
        return 1;
    return 0;
}


void
insertqueue(struct queue* q, struct proc* p)
{   
    if(isfullqueue(q))
    {
        cprintf("Queue is full\n");
        return;
    }
    q->proc[q->rear % NPROC] = p;
    q->rear = (q->rear + 1) % NPROC;
}

struct proc*
deletequeue(struct queue* q)
{   
    struct proc* p;
    if(isemptyqueue(q))
    {
        cprintf("Queue is empty\n");
        return 0;
    }
    p = q->proc[q->front % NPROC];
    q->front = (q->front + 1) % NPROC;
    return p;
}


#endif