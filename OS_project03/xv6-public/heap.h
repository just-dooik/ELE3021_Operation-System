#ifndef HEAP_H
#define HEAP_H

#include "proc.h"
#include "defs.h"
#include "param.h"

struct heap {
    struct proc* proc[NPROC]; 
    int size;
};

void
initheap(struct heap* h)
{
    h->size = 0;
}

int
isfullheap(struct heap* h)
{
    if(h->size == NPROC)
        return 1;
    return 0;
}

int
isemptyheap(struct heap* h)
{
    if(h->size == 0)
        return 1;
    return 0;
}


void
heapify(struct heap* h, int index)
{
    int largest = index;
    int left = 2 * index + 1;
    int right = 2 * index + 2;

    // Check if the left child is larger than the root

    if (left < h->size && h->proc[left]->priority > h->proc[largest]->priority)
        largest = left;

    // Check if the right child is larger than the largest so far

    if (right < h->size && h->proc[right]->priority > h->proc[largest]->priority)
        largest = right;

    // If the largest is not the root, swap the root with the largest and heapify the heap

    if (largest != index) {
        struct proc* temp = h->proc[index];
        h->proc[index] = h->proc[largest];
        h->proc[largest] = temp;
        heapify(h, largest);
    }
}


struct proc*
deleteheap(struct heap* h)
{
    if (isemptyheap(h))
        return 0;

    // Store the root process (the largest element)
    struct proc* root = h->proc[0];

    // Replace the root process with the last process in the heap
    h->proc[0] = h->proc[h->size - 1];
    h->size--;

    // Heapify the heap after deletion
    heapify(h, 0);

    return root;
}
void
insertheap(struct heap* h, struct proc* p)
{
    if (isfullheap(h))
        return;

    // Insert the new process at the end of the heap
    h->proc[h->size] = p;
    h->size++;

    // Heapify the heap after insertion
    int i = h->size - 1;
    while (i != 0 && h->proc[(i - 1) / 2]->priority < h->proc[i]->priority) {
        struct proc* temp = h->proc[i];
        h->proc[i] = h->proc[(i - 1) / 2];
        h->proc[(i - 1) / 2] = temp;
        i = (i - 1) / 2;
    }
}

#endif