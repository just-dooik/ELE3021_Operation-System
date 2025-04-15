
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 30 6e 11 80       	mov    $0x80116e30,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 30 10 80       	mov    $0x80103060,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 a0 7f 10 80       	push   $0x80107fa0
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 f5 4e 00 00       	call   80104f50 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 7f 10 80       	push   $0x80107fa7
80100097:	50                   	push   %eax
80100098:	e8 83 4d 00 00       	call   80104e20 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 37 50 00 00       	call   80105120 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 59 4f 00 00       	call   801050c0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ee 4c 00 00       	call   80104e60 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 4f 21 00 00       	call   801022e0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 ae 7f 10 80       	push   $0x80107fae
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 3d 4d 00 00       	call   80104f00 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 07 21 00 00       	jmp    801022e0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 bf 7f 10 80       	push   $0x80107fbf
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 fc 4c 00 00       	call   80104f00 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 ac 4c 00 00       	call   80104ec0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 00 4f 00 00       	call   80105120 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 4f 4e 00 00       	jmp    801050c0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 c6 7f 10 80       	push   $0x80107fc6
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 c7 15 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 7b 4e 00 00       	call   80105120 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 be 48 00 00       	call   80104b90 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 29 3d 00 00       	call   80104010 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 c5 4d 00 00       	call   801050c0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 7c 14 00 00       	call   80101780 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 6f 4d 00 00       	call   801050c0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 26 14 00 00       	call   80101780 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 52 25 00 00       	call   801028f0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 cd 7f 10 80       	push   $0x80107fcd
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 53 89 10 80 	movl   $0x80108953,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 a3 4b 00 00       	call   80104f70 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 e1 7f 10 80       	push   $0x80107fe1
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 a1 66 00 00       	call   80106ac0 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 b6 65 00 00       	call   80106ac0 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 aa 65 00 00       	call   80106ac0 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 9e 65 00 00       	call   80106ac0 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 2a 4d 00 00       	call   80105280 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 75 4c 00 00       	call   801051e0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 e5 7f 10 80       	push   $0x80107fe5
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 bc 12 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 70 4b 00 00       	call   80105120 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ff 10 80       	push   $0x8010ff20
801005e4:	e8 d7 4a 00 00       	call   801050c0 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 8e 11 00 00       	call   80101780 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 10 80 10 80 	movzbl -0x7fef7ff0(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ff 10 80       	mov    0x8010ff54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ff 10 80       	push   $0x8010ff20
801007e8:	e8 33 49 00 00       	call   80105120 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf f8 7f 10 80       	mov    $0x80107ff8,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 60 48 00 00       	call   801050c0 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 ff 7f 10 80       	push   $0x80107fff
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 ff 10 80       	push   $0x8010ff20
80100893:	e8 88 48 00 00       	call   80105120 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100945:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
8010096c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100985:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100999:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009b7:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ff 10 80       	push   $0x8010ff20
801009d0:	e8 eb 46 00 00       	call   801050c0 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 4d 43 00 00       	jmp    80104d60 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a3f:	68 00 ff 10 80       	push   $0x8010ff00
80100a44:	e8 67 42 00 00       	call   80104cb0 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 08 80 10 80       	push   $0x80108008
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 db 44 00 00       	call   80104f50 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 09 11 80 90 	movl   $0x80100590,0x8011090c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 e2 19 00 00       	call   80102480 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 4f 35 00 00       	call   80104010 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 94 22 00 00       	call   80102d60 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 c9 15 00 00       	call   801020a0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 02 03 00 00    	je     80100de4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 93 0c 00 00       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 92 0f 00 00       	call   80101a90 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 01 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100b0f:	e8 bc 22 00 00       	call   80102dd0 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 17 71 00 00       	call   80107c50 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ac 02 00 00    	je     80100e03 <exec+0x353>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 c8 6e 00 00       	call   80107a70 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 a2 6d 00 00       	call   80107980 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 8a 0e 00 00       	call   80101a90 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 b0 6f 00 00       	call   80107bd0 <freevm>
  if(ip){
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 bf 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c51:	e8 7a 21 00 00       	call   80102dd0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 09 6e 00 00       	call   80107a70 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 68 70 00 00       	call   80107cf0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8b 00 00 00    	je     80100d29 <exec+0x279>
80100c9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100caa:	eb 23                	jmp    80100ccf <exec+0x21f>
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 08 47 00 00       	call   801053e0 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 f4 46 00 00       	call   801053e0 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 c3 71 00 00       	call   80107ec0 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 ba 6e 00 00       	call   80107bd0 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d63:	e8 58 71 00 00       	call   80107ec0 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 6c             	add    $0x6c,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 fa 45 00 00       	call   801053a0 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 18             	mov    0x18(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 1e 6a 00 00       	call   801077f0 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 f6 6d 00 00       	call   80107bd0 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 e7 1f 00 00       	call   80102dd0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 21 80 10 80       	push   $0x80108021
80100df1:	e8 aa f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfe:	e9 19 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e03:	be 00 20 00 00       	mov    $0x2000,%esi
80100e08:	31 ff                	xor    %edi,%edi
80100e0a:	e9 39 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e0f:	90                   	nop

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 2d 80 10 80       	push   $0x8010802d
80100e1b:	68 60 ff 10 80       	push   $0x8010ff60
80100e20:	e8 2b 41 00 00       	call   80104f50 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 60 ff 10 80       	push   $0x8010ff60
80100e41:	e8 da 42 00 00       	call   80105120 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100e59:	74 25                	je     80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 60 ff 10 80       	push   $0x8010ff60
80100e71:	e8 4a 42 00 00       	call   801050c0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 60 ff 10 80       	push   $0x8010ff60
80100e8a:	e8 31 42 00 00       	call   801050c0 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 60 ff 10 80       	push   $0x8010ff60
80100eaf:	e8 6c 42 00 00       	call   80105120 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 60 ff 10 80       	push   $0x8010ff60
80100ecc:	e8 ef 41 00 00       	call   801050c0 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 34 80 10 80       	push   $0x80108034
80100ee0:	e8 9b f4 ff ff       	call   80100380 <panic>
80100ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 60 ff 10 80       	push   $0x8010ff60
80100f01:	e8 1a 42 00 00       	call   80105120 <acquire>
  if(f->ref < 1)
80100f06:	8b 53 04             	mov    0x4(%ebx),%edx
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 d2                	test   %edx,%edx
80100f0e:	0f 8e a5 00 00 00    	jle    80100fb9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 ea 01             	sub    $0x1,%edx
80100f17:	89 53 04             	mov    %edx,0x4(%ebx)
80100f1a:	75 44                	jne    80100f60 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f1c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f20:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f23:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f2b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f2e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f34:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 7f 41 00 00       	call   801050c0 <release>

  if(ff.type == FD_PIPE)
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	83 ff 01             	cmp    $0x1,%edi
80100f47:	74 57                	je     80100fa0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f49:	83 ff 02             	cmp    $0x2,%edi
80100f4c:	74 2a                	je     80100f78 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f51:	5b                   	pop    %ebx
80100f52:	5e                   	pop    %esi
80100f53:	5f                   	pop    %edi
80100f54:	5d                   	pop    %ebp
80100f55:	c3                   	ret    
80100f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f60:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 4d 41 00 00       	jmp    801050c0 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 e3 1d 00 00       	call   80102d60 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 28 09 00 00       	call   801018b0 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 39 1e 00 00       	jmp    80102dd0 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 82 25 00 00       	call   80103530 <pipeclose>
80100fae:	83 c4 10             	add    $0x10,%esp
}
80100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5e                   	pop    %esi
80100fb6:	5f                   	pop    %edi
80100fb7:	5d                   	pop    %ebp
80100fb8:	c3                   	ret    
    panic("fileclose");
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	68 3c 80 10 80       	push   $0x8010803c
80100fc1:	e8 ba f3 ff ff       	call   80100380 <panic>
80100fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	ff 73 10             	push   0x10(%ebx)
80100fe5:	e8 96 07 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 69 0a 00 00       	call   80101a60 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 60 08 00 00       	call   80101860 <iunlock>
    return 0;
  }
  return -1;
}
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101003:	83 c4 10             	add    $0x10,%esp
80101006:	31 c0                	xor    %eax,%eax
}
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010102f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101032:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101036:	74 60                	je     80101098 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101038:	8b 03                	mov    (%ebx),%eax
8010103a:	83 f8 01             	cmp    $0x1,%eax
8010103d:	74 41                	je     80101080 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103f:	83 f8 02             	cmp    $0x2,%eax
80101042:	75 5b                	jne    8010109f <fileread+0x7f>
    ilock(f->ip);
80101044:	83 ec 0c             	sub    $0xc,%esp
80101047:	ff 73 10             	push   0x10(%ebx)
8010104a:	e8 31 07 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 34 0a 00 00       	call   80101a90 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 ed 07 00 00       	call   80101860 <iunlock>
    return r;
80101073:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	89 f0                	mov    %esi,%eax
8010107b:	5b                   	pop    %ebx
8010107c:	5e                   	pop    %esi
8010107d:	5f                   	pop    %edi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101080:	8b 43 0c             	mov    0xc(%ebx),%eax
80101083:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010108d:	e9 3e 26 00 00       	jmp    801036d0 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 46 80 10 80       	push   $0x80108046
801010a7:	e8 d4 f2 ff ff       	call   80100380 <panic>
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 1c             	sub    $0x1c,%esp
801010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010cc:	0f 84 bd 00 00 00    	je     8010118f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010d2:	8b 03                	mov    (%ebx),%eax
801010d4:	83 f8 01             	cmp    $0x1,%eax
801010d7:	0f 84 bf 00 00 00    	je     8010119c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010dd:	83 f8 02             	cmp    $0x2,%eax
801010e0:	0f 85 c8 00 00 00    	jne    801011ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010eb:	85 c0                	test   %eax,%eax
801010ed:	7f 30                	jg     8010111f <filewrite+0x6f>
801010ef:	e9 94 00 00 00       	jmp    80101188 <filewrite+0xd8>
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101104:	e8 57 07 00 00       	call   80101860 <iunlock>
      end_op();
80101109:	e8 c2 1c 00 00       	call   80102dd0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	39 c7                	cmp    %eax,%edi
80101116:	75 5c                	jne    80101174 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101118:	01 fe                	add    %edi,%esi
    while(i < n){
8010111a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010111d:	7e 69                	jle    80101188 <filewrite+0xd8>
      int n1 = n - i;
8010111f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101122:	b8 00 06 00 00       	mov    $0x600,%eax
80101127:	29 f7                	sub    %esi,%edi
80101129:	39 c7                	cmp    %eax,%edi
8010112b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010112e:	e8 2d 1c 00 00       	call   80102d60 <begin_op>
      ilock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 42 06 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101141:	57                   	push   %edi
80101142:	ff 73 14             	push   0x14(%ebx)
80101145:	01 f0                	add    %esi,%eax
80101147:	50                   	push   %eax
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 40 0a 00 00       	call   80101b90 <writei>
80101150:	83 c4 20             	add    $0x20,%esp
80101153:	85 c0                	test   %eax,%eax
80101155:	7f a1                	jg     801010f8 <filewrite+0x48>
      iunlock(f->ip);
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 fb 06 00 00       	call   80101860 <iunlock>
      end_op();
80101165:	e8 66 1c 00 00       	call   80102dd0 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 4f 80 10 80       	push   $0x8010804f
8010117c:	e8 ff f1 ff ff       	call   80100380 <panic>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101188:	89 f0                	mov    %esi,%eax
8010118a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010118d:	74 05                	je     80101194 <filewrite+0xe4>
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101197:	5b                   	pop    %ebx
80101198:	5e                   	pop    %esi
80101199:	5f                   	pop    %edi
8010119a:	5d                   	pop    %ebp
8010119b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010119c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010119f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a5:	5b                   	pop    %ebx
801011a6:	5e                   	pop    %esi
801011a7:	5f                   	pop    %edi
801011a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a9:	e9 22 24 00 00       	jmp    801035d0 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 55 80 10 80       	push   $0x80108055
801011b6:	e8 c5 f1 ff ff       	call   80100380 <panic>
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
801011e3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011e6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011e8:	83 e1 07             	and    $0x7,%ecx
801011eb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801011f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801011f6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801011f8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801011fd:	85 c1                	test   %eax,%ecx
801011ff:	74 23                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101201:	f7 d0                	not    %eax
  log_write(bp);
80101203:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101206:	21 c8                	and    %ecx,%eax
80101208:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010120c:	56                   	push   %esi
8010120d:	e8 2e 1d 00 00       	call   80102f40 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 5f 80 10 80       	push   $0x8010805f
8010122c:	e8 4f f1 ff ff       	call   80100380 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	push   -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 72 80 10 80       	push   $0x80108072
801012e9:	e8 92 f0 ff ff       	call   80100380 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 3e 1c 00 00       	call   80102f40 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	push   -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 b6 3e 00 00       	call   801051e0 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 0e 1c 00 00       	call   80102f40 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 60 09 11 80       	push   $0x80110960
8010136a:	e8 b1 3d 00 00       	call   80105120 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010138a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 43 08             	mov    0x8(%ebx),%eax
80101395:	85 c0                	test   %eax,%eax
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	85 c0                	test   %eax,%eax
8010139f:	75 76                	jne    80101417 <iget+0xc7>
801013a1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a9:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013af:	72 e1                	jb     80101392 <iget+0x42>
801013b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 79                	je     80101435 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 60 09 11 80       	push   $0x80110960
801013d7:	e8 e4 3c 00 00       	call   801050c0 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c0 01             	add    $0x1,%eax
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 b6 3c 00 00       	call   801050c0 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010141d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 88 80 10 80       	push   $0x80108088
8010143d:	e8 3e ef ff ff       	call   80100380 <panic>
80101442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101450 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	89 c6                	mov    %eax,%esi
80101457:	53                   	push   %ebx
80101458:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010145b:	83 fa 0b             	cmp    $0xb,%edx
8010145e:	0f 86 8c 00 00 00    	jbe    801014f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101464:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101467:	83 fb 7f             	cmp    $0x7f,%ebx
8010146a:	0f 87 a2 00 00 00    	ja     80101512 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101470:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101476:	85 c0                	test   %eax,%eax
80101478:	74 5e                	je     801014d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010147a:	83 ec 08             	sub    $0x8,%esp
8010147d:	50                   	push   %eax
8010147e:	ff 36                	push   (%esi)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101485:	83 c4 10             	add    $0x10,%esp
80101488:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010148c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010148e:	8b 3b                	mov    (%ebx),%edi
80101490:	85 ff                	test   %edi,%edi
80101492:	74 1c                	je     801014b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101494:	83 ec 0c             	sub    $0xc,%esp
80101497:	52                   	push   %edx
80101498:	e8 53 ed ff ff       	call   801001f0 <brelse>
8010149d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a3:	89 f8                	mov    %edi,%eax
801014a5:	5b                   	pop    %ebx
801014a6:	5e                   	pop    %esi
801014a7:	5f                   	pop    %edi
801014a8:	5d                   	pop    %ebp
801014a9:	c3                   	ret    
801014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014b3:	8b 06                	mov    (%esi),%eax
801014b5:	e8 86 fd ff ff       	call   80101240 <balloc>
      log_write(bp);
801014ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014c0:	89 03                	mov    %eax,(%ebx)
801014c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014c4:	52                   	push   %edx
801014c5:	e8 76 1a 00 00       	call   80102f40 <log_write>
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 c4 10             	add    $0x10,%esp
801014d0:	eb c2                	jmp    80101494 <bmap+0x44>
801014d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014d8:	8b 06                	mov    (%esi),%eax
801014da:	e8 61 fd ff ff       	call   80101240 <balloc>
801014df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014e5:	eb 93                	jmp    8010147a <bmap+0x2a>
801014e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ee:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801014f0:	8d 5a 14             	lea    0x14(%edx),%ebx
801014f3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801014f7:	85 ff                	test   %edi,%edi
801014f9:	75 a5                	jne    801014a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014fb:	8b 00                	mov    (%eax),%eax
801014fd:	e8 3e fd ff ff       	call   80101240 <balloc>
80101502:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101506:	89 c7                	mov    %eax,%edi
}
80101508:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010150b:	5b                   	pop    %ebx
8010150c:	89 f8                	mov    %edi,%eax
8010150e:	5e                   	pop    %esi
8010150f:	5f                   	pop    %edi
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
  panic("bmap: out of range");
80101512:	83 ec 0c             	sub    $0xc,%esp
80101515:	68 98 80 10 80       	push   $0x80108098
8010151a:	e8 61 ee ff ff       	call   80100380 <panic>
8010151f:	90                   	nop

80101520 <readsb>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	56                   	push   %esi
80101524:	53                   	push   %ebx
80101525:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101528:	83 ec 08             	sub    $0x8,%esp
8010152b:	6a 01                	push   $0x1
8010152d:	ff 75 08             	push   0x8(%ebp)
80101530:	e8 9b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101535:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101538:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010153a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010153d:	6a 1c                	push   $0x1c
8010153f:	50                   	push   %eax
80101540:	56                   	push   %esi
80101541:	e8 3a 3d 00 00       	call   80105280 <memmove>
  brelse(bp);
80101546:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101549:	83 c4 10             	add    $0x10,%esp
}
8010154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5d                   	pop    %ebp
  brelse(bp);
80101552:	e9 99 ec ff ff       	jmp    801001f0 <brelse>
80101557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155e:	66 90                	xchg   %ax,%ax

80101560 <iinit>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	53                   	push   %ebx
80101564:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 ab 80 10 80       	push   $0x801080ab
80101571:	68 60 09 11 80       	push   $0x80110960
80101576:	e8 d5 39 00 00       	call   80104f50 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 b2 80 10 80       	push   $0x801080b2
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 8c 38 00 00       	call   80104e20 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
8010159d:	75 e1                	jne    80101580 <iinit+0x20>
  bp = bread(dev, 1);
8010159f:	83 ec 08             	sub    $0x8,%esp
801015a2:	6a 01                	push   $0x1
801015a4:	ff 75 08             	push   0x8(%ebp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015ac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015af:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015b4:	6a 1c                	push   $0x1c
801015b6:	50                   	push   %eax
801015b7:	68 b4 25 11 80       	push   $0x801125b4
801015bc:	e8 bf 3c 00 00       	call   80105280 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 cc 25 11 80    	push   0x801125cc
801015cf:	ff 35 c8 25 11 80    	push   0x801125c8
801015d5:	ff 35 c4 25 11 80    	push   0x801125c4
801015db:	ff 35 c0 25 11 80    	push   0x801125c0
801015e1:	ff 35 bc 25 11 80    	push   0x801125bc
801015e7:	ff 35 b8 25 11 80    	push   0x801125b8
801015ed:	ff 35 b4 25 11 80    	push   0x801125b4
801015f3:	68 18 81 10 80       	push   $0x80108118
801015f8:	e8 a3 f0 ff ff       	call   801006a0 <cprintf>
}
801015fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101600:	83 c4 30             	add    $0x30,%esp
80101603:	c9                   	leave  
80101604:	c3                   	ret    
80101605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <ialloc>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	83 ec 1c             	sub    $0x1c,%esp
80101619:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101623:	8b 75 08             	mov    0x8(%ebp),%esi
80101626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101629:	0f 86 91 00 00 00    	jbe    801016c0 <ialloc+0xb0>
8010162f:	bf 01 00 00 00       	mov    $0x1,%edi
80101634:	eb 21                	jmp    80101657 <ialloc+0x47>
80101636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101640:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101643:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101646:	53                   	push   %ebx
80101647:	e8 a4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010164c:	83 c4 10             	add    $0x10,%esp
8010164f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101665:	50                   	push   %eax
80101666:	56                   	push   %esi
80101667:	e8 64 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010166c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010166f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101671:	89 f8                	mov    %edi,%eax
80101673:	83 e0 07             	and    $0x7,%eax
80101676:	c1 e0 06             	shl    $0x6,%eax
80101679:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010167d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101681:	75 bd                	jne    80101640 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101683:	83 ec 04             	sub    $0x4,%esp
80101686:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101689:	6a 40                	push   $0x40
8010168b:	6a 00                	push   $0x0
8010168d:	51                   	push   %ecx
8010168e:	e8 4d 3b 00 00       	call   801051e0 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 9b 18 00 00       	call   80102f40 <log_write>
      brelse(bp);
801016a5:	89 1c 24             	mov    %ebx,(%esp)
801016a8:	e8 43 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016ad:	83 c4 10             	add    $0x10,%esp
}
801016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016b3:	89 fa                	mov    %edi,%edx
}
801016b5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016b6:	89 f0                	mov    %esi,%eax
}
801016b8:	5e                   	pop    %esi
801016b9:	5f                   	pop    %edi
801016ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801016bb:	e9 90 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 b8 80 10 80       	push   $0x801080b8
801016c8:	e8 b3 ec ff ff       	call   80100380 <panic>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <iupdate>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	83 ec 08             	sub    $0x8,%esp
801016e1:	c1 e8 03             	shr    $0x3,%eax
801016e4:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801016ea:	50                   	push   %eax
801016eb:	ff 73 a4             	push   -0x5c(%ebx)
801016ee:	e8 dd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016f3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016fc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101709:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010170c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101710:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101713:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101717:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010171b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010171f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101723:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101727:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010172a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172d:	6a 34                	push   $0x34
8010172f:	53                   	push   %ebx
80101730:	50                   	push   %eax
80101731:	e8 4a 3b 00 00       	call   80105280 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 02 18 00 00       	call   80102f40 <log_write>
  brelse(bp);
8010173e:	89 75 08             	mov    %esi,0x8(%ebp)
80101741:	83 c4 10             	add    $0x10,%esp
}
80101744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101747:	5b                   	pop    %ebx
80101748:	5e                   	pop    %esi
80101749:	5d                   	pop    %ebp
  brelse(bp);
8010174a:	e9 a1 ea ff ff       	jmp    801001f0 <brelse>
8010174f:	90                   	nop

80101750 <idup>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 10             	sub    $0x10,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175a:	68 60 09 11 80       	push   $0x80110960
8010175f:	e8 bc 39 00 00       	call   80105120 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010176f:	e8 4c 39 00 00       	call   801050c0 <release>
}
80101774:	89 d8                	mov    %ebx,%eax
80101776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101779:	c9                   	leave  
8010177a:	c3                   	ret    
8010177b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010177f:	90                   	nop

80101780 <ilock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	0f 84 b7 00 00 00    	je     80101847 <ilock+0xc7>
80101790:	8b 53 08             	mov    0x8(%ebx),%edx
80101793:	85 d2                	test   %edx,%edx
80101795:	0f 8e ac 00 00 00    	jle    80101847 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010179b:	83 ec 0c             	sub    $0xc,%esp
8010179e:	8d 43 0c             	lea    0xc(%ebx),%eax
801017a1:	50                   	push   %eax
801017a2:	e8 b9 36 00 00       	call   80104e60 <acquiresleep>
  if(ip->valid == 0){
801017a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017aa:	83 c4 10             	add    $0x10,%esp
801017ad:	85 c0                	test   %eax,%eax
801017af:	74 0f                	je     801017c0 <ilock+0x40>
}
801017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b4:	5b                   	pop    %ebx
801017b5:	5e                   	pop    %esi
801017b6:	5d                   	pop    %ebp
801017b7:	c3                   	ret    
801017b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017bf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 03             	shr    $0x3,%eax
801017c9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	push   (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017da:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017dc:	8b 43 04             	mov    0x4(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
801017e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101811:	6a 34                	push   $0x34
80101813:	50                   	push   %eax
80101814:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 63 3a 00 00       	call   80105280 <memmove>
    brelse(bp);
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 cb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010182d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101834:	0f 85 77 ff ff ff    	jne    801017b1 <ilock+0x31>
      panic("ilock: no type");
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 d0 80 10 80       	push   $0x801080d0
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 ca 80 10 80       	push   $0x801080ca
8010184f:	e8 2c eb ff ff       	call   80100380 <panic>
80101854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop

80101860 <iunlock>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	56                   	push   %esi
80101864:	53                   	push   %ebx
80101865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101868:	85 db                	test   %ebx,%ebx
8010186a:	74 28                	je     80101894 <iunlock+0x34>
8010186c:	83 ec 0c             	sub    $0xc,%esp
8010186f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101872:	56                   	push   %esi
80101873:	e8 88 36 00 00       	call   80104f00 <holdingsleep>
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 c0                	test   %eax,%eax
8010187d:	74 15                	je     80101894 <iunlock+0x34>
8010187f:	8b 43 08             	mov    0x8(%ebx),%eax
80101882:	85 c0                	test   %eax,%eax
80101884:	7e 0e                	jle    80101894 <iunlock+0x34>
  releasesleep(&ip->lock);
80101886:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101889:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010188f:	e9 2c 36 00 00       	jmp    80104ec0 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 df 80 10 80       	push   $0x801080df
8010189c:	e8 df ea ff ff       	call   80100380 <panic>
801018a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iput>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 28             	sub    $0x28,%esp
801018b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018bf:	57                   	push   %edi
801018c0:	e8 9b 35 00 00       	call   80104e60 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 d2                	test   %edx,%edx
801018cd:	74 07                	je     801018d6 <iput+0x26>
801018cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018d4:	74 32                	je     80101908 <iput+0x58>
  releasesleep(&ip->lock);
801018d6:	83 ec 0c             	sub    $0xc,%esp
801018d9:	57                   	push   %edi
801018da:	e8 e1 35 00 00       	call   80104ec0 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801018e6:	e8 35 38 00 00       	call   80105120 <acquire>
  ip->ref--;
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101900:	e9 bb 37 00 00       	jmp    801050c0 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 09 11 80       	push   $0x80110960
80101910:	e8 0b 38 00 00       	call   80105120 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010191f:	e8 9c 37 00 00       	call   801050c0 <release>
    if(r == 1){
80101924:	83 c4 10             	add    $0x10,%esp
80101927:	83 fe 01             	cmp    $0x1,%esi
8010192a:	75 aa                	jne    801018d6 <iput+0x26>
8010192c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101932:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101935:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101938:	89 cf                	mov    %ecx,%edi
8010193a:	eb 0b                	jmp    80101947 <iput+0x97>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101940:	83 c6 04             	add    $0x4,%esi
80101943:	39 fe                	cmp    %edi,%esi
80101945:	74 19                	je     80101960 <iput+0xb0>
    if(ip->addrs[i]){
80101947:	8b 16                	mov    (%esi),%edx
80101949:	85 d2                	test   %edx,%edx
8010194b:	74 f3                	je     80101940 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010194d:	8b 03                	mov    (%ebx),%eax
8010194f:	e8 6c f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
80101954:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010195a:	eb e4                	jmp    80101940 <iput+0x90>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101960:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101966:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101969:	85 c0                	test   %eax,%eax
8010196b:	75 2d                	jne    8010199a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010196d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101970:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101977:	53                   	push   %ebx
80101978:	e8 53 fd ff ff       	call   801016d0 <iupdate>
      ip->type = 0;
8010197d:	31 c0                	xor    %eax,%eax
8010197f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101983:	89 1c 24             	mov    %ebx,(%esp)
80101986:	e8 45 fd ff ff       	call   801016d0 <iupdate>
      ip->valid = 0;
8010198b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101992:	83 c4 10             	add    $0x10,%esp
80101995:	e9 3c ff ff ff       	jmp    801018d6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010199a:	83 ec 08             	sub    $0x8,%esp
8010199d:	50                   	push   %eax
8010199e:	ff 33                	push   (%ebx)
801019a0:	e8 2b e7 ff ff       	call   801000d0 <bread>
801019a5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b7:	89 cf                	mov    %ecx,%edi
801019b9:	eb 0c                	jmp    801019c7 <iput+0x117>
801019bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019bf:	90                   	nop
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 0f                	je     801019d6 <iput+0x126>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x110>
    brelse(bp);
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	ff 75 e4             	push   -0x1c(%ebp)
801019dc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019df:	e8 0c e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019e4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019ea:	8b 03                	mov    (%ebx),%eax
801019ec:	e8 cf f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019f1:	83 c4 10             	add    $0x10,%esp
801019f4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019fb:	00 00 00 
801019fe:	e9 6a ff ff ff       	jmp    8010196d <iput+0xbd>
80101a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	56                   	push   %esi
80101a14:	53                   	push   %ebx
80101a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a18:	85 db                	test   %ebx,%ebx
80101a1a:	74 34                	je     80101a50 <iunlockput+0x40>
80101a1c:	83 ec 0c             	sub    $0xc,%esp
80101a1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a22:	56                   	push   %esi
80101a23:	e8 d8 34 00 00       	call   80104f00 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 81 34 00 00       	call   80104ec0 <releasesleep>
  iput(ip);
80101a3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a42:	83 c4 10             	add    $0x10,%esp
}
80101a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5d                   	pop    %ebp
  iput(ip);
80101a4b:	e9 60 fe ff ff       	jmp    801018b0 <iput>
    panic("iunlock");
80101a50:	83 ec 0c             	sub    $0xc,%esp
80101a53:	68 df 80 10 80       	push   $0x801080df
80101a58:	e8 23 e9 ff ff       	call   80100380 <panic>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi

80101a60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	8b 55 08             	mov    0x8(%ebp),%edx
80101a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a69:	8b 0a                	mov    (%edx),%ecx
80101a6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a83:	8b 52 58             	mov    0x58(%edx),%edx
80101a86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a89:	5d                   	pop    %ebp
80101a8a:	c3                   	ret    
80101a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a8f:	90                   	nop

80101a90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101aa5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 a7 00 00 00    	je     80101b60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	8b 40 58             	mov    0x58(%eax),%eax
80101abf:	39 c6                	cmp    %eax,%esi
80101ac1:	0f 87 ba 00 00 00    	ja     80101b81 <readi+0xf1>
80101ac7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aca:	31 c9                	xor    %ecx,%ecx
80101acc:	89 da                	mov    %ebx,%edx
80101ace:	01 f2                	add    %esi,%edx
80101ad0:	0f 92 c1             	setb   %cl
80101ad3:	89 cf                	mov    %ecx,%edi
80101ad5:	0f 82 a6 00 00 00    	jb     80101b81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101adb:	89 c1                	mov    %eax,%ecx
80101add:	29 f1                	sub    %esi,%ecx
80101adf:	39 d0                	cmp    %edx,%eax
80101ae1:	0f 43 cb             	cmovae %ebx,%ecx
80101ae4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae7:	85 c9                	test   %ecx,%ecx
80101ae9:	74 67                	je     80101b52 <readi+0xc2>
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 d8                	mov    %ebx,%eax
80101afa:	e8 51 f9 ff ff       	call   80101450 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 33                	push   (%ebx)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b0d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b12:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b14:	89 f0                	mov    %esi,%eax
80101b16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b20:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b22:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b26:	39 d9                	cmp    %ebx,%ecx
80101b28:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2b:	83 c4 0c             	add    $0xc,%esp
80101b2e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	01 df                	add    %ebx,%edi
80101b31:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b33:	50                   	push   %eax
80101b34:	ff 75 e0             	push   -0x20(%ebp)
80101b37:	e8 44 37 00 00       	call   80105280 <memmove>
    brelse(bp);
80101b3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b3f:	89 14 24             	mov    %edx,(%esp)
80101b42:	e8 a9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b50:	77 9e                	ja     80101af0 <readi+0x60>
  }
  return n;
80101b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 17                	ja     80101b81 <readi+0xf1>
80101b6a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 0c                	je     80101b81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b7f:	ff e0                	jmp    *%eax
      return -1;
80101b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b86:	eb cd                	jmp    80101b55 <readi+0xc5>
80101b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8f:	90                   	nop

80101b90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b9f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ba2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ba7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101baa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bad:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bb3:	0f 84 b7 00 00 00    	je     80101c70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bbf:	0f 87 e7 00 00 00    	ja     80101cac <writei+0x11c>
80101bc5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc8:	31 d2                	xor    %edx,%edx
80101bca:	89 f8                	mov    %edi,%eax
80101bcc:	01 f0                	add    %esi,%eax
80101bce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bd1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bd6:	0f 87 d0 00 00 00    	ja     80101cac <writei+0x11c>
80101bdc:	85 d2                	test   %edx,%edx
80101bde:	0f 85 c8 00 00 00    	jne    80101cac <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101beb:	85 ff                	test   %edi,%edi
80101bed:	74 72                	je     80101c61 <writei+0xd1>
80101bef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bf3:	89 f2                	mov    %esi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 f8                	mov    %edi,%eax
80101bfa:	e8 51 f8 ff ff       	call   80101450 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 37                	push   (%edi)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c15:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c17:	89 f0                	mov    %esi,%eax
80101c19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c1e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c20:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c24:	39 d9                	cmp    %ebx,%ecx
80101c26:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c29:	83 c4 0c             	add    $0xc,%esp
80101c2c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c2d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c2f:	ff 75 dc             	push   -0x24(%ebp)
80101c32:	50                   	push   %eax
80101c33:	e8 48 36 00 00       	call   80105280 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 00 13 00 00       	call   80102f40 <log_write>
    brelse(bp);
80101c40:	89 3c 24             	mov    %edi,(%esp)
80101c43:	e8 a8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c4b:	83 c4 10             	add    $0x10,%esp
80101c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c57:	77 97                	ja     80101bf0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c5f:	77 37                	ja     80101c98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c67:	5b                   	pop    %ebx
80101c68:	5e                   	pop    %esi
80101c69:	5f                   	pop    %edi
80101c6a:	5d                   	pop    %ebp
80101c6b:	c3                   	ret    
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 32                	ja     80101cac <writei+0x11c>
80101c7a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 27                	je     80101cac <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c85:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ca1:	50                   	push   %eax
80101ca2:	e8 29 fa ff ff       	call   801016d0 <iupdate>
80101ca7:	83 c4 10             	add    $0x10,%esp
80101caa:	eb b5                	jmp    80101c61 <writei+0xd1>
      return -1;
80101cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb1:	eb b1                	jmp    80101c64 <writei+0xd4>
80101cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cc6:	6a 0e                	push   $0xe
80101cc8:	ff 75 0c             	push   0xc(%ebp)
80101ccb:	ff 75 08             	push   0x8(%ebp)
80101cce:	e8 1d 36 00 00       	call   801052f0 <strncmp>
}
80101cd3:	c9                   	leave  
80101cd4:	c3                   	ret    
80101cd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ce0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cf1:	0f 85 85 00 00 00    	jne    80101d7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cfa:	31 ff                	xor    %edi,%edi
80101cfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cff:	85 d2                	test   %edx,%edx
80101d01:	74 3e                	je     80101d41 <dirlookup+0x61>
80101d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d07:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d08:	6a 10                	push   $0x10
80101d0a:	57                   	push   %edi
80101d0b:	56                   	push   %esi
80101d0c:	53                   	push   %ebx
80101d0d:	e8 7e fd ff ff       	call   80101a90 <readi>
80101d12:	83 c4 10             	add    $0x10,%esp
80101d15:	83 f8 10             	cmp    $0x10,%eax
80101d18:	75 55                	jne    80101d6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d1f:	74 18                	je     80101d39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d21:	83 ec 04             	sub    $0x4,%esp
80101d24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d27:	6a 0e                	push   $0xe
80101d29:	50                   	push   %eax
80101d2a:	ff 75 0c             	push   0xc(%ebp)
80101d2d:	e8 be 35 00 00       	call   801052f0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	85 c0                	test   %eax,%eax
80101d37:	74 17                	je     80101d50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d39:	83 c7 10             	add    $0x10,%edi
80101d3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d3f:	72 c7                	jb     80101d08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d44:	31 c0                	xor    %eax,%eax
}
80101d46:	5b                   	pop    %ebx
80101d47:	5e                   	pop    %esi
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop
      if(poff)
80101d50:	8b 45 10             	mov    0x10(%ebp),%eax
80101d53:	85 c0                	test   %eax,%eax
80101d55:	74 05                	je     80101d5c <dirlookup+0x7c>
        *poff = off;
80101d57:	8b 45 10             	mov    0x10(%ebp),%eax
80101d5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d60:	8b 03                	mov    (%ebx),%eax
80101d62:	e8 e9 f5 ff ff       	call   80101350 <iget>
}
80101d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d6a:	5b                   	pop    %ebx
80101d6b:	5e                   	pop    %esi
80101d6c:	5f                   	pop    %edi
80101d6d:	5d                   	pop    %ebp
80101d6e:	c3                   	ret    
      panic("dirlookup read");
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	68 f9 80 10 80       	push   $0x801080f9
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 e7 80 10 80       	push   $0x801080e7
80101d84:	e8 f7 e5 ff ff       	call   80100380 <panic>
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	89 c3                	mov    %eax,%ebx
80101d98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101da4:	0f 84 64 01 00 00    	je     80101f0e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101daa:	e8 61 22 00 00       	call   80104010 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 60 09 11 80       	push   $0x80110960
80101dba:	e8 61 33 00 00       	call   80105120 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dca:	e8 f1 32 00 00       	call   801050c0 <release>
80101dcf:	83 c4 10             	add    $0x10,%esp
80101dd2:	eb 07                	jmp    80101ddb <namex+0x4b>
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101dd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ddb:	0f b6 03             	movzbl (%ebx),%eax
80101dde:	3c 2f                	cmp    $0x2f,%al
80101de0:	74 f6                	je     80101dd8 <namex+0x48>
  if(*path == 0)
80101de2:	84 c0                	test   %al,%al
80101de4:	0f 84 06 01 00 00    	je     80101ef0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dea:	0f b6 03             	movzbl (%ebx),%eax
80101ded:	84 c0                	test   %al,%al
80101def:	0f 84 10 01 00 00    	je     80101f05 <namex+0x175>
80101df5:	89 df                	mov    %ebx,%edi
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	0f 84 06 01 00 00    	je     80101f05 <namex+0x175>
80101dff:	90                   	nop
80101e00:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e04:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x7f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x70>
  len = path - s;
80101e0f:	89 f8                	mov    %edi,%eax
80101e11:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e ac 00 00 00    	jle    80101ec8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	53                   	push   %ebx
    path++;
80101e22:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	push   -0x1c(%ebp)
80101e27:	e8 54 34 00 00       	call   80105280 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e32:	75 0c                	jne    80101e40 <namex+0xb0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e3b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e3e:	74 f8                	je     80101e38 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 37 f9 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 cd 00 00 00    	jne    80101f24 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	74 09                	je     80101e67 <namex+0xd7>
80101e5e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e61:	0f 84 22 01 00 00    	je     80101f89 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	push   -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 6b fe ff ff       	call   80101ce0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e75:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e78:	83 c4 10             	add    $0x10,%esp
80101e7b:	89 c7                	mov    %eax,%edi
80101e7d:	85 c0                	test   %eax,%eax
80101e7f:	0f 84 e1 00 00 00    	je     80101f66 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e8b:	52                   	push   %edx
80101e8c:	e8 6f 30 00 00       	call   80104f00 <holdingsleep>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	85 c0                	test   %eax,%eax
80101e96:	0f 84 30 01 00 00    	je     80101fcc <namex+0x23c>
80101e9c:	8b 56 08             	mov    0x8(%esi),%edx
80101e9f:	85 d2                	test   %edx,%edx
80101ea1:	0f 8e 25 01 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eaa:	83 ec 0c             	sub    $0xc,%esp
80101ead:	52                   	push   %edx
80101eae:	e8 0d 30 00 00       	call   80104ec0 <releasesleep>
  iput(ip);
80101eb3:	89 34 24             	mov    %esi,(%esp)
80101eb6:	89 fe                	mov    %edi,%esi
80101eb8:	e8 f3 f9 ff ff       	call   801018b0 <iput>
80101ebd:	83 c4 10             	add    $0x10,%esp
80101ec0:	e9 16 ff ff ff       	jmp    80101ddb <namex+0x4b>
80101ec5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ec8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ecb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ece:	83 ec 04             	sub    $0x4,%esp
80101ed1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ed4:	50                   	push   %eax
80101ed5:	53                   	push   %ebx
    name[len] = 0;
80101ed6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ed8:	ff 75 e4             	push   -0x1c(%ebp)
80101edb:	e8 a0 33 00 00       	call   80105280 <memmove>
    name[len] = 0;
80101ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ee3:	83 c4 10             	add    $0x10,%esp
80101ee6:	c6 02 00             	movb   $0x0,(%edx)
80101ee9:	e9 41 ff ff ff       	jmp    80101e2f <namex+0x9f>
80101eee:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ef3:	85 c0                	test   %eax,%eax
80101ef5:	0f 85 be 00 00 00    	jne    80101fb9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efe:	89 f0                	mov    %esi,%eax
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f08:	89 df                	mov    %ebx,%edi
80101f0a:	31 c0                	xor    %eax,%eax
80101f0c:	eb c0                	jmp    80101ece <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f0e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f13:	b8 01 00 00 00       	mov    $0x1,%eax
80101f18:	e8 33 f4 ff ff       	call   80101350 <iget>
80101f1d:	89 c6                	mov    %eax,%esi
80101f1f:	e9 b7 fe ff ff       	jmp    80101ddb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f24:	83 ec 0c             	sub    $0xc,%esp
80101f27:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f2a:	53                   	push   %ebx
80101f2b:	e8 d0 2f 00 00       	call   80104f00 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 71 2f 00 00       	call   80104ec0 <releasesleep>
  iput(ip);
80101f4f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f52:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f54:	e8 57 f9 ff ff       	call   801018b0 <iput>
      return 0;
80101f59:	83 c4 10             	add    $0x10,%esp
}
80101f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5f:	89 f0                	mov    %esi,%eax
80101f61:	5b                   	pop    %ebx
80101f62:	5e                   	pop    %esi
80101f63:	5f                   	pop    %edi
80101f64:	5d                   	pop    %ebp
80101f65:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f6c:	52                   	push   %edx
80101f6d:	e8 8e 2f 00 00       	call   80104f00 <holdingsleep>
80101f72:	83 c4 10             	add    $0x10,%esp
80101f75:	85 c0                	test   %eax,%eax
80101f77:	74 53                	je     80101fcc <namex+0x23c>
80101f79:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f7c:	85 c9                	test   %ecx,%ecx
80101f7e:	7e 4c                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f83:	83 ec 0c             	sub    $0xc,%esp
80101f86:	52                   	push   %edx
80101f87:	eb c1                	jmp    80101f4a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f89:	83 ec 0c             	sub    $0xc,%esp
80101f8c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f8f:	53                   	push   %ebx
80101f90:	e8 6b 2f 00 00       	call   80104f00 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 14 2f 00 00       	call   80104ec0 <releasesleep>
}
80101fac:	83 c4 10             	add    $0x10,%esp
}
80101faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb2:	89 f0                	mov    %esi,%eax
80101fb4:	5b                   	pop    %ebx
80101fb5:	5e                   	pop    %esi
80101fb6:	5f                   	pop    %edi
80101fb7:	5d                   	pop    %ebp
80101fb8:	c3                   	ret    
    iput(ip);
80101fb9:	83 ec 0c             	sub    $0xc,%esp
80101fbc:	56                   	push   %esi
    return 0;
80101fbd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fbf:	e8 ec f8 ff ff       	call   801018b0 <iput>
    return 0;
80101fc4:	83 c4 10             	add    $0x10,%esp
80101fc7:	e9 2f ff ff ff       	jmp    80101efb <namex+0x16b>
    panic("iunlock");
80101fcc:	83 ec 0c             	sub    $0xc,%esp
80101fcf:	68 df 80 10 80       	push   $0x801080df
80101fd4:	e8 a7 e3 ff ff       	call   80100380 <panic>
80101fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <dirlink>:
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 20             	sub    $0x20,%esp
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fec:	6a 00                	push   $0x0
80101fee:	ff 75 0c             	push   0xc(%ebp)
80101ff1:	53                   	push   %ebx
80101ff2:	e8 e9 fc ff ff       	call   80101ce0 <dirlookup>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	75 67                	jne    80102065 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ffe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102001:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102004:	85 ff                	test   %edi,%edi
80102006:	74 29                	je     80102031 <dirlink+0x51>
80102008:	31 ff                	xor    %edi,%edi
8010200a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010200d:	eb 09                	jmp    80102018 <dirlink+0x38>
8010200f:	90                   	nop
80102010:	83 c7 10             	add    $0x10,%edi
80102013:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102016:	73 19                	jae    80102031 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102018:	6a 10                	push   $0x10
8010201a:	57                   	push   %edi
8010201b:	56                   	push   %esi
8010201c:	53                   	push   %ebx
8010201d:	e8 6e fa ff ff       	call   80101a90 <readi>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	83 f8 10             	cmp    $0x10,%eax
80102028:	75 4e                	jne    80102078 <dirlink+0x98>
    if(de.inum == 0)
8010202a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010202f:	75 df                	jne    80102010 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102031:	83 ec 04             	sub    $0x4,%esp
80102034:	8d 45 da             	lea    -0x26(%ebp),%eax
80102037:	6a 0e                	push   $0xe
80102039:	ff 75 0c             	push   0xc(%ebp)
8010203c:	50                   	push   %eax
8010203d:	e8 fe 32 00 00       	call   80105340 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102042:	6a 10                	push   $0x10
  de.inum = inum;
80102044:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102047:	57                   	push   %edi
80102048:	56                   	push   %esi
80102049:	53                   	push   %ebx
  de.inum = inum;
8010204a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010204e:	e8 3d fb ff ff       	call   80101b90 <writei>
80102053:	83 c4 20             	add    $0x20,%esp
80102056:	83 f8 10             	cmp    $0x10,%eax
80102059:	75 2a                	jne    80102085 <dirlink+0xa5>
  return 0;
8010205b:	31 c0                	xor    %eax,%eax
}
8010205d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102060:	5b                   	pop    %ebx
80102061:	5e                   	pop    %esi
80102062:	5f                   	pop    %edi
80102063:	5d                   	pop    %ebp
80102064:	c3                   	ret    
    iput(ip);
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	50                   	push   %eax
80102069:	e8 42 f8 ff ff       	call   801018b0 <iput>
    return -1;
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102076:	eb e5                	jmp    8010205d <dirlink+0x7d>
      panic("dirlink read");
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	68 08 81 10 80       	push   $0x80108108
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 3a 87 10 80       	push   $0x8010873a
8010208d:	e8 ee e2 ff ff       	call   80100380 <panic>
80102092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <namei>:

struct inode*
namei(char *path)
{
801020a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020a1:	31 d2                	xor    %edx,%edx
{
801020a3:	89 e5                	mov    %esp,%ebp
801020a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ae:	e8 dd fc ff ff       	call   80101d90 <namex>
}
801020b3:	c9                   	leave  
801020b4:	c3                   	ret    
801020b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020c0:	55                   	push   %ebp
  return namex(path, 1, name);
801020c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020cf:	e9 bc fc ff ff       	jmp    80101d90 <namex>
801020d4:	66 90                	xchg   %ax,%ax
801020d6:	66 90                	xchg   %ax,%ax
801020d8:	66 90                	xchg   %ax,%ax
801020da:	66 90                	xchg   %ax,%ax
801020dc:	66 90                	xchg   %ax,%ax
801020de:	66 90                	xchg   %ax,%ax

801020e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020e9:	85 c0                	test   %eax,%eax
801020eb:	0f 84 b4 00 00 00    	je     801021a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020f1:	8b 70 08             	mov    0x8(%eax),%esi
801020f4:	89 c3                	mov    %eax,%ebx
801020f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020fc:	0f 87 96 00 00 00    	ja     80102198 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102102:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210e:	66 90                	xchg   %ax,%ax
80102110:	89 ca                	mov    %ecx,%edx
80102112:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102113:	83 e0 c0             	and    $0xffffffc0,%eax
80102116:	3c 40                	cmp    $0x40,%al
80102118:	75 f6                	jne    80102110 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010211a:	31 ff                	xor    %edi,%edi
8010211c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102121:	89 f8                	mov    %edi,%eax
80102123:	ee                   	out    %al,(%dx)
80102124:	b8 01 00 00 00       	mov    $0x1,%eax
80102129:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010212e:	ee                   	out    %al,(%dx)
8010212f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102134:	89 f0                	mov    %esi,%eax
80102136:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102137:	89 f0                	mov    %esi,%eax
80102139:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010213e:	c1 f8 08             	sar    $0x8,%eax
80102141:	ee                   	out    %al,(%dx)
80102142:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102147:	89 f8                	mov    %edi,%eax
80102149:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010214a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010214e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102153:	c1 e0 04             	shl    $0x4,%eax
80102156:	83 e0 10             	and    $0x10,%eax
80102159:	83 c8 e0             	or     $0xffffffe0,%eax
8010215c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010215d:	f6 03 04             	testb  $0x4,(%ebx)
80102160:	75 16                	jne    80102178 <idestart+0x98>
80102162:	b8 20 00 00 00       	mov    $0x20,%eax
80102167:	89 ca                	mov    %ecx,%edx
80102169:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010216a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010216d:	5b                   	pop    %ebx
8010216e:	5e                   	pop    %esi
8010216f:	5f                   	pop    %edi
80102170:	5d                   	pop    %ebp
80102171:	c3                   	ret    
80102172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102178:	b8 30 00 00 00       	mov    $0x30,%eax
8010217d:	89 ca                	mov    %ecx,%edx
8010217f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102180:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102185:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102188:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218d:	fc                   	cld    
8010218e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102193:	5b                   	pop    %ebx
80102194:	5e                   	pop    %esi
80102195:	5f                   	pop    %edi
80102196:	5d                   	pop    %ebp
80102197:	c3                   	ret    
    panic("incorrect blockno");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 74 81 10 80       	push   $0x80108174
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 6b 81 10 80       	push   $0x8010816b
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 86 81 10 80       	push   $0x80108186
801021cb:	68 00 26 11 80       	push   $0x80112600
801021d0:	e8 7b 2d 00 00       	call   80104f50 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 84 27 11 80       	mov    0x80112784,%eax
801021db:	5a                   	pop    %edx
801021dc:	83 e8 01             	sub    $0x1,%eax
801021df:	50                   	push   %eax
801021e0:	6a 0e                	push   $0xe
801021e2:	e8 99 02 00 00       	call   80102480 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ef:	90                   	nop
801021f0:	ec                   	in     (%dx),%al
801021f1:	83 e0 c0             	and    $0xffffffc0,%eax
801021f4:	3c 40                	cmp    $0x40,%al
801021f6:	75 f8                	jne    801021f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102202:	ee                   	out    %al,(%dx)
80102203:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102208:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220d:	eb 06                	jmp    80102215 <ideinit+0x55>
8010220f:	90                   	nop
  for(i=0; i<1000; i++){
80102210:	83 e9 01             	sub    $0x1,%ecx
80102213:	74 0f                	je     80102224 <ideinit+0x64>
80102215:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102216:	84 c0                	test   %al,%al
80102218:	74 f6                	je     80102210 <ideinit+0x50>
      havedisk1 = 1;
8010221a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102221:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102224:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102229:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010222e:	ee                   	out    %al,(%dx)
}
8010222f:	c9                   	leave  
80102230:	c3                   	ret    
80102231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102249:	68 00 26 11 80       	push   $0x80112600
8010224e:	e8 cd 2e 00 00       	call   80105120 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102268:	8b 33                	mov    (%ebx),%esi
8010226a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102270:	75 2f                	jne    801022a1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102272:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227e:	66 90                	xchg   %ax,%ax
80102280:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102281:	89 c1                	mov    %eax,%ecx
80102283:	83 e1 c0             	and    $0xffffffc0,%ecx
80102286:	80 f9 40             	cmp    $0x40,%cl
80102289:	75 f5                	jne    80102280 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010228b:	a8 21                	test   $0x21,%al
8010228d:	75 12                	jne    801022a1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010228f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102292:	b9 80 00 00 00       	mov    $0x80,%ecx
80102297:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229c:	fc                   	cld    
8010229d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010229f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022a1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022a4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022a7:	83 ce 02             	or     $0x2,%esi
801022aa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022ac:	53                   	push   %ebx
801022ad:	e8 fe 29 00 00       	call   80104cb0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 00 26 11 80       	push   $0x80112600
801022cb:	e8 f0 2d 00 00       	call   801050c0 <release>

  release(&idelock);
}
801022d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d3:	5b                   	pop    %ebx
801022d4:	5e                   	pop    %esi
801022d5:	5f                   	pop    %edi
801022d6:	5d                   	pop    %ebp
801022d7:	c3                   	ret    
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop

801022e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 10             	sub    $0x10,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801022ed:	50                   	push   %eax
801022ee:	e8 0d 2c 00 00       	call   80104f00 <holdingsleep>
801022f3:	83 c4 10             	add    $0x10,%esp
801022f6:	85 c0                	test   %eax,%eax
801022f8:	0f 84 c3 00 00 00    	je     801023c1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	0f 84 a8 00 00 00    	je     801023b4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010230c:	8b 53 04             	mov    0x4(%ebx),%edx
8010230f:	85 d2                	test   %edx,%edx
80102311:	74 0d                	je     80102320 <iderw+0x40>
80102313:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 00 26 11 80       	push   $0x80112600
80102328:	e8 f3 2d 00 00       	call   80105120 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102332:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 c0                	test   %eax,%eax
8010233e:	74 60                	je     801023a0 <iderw+0xc0>
80102340:	89 c2                	mov    %eax,%edx
80102342:	8b 40 58             	mov    0x58(%eax),%eax
80102345:	85 c0                	test   %eax,%eax
80102347:	75 f7                	jne    80102340 <iderw+0x60>
80102349:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010234c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010234e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102354:	74 3a                	je     80102390 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102356:	8b 03                	mov    (%ebx),%eax
80102358:	83 e0 06             	and    $0x6,%eax
8010235b:	83 f8 02             	cmp    $0x2,%eax
8010235e:	74 1b                	je     8010237b <iderw+0x9b>
    sleep(b, &idelock);
80102360:	83 ec 08             	sub    $0x8,%esp
80102363:	68 00 26 11 80       	push   $0x80112600
80102368:	53                   	push   %ebx
80102369:	e8 22 28 00 00       	call   80104b90 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x80>
  }


  release(&idelock);
8010237b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 35 2d 00 00       	jmp    801050c0 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba e4 25 11 80       	mov    $0x801125e4,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 b5 81 10 80       	push   $0x801081b5
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 a0 81 10 80       	push   $0x801081a0
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 8a 81 10 80       	push   $0x8010818a
801023c9:	e8 b2 df ff ff       	call   80100380 <panic>
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023d1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023f8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fe:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102405:	c1 ee 10             	shr    $0x10,%esi
80102408:	89 f0                	mov    %esi,%eax
8010240a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010240d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102410:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102413:	39 c2                	cmp    %eax,%edx
80102415:	74 16                	je     8010242d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 d4 81 10 80       	push   $0x801081d4
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102424:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010242a:	83 c4 10             	add    $0x10,%esp
8010242d:	83 c6 21             	add    $0x21,%esi
{
80102430:	ba 10 00 00 00       	mov    $0x10,%edx
80102435:	b8 20 00 00 00       	mov    $0x20,%eax
8010243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102440:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102442:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102444:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010244a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010244d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102453:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102456:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102459:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010245c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010245e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102464:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010246b:	39 f0                	cmp    %esi,%eax
8010246d:	75 d1                	jne    80102440 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010246f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102472:	5b                   	pop    %ebx
80102473:	5e                   	pop    %esi
80102474:	5d                   	pop    %ebp
80102475:	c3                   	ret    
80102476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247d:	8d 76 00             	lea    0x0(%esi),%esi

80102480 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102480:	55                   	push   %ebp
  ioapic->reg = reg;
80102481:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102487:	89 e5                	mov    %esp,%ebp
80102489:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010248c:	8d 50 20             	lea    0x20(%eax),%edx
8010248f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102493:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102495:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801024b1:	5d                   	pop    %ebp
801024b2:	c3                   	ret    
801024b3:	66 90                	xchg   %ax,%ax
801024b5:	66 90                	xchg   %ax,%ax
801024b7:	66 90                	xchg   %ax,%ax
801024b9:	66 90                	xchg   %ax,%ax
801024bb:	66 90                	xchg   %ax,%ax
801024bd:	66 90                	xchg   %ax,%ax
801024bf:	90                   	nop

801024c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	53                   	push   %ebx
801024c4:	83 ec 04             	sub    $0x4,%esp
801024c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024d0:	75 76                	jne    80102548 <kfree+0x88>
801024d2:	81 fb 30 6e 11 80    	cmp    $0x80116e30,%ebx
801024d8:	72 6e                	jb     80102548 <kfree+0x88>
801024da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024e5:	77 61                	ja     80102548 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024e7:	83 ec 04             	sub    $0x4,%esp
801024ea:	68 00 10 00 00       	push   $0x1000
801024ef:	6a 01                	push   $0x1
801024f1:	53                   	push   %ebx
801024f2:	e8 e9 2c 00 00       	call   801051e0 <memset>

  if(kmem.use_lock)
801024f7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	85 d2                	test   %edx,%edx
80102502:	75 1c                	jne    80102520 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102504:	a1 78 26 11 80       	mov    0x80112678,%eax
80102509:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010250b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102510:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102516:	85 c0                	test   %eax,%eax
80102518:	75 1e                	jne    80102538 <kfree+0x78>
    release(&kmem.lock);
}
8010251a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010251d:	c9                   	leave  
8010251e:	c3                   	ret    
8010251f:	90                   	nop
    acquire(&kmem.lock);
80102520:	83 ec 0c             	sub    $0xc,%esp
80102523:	68 40 26 11 80       	push   $0x80112640
80102528:	e8 f3 2b 00 00       	call   80105120 <acquire>
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	eb d2                	jmp    80102504 <kfree+0x44>
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102538:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010253f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102542:	c9                   	leave  
    release(&kmem.lock);
80102543:	e9 78 2b 00 00       	jmp    801050c0 <release>
    panic("kfree");
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 06 82 10 80       	push   $0x80108206
80102550:	e8 2b de ff ff       	call   80100380 <panic>
80102555:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102560 <freerange>:
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102564:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102567:	8b 75 0c             	mov    0xc(%ebp),%esi
8010256a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010256b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102571:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102577:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010257d:	39 de                	cmp    %ebx,%esi
8010257f:	72 23                	jb     801025a4 <freerange+0x44>
80102581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102588:	83 ec 0c             	sub    $0xc,%esp
8010258b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102597:	50                   	push   %eax
80102598:	e8 23 ff ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259d:	83 c4 10             	add    $0x10,%esp
801025a0:	39 f3                	cmp    %esi,%ebx
801025a2:	76 e4                	jbe    80102588 <freerange+0x28>
}
801025a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a7:	5b                   	pop    %ebx
801025a8:	5e                   	pop    %esi
801025a9:	5d                   	pop    %ebp
801025aa:	c3                   	ret    
801025ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025af:	90                   	nop

801025b0 <kinit2>:
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025b4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025b7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ba:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025cd:	39 de                	cmp    %ebx,%esi
801025cf:	72 23                	jb     801025f4 <kinit2+0x44>
801025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025d8:	83 ec 0c             	sub    $0xc,%esp
801025db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025e7:	50                   	push   %eax
801025e8:	e8 d3 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ed:	83 c4 10             	add    $0x10,%esp
801025f0:	39 de                	cmp    %ebx,%esi
801025f2:	73 e4                	jae    801025d8 <kinit2+0x28>
  kmem.use_lock = 1;
801025f4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801025fb:	00 00 00 
}
801025fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102601:	5b                   	pop    %ebx
80102602:	5e                   	pop    %esi
80102603:	5d                   	pop    %ebp
80102604:	c3                   	ret    
80102605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102610 <kinit1>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
80102615:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102618:	83 ec 08             	sub    $0x8,%esp
8010261b:	68 0c 82 10 80       	push   $0x8010820c
80102620:	68 40 26 11 80       	push   $0x80112640
80102625:	e8 26 29 00 00       	call   80104f50 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010262a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010262d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102630:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102637:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102640:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102646:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264c:	39 de                	cmp    %ebx,%esi
8010264e:	72 1c                	jb     8010266c <kinit1+0x5c>
    kfree(p);
80102650:	83 ec 0c             	sub    $0xc,%esp
80102653:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102659:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010265f:	50                   	push   %eax
80102660:	e8 5b fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102665:	83 c4 10             	add    $0x10,%esp
80102668:	39 de                	cmp    %ebx,%esi
8010266a:	73 e4                	jae    80102650 <kinit1+0x40>
}
8010266c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010266f:	5b                   	pop    %ebx
80102670:	5e                   	pop    %esi
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102680 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102680:	a1 74 26 11 80       	mov    0x80112674,%eax
80102685:	85 c0                	test   %eax,%eax
80102687:	75 1f                	jne    801026a8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102689:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010268e:	85 c0                	test   %eax,%eax
80102690:	74 0e                	je     801026a0 <kalloc+0x20>
    kmem.freelist = r->next;
80102692:	8b 10                	mov    (%eax),%edx
80102694:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
8010269a:	c3                   	ret    
8010269b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010269f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026a0:	c3                   	ret    
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026a8:	55                   	push   %ebp
801026a9:	89 e5                	mov    %esp,%ebp
801026ab:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026ae:	68 40 26 11 80       	push   $0x80112640
801026b3:	e8 68 2a 00 00       	call   80105120 <acquire>
  r = kmem.freelist;
801026b8:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(kmem.use_lock)
801026bd:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(r)
801026c3:	83 c4 10             	add    $0x10,%esp
801026c6:	85 c0                	test   %eax,%eax
801026c8:	74 08                	je     801026d2 <kalloc+0x52>
    kmem.freelist = r->next;
801026ca:	8b 08                	mov    (%eax),%ecx
801026cc:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
801026d2:	85 d2                	test   %edx,%edx
801026d4:	74 16                	je     801026ec <kalloc+0x6c>
    release(&kmem.lock);
801026d6:	83 ec 0c             	sub    $0xc,%esp
801026d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026dc:	68 40 26 11 80       	push   $0x80112640
801026e1:	e8 da 29 00 00       	call   801050c0 <release>
  return (char*)r;
801026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026e9:	83 c4 10             	add    $0x10,%esp
}
801026ec:	c9                   	leave  
801026ed:	c3                   	ret    
801026ee:	66 90                	xchg   %ax,%ax

801026f0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026f0:	ba 64 00 00 00       	mov    $0x64,%edx
801026f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026f6:	a8 01                	test   $0x1,%al
801026f8:	0f 84 c2 00 00 00    	je     801027c0 <kbdgetc+0xd0>
{
801026fe:	55                   	push   %ebp
801026ff:	ba 60 00 00 00       	mov    $0x60,%edx
80102704:	89 e5                	mov    %esp,%ebp
80102706:	53                   	push   %ebx
80102707:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102708:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
8010270e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102711:	3c e0                	cmp    $0xe0,%al
80102713:	74 5b                	je     80102770 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102715:	89 da                	mov    %ebx,%edx
80102717:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010271a:	84 c0                	test   %al,%al
8010271c:	78 62                	js     80102780 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010271e:	85 d2                	test   %edx,%edx
80102720:	74 09                	je     8010272b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102722:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102725:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102728:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010272b:	0f b6 91 40 83 10 80 	movzbl -0x7fef7cc0(%ecx),%edx
  shift ^= togglecode[data];
80102732:	0f b6 81 40 82 10 80 	movzbl -0x7fef7dc0(%ecx),%eax
  shift |= shiftcode[data];
80102739:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010273b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010273d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010273f:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
80102745:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102748:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010274b:	8b 04 85 20 82 10 80 	mov    -0x7fef7de0(,%eax,4),%eax
80102752:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102756:	74 0b                	je     80102763 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102758:	8d 50 9f             	lea    -0x61(%eax),%edx
8010275b:	83 fa 19             	cmp    $0x19,%edx
8010275e:	77 48                	ja     801027a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102760:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102763:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102766:	c9                   	leave  
80102767:	c3                   	ret    
80102768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276f:	90                   	nop
    shift |= E0ESC;
80102770:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102773:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102775:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
8010277b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010277e:	c9                   	leave  
8010277f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102780:	83 e0 7f             	and    $0x7f,%eax
80102783:	85 d2                	test   %edx,%edx
80102785:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102788:	0f b6 81 40 83 10 80 	movzbl -0x7fef7cc0(%ecx),%eax
8010278f:	83 c8 40             	or     $0x40,%eax
80102792:	0f b6 c0             	movzbl %al,%eax
80102795:	f7 d0                	not    %eax
80102797:	21 d8                	and    %ebx,%eax
}
80102799:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010279c:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
801027a1:	31 c0                	xor    %eax,%eax
}
801027a3:	c9                   	leave  
801027a4:	c3                   	ret    
801027a5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027ab:	8d 50 20             	lea    0x20(%eax),%edx
}
801027ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027b1:	c9                   	leave  
      c += 'a' - 'A';
801027b2:	83 f9 1a             	cmp    $0x1a,%ecx
801027b5:	0f 42 c2             	cmovb  %edx,%eax
}
801027b8:	c3                   	ret    
801027b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027c5:	c3                   	ret    
801027c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027cd:	8d 76 00             	lea    0x0(%esi),%esi

801027d0 <kbdintr>:

void
kbdintr(void)
{
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
801027d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027d6:	68 f0 26 10 80       	push   $0x801026f0
801027db:	e8 a0 e0 ff ff       	call   80100880 <consoleintr>
}
801027e0:	83 c4 10             	add    $0x10,%esp
801027e3:	c9                   	leave  
801027e4:	c3                   	ret    
801027e5:	66 90                	xchg   %ax,%ax
801027e7:	66 90                	xchg   %ax,%ax
801027e9:	66 90                	xchg   %ax,%ax
801027eb:	66 90                	xchg   %ax,%ax
801027ed:	66 90                	xchg   %ax,%ax
801027ef:	90                   	nop

801027f0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801027f0:	a1 80 26 11 80       	mov    0x80112680,%eax
801027f5:	85 c0                	test   %eax,%eax
801027f7:	0f 84 cb 00 00 00    	je     801028c8 <lapicinit+0xd8>
  lapic[index] = value;
801027fd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102804:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102807:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010280a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102811:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102814:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102817:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010281e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102821:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102824:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010282b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010282e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102831:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102838:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010283b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010283e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102845:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102848:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010284b:	8b 50 30             	mov    0x30(%eax),%edx
8010284e:	c1 ea 10             	shr    $0x10,%edx
80102851:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102857:	75 77                	jne    801028d0 <lapicinit+0xe0>
  lapic[index] = value;
80102859:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102860:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102863:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102866:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010286d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102870:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102873:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010287a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010287d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102880:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102887:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010288d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102894:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102897:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028a1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028a4:	8b 50 20             	mov    0x20(%eax),%edx
801028a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ae:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028b0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028b6:	80 e6 10             	and    $0x10,%dh
801028b9:	75 f5                	jne    801028b0 <lapicinit+0xc0>
  lapic[index] = value;
801028bb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028c2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028c8:	c3                   	ret    
801028c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028d0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028d7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028da:	8b 50 20             	mov    0x20(%eax),%edx
}
801028dd:	e9 77 ff ff ff       	jmp    80102859 <lapicinit+0x69>
801028e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028f0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801028f0:	a1 80 26 11 80       	mov    0x80112680,%eax
801028f5:	85 c0                	test   %eax,%eax
801028f7:	74 07                	je     80102900 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801028f9:	8b 40 20             	mov    0x20(%eax),%eax
801028fc:	c1 e8 18             	shr    $0x18,%eax
801028ff:	c3                   	ret    
    return 0;
80102900:	31 c0                	xor    %eax,%eax
}
80102902:	c3                   	ret    
80102903:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010290a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102910 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102910:	a1 80 26 11 80       	mov    0x80112680,%eax
80102915:	85 c0                	test   %eax,%eax
80102917:	74 0d                	je     80102926 <lapiceoi+0x16>
  lapic[index] = value;
80102919:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102920:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102923:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102926:	c3                   	ret    
80102927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010292e:	66 90                	xchg   %ax,%ax

80102930 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102930:	c3                   	ret    
80102931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293f:	90                   	nop

80102940 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102940:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102941:	b8 0f 00 00 00       	mov    $0xf,%eax
80102946:	ba 70 00 00 00       	mov    $0x70,%edx
8010294b:	89 e5                	mov    %esp,%ebp
8010294d:	53                   	push   %ebx
8010294e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102951:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102954:	ee                   	out    %al,(%dx)
80102955:	b8 0a 00 00 00       	mov    $0xa,%eax
8010295a:	ba 71 00 00 00       	mov    $0x71,%edx
8010295f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102960:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102962:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102965:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010296b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010296d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102970:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102972:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102975:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102978:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010297e:	a1 80 26 11 80       	mov    0x80112680,%eax
80102983:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102989:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010298c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102993:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102996:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102999:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029a0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029a6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ac:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029af:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029b5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029c1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029cd:	c9                   	leave  
801029ce:	c3                   	ret    
801029cf:	90                   	nop

801029d0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029d0:	55                   	push   %ebp
801029d1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029d6:	ba 70 00 00 00       	mov    $0x70,%edx
801029db:	89 e5                	mov    %esp,%ebp
801029dd:	57                   	push   %edi
801029de:	56                   	push   %esi
801029df:	53                   	push   %ebx
801029e0:	83 ec 4c             	sub    $0x4c,%esp
801029e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e4:	ba 71 00 00 00       	mov    $0x71,%edx
801029e9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ea:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ed:	bb 70 00 00 00       	mov    $0x70,%ebx
801029f2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029f5:	8d 76 00             	lea    0x0(%esi),%esi
801029f8:	31 c0                	xor    %eax,%eax
801029fa:	89 da                	mov    %ebx,%edx
801029fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a02:	89 ca                	mov    %ecx,%edx
80102a04:	ec                   	in     (%dx),%al
80102a05:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a08:	89 da                	mov    %ebx,%edx
80102a0a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a10:	89 ca                	mov    %ecx,%edx
80102a12:	ec                   	in     (%dx),%al
80102a13:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a16:	89 da                	mov    %ebx,%edx
80102a18:	b8 04 00 00 00       	mov    $0x4,%eax
80102a1d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1e:	89 ca                	mov    %ecx,%edx
80102a20:	ec                   	in     (%dx),%al
80102a21:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a24:	89 da                	mov    %ebx,%edx
80102a26:	b8 07 00 00 00       	mov    $0x7,%eax
80102a2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2c:	89 ca                	mov    %ecx,%edx
80102a2e:	ec                   	in     (%dx),%al
80102a2f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a32:	89 da                	mov    %ebx,%edx
80102a34:	b8 08 00 00 00       	mov    $0x8,%eax
80102a39:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3a:	89 ca                	mov    %ecx,%edx
80102a3c:	ec                   	in     (%dx),%al
80102a3d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a3f:	89 da                	mov    %ebx,%edx
80102a41:	b8 09 00 00 00       	mov    $0x9,%eax
80102a46:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a47:	89 ca                	mov    %ecx,%edx
80102a49:	ec                   	in     (%dx),%al
80102a4a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4c:	89 da                	mov    %ebx,%edx
80102a4e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	89 ca                	mov    %ecx,%edx
80102a56:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a57:	84 c0                	test   %al,%al
80102a59:	78 9d                	js     801029f8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a5b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a5f:	89 fa                	mov    %edi,%edx
80102a61:	0f b6 fa             	movzbl %dl,%edi
80102a64:	89 f2                	mov    %esi,%edx
80102a66:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a69:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a6d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a70:	89 da                	mov    %ebx,%edx
80102a72:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a75:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a78:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a7c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a7f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a82:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a86:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a89:	31 c0                	xor    %eax,%eax
80102a8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8c:	89 ca                	mov    %ecx,%edx
80102a8e:	ec                   	in     (%dx),%al
80102a8f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a92:	89 da                	mov    %ebx,%edx
80102a94:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a97:	b8 02 00 00 00       	mov    $0x2,%eax
80102a9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9d:	89 ca                	mov    %ecx,%edx
80102a9f:	ec                   	in     (%dx),%al
80102aa0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa3:	89 da                	mov    %ebx,%edx
80102aa5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102aa8:	b8 04 00 00 00       	mov    $0x4,%eax
80102aad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aae:	89 ca                	mov    %ecx,%edx
80102ab0:	ec                   	in     (%dx),%al
80102ab1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab4:	89 da                	mov    %ebx,%edx
80102ab6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ab9:	b8 07 00 00 00       	mov    $0x7,%eax
80102abe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abf:	89 ca                	mov    %ecx,%edx
80102ac1:	ec                   	in     (%dx),%al
80102ac2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac5:	89 da                	mov    %ebx,%edx
80102ac7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aca:	b8 08 00 00 00       	mov    $0x8,%eax
80102acf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad0:	89 ca                	mov    %ecx,%edx
80102ad2:	ec                   	in     (%dx),%al
80102ad3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad6:	89 da                	mov    %ebx,%edx
80102ad8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102adb:	b8 09 00 00 00       	mov    $0x9,%eax
80102ae0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae1:	89 ca                	mov    %ecx,%edx
80102ae3:	ec                   	in     (%dx),%al
80102ae4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ae7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102aea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aed:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102af0:	6a 18                	push   $0x18
80102af2:	50                   	push   %eax
80102af3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102af6:	50                   	push   %eax
80102af7:	e8 34 27 00 00       	call   80105230 <memcmp>
80102afc:	83 c4 10             	add    $0x10,%esp
80102aff:	85 c0                	test   %eax,%eax
80102b01:	0f 85 f1 fe ff ff    	jne    801029f8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b07:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b0b:	75 78                	jne    80102b85 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b0d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b10:	89 c2                	mov    %eax,%edx
80102b12:	83 e0 0f             	and    $0xf,%eax
80102b15:	c1 ea 04             	shr    $0x4,%edx
80102b18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b21:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b24:	89 c2                	mov    %eax,%edx
80102b26:	83 e0 0f             	and    $0xf,%eax
80102b29:	c1 ea 04             	shr    $0x4,%edx
80102b2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b32:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b35:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b38:	89 c2                	mov    %eax,%edx
80102b3a:	83 e0 0f             	and    $0xf,%eax
80102b3d:	c1 ea 04             	shr    $0x4,%edx
80102b40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b46:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b4c:	89 c2                	mov    %eax,%edx
80102b4e:	83 e0 0f             	and    $0xf,%eax
80102b51:	c1 ea 04             	shr    $0x4,%edx
80102b54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b5d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b60:	89 c2                	mov    %eax,%edx
80102b62:	83 e0 0f             	and    $0xf,%eax
80102b65:	c1 ea 04             	shr    $0x4,%edx
80102b68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b71:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b74:	89 c2                	mov    %eax,%edx
80102b76:	83 e0 0f             	and    $0xf,%eax
80102b79:	c1 ea 04             	shr    $0x4,%edx
80102b7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b82:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b85:	8b 75 08             	mov    0x8(%ebp),%esi
80102b88:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b8b:	89 06                	mov    %eax,(%esi)
80102b8d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b90:	89 46 04             	mov    %eax,0x4(%esi)
80102b93:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b96:	89 46 08             	mov    %eax,0x8(%esi)
80102b99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b9c:	89 46 0c             	mov    %eax,0xc(%esi)
80102b9f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ba2:	89 46 10             	mov    %eax,0x10(%esi)
80102ba5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ba8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bab:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bb5:	5b                   	pop    %ebx
80102bb6:	5e                   	pop    %esi
80102bb7:	5f                   	pop    %edi
80102bb8:	5d                   	pop    %ebp
80102bb9:	c3                   	ret    
80102bba:	66 90                	xchg   %ax,%ax
80102bbc:	66 90                	xchg   %ax,%ax
80102bbe:	66 90                	xchg   %ax,%ax

80102bc0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bc0:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102bc6:	85 c9                	test   %ecx,%ecx
80102bc8:	0f 8e 8a 00 00 00    	jle    80102c58 <install_trans+0x98>
{
80102bce:	55                   	push   %ebp
80102bcf:	89 e5                	mov    %esp,%ebp
80102bd1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bd2:	31 ff                	xor    %edi,%edi
{
80102bd4:	56                   	push   %esi
80102bd5:	53                   	push   %ebx
80102bd6:	83 ec 0c             	sub    $0xc,%esp
80102bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102be0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102be5:	83 ec 08             	sub    $0x8,%esp
80102be8:	01 f8                	add    %edi,%eax
80102bea:	83 c0 01             	add    $0x1,%eax
80102bed:	50                   	push   %eax
80102bee:	ff 35 e4 26 11 80    	push   0x801126e4
80102bf4:	e8 d7 d4 ff ff       	call   801000d0 <bread>
80102bf9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bfb:	58                   	pop    %eax
80102bfc:	5a                   	pop    %edx
80102bfd:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102c04:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c0a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c0d:	e8 be d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c12:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c15:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c17:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c1a:	68 00 02 00 00       	push   $0x200
80102c1f:	50                   	push   %eax
80102c20:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c23:	50                   	push   %eax
80102c24:	e8 57 26 00 00       	call   80105280 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c29:	89 1c 24             	mov    %ebx,(%esp)
80102c2c:	e8 7f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c31:	89 34 24             	mov    %esi,(%esp)
80102c34:	e8 b7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c39:	89 1c 24             	mov    %ebx,(%esp)
80102c3c:	e8 af d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c41:	83 c4 10             	add    $0x10,%esp
80102c44:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102c4a:	7f 94                	jg     80102be0 <install_trans+0x20>
  }
}
80102c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c4f:	5b                   	pop    %ebx
80102c50:	5e                   	pop    %esi
80102c51:	5f                   	pop    %edi
80102c52:	5d                   	pop    %ebp
80102c53:	c3                   	ret    
80102c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c58:	c3                   	ret    
80102c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c60 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c60:	55                   	push   %ebp
80102c61:	89 e5                	mov    %esp,%ebp
80102c63:	53                   	push   %ebx
80102c64:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c67:	ff 35 d4 26 11 80    	push   0x801126d4
80102c6d:	ff 35 e4 26 11 80    	push   0x801126e4
80102c73:	e8 58 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c78:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c7b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c7d:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102c82:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c85:	85 c0                	test   %eax,%eax
80102c87:	7e 19                	jle    80102ca2 <write_head+0x42>
80102c89:	31 d2                	xor    %edx,%edx
80102c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c90:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102c97:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c9b:	83 c2 01             	add    $0x1,%edx
80102c9e:	39 d0                	cmp    %edx,%eax
80102ca0:	75 ee                	jne    80102c90 <write_head+0x30>
  }
  bwrite(buf);
80102ca2:	83 ec 0c             	sub    $0xc,%esp
80102ca5:	53                   	push   %ebx
80102ca6:	e8 05 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cab:	89 1c 24             	mov    %ebx,(%esp)
80102cae:	e8 3d d5 ff ff       	call   801001f0 <brelse>
}
80102cb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cb6:	83 c4 10             	add    $0x10,%esp
80102cb9:	c9                   	leave  
80102cba:	c3                   	ret    
80102cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cbf:	90                   	nop

80102cc0 <initlog>:
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	53                   	push   %ebx
80102cc4:	83 ec 2c             	sub    $0x2c,%esp
80102cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cca:	68 40 84 10 80       	push   $0x80108440
80102ccf:	68 a0 26 11 80       	push   $0x801126a0
80102cd4:	e8 77 22 00 00       	call   80104f50 <initlock>
  readsb(dev, &sb);
80102cd9:	58                   	pop    %eax
80102cda:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cdd:	5a                   	pop    %edx
80102cde:	50                   	push   %eax
80102cdf:	53                   	push   %ebx
80102ce0:	e8 3b e8 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80102ce5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ce8:	59                   	pop    %ecx
  log.dev = dev;
80102ce9:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102cef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cf2:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102cf7:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102cfd:	5a                   	pop    %edx
80102cfe:	50                   	push   %eax
80102cff:	53                   	push   %ebx
80102d00:	e8 cb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d05:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d08:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d0b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102d11:	85 db                	test   %ebx,%ebx
80102d13:	7e 1d                	jle    80102d32 <initlog+0x72>
80102d15:	31 d2                	xor    %edx,%edx
80102d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d1e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d20:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d24:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d2b:	83 c2 01             	add    $0x1,%edx
80102d2e:	39 d3                	cmp    %edx,%ebx
80102d30:	75 ee                	jne    80102d20 <initlog+0x60>
  brelse(buf);
80102d32:	83 ec 0c             	sub    $0xc,%esp
80102d35:	50                   	push   %eax
80102d36:	e8 b5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d3b:	e8 80 fe ff ff       	call   80102bc0 <install_trans>
  log.lh.n = 0;
80102d40:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102d47:	00 00 00 
  write_head(); // clear the log
80102d4a:	e8 11 ff ff ff       	call   80102c60 <write_head>
}
80102d4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d52:	83 c4 10             	add    $0x10,%esp
80102d55:	c9                   	leave  
80102d56:	c3                   	ret    
80102d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d5e:	66 90                	xchg   %ax,%ax

80102d60 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d60:	55                   	push   %ebp
80102d61:	89 e5                	mov    %esp,%ebp
80102d63:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d66:	68 a0 26 11 80       	push   $0x801126a0
80102d6b:	e8 b0 23 00 00       	call   80105120 <acquire>
80102d70:	83 c4 10             	add    $0x10,%esp
80102d73:	eb 18                	jmp    80102d8d <begin_op+0x2d>
80102d75:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d78:	83 ec 08             	sub    $0x8,%esp
80102d7b:	68 a0 26 11 80       	push   $0x801126a0
80102d80:	68 a0 26 11 80       	push   $0x801126a0
80102d85:	e8 06 1e 00 00       	call   80104b90 <sleep>
80102d8a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d8d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102d92:	85 c0                	test   %eax,%eax
80102d94:	75 e2                	jne    80102d78 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d96:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102d9b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102da1:	83 c0 01             	add    $0x1,%eax
80102da4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102da7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102daa:	83 fa 1e             	cmp    $0x1e,%edx
80102dad:	7f c9                	jg     80102d78 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102daf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102db2:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102db7:	68 a0 26 11 80       	push   $0x801126a0
80102dbc:	e8 ff 22 00 00       	call   801050c0 <release>
      break;
    }
  }
}
80102dc1:	83 c4 10             	add    $0x10,%esp
80102dc4:	c9                   	leave  
80102dc5:	c3                   	ret    
80102dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dcd:	8d 76 00             	lea    0x0(%esi),%esi

80102dd0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	57                   	push   %edi
80102dd4:	56                   	push   %esi
80102dd5:	53                   	push   %ebx
80102dd6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dd9:	68 a0 26 11 80       	push   $0x801126a0
80102dde:	e8 3d 23 00 00       	call   80105120 <acquire>
  log.outstanding -= 1;
80102de3:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102de8:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102dee:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102df1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102df4:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102dfa:	85 f6                	test   %esi,%esi
80102dfc:	0f 85 22 01 00 00    	jne    80102f24 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e02:	85 db                	test   %ebx,%ebx
80102e04:	0f 85 f6 00 00 00    	jne    80102f00 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e0a:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102e11:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e14:	83 ec 0c             	sub    $0xc,%esp
80102e17:	68 a0 26 11 80       	push   $0x801126a0
80102e1c:	e8 9f 22 00 00       	call   801050c0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e21:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102e27:	83 c4 10             	add    $0x10,%esp
80102e2a:	85 c9                	test   %ecx,%ecx
80102e2c:	7f 42                	jg     80102e70 <end_op+0xa0>
    acquire(&log.lock);
80102e2e:	83 ec 0c             	sub    $0xc,%esp
80102e31:	68 a0 26 11 80       	push   $0x801126a0
80102e36:	e8 e5 22 00 00       	call   80105120 <acquire>
    wakeup(&log);
80102e3b:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102e42:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102e49:	00 00 00 
    wakeup(&log);
80102e4c:	e8 5f 1e 00 00       	call   80104cb0 <wakeup>
    release(&log.lock);
80102e51:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e58:	e8 63 22 00 00       	call   801050c0 <release>
80102e5d:	83 c4 10             	add    $0x10,%esp
}
80102e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e63:	5b                   	pop    %ebx
80102e64:	5e                   	pop    %esi
80102e65:	5f                   	pop    %edi
80102e66:	5d                   	pop    %ebp
80102e67:	c3                   	ret    
80102e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e6f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e70:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102e75:	83 ec 08             	sub    $0x8,%esp
80102e78:	01 d8                	add    %ebx,%eax
80102e7a:	83 c0 01             	add    $0x1,%eax
80102e7d:	50                   	push   %eax
80102e7e:	ff 35 e4 26 11 80    	push   0x801126e4
80102e84:	e8 47 d2 ff ff       	call   801000d0 <bread>
80102e89:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e8b:	58                   	pop    %eax
80102e8c:	5a                   	pop    %edx
80102e8d:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80102e94:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e9a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e9d:	e8 2e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ea2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ea5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ea7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eaa:	68 00 02 00 00       	push   $0x200
80102eaf:	50                   	push   %eax
80102eb0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102eb3:	50                   	push   %eax
80102eb4:	e8 c7 23 00 00       	call   80105280 <memmove>
    bwrite(to);  // write the log
80102eb9:	89 34 24             	mov    %esi,(%esp)
80102ebc:	e8 ef d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ec1:	89 3c 24             	mov    %edi,(%esp)
80102ec4:	e8 27 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ec9:	89 34 24             	mov    %esi,(%esp)
80102ecc:	e8 1f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ed1:	83 c4 10             	add    $0x10,%esp
80102ed4:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102eda:	7c 94                	jl     80102e70 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102edc:	e8 7f fd ff ff       	call   80102c60 <write_head>
    install_trans(); // Now install writes to home locations
80102ee1:	e8 da fc ff ff       	call   80102bc0 <install_trans>
    log.lh.n = 0;
80102ee6:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102eed:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ef0:	e8 6b fd ff ff       	call   80102c60 <write_head>
80102ef5:	e9 34 ff ff ff       	jmp    80102e2e <end_op+0x5e>
80102efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f00:	83 ec 0c             	sub    $0xc,%esp
80102f03:	68 a0 26 11 80       	push   $0x801126a0
80102f08:	e8 a3 1d 00 00       	call   80104cb0 <wakeup>
  release(&log.lock);
80102f0d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102f14:	e8 a7 21 00 00       	call   801050c0 <release>
80102f19:	83 c4 10             	add    $0x10,%esp
}
80102f1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f1f:	5b                   	pop    %ebx
80102f20:	5e                   	pop    %esi
80102f21:	5f                   	pop    %edi
80102f22:	5d                   	pop    %ebp
80102f23:	c3                   	ret    
    panic("log.committing");
80102f24:	83 ec 0c             	sub    $0xc,%esp
80102f27:	68 44 84 10 80       	push   $0x80108444
80102f2c:	e8 4f d4 ff ff       	call   80100380 <panic>
80102f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f3f:	90                   	nop

80102f40 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	53                   	push   %ebx
80102f44:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f47:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
80102f4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f50:	83 fa 1d             	cmp    $0x1d,%edx
80102f53:	0f 8f 85 00 00 00    	jg     80102fde <log_write+0x9e>
80102f59:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102f5e:	83 e8 01             	sub    $0x1,%eax
80102f61:	39 c2                	cmp    %eax,%edx
80102f63:	7d 79                	jge    80102fde <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f65:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102f6a:	85 c0                	test   %eax,%eax
80102f6c:	7e 7d                	jle    80102feb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f6e:	83 ec 0c             	sub    $0xc,%esp
80102f71:	68 a0 26 11 80       	push   $0x801126a0
80102f76:	e8 a5 21 00 00       	call   80105120 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f7b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102f81:	83 c4 10             	add    $0x10,%esp
80102f84:	85 d2                	test   %edx,%edx
80102f86:	7e 4a                	jle    80102fd2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f88:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f8b:	31 c0                	xor    %eax,%eax
80102f8d:	eb 08                	jmp    80102f97 <log_write+0x57>
80102f8f:	90                   	nop
80102f90:	83 c0 01             	add    $0x1,%eax
80102f93:	39 c2                	cmp    %eax,%edx
80102f95:	74 29                	je     80102fc0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f97:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102f9e:	75 f0                	jne    80102f90 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fa7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102faa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fad:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102fb4:	c9                   	leave  
  release(&log.lock);
80102fb5:	e9 06 21 00 00       	jmp    801050c0 <release>
80102fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fc0:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80102fc7:	83 c2 01             	add    $0x1,%edx
80102fca:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80102fd0:	eb d5                	jmp    80102fa7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102fd2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fd5:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102fda:	75 cb                	jne    80102fa7 <log_write+0x67>
80102fdc:	eb e9                	jmp    80102fc7 <log_write+0x87>
    panic("too big a transaction");
80102fde:	83 ec 0c             	sub    $0xc,%esp
80102fe1:	68 53 84 10 80       	push   $0x80108453
80102fe6:	e8 95 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102feb:	83 ec 0c             	sub    $0xc,%esp
80102fee:	68 69 84 10 80       	push   $0x80108469
80102ff3:	e8 88 d3 ff ff       	call   80100380 <panic>
80102ff8:	66 90                	xchg   %ax,%ax
80102ffa:	66 90                	xchg   %ax,%ax
80102ffc:	66 90                	xchg   %ax,%ax
80102ffe:	66 90                	xchg   %ax,%ax

80103000 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	53                   	push   %ebx
80103004:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103007:	e8 b4 0f 00 00       	call   80103fc0 <cpuid>
8010300c:	89 c3                	mov    %eax,%ebx
8010300e:	e8 ad 0f 00 00       	call   80103fc0 <cpuid>
80103013:	83 ec 04             	sub    $0x4,%esp
80103016:	53                   	push   %ebx
80103017:	50                   	push   %eax
80103018:	68 84 84 10 80       	push   $0x80108484
8010301d:	e8 7e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103022:	e8 a9 35 00 00       	call   801065d0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103027:	e8 e4 0e 00 00       	call   80103f10 <mycpu>
8010302c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010302e:	b8 01 00 00 00       	mov    $0x1,%eax
80103033:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010303a:	e8 01 13 00 00       	call   80104340 <scheduler>
8010303f:	90                   	nop

80103040 <mpenter>:
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103046:	e8 95 47 00 00       	call   801077e0 <switchkvm>
  seginit();
8010304b:	e8 00 47 00 00       	call   80107750 <seginit>
  lapicinit();
80103050:	e8 9b f7 ff ff       	call   801027f0 <lapicinit>
  mpmain();
80103055:	e8 a6 ff ff ff       	call   80103000 <mpmain>
8010305a:	66 90                	xchg   %ax,%ax
8010305c:	66 90                	xchg   %ax,%ax
8010305e:	66 90                	xchg   %ax,%ax

80103060 <main>:
{
80103060:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103064:	83 e4 f0             	and    $0xfffffff0,%esp
80103067:	ff 71 fc             	push   -0x4(%ecx)
8010306a:	55                   	push   %ebp
8010306b:	89 e5                	mov    %esp,%ebp
8010306d:	53                   	push   %ebx
8010306e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010306f:	83 ec 08             	sub    $0x8,%esp
80103072:	68 00 00 40 80       	push   $0x80400000
80103077:	68 30 6e 11 80       	push   $0x80116e30
8010307c:	e8 8f f5 ff ff       	call   80102610 <kinit1>
  kvmalloc();      // kernel page table
80103081:	e8 4a 4c 00 00       	call   80107cd0 <kvmalloc>
  mpinit();        // detect other processors
80103086:	e8 85 01 00 00       	call   80103210 <mpinit>
  lapicinit();     // interrupt controller
8010308b:	e8 60 f7 ff ff       	call   801027f0 <lapicinit>
  seginit();       // segment descriptors
80103090:	e8 bb 46 00 00       	call   80107750 <seginit>
  picinit();       // disable pic
80103095:	e8 76 03 00 00       	call   80103410 <picinit>
  ioapicinit();    // another interrupt controller
8010309a:	e8 31 f3 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
8010309f:	e8 bc d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030a4:	e8 37 39 00 00       	call   801069e0 <uartinit>
  pinit();         // process table
801030a9:	e8 42 0e 00 00       	call   80103ef0 <pinit>
  tvinit();        // trap vectors
801030ae:	e8 9d 34 00 00       	call   80106550 <tvinit>
  binit();         // buffer cache
801030b3:	e8 88 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030b8:	e8 53 dd ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
801030bd:	e8 fe f0 ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030c2:	83 c4 0c             	add    $0xc,%esp
801030c5:	68 8a 00 00 00       	push   $0x8a
801030ca:	68 8c b4 10 80       	push   $0x8010b48c
801030cf:	68 00 70 00 80       	push   $0x80007000
801030d4:	e8 a7 21 00 00       	call   80105280 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030d9:	83 c4 10             	add    $0x10,%esp
801030dc:	69 05 84 27 11 80 b4 	imul   $0xb4,0x80112784,%eax
801030e3:	00 00 00 
801030e6:	05 a0 27 11 80       	add    $0x801127a0,%eax
801030eb:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
801030f0:	76 7e                	jbe    80103170 <main+0x110>
801030f2:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
801030f7:	eb 20                	jmp    80103119 <main+0xb9>
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103100:	69 05 84 27 11 80 b4 	imul   $0xb4,0x80112784,%eax
80103107:	00 00 00 
8010310a:	81 c3 b4 00 00 00    	add    $0xb4,%ebx
80103110:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103115:	39 c3                	cmp    %eax,%ebx
80103117:	73 57                	jae    80103170 <main+0x110>
    if(c == mycpu())  // We've started already.
80103119:	e8 f2 0d 00 00       	call   80103f10 <mycpu>
8010311e:	39 c3                	cmp    %eax,%ebx
80103120:	74 de                	je     80103100 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103122:	e8 59 f5 ff ff       	call   80102680 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103127:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010312a:	c7 05 f8 6f 00 80 40 	movl   $0x80103040,0x80006ff8
80103131:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103134:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010313b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010313e:	05 00 10 00 00       	add    $0x1000,%eax
80103143:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103148:	0f b6 03             	movzbl (%ebx),%eax
8010314b:	68 00 70 00 00       	push   $0x7000
80103150:	50                   	push   %eax
80103151:	e8 ea f7 ff ff       	call   80102940 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103156:	83 c4 10             	add    $0x10,%esp
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103160:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103166:	85 c0                	test   %eax,%eax
80103168:	74 f6                	je     80103160 <main+0x100>
8010316a:	eb 94                	jmp    80103100 <main+0xa0>
8010316c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103170:	83 ec 08             	sub    $0x8,%esp
80103173:	68 00 00 00 8e       	push   $0x8e000000
80103178:	68 00 00 40 80       	push   $0x80400000
8010317d:	e8 2e f4 ff ff       	call   801025b0 <kinit2>
  userinit();      // first user process
80103182:	e8 b9 0e 00 00       	call   80104040 <userinit>
  mpmain();        // finish this processor's setup
80103187:	e8 74 fe ff ff       	call   80103000 <mpmain>
8010318c:	66 90                	xchg   %ax,%ax
8010318e:	66 90                	xchg   %ax,%ax

80103190 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	57                   	push   %edi
80103194:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103195:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010319b:	53                   	push   %ebx
  e = addr+len;
8010319c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010319f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031a2:	39 de                	cmp    %ebx,%esi
801031a4:	72 10                	jb     801031b6 <mpsearch1+0x26>
801031a6:	eb 50                	jmp    801031f8 <mpsearch1+0x68>
801031a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031af:	90                   	nop
801031b0:	89 fe                	mov    %edi,%esi
801031b2:	39 fb                	cmp    %edi,%ebx
801031b4:	76 42                	jbe    801031f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b6:	83 ec 04             	sub    $0x4,%esp
801031b9:	8d 7e 10             	lea    0x10(%esi),%edi
801031bc:	6a 04                	push   $0x4
801031be:	68 98 84 10 80       	push   $0x80108498
801031c3:	56                   	push   %esi
801031c4:	e8 67 20 00 00       	call   80105230 <memcmp>
801031c9:	83 c4 10             	add    $0x10,%esp
801031cc:	85 c0                	test   %eax,%eax
801031ce:	75 e0                	jne    801031b0 <mpsearch1+0x20>
801031d0:	89 f2                	mov    %esi,%edx
801031d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031d8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031db:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031de:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031e0:	39 fa                	cmp    %edi,%edx
801031e2:	75 f4                	jne    801031d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031e4:	84 c0                	test   %al,%al
801031e6:	75 c8                	jne    801031b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031eb:	89 f0                	mov    %esi,%eax
801031ed:	5b                   	pop    %ebx
801031ee:	5e                   	pop    %esi
801031ef:	5f                   	pop    %edi
801031f0:	5d                   	pop    %ebp
801031f1:	c3                   	ret    
801031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031fb:	31 f6                	xor    %esi,%esi
}
801031fd:	5b                   	pop    %ebx
801031fe:	89 f0                	mov    %esi,%eax
80103200:	5e                   	pop    %esi
80103201:	5f                   	pop    %edi
80103202:	5d                   	pop    %ebp
80103203:	c3                   	ret    
80103204:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010320b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010320f:	90                   	nop

80103210 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	57                   	push   %edi
80103214:	56                   	push   %esi
80103215:	53                   	push   %ebx
80103216:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103219:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103220:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103227:	c1 e0 08             	shl    $0x8,%eax
8010322a:	09 d0                	or     %edx,%eax
8010322c:	c1 e0 04             	shl    $0x4,%eax
8010322f:	75 1b                	jne    8010324c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103231:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103238:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010323f:	c1 e0 08             	shl    $0x8,%eax
80103242:	09 d0                	or     %edx,%eax
80103244:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103247:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010324c:	ba 00 04 00 00       	mov    $0x400,%edx
80103251:	e8 3a ff ff ff       	call   80103190 <mpsearch1>
80103256:	89 c3                	mov    %eax,%ebx
80103258:	85 c0                	test   %eax,%eax
8010325a:	0f 84 40 01 00 00    	je     801033a0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103260:	8b 73 04             	mov    0x4(%ebx),%esi
80103263:	85 f6                	test   %esi,%esi
80103265:	0f 84 25 01 00 00    	je     80103390 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010326b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010326e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103274:	6a 04                	push   $0x4
80103276:	68 9d 84 10 80       	push   $0x8010849d
8010327b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010327c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010327f:	e8 ac 1f 00 00       	call   80105230 <memcmp>
80103284:	83 c4 10             	add    $0x10,%esp
80103287:	85 c0                	test   %eax,%eax
80103289:	0f 85 01 01 00 00    	jne    80103390 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010328f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103296:	3c 01                	cmp    $0x1,%al
80103298:	74 08                	je     801032a2 <mpinit+0x92>
8010329a:	3c 04                	cmp    $0x4,%al
8010329c:	0f 85 ee 00 00 00    	jne    80103390 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801032a2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032a9:	66 85 d2             	test   %dx,%dx
801032ac:	74 22                	je     801032d0 <mpinit+0xc0>
801032ae:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032b1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032b3:	31 d2                	xor    %edx,%edx
801032b5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032b8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032bf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032c2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032c4:	39 c7                	cmp    %eax,%edi
801032c6:	75 f0                	jne    801032b8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801032c8:	84 d2                	test   %dl,%dl
801032ca:	0f 85 c0 00 00 00    	jne    80103390 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032d0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801032d6:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032db:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032e2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801032e8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032ed:	03 55 e4             	add    -0x1c(%ebp),%edx
801032f0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032f7:	90                   	nop
801032f8:	39 d0                	cmp    %edx,%eax
801032fa:	73 15                	jae    80103311 <mpinit+0x101>
    switch(*p){
801032fc:	0f b6 08             	movzbl (%eax),%ecx
801032ff:	80 f9 02             	cmp    $0x2,%cl
80103302:	74 4c                	je     80103350 <mpinit+0x140>
80103304:	77 3a                	ja     80103340 <mpinit+0x130>
80103306:	84 c9                	test   %cl,%cl
80103308:	74 56                	je     80103360 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010330a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010330d:	39 d0                	cmp    %edx,%eax
8010330f:	72 eb                	jb     801032fc <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103311:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103314:	85 f6                	test   %esi,%esi
80103316:	0f 84 d9 00 00 00    	je     801033f5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010331c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103320:	74 15                	je     80103337 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103322:	b8 70 00 00 00       	mov    $0x70,%eax
80103327:	ba 22 00 00 00       	mov    $0x22,%edx
8010332c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010332d:	ba 23 00 00 00       	mov    $0x23,%edx
80103332:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103333:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103336:	ee                   	out    %al,(%dx)
  }
}
80103337:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010333a:	5b                   	pop    %ebx
8010333b:	5e                   	pop    %esi
8010333c:	5f                   	pop    %edi
8010333d:	5d                   	pop    %ebp
8010333e:	c3                   	ret    
8010333f:	90                   	nop
    switch(*p){
80103340:	83 e9 03             	sub    $0x3,%ecx
80103343:	80 f9 01             	cmp    $0x1,%cl
80103346:	76 c2                	jbe    8010330a <mpinit+0xfa>
80103348:	31 f6                	xor    %esi,%esi
8010334a:	eb ac                	jmp    801032f8 <mpinit+0xe8>
8010334c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103350:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103354:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103357:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
8010335d:	eb 99                	jmp    801032f8 <mpinit+0xe8>
8010335f:	90                   	nop
      if(ncpu < NCPU) {
80103360:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
80103366:	83 f9 07             	cmp    $0x7,%ecx
80103369:	7f 19                	jg     80103384 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010336b:	69 f9 b4 00 00 00    	imul   $0xb4,%ecx,%edi
80103371:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103375:	83 c1 01             	add    $0x1,%ecx
80103378:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337e:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
80103384:	83 c0 14             	add    $0x14,%eax
      continue;
80103387:	e9 6c ff ff ff       	jmp    801032f8 <mpinit+0xe8>
8010338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103390:	83 ec 0c             	sub    $0xc,%esp
80103393:	68 a2 84 10 80       	push   $0x801084a2
80103398:	e8 e3 cf ff ff       	call   80100380 <panic>
8010339d:	8d 76 00             	lea    0x0(%esi),%esi
{
801033a0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033a5:	eb 13                	jmp    801033ba <mpinit+0x1aa>
801033a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ae:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801033b0:	89 f3                	mov    %esi,%ebx
801033b2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033b8:	74 d6                	je     80103390 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ba:	83 ec 04             	sub    $0x4,%esp
801033bd:	8d 73 10             	lea    0x10(%ebx),%esi
801033c0:	6a 04                	push   $0x4
801033c2:	68 98 84 10 80       	push   $0x80108498
801033c7:	53                   	push   %ebx
801033c8:	e8 63 1e 00 00       	call   80105230 <memcmp>
801033cd:	83 c4 10             	add    $0x10,%esp
801033d0:	85 c0                	test   %eax,%eax
801033d2:	75 dc                	jne    801033b0 <mpinit+0x1a0>
801033d4:	89 da                	mov    %ebx,%edx
801033d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033dd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033e0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033e3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033e6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033e8:	39 d6                	cmp    %edx,%esi
801033ea:	75 f4                	jne    801033e0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ec:	84 c0                	test   %al,%al
801033ee:	75 c0                	jne    801033b0 <mpinit+0x1a0>
801033f0:	e9 6b fe ff ff       	jmp    80103260 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801033f5:	83 ec 0c             	sub    $0xc,%esp
801033f8:	68 bc 84 10 80       	push   $0x801084bc
801033fd:	e8 7e cf ff ff       	call   80100380 <panic>
80103402:	66 90                	xchg   %ax,%ax
80103404:	66 90                	xchg   %ax,%ax
80103406:	66 90                	xchg   %ax,%ax
80103408:	66 90                	xchg   %ax,%ax
8010340a:	66 90                	xchg   %ax,%ax
8010340c:	66 90                	xchg   %ax,%ax
8010340e:	66 90                	xchg   %ax,%ax

80103410 <picinit>:
80103410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103415:	ba 21 00 00 00       	mov    $0x21,%edx
8010341a:	ee                   	out    %al,(%dx)
8010341b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103420:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103421:	c3                   	ret    
80103422:	66 90                	xchg   %ax,%ax
80103424:	66 90                	xchg   %ax,%ax
80103426:	66 90                	xchg   %ax,%ax
80103428:	66 90                	xchg   %ax,%ax
8010342a:	66 90                	xchg   %ax,%ax
8010342c:	66 90                	xchg   %ax,%ax
8010342e:	66 90                	xchg   %ax,%ax

80103430 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 0c             	sub    $0xc,%esp
80103439:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010343c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010343f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103445:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010344b:	e8 e0 d9 ff ff       	call   80100e30 <filealloc>
80103450:	89 03                	mov    %eax,(%ebx)
80103452:	85 c0                	test   %eax,%eax
80103454:	0f 84 a8 00 00 00    	je     80103502 <pipealloc+0xd2>
8010345a:	e8 d1 d9 ff ff       	call   80100e30 <filealloc>
8010345f:	89 06                	mov    %eax,(%esi)
80103461:	85 c0                	test   %eax,%eax
80103463:	0f 84 87 00 00 00    	je     801034f0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103469:	e8 12 f2 ff ff       	call   80102680 <kalloc>
8010346e:	89 c7                	mov    %eax,%edi
80103470:	85 c0                	test   %eax,%eax
80103472:	0f 84 b0 00 00 00    	je     80103528 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103478:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010347f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103482:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103485:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010348c:	00 00 00 
  p->nwrite = 0;
8010348f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103496:	00 00 00 
  p->nread = 0;
80103499:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034a0:	00 00 00 
  initlock(&p->lock, "pipe");
801034a3:	68 db 84 10 80       	push   $0x801084db
801034a8:	50                   	push   %eax
801034a9:	e8 a2 1a 00 00       	call   80104f50 <initlock>
  (*f0)->type = FD_PIPE;
801034ae:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034b0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034b3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034b9:	8b 03                	mov    (%ebx),%eax
801034bb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034bf:	8b 03                	mov    (%ebx),%eax
801034c1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034c5:	8b 03                	mov    (%ebx),%eax
801034c7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034ca:	8b 06                	mov    (%esi),%eax
801034cc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034d2:	8b 06                	mov    (%esi),%eax
801034d4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034d8:	8b 06                	mov    (%esi),%eax
801034da:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034de:	8b 06                	mov    (%esi),%eax
801034e0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034e6:	31 c0                	xor    %eax,%eax
}
801034e8:	5b                   	pop    %ebx
801034e9:	5e                   	pop    %esi
801034ea:	5f                   	pop    %edi
801034eb:	5d                   	pop    %ebp
801034ec:	c3                   	ret    
801034ed:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801034f0:	8b 03                	mov    (%ebx),%eax
801034f2:	85 c0                	test   %eax,%eax
801034f4:	74 1e                	je     80103514 <pipealloc+0xe4>
    fileclose(*f0);
801034f6:	83 ec 0c             	sub    $0xc,%esp
801034f9:	50                   	push   %eax
801034fa:	e8 f1 d9 ff ff       	call   80100ef0 <fileclose>
801034ff:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103502:	8b 06                	mov    (%esi),%eax
80103504:	85 c0                	test   %eax,%eax
80103506:	74 0c                	je     80103514 <pipealloc+0xe4>
    fileclose(*f1);
80103508:	83 ec 0c             	sub    $0xc,%esp
8010350b:	50                   	push   %eax
8010350c:	e8 df d9 ff ff       	call   80100ef0 <fileclose>
80103511:	83 c4 10             	add    $0x10,%esp
}
80103514:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103517:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010351c:	5b                   	pop    %ebx
8010351d:	5e                   	pop    %esi
8010351e:	5f                   	pop    %edi
8010351f:	5d                   	pop    %ebp
80103520:	c3                   	ret    
80103521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103528:	8b 03                	mov    (%ebx),%eax
8010352a:	85 c0                	test   %eax,%eax
8010352c:	75 c8                	jne    801034f6 <pipealloc+0xc6>
8010352e:	eb d2                	jmp    80103502 <pipealloc+0xd2>

80103530 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	56                   	push   %esi
80103534:	53                   	push   %ebx
80103535:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103538:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010353b:	83 ec 0c             	sub    $0xc,%esp
8010353e:	53                   	push   %ebx
8010353f:	e8 dc 1b 00 00       	call   80105120 <acquire>
  if(writable){
80103544:	83 c4 10             	add    $0x10,%esp
80103547:	85 f6                	test   %esi,%esi
80103549:	74 65                	je     801035b0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010354b:	83 ec 0c             	sub    $0xc,%esp
8010354e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103554:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010355b:	00 00 00 
    wakeup(&p->nread);
8010355e:	50                   	push   %eax
8010355f:	e8 4c 17 00 00       	call   80104cb0 <wakeup>
80103564:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103567:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010356d:	85 d2                	test   %edx,%edx
8010356f:	75 0a                	jne    8010357b <pipeclose+0x4b>
80103571:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103577:	85 c0                	test   %eax,%eax
80103579:	74 15                	je     80103590 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010357b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010357e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103581:	5b                   	pop    %ebx
80103582:	5e                   	pop    %esi
80103583:	5d                   	pop    %ebp
    release(&p->lock);
80103584:	e9 37 1b 00 00       	jmp    801050c0 <release>
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 27 1b 00 00       	call   801050c0 <release>
    kfree((char*)p);
80103599:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010359c:	83 c4 10             	add    $0x10,%esp
}
8010359f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a2:	5b                   	pop    %ebx
801035a3:	5e                   	pop    %esi
801035a4:	5d                   	pop    %ebp
    kfree((char*)p);
801035a5:	e9 16 ef ff ff       	jmp    801024c0 <kfree>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035c0:	00 00 00 
    wakeup(&p->nwrite);
801035c3:	50                   	push   %eax
801035c4:	e8 e7 16 00 00       	call   80104cb0 <wakeup>
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	eb 99                	jmp    80103567 <pipeclose+0x37>
801035ce:	66 90                	xchg   %ax,%ax

801035d0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	57                   	push   %edi
801035d4:	56                   	push   %esi
801035d5:	53                   	push   %ebx
801035d6:	83 ec 28             	sub    $0x28,%esp
801035d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035dc:	53                   	push   %ebx
801035dd:	e8 3e 1b 00 00       	call   80105120 <acquire>
  for(i = 0; i < n; i++){
801035e2:	8b 45 10             	mov    0x10(%ebp),%eax
801035e5:	83 c4 10             	add    $0x10,%esp
801035e8:	85 c0                	test   %eax,%eax
801035ea:	0f 8e c0 00 00 00    	jle    801036b0 <pipewrite+0xe0>
801035f0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035f3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035f9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103602:	03 45 10             	add    0x10(%ebp),%eax
80103605:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103608:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010360e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103614:	89 ca                	mov    %ecx,%edx
80103616:	05 00 02 00 00       	add    $0x200,%eax
8010361b:	39 c1                	cmp    %eax,%ecx
8010361d:	74 3f                	je     8010365e <pipewrite+0x8e>
8010361f:	eb 67                	jmp    80103688 <pipewrite+0xb8>
80103621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103628:	e8 e3 09 00 00       	call   80104010 <myproc>
8010362d:	8b 48 24             	mov    0x24(%eax),%ecx
80103630:	85 c9                	test   %ecx,%ecx
80103632:	75 34                	jne    80103668 <pipewrite+0x98>
      wakeup(&p->nread);
80103634:	83 ec 0c             	sub    $0xc,%esp
80103637:	57                   	push   %edi
80103638:	e8 73 16 00 00       	call   80104cb0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010363d:	58                   	pop    %eax
8010363e:	5a                   	pop    %edx
8010363f:	53                   	push   %ebx
80103640:	56                   	push   %esi
80103641:	e8 4a 15 00 00       	call   80104b90 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103646:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010364c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103652:	83 c4 10             	add    $0x10,%esp
80103655:	05 00 02 00 00       	add    $0x200,%eax
8010365a:	39 c2                	cmp    %eax,%edx
8010365c:	75 2a                	jne    80103688 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010365e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103664:	85 c0                	test   %eax,%eax
80103666:	75 c0                	jne    80103628 <pipewrite+0x58>
        release(&p->lock);
80103668:	83 ec 0c             	sub    $0xc,%esp
8010366b:	53                   	push   %ebx
8010366c:	e8 4f 1a 00 00       	call   801050c0 <release>
        return -1;
80103671:	83 c4 10             	add    $0x10,%esp
80103674:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103679:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010367c:	5b                   	pop    %ebx
8010367d:	5e                   	pop    %esi
8010367e:	5f                   	pop    %edi
8010367f:	5d                   	pop    %ebp
80103680:	c3                   	ret    
80103681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103688:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010368b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010368e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103694:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010369a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010369d:	83 c6 01             	add    $0x1,%esi
801036a0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036a3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036a7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036aa:	0f 85 58 ff ff ff    	jne    80103608 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036b0:	83 ec 0c             	sub    $0xc,%esp
801036b3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036b9:	50                   	push   %eax
801036ba:	e8 f1 15 00 00       	call   80104cb0 <wakeup>
  release(&p->lock);
801036bf:	89 1c 24             	mov    %ebx,(%esp)
801036c2:	e8 f9 19 00 00       	call   801050c0 <release>
  return n;
801036c7:	8b 45 10             	mov    0x10(%ebp),%eax
801036ca:	83 c4 10             	add    $0x10,%esp
801036cd:	eb aa                	jmp    80103679 <pipewrite+0xa9>
801036cf:	90                   	nop

801036d0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	57                   	push   %edi
801036d4:	56                   	push   %esi
801036d5:	53                   	push   %ebx
801036d6:	83 ec 18             	sub    $0x18,%esp
801036d9:	8b 75 08             	mov    0x8(%ebp),%esi
801036dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036df:	56                   	push   %esi
801036e0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036e6:	e8 35 1a 00 00       	call   80105120 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036eb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036f1:	83 c4 10             	add    $0x10,%esp
801036f4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036fa:	74 2f                	je     8010372b <piperead+0x5b>
801036fc:	eb 37                	jmp    80103735 <piperead+0x65>
801036fe:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103700:	e8 0b 09 00 00       	call   80104010 <myproc>
80103705:	8b 48 24             	mov    0x24(%eax),%ecx
80103708:	85 c9                	test   %ecx,%ecx
8010370a:	0f 85 80 00 00 00    	jne    80103790 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103710:	83 ec 08             	sub    $0x8,%esp
80103713:	56                   	push   %esi
80103714:	53                   	push   %ebx
80103715:	e8 76 14 00 00       	call   80104b90 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010371a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103720:	83 c4 10             	add    $0x10,%esp
80103723:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103729:	75 0a                	jne    80103735 <piperead+0x65>
8010372b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103731:	85 c0                	test   %eax,%eax
80103733:	75 cb                	jne    80103700 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103735:	8b 55 10             	mov    0x10(%ebp),%edx
80103738:	31 db                	xor    %ebx,%ebx
8010373a:	85 d2                	test   %edx,%edx
8010373c:	7f 20                	jg     8010375e <piperead+0x8e>
8010373e:	eb 2c                	jmp    8010376c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103740:	8d 48 01             	lea    0x1(%eax),%ecx
80103743:	25 ff 01 00 00       	and    $0x1ff,%eax
80103748:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010374e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103753:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103756:	83 c3 01             	add    $0x1,%ebx
80103759:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010375c:	74 0e                	je     8010376c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010375e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103764:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010376a:	75 d4                	jne    80103740 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010376c:	83 ec 0c             	sub    $0xc,%esp
8010376f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103775:	50                   	push   %eax
80103776:	e8 35 15 00 00       	call   80104cb0 <wakeup>
  release(&p->lock);
8010377b:	89 34 24             	mov    %esi,(%esp)
8010377e:	e8 3d 19 00 00       	call   801050c0 <release>
  return i;
80103783:	83 c4 10             	add    $0x10,%esp
}
80103786:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103789:	89 d8                	mov    %ebx,%eax
8010378b:	5b                   	pop    %ebx
8010378c:	5e                   	pop    %esi
8010378d:	5f                   	pop    %edi
8010378e:	5d                   	pop    %ebp
8010378f:	c3                   	ret    
      release(&p->lock);
80103790:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103793:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103798:	56                   	push   %esi
80103799:	e8 22 19 00 00       	call   801050c0 <release>
      return -1;
8010379e:	83 c4 10             	add    $0x10,%esp
}
801037a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a4:	89 d8                	mov    %ebx,%eax
801037a6:	5b                   	pop    %ebx
801037a7:	5e                   	pop    %esi
801037a8:	5f                   	pop    %edi
801037a9:	5d                   	pop    %ebp
801037aa:	c3                   	ret    
801037ab:	66 90                	xchg   %ax,%ax
801037ad:	66 90                	xchg   %ax,%ax
801037af:	90                   	nop

801037b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037b4:	bb b4 32 11 80       	mov    $0x801132b4,%ebx
{
801037b9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037bc:	68 80 32 11 80       	push   $0x80113280
801037c1:	e8 5a 19 00 00       	call   80105120 <acquire>
801037c6:	83 c4 10             	add    $0x10,%esp
801037c9:	eb 17                	jmp    801037e2 <allocproc+0x32>
801037cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037cf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d0:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801037d6:	81 fb b4 55 11 80    	cmp    $0x801155b4,%ebx
801037dc:	0f 84 96 00 00 00    	je     80103878 <allocproc+0xc8>
    if(p->state == UNUSED)
801037e2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037e5:	85 c0                	test   %eax,%eax
801037e7:	75 e7                	jne    801037d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037e9:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->priority = 0;
  p->level = 0;
  p->tq = 0;

  release(&ptable.lock);  
801037ee:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037f1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->priority = 0;
801037f8:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->pid = nextpid++;
801037ff:	89 43 10             	mov    %eax,0x10(%ebx)
80103802:	8d 50 01             	lea    0x1(%eax),%edx
  p->level = 0;
80103805:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
8010380c:	00 00 00 
  p->tq = 0;
8010380f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103816:	00 00 00 
  release(&ptable.lock);  
80103819:	68 80 32 11 80       	push   $0x80113280
  p->pid = nextpid++;
8010381e:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);  
80103824:	e8 97 18 00 00       	call   801050c0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103829:	e8 52 ee ff ff       	call   80102680 <kalloc>
8010382e:	83 c4 10             	add    $0x10,%esp
80103831:	89 43 08             	mov    %eax,0x8(%ebx)
80103834:	85 c0                	test   %eax,%eax
80103836:	74 59                	je     80103891 <allocproc+0xe1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103838:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010383e:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103841:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103846:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103849:	c7 40 14 39 65 10 80 	movl   $0x80106539,0x14(%eax)
  p->context = (struct context*)sp;
80103850:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103853:	6a 14                	push   $0x14
80103855:	6a 00                	push   $0x0
80103857:	50                   	push   %eax
80103858:	e8 83 19 00 00       	call   801051e0 <memset>
  p->context->eip = (uint)forkret;
8010385d:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103860:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103863:	c7 40 10 b0 38 10 80 	movl   $0x801038b0,0x10(%eax)
}
8010386a:	89 d8                	mov    %ebx,%eax
8010386c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010386f:	c9                   	leave  
80103870:	c3                   	ret    
80103871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103878:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010387b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010387d:	68 80 32 11 80       	push   $0x80113280
80103882:	e8 39 18 00 00       	call   801050c0 <release>
}
80103887:	89 d8                	mov    %ebx,%eax
  return 0;
80103889:	83 c4 10             	add    $0x10,%esp
}
8010388c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010388f:	c9                   	leave  
80103890:	c3                   	ret    
    p->state = UNUSED;
80103891:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103898:	31 db                	xor    %ebx,%ebx
}
8010389a:	89 d8                	mov    %ebx,%eax
8010389c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010389f:	c9                   	leave  
801038a0:	c3                   	ret    
801038a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038af:	90                   	nop

801038b0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038b6:	68 80 32 11 80       	push   $0x80113280
801038bb:	e8 00 18 00 00       	call   801050c0 <release>

  if (first) {
801038c0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038c5:	83 c4 10             	add    $0x10,%esp
801038c8:	85 c0                	test   %eax,%eax
801038ca:	75 04                	jne    801038d0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038cc:	c9                   	leave  
801038cd:	c3                   	ret    
801038ce:	66 90                	xchg   %ax,%ax
    first = 0;
801038d0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038d7:	00 00 00 
    iinit(ROOTDEV);
801038da:	83 ec 0c             	sub    $0xc,%esp
801038dd:	6a 01                	push   $0x1
801038df:	e8 7c dc ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
801038e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038eb:	e8 d0 f3 ff ff       	call   80102cc0 <initlog>
}
801038f0:	83 c4 10             	add    $0x10,%esp
801038f3:	c9                   	leave  
801038f4:	c3                   	ret    
801038f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103900 <initqueue>:
    int rear;
};

void
initqueue(struct queue* q)
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	8b 45 08             	mov    0x8(%ebp),%eax
    q->front = 0;
80103906:	c7 80 00 01 00 00 00 	movl   $0x0,0x100(%eax)
8010390d:	00 00 00 
    q->rear = 0;
80103910:	c7 80 04 01 00 00 00 	movl   $0x0,0x104(%eax)
80103917:	00 00 00 
}
8010391a:	5d                   	pop    %ebp
8010391b:	c3                   	ret    
8010391c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103920 <sizeofqueue>:

int
sizeofqueue(struct queue* q)
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	8b 55 08             	mov    0x8(%ebp),%edx
    return (q->rear - q->front + NPROC) % NPROC;
}
80103926:	5d                   	pop    %ebp
    return (q->rear - q->front + NPROC) % NPROC;
80103927:	8b 82 04 01 00 00    	mov    0x104(%edx),%eax
8010392d:	2b 82 00 01 00 00    	sub    0x100(%edx),%eax
80103933:	83 c0 40             	add    $0x40,%eax
80103936:	99                   	cltd   
80103937:	c1 ea 1a             	shr    $0x1a,%edx
8010393a:	01 d0                	add    %edx,%eax
8010393c:	83 e0 3f             	and    $0x3f,%eax
8010393f:	29 d0                	sub    %edx,%eax
}
80103941:	c3                   	ret    
80103942:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103950 <isfullqueue>:

int
isfullqueue(struct queue* q)
{
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	8b 45 08             	mov    0x8(%ebp),%eax
    if(q->front == 0 && q->rear == NPROC - 1)
80103956:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
8010395c:	8b 80 04 01 00 00    	mov    0x104(%eax),%eax
80103962:	85 d2                	test   %edx,%edx
80103964:	75 0a                	jne    80103970 <isfullqueue+0x20>
        return 1;
80103966:	b9 01 00 00 00       	mov    $0x1,%ecx
    if(q->front == 0 && q->rear == NPROC - 1)
8010396b:	83 f8 3f             	cmp    $0x3f,%eax
8010396e:	74 19                	je     80103989 <isfullqueue+0x39>
    if(q->front == (q->rear + 1) % NPROC)
80103970:	83 c0 01             	add    $0x1,%eax
80103973:	89 c1                	mov    %eax,%ecx
80103975:	c1 f9 1f             	sar    $0x1f,%ecx
80103978:	c1 e9 1a             	shr    $0x1a,%ecx
8010397b:	01 c8                	add    %ecx,%eax
8010397d:	83 e0 3f             	and    $0x3f,%eax
80103980:	29 c8                	sub    %ecx,%eax
80103982:	31 c9                	xor    %ecx,%ecx
80103984:	39 d0                	cmp    %edx,%eax
80103986:	0f 94 c1             	sete   %cl
        return 1;
    return 0;
} 
80103989:	89 c8                	mov    %ecx,%eax
8010398b:	5d                   	pop    %ebp
8010398c:	c3                   	ret    
8010398d:	8d 76 00             	lea    0x0(%esi),%esi

80103990 <isemptyqueue>:

int isemptyqueue(struct queue* q)
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	53                   	push   %ebx
80103994:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if(q->front % NPROC == q->rear % NPROC)
80103997:	8b 83 00 01 00 00    	mov    0x100(%ebx),%eax
8010399d:	89 c1                	mov    %eax,%ecx
8010399f:	c1 f9 1f             	sar    $0x1f,%ecx
801039a2:	c1 e9 1a             	shr    $0x1a,%ecx
801039a5:	8d 14 08             	lea    (%eax,%ecx,1),%edx
801039a8:	8b 83 04 01 00 00    	mov    0x104(%ebx),%eax
        return 1;
    return 0;
}
801039ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039b1:	c9                   	leave  
    if(q->front % NPROC == q->rear % NPROC)
801039b2:	83 e2 3f             	and    $0x3f,%edx
801039b5:	29 ca                	sub    %ecx,%edx
801039b7:	89 c1                	mov    %eax,%ecx
801039b9:	c1 f9 1f             	sar    $0x1f,%ecx
801039bc:	c1 e9 1a             	shr    $0x1a,%ecx
801039bf:	01 c8                	add    %ecx,%eax
801039c1:	83 e0 3f             	and    $0x3f,%eax
801039c4:	29 c8                	sub    %ecx,%eax
801039c6:	39 c2                	cmp    %eax,%edx
801039c8:	0f 94 c0             	sete   %al
801039cb:	0f b6 c0             	movzbl %al,%eax
}
801039ce:	c3                   	ret    
801039cf:	90                   	nop

801039d0 <insertqueue>:


void
insertqueue(struct queue* q, struct proc* p)
{   
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	57                   	push   %edi
801039d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
801039d7:	56                   	push   %esi
801039d8:	53                   	push   %ebx
801039d9:	8b 75 0c             	mov    0xc(%ebp),%esi
    if(q->front == 0 && q->rear == NPROC - 1)
801039dc:	8b b9 00 01 00 00    	mov    0x100(%ecx),%edi
801039e2:	8b 91 04 01 00 00    	mov    0x104(%ecx),%edx
801039e8:	85 ff                	test   %edi,%edi
801039ea:	75 05                	jne    801039f1 <insertqueue+0x21>
801039ec:	83 fa 3f             	cmp    $0x3f,%edx
801039ef:	74 37                	je     80103a28 <insertqueue+0x58>
    if(q->front == (q->rear + 1) % NPROC)
801039f1:	8d 42 01             	lea    0x1(%edx),%eax
801039f4:	89 c3                	mov    %eax,%ebx
801039f6:	c1 fb 1f             	sar    $0x1f,%ebx
801039f9:	c1 eb 1a             	shr    $0x1a,%ebx
801039fc:	01 d8                	add    %ebx,%eax
801039fe:	83 e0 3f             	and    $0x3f,%eax
80103a01:	29 d8                	sub    %ebx,%eax
80103a03:	39 c7                	cmp    %eax,%edi
80103a05:	74 21                	je     80103a28 <insertqueue+0x58>
    if(isfullqueue(q))
    {
        cprintf("Queue is full\n");
        return;
    }
    q->proc[q->rear % NPROC] = p;
80103a07:	89 d3                	mov    %edx,%ebx
80103a09:	c1 fb 1f             	sar    $0x1f,%ebx
80103a0c:	c1 eb 1a             	shr    $0x1a,%ebx
80103a0f:	01 da                	add    %ebx,%edx
80103a11:	83 e2 3f             	and    $0x3f,%edx
80103a14:	29 da                	sub    %ebx,%edx
80103a16:	89 34 91             	mov    %esi,(%ecx,%edx,4)
    q->rear = (q->rear + 1) % NPROC;
80103a19:	89 81 04 01 00 00    	mov    %eax,0x104(%ecx)
}
80103a1f:	5b                   	pop    %ebx
80103a20:	5e                   	pop    %esi
80103a21:	5f                   	pop    %edi
80103a22:	5d                   	pop    %ebp
80103a23:	c3                   	ret    
80103a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a28:	5b                   	pop    %ebx
80103a29:	5e                   	pop    %esi
        cprintf("Queue is full\n");
80103a2a:	c7 45 08 e0 84 10 80 	movl   $0x801084e0,0x8(%ebp)
}
80103a31:	5f                   	pop    %edi
80103a32:	5d                   	pop    %ebp
        cprintf("Queue is full\n");
80103a33:	e9 68 cc ff ff       	jmp    801006a0 <cprintf>
80103a38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a3f:	90                   	nop

80103a40 <deletequeue>:

struct proc*
deletequeue(struct queue* q)
{   
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	56                   	push   %esi
80103a44:	8b 55 08             	mov    0x8(%ebp),%edx
80103a47:	53                   	push   %ebx
    if(q->front % NPROC == q->rear % NPROC)
80103a48:	8b 82 00 01 00 00    	mov    0x100(%edx),%eax
80103a4e:	89 c1                	mov    %eax,%ecx
80103a50:	c1 f9 1f             	sar    $0x1f,%ecx
80103a53:	c1 e9 1a             	shr    $0x1a,%ecx
80103a56:	8d 1c 08             	lea    (%eax,%ecx,1),%ebx
80103a59:	83 e3 3f             	and    $0x3f,%ebx
80103a5c:	29 cb                	sub    %ecx,%ebx
80103a5e:	8b 8a 04 01 00 00    	mov    0x104(%edx),%ecx
80103a64:	89 ce                	mov    %ecx,%esi
80103a66:	c1 fe 1f             	sar    $0x1f,%esi
80103a69:	c1 ee 1a             	shr    $0x1a,%esi
80103a6c:	01 f1                	add    %esi,%ecx
80103a6e:	83 e1 3f             	and    $0x3f,%ecx
80103a71:	29 f1                	sub    %esi,%ecx
80103a73:	39 cb                	cmp    %ecx,%ebx
80103a75:	74 29                	je     80103aa0 <deletequeue+0x60>
    {
        cprintf("Queue is empty\n");
        return 0;
    }
    p = q->proc[q->front % NPROC];
    q->front = (q->front + 1) % NPROC;
80103a77:	83 c0 01             	add    $0x1,%eax
    p = q->proc[q->front % NPROC];
80103a7a:	8b 0c 9a             	mov    (%edx,%ebx,4),%ecx
    q->front = (q->front + 1) % NPROC;
80103a7d:	89 c3                	mov    %eax,%ebx
80103a7f:	c1 fb 1f             	sar    $0x1f,%ebx
80103a82:	c1 eb 1a             	shr    $0x1a,%ebx
80103a85:	01 d8                	add    %ebx,%eax
80103a87:	83 e0 3f             	and    $0x3f,%eax
80103a8a:	29 d8                	sub    %ebx,%eax
80103a8c:	89 82 00 01 00 00    	mov    %eax,0x100(%edx)
    return p;
}
80103a92:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a95:	89 c8                	mov    %ecx,%eax
80103a97:	5b                   	pop    %ebx
80103a98:	5e                   	pop    %esi
80103a99:	5d                   	pop    %ebp
80103a9a:	c3                   	ret    
80103a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a9f:	90                   	nop
        cprintf("Queue is empty\n");
80103aa0:	83 ec 0c             	sub    $0xc,%esp
80103aa3:	68 ef 84 10 80       	push   $0x801084ef
80103aa8:	e8 f3 cb ff ff       	call   801006a0 <cprintf>
        return 0;
80103aad:	83 c4 10             	add    $0x10,%esp
80103ab0:	31 c9                	xor    %ecx,%ecx
}
80103ab2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ab5:	5b                   	pop    %ebx
80103ab6:	89 c8                	mov    %ecx,%eax
80103ab8:	5e                   	pop    %esi
80103ab9:	5d                   	pop    %ebp
80103aba:	c3                   	ret    
80103abb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103abf:	90                   	nop

80103ac0 <initheap>:
    int size;
};

void
initheap(struct heap* h)
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
    h->size = 0;
80103ac3:	8b 45 08             	mov    0x8(%ebp),%eax
80103ac6:	c7 80 00 01 00 00 00 	movl   $0x0,0x100(%eax)
80103acd:	00 00 00 
}
80103ad0:	5d                   	pop    %ebp
80103ad1:	c3                   	ret    
80103ad2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ae0 <isfullheap>:

int
isfullheap(struct heap* h)
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
    if(h->size == NPROC)
80103ae3:	8b 45 08             	mov    0x8(%ebp),%eax
        return 1;
    return 0;
}
80103ae6:	5d                   	pop    %ebp
    if(h->size == NPROC)
80103ae7:	83 b8 00 01 00 00 40 	cmpl   $0x40,0x100(%eax)
80103aee:	0f 94 c0             	sete   %al
80103af1:	0f b6 c0             	movzbl %al,%eax
}
80103af4:	c3                   	ret    
80103af5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b00 <isemptyheap>:

int
isemptyheap(struct heap* h)
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
    if(h->size == 0)
80103b03:	8b 45 08             	mov    0x8(%ebp),%eax
        return 1;
    return 0;
}
80103b06:	5d                   	pop    %ebp
    if(h->size == 0)
80103b07:	8b 80 00 01 00 00    	mov    0x100(%eax),%eax
80103b0d:	85 c0                	test   %eax,%eax
80103b0f:	0f 94 c0             	sete   %al
80103b12:	0f b6 c0             	movzbl %al,%eax
}
80103b15:	c3                   	ret    
80103b16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b1d:	8d 76 00             	lea    0x0(%esi),%esi

80103b20 <heapify>:


void
heapify(struct heap* h, int index)
{
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	57                   	push   %edi
80103b24:	56                   	push   %esi
80103b25:	53                   	push   %ebx
80103b26:	83 ec 0c             	sub    $0xc,%esp
80103b29:	8b 55 08             	mov    0x8(%ebp),%edx
80103b2c:	8b 7d 0c             	mov    0xc(%ebp),%edi
    int left = 2 * index + 1;
    int right = 2 * index + 2;

    // Check if the left child is larger than the root

    if (left < h->size && h->proc[left]->priority > h->proc[largest]->priority)
80103b2f:	8b b2 00 01 00 00    	mov    0x100(%edx),%esi
80103b35:	89 75 f0             	mov    %esi,-0x10(%ebp)
80103b38:	eb 2e                	jmp    80103b68 <heapify+0x48>
80103b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b40:	8b 34 b2             	mov    (%edx,%esi,4),%esi
80103b43:	8b 0c ba             	mov    (%edx,%edi,4),%ecx
80103b46:	89 75 e8             	mov    %esi,-0x18(%ebp)
80103b49:	8b 59 7c             	mov    0x7c(%ecx),%ebx
80103b4c:	39 5e 7c             	cmp    %ebx,0x7c(%esi)
80103b4f:	7e 28                	jle    80103b79 <heapify+0x59>
        largest = left;

    // Check if the right child is larger than the largest so far

    if (right < h->size && h->proc[right]->priority > h->proc[largest]->priority)
80103b51:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80103b54:	7f 3e                	jg     80103b94 <heapify+0x74>
80103b56:	8b 45 ec             	mov    -0x14(%ebp),%eax
        largest = right;

    // If the largest is not the root, swap the root with the largest and heapify the heap

    if (largest != index) {
80103b59:	39 f8                	cmp    %edi,%eax
80103b5b:	74 2f                	je     80103b8c <heapify+0x6c>
        struct proc* temp = h->proc[index];
        h->proc[index] = h->proc[largest];
80103b5d:	8b 1c 82             	mov    (%edx,%eax,4),%ebx
80103b60:	89 1c ba             	mov    %ebx,(%edx,%edi,4)
        h->proc[largest] = temp;
80103b63:	89 c7                	mov    %eax,%edi
80103b65:	89 0c 82             	mov    %ecx,(%edx,%eax,4)
    int left = 2 * index + 1;
80103b68:	8d 04 3f             	lea    (%edi,%edi,1),%eax
80103b6b:	8d 70 01             	lea    0x1(%eax),%esi
    int right = 2 * index + 2;
80103b6e:	83 c0 02             	add    $0x2,%eax
    int left = 2 * index + 1;
80103b71:	89 75 ec             	mov    %esi,-0x14(%ebp)
    if (left < h->size && h->proc[left]->priority > h->proc[largest]->priority)
80103b74:	39 75 f0             	cmp    %esi,-0x10(%ebp)
80103b77:	7f c7                	jg     80103b40 <heapify+0x20>
    if (right < h->size && h->proc[right]->priority > h->proc[largest]->priority)
80103b79:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80103b7c:	7e 0e                	jle    80103b8c <heapify+0x6c>
80103b7e:	8b 0c ba             	mov    (%edx,%edi,4),%ecx
80103b81:	8b 1c 82             	mov    (%edx,%eax,4),%ebx
80103b84:	8b 71 7c             	mov    0x7c(%ecx),%esi
80103b87:	39 73 7c             	cmp    %esi,0x7c(%ebx)
80103b8a:	7f cd                	jg     80103b59 <heapify+0x39>
        heapify(h, largest);
    }
}
80103b8c:	83 c4 0c             	add    $0xc,%esp
80103b8f:	5b                   	pop    %ebx
80103b90:	5e                   	pop    %esi
80103b91:	5f                   	pop    %edi
80103b92:	5d                   	pop    %ebp
80103b93:	c3                   	ret    
80103b94:	8b 34 82             	mov    (%edx,%eax,4),%esi
80103b97:	8b 5d e8             	mov    -0x18(%ebp),%ebx
80103b9a:	8b 5b 7c             	mov    0x7c(%ebx),%ebx
80103b9d:	39 5e 7c             	cmp    %ebx,0x7c(%esi)
80103ba0:	0f 4e 45 ec          	cmovle -0x14(%ebp),%eax
80103ba4:	eb b3                	jmp    80103b59 <heapify+0x39>
80103ba6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bad:	8d 76 00             	lea    0x0(%esi),%esi

80103bb0 <deleteheap>:


struct proc*
deleteheap(struct heap* h)
{
80103bb0:	55                   	push   %ebp
80103bb1:	89 e5                	mov    %esp,%ebp
80103bb3:	53                   	push   %ebx
80103bb4:	31 db                	xor    %ebx,%ebx
80103bb6:	8b 45 08             	mov    0x8(%ebp),%eax
    if(h->size == 0)
80103bb9:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
80103bbf:	85 d2                	test   %edx,%edx
80103bc1:	74 1a                	je     80103bdd <deleteheap+0x2d>

    // Store the root process (the largest element)
    struct proc* root = h->proc[0];

    // Replace the root process with the last process in the heap
    h->proc[0] = h->proc[h->size - 1];
80103bc3:	83 ea 01             	sub    $0x1,%edx
    struct proc* root = h->proc[0];
80103bc6:	8b 18                	mov    (%eax),%ebx
    h->proc[0] = h->proc[h->size - 1];
80103bc8:	8b 0c 90             	mov    (%eax,%edx,4),%ecx
    h->size--;
80103bcb:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
    h->proc[0] = h->proc[h->size - 1];
80103bd1:	89 08                	mov    %ecx,(%eax)

    // Heapify the heap after deletion
    heapify(h, 0);
80103bd3:	6a 00                	push   $0x0
80103bd5:	50                   	push   %eax
80103bd6:	e8 45 ff ff ff       	call   80103b20 <heapify>

    return root;
80103bdb:	58                   	pop    %eax
80103bdc:	5a                   	pop    %edx
}
80103bdd:	89 d8                	mov    %ebx,%eax
80103bdf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103be2:	c9                   	leave  
80103be3:	c3                   	ret    
80103be4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103beb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103bef:	90                   	nop

80103bf0 <insertheap>:
void
insertheap(struct heap* h, struct proc* p)
{
80103bf0:	55                   	push   %ebp
80103bf1:	89 e5                	mov    %esp,%ebp
80103bf3:	57                   	push   %edi
80103bf4:	56                   	push   %esi
80103bf5:	53                   	push   %ebx
80103bf6:	83 ec 04             	sub    $0x4,%esp
80103bf9:	8b 55 08             	mov    0x8(%ebp),%edx
80103bfc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if(h->size == NPROC)
80103bff:	8b b2 00 01 00 00    	mov    0x100(%edx),%esi
80103c05:	83 fe 40             	cmp    $0x40,%esi
80103c08:	74 3f                	je     80103c49 <insertheap+0x59>
    if (isfullheap(h))
        return;

    // Insert the new process at the end of the heap
    h->proc[h->size] = p;
    h->size++;
80103c0a:	8d 46 01             	lea    0x1(%esi),%eax
    h->proc[h->size] = p;
80103c0d:	89 1c b2             	mov    %ebx,(%edx,%esi,4)
    h->size++;
80103c10:	89 82 00 01 00 00    	mov    %eax,0x100(%edx)

    // Heapify the heap after insertion
    int i = h->size - 1;
    while (i != 0 && h->proc[(i - 1) / 2]->priority < h->proc[i]->priority) {
80103c16:	85 f6                	test   %esi,%esi
80103c18:	75 13                	jne    80103c2d <insertheap+0x3d>
80103c1a:	eb 2d                	jmp    80103c49 <insertheap+0x59>
80103c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        struct proc* temp = h->proc[i];
        h->proc[i] = h->proc[(i - 1) / 2];
80103c20:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80103c23:	89 3c 8a             	mov    %edi,(%edx,%ecx,4)
        h->proc[(i - 1) / 2] = temp;
80103c26:	89 1c 82             	mov    %ebx,(%edx,%eax,4)
    while (i != 0 && h->proc[(i - 1) / 2]->priority < h->proc[i]->priority) {
80103c29:	85 f6                	test   %esi,%esi
80103c2b:	74 1c                	je     80103c49 <insertheap+0x59>
80103c2d:	89 75 f0             	mov    %esi,-0x10(%ebp)
80103c30:	8d 76 ff             	lea    -0x1(%esi),%esi
80103c33:	8b 4b 7c             	mov    0x7c(%ebx),%ecx
80103c36:	89 f0                	mov    %esi,%eax
80103c38:	c1 e8 1f             	shr    $0x1f,%eax
80103c3b:	01 f0                	add    %esi,%eax
80103c3d:	d1 f8                	sar    %eax
80103c3f:	8b 3c 82             	mov    (%edx,%eax,4),%edi
80103c42:	89 c6                	mov    %eax,%esi
80103c44:	39 4f 7c             	cmp    %ecx,0x7c(%edi)
80103c47:	7c d7                	jl     80103c20 <insertheap+0x30>
        i = (i - 1) / 2;
    }
}
80103c49:	83 c4 04             	add    $0x4,%esp
80103c4c:	5b                   	pop    %ebx
80103c4d:	5e                   	pop    %esi
80103c4e:	5f                   	pop    %edi
80103c4f:	5d                   	pop    %ebp
80103c50:	c3                   	ret    
80103c51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c5f:	90                   	nop

80103c60 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	56                   	push   %esi
80103c64:	89 c6                	mov    %eax,%esi
80103c66:	53                   	push   %ebx
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103c67:	bb b4 32 11 80       	mov    $0x801132b4,%ebx
80103c6c:	eb 10                	jmp    80103c7e <wakeup1+0x1e>
80103c6e:	66 90                	xchg   %ax,%ax
80103c70:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103c76:	81 fb b4 55 11 80    	cmp    $0x801155b4,%ebx
80103c7c:	74 4d                	je     80103ccb <wakeup1+0x6b>
    if(p->state == SLEEPING && p->chan == chan) {
80103c7e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103c82:	75 ec                	jne    80103c70 <wakeup1+0x10>
80103c84:	39 73 20             	cmp    %esi,0x20(%ebx)
80103c87:	75 e7                	jne    80103c70 <wakeup1+0x10>
      p->state = RUNNABLE;
      if(p->monopoly == 0) {
80103c89:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
      p->state = RUNNABLE;
80103c8f:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
      if(p->monopoly == 0) {
80103c96:	85 c0                	test   %eax,%eax
80103c98:	75 d6                	jne    80103c70 <wakeup1+0x10>
  if(p->level < 3) {
80103c9a:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80103ca0:	83 f8 02             	cmp    $0x2,%eax
80103ca3:	7f 33                	jg     80103cd8 <wakeup1+0x78>
    insertqueue(&(mlfq.q[p->level]), p);
80103ca5:	69 c0 08 01 00 00    	imul   $0x108,%eax,%eax
80103cab:	83 ec 08             	sub    $0x8,%esp
80103cae:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103caf:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
    insertqueue(&(mlfq.q[p->level]), p);
80103cb5:	05 60 2e 11 80       	add    $0x80112e60,%eax
80103cba:	50                   	push   %eax
80103cbb:	e8 10 fd ff ff       	call   801039d0 <insertqueue>
80103cc0:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103cc3:	81 fb b4 55 11 80    	cmp    $0x801155b4,%ebx
80103cc9:	75 b3                	jne    80103c7e <wakeup1+0x1e>
        insertmlfq(p);
      }
    }
  }
}
80103ccb:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cce:	5b                   	pop    %ebx
80103ccf:	5e                   	pop    %esi
80103cd0:	5d                   	pop    %ebp
80103cd1:	c3                   	ret    
80103cd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    insertheap(&(mlfq.h), p);
80103cd8:	83 ec 08             	sub    $0x8,%esp
80103cdb:	53                   	push   %ebx
80103cdc:	68 78 31 11 80       	push   $0x80113178
80103ce1:	e8 0a ff ff ff       	call   80103bf0 <insertheap>
80103ce6:	83 c4 10             	add    $0x10,%esp
80103ce9:	eb 85                	jmp    80103c70 <wakeup1+0x10>
80103ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cef:	90                   	nop

80103cf0 <setpriority>:
setpriority(int pid, int priority) {
80103cf0:	55                   	push   %ebp
80103cf1:	89 e5                	mov    %esp,%ebp
80103cf3:	56                   	push   %esi
80103cf4:	8b 75 0c             	mov    0xc(%ebp),%esi
80103cf7:	53                   	push   %ebx
80103cf8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(priority < 0 || priority > 10) return -2;
80103cfb:	83 fe 0a             	cmp    $0xa,%esi
80103cfe:	77 6c                	ja     80103d6c <setpriority+0x7c>
  acquire(&ptable.lock);
80103d00:	83 ec 0c             	sub    $0xc,%esp
80103d03:	68 80 32 11 80       	push   $0x80113280
80103d08:	e8 13 14 00 00       	call   80105120 <acquire>
80103d0d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103d10:	b8 b4 32 11 80       	mov    $0x801132b4,%eax
80103d15:	eb 15                	jmp    80103d2c <setpriority+0x3c>
80103d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d1e:	66 90                	xchg   %ax,%ax
80103d20:	05 8c 00 00 00       	add    $0x8c,%eax
80103d25:	3d b4 55 11 80       	cmp    $0x801155b4,%eax
80103d2a:	74 24                	je     80103d50 <setpriority+0x60>
    if(p->pid == pid) {
80103d2c:	39 58 10             	cmp    %ebx,0x10(%eax)
80103d2f:	75 ef                	jne    80103d20 <setpriority+0x30>
      release(&ptable.lock);
80103d31:	83 ec 0c             	sub    $0xc,%esp
      p->priority = priority;
80103d34:	89 70 7c             	mov    %esi,0x7c(%eax)
      release(&ptable.lock);
80103d37:	68 80 32 11 80       	push   $0x80113280
80103d3c:	e8 7f 13 00 00       	call   801050c0 <release>
      return 0;
80103d41:	83 c4 10             	add    $0x10,%esp
80103d44:	31 c0                	xor    %eax,%eax
}
80103d46:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d49:	5b                   	pop    %ebx
80103d4a:	5e                   	pop    %esi
80103d4b:	5d                   	pop    %ebp
80103d4c:	c3                   	ret    
80103d4d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103d50:	83 ec 0c             	sub    $0xc,%esp
80103d53:	68 80 32 11 80       	push   $0x80113280
80103d58:	e8 63 13 00 00       	call   801050c0 <release>
  return -1;
80103d5d:	83 c4 10             	add    $0x10,%esp
}
80103d60:	8d 65 f8             	lea    -0x8(%ebp),%esp
  return -1;
80103d63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103d68:	5b                   	pop    %ebx
80103d69:	5e                   	pop    %esi
80103d6a:	5d                   	pop    %ebp
80103d6b:	c3                   	ret    
  if(priority < 0 || priority > 10) return -2;
80103d6c:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80103d71:	eb d3                	jmp    80103d46 <setpriority+0x56>
80103d73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d80 <insertmlfq>:
insertmlfq(struct proc *p) {
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	83 ec 08             	sub    $0x8,%esp
80103d86:	8b 55 08             	mov    0x8(%ebp),%edx
  if(p->level < 3) {
80103d89:	8b 82 80 00 00 00    	mov    0x80(%edx),%eax
80103d8f:	83 f8 02             	cmp    $0x2,%eax
80103d92:	7f 1c                	jg     80103db0 <insertmlfq+0x30>
    insertqueue(&(mlfq.q[p->level]), p);
80103d94:	69 c0 08 01 00 00    	imul   $0x108,%eax,%eax
80103d9a:	83 ec 08             	sub    $0x8,%esp
80103d9d:	52                   	push   %edx
80103d9e:	05 60 2e 11 80       	add    $0x80112e60,%eax
80103da3:	50                   	push   %eax
80103da4:	e8 27 fc ff ff       	call   801039d0 <insertqueue>
80103da9:	83 c4 10             	add    $0x10,%esp
}
80103dac:	c9                   	leave  
80103dad:	c3                   	ret    
80103dae:	66 90                	xchg   %ax,%ax
    insertheap(&(mlfq.h), p);
80103db0:	83 ec 08             	sub    $0x8,%esp
80103db3:	52                   	push   %edx
80103db4:	68 78 31 11 80       	push   $0x80113178
80103db9:	e8 32 fe ff ff       	call   80103bf0 <insertheap>
80103dbe:	83 c4 10             	add    $0x10,%esp
}
80103dc1:	c9                   	leave  
80103dc2:	c3                   	ret    
80103dc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103dd0 <insertmoq>:
insertmoq(struct proc *p) {
80103dd0:	55                   	push   %ebp
    if(q->front == 0 && q->rear == NPROC - 1)
80103dd1:	8b 15 44 2e 11 80    	mov    0x80112e44,%edx
80103dd7:	89 e5                	mov    %esp,%ebp
80103dd9:	56                   	push   %esi
80103dda:	8b 35 40 2e 11 80    	mov    0x80112e40,%esi
80103de0:	53                   	push   %ebx
80103de1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103de4:	85 f6                	test   %esi,%esi
80103de6:	75 05                	jne    80103ded <insertmoq+0x1d>
80103de8:	83 fa 3f             	cmp    $0x3f,%edx
80103deb:	74 3b                	je     80103e28 <insertmoq+0x58>
    if(q->front == (q->rear + 1) % NPROC)
80103ded:	8d 42 01             	lea    0x1(%edx),%eax
80103df0:	89 c1                	mov    %eax,%ecx
80103df2:	c1 f9 1f             	sar    $0x1f,%ecx
80103df5:	c1 e9 1a             	shr    $0x1a,%ecx
80103df8:	01 c8                	add    %ecx,%eax
80103dfa:	83 e0 3f             	and    $0x3f,%eax
80103dfd:	29 c8                	sub    %ecx,%eax
80103dff:	39 c6                	cmp    %eax,%esi
80103e01:	74 25                	je     80103e28 <insertmoq+0x58>
    q->proc[q->rear % NPROC] = p;
80103e03:	89 d1                	mov    %edx,%ecx
    q->rear = (q->rear + 1) % NPROC;
80103e05:	a3 44 2e 11 80       	mov    %eax,0x80112e44
    q->proc[q->rear % NPROC] = p;
80103e0a:	c1 f9 1f             	sar    $0x1f,%ecx
80103e0d:	c1 e9 1a             	shr    $0x1a,%ecx
80103e10:	01 ca                	add    %ecx,%edx
80103e12:	83 e2 3f             	and    $0x3f,%edx
80103e15:	29 ca                	sub    %ecx,%edx
80103e17:	89 1c 95 40 2d 11 80 	mov    %ebx,-0x7feed2c0(,%edx,4)
}
80103e1e:	5b                   	pop    %ebx
80103e1f:	5e                   	pop    %esi
80103e20:	5d                   	pop    %ebp
80103e21:	c3                   	ret    
80103e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e28:	5b                   	pop    %ebx
80103e29:	5e                   	pop    %esi
        cprintf("Queue is full\n");
80103e2a:	c7 45 08 e0 84 10 80 	movl   $0x801084e0,0x8(%ebp)
80103e31:	5d                   	pop    %ebp
80103e32:	e9 69 c8 ff ff       	jmp    801006a0 <cprintf>
80103e37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e3e:	66 90                	xchg   %ax,%ax

80103e40 <priorityboosting>:
priorityboosting(void) {
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103e44:	bb b4 32 11 80       	mov    $0x801132b4,%ebx
priorityboosting(void) {
80103e49:	83 ec 04             	sub    $0x4,%esp
    q->front = 0;
80103e4c:	c7 05 60 2f 11 80 00 	movl   $0x0,0x80112f60
80103e53:	00 00 00 
    q->rear = 0;
80103e56:	c7 05 64 2f 11 80 00 	movl   $0x0,0x80112f64
80103e5d:	00 00 00 
    q->front = 0;
80103e60:	c7 05 68 30 11 80 00 	movl   $0x0,0x80113068
80103e67:	00 00 00 
    q->rear = 0;
80103e6a:	c7 05 6c 30 11 80 00 	movl   $0x0,0x8011306c
80103e71:	00 00 00 
    q->front = 0;
80103e74:	c7 05 70 31 11 80 00 	movl   $0x0,0x80113170
80103e7b:	00 00 00 
    q->rear = 0;
80103e7e:	c7 05 74 31 11 80 00 	movl   $0x0,0x80113174
80103e85:	00 00 00 
    h->size = 0;
80103e88:	c7 05 78 32 11 80 00 	movl   $0x0,0x80113278
80103e8f:	00 00 00 
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103e92:	eb 12                	jmp    80103ea6 <priorityboosting+0x66>
80103e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e98:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103e9e:	81 fb b4 55 11 80    	cmp    $0x801155b4,%ebx
80103ea4:	74 3d                	je     80103ee3 <priorityboosting+0xa3>
    if(p->state == RUNNABLE && p->monopoly == 0) {
80103ea6:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103eaa:	75 ec                	jne    80103e98 <priorityboosting+0x58>
80103eac:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80103eb2:	85 c0                	test   %eax,%eax
80103eb4:	75 e2                	jne    80103e98 <priorityboosting+0x58>
      insertqueue(&(mlfq.q[0]), p);
80103eb6:	83 ec 08             	sub    $0x8,%esp
80103eb9:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103eba:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
      insertqueue(&(mlfq.q[0]), p);
80103ec0:	68 60 2e 11 80       	push   $0x80112e60
80103ec5:	e8 06 fb ff ff       	call   801039d0 <insertqueue>
      p->tq = 0;
80103eca:	c7 43 f8 00 00 00 00 	movl   $0x0,-0x8(%ebx)
      p->level = 0;
80103ed1:	83 c4 10             	add    $0x10,%esp
80103ed4:	c7 43 f4 00 00 00 00 	movl   $0x0,-0xc(%ebx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103edb:	81 fb b4 55 11 80    	cmp    $0x801155b4,%ebx
80103ee1:	75 c3                	jne    80103ea6 <priorityboosting+0x66>
}
80103ee3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ee6:	c9                   	leave  
80103ee7:	c3                   	ret    
80103ee8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eef:	90                   	nop

80103ef0 <pinit>:
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103ef6:	68 ff 84 10 80       	push   $0x801084ff
80103efb:	68 80 32 11 80       	push   $0x80113280
80103f00:	e8 4b 10 00 00       	call   80104f50 <initlock>
}
80103f05:	83 c4 10             	add    $0x10,%esp
80103f08:	c9                   	leave  
80103f09:	c3                   	ret    
80103f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103f10 <mycpu>:
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	56                   	push   %esi
80103f14:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f15:	9c                   	pushf  
80103f16:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f17:	f6 c4 02             	test   $0x2,%ah
80103f1a:	75 46                	jne    80103f62 <mycpu+0x52>
  apicid = lapicid();
80103f1c:	e8 cf e9 ff ff       	call   801028f0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103f21:	8b 35 84 27 11 80    	mov    0x80112784,%esi
80103f27:	85 f6                	test   %esi,%esi
80103f29:	7e 2a                	jle    80103f55 <mycpu+0x45>
80103f2b:	31 d2                	xor    %edx,%edx
80103f2d:	eb 08                	jmp    80103f37 <mycpu+0x27>
80103f2f:	90                   	nop
80103f30:	83 c2 01             	add    $0x1,%edx
80103f33:	39 f2                	cmp    %esi,%edx
80103f35:	74 1e                	je     80103f55 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103f37:	69 ca b4 00 00 00    	imul   $0xb4,%edx,%ecx
80103f3d:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103f44:	39 c3                	cmp    %eax,%ebx
80103f46:	75 e8                	jne    80103f30 <mycpu+0x20>
}
80103f48:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103f4b:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80103f51:	5b                   	pop    %ebx
80103f52:	5e                   	pop    %esi
80103f53:	5d                   	pop    %ebp
80103f54:	c3                   	ret    
  panic("unknown apicid\n");
80103f55:	83 ec 0c             	sub    $0xc,%esp
80103f58:	68 06 85 10 80       	push   $0x80108506
80103f5d:	e8 1e c4 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103f62:	83 ec 0c             	sub    $0xc,%esp
80103f65:	68 ec 85 10 80       	push   $0x801085ec
80103f6a:	e8 11 c4 ff ff       	call   80100380 <panic>
80103f6f:	90                   	nop

80103f70 <monopolize>:
monopolize(void) {
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	83 ec 08             	sub    $0x8,%esp
  pushcli();
80103f76:	e8 55 10 00 00       	call   80104fd0 <pushcli>
  struct cpu *c = mycpu();
80103f7b:	e8 90 ff ff ff       	call   80103f10 <mycpu>
  c->monopoly = 1;
80103f80:	c7 80 b0 00 00 00 01 	movl   $0x1,0xb0(%eax)
80103f87:	00 00 00 
}
80103f8a:	c9                   	leave  
  popcli();
80103f8b:	e9 90 10 00 00       	jmp    80105020 <popcli>

80103f90 <unmonopolize>:
unmonopolize(void) {
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	83 ec 08             	sub    $0x8,%esp
  pushcli();
80103f96:	e8 35 10 00 00       	call   80104fd0 <pushcli>
  struct cpu *c = mycpu();
80103f9b:	e8 70 ff ff ff       	call   80103f10 <mycpu>
  ticks = 0;
80103fa0:	c7 05 c0 55 11 80 00 	movl   $0x0,0x801155c0
80103fa7:	00 00 00 
  c->monopoly = 0;
80103faa:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103fb1:	00 00 00 
}
80103fb4:	c9                   	leave  
  popcli();
80103fb5:	e9 66 10 00 00       	jmp    80105020 <popcli>
80103fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103fc0 <cpuid>:
cpuid() {
80103fc0:	55                   	push   %ebp
80103fc1:	89 e5                	mov    %esp,%ebp
80103fc3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103fc6:	e8 45 ff ff ff       	call   80103f10 <mycpu>
}
80103fcb:	c9                   	leave  
  return mycpu()-cpus;
80103fcc:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103fd1:	c1 f8 02             	sar    $0x2,%eax
80103fd4:	69 c0 a5 4f fa a4    	imul   $0xa4fa4fa5,%eax,%eax
}
80103fda:	c3                   	ret    
80103fdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fdf:	90                   	nop

80103fe0 <getlev>:
getlev(void) {
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	53                   	push   %ebx
80103fe4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103fe7:	e8 e4 0f 00 00       	call   80104fd0 <pushcli>
  c = mycpu();
80103fec:	e8 1f ff ff ff       	call   80103f10 <mycpu>
  p = c->proc;
80103ff1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ff7:	e8 24 10 00 00       	call   80105020 <popcli>
  return myproc()->level;
80103ffc:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
}
80104002:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104005:	c9                   	leave  
80104006:	c3                   	ret    
80104007:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010400e:	66 90                	xchg   %ax,%ax

80104010 <myproc>:
myproc(void) {
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	53                   	push   %ebx
80104014:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104017:	e8 b4 0f 00 00       	call   80104fd0 <pushcli>
  c = mycpu();
8010401c:	e8 ef fe ff ff       	call   80103f10 <mycpu>
  p = c->proc;
80104021:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104027:	e8 f4 0f 00 00       	call   80105020 <popcli>
}
8010402c:	89 d8                	mov    %ebx,%eax
8010402e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104031:	c9                   	leave  
80104032:	c3                   	ret    
80104033:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010403a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104040 <userinit>:
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	53                   	push   %ebx
80104044:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80104047:	e8 64 f7 ff ff       	call   801037b0 <allocproc>
8010404c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010404e:	a3 b4 55 11 80       	mov    %eax,0x801155b4
  if((p->pgdir = setupkvm()) == 0)
80104053:	e8 f8 3b 00 00       	call   80107c50 <setupkvm>
80104058:	89 43 04             	mov    %eax,0x4(%ebx)
8010405b:	85 c0                	test   %eax,%eax
8010405d:	0f 84 f7 00 00 00    	je     8010415a <userinit+0x11a>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104063:	83 ec 04             	sub    $0x4,%esp
80104066:	68 2c 00 00 00       	push   $0x2c
8010406b:	68 60 b4 10 80       	push   $0x8010b460
80104070:	50                   	push   %eax
80104071:	e8 8a 38 00 00       	call   80107900 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104076:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104079:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010407f:	6a 4c                	push   $0x4c
80104081:	6a 00                	push   $0x0
80104083:	ff 73 18             	push   0x18(%ebx)
80104086:	e8 55 11 00 00       	call   801051e0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010408b:	8b 43 18             	mov    0x18(%ebx),%eax
8010408e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104093:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104096:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010409b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010409f:	8b 43 18             	mov    0x18(%ebx),%eax
801040a2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801040a6:	8b 43 18             	mov    0x18(%ebx),%eax
801040a9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801040ad:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801040b1:	8b 43 18             	mov    0x18(%ebx),%eax
801040b4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801040b8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801040bc:	8b 43 18             	mov    0x18(%ebx),%eax
801040bf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801040c6:	8b 43 18             	mov    0x18(%ebx),%eax
801040c9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801040d0:	8b 43 18             	mov    0x18(%ebx),%eax
801040d3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801040da:	8d 43 6c             	lea    0x6c(%ebx),%eax
801040dd:	6a 10                	push   $0x10
801040df:	68 2f 85 10 80       	push   $0x8010852f
801040e4:	50                   	push   %eax
801040e5:	e8 b6 12 00 00       	call   801053a0 <safestrcpy>
  p->cwd = namei("/");
801040ea:	c7 04 24 38 85 10 80 	movl   $0x80108538,(%esp)
801040f1:	e8 aa df ff ff       	call   801020a0 <namei>
801040f6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801040f9:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80104100:	e8 1b 10 00 00       	call   80105120 <acquire>
  if(p->level < 3) {
80104105:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
8010410b:	83 c4 10             	add    $0x10,%esp
8010410e:	83 f8 02             	cmp    $0x2,%eax
80104111:	7e 2d                	jle    80104140 <userinit+0x100>
    insertheap(&(mlfq.h), p);
80104113:	83 ec 08             	sub    $0x8,%esp
80104116:	53                   	push   %ebx
80104117:	68 78 31 11 80       	push   $0x80113178
8010411c:	e8 cf fa ff ff       	call   80103bf0 <insertheap>
80104121:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104124:	83 ec 0c             	sub    $0xc,%esp
  p->state = RUNNABLE;
80104127:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010412e:	68 80 32 11 80       	push   $0x80113280
80104133:	e8 88 0f 00 00       	call   801050c0 <release>
}
80104138:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010413b:	83 c4 10             	add    $0x10,%esp
8010413e:	c9                   	leave  
8010413f:	c3                   	ret    
    insertqueue(&(mlfq.q[p->level]), p);
80104140:	69 c0 08 01 00 00    	imul   $0x108,%eax,%eax
80104146:	83 ec 08             	sub    $0x8,%esp
80104149:	53                   	push   %ebx
8010414a:	05 60 2e 11 80       	add    $0x80112e60,%eax
8010414f:	50                   	push   %eax
80104150:	e8 7b f8 ff ff       	call   801039d0 <insertqueue>
80104155:	83 c4 10             	add    $0x10,%esp
80104158:	eb ca                	jmp    80104124 <userinit+0xe4>
    panic("userinit: out of memory?");
8010415a:	83 ec 0c             	sub    $0xc,%esp
8010415d:	68 16 85 10 80       	push   $0x80108516
80104162:	e8 19 c2 ff ff       	call   80100380 <panic>
80104167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010416e:	66 90                	xchg   %ax,%ax

80104170 <growproc>:
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	56                   	push   %esi
80104174:	53                   	push   %ebx
80104175:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80104178:	e8 53 0e 00 00       	call   80104fd0 <pushcli>
  c = mycpu();
8010417d:	e8 8e fd ff ff       	call   80103f10 <mycpu>
  p = c->proc;
80104182:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104188:	e8 93 0e 00 00       	call   80105020 <popcli>
  sz = curproc->sz;
8010418d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
8010418f:	85 f6                	test   %esi,%esi
80104191:	7f 1d                	jg     801041b0 <growproc+0x40>
  } else if(n < 0){
80104193:	75 3b                	jne    801041d0 <growproc+0x60>
  switchuvm(curproc);
80104195:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80104198:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010419a:	53                   	push   %ebx
8010419b:	e8 50 36 00 00       	call   801077f0 <switchuvm>
  return 0;
801041a0:	83 c4 10             	add    $0x10,%esp
801041a3:	31 c0                	xor    %eax,%eax
}
801041a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041a8:	5b                   	pop    %ebx
801041a9:	5e                   	pop    %esi
801041aa:	5d                   	pop    %ebp
801041ab:	c3                   	ret    
801041ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801041b0:	83 ec 04             	sub    $0x4,%esp
801041b3:	01 c6                	add    %eax,%esi
801041b5:	56                   	push   %esi
801041b6:	50                   	push   %eax
801041b7:	ff 73 04             	push   0x4(%ebx)
801041ba:	e8 b1 38 00 00       	call   80107a70 <allocuvm>
801041bf:	83 c4 10             	add    $0x10,%esp
801041c2:	85 c0                	test   %eax,%eax
801041c4:	75 cf                	jne    80104195 <growproc+0x25>
      return -1;
801041c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041cb:	eb d8                	jmp    801041a5 <growproc+0x35>
801041cd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801041d0:	83 ec 04             	sub    $0x4,%esp
801041d3:	01 c6                	add    %eax,%esi
801041d5:	56                   	push   %esi
801041d6:	50                   	push   %eax
801041d7:	ff 73 04             	push   0x4(%ebx)
801041da:	e8 c1 39 00 00       	call   80107ba0 <deallocuvm>
801041df:	83 c4 10             	add    $0x10,%esp
801041e2:	85 c0                	test   %eax,%eax
801041e4:	75 af                	jne    80104195 <growproc+0x25>
801041e6:	eb de                	jmp    801041c6 <growproc+0x56>
801041e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041ef:	90                   	nop

801041f0 <fork>:
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	57                   	push   %edi
801041f4:	56                   	push   %esi
801041f5:	53                   	push   %ebx
801041f6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801041f9:	e8 d2 0d 00 00       	call   80104fd0 <pushcli>
  c = mycpu();
801041fe:	e8 0d fd ff ff       	call   80103f10 <mycpu>
  p = c->proc;
80104203:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104209:	e8 12 0e 00 00       	call   80105020 <popcli>
  if((np = allocproc()) == 0){
8010420e:	e8 9d f5 ff ff       	call   801037b0 <allocproc>
80104213:	85 c0                	test   %eax,%eax
80104215:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104218:	0f 84 ee 00 00 00    	je     8010430c <fork+0x11c>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
8010421e:	83 ec 08             	sub    $0x8,%esp
80104221:	ff 33                	push   (%ebx)
80104223:	ff 73 04             	push   0x4(%ebx)
80104226:	e8 15 3b 00 00       	call   80107d40 <copyuvm>
8010422b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010422e:	83 c4 10             	add    $0x10,%esp
80104231:	89 42 04             	mov    %eax,0x4(%edx)
80104234:	85 c0                	test   %eax,%eax
80104236:	0f 84 d7 00 00 00    	je     80104313 <fork+0x123>
  np->sz = curproc->sz;
8010423c:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
8010423e:	8b 7a 18             	mov    0x18(%edx),%edi
  np->parent = curproc;
80104241:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80104244:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80104249:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
8010424b:	8b 73 18             	mov    0x18(%ebx),%esi
8010424e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104250:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104252:	8b 42 18             	mov    0x18(%edx),%eax
80104255:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
8010425c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80104260:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104264:	85 c0                	test   %eax,%eax
80104266:	74 16                	je     8010427e <fork+0x8e>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104268:	83 ec 0c             	sub    $0xc,%esp
8010426b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010426e:	50                   	push   %eax
8010426f:	e8 2c cc ff ff       	call   80100ea0 <filedup>
80104274:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104277:	83 c4 10             	add    $0x10,%esp
8010427a:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010427e:	83 c6 01             	add    $0x1,%esi
80104281:	83 fe 10             	cmp    $0x10,%esi
80104284:	75 da                	jne    80104260 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80104286:	83 ec 0c             	sub    $0xc,%esp
80104289:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010428c:	83 c3 6c             	add    $0x6c,%ebx
8010428f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  np->cwd = idup(curproc->cwd);
80104292:	e8 b9 d4 ff ff       	call   80101750 <idup>
80104297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010429a:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010429d:	89 42 68             	mov    %eax,0x68(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801042a0:	8d 42 6c             	lea    0x6c(%edx),%eax
801042a3:	6a 10                	push   $0x10
801042a5:	53                   	push   %ebx
801042a6:	50                   	push   %eax
801042a7:	e8 f4 10 00 00       	call   801053a0 <safestrcpy>
  pid = np->pid;
801042ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801042af:	8b 5a 10             	mov    0x10(%edx),%ebx
  acquire(&ptable.lock);
801042b2:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
801042b9:	e8 62 0e 00 00       	call   80105120 <acquire>
  np->state = RUNNABLE;
801042be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801042c1:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  np->level = 0;
801042c8:	c7 82 80 00 00 00 00 	movl   $0x0,0x80(%edx)
801042cf:	00 00 00 
  np->tq = 0;
801042d2:	c7 82 84 00 00 00 00 	movl   $0x0,0x84(%edx)
801042d9:	00 00 00 
  np->monopoly = 0;
801042dc:	c7 82 88 00 00 00 00 	movl   $0x0,0x88(%edx)
801042e3:	00 00 00 
    insertqueue(&(mlfq.q[p->level]), p);
801042e6:	58                   	pop    %eax
801042e7:	59                   	pop    %ecx
801042e8:	52                   	push   %edx
801042e9:	68 60 2e 11 80       	push   $0x80112e60
801042ee:	e8 dd f6 ff ff       	call   801039d0 <insertqueue>
  release(&ptable.lock);
801042f3:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
801042fa:	e8 c1 0d 00 00       	call   801050c0 <release>
  return pid;
801042ff:	83 c4 10             	add    $0x10,%esp
}
80104302:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104305:	89 d8                	mov    %ebx,%eax
80104307:	5b                   	pop    %ebx
80104308:	5e                   	pop    %esi
80104309:	5f                   	pop    %edi
8010430a:	5d                   	pop    %ebp
8010430b:	c3                   	ret    
    return -1;
8010430c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104311:	eb ef                	jmp    80104302 <fork+0x112>
    kfree(np->kstack);
80104313:	83 ec 0c             	sub    $0xc,%esp
80104316:	ff 72 08             	push   0x8(%edx)
    return -1;
80104319:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
8010431e:	e8 9d e1 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80104323:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    return -1;
80104326:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104329:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
    np->state = UNUSED;
80104330:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
    return -1;
80104337:	eb c9                	jmp    80104302 <fork+0x112>
80104339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104340 <scheduler>:
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	57                   	push   %edi
80104344:	56                   	push   %esi
80104345:	53                   	push   %ebx
80104346:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80104349:	e8 c2 fb ff ff       	call   80103f10 <mycpu>
  c->proc = 0;
8010434e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104355:	00 00 00 
  struct cpu *c = mycpu();
80104358:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  c->proc = 0;
8010435b:	83 c0 04             	add    $0x4,%eax
8010435e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80104368:	fb                   	sti    
    acquire(&ptable.lock);
80104369:	83 ec 0c             	sub    $0xc,%esp
8010436c:	68 80 32 11 80       	push   $0x80113280
80104371:	e8 aa 0d 00 00       	call   80105120 <acquire>
    if(c->monopoly == 0)  {
80104376:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104379:	83 c4 10             	add    $0x10,%esp
8010437c:	8b 90 b0 00 00 00    	mov    0xb0(%eax),%edx
80104382:	85 d2                	test   %edx,%edx
80104384:	0f 85 3e 01 00 00    	jne    801044c8 <scheduler+0x188>
8010438a:	bf 60 2e 11 80       	mov    $0x80112e60,%edi
    if(q->front % NPROC == q->rear % NPROC)
8010438f:	8b 87 00 01 00 00    	mov    0x100(%edi),%eax
80104395:	89 c1                	mov    %eax,%ecx
80104397:	c1 f9 1f             	sar    $0x1f,%ecx
8010439a:	c1 e9 1a             	shr    $0x1a,%ecx
8010439d:	8d 1c 08             	lea    (%eax,%ecx,1),%ebx
801043a0:	83 e3 3f             	and    $0x3f,%ebx
801043a3:	29 cb                	sub    %ecx,%ebx
801043a5:	8b 8f 04 01 00 00    	mov    0x104(%edi),%ecx
801043ab:	89 ce                	mov    %ecx,%esi
801043ad:	c1 fe 1f             	sar    $0x1f,%esi
801043b0:	c1 ee 1a             	shr    $0x1a,%esi
801043b3:	01 f1                	add    %esi,%ecx
801043b5:	83 e1 3f             	and    $0x3f,%ecx
801043b8:	29 f1                	sub    %esi,%ecx
801043ba:	39 cb                	cmp    %ecx,%ebx
801043bc:	0f 84 7e 01 00 00    	je     80104540 <scheduler+0x200>
    p = q->proc[q->front % NPROC];
801043c2:	6b ca 42             	imul   $0x42,%edx,%ecx
    q->front = (q->front + 1) % NPROC;
801043c5:	83 c0 01             	add    $0x1,%eax
801043c8:	69 d2 08 01 00 00    	imul   $0x108,%edx,%edx
    p = q->proc[q->front % NPROC];
801043ce:	01 d9                	add    %ebx,%ecx
801043d0:	8b 1c 8d 60 2e 11 80 	mov    -0x7feed1a0(,%ecx,4),%ebx
    q->front = (q->front + 1) % NPROC;
801043d7:	89 c1                	mov    %eax,%ecx
801043d9:	c1 f9 1f             	sar    $0x1f,%ecx
801043dc:	c1 e9 1a             	shr    $0x1a,%ecx
801043df:	01 c8                	add    %ecx,%eax
801043e1:	83 e0 3f             	and    $0x3f,%eax
801043e4:	29 c8                	sub    %ecx,%eax
801043e6:	89 82 60 2f 11 80    	mov    %eax,-0x7feed0a0(%edx)
          if(p->monopoly == 1 || p->state != RUNNABLE) {
801043ec:	83 bb 88 00 00 00 01 	cmpl   $0x1,0x88(%ebx)
801043f3:	74 06                	je     801043fb <scheduler+0xbb>
801043f5:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801043f9:	74 4d                	je     80104448 <scheduler+0x108>
    if(h->size == 0)
801043fb:	a1 78 32 11 80       	mov    0x80113278,%eax
80104400:	85 c0                	test   %eax,%eax
80104402:	74 7c                	je     80104480 <scheduler+0x140>
    heapify(h, 0);
80104404:	83 ec 08             	sub    $0x8,%esp
    h->proc[0] = h->proc[h->size - 1];
80104407:	83 e8 01             	sub    $0x1,%eax
    struct proc* root = h->proc[0];
8010440a:	8b 1d 78 31 11 80    	mov    0x80113178,%ebx
    heapify(h, 0);
80104410:	6a 00                	push   $0x0
    h->proc[0] = h->proc[h->size - 1];
80104412:	8b 14 85 78 31 11 80 	mov    -0x7feece88(,%eax,4),%edx
    heapify(h, 0);
80104419:	68 78 31 11 80       	push   $0x80113178
    h->proc[0] = h->proc[h->size - 1];
8010441e:	89 15 78 31 11 80    	mov    %edx,0x80113178
    h->size--;
80104424:	a3 78 32 11 80       	mov    %eax,0x80113278
    heapify(h, 0);
80104429:	e8 f2 f6 ff ff       	call   80103b20 <heapify>
          if(p->monopoly == 1 || p->state != RUNNABLE) {
8010442e:	83 c4 10             	add    $0x10,%esp
80104431:	83 bb 88 00 00 00 01 	cmpl   $0x1,0x88(%ebx)
80104438:	0f 84 2a ff ff ff    	je     80104368 <scheduler+0x28>
8010443e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104442:	0f 85 20 ff ff ff    	jne    80104368 <scheduler+0x28>
          c->proc = p;
80104448:	8b 7d e4             	mov    -0x1c(%ebp),%edi
          switchuvm(p);
8010444b:	83 ec 0c             	sub    $0xc,%esp
          c->proc = p;
8010444e:	89 9f ac 00 00 00    	mov    %ebx,0xac(%edi)
          switchuvm(p);
80104454:	53                   	push   %ebx
80104455:	e8 96 33 00 00       	call   801077f0 <switchuvm>
          p->state = RUNNING;
8010445a:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
          swtch(&(c->scheduler), p->context);
80104461:	59                   	pop    %ecx
80104462:	5e                   	pop    %esi
80104463:	ff 73 1c             	push   0x1c(%ebx)
80104466:	ff 75 e0             	push   -0x20(%ebp)
80104469:	e8 8d 0f 00 00       	call   801053fb <swtch>
          switchkvm();
8010446e:	e8 6d 33 00 00       	call   801077e0 <switchkvm>
          c->proc = 0;
80104473:	83 c4 10             	add    $0x10,%esp
80104476:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
8010447d:	00 00 00 
      if(ticks % 100 == 0 && ticks != 0) {
80104480:	8b 15 c0 55 11 80    	mov    0x801155c0,%edx
80104486:	69 c2 29 5c 8f c2    	imul   $0xc28f5c29,%edx,%eax
8010448c:	c1 c8 02             	ror    $0x2,%eax
8010448f:	3d 28 5c 8f 02       	cmp    $0x28f5c28,%eax
80104494:	77 1a                	ja     801044b0 <scheduler+0x170>
80104496:	85 d2                	test   %edx,%edx
80104498:	74 16                	je     801044b0 <scheduler+0x170>
        priorityboosting();
8010449a:	e8 a1 f9 ff ff       	call   80103e40 <priorityboosting>
        ticks = 0;
8010449f:	c7 05 c0 55 11 80 00 	movl   $0x0,0x801155c0
801044a6:	00 00 00 
801044a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&ptable.lock); 
801044b0:	83 ec 0c             	sub    $0xc,%esp
801044b3:	68 80 32 11 80       	push   $0x80113280
801044b8:	e8 03 0c 00 00       	call   801050c0 <release>
801044bd:	83 c4 10             	add    $0x10,%esp
801044c0:	e9 a3 fe ff ff       	jmp    80104368 <scheduler+0x28>
801044c5:	8d 76 00             	lea    0x0(%esi),%esi
    } else if (c->monopoly == 1){
801044c8:	83 fa 01             	cmp    $0x1,%edx
801044cb:	75 e3                	jne    801044b0 <scheduler+0x170>
    if(q->front % NPROC == q->rear % NPROC)
801044cd:	a1 40 2e 11 80       	mov    0x80112e40,%eax
801044d2:	99                   	cltd   
801044d3:	c1 ea 1a             	shr    $0x1a,%edx
801044d6:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
801044d9:	83 e1 3f             	and    $0x3f,%ecx
801044dc:	29 d1                	sub    %edx,%ecx
801044de:	8b 15 44 2e 11 80    	mov    0x80112e44,%edx
801044e4:	89 d3                	mov    %edx,%ebx
801044e6:	c1 fb 1f             	sar    $0x1f,%ebx
801044e9:	c1 eb 1a             	shr    $0x1a,%ebx
801044ec:	01 da                	add    %ebx,%edx
801044ee:	83 e2 3f             	and    $0x3f,%edx
801044f1:	29 da                	sub    %ebx,%edx
801044f3:	39 d1                	cmp    %edx,%ecx
801044f5:	0f 84 a5 00 00 00    	je     801045a0 <scheduler+0x260>
    q->front = (q->front + 1) % NPROC;
801044fb:	83 c0 01             	add    $0x1,%eax
    p = q->proc[q->front % NPROC];
801044fe:	8b 1c 8d 40 2d 11 80 	mov    -0x7feed2c0(,%ecx,4),%ebx
    q->front = (q->front + 1) % NPROC;
80104505:	99                   	cltd   
80104506:	c1 ea 1a             	shr    $0x1a,%edx
80104509:	01 d0                	add    %edx,%eax
8010450b:	83 e0 3f             	and    $0x3f,%eax
8010450e:	29 d0                	sub    %edx,%eax
80104510:	a3 40 2e 11 80       	mov    %eax,0x80112e40
        if(p->state != RUNNABLE) {
80104515:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104519:	74 45                	je     80104560 <scheduler+0x220>
  insertqueue(&(moq.q), p);
8010451b:	83 ec 08             	sub    $0x8,%esp
8010451e:	53                   	push   %ebx
8010451f:	68 40 2d 11 80       	push   $0x80112d40
80104524:	e8 a7 f4 ff ff       	call   801039d0 <insertqueue>
          release(&ptable.lock);
80104529:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80104530:	e8 8b 0b 00 00       	call   801050c0 <release>
          continue;
80104535:	83 c4 10             	add    $0x10,%esp
80104538:	e9 2b fe ff ff       	jmp    80104368 <scheduler+0x28>
8010453d:	8d 76 00             	lea    0x0(%esi),%esi
      for(int i = 0; i < 3; i++){
80104540:	83 c2 01             	add    $0x1,%edx
80104543:	81 c7 08 01 00 00    	add    $0x108,%edi
80104549:	83 fa 03             	cmp    $0x3,%edx
8010454c:	0f 84 a9 fe ff ff    	je     801043fb <scheduler+0xbb>
80104552:	e9 38 fe ff ff       	jmp    8010438f <scheduler+0x4f>
80104557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010455e:	66 90                	xchg   %ax,%ax
        c->proc = p;
80104560:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        switchuvm(p);
80104563:	83 ec 0c             	sub    $0xc,%esp
        c->proc = p;
80104566:	89 9f ac 00 00 00    	mov    %ebx,0xac(%edi)
        switchuvm(p);
8010456c:	53                   	push   %ebx
8010456d:	e8 7e 32 00 00       	call   801077f0 <switchuvm>
        p->state = RUNNING;
80104572:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
        swtch(&(c->scheduler), p->context);
80104579:	58                   	pop    %eax
8010457a:	5a                   	pop    %edx
8010457b:	ff 73 1c             	push   0x1c(%ebx)
8010457e:	ff 75 e0             	push   -0x20(%ebp)
80104581:	e8 75 0e 00 00       	call   801053fb <swtch>
        switchkvm();
80104586:	e8 55 32 00 00       	call   801077e0 <switchkvm>
        c->proc = 0;
8010458b:	83 c4 10             	add    $0x10,%esp
8010458e:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
80104595:	00 00 00 
80104598:	e9 13 ff ff ff       	jmp    801044b0 <scheduler+0x170>
8010459d:	8d 76 00             	lea    0x0(%esi),%esi
  pushcli();
801045a0:	e8 2b 0a 00 00       	call   80104fd0 <pushcli>
  struct cpu *c = mycpu();
801045a5:	e8 66 f9 ff ff       	call   80103f10 <mycpu>
  ticks = 0;
801045aa:	c7 05 c0 55 11 80 00 	movl   $0x0,0x801155c0
801045b1:	00 00 00 
  c->monopoly = 0;
801045b4:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801045bb:	00 00 00 
  popcli();
801045be:	e8 5d 0a 00 00       	call   80105020 <popcli>
}
801045c3:	e9 e8 fe ff ff       	jmp    801044b0 <scheduler+0x170>
801045c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045cf:	90                   	nop

801045d0 <sched>:
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	56                   	push   %esi
801045d4:	53                   	push   %ebx
  pushcli();
801045d5:	e8 f6 09 00 00       	call   80104fd0 <pushcli>
  c = mycpu();
801045da:	e8 31 f9 ff ff       	call   80103f10 <mycpu>
  p = c->proc;
801045df:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045e5:	e8 36 0a 00 00       	call   80105020 <popcli>
  if(!holding(&ptable.lock))
801045ea:	83 ec 0c             	sub    $0xc,%esp
801045ed:	68 80 32 11 80       	push   $0x80113280
801045f2:	e8 89 0a 00 00       	call   80105080 <holding>
801045f7:	83 c4 10             	add    $0x10,%esp
801045fa:	85 c0                	test   %eax,%eax
801045fc:	74 4f                	je     8010464d <sched+0x7d>
  if(mycpu()->ncli != 1)
801045fe:	e8 0d f9 ff ff       	call   80103f10 <mycpu>
80104603:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010460a:	75 68                	jne    80104674 <sched+0xa4>
  if(p->state == RUNNING)
8010460c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104610:	74 55                	je     80104667 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104612:	9c                   	pushf  
80104613:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104614:	f6 c4 02             	test   $0x2,%ah
80104617:	75 41                	jne    8010465a <sched+0x8a>
  intena = mycpu()->intena;
80104619:	e8 f2 f8 ff ff       	call   80103f10 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010461e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104621:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104627:	e8 e4 f8 ff ff       	call   80103f10 <mycpu>
8010462c:	83 ec 08             	sub    $0x8,%esp
8010462f:	ff 70 04             	push   0x4(%eax)
80104632:	53                   	push   %ebx
80104633:	e8 c3 0d 00 00       	call   801053fb <swtch>
  mycpu()->intena = intena;
80104638:	e8 d3 f8 ff ff       	call   80103f10 <mycpu>
}
8010463d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104640:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104646:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104649:	5b                   	pop    %ebx
8010464a:	5e                   	pop    %esi
8010464b:	5d                   	pop    %ebp
8010464c:	c3                   	ret    
    panic("sched ptable.lock");
8010464d:	83 ec 0c             	sub    $0xc,%esp
80104650:	68 3a 85 10 80       	push   $0x8010853a
80104655:	e8 26 bd ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010465a:	83 ec 0c             	sub    $0xc,%esp
8010465d:	68 66 85 10 80       	push   $0x80108566
80104662:	e8 19 bd ff ff       	call   80100380 <panic>
    panic("sched running");
80104667:	83 ec 0c             	sub    $0xc,%esp
8010466a:	68 58 85 10 80       	push   $0x80108558
8010466f:	e8 0c bd ff ff       	call   80100380 <panic>
    panic("sched locks");
80104674:	83 ec 0c             	sub    $0xc,%esp
80104677:	68 4c 85 10 80       	push   $0x8010854c
8010467c:	e8 ff bc ff ff       	call   80100380 <panic>
80104681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010468f:	90                   	nop

80104690 <exit>:
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	57                   	push   %edi
80104694:	56                   	push   %esi
80104695:	53                   	push   %ebx
80104696:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104699:	e8 72 f9 ff ff       	call   80104010 <myproc>
  cprintf("exit %d\n", curproc->pid);
8010469e:	83 ec 08             	sub    $0x8,%esp
801046a1:	ff 70 10             	push   0x10(%eax)
  struct proc *curproc = myproc();
801046a4:	89 c6                	mov    %eax,%esi
  cprintf("exit %d\n", curproc->pid);
801046a6:	68 7a 85 10 80       	push   $0x8010857a
801046ab:	8d 5e 28             	lea    0x28(%esi),%ebx
801046ae:	8d 7e 68             	lea    0x68(%esi),%edi
801046b1:	e8 ea bf ff ff       	call   801006a0 <cprintf>
  if(curproc == initproc)
801046b6:	83 c4 10             	add    $0x10,%esp
801046b9:	39 35 b4 55 11 80    	cmp    %esi,0x801155b4
801046bf:	0f 84 b4 00 00 00    	je     80104779 <exit+0xe9>
801046c5:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
801046c8:	8b 03                	mov    (%ebx),%eax
801046ca:	85 c0                	test   %eax,%eax
801046cc:	74 12                	je     801046e0 <exit+0x50>
      fileclose(curproc->ofile[fd]);
801046ce:	83 ec 0c             	sub    $0xc,%esp
801046d1:	50                   	push   %eax
801046d2:	e8 19 c8 ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
801046d7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801046dd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801046e0:	83 c3 04             	add    $0x4,%ebx
801046e3:	39 fb                	cmp    %edi,%ebx
801046e5:	75 e1                	jne    801046c8 <exit+0x38>
  begin_op();
801046e7:	e8 74 e6 ff ff       	call   80102d60 <begin_op>
  iput(curproc->cwd);
801046ec:	83 ec 0c             	sub    $0xc,%esp
801046ef:	ff 76 68             	push   0x68(%esi)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046f2:	bb b4 32 11 80       	mov    $0x801132b4,%ebx
  iput(curproc->cwd);
801046f7:	e8 b4 d1 ff ff       	call   801018b0 <iput>
  end_op();
801046fc:	e8 cf e6 ff ff       	call   80102dd0 <end_op>
  curproc->cwd = 0;
80104701:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104708:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
8010470f:	e8 0c 0a 00 00       	call   80105120 <acquire>
  wakeup1(curproc->parent);
80104714:	8b 46 14             	mov    0x14(%esi),%eax
80104717:	e8 44 f5 ff ff       	call   80103c60 <wakeup1>
8010471c:	83 c4 10             	add    $0x10,%esp
8010471f:	eb 15                	jmp    80104736 <exit+0xa6>
80104721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104728:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
8010472e:	81 fb b4 55 11 80    	cmp    $0x801155b4,%ebx
80104734:	74 2a                	je     80104760 <exit+0xd0>
    if(p->parent == curproc){
80104736:	39 73 14             	cmp    %esi,0x14(%ebx)
80104739:	75 ed                	jne    80104728 <exit+0x98>
      p->parent = initproc;
8010473b:	a1 b4 55 11 80       	mov    0x801155b4,%eax
      if(p->state == ZOMBIE)
80104740:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
      p->parent = initproc;
80104744:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
80104747:	75 df                	jne    80104728 <exit+0x98>
        wakeup1(initproc);
80104749:	e8 12 f5 ff ff       	call   80103c60 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010474e:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80104754:	81 fb b4 55 11 80    	cmp    $0x801155b4,%ebx
8010475a:	75 da                	jne    80104736 <exit+0xa6>
8010475c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  curproc->state = ZOMBIE;
80104760:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104767:	e8 64 fe ff ff       	call   801045d0 <sched>
  panic("zombie exit");
8010476c:	83 ec 0c             	sub    $0xc,%esp
8010476f:	68 90 85 10 80       	push   $0x80108590
80104774:	e8 07 bc ff ff       	call   80100380 <panic>
    panic("init exiting");
80104779:	83 ec 0c             	sub    $0xc,%esp
8010477c:	68 83 85 10 80       	push   $0x80108583
80104781:	e8 fa bb ff ff       	call   80100380 <panic>
80104786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010478d:	8d 76 00             	lea    0x0(%esi),%esi

80104790 <wait>:
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	56                   	push   %esi
80104794:	53                   	push   %ebx
  pushcli();
80104795:	e8 36 08 00 00       	call   80104fd0 <pushcli>
  c = mycpu();
8010479a:	e8 71 f7 ff ff       	call   80103f10 <mycpu>
  p = c->proc;
8010479f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801047a5:	e8 76 08 00 00       	call   80105020 <popcli>
  acquire(&ptable.lock);
801047aa:	83 ec 0c             	sub    $0xc,%esp
801047ad:	68 80 32 11 80       	push   $0x80113280
801047b2:	e8 69 09 00 00       	call   80105120 <acquire>
801047b7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801047ba:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047bc:	bb b4 32 11 80       	mov    $0x801132b4,%ebx
801047c1:	eb 13                	jmp    801047d6 <wait+0x46>
801047c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047c7:	90                   	nop
801047c8:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801047ce:	81 fb b4 55 11 80    	cmp    $0x801155b4,%ebx
801047d4:	74 1e                	je     801047f4 <wait+0x64>
      if(p->parent != curproc)
801047d6:	39 73 14             	cmp    %esi,0x14(%ebx)
801047d9:	75 ed                	jne    801047c8 <wait+0x38>
      if(p->state == ZOMBIE){
801047db:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801047df:	74 6f                	je     80104850 <wait+0xc0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047e1:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
      havekids = 1;
801047e7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047ec:	81 fb b4 55 11 80    	cmp    $0x801155b4,%ebx
801047f2:	75 e2                	jne    801047d6 <wait+0x46>
    if(!havekids || curproc->killed){
801047f4:	85 c0                	test   %eax,%eax
801047f6:	0f 84 cc 00 00 00    	je     801048c8 <wait+0x138>
801047fc:	8b 46 24             	mov    0x24(%esi),%eax
801047ff:	85 c0                	test   %eax,%eax
80104801:	0f 85 c1 00 00 00    	jne    801048c8 <wait+0x138>
  pushcli();
80104807:	e8 c4 07 00 00       	call   80104fd0 <pushcli>
  c = mycpu();
8010480c:	e8 ff f6 ff ff       	call   80103f10 <mycpu>
  p = c->proc;
80104811:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104817:	e8 04 08 00 00       	call   80105020 <popcli>
  if(p == 0)
8010481c:	85 db                	test   %ebx,%ebx
8010481e:	0f 84 bb 00 00 00    	je     801048df <wait+0x14f>
  if(p->monopoly == 1) {
80104824:	83 bb 88 00 00 00 01 	cmpl   $0x1,0x88(%ebx)
  p->chan = chan;
8010482b:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
8010482e:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  if(p->monopoly == 1) {
80104835:	74 6f                	je     801048a6 <wait+0x116>
  sched();
80104837:	e8 94 fd ff ff       	call   801045d0 <sched>
  p->chan = 0;
8010483c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104843:	e9 72 ff ff ff       	jmp    801047ba <wait+0x2a>
80104848:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010484f:	90                   	nop
        kfree(p->kstack);
80104850:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104853:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104856:	ff 73 08             	push   0x8(%ebx)
80104859:	e8 62 dc ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
8010485e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104865:	5a                   	pop    %edx
80104866:	ff 73 04             	push   0x4(%ebx)
80104869:	e8 62 33 00 00       	call   80107bd0 <freevm>
        p->pid = 0;
8010486e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104875:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010487c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104880:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104887:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010488e:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80104895:	e8 26 08 00 00       	call   801050c0 <release>
        return pid;
8010489a:	83 c4 10             	add    $0x10,%esp
}
8010489d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048a0:	89 f0                	mov    %esi,%eax
801048a2:	5b                   	pop    %ebx
801048a3:	5e                   	pop    %esi
801048a4:	5d                   	pop    %ebp
801048a5:	c3                   	ret    
  insertqueue(&(moq.q), p);
801048a6:	83 ec 08             	sub    $0x8,%esp
801048a9:	53                   	push   %ebx
801048aa:	68 40 2d 11 80       	push   $0x80112d40
801048af:	e8 1c f1 ff ff       	call   801039d0 <insertqueue>
}
801048b4:	83 c4 10             	add    $0x10,%esp
  sched();
801048b7:	e8 14 fd ff ff       	call   801045d0 <sched>
  p->chan = 0;
801048bc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  if(lk != &ptable.lock){  //DOC: sleeplock2
801048c3:	e9 f2 fe ff ff       	jmp    801047ba <wait+0x2a>
      release(&ptable.lock);
801048c8:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801048cb:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801048d0:	68 80 32 11 80       	push   $0x80113280
801048d5:	e8 e6 07 00 00       	call   801050c0 <release>
      return -1;
801048da:	83 c4 10             	add    $0x10,%esp
801048dd:	eb be                	jmp    8010489d <wait+0x10d>
    panic("sleep");
801048df:	83 ec 0c             	sub    $0xc,%esp
801048e2:	68 9c 85 10 80       	push   $0x8010859c
801048e7:	e8 94 ba ff ff       	call   80100380 <panic>
801048ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048f0 <yield>:
{ 
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	53                   	push   %ebx
801048f4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801048f7:	68 80 32 11 80       	push   $0x80113280
801048fc:	e8 1f 08 00 00       	call   80105120 <acquire>
  pushcli();
80104901:	e8 ca 06 00 00       	call   80104fd0 <pushcli>
  c = mycpu();
80104906:	e8 05 f6 ff ff       	call   80103f10 <mycpu>
  p = c->proc;
8010490b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104911:	e8 0a 07 00 00       	call   80105020 <popcli>
  myproc()->state = RUNNABLE;
80104916:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  pushcli();
8010491d:	e8 ae 06 00 00       	call   80104fd0 <pushcli>
  c = mycpu();
80104922:	e8 e9 f5 ff ff       	call   80103f10 <mycpu>
  p = c->proc;
80104927:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010492d:	e8 ee 06 00 00       	call   80105020 <popcli>
  myproc()->tq = 0; 
80104932:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80104939:	00 00 00 
  if(mycpu()->monopoly == 0) {
8010493c:	e8 cf f5 ff ff       	call   80103f10 <mycpu>
80104941:	83 c4 10             	add    $0x10,%esp
80104944:	8b 88 b0 00 00 00    	mov    0xb0(%eax),%ecx
8010494a:	85 c9                	test   %ecx,%ecx
8010494c:	75 5a                	jne    801049a8 <yield+0xb8>
  pushcli();
8010494e:	e8 7d 06 00 00       	call   80104fd0 <pushcli>
  c = mycpu();
80104953:	e8 b8 f5 ff ff       	call   80103f10 <mycpu>
  p = c->proc;
80104958:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010495e:	e8 bd 06 00 00       	call   80105020 <popcli>
    if(myproc()->monopoly == 0) 
80104963:	8b 93 88 00 00 00    	mov    0x88(%ebx),%edx
80104969:	85 d2                	test   %edx,%edx
8010496b:	0f 84 c7 00 00 00    	je     80104a38 <yield+0x148>
    insertheap(&(mlfq.h), p);
80104971:	69 05 c0 55 11 80 29 	imul   $0xc28f5c29,0x801155c0,%eax
80104978:	5c 8f c2 
8010497b:	c1 c8 02             	ror    $0x2,%eax
    if(ticks % 100 == 0) {
8010497e:	3d 28 5c 8f 02       	cmp    $0x28f5c28,%eax
80104983:	0f 86 97 00 00 00    	jbe    80104a20 <yield+0x130>
  sched();
80104989:	e8 42 fc ff ff       	call   801045d0 <sched>
  release(&ptable.lock);
8010498e:	83 ec 0c             	sub    $0xc,%esp
80104991:	68 80 32 11 80       	push   $0x80113280
80104996:	e8 25 07 00 00       	call   801050c0 <release>
}
8010499b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010499e:	83 c4 10             	add    $0x10,%esp
801049a1:	c9                   	leave  
801049a2:	c3                   	ret    
801049a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049a7:	90                   	nop
  } else if(mycpu()->monopoly == 1) {
801049a8:	e8 63 f5 ff ff       	call   80103f10 <mycpu>
801049ad:	83 b8 b0 00 00 00 01 	cmpl   $0x1,0xb0(%eax)
801049b4:	75 d3                	jne    80104989 <yield+0x99>
  pushcli();
801049b6:	e8 15 06 00 00       	call   80104fd0 <pushcli>
  c = mycpu();
801049bb:	e8 50 f5 ff ff       	call   80103f10 <mycpu>
  p = c->proc;
801049c0:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801049c6:	e8 55 06 00 00       	call   80105020 <popcli>
    if(myproc()->monopoly == 0) {
801049cb:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
801049d1:	85 c0                	test   %eax,%eax
801049d3:	75 b4                	jne    80104989 <yield+0x99>
  pushcli();
801049d5:	e8 f6 05 00 00       	call   80104fd0 <pushcli>
  c = mycpu();
801049da:	e8 31 f5 ff ff       	call   80103f10 <mycpu>
  p = c->proc;
801049df:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801049e5:	e8 36 06 00 00       	call   80105020 <popcli>
  if(p->level < 3) {
801049ea:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
801049f0:	83 f8 02             	cmp    $0x2,%eax
801049f3:	0f 8f 97 00 00 00    	jg     80104a90 <yield+0x1a0>
    insertqueue(&(mlfq.q[p->level]), p);
801049f9:	69 c0 08 01 00 00    	imul   $0x108,%eax,%eax
801049ff:	83 ec 08             	sub    $0x8,%esp
80104a02:	53                   	push   %ebx
80104a03:	05 60 2e 11 80       	add    $0x80112e60,%eax
80104a08:	50                   	push   %eax
80104a09:	e8 c2 ef ff ff       	call   801039d0 <insertqueue>
80104a0e:	83 c4 10             	add    $0x10,%esp
80104a11:	e9 73 ff ff ff       	jmp    80104989 <yield+0x99>
80104a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a1d:	8d 76 00             	lea    0x0(%esi),%esi
      priorityboosting();
80104a20:	e8 1b f4 ff ff       	call   80103e40 <priorityboosting>
      ticks = 0;
80104a25:	c7 05 c0 55 11 80 00 	movl   $0x0,0x801155c0
80104a2c:	00 00 00 
80104a2f:	e9 55 ff ff ff       	jmp    80104989 <yield+0x99>
80104a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  pushcli();
80104a38:	e8 93 05 00 00       	call   80104fd0 <pushcli>
  c = mycpu();
80104a3d:	e8 ce f4 ff ff       	call   80103f10 <mycpu>
  p = c->proc;
80104a42:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104a48:	e8 d3 05 00 00       	call   80105020 <popcli>
  if(p->level < 3) {
80104a4d:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80104a53:	83 f8 02             	cmp    $0x2,%eax
80104a56:	7f 20                	jg     80104a78 <yield+0x188>
    insertqueue(&(mlfq.q[p->level]), p);
80104a58:	69 c0 08 01 00 00    	imul   $0x108,%eax,%eax
80104a5e:	83 ec 08             	sub    $0x8,%esp
80104a61:	53                   	push   %ebx
80104a62:	05 60 2e 11 80       	add    $0x80112e60,%eax
80104a67:	50                   	push   %eax
80104a68:	e8 63 ef ff ff       	call   801039d0 <insertqueue>
80104a6d:	83 c4 10             	add    $0x10,%esp
80104a70:	e9 fc fe ff ff       	jmp    80104971 <yield+0x81>
80104a75:	8d 76 00             	lea    0x0(%esi),%esi
    insertheap(&(mlfq.h), p);
80104a78:	83 ec 08             	sub    $0x8,%esp
80104a7b:	53                   	push   %ebx
80104a7c:	68 78 31 11 80       	push   $0x80113178
80104a81:	e8 6a f1 ff ff       	call   80103bf0 <insertheap>
80104a86:	83 c4 10             	add    $0x10,%esp
80104a89:	e9 e3 fe ff ff       	jmp    80104971 <yield+0x81>
80104a8e:	66 90                	xchg   %ax,%ax
80104a90:	83 ec 08             	sub    $0x8,%esp
80104a93:	53                   	push   %ebx
80104a94:	68 78 31 11 80       	push   $0x80113178
80104a99:	e8 52 f1 ff ff       	call   80103bf0 <insertheap>
80104a9e:	83 c4 10             	add    $0x10,%esp
80104aa1:	e9 e3 fe ff ff       	jmp    80104989 <yield+0x99>
80104aa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aad:	8d 76 00             	lea    0x0(%esi),%esi

80104ab0 <setmonopoly>:
setmonopoly(int pid, int password) {
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	56                   	push   %esi
  if(password != 2020099743) return -2;
80104ab4:	81 7d 0c 9f 46 68 78 	cmpl   $0x7868469f,0xc(%ebp)
setmonopoly(int pid, int password) {
80104abb:	53                   	push   %ebx
80104abc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(password != 2020099743) return -2;
80104abf:	0f 85 c2 00 00 00    	jne    80104b87 <setmonopoly+0xd7>
  acquire(&ptable.lock);
80104ac5:	83 ec 0c             	sub    $0xc,%esp
80104ac8:	68 80 32 11 80       	push   $0x80113280
80104acd:	e8 4e 06 00 00       	call   80105120 <acquire>
80104ad2:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104ad5:	b8 b4 32 11 80       	mov    $0x801132b4,%eax
80104ada:	eb 10                	jmp    80104aec <setmonopoly+0x3c>
80104adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ae0:	05 8c 00 00 00       	add    $0x8c,%eax
80104ae5:	3d b4 55 11 80       	cmp    $0x801155b4,%eax
80104aea:	74 74                	je     80104b60 <setmonopoly+0xb0>
    if(p->pid == pid) {
80104aec:	39 58 10             	cmp    %ebx,0x10(%eax)
80104aef:	75 ef                	jne    80104ae0 <setmonopoly+0x30>
      p->monopoly = 1;
80104af1:	c7 80 88 00 00 00 01 	movl   $0x1,0x88(%eax)
80104af8:	00 00 00 
  insertqueue(&(moq.q), p);
80104afb:	83 ec 08             	sub    $0x8,%esp
      p->level = 99;
80104afe:	c7 80 80 00 00 00 63 	movl   $0x63,0x80(%eax)
80104b05:	00 00 00 
  insertqueue(&(moq.q), p);
80104b08:	50                   	push   %eax
80104b09:	68 40 2d 11 80       	push   $0x80112d40
80104b0e:	e8 bd ee ff ff       	call   801039d0 <insertqueue>
      release(&ptable.lock);
80104b13:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80104b1a:	e8 a1 05 00 00       	call   801050c0 <release>
  pushcli();
80104b1f:	e8 ac 04 00 00       	call   80104fd0 <pushcli>
  c = mycpu();
80104b24:	e8 e7 f3 ff ff       	call   80103f10 <mycpu>
  p = c->proc;
80104b29:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104b2f:	e8 ec 04 00 00       	call   80105020 <popcli>
      if(myproc()->pid == pid) {
80104b34:	83 c4 10             	add    $0x10,%esp
80104b37:	39 5e 10             	cmp    %ebx,0x10(%esi)
80104b3a:	74 44                	je     80104b80 <setmonopoly+0xd0>
    return (q->rear - q->front + NPROC) % NPROC;
80104b3c:	a1 44 2e 11 80       	mov    0x80112e44,%eax
80104b41:	2b 05 40 2e 11 80    	sub    0x80112e40,%eax
80104b47:	83 c0 40             	add    $0x40,%eax
80104b4a:	99                   	cltd   
80104b4b:	c1 ea 1a             	shr    $0x1a,%edx
80104b4e:	01 d0                	add    %edx,%eax
80104b50:	83 e0 3f             	and    $0x3f,%eax
80104b53:	29 d0                	sub    %edx,%eax
}
80104b55:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b58:	5b                   	pop    %ebx
80104b59:	5e                   	pop    %esi
80104b5a:	5d                   	pop    %ebp
80104b5b:	c3                   	ret    
80104b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104b60:	83 ec 0c             	sub    $0xc,%esp
80104b63:	68 80 32 11 80       	push   $0x80113280
80104b68:	e8 53 05 00 00       	call   801050c0 <release>
  return -1;
80104b6d:	83 c4 10             	add    $0x10,%esp
}
80104b70:	8d 65 f8             	lea    -0x8(%ebp),%esp
  return -1;
80104b73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b78:	5b                   	pop    %ebx
80104b79:	5e                   	pop    %esi
80104b7a:	5d                   	pop    %ebp
80104b7b:	c3                   	ret    
80104b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        yield();
80104b80:	e8 6b fd ff ff       	call   801048f0 <yield>
80104b85:	eb b5                	jmp    80104b3c <setmonopoly+0x8c>
  if(password != 2020099743) return -2;
80104b87:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80104b8c:	eb c7                	jmp    80104b55 <setmonopoly+0xa5>
80104b8e:	66 90                	xchg   %ax,%ax

80104b90 <sleep>:
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	57                   	push   %edi
80104b94:	56                   	push   %esi
80104b95:	53                   	push   %ebx
80104b96:	83 ec 0c             	sub    $0xc,%esp
80104b99:	8b 7d 08             	mov    0x8(%ebp),%edi
80104b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104b9f:	e8 2c 04 00 00       	call   80104fd0 <pushcli>
  c = mycpu();
80104ba4:	e8 67 f3 ff ff       	call   80103f10 <mycpu>
  p = c->proc;
80104ba9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104baf:	e8 6c 04 00 00       	call   80105020 <popcli>
  if(p == 0)
80104bb4:	85 db                	test   %ebx,%ebx
80104bb6:	0f 84 d3 00 00 00    	je     80104c8f <sleep+0xff>
  if(lk == 0)
80104bbc:	85 f6                	test   %esi,%esi
80104bbe:	0f 84 d8 00 00 00    	je     80104c9c <sleep+0x10c>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104bc4:	81 fe 80 32 11 80    	cmp    $0x80113280,%esi
80104bca:	74 5c                	je     80104c28 <sleep+0x98>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104bcc:	83 ec 0c             	sub    $0xc,%esp
80104bcf:	68 80 32 11 80       	push   $0x80113280
80104bd4:	e8 47 05 00 00       	call   80105120 <acquire>
    release(lk);
80104bd9:	89 34 24             	mov    %esi,(%esp)
80104bdc:	e8 df 04 00 00       	call   801050c0 <release>
  if(p->monopoly == 1) {
80104be1:	83 c4 10             	add    $0x10,%esp
  p->chan = chan;
80104be4:	89 7b 20             	mov    %edi,0x20(%ebx)
  if(p->monopoly == 1) {
80104be7:	83 bb 88 00 00 00 01 	cmpl   $0x1,0x88(%ebx)
  p->state = SLEEPING;
80104bee:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  if(p->monopoly == 1) {
80104bf5:	74 59                	je     80104c50 <sleep+0xc0>
  sched();
80104bf7:	e8 d4 f9 ff ff       	call   801045d0 <sched>
  p->chan = 0;
80104bfc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104c03:	83 ec 0c             	sub    $0xc,%esp
80104c06:	68 80 32 11 80       	push   $0x80113280
80104c0b:	e8 b0 04 00 00       	call   801050c0 <release>
    acquire(lk);
80104c10:	89 75 08             	mov    %esi,0x8(%ebp)
80104c13:	83 c4 10             	add    $0x10,%esp
}
80104c16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c19:	5b                   	pop    %ebx
80104c1a:	5e                   	pop    %esi
80104c1b:	5f                   	pop    %edi
80104c1c:	5d                   	pop    %ebp
    acquire(lk);
80104c1d:	e9 fe 04 00 00       	jmp    80105120 <acquire>
80104c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(p->monopoly == 1) {
80104c28:	83 bb 88 00 00 00 01 	cmpl   $0x1,0x88(%ebx)
  p->chan = chan;
80104c2f:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104c32:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  if(p->monopoly == 1) {
80104c39:	74 35                	je     80104c70 <sleep+0xe0>
  sched();
80104c3b:	e8 90 f9 ff ff       	call   801045d0 <sched>
  p->chan = 0;
80104c40:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104c47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c4a:	5b                   	pop    %ebx
80104c4b:	5e                   	pop    %esi
80104c4c:	5f                   	pop    %edi
80104c4d:	5d                   	pop    %ebp
80104c4e:	c3                   	ret    
80104c4f:	90                   	nop
  insertqueue(&(moq.q), p);
80104c50:	83 ec 08             	sub    $0x8,%esp
80104c53:	53                   	push   %ebx
80104c54:	68 40 2d 11 80       	push   $0x80112d40
80104c59:	e8 72 ed ff ff       	call   801039d0 <insertqueue>
  sched();
80104c5e:	e8 6d f9 ff ff       	call   801045d0 <sched>
  p->chan = 0;
80104c63:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
80104c6a:	83 c4 10             	add    $0x10,%esp
80104c6d:	eb 94                	jmp    80104c03 <sleep+0x73>
80104c6f:	90                   	nop
  insertqueue(&(moq.q), p);
80104c70:	83 ec 08             	sub    $0x8,%esp
80104c73:	53                   	push   %ebx
80104c74:	68 40 2d 11 80       	push   $0x80112d40
80104c79:	e8 52 ed ff ff       	call   801039d0 <insertqueue>
  sched();
80104c7e:	e8 4d f9 ff ff       	call   801045d0 <sched>
  p->chan = 0;
80104c83:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
80104c8a:	83 c4 10             	add    $0x10,%esp
80104c8d:	eb b8                	jmp    80104c47 <sleep+0xb7>
    panic("sleep");
80104c8f:	83 ec 0c             	sub    $0xc,%esp
80104c92:	68 9c 85 10 80       	push   $0x8010859c
80104c97:	e8 e4 b6 ff ff       	call   80100380 <panic>
    panic("sleep without lk");
80104c9c:	83 ec 0c             	sub    $0xc,%esp
80104c9f:	68 a2 85 10 80       	push   $0x801085a2
80104ca4:	e8 d7 b6 ff ff       	call   80100380 <panic>
80104ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104cb0 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	53                   	push   %ebx
80104cb4:	83 ec 10             	sub    $0x10,%esp
80104cb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104cba:	68 80 32 11 80       	push   $0x80113280
80104cbf:	e8 5c 04 00 00       	call   80105120 <acquire>
  wakeup1(chan);
80104cc4:	89 d8                	mov    %ebx,%eax
80104cc6:	e8 95 ef ff ff       	call   80103c60 <wakeup1>
  release(&ptable.lock);
80104ccb:	c7 45 08 80 32 11 80 	movl   $0x80113280,0x8(%ebp)
}
80104cd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&ptable.lock);
80104cd5:	83 c4 10             	add    $0x10,%esp
}
80104cd8:	c9                   	leave  
  release(&ptable.lock);
80104cd9:	e9 e2 03 00 00       	jmp    801050c0 <release>
80104cde:	66 90                	xchg   %ax,%ax

80104ce0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	53                   	push   %ebx
80104ce4:	83 ec 10             	sub    $0x10,%esp
80104ce7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104cea:	68 80 32 11 80       	push   $0x80113280
80104cef:	e8 2c 04 00 00       	call   80105120 <acquire>
80104cf4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cf7:	b8 b4 32 11 80       	mov    $0x801132b4,%eax
80104cfc:	eb 0e                	jmp    80104d0c <kill+0x2c>
80104cfe:	66 90                	xchg   %ax,%ax
80104d00:	05 8c 00 00 00       	add    $0x8c,%eax
80104d05:	3d b4 55 11 80       	cmp    $0x801155b4,%eax
80104d0a:	74 34                	je     80104d40 <kill+0x60>
    if(p->pid == pid){
80104d0c:	39 58 10             	cmp    %ebx,0x10(%eax)
80104d0f:	75 ef                	jne    80104d00 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104d11:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104d15:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104d1c:	75 07                	jne    80104d25 <kill+0x45>
        p->state = RUNNABLE;
80104d1e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104d25:	83 ec 0c             	sub    $0xc,%esp
80104d28:	68 80 32 11 80       	push   $0x80113280
80104d2d:	e8 8e 03 00 00       	call   801050c0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104d32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104d35:	83 c4 10             	add    $0x10,%esp
80104d38:	31 c0                	xor    %eax,%eax
}
80104d3a:	c9                   	leave  
80104d3b:	c3                   	ret    
80104d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104d40:	83 ec 0c             	sub    $0xc,%esp
80104d43:	68 80 32 11 80       	push   $0x80113280
80104d48:	e8 73 03 00 00       	call   801050c0 <release>
}
80104d4d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104d50:	83 c4 10             	add    $0x10,%esp
80104d53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d58:	c9                   	leave  
80104d59:	c3                   	ret    
80104d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d60 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	57                   	push   %edi
80104d64:	56                   	push   %esi
80104d65:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104d68:	53                   	push   %ebx
80104d69:	bb 20 33 11 80       	mov    $0x80113320,%ebx
80104d6e:	83 ec 3c             	sub    $0x3c,%esp
80104d71:	eb 27                	jmp    80104d9a <procdump+0x3a>
80104d73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d77:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104d78:	83 ec 0c             	sub    $0xc,%esp
80104d7b:	68 53 89 10 80       	push   $0x80108953
80104d80:	e8 1b b9 ff ff       	call   801006a0 <cprintf>
80104d85:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d88:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80104d8e:	81 fb 20 56 11 80    	cmp    $0x80115620,%ebx
80104d94:	0f 84 7e 00 00 00    	je     80104e18 <procdump+0xb8>
    if(p->state == UNUSED)
80104d9a:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104d9d:	85 c0                	test   %eax,%eax
80104d9f:	74 e7                	je     80104d88 <procdump+0x28>
      state = "???";
80104da1:	ba b3 85 10 80       	mov    $0x801085b3,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104da6:	83 f8 05             	cmp    $0x5,%eax
80104da9:	77 11                	ja     80104dbc <procdump+0x5c>
80104dab:	8b 14 85 14 86 10 80 	mov    -0x7fef79ec(,%eax,4),%edx
      state = "???";
80104db2:	b8 b3 85 10 80       	mov    $0x801085b3,%eax
80104db7:	85 d2                	test   %edx,%edx
80104db9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104dbc:	53                   	push   %ebx
80104dbd:	52                   	push   %edx
80104dbe:	ff 73 a4             	push   -0x5c(%ebx)
80104dc1:	68 b7 85 10 80       	push   $0x801085b7
80104dc6:	e8 d5 b8 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
80104dcb:	83 c4 10             	add    $0x10,%esp
80104dce:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104dd2:	75 a4                	jne    80104d78 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104dd4:	83 ec 08             	sub    $0x8,%esp
80104dd7:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104dda:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104ddd:	50                   	push   %eax
80104dde:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104de1:	8b 40 0c             	mov    0xc(%eax),%eax
80104de4:	83 c0 08             	add    $0x8,%eax
80104de7:	50                   	push   %eax
80104de8:	e8 83 01 00 00       	call   80104f70 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104ded:	83 c4 10             	add    $0x10,%esp
80104df0:	8b 17                	mov    (%edi),%edx
80104df2:	85 d2                	test   %edx,%edx
80104df4:	74 82                	je     80104d78 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104df6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104df9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
80104dfc:	52                   	push   %edx
80104dfd:	68 e1 7f 10 80       	push   $0x80107fe1
80104e02:	e8 99 b8 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104e07:	83 c4 10             	add    $0x10,%esp
80104e0a:	39 fe                	cmp    %edi,%esi
80104e0c:	75 e2                	jne    80104df0 <procdump+0x90>
80104e0e:	e9 65 ff ff ff       	jmp    80104d78 <procdump+0x18>
80104e13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e17:	90                   	nop
  }
}
80104e18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e1b:	5b                   	pop    %ebx
80104e1c:	5e                   	pop    %esi
80104e1d:	5f                   	pop    %edi
80104e1e:	5d                   	pop    %ebp
80104e1f:	c3                   	ret    

80104e20 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	53                   	push   %ebx
80104e24:	83 ec 0c             	sub    $0xc,%esp
80104e27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104e2a:	68 2c 86 10 80       	push   $0x8010862c
80104e2f:	8d 43 04             	lea    0x4(%ebx),%eax
80104e32:	50                   	push   %eax
80104e33:	e8 18 01 00 00       	call   80104f50 <initlock>
  lk->name = name;
80104e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104e3b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104e41:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104e44:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104e4b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104e4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e51:	c9                   	leave  
80104e52:	c3                   	ret    
80104e53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e60 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	56                   	push   %esi
80104e64:	53                   	push   %ebx
80104e65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104e68:	8d 73 04             	lea    0x4(%ebx),%esi
80104e6b:	83 ec 0c             	sub    $0xc,%esp
80104e6e:	56                   	push   %esi
80104e6f:	e8 ac 02 00 00       	call   80105120 <acquire>
  while (lk->locked) {
80104e74:	8b 13                	mov    (%ebx),%edx
80104e76:	83 c4 10             	add    $0x10,%esp
80104e79:	85 d2                	test   %edx,%edx
80104e7b:	74 16                	je     80104e93 <acquiresleep+0x33>
80104e7d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104e80:	83 ec 08             	sub    $0x8,%esp
80104e83:	56                   	push   %esi
80104e84:	53                   	push   %ebx
80104e85:	e8 06 fd ff ff       	call   80104b90 <sleep>
  while (lk->locked) {
80104e8a:	8b 03                	mov    (%ebx),%eax
80104e8c:	83 c4 10             	add    $0x10,%esp
80104e8f:	85 c0                	test   %eax,%eax
80104e91:	75 ed                	jne    80104e80 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104e93:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104e99:	e8 72 f1 ff ff       	call   80104010 <myproc>
80104e9e:	8b 40 10             	mov    0x10(%eax),%eax
80104ea1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104ea4:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104ea7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104eaa:	5b                   	pop    %ebx
80104eab:	5e                   	pop    %esi
80104eac:	5d                   	pop    %ebp
  release(&lk->lk);
80104ead:	e9 0e 02 00 00       	jmp    801050c0 <release>
80104eb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ec0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	56                   	push   %esi
80104ec4:	53                   	push   %ebx
80104ec5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104ec8:	8d 73 04             	lea    0x4(%ebx),%esi
80104ecb:	83 ec 0c             	sub    $0xc,%esp
80104ece:	56                   	push   %esi
80104ecf:	e8 4c 02 00 00       	call   80105120 <acquire>
  lk->locked = 0;
80104ed4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104eda:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104ee1:	89 1c 24             	mov    %ebx,(%esp)
80104ee4:	e8 c7 fd ff ff       	call   80104cb0 <wakeup>
  release(&lk->lk);
80104ee9:	89 75 08             	mov    %esi,0x8(%ebp)
80104eec:	83 c4 10             	add    $0x10,%esp
}
80104eef:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ef2:	5b                   	pop    %ebx
80104ef3:	5e                   	pop    %esi
80104ef4:	5d                   	pop    %ebp
  release(&lk->lk);
80104ef5:	e9 c6 01 00 00       	jmp    801050c0 <release>
80104efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f00 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	57                   	push   %edi
80104f04:	31 ff                	xor    %edi,%edi
80104f06:	56                   	push   %esi
80104f07:	53                   	push   %ebx
80104f08:	83 ec 18             	sub    $0x18,%esp
80104f0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104f0e:	8d 73 04             	lea    0x4(%ebx),%esi
80104f11:	56                   	push   %esi
80104f12:	e8 09 02 00 00       	call   80105120 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104f17:	8b 03                	mov    (%ebx),%eax
80104f19:	83 c4 10             	add    $0x10,%esp
80104f1c:	85 c0                	test   %eax,%eax
80104f1e:	75 18                	jne    80104f38 <holdingsleep+0x38>
  release(&lk->lk);
80104f20:	83 ec 0c             	sub    $0xc,%esp
80104f23:	56                   	push   %esi
80104f24:	e8 97 01 00 00       	call   801050c0 <release>
  return r;
}
80104f29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f2c:	89 f8                	mov    %edi,%eax
80104f2e:	5b                   	pop    %ebx
80104f2f:	5e                   	pop    %esi
80104f30:	5f                   	pop    %edi
80104f31:	5d                   	pop    %ebp
80104f32:	c3                   	ret    
80104f33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f37:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104f38:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104f3b:	e8 d0 f0 ff ff       	call   80104010 <myproc>
80104f40:	39 58 10             	cmp    %ebx,0x10(%eax)
80104f43:	0f 94 c0             	sete   %al
80104f46:	0f b6 c0             	movzbl %al,%eax
80104f49:	89 c7                	mov    %eax,%edi
80104f4b:	eb d3                	jmp    80104f20 <holdingsleep+0x20>
80104f4d:	66 90                	xchg   %ax,%ax
80104f4f:	90                   	nop

80104f50 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104f56:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104f59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104f5f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104f62:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104f69:	5d                   	pop    %ebp
80104f6a:	c3                   	ret    
80104f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f6f:	90                   	nop

80104f70 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104f70:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104f71:	31 d2                	xor    %edx,%edx
{
80104f73:	89 e5                	mov    %esp,%ebp
80104f75:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104f76:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104f79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104f7c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104f7f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104f80:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104f86:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104f8c:	77 1a                	ja     80104fa8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104f8e:	8b 58 04             	mov    0x4(%eax),%ebx
80104f91:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104f94:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104f97:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104f99:	83 fa 0a             	cmp    $0xa,%edx
80104f9c:	75 e2                	jne    80104f80 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104f9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fa1:	c9                   	leave  
80104fa2:	c3                   	ret    
80104fa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fa7:	90                   	nop
  for(; i < 10; i++)
80104fa8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104fab:	8d 51 28             	lea    0x28(%ecx),%edx
80104fae:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104fb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104fb6:	83 c0 04             	add    $0x4,%eax
80104fb9:	39 d0                	cmp    %edx,%eax
80104fbb:	75 f3                	jne    80104fb0 <getcallerpcs+0x40>
}
80104fbd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fc0:	c9                   	leave  
80104fc1:	c3                   	ret    
80104fc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104fd0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	53                   	push   %ebx
80104fd4:	83 ec 04             	sub    $0x4,%esp
80104fd7:	9c                   	pushf  
80104fd8:	5b                   	pop    %ebx
  asm volatile("cli");
80104fd9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104fda:	e8 31 ef ff ff       	call   80103f10 <mycpu>
80104fdf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104fe5:	85 c0                	test   %eax,%eax
80104fe7:	74 17                	je     80105000 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104fe9:	e8 22 ef ff ff       	call   80103f10 <mycpu>
80104fee:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104ff5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ff8:	c9                   	leave  
80104ff9:	c3                   	ret    
80104ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80105000:	e8 0b ef ff ff       	call   80103f10 <mycpu>
80105005:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010500b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80105011:	eb d6                	jmp    80104fe9 <pushcli+0x19>
80105013:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010501a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105020 <popcli>:

void
popcli(void)
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105026:	9c                   	pushf  
80105027:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105028:	f6 c4 02             	test   $0x2,%ah
8010502b:	75 35                	jne    80105062 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010502d:	e8 de ee ff ff       	call   80103f10 <mycpu>
80105032:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105039:	78 34                	js     8010506f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010503b:	e8 d0 ee ff ff       	call   80103f10 <mycpu>
80105040:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105046:	85 d2                	test   %edx,%edx
80105048:	74 06                	je     80105050 <popcli+0x30>
    sti();
}
8010504a:	c9                   	leave  
8010504b:	c3                   	ret    
8010504c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105050:	e8 bb ee ff ff       	call   80103f10 <mycpu>
80105055:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010505b:	85 c0                	test   %eax,%eax
8010505d:	74 eb                	je     8010504a <popcli+0x2a>
  asm volatile("sti");
8010505f:	fb                   	sti    
}
80105060:	c9                   	leave  
80105061:	c3                   	ret    
    panic("popcli - interruptible");
80105062:	83 ec 0c             	sub    $0xc,%esp
80105065:	68 37 86 10 80       	push   $0x80108637
8010506a:	e8 11 b3 ff ff       	call   80100380 <panic>
    panic("popcli");
8010506f:	83 ec 0c             	sub    $0xc,%esp
80105072:	68 4e 86 10 80       	push   $0x8010864e
80105077:	e8 04 b3 ff ff       	call   80100380 <panic>
8010507c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105080 <holding>:
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	56                   	push   %esi
80105084:	53                   	push   %ebx
80105085:	8b 75 08             	mov    0x8(%ebp),%esi
80105088:	31 db                	xor    %ebx,%ebx
  pushcli();
8010508a:	e8 41 ff ff ff       	call   80104fd0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010508f:	8b 06                	mov    (%esi),%eax
80105091:	85 c0                	test   %eax,%eax
80105093:	75 0b                	jne    801050a0 <holding+0x20>
  popcli();
80105095:	e8 86 ff ff ff       	call   80105020 <popcli>
}
8010509a:	89 d8                	mov    %ebx,%eax
8010509c:	5b                   	pop    %ebx
8010509d:	5e                   	pop    %esi
8010509e:	5d                   	pop    %ebp
8010509f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
801050a0:	8b 5e 08             	mov    0x8(%esi),%ebx
801050a3:	e8 68 ee ff ff       	call   80103f10 <mycpu>
801050a8:	39 c3                	cmp    %eax,%ebx
801050aa:	0f 94 c3             	sete   %bl
  popcli();
801050ad:	e8 6e ff ff ff       	call   80105020 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801050b2:	0f b6 db             	movzbl %bl,%ebx
}
801050b5:	89 d8                	mov    %ebx,%eax
801050b7:	5b                   	pop    %ebx
801050b8:	5e                   	pop    %esi
801050b9:	5d                   	pop    %ebp
801050ba:	c3                   	ret    
801050bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050bf:	90                   	nop

801050c0 <release>:
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	56                   	push   %esi
801050c4:	53                   	push   %ebx
801050c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801050c8:	e8 03 ff ff ff       	call   80104fd0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801050cd:	8b 03                	mov    (%ebx),%eax
801050cf:	85 c0                	test   %eax,%eax
801050d1:	75 15                	jne    801050e8 <release+0x28>
  popcli();
801050d3:	e8 48 ff ff ff       	call   80105020 <popcli>
    panic("release");
801050d8:	83 ec 0c             	sub    $0xc,%esp
801050db:	68 55 86 10 80       	push   $0x80108655
801050e0:	e8 9b b2 ff ff       	call   80100380 <panic>
801050e5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801050e8:	8b 73 08             	mov    0x8(%ebx),%esi
801050eb:	e8 20 ee ff ff       	call   80103f10 <mycpu>
801050f0:	39 c6                	cmp    %eax,%esi
801050f2:	75 df                	jne    801050d3 <release+0x13>
  popcli();
801050f4:	e8 27 ff ff ff       	call   80105020 <popcli>
  lk->pcs[0] = 0;
801050f9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105100:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105107:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010510c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105112:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105115:	5b                   	pop    %ebx
80105116:	5e                   	pop    %esi
80105117:	5d                   	pop    %ebp
  popcli();
80105118:	e9 03 ff ff ff       	jmp    80105020 <popcli>
8010511d:	8d 76 00             	lea    0x0(%esi),%esi

80105120 <acquire>:
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	53                   	push   %ebx
80105124:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105127:	e8 a4 fe ff ff       	call   80104fd0 <pushcli>
  if(holding(lk))
8010512c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010512f:	e8 9c fe ff ff       	call   80104fd0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105134:	8b 03                	mov    (%ebx),%eax
80105136:	85 c0                	test   %eax,%eax
80105138:	75 7e                	jne    801051b8 <acquire+0x98>
  popcli();
8010513a:	e8 e1 fe ff ff       	call   80105020 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010513f:	b9 01 00 00 00       	mov    $0x1,%ecx
80105144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80105148:	8b 55 08             	mov    0x8(%ebp),%edx
8010514b:	89 c8                	mov    %ecx,%eax
8010514d:	f0 87 02             	lock xchg %eax,(%edx)
80105150:	85 c0                	test   %eax,%eax
80105152:	75 f4                	jne    80105148 <acquire+0x28>
  __sync_synchronize();
80105154:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105159:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010515c:	e8 af ed ff ff       	call   80103f10 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105161:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80105164:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80105166:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80105169:	31 c0                	xor    %eax,%eax
8010516b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010516f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105170:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80105176:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010517c:	77 1a                	ja     80105198 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010517e:	8b 5a 04             	mov    0x4(%edx),%ebx
80105181:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80105185:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80105188:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010518a:	83 f8 0a             	cmp    $0xa,%eax
8010518d:	75 e1                	jne    80105170 <acquire+0x50>
}
8010518f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105192:	c9                   	leave  
80105193:	c3                   	ret    
80105194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80105198:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010519c:	8d 51 34             	lea    0x34(%ecx),%edx
8010519f:	90                   	nop
    pcs[i] = 0;
801051a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801051a6:	83 c0 04             	add    $0x4,%eax
801051a9:	39 c2                	cmp    %eax,%edx
801051ab:	75 f3                	jne    801051a0 <acquire+0x80>
}
801051ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051b0:	c9                   	leave  
801051b1:	c3                   	ret    
801051b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801051b8:	8b 5b 08             	mov    0x8(%ebx),%ebx
801051bb:	e8 50 ed ff ff       	call   80103f10 <mycpu>
801051c0:	39 c3                	cmp    %eax,%ebx
801051c2:	0f 85 72 ff ff ff    	jne    8010513a <acquire+0x1a>
  popcli();
801051c8:	e8 53 fe ff ff       	call   80105020 <popcli>
    panic("acquire");
801051cd:	83 ec 0c             	sub    $0xc,%esp
801051d0:	68 5d 86 10 80       	push   $0x8010865d
801051d5:	e8 a6 b1 ff ff       	call   80100380 <panic>
801051da:	66 90                	xchg   %ax,%ax
801051dc:	66 90                	xchg   %ax,%ax
801051de:	66 90                	xchg   %ax,%ax

801051e0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	57                   	push   %edi
801051e4:	8b 55 08             	mov    0x8(%ebp),%edx
801051e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801051ea:	53                   	push   %ebx
801051eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801051ee:	89 d7                	mov    %edx,%edi
801051f0:	09 cf                	or     %ecx,%edi
801051f2:	83 e7 03             	and    $0x3,%edi
801051f5:	75 29                	jne    80105220 <memset+0x40>
    c &= 0xFF;
801051f7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801051fa:	c1 e0 18             	shl    $0x18,%eax
801051fd:	89 fb                	mov    %edi,%ebx
801051ff:	c1 e9 02             	shr    $0x2,%ecx
80105202:	c1 e3 10             	shl    $0x10,%ebx
80105205:	09 d8                	or     %ebx,%eax
80105207:	09 f8                	or     %edi,%eax
80105209:	c1 e7 08             	shl    $0x8,%edi
8010520c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010520e:	89 d7                	mov    %edx,%edi
80105210:	fc                   	cld    
80105211:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105213:	5b                   	pop    %ebx
80105214:	89 d0                	mov    %edx,%eax
80105216:	5f                   	pop    %edi
80105217:	5d                   	pop    %ebp
80105218:	c3                   	ret    
80105219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80105220:	89 d7                	mov    %edx,%edi
80105222:	fc                   	cld    
80105223:	f3 aa                	rep stos %al,%es:(%edi)
80105225:	5b                   	pop    %ebx
80105226:	89 d0                	mov    %edx,%eax
80105228:	5f                   	pop    %edi
80105229:	5d                   	pop    %ebp
8010522a:	c3                   	ret    
8010522b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010522f:	90                   	nop

80105230 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	56                   	push   %esi
80105234:	8b 75 10             	mov    0x10(%ebp),%esi
80105237:	8b 55 08             	mov    0x8(%ebp),%edx
8010523a:	53                   	push   %ebx
8010523b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010523e:	85 f6                	test   %esi,%esi
80105240:	74 2e                	je     80105270 <memcmp+0x40>
80105242:	01 c6                	add    %eax,%esi
80105244:	eb 14                	jmp    8010525a <memcmp+0x2a>
80105246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010524d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105250:	83 c0 01             	add    $0x1,%eax
80105253:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105256:	39 f0                	cmp    %esi,%eax
80105258:	74 16                	je     80105270 <memcmp+0x40>
    if(*s1 != *s2)
8010525a:	0f b6 0a             	movzbl (%edx),%ecx
8010525d:	0f b6 18             	movzbl (%eax),%ebx
80105260:	38 d9                	cmp    %bl,%cl
80105262:	74 ec                	je     80105250 <memcmp+0x20>
      return *s1 - *s2;
80105264:	0f b6 c1             	movzbl %cl,%eax
80105267:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105269:	5b                   	pop    %ebx
8010526a:	5e                   	pop    %esi
8010526b:	5d                   	pop    %ebp
8010526c:	c3                   	ret    
8010526d:	8d 76 00             	lea    0x0(%esi),%esi
80105270:	5b                   	pop    %ebx
  return 0;
80105271:	31 c0                	xor    %eax,%eax
}
80105273:	5e                   	pop    %esi
80105274:	5d                   	pop    %ebp
80105275:	c3                   	ret    
80105276:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010527d:	8d 76 00             	lea    0x0(%esi),%esi

80105280 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	57                   	push   %edi
80105284:	8b 55 08             	mov    0x8(%ebp),%edx
80105287:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010528a:	56                   	push   %esi
8010528b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010528e:	39 d6                	cmp    %edx,%esi
80105290:	73 26                	jae    801052b8 <memmove+0x38>
80105292:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105295:	39 fa                	cmp    %edi,%edx
80105297:	73 1f                	jae    801052b8 <memmove+0x38>
80105299:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010529c:	85 c9                	test   %ecx,%ecx
8010529e:	74 0c                	je     801052ac <memmove+0x2c>
      *--d = *--s;
801052a0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801052a4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801052a7:	83 e8 01             	sub    $0x1,%eax
801052aa:	73 f4                	jae    801052a0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801052ac:	5e                   	pop    %esi
801052ad:	89 d0                	mov    %edx,%eax
801052af:	5f                   	pop    %edi
801052b0:	5d                   	pop    %ebp
801052b1:	c3                   	ret    
801052b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801052b8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801052bb:	89 d7                	mov    %edx,%edi
801052bd:	85 c9                	test   %ecx,%ecx
801052bf:	74 eb                	je     801052ac <memmove+0x2c>
801052c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801052c8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801052c9:	39 c6                	cmp    %eax,%esi
801052cb:	75 fb                	jne    801052c8 <memmove+0x48>
}
801052cd:	5e                   	pop    %esi
801052ce:	89 d0                	mov    %edx,%eax
801052d0:	5f                   	pop    %edi
801052d1:	5d                   	pop    %ebp
801052d2:	c3                   	ret    
801052d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801052e0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801052e0:	eb 9e                	jmp    80105280 <memmove>
801052e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801052f0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	56                   	push   %esi
801052f4:	8b 75 10             	mov    0x10(%ebp),%esi
801052f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801052fa:	53                   	push   %ebx
801052fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
801052fe:	85 f6                	test   %esi,%esi
80105300:	74 2e                	je     80105330 <strncmp+0x40>
80105302:	01 d6                	add    %edx,%esi
80105304:	eb 18                	jmp    8010531e <strncmp+0x2e>
80105306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010530d:	8d 76 00             	lea    0x0(%esi),%esi
80105310:	38 d8                	cmp    %bl,%al
80105312:	75 14                	jne    80105328 <strncmp+0x38>
    n--, p++, q++;
80105314:	83 c2 01             	add    $0x1,%edx
80105317:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010531a:	39 f2                	cmp    %esi,%edx
8010531c:	74 12                	je     80105330 <strncmp+0x40>
8010531e:	0f b6 01             	movzbl (%ecx),%eax
80105321:	0f b6 1a             	movzbl (%edx),%ebx
80105324:	84 c0                	test   %al,%al
80105326:	75 e8                	jne    80105310 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105328:	29 d8                	sub    %ebx,%eax
}
8010532a:	5b                   	pop    %ebx
8010532b:	5e                   	pop    %esi
8010532c:	5d                   	pop    %ebp
8010532d:	c3                   	ret    
8010532e:	66 90                	xchg   %ax,%ax
80105330:	5b                   	pop    %ebx
    return 0;
80105331:	31 c0                	xor    %eax,%eax
}
80105333:	5e                   	pop    %esi
80105334:	5d                   	pop    %ebp
80105335:	c3                   	ret    
80105336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010533d:	8d 76 00             	lea    0x0(%esi),%esi

80105340 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	57                   	push   %edi
80105344:	56                   	push   %esi
80105345:	8b 75 08             	mov    0x8(%ebp),%esi
80105348:	53                   	push   %ebx
80105349:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010534c:	89 f0                	mov    %esi,%eax
8010534e:	eb 15                	jmp    80105365 <strncpy+0x25>
80105350:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105354:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105357:	83 c0 01             	add    $0x1,%eax
8010535a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010535e:	88 50 ff             	mov    %dl,-0x1(%eax)
80105361:	84 d2                	test   %dl,%dl
80105363:	74 09                	je     8010536e <strncpy+0x2e>
80105365:	89 cb                	mov    %ecx,%ebx
80105367:	83 e9 01             	sub    $0x1,%ecx
8010536a:	85 db                	test   %ebx,%ebx
8010536c:	7f e2                	jg     80105350 <strncpy+0x10>
    ;
  while(n-- > 0)
8010536e:	89 c2                	mov    %eax,%edx
80105370:	85 c9                	test   %ecx,%ecx
80105372:	7e 17                	jle    8010538b <strncpy+0x4b>
80105374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105378:	83 c2 01             	add    $0x1,%edx
8010537b:	89 c1                	mov    %eax,%ecx
8010537d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80105381:	29 d1                	sub    %edx,%ecx
80105383:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80105387:	85 c9                	test   %ecx,%ecx
80105389:	7f ed                	jg     80105378 <strncpy+0x38>
  return os;
}
8010538b:	5b                   	pop    %ebx
8010538c:	89 f0                	mov    %esi,%eax
8010538e:	5e                   	pop    %esi
8010538f:	5f                   	pop    %edi
80105390:	5d                   	pop    %ebp
80105391:	c3                   	ret    
80105392:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801053a0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	56                   	push   %esi
801053a4:	8b 55 10             	mov    0x10(%ebp),%edx
801053a7:	8b 75 08             	mov    0x8(%ebp),%esi
801053aa:	53                   	push   %ebx
801053ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801053ae:	85 d2                	test   %edx,%edx
801053b0:	7e 25                	jle    801053d7 <safestrcpy+0x37>
801053b2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801053b6:	89 f2                	mov    %esi,%edx
801053b8:	eb 16                	jmp    801053d0 <safestrcpy+0x30>
801053ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801053c0:	0f b6 08             	movzbl (%eax),%ecx
801053c3:	83 c0 01             	add    $0x1,%eax
801053c6:	83 c2 01             	add    $0x1,%edx
801053c9:	88 4a ff             	mov    %cl,-0x1(%edx)
801053cc:	84 c9                	test   %cl,%cl
801053ce:	74 04                	je     801053d4 <safestrcpy+0x34>
801053d0:	39 d8                	cmp    %ebx,%eax
801053d2:	75 ec                	jne    801053c0 <safestrcpy+0x20>
    ;
  *s = 0;
801053d4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801053d7:	89 f0                	mov    %esi,%eax
801053d9:	5b                   	pop    %ebx
801053da:	5e                   	pop    %esi
801053db:	5d                   	pop    %ebp
801053dc:	c3                   	ret    
801053dd:	8d 76 00             	lea    0x0(%esi),%esi

801053e0 <strlen>:

int
strlen(const char *s)
{
801053e0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801053e1:	31 c0                	xor    %eax,%eax
{
801053e3:	89 e5                	mov    %esp,%ebp
801053e5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801053e8:	80 3a 00             	cmpb   $0x0,(%edx)
801053eb:	74 0c                	je     801053f9 <strlen+0x19>
801053ed:	8d 76 00             	lea    0x0(%esi),%esi
801053f0:	83 c0 01             	add    $0x1,%eax
801053f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801053f7:	75 f7                	jne    801053f0 <strlen+0x10>
    ;
  return n;
}
801053f9:	5d                   	pop    %ebp
801053fa:	c3                   	ret    

801053fb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801053fb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801053ff:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105403:	55                   	push   %ebp
  pushl %ebx
80105404:	53                   	push   %ebx
  pushl %esi
80105405:	56                   	push   %esi
  pushl %edi
80105406:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105407:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105409:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010540b:	5f                   	pop    %edi
  popl %esi
8010540c:	5e                   	pop    %esi
  popl %ebx
8010540d:	5b                   	pop    %ebx
  popl %ebp
8010540e:	5d                   	pop    %ebp
  ret
8010540f:	c3                   	ret    

80105410 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	53                   	push   %ebx
80105414:	83 ec 04             	sub    $0x4,%esp
80105417:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010541a:	e8 f1 eb ff ff       	call   80104010 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010541f:	8b 00                	mov    (%eax),%eax
80105421:	39 d8                	cmp    %ebx,%eax
80105423:	76 1b                	jbe    80105440 <fetchint+0x30>
80105425:	8d 53 04             	lea    0x4(%ebx),%edx
80105428:	39 d0                	cmp    %edx,%eax
8010542a:	72 14                	jb     80105440 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010542c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010542f:	8b 13                	mov    (%ebx),%edx
80105431:	89 10                	mov    %edx,(%eax)
  return 0;
80105433:	31 c0                	xor    %eax,%eax
}
80105435:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105438:	c9                   	leave  
80105439:	c3                   	ret    
8010543a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105440:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105445:	eb ee                	jmp    80105435 <fetchint+0x25>
80105447:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010544e:	66 90                	xchg   %ax,%ax

80105450 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	53                   	push   %ebx
80105454:	83 ec 04             	sub    $0x4,%esp
80105457:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010545a:	e8 b1 eb ff ff       	call   80104010 <myproc>

  if(addr >= curproc->sz)
8010545f:	39 18                	cmp    %ebx,(%eax)
80105461:	76 2d                	jbe    80105490 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80105463:	8b 55 0c             	mov    0xc(%ebp),%edx
80105466:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105468:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010546a:	39 d3                	cmp    %edx,%ebx
8010546c:	73 22                	jae    80105490 <fetchstr+0x40>
8010546e:	89 d8                	mov    %ebx,%eax
80105470:	eb 0d                	jmp    8010547f <fetchstr+0x2f>
80105472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105478:	83 c0 01             	add    $0x1,%eax
8010547b:	39 c2                	cmp    %eax,%edx
8010547d:	76 11                	jbe    80105490 <fetchstr+0x40>
    if(*s == 0)
8010547f:	80 38 00             	cmpb   $0x0,(%eax)
80105482:	75 f4                	jne    80105478 <fetchstr+0x28>
      return s - *pp;
80105484:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105486:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105489:	c9                   	leave  
8010548a:	c3                   	ret    
8010548b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010548f:	90                   	nop
80105490:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105493:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105498:	c9                   	leave  
80105499:	c3                   	ret    
8010549a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801054a0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	56                   	push   %esi
801054a4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801054a5:	e8 66 eb ff ff       	call   80104010 <myproc>
801054aa:	8b 55 08             	mov    0x8(%ebp),%edx
801054ad:	8b 40 18             	mov    0x18(%eax),%eax
801054b0:	8b 40 44             	mov    0x44(%eax),%eax
801054b3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801054b6:	e8 55 eb ff ff       	call   80104010 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801054bb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801054be:	8b 00                	mov    (%eax),%eax
801054c0:	39 c6                	cmp    %eax,%esi
801054c2:	73 1c                	jae    801054e0 <argint+0x40>
801054c4:	8d 53 08             	lea    0x8(%ebx),%edx
801054c7:	39 d0                	cmp    %edx,%eax
801054c9:	72 15                	jb     801054e0 <argint+0x40>
  *ip = *(int*)(addr);
801054cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801054ce:	8b 53 04             	mov    0x4(%ebx),%edx
801054d1:	89 10                	mov    %edx,(%eax)
  return 0;
801054d3:	31 c0                	xor    %eax,%eax
}
801054d5:	5b                   	pop    %ebx
801054d6:	5e                   	pop    %esi
801054d7:	5d                   	pop    %ebp
801054d8:	c3                   	ret    
801054d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801054e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801054e5:	eb ee                	jmp    801054d5 <argint+0x35>
801054e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ee:	66 90                	xchg   %ax,%ax

801054f0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	57                   	push   %edi
801054f4:	56                   	push   %esi
801054f5:	53                   	push   %ebx
801054f6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
801054f9:	e8 12 eb ff ff       	call   80104010 <myproc>
801054fe:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105500:	e8 0b eb ff ff       	call   80104010 <myproc>
80105505:	8b 55 08             	mov    0x8(%ebp),%edx
80105508:	8b 40 18             	mov    0x18(%eax),%eax
8010550b:	8b 40 44             	mov    0x44(%eax),%eax
8010550e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105511:	e8 fa ea ff ff       	call   80104010 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105516:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105519:	8b 00                	mov    (%eax),%eax
8010551b:	39 c7                	cmp    %eax,%edi
8010551d:	73 31                	jae    80105550 <argptr+0x60>
8010551f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80105522:	39 c8                	cmp    %ecx,%eax
80105524:	72 2a                	jb     80105550 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105526:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80105529:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010552c:	85 d2                	test   %edx,%edx
8010552e:	78 20                	js     80105550 <argptr+0x60>
80105530:	8b 16                	mov    (%esi),%edx
80105532:	39 c2                	cmp    %eax,%edx
80105534:	76 1a                	jbe    80105550 <argptr+0x60>
80105536:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105539:	01 c3                	add    %eax,%ebx
8010553b:	39 da                	cmp    %ebx,%edx
8010553d:	72 11                	jb     80105550 <argptr+0x60>
    return -1;
  *pp = (char*)i;
8010553f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105542:	89 02                	mov    %eax,(%edx)
  return 0;
80105544:	31 c0                	xor    %eax,%eax
}
80105546:	83 c4 0c             	add    $0xc,%esp
80105549:	5b                   	pop    %ebx
8010554a:	5e                   	pop    %esi
8010554b:	5f                   	pop    %edi
8010554c:	5d                   	pop    %ebp
8010554d:	c3                   	ret    
8010554e:	66 90                	xchg   %ax,%ax
    return -1;
80105550:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105555:	eb ef                	jmp    80105546 <argptr+0x56>
80105557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010555e:	66 90                	xchg   %ax,%ax

80105560 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	56                   	push   %esi
80105564:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105565:	e8 a6 ea ff ff       	call   80104010 <myproc>
8010556a:	8b 55 08             	mov    0x8(%ebp),%edx
8010556d:	8b 40 18             	mov    0x18(%eax),%eax
80105570:	8b 40 44             	mov    0x44(%eax),%eax
80105573:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105576:	e8 95 ea ff ff       	call   80104010 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010557b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010557e:	8b 00                	mov    (%eax),%eax
80105580:	39 c6                	cmp    %eax,%esi
80105582:	73 44                	jae    801055c8 <argstr+0x68>
80105584:	8d 53 08             	lea    0x8(%ebx),%edx
80105587:	39 d0                	cmp    %edx,%eax
80105589:	72 3d                	jb     801055c8 <argstr+0x68>
  *ip = *(int*)(addr);
8010558b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
8010558e:	e8 7d ea ff ff       	call   80104010 <myproc>
  if(addr >= curproc->sz)
80105593:	3b 18                	cmp    (%eax),%ebx
80105595:	73 31                	jae    801055c8 <argstr+0x68>
  *pp = (char*)addr;
80105597:	8b 55 0c             	mov    0xc(%ebp),%edx
8010559a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010559c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010559e:	39 d3                	cmp    %edx,%ebx
801055a0:	73 26                	jae    801055c8 <argstr+0x68>
801055a2:	89 d8                	mov    %ebx,%eax
801055a4:	eb 11                	jmp    801055b7 <argstr+0x57>
801055a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ad:	8d 76 00             	lea    0x0(%esi),%esi
801055b0:	83 c0 01             	add    $0x1,%eax
801055b3:	39 c2                	cmp    %eax,%edx
801055b5:	76 11                	jbe    801055c8 <argstr+0x68>
    if(*s == 0)
801055b7:	80 38 00             	cmpb   $0x0,(%eax)
801055ba:	75 f4                	jne    801055b0 <argstr+0x50>
      return s - *pp;
801055bc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801055be:	5b                   	pop    %ebx
801055bf:	5e                   	pop    %esi
801055c0:	5d                   	pop    %ebp
801055c1:	c3                   	ret    
801055c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801055c8:	5b                   	pop    %ebx
    return -1;
801055c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055ce:	5e                   	pop    %esi
801055cf:	5d                   	pop    %ebp
801055d0:	c3                   	ret    
801055d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055df:	90                   	nop

801055e0 <syscall>:
[SYS_rn_sleep] sys_rn_sleep,
};

void
syscall(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	53                   	push   %ebx
801055e4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801055e7:	e8 24 ea ff ff       	call   80104010 <myproc>
801055ec:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801055ee:	8b 40 18             	mov    0x18(%eax),%eax
801055f1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801055f4:	8d 50 ff             	lea    -0x1(%eax),%edx
801055f7:	83 fa 1b             	cmp    $0x1b,%edx
801055fa:	77 24                	ja     80105620 <syscall+0x40>
801055fc:	8b 14 85 a0 86 10 80 	mov    -0x7fef7960(,%eax,4),%edx
80105603:	85 d2                	test   %edx,%edx
80105605:	74 19                	je     80105620 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105607:	ff d2                	call   *%edx
80105609:	89 c2                	mov    %eax,%edx
8010560b:	8b 43 18             	mov    0x18(%ebx),%eax
8010560e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105611:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105614:	c9                   	leave  
80105615:	c3                   	ret    
80105616:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010561d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105620:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105621:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105624:	50                   	push   %eax
80105625:	ff 73 10             	push   0x10(%ebx)
80105628:	68 65 86 10 80       	push   $0x80108665
8010562d:	e8 6e b0 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80105632:	8b 43 18             	mov    0x18(%ebx),%eax
80105635:	83 c4 10             	add    $0x10,%esp
80105638:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010563f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105642:	c9                   	leave  
80105643:	c3                   	ret    
80105644:	66 90                	xchg   %ax,%ax
80105646:	66 90                	xchg   %ax,%ax
80105648:	66 90                	xchg   %ax,%ax
8010564a:	66 90                	xchg   %ax,%ax
8010564c:	66 90                	xchg   %ax,%ax
8010564e:	66 90                	xchg   %ax,%ax

80105650 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	57                   	push   %edi
80105654:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105655:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105658:	53                   	push   %ebx
80105659:	83 ec 34             	sub    $0x34,%esp
8010565c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010565f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105662:	57                   	push   %edi
80105663:	50                   	push   %eax
{
80105664:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105667:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010566a:	e8 51 ca ff ff       	call   801020c0 <nameiparent>
8010566f:	83 c4 10             	add    $0x10,%esp
80105672:	85 c0                	test   %eax,%eax
80105674:	0f 84 46 01 00 00    	je     801057c0 <create+0x170>
    return 0;
  ilock(dp);
8010567a:	83 ec 0c             	sub    $0xc,%esp
8010567d:	89 c3                	mov    %eax,%ebx
8010567f:	50                   	push   %eax
80105680:	e8 fb c0 ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105685:	83 c4 0c             	add    $0xc,%esp
80105688:	6a 00                	push   $0x0
8010568a:	57                   	push   %edi
8010568b:	53                   	push   %ebx
8010568c:	e8 4f c6 ff ff       	call   80101ce0 <dirlookup>
80105691:	83 c4 10             	add    $0x10,%esp
80105694:	89 c6                	mov    %eax,%esi
80105696:	85 c0                	test   %eax,%eax
80105698:	74 56                	je     801056f0 <create+0xa0>
    iunlockput(dp);
8010569a:	83 ec 0c             	sub    $0xc,%esp
8010569d:	53                   	push   %ebx
8010569e:	e8 6d c3 ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
801056a3:	89 34 24             	mov    %esi,(%esp)
801056a6:	e8 d5 c0 ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801056ab:	83 c4 10             	add    $0x10,%esp
801056ae:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801056b3:	75 1b                	jne    801056d0 <create+0x80>
801056b5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801056ba:	75 14                	jne    801056d0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801056bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056bf:	89 f0                	mov    %esi,%eax
801056c1:	5b                   	pop    %ebx
801056c2:	5e                   	pop    %esi
801056c3:	5f                   	pop    %edi
801056c4:	5d                   	pop    %ebp
801056c5:	c3                   	ret    
801056c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056cd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801056d0:	83 ec 0c             	sub    $0xc,%esp
801056d3:	56                   	push   %esi
    return 0;
801056d4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
801056d6:	e8 35 c3 ff ff       	call   80101a10 <iunlockput>
    return 0;
801056db:	83 c4 10             	add    $0x10,%esp
}
801056de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056e1:	89 f0                	mov    %esi,%eax
801056e3:	5b                   	pop    %ebx
801056e4:	5e                   	pop    %esi
801056e5:	5f                   	pop    %edi
801056e6:	5d                   	pop    %ebp
801056e7:	c3                   	ret    
801056e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ef:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
801056f0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801056f4:	83 ec 08             	sub    $0x8,%esp
801056f7:	50                   	push   %eax
801056f8:	ff 33                	push   (%ebx)
801056fa:	e8 11 bf ff ff       	call   80101610 <ialloc>
801056ff:	83 c4 10             	add    $0x10,%esp
80105702:	89 c6                	mov    %eax,%esi
80105704:	85 c0                	test   %eax,%eax
80105706:	0f 84 cd 00 00 00    	je     801057d9 <create+0x189>
  ilock(ip);
8010570c:	83 ec 0c             	sub    $0xc,%esp
8010570f:	50                   	push   %eax
80105710:	e8 6b c0 ff ff       	call   80101780 <ilock>
  ip->major = major;
80105715:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105719:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010571d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105721:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105725:	b8 01 00 00 00       	mov    $0x1,%eax
8010572a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010572e:	89 34 24             	mov    %esi,(%esp)
80105731:	e8 9a bf ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105736:	83 c4 10             	add    $0x10,%esp
80105739:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010573e:	74 30                	je     80105770 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105740:	83 ec 04             	sub    $0x4,%esp
80105743:	ff 76 04             	push   0x4(%esi)
80105746:	57                   	push   %edi
80105747:	53                   	push   %ebx
80105748:	e8 93 c8 ff ff       	call   80101fe0 <dirlink>
8010574d:	83 c4 10             	add    $0x10,%esp
80105750:	85 c0                	test   %eax,%eax
80105752:	78 78                	js     801057cc <create+0x17c>
  iunlockput(dp);
80105754:	83 ec 0c             	sub    $0xc,%esp
80105757:	53                   	push   %ebx
80105758:	e8 b3 c2 ff ff       	call   80101a10 <iunlockput>
  return ip;
8010575d:	83 c4 10             	add    $0x10,%esp
}
80105760:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105763:	89 f0                	mov    %esi,%eax
80105765:	5b                   	pop    %ebx
80105766:	5e                   	pop    %esi
80105767:	5f                   	pop    %edi
80105768:	5d                   	pop    %ebp
80105769:	c3                   	ret    
8010576a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105770:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105773:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105778:	53                   	push   %ebx
80105779:	e8 52 bf ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010577e:	83 c4 0c             	add    $0xc,%esp
80105781:	ff 76 04             	push   0x4(%esi)
80105784:	68 30 87 10 80       	push   $0x80108730
80105789:	56                   	push   %esi
8010578a:	e8 51 c8 ff ff       	call   80101fe0 <dirlink>
8010578f:	83 c4 10             	add    $0x10,%esp
80105792:	85 c0                	test   %eax,%eax
80105794:	78 18                	js     801057ae <create+0x15e>
80105796:	83 ec 04             	sub    $0x4,%esp
80105799:	ff 73 04             	push   0x4(%ebx)
8010579c:	68 2f 87 10 80       	push   $0x8010872f
801057a1:	56                   	push   %esi
801057a2:	e8 39 c8 ff ff       	call   80101fe0 <dirlink>
801057a7:	83 c4 10             	add    $0x10,%esp
801057aa:	85 c0                	test   %eax,%eax
801057ac:	79 92                	jns    80105740 <create+0xf0>
      panic("create dots");
801057ae:	83 ec 0c             	sub    $0xc,%esp
801057b1:	68 23 87 10 80       	push   $0x80108723
801057b6:	e8 c5 ab ff ff       	call   80100380 <panic>
801057bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057bf:	90                   	nop
}
801057c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801057c3:	31 f6                	xor    %esi,%esi
}
801057c5:	5b                   	pop    %ebx
801057c6:	89 f0                	mov    %esi,%eax
801057c8:	5e                   	pop    %esi
801057c9:	5f                   	pop    %edi
801057ca:	5d                   	pop    %ebp
801057cb:	c3                   	ret    
    panic("create: dirlink");
801057cc:	83 ec 0c             	sub    $0xc,%esp
801057cf:	68 32 87 10 80       	push   $0x80108732
801057d4:	e8 a7 ab ff ff       	call   80100380 <panic>
    panic("create: ialloc");
801057d9:	83 ec 0c             	sub    $0xc,%esp
801057dc:	68 14 87 10 80       	push   $0x80108714
801057e1:	e8 9a ab ff ff       	call   80100380 <panic>
801057e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ed:	8d 76 00             	lea    0x0(%esi),%esi

801057f0 <sys_dup>:
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	56                   	push   %esi
801057f4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801057f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057f8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801057fb:	50                   	push   %eax
801057fc:	6a 00                	push   $0x0
801057fe:	e8 9d fc ff ff       	call   801054a0 <argint>
80105803:	83 c4 10             	add    $0x10,%esp
80105806:	85 c0                	test   %eax,%eax
80105808:	78 36                	js     80105840 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010580a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010580e:	77 30                	ja     80105840 <sys_dup+0x50>
80105810:	e8 fb e7 ff ff       	call   80104010 <myproc>
80105815:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105818:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010581c:	85 f6                	test   %esi,%esi
8010581e:	74 20                	je     80105840 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105820:	e8 eb e7 ff ff       	call   80104010 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105825:	31 db                	xor    %ebx,%ebx
80105827:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010582e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105830:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105834:	85 d2                	test   %edx,%edx
80105836:	74 18                	je     80105850 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105838:	83 c3 01             	add    $0x1,%ebx
8010583b:	83 fb 10             	cmp    $0x10,%ebx
8010583e:	75 f0                	jne    80105830 <sys_dup+0x40>
}
80105840:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105843:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105848:	89 d8                	mov    %ebx,%eax
8010584a:	5b                   	pop    %ebx
8010584b:	5e                   	pop    %esi
8010584c:	5d                   	pop    %ebp
8010584d:	c3                   	ret    
8010584e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105850:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105853:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105857:	56                   	push   %esi
80105858:	e8 43 b6 ff ff       	call   80100ea0 <filedup>
  return fd;
8010585d:	83 c4 10             	add    $0x10,%esp
}
80105860:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105863:	89 d8                	mov    %ebx,%eax
80105865:	5b                   	pop    %ebx
80105866:	5e                   	pop    %esi
80105867:	5d                   	pop    %ebp
80105868:	c3                   	ret    
80105869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105870 <sys_read>:
{
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
80105873:	56                   	push   %esi
80105874:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105875:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105878:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010587b:	53                   	push   %ebx
8010587c:	6a 00                	push   $0x0
8010587e:	e8 1d fc ff ff       	call   801054a0 <argint>
80105883:	83 c4 10             	add    $0x10,%esp
80105886:	85 c0                	test   %eax,%eax
80105888:	78 5e                	js     801058e8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010588a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010588e:	77 58                	ja     801058e8 <sys_read+0x78>
80105890:	e8 7b e7 ff ff       	call   80104010 <myproc>
80105895:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105898:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010589c:	85 f6                	test   %esi,%esi
8010589e:	74 48                	je     801058e8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801058a0:	83 ec 08             	sub    $0x8,%esp
801058a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058a6:	50                   	push   %eax
801058a7:	6a 02                	push   $0x2
801058a9:	e8 f2 fb ff ff       	call   801054a0 <argint>
801058ae:	83 c4 10             	add    $0x10,%esp
801058b1:	85 c0                	test   %eax,%eax
801058b3:	78 33                	js     801058e8 <sys_read+0x78>
801058b5:	83 ec 04             	sub    $0x4,%esp
801058b8:	ff 75 f0             	push   -0x10(%ebp)
801058bb:	53                   	push   %ebx
801058bc:	6a 01                	push   $0x1
801058be:	e8 2d fc ff ff       	call   801054f0 <argptr>
801058c3:	83 c4 10             	add    $0x10,%esp
801058c6:	85 c0                	test   %eax,%eax
801058c8:	78 1e                	js     801058e8 <sys_read+0x78>
  return fileread(f, p, n);
801058ca:	83 ec 04             	sub    $0x4,%esp
801058cd:	ff 75 f0             	push   -0x10(%ebp)
801058d0:	ff 75 f4             	push   -0xc(%ebp)
801058d3:	56                   	push   %esi
801058d4:	e8 47 b7 ff ff       	call   80101020 <fileread>
801058d9:	83 c4 10             	add    $0x10,%esp
}
801058dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058df:	5b                   	pop    %ebx
801058e0:	5e                   	pop    %esi
801058e1:	5d                   	pop    %ebp
801058e2:	c3                   	ret    
801058e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058e7:	90                   	nop
    return -1;
801058e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058ed:	eb ed                	jmp    801058dc <sys_read+0x6c>
801058ef:	90                   	nop

801058f0 <sys_write>:
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	56                   	push   %esi
801058f4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801058f5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801058f8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801058fb:	53                   	push   %ebx
801058fc:	6a 00                	push   $0x0
801058fe:	e8 9d fb ff ff       	call   801054a0 <argint>
80105903:	83 c4 10             	add    $0x10,%esp
80105906:	85 c0                	test   %eax,%eax
80105908:	78 5e                	js     80105968 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010590a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010590e:	77 58                	ja     80105968 <sys_write+0x78>
80105910:	e8 fb e6 ff ff       	call   80104010 <myproc>
80105915:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105918:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010591c:	85 f6                	test   %esi,%esi
8010591e:	74 48                	je     80105968 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105920:	83 ec 08             	sub    $0x8,%esp
80105923:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105926:	50                   	push   %eax
80105927:	6a 02                	push   $0x2
80105929:	e8 72 fb ff ff       	call   801054a0 <argint>
8010592e:	83 c4 10             	add    $0x10,%esp
80105931:	85 c0                	test   %eax,%eax
80105933:	78 33                	js     80105968 <sys_write+0x78>
80105935:	83 ec 04             	sub    $0x4,%esp
80105938:	ff 75 f0             	push   -0x10(%ebp)
8010593b:	53                   	push   %ebx
8010593c:	6a 01                	push   $0x1
8010593e:	e8 ad fb ff ff       	call   801054f0 <argptr>
80105943:	83 c4 10             	add    $0x10,%esp
80105946:	85 c0                	test   %eax,%eax
80105948:	78 1e                	js     80105968 <sys_write+0x78>
  return filewrite(f, p, n);
8010594a:	83 ec 04             	sub    $0x4,%esp
8010594d:	ff 75 f0             	push   -0x10(%ebp)
80105950:	ff 75 f4             	push   -0xc(%ebp)
80105953:	56                   	push   %esi
80105954:	e8 57 b7 ff ff       	call   801010b0 <filewrite>
80105959:	83 c4 10             	add    $0x10,%esp
}
8010595c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010595f:	5b                   	pop    %ebx
80105960:	5e                   	pop    %esi
80105961:	5d                   	pop    %ebp
80105962:	c3                   	ret    
80105963:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105967:	90                   	nop
    return -1;
80105968:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010596d:	eb ed                	jmp    8010595c <sys_write+0x6c>
8010596f:	90                   	nop

80105970 <sys_close>:
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	56                   	push   %esi
80105974:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105975:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105978:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010597b:	50                   	push   %eax
8010597c:	6a 00                	push   $0x0
8010597e:	e8 1d fb ff ff       	call   801054a0 <argint>
80105983:	83 c4 10             	add    $0x10,%esp
80105986:	85 c0                	test   %eax,%eax
80105988:	78 3e                	js     801059c8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010598a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010598e:	77 38                	ja     801059c8 <sys_close+0x58>
80105990:	e8 7b e6 ff ff       	call   80104010 <myproc>
80105995:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105998:	8d 5a 08             	lea    0x8(%edx),%ebx
8010599b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010599f:	85 f6                	test   %esi,%esi
801059a1:	74 25                	je     801059c8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801059a3:	e8 68 e6 ff ff       	call   80104010 <myproc>
  fileclose(f);
801059a8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801059ab:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801059b2:	00 
  fileclose(f);
801059b3:	56                   	push   %esi
801059b4:	e8 37 b5 ff ff       	call   80100ef0 <fileclose>
  return 0;
801059b9:	83 c4 10             	add    $0x10,%esp
801059bc:	31 c0                	xor    %eax,%eax
}
801059be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801059c1:	5b                   	pop    %ebx
801059c2:	5e                   	pop    %esi
801059c3:	5d                   	pop    %ebp
801059c4:	c3                   	ret    
801059c5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801059c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059cd:	eb ef                	jmp    801059be <sys_close+0x4e>
801059cf:	90                   	nop

801059d0 <sys_fstat>:
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	56                   	push   %esi
801059d4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801059d5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801059d8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801059db:	53                   	push   %ebx
801059dc:	6a 00                	push   $0x0
801059de:	e8 bd fa ff ff       	call   801054a0 <argint>
801059e3:	83 c4 10             	add    $0x10,%esp
801059e6:	85 c0                	test   %eax,%eax
801059e8:	78 46                	js     80105a30 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801059ea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801059ee:	77 40                	ja     80105a30 <sys_fstat+0x60>
801059f0:	e8 1b e6 ff ff       	call   80104010 <myproc>
801059f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059f8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801059fc:	85 f6                	test   %esi,%esi
801059fe:	74 30                	je     80105a30 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105a00:	83 ec 04             	sub    $0x4,%esp
80105a03:	6a 14                	push   $0x14
80105a05:	53                   	push   %ebx
80105a06:	6a 01                	push   $0x1
80105a08:	e8 e3 fa ff ff       	call   801054f0 <argptr>
80105a0d:	83 c4 10             	add    $0x10,%esp
80105a10:	85 c0                	test   %eax,%eax
80105a12:	78 1c                	js     80105a30 <sys_fstat+0x60>
  return filestat(f, st);
80105a14:	83 ec 08             	sub    $0x8,%esp
80105a17:	ff 75 f4             	push   -0xc(%ebp)
80105a1a:	56                   	push   %esi
80105a1b:	e8 b0 b5 ff ff       	call   80100fd0 <filestat>
80105a20:	83 c4 10             	add    $0x10,%esp
}
80105a23:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a26:	5b                   	pop    %ebx
80105a27:	5e                   	pop    %esi
80105a28:	5d                   	pop    %ebp
80105a29:	c3                   	ret    
80105a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105a30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a35:	eb ec                	jmp    80105a23 <sys_fstat+0x53>
80105a37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a3e:	66 90                	xchg   %ax,%ax

80105a40 <sys_link>:
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	57                   	push   %edi
80105a44:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105a45:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105a48:	53                   	push   %ebx
80105a49:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105a4c:	50                   	push   %eax
80105a4d:	6a 00                	push   $0x0
80105a4f:	e8 0c fb ff ff       	call   80105560 <argstr>
80105a54:	83 c4 10             	add    $0x10,%esp
80105a57:	85 c0                	test   %eax,%eax
80105a59:	0f 88 fb 00 00 00    	js     80105b5a <sys_link+0x11a>
80105a5f:	83 ec 08             	sub    $0x8,%esp
80105a62:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105a65:	50                   	push   %eax
80105a66:	6a 01                	push   $0x1
80105a68:	e8 f3 fa ff ff       	call   80105560 <argstr>
80105a6d:	83 c4 10             	add    $0x10,%esp
80105a70:	85 c0                	test   %eax,%eax
80105a72:	0f 88 e2 00 00 00    	js     80105b5a <sys_link+0x11a>
  begin_op();
80105a78:	e8 e3 d2 ff ff       	call   80102d60 <begin_op>
  if((ip = namei(old)) == 0){
80105a7d:	83 ec 0c             	sub    $0xc,%esp
80105a80:	ff 75 d4             	push   -0x2c(%ebp)
80105a83:	e8 18 c6 ff ff       	call   801020a0 <namei>
80105a88:	83 c4 10             	add    $0x10,%esp
80105a8b:	89 c3                	mov    %eax,%ebx
80105a8d:	85 c0                	test   %eax,%eax
80105a8f:	0f 84 e4 00 00 00    	je     80105b79 <sys_link+0x139>
  ilock(ip);
80105a95:	83 ec 0c             	sub    $0xc,%esp
80105a98:	50                   	push   %eax
80105a99:	e8 e2 bc ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
80105a9e:	83 c4 10             	add    $0x10,%esp
80105aa1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105aa6:	0f 84 b5 00 00 00    	je     80105b61 <sys_link+0x121>
  iupdate(ip);
80105aac:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105aaf:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105ab4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105ab7:	53                   	push   %ebx
80105ab8:	e8 13 bc ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
80105abd:	89 1c 24             	mov    %ebx,(%esp)
80105ac0:	e8 9b bd ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105ac5:	58                   	pop    %eax
80105ac6:	5a                   	pop    %edx
80105ac7:	57                   	push   %edi
80105ac8:	ff 75 d0             	push   -0x30(%ebp)
80105acb:	e8 f0 c5 ff ff       	call   801020c0 <nameiparent>
80105ad0:	83 c4 10             	add    $0x10,%esp
80105ad3:	89 c6                	mov    %eax,%esi
80105ad5:	85 c0                	test   %eax,%eax
80105ad7:	74 5b                	je     80105b34 <sys_link+0xf4>
  ilock(dp);
80105ad9:	83 ec 0c             	sub    $0xc,%esp
80105adc:	50                   	push   %eax
80105add:	e8 9e bc ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105ae2:	8b 03                	mov    (%ebx),%eax
80105ae4:	83 c4 10             	add    $0x10,%esp
80105ae7:	39 06                	cmp    %eax,(%esi)
80105ae9:	75 3d                	jne    80105b28 <sys_link+0xe8>
80105aeb:	83 ec 04             	sub    $0x4,%esp
80105aee:	ff 73 04             	push   0x4(%ebx)
80105af1:	57                   	push   %edi
80105af2:	56                   	push   %esi
80105af3:	e8 e8 c4 ff ff       	call   80101fe0 <dirlink>
80105af8:	83 c4 10             	add    $0x10,%esp
80105afb:	85 c0                	test   %eax,%eax
80105afd:	78 29                	js     80105b28 <sys_link+0xe8>
  iunlockput(dp);
80105aff:	83 ec 0c             	sub    $0xc,%esp
80105b02:	56                   	push   %esi
80105b03:	e8 08 bf ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80105b08:	89 1c 24             	mov    %ebx,(%esp)
80105b0b:	e8 a0 bd ff ff       	call   801018b0 <iput>
  end_op();
80105b10:	e8 bb d2 ff ff       	call   80102dd0 <end_op>
  return 0;
80105b15:	83 c4 10             	add    $0x10,%esp
80105b18:	31 c0                	xor    %eax,%eax
}
80105b1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b1d:	5b                   	pop    %ebx
80105b1e:	5e                   	pop    %esi
80105b1f:	5f                   	pop    %edi
80105b20:	5d                   	pop    %ebp
80105b21:	c3                   	ret    
80105b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105b28:	83 ec 0c             	sub    $0xc,%esp
80105b2b:	56                   	push   %esi
80105b2c:	e8 df be ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105b31:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105b34:	83 ec 0c             	sub    $0xc,%esp
80105b37:	53                   	push   %ebx
80105b38:	e8 43 bc ff ff       	call   80101780 <ilock>
  ip->nlink--;
80105b3d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105b42:	89 1c 24             	mov    %ebx,(%esp)
80105b45:	e8 86 bb ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105b4a:	89 1c 24             	mov    %ebx,(%esp)
80105b4d:	e8 be be ff ff       	call   80101a10 <iunlockput>
  end_op();
80105b52:	e8 79 d2 ff ff       	call   80102dd0 <end_op>
  return -1;
80105b57:	83 c4 10             	add    $0x10,%esp
80105b5a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b5f:	eb b9                	jmp    80105b1a <sys_link+0xda>
    iunlockput(ip);
80105b61:	83 ec 0c             	sub    $0xc,%esp
80105b64:	53                   	push   %ebx
80105b65:	e8 a6 be ff ff       	call   80101a10 <iunlockput>
    end_op();
80105b6a:	e8 61 d2 ff ff       	call   80102dd0 <end_op>
    return -1;
80105b6f:	83 c4 10             	add    $0x10,%esp
80105b72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b77:	eb a1                	jmp    80105b1a <sys_link+0xda>
    end_op();
80105b79:	e8 52 d2 ff ff       	call   80102dd0 <end_op>
    return -1;
80105b7e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b83:	eb 95                	jmp    80105b1a <sys_link+0xda>
80105b85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b90 <sys_unlink>:
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	57                   	push   %edi
80105b94:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105b95:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105b98:	53                   	push   %ebx
80105b99:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105b9c:	50                   	push   %eax
80105b9d:	6a 00                	push   $0x0
80105b9f:	e8 bc f9 ff ff       	call   80105560 <argstr>
80105ba4:	83 c4 10             	add    $0x10,%esp
80105ba7:	85 c0                	test   %eax,%eax
80105ba9:	0f 88 7a 01 00 00    	js     80105d29 <sys_unlink+0x199>
  begin_op();
80105baf:	e8 ac d1 ff ff       	call   80102d60 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105bb4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105bb7:	83 ec 08             	sub    $0x8,%esp
80105bba:	53                   	push   %ebx
80105bbb:	ff 75 c0             	push   -0x40(%ebp)
80105bbe:	e8 fd c4 ff ff       	call   801020c0 <nameiparent>
80105bc3:	83 c4 10             	add    $0x10,%esp
80105bc6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105bc9:	85 c0                	test   %eax,%eax
80105bcb:	0f 84 62 01 00 00    	je     80105d33 <sys_unlink+0x1a3>
  ilock(dp);
80105bd1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105bd4:	83 ec 0c             	sub    $0xc,%esp
80105bd7:	57                   	push   %edi
80105bd8:	e8 a3 bb ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105bdd:	58                   	pop    %eax
80105bde:	5a                   	pop    %edx
80105bdf:	68 30 87 10 80       	push   $0x80108730
80105be4:	53                   	push   %ebx
80105be5:	e8 d6 c0 ff ff       	call   80101cc0 <namecmp>
80105bea:	83 c4 10             	add    $0x10,%esp
80105bed:	85 c0                	test   %eax,%eax
80105bef:	0f 84 fb 00 00 00    	je     80105cf0 <sys_unlink+0x160>
80105bf5:	83 ec 08             	sub    $0x8,%esp
80105bf8:	68 2f 87 10 80       	push   $0x8010872f
80105bfd:	53                   	push   %ebx
80105bfe:	e8 bd c0 ff ff       	call   80101cc0 <namecmp>
80105c03:	83 c4 10             	add    $0x10,%esp
80105c06:	85 c0                	test   %eax,%eax
80105c08:	0f 84 e2 00 00 00    	je     80105cf0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105c0e:	83 ec 04             	sub    $0x4,%esp
80105c11:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105c14:	50                   	push   %eax
80105c15:	53                   	push   %ebx
80105c16:	57                   	push   %edi
80105c17:	e8 c4 c0 ff ff       	call   80101ce0 <dirlookup>
80105c1c:	83 c4 10             	add    $0x10,%esp
80105c1f:	89 c3                	mov    %eax,%ebx
80105c21:	85 c0                	test   %eax,%eax
80105c23:	0f 84 c7 00 00 00    	je     80105cf0 <sys_unlink+0x160>
  ilock(ip);
80105c29:	83 ec 0c             	sub    $0xc,%esp
80105c2c:	50                   	push   %eax
80105c2d:	e8 4e bb ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
80105c32:	83 c4 10             	add    $0x10,%esp
80105c35:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105c3a:	0f 8e 1c 01 00 00    	jle    80105d5c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105c40:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c45:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105c48:	74 66                	je     80105cb0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105c4a:	83 ec 04             	sub    $0x4,%esp
80105c4d:	6a 10                	push   $0x10
80105c4f:	6a 00                	push   $0x0
80105c51:	57                   	push   %edi
80105c52:	e8 89 f5 ff ff       	call   801051e0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c57:	6a 10                	push   $0x10
80105c59:	ff 75 c4             	push   -0x3c(%ebp)
80105c5c:	57                   	push   %edi
80105c5d:	ff 75 b4             	push   -0x4c(%ebp)
80105c60:	e8 2b bf ff ff       	call   80101b90 <writei>
80105c65:	83 c4 20             	add    $0x20,%esp
80105c68:	83 f8 10             	cmp    $0x10,%eax
80105c6b:	0f 85 de 00 00 00    	jne    80105d4f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105c71:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c76:	0f 84 94 00 00 00    	je     80105d10 <sys_unlink+0x180>
  iunlockput(dp);
80105c7c:	83 ec 0c             	sub    $0xc,%esp
80105c7f:	ff 75 b4             	push   -0x4c(%ebp)
80105c82:	e8 89 bd ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
80105c87:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105c8c:	89 1c 24             	mov    %ebx,(%esp)
80105c8f:	e8 3c ba ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105c94:	89 1c 24             	mov    %ebx,(%esp)
80105c97:	e8 74 bd ff ff       	call   80101a10 <iunlockput>
  end_op();
80105c9c:	e8 2f d1 ff ff       	call   80102dd0 <end_op>
  return 0;
80105ca1:	83 c4 10             	add    $0x10,%esp
80105ca4:	31 c0                	xor    %eax,%eax
}
80105ca6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ca9:	5b                   	pop    %ebx
80105caa:	5e                   	pop    %esi
80105cab:	5f                   	pop    %edi
80105cac:	5d                   	pop    %ebp
80105cad:	c3                   	ret    
80105cae:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105cb0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105cb4:	76 94                	jbe    80105c4a <sys_unlink+0xba>
80105cb6:	be 20 00 00 00       	mov    $0x20,%esi
80105cbb:	eb 0b                	jmp    80105cc8 <sys_unlink+0x138>
80105cbd:	8d 76 00             	lea    0x0(%esi),%esi
80105cc0:	83 c6 10             	add    $0x10,%esi
80105cc3:	3b 73 58             	cmp    0x58(%ebx),%esi
80105cc6:	73 82                	jae    80105c4a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105cc8:	6a 10                	push   $0x10
80105cca:	56                   	push   %esi
80105ccb:	57                   	push   %edi
80105ccc:	53                   	push   %ebx
80105ccd:	e8 be bd ff ff       	call   80101a90 <readi>
80105cd2:	83 c4 10             	add    $0x10,%esp
80105cd5:	83 f8 10             	cmp    $0x10,%eax
80105cd8:	75 68                	jne    80105d42 <sys_unlink+0x1b2>
    if(de.inum != 0)
80105cda:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105cdf:	74 df                	je     80105cc0 <sys_unlink+0x130>
    iunlockput(ip);
80105ce1:	83 ec 0c             	sub    $0xc,%esp
80105ce4:	53                   	push   %ebx
80105ce5:	e8 26 bd ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105cea:	83 c4 10             	add    $0x10,%esp
80105ced:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105cf0:	83 ec 0c             	sub    $0xc,%esp
80105cf3:	ff 75 b4             	push   -0x4c(%ebp)
80105cf6:	e8 15 bd ff ff       	call   80101a10 <iunlockput>
  end_op();
80105cfb:	e8 d0 d0 ff ff       	call   80102dd0 <end_op>
  return -1;
80105d00:	83 c4 10             	add    $0x10,%esp
80105d03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d08:	eb 9c                	jmp    80105ca6 <sys_unlink+0x116>
80105d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105d10:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105d13:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105d16:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105d1b:	50                   	push   %eax
80105d1c:	e8 af b9 ff ff       	call   801016d0 <iupdate>
80105d21:	83 c4 10             	add    $0x10,%esp
80105d24:	e9 53 ff ff ff       	jmp    80105c7c <sys_unlink+0xec>
    return -1;
80105d29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d2e:	e9 73 ff ff ff       	jmp    80105ca6 <sys_unlink+0x116>
    end_op();
80105d33:	e8 98 d0 ff ff       	call   80102dd0 <end_op>
    return -1;
80105d38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d3d:	e9 64 ff ff ff       	jmp    80105ca6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105d42:	83 ec 0c             	sub    $0xc,%esp
80105d45:	68 54 87 10 80       	push   $0x80108754
80105d4a:	e8 31 a6 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
80105d4f:	83 ec 0c             	sub    $0xc,%esp
80105d52:	68 66 87 10 80       	push   $0x80108766
80105d57:	e8 24 a6 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
80105d5c:	83 ec 0c             	sub    $0xc,%esp
80105d5f:	68 42 87 10 80       	push   $0x80108742
80105d64:	e8 17 a6 ff ff       	call   80100380 <panic>
80105d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d70 <sys_open>:

int
sys_open(void)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	57                   	push   %edi
80105d74:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105d75:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105d78:	53                   	push   %ebx
80105d79:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105d7c:	50                   	push   %eax
80105d7d:	6a 00                	push   $0x0
80105d7f:	e8 dc f7 ff ff       	call   80105560 <argstr>
80105d84:	83 c4 10             	add    $0x10,%esp
80105d87:	85 c0                	test   %eax,%eax
80105d89:	0f 88 8e 00 00 00    	js     80105e1d <sys_open+0xad>
80105d8f:	83 ec 08             	sub    $0x8,%esp
80105d92:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d95:	50                   	push   %eax
80105d96:	6a 01                	push   $0x1
80105d98:	e8 03 f7 ff ff       	call   801054a0 <argint>
80105d9d:	83 c4 10             	add    $0x10,%esp
80105da0:	85 c0                	test   %eax,%eax
80105da2:	78 79                	js     80105e1d <sys_open+0xad>
    return -1;

  begin_op();
80105da4:	e8 b7 cf ff ff       	call   80102d60 <begin_op>

  if(omode & O_CREATE){
80105da9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105dad:	75 79                	jne    80105e28 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105daf:	83 ec 0c             	sub    $0xc,%esp
80105db2:	ff 75 e0             	push   -0x20(%ebp)
80105db5:	e8 e6 c2 ff ff       	call   801020a0 <namei>
80105dba:	83 c4 10             	add    $0x10,%esp
80105dbd:	89 c6                	mov    %eax,%esi
80105dbf:	85 c0                	test   %eax,%eax
80105dc1:	0f 84 7e 00 00 00    	je     80105e45 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105dc7:	83 ec 0c             	sub    $0xc,%esp
80105dca:	50                   	push   %eax
80105dcb:	e8 b0 b9 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105dd0:	83 c4 10             	add    $0x10,%esp
80105dd3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105dd8:	0f 84 c2 00 00 00    	je     80105ea0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105dde:	e8 4d b0 ff ff       	call   80100e30 <filealloc>
80105de3:	89 c7                	mov    %eax,%edi
80105de5:	85 c0                	test   %eax,%eax
80105de7:	74 23                	je     80105e0c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105de9:	e8 22 e2 ff ff       	call   80104010 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105dee:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105df0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105df4:	85 d2                	test   %edx,%edx
80105df6:	74 60                	je     80105e58 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105df8:	83 c3 01             	add    $0x1,%ebx
80105dfb:	83 fb 10             	cmp    $0x10,%ebx
80105dfe:	75 f0                	jne    80105df0 <sys_open+0x80>
    if(f)
      fileclose(f);
80105e00:	83 ec 0c             	sub    $0xc,%esp
80105e03:	57                   	push   %edi
80105e04:	e8 e7 b0 ff ff       	call   80100ef0 <fileclose>
80105e09:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105e0c:	83 ec 0c             	sub    $0xc,%esp
80105e0f:	56                   	push   %esi
80105e10:	e8 fb bb ff ff       	call   80101a10 <iunlockput>
    end_op();
80105e15:	e8 b6 cf ff ff       	call   80102dd0 <end_op>
    return -1;
80105e1a:	83 c4 10             	add    $0x10,%esp
80105e1d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105e22:	eb 6d                	jmp    80105e91 <sys_open+0x121>
80105e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105e28:	83 ec 0c             	sub    $0xc,%esp
80105e2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105e2e:	31 c9                	xor    %ecx,%ecx
80105e30:	ba 02 00 00 00       	mov    $0x2,%edx
80105e35:	6a 00                	push   $0x0
80105e37:	e8 14 f8 ff ff       	call   80105650 <create>
    if(ip == 0){
80105e3c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105e3f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105e41:	85 c0                	test   %eax,%eax
80105e43:	75 99                	jne    80105dde <sys_open+0x6e>
      end_op();
80105e45:	e8 86 cf ff ff       	call   80102dd0 <end_op>
      return -1;
80105e4a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105e4f:	eb 40                	jmp    80105e91 <sys_open+0x121>
80105e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105e58:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105e5b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105e5f:	56                   	push   %esi
80105e60:	e8 fb b9 ff ff       	call   80101860 <iunlock>
  end_op();
80105e65:	e8 66 cf ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
80105e6a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105e70:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e73:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105e76:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105e79:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105e7b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105e82:	f7 d0                	not    %eax
80105e84:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e87:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105e8a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e8d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105e91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e94:	89 d8                	mov    %ebx,%eax
80105e96:	5b                   	pop    %ebx
80105e97:	5e                   	pop    %esi
80105e98:	5f                   	pop    %edi
80105e99:	5d                   	pop    %ebp
80105e9a:	c3                   	ret    
80105e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e9f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105ea0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105ea3:	85 c9                	test   %ecx,%ecx
80105ea5:	0f 84 33 ff ff ff    	je     80105dde <sys_open+0x6e>
80105eab:	e9 5c ff ff ff       	jmp    80105e0c <sys_open+0x9c>

80105eb0 <sys_mkdir>:

int
sys_mkdir(void)
{
80105eb0:	55                   	push   %ebp
80105eb1:	89 e5                	mov    %esp,%ebp
80105eb3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105eb6:	e8 a5 ce ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105ebb:	83 ec 08             	sub    $0x8,%esp
80105ebe:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ec1:	50                   	push   %eax
80105ec2:	6a 00                	push   $0x0
80105ec4:	e8 97 f6 ff ff       	call   80105560 <argstr>
80105ec9:	83 c4 10             	add    $0x10,%esp
80105ecc:	85 c0                	test   %eax,%eax
80105ece:	78 30                	js     80105f00 <sys_mkdir+0x50>
80105ed0:	83 ec 0c             	sub    $0xc,%esp
80105ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ed6:	31 c9                	xor    %ecx,%ecx
80105ed8:	ba 01 00 00 00       	mov    $0x1,%edx
80105edd:	6a 00                	push   $0x0
80105edf:	e8 6c f7 ff ff       	call   80105650 <create>
80105ee4:	83 c4 10             	add    $0x10,%esp
80105ee7:	85 c0                	test   %eax,%eax
80105ee9:	74 15                	je     80105f00 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105eeb:	83 ec 0c             	sub    $0xc,%esp
80105eee:	50                   	push   %eax
80105eef:	e8 1c bb ff ff       	call   80101a10 <iunlockput>
  end_op();
80105ef4:	e8 d7 ce ff ff       	call   80102dd0 <end_op>
  return 0;
80105ef9:	83 c4 10             	add    $0x10,%esp
80105efc:	31 c0                	xor    %eax,%eax
}
80105efe:	c9                   	leave  
80105eff:	c3                   	ret    
    end_op();
80105f00:	e8 cb ce ff ff       	call   80102dd0 <end_op>
    return -1;
80105f05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f0a:	c9                   	leave  
80105f0b:	c3                   	ret    
80105f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f10 <sys_mknod>:

int
sys_mknod(void)
{
80105f10:	55                   	push   %ebp
80105f11:	89 e5                	mov    %esp,%ebp
80105f13:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105f16:	e8 45 ce ff ff       	call   80102d60 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105f1b:	83 ec 08             	sub    $0x8,%esp
80105f1e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f21:	50                   	push   %eax
80105f22:	6a 00                	push   $0x0
80105f24:	e8 37 f6 ff ff       	call   80105560 <argstr>
80105f29:	83 c4 10             	add    $0x10,%esp
80105f2c:	85 c0                	test   %eax,%eax
80105f2e:	78 60                	js     80105f90 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105f30:	83 ec 08             	sub    $0x8,%esp
80105f33:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f36:	50                   	push   %eax
80105f37:	6a 01                	push   $0x1
80105f39:	e8 62 f5 ff ff       	call   801054a0 <argint>
  if((argstr(0, &path)) < 0 ||
80105f3e:	83 c4 10             	add    $0x10,%esp
80105f41:	85 c0                	test   %eax,%eax
80105f43:	78 4b                	js     80105f90 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105f45:	83 ec 08             	sub    $0x8,%esp
80105f48:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f4b:	50                   	push   %eax
80105f4c:	6a 02                	push   $0x2
80105f4e:	e8 4d f5 ff ff       	call   801054a0 <argint>
     argint(1, &major) < 0 ||
80105f53:	83 c4 10             	add    $0x10,%esp
80105f56:	85 c0                	test   %eax,%eax
80105f58:	78 36                	js     80105f90 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105f5a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105f5e:	83 ec 0c             	sub    $0xc,%esp
80105f61:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105f65:	ba 03 00 00 00       	mov    $0x3,%edx
80105f6a:	50                   	push   %eax
80105f6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105f6e:	e8 dd f6 ff ff       	call   80105650 <create>
     argint(2, &minor) < 0 ||
80105f73:	83 c4 10             	add    $0x10,%esp
80105f76:	85 c0                	test   %eax,%eax
80105f78:	74 16                	je     80105f90 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105f7a:	83 ec 0c             	sub    $0xc,%esp
80105f7d:	50                   	push   %eax
80105f7e:	e8 8d ba ff ff       	call   80101a10 <iunlockput>
  end_op();
80105f83:	e8 48 ce ff ff       	call   80102dd0 <end_op>
  return 0;
80105f88:	83 c4 10             	add    $0x10,%esp
80105f8b:	31 c0                	xor    %eax,%eax
}
80105f8d:	c9                   	leave  
80105f8e:	c3                   	ret    
80105f8f:	90                   	nop
    end_op();
80105f90:	e8 3b ce ff ff       	call   80102dd0 <end_op>
    return -1;
80105f95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f9a:	c9                   	leave  
80105f9b:	c3                   	ret    
80105f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105fa0 <sys_chdir>:

int
sys_chdir(void)
{
80105fa0:	55                   	push   %ebp
80105fa1:	89 e5                	mov    %esp,%ebp
80105fa3:	56                   	push   %esi
80105fa4:	53                   	push   %ebx
80105fa5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105fa8:	e8 63 e0 ff ff       	call   80104010 <myproc>
80105fad:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105faf:	e8 ac cd ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105fb4:	83 ec 08             	sub    $0x8,%esp
80105fb7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fba:	50                   	push   %eax
80105fbb:	6a 00                	push   $0x0
80105fbd:	e8 9e f5 ff ff       	call   80105560 <argstr>
80105fc2:	83 c4 10             	add    $0x10,%esp
80105fc5:	85 c0                	test   %eax,%eax
80105fc7:	78 77                	js     80106040 <sys_chdir+0xa0>
80105fc9:	83 ec 0c             	sub    $0xc,%esp
80105fcc:	ff 75 f4             	push   -0xc(%ebp)
80105fcf:	e8 cc c0 ff ff       	call   801020a0 <namei>
80105fd4:	83 c4 10             	add    $0x10,%esp
80105fd7:	89 c3                	mov    %eax,%ebx
80105fd9:	85 c0                	test   %eax,%eax
80105fdb:	74 63                	je     80106040 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105fdd:	83 ec 0c             	sub    $0xc,%esp
80105fe0:	50                   	push   %eax
80105fe1:	e8 9a b7 ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
80105fe6:	83 c4 10             	add    $0x10,%esp
80105fe9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105fee:	75 30                	jne    80106020 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105ff0:	83 ec 0c             	sub    $0xc,%esp
80105ff3:	53                   	push   %ebx
80105ff4:	e8 67 b8 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
80105ff9:	58                   	pop    %eax
80105ffa:	ff 76 68             	push   0x68(%esi)
80105ffd:	e8 ae b8 ff ff       	call   801018b0 <iput>
  end_op();
80106002:	e8 c9 cd ff ff       	call   80102dd0 <end_op>
  curproc->cwd = ip;
80106007:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010600a:	83 c4 10             	add    $0x10,%esp
8010600d:	31 c0                	xor    %eax,%eax
}
8010600f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106012:	5b                   	pop    %ebx
80106013:	5e                   	pop    %esi
80106014:	5d                   	pop    %ebp
80106015:	c3                   	ret    
80106016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010601d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80106020:	83 ec 0c             	sub    $0xc,%esp
80106023:	53                   	push   %ebx
80106024:	e8 e7 b9 ff ff       	call   80101a10 <iunlockput>
    end_op();
80106029:	e8 a2 cd ff ff       	call   80102dd0 <end_op>
    return -1;
8010602e:	83 c4 10             	add    $0x10,%esp
80106031:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106036:	eb d7                	jmp    8010600f <sys_chdir+0x6f>
80106038:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010603f:	90                   	nop
    end_op();
80106040:	e8 8b cd ff ff       	call   80102dd0 <end_op>
    return -1;
80106045:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010604a:	eb c3                	jmp    8010600f <sys_chdir+0x6f>
8010604c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106050 <sys_exec>:

int
sys_exec(void)
{
80106050:	55                   	push   %ebp
80106051:	89 e5                	mov    %esp,%ebp
80106053:	57                   	push   %edi
80106054:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106055:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010605b:	53                   	push   %ebx
8010605c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106062:	50                   	push   %eax
80106063:	6a 00                	push   $0x0
80106065:	e8 f6 f4 ff ff       	call   80105560 <argstr>
8010606a:	83 c4 10             	add    $0x10,%esp
8010606d:	85 c0                	test   %eax,%eax
8010606f:	0f 88 87 00 00 00    	js     801060fc <sys_exec+0xac>
80106075:	83 ec 08             	sub    $0x8,%esp
80106078:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010607e:	50                   	push   %eax
8010607f:	6a 01                	push   $0x1
80106081:	e8 1a f4 ff ff       	call   801054a0 <argint>
80106086:	83 c4 10             	add    $0x10,%esp
80106089:	85 c0                	test   %eax,%eax
8010608b:	78 6f                	js     801060fc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010608d:	83 ec 04             	sub    $0x4,%esp
80106090:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80106096:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80106098:	68 80 00 00 00       	push   $0x80
8010609d:	6a 00                	push   $0x0
8010609f:	56                   	push   %esi
801060a0:	e8 3b f1 ff ff       	call   801051e0 <memset>
801060a5:	83 c4 10             	add    $0x10,%esp
801060a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060af:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801060b0:	83 ec 08             	sub    $0x8,%esp
801060b3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801060b9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801060c0:	50                   	push   %eax
801060c1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801060c7:	01 f8                	add    %edi,%eax
801060c9:	50                   	push   %eax
801060ca:	e8 41 f3 ff ff       	call   80105410 <fetchint>
801060cf:	83 c4 10             	add    $0x10,%esp
801060d2:	85 c0                	test   %eax,%eax
801060d4:	78 26                	js     801060fc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801060d6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801060dc:	85 c0                	test   %eax,%eax
801060de:	74 30                	je     80106110 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801060e0:	83 ec 08             	sub    $0x8,%esp
801060e3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801060e6:	52                   	push   %edx
801060e7:	50                   	push   %eax
801060e8:	e8 63 f3 ff ff       	call   80105450 <fetchstr>
801060ed:	83 c4 10             	add    $0x10,%esp
801060f0:	85 c0                	test   %eax,%eax
801060f2:	78 08                	js     801060fc <sys_exec+0xac>
  for(i=0;; i++){
801060f4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801060f7:	83 fb 20             	cmp    $0x20,%ebx
801060fa:	75 b4                	jne    801060b0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801060fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801060ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106104:	5b                   	pop    %ebx
80106105:	5e                   	pop    %esi
80106106:	5f                   	pop    %edi
80106107:	5d                   	pop    %ebp
80106108:	c3                   	ret    
80106109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80106110:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106117:	00 00 00 00 
  return exec(path, argv);
8010611b:	83 ec 08             	sub    $0x8,%esp
8010611e:	56                   	push   %esi
8010611f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80106125:	e8 86 a9 ff ff       	call   80100ab0 <exec>
8010612a:	83 c4 10             	add    $0x10,%esp
}
8010612d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106130:	5b                   	pop    %ebx
80106131:	5e                   	pop    %esi
80106132:	5f                   	pop    %edi
80106133:	5d                   	pop    %ebp
80106134:	c3                   	ret    
80106135:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010613c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106140 <sys_pipe>:

int
sys_pipe(void)
{
80106140:	55                   	push   %ebp
80106141:	89 e5                	mov    %esp,%ebp
80106143:	57                   	push   %edi
80106144:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106145:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106148:	53                   	push   %ebx
80106149:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010614c:	6a 08                	push   $0x8
8010614e:	50                   	push   %eax
8010614f:	6a 00                	push   $0x0
80106151:	e8 9a f3 ff ff       	call   801054f0 <argptr>
80106156:	83 c4 10             	add    $0x10,%esp
80106159:	85 c0                	test   %eax,%eax
8010615b:	78 4a                	js     801061a7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010615d:	83 ec 08             	sub    $0x8,%esp
80106160:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106163:	50                   	push   %eax
80106164:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106167:	50                   	push   %eax
80106168:	e8 c3 d2 ff ff       	call   80103430 <pipealloc>
8010616d:	83 c4 10             	add    $0x10,%esp
80106170:	85 c0                	test   %eax,%eax
80106172:	78 33                	js     801061a7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106174:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80106177:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106179:	e8 92 de ff ff       	call   80104010 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010617e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80106180:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80106184:	85 f6                	test   %esi,%esi
80106186:	74 28                	je     801061b0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80106188:	83 c3 01             	add    $0x1,%ebx
8010618b:	83 fb 10             	cmp    $0x10,%ebx
8010618e:	75 f0                	jne    80106180 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106190:	83 ec 0c             	sub    $0xc,%esp
80106193:	ff 75 e0             	push   -0x20(%ebp)
80106196:	e8 55 ad ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
8010619b:	58                   	pop    %eax
8010619c:	ff 75 e4             	push   -0x1c(%ebp)
8010619f:	e8 4c ad ff ff       	call   80100ef0 <fileclose>
    return -1;
801061a4:	83 c4 10             	add    $0x10,%esp
801061a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061ac:	eb 53                	jmp    80106201 <sys_pipe+0xc1>
801061ae:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801061b0:	8d 73 08             	lea    0x8(%ebx),%esi
801061b3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801061b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801061ba:	e8 51 de ff ff       	call   80104010 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801061bf:	31 d2                	xor    %edx,%edx
801061c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801061c8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801061cc:	85 c9                	test   %ecx,%ecx
801061ce:	74 20                	je     801061f0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801061d0:	83 c2 01             	add    $0x1,%edx
801061d3:	83 fa 10             	cmp    $0x10,%edx
801061d6:	75 f0                	jne    801061c8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801061d8:	e8 33 de ff ff       	call   80104010 <myproc>
801061dd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801061e4:	00 
801061e5:	eb a9                	jmp    80106190 <sys_pipe+0x50>
801061e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061ee:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801061f0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801061f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801061f7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801061f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801061fc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801061ff:	31 c0                	xor    %eax,%eax
}
80106201:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106204:	5b                   	pop    %ebx
80106205:	5e                   	pop    %esi
80106206:	5f                   	pop    %edi
80106207:	5d                   	pop    %ebp
80106208:	c3                   	ret    
80106209:	66 90                	xchg   %ax,%ax
8010620b:	66 90                	xchg   %ax,%ax
8010620d:	66 90                	xchg   %ax,%ax
8010620f:	90                   	nop

80106210 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80106210:	e9 db df ff ff       	jmp    801041f0 <fork>
80106215:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010621c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106220 <sys_exit>:
}

int
sys_exit(void)
{
80106220:	55                   	push   %ebp
80106221:	89 e5                	mov    %esp,%ebp
80106223:	83 ec 08             	sub    $0x8,%esp
  exit();
80106226:	e8 65 e4 ff ff       	call   80104690 <exit>
  return 0;  // not reached
}
8010622b:	31 c0                	xor    %eax,%eax
8010622d:	c9                   	leave  
8010622e:	c3                   	ret    
8010622f:	90                   	nop

80106230 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80106230:	e9 5b e5 ff ff       	jmp    80104790 <wait>
80106235:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010623c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106240 <sys_kill>:
}

int
sys_kill(void)
{
80106240:	55                   	push   %ebp
80106241:	89 e5                	mov    %esp,%ebp
80106243:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106246:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106249:	50                   	push   %eax
8010624a:	6a 00                	push   $0x0
8010624c:	e8 4f f2 ff ff       	call   801054a0 <argint>
80106251:	83 c4 10             	add    $0x10,%esp
80106254:	85 c0                	test   %eax,%eax
80106256:	78 18                	js     80106270 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106258:	83 ec 0c             	sub    $0xc,%esp
8010625b:	ff 75 f4             	push   -0xc(%ebp)
8010625e:	e8 7d ea ff ff       	call   80104ce0 <kill>
80106263:	83 c4 10             	add    $0x10,%esp
}
80106266:	c9                   	leave  
80106267:	c3                   	ret    
80106268:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010626f:	90                   	nop
80106270:	c9                   	leave  
    return -1;
80106271:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106276:	c3                   	ret    
80106277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010627e:	66 90                	xchg   %ax,%ax

80106280 <sys_getpid>:

int
sys_getpid(void)
{
80106280:	55                   	push   %ebp
80106281:	89 e5                	mov    %esp,%ebp
80106283:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106286:	e8 85 dd ff ff       	call   80104010 <myproc>
8010628b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010628e:	c9                   	leave  
8010628f:	c3                   	ret    

80106290 <sys_sbrk>:

int
sys_sbrk(void)
{
80106290:	55                   	push   %ebp
80106291:	89 e5                	mov    %esp,%ebp
80106293:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106294:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106297:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010629a:	50                   	push   %eax
8010629b:	6a 00                	push   $0x0
8010629d:	e8 fe f1 ff ff       	call   801054a0 <argint>
801062a2:	83 c4 10             	add    $0x10,%esp
801062a5:	85 c0                	test   %eax,%eax
801062a7:	78 27                	js     801062d0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801062a9:	e8 62 dd ff ff       	call   80104010 <myproc>
  if(growproc(n) < 0)
801062ae:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801062b1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801062b3:	ff 75 f4             	push   -0xc(%ebp)
801062b6:	e8 b5 de ff ff       	call   80104170 <growproc>
801062bb:	83 c4 10             	add    $0x10,%esp
801062be:	85 c0                	test   %eax,%eax
801062c0:	78 0e                	js     801062d0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801062c2:	89 d8                	mov    %ebx,%eax
801062c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801062c7:	c9                   	leave  
801062c8:	c3                   	ret    
801062c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801062d0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801062d5:	eb eb                	jmp    801062c2 <sys_sbrk+0x32>
801062d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062de:	66 90                	xchg   %ax,%ax

801062e0 <sys_sleep>:

int
sys_sleep(void)
{
801062e0:	55                   	push   %ebp
801062e1:	89 e5                	mov    %esp,%ebp
801062e3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801062e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801062e7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801062ea:	50                   	push   %eax
801062eb:	6a 00                	push   $0x0
801062ed:	e8 ae f1 ff ff       	call   801054a0 <argint>
801062f2:	83 c4 10             	add    $0x10,%esp
801062f5:	85 c0                	test   %eax,%eax
801062f7:	0f 88 8a 00 00 00    	js     80106387 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801062fd:	83 ec 0c             	sub    $0xc,%esp
80106300:	68 e0 55 11 80       	push   $0x801155e0
80106305:	e8 16 ee ff ff       	call   80105120 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010630a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010630d:	8b 1d c0 55 11 80    	mov    0x801155c0,%ebx
  while(ticks - ticks0 < n){
80106313:	83 c4 10             	add    $0x10,%esp
80106316:	85 d2                	test   %edx,%edx
80106318:	75 27                	jne    80106341 <sys_sleep+0x61>
8010631a:	eb 54                	jmp    80106370 <sys_sleep+0x90>
8010631c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106320:	83 ec 08             	sub    $0x8,%esp
80106323:	68 e0 55 11 80       	push   $0x801155e0
80106328:	68 c0 55 11 80       	push   $0x801155c0
8010632d:	e8 5e e8 ff ff       	call   80104b90 <sleep>
  while(ticks - ticks0 < n){
80106332:	a1 c0 55 11 80       	mov    0x801155c0,%eax
80106337:	83 c4 10             	add    $0x10,%esp
8010633a:	29 d8                	sub    %ebx,%eax
8010633c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010633f:	73 2f                	jae    80106370 <sys_sleep+0x90>
    if(myproc()->killed){
80106341:	e8 ca dc ff ff       	call   80104010 <myproc>
80106346:	8b 40 24             	mov    0x24(%eax),%eax
80106349:	85 c0                	test   %eax,%eax
8010634b:	74 d3                	je     80106320 <sys_sleep+0x40>
      release(&tickslock);
8010634d:	83 ec 0c             	sub    $0xc,%esp
80106350:	68 e0 55 11 80       	push   $0x801155e0
80106355:	e8 66 ed ff ff       	call   801050c0 <release>
  }
  release(&tickslock);
  return 0;
}
8010635a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010635d:	83 c4 10             	add    $0x10,%esp
80106360:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106365:	c9                   	leave  
80106366:	c3                   	ret    
80106367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010636e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106370:	83 ec 0c             	sub    $0xc,%esp
80106373:	68 e0 55 11 80       	push   $0x801155e0
80106378:	e8 43 ed ff ff       	call   801050c0 <release>
  return 0;
8010637d:	83 c4 10             	add    $0x10,%esp
80106380:	31 c0                	xor    %eax,%eax
}
80106382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106385:	c9                   	leave  
80106386:	c3                   	ret    
    return -1;
80106387:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010638c:	eb f4                	jmp    80106382 <sys_sleep+0xa2>
8010638e:	66 90                	xchg   %ax,%ax

80106390 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106390:	55                   	push   %ebp
80106391:	89 e5                	mov    %esp,%ebp
80106393:	53                   	push   %ebx
80106394:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106397:	68 e0 55 11 80       	push   $0x801155e0
8010639c:	e8 7f ed ff ff       	call   80105120 <acquire>
  xticks = ticks;
801063a1:	8b 1d c0 55 11 80    	mov    0x801155c0,%ebx
  release(&tickslock);
801063a7:	c7 04 24 e0 55 11 80 	movl   $0x801155e0,(%esp)
801063ae:	e8 0d ed ff ff       	call   801050c0 <release>
  return xticks;
}
801063b3:	89 d8                	mov    %ebx,%eax
801063b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801063b8:	c9                   	leave  
801063b9:	c3                   	ret    
801063ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801063c0 <sys_yield>:

int
sys_yield(void)
{
801063c0:	55                   	push   %ebp
801063c1:	89 e5                	mov    %esp,%ebp
801063c3:	83 ec 08             	sub    $0x8,%esp
  yield();
801063c6:	e8 25 e5 ff ff       	call   801048f0 <yield>
  return 0;
}
801063cb:	31 c0                	xor    %eax,%eax
801063cd:	c9                   	leave  
801063ce:	c3                   	ret    
801063cf:	90                   	nop

801063d0 <sys_getlev>:

int
sys_getlev(void)
{
  return getlev();
801063d0:	e9 0b dc ff ff       	jmp    80103fe0 <getlev>
801063d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801063e0 <sys_setpriority>:
}

int
sys_setpriority(void)
{
801063e0:	55                   	push   %ebp
801063e1:	89 e5                	mov    %esp,%ebp
801063e3:	83 ec 20             	sub    $0x20,%esp
  int pid, priority;

  if(argint(0, &pid) < 0)
801063e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801063e9:	50                   	push   %eax
801063ea:	6a 00                	push   $0x0
801063ec:	e8 af f0 ff ff       	call   801054a0 <argint>
801063f1:	83 c4 10             	add    $0x10,%esp
801063f4:	85 c0                	test   %eax,%eax
801063f6:	78 28                	js     80106420 <sys_setpriority+0x40>
    return -1;
  if(argint(1, &priority) < 0)
801063f8:	83 ec 08             	sub    $0x8,%esp
801063fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063fe:	50                   	push   %eax
801063ff:	6a 01                	push   $0x1
80106401:	e8 9a f0 ff ff       	call   801054a0 <argint>
80106406:	83 c4 10             	add    $0x10,%esp
80106409:	85 c0                	test   %eax,%eax
8010640b:	78 13                	js     80106420 <sys_setpriority+0x40>
    return -1;
  return setpriority(pid, priority);
8010640d:	83 ec 08             	sub    $0x8,%esp
80106410:	ff 75 f4             	push   -0xc(%ebp)
80106413:	ff 75 f0             	push   -0x10(%ebp)
80106416:	e8 d5 d8 ff ff       	call   80103cf0 <setpriority>
8010641b:	83 c4 10             	add    $0x10,%esp
}
8010641e:	c9                   	leave  
8010641f:	c3                   	ret    
80106420:	c9                   	leave  
    return -1;
80106421:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106426:	c3                   	ret    
80106427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010642e:	66 90                	xchg   %ax,%ax

80106430 <sys_setmonopoly>:

int
sys_setmonopoly(void)
{
80106430:	55                   	push   %ebp
80106431:	89 e5                	mov    %esp,%ebp
80106433:	83 ec 20             	sub    $0x20,%esp
  int pid, password;

  if(argint(0, &pid) < 0)
80106436:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106439:	50                   	push   %eax
8010643a:	6a 00                	push   $0x0
8010643c:	e8 5f f0 ff ff       	call   801054a0 <argint>
80106441:	83 c4 10             	add    $0x10,%esp
80106444:	85 c0                	test   %eax,%eax
80106446:	78 28                	js     80106470 <sys_setmonopoly+0x40>
    return -1;
  if(argint(1, &password) < 0)
80106448:	83 ec 08             	sub    $0x8,%esp
8010644b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010644e:	50                   	push   %eax
8010644f:	6a 01                	push   $0x1
80106451:	e8 4a f0 ff ff       	call   801054a0 <argint>
80106456:	83 c4 10             	add    $0x10,%esp
80106459:	85 c0                	test   %eax,%eax
8010645b:	78 13                	js     80106470 <sys_setmonopoly+0x40>
    return -1;
  return setmonopoly(pid, password);
8010645d:	83 ec 08             	sub    $0x8,%esp
80106460:	ff 75 f4             	push   -0xc(%ebp)
80106463:	ff 75 f0             	push   -0x10(%ebp)
80106466:	e8 45 e6 ff ff       	call   80104ab0 <setmonopoly>
8010646b:	83 c4 10             	add    $0x10,%esp
}
8010646e:	c9                   	leave  
8010646f:	c3                   	ret    
80106470:	c9                   	leave  
    return -1;
80106471:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106476:	c3                   	ret    
80106477:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010647e:	66 90                	xchg   %ax,%ax

80106480 <sys_monopolize>:

int
sys_monopolize(void)
{
80106480:	55                   	push   %ebp
80106481:	89 e5                	mov    %esp,%ebp
80106483:	83 ec 08             	sub    $0x8,%esp
  monopolize();
80106486:	e8 e5 da ff ff       	call   80103f70 <monopolize>
  return 0;
}
8010648b:	31 c0                	xor    %eax,%eax
8010648d:	c9                   	leave  
8010648e:	c3                   	ret    
8010648f:	90                   	nop

80106490 <sys_unmonopolize>:

int
sys_unmonopolize(void)
{
80106490:	55                   	push   %ebp
80106491:	89 e5                	mov    %esp,%ebp
80106493:	83 ec 08             	sub    $0x8,%esp
  unmonopolize();
80106496:	e8 f5 da ff ff       	call   80103f90 <unmonopolize>
  return 0; 
}
8010649b:	31 c0                	xor    %eax,%eax
8010649d:	c9                   	leave  
8010649e:	c3                   	ret    
8010649f:	90                   	nop

801064a0 <sys_rn_sleep>:

int sys_rn_sleep(void) {
801064a0:	55                   	push   %ebp
801064a1:	89 e5                	mov    %esp,%ebp
801064a3:	57                   	push   %edi
801064a4:	56                   	push   %esi
  int ms, prev, cur, ms_tick;

  if(argint(0, &ms) < 0)
801064a5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
int sys_rn_sleep(void) {
801064a8:	53                   	push   %ebx
801064a9:	83 ec 24             	sub    $0x24,%esp
  if(argint(0, &ms) < 0)
801064ac:	50                   	push   %eax
801064ad:	6a 00                	push   $0x0
801064af:	e8 ec ef ff ff       	call   801054a0 <argint>
801064b4:	83 c4 10             	add    $0x10,%esp
801064b7:	85 c0                	test   %eax,%eax
801064b9:	78 5f                	js     8010651a <sys_rn_sleep+0x7a>
    return -1;

  prev = lapic[0x0390 / 4];
801064bb:	8b 35 80 26 11 80    	mov    0x80112680,%esi
  ms_tick = 0;
  for (; ;) {
    cur = lapic[0x0390 / 4];

    if (cur + 1000000 <= prev) {
      if (++ms_tick == ms) break;
801064c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  ms_tick = 0;
801064c4:	31 db                	xor    %ebx,%ebx
  prev = lapic[0x0390 / 4];
801064c6:	8b 86 90 03 00 00    	mov    0x390(%esi),%eax
  ms_tick = 0;
801064cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cur = lapic[0x0390 / 4];
801064d0:	8b 96 90 03 00 00    	mov    0x390(%esi),%edx
    if (cur + 1000000 <= prev) {
801064d6:	8d 8a 3f 42 0f 00    	lea    0xf423f(%edx),%ecx
801064dc:	39 c1                	cmp    %eax,%ecx
801064de:	7d 1c                	jge    801064fc <sys_rn_sleep+0x5c>
      if (++ms_tick == ms) break;
801064e0:	83 c3 01             	add    $0x1,%ebx
801064e3:	39 df                	cmp    %ebx,%edi
801064e5:	74 29                	je     80106510 <sys_rn_sleep+0x70>
    cur = lapic[0x0390 / 4];
801064e7:	8b 96 90 03 00 00    	mov    0x390(%esi),%edx
      prev -= 1000000;
801064ed:	2d 40 42 0f 00       	sub    $0xf4240,%eax
    if (cur + 1000000 <= prev) {
801064f2:	8d 8a 3f 42 0f 00    	lea    0xf423f(%edx),%ecx
801064f8:	39 c1                	cmp    %eax,%ecx
801064fa:	7c e4                	jl     801064e0 <sys_rn_sleep+0x40>
    } else if (cur >= prev) {
      prev += 10000000;
801064fc:	8d 88 80 96 98 00    	lea    0x989680(%eax),%ecx
80106502:	39 d0                	cmp    %edx,%eax
80106504:	0f 4e c1             	cmovle %ecx,%eax
80106507:	eb c7                	jmp    801064d0 <sys_rn_sleep+0x30>
80106509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
  }
  return 0;
80106510:	31 c0                	xor    %eax,%eax
80106512:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106515:	5b                   	pop    %ebx
80106516:	5e                   	pop    %esi
80106517:	5f                   	pop    %edi
80106518:	5d                   	pop    %ebp
80106519:	c3                   	ret    
    return -1;
8010651a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010651f:	eb f1                	jmp    80106512 <sys_rn_sleep+0x72>

80106521 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106521:	1e                   	push   %ds
  pushl %es
80106522:	06                   	push   %es
  pushl %fs
80106523:	0f a0                	push   %fs
  pushl %gs
80106525:	0f a8                	push   %gs
  pushal
80106527:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106528:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010652c:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010652e:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106530:	54                   	push   %esp
  call trap
80106531:	e8 ca 00 00 00       	call   80106600 <trap>
  addl $4, %esp
80106536:	83 c4 04             	add    $0x4,%esp

80106539 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106539:	61                   	popa   
  popl %gs
8010653a:	0f a9                	pop    %gs
  popl %fs
8010653c:	0f a1                	pop    %fs
  popl %es
8010653e:	07                   	pop    %es
  popl %ds
8010653f:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106540:	83 c4 08             	add    $0x8,%esp
  iret
80106543:	cf                   	iret   
80106544:	66 90                	xchg   %ax,%ax
80106546:	66 90                	xchg   %ax,%ax
80106548:	66 90                	xchg   %ax,%ax
8010654a:	66 90                	xchg   %ax,%ax
8010654c:	66 90                	xchg   %ax,%ax
8010654e:	66 90                	xchg   %ax,%ax

80106550 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106550:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106551:	31 c0                	xor    %eax,%eax
{
80106553:	89 e5                	mov    %esp,%ebp
80106555:	83 ec 08             	sub    $0x8,%esp
80106558:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010655f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106560:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106567:	c7 04 c5 22 56 11 80 	movl   $0x8e000008,-0x7feea9de(,%eax,8)
8010656e:	08 00 00 8e 
80106572:	66 89 14 c5 20 56 11 	mov    %dx,-0x7feea9e0(,%eax,8)
80106579:	80 
8010657a:	c1 ea 10             	shr    $0x10,%edx
8010657d:	66 89 14 c5 26 56 11 	mov    %dx,-0x7feea9da(,%eax,8)
80106584:	80 
  for(i = 0; i < 256; i++)
80106585:	83 c0 01             	add    $0x1,%eax
80106588:	3d 00 01 00 00       	cmp    $0x100,%eax
8010658d:	75 d1                	jne    80106560 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010658f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106592:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106597:	c7 05 22 58 11 80 08 	movl   $0xef000008,0x80115822
8010659e:	00 00 ef 
  initlock(&tickslock, "time");
801065a1:	68 75 87 10 80       	push   $0x80108775
801065a6:	68 e0 55 11 80       	push   $0x801155e0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801065ab:	66 a3 20 58 11 80    	mov    %ax,0x80115820
801065b1:	c1 e8 10             	shr    $0x10,%eax
801065b4:	66 a3 26 58 11 80    	mov    %ax,0x80115826
  initlock(&tickslock, "time");
801065ba:	e8 91 e9 ff ff       	call   80104f50 <initlock>
}
801065bf:	83 c4 10             	add    $0x10,%esp
801065c2:	c9                   	leave  
801065c3:	c3                   	ret    
801065c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801065cf:	90                   	nop

801065d0 <idtinit>:

void
idtinit(void)
{
801065d0:	55                   	push   %ebp
  pd[0] = size-1;
801065d1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801065d6:	89 e5                	mov    %esp,%ebp
801065d8:	83 ec 10             	sub    $0x10,%esp
801065db:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801065df:	b8 20 56 11 80       	mov    $0x80115620,%eax
801065e4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801065e8:	c1 e8 10             	shr    $0x10,%eax
801065eb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801065ef:	8d 45 fa             	lea    -0x6(%ebp),%eax
801065f2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801065f5:	c9                   	leave  
801065f6:	c3                   	ret    
801065f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065fe:	66 90                	xchg   %ax,%ax

80106600 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106600:	55                   	push   %ebp
80106601:	89 e5                	mov    %esp,%ebp
80106603:	57                   	push   %edi
80106604:	56                   	push   %esi
80106605:	53                   	push   %ebx
80106606:	83 ec 1c             	sub    $0x1c,%esp
80106609:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010660c:	8b 43 30             	mov    0x30(%ebx),%eax
8010660f:	83 f8 40             	cmp    $0x40,%eax
80106612:	0f 84 e0 01 00 00    	je     801067f8 <trap+0x1f8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106618:	83 e8 20             	sub    $0x20,%eax
8010661b:	83 f8 1f             	cmp    $0x1f,%eax
8010661e:	0f 87 8c 00 00 00    	ja     801066b0 <trap+0xb0>
80106624:	ff 24 85 1c 88 10 80 	jmp    *-0x7fef77e4(,%eax,4)
8010662b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010662f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106630:	e8 0b bc ff ff       	call   80102240 <ideintr>
    lapiceoi();
80106635:	e8 d6 c2 ff ff       	call   80102910 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010663a:	e8 d1 d9 ff ff       	call   80104010 <myproc>
8010663f:	85 c0                	test   %eax,%eax
80106641:	74 1d                	je     80106660 <trap+0x60>
80106643:	e8 c8 d9 ff ff       	call   80104010 <myproc>
80106648:	8b 78 24             	mov    0x24(%eax),%edi
8010664b:	85 ff                	test   %edi,%edi
8010664d:	74 11                	je     80106660 <trap+0x60>
8010664f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106653:	83 e0 03             	and    $0x3,%eax
80106656:	66 83 f8 03          	cmp    $0x3,%ax
8010665a:	0f 84 60 02 00 00    	je     801068c0 <trap+0x2c0>
  // If interrupts were on while locks held, would need to check nlock.
  /*if(myproc() && myproc()->state == RUNNING &&
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
  */
  if(myproc() && myproc()->state == RUNNING &&
80106660:	e8 ab d9 ff ff       	call   80104010 <myproc>
80106665:	85 c0                	test   %eax,%eax
80106667:	74 0f                	je     80106678 <trap+0x78>
80106669:	e8 a2 d9 ff ff       	call   80104010 <myproc>
8010666e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106672:	0f 84 b8 00 00 00    	je     80106730 <trap+0x130>
        };
      } 
    }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106678:	e8 93 d9 ff ff       	call   80104010 <myproc>
8010667d:	85 c0                	test   %eax,%eax
8010667f:	74 1d                	je     8010669e <trap+0x9e>
80106681:	e8 8a d9 ff ff       	call   80104010 <myproc>
80106686:	8b 40 24             	mov    0x24(%eax),%eax
80106689:	85 c0                	test   %eax,%eax
8010668b:	74 11                	je     8010669e <trap+0x9e>
8010668d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106691:	83 e0 03             	and    $0x3,%eax
80106694:	66 83 f8 03          	cmp    $0x3,%ax
80106698:	0f 84 87 01 00 00    	je     80106825 <trap+0x225>
    exit();
}
8010669e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066a1:	5b                   	pop    %ebx
801066a2:	5e                   	pop    %esi
801066a3:	5f                   	pop    %edi
801066a4:	5d                   	pop    %ebp
801066a5:	c3                   	ret    
801066a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066ad:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
801066b0:	e8 5b d9 ff ff       	call   80104010 <myproc>
801066b5:	8b 7b 38             	mov    0x38(%ebx),%edi
801066b8:	85 c0                	test   %eax,%eax
801066ba:	0f 84 bf 02 00 00    	je     8010697f <trap+0x37f>
801066c0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801066c4:	0f 84 b5 02 00 00    	je     8010697f <trap+0x37f>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801066ca:	0f 20 d1             	mov    %cr2,%ecx
801066cd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066d0:	e8 eb d8 ff ff       	call   80103fc0 <cpuid>
801066d5:	8b 73 30             	mov    0x30(%ebx),%esi
801066d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
801066db:	8b 43 34             	mov    0x34(%ebx),%eax
801066de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
801066e1:	e8 2a d9 ff ff       	call   80104010 <myproc>
801066e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801066e9:	e8 22 d9 ff ff       	call   80104010 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066ee:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801066f1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801066f4:	51                   	push   %ecx
801066f5:	57                   	push   %edi
801066f6:	52                   	push   %edx
801066f7:	ff 75 e4             	push   -0x1c(%ebp)
801066fa:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801066fb:	8b 75 e0             	mov    -0x20(%ebp),%esi
801066fe:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106701:	56                   	push   %esi
80106702:	ff 70 10             	push   0x10(%eax)
80106705:	68 d8 87 10 80       	push   $0x801087d8
8010670a:	e8 91 9f ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
8010670f:	83 c4 20             	add    $0x20,%esp
80106712:	e8 f9 d8 ff ff       	call   80104010 <myproc>
80106717:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010671e:	e8 ed d8 ff ff       	call   80104010 <myproc>
80106723:	85 c0                	test   %eax,%eax
80106725:	0f 85 18 ff ff ff    	jne    80106643 <trap+0x43>
8010672b:	e9 30 ff ff ff       	jmp    80106660 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80106730:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106734:	0f 85 3e ff ff ff    	jne    80106678 <trap+0x78>
      if(myproc()->monopoly == 0) {
8010673a:	e8 d1 d8 ff ff       	call   80104010 <myproc>
8010673f:	8b b0 88 00 00 00    	mov    0x88(%eax),%esi
80106745:	85 f6                	test   %esi,%esi
80106747:	0f 85 93 01 00 00    	jne    801068e0 <trap+0x2e0>
        if(ticks % 100 == 0) {
8010674d:	69 05 c0 55 11 80 29 	imul   $0xc28f5c29,0x801155c0,%eax
80106754:	5c 8f c2 
80106757:	c1 c8 02             	ror    $0x2,%eax
8010675a:	3d 28 5c 8f 02       	cmp    $0x28f5c28,%eax
8010675f:	0f 86 ab 01 00 00    	jbe    80106910 <trap+0x310>
        int level = myproc()->level;
80106765:	e8 a6 d8 ff ff       	call   80104010 <myproc>
8010676a:	8b b0 80 00 00 00    	mov    0x80(%eax),%esi
        int tq = ++myproc()->tq;
80106770:	e8 9b d8 ff ff       	call   80104010 <myproc>
80106775:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
8010677b:	8d 51 01             	lea    0x1(%ecx),%edx
8010677e:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
        if(tq >= 2 + level * 2) {
80106784:	8d 44 36 02          	lea    0x2(%esi,%esi,1),%eax
80106788:	39 c2                	cmp    %eax,%edx
8010678a:	0f 8c e8 fe ff ff    	jl     80106678 <trap+0x78>
          if(myproc()->level == 3) {
80106790:	e8 7b d8 ff ff       	call   80104010 <myproc>
80106795:	83 b8 80 00 00 00 03 	cmpl   $0x3,0x80(%eax)
8010679c:	0f 84 8c 01 00 00    	je     8010692e <trap+0x32e>
          } else if(level == 1 || level == 2) {
801067a2:	8d 46 ff             	lea    -0x1(%esi),%eax
801067a5:	83 f8 01             	cmp    $0x1,%eax
801067a8:	0f 86 6c 01 00 00    	jbe    8010691a <trap+0x31a>
          } else if(level == 0) {
801067ae:	85 f6                	test   %esi,%esi
801067b0:	0f 84 96 01 00 00    	je     8010694c <trap+0x34c>
          yield();
801067b6:	e8 35 e1 ff ff       	call   801048f0 <yield>
801067bb:	e9 b8 fe ff ff       	jmp    80106678 <trap+0x78>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801067c0:	8b 7b 38             	mov    0x38(%ebx),%edi
801067c3:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801067c7:	e8 f4 d7 ff ff       	call   80103fc0 <cpuid>
801067cc:	57                   	push   %edi
801067cd:	56                   	push   %esi
801067ce:	50                   	push   %eax
801067cf:	68 80 87 10 80       	push   $0x80108780
801067d4:	e8 c7 9e ff ff       	call   801006a0 <cprintf>
    lapiceoi();
801067d9:	e8 32 c1 ff ff       	call   80102910 <lapiceoi>
    break;
801067de:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801067e1:	e8 2a d8 ff ff       	call   80104010 <myproc>
801067e6:	85 c0                	test   %eax,%eax
801067e8:	0f 85 55 fe ff ff    	jne    80106643 <trap+0x43>
801067ee:	e9 6d fe ff ff       	jmp    80106660 <trap+0x60>
801067f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801067f7:	90                   	nop
    if(myproc()->killed)
801067f8:	e8 13 d8 ff ff       	call   80104010 <myproc>
801067fd:	8b 40 24             	mov    0x24(%eax),%eax
80106800:	85 c0                	test   %eax,%eax
80106802:	0f 85 c8 00 00 00    	jne    801068d0 <trap+0x2d0>
    myproc()->tf = tf;
80106808:	e8 03 d8 ff ff       	call   80104010 <myproc>
8010680d:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106810:	e8 cb ed ff ff       	call   801055e0 <syscall>
    if(myproc()->killed)
80106815:	e8 f6 d7 ff ff       	call   80104010 <myproc>
8010681a:	8b 40 24             	mov    0x24(%eax),%eax
8010681d:	85 c0                	test   %eax,%eax
8010681f:	0f 84 79 fe ff ff    	je     8010669e <trap+0x9e>
}
80106825:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106828:	5b                   	pop    %ebx
80106829:	5e                   	pop    %esi
8010682a:	5f                   	pop    %edi
8010682b:	5d                   	pop    %ebp
      exit();
8010682c:	e9 5f de ff ff       	jmp    80104690 <exit>
80106831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106838:	e8 e3 02 00 00       	call   80106b20 <uartintr>
    lapiceoi();
8010683d:	e8 ce c0 ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106842:	e8 c9 d7 ff ff       	call   80104010 <myproc>
80106847:	85 c0                	test   %eax,%eax
80106849:	0f 85 f4 fd ff ff    	jne    80106643 <trap+0x43>
8010684f:	e9 0c fe ff ff       	jmp    80106660 <trap+0x60>
80106854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106858:	e8 73 bf ff ff       	call   801027d0 <kbdintr>
    lapiceoi();
8010685d:	e8 ae c0 ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106862:	e8 a9 d7 ff ff       	call   80104010 <myproc>
80106867:	85 c0                	test   %eax,%eax
80106869:	0f 85 d4 fd ff ff    	jne    80106643 <trap+0x43>
8010686f:	e9 ec fd ff ff       	jmp    80106660 <trap+0x60>
80106874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106878:	e8 43 d7 ff ff       	call   80103fc0 <cpuid>
8010687d:	85 c0                	test   %eax,%eax
8010687f:	0f 85 b0 fd ff ff    	jne    80106635 <trap+0x35>
      acquire(&tickslock);
80106885:	83 ec 0c             	sub    $0xc,%esp
80106888:	68 e0 55 11 80       	push   $0x801155e0
8010688d:	e8 8e e8 ff ff       	call   80105120 <acquire>
      wakeup(&ticks);
80106892:	c7 04 24 c0 55 11 80 	movl   $0x801155c0,(%esp)
      ticks++;
80106899:	83 05 c0 55 11 80 01 	addl   $0x1,0x801155c0
      wakeup(&ticks);
801068a0:	e8 0b e4 ff ff       	call   80104cb0 <wakeup>
      release(&tickslock);
801068a5:	c7 04 24 e0 55 11 80 	movl   $0x801155e0,(%esp)
801068ac:	e8 0f e8 ff ff       	call   801050c0 <release>
801068b1:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801068b4:	e9 7c fd ff ff       	jmp    80106635 <trap+0x35>
801068b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
801068c0:	e8 cb dd ff ff       	call   80104690 <exit>
801068c5:	e9 96 fd ff ff       	jmp    80106660 <trap+0x60>
801068ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801068d0:	e8 bb dd ff ff       	call   80104690 <exit>
801068d5:	e9 2e ff ff ff       	jmp    80106808 <trap+0x208>
801068da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else if(myproc()->monopoly == 1) {
801068e0:	e8 2b d7 ff ff       	call   80104010 <myproc>
801068e5:	83 b8 88 00 00 00 01 	cmpl   $0x1,0x88(%eax)
801068ec:	0f 85 86 fd ff ff    	jne    80106678 <trap+0x78>
        if(mycpu()->monopoly == 0) {
801068f2:	e8 19 d6 ff ff       	call   80103f10 <mycpu>
801068f7:	8b 90 b0 00 00 00    	mov    0xb0(%eax),%edx
801068fd:	85 d2                	test   %edx,%edx
801068ff:	0f 85 73 fd ff ff    	jne    80106678 <trap+0x78>
80106905:	e9 ac fe ff ff       	jmp    801067b6 <trap+0x1b6>
8010690a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          yield();
80106910:	e8 db df ff ff       	call   801048f0 <yield>
80106915:	e9 4b fe ff ff       	jmp    80106765 <trap+0x165>
            myproc()->level = 3;
8010691a:	e8 f1 d6 ff ff       	call   80104010 <myproc>
8010691f:	c7 80 80 00 00 00 03 	movl   $0x3,0x80(%eax)
80106926:	00 00 00 
80106929:	e9 88 fe ff ff       	jmp    801067b6 <trap+0x1b6>
            if(myproc()->priority > 0) {
8010692e:	e8 dd d6 ff ff       	call   80104010 <myproc>
80106933:	8b 48 7c             	mov    0x7c(%eax),%ecx
80106936:	85 c9                	test   %ecx,%ecx
80106938:	0f 8e 78 fe ff ff    	jle    801067b6 <trap+0x1b6>
              myproc()->priority--;
8010693e:	e8 cd d6 ff ff       	call   80104010 <myproc>
80106943:	83 68 7c 01          	subl   $0x1,0x7c(%eax)
80106947:	e9 6a fe ff ff       	jmp    801067b6 <trap+0x1b6>
            if(myproc()->pid % 2) {
8010694c:	e8 bf d6 ff ff       	call   80104010 <myproc>
80106951:	f6 40 10 01          	testb  $0x1,0x10(%eax)
80106955:	74 14                	je     8010696b <trap+0x36b>
              myproc()->level = 1;
80106957:	e8 b4 d6 ff ff       	call   80104010 <myproc>
8010695c:	c7 80 80 00 00 00 01 	movl   $0x1,0x80(%eax)
80106963:	00 00 00 
80106966:	e9 4b fe ff ff       	jmp    801067b6 <trap+0x1b6>
              myproc()->level = 2;
8010696b:	e8 a0 d6 ff ff       	call   80104010 <myproc>
80106970:	c7 80 80 00 00 00 02 	movl   $0x2,0x80(%eax)
80106977:	00 00 00 
8010697a:	e9 37 fe ff ff       	jmp    801067b6 <trap+0x1b6>
8010697f:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106982:	e8 39 d6 ff ff       	call   80103fc0 <cpuid>
80106987:	83 ec 0c             	sub    $0xc,%esp
8010698a:	56                   	push   %esi
8010698b:	57                   	push   %edi
8010698c:	50                   	push   %eax
8010698d:	ff 73 30             	push   0x30(%ebx)
80106990:	68 a4 87 10 80       	push   $0x801087a4
80106995:	e8 06 9d ff ff       	call   801006a0 <cprintf>
      panic("trap");
8010699a:	83 c4 14             	add    $0x14,%esp
8010699d:	68 7a 87 10 80       	push   $0x8010877a
801069a2:	e8 d9 99 ff ff       	call   80100380 <panic>
801069a7:	66 90                	xchg   %ax,%ax
801069a9:	66 90                	xchg   %ax,%ax
801069ab:	66 90                	xchg   %ax,%ax
801069ad:	66 90                	xchg   %ax,%ax
801069af:	90                   	nop

801069b0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801069b0:	a1 20 5e 11 80       	mov    0x80115e20,%eax
801069b5:	85 c0                	test   %eax,%eax
801069b7:	74 17                	je     801069d0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801069b9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801069be:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801069bf:	a8 01                	test   $0x1,%al
801069c1:	74 0d                	je     801069d0 <uartgetc+0x20>
801069c3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801069c8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801069c9:	0f b6 c0             	movzbl %al,%eax
801069cc:	c3                   	ret    
801069cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801069d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801069d5:	c3                   	ret    
801069d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069dd:	8d 76 00             	lea    0x0(%esi),%esi

801069e0 <uartinit>:
{
801069e0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801069e1:	31 c9                	xor    %ecx,%ecx
801069e3:	89 c8                	mov    %ecx,%eax
801069e5:	89 e5                	mov    %esp,%ebp
801069e7:	57                   	push   %edi
801069e8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801069ed:	56                   	push   %esi
801069ee:	89 fa                	mov    %edi,%edx
801069f0:	53                   	push   %ebx
801069f1:	83 ec 1c             	sub    $0x1c,%esp
801069f4:	ee                   	out    %al,(%dx)
801069f5:	be fb 03 00 00       	mov    $0x3fb,%esi
801069fa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801069ff:	89 f2                	mov    %esi,%edx
80106a01:	ee                   	out    %al,(%dx)
80106a02:	b8 0c 00 00 00       	mov    $0xc,%eax
80106a07:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106a0c:	ee                   	out    %al,(%dx)
80106a0d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106a12:	89 c8                	mov    %ecx,%eax
80106a14:	89 da                	mov    %ebx,%edx
80106a16:	ee                   	out    %al,(%dx)
80106a17:	b8 03 00 00 00       	mov    $0x3,%eax
80106a1c:	89 f2                	mov    %esi,%edx
80106a1e:	ee                   	out    %al,(%dx)
80106a1f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106a24:	89 c8                	mov    %ecx,%eax
80106a26:	ee                   	out    %al,(%dx)
80106a27:	b8 01 00 00 00       	mov    $0x1,%eax
80106a2c:	89 da                	mov    %ebx,%edx
80106a2e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106a2f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106a34:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106a35:	3c ff                	cmp    $0xff,%al
80106a37:	74 78                	je     80106ab1 <uartinit+0xd1>
  uart = 1;
80106a39:	c7 05 20 5e 11 80 01 	movl   $0x1,0x80115e20
80106a40:	00 00 00 
80106a43:	89 fa                	mov    %edi,%edx
80106a45:	ec                   	in     (%dx),%al
80106a46:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106a4b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106a4c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106a4f:	bf 9c 88 10 80       	mov    $0x8010889c,%edi
80106a54:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106a59:	6a 00                	push   $0x0
80106a5b:	6a 04                	push   $0x4
80106a5d:	e8 1e ba ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106a62:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106a66:	83 c4 10             	add    $0x10,%esp
80106a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106a70:	a1 20 5e 11 80       	mov    0x80115e20,%eax
80106a75:	bb 80 00 00 00       	mov    $0x80,%ebx
80106a7a:	85 c0                	test   %eax,%eax
80106a7c:	75 14                	jne    80106a92 <uartinit+0xb2>
80106a7e:	eb 23                	jmp    80106aa3 <uartinit+0xc3>
    microdelay(10);
80106a80:	83 ec 0c             	sub    $0xc,%esp
80106a83:	6a 0a                	push   $0xa
80106a85:	e8 a6 be ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106a8a:	83 c4 10             	add    $0x10,%esp
80106a8d:	83 eb 01             	sub    $0x1,%ebx
80106a90:	74 07                	je     80106a99 <uartinit+0xb9>
80106a92:	89 f2                	mov    %esi,%edx
80106a94:	ec                   	in     (%dx),%al
80106a95:	a8 20                	test   $0x20,%al
80106a97:	74 e7                	je     80106a80 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106a99:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80106a9d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106aa2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106aa3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106aa7:	83 c7 01             	add    $0x1,%edi
80106aaa:	88 45 e7             	mov    %al,-0x19(%ebp)
80106aad:	84 c0                	test   %al,%al
80106aaf:	75 bf                	jne    80106a70 <uartinit+0x90>
}
80106ab1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ab4:	5b                   	pop    %ebx
80106ab5:	5e                   	pop    %esi
80106ab6:	5f                   	pop    %edi
80106ab7:	5d                   	pop    %ebp
80106ab8:	c3                   	ret    
80106ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ac0 <uartputc>:
  if(!uart)
80106ac0:	a1 20 5e 11 80       	mov    0x80115e20,%eax
80106ac5:	85 c0                	test   %eax,%eax
80106ac7:	74 47                	je     80106b10 <uartputc+0x50>
{
80106ac9:	55                   	push   %ebp
80106aca:	89 e5                	mov    %esp,%ebp
80106acc:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106acd:	be fd 03 00 00       	mov    $0x3fd,%esi
80106ad2:	53                   	push   %ebx
80106ad3:	bb 80 00 00 00       	mov    $0x80,%ebx
80106ad8:	eb 18                	jmp    80106af2 <uartputc+0x32>
80106ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106ae0:	83 ec 0c             	sub    $0xc,%esp
80106ae3:	6a 0a                	push   $0xa
80106ae5:	e8 46 be ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106aea:	83 c4 10             	add    $0x10,%esp
80106aed:	83 eb 01             	sub    $0x1,%ebx
80106af0:	74 07                	je     80106af9 <uartputc+0x39>
80106af2:	89 f2                	mov    %esi,%edx
80106af4:	ec                   	in     (%dx),%al
80106af5:	a8 20                	test   $0x20,%al
80106af7:	74 e7                	je     80106ae0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106af9:	8b 45 08             	mov    0x8(%ebp),%eax
80106afc:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106b01:	ee                   	out    %al,(%dx)
}
80106b02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106b05:	5b                   	pop    %ebx
80106b06:	5e                   	pop    %esi
80106b07:	5d                   	pop    %ebp
80106b08:	c3                   	ret    
80106b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b10:	c3                   	ret    
80106b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b1f:	90                   	nop

80106b20 <uartintr>:

void
uartintr(void)
{
80106b20:	55                   	push   %ebp
80106b21:	89 e5                	mov    %esp,%ebp
80106b23:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106b26:	68 b0 69 10 80       	push   $0x801069b0
80106b2b:	e8 50 9d ff ff       	call   80100880 <consoleintr>
}
80106b30:	83 c4 10             	add    $0x10,%esp
80106b33:	c9                   	leave  
80106b34:	c3                   	ret    

80106b35 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106b35:	6a 00                	push   $0x0
  pushl $0
80106b37:	6a 00                	push   $0x0
  jmp alltraps
80106b39:	e9 e3 f9 ff ff       	jmp    80106521 <alltraps>

80106b3e <vector1>:
.globl vector1
vector1:
  pushl $0
80106b3e:	6a 00                	push   $0x0
  pushl $1
80106b40:	6a 01                	push   $0x1
  jmp alltraps
80106b42:	e9 da f9 ff ff       	jmp    80106521 <alltraps>

80106b47 <vector2>:
.globl vector2
vector2:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $2
80106b49:	6a 02                	push   $0x2
  jmp alltraps
80106b4b:	e9 d1 f9 ff ff       	jmp    80106521 <alltraps>

80106b50 <vector3>:
.globl vector3
vector3:
  pushl $0
80106b50:	6a 00                	push   $0x0
  pushl $3
80106b52:	6a 03                	push   $0x3
  jmp alltraps
80106b54:	e9 c8 f9 ff ff       	jmp    80106521 <alltraps>

80106b59 <vector4>:
.globl vector4
vector4:
  pushl $0
80106b59:	6a 00                	push   $0x0
  pushl $4
80106b5b:	6a 04                	push   $0x4
  jmp alltraps
80106b5d:	e9 bf f9 ff ff       	jmp    80106521 <alltraps>

80106b62 <vector5>:
.globl vector5
vector5:
  pushl $0
80106b62:	6a 00                	push   $0x0
  pushl $5
80106b64:	6a 05                	push   $0x5
  jmp alltraps
80106b66:	e9 b6 f9 ff ff       	jmp    80106521 <alltraps>

80106b6b <vector6>:
.globl vector6
vector6:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $6
80106b6d:	6a 06                	push   $0x6
  jmp alltraps
80106b6f:	e9 ad f9 ff ff       	jmp    80106521 <alltraps>

80106b74 <vector7>:
.globl vector7
vector7:
  pushl $0
80106b74:	6a 00                	push   $0x0
  pushl $7
80106b76:	6a 07                	push   $0x7
  jmp alltraps
80106b78:	e9 a4 f9 ff ff       	jmp    80106521 <alltraps>

80106b7d <vector8>:
.globl vector8
vector8:
  pushl $8
80106b7d:	6a 08                	push   $0x8
  jmp alltraps
80106b7f:	e9 9d f9 ff ff       	jmp    80106521 <alltraps>

80106b84 <vector9>:
.globl vector9
vector9:
  pushl $0
80106b84:	6a 00                	push   $0x0
  pushl $9
80106b86:	6a 09                	push   $0x9
  jmp alltraps
80106b88:	e9 94 f9 ff ff       	jmp    80106521 <alltraps>

80106b8d <vector10>:
.globl vector10
vector10:
  pushl $10
80106b8d:	6a 0a                	push   $0xa
  jmp alltraps
80106b8f:	e9 8d f9 ff ff       	jmp    80106521 <alltraps>

80106b94 <vector11>:
.globl vector11
vector11:
  pushl $11
80106b94:	6a 0b                	push   $0xb
  jmp alltraps
80106b96:	e9 86 f9 ff ff       	jmp    80106521 <alltraps>

80106b9b <vector12>:
.globl vector12
vector12:
  pushl $12
80106b9b:	6a 0c                	push   $0xc
  jmp alltraps
80106b9d:	e9 7f f9 ff ff       	jmp    80106521 <alltraps>

80106ba2 <vector13>:
.globl vector13
vector13:
  pushl $13
80106ba2:	6a 0d                	push   $0xd
  jmp alltraps
80106ba4:	e9 78 f9 ff ff       	jmp    80106521 <alltraps>

80106ba9 <vector14>:
.globl vector14
vector14:
  pushl $14
80106ba9:	6a 0e                	push   $0xe
  jmp alltraps
80106bab:	e9 71 f9 ff ff       	jmp    80106521 <alltraps>

80106bb0 <vector15>:
.globl vector15
vector15:
  pushl $0
80106bb0:	6a 00                	push   $0x0
  pushl $15
80106bb2:	6a 0f                	push   $0xf
  jmp alltraps
80106bb4:	e9 68 f9 ff ff       	jmp    80106521 <alltraps>

80106bb9 <vector16>:
.globl vector16
vector16:
  pushl $0
80106bb9:	6a 00                	push   $0x0
  pushl $16
80106bbb:	6a 10                	push   $0x10
  jmp alltraps
80106bbd:	e9 5f f9 ff ff       	jmp    80106521 <alltraps>

80106bc2 <vector17>:
.globl vector17
vector17:
  pushl $17
80106bc2:	6a 11                	push   $0x11
  jmp alltraps
80106bc4:	e9 58 f9 ff ff       	jmp    80106521 <alltraps>

80106bc9 <vector18>:
.globl vector18
vector18:
  pushl $0
80106bc9:	6a 00                	push   $0x0
  pushl $18
80106bcb:	6a 12                	push   $0x12
  jmp alltraps
80106bcd:	e9 4f f9 ff ff       	jmp    80106521 <alltraps>

80106bd2 <vector19>:
.globl vector19
vector19:
  pushl $0
80106bd2:	6a 00                	push   $0x0
  pushl $19
80106bd4:	6a 13                	push   $0x13
  jmp alltraps
80106bd6:	e9 46 f9 ff ff       	jmp    80106521 <alltraps>

80106bdb <vector20>:
.globl vector20
vector20:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $20
80106bdd:	6a 14                	push   $0x14
  jmp alltraps
80106bdf:	e9 3d f9 ff ff       	jmp    80106521 <alltraps>

80106be4 <vector21>:
.globl vector21
vector21:
  pushl $0
80106be4:	6a 00                	push   $0x0
  pushl $21
80106be6:	6a 15                	push   $0x15
  jmp alltraps
80106be8:	e9 34 f9 ff ff       	jmp    80106521 <alltraps>

80106bed <vector22>:
.globl vector22
vector22:
  pushl $0
80106bed:	6a 00                	push   $0x0
  pushl $22
80106bef:	6a 16                	push   $0x16
  jmp alltraps
80106bf1:	e9 2b f9 ff ff       	jmp    80106521 <alltraps>

80106bf6 <vector23>:
.globl vector23
vector23:
  pushl $0
80106bf6:	6a 00                	push   $0x0
  pushl $23
80106bf8:	6a 17                	push   $0x17
  jmp alltraps
80106bfa:	e9 22 f9 ff ff       	jmp    80106521 <alltraps>

80106bff <vector24>:
.globl vector24
vector24:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $24
80106c01:	6a 18                	push   $0x18
  jmp alltraps
80106c03:	e9 19 f9 ff ff       	jmp    80106521 <alltraps>

80106c08 <vector25>:
.globl vector25
vector25:
  pushl $0
80106c08:	6a 00                	push   $0x0
  pushl $25
80106c0a:	6a 19                	push   $0x19
  jmp alltraps
80106c0c:	e9 10 f9 ff ff       	jmp    80106521 <alltraps>

80106c11 <vector26>:
.globl vector26
vector26:
  pushl $0
80106c11:	6a 00                	push   $0x0
  pushl $26
80106c13:	6a 1a                	push   $0x1a
  jmp alltraps
80106c15:	e9 07 f9 ff ff       	jmp    80106521 <alltraps>

80106c1a <vector27>:
.globl vector27
vector27:
  pushl $0
80106c1a:	6a 00                	push   $0x0
  pushl $27
80106c1c:	6a 1b                	push   $0x1b
  jmp alltraps
80106c1e:	e9 fe f8 ff ff       	jmp    80106521 <alltraps>

80106c23 <vector28>:
.globl vector28
vector28:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $28
80106c25:	6a 1c                	push   $0x1c
  jmp alltraps
80106c27:	e9 f5 f8 ff ff       	jmp    80106521 <alltraps>

80106c2c <vector29>:
.globl vector29
vector29:
  pushl $0
80106c2c:	6a 00                	push   $0x0
  pushl $29
80106c2e:	6a 1d                	push   $0x1d
  jmp alltraps
80106c30:	e9 ec f8 ff ff       	jmp    80106521 <alltraps>

80106c35 <vector30>:
.globl vector30
vector30:
  pushl $0
80106c35:	6a 00                	push   $0x0
  pushl $30
80106c37:	6a 1e                	push   $0x1e
  jmp alltraps
80106c39:	e9 e3 f8 ff ff       	jmp    80106521 <alltraps>

80106c3e <vector31>:
.globl vector31
vector31:
  pushl $0
80106c3e:	6a 00                	push   $0x0
  pushl $31
80106c40:	6a 1f                	push   $0x1f
  jmp alltraps
80106c42:	e9 da f8 ff ff       	jmp    80106521 <alltraps>

80106c47 <vector32>:
.globl vector32
vector32:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $32
80106c49:	6a 20                	push   $0x20
  jmp alltraps
80106c4b:	e9 d1 f8 ff ff       	jmp    80106521 <alltraps>

80106c50 <vector33>:
.globl vector33
vector33:
  pushl $0
80106c50:	6a 00                	push   $0x0
  pushl $33
80106c52:	6a 21                	push   $0x21
  jmp alltraps
80106c54:	e9 c8 f8 ff ff       	jmp    80106521 <alltraps>

80106c59 <vector34>:
.globl vector34
vector34:
  pushl $0
80106c59:	6a 00                	push   $0x0
  pushl $34
80106c5b:	6a 22                	push   $0x22
  jmp alltraps
80106c5d:	e9 bf f8 ff ff       	jmp    80106521 <alltraps>

80106c62 <vector35>:
.globl vector35
vector35:
  pushl $0
80106c62:	6a 00                	push   $0x0
  pushl $35
80106c64:	6a 23                	push   $0x23
  jmp alltraps
80106c66:	e9 b6 f8 ff ff       	jmp    80106521 <alltraps>

80106c6b <vector36>:
.globl vector36
vector36:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $36
80106c6d:	6a 24                	push   $0x24
  jmp alltraps
80106c6f:	e9 ad f8 ff ff       	jmp    80106521 <alltraps>

80106c74 <vector37>:
.globl vector37
vector37:
  pushl $0
80106c74:	6a 00                	push   $0x0
  pushl $37
80106c76:	6a 25                	push   $0x25
  jmp alltraps
80106c78:	e9 a4 f8 ff ff       	jmp    80106521 <alltraps>

80106c7d <vector38>:
.globl vector38
vector38:
  pushl $0
80106c7d:	6a 00                	push   $0x0
  pushl $38
80106c7f:	6a 26                	push   $0x26
  jmp alltraps
80106c81:	e9 9b f8 ff ff       	jmp    80106521 <alltraps>

80106c86 <vector39>:
.globl vector39
vector39:
  pushl $0
80106c86:	6a 00                	push   $0x0
  pushl $39
80106c88:	6a 27                	push   $0x27
  jmp alltraps
80106c8a:	e9 92 f8 ff ff       	jmp    80106521 <alltraps>

80106c8f <vector40>:
.globl vector40
vector40:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $40
80106c91:	6a 28                	push   $0x28
  jmp alltraps
80106c93:	e9 89 f8 ff ff       	jmp    80106521 <alltraps>

80106c98 <vector41>:
.globl vector41
vector41:
  pushl $0
80106c98:	6a 00                	push   $0x0
  pushl $41
80106c9a:	6a 29                	push   $0x29
  jmp alltraps
80106c9c:	e9 80 f8 ff ff       	jmp    80106521 <alltraps>

80106ca1 <vector42>:
.globl vector42
vector42:
  pushl $0
80106ca1:	6a 00                	push   $0x0
  pushl $42
80106ca3:	6a 2a                	push   $0x2a
  jmp alltraps
80106ca5:	e9 77 f8 ff ff       	jmp    80106521 <alltraps>

80106caa <vector43>:
.globl vector43
vector43:
  pushl $0
80106caa:	6a 00                	push   $0x0
  pushl $43
80106cac:	6a 2b                	push   $0x2b
  jmp alltraps
80106cae:	e9 6e f8 ff ff       	jmp    80106521 <alltraps>

80106cb3 <vector44>:
.globl vector44
vector44:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $44
80106cb5:	6a 2c                	push   $0x2c
  jmp alltraps
80106cb7:	e9 65 f8 ff ff       	jmp    80106521 <alltraps>

80106cbc <vector45>:
.globl vector45
vector45:
  pushl $0
80106cbc:	6a 00                	push   $0x0
  pushl $45
80106cbe:	6a 2d                	push   $0x2d
  jmp alltraps
80106cc0:	e9 5c f8 ff ff       	jmp    80106521 <alltraps>

80106cc5 <vector46>:
.globl vector46
vector46:
  pushl $0
80106cc5:	6a 00                	push   $0x0
  pushl $46
80106cc7:	6a 2e                	push   $0x2e
  jmp alltraps
80106cc9:	e9 53 f8 ff ff       	jmp    80106521 <alltraps>

80106cce <vector47>:
.globl vector47
vector47:
  pushl $0
80106cce:	6a 00                	push   $0x0
  pushl $47
80106cd0:	6a 2f                	push   $0x2f
  jmp alltraps
80106cd2:	e9 4a f8 ff ff       	jmp    80106521 <alltraps>

80106cd7 <vector48>:
.globl vector48
vector48:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $48
80106cd9:	6a 30                	push   $0x30
  jmp alltraps
80106cdb:	e9 41 f8 ff ff       	jmp    80106521 <alltraps>

80106ce0 <vector49>:
.globl vector49
vector49:
  pushl $0
80106ce0:	6a 00                	push   $0x0
  pushl $49
80106ce2:	6a 31                	push   $0x31
  jmp alltraps
80106ce4:	e9 38 f8 ff ff       	jmp    80106521 <alltraps>

80106ce9 <vector50>:
.globl vector50
vector50:
  pushl $0
80106ce9:	6a 00                	push   $0x0
  pushl $50
80106ceb:	6a 32                	push   $0x32
  jmp alltraps
80106ced:	e9 2f f8 ff ff       	jmp    80106521 <alltraps>

80106cf2 <vector51>:
.globl vector51
vector51:
  pushl $0
80106cf2:	6a 00                	push   $0x0
  pushl $51
80106cf4:	6a 33                	push   $0x33
  jmp alltraps
80106cf6:	e9 26 f8 ff ff       	jmp    80106521 <alltraps>

80106cfb <vector52>:
.globl vector52
vector52:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $52
80106cfd:	6a 34                	push   $0x34
  jmp alltraps
80106cff:	e9 1d f8 ff ff       	jmp    80106521 <alltraps>

80106d04 <vector53>:
.globl vector53
vector53:
  pushl $0
80106d04:	6a 00                	push   $0x0
  pushl $53
80106d06:	6a 35                	push   $0x35
  jmp alltraps
80106d08:	e9 14 f8 ff ff       	jmp    80106521 <alltraps>

80106d0d <vector54>:
.globl vector54
vector54:
  pushl $0
80106d0d:	6a 00                	push   $0x0
  pushl $54
80106d0f:	6a 36                	push   $0x36
  jmp alltraps
80106d11:	e9 0b f8 ff ff       	jmp    80106521 <alltraps>

80106d16 <vector55>:
.globl vector55
vector55:
  pushl $0
80106d16:	6a 00                	push   $0x0
  pushl $55
80106d18:	6a 37                	push   $0x37
  jmp alltraps
80106d1a:	e9 02 f8 ff ff       	jmp    80106521 <alltraps>

80106d1f <vector56>:
.globl vector56
vector56:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $56
80106d21:	6a 38                	push   $0x38
  jmp alltraps
80106d23:	e9 f9 f7 ff ff       	jmp    80106521 <alltraps>

80106d28 <vector57>:
.globl vector57
vector57:
  pushl $0
80106d28:	6a 00                	push   $0x0
  pushl $57
80106d2a:	6a 39                	push   $0x39
  jmp alltraps
80106d2c:	e9 f0 f7 ff ff       	jmp    80106521 <alltraps>

80106d31 <vector58>:
.globl vector58
vector58:
  pushl $0
80106d31:	6a 00                	push   $0x0
  pushl $58
80106d33:	6a 3a                	push   $0x3a
  jmp alltraps
80106d35:	e9 e7 f7 ff ff       	jmp    80106521 <alltraps>

80106d3a <vector59>:
.globl vector59
vector59:
  pushl $0
80106d3a:	6a 00                	push   $0x0
  pushl $59
80106d3c:	6a 3b                	push   $0x3b
  jmp alltraps
80106d3e:	e9 de f7 ff ff       	jmp    80106521 <alltraps>

80106d43 <vector60>:
.globl vector60
vector60:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $60
80106d45:	6a 3c                	push   $0x3c
  jmp alltraps
80106d47:	e9 d5 f7 ff ff       	jmp    80106521 <alltraps>

80106d4c <vector61>:
.globl vector61
vector61:
  pushl $0
80106d4c:	6a 00                	push   $0x0
  pushl $61
80106d4e:	6a 3d                	push   $0x3d
  jmp alltraps
80106d50:	e9 cc f7 ff ff       	jmp    80106521 <alltraps>

80106d55 <vector62>:
.globl vector62
vector62:
  pushl $0
80106d55:	6a 00                	push   $0x0
  pushl $62
80106d57:	6a 3e                	push   $0x3e
  jmp alltraps
80106d59:	e9 c3 f7 ff ff       	jmp    80106521 <alltraps>

80106d5e <vector63>:
.globl vector63
vector63:
  pushl $0
80106d5e:	6a 00                	push   $0x0
  pushl $63
80106d60:	6a 3f                	push   $0x3f
  jmp alltraps
80106d62:	e9 ba f7 ff ff       	jmp    80106521 <alltraps>

80106d67 <vector64>:
.globl vector64
vector64:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $64
80106d69:	6a 40                	push   $0x40
  jmp alltraps
80106d6b:	e9 b1 f7 ff ff       	jmp    80106521 <alltraps>

80106d70 <vector65>:
.globl vector65
vector65:
  pushl $0
80106d70:	6a 00                	push   $0x0
  pushl $65
80106d72:	6a 41                	push   $0x41
  jmp alltraps
80106d74:	e9 a8 f7 ff ff       	jmp    80106521 <alltraps>

80106d79 <vector66>:
.globl vector66
vector66:
  pushl $0
80106d79:	6a 00                	push   $0x0
  pushl $66
80106d7b:	6a 42                	push   $0x42
  jmp alltraps
80106d7d:	e9 9f f7 ff ff       	jmp    80106521 <alltraps>

80106d82 <vector67>:
.globl vector67
vector67:
  pushl $0
80106d82:	6a 00                	push   $0x0
  pushl $67
80106d84:	6a 43                	push   $0x43
  jmp alltraps
80106d86:	e9 96 f7 ff ff       	jmp    80106521 <alltraps>

80106d8b <vector68>:
.globl vector68
vector68:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $68
80106d8d:	6a 44                	push   $0x44
  jmp alltraps
80106d8f:	e9 8d f7 ff ff       	jmp    80106521 <alltraps>

80106d94 <vector69>:
.globl vector69
vector69:
  pushl $0
80106d94:	6a 00                	push   $0x0
  pushl $69
80106d96:	6a 45                	push   $0x45
  jmp alltraps
80106d98:	e9 84 f7 ff ff       	jmp    80106521 <alltraps>

80106d9d <vector70>:
.globl vector70
vector70:
  pushl $0
80106d9d:	6a 00                	push   $0x0
  pushl $70
80106d9f:	6a 46                	push   $0x46
  jmp alltraps
80106da1:	e9 7b f7 ff ff       	jmp    80106521 <alltraps>

80106da6 <vector71>:
.globl vector71
vector71:
  pushl $0
80106da6:	6a 00                	push   $0x0
  pushl $71
80106da8:	6a 47                	push   $0x47
  jmp alltraps
80106daa:	e9 72 f7 ff ff       	jmp    80106521 <alltraps>

80106daf <vector72>:
.globl vector72
vector72:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $72
80106db1:	6a 48                	push   $0x48
  jmp alltraps
80106db3:	e9 69 f7 ff ff       	jmp    80106521 <alltraps>

80106db8 <vector73>:
.globl vector73
vector73:
  pushl $0
80106db8:	6a 00                	push   $0x0
  pushl $73
80106dba:	6a 49                	push   $0x49
  jmp alltraps
80106dbc:	e9 60 f7 ff ff       	jmp    80106521 <alltraps>

80106dc1 <vector74>:
.globl vector74
vector74:
  pushl $0
80106dc1:	6a 00                	push   $0x0
  pushl $74
80106dc3:	6a 4a                	push   $0x4a
  jmp alltraps
80106dc5:	e9 57 f7 ff ff       	jmp    80106521 <alltraps>

80106dca <vector75>:
.globl vector75
vector75:
  pushl $0
80106dca:	6a 00                	push   $0x0
  pushl $75
80106dcc:	6a 4b                	push   $0x4b
  jmp alltraps
80106dce:	e9 4e f7 ff ff       	jmp    80106521 <alltraps>

80106dd3 <vector76>:
.globl vector76
vector76:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $76
80106dd5:	6a 4c                	push   $0x4c
  jmp alltraps
80106dd7:	e9 45 f7 ff ff       	jmp    80106521 <alltraps>

80106ddc <vector77>:
.globl vector77
vector77:
  pushl $0
80106ddc:	6a 00                	push   $0x0
  pushl $77
80106dde:	6a 4d                	push   $0x4d
  jmp alltraps
80106de0:	e9 3c f7 ff ff       	jmp    80106521 <alltraps>

80106de5 <vector78>:
.globl vector78
vector78:
  pushl $0
80106de5:	6a 00                	push   $0x0
  pushl $78
80106de7:	6a 4e                	push   $0x4e
  jmp alltraps
80106de9:	e9 33 f7 ff ff       	jmp    80106521 <alltraps>

80106dee <vector79>:
.globl vector79
vector79:
  pushl $0
80106dee:	6a 00                	push   $0x0
  pushl $79
80106df0:	6a 4f                	push   $0x4f
  jmp alltraps
80106df2:	e9 2a f7 ff ff       	jmp    80106521 <alltraps>

80106df7 <vector80>:
.globl vector80
vector80:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $80
80106df9:	6a 50                	push   $0x50
  jmp alltraps
80106dfb:	e9 21 f7 ff ff       	jmp    80106521 <alltraps>

80106e00 <vector81>:
.globl vector81
vector81:
  pushl $0
80106e00:	6a 00                	push   $0x0
  pushl $81
80106e02:	6a 51                	push   $0x51
  jmp alltraps
80106e04:	e9 18 f7 ff ff       	jmp    80106521 <alltraps>

80106e09 <vector82>:
.globl vector82
vector82:
  pushl $0
80106e09:	6a 00                	push   $0x0
  pushl $82
80106e0b:	6a 52                	push   $0x52
  jmp alltraps
80106e0d:	e9 0f f7 ff ff       	jmp    80106521 <alltraps>

80106e12 <vector83>:
.globl vector83
vector83:
  pushl $0
80106e12:	6a 00                	push   $0x0
  pushl $83
80106e14:	6a 53                	push   $0x53
  jmp alltraps
80106e16:	e9 06 f7 ff ff       	jmp    80106521 <alltraps>

80106e1b <vector84>:
.globl vector84
vector84:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $84
80106e1d:	6a 54                	push   $0x54
  jmp alltraps
80106e1f:	e9 fd f6 ff ff       	jmp    80106521 <alltraps>

80106e24 <vector85>:
.globl vector85
vector85:
  pushl $0
80106e24:	6a 00                	push   $0x0
  pushl $85
80106e26:	6a 55                	push   $0x55
  jmp alltraps
80106e28:	e9 f4 f6 ff ff       	jmp    80106521 <alltraps>

80106e2d <vector86>:
.globl vector86
vector86:
  pushl $0
80106e2d:	6a 00                	push   $0x0
  pushl $86
80106e2f:	6a 56                	push   $0x56
  jmp alltraps
80106e31:	e9 eb f6 ff ff       	jmp    80106521 <alltraps>

80106e36 <vector87>:
.globl vector87
vector87:
  pushl $0
80106e36:	6a 00                	push   $0x0
  pushl $87
80106e38:	6a 57                	push   $0x57
  jmp alltraps
80106e3a:	e9 e2 f6 ff ff       	jmp    80106521 <alltraps>

80106e3f <vector88>:
.globl vector88
vector88:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $88
80106e41:	6a 58                	push   $0x58
  jmp alltraps
80106e43:	e9 d9 f6 ff ff       	jmp    80106521 <alltraps>

80106e48 <vector89>:
.globl vector89
vector89:
  pushl $0
80106e48:	6a 00                	push   $0x0
  pushl $89
80106e4a:	6a 59                	push   $0x59
  jmp alltraps
80106e4c:	e9 d0 f6 ff ff       	jmp    80106521 <alltraps>

80106e51 <vector90>:
.globl vector90
vector90:
  pushl $0
80106e51:	6a 00                	push   $0x0
  pushl $90
80106e53:	6a 5a                	push   $0x5a
  jmp alltraps
80106e55:	e9 c7 f6 ff ff       	jmp    80106521 <alltraps>

80106e5a <vector91>:
.globl vector91
vector91:
  pushl $0
80106e5a:	6a 00                	push   $0x0
  pushl $91
80106e5c:	6a 5b                	push   $0x5b
  jmp alltraps
80106e5e:	e9 be f6 ff ff       	jmp    80106521 <alltraps>

80106e63 <vector92>:
.globl vector92
vector92:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $92
80106e65:	6a 5c                	push   $0x5c
  jmp alltraps
80106e67:	e9 b5 f6 ff ff       	jmp    80106521 <alltraps>

80106e6c <vector93>:
.globl vector93
vector93:
  pushl $0
80106e6c:	6a 00                	push   $0x0
  pushl $93
80106e6e:	6a 5d                	push   $0x5d
  jmp alltraps
80106e70:	e9 ac f6 ff ff       	jmp    80106521 <alltraps>

80106e75 <vector94>:
.globl vector94
vector94:
  pushl $0
80106e75:	6a 00                	push   $0x0
  pushl $94
80106e77:	6a 5e                	push   $0x5e
  jmp alltraps
80106e79:	e9 a3 f6 ff ff       	jmp    80106521 <alltraps>

80106e7e <vector95>:
.globl vector95
vector95:
  pushl $0
80106e7e:	6a 00                	push   $0x0
  pushl $95
80106e80:	6a 5f                	push   $0x5f
  jmp alltraps
80106e82:	e9 9a f6 ff ff       	jmp    80106521 <alltraps>

80106e87 <vector96>:
.globl vector96
vector96:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $96
80106e89:	6a 60                	push   $0x60
  jmp alltraps
80106e8b:	e9 91 f6 ff ff       	jmp    80106521 <alltraps>

80106e90 <vector97>:
.globl vector97
vector97:
  pushl $0
80106e90:	6a 00                	push   $0x0
  pushl $97
80106e92:	6a 61                	push   $0x61
  jmp alltraps
80106e94:	e9 88 f6 ff ff       	jmp    80106521 <alltraps>

80106e99 <vector98>:
.globl vector98
vector98:
  pushl $0
80106e99:	6a 00                	push   $0x0
  pushl $98
80106e9b:	6a 62                	push   $0x62
  jmp alltraps
80106e9d:	e9 7f f6 ff ff       	jmp    80106521 <alltraps>

80106ea2 <vector99>:
.globl vector99
vector99:
  pushl $0
80106ea2:	6a 00                	push   $0x0
  pushl $99
80106ea4:	6a 63                	push   $0x63
  jmp alltraps
80106ea6:	e9 76 f6 ff ff       	jmp    80106521 <alltraps>

80106eab <vector100>:
.globl vector100
vector100:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $100
80106ead:	6a 64                	push   $0x64
  jmp alltraps
80106eaf:	e9 6d f6 ff ff       	jmp    80106521 <alltraps>

80106eb4 <vector101>:
.globl vector101
vector101:
  pushl $0
80106eb4:	6a 00                	push   $0x0
  pushl $101
80106eb6:	6a 65                	push   $0x65
  jmp alltraps
80106eb8:	e9 64 f6 ff ff       	jmp    80106521 <alltraps>

80106ebd <vector102>:
.globl vector102
vector102:
  pushl $0
80106ebd:	6a 00                	push   $0x0
  pushl $102
80106ebf:	6a 66                	push   $0x66
  jmp alltraps
80106ec1:	e9 5b f6 ff ff       	jmp    80106521 <alltraps>

80106ec6 <vector103>:
.globl vector103
vector103:
  pushl $0
80106ec6:	6a 00                	push   $0x0
  pushl $103
80106ec8:	6a 67                	push   $0x67
  jmp alltraps
80106eca:	e9 52 f6 ff ff       	jmp    80106521 <alltraps>

80106ecf <vector104>:
.globl vector104
vector104:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $104
80106ed1:	6a 68                	push   $0x68
  jmp alltraps
80106ed3:	e9 49 f6 ff ff       	jmp    80106521 <alltraps>

80106ed8 <vector105>:
.globl vector105
vector105:
  pushl $0
80106ed8:	6a 00                	push   $0x0
  pushl $105
80106eda:	6a 69                	push   $0x69
  jmp alltraps
80106edc:	e9 40 f6 ff ff       	jmp    80106521 <alltraps>

80106ee1 <vector106>:
.globl vector106
vector106:
  pushl $0
80106ee1:	6a 00                	push   $0x0
  pushl $106
80106ee3:	6a 6a                	push   $0x6a
  jmp alltraps
80106ee5:	e9 37 f6 ff ff       	jmp    80106521 <alltraps>

80106eea <vector107>:
.globl vector107
vector107:
  pushl $0
80106eea:	6a 00                	push   $0x0
  pushl $107
80106eec:	6a 6b                	push   $0x6b
  jmp alltraps
80106eee:	e9 2e f6 ff ff       	jmp    80106521 <alltraps>

80106ef3 <vector108>:
.globl vector108
vector108:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $108
80106ef5:	6a 6c                	push   $0x6c
  jmp alltraps
80106ef7:	e9 25 f6 ff ff       	jmp    80106521 <alltraps>

80106efc <vector109>:
.globl vector109
vector109:
  pushl $0
80106efc:	6a 00                	push   $0x0
  pushl $109
80106efe:	6a 6d                	push   $0x6d
  jmp alltraps
80106f00:	e9 1c f6 ff ff       	jmp    80106521 <alltraps>

80106f05 <vector110>:
.globl vector110
vector110:
  pushl $0
80106f05:	6a 00                	push   $0x0
  pushl $110
80106f07:	6a 6e                	push   $0x6e
  jmp alltraps
80106f09:	e9 13 f6 ff ff       	jmp    80106521 <alltraps>

80106f0e <vector111>:
.globl vector111
vector111:
  pushl $0
80106f0e:	6a 00                	push   $0x0
  pushl $111
80106f10:	6a 6f                	push   $0x6f
  jmp alltraps
80106f12:	e9 0a f6 ff ff       	jmp    80106521 <alltraps>

80106f17 <vector112>:
.globl vector112
vector112:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $112
80106f19:	6a 70                	push   $0x70
  jmp alltraps
80106f1b:	e9 01 f6 ff ff       	jmp    80106521 <alltraps>

80106f20 <vector113>:
.globl vector113
vector113:
  pushl $0
80106f20:	6a 00                	push   $0x0
  pushl $113
80106f22:	6a 71                	push   $0x71
  jmp alltraps
80106f24:	e9 f8 f5 ff ff       	jmp    80106521 <alltraps>

80106f29 <vector114>:
.globl vector114
vector114:
  pushl $0
80106f29:	6a 00                	push   $0x0
  pushl $114
80106f2b:	6a 72                	push   $0x72
  jmp alltraps
80106f2d:	e9 ef f5 ff ff       	jmp    80106521 <alltraps>

80106f32 <vector115>:
.globl vector115
vector115:
  pushl $0
80106f32:	6a 00                	push   $0x0
  pushl $115
80106f34:	6a 73                	push   $0x73
  jmp alltraps
80106f36:	e9 e6 f5 ff ff       	jmp    80106521 <alltraps>

80106f3b <vector116>:
.globl vector116
vector116:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $116
80106f3d:	6a 74                	push   $0x74
  jmp alltraps
80106f3f:	e9 dd f5 ff ff       	jmp    80106521 <alltraps>

80106f44 <vector117>:
.globl vector117
vector117:
  pushl $0
80106f44:	6a 00                	push   $0x0
  pushl $117
80106f46:	6a 75                	push   $0x75
  jmp alltraps
80106f48:	e9 d4 f5 ff ff       	jmp    80106521 <alltraps>

80106f4d <vector118>:
.globl vector118
vector118:
  pushl $0
80106f4d:	6a 00                	push   $0x0
  pushl $118
80106f4f:	6a 76                	push   $0x76
  jmp alltraps
80106f51:	e9 cb f5 ff ff       	jmp    80106521 <alltraps>

80106f56 <vector119>:
.globl vector119
vector119:
  pushl $0
80106f56:	6a 00                	push   $0x0
  pushl $119
80106f58:	6a 77                	push   $0x77
  jmp alltraps
80106f5a:	e9 c2 f5 ff ff       	jmp    80106521 <alltraps>

80106f5f <vector120>:
.globl vector120
vector120:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $120
80106f61:	6a 78                	push   $0x78
  jmp alltraps
80106f63:	e9 b9 f5 ff ff       	jmp    80106521 <alltraps>

80106f68 <vector121>:
.globl vector121
vector121:
  pushl $0
80106f68:	6a 00                	push   $0x0
  pushl $121
80106f6a:	6a 79                	push   $0x79
  jmp alltraps
80106f6c:	e9 b0 f5 ff ff       	jmp    80106521 <alltraps>

80106f71 <vector122>:
.globl vector122
vector122:
  pushl $0
80106f71:	6a 00                	push   $0x0
  pushl $122
80106f73:	6a 7a                	push   $0x7a
  jmp alltraps
80106f75:	e9 a7 f5 ff ff       	jmp    80106521 <alltraps>

80106f7a <vector123>:
.globl vector123
vector123:
  pushl $0
80106f7a:	6a 00                	push   $0x0
  pushl $123
80106f7c:	6a 7b                	push   $0x7b
  jmp alltraps
80106f7e:	e9 9e f5 ff ff       	jmp    80106521 <alltraps>

80106f83 <vector124>:
.globl vector124
vector124:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $124
80106f85:	6a 7c                	push   $0x7c
  jmp alltraps
80106f87:	e9 95 f5 ff ff       	jmp    80106521 <alltraps>

80106f8c <vector125>:
.globl vector125
vector125:
  pushl $0
80106f8c:	6a 00                	push   $0x0
  pushl $125
80106f8e:	6a 7d                	push   $0x7d
  jmp alltraps
80106f90:	e9 8c f5 ff ff       	jmp    80106521 <alltraps>

80106f95 <vector126>:
.globl vector126
vector126:
  pushl $0
80106f95:	6a 00                	push   $0x0
  pushl $126
80106f97:	6a 7e                	push   $0x7e
  jmp alltraps
80106f99:	e9 83 f5 ff ff       	jmp    80106521 <alltraps>

80106f9e <vector127>:
.globl vector127
vector127:
  pushl $0
80106f9e:	6a 00                	push   $0x0
  pushl $127
80106fa0:	6a 7f                	push   $0x7f
  jmp alltraps
80106fa2:	e9 7a f5 ff ff       	jmp    80106521 <alltraps>

80106fa7 <vector128>:
.globl vector128
vector128:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $128
80106fa9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106fae:	e9 6e f5 ff ff       	jmp    80106521 <alltraps>

80106fb3 <vector129>:
.globl vector129
vector129:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $129
80106fb5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106fba:	e9 62 f5 ff ff       	jmp    80106521 <alltraps>

80106fbf <vector130>:
.globl vector130
vector130:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $130
80106fc1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106fc6:	e9 56 f5 ff ff       	jmp    80106521 <alltraps>

80106fcb <vector131>:
.globl vector131
vector131:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $131
80106fcd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106fd2:	e9 4a f5 ff ff       	jmp    80106521 <alltraps>

80106fd7 <vector132>:
.globl vector132
vector132:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $132
80106fd9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106fde:	e9 3e f5 ff ff       	jmp    80106521 <alltraps>

80106fe3 <vector133>:
.globl vector133
vector133:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $133
80106fe5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106fea:	e9 32 f5 ff ff       	jmp    80106521 <alltraps>

80106fef <vector134>:
.globl vector134
vector134:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $134
80106ff1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106ff6:	e9 26 f5 ff ff       	jmp    80106521 <alltraps>

80106ffb <vector135>:
.globl vector135
vector135:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $135
80106ffd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107002:	e9 1a f5 ff ff       	jmp    80106521 <alltraps>

80107007 <vector136>:
.globl vector136
vector136:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $136
80107009:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010700e:	e9 0e f5 ff ff       	jmp    80106521 <alltraps>

80107013 <vector137>:
.globl vector137
vector137:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $137
80107015:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010701a:	e9 02 f5 ff ff       	jmp    80106521 <alltraps>

8010701f <vector138>:
.globl vector138
vector138:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $138
80107021:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107026:	e9 f6 f4 ff ff       	jmp    80106521 <alltraps>

8010702b <vector139>:
.globl vector139
vector139:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $139
8010702d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107032:	e9 ea f4 ff ff       	jmp    80106521 <alltraps>

80107037 <vector140>:
.globl vector140
vector140:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $140
80107039:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010703e:	e9 de f4 ff ff       	jmp    80106521 <alltraps>

80107043 <vector141>:
.globl vector141
vector141:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $141
80107045:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010704a:	e9 d2 f4 ff ff       	jmp    80106521 <alltraps>

8010704f <vector142>:
.globl vector142
vector142:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $142
80107051:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107056:	e9 c6 f4 ff ff       	jmp    80106521 <alltraps>

8010705b <vector143>:
.globl vector143
vector143:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $143
8010705d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107062:	e9 ba f4 ff ff       	jmp    80106521 <alltraps>

80107067 <vector144>:
.globl vector144
vector144:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $144
80107069:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010706e:	e9 ae f4 ff ff       	jmp    80106521 <alltraps>

80107073 <vector145>:
.globl vector145
vector145:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $145
80107075:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010707a:	e9 a2 f4 ff ff       	jmp    80106521 <alltraps>

8010707f <vector146>:
.globl vector146
vector146:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $146
80107081:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107086:	e9 96 f4 ff ff       	jmp    80106521 <alltraps>

8010708b <vector147>:
.globl vector147
vector147:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $147
8010708d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107092:	e9 8a f4 ff ff       	jmp    80106521 <alltraps>

80107097 <vector148>:
.globl vector148
vector148:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $148
80107099:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010709e:	e9 7e f4 ff ff       	jmp    80106521 <alltraps>

801070a3 <vector149>:
.globl vector149
vector149:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $149
801070a5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801070aa:	e9 72 f4 ff ff       	jmp    80106521 <alltraps>

801070af <vector150>:
.globl vector150
vector150:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $150
801070b1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801070b6:	e9 66 f4 ff ff       	jmp    80106521 <alltraps>

801070bb <vector151>:
.globl vector151
vector151:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $151
801070bd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801070c2:	e9 5a f4 ff ff       	jmp    80106521 <alltraps>

801070c7 <vector152>:
.globl vector152
vector152:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $152
801070c9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801070ce:	e9 4e f4 ff ff       	jmp    80106521 <alltraps>

801070d3 <vector153>:
.globl vector153
vector153:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $153
801070d5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801070da:	e9 42 f4 ff ff       	jmp    80106521 <alltraps>

801070df <vector154>:
.globl vector154
vector154:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $154
801070e1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801070e6:	e9 36 f4 ff ff       	jmp    80106521 <alltraps>

801070eb <vector155>:
.globl vector155
vector155:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $155
801070ed:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801070f2:	e9 2a f4 ff ff       	jmp    80106521 <alltraps>

801070f7 <vector156>:
.globl vector156
vector156:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $156
801070f9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801070fe:	e9 1e f4 ff ff       	jmp    80106521 <alltraps>

80107103 <vector157>:
.globl vector157
vector157:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $157
80107105:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010710a:	e9 12 f4 ff ff       	jmp    80106521 <alltraps>

8010710f <vector158>:
.globl vector158
vector158:
  pushl $0
8010710f:	6a 00                	push   $0x0
  pushl $158
80107111:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107116:	e9 06 f4 ff ff       	jmp    80106521 <alltraps>

8010711b <vector159>:
.globl vector159
vector159:
  pushl $0
8010711b:	6a 00                	push   $0x0
  pushl $159
8010711d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107122:	e9 fa f3 ff ff       	jmp    80106521 <alltraps>

80107127 <vector160>:
.globl vector160
vector160:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $160
80107129:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010712e:	e9 ee f3 ff ff       	jmp    80106521 <alltraps>

80107133 <vector161>:
.globl vector161
vector161:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $161
80107135:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010713a:	e9 e2 f3 ff ff       	jmp    80106521 <alltraps>

8010713f <vector162>:
.globl vector162
vector162:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $162
80107141:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107146:	e9 d6 f3 ff ff       	jmp    80106521 <alltraps>

8010714b <vector163>:
.globl vector163
vector163:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $163
8010714d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107152:	e9 ca f3 ff ff       	jmp    80106521 <alltraps>

80107157 <vector164>:
.globl vector164
vector164:
  pushl $0
80107157:	6a 00                	push   $0x0
  pushl $164
80107159:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010715e:	e9 be f3 ff ff       	jmp    80106521 <alltraps>

80107163 <vector165>:
.globl vector165
vector165:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $165
80107165:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010716a:	e9 b2 f3 ff ff       	jmp    80106521 <alltraps>

8010716f <vector166>:
.globl vector166
vector166:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $166
80107171:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107176:	e9 a6 f3 ff ff       	jmp    80106521 <alltraps>

8010717b <vector167>:
.globl vector167
vector167:
  pushl $0
8010717b:	6a 00                	push   $0x0
  pushl $167
8010717d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107182:	e9 9a f3 ff ff       	jmp    80106521 <alltraps>

80107187 <vector168>:
.globl vector168
vector168:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $168
80107189:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010718e:	e9 8e f3 ff ff       	jmp    80106521 <alltraps>

80107193 <vector169>:
.globl vector169
vector169:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $169
80107195:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010719a:	e9 82 f3 ff ff       	jmp    80106521 <alltraps>

8010719f <vector170>:
.globl vector170
vector170:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $170
801071a1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801071a6:	e9 76 f3 ff ff       	jmp    80106521 <alltraps>

801071ab <vector171>:
.globl vector171
vector171:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $171
801071ad:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801071b2:	e9 6a f3 ff ff       	jmp    80106521 <alltraps>

801071b7 <vector172>:
.globl vector172
vector172:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $172
801071b9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801071be:	e9 5e f3 ff ff       	jmp    80106521 <alltraps>

801071c3 <vector173>:
.globl vector173
vector173:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $173
801071c5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801071ca:	e9 52 f3 ff ff       	jmp    80106521 <alltraps>

801071cf <vector174>:
.globl vector174
vector174:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $174
801071d1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801071d6:	e9 46 f3 ff ff       	jmp    80106521 <alltraps>

801071db <vector175>:
.globl vector175
vector175:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $175
801071dd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801071e2:	e9 3a f3 ff ff       	jmp    80106521 <alltraps>

801071e7 <vector176>:
.globl vector176
vector176:
  pushl $0
801071e7:	6a 00                	push   $0x0
  pushl $176
801071e9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801071ee:	e9 2e f3 ff ff       	jmp    80106521 <alltraps>

801071f3 <vector177>:
.globl vector177
vector177:
  pushl $0
801071f3:	6a 00                	push   $0x0
  pushl $177
801071f5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801071fa:	e9 22 f3 ff ff       	jmp    80106521 <alltraps>

801071ff <vector178>:
.globl vector178
vector178:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $178
80107201:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107206:	e9 16 f3 ff ff       	jmp    80106521 <alltraps>

8010720b <vector179>:
.globl vector179
vector179:
  pushl $0
8010720b:	6a 00                	push   $0x0
  pushl $179
8010720d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107212:	e9 0a f3 ff ff       	jmp    80106521 <alltraps>

80107217 <vector180>:
.globl vector180
vector180:
  pushl $0
80107217:	6a 00                	push   $0x0
  pushl $180
80107219:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010721e:	e9 fe f2 ff ff       	jmp    80106521 <alltraps>

80107223 <vector181>:
.globl vector181
vector181:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $181
80107225:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010722a:	e9 f2 f2 ff ff       	jmp    80106521 <alltraps>

8010722f <vector182>:
.globl vector182
vector182:
  pushl $0
8010722f:	6a 00                	push   $0x0
  pushl $182
80107231:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107236:	e9 e6 f2 ff ff       	jmp    80106521 <alltraps>

8010723b <vector183>:
.globl vector183
vector183:
  pushl $0
8010723b:	6a 00                	push   $0x0
  pushl $183
8010723d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107242:	e9 da f2 ff ff       	jmp    80106521 <alltraps>

80107247 <vector184>:
.globl vector184
vector184:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $184
80107249:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010724e:	e9 ce f2 ff ff       	jmp    80106521 <alltraps>

80107253 <vector185>:
.globl vector185
vector185:
  pushl $0
80107253:	6a 00                	push   $0x0
  pushl $185
80107255:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010725a:	e9 c2 f2 ff ff       	jmp    80106521 <alltraps>

8010725f <vector186>:
.globl vector186
vector186:
  pushl $0
8010725f:	6a 00                	push   $0x0
  pushl $186
80107261:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107266:	e9 b6 f2 ff ff       	jmp    80106521 <alltraps>

8010726b <vector187>:
.globl vector187
vector187:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $187
8010726d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107272:	e9 aa f2 ff ff       	jmp    80106521 <alltraps>

80107277 <vector188>:
.globl vector188
vector188:
  pushl $0
80107277:	6a 00                	push   $0x0
  pushl $188
80107279:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010727e:	e9 9e f2 ff ff       	jmp    80106521 <alltraps>

80107283 <vector189>:
.globl vector189
vector189:
  pushl $0
80107283:	6a 00                	push   $0x0
  pushl $189
80107285:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010728a:	e9 92 f2 ff ff       	jmp    80106521 <alltraps>

8010728f <vector190>:
.globl vector190
vector190:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $190
80107291:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107296:	e9 86 f2 ff ff       	jmp    80106521 <alltraps>

8010729b <vector191>:
.globl vector191
vector191:
  pushl $0
8010729b:	6a 00                	push   $0x0
  pushl $191
8010729d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801072a2:	e9 7a f2 ff ff       	jmp    80106521 <alltraps>

801072a7 <vector192>:
.globl vector192
vector192:
  pushl $0
801072a7:	6a 00                	push   $0x0
  pushl $192
801072a9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801072ae:	e9 6e f2 ff ff       	jmp    80106521 <alltraps>

801072b3 <vector193>:
.globl vector193
vector193:
  pushl $0
801072b3:	6a 00                	push   $0x0
  pushl $193
801072b5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801072ba:	e9 62 f2 ff ff       	jmp    80106521 <alltraps>

801072bf <vector194>:
.globl vector194
vector194:
  pushl $0
801072bf:	6a 00                	push   $0x0
  pushl $194
801072c1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801072c6:	e9 56 f2 ff ff       	jmp    80106521 <alltraps>

801072cb <vector195>:
.globl vector195
vector195:
  pushl $0
801072cb:	6a 00                	push   $0x0
  pushl $195
801072cd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801072d2:	e9 4a f2 ff ff       	jmp    80106521 <alltraps>

801072d7 <vector196>:
.globl vector196
vector196:
  pushl $0
801072d7:	6a 00                	push   $0x0
  pushl $196
801072d9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801072de:	e9 3e f2 ff ff       	jmp    80106521 <alltraps>

801072e3 <vector197>:
.globl vector197
vector197:
  pushl $0
801072e3:	6a 00                	push   $0x0
  pushl $197
801072e5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801072ea:	e9 32 f2 ff ff       	jmp    80106521 <alltraps>

801072ef <vector198>:
.globl vector198
vector198:
  pushl $0
801072ef:	6a 00                	push   $0x0
  pushl $198
801072f1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801072f6:	e9 26 f2 ff ff       	jmp    80106521 <alltraps>

801072fb <vector199>:
.globl vector199
vector199:
  pushl $0
801072fb:	6a 00                	push   $0x0
  pushl $199
801072fd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107302:	e9 1a f2 ff ff       	jmp    80106521 <alltraps>

80107307 <vector200>:
.globl vector200
vector200:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $200
80107309:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010730e:	e9 0e f2 ff ff       	jmp    80106521 <alltraps>

80107313 <vector201>:
.globl vector201
vector201:
  pushl $0
80107313:	6a 00                	push   $0x0
  pushl $201
80107315:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010731a:	e9 02 f2 ff ff       	jmp    80106521 <alltraps>

8010731f <vector202>:
.globl vector202
vector202:
  pushl $0
8010731f:	6a 00                	push   $0x0
  pushl $202
80107321:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107326:	e9 f6 f1 ff ff       	jmp    80106521 <alltraps>

8010732b <vector203>:
.globl vector203
vector203:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $203
8010732d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107332:	e9 ea f1 ff ff       	jmp    80106521 <alltraps>

80107337 <vector204>:
.globl vector204
vector204:
  pushl $0
80107337:	6a 00                	push   $0x0
  pushl $204
80107339:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010733e:	e9 de f1 ff ff       	jmp    80106521 <alltraps>

80107343 <vector205>:
.globl vector205
vector205:
  pushl $0
80107343:	6a 00                	push   $0x0
  pushl $205
80107345:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010734a:	e9 d2 f1 ff ff       	jmp    80106521 <alltraps>

8010734f <vector206>:
.globl vector206
vector206:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $206
80107351:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107356:	e9 c6 f1 ff ff       	jmp    80106521 <alltraps>

8010735b <vector207>:
.globl vector207
vector207:
  pushl $0
8010735b:	6a 00                	push   $0x0
  pushl $207
8010735d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107362:	e9 ba f1 ff ff       	jmp    80106521 <alltraps>

80107367 <vector208>:
.globl vector208
vector208:
  pushl $0
80107367:	6a 00                	push   $0x0
  pushl $208
80107369:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010736e:	e9 ae f1 ff ff       	jmp    80106521 <alltraps>

80107373 <vector209>:
.globl vector209
vector209:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $209
80107375:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010737a:	e9 a2 f1 ff ff       	jmp    80106521 <alltraps>

8010737f <vector210>:
.globl vector210
vector210:
  pushl $0
8010737f:	6a 00                	push   $0x0
  pushl $210
80107381:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107386:	e9 96 f1 ff ff       	jmp    80106521 <alltraps>

8010738b <vector211>:
.globl vector211
vector211:
  pushl $0
8010738b:	6a 00                	push   $0x0
  pushl $211
8010738d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107392:	e9 8a f1 ff ff       	jmp    80106521 <alltraps>

80107397 <vector212>:
.globl vector212
vector212:
  pushl $0
80107397:	6a 00                	push   $0x0
  pushl $212
80107399:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010739e:	e9 7e f1 ff ff       	jmp    80106521 <alltraps>

801073a3 <vector213>:
.globl vector213
vector213:
  pushl $0
801073a3:	6a 00                	push   $0x0
  pushl $213
801073a5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801073aa:	e9 72 f1 ff ff       	jmp    80106521 <alltraps>

801073af <vector214>:
.globl vector214
vector214:
  pushl $0
801073af:	6a 00                	push   $0x0
  pushl $214
801073b1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801073b6:	e9 66 f1 ff ff       	jmp    80106521 <alltraps>

801073bb <vector215>:
.globl vector215
vector215:
  pushl $0
801073bb:	6a 00                	push   $0x0
  pushl $215
801073bd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801073c2:	e9 5a f1 ff ff       	jmp    80106521 <alltraps>

801073c7 <vector216>:
.globl vector216
vector216:
  pushl $0
801073c7:	6a 00                	push   $0x0
  pushl $216
801073c9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801073ce:	e9 4e f1 ff ff       	jmp    80106521 <alltraps>

801073d3 <vector217>:
.globl vector217
vector217:
  pushl $0
801073d3:	6a 00                	push   $0x0
  pushl $217
801073d5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801073da:	e9 42 f1 ff ff       	jmp    80106521 <alltraps>

801073df <vector218>:
.globl vector218
vector218:
  pushl $0
801073df:	6a 00                	push   $0x0
  pushl $218
801073e1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801073e6:	e9 36 f1 ff ff       	jmp    80106521 <alltraps>

801073eb <vector219>:
.globl vector219
vector219:
  pushl $0
801073eb:	6a 00                	push   $0x0
  pushl $219
801073ed:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801073f2:	e9 2a f1 ff ff       	jmp    80106521 <alltraps>

801073f7 <vector220>:
.globl vector220
vector220:
  pushl $0
801073f7:	6a 00                	push   $0x0
  pushl $220
801073f9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801073fe:	e9 1e f1 ff ff       	jmp    80106521 <alltraps>

80107403 <vector221>:
.globl vector221
vector221:
  pushl $0
80107403:	6a 00                	push   $0x0
  pushl $221
80107405:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010740a:	e9 12 f1 ff ff       	jmp    80106521 <alltraps>

8010740f <vector222>:
.globl vector222
vector222:
  pushl $0
8010740f:	6a 00                	push   $0x0
  pushl $222
80107411:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107416:	e9 06 f1 ff ff       	jmp    80106521 <alltraps>

8010741b <vector223>:
.globl vector223
vector223:
  pushl $0
8010741b:	6a 00                	push   $0x0
  pushl $223
8010741d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107422:	e9 fa f0 ff ff       	jmp    80106521 <alltraps>

80107427 <vector224>:
.globl vector224
vector224:
  pushl $0
80107427:	6a 00                	push   $0x0
  pushl $224
80107429:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010742e:	e9 ee f0 ff ff       	jmp    80106521 <alltraps>

80107433 <vector225>:
.globl vector225
vector225:
  pushl $0
80107433:	6a 00                	push   $0x0
  pushl $225
80107435:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010743a:	e9 e2 f0 ff ff       	jmp    80106521 <alltraps>

8010743f <vector226>:
.globl vector226
vector226:
  pushl $0
8010743f:	6a 00                	push   $0x0
  pushl $226
80107441:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107446:	e9 d6 f0 ff ff       	jmp    80106521 <alltraps>

8010744b <vector227>:
.globl vector227
vector227:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $227
8010744d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107452:	e9 ca f0 ff ff       	jmp    80106521 <alltraps>

80107457 <vector228>:
.globl vector228
vector228:
  pushl $0
80107457:	6a 00                	push   $0x0
  pushl $228
80107459:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010745e:	e9 be f0 ff ff       	jmp    80106521 <alltraps>

80107463 <vector229>:
.globl vector229
vector229:
  pushl $0
80107463:	6a 00                	push   $0x0
  pushl $229
80107465:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010746a:	e9 b2 f0 ff ff       	jmp    80106521 <alltraps>

8010746f <vector230>:
.globl vector230
vector230:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $230
80107471:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107476:	e9 a6 f0 ff ff       	jmp    80106521 <alltraps>

8010747b <vector231>:
.globl vector231
vector231:
  pushl $0
8010747b:	6a 00                	push   $0x0
  pushl $231
8010747d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107482:	e9 9a f0 ff ff       	jmp    80106521 <alltraps>

80107487 <vector232>:
.globl vector232
vector232:
  pushl $0
80107487:	6a 00                	push   $0x0
  pushl $232
80107489:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010748e:	e9 8e f0 ff ff       	jmp    80106521 <alltraps>

80107493 <vector233>:
.globl vector233
vector233:
  pushl $0
80107493:	6a 00                	push   $0x0
  pushl $233
80107495:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010749a:	e9 82 f0 ff ff       	jmp    80106521 <alltraps>

8010749f <vector234>:
.globl vector234
vector234:
  pushl $0
8010749f:	6a 00                	push   $0x0
  pushl $234
801074a1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801074a6:	e9 76 f0 ff ff       	jmp    80106521 <alltraps>

801074ab <vector235>:
.globl vector235
vector235:
  pushl $0
801074ab:	6a 00                	push   $0x0
  pushl $235
801074ad:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801074b2:	e9 6a f0 ff ff       	jmp    80106521 <alltraps>

801074b7 <vector236>:
.globl vector236
vector236:
  pushl $0
801074b7:	6a 00                	push   $0x0
  pushl $236
801074b9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801074be:	e9 5e f0 ff ff       	jmp    80106521 <alltraps>

801074c3 <vector237>:
.globl vector237
vector237:
  pushl $0
801074c3:	6a 00                	push   $0x0
  pushl $237
801074c5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801074ca:	e9 52 f0 ff ff       	jmp    80106521 <alltraps>

801074cf <vector238>:
.globl vector238
vector238:
  pushl $0
801074cf:	6a 00                	push   $0x0
  pushl $238
801074d1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801074d6:	e9 46 f0 ff ff       	jmp    80106521 <alltraps>

801074db <vector239>:
.globl vector239
vector239:
  pushl $0
801074db:	6a 00                	push   $0x0
  pushl $239
801074dd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801074e2:	e9 3a f0 ff ff       	jmp    80106521 <alltraps>

801074e7 <vector240>:
.globl vector240
vector240:
  pushl $0
801074e7:	6a 00                	push   $0x0
  pushl $240
801074e9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801074ee:	e9 2e f0 ff ff       	jmp    80106521 <alltraps>

801074f3 <vector241>:
.globl vector241
vector241:
  pushl $0
801074f3:	6a 00                	push   $0x0
  pushl $241
801074f5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801074fa:	e9 22 f0 ff ff       	jmp    80106521 <alltraps>

801074ff <vector242>:
.globl vector242
vector242:
  pushl $0
801074ff:	6a 00                	push   $0x0
  pushl $242
80107501:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107506:	e9 16 f0 ff ff       	jmp    80106521 <alltraps>

8010750b <vector243>:
.globl vector243
vector243:
  pushl $0
8010750b:	6a 00                	push   $0x0
  pushl $243
8010750d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107512:	e9 0a f0 ff ff       	jmp    80106521 <alltraps>

80107517 <vector244>:
.globl vector244
vector244:
  pushl $0
80107517:	6a 00                	push   $0x0
  pushl $244
80107519:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010751e:	e9 fe ef ff ff       	jmp    80106521 <alltraps>

80107523 <vector245>:
.globl vector245
vector245:
  pushl $0
80107523:	6a 00                	push   $0x0
  pushl $245
80107525:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010752a:	e9 f2 ef ff ff       	jmp    80106521 <alltraps>

8010752f <vector246>:
.globl vector246
vector246:
  pushl $0
8010752f:	6a 00                	push   $0x0
  pushl $246
80107531:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107536:	e9 e6 ef ff ff       	jmp    80106521 <alltraps>

8010753b <vector247>:
.globl vector247
vector247:
  pushl $0
8010753b:	6a 00                	push   $0x0
  pushl $247
8010753d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107542:	e9 da ef ff ff       	jmp    80106521 <alltraps>

80107547 <vector248>:
.globl vector248
vector248:
  pushl $0
80107547:	6a 00                	push   $0x0
  pushl $248
80107549:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010754e:	e9 ce ef ff ff       	jmp    80106521 <alltraps>

80107553 <vector249>:
.globl vector249
vector249:
  pushl $0
80107553:	6a 00                	push   $0x0
  pushl $249
80107555:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010755a:	e9 c2 ef ff ff       	jmp    80106521 <alltraps>

8010755f <vector250>:
.globl vector250
vector250:
  pushl $0
8010755f:	6a 00                	push   $0x0
  pushl $250
80107561:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107566:	e9 b6 ef ff ff       	jmp    80106521 <alltraps>

8010756b <vector251>:
.globl vector251
vector251:
  pushl $0
8010756b:	6a 00                	push   $0x0
  pushl $251
8010756d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107572:	e9 aa ef ff ff       	jmp    80106521 <alltraps>

80107577 <vector252>:
.globl vector252
vector252:
  pushl $0
80107577:	6a 00                	push   $0x0
  pushl $252
80107579:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010757e:	e9 9e ef ff ff       	jmp    80106521 <alltraps>

80107583 <vector253>:
.globl vector253
vector253:
  pushl $0
80107583:	6a 00                	push   $0x0
  pushl $253
80107585:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010758a:	e9 92 ef ff ff       	jmp    80106521 <alltraps>

8010758f <vector254>:
.globl vector254
vector254:
  pushl $0
8010758f:	6a 00                	push   $0x0
  pushl $254
80107591:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107596:	e9 86 ef ff ff       	jmp    80106521 <alltraps>

8010759b <vector255>:
.globl vector255
vector255:
  pushl $0
8010759b:	6a 00                	push   $0x0
  pushl $255
8010759d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801075a2:	e9 7a ef ff ff       	jmp    80106521 <alltraps>
801075a7:	66 90                	xchg   %ax,%ax
801075a9:	66 90                	xchg   %ax,%ax
801075ab:	66 90                	xchg   %ax,%ax
801075ad:	66 90                	xchg   %ax,%ax
801075af:	90                   	nop

801075b0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801075b0:	55                   	push   %ebp
801075b1:	89 e5                	mov    %esp,%ebp
801075b3:	57                   	push   %edi
801075b4:	56                   	push   %esi
801075b5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801075b6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801075bc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801075c2:	83 ec 1c             	sub    $0x1c,%esp
801075c5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801075c8:	39 d3                	cmp    %edx,%ebx
801075ca:	73 49                	jae    80107615 <deallocuvm.part.0+0x65>
801075cc:	89 c7                	mov    %eax,%edi
801075ce:	eb 0c                	jmp    801075dc <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801075d0:	83 c0 01             	add    $0x1,%eax
801075d3:	c1 e0 16             	shl    $0x16,%eax
801075d6:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
801075d8:	39 da                	cmp    %ebx,%edx
801075da:	76 39                	jbe    80107615 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
801075dc:	89 d8                	mov    %ebx,%eax
801075de:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801075e1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
801075e4:	f6 c1 01             	test   $0x1,%cl
801075e7:	74 e7                	je     801075d0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
801075e9:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801075eb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801075f1:	c1 ee 0a             	shr    $0xa,%esi
801075f4:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
801075fa:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80107601:	85 f6                	test   %esi,%esi
80107603:	74 cb                	je     801075d0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80107605:	8b 06                	mov    (%esi),%eax
80107607:	a8 01                	test   $0x1,%al
80107609:	75 15                	jne    80107620 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
8010760b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107611:	39 da                	cmp    %ebx,%edx
80107613:	77 c7                	ja     801075dc <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107615:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107618:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010761b:	5b                   	pop    %ebx
8010761c:	5e                   	pop    %esi
8010761d:	5f                   	pop    %edi
8010761e:	5d                   	pop    %ebp
8010761f:	c3                   	ret    
      if(pa == 0)
80107620:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107625:	74 25                	je     8010764c <deallocuvm.part.0+0x9c>
      kfree(v);
80107627:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010762a:	05 00 00 00 80       	add    $0x80000000,%eax
8010762f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107632:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80107638:	50                   	push   %eax
80107639:	e8 82 ae ff ff       	call   801024c0 <kfree>
      *pte = 0;
8010763e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80107644:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107647:	83 c4 10             	add    $0x10,%esp
8010764a:	eb 8c                	jmp    801075d8 <deallocuvm.part.0+0x28>
        panic("kfree");
8010764c:	83 ec 0c             	sub    $0xc,%esp
8010764f:	68 06 82 10 80       	push   $0x80108206
80107654:	e8 27 8d ff ff       	call   80100380 <panic>
80107659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107660 <mappages>:
{
80107660:	55                   	push   %ebp
80107661:	89 e5                	mov    %esp,%ebp
80107663:	57                   	push   %edi
80107664:	56                   	push   %esi
80107665:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107666:	89 d3                	mov    %edx,%ebx
80107668:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010766e:	83 ec 1c             	sub    $0x1c,%esp
80107671:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107674:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107678:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010767d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107680:	8b 45 08             	mov    0x8(%ebp),%eax
80107683:	29 d8                	sub    %ebx,%eax
80107685:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107688:	eb 3d                	jmp    801076c7 <mappages+0x67>
8010768a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107690:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107692:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107697:	c1 ea 0a             	shr    $0xa,%edx
8010769a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801076a0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801076a7:	85 c0                	test   %eax,%eax
801076a9:	74 75                	je     80107720 <mappages+0xc0>
    if(*pte & PTE_P)
801076ab:	f6 00 01             	testb  $0x1,(%eax)
801076ae:	0f 85 86 00 00 00    	jne    8010773a <mappages+0xda>
    *pte = pa | perm | PTE_P;
801076b4:	0b 75 0c             	or     0xc(%ebp),%esi
801076b7:	83 ce 01             	or     $0x1,%esi
801076ba:	89 30                	mov    %esi,(%eax)
    if(a == last)
801076bc:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
801076bf:	74 6f                	je     80107730 <mappages+0xd0>
    a += PGSIZE;
801076c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
801076c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
801076ca:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801076cd:	8d 34 18             	lea    (%eax,%ebx,1),%esi
801076d0:	89 d8                	mov    %ebx,%eax
801076d2:	c1 e8 16             	shr    $0x16,%eax
801076d5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
801076d8:	8b 07                	mov    (%edi),%eax
801076da:	a8 01                	test   $0x1,%al
801076dc:	75 b2                	jne    80107690 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801076de:	e8 9d af ff ff       	call   80102680 <kalloc>
801076e3:	85 c0                	test   %eax,%eax
801076e5:	74 39                	je     80107720 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
801076e7:	83 ec 04             	sub    $0x4,%esp
801076ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
801076ed:	68 00 10 00 00       	push   $0x1000
801076f2:	6a 00                	push   $0x0
801076f4:	50                   	push   %eax
801076f5:	e8 e6 da ff ff       	call   801051e0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801076fa:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
801076fd:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107700:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107706:	83 c8 07             	or     $0x7,%eax
80107709:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010770b:	89 d8                	mov    %ebx,%eax
8010770d:	c1 e8 0a             	shr    $0xa,%eax
80107710:	25 fc 0f 00 00       	and    $0xffc,%eax
80107715:	01 d0                	add    %edx,%eax
80107717:	eb 92                	jmp    801076ab <mappages+0x4b>
80107719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107720:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107723:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107728:	5b                   	pop    %ebx
80107729:	5e                   	pop    %esi
8010772a:	5f                   	pop    %edi
8010772b:	5d                   	pop    %ebp
8010772c:	c3                   	ret    
8010772d:	8d 76 00             	lea    0x0(%esi),%esi
80107730:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107733:	31 c0                	xor    %eax,%eax
}
80107735:	5b                   	pop    %ebx
80107736:	5e                   	pop    %esi
80107737:	5f                   	pop    %edi
80107738:	5d                   	pop    %ebp
80107739:	c3                   	ret    
      panic("remap");
8010773a:	83 ec 0c             	sub    $0xc,%esp
8010773d:	68 a4 88 10 80       	push   $0x801088a4
80107742:	e8 39 8c ff ff       	call   80100380 <panic>
80107747:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010774e:	66 90                	xchg   %ax,%ax

80107750 <seginit>:
{
80107750:	55                   	push   %ebp
80107751:	89 e5                	mov    %esp,%ebp
80107753:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107756:	e8 65 c8 ff ff       	call   80103fc0 <cpuid>
  pd[0] = size-1;
8010775b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107760:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
80107766:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010776a:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80107771:	ff 00 00 
80107774:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
8010777b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010777e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80107785:	ff 00 00 
80107788:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
8010778f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107792:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80107799:	ff 00 00 
8010779c:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
801077a3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801077a6:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
801077ad:	ff 00 00 
801077b0:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
801077b7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801077ba:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
801077bf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801077c3:	c1 e8 10             	shr    $0x10,%eax
801077c6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801077ca:	8d 45 f2             	lea    -0xe(%ebp),%eax
801077cd:	0f 01 10             	lgdtl  (%eax)
}
801077d0:	c9                   	leave  
801077d1:	c3                   	ret    
801077d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801077e0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801077e0:	a1 24 5e 11 80       	mov    0x80115e24,%eax
801077e5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801077ea:	0f 22 d8             	mov    %eax,%cr3
}
801077ed:	c3                   	ret    
801077ee:	66 90                	xchg   %ax,%ax

801077f0 <switchuvm>:
{
801077f0:	55                   	push   %ebp
801077f1:	89 e5                	mov    %esp,%ebp
801077f3:	57                   	push   %edi
801077f4:	56                   	push   %esi
801077f5:	53                   	push   %ebx
801077f6:	83 ec 1c             	sub    $0x1c,%esp
801077f9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801077fc:	85 f6                	test   %esi,%esi
801077fe:	0f 84 cb 00 00 00    	je     801078cf <switchuvm+0xdf>
  if(p->kstack == 0)
80107804:	8b 46 08             	mov    0x8(%esi),%eax
80107807:	85 c0                	test   %eax,%eax
80107809:	0f 84 da 00 00 00    	je     801078e9 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010780f:	8b 46 04             	mov    0x4(%esi),%eax
80107812:	85 c0                	test   %eax,%eax
80107814:	0f 84 c2 00 00 00    	je     801078dc <switchuvm+0xec>
  pushcli();
8010781a:	e8 b1 d7 ff ff       	call   80104fd0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010781f:	e8 ec c6 ff ff       	call   80103f10 <mycpu>
80107824:	89 c3                	mov    %eax,%ebx
80107826:	e8 e5 c6 ff ff       	call   80103f10 <mycpu>
8010782b:	89 c7                	mov    %eax,%edi
8010782d:	e8 de c6 ff ff       	call   80103f10 <mycpu>
80107832:	83 c7 08             	add    $0x8,%edi
80107835:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107838:	e8 d3 c6 ff ff       	call   80103f10 <mycpu>
8010783d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107840:	ba 67 00 00 00       	mov    $0x67,%edx
80107845:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010784c:	83 c0 08             	add    $0x8,%eax
8010784f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107856:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010785b:	83 c1 08             	add    $0x8,%ecx
8010785e:	c1 e8 18             	shr    $0x18,%eax
80107861:	c1 e9 10             	shr    $0x10,%ecx
80107864:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010786a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107870:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107875:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010787c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107881:	e8 8a c6 ff ff       	call   80103f10 <mycpu>
80107886:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010788d:	e8 7e c6 ff ff       	call   80103f10 <mycpu>
80107892:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107896:	8b 5e 08             	mov    0x8(%esi),%ebx
80107899:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010789f:	e8 6c c6 ff ff       	call   80103f10 <mycpu>
801078a4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801078a7:	e8 64 c6 ff ff       	call   80103f10 <mycpu>
801078ac:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801078b0:	b8 28 00 00 00       	mov    $0x28,%eax
801078b5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801078b8:	8b 46 04             	mov    0x4(%esi),%eax
801078bb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801078c0:	0f 22 d8             	mov    %eax,%cr3
}
801078c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078c6:	5b                   	pop    %ebx
801078c7:	5e                   	pop    %esi
801078c8:	5f                   	pop    %edi
801078c9:	5d                   	pop    %ebp
  popcli();
801078ca:	e9 51 d7 ff ff       	jmp    80105020 <popcli>
    panic("switchuvm: no process");
801078cf:	83 ec 0c             	sub    $0xc,%esp
801078d2:	68 aa 88 10 80       	push   $0x801088aa
801078d7:	e8 a4 8a ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
801078dc:	83 ec 0c             	sub    $0xc,%esp
801078df:	68 d5 88 10 80       	push   $0x801088d5
801078e4:	e8 97 8a ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
801078e9:	83 ec 0c             	sub    $0xc,%esp
801078ec:	68 c0 88 10 80       	push   $0x801088c0
801078f1:	e8 8a 8a ff ff       	call   80100380 <panic>
801078f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078fd:	8d 76 00             	lea    0x0(%esi),%esi

80107900 <inituvm>:
{
80107900:	55                   	push   %ebp
80107901:	89 e5                	mov    %esp,%ebp
80107903:	57                   	push   %edi
80107904:	56                   	push   %esi
80107905:	53                   	push   %ebx
80107906:	83 ec 1c             	sub    $0x1c,%esp
80107909:	8b 45 0c             	mov    0xc(%ebp),%eax
8010790c:	8b 75 10             	mov    0x10(%ebp),%esi
8010790f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107912:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107915:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010791b:	77 4b                	ja     80107968 <inituvm+0x68>
  mem = kalloc();
8010791d:	e8 5e ad ff ff       	call   80102680 <kalloc>
  memset(mem, 0, PGSIZE);
80107922:	83 ec 04             	sub    $0x4,%esp
80107925:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010792a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010792c:	6a 00                	push   $0x0
8010792e:	50                   	push   %eax
8010792f:	e8 ac d8 ff ff       	call   801051e0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107934:	58                   	pop    %eax
80107935:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010793b:	5a                   	pop    %edx
8010793c:	6a 06                	push   $0x6
8010793e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107943:	31 d2                	xor    %edx,%edx
80107945:	50                   	push   %eax
80107946:	89 f8                	mov    %edi,%eax
80107948:	e8 13 fd ff ff       	call   80107660 <mappages>
  memmove(mem, init, sz);
8010794d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107950:	89 75 10             	mov    %esi,0x10(%ebp)
80107953:	83 c4 10             	add    $0x10,%esp
80107956:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107959:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010795c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010795f:	5b                   	pop    %ebx
80107960:	5e                   	pop    %esi
80107961:	5f                   	pop    %edi
80107962:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107963:	e9 18 d9 ff ff       	jmp    80105280 <memmove>
    panic("inituvm: more than a page");
80107968:	83 ec 0c             	sub    $0xc,%esp
8010796b:	68 e9 88 10 80       	push   $0x801088e9
80107970:	e8 0b 8a ff ff       	call   80100380 <panic>
80107975:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010797c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107980 <loaduvm>:
{
80107980:	55                   	push   %ebp
80107981:	89 e5                	mov    %esp,%ebp
80107983:	57                   	push   %edi
80107984:	56                   	push   %esi
80107985:	53                   	push   %ebx
80107986:	83 ec 1c             	sub    $0x1c,%esp
80107989:	8b 45 0c             	mov    0xc(%ebp),%eax
8010798c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010798f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107994:	0f 85 bb 00 00 00    	jne    80107a55 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
8010799a:	01 f0                	add    %esi,%eax
8010799c:	89 f3                	mov    %esi,%ebx
8010799e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801079a1:	8b 45 14             	mov    0x14(%ebp),%eax
801079a4:	01 f0                	add    %esi,%eax
801079a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801079a9:	85 f6                	test   %esi,%esi
801079ab:	0f 84 87 00 00 00    	je     80107a38 <loaduvm+0xb8>
801079b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
801079b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
801079bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801079be:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
801079c0:	89 c2                	mov    %eax,%edx
801079c2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801079c5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
801079c8:	f6 c2 01             	test   $0x1,%dl
801079cb:	75 13                	jne    801079e0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
801079cd:	83 ec 0c             	sub    $0xc,%esp
801079d0:	68 03 89 10 80       	push   $0x80108903
801079d5:	e8 a6 89 ff ff       	call   80100380 <panic>
801079da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801079e0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801079e3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801079e9:	25 fc 0f 00 00       	and    $0xffc,%eax
801079ee:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801079f5:	85 c0                	test   %eax,%eax
801079f7:	74 d4                	je     801079cd <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
801079f9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801079fb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801079fe:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107a03:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107a08:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107a0e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107a11:	29 d9                	sub    %ebx,%ecx
80107a13:	05 00 00 00 80       	add    $0x80000000,%eax
80107a18:	57                   	push   %edi
80107a19:	51                   	push   %ecx
80107a1a:	50                   	push   %eax
80107a1b:	ff 75 10             	push   0x10(%ebp)
80107a1e:	e8 6d a0 ff ff       	call   80101a90 <readi>
80107a23:	83 c4 10             	add    $0x10,%esp
80107a26:	39 f8                	cmp    %edi,%eax
80107a28:	75 1e                	jne    80107a48 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107a2a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107a30:	89 f0                	mov    %esi,%eax
80107a32:	29 d8                	sub    %ebx,%eax
80107a34:	39 c6                	cmp    %eax,%esi
80107a36:	77 80                	ja     801079b8 <loaduvm+0x38>
}
80107a38:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107a3b:	31 c0                	xor    %eax,%eax
}
80107a3d:	5b                   	pop    %ebx
80107a3e:	5e                   	pop    %esi
80107a3f:	5f                   	pop    %edi
80107a40:	5d                   	pop    %ebp
80107a41:	c3                   	ret    
80107a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107a4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a50:	5b                   	pop    %ebx
80107a51:	5e                   	pop    %esi
80107a52:	5f                   	pop    %edi
80107a53:	5d                   	pop    %ebp
80107a54:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107a55:	83 ec 0c             	sub    $0xc,%esp
80107a58:	68 a4 89 10 80       	push   $0x801089a4
80107a5d:	e8 1e 89 ff ff       	call   80100380 <panic>
80107a62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107a70 <allocuvm>:
{
80107a70:	55                   	push   %ebp
80107a71:	89 e5                	mov    %esp,%ebp
80107a73:	57                   	push   %edi
80107a74:	56                   	push   %esi
80107a75:	53                   	push   %ebx
80107a76:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107a79:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107a7c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107a7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107a82:	85 c0                	test   %eax,%eax
80107a84:	0f 88 b6 00 00 00    	js     80107b40 <allocuvm+0xd0>
  if(newsz < oldsz)
80107a8a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107a8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107a90:	0f 82 9a 00 00 00    	jb     80107b30 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107a96:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107a9c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107aa2:	39 75 10             	cmp    %esi,0x10(%ebp)
80107aa5:	77 44                	ja     80107aeb <allocuvm+0x7b>
80107aa7:	e9 87 00 00 00       	jmp    80107b33 <allocuvm+0xc3>
80107aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107ab0:	83 ec 04             	sub    $0x4,%esp
80107ab3:	68 00 10 00 00       	push   $0x1000
80107ab8:	6a 00                	push   $0x0
80107aba:	50                   	push   %eax
80107abb:	e8 20 d7 ff ff       	call   801051e0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107ac0:	58                   	pop    %eax
80107ac1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107ac7:	5a                   	pop    %edx
80107ac8:	6a 06                	push   $0x6
80107aca:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107acf:	89 f2                	mov    %esi,%edx
80107ad1:	50                   	push   %eax
80107ad2:	89 f8                	mov    %edi,%eax
80107ad4:	e8 87 fb ff ff       	call   80107660 <mappages>
80107ad9:	83 c4 10             	add    $0x10,%esp
80107adc:	85 c0                	test   %eax,%eax
80107ade:	78 78                	js     80107b58 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107ae0:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107ae6:	39 75 10             	cmp    %esi,0x10(%ebp)
80107ae9:	76 48                	jbe    80107b33 <allocuvm+0xc3>
    mem = kalloc();
80107aeb:	e8 90 ab ff ff       	call   80102680 <kalloc>
80107af0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107af2:	85 c0                	test   %eax,%eax
80107af4:	75 ba                	jne    80107ab0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107af6:	83 ec 0c             	sub    $0xc,%esp
80107af9:	68 21 89 10 80       	push   $0x80108921
80107afe:	e8 9d 8b ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107b03:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b06:	83 c4 10             	add    $0x10,%esp
80107b09:	39 45 10             	cmp    %eax,0x10(%ebp)
80107b0c:	74 32                	je     80107b40 <allocuvm+0xd0>
80107b0e:	8b 55 10             	mov    0x10(%ebp),%edx
80107b11:	89 c1                	mov    %eax,%ecx
80107b13:	89 f8                	mov    %edi,%eax
80107b15:	e8 96 fa ff ff       	call   801075b0 <deallocuvm.part.0>
      return 0;
80107b1a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107b24:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b27:	5b                   	pop    %ebx
80107b28:	5e                   	pop    %esi
80107b29:	5f                   	pop    %edi
80107b2a:	5d                   	pop    %ebp
80107b2b:	c3                   	ret    
80107b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107b30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107b33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107b36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b39:	5b                   	pop    %ebx
80107b3a:	5e                   	pop    %esi
80107b3b:	5f                   	pop    %edi
80107b3c:	5d                   	pop    %ebp
80107b3d:	c3                   	ret    
80107b3e:	66 90                	xchg   %ax,%ax
    return 0;
80107b40:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107b47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107b4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b4d:	5b                   	pop    %ebx
80107b4e:	5e                   	pop    %esi
80107b4f:	5f                   	pop    %edi
80107b50:	5d                   	pop    %ebp
80107b51:	c3                   	ret    
80107b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107b58:	83 ec 0c             	sub    $0xc,%esp
80107b5b:	68 39 89 10 80       	push   $0x80108939
80107b60:	e8 3b 8b ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107b65:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b68:	83 c4 10             	add    $0x10,%esp
80107b6b:	39 45 10             	cmp    %eax,0x10(%ebp)
80107b6e:	74 0c                	je     80107b7c <allocuvm+0x10c>
80107b70:	8b 55 10             	mov    0x10(%ebp),%edx
80107b73:	89 c1                	mov    %eax,%ecx
80107b75:	89 f8                	mov    %edi,%eax
80107b77:	e8 34 fa ff ff       	call   801075b0 <deallocuvm.part.0>
      kfree(mem);
80107b7c:	83 ec 0c             	sub    $0xc,%esp
80107b7f:	53                   	push   %ebx
80107b80:	e8 3b a9 ff ff       	call   801024c0 <kfree>
      return 0;
80107b85:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107b8c:	83 c4 10             	add    $0x10,%esp
}
80107b8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107b92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b95:	5b                   	pop    %ebx
80107b96:	5e                   	pop    %esi
80107b97:	5f                   	pop    %edi
80107b98:	5d                   	pop    %ebp
80107b99:	c3                   	ret    
80107b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107ba0 <deallocuvm>:
{
80107ba0:	55                   	push   %ebp
80107ba1:	89 e5                	mov    %esp,%ebp
80107ba3:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ba6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107bac:	39 d1                	cmp    %edx,%ecx
80107bae:	73 10                	jae    80107bc0 <deallocuvm+0x20>
}
80107bb0:	5d                   	pop    %ebp
80107bb1:	e9 fa f9 ff ff       	jmp    801075b0 <deallocuvm.part.0>
80107bb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107bbd:	8d 76 00             	lea    0x0(%esi),%esi
80107bc0:	89 d0                	mov    %edx,%eax
80107bc2:	5d                   	pop    %ebp
80107bc3:	c3                   	ret    
80107bc4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107bcf:	90                   	nop

80107bd0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107bd0:	55                   	push   %ebp
80107bd1:	89 e5                	mov    %esp,%ebp
80107bd3:	57                   	push   %edi
80107bd4:	56                   	push   %esi
80107bd5:	53                   	push   %ebx
80107bd6:	83 ec 0c             	sub    $0xc,%esp
80107bd9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107bdc:	85 f6                	test   %esi,%esi
80107bde:	74 59                	je     80107c39 <freevm+0x69>
  if(newsz >= oldsz)
80107be0:	31 c9                	xor    %ecx,%ecx
80107be2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107be7:	89 f0                	mov    %esi,%eax
80107be9:	89 f3                	mov    %esi,%ebx
80107beb:	e8 c0 f9 ff ff       	call   801075b0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107bf0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107bf6:	eb 0f                	jmp    80107c07 <freevm+0x37>
80107bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107bff:	90                   	nop
80107c00:	83 c3 04             	add    $0x4,%ebx
80107c03:	39 df                	cmp    %ebx,%edi
80107c05:	74 23                	je     80107c2a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107c07:	8b 03                	mov    (%ebx),%eax
80107c09:	a8 01                	test   $0x1,%al
80107c0b:	74 f3                	je     80107c00 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107c0d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107c12:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107c15:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107c18:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107c1d:	50                   	push   %eax
80107c1e:	e8 9d a8 ff ff       	call   801024c0 <kfree>
80107c23:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107c26:	39 df                	cmp    %ebx,%edi
80107c28:	75 dd                	jne    80107c07 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107c2a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107c2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c30:	5b                   	pop    %ebx
80107c31:	5e                   	pop    %esi
80107c32:	5f                   	pop    %edi
80107c33:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107c34:	e9 87 a8 ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
80107c39:	83 ec 0c             	sub    $0xc,%esp
80107c3c:	68 55 89 10 80       	push   $0x80108955
80107c41:	e8 3a 87 ff ff       	call   80100380 <panic>
80107c46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c4d:	8d 76 00             	lea    0x0(%esi),%esi

80107c50 <setupkvm>:
{
80107c50:	55                   	push   %ebp
80107c51:	89 e5                	mov    %esp,%ebp
80107c53:	56                   	push   %esi
80107c54:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107c55:	e8 26 aa ff ff       	call   80102680 <kalloc>
80107c5a:	89 c6                	mov    %eax,%esi
80107c5c:	85 c0                	test   %eax,%eax
80107c5e:	74 42                	je     80107ca2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107c60:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107c63:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107c68:	68 00 10 00 00       	push   $0x1000
80107c6d:	6a 00                	push   $0x0
80107c6f:	50                   	push   %eax
80107c70:	e8 6b d5 ff ff       	call   801051e0 <memset>
80107c75:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107c78:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107c7b:	83 ec 08             	sub    $0x8,%esp
80107c7e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107c81:	ff 73 0c             	push   0xc(%ebx)
80107c84:	8b 13                	mov    (%ebx),%edx
80107c86:	50                   	push   %eax
80107c87:	29 c1                	sub    %eax,%ecx
80107c89:	89 f0                	mov    %esi,%eax
80107c8b:	e8 d0 f9 ff ff       	call   80107660 <mappages>
80107c90:	83 c4 10             	add    $0x10,%esp
80107c93:	85 c0                	test   %eax,%eax
80107c95:	78 19                	js     80107cb0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107c97:	83 c3 10             	add    $0x10,%ebx
80107c9a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107ca0:	75 d6                	jne    80107c78 <setupkvm+0x28>
}
80107ca2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107ca5:	89 f0                	mov    %esi,%eax
80107ca7:	5b                   	pop    %ebx
80107ca8:	5e                   	pop    %esi
80107ca9:	5d                   	pop    %ebp
80107caa:	c3                   	ret    
80107cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107caf:	90                   	nop
      freevm(pgdir);
80107cb0:	83 ec 0c             	sub    $0xc,%esp
80107cb3:	56                   	push   %esi
      return 0;
80107cb4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107cb6:	e8 15 ff ff ff       	call   80107bd0 <freevm>
      return 0;
80107cbb:	83 c4 10             	add    $0x10,%esp
}
80107cbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107cc1:	89 f0                	mov    %esi,%eax
80107cc3:	5b                   	pop    %ebx
80107cc4:	5e                   	pop    %esi
80107cc5:	5d                   	pop    %ebp
80107cc6:	c3                   	ret    
80107cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107cce:	66 90                	xchg   %ax,%ax

80107cd0 <kvmalloc>:
{
80107cd0:	55                   	push   %ebp
80107cd1:	89 e5                	mov    %esp,%ebp
80107cd3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107cd6:	e8 75 ff ff ff       	call   80107c50 <setupkvm>
80107cdb:	a3 24 5e 11 80       	mov    %eax,0x80115e24
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107ce0:	05 00 00 00 80       	add    $0x80000000,%eax
80107ce5:	0f 22 d8             	mov    %eax,%cr3
}
80107ce8:	c9                   	leave  
80107ce9:	c3                   	ret    
80107cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107cf0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107cf0:	55                   	push   %ebp
80107cf1:	89 e5                	mov    %esp,%ebp
80107cf3:	83 ec 08             	sub    $0x8,%esp
80107cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107cf9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107cfc:	89 c1                	mov    %eax,%ecx
80107cfe:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107d01:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107d04:	f6 c2 01             	test   $0x1,%dl
80107d07:	75 17                	jne    80107d20 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107d09:	83 ec 0c             	sub    $0xc,%esp
80107d0c:	68 66 89 10 80       	push   $0x80108966
80107d11:	e8 6a 86 ff ff       	call   80100380 <panic>
80107d16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d1d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107d20:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107d23:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107d29:	25 fc 0f 00 00       	and    $0xffc,%eax
80107d2e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107d35:	85 c0                	test   %eax,%eax
80107d37:	74 d0                	je     80107d09 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107d39:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107d3c:	c9                   	leave  
80107d3d:	c3                   	ret    
80107d3e:	66 90                	xchg   %ax,%ax

80107d40 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107d40:	55                   	push   %ebp
80107d41:	89 e5                	mov    %esp,%ebp
80107d43:	57                   	push   %edi
80107d44:	56                   	push   %esi
80107d45:	53                   	push   %ebx
80107d46:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107d49:	e8 02 ff ff ff       	call   80107c50 <setupkvm>
80107d4e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107d51:	85 c0                	test   %eax,%eax
80107d53:	0f 84 bd 00 00 00    	je     80107e16 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107d59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107d5c:	85 c9                	test   %ecx,%ecx
80107d5e:	0f 84 b2 00 00 00    	je     80107e16 <copyuvm+0xd6>
80107d64:	31 f6                	xor    %esi,%esi
80107d66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d6d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107d70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107d73:	89 f0                	mov    %esi,%eax
80107d75:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107d78:	8b 04 81             	mov    (%ecx,%eax,4),%eax
80107d7b:	a8 01                	test   $0x1,%al
80107d7d:	75 11                	jne    80107d90 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80107d7f:	83 ec 0c             	sub    $0xc,%esp
80107d82:	68 70 89 10 80       	push   $0x80108970
80107d87:	e8 f4 85 ff ff       	call   80100380 <panic>
80107d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107d90:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107d92:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107d97:	c1 ea 0a             	shr    $0xa,%edx
80107d9a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107da0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107da7:	85 c0                	test   %eax,%eax
80107da9:	74 d4                	je     80107d7f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
80107dab:	8b 00                	mov    (%eax),%eax
80107dad:	a8 01                	test   $0x1,%al
80107daf:	0f 84 9f 00 00 00    	je     80107e54 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107db5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107db7:	25 ff 0f 00 00       	and    $0xfff,%eax
80107dbc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107dbf:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107dc5:	e8 b6 a8 ff ff       	call   80102680 <kalloc>
80107dca:	89 c3                	mov    %eax,%ebx
80107dcc:	85 c0                	test   %eax,%eax
80107dce:	74 64                	je     80107e34 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107dd0:	83 ec 04             	sub    $0x4,%esp
80107dd3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107dd9:	68 00 10 00 00       	push   $0x1000
80107dde:	57                   	push   %edi
80107ddf:	50                   	push   %eax
80107de0:	e8 9b d4 ff ff       	call   80105280 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107de5:	58                   	pop    %eax
80107de6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107dec:	5a                   	pop    %edx
80107ded:	ff 75 e4             	push   -0x1c(%ebp)
80107df0:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107df5:	89 f2                	mov    %esi,%edx
80107df7:	50                   	push   %eax
80107df8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107dfb:	e8 60 f8 ff ff       	call   80107660 <mappages>
80107e00:	83 c4 10             	add    $0x10,%esp
80107e03:	85 c0                	test   %eax,%eax
80107e05:	78 21                	js     80107e28 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107e07:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107e0d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107e10:	0f 87 5a ff ff ff    	ja     80107d70 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107e16:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107e19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e1c:	5b                   	pop    %ebx
80107e1d:	5e                   	pop    %esi
80107e1e:	5f                   	pop    %edi
80107e1f:	5d                   	pop    %ebp
80107e20:	c3                   	ret    
80107e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107e28:	83 ec 0c             	sub    $0xc,%esp
80107e2b:	53                   	push   %ebx
80107e2c:	e8 8f a6 ff ff       	call   801024c0 <kfree>
      goto bad;
80107e31:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107e34:	83 ec 0c             	sub    $0xc,%esp
80107e37:	ff 75 e0             	push   -0x20(%ebp)
80107e3a:	e8 91 fd ff ff       	call   80107bd0 <freevm>
  return 0;
80107e3f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107e46:	83 c4 10             	add    $0x10,%esp
}
80107e49:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107e4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e4f:	5b                   	pop    %ebx
80107e50:	5e                   	pop    %esi
80107e51:	5f                   	pop    %edi
80107e52:	5d                   	pop    %ebp
80107e53:	c3                   	ret    
      panic("copyuvm: page not present");
80107e54:	83 ec 0c             	sub    $0xc,%esp
80107e57:	68 8a 89 10 80       	push   $0x8010898a
80107e5c:	e8 1f 85 ff ff       	call   80100380 <panic>
80107e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e6f:	90                   	nop

80107e70 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107e70:	55                   	push   %ebp
80107e71:	89 e5                	mov    %esp,%ebp
80107e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107e76:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107e79:	89 c1                	mov    %eax,%ecx
80107e7b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107e7e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107e81:	f6 c2 01             	test   $0x1,%dl
80107e84:	0f 84 00 01 00 00    	je     80107f8a <uva2ka.cold>
  return &pgtab[PTX(va)];
80107e8a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107e8d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107e93:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107e94:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107e99:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107ea0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107ea2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107ea7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107eaa:	05 00 00 00 80       	add    $0x80000000,%eax
80107eaf:	83 fa 05             	cmp    $0x5,%edx
80107eb2:	ba 00 00 00 00       	mov    $0x0,%edx
80107eb7:	0f 45 c2             	cmovne %edx,%eax
}
80107eba:	c3                   	ret    
80107ebb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107ebf:	90                   	nop

80107ec0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107ec0:	55                   	push   %ebp
80107ec1:	89 e5                	mov    %esp,%ebp
80107ec3:	57                   	push   %edi
80107ec4:	56                   	push   %esi
80107ec5:	53                   	push   %ebx
80107ec6:	83 ec 0c             	sub    $0xc,%esp
80107ec9:	8b 75 14             	mov    0x14(%ebp),%esi
80107ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ecf:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107ed2:	85 f6                	test   %esi,%esi
80107ed4:	75 51                	jne    80107f27 <copyout+0x67>
80107ed6:	e9 a5 00 00 00       	jmp    80107f80 <copyout+0xc0>
80107edb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107edf:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107ee0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107ee6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80107eec:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107ef2:	74 75                	je     80107f69 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107ef4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107ef6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107ef9:	29 c3                	sub    %eax,%ebx
80107efb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107f01:	39 f3                	cmp    %esi,%ebx
80107f03:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107f06:	29 f8                	sub    %edi,%eax
80107f08:	83 ec 04             	sub    $0x4,%esp
80107f0b:	01 c1                	add    %eax,%ecx
80107f0d:	53                   	push   %ebx
80107f0e:	52                   	push   %edx
80107f0f:	51                   	push   %ecx
80107f10:	e8 6b d3 ff ff       	call   80105280 <memmove>
    len -= n;
    buf += n;
80107f15:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107f18:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
80107f1e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107f21:	01 da                	add    %ebx,%edx
  while(len > 0){
80107f23:	29 de                	sub    %ebx,%esi
80107f25:	74 59                	je     80107f80 <copyout+0xc0>
  if(*pde & PTE_P){
80107f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80107f2a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107f2c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
80107f2e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107f31:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107f37:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80107f3a:	f6 c1 01             	test   $0x1,%cl
80107f3d:	0f 84 4e 00 00 00    	je     80107f91 <copyout.cold>
  return &pgtab[PTX(va)];
80107f43:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107f45:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107f4b:	c1 eb 0c             	shr    $0xc,%ebx
80107f4e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107f54:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80107f5b:	89 d9                	mov    %ebx,%ecx
80107f5d:	83 e1 05             	and    $0x5,%ecx
80107f60:	83 f9 05             	cmp    $0x5,%ecx
80107f63:	0f 84 77 ff ff ff    	je     80107ee0 <copyout+0x20>
  }
  return 0;
}
80107f69:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107f6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107f71:	5b                   	pop    %ebx
80107f72:	5e                   	pop    %esi
80107f73:	5f                   	pop    %edi
80107f74:	5d                   	pop    %ebp
80107f75:	c3                   	ret    
80107f76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f7d:	8d 76 00             	lea    0x0(%esi),%esi
80107f80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107f83:	31 c0                	xor    %eax,%eax
}
80107f85:	5b                   	pop    %ebx
80107f86:	5e                   	pop    %esi
80107f87:	5f                   	pop    %edi
80107f88:	5d                   	pop    %ebp
80107f89:	c3                   	ret    

80107f8a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107f8a:	a1 00 00 00 00       	mov    0x0,%eax
80107f8f:	0f 0b                	ud2    

80107f91 <copyout.cold>:
80107f91:	a1 00 00 00 00       	mov    0x0,%eax
80107f96:	0f 0b                	ud2    
