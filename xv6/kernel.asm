
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc f0 57 11 80       	mov    $0x801157f0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 b0 30 10 80       	mov    $0x801030b0,%eax
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
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 80 72 10 80       	push   $0x80107280
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 c5 43 00 00       	call   80104420 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
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
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 87 72 10 80       	push   $0x80107287
80100097:	50                   	push   %eax
80100098:	e8 53 42 00 00       	call   801042f0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
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
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 07 45 00 00       	call   801045f0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
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
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
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
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 29 44 00 00       	call   80104590 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 41 00 00       	call   80104330 <acquiresleep>
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
8010018c:	e8 9f 21 00 00       	call   80102330 <iderw>
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
801001a1:	68 8e 72 10 80       	push   $0x8010728e
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
801001be:	e8 0d 42 00 00       	call   801043d0 <holdingsleep>
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
801001d4:	e9 57 21 00 00       	jmp    80102330 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 9f 72 10 80       	push   $0x8010729f
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
801001ff:	e8 cc 41 00 00       	call   801043d0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 7c 41 00 00       	call   80104390 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 d0 43 00 00       	call   801045f0 <acquire>
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
80100242:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 1f 43 00 00       	jmp    80104590 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 a6 72 10 80       	push   $0x801072a6
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
80100294:	e8 17 16 00 00       	call   801018b0 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002a0:	e8 4b 43 00 00       	call   801045f0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002b5:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
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
801002c3:	68 20 ef 10 80       	push   $0x8010ef20
801002c8:	68 00 ef 10 80       	push   $0x8010ef00
801002cd:	e8 be 3d 00 00       	call   80104090 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 d9 36 00 00       	call   801039c0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ef 10 80       	push   $0x8010ef20
801002f6:	e8 95 42 00 00       	call   80104590 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 cc 14 00 00       	call   801017d0 <ilock>
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
8010031b:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
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
80100347:	68 20 ef 10 80       	push   $0x8010ef20
8010034c:	e8 3f 42 00 00       	call   80104590 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 76 14 00 00       	call   801017d0 <ilock>
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
8010036d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
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
80100389:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 a2 25 00 00       	call   80102940 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 ad 72 10 80       	push   $0x801072ad
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 db 7b 10 80 	movl   $0x80107bdb,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 73 40 00 00       	call   80104440 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 c1 72 10 80       	push   $0x801072c1
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
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
8010041a:	e8 71 59 00 00       	call   80105d90 <uartputc>
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
80100505:	e8 86 58 00 00       	call   80105d90 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 7a 58 00 00       	call   80105d90 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 6e 58 00 00       	call   80105d90 <uartputc>
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
80100551:	e8 fa 41 00 00       	call   80104750 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 45 41 00 00       	call   801046b0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 c5 72 10 80       	push   $0x801072c5
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
8010059f:	e8 0c 13 00 00       	call   801018b0 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005ab:	e8 40 40 00 00       	call   801045f0 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
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
801005df:	68 20 ef 10 80       	push   $0x8010ef20
801005e4:	e8 a7 3f 00 00       	call   80104590 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 de 11 00 00       	call   801017d0 <ilock>

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
80100636:	0f b6 92 f0 72 10 80 	movzbl -0x7fef8d10(%edx),%edx
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
80100662:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
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
801006a9:	a1 54 ef 10 80       	mov    0x8010ef54,%eax
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
80100760:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
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
801007a8:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
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
801007e3:	68 20 ef 10 80       	push   $0x8010ef20
801007e8:	e8 03 3e 00 00       	call   801045f0 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
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
80100838:	bf d8 72 10 80       	mov    $0x801072d8,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ef 10 80       	push   $0x8010ef20
8010085b:	e8 30 3d 00 00       	call   80104590 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 df 72 10 80       	push   $0x801072df
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
8010088e:	68 20 ef 10 80       	push   $0x8010ef20
80100893:	e8 58 3d 00 00       	call   801045f0 <acquire>
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
801008d3:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ef 10 80    	mov    %ecx,0x8010ef08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 ee 10 80    	mov    %bl,-0x7fef1180(%eax)
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
80100927:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100945:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
8010096c:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100985:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100999:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801009b7:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ef 10 80       	push   $0x8010ef20
801009d0:	e8 bb 3b 00 00       	call   80104590 <release>
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
80100a0e:	e9 1d 38 00 00       	jmp    80104230 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%eax)
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
80100a32:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100a3f:	68 00 ef 10 80       	push   $0x8010ef00
80100a44:	e8 07 37 00 00       	call   80104150 <wakeup>
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
80100a66:	68 e8 72 10 80       	push   $0x801072e8
80100a6b:	68 20 ef 10 80       	push   $0x8010ef20
80100a70:	e8 ab 39 00 00       	call   80104420 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 2c fc 10 80 90 	movl   $0x80100590,0x8010fc2c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 28 fc 10 80 80 	movl   $0x80100280,0x8010fc28
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 32 1a 00 00       	call   801024d0 <ioapicenable>
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
80100abc:	e8 ff 2e 00 00       	call   801039c0 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 e4 22 00 00       	call   80102db0 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 19 16 00 00       	call   801020f0 <namei>
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
80100ae8:	e8 e3 0c 00 00       	call   801017d0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 e2 0f 00 00       	call   80101ae0 <readi>
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
80100b0a:	e8 51 0f 00 00       	call   80101a60 <iunlockput>
    end_op();
80100b0f:	e8 0c 23 00 00       	call   80102e20 <end_op>
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
80100b34:	e8 e7 63 00 00       	call   80106f20 <setupkvm>
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
80100ba3:	e8 98 61 00 00       	call   80106d40 <allocuvm>
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
80100bd9:	e8 72 60 00 00       	call   80106c50 <loaduvm>
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
80100c01:	e8 da 0e 00 00       	call   80101ae0 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 80 62 00 00       	call   80106ea0 <freevm>
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
80100c4c:	e8 0f 0e 00 00       	call   80101a60 <iunlockput>
  end_op();
80100c51:	e8 ca 21 00 00       	call   80102e20 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 d9 60 00 00       	call   80106d40 <allocuvm>
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
80100c83:	e8 38 63 00 00       	call   80106fc0 <clearpteu>
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
80100cd3:	e8 d8 3b 00 00       	call   801048b0 <strlen>
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
80100ce7:	e8 c4 3b 00 00       	call   801048b0 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 93 64 00 00       	call   80107190 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 8a 61 00 00       	call   80106ea0 <freevm>
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
80100d63:	e8 28 64 00 00       	call   80107190 <copyout>
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
80100da1:	e8 ca 3a 00 00       	call   80104870 <safestrcpy>
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
80100dcd:	e8 ee 5c 00 00       	call   80106ac0 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 c6 60 00 00       	call   80106ea0 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 37 20 00 00       	call   80102e20 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 01 73 10 80       	push   $0x80107301
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
80100e16:	68 0d 73 10 80       	push   $0x8010730d
80100e1b:	68 60 ef 10 80       	push   $0x8010ef60
80100e20:	e8 fb 35 00 00       	call   80104420 <initlock>
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
80100e34:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 60 ef 10 80       	push   $0x8010ef60
80100e41:	e8 aa 37 00 00       	call   801045f0 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 20             	add    $0x20,%ebx
80100e53:	81 fb 14 fc 10 80    	cmp    $0x8010fc14,%ebx
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
80100e6c:	68 60 ef 10 80       	push   $0x8010ef60
80100e71:	e8 1a 37 00 00       	call   80104590 <release>
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
80100e85:	68 60 ef 10 80       	push   $0x8010ef60
80100e8a:	e8 01 37 00 00       	call   80104590 <release>
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
80100eaa:	68 60 ef 10 80       	push   $0x8010ef60
80100eaf:	e8 3c 37 00 00       	call   801045f0 <acquire>
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
80100ec7:	68 60 ef 10 80       	push   $0x8010ef60
80100ecc:	e8 bf 36 00 00       	call   80104590 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 14 73 10 80       	push   $0x80107314
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
80100efc:	68 60 ef 10 80       	push   $0x8010ef60
80100f01:	e8 ea 36 00 00       	call   801045f0 <acquire>
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
80100f34:	68 60 ef 10 80       	push   $0x8010ef60
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 4f 36 00 00       	call   80104590 <release>

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
80100f60:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 1d 36 00 00       	jmp    80104590 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 33 1e 00 00       	call   80102db0 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 78 09 00 00       	call   80101900 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 89 1e 00 00       	jmp    80102e20 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 d2 25 00 00       	call   80103580 <pipeclose>
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
80100fbc:	68 1c 73 10 80       	push   $0x8010731c
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
80100fe5:	e8 e6 07 00 00       	call   801017d0 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 b9 0a 00 00       	call   80101ab0 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 b0 08 00 00       	call   801018b0 <iunlock>
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
8010104a:	e8 81 07 00 00       	call   801017d0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 84 0a 00 00       	call   80101ae0 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 3d 08 00 00       	call   801018b0 <iunlock>
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
8010108d:	e9 8e 26 00 00       	jmp    80103720 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 26 73 10 80       	push   $0x80107326
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
80101104:	e8 a7 07 00 00       	call   801018b0 <iunlock>
      end_op();
80101109:	e8 12 1d 00 00       	call   80102e20 <end_op>

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
8010112e:	e8 7d 1c 00 00       	call   80102db0 <begin_op>
      ilock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 92 06 00 00       	call   801017d0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101141:	57                   	push   %edi
80101142:	ff 73 14             	push   0x14(%ebx)
80101145:	01 f0                	add    %esi,%eax
80101147:	50                   	push   %eax
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 90 0a 00 00       	call   80101be0 <writei>
80101150:	83 c4 20             	add    $0x20,%esp
80101153:	85 c0                	test   %eax,%eax
80101155:	7f a1                	jg     801010f8 <filewrite+0x48>
      iunlock(f->ip);
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 4b 07 00 00       	call   801018b0 <iunlock>
      end_op();
80101165:	e8 b6 1c 00 00       	call   80102e20 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 2f 73 10 80       	push   $0x8010732f
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
801011a9:	e9 72 24 00 00       	jmp    80103620 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 35 73 10 80       	push   $0x80107335
801011b6:	e8 c5 f1 ff ff       	call   80100380 <panic>
801011bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801011bf:	90                   	nop

801011c0 <iostat>:

int
iostat(struct file *f, struct iostats *iost)
{
801011c0:	55                   	push   %ebp
801011c1:	89 e5                	mov    %esp,%ebp
801011c3:	56                   	push   %esi
801011c4:	53                   	push   %ebx
801011c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801011c8:	8b 75 0c             	mov    0xc(%ebp),%esi
    if(f->type == FD_INODE){
801011cb:	83 3b 02             	cmpl   $0x2,(%ebx)
801011ce:	75 30                	jne    80101200 <iostat+0x40>
        ilock(f->ip);
801011d0:	83 ec 0c             	sub    $0xc,%esp
801011d3:	ff 73 10             	push   0x10(%ebx)
801011d6:	e8 f5 05 00 00       	call   801017d0 <ilock>
        iost->read_bytes = f->read_bytes;
801011db:	8b 43 18             	mov    0x18(%ebx),%eax
801011de:	89 06                	mov    %eax,(%esi)
        iost->write_bytes = f->write_bytes;
801011e0:	8b 43 1c             	mov    0x1c(%ebx),%eax
801011e3:	89 46 04             	mov    %eax,0x4(%esi)
        iunlock(f->ip);
801011e6:	58                   	pop    %eax
801011e7:	ff 73 10             	push   0x10(%ebx)
801011ea:	e8 c1 06 00 00       	call   801018b0 <iunlock>
        return 0;
801011ef:	83 c4 10             	add    $0x10,%esp
    }
    return -1;
}
801011f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
        return 0;
801011f5:	31 c0                	xor    %eax,%eax
}
801011f7:	5b                   	pop    %ebx
801011f8:	5e                   	pop    %esi
801011f9:	5d                   	pop    %ebp
801011fa:	c3                   	ret    
801011fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801011ff:	90                   	nop
80101200:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80101203:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101208:	5b                   	pop    %ebx
80101209:	5e                   	pop    %esi
8010120a:	5d                   	pop    %ebp
8010120b:	c3                   	ret    
8010120c:	66 90                	xchg   %ax,%ax
8010120e:	66 90                	xchg   %ax,%ax

80101210 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101210:	55                   	push   %ebp
80101211:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101213:	89 d0                	mov    %edx,%eax
80101215:	c1 e8 0c             	shr    $0xc,%eax
80101218:	03 05 ec 18 11 80    	add    0x801118ec,%eax
{
8010121e:	89 e5                	mov    %esp,%ebp
80101220:	56                   	push   %esi
80101221:	53                   	push   %ebx
80101222:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101224:	83 ec 08             	sub    $0x8,%esp
80101227:	50                   	push   %eax
80101228:	51                   	push   %ecx
80101229:	e8 a2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010122e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101230:	c1 fb 03             	sar    $0x3,%ebx
80101233:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101236:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101238:	83 e1 07             	and    $0x7,%ecx
8010123b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101240:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101246:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101248:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010124d:	85 c1                	test   %eax,%ecx
8010124f:	74 23                	je     80101274 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101251:	f7 d0                	not    %eax
  log_write(bp);
80101253:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101256:	21 c8                	and    %ecx,%eax
80101258:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010125c:	56                   	push   %esi
8010125d:	e8 2e 1d 00 00       	call   80102f90 <log_write>
  brelse(bp);
80101262:	89 34 24             	mov    %esi,(%esp)
80101265:	e8 86 ef ff ff       	call   801001f0 <brelse>
}
8010126a:	83 c4 10             	add    $0x10,%esp
8010126d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101270:	5b                   	pop    %ebx
80101271:	5e                   	pop    %esi
80101272:	5d                   	pop    %ebp
80101273:	c3                   	ret    
    panic("freeing free block");
80101274:	83 ec 0c             	sub    $0xc,%esp
80101277:	68 3f 73 10 80       	push   $0x8010733f
8010127c:	e8 ff f0 ff ff       	call   80100380 <panic>
80101281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010128f:	90                   	nop

80101290 <balloc>:
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	56                   	push   %esi
80101295:	53                   	push   %ebx
80101296:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101299:	8b 0d d4 18 11 80    	mov    0x801118d4,%ecx
{
8010129f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801012a2:	85 c9                	test   %ecx,%ecx
801012a4:	0f 84 87 00 00 00    	je     80101331 <balloc+0xa1>
801012aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801012b1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801012b4:	83 ec 08             	sub    $0x8,%esp
801012b7:	89 f0                	mov    %esi,%eax
801012b9:	c1 f8 0c             	sar    $0xc,%eax
801012bc:	03 05 ec 18 11 80    	add    0x801118ec,%eax
801012c2:	50                   	push   %eax
801012c3:	ff 75 d8             	push   -0x28(%ebp)
801012c6:	e8 05 ee ff ff       	call   801000d0 <bread>
801012cb:	83 c4 10             	add    $0x10,%esp
801012ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012d1:	a1 d4 18 11 80       	mov    0x801118d4,%eax
801012d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801012d9:	31 c0                	xor    %eax,%eax
801012db:	eb 2f                	jmp    8010130c <balloc+0x7c>
801012dd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012e0:	89 c1                	mov    %eax,%ecx
801012e2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801012ea:	83 e1 07             	and    $0x7,%ecx
801012ed:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012ef:	89 c1                	mov    %eax,%ecx
801012f1:	c1 f9 03             	sar    $0x3,%ecx
801012f4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012f9:	89 fa                	mov    %edi,%edx
801012fb:	85 df                	test   %ebx,%edi
801012fd:	74 41                	je     80101340 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012ff:	83 c0 01             	add    $0x1,%eax
80101302:	83 c6 01             	add    $0x1,%esi
80101305:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010130a:	74 05                	je     80101311 <balloc+0x81>
8010130c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010130f:	77 cf                	ja     801012e0 <balloc+0x50>
    brelse(bp);
80101311:	83 ec 0c             	sub    $0xc,%esp
80101314:	ff 75 e4             	push   -0x1c(%ebp)
80101317:	e8 d4 ee ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010131c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101323:	83 c4 10             	add    $0x10,%esp
80101326:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101329:	39 05 d4 18 11 80    	cmp    %eax,0x801118d4
8010132f:	77 80                	ja     801012b1 <balloc+0x21>
  panic("balloc: out of blocks");
80101331:	83 ec 0c             	sub    $0xc,%esp
80101334:	68 52 73 10 80       	push   $0x80107352
80101339:	e8 42 f0 ff ff       	call   80100380 <panic>
8010133e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101340:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101343:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101346:	09 da                	or     %ebx,%edx
80101348:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010134c:	57                   	push   %edi
8010134d:	e8 3e 1c 00 00       	call   80102f90 <log_write>
        brelse(bp);
80101352:	89 3c 24             	mov    %edi,(%esp)
80101355:	e8 96 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010135a:	58                   	pop    %eax
8010135b:	5a                   	pop    %edx
8010135c:	56                   	push   %esi
8010135d:	ff 75 d8             	push   -0x28(%ebp)
80101360:	e8 6b ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101365:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101368:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010136a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010136d:	68 00 02 00 00       	push   $0x200
80101372:	6a 00                	push   $0x0
80101374:	50                   	push   %eax
80101375:	e8 36 33 00 00       	call   801046b0 <memset>
  log_write(bp);
8010137a:	89 1c 24             	mov    %ebx,(%esp)
8010137d:	e8 0e 1c 00 00       	call   80102f90 <log_write>
  brelse(bp);
80101382:	89 1c 24             	mov    %ebx,(%esp)
80101385:	e8 66 ee ff ff       	call   801001f0 <brelse>
}
8010138a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010138d:	89 f0                	mov    %esi,%eax
8010138f:	5b                   	pop    %ebx
80101390:	5e                   	pop    %esi
80101391:	5f                   	pop    %edi
80101392:	5d                   	pop    %ebp
80101393:	c3                   	ret    
80101394:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010139b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010139f:	90                   	nop

801013a0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801013a0:	55                   	push   %ebp
801013a1:	89 e5                	mov    %esp,%ebp
801013a3:	57                   	push   %edi
801013a4:	89 c7                	mov    %eax,%edi
801013a6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801013a7:	31 f6                	xor    %esi,%esi
{
801013a9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013aa:	bb b4 fc 10 80       	mov    $0x8010fcb4,%ebx
{
801013af:	83 ec 28             	sub    $0x28,%esp
801013b2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801013b5:	68 80 fc 10 80       	push   $0x8010fc80
801013ba:	e8 31 32 00 00       	call   801045f0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801013c2:	83 c4 10             	add    $0x10,%esp
801013c5:	eb 1b                	jmp    801013e2 <iget+0x42>
801013c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013ce:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013d0:	39 3b                	cmp    %edi,(%ebx)
801013d2:	74 6c                	je     80101440 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013d4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013da:	81 fb d4 18 11 80    	cmp    $0x801118d4,%ebx
801013e0:	73 26                	jae    80101408 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013e2:	8b 43 08             	mov    0x8(%ebx),%eax
801013e5:	85 c0                	test   %eax,%eax
801013e7:	7f e7                	jg     801013d0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013e9:	85 f6                	test   %esi,%esi
801013eb:	75 e7                	jne    801013d4 <iget+0x34>
801013ed:	85 c0                	test   %eax,%eax
801013ef:	75 76                	jne    80101467 <iget+0xc7>
801013f1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013f3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013f9:	81 fb d4 18 11 80    	cmp    $0x801118d4,%ebx
801013ff:	72 e1                	jb     801013e2 <iget+0x42>
80101401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101408:	85 f6                	test   %esi,%esi
8010140a:	74 79                	je     80101485 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010140c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010140f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101411:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101414:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010141b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101422:	68 80 fc 10 80       	push   $0x8010fc80
80101427:	e8 64 31 00 00       	call   80104590 <release>

  return ip;
8010142c:	83 c4 10             	add    $0x10,%esp
}
8010142f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101432:	89 f0                	mov    %esi,%eax
80101434:	5b                   	pop    %ebx
80101435:	5e                   	pop    %esi
80101436:	5f                   	pop    %edi
80101437:	5d                   	pop    %ebp
80101438:	c3                   	ret    
80101439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101440:	39 53 04             	cmp    %edx,0x4(%ebx)
80101443:	75 8f                	jne    801013d4 <iget+0x34>
      release(&icache.lock);
80101445:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101448:	83 c0 01             	add    $0x1,%eax
      return ip;
8010144b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010144d:	68 80 fc 10 80       	push   $0x8010fc80
      ip->ref++;
80101452:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101455:	e8 36 31 00 00       	call   80104590 <release>
      return ip;
8010145a:	83 c4 10             	add    $0x10,%esp
}
8010145d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101460:	89 f0                	mov    %esi,%eax
80101462:	5b                   	pop    %ebx
80101463:	5e                   	pop    %esi
80101464:	5f                   	pop    %edi
80101465:	5d                   	pop    %ebp
80101466:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101467:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010146d:	81 fb d4 18 11 80    	cmp    $0x801118d4,%ebx
80101473:	73 10                	jae    80101485 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101475:	8b 43 08             	mov    0x8(%ebx),%eax
80101478:	85 c0                	test   %eax,%eax
8010147a:	0f 8f 50 ff ff ff    	jg     801013d0 <iget+0x30>
80101480:	e9 68 ff ff ff       	jmp    801013ed <iget+0x4d>
    panic("iget: no inodes");
80101485:	83 ec 0c             	sub    $0xc,%esp
80101488:	68 68 73 10 80       	push   $0x80107368
8010148d:	e8 ee ee ff ff       	call   80100380 <panic>
80101492:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801014a0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	57                   	push   %edi
801014a4:	56                   	push   %esi
801014a5:	89 c6                	mov    %eax,%esi
801014a7:	53                   	push   %ebx
801014a8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801014ab:	83 fa 0b             	cmp    $0xb,%edx
801014ae:	0f 86 8c 00 00 00    	jbe    80101540 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801014b4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801014b7:	83 fb 7f             	cmp    $0x7f,%ebx
801014ba:	0f 87 a2 00 00 00    	ja     80101562 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801014c0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801014c6:	85 c0                	test   %eax,%eax
801014c8:	74 5e                	je     80101528 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801014ca:	83 ec 08             	sub    $0x8,%esp
801014cd:	50                   	push   %eax
801014ce:	ff 36                	push   (%esi)
801014d0:	e8 fb eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014d5:	83 c4 10             	add    $0x10,%esp
801014d8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801014dc:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801014de:	8b 3b                	mov    (%ebx),%edi
801014e0:	85 ff                	test   %edi,%edi
801014e2:	74 1c                	je     80101500 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014e4:	83 ec 0c             	sub    $0xc,%esp
801014e7:	52                   	push   %edx
801014e8:	e8 03 ed ff ff       	call   801001f0 <brelse>
801014ed:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014f3:	89 f8                	mov    %edi,%eax
801014f5:	5b                   	pop    %ebx
801014f6:	5e                   	pop    %esi
801014f7:	5f                   	pop    %edi
801014f8:	5d                   	pop    %ebp
801014f9:	c3                   	ret    
801014fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101500:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101503:	8b 06                	mov    (%esi),%eax
80101505:	e8 86 fd ff ff       	call   80101290 <balloc>
      log_write(bp);
8010150a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010150d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101510:	89 03                	mov    %eax,(%ebx)
80101512:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101514:	52                   	push   %edx
80101515:	e8 76 1a 00 00       	call   80102f90 <log_write>
8010151a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010151d:	83 c4 10             	add    $0x10,%esp
80101520:	eb c2                	jmp    801014e4 <bmap+0x44>
80101522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101528:	8b 06                	mov    (%esi),%eax
8010152a:	e8 61 fd ff ff       	call   80101290 <balloc>
8010152f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101535:	eb 93                	jmp    801014ca <bmap+0x2a>
80101537:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010153e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101540:	8d 5a 14             	lea    0x14(%edx),%ebx
80101543:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101547:	85 ff                	test   %edi,%edi
80101549:	75 a5                	jne    801014f0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010154b:	8b 00                	mov    (%eax),%eax
8010154d:	e8 3e fd ff ff       	call   80101290 <balloc>
80101552:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101556:	89 c7                	mov    %eax,%edi
}
80101558:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010155b:	5b                   	pop    %ebx
8010155c:	89 f8                	mov    %edi,%eax
8010155e:	5e                   	pop    %esi
8010155f:	5f                   	pop    %edi
80101560:	5d                   	pop    %ebp
80101561:	c3                   	ret    
  panic("bmap: out of range");
80101562:	83 ec 0c             	sub    $0xc,%esp
80101565:	68 78 73 10 80       	push   $0x80107378
8010156a:	e8 11 ee ff ff       	call   80100380 <panic>
8010156f:	90                   	nop

80101570 <readsb>:
{
80101570:	55                   	push   %ebp
80101571:	89 e5                	mov    %esp,%ebp
80101573:	56                   	push   %esi
80101574:	53                   	push   %ebx
80101575:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101578:	83 ec 08             	sub    $0x8,%esp
8010157b:	6a 01                	push   $0x1
8010157d:	ff 75 08             	push   0x8(%ebp)
80101580:	e8 4b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101585:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101588:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010158a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010158d:	6a 1c                	push   $0x1c
8010158f:	50                   	push   %eax
80101590:	56                   	push   %esi
80101591:	e8 ba 31 00 00       	call   80104750 <memmove>
  brelse(bp);
80101596:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101599:	83 c4 10             	add    $0x10,%esp
}
8010159c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010159f:	5b                   	pop    %ebx
801015a0:	5e                   	pop    %esi
801015a1:	5d                   	pop    %ebp
  brelse(bp);
801015a2:	e9 49 ec ff ff       	jmp    801001f0 <brelse>
801015a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ae:	66 90                	xchg   %ax,%ax

801015b0 <iinit>:
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	53                   	push   %ebx
801015b4:	bb c0 fc 10 80       	mov    $0x8010fcc0,%ebx
801015b9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801015bc:	68 8b 73 10 80       	push   $0x8010738b
801015c1:	68 80 fc 10 80       	push   $0x8010fc80
801015c6:	e8 55 2e 00 00       	call   80104420 <initlock>
  for(i = 0; i < NINODE; i++) {
801015cb:	83 c4 10             	add    $0x10,%esp
801015ce:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015d0:	83 ec 08             	sub    $0x8,%esp
801015d3:	68 92 73 10 80       	push   $0x80107392
801015d8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015d9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015df:	e8 0c 2d 00 00       	call   801042f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015e4:	83 c4 10             	add    $0x10,%esp
801015e7:	81 fb e0 18 11 80    	cmp    $0x801118e0,%ebx
801015ed:	75 e1                	jne    801015d0 <iinit+0x20>
  bp = bread(dev, 1);
801015ef:	83 ec 08             	sub    $0x8,%esp
801015f2:	6a 01                	push   $0x1
801015f4:	ff 75 08             	push   0x8(%ebp)
801015f7:	e8 d4 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015fc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015ff:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101601:	8d 40 5c             	lea    0x5c(%eax),%eax
80101604:	6a 1c                	push   $0x1c
80101606:	50                   	push   %eax
80101607:	68 d4 18 11 80       	push   $0x801118d4
8010160c:	e8 3f 31 00 00       	call   80104750 <memmove>
  brelse(bp);
80101611:	89 1c 24             	mov    %ebx,(%esp)
80101614:	e8 d7 eb ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101619:	ff 35 ec 18 11 80    	push   0x801118ec
8010161f:	ff 35 e8 18 11 80    	push   0x801118e8
80101625:	ff 35 e4 18 11 80    	push   0x801118e4
8010162b:	ff 35 e0 18 11 80    	push   0x801118e0
80101631:	ff 35 dc 18 11 80    	push   0x801118dc
80101637:	ff 35 d8 18 11 80    	push   0x801118d8
8010163d:	ff 35 d4 18 11 80    	push   0x801118d4
80101643:	68 f8 73 10 80       	push   $0x801073f8
80101648:	e8 53 f0 ff ff       	call   801006a0 <cprintf>
}
8010164d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101650:	83 c4 30             	add    $0x30,%esp
80101653:	c9                   	leave  
80101654:	c3                   	ret    
80101655:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010165c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101660 <ialloc>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	57                   	push   %edi
80101664:	56                   	push   %esi
80101665:	53                   	push   %ebx
80101666:	83 ec 1c             	sub    $0x1c,%esp
80101669:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010166c:	83 3d dc 18 11 80 01 	cmpl   $0x1,0x801118dc
{
80101673:	8b 75 08             	mov    0x8(%ebp),%esi
80101676:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101679:	0f 86 91 00 00 00    	jbe    80101710 <ialloc+0xb0>
8010167f:	bf 01 00 00 00       	mov    $0x1,%edi
80101684:	eb 21                	jmp    801016a7 <ialloc+0x47>
80101686:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010168d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101690:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101693:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101696:	53                   	push   %ebx
80101697:	e8 54 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010169c:	83 c4 10             	add    $0x10,%esp
8010169f:	3b 3d dc 18 11 80    	cmp    0x801118dc,%edi
801016a5:	73 69                	jae    80101710 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801016a7:	89 f8                	mov    %edi,%eax
801016a9:	83 ec 08             	sub    $0x8,%esp
801016ac:	c1 e8 03             	shr    $0x3,%eax
801016af:	03 05 e8 18 11 80    	add    0x801118e8,%eax
801016b5:	50                   	push   %eax
801016b6:	56                   	push   %esi
801016b7:	e8 14 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801016bc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801016bf:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801016c1:	89 f8                	mov    %edi,%eax
801016c3:	83 e0 07             	and    $0x7,%eax
801016c6:	c1 e0 06             	shl    $0x6,%eax
801016c9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801016cd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016d1:	75 bd                	jne    80101690 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016d3:	83 ec 04             	sub    $0x4,%esp
801016d6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016d9:	6a 40                	push   $0x40
801016db:	6a 00                	push   $0x0
801016dd:	51                   	push   %ecx
801016de:	e8 cd 2f 00 00       	call   801046b0 <memset>
      dip->type = type;
801016e3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016e7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016ea:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016ed:	89 1c 24             	mov    %ebx,(%esp)
801016f0:	e8 9b 18 00 00       	call   80102f90 <log_write>
      brelse(bp);
801016f5:	89 1c 24             	mov    %ebx,(%esp)
801016f8:	e8 f3 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016fd:	83 c4 10             	add    $0x10,%esp
}
80101700:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101703:	89 fa                	mov    %edi,%edx
}
80101705:	5b                   	pop    %ebx
      return iget(dev, inum);
80101706:	89 f0                	mov    %esi,%eax
}
80101708:	5e                   	pop    %esi
80101709:	5f                   	pop    %edi
8010170a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010170b:	e9 90 fc ff ff       	jmp    801013a0 <iget>
  panic("ialloc: no inodes");
80101710:	83 ec 0c             	sub    $0xc,%esp
80101713:	68 98 73 10 80       	push   $0x80107398
80101718:	e8 63 ec ff ff       	call   80100380 <panic>
8010171d:	8d 76 00             	lea    0x0(%esi),%esi

80101720 <iupdate>:
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	56                   	push   %esi
80101724:	53                   	push   %ebx
80101725:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101728:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010172e:	83 ec 08             	sub    $0x8,%esp
80101731:	c1 e8 03             	shr    $0x3,%eax
80101734:	03 05 e8 18 11 80    	add    0x801118e8,%eax
8010173a:	50                   	push   %eax
8010173b:	ff 73 a4             	push   -0x5c(%ebx)
8010173e:	e8 8d e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101743:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101747:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010174a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010174c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010174f:	83 e0 07             	and    $0x7,%eax
80101752:	c1 e0 06             	shl    $0x6,%eax
80101755:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101759:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010175c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101760:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101763:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101767:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010176b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010176f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101773:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101777:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010177a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010177d:	6a 34                	push   $0x34
8010177f:	53                   	push   %ebx
80101780:	50                   	push   %eax
80101781:	e8 ca 2f 00 00       	call   80104750 <memmove>
  log_write(bp);
80101786:	89 34 24             	mov    %esi,(%esp)
80101789:	e8 02 18 00 00       	call   80102f90 <log_write>
  brelse(bp);
8010178e:	89 75 08             	mov    %esi,0x8(%ebp)
80101791:	83 c4 10             	add    $0x10,%esp
}
80101794:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101797:	5b                   	pop    %ebx
80101798:	5e                   	pop    %esi
80101799:	5d                   	pop    %ebp
  brelse(bp);
8010179a:	e9 51 ea ff ff       	jmp    801001f0 <brelse>
8010179f:	90                   	nop

801017a0 <idup>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	53                   	push   %ebx
801017a4:	83 ec 10             	sub    $0x10,%esp
801017a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801017aa:	68 80 fc 10 80       	push   $0x8010fc80
801017af:	e8 3c 2e 00 00       	call   801045f0 <acquire>
  ip->ref++;
801017b4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017b8:	c7 04 24 80 fc 10 80 	movl   $0x8010fc80,(%esp)
801017bf:	e8 cc 2d 00 00       	call   80104590 <release>
}
801017c4:	89 d8                	mov    %ebx,%eax
801017c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017c9:	c9                   	leave  
801017ca:	c3                   	ret    
801017cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017cf:	90                   	nop

801017d0 <ilock>:
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	56                   	push   %esi
801017d4:	53                   	push   %ebx
801017d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017d8:	85 db                	test   %ebx,%ebx
801017da:	0f 84 b7 00 00 00    	je     80101897 <ilock+0xc7>
801017e0:	8b 53 08             	mov    0x8(%ebx),%edx
801017e3:	85 d2                	test   %edx,%edx
801017e5:	0f 8e ac 00 00 00    	jle    80101897 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017eb:	83 ec 0c             	sub    $0xc,%esp
801017ee:	8d 43 0c             	lea    0xc(%ebx),%eax
801017f1:	50                   	push   %eax
801017f2:	e8 39 2b 00 00       	call   80104330 <acquiresleep>
  if(ip->valid == 0){
801017f7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017fa:	83 c4 10             	add    $0x10,%esp
801017fd:	85 c0                	test   %eax,%eax
801017ff:	74 0f                	je     80101810 <ilock+0x40>
}
80101801:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101804:	5b                   	pop    %ebx
80101805:	5e                   	pop    %esi
80101806:	5d                   	pop    %ebp
80101807:	c3                   	ret    
80101808:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010180f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101810:	8b 43 04             	mov    0x4(%ebx),%eax
80101813:	83 ec 08             	sub    $0x8,%esp
80101816:	c1 e8 03             	shr    $0x3,%eax
80101819:	03 05 e8 18 11 80    	add    0x801118e8,%eax
8010181f:	50                   	push   %eax
80101820:	ff 33                	push   (%ebx)
80101822:	e8 a9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101827:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010182a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010182c:	8b 43 04             	mov    0x4(%ebx),%eax
8010182f:	83 e0 07             	and    $0x7,%eax
80101832:	c1 e0 06             	shl    $0x6,%eax
80101835:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101839:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010183c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010183f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101843:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101847:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010184b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010184f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101853:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101857:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010185b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010185e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101861:	6a 34                	push   $0x34
80101863:	50                   	push   %eax
80101864:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101867:	50                   	push   %eax
80101868:	e8 e3 2e 00 00       	call   80104750 <memmove>
    brelse(bp);
8010186d:	89 34 24             	mov    %esi,(%esp)
80101870:	e8 7b e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101875:	83 c4 10             	add    $0x10,%esp
80101878:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010187d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101884:	0f 85 77 ff ff ff    	jne    80101801 <ilock+0x31>
      panic("ilock: no type");
8010188a:	83 ec 0c             	sub    $0xc,%esp
8010188d:	68 b0 73 10 80       	push   $0x801073b0
80101892:	e8 e9 ea ff ff       	call   80100380 <panic>
    panic("ilock");
80101897:	83 ec 0c             	sub    $0xc,%esp
8010189a:	68 aa 73 10 80       	push   $0x801073aa
8010189f:	e8 dc ea ff ff       	call   80100380 <panic>
801018a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iunlock>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	56                   	push   %esi
801018b4:	53                   	push   %ebx
801018b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018b8:	85 db                	test   %ebx,%ebx
801018ba:	74 28                	je     801018e4 <iunlock+0x34>
801018bc:	83 ec 0c             	sub    $0xc,%esp
801018bf:	8d 73 0c             	lea    0xc(%ebx),%esi
801018c2:	56                   	push   %esi
801018c3:	e8 08 2b 00 00       	call   801043d0 <holdingsleep>
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 c0                	test   %eax,%eax
801018cd:	74 15                	je     801018e4 <iunlock+0x34>
801018cf:	8b 43 08             	mov    0x8(%ebx),%eax
801018d2:	85 c0                	test   %eax,%eax
801018d4:	7e 0e                	jle    801018e4 <iunlock+0x34>
  releasesleep(&ip->lock);
801018d6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018dc:	5b                   	pop    %ebx
801018dd:	5e                   	pop    %esi
801018de:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018df:	e9 ac 2a 00 00       	jmp    80104390 <releasesleep>
    panic("iunlock");
801018e4:	83 ec 0c             	sub    $0xc,%esp
801018e7:	68 bf 73 10 80       	push   $0x801073bf
801018ec:	e8 8f ea ff ff       	call   80100380 <panic>
801018f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018ff:	90                   	nop

80101900 <iput>:
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	57                   	push   %edi
80101904:	56                   	push   %esi
80101905:	53                   	push   %ebx
80101906:	83 ec 28             	sub    $0x28,%esp
80101909:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010190c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010190f:	57                   	push   %edi
80101910:	e8 1b 2a 00 00       	call   80104330 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101915:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101918:	83 c4 10             	add    $0x10,%esp
8010191b:	85 d2                	test   %edx,%edx
8010191d:	74 07                	je     80101926 <iput+0x26>
8010191f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101924:	74 32                	je     80101958 <iput+0x58>
  releasesleep(&ip->lock);
80101926:	83 ec 0c             	sub    $0xc,%esp
80101929:	57                   	push   %edi
8010192a:	e8 61 2a 00 00       	call   80104390 <releasesleep>
  acquire(&icache.lock);
8010192f:	c7 04 24 80 fc 10 80 	movl   $0x8010fc80,(%esp)
80101936:	e8 b5 2c 00 00       	call   801045f0 <acquire>
  ip->ref--;
8010193b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010193f:	83 c4 10             	add    $0x10,%esp
80101942:	c7 45 08 80 fc 10 80 	movl   $0x8010fc80,0x8(%ebp)
}
80101949:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010194c:	5b                   	pop    %ebx
8010194d:	5e                   	pop    %esi
8010194e:	5f                   	pop    %edi
8010194f:	5d                   	pop    %ebp
  release(&icache.lock);
80101950:	e9 3b 2c 00 00       	jmp    80104590 <release>
80101955:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101958:	83 ec 0c             	sub    $0xc,%esp
8010195b:	68 80 fc 10 80       	push   $0x8010fc80
80101960:	e8 8b 2c 00 00       	call   801045f0 <acquire>
    int r = ip->ref;
80101965:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101968:	c7 04 24 80 fc 10 80 	movl   $0x8010fc80,(%esp)
8010196f:	e8 1c 2c 00 00       	call   80104590 <release>
    if(r == 1){
80101974:	83 c4 10             	add    $0x10,%esp
80101977:	83 fe 01             	cmp    $0x1,%esi
8010197a:	75 aa                	jne    80101926 <iput+0x26>
8010197c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101982:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101985:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101988:	89 cf                	mov    %ecx,%edi
8010198a:	eb 0b                	jmp    80101997 <iput+0x97>
8010198c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101990:	83 c6 04             	add    $0x4,%esi
80101993:	39 fe                	cmp    %edi,%esi
80101995:	74 19                	je     801019b0 <iput+0xb0>
    if(ip->addrs[i]){
80101997:	8b 16                	mov    (%esi),%edx
80101999:	85 d2                	test   %edx,%edx
8010199b:	74 f3                	je     80101990 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010199d:	8b 03                	mov    (%ebx),%eax
8010199f:	e8 6c f8 ff ff       	call   80101210 <bfree>
      ip->addrs[i] = 0;
801019a4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801019aa:	eb e4                	jmp    80101990 <iput+0x90>
801019ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019b0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801019b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019b9:	85 c0                	test   %eax,%eax
801019bb:	75 2d                	jne    801019ea <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801019bd:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801019c0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801019c7:	53                   	push   %ebx
801019c8:	e8 53 fd ff ff       	call   80101720 <iupdate>
      ip->type = 0;
801019cd:	31 c0                	xor    %eax,%eax
801019cf:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019d3:	89 1c 24             	mov    %ebx,(%esp)
801019d6:	e8 45 fd ff ff       	call   80101720 <iupdate>
      ip->valid = 0;
801019db:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019e2:	83 c4 10             	add    $0x10,%esp
801019e5:	e9 3c ff ff ff       	jmp    80101926 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019ea:	83 ec 08             	sub    $0x8,%esp
801019ed:	50                   	push   %eax
801019ee:	ff 33                	push   (%ebx)
801019f0:	e8 db e6 ff ff       	call   801000d0 <bread>
801019f5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019f8:	83 c4 10             	add    $0x10,%esp
801019fb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101a04:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a07:	89 cf                	mov    %ecx,%edi
80101a09:	eb 0c                	jmp    80101a17 <iput+0x117>
80101a0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a0f:	90                   	nop
80101a10:	83 c6 04             	add    $0x4,%esi
80101a13:	39 f7                	cmp    %esi,%edi
80101a15:	74 0f                	je     80101a26 <iput+0x126>
      if(a[j])
80101a17:	8b 16                	mov    (%esi),%edx
80101a19:	85 d2                	test   %edx,%edx
80101a1b:	74 f3                	je     80101a10 <iput+0x110>
        bfree(ip->dev, a[j]);
80101a1d:	8b 03                	mov    (%ebx),%eax
80101a1f:	e8 ec f7 ff ff       	call   80101210 <bfree>
80101a24:	eb ea                	jmp    80101a10 <iput+0x110>
    brelse(bp);
80101a26:	83 ec 0c             	sub    $0xc,%esp
80101a29:	ff 75 e4             	push   -0x1c(%ebp)
80101a2c:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a2f:	e8 bc e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a34:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a3a:	8b 03                	mov    (%ebx),%eax
80101a3c:	e8 cf f7 ff ff       	call   80101210 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a41:	83 c4 10             	add    $0x10,%esp
80101a44:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a4b:	00 00 00 
80101a4e:	e9 6a ff ff ff       	jmp    801019bd <iput+0xbd>
80101a53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a60 <iunlockput>:
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	56                   	push   %esi
80101a64:	53                   	push   %ebx
80101a65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a68:	85 db                	test   %ebx,%ebx
80101a6a:	74 34                	je     80101aa0 <iunlockput+0x40>
80101a6c:	83 ec 0c             	sub    $0xc,%esp
80101a6f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a72:	56                   	push   %esi
80101a73:	e8 58 29 00 00       	call   801043d0 <holdingsleep>
80101a78:	83 c4 10             	add    $0x10,%esp
80101a7b:	85 c0                	test   %eax,%eax
80101a7d:	74 21                	je     80101aa0 <iunlockput+0x40>
80101a7f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a82:	85 c0                	test   %eax,%eax
80101a84:	7e 1a                	jle    80101aa0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a86:	83 ec 0c             	sub    $0xc,%esp
80101a89:	56                   	push   %esi
80101a8a:	e8 01 29 00 00       	call   80104390 <releasesleep>
  iput(ip);
80101a8f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a92:	83 c4 10             	add    $0x10,%esp
}
80101a95:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a98:	5b                   	pop    %ebx
80101a99:	5e                   	pop    %esi
80101a9a:	5d                   	pop    %ebp
  iput(ip);
80101a9b:	e9 60 fe ff ff       	jmp    80101900 <iput>
    panic("iunlock");
80101aa0:	83 ec 0c             	sub    $0xc,%esp
80101aa3:	68 bf 73 10 80       	push   $0x801073bf
80101aa8:	e8 d3 e8 ff ff       	call   80100380 <panic>
80101aad:	8d 76 00             	lea    0x0(%esi),%esi

80101ab0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101ab9:	8b 0a                	mov    (%edx),%ecx
80101abb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101abe:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ac1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ac4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101ac8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101acb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101acf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101ad3:	8b 52 58             	mov    0x58(%edx),%edx
80101ad6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101ad9:	5d                   	pop    %ebp
80101ada:	c3                   	ret    
80101adb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101adf:	90                   	nop

80101ae0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ae0:	55                   	push   %ebp
80101ae1:	89 e5                	mov    %esp,%ebp
80101ae3:	57                   	push   %edi
80101ae4:	56                   	push   %esi
80101ae5:	53                   	push   %ebx
80101ae6:	83 ec 1c             	sub    $0x1c,%esp
80101ae9:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101aec:	8b 45 08             	mov    0x8(%ebp),%eax
80101aef:	8b 75 10             	mov    0x10(%ebp),%esi
80101af2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101af5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101af8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101afd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b00:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101b03:	0f 84 a7 00 00 00    	je     80101bb0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b09:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b0c:	8b 40 58             	mov    0x58(%eax),%eax
80101b0f:	39 c6                	cmp    %eax,%esi
80101b11:	0f 87 ba 00 00 00    	ja     80101bd1 <readi+0xf1>
80101b17:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b1a:	31 c9                	xor    %ecx,%ecx
80101b1c:	89 da                	mov    %ebx,%edx
80101b1e:	01 f2                	add    %esi,%edx
80101b20:	0f 92 c1             	setb   %cl
80101b23:	89 cf                	mov    %ecx,%edi
80101b25:	0f 82 a6 00 00 00    	jb     80101bd1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b2b:	89 c1                	mov    %eax,%ecx
80101b2d:	29 f1                	sub    %esi,%ecx
80101b2f:	39 d0                	cmp    %edx,%eax
80101b31:	0f 43 cb             	cmovae %ebx,%ecx
80101b34:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b37:	85 c9                	test   %ecx,%ecx
80101b39:	74 67                	je     80101ba2 <readi+0xc2>
80101b3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b3f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b40:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b43:	89 f2                	mov    %esi,%edx
80101b45:	c1 ea 09             	shr    $0x9,%edx
80101b48:	89 d8                	mov    %ebx,%eax
80101b4a:	e8 51 f9 ff ff       	call   801014a0 <bmap>
80101b4f:	83 ec 08             	sub    $0x8,%esp
80101b52:	50                   	push   %eax
80101b53:	ff 33                	push   (%ebx)
80101b55:	e8 76 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b5a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b5d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b62:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b64:	89 f0                	mov    %esi,%eax
80101b66:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b6b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b6d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b70:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b72:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b76:	39 d9                	cmp    %ebx,%ecx
80101b78:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b7b:	83 c4 0c             	add    $0xc,%esp
80101b7e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b7f:	01 df                	add    %ebx,%edi
80101b81:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b83:	50                   	push   %eax
80101b84:	ff 75 e0             	push   -0x20(%ebp)
80101b87:	e8 c4 2b 00 00       	call   80104750 <memmove>
    brelse(bp);
80101b8c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b8f:	89 14 24             	mov    %edx,(%esp)
80101b92:	e8 59 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b97:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b9a:	83 c4 10             	add    $0x10,%esp
80101b9d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ba0:	77 9e                	ja     80101b40 <readi+0x60>
  }
  return n;
80101ba2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ba5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ba8:	5b                   	pop    %ebx
80101ba9:	5e                   	pop    %esi
80101baa:	5f                   	pop    %edi
80101bab:	5d                   	pop    %ebp
80101bac:	c3                   	ret    
80101bad:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101bb0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101bb4:	66 83 f8 09          	cmp    $0x9,%ax
80101bb8:	77 17                	ja     80101bd1 <readi+0xf1>
80101bba:	8b 04 c5 20 fc 10 80 	mov    -0x7fef03e0(,%eax,8),%eax
80101bc1:	85 c0                	test   %eax,%eax
80101bc3:	74 0c                	je     80101bd1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101bc5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101bc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bcb:	5b                   	pop    %ebx
80101bcc:	5e                   	pop    %esi
80101bcd:	5f                   	pop    %edi
80101bce:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101bcf:	ff e0                	jmp    *%eax
      return -1;
80101bd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bd6:	eb cd                	jmp    80101ba5 <readi+0xc5>
80101bd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bdf:	90                   	nop

80101be0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101be0:	55                   	push   %ebp
80101be1:	89 e5                	mov    %esp,%ebp
80101be3:	57                   	push   %edi
80101be4:	56                   	push   %esi
80101be5:	53                   	push   %ebx
80101be6:	83 ec 1c             	sub    $0x1c,%esp
80101be9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bec:	8b 75 0c             	mov    0xc(%ebp),%esi
80101bef:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bf2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bf7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101bfa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bfd:	8b 75 10             	mov    0x10(%ebp),%esi
80101c00:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101c03:	0f 84 b7 00 00 00    	je     80101cc0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c09:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c0c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c0f:	0f 87 e7 00 00 00    	ja     80101cfc <writei+0x11c>
80101c15:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c18:	31 d2                	xor    %edx,%edx
80101c1a:	89 f8                	mov    %edi,%eax
80101c1c:	01 f0                	add    %esi,%eax
80101c1e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c21:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101c26:	0f 87 d0 00 00 00    	ja     80101cfc <writei+0x11c>
80101c2c:	85 d2                	test   %edx,%edx
80101c2e:	0f 85 c8 00 00 00    	jne    80101cfc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c34:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101c3b:	85 ff                	test   %edi,%edi
80101c3d:	74 72                	je     80101cb1 <writei+0xd1>
80101c3f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c40:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c43:	89 f2                	mov    %esi,%edx
80101c45:	c1 ea 09             	shr    $0x9,%edx
80101c48:	89 f8                	mov    %edi,%eax
80101c4a:	e8 51 f8 ff ff       	call   801014a0 <bmap>
80101c4f:	83 ec 08             	sub    $0x8,%esp
80101c52:	50                   	push   %eax
80101c53:	ff 37                	push   (%edi)
80101c55:	e8 76 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c5a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c5f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c62:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c65:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c67:	89 f0                	mov    %esi,%eax
80101c69:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c6e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c70:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c74:	39 d9                	cmp    %ebx,%ecx
80101c76:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c79:	83 c4 0c             	add    $0xc,%esp
80101c7c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c7d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c7f:	ff 75 dc             	push   -0x24(%ebp)
80101c82:	50                   	push   %eax
80101c83:	e8 c8 2a 00 00       	call   80104750 <memmove>
    log_write(bp);
80101c88:	89 3c 24             	mov    %edi,(%esp)
80101c8b:	e8 00 13 00 00       	call   80102f90 <log_write>
    brelse(bp);
80101c90:	89 3c 24             	mov    %edi,(%esp)
80101c93:	e8 58 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c98:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c9b:	83 c4 10             	add    $0x10,%esp
80101c9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ca1:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101ca4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101ca7:	77 97                	ja     80101c40 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101ca9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cac:	3b 70 58             	cmp    0x58(%eax),%esi
80101caf:	77 37                	ja     80101ce8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101cb1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101cb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cb7:	5b                   	pop    %ebx
80101cb8:	5e                   	pop    %esi
80101cb9:	5f                   	pop    %edi
80101cba:	5d                   	pop    %ebp
80101cbb:	c3                   	ret    
80101cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101cc0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101cc4:	66 83 f8 09          	cmp    $0x9,%ax
80101cc8:	77 32                	ja     80101cfc <writei+0x11c>
80101cca:	8b 04 c5 24 fc 10 80 	mov    -0x7fef03dc(,%eax,8),%eax
80101cd1:	85 c0                	test   %eax,%eax
80101cd3:	74 27                	je     80101cfc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101cd5:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101cd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cdb:	5b                   	pop    %ebx
80101cdc:	5e                   	pop    %esi
80101cdd:	5f                   	pop    %edi
80101cde:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101cdf:	ff e0                	jmp    *%eax
80101ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101ce8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101ceb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cee:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101cf1:	50                   	push   %eax
80101cf2:	e8 29 fa ff ff       	call   80101720 <iupdate>
80101cf7:	83 c4 10             	add    $0x10,%esp
80101cfa:	eb b5                	jmp    80101cb1 <writei+0xd1>
      return -1;
80101cfc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d01:	eb b1                	jmp    80101cb4 <writei+0xd4>
80101d03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101d10 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d10:	55                   	push   %ebp
80101d11:	89 e5                	mov    %esp,%ebp
80101d13:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d16:	6a 0e                	push   $0xe
80101d18:	ff 75 0c             	push   0xc(%ebp)
80101d1b:	ff 75 08             	push   0x8(%ebp)
80101d1e:	e8 9d 2a 00 00       	call   801047c0 <strncmp>
}
80101d23:	c9                   	leave  
80101d24:	c3                   	ret    
80101d25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d30 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d30:	55                   	push   %ebp
80101d31:	89 e5                	mov    %esp,%ebp
80101d33:	57                   	push   %edi
80101d34:	56                   	push   %esi
80101d35:	53                   	push   %ebx
80101d36:	83 ec 1c             	sub    $0x1c,%esp
80101d39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d3c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d41:	0f 85 85 00 00 00    	jne    80101dcc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d47:	8b 53 58             	mov    0x58(%ebx),%edx
80101d4a:	31 ff                	xor    %edi,%edi
80101d4c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d4f:	85 d2                	test   %edx,%edx
80101d51:	74 3e                	je     80101d91 <dirlookup+0x61>
80101d53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d57:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d58:	6a 10                	push   $0x10
80101d5a:	57                   	push   %edi
80101d5b:	56                   	push   %esi
80101d5c:	53                   	push   %ebx
80101d5d:	e8 7e fd ff ff       	call   80101ae0 <readi>
80101d62:	83 c4 10             	add    $0x10,%esp
80101d65:	83 f8 10             	cmp    $0x10,%eax
80101d68:	75 55                	jne    80101dbf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d6a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d6f:	74 18                	je     80101d89 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d71:	83 ec 04             	sub    $0x4,%esp
80101d74:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d77:	6a 0e                	push   $0xe
80101d79:	50                   	push   %eax
80101d7a:	ff 75 0c             	push   0xc(%ebp)
80101d7d:	e8 3e 2a 00 00       	call   801047c0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d82:	83 c4 10             	add    $0x10,%esp
80101d85:	85 c0                	test   %eax,%eax
80101d87:	74 17                	je     80101da0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d89:	83 c7 10             	add    $0x10,%edi
80101d8c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d8f:	72 c7                	jb     80101d58 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d94:	31 c0                	xor    %eax,%eax
}
80101d96:	5b                   	pop    %ebx
80101d97:	5e                   	pop    %esi
80101d98:	5f                   	pop    %edi
80101d99:	5d                   	pop    %ebp
80101d9a:	c3                   	ret    
80101d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d9f:	90                   	nop
      if(poff)
80101da0:	8b 45 10             	mov    0x10(%ebp),%eax
80101da3:	85 c0                	test   %eax,%eax
80101da5:	74 05                	je     80101dac <dirlookup+0x7c>
        *poff = off;
80101da7:	8b 45 10             	mov    0x10(%ebp),%eax
80101daa:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101dac:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101db0:	8b 03                	mov    (%ebx),%eax
80101db2:	e8 e9 f5 ff ff       	call   801013a0 <iget>
}
80101db7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dba:	5b                   	pop    %ebx
80101dbb:	5e                   	pop    %esi
80101dbc:	5f                   	pop    %edi
80101dbd:	5d                   	pop    %ebp
80101dbe:	c3                   	ret    
      panic("dirlookup read");
80101dbf:	83 ec 0c             	sub    $0xc,%esp
80101dc2:	68 d9 73 10 80       	push   $0x801073d9
80101dc7:	e8 b4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101dcc:	83 ec 0c             	sub    $0xc,%esp
80101dcf:	68 c7 73 10 80       	push   $0x801073c7
80101dd4:	e8 a7 e5 ff ff       	call   80100380 <panic>
80101dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101de0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101de0:	55                   	push   %ebp
80101de1:	89 e5                	mov    %esp,%ebp
80101de3:	57                   	push   %edi
80101de4:	56                   	push   %esi
80101de5:	53                   	push   %ebx
80101de6:	89 c3                	mov    %eax,%ebx
80101de8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101deb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dee:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101df1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101df4:	0f 84 64 01 00 00    	je     80101f5e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dfa:	e8 c1 1b 00 00       	call   801039c0 <myproc>
  acquire(&icache.lock);
80101dff:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101e02:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101e05:	68 80 fc 10 80       	push   $0x8010fc80
80101e0a:	e8 e1 27 00 00       	call   801045f0 <acquire>
  ip->ref++;
80101e0f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e13:	c7 04 24 80 fc 10 80 	movl   $0x8010fc80,(%esp)
80101e1a:	e8 71 27 00 00       	call   80104590 <release>
80101e1f:	83 c4 10             	add    $0x10,%esp
80101e22:	eb 07                	jmp    80101e2b <namex+0x4b>
80101e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e28:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e2b:	0f b6 03             	movzbl (%ebx),%eax
80101e2e:	3c 2f                	cmp    $0x2f,%al
80101e30:	74 f6                	je     80101e28 <namex+0x48>
  if(*path == 0)
80101e32:	84 c0                	test   %al,%al
80101e34:	0f 84 06 01 00 00    	je     80101f40 <namex+0x160>
  while(*path != '/' && *path != 0)
80101e3a:	0f b6 03             	movzbl (%ebx),%eax
80101e3d:	84 c0                	test   %al,%al
80101e3f:	0f 84 10 01 00 00    	je     80101f55 <namex+0x175>
80101e45:	89 df                	mov    %ebx,%edi
80101e47:	3c 2f                	cmp    $0x2f,%al
80101e49:	0f 84 06 01 00 00    	je     80101f55 <namex+0x175>
80101e4f:	90                   	nop
80101e50:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e54:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e57:	3c 2f                	cmp    $0x2f,%al
80101e59:	74 04                	je     80101e5f <namex+0x7f>
80101e5b:	84 c0                	test   %al,%al
80101e5d:	75 f1                	jne    80101e50 <namex+0x70>
  len = path - s;
80101e5f:	89 f8                	mov    %edi,%eax
80101e61:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e63:	83 f8 0d             	cmp    $0xd,%eax
80101e66:	0f 8e ac 00 00 00    	jle    80101f18 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e6c:	83 ec 04             	sub    $0x4,%esp
80101e6f:	6a 0e                	push   $0xe
80101e71:	53                   	push   %ebx
    path++;
80101e72:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e74:	ff 75 e4             	push   -0x1c(%ebp)
80101e77:	e8 d4 28 00 00       	call   80104750 <memmove>
80101e7c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e7f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e82:	75 0c                	jne    80101e90 <namex+0xb0>
80101e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e88:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e8b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e8e:	74 f8                	je     80101e88 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e90:	83 ec 0c             	sub    $0xc,%esp
80101e93:	56                   	push   %esi
80101e94:	e8 37 f9 ff ff       	call   801017d0 <ilock>
    if(ip->type != T_DIR){
80101e99:	83 c4 10             	add    $0x10,%esp
80101e9c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ea1:	0f 85 cd 00 00 00    	jne    80101f74 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101ea7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eaa:	85 c0                	test   %eax,%eax
80101eac:	74 09                	je     80101eb7 <namex+0xd7>
80101eae:	80 3b 00             	cmpb   $0x0,(%ebx)
80101eb1:	0f 84 22 01 00 00    	je     80101fd9 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101eb7:	83 ec 04             	sub    $0x4,%esp
80101eba:	6a 00                	push   $0x0
80101ebc:	ff 75 e4             	push   -0x1c(%ebp)
80101ebf:	56                   	push   %esi
80101ec0:	e8 6b fe ff ff       	call   80101d30 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ec5:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101ec8:	83 c4 10             	add    $0x10,%esp
80101ecb:	89 c7                	mov    %eax,%edi
80101ecd:	85 c0                	test   %eax,%eax
80101ecf:	0f 84 e1 00 00 00    	je     80101fb6 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ed5:	83 ec 0c             	sub    $0xc,%esp
80101ed8:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101edb:	52                   	push   %edx
80101edc:	e8 ef 24 00 00       	call   801043d0 <holdingsleep>
80101ee1:	83 c4 10             	add    $0x10,%esp
80101ee4:	85 c0                	test   %eax,%eax
80101ee6:	0f 84 30 01 00 00    	je     8010201c <namex+0x23c>
80101eec:	8b 56 08             	mov    0x8(%esi),%edx
80101eef:	85 d2                	test   %edx,%edx
80101ef1:	0f 8e 25 01 00 00    	jle    8010201c <namex+0x23c>
  releasesleep(&ip->lock);
80101ef7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101efa:	83 ec 0c             	sub    $0xc,%esp
80101efd:	52                   	push   %edx
80101efe:	e8 8d 24 00 00       	call   80104390 <releasesleep>
  iput(ip);
80101f03:	89 34 24             	mov    %esi,(%esp)
80101f06:	89 fe                	mov    %edi,%esi
80101f08:	e8 f3 f9 ff ff       	call   80101900 <iput>
80101f0d:	83 c4 10             	add    $0x10,%esp
80101f10:	e9 16 ff ff ff       	jmp    80101e2b <namex+0x4b>
80101f15:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101f18:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f1b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101f1e:	83 ec 04             	sub    $0x4,%esp
80101f21:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101f24:	50                   	push   %eax
80101f25:	53                   	push   %ebx
    name[len] = 0;
80101f26:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101f28:	ff 75 e4             	push   -0x1c(%ebp)
80101f2b:	e8 20 28 00 00       	call   80104750 <memmove>
    name[len] = 0;
80101f30:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f33:	83 c4 10             	add    $0x10,%esp
80101f36:	c6 02 00             	movb   $0x0,(%edx)
80101f39:	e9 41 ff ff ff       	jmp    80101e7f <namex+0x9f>
80101f3e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f40:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f43:	85 c0                	test   %eax,%eax
80101f45:	0f 85 be 00 00 00    	jne    80102009 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f4e:	89 f0                	mov    %esi,%eax
80101f50:	5b                   	pop    %ebx
80101f51:	5e                   	pop    %esi
80101f52:	5f                   	pop    %edi
80101f53:	5d                   	pop    %ebp
80101f54:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f55:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f58:	89 df                	mov    %ebx,%edi
80101f5a:	31 c0                	xor    %eax,%eax
80101f5c:	eb c0                	jmp    80101f1e <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f5e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f63:	b8 01 00 00 00       	mov    $0x1,%eax
80101f68:	e8 33 f4 ff ff       	call   801013a0 <iget>
80101f6d:	89 c6                	mov    %eax,%esi
80101f6f:	e9 b7 fe ff ff       	jmp    80101e2b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f74:	83 ec 0c             	sub    $0xc,%esp
80101f77:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f7a:	53                   	push   %ebx
80101f7b:	e8 50 24 00 00       	call   801043d0 <holdingsleep>
80101f80:	83 c4 10             	add    $0x10,%esp
80101f83:	85 c0                	test   %eax,%eax
80101f85:	0f 84 91 00 00 00    	je     8010201c <namex+0x23c>
80101f8b:	8b 46 08             	mov    0x8(%esi),%eax
80101f8e:	85 c0                	test   %eax,%eax
80101f90:	0f 8e 86 00 00 00    	jle    8010201c <namex+0x23c>
  releasesleep(&ip->lock);
80101f96:	83 ec 0c             	sub    $0xc,%esp
80101f99:	53                   	push   %ebx
80101f9a:	e8 f1 23 00 00       	call   80104390 <releasesleep>
  iput(ip);
80101f9f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101fa2:	31 f6                	xor    %esi,%esi
  iput(ip);
80101fa4:	e8 57 f9 ff ff       	call   80101900 <iput>
      return 0;
80101fa9:	83 c4 10             	add    $0x10,%esp
}
80101fac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101faf:	89 f0                	mov    %esi,%eax
80101fb1:	5b                   	pop    %ebx
80101fb2:	5e                   	pop    %esi
80101fb3:	5f                   	pop    %edi
80101fb4:	5d                   	pop    %ebp
80101fb5:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fb6:	83 ec 0c             	sub    $0xc,%esp
80101fb9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101fbc:	52                   	push   %edx
80101fbd:	e8 0e 24 00 00       	call   801043d0 <holdingsleep>
80101fc2:	83 c4 10             	add    $0x10,%esp
80101fc5:	85 c0                	test   %eax,%eax
80101fc7:	74 53                	je     8010201c <namex+0x23c>
80101fc9:	8b 4e 08             	mov    0x8(%esi),%ecx
80101fcc:	85 c9                	test   %ecx,%ecx
80101fce:	7e 4c                	jle    8010201c <namex+0x23c>
  releasesleep(&ip->lock);
80101fd0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101fd3:	83 ec 0c             	sub    $0xc,%esp
80101fd6:	52                   	push   %edx
80101fd7:	eb c1                	jmp    80101f9a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fd9:	83 ec 0c             	sub    $0xc,%esp
80101fdc:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101fdf:	53                   	push   %ebx
80101fe0:	e8 eb 23 00 00       	call   801043d0 <holdingsleep>
80101fe5:	83 c4 10             	add    $0x10,%esp
80101fe8:	85 c0                	test   %eax,%eax
80101fea:	74 30                	je     8010201c <namex+0x23c>
80101fec:	8b 7e 08             	mov    0x8(%esi),%edi
80101fef:	85 ff                	test   %edi,%edi
80101ff1:	7e 29                	jle    8010201c <namex+0x23c>
  releasesleep(&ip->lock);
80101ff3:	83 ec 0c             	sub    $0xc,%esp
80101ff6:	53                   	push   %ebx
80101ff7:	e8 94 23 00 00       	call   80104390 <releasesleep>
}
80101ffc:	83 c4 10             	add    $0x10,%esp
}
80101fff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102002:	89 f0                	mov    %esi,%eax
80102004:	5b                   	pop    %ebx
80102005:	5e                   	pop    %esi
80102006:	5f                   	pop    %edi
80102007:	5d                   	pop    %ebp
80102008:	c3                   	ret    
    iput(ip);
80102009:	83 ec 0c             	sub    $0xc,%esp
8010200c:	56                   	push   %esi
    return 0;
8010200d:	31 f6                	xor    %esi,%esi
    iput(ip);
8010200f:	e8 ec f8 ff ff       	call   80101900 <iput>
    return 0;
80102014:	83 c4 10             	add    $0x10,%esp
80102017:	e9 2f ff ff ff       	jmp    80101f4b <namex+0x16b>
    panic("iunlock");
8010201c:	83 ec 0c             	sub    $0xc,%esp
8010201f:	68 bf 73 10 80       	push   $0x801073bf
80102024:	e8 57 e3 ff ff       	call   80100380 <panic>
80102029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102030 <dirlink>:
{
80102030:	55                   	push   %ebp
80102031:	89 e5                	mov    %esp,%ebp
80102033:	57                   	push   %edi
80102034:	56                   	push   %esi
80102035:	53                   	push   %ebx
80102036:	83 ec 20             	sub    $0x20,%esp
80102039:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010203c:	6a 00                	push   $0x0
8010203e:	ff 75 0c             	push   0xc(%ebp)
80102041:	53                   	push   %ebx
80102042:	e8 e9 fc ff ff       	call   80101d30 <dirlookup>
80102047:	83 c4 10             	add    $0x10,%esp
8010204a:	85 c0                	test   %eax,%eax
8010204c:	75 67                	jne    801020b5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010204e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102051:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102054:	85 ff                	test   %edi,%edi
80102056:	74 29                	je     80102081 <dirlink+0x51>
80102058:	31 ff                	xor    %edi,%edi
8010205a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010205d:	eb 09                	jmp    80102068 <dirlink+0x38>
8010205f:	90                   	nop
80102060:	83 c7 10             	add    $0x10,%edi
80102063:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102066:	73 19                	jae    80102081 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102068:	6a 10                	push   $0x10
8010206a:	57                   	push   %edi
8010206b:	56                   	push   %esi
8010206c:	53                   	push   %ebx
8010206d:	e8 6e fa ff ff       	call   80101ae0 <readi>
80102072:	83 c4 10             	add    $0x10,%esp
80102075:	83 f8 10             	cmp    $0x10,%eax
80102078:	75 4e                	jne    801020c8 <dirlink+0x98>
    if(de.inum == 0)
8010207a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010207f:	75 df                	jne    80102060 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102081:	83 ec 04             	sub    $0x4,%esp
80102084:	8d 45 da             	lea    -0x26(%ebp),%eax
80102087:	6a 0e                	push   $0xe
80102089:	ff 75 0c             	push   0xc(%ebp)
8010208c:	50                   	push   %eax
8010208d:	e8 7e 27 00 00       	call   80104810 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102092:	6a 10                	push   $0x10
  de.inum = inum;
80102094:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102097:	57                   	push   %edi
80102098:	56                   	push   %esi
80102099:	53                   	push   %ebx
  de.inum = inum;
8010209a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010209e:	e8 3d fb ff ff       	call   80101be0 <writei>
801020a3:	83 c4 20             	add    $0x20,%esp
801020a6:	83 f8 10             	cmp    $0x10,%eax
801020a9:	75 2a                	jne    801020d5 <dirlink+0xa5>
  return 0;
801020ab:	31 c0                	xor    %eax,%eax
}
801020ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020b0:	5b                   	pop    %ebx
801020b1:	5e                   	pop    %esi
801020b2:	5f                   	pop    %edi
801020b3:	5d                   	pop    %ebp
801020b4:	c3                   	ret    
    iput(ip);
801020b5:	83 ec 0c             	sub    $0xc,%esp
801020b8:	50                   	push   %eax
801020b9:	e8 42 f8 ff ff       	call   80101900 <iput>
    return -1;
801020be:	83 c4 10             	add    $0x10,%esp
801020c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020c6:	eb e5                	jmp    801020ad <dirlink+0x7d>
      panic("dirlink read");
801020c8:	83 ec 0c             	sub    $0xc,%esp
801020cb:	68 e8 73 10 80       	push   $0x801073e8
801020d0:	e8 ab e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
801020d5:	83 ec 0c             	sub    $0xc,%esp
801020d8:	68 c2 79 10 80       	push   $0x801079c2
801020dd:	e8 9e e2 ff ff       	call   80100380 <panic>
801020e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020f0 <namei>:

struct inode*
namei(char *path)
{
801020f0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020f1:	31 d2                	xor    %edx,%edx
{
801020f3:	89 e5                	mov    %esp,%ebp
801020f5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020f8:	8b 45 08             	mov    0x8(%ebp),%eax
801020fb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020fe:	e8 dd fc ff ff       	call   80101de0 <namex>
}
80102103:	c9                   	leave  
80102104:	c3                   	ret    
80102105:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102110 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102110:	55                   	push   %ebp
  return namex(path, 1, name);
80102111:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102116:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102118:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010211b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010211e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010211f:	e9 bc fc ff ff       	jmp    80101de0 <namex>
80102124:	66 90                	xchg   %ax,%ax
80102126:	66 90                	xchg   %ax,%ax
80102128:	66 90                	xchg   %ax,%ax
8010212a:	66 90                	xchg   %ax,%ax
8010212c:	66 90                	xchg   %ax,%ax
8010212e:	66 90                	xchg   %ax,%ax

80102130 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102130:	55                   	push   %ebp
80102131:	89 e5                	mov    %esp,%ebp
80102133:	57                   	push   %edi
80102134:	56                   	push   %esi
80102135:	53                   	push   %ebx
80102136:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102139:	85 c0                	test   %eax,%eax
8010213b:	0f 84 b4 00 00 00    	je     801021f5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102141:	8b 70 08             	mov    0x8(%eax),%esi
80102144:	89 c3                	mov    %eax,%ebx
80102146:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010214c:	0f 87 96 00 00 00    	ja     801021e8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102152:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102157:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010215e:	66 90                	xchg   %ax,%ax
80102160:	89 ca                	mov    %ecx,%edx
80102162:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102163:	83 e0 c0             	and    $0xffffffc0,%eax
80102166:	3c 40                	cmp    $0x40,%al
80102168:	75 f6                	jne    80102160 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010216a:	31 ff                	xor    %edi,%edi
8010216c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102171:	89 f8                	mov    %edi,%eax
80102173:	ee                   	out    %al,(%dx)
80102174:	b8 01 00 00 00       	mov    $0x1,%eax
80102179:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010217e:	ee                   	out    %al,(%dx)
8010217f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102184:	89 f0                	mov    %esi,%eax
80102186:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102187:	89 f0                	mov    %esi,%eax
80102189:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010218e:	c1 f8 08             	sar    $0x8,%eax
80102191:	ee                   	out    %al,(%dx)
80102192:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102197:	89 f8                	mov    %edi,%eax
80102199:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010219a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010219e:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021a3:	c1 e0 04             	shl    $0x4,%eax
801021a6:	83 e0 10             	and    $0x10,%eax
801021a9:	83 c8 e0             	or     $0xffffffe0,%eax
801021ac:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801021ad:	f6 03 04             	testb  $0x4,(%ebx)
801021b0:	75 16                	jne    801021c8 <idestart+0x98>
801021b2:	b8 20 00 00 00       	mov    $0x20,%eax
801021b7:	89 ca                	mov    %ecx,%edx
801021b9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801021ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021bd:	5b                   	pop    %ebx
801021be:	5e                   	pop    %esi
801021bf:	5f                   	pop    %edi
801021c0:	5d                   	pop    %ebp
801021c1:	c3                   	ret    
801021c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021c8:	b8 30 00 00 00       	mov    $0x30,%eax
801021cd:	89 ca                	mov    %ecx,%edx
801021cf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801021d0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801021d5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801021d8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021dd:	fc                   	cld    
801021de:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021e3:	5b                   	pop    %ebx
801021e4:	5e                   	pop    %esi
801021e5:	5f                   	pop    %edi
801021e6:	5d                   	pop    %ebp
801021e7:	c3                   	ret    
    panic("incorrect blockno");
801021e8:	83 ec 0c             	sub    $0xc,%esp
801021eb:	68 54 74 10 80       	push   $0x80107454
801021f0:	e8 8b e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021f5:	83 ec 0c             	sub    $0xc,%esp
801021f8:	68 4b 74 10 80       	push   $0x8010744b
801021fd:	e8 7e e1 ff ff       	call   80100380 <panic>
80102202:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102210 <ideinit>:
{
80102210:	55                   	push   %ebp
80102211:	89 e5                	mov    %esp,%ebp
80102213:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102216:	68 66 74 10 80       	push   $0x80107466
8010221b:	68 20 19 11 80       	push   $0x80111920
80102220:	e8 fb 21 00 00       	call   80104420 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102225:	58                   	pop    %eax
80102226:	a1 a4 1a 11 80       	mov    0x80111aa4,%eax
8010222b:	5a                   	pop    %edx
8010222c:	83 e8 01             	sub    $0x1,%eax
8010222f:	50                   	push   %eax
80102230:	6a 0e                	push   $0xe
80102232:	e8 99 02 00 00       	call   801024d0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102237:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010223a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010223f:	90                   	nop
80102240:	ec                   	in     (%dx),%al
80102241:	83 e0 c0             	and    $0xffffffc0,%eax
80102244:	3c 40                	cmp    $0x40,%al
80102246:	75 f8                	jne    80102240 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102248:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010224d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102252:	ee                   	out    %al,(%dx)
80102253:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102258:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010225d:	eb 06                	jmp    80102265 <ideinit+0x55>
8010225f:	90                   	nop
  for(i=0; i<1000; i++){
80102260:	83 e9 01             	sub    $0x1,%ecx
80102263:	74 0f                	je     80102274 <ideinit+0x64>
80102265:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102266:	84 c0                	test   %al,%al
80102268:	74 f6                	je     80102260 <ideinit+0x50>
      havedisk1 = 1;
8010226a:	c7 05 00 19 11 80 01 	movl   $0x1,0x80111900
80102271:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102274:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102279:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010227e:	ee                   	out    %al,(%dx)
}
8010227f:	c9                   	leave  
80102280:	c3                   	ret    
80102281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010228f:	90                   	nop

80102290 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	57                   	push   %edi
80102294:	56                   	push   %esi
80102295:	53                   	push   %ebx
80102296:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102299:	68 20 19 11 80       	push   $0x80111920
8010229e:	e8 4d 23 00 00       	call   801045f0 <acquire>

  if((b = idequeue) == 0){
801022a3:	8b 1d 04 19 11 80    	mov    0x80111904,%ebx
801022a9:	83 c4 10             	add    $0x10,%esp
801022ac:	85 db                	test   %ebx,%ebx
801022ae:	74 63                	je     80102313 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801022b0:	8b 43 58             	mov    0x58(%ebx),%eax
801022b3:	a3 04 19 11 80       	mov    %eax,0x80111904

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801022b8:	8b 33                	mov    (%ebx),%esi
801022ba:	f7 c6 04 00 00 00    	test   $0x4,%esi
801022c0:	75 2f                	jne    801022f1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022c2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ce:	66 90                	xchg   %ax,%ax
801022d0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022d1:	89 c1                	mov    %eax,%ecx
801022d3:	83 e1 c0             	and    $0xffffffc0,%ecx
801022d6:	80 f9 40             	cmp    $0x40,%cl
801022d9:	75 f5                	jne    801022d0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801022db:	a8 21                	test   $0x21,%al
801022dd:	75 12                	jne    801022f1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801022df:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022e2:	b9 80 00 00 00       	mov    $0x80,%ecx
801022e7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022ec:	fc                   	cld    
801022ed:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801022ef:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022f1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022f4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022f7:	83 ce 02             	or     $0x2,%esi
801022fa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022fc:	53                   	push   %ebx
801022fd:	e8 4e 1e 00 00       	call   80104150 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102302:	a1 04 19 11 80       	mov    0x80111904,%eax
80102307:	83 c4 10             	add    $0x10,%esp
8010230a:	85 c0                	test   %eax,%eax
8010230c:	74 05                	je     80102313 <ideintr+0x83>
    idestart(idequeue);
8010230e:	e8 1d fe ff ff       	call   80102130 <idestart>
    release(&idelock);
80102313:	83 ec 0c             	sub    $0xc,%esp
80102316:	68 20 19 11 80       	push   $0x80111920
8010231b:	e8 70 22 00 00       	call   80104590 <release>

  release(&idelock);
}
80102320:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102323:	5b                   	pop    %ebx
80102324:	5e                   	pop    %esi
80102325:	5f                   	pop    %edi
80102326:	5d                   	pop    %ebp
80102327:	c3                   	ret    
80102328:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010232f:	90                   	nop

80102330 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102330:	55                   	push   %ebp
80102331:	89 e5                	mov    %esp,%ebp
80102333:	53                   	push   %ebx
80102334:	83 ec 10             	sub    $0x10,%esp
80102337:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010233a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010233d:	50                   	push   %eax
8010233e:	e8 8d 20 00 00       	call   801043d0 <holdingsleep>
80102343:	83 c4 10             	add    $0x10,%esp
80102346:	85 c0                	test   %eax,%eax
80102348:	0f 84 c3 00 00 00    	je     80102411 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010234e:	8b 03                	mov    (%ebx),%eax
80102350:	83 e0 06             	and    $0x6,%eax
80102353:	83 f8 02             	cmp    $0x2,%eax
80102356:	0f 84 a8 00 00 00    	je     80102404 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010235c:	8b 53 04             	mov    0x4(%ebx),%edx
8010235f:	85 d2                	test   %edx,%edx
80102361:	74 0d                	je     80102370 <iderw+0x40>
80102363:	a1 00 19 11 80       	mov    0x80111900,%eax
80102368:	85 c0                	test   %eax,%eax
8010236a:	0f 84 87 00 00 00    	je     801023f7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102370:	83 ec 0c             	sub    $0xc,%esp
80102373:	68 20 19 11 80       	push   $0x80111920
80102378:	e8 73 22 00 00       	call   801045f0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010237d:	a1 04 19 11 80       	mov    0x80111904,%eax
  b->qnext = 0;
80102382:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102389:	83 c4 10             	add    $0x10,%esp
8010238c:	85 c0                	test   %eax,%eax
8010238e:	74 60                	je     801023f0 <iderw+0xc0>
80102390:	89 c2                	mov    %eax,%edx
80102392:	8b 40 58             	mov    0x58(%eax),%eax
80102395:	85 c0                	test   %eax,%eax
80102397:	75 f7                	jne    80102390 <iderw+0x60>
80102399:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010239c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010239e:	39 1d 04 19 11 80    	cmp    %ebx,0x80111904
801023a4:	74 3a                	je     801023e0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023a6:	8b 03                	mov    (%ebx),%eax
801023a8:	83 e0 06             	and    $0x6,%eax
801023ab:	83 f8 02             	cmp    $0x2,%eax
801023ae:	74 1b                	je     801023cb <iderw+0x9b>
    sleep(b, &idelock);
801023b0:	83 ec 08             	sub    $0x8,%esp
801023b3:	68 20 19 11 80       	push   $0x80111920
801023b8:	53                   	push   %ebx
801023b9:	e8 d2 1c 00 00       	call   80104090 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023be:	8b 03                	mov    (%ebx),%eax
801023c0:	83 c4 10             	add    $0x10,%esp
801023c3:	83 e0 06             	and    $0x6,%eax
801023c6:	83 f8 02             	cmp    $0x2,%eax
801023c9:	75 e5                	jne    801023b0 <iderw+0x80>
  }


  release(&idelock);
801023cb:	c7 45 08 20 19 11 80 	movl   $0x80111920,0x8(%ebp)
}
801023d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023d5:	c9                   	leave  
  release(&idelock);
801023d6:	e9 b5 21 00 00       	jmp    80104590 <release>
801023db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023df:	90                   	nop
    idestart(b);
801023e0:	89 d8                	mov    %ebx,%eax
801023e2:	e8 49 fd ff ff       	call   80102130 <idestart>
801023e7:	eb bd                	jmp    801023a6 <iderw+0x76>
801023e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023f0:	ba 04 19 11 80       	mov    $0x80111904,%edx
801023f5:	eb a5                	jmp    8010239c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023f7:	83 ec 0c             	sub    $0xc,%esp
801023fa:	68 95 74 10 80       	push   $0x80107495
801023ff:	e8 7c df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102404:	83 ec 0c             	sub    $0xc,%esp
80102407:	68 80 74 10 80       	push   $0x80107480
8010240c:	e8 6f df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102411:	83 ec 0c             	sub    $0xc,%esp
80102414:	68 6a 74 10 80       	push   $0x8010746a
80102419:	e8 62 df ff ff       	call   80100380 <panic>
8010241e:	66 90                	xchg   %ax,%ax

80102420 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102420:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102421:	c7 05 54 19 11 80 00 	movl   $0xfec00000,0x80111954
80102428:	00 c0 fe 
{
8010242b:	89 e5                	mov    %esp,%ebp
8010242d:	56                   	push   %esi
8010242e:	53                   	push   %ebx
  ioapic->reg = reg;
8010242f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102436:	00 00 00 
  return ioapic->data;
80102439:	8b 15 54 19 11 80    	mov    0x80111954,%edx
8010243f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102442:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102448:	8b 0d 54 19 11 80    	mov    0x80111954,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010244e:	0f b6 15 a0 1a 11 80 	movzbl 0x80111aa0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102455:	c1 ee 10             	shr    $0x10,%esi
80102458:	89 f0                	mov    %esi,%eax
8010245a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010245d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102460:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102463:	39 c2                	cmp    %eax,%edx
80102465:	74 16                	je     8010247d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102467:	83 ec 0c             	sub    $0xc,%esp
8010246a:	68 b4 74 10 80       	push   $0x801074b4
8010246f:	e8 2c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102474:	8b 0d 54 19 11 80    	mov    0x80111954,%ecx
8010247a:	83 c4 10             	add    $0x10,%esp
8010247d:	83 c6 21             	add    $0x21,%esi
{
80102480:	ba 10 00 00 00       	mov    $0x10,%edx
80102485:	b8 20 00 00 00       	mov    $0x20,%eax
8010248a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102490:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102492:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102494:	8b 0d 54 19 11 80    	mov    0x80111954,%ecx
  for(i = 0; i <= maxintr; i++){
8010249a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010249d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
801024a3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
801024a6:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
801024a9:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801024ac:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801024ae:	8b 0d 54 19 11 80    	mov    0x80111954,%ecx
801024b4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801024bb:	39 f0                	cmp    %esi,%eax
801024bd:	75 d1                	jne    80102490 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801024bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024c2:	5b                   	pop    %ebx
801024c3:	5e                   	pop    %esi
801024c4:	5d                   	pop    %ebp
801024c5:	c3                   	ret    
801024c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024cd:	8d 76 00             	lea    0x0(%esi),%esi

801024d0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801024d0:	55                   	push   %ebp
  ioapic->reg = reg;
801024d1:	8b 0d 54 19 11 80    	mov    0x80111954,%ecx
{
801024d7:	89 e5                	mov    %esp,%ebp
801024d9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801024dc:	8d 50 20             	lea    0x20(%eax),%edx
801024df:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024e3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024e5:	8b 0d 54 19 11 80    	mov    0x80111954,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024eb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024ee:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024f4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024f6:	a1 54 19 11 80       	mov    0x80111954,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024fb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024fe:	89 50 10             	mov    %edx,0x10(%eax)
}
80102501:	5d                   	pop    %ebp
80102502:	c3                   	ret    
80102503:	66 90                	xchg   %ax,%ax
80102505:	66 90                	xchg   %ax,%ax
80102507:	66 90                	xchg   %ax,%ax
80102509:	66 90                	xchg   %ax,%ax
8010250b:	66 90                	xchg   %ax,%ax
8010250d:	66 90                	xchg   %ax,%ax
8010250f:	90                   	nop

80102510 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102510:	55                   	push   %ebp
80102511:	89 e5                	mov    %esp,%ebp
80102513:	53                   	push   %ebx
80102514:	83 ec 04             	sub    $0x4,%esp
80102517:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010251a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102520:	75 76                	jne    80102598 <kfree+0x88>
80102522:	81 fb f0 57 11 80    	cmp    $0x801157f0,%ebx
80102528:	72 6e                	jb     80102598 <kfree+0x88>
8010252a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102530:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102535:	77 61                	ja     80102598 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102537:	83 ec 04             	sub    $0x4,%esp
8010253a:	68 00 10 00 00       	push   $0x1000
8010253f:	6a 01                	push   $0x1
80102541:	53                   	push   %ebx
80102542:	e8 69 21 00 00       	call   801046b0 <memset>

  if(kmem.use_lock)
80102547:	8b 15 94 19 11 80    	mov    0x80111994,%edx
8010254d:	83 c4 10             	add    $0x10,%esp
80102550:	85 d2                	test   %edx,%edx
80102552:	75 1c                	jne    80102570 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102554:	a1 98 19 11 80       	mov    0x80111998,%eax
80102559:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010255b:	a1 94 19 11 80       	mov    0x80111994,%eax
  kmem.freelist = r;
80102560:	89 1d 98 19 11 80    	mov    %ebx,0x80111998
  if(kmem.use_lock)
80102566:	85 c0                	test   %eax,%eax
80102568:	75 1e                	jne    80102588 <kfree+0x78>
    release(&kmem.lock);
}
8010256a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010256d:	c9                   	leave  
8010256e:	c3                   	ret    
8010256f:	90                   	nop
    acquire(&kmem.lock);
80102570:	83 ec 0c             	sub    $0xc,%esp
80102573:	68 60 19 11 80       	push   $0x80111960
80102578:	e8 73 20 00 00       	call   801045f0 <acquire>
8010257d:	83 c4 10             	add    $0x10,%esp
80102580:	eb d2                	jmp    80102554 <kfree+0x44>
80102582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102588:	c7 45 08 60 19 11 80 	movl   $0x80111960,0x8(%ebp)
}
8010258f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102592:	c9                   	leave  
    release(&kmem.lock);
80102593:	e9 f8 1f 00 00       	jmp    80104590 <release>
    panic("kfree");
80102598:	83 ec 0c             	sub    $0xc,%esp
8010259b:	68 e6 74 10 80       	push   $0x801074e6
801025a0:	e8 db dd ff ff       	call   80100380 <panic>
801025a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025b0 <freerange>:
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
801025cf:	72 23                	jb     801025f4 <freerange+0x44>
801025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025d8:	83 ec 0c             	sub    $0xc,%esp
801025db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025e7:	50                   	push   %eax
801025e8:	e8 23 ff ff ff       	call   80102510 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ed:	83 c4 10             	add    $0x10,%esp
801025f0:	39 f3                	cmp    %esi,%ebx
801025f2:	76 e4                	jbe    801025d8 <freerange+0x28>
}
801025f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025f7:	5b                   	pop    %ebx
801025f8:	5e                   	pop    %esi
801025f9:	5d                   	pop    %ebp
801025fa:	c3                   	ret    
801025fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025ff:	90                   	nop

80102600 <kinit2>:
{
80102600:	55                   	push   %ebp
80102601:	89 e5                	mov    %esp,%ebp
80102603:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102604:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102607:	8b 75 0c             	mov    0xc(%ebp),%esi
8010260a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010260b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102611:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102617:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010261d:	39 de                	cmp    %ebx,%esi
8010261f:	72 23                	jb     80102644 <kinit2+0x44>
80102621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102628:	83 ec 0c             	sub    $0xc,%esp
8010262b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102631:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102637:	50                   	push   %eax
80102638:	e8 d3 fe ff ff       	call   80102510 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010263d:	83 c4 10             	add    $0x10,%esp
80102640:	39 de                	cmp    %ebx,%esi
80102642:	73 e4                	jae    80102628 <kinit2+0x28>
  kmem.use_lock = 1;
80102644:	c7 05 94 19 11 80 01 	movl   $0x1,0x80111994
8010264b:	00 00 00 
}
8010264e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102651:	5b                   	pop    %ebx
80102652:	5e                   	pop    %esi
80102653:	5d                   	pop    %ebp
80102654:	c3                   	ret    
80102655:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010265c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102660 <kinit1>:
{
80102660:	55                   	push   %ebp
80102661:	89 e5                	mov    %esp,%ebp
80102663:	56                   	push   %esi
80102664:	53                   	push   %ebx
80102665:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102668:	83 ec 08             	sub    $0x8,%esp
8010266b:	68 ec 74 10 80       	push   $0x801074ec
80102670:	68 60 19 11 80       	push   $0x80111960
80102675:	e8 a6 1d 00 00       	call   80104420 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010267a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010267d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102680:	c7 05 94 19 11 80 00 	movl   $0x0,0x80111994
80102687:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010268a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102690:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102696:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010269c:	39 de                	cmp    %ebx,%esi
8010269e:	72 1c                	jb     801026bc <kinit1+0x5c>
    kfree(p);
801026a0:	83 ec 0c             	sub    $0xc,%esp
801026a3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026a9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026af:	50                   	push   %eax
801026b0:	e8 5b fe ff ff       	call   80102510 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026b5:	83 c4 10             	add    $0x10,%esp
801026b8:	39 de                	cmp    %ebx,%esi
801026ba:	73 e4                	jae    801026a0 <kinit1+0x40>
}
801026bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026bf:	5b                   	pop    %ebx
801026c0:	5e                   	pop    %esi
801026c1:	5d                   	pop    %ebp
801026c2:	c3                   	ret    
801026c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801026d0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801026d0:	a1 94 19 11 80       	mov    0x80111994,%eax
801026d5:	85 c0                	test   %eax,%eax
801026d7:	75 1f                	jne    801026f8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026d9:	a1 98 19 11 80       	mov    0x80111998,%eax
  if(r)
801026de:	85 c0                	test   %eax,%eax
801026e0:	74 0e                	je     801026f0 <kalloc+0x20>
    kmem.freelist = r->next;
801026e2:	8b 10                	mov    (%eax),%edx
801026e4:	89 15 98 19 11 80    	mov    %edx,0x80111998
  if(kmem.use_lock)
801026ea:	c3                   	ret    
801026eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026ef:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026f0:	c3                   	ret    
801026f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026f8:	55                   	push   %ebp
801026f9:	89 e5                	mov    %esp,%ebp
801026fb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026fe:	68 60 19 11 80       	push   $0x80111960
80102703:	e8 e8 1e 00 00       	call   801045f0 <acquire>
  r = kmem.freelist;
80102708:	a1 98 19 11 80       	mov    0x80111998,%eax
  if(kmem.use_lock)
8010270d:	8b 15 94 19 11 80    	mov    0x80111994,%edx
  if(r)
80102713:	83 c4 10             	add    $0x10,%esp
80102716:	85 c0                	test   %eax,%eax
80102718:	74 08                	je     80102722 <kalloc+0x52>
    kmem.freelist = r->next;
8010271a:	8b 08                	mov    (%eax),%ecx
8010271c:	89 0d 98 19 11 80    	mov    %ecx,0x80111998
  if(kmem.use_lock)
80102722:	85 d2                	test   %edx,%edx
80102724:	74 16                	je     8010273c <kalloc+0x6c>
    release(&kmem.lock);
80102726:	83 ec 0c             	sub    $0xc,%esp
80102729:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010272c:	68 60 19 11 80       	push   $0x80111960
80102731:	e8 5a 1e 00 00       	call   80104590 <release>
  return (char*)r;
80102736:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102739:	83 c4 10             	add    $0x10,%esp
}
8010273c:	c9                   	leave  
8010273d:	c3                   	ret    
8010273e:	66 90                	xchg   %ax,%ax

80102740 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102740:	ba 64 00 00 00       	mov    $0x64,%edx
80102745:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102746:	a8 01                	test   $0x1,%al
80102748:	0f 84 c2 00 00 00    	je     80102810 <kbdgetc+0xd0>
{
8010274e:	55                   	push   %ebp
8010274f:	ba 60 00 00 00       	mov    $0x60,%edx
80102754:	89 e5                	mov    %esp,%ebp
80102756:	53                   	push   %ebx
80102757:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102758:	8b 1d 9c 19 11 80    	mov    0x8011199c,%ebx
  data = inb(KBDATAP);
8010275e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102761:	3c e0                	cmp    $0xe0,%al
80102763:	74 5b                	je     801027c0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102765:	89 da                	mov    %ebx,%edx
80102767:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010276a:	84 c0                	test   %al,%al
8010276c:	78 62                	js     801027d0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010276e:	85 d2                	test   %edx,%edx
80102770:	74 09                	je     8010277b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102772:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102775:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102778:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010277b:	0f b6 91 20 76 10 80 	movzbl -0x7fef89e0(%ecx),%edx
  shift ^= togglecode[data];
80102782:	0f b6 81 20 75 10 80 	movzbl -0x7fef8ae0(%ecx),%eax
  shift |= shiftcode[data];
80102789:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010278b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010278d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010278f:	89 15 9c 19 11 80    	mov    %edx,0x8011199c
  c = charcode[shift & (CTL | SHIFT)][data];
80102795:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102798:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010279b:	8b 04 85 00 75 10 80 	mov    -0x7fef8b00(,%eax,4),%eax
801027a2:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801027a6:	74 0b                	je     801027b3 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
801027a8:	8d 50 9f             	lea    -0x61(%eax),%edx
801027ab:	83 fa 19             	cmp    $0x19,%edx
801027ae:	77 48                	ja     801027f8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801027b0:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801027b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027b6:	c9                   	leave  
801027b7:	c3                   	ret    
801027b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027bf:	90                   	nop
    shift |= E0ESC;
801027c0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801027c3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801027c5:	89 1d 9c 19 11 80    	mov    %ebx,0x8011199c
}
801027cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027ce:	c9                   	leave  
801027cf:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
801027d0:	83 e0 7f             	and    $0x7f,%eax
801027d3:	85 d2                	test   %edx,%edx
801027d5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801027d8:	0f b6 81 20 76 10 80 	movzbl -0x7fef89e0(%ecx),%eax
801027df:	83 c8 40             	or     $0x40,%eax
801027e2:	0f b6 c0             	movzbl %al,%eax
801027e5:	f7 d0                	not    %eax
801027e7:	21 d8                	and    %ebx,%eax
}
801027e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
801027ec:	a3 9c 19 11 80       	mov    %eax,0x8011199c
    return 0;
801027f1:	31 c0                	xor    %eax,%eax
}
801027f3:	c9                   	leave  
801027f4:	c3                   	ret    
801027f5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027f8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027fb:	8d 50 20             	lea    0x20(%eax),%edx
}
801027fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102801:	c9                   	leave  
      c += 'a' - 'A';
80102802:	83 f9 1a             	cmp    $0x1a,%ecx
80102805:	0f 42 c2             	cmovb  %edx,%eax
}
80102808:	c3                   	ret    
80102809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102810:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102815:	c3                   	ret    
80102816:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010281d:	8d 76 00             	lea    0x0(%esi),%esi

80102820 <kbdintr>:

void
kbdintr(void)
{
80102820:	55                   	push   %ebp
80102821:	89 e5                	mov    %esp,%ebp
80102823:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102826:	68 40 27 10 80       	push   $0x80102740
8010282b:	e8 50 e0 ff ff       	call   80100880 <consoleintr>
}
80102830:	83 c4 10             	add    $0x10,%esp
80102833:	c9                   	leave  
80102834:	c3                   	ret    
80102835:	66 90                	xchg   %ax,%ax
80102837:	66 90                	xchg   %ax,%ax
80102839:	66 90                	xchg   %ax,%ax
8010283b:	66 90                	xchg   %ax,%ax
8010283d:	66 90                	xchg   %ax,%ax
8010283f:	90                   	nop

80102840 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102840:	a1 a0 19 11 80       	mov    0x801119a0,%eax
80102845:	85 c0                	test   %eax,%eax
80102847:	0f 84 cb 00 00 00    	je     80102918 <lapicinit+0xd8>
  lapic[index] = value;
8010284d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102854:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102857:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010285a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102861:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102864:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102867:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010286e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102871:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102874:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010287b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010287e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102881:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102888:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010288b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010288e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102895:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102898:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010289b:	8b 50 30             	mov    0x30(%eax),%edx
8010289e:	c1 ea 10             	shr    $0x10,%edx
801028a1:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801028a7:	75 77                	jne    80102920 <lapicinit+0xe0>
  lapic[index] = value;
801028a9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801028b0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028b3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028b6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028bd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028c3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028ca:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028cd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028d0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028d7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028da:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028dd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ea:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028f1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028f4:	8b 50 20             	mov    0x20(%eax),%edx
801028f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028fe:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102900:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102906:	80 e6 10             	and    $0x10,%dh
80102909:	75 f5                	jne    80102900 <lapicinit+0xc0>
  lapic[index] = value;
8010290b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102912:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102915:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102918:	c3                   	ret    
80102919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102920:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102927:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010292a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010292d:	e9 77 ff ff ff       	jmp    801028a9 <lapicinit+0x69>
80102932:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102940 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102940:	a1 a0 19 11 80       	mov    0x801119a0,%eax
80102945:	85 c0                	test   %eax,%eax
80102947:	74 07                	je     80102950 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102949:	8b 40 20             	mov    0x20(%eax),%eax
8010294c:	c1 e8 18             	shr    $0x18,%eax
8010294f:	c3                   	ret    
    return 0;
80102950:	31 c0                	xor    %eax,%eax
}
80102952:	c3                   	ret    
80102953:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010295a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102960 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102960:	a1 a0 19 11 80       	mov    0x801119a0,%eax
80102965:	85 c0                	test   %eax,%eax
80102967:	74 0d                	je     80102976 <lapiceoi+0x16>
  lapic[index] = value;
80102969:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102970:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102973:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102976:	c3                   	ret    
80102977:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010297e:	66 90                	xchg   %ax,%ax

80102980 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102980:	c3                   	ret    
80102981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010298f:	90                   	nop

80102990 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102990:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102991:	b8 0f 00 00 00       	mov    $0xf,%eax
80102996:	ba 70 00 00 00       	mov    $0x70,%edx
8010299b:	89 e5                	mov    %esp,%ebp
8010299d:	53                   	push   %ebx
8010299e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801029a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801029a4:	ee                   	out    %al,(%dx)
801029a5:	b8 0a 00 00 00       	mov    $0xa,%eax
801029aa:	ba 71 00 00 00       	mov    $0x71,%edx
801029af:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801029b0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801029b2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801029b5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801029bb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801029bd:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
801029c0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801029c2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801029c5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801029c8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801029ce:	a1 a0 19 11 80       	mov    0x801119a0,%eax
801029d3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029d9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029dc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029e3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029e6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029e9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029f0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029f3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029f6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029fc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029ff:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a05:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a08:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a0e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a11:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a17:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a1d:	c9                   	leave  
80102a1e:	c3                   	ret    
80102a1f:	90                   	nop

80102a20 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102a20:	55                   	push   %ebp
80102a21:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a26:	ba 70 00 00 00       	mov    $0x70,%edx
80102a2b:	89 e5                	mov    %esp,%ebp
80102a2d:	57                   	push   %edi
80102a2e:	56                   	push   %esi
80102a2f:	53                   	push   %ebx
80102a30:	83 ec 4c             	sub    $0x4c,%esp
80102a33:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a34:	ba 71 00 00 00       	mov    $0x71,%edx
80102a39:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a3a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a3d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a42:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a45:	8d 76 00             	lea    0x0(%esi),%esi
80102a48:	31 c0                	xor    %eax,%eax
80102a4a:	89 da                	mov    %ebx,%edx
80102a4c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a52:	89 ca                	mov    %ecx,%edx
80102a54:	ec                   	in     (%dx),%al
80102a55:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a58:	89 da                	mov    %ebx,%edx
80102a5a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a5f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a60:	89 ca                	mov    %ecx,%edx
80102a62:	ec                   	in     (%dx),%al
80102a63:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a66:	89 da                	mov    %ebx,%edx
80102a68:	b8 04 00 00 00       	mov    $0x4,%eax
80102a6d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a6e:	89 ca                	mov    %ecx,%edx
80102a70:	ec                   	in     (%dx),%al
80102a71:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a74:	89 da                	mov    %ebx,%edx
80102a76:	b8 07 00 00 00       	mov    $0x7,%eax
80102a7b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a7c:	89 ca                	mov    %ecx,%edx
80102a7e:	ec                   	in     (%dx),%al
80102a7f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a82:	89 da                	mov    %ebx,%edx
80102a84:	b8 08 00 00 00       	mov    $0x8,%eax
80102a89:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8a:	89 ca                	mov    %ecx,%edx
80102a8c:	ec                   	in     (%dx),%al
80102a8d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a8f:	89 da                	mov    %ebx,%edx
80102a91:	b8 09 00 00 00       	mov    $0x9,%eax
80102a96:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a97:	89 ca                	mov    %ecx,%edx
80102a99:	ec                   	in     (%dx),%al
80102a9a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9c:	89 da                	mov    %ebx,%edx
80102a9e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102aa3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa4:	89 ca                	mov    %ecx,%edx
80102aa6:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102aa7:	84 c0                	test   %al,%al
80102aa9:	78 9d                	js     80102a48 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102aab:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102aaf:	89 fa                	mov    %edi,%edx
80102ab1:	0f b6 fa             	movzbl %dl,%edi
80102ab4:	89 f2                	mov    %esi,%edx
80102ab6:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102ab9:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102abd:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac0:	89 da                	mov    %ebx,%edx
80102ac2:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102ac5:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102ac8:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102acc:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102acf:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102ad2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102ad6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ad9:	31 c0                	xor    %eax,%eax
80102adb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102adc:	89 ca                	mov    %ecx,%edx
80102ade:	ec                   	in     (%dx),%al
80102adf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae2:	89 da                	mov    %ebx,%edx
80102ae4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ae7:	b8 02 00 00 00       	mov    $0x2,%eax
80102aec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aed:	89 ca                	mov    %ecx,%edx
80102aef:	ec                   	in     (%dx),%al
80102af0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af3:	89 da                	mov    %ebx,%edx
80102af5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102af8:	b8 04 00 00 00       	mov    $0x4,%eax
80102afd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102afe:	89 ca                	mov    %ecx,%edx
80102b00:	ec                   	in     (%dx),%al
80102b01:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b04:	89 da                	mov    %ebx,%edx
80102b06:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b09:	b8 07 00 00 00       	mov    $0x7,%eax
80102b0e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b0f:	89 ca                	mov    %ecx,%edx
80102b11:	ec                   	in     (%dx),%al
80102b12:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b15:	89 da                	mov    %ebx,%edx
80102b17:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b1a:	b8 08 00 00 00       	mov    $0x8,%eax
80102b1f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b20:	89 ca                	mov    %ecx,%edx
80102b22:	ec                   	in     (%dx),%al
80102b23:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b26:	89 da                	mov    %ebx,%edx
80102b28:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b2b:	b8 09 00 00 00       	mov    $0x9,%eax
80102b30:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b31:	89 ca                	mov    %ecx,%edx
80102b33:	ec                   	in     (%dx),%al
80102b34:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b37:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b3a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b3d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b40:	6a 18                	push   $0x18
80102b42:	50                   	push   %eax
80102b43:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b46:	50                   	push   %eax
80102b47:	e8 b4 1b 00 00       	call   80104700 <memcmp>
80102b4c:	83 c4 10             	add    $0x10,%esp
80102b4f:	85 c0                	test   %eax,%eax
80102b51:	0f 85 f1 fe ff ff    	jne    80102a48 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b57:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b5b:	75 78                	jne    80102bd5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b5d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b60:	89 c2                	mov    %eax,%edx
80102b62:	83 e0 0f             	and    $0xf,%eax
80102b65:	c1 ea 04             	shr    $0x4,%edx
80102b68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b71:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b74:	89 c2                	mov    %eax,%edx
80102b76:	83 e0 0f             	and    $0xf,%eax
80102b79:	c1 ea 04             	shr    $0x4,%edx
80102b7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b82:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b85:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b88:	89 c2                	mov    %eax,%edx
80102b8a:	83 e0 0f             	and    $0xf,%eax
80102b8d:	c1 ea 04             	shr    $0x4,%edx
80102b90:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b93:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b96:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b9c:	89 c2                	mov    %eax,%edx
80102b9e:	83 e0 0f             	and    $0xf,%eax
80102ba1:	c1 ea 04             	shr    $0x4,%edx
80102ba4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ba7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102baa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102bad:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bb0:	89 c2                	mov    %eax,%edx
80102bb2:	83 e0 0f             	and    $0xf,%eax
80102bb5:	c1 ea 04             	shr    $0x4,%edx
80102bb8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bbb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bbe:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102bc1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bc4:	89 c2                	mov    %eax,%edx
80102bc6:	83 e0 0f             	and    $0xf,%eax
80102bc9:	c1 ea 04             	shr    $0x4,%edx
80102bcc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bcf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bd2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102bd5:	8b 75 08             	mov    0x8(%ebp),%esi
80102bd8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bdb:	89 06                	mov    %eax,(%esi)
80102bdd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102be0:	89 46 04             	mov    %eax,0x4(%esi)
80102be3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102be6:	89 46 08             	mov    %eax,0x8(%esi)
80102be9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bec:	89 46 0c             	mov    %eax,0xc(%esi)
80102bef:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bf2:	89 46 10             	mov    %eax,0x10(%esi)
80102bf5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bf8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bfb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102c02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c05:	5b                   	pop    %ebx
80102c06:	5e                   	pop    %esi
80102c07:	5f                   	pop    %edi
80102c08:	5d                   	pop    %ebp
80102c09:	c3                   	ret    
80102c0a:	66 90                	xchg   %ax,%ax
80102c0c:	66 90                	xchg   %ax,%ax
80102c0e:	66 90                	xchg   %ax,%ax

80102c10 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c10:	8b 0d 08 1a 11 80    	mov    0x80111a08,%ecx
80102c16:	85 c9                	test   %ecx,%ecx
80102c18:	0f 8e 8a 00 00 00    	jle    80102ca8 <install_trans+0x98>
{
80102c1e:	55                   	push   %ebp
80102c1f:	89 e5                	mov    %esp,%ebp
80102c21:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c22:	31 ff                	xor    %edi,%edi
{
80102c24:	56                   	push   %esi
80102c25:	53                   	push   %ebx
80102c26:	83 ec 0c             	sub    $0xc,%esp
80102c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c30:	a1 f4 19 11 80       	mov    0x801119f4,%eax
80102c35:	83 ec 08             	sub    $0x8,%esp
80102c38:	01 f8                	add    %edi,%eax
80102c3a:	83 c0 01             	add    $0x1,%eax
80102c3d:	50                   	push   %eax
80102c3e:	ff 35 04 1a 11 80    	push   0x80111a04
80102c44:	e8 87 d4 ff ff       	call   801000d0 <bread>
80102c49:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c4b:	58                   	pop    %eax
80102c4c:	5a                   	pop    %edx
80102c4d:	ff 34 bd 0c 1a 11 80 	push   -0x7feee5f4(,%edi,4)
80102c54:	ff 35 04 1a 11 80    	push   0x80111a04
  for (tail = 0; tail < log.lh.n; tail++) {
80102c5a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c5d:	e8 6e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c62:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c65:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c67:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c6a:	68 00 02 00 00       	push   $0x200
80102c6f:	50                   	push   %eax
80102c70:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c73:	50                   	push   %eax
80102c74:	e8 d7 1a 00 00       	call   80104750 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c79:	89 1c 24             	mov    %ebx,(%esp)
80102c7c:	e8 2f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c81:	89 34 24             	mov    %esi,(%esp)
80102c84:	e8 67 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c89:	89 1c 24             	mov    %ebx,(%esp)
80102c8c:	e8 5f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c91:	83 c4 10             	add    $0x10,%esp
80102c94:	39 3d 08 1a 11 80    	cmp    %edi,0x80111a08
80102c9a:	7f 94                	jg     80102c30 <install_trans+0x20>
  }
}
80102c9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c9f:	5b                   	pop    %ebx
80102ca0:	5e                   	pop    %esi
80102ca1:	5f                   	pop    %edi
80102ca2:	5d                   	pop    %ebp
80102ca3:	c3                   	ret    
80102ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ca8:	c3                   	ret    
80102ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102cb0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102cb0:	55                   	push   %ebp
80102cb1:	89 e5                	mov    %esp,%ebp
80102cb3:	53                   	push   %ebx
80102cb4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102cb7:	ff 35 f4 19 11 80    	push   0x801119f4
80102cbd:	ff 35 04 1a 11 80    	push   0x80111a04
80102cc3:	e8 08 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102cc8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ccb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102ccd:	a1 08 1a 11 80       	mov    0x80111a08,%eax
80102cd2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102cd5:	85 c0                	test   %eax,%eax
80102cd7:	7e 19                	jle    80102cf2 <write_head+0x42>
80102cd9:	31 d2                	xor    %edx,%edx
80102cdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cdf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102ce0:	8b 0c 95 0c 1a 11 80 	mov    -0x7feee5f4(,%edx,4),%ecx
80102ce7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102ceb:	83 c2 01             	add    $0x1,%edx
80102cee:	39 d0                	cmp    %edx,%eax
80102cf0:	75 ee                	jne    80102ce0 <write_head+0x30>
  }
  bwrite(buf);
80102cf2:	83 ec 0c             	sub    $0xc,%esp
80102cf5:	53                   	push   %ebx
80102cf6:	e8 b5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cfb:	89 1c 24             	mov    %ebx,(%esp)
80102cfe:	e8 ed d4 ff ff       	call   801001f0 <brelse>
}
80102d03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d06:	83 c4 10             	add    $0x10,%esp
80102d09:	c9                   	leave  
80102d0a:	c3                   	ret    
80102d0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d0f:	90                   	nop

80102d10 <initlog>:
{
80102d10:	55                   	push   %ebp
80102d11:	89 e5                	mov    %esp,%ebp
80102d13:	53                   	push   %ebx
80102d14:	83 ec 2c             	sub    $0x2c,%esp
80102d17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d1a:	68 20 77 10 80       	push   $0x80107720
80102d1f:	68 c0 19 11 80       	push   $0x801119c0
80102d24:	e8 f7 16 00 00       	call   80104420 <initlock>
  readsb(dev, &sb);
80102d29:	58                   	pop    %eax
80102d2a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d2d:	5a                   	pop    %edx
80102d2e:	50                   	push   %eax
80102d2f:	53                   	push   %ebx
80102d30:	e8 3b e8 ff ff       	call   80101570 <readsb>
  log.start = sb.logstart;
80102d35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d38:	59                   	pop    %ecx
  log.dev = dev;
80102d39:	89 1d 04 1a 11 80    	mov    %ebx,0x80111a04
  log.size = sb.nlog;
80102d3f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d42:	a3 f4 19 11 80       	mov    %eax,0x801119f4
  log.size = sb.nlog;
80102d47:	89 15 f8 19 11 80    	mov    %edx,0x801119f8
  struct buf *buf = bread(log.dev, log.start);
80102d4d:	5a                   	pop    %edx
80102d4e:	50                   	push   %eax
80102d4f:	53                   	push   %ebx
80102d50:	e8 7b d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d55:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d58:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d5b:	89 1d 08 1a 11 80    	mov    %ebx,0x80111a08
  for (i = 0; i < log.lh.n; i++) {
80102d61:	85 db                	test   %ebx,%ebx
80102d63:	7e 1d                	jle    80102d82 <initlog+0x72>
80102d65:	31 d2                	xor    %edx,%edx
80102d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d6e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d70:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d74:	89 0c 95 0c 1a 11 80 	mov    %ecx,-0x7feee5f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d7b:	83 c2 01             	add    $0x1,%edx
80102d7e:	39 d3                	cmp    %edx,%ebx
80102d80:	75 ee                	jne    80102d70 <initlog+0x60>
  brelse(buf);
80102d82:	83 ec 0c             	sub    $0xc,%esp
80102d85:	50                   	push   %eax
80102d86:	e8 65 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d8b:	e8 80 fe ff ff       	call   80102c10 <install_trans>
  log.lh.n = 0;
80102d90:	c7 05 08 1a 11 80 00 	movl   $0x0,0x80111a08
80102d97:	00 00 00 
  write_head(); // clear the log
80102d9a:	e8 11 ff ff ff       	call   80102cb0 <write_head>
}
80102d9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102da2:	83 c4 10             	add    $0x10,%esp
80102da5:	c9                   	leave  
80102da6:	c3                   	ret    
80102da7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dae:	66 90                	xchg   %ax,%ax

80102db0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102db6:	68 c0 19 11 80       	push   $0x801119c0
80102dbb:	e8 30 18 00 00       	call   801045f0 <acquire>
80102dc0:	83 c4 10             	add    $0x10,%esp
80102dc3:	eb 18                	jmp    80102ddd <begin_op+0x2d>
80102dc5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102dc8:	83 ec 08             	sub    $0x8,%esp
80102dcb:	68 c0 19 11 80       	push   $0x801119c0
80102dd0:	68 c0 19 11 80       	push   $0x801119c0
80102dd5:	e8 b6 12 00 00       	call   80104090 <sleep>
80102dda:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102ddd:	a1 00 1a 11 80       	mov    0x80111a00,%eax
80102de2:	85 c0                	test   %eax,%eax
80102de4:	75 e2                	jne    80102dc8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102de6:	a1 fc 19 11 80       	mov    0x801119fc,%eax
80102deb:	8b 15 08 1a 11 80    	mov    0x80111a08,%edx
80102df1:	83 c0 01             	add    $0x1,%eax
80102df4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102df7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102dfa:	83 fa 1e             	cmp    $0x1e,%edx
80102dfd:	7f c9                	jg     80102dc8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102dff:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e02:	a3 fc 19 11 80       	mov    %eax,0x801119fc
      release(&log.lock);
80102e07:	68 c0 19 11 80       	push   $0x801119c0
80102e0c:	e8 7f 17 00 00       	call   80104590 <release>
      break;
    }
  }
}
80102e11:	83 c4 10             	add    $0x10,%esp
80102e14:	c9                   	leave  
80102e15:	c3                   	ret    
80102e16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e1d:	8d 76 00             	lea    0x0(%esi),%esi

80102e20 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e20:	55                   	push   %ebp
80102e21:	89 e5                	mov    %esp,%ebp
80102e23:	57                   	push   %edi
80102e24:	56                   	push   %esi
80102e25:	53                   	push   %ebx
80102e26:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e29:	68 c0 19 11 80       	push   $0x801119c0
80102e2e:	e8 bd 17 00 00       	call   801045f0 <acquire>
  log.outstanding -= 1;
80102e33:	a1 fc 19 11 80       	mov    0x801119fc,%eax
  if(log.committing)
80102e38:	8b 35 00 1a 11 80    	mov    0x80111a00,%esi
80102e3e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e41:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e44:	89 1d fc 19 11 80    	mov    %ebx,0x801119fc
  if(log.committing)
80102e4a:	85 f6                	test   %esi,%esi
80102e4c:	0f 85 22 01 00 00    	jne    80102f74 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e52:	85 db                	test   %ebx,%ebx
80102e54:	0f 85 f6 00 00 00    	jne    80102f50 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e5a:	c7 05 00 1a 11 80 01 	movl   $0x1,0x80111a00
80102e61:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e64:	83 ec 0c             	sub    $0xc,%esp
80102e67:	68 c0 19 11 80       	push   $0x801119c0
80102e6c:	e8 1f 17 00 00       	call   80104590 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e71:	8b 0d 08 1a 11 80    	mov    0x80111a08,%ecx
80102e77:	83 c4 10             	add    $0x10,%esp
80102e7a:	85 c9                	test   %ecx,%ecx
80102e7c:	7f 42                	jg     80102ec0 <end_op+0xa0>
    acquire(&log.lock);
80102e7e:	83 ec 0c             	sub    $0xc,%esp
80102e81:	68 c0 19 11 80       	push   $0x801119c0
80102e86:	e8 65 17 00 00       	call   801045f0 <acquire>
    wakeup(&log);
80102e8b:	c7 04 24 c0 19 11 80 	movl   $0x801119c0,(%esp)
    log.committing = 0;
80102e92:	c7 05 00 1a 11 80 00 	movl   $0x0,0x80111a00
80102e99:	00 00 00 
    wakeup(&log);
80102e9c:	e8 af 12 00 00       	call   80104150 <wakeup>
    release(&log.lock);
80102ea1:	c7 04 24 c0 19 11 80 	movl   $0x801119c0,(%esp)
80102ea8:	e8 e3 16 00 00       	call   80104590 <release>
80102ead:	83 c4 10             	add    $0x10,%esp
}
80102eb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eb3:	5b                   	pop    %ebx
80102eb4:	5e                   	pop    %esi
80102eb5:	5f                   	pop    %edi
80102eb6:	5d                   	pop    %ebp
80102eb7:	c3                   	ret    
80102eb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ebf:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ec0:	a1 f4 19 11 80       	mov    0x801119f4,%eax
80102ec5:	83 ec 08             	sub    $0x8,%esp
80102ec8:	01 d8                	add    %ebx,%eax
80102eca:	83 c0 01             	add    $0x1,%eax
80102ecd:	50                   	push   %eax
80102ece:	ff 35 04 1a 11 80    	push   0x80111a04
80102ed4:	e8 f7 d1 ff ff       	call   801000d0 <bread>
80102ed9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102edb:	58                   	pop    %eax
80102edc:	5a                   	pop    %edx
80102edd:	ff 34 9d 0c 1a 11 80 	push   -0x7feee5f4(,%ebx,4)
80102ee4:	ff 35 04 1a 11 80    	push   0x80111a04
  for (tail = 0; tail < log.lh.n; tail++) {
80102eea:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102eed:	e8 de d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ef2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ef5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ef7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102efa:	68 00 02 00 00       	push   $0x200
80102eff:	50                   	push   %eax
80102f00:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f03:	50                   	push   %eax
80102f04:	e8 47 18 00 00       	call   80104750 <memmove>
    bwrite(to);  // write the log
80102f09:	89 34 24             	mov    %esi,(%esp)
80102f0c:	e8 9f d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102f11:	89 3c 24             	mov    %edi,(%esp)
80102f14:	e8 d7 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102f19:	89 34 24             	mov    %esi,(%esp)
80102f1c:	e8 cf d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f21:	83 c4 10             	add    $0x10,%esp
80102f24:	3b 1d 08 1a 11 80    	cmp    0x80111a08,%ebx
80102f2a:	7c 94                	jl     80102ec0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f2c:	e8 7f fd ff ff       	call   80102cb0 <write_head>
    install_trans(); // Now install writes to home locations
80102f31:	e8 da fc ff ff       	call   80102c10 <install_trans>
    log.lh.n = 0;
80102f36:	c7 05 08 1a 11 80 00 	movl   $0x0,0x80111a08
80102f3d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f40:	e8 6b fd ff ff       	call   80102cb0 <write_head>
80102f45:	e9 34 ff ff ff       	jmp    80102e7e <end_op+0x5e>
80102f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f50:	83 ec 0c             	sub    $0xc,%esp
80102f53:	68 c0 19 11 80       	push   $0x801119c0
80102f58:	e8 f3 11 00 00       	call   80104150 <wakeup>
  release(&log.lock);
80102f5d:	c7 04 24 c0 19 11 80 	movl   $0x801119c0,(%esp)
80102f64:	e8 27 16 00 00       	call   80104590 <release>
80102f69:	83 c4 10             	add    $0x10,%esp
}
80102f6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f6f:	5b                   	pop    %ebx
80102f70:	5e                   	pop    %esi
80102f71:	5f                   	pop    %edi
80102f72:	5d                   	pop    %ebp
80102f73:	c3                   	ret    
    panic("log.committing");
80102f74:	83 ec 0c             	sub    $0xc,%esp
80102f77:	68 24 77 10 80       	push   $0x80107724
80102f7c:	e8 ff d3 ff ff       	call   80100380 <panic>
80102f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f8f:	90                   	nop

80102f90 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f90:	55                   	push   %ebp
80102f91:	89 e5                	mov    %esp,%ebp
80102f93:	53                   	push   %ebx
80102f94:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f97:	8b 15 08 1a 11 80    	mov    0x80111a08,%edx
{
80102f9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fa0:	83 fa 1d             	cmp    $0x1d,%edx
80102fa3:	0f 8f 85 00 00 00    	jg     8010302e <log_write+0x9e>
80102fa9:	a1 f8 19 11 80       	mov    0x801119f8,%eax
80102fae:	83 e8 01             	sub    $0x1,%eax
80102fb1:	39 c2                	cmp    %eax,%edx
80102fb3:	7d 79                	jge    8010302e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102fb5:	a1 fc 19 11 80       	mov    0x801119fc,%eax
80102fba:	85 c0                	test   %eax,%eax
80102fbc:	7e 7d                	jle    8010303b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102fbe:	83 ec 0c             	sub    $0xc,%esp
80102fc1:	68 c0 19 11 80       	push   $0x801119c0
80102fc6:	e8 25 16 00 00       	call   801045f0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102fcb:	8b 15 08 1a 11 80    	mov    0x80111a08,%edx
80102fd1:	83 c4 10             	add    $0x10,%esp
80102fd4:	85 d2                	test   %edx,%edx
80102fd6:	7e 4a                	jle    80103022 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fd8:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102fdb:	31 c0                	xor    %eax,%eax
80102fdd:	eb 08                	jmp    80102fe7 <log_write+0x57>
80102fdf:	90                   	nop
80102fe0:	83 c0 01             	add    $0x1,%eax
80102fe3:	39 c2                	cmp    %eax,%edx
80102fe5:	74 29                	je     80103010 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fe7:	39 0c 85 0c 1a 11 80 	cmp    %ecx,-0x7feee5f4(,%eax,4)
80102fee:	75 f0                	jne    80102fe0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102ff0:	89 0c 85 0c 1a 11 80 	mov    %ecx,-0x7feee5f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102ff7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102ffa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102ffd:	c7 45 08 c0 19 11 80 	movl   $0x801119c0,0x8(%ebp)
}
80103004:	c9                   	leave  
  release(&log.lock);
80103005:	e9 86 15 00 00       	jmp    80104590 <release>
8010300a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103010:	89 0c 95 0c 1a 11 80 	mov    %ecx,-0x7feee5f4(,%edx,4)
    log.lh.n++;
80103017:	83 c2 01             	add    $0x1,%edx
8010301a:	89 15 08 1a 11 80    	mov    %edx,0x80111a08
80103020:	eb d5                	jmp    80102ff7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103022:	8b 43 08             	mov    0x8(%ebx),%eax
80103025:	a3 0c 1a 11 80       	mov    %eax,0x80111a0c
  if (i == log.lh.n)
8010302a:	75 cb                	jne    80102ff7 <log_write+0x67>
8010302c:	eb e9                	jmp    80103017 <log_write+0x87>
    panic("too big a transaction");
8010302e:	83 ec 0c             	sub    $0xc,%esp
80103031:	68 33 77 10 80       	push   $0x80107733
80103036:	e8 45 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010303b:	83 ec 0c             	sub    $0xc,%esp
8010303e:	68 49 77 10 80       	push   $0x80107749
80103043:	e8 38 d3 ff ff       	call   80100380 <panic>
80103048:	66 90                	xchg   %ax,%ax
8010304a:	66 90                	xchg   %ax,%ax
8010304c:	66 90                	xchg   %ax,%ax
8010304e:	66 90                	xchg   %ax,%ax

80103050 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	53                   	push   %ebx
80103054:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103057:	e8 44 09 00 00       	call   801039a0 <cpuid>
8010305c:	89 c3                	mov    %eax,%ebx
8010305e:	e8 3d 09 00 00       	call   801039a0 <cpuid>
80103063:	83 ec 04             	sub    $0x4,%esp
80103066:	53                   	push   %ebx
80103067:	50                   	push   %eax
80103068:	68 64 77 10 80       	push   $0x80107764
8010306d:	e8 2e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103072:	e8 49 29 00 00       	call   801059c0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103077:	e8 c4 08 00 00       	call   80103940 <mycpu>
8010307c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010307e:	b8 01 00 00 00       	mov    $0x1,%eax
80103083:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010308a:	e8 f1 0b 00 00       	call   80103c80 <scheduler>
8010308f:	90                   	nop

80103090 <mpenter>:
{
80103090:	55                   	push   %ebp
80103091:	89 e5                	mov    %esp,%ebp
80103093:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103096:	e8 15 3a 00 00       	call   80106ab0 <switchkvm>
  seginit();
8010309b:	e8 80 39 00 00       	call   80106a20 <seginit>
  lapicinit();
801030a0:	e8 9b f7 ff ff       	call   80102840 <lapicinit>
  mpmain();
801030a5:	e8 a6 ff ff ff       	call   80103050 <mpmain>
801030aa:	66 90                	xchg   %ax,%ax
801030ac:	66 90                	xchg   %ax,%ax
801030ae:	66 90                	xchg   %ax,%ax

801030b0 <main>:
{
801030b0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801030b4:	83 e4 f0             	and    $0xfffffff0,%esp
801030b7:	ff 71 fc             	push   -0x4(%ecx)
801030ba:	55                   	push   %ebp
801030bb:	89 e5                	mov    %esp,%ebp
801030bd:	53                   	push   %ebx
801030be:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030bf:	83 ec 08             	sub    $0x8,%esp
801030c2:	68 00 00 40 80       	push   $0x80400000
801030c7:	68 f0 57 11 80       	push   $0x801157f0
801030cc:	e8 8f f5 ff ff       	call   80102660 <kinit1>
  kvmalloc();      // kernel page table
801030d1:	e8 ca 3e 00 00       	call   80106fa0 <kvmalloc>
  mpinit();        // detect other processors
801030d6:	e8 85 01 00 00       	call   80103260 <mpinit>
  lapicinit();     // interrupt controller
801030db:	e8 60 f7 ff ff       	call   80102840 <lapicinit>
  seginit();       // segment descriptors
801030e0:	e8 3b 39 00 00       	call   80106a20 <seginit>
  picinit();       // disable pic
801030e5:	e8 76 03 00 00       	call   80103460 <picinit>
  ioapicinit();    // another interrupt controller
801030ea:	e8 31 f3 ff ff       	call   80102420 <ioapicinit>
  consoleinit();   // console hardware
801030ef:	e8 6c d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030f4:	e8 b7 2b 00 00       	call   80105cb0 <uartinit>
  pinit();         // process table
801030f9:	e8 22 08 00 00       	call   80103920 <pinit>
  tvinit();        // trap vectors
801030fe:	e8 3d 28 00 00       	call   80105940 <tvinit>
  binit();         // buffer cache
80103103:	e8 38 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103108:	e8 03 dd ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
8010310d:	e8 fe f0 ff ff       	call   80102210 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103112:	83 c4 0c             	add    $0xc,%esp
80103115:	68 8a 00 00 00       	push   $0x8a
8010311a:	68 8c a4 10 80       	push   $0x8010a48c
8010311f:	68 00 70 00 80       	push   $0x80007000
80103124:	e8 27 16 00 00       	call   80104750 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103129:	83 c4 10             	add    $0x10,%esp
8010312c:	69 05 a4 1a 11 80 b0 	imul   $0xb0,0x80111aa4,%eax
80103133:	00 00 00 
80103136:	05 c0 1a 11 80       	add    $0x80111ac0,%eax
8010313b:	3d c0 1a 11 80       	cmp    $0x80111ac0,%eax
80103140:	76 7e                	jbe    801031c0 <main+0x110>
80103142:	bb c0 1a 11 80       	mov    $0x80111ac0,%ebx
80103147:	eb 20                	jmp    80103169 <main+0xb9>
80103149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103150:	69 05 a4 1a 11 80 b0 	imul   $0xb0,0x80111aa4,%eax
80103157:	00 00 00 
8010315a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103160:	05 c0 1a 11 80       	add    $0x80111ac0,%eax
80103165:	39 c3                	cmp    %eax,%ebx
80103167:	73 57                	jae    801031c0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103169:	e8 d2 07 00 00       	call   80103940 <mycpu>
8010316e:	39 c3                	cmp    %eax,%ebx
80103170:	74 de                	je     80103150 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103172:	e8 59 f5 ff ff       	call   801026d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103177:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010317a:	c7 05 f8 6f 00 80 90 	movl   $0x80103090,0x80006ff8
80103181:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103184:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010318b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010318e:	05 00 10 00 00       	add    $0x1000,%eax
80103193:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103198:	0f b6 03             	movzbl (%ebx),%eax
8010319b:	68 00 70 00 00       	push   $0x7000
801031a0:	50                   	push   %eax
801031a1:	e8 ea f7 ff ff       	call   80102990 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801031a6:	83 c4 10             	add    $0x10,%esp
801031a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031b0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801031b6:	85 c0                	test   %eax,%eax
801031b8:	74 f6                	je     801031b0 <main+0x100>
801031ba:	eb 94                	jmp    80103150 <main+0xa0>
801031bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801031c0:	83 ec 08             	sub    $0x8,%esp
801031c3:	68 00 00 00 8e       	push   $0x8e000000
801031c8:	68 00 00 40 80       	push   $0x80400000
801031cd:	e8 2e f4 ff ff       	call   80102600 <kinit2>
  userinit();      // first user process
801031d2:	e8 19 08 00 00       	call   801039f0 <userinit>
  mpmain();        // finish this processor's setup
801031d7:	e8 74 fe ff ff       	call   80103050 <mpmain>
801031dc:	66 90                	xchg   %ax,%ax
801031de:	66 90                	xchg   %ax,%ax

801031e0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031e0:	55                   	push   %ebp
801031e1:	89 e5                	mov    %esp,%ebp
801031e3:	57                   	push   %edi
801031e4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031e5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031eb:	53                   	push   %ebx
  e = addr+len;
801031ec:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031ef:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031f2:	39 de                	cmp    %ebx,%esi
801031f4:	72 10                	jb     80103206 <mpsearch1+0x26>
801031f6:	eb 50                	jmp    80103248 <mpsearch1+0x68>
801031f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031ff:	90                   	nop
80103200:	89 fe                	mov    %edi,%esi
80103202:	39 fb                	cmp    %edi,%ebx
80103204:	76 42                	jbe    80103248 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103206:	83 ec 04             	sub    $0x4,%esp
80103209:	8d 7e 10             	lea    0x10(%esi),%edi
8010320c:	6a 04                	push   $0x4
8010320e:	68 78 77 10 80       	push   $0x80107778
80103213:	56                   	push   %esi
80103214:	e8 e7 14 00 00       	call   80104700 <memcmp>
80103219:	83 c4 10             	add    $0x10,%esp
8010321c:	85 c0                	test   %eax,%eax
8010321e:	75 e0                	jne    80103200 <mpsearch1+0x20>
80103220:	89 f2                	mov    %esi,%edx
80103222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103228:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010322b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010322e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103230:	39 fa                	cmp    %edi,%edx
80103232:	75 f4                	jne    80103228 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103234:	84 c0                	test   %al,%al
80103236:	75 c8                	jne    80103200 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103238:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010323b:	89 f0                	mov    %esi,%eax
8010323d:	5b                   	pop    %ebx
8010323e:	5e                   	pop    %esi
8010323f:	5f                   	pop    %edi
80103240:	5d                   	pop    %ebp
80103241:	c3                   	ret    
80103242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103248:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010324b:	31 f6                	xor    %esi,%esi
}
8010324d:	5b                   	pop    %ebx
8010324e:	89 f0                	mov    %esi,%eax
80103250:	5e                   	pop    %esi
80103251:	5f                   	pop    %edi
80103252:	5d                   	pop    %ebp
80103253:	c3                   	ret    
80103254:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010325b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010325f:	90                   	nop

80103260 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103260:	55                   	push   %ebp
80103261:	89 e5                	mov    %esp,%ebp
80103263:	57                   	push   %edi
80103264:	56                   	push   %esi
80103265:	53                   	push   %ebx
80103266:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103269:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103270:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103277:	c1 e0 08             	shl    $0x8,%eax
8010327a:	09 d0                	or     %edx,%eax
8010327c:	c1 e0 04             	shl    $0x4,%eax
8010327f:	75 1b                	jne    8010329c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103281:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103288:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010328f:	c1 e0 08             	shl    $0x8,%eax
80103292:	09 d0                	or     %edx,%eax
80103294:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103297:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010329c:	ba 00 04 00 00       	mov    $0x400,%edx
801032a1:	e8 3a ff ff ff       	call   801031e0 <mpsearch1>
801032a6:	89 c3                	mov    %eax,%ebx
801032a8:	85 c0                	test   %eax,%eax
801032aa:	0f 84 40 01 00 00    	je     801033f0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032b0:	8b 73 04             	mov    0x4(%ebx),%esi
801032b3:	85 f6                	test   %esi,%esi
801032b5:	0f 84 25 01 00 00    	je     801033e0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
801032bb:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032be:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801032c4:	6a 04                	push   $0x4
801032c6:	68 7d 77 10 80       	push   $0x8010777d
801032cb:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801032cf:	e8 2c 14 00 00       	call   80104700 <memcmp>
801032d4:	83 c4 10             	add    $0x10,%esp
801032d7:	85 c0                	test   %eax,%eax
801032d9:	0f 85 01 01 00 00    	jne    801033e0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
801032df:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801032e6:	3c 01                	cmp    $0x1,%al
801032e8:	74 08                	je     801032f2 <mpinit+0x92>
801032ea:	3c 04                	cmp    $0x4,%al
801032ec:	0f 85 ee 00 00 00    	jne    801033e0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801032f2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032f9:	66 85 d2             	test   %dx,%dx
801032fc:	74 22                	je     80103320 <mpinit+0xc0>
801032fe:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103301:	89 f0                	mov    %esi,%eax
  sum = 0;
80103303:	31 d2                	xor    %edx,%edx
80103305:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103308:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010330f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103312:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103314:	39 c7                	cmp    %eax,%edi
80103316:	75 f0                	jne    80103308 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103318:	84 d2                	test   %dl,%dl
8010331a:	0f 85 c0 00 00 00    	jne    801033e0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103320:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103326:	a3 a0 19 11 80       	mov    %eax,0x801119a0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010332b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103332:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103338:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010333d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103340:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103343:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103347:	90                   	nop
80103348:	39 d0                	cmp    %edx,%eax
8010334a:	73 15                	jae    80103361 <mpinit+0x101>
    switch(*p){
8010334c:	0f b6 08             	movzbl (%eax),%ecx
8010334f:	80 f9 02             	cmp    $0x2,%cl
80103352:	74 4c                	je     801033a0 <mpinit+0x140>
80103354:	77 3a                	ja     80103390 <mpinit+0x130>
80103356:	84 c9                	test   %cl,%cl
80103358:	74 56                	je     801033b0 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010335a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010335d:	39 d0                	cmp    %edx,%eax
8010335f:	72 eb                	jb     8010334c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103361:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103364:	85 f6                	test   %esi,%esi
80103366:	0f 84 d9 00 00 00    	je     80103445 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010336c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103370:	74 15                	je     80103387 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103372:	b8 70 00 00 00       	mov    $0x70,%eax
80103377:	ba 22 00 00 00       	mov    $0x22,%edx
8010337c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010337d:	ba 23 00 00 00       	mov    $0x23,%edx
80103382:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103383:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103386:	ee                   	out    %al,(%dx)
  }
}
80103387:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010338a:	5b                   	pop    %ebx
8010338b:	5e                   	pop    %esi
8010338c:	5f                   	pop    %edi
8010338d:	5d                   	pop    %ebp
8010338e:	c3                   	ret    
8010338f:	90                   	nop
    switch(*p){
80103390:	83 e9 03             	sub    $0x3,%ecx
80103393:	80 f9 01             	cmp    $0x1,%cl
80103396:	76 c2                	jbe    8010335a <mpinit+0xfa>
80103398:	31 f6                	xor    %esi,%esi
8010339a:	eb ac                	jmp    80103348 <mpinit+0xe8>
8010339c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801033a0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801033a4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801033a7:	88 0d a0 1a 11 80    	mov    %cl,0x80111aa0
      continue;
801033ad:	eb 99                	jmp    80103348 <mpinit+0xe8>
801033af:	90                   	nop
      if(ncpu < NCPU) {
801033b0:	8b 0d a4 1a 11 80    	mov    0x80111aa4,%ecx
801033b6:	83 f9 07             	cmp    $0x7,%ecx
801033b9:	7f 19                	jg     801033d4 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033bb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801033c1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801033c5:	83 c1 01             	add    $0x1,%ecx
801033c8:	89 0d a4 1a 11 80    	mov    %ecx,0x80111aa4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033ce:	88 9f c0 1a 11 80    	mov    %bl,-0x7feee540(%edi)
      p += sizeof(struct mpproc);
801033d4:	83 c0 14             	add    $0x14,%eax
      continue;
801033d7:	e9 6c ff ff ff       	jmp    80103348 <mpinit+0xe8>
801033dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033e0:	83 ec 0c             	sub    $0xc,%esp
801033e3:	68 82 77 10 80       	push   $0x80107782
801033e8:	e8 93 cf ff ff       	call   80100380 <panic>
801033ed:	8d 76 00             	lea    0x0(%esi),%esi
{
801033f0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033f5:	eb 13                	jmp    8010340a <mpinit+0x1aa>
801033f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033fe:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103400:	89 f3                	mov    %esi,%ebx
80103402:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103408:	74 d6                	je     801033e0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010340a:	83 ec 04             	sub    $0x4,%esp
8010340d:	8d 73 10             	lea    0x10(%ebx),%esi
80103410:	6a 04                	push   $0x4
80103412:	68 78 77 10 80       	push   $0x80107778
80103417:	53                   	push   %ebx
80103418:	e8 e3 12 00 00       	call   80104700 <memcmp>
8010341d:	83 c4 10             	add    $0x10,%esp
80103420:	85 c0                	test   %eax,%eax
80103422:	75 dc                	jne    80103400 <mpinit+0x1a0>
80103424:	89 da                	mov    %ebx,%edx
80103426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010342d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103430:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103433:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103436:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103438:	39 d6                	cmp    %edx,%esi
8010343a:	75 f4                	jne    80103430 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010343c:	84 c0                	test   %al,%al
8010343e:	75 c0                	jne    80103400 <mpinit+0x1a0>
80103440:	e9 6b fe ff ff       	jmp    801032b0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103445:	83 ec 0c             	sub    $0xc,%esp
80103448:	68 9c 77 10 80       	push   $0x8010779c
8010344d:	e8 2e cf ff ff       	call   80100380 <panic>
80103452:	66 90                	xchg   %ax,%ax
80103454:	66 90                	xchg   %ax,%ax
80103456:	66 90                	xchg   %ax,%ax
80103458:	66 90                	xchg   %ax,%ax
8010345a:	66 90                	xchg   %ax,%ax
8010345c:	66 90                	xchg   %ax,%ax
8010345e:	66 90                	xchg   %ax,%ax

80103460 <picinit>:
80103460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103465:	ba 21 00 00 00       	mov    $0x21,%edx
8010346a:	ee                   	out    %al,(%dx)
8010346b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103470:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103471:	c3                   	ret    
80103472:	66 90                	xchg   %ax,%ax
80103474:	66 90                	xchg   %ax,%ax
80103476:	66 90                	xchg   %ax,%ax
80103478:	66 90                	xchg   %ax,%ax
8010347a:	66 90                	xchg   %ax,%ax
8010347c:	66 90                	xchg   %ax,%ax
8010347e:	66 90                	xchg   %ax,%ax

80103480 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	57                   	push   %edi
80103484:	56                   	push   %esi
80103485:	53                   	push   %ebx
80103486:	83 ec 0c             	sub    $0xc,%esp
80103489:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010348c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010348f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103495:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010349b:	e8 90 d9 ff ff       	call   80100e30 <filealloc>
801034a0:	89 03                	mov    %eax,(%ebx)
801034a2:	85 c0                	test   %eax,%eax
801034a4:	0f 84 a8 00 00 00    	je     80103552 <pipealloc+0xd2>
801034aa:	e8 81 d9 ff ff       	call   80100e30 <filealloc>
801034af:	89 06                	mov    %eax,(%esi)
801034b1:	85 c0                	test   %eax,%eax
801034b3:	0f 84 87 00 00 00    	je     80103540 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801034b9:	e8 12 f2 ff ff       	call   801026d0 <kalloc>
801034be:	89 c7                	mov    %eax,%edi
801034c0:	85 c0                	test   %eax,%eax
801034c2:	0f 84 b0 00 00 00    	je     80103578 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
801034c8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801034cf:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801034d2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801034d5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034dc:	00 00 00 
  p->nwrite = 0;
801034df:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034e6:	00 00 00 
  p->nread = 0;
801034e9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034f0:	00 00 00 
  initlock(&p->lock, "pipe");
801034f3:	68 bb 77 10 80       	push   $0x801077bb
801034f8:	50                   	push   %eax
801034f9:	e8 22 0f 00 00       	call   80104420 <initlock>
  (*f0)->type = FD_PIPE;
801034fe:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103500:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103503:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103509:	8b 03                	mov    (%ebx),%eax
8010350b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010350f:	8b 03                	mov    (%ebx),%eax
80103511:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103515:	8b 03                	mov    (%ebx),%eax
80103517:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010351a:	8b 06                	mov    (%esi),%eax
8010351c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103522:	8b 06                	mov    (%esi),%eax
80103524:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103528:	8b 06                	mov    (%esi),%eax
8010352a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010352e:	8b 06                	mov    (%esi),%eax
80103530:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103533:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103536:	31 c0                	xor    %eax,%eax
}
80103538:	5b                   	pop    %ebx
80103539:	5e                   	pop    %esi
8010353a:	5f                   	pop    %edi
8010353b:	5d                   	pop    %ebp
8010353c:	c3                   	ret    
8010353d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103540:	8b 03                	mov    (%ebx),%eax
80103542:	85 c0                	test   %eax,%eax
80103544:	74 1e                	je     80103564 <pipealloc+0xe4>
    fileclose(*f0);
80103546:	83 ec 0c             	sub    $0xc,%esp
80103549:	50                   	push   %eax
8010354a:	e8 a1 d9 ff ff       	call   80100ef0 <fileclose>
8010354f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103552:	8b 06                	mov    (%esi),%eax
80103554:	85 c0                	test   %eax,%eax
80103556:	74 0c                	je     80103564 <pipealloc+0xe4>
    fileclose(*f1);
80103558:	83 ec 0c             	sub    $0xc,%esp
8010355b:	50                   	push   %eax
8010355c:	e8 8f d9 ff ff       	call   80100ef0 <fileclose>
80103561:	83 c4 10             	add    $0x10,%esp
}
80103564:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103567:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010356c:	5b                   	pop    %ebx
8010356d:	5e                   	pop    %esi
8010356e:	5f                   	pop    %edi
8010356f:	5d                   	pop    %ebp
80103570:	c3                   	ret    
80103571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103578:	8b 03                	mov    (%ebx),%eax
8010357a:	85 c0                	test   %eax,%eax
8010357c:	75 c8                	jne    80103546 <pipealloc+0xc6>
8010357e:	eb d2                	jmp    80103552 <pipealloc+0xd2>

80103580 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103580:	55                   	push   %ebp
80103581:	89 e5                	mov    %esp,%ebp
80103583:	56                   	push   %esi
80103584:	53                   	push   %ebx
80103585:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103588:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010358b:	83 ec 0c             	sub    $0xc,%esp
8010358e:	53                   	push   %ebx
8010358f:	e8 5c 10 00 00       	call   801045f0 <acquire>
  if(writable){
80103594:	83 c4 10             	add    $0x10,%esp
80103597:	85 f6                	test   %esi,%esi
80103599:	74 65                	je     80103600 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010359b:	83 ec 0c             	sub    $0xc,%esp
8010359e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801035a4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801035ab:	00 00 00 
    wakeup(&p->nread);
801035ae:	50                   	push   %eax
801035af:	e8 9c 0b 00 00       	call   80104150 <wakeup>
801035b4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801035b7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801035bd:	85 d2                	test   %edx,%edx
801035bf:	75 0a                	jne    801035cb <pipeclose+0x4b>
801035c1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801035c7:	85 c0                	test   %eax,%eax
801035c9:	74 15                	je     801035e0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035cb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035d1:	5b                   	pop    %ebx
801035d2:	5e                   	pop    %esi
801035d3:	5d                   	pop    %ebp
    release(&p->lock);
801035d4:	e9 b7 0f 00 00       	jmp    80104590 <release>
801035d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801035e0:	83 ec 0c             	sub    $0xc,%esp
801035e3:	53                   	push   %ebx
801035e4:	e8 a7 0f 00 00       	call   80104590 <release>
    kfree((char*)p);
801035e9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035ec:	83 c4 10             	add    $0x10,%esp
}
801035ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035f2:	5b                   	pop    %ebx
801035f3:	5e                   	pop    %esi
801035f4:	5d                   	pop    %ebp
    kfree((char*)p);
801035f5:	e9 16 ef ff ff       	jmp    80102510 <kfree>
801035fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103600:	83 ec 0c             	sub    $0xc,%esp
80103603:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103609:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103610:	00 00 00 
    wakeup(&p->nwrite);
80103613:	50                   	push   %eax
80103614:	e8 37 0b 00 00       	call   80104150 <wakeup>
80103619:	83 c4 10             	add    $0x10,%esp
8010361c:	eb 99                	jmp    801035b7 <pipeclose+0x37>
8010361e:	66 90                	xchg   %ax,%ax

80103620 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103620:	55                   	push   %ebp
80103621:	89 e5                	mov    %esp,%ebp
80103623:	57                   	push   %edi
80103624:	56                   	push   %esi
80103625:	53                   	push   %ebx
80103626:	83 ec 28             	sub    $0x28,%esp
80103629:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010362c:	53                   	push   %ebx
8010362d:	e8 be 0f 00 00       	call   801045f0 <acquire>
  for(i = 0; i < n; i++){
80103632:	8b 45 10             	mov    0x10(%ebp),%eax
80103635:	83 c4 10             	add    $0x10,%esp
80103638:	85 c0                	test   %eax,%eax
8010363a:	0f 8e c0 00 00 00    	jle    80103700 <pipewrite+0xe0>
80103640:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103643:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103649:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010364f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103652:	03 45 10             	add    0x10(%ebp),%eax
80103655:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103658:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010365e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103664:	89 ca                	mov    %ecx,%edx
80103666:	05 00 02 00 00       	add    $0x200,%eax
8010366b:	39 c1                	cmp    %eax,%ecx
8010366d:	74 3f                	je     801036ae <pipewrite+0x8e>
8010366f:	eb 67                	jmp    801036d8 <pipewrite+0xb8>
80103671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103678:	e8 43 03 00 00       	call   801039c0 <myproc>
8010367d:	8b 48 24             	mov    0x24(%eax),%ecx
80103680:	85 c9                	test   %ecx,%ecx
80103682:	75 34                	jne    801036b8 <pipewrite+0x98>
      wakeup(&p->nread);
80103684:	83 ec 0c             	sub    $0xc,%esp
80103687:	57                   	push   %edi
80103688:	e8 c3 0a 00 00       	call   80104150 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010368d:	58                   	pop    %eax
8010368e:	5a                   	pop    %edx
8010368f:	53                   	push   %ebx
80103690:	56                   	push   %esi
80103691:	e8 fa 09 00 00       	call   80104090 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103696:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010369c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801036a2:	83 c4 10             	add    $0x10,%esp
801036a5:	05 00 02 00 00       	add    $0x200,%eax
801036aa:	39 c2                	cmp    %eax,%edx
801036ac:	75 2a                	jne    801036d8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
801036ae:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801036b4:	85 c0                	test   %eax,%eax
801036b6:	75 c0                	jne    80103678 <pipewrite+0x58>
        release(&p->lock);
801036b8:	83 ec 0c             	sub    $0xc,%esp
801036bb:	53                   	push   %ebx
801036bc:	e8 cf 0e 00 00       	call   80104590 <release>
        return -1;
801036c1:	83 c4 10             	add    $0x10,%esp
801036c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801036c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036cc:	5b                   	pop    %ebx
801036cd:	5e                   	pop    %esi
801036ce:	5f                   	pop    %edi
801036cf:	5d                   	pop    %ebp
801036d0:	c3                   	ret    
801036d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036d8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801036db:	8d 4a 01             	lea    0x1(%edx),%ecx
801036de:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036e4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801036ea:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801036ed:	83 c6 01             	add    $0x1,%esi
801036f0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036f3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036f7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036fa:	0f 85 58 ff ff ff    	jne    80103658 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103700:	83 ec 0c             	sub    $0xc,%esp
80103703:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103709:	50                   	push   %eax
8010370a:	e8 41 0a 00 00       	call   80104150 <wakeup>
  release(&p->lock);
8010370f:	89 1c 24             	mov    %ebx,(%esp)
80103712:	e8 79 0e 00 00       	call   80104590 <release>
  return n;
80103717:	8b 45 10             	mov    0x10(%ebp),%eax
8010371a:	83 c4 10             	add    $0x10,%esp
8010371d:	eb aa                	jmp    801036c9 <pipewrite+0xa9>
8010371f:	90                   	nop

80103720 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	57                   	push   %edi
80103724:	56                   	push   %esi
80103725:	53                   	push   %ebx
80103726:	83 ec 18             	sub    $0x18,%esp
80103729:	8b 75 08             	mov    0x8(%ebp),%esi
8010372c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010372f:	56                   	push   %esi
80103730:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103736:	e8 b5 0e 00 00       	call   801045f0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010373b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103741:	83 c4 10             	add    $0x10,%esp
80103744:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010374a:	74 2f                	je     8010377b <piperead+0x5b>
8010374c:	eb 37                	jmp    80103785 <piperead+0x65>
8010374e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103750:	e8 6b 02 00 00       	call   801039c0 <myproc>
80103755:	8b 48 24             	mov    0x24(%eax),%ecx
80103758:	85 c9                	test   %ecx,%ecx
8010375a:	0f 85 80 00 00 00    	jne    801037e0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103760:	83 ec 08             	sub    $0x8,%esp
80103763:	56                   	push   %esi
80103764:	53                   	push   %ebx
80103765:	e8 26 09 00 00       	call   80104090 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010376a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103770:	83 c4 10             	add    $0x10,%esp
80103773:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103779:	75 0a                	jne    80103785 <piperead+0x65>
8010377b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103781:	85 c0                	test   %eax,%eax
80103783:	75 cb                	jne    80103750 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103785:	8b 55 10             	mov    0x10(%ebp),%edx
80103788:	31 db                	xor    %ebx,%ebx
8010378a:	85 d2                	test   %edx,%edx
8010378c:	7f 20                	jg     801037ae <piperead+0x8e>
8010378e:	eb 2c                	jmp    801037bc <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103790:	8d 48 01             	lea    0x1(%eax),%ecx
80103793:	25 ff 01 00 00       	and    $0x1ff,%eax
80103798:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010379e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801037a3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037a6:	83 c3 01             	add    $0x1,%ebx
801037a9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801037ac:	74 0e                	je     801037bc <piperead+0x9c>
    if(p->nread == p->nwrite)
801037ae:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801037b4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801037ba:	75 d4                	jne    80103790 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801037bc:	83 ec 0c             	sub    $0xc,%esp
801037bf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037c5:	50                   	push   %eax
801037c6:	e8 85 09 00 00       	call   80104150 <wakeup>
  release(&p->lock);
801037cb:	89 34 24             	mov    %esi,(%esp)
801037ce:	e8 bd 0d 00 00       	call   80104590 <release>
  return i;
801037d3:	83 c4 10             	add    $0x10,%esp
}
801037d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037d9:	89 d8                	mov    %ebx,%eax
801037db:	5b                   	pop    %ebx
801037dc:	5e                   	pop    %esi
801037dd:	5f                   	pop    %edi
801037de:	5d                   	pop    %ebp
801037df:	c3                   	ret    
      release(&p->lock);
801037e0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037e3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037e8:	56                   	push   %esi
801037e9:	e8 a2 0d 00 00       	call   80104590 <release>
      return -1;
801037ee:	83 c4 10             	add    $0x10,%esp
}
801037f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037f4:	89 d8                	mov    %ebx,%eax
801037f6:	5b                   	pop    %ebx
801037f7:	5e                   	pop    %esi
801037f8:	5f                   	pop    %edi
801037f9:	5d                   	pop    %ebp
801037fa:	c3                   	ret    
801037fb:	66 90                	xchg   %ax,%ax
801037fd:	66 90                	xchg   %ax,%ax
801037ff:	90                   	nop

80103800 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103804:	bb 74 20 11 80       	mov    $0x80112074,%ebx
{
80103809:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010380c:	68 40 20 11 80       	push   $0x80112040
80103811:	e8 da 0d 00 00       	call   801045f0 <acquire>
80103816:	83 c4 10             	add    $0x10,%esp
80103819:	eb 10                	jmp    8010382b <allocproc+0x2b>
8010381b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010381f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103820:	83 c3 7c             	add    $0x7c,%ebx
80103823:	81 fb 74 3f 11 80    	cmp    $0x80113f74,%ebx
80103829:	74 75                	je     801038a0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010382b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010382e:	85 c0                	test   %eax,%eax
80103830:	75 ee                	jne    80103820 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103832:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103837:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010383a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103841:	89 43 10             	mov    %eax,0x10(%ebx)
80103844:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103847:	68 40 20 11 80       	push   $0x80112040
  p->pid = nextpid++;
8010384c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103852:	e8 39 0d 00 00       	call   80104590 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103857:	e8 74 ee ff ff       	call   801026d0 <kalloc>
8010385c:	83 c4 10             	add    $0x10,%esp
8010385f:	89 43 08             	mov    %eax,0x8(%ebx)
80103862:	85 c0                	test   %eax,%eax
80103864:	74 53                	je     801038b9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103866:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010386c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010386f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103874:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103877:	c7 40 14 32 59 10 80 	movl   $0x80105932,0x14(%eax)
  p->context = (struct context*)sp;
8010387e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103881:	6a 14                	push   $0x14
80103883:	6a 00                	push   $0x0
80103885:	50                   	push   %eax
80103886:	e8 25 0e 00 00       	call   801046b0 <memset>
  p->context->eip = (uint)forkret;
8010388b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010388e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103891:	c7 40 10 d0 38 10 80 	movl   $0x801038d0,0x10(%eax)
}
80103898:	89 d8                	mov    %ebx,%eax
8010389a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010389d:	c9                   	leave  
8010389e:	c3                   	ret    
8010389f:	90                   	nop
  release(&ptable.lock);
801038a0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801038a3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801038a5:	68 40 20 11 80       	push   $0x80112040
801038aa:	e8 e1 0c 00 00       	call   80104590 <release>
}
801038af:	89 d8                	mov    %ebx,%eax
  return 0;
801038b1:	83 c4 10             	add    $0x10,%esp
}
801038b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038b7:	c9                   	leave  
801038b8:	c3                   	ret    
    p->state = UNUSED;
801038b9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038c0:	31 db                	xor    %ebx,%ebx
}
801038c2:	89 d8                	mov    %ebx,%eax
801038c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038c7:	c9                   	leave  
801038c8:	c3                   	ret    
801038c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038d0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038d6:	68 40 20 11 80       	push   $0x80112040
801038db:	e8 b0 0c 00 00       	call   80104590 <release>

  if (first) {
801038e0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801038e5:	83 c4 10             	add    $0x10,%esp
801038e8:	85 c0                	test   %eax,%eax
801038ea:	75 04                	jne    801038f0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038ec:	c9                   	leave  
801038ed:	c3                   	ret    
801038ee:	66 90                	xchg   %ax,%ax
    first = 0;
801038f0:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801038f7:	00 00 00 
    iinit(ROOTDEV);
801038fa:	83 ec 0c             	sub    $0xc,%esp
801038fd:	6a 01                	push   $0x1
801038ff:	e8 ac dc ff ff       	call   801015b0 <iinit>
    initlog(ROOTDEV);
80103904:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010390b:	e8 00 f4 ff ff       	call   80102d10 <initlog>
}
80103910:	83 c4 10             	add    $0x10,%esp
80103913:	c9                   	leave  
80103914:	c3                   	ret    
80103915:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010391c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103920 <pinit>:
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103926:	68 c0 77 10 80       	push   $0x801077c0
8010392b:	68 40 20 11 80       	push   $0x80112040
80103930:	e8 eb 0a 00 00       	call   80104420 <initlock>
}
80103935:	83 c4 10             	add    $0x10,%esp
80103938:	c9                   	leave  
80103939:	c3                   	ret    
8010393a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103940 <mycpu>:
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	56                   	push   %esi
80103944:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103945:	9c                   	pushf  
80103946:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103947:	f6 c4 02             	test   $0x2,%ah
8010394a:	75 46                	jne    80103992 <mycpu+0x52>
  apicid = lapicid();
8010394c:	e8 ef ef ff ff       	call   80102940 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103951:	8b 35 a4 1a 11 80    	mov    0x80111aa4,%esi
80103957:	85 f6                	test   %esi,%esi
80103959:	7e 2a                	jle    80103985 <mycpu+0x45>
8010395b:	31 d2                	xor    %edx,%edx
8010395d:	eb 08                	jmp    80103967 <mycpu+0x27>
8010395f:	90                   	nop
80103960:	83 c2 01             	add    $0x1,%edx
80103963:	39 f2                	cmp    %esi,%edx
80103965:	74 1e                	je     80103985 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103967:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010396d:	0f b6 99 c0 1a 11 80 	movzbl -0x7feee540(%ecx),%ebx
80103974:	39 c3                	cmp    %eax,%ebx
80103976:	75 e8                	jne    80103960 <mycpu+0x20>
}
80103978:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010397b:	8d 81 c0 1a 11 80    	lea    -0x7feee540(%ecx),%eax
}
80103981:	5b                   	pop    %ebx
80103982:	5e                   	pop    %esi
80103983:	5d                   	pop    %ebp
80103984:	c3                   	ret    
  panic("unknown apicid\n");
80103985:	83 ec 0c             	sub    $0xc,%esp
80103988:	68 c7 77 10 80       	push   $0x801077c7
8010398d:	e8 ee c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103992:	83 ec 0c             	sub    $0xc,%esp
80103995:	68 a4 78 10 80       	push   $0x801078a4
8010399a:	e8 e1 c9 ff ff       	call   80100380 <panic>
8010399f:	90                   	nop

801039a0 <cpuid>:
cpuid() {
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801039a6:	e8 95 ff ff ff       	call   80103940 <mycpu>
}
801039ab:	c9                   	leave  
  return mycpu()-cpus;
801039ac:	2d c0 1a 11 80       	sub    $0x80111ac0,%eax
801039b1:	c1 f8 04             	sar    $0x4,%eax
801039b4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039ba:	c3                   	ret    
801039bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039bf:	90                   	nop

801039c0 <myproc>:
myproc(void) {
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	53                   	push   %ebx
801039c4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801039c7:	e8 d4 0a 00 00       	call   801044a0 <pushcli>
  c = mycpu();
801039cc:	e8 6f ff ff ff       	call   80103940 <mycpu>
  p = c->proc;
801039d1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039d7:	e8 14 0b 00 00       	call   801044f0 <popcli>
}
801039dc:	89 d8                	mov    %ebx,%eax
801039de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039e1:	c9                   	leave  
801039e2:	c3                   	ret    
801039e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039f0 <userinit>:
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	53                   	push   %ebx
801039f4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039f7:	e8 04 fe ff ff       	call   80103800 <allocproc>
801039fc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039fe:	a3 74 3f 11 80       	mov    %eax,0x80113f74
  if((p->pgdir = setupkvm()) == 0)
80103a03:	e8 18 35 00 00       	call   80106f20 <setupkvm>
80103a08:	89 43 04             	mov    %eax,0x4(%ebx)
80103a0b:	85 c0                	test   %eax,%eax
80103a0d:	0f 84 bd 00 00 00    	je     80103ad0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a13:	83 ec 04             	sub    $0x4,%esp
80103a16:	68 2c 00 00 00       	push   $0x2c
80103a1b:	68 60 a4 10 80       	push   $0x8010a460
80103a20:	50                   	push   %eax
80103a21:	e8 aa 31 00 00       	call   80106bd0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a26:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a29:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a2f:	6a 4c                	push   $0x4c
80103a31:	6a 00                	push   $0x0
80103a33:	ff 73 18             	push   0x18(%ebx)
80103a36:	e8 75 0c 00 00       	call   801046b0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a3b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a3e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a43:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a46:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a4b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a4f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a52:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a56:	8b 43 18             	mov    0x18(%ebx),%eax
80103a59:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a5d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a61:	8b 43 18             	mov    0x18(%ebx),%eax
80103a64:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a68:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a6c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a6f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a76:	8b 43 18             	mov    0x18(%ebx),%eax
80103a79:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a80:	8b 43 18             	mov    0x18(%ebx),%eax
80103a83:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a8a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a8d:	6a 10                	push   $0x10
80103a8f:	68 f0 77 10 80       	push   $0x801077f0
80103a94:	50                   	push   %eax
80103a95:	e8 d6 0d 00 00       	call   80104870 <safestrcpy>
  p->cwd = namei("/");
80103a9a:	c7 04 24 f9 77 10 80 	movl   $0x801077f9,(%esp)
80103aa1:	e8 4a e6 ff ff       	call   801020f0 <namei>
80103aa6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103aa9:	c7 04 24 40 20 11 80 	movl   $0x80112040,(%esp)
80103ab0:	e8 3b 0b 00 00       	call   801045f0 <acquire>
  p->state = RUNNABLE;
80103ab5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103abc:	c7 04 24 40 20 11 80 	movl   $0x80112040,(%esp)
80103ac3:	e8 c8 0a 00 00       	call   80104590 <release>
}
80103ac8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103acb:	83 c4 10             	add    $0x10,%esp
80103ace:	c9                   	leave  
80103acf:	c3                   	ret    
    panic("userinit: out of memory?");
80103ad0:	83 ec 0c             	sub    $0xc,%esp
80103ad3:	68 d7 77 10 80       	push   $0x801077d7
80103ad8:	e8 a3 c8 ff ff       	call   80100380 <panic>
80103add:	8d 76 00             	lea    0x0(%esi),%esi

80103ae0 <growproc>:
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	56                   	push   %esi
80103ae4:	53                   	push   %ebx
80103ae5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ae8:	e8 b3 09 00 00       	call   801044a0 <pushcli>
  c = mycpu();
80103aed:	e8 4e fe ff ff       	call   80103940 <mycpu>
  p = c->proc;
80103af2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103af8:	e8 f3 09 00 00       	call   801044f0 <popcli>
  sz = curproc->sz;
80103afd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103aff:	85 f6                	test   %esi,%esi
80103b01:	7f 1d                	jg     80103b20 <growproc+0x40>
  } else if(n < 0){
80103b03:	75 3b                	jne    80103b40 <growproc+0x60>
  switchuvm(curproc);
80103b05:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b08:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b0a:	53                   	push   %ebx
80103b0b:	e8 b0 2f 00 00       	call   80106ac0 <switchuvm>
  return 0;
80103b10:	83 c4 10             	add    $0x10,%esp
80103b13:	31 c0                	xor    %eax,%eax
}
80103b15:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b18:	5b                   	pop    %ebx
80103b19:	5e                   	pop    %esi
80103b1a:	5d                   	pop    %ebp
80103b1b:	c3                   	ret    
80103b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b20:	83 ec 04             	sub    $0x4,%esp
80103b23:	01 c6                	add    %eax,%esi
80103b25:	56                   	push   %esi
80103b26:	50                   	push   %eax
80103b27:	ff 73 04             	push   0x4(%ebx)
80103b2a:	e8 11 32 00 00       	call   80106d40 <allocuvm>
80103b2f:	83 c4 10             	add    $0x10,%esp
80103b32:	85 c0                	test   %eax,%eax
80103b34:	75 cf                	jne    80103b05 <growproc+0x25>
      return -1;
80103b36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b3b:	eb d8                	jmp    80103b15 <growproc+0x35>
80103b3d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b40:	83 ec 04             	sub    $0x4,%esp
80103b43:	01 c6                	add    %eax,%esi
80103b45:	56                   	push   %esi
80103b46:	50                   	push   %eax
80103b47:	ff 73 04             	push   0x4(%ebx)
80103b4a:	e8 21 33 00 00       	call   80106e70 <deallocuvm>
80103b4f:	83 c4 10             	add    $0x10,%esp
80103b52:	85 c0                	test   %eax,%eax
80103b54:	75 af                	jne    80103b05 <growproc+0x25>
80103b56:	eb de                	jmp    80103b36 <growproc+0x56>
80103b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b5f:	90                   	nop

80103b60 <fork>:
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	57                   	push   %edi
80103b64:	56                   	push   %esi
80103b65:	53                   	push   %ebx
80103b66:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b69:	e8 32 09 00 00       	call   801044a0 <pushcli>
  c = mycpu();
80103b6e:	e8 cd fd ff ff       	call   80103940 <mycpu>
  p = c->proc;
80103b73:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b79:	e8 72 09 00 00       	call   801044f0 <popcli>
  if((np = allocproc()) == 0){
80103b7e:	e8 7d fc ff ff       	call   80103800 <allocproc>
80103b83:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b86:	85 c0                	test   %eax,%eax
80103b88:	0f 84 b7 00 00 00    	je     80103c45 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b8e:	83 ec 08             	sub    $0x8,%esp
80103b91:	ff 33                	push   (%ebx)
80103b93:	89 c7                	mov    %eax,%edi
80103b95:	ff 73 04             	push   0x4(%ebx)
80103b98:	e8 73 34 00 00       	call   80107010 <copyuvm>
80103b9d:	83 c4 10             	add    $0x10,%esp
80103ba0:	89 47 04             	mov    %eax,0x4(%edi)
80103ba3:	85 c0                	test   %eax,%eax
80103ba5:	0f 84 a1 00 00 00    	je     80103c4c <fork+0xec>
  np->sz = curproc->sz;
80103bab:	8b 03                	mov    (%ebx),%eax
80103bad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103bb0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103bb2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103bb5:	89 c8                	mov    %ecx,%eax
80103bb7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103bba:	b9 13 00 00 00       	mov    $0x13,%ecx
80103bbf:	8b 73 18             	mov    0x18(%ebx),%esi
80103bc2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103bc4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103bc6:	8b 40 18             	mov    0x18(%eax),%eax
80103bc9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103bd0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103bd4:	85 c0                	test   %eax,%eax
80103bd6:	74 13                	je     80103beb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103bd8:	83 ec 0c             	sub    $0xc,%esp
80103bdb:	50                   	push   %eax
80103bdc:	e8 bf d2 ff ff       	call   80100ea0 <filedup>
80103be1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103be4:	83 c4 10             	add    $0x10,%esp
80103be7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103beb:	83 c6 01             	add    $0x1,%esi
80103bee:	83 fe 10             	cmp    $0x10,%esi
80103bf1:	75 dd                	jne    80103bd0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103bf3:	83 ec 0c             	sub    $0xc,%esp
80103bf6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bf9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bfc:	e8 9f db ff ff       	call   801017a0 <idup>
80103c01:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c04:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c07:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c0a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c0d:	6a 10                	push   $0x10
80103c0f:	53                   	push   %ebx
80103c10:	50                   	push   %eax
80103c11:	e8 5a 0c 00 00       	call   80104870 <safestrcpy>
  pid = np->pid;
80103c16:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c19:	c7 04 24 40 20 11 80 	movl   $0x80112040,(%esp)
80103c20:	e8 cb 09 00 00       	call   801045f0 <acquire>
  np->state = RUNNABLE;
80103c25:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c2c:	c7 04 24 40 20 11 80 	movl   $0x80112040,(%esp)
80103c33:	e8 58 09 00 00       	call   80104590 <release>
  return pid;
80103c38:	83 c4 10             	add    $0x10,%esp
}
80103c3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c3e:	89 d8                	mov    %ebx,%eax
80103c40:	5b                   	pop    %ebx
80103c41:	5e                   	pop    %esi
80103c42:	5f                   	pop    %edi
80103c43:	5d                   	pop    %ebp
80103c44:	c3                   	ret    
    return -1;
80103c45:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c4a:	eb ef                	jmp    80103c3b <fork+0xdb>
    kfree(np->kstack);
80103c4c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c4f:	83 ec 0c             	sub    $0xc,%esp
80103c52:	ff 73 08             	push   0x8(%ebx)
80103c55:	e8 b6 e8 ff ff       	call   80102510 <kfree>
    np->kstack = 0;
80103c5a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c61:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c64:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c6b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c70:	eb c9                	jmp    80103c3b <fork+0xdb>
80103c72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c80 <scheduler>:
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	57                   	push   %edi
80103c84:	56                   	push   %esi
80103c85:	53                   	push   %ebx
80103c86:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c89:	e8 b2 fc ff ff       	call   80103940 <mycpu>
  c->proc = 0;
80103c8e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c95:	00 00 00 
  struct cpu *c = mycpu();
80103c98:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c9a:	8d 78 04             	lea    0x4(%eax),%edi
80103c9d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103ca0:	fb                   	sti    
    acquire(&ptable.lock);
80103ca1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ca4:	bb 74 20 11 80       	mov    $0x80112074,%ebx
    acquire(&ptable.lock);
80103ca9:	68 40 20 11 80       	push   $0x80112040
80103cae:	e8 3d 09 00 00       	call   801045f0 <acquire>
80103cb3:	83 c4 10             	add    $0x10,%esp
80103cb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cbd:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103cc0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103cc4:	75 33                	jne    80103cf9 <scheduler+0x79>
      switchuvm(p);
80103cc6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103cc9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103ccf:	53                   	push   %ebx
80103cd0:	e8 eb 2d 00 00       	call   80106ac0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103cd5:	58                   	pop    %eax
80103cd6:	5a                   	pop    %edx
80103cd7:	ff 73 1c             	push   0x1c(%ebx)
80103cda:	57                   	push   %edi
      p->state = RUNNING;
80103cdb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103ce2:	e8 e4 0b 00 00       	call   801048cb <swtch>
      switchkvm();
80103ce7:	e8 c4 2d 00 00       	call   80106ab0 <switchkvm>
      c->proc = 0;
80103cec:	83 c4 10             	add    $0x10,%esp
80103cef:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103cf6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cf9:	83 c3 7c             	add    $0x7c,%ebx
80103cfc:	81 fb 74 3f 11 80    	cmp    $0x80113f74,%ebx
80103d02:	75 bc                	jne    80103cc0 <scheduler+0x40>
    release(&ptable.lock);
80103d04:	83 ec 0c             	sub    $0xc,%esp
80103d07:	68 40 20 11 80       	push   $0x80112040
80103d0c:	e8 7f 08 00 00       	call   80104590 <release>
    sti();
80103d11:	83 c4 10             	add    $0x10,%esp
80103d14:	eb 8a                	jmp    80103ca0 <scheduler+0x20>
80103d16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d1d:	8d 76 00             	lea    0x0(%esi),%esi

80103d20 <sched>:
{
80103d20:	55                   	push   %ebp
80103d21:	89 e5                	mov    %esp,%ebp
80103d23:	56                   	push   %esi
80103d24:	53                   	push   %ebx
  pushcli();
80103d25:	e8 76 07 00 00       	call   801044a0 <pushcli>
  c = mycpu();
80103d2a:	e8 11 fc ff ff       	call   80103940 <mycpu>
  p = c->proc;
80103d2f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d35:	e8 b6 07 00 00       	call   801044f0 <popcli>
  if(!holding(&ptable.lock))
80103d3a:	83 ec 0c             	sub    $0xc,%esp
80103d3d:	68 40 20 11 80       	push   $0x80112040
80103d42:	e8 09 08 00 00       	call   80104550 <holding>
80103d47:	83 c4 10             	add    $0x10,%esp
80103d4a:	85 c0                	test   %eax,%eax
80103d4c:	74 4f                	je     80103d9d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103d4e:	e8 ed fb ff ff       	call   80103940 <mycpu>
80103d53:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d5a:	75 68                	jne    80103dc4 <sched+0xa4>
  if(p->state == RUNNING)
80103d5c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d60:	74 55                	je     80103db7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d62:	9c                   	pushf  
80103d63:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d64:	f6 c4 02             	test   $0x2,%ah
80103d67:	75 41                	jne    80103daa <sched+0x8a>
  intena = mycpu()->intena;
80103d69:	e8 d2 fb ff ff       	call   80103940 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d6e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d71:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d77:	e8 c4 fb ff ff       	call   80103940 <mycpu>
80103d7c:	83 ec 08             	sub    $0x8,%esp
80103d7f:	ff 70 04             	push   0x4(%eax)
80103d82:	53                   	push   %ebx
80103d83:	e8 43 0b 00 00       	call   801048cb <swtch>
  mycpu()->intena = intena;
80103d88:	e8 b3 fb ff ff       	call   80103940 <mycpu>
}
80103d8d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d90:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d96:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d99:	5b                   	pop    %ebx
80103d9a:	5e                   	pop    %esi
80103d9b:	5d                   	pop    %ebp
80103d9c:	c3                   	ret    
    panic("sched ptable.lock");
80103d9d:	83 ec 0c             	sub    $0xc,%esp
80103da0:	68 fb 77 10 80       	push   $0x801077fb
80103da5:	e8 d6 c5 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103daa:	83 ec 0c             	sub    $0xc,%esp
80103dad:	68 27 78 10 80       	push   $0x80107827
80103db2:	e8 c9 c5 ff ff       	call   80100380 <panic>
    panic("sched running");
80103db7:	83 ec 0c             	sub    $0xc,%esp
80103dba:	68 19 78 10 80       	push   $0x80107819
80103dbf:	e8 bc c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103dc4:	83 ec 0c             	sub    $0xc,%esp
80103dc7:	68 0d 78 10 80       	push   $0x8010780d
80103dcc:	e8 af c5 ff ff       	call   80100380 <panic>
80103dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ddf:	90                   	nop

80103de0 <exit>:
{
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	57                   	push   %edi
80103de4:	56                   	push   %esi
80103de5:	53                   	push   %ebx
80103de6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103de9:	e8 d2 fb ff ff       	call   801039c0 <myproc>
  if(curproc == initproc)
80103dee:	39 05 74 3f 11 80    	cmp    %eax,0x80113f74
80103df4:	0f 84 fd 00 00 00    	je     80103ef7 <exit+0x117>
80103dfa:	89 c3                	mov    %eax,%ebx
80103dfc:	8d 70 28             	lea    0x28(%eax),%esi
80103dff:	8d 78 68             	lea    0x68(%eax),%edi
80103e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103e08:	8b 06                	mov    (%esi),%eax
80103e0a:	85 c0                	test   %eax,%eax
80103e0c:	74 12                	je     80103e20 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103e0e:	83 ec 0c             	sub    $0xc,%esp
80103e11:	50                   	push   %eax
80103e12:	e8 d9 d0 ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80103e17:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103e1d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103e20:	83 c6 04             	add    $0x4,%esi
80103e23:	39 f7                	cmp    %esi,%edi
80103e25:	75 e1                	jne    80103e08 <exit+0x28>
  begin_op();
80103e27:	e8 84 ef ff ff       	call   80102db0 <begin_op>
  iput(curproc->cwd);
80103e2c:	83 ec 0c             	sub    $0xc,%esp
80103e2f:	ff 73 68             	push   0x68(%ebx)
80103e32:	e8 c9 da ff ff       	call   80101900 <iput>
  end_op();
80103e37:	e8 e4 ef ff ff       	call   80102e20 <end_op>
  curproc->cwd = 0;
80103e3c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103e43:	c7 04 24 40 20 11 80 	movl   $0x80112040,(%esp)
80103e4a:	e8 a1 07 00 00       	call   801045f0 <acquire>
  wakeup1(curproc->parent);
80103e4f:	8b 53 14             	mov    0x14(%ebx),%edx
80103e52:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e55:	b8 74 20 11 80       	mov    $0x80112074,%eax
80103e5a:	eb 0e                	jmp    80103e6a <exit+0x8a>
80103e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e60:	83 c0 7c             	add    $0x7c,%eax
80103e63:	3d 74 3f 11 80       	cmp    $0x80113f74,%eax
80103e68:	74 1c                	je     80103e86 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103e6a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e6e:	75 f0                	jne    80103e60 <exit+0x80>
80103e70:	3b 50 20             	cmp    0x20(%eax),%edx
80103e73:	75 eb                	jne    80103e60 <exit+0x80>
      p->state = RUNNABLE;
80103e75:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e7c:	83 c0 7c             	add    $0x7c,%eax
80103e7f:	3d 74 3f 11 80       	cmp    $0x80113f74,%eax
80103e84:	75 e4                	jne    80103e6a <exit+0x8a>
      p->parent = initproc;
80103e86:	8b 0d 74 3f 11 80    	mov    0x80113f74,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e8c:	ba 74 20 11 80       	mov    $0x80112074,%edx
80103e91:	eb 10                	jmp    80103ea3 <exit+0xc3>
80103e93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e97:	90                   	nop
80103e98:	83 c2 7c             	add    $0x7c,%edx
80103e9b:	81 fa 74 3f 11 80    	cmp    $0x80113f74,%edx
80103ea1:	74 3b                	je     80103ede <exit+0xfe>
    if(p->parent == curproc){
80103ea3:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103ea6:	75 f0                	jne    80103e98 <exit+0xb8>
      if(p->state == ZOMBIE)
80103ea8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103eac:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103eaf:	75 e7                	jne    80103e98 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103eb1:	b8 74 20 11 80       	mov    $0x80112074,%eax
80103eb6:	eb 12                	jmp    80103eca <exit+0xea>
80103eb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ebf:	90                   	nop
80103ec0:	83 c0 7c             	add    $0x7c,%eax
80103ec3:	3d 74 3f 11 80       	cmp    $0x80113f74,%eax
80103ec8:	74 ce                	je     80103e98 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103eca:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ece:	75 f0                	jne    80103ec0 <exit+0xe0>
80103ed0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103ed3:	75 eb                	jne    80103ec0 <exit+0xe0>
      p->state = RUNNABLE;
80103ed5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103edc:	eb e2                	jmp    80103ec0 <exit+0xe0>
  curproc->state = ZOMBIE;
80103ede:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103ee5:	e8 36 fe ff ff       	call   80103d20 <sched>
  panic("zombie exit");
80103eea:	83 ec 0c             	sub    $0xc,%esp
80103eed:	68 48 78 10 80       	push   $0x80107848
80103ef2:	e8 89 c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103ef7:	83 ec 0c             	sub    $0xc,%esp
80103efa:	68 3b 78 10 80       	push   $0x8010783b
80103eff:	e8 7c c4 ff ff       	call   80100380 <panic>
80103f04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f0f:	90                   	nop

80103f10 <wait>:
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	56                   	push   %esi
80103f14:	53                   	push   %ebx
  pushcli();
80103f15:	e8 86 05 00 00       	call   801044a0 <pushcli>
  c = mycpu();
80103f1a:	e8 21 fa ff ff       	call   80103940 <mycpu>
  p = c->proc;
80103f1f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f25:	e8 c6 05 00 00       	call   801044f0 <popcli>
  acquire(&ptable.lock);
80103f2a:	83 ec 0c             	sub    $0xc,%esp
80103f2d:	68 40 20 11 80       	push   $0x80112040
80103f32:	e8 b9 06 00 00       	call   801045f0 <acquire>
80103f37:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f3a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f3c:	bb 74 20 11 80       	mov    $0x80112074,%ebx
80103f41:	eb 10                	jmp    80103f53 <wait+0x43>
80103f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f47:	90                   	nop
80103f48:	83 c3 7c             	add    $0x7c,%ebx
80103f4b:	81 fb 74 3f 11 80    	cmp    $0x80113f74,%ebx
80103f51:	74 1b                	je     80103f6e <wait+0x5e>
      if(p->parent != curproc)
80103f53:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f56:	75 f0                	jne    80103f48 <wait+0x38>
      if(p->state == ZOMBIE){
80103f58:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f5c:	74 62                	je     80103fc0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f5e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103f61:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f66:	81 fb 74 3f 11 80    	cmp    $0x80113f74,%ebx
80103f6c:	75 e5                	jne    80103f53 <wait+0x43>
    if(!havekids || curproc->killed){
80103f6e:	85 c0                	test   %eax,%eax
80103f70:	0f 84 a0 00 00 00    	je     80104016 <wait+0x106>
80103f76:	8b 46 24             	mov    0x24(%esi),%eax
80103f79:	85 c0                	test   %eax,%eax
80103f7b:	0f 85 95 00 00 00    	jne    80104016 <wait+0x106>
  pushcli();
80103f81:	e8 1a 05 00 00       	call   801044a0 <pushcli>
  c = mycpu();
80103f86:	e8 b5 f9 ff ff       	call   80103940 <mycpu>
  p = c->proc;
80103f8b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f91:	e8 5a 05 00 00       	call   801044f0 <popcli>
  if(p == 0)
80103f96:	85 db                	test   %ebx,%ebx
80103f98:	0f 84 8f 00 00 00    	je     8010402d <wait+0x11d>
  p->chan = chan;
80103f9e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80103fa1:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103fa8:	e8 73 fd ff ff       	call   80103d20 <sched>
  p->chan = 0;
80103fad:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103fb4:	eb 84                	jmp    80103f3a <wait+0x2a>
80103fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fbd:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80103fc0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80103fc3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103fc6:	ff 73 08             	push   0x8(%ebx)
80103fc9:	e8 42 e5 ff ff       	call   80102510 <kfree>
        p->kstack = 0;
80103fce:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103fd5:	5a                   	pop    %edx
80103fd6:	ff 73 04             	push   0x4(%ebx)
80103fd9:	e8 c2 2e 00 00       	call   80106ea0 <freevm>
        p->pid = 0;
80103fde:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103fe5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103fec:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103ff0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103ff7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103ffe:	c7 04 24 40 20 11 80 	movl   $0x80112040,(%esp)
80104005:	e8 86 05 00 00       	call   80104590 <release>
        return pid;
8010400a:	83 c4 10             	add    $0x10,%esp
}
8010400d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104010:	89 f0                	mov    %esi,%eax
80104012:	5b                   	pop    %ebx
80104013:	5e                   	pop    %esi
80104014:	5d                   	pop    %ebp
80104015:	c3                   	ret    
      release(&ptable.lock);
80104016:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104019:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010401e:	68 40 20 11 80       	push   $0x80112040
80104023:	e8 68 05 00 00       	call   80104590 <release>
      return -1;
80104028:	83 c4 10             	add    $0x10,%esp
8010402b:	eb e0                	jmp    8010400d <wait+0xfd>
    panic("sleep");
8010402d:	83 ec 0c             	sub    $0xc,%esp
80104030:	68 54 78 10 80       	push   $0x80107854
80104035:	e8 46 c3 ff ff       	call   80100380 <panic>
8010403a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104040 <yield>:
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	53                   	push   %ebx
80104044:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104047:	68 40 20 11 80       	push   $0x80112040
8010404c:	e8 9f 05 00 00       	call   801045f0 <acquire>
  pushcli();
80104051:	e8 4a 04 00 00       	call   801044a0 <pushcli>
  c = mycpu();
80104056:	e8 e5 f8 ff ff       	call   80103940 <mycpu>
  p = c->proc;
8010405b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104061:	e8 8a 04 00 00       	call   801044f0 <popcli>
  myproc()->state = RUNNABLE;
80104066:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010406d:	e8 ae fc ff ff       	call   80103d20 <sched>
  release(&ptable.lock);
80104072:	c7 04 24 40 20 11 80 	movl   $0x80112040,(%esp)
80104079:	e8 12 05 00 00       	call   80104590 <release>
}
8010407e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104081:	83 c4 10             	add    $0x10,%esp
80104084:	c9                   	leave  
80104085:	c3                   	ret    
80104086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010408d:	8d 76 00             	lea    0x0(%esi),%esi

80104090 <sleep>:
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	57                   	push   %edi
80104094:	56                   	push   %esi
80104095:	53                   	push   %ebx
80104096:	83 ec 0c             	sub    $0xc,%esp
80104099:	8b 7d 08             	mov    0x8(%ebp),%edi
8010409c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010409f:	e8 fc 03 00 00       	call   801044a0 <pushcli>
  c = mycpu();
801040a4:	e8 97 f8 ff ff       	call   80103940 <mycpu>
  p = c->proc;
801040a9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040af:	e8 3c 04 00 00       	call   801044f0 <popcli>
  if(p == 0)
801040b4:	85 db                	test   %ebx,%ebx
801040b6:	0f 84 87 00 00 00    	je     80104143 <sleep+0xb3>
  if(lk == 0)
801040bc:	85 f6                	test   %esi,%esi
801040be:	74 76                	je     80104136 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801040c0:	81 fe 40 20 11 80    	cmp    $0x80112040,%esi
801040c6:	74 50                	je     80104118 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801040c8:	83 ec 0c             	sub    $0xc,%esp
801040cb:	68 40 20 11 80       	push   $0x80112040
801040d0:	e8 1b 05 00 00       	call   801045f0 <acquire>
    release(lk);
801040d5:	89 34 24             	mov    %esi,(%esp)
801040d8:	e8 b3 04 00 00       	call   80104590 <release>
  p->chan = chan;
801040dd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040e0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040e7:	e8 34 fc ff ff       	call   80103d20 <sched>
  p->chan = 0;
801040ec:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801040f3:	c7 04 24 40 20 11 80 	movl   $0x80112040,(%esp)
801040fa:	e8 91 04 00 00       	call   80104590 <release>
    acquire(lk);
801040ff:	89 75 08             	mov    %esi,0x8(%ebp)
80104102:	83 c4 10             	add    $0x10,%esp
}
80104105:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104108:	5b                   	pop    %ebx
80104109:	5e                   	pop    %esi
8010410a:	5f                   	pop    %edi
8010410b:	5d                   	pop    %ebp
    acquire(lk);
8010410c:	e9 df 04 00 00       	jmp    801045f0 <acquire>
80104111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104118:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010411b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104122:	e8 f9 fb ff ff       	call   80103d20 <sched>
  p->chan = 0;
80104127:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010412e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104131:	5b                   	pop    %ebx
80104132:	5e                   	pop    %esi
80104133:	5f                   	pop    %edi
80104134:	5d                   	pop    %ebp
80104135:	c3                   	ret    
    panic("sleep without lk");
80104136:	83 ec 0c             	sub    $0xc,%esp
80104139:	68 5a 78 10 80       	push   $0x8010785a
8010413e:	e8 3d c2 ff ff       	call   80100380 <panic>
    panic("sleep");
80104143:	83 ec 0c             	sub    $0xc,%esp
80104146:	68 54 78 10 80       	push   $0x80107854
8010414b:	e8 30 c2 ff ff       	call   80100380 <panic>

80104150 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	53                   	push   %ebx
80104154:	83 ec 10             	sub    $0x10,%esp
80104157:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010415a:	68 40 20 11 80       	push   $0x80112040
8010415f:	e8 8c 04 00 00       	call   801045f0 <acquire>
80104164:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104167:	b8 74 20 11 80       	mov    $0x80112074,%eax
8010416c:	eb 0c                	jmp    8010417a <wakeup+0x2a>
8010416e:	66 90                	xchg   %ax,%ax
80104170:	83 c0 7c             	add    $0x7c,%eax
80104173:	3d 74 3f 11 80       	cmp    $0x80113f74,%eax
80104178:	74 1c                	je     80104196 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010417a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010417e:	75 f0                	jne    80104170 <wakeup+0x20>
80104180:	3b 58 20             	cmp    0x20(%eax),%ebx
80104183:	75 eb                	jne    80104170 <wakeup+0x20>
      p->state = RUNNABLE;
80104185:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010418c:	83 c0 7c             	add    $0x7c,%eax
8010418f:	3d 74 3f 11 80       	cmp    $0x80113f74,%eax
80104194:	75 e4                	jne    8010417a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104196:	c7 45 08 40 20 11 80 	movl   $0x80112040,0x8(%ebp)
}
8010419d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041a0:	c9                   	leave  
  release(&ptable.lock);
801041a1:	e9 ea 03 00 00       	jmp    80104590 <release>
801041a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041ad:	8d 76 00             	lea    0x0(%esi),%esi

801041b0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	53                   	push   %ebx
801041b4:	83 ec 10             	sub    $0x10,%esp
801041b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801041ba:	68 40 20 11 80       	push   $0x80112040
801041bf:	e8 2c 04 00 00       	call   801045f0 <acquire>
801041c4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041c7:	b8 74 20 11 80       	mov    $0x80112074,%eax
801041cc:	eb 0c                	jmp    801041da <kill+0x2a>
801041ce:	66 90                	xchg   %ax,%ax
801041d0:	83 c0 7c             	add    $0x7c,%eax
801041d3:	3d 74 3f 11 80       	cmp    $0x80113f74,%eax
801041d8:	74 36                	je     80104210 <kill+0x60>
    if(p->pid == pid){
801041da:	39 58 10             	cmp    %ebx,0x10(%eax)
801041dd:	75 f1                	jne    801041d0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041df:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801041e3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801041ea:	75 07                	jne    801041f3 <kill+0x43>
        p->state = RUNNABLE;
801041ec:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801041f3:	83 ec 0c             	sub    $0xc,%esp
801041f6:	68 40 20 11 80       	push   $0x80112040
801041fb:	e8 90 03 00 00       	call   80104590 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104200:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104203:	83 c4 10             	add    $0x10,%esp
80104206:	31 c0                	xor    %eax,%eax
}
80104208:	c9                   	leave  
80104209:	c3                   	ret    
8010420a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104210:	83 ec 0c             	sub    $0xc,%esp
80104213:	68 40 20 11 80       	push   $0x80112040
80104218:	e8 73 03 00 00       	call   80104590 <release>
}
8010421d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104220:	83 c4 10             	add    $0x10,%esp
80104223:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104228:	c9                   	leave  
80104229:	c3                   	ret    
8010422a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104230 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	57                   	push   %edi
80104234:	56                   	push   %esi
80104235:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104238:	53                   	push   %ebx
80104239:	bb e0 20 11 80       	mov    $0x801120e0,%ebx
8010423e:	83 ec 3c             	sub    $0x3c,%esp
80104241:	eb 24                	jmp    80104267 <procdump+0x37>
80104243:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104247:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104248:	83 ec 0c             	sub    $0xc,%esp
8010424b:	68 db 7b 10 80       	push   $0x80107bdb
80104250:	e8 4b c4 ff ff       	call   801006a0 <cprintf>
80104255:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104258:	83 c3 7c             	add    $0x7c,%ebx
8010425b:	81 fb e0 3f 11 80    	cmp    $0x80113fe0,%ebx
80104261:	0f 84 81 00 00 00    	je     801042e8 <procdump+0xb8>
    if(p->state == UNUSED)
80104267:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010426a:	85 c0                	test   %eax,%eax
8010426c:	74 ea                	je     80104258 <procdump+0x28>
      state = "???";
8010426e:	ba 6b 78 10 80       	mov    $0x8010786b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104273:	83 f8 05             	cmp    $0x5,%eax
80104276:	77 11                	ja     80104289 <procdump+0x59>
80104278:	8b 14 85 cc 78 10 80 	mov    -0x7fef8734(,%eax,4),%edx
      state = "???";
8010427f:	b8 6b 78 10 80       	mov    $0x8010786b,%eax
80104284:	85 d2                	test   %edx,%edx
80104286:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104289:	53                   	push   %ebx
8010428a:	52                   	push   %edx
8010428b:	ff 73 a4             	push   -0x5c(%ebx)
8010428e:	68 6f 78 10 80       	push   $0x8010786f
80104293:	e8 08 c4 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
80104298:	83 c4 10             	add    $0x10,%esp
8010429b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010429f:	75 a7                	jne    80104248 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801042a1:	83 ec 08             	sub    $0x8,%esp
801042a4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801042a7:	8d 7d c0             	lea    -0x40(%ebp),%edi
801042aa:	50                   	push   %eax
801042ab:	8b 43 b0             	mov    -0x50(%ebx),%eax
801042ae:	8b 40 0c             	mov    0xc(%eax),%eax
801042b1:	83 c0 08             	add    $0x8,%eax
801042b4:	50                   	push   %eax
801042b5:	e8 86 01 00 00       	call   80104440 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801042ba:	83 c4 10             	add    $0x10,%esp
801042bd:	8d 76 00             	lea    0x0(%esi),%esi
801042c0:	8b 17                	mov    (%edi),%edx
801042c2:	85 d2                	test   %edx,%edx
801042c4:	74 82                	je     80104248 <procdump+0x18>
        cprintf(" %p", pc[i]);
801042c6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801042c9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801042cc:	52                   	push   %edx
801042cd:	68 c1 72 10 80       	push   $0x801072c1
801042d2:	e8 c9 c3 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801042d7:	83 c4 10             	add    $0x10,%esp
801042da:	39 fe                	cmp    %edi,%esi
801042dc:	75 e2                	jne    801042c0 <procdump+0x90>
801042de:	e9 65 ff ff ff       	jmp    80104248 <procdump+0x18>
801042e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042e7:	90                   	nop
  }
}
801042e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042eb:	5b                   	pop    %ebx
801042ec:	5e                   	pop    %esi
801042ed:	5f                   	pop    %edi
801042ee:	5d                   	pop    %ebp
801042ef:	c3                   	ret    

801042f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	53                   	push   %ebx
801042f4:	83 ec 0c             	sub    $0xc,%esp
801042f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801042fa:	68 e4 78 10 80       	push   $0x801078e4
801042ff:	8d 43 04             	lea    0x4(%ebx),%eax
80104302:	50                   	push   %eax
80104303:	e8 18 01 00 00       	call   80104420 <initlock>
  lk->name = name;
80104308:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010430b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104311:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104314:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010431b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010431e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104321:	c9                   	leave  
80104322:	c3                   	ret    
80104323:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010432a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104330 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	56                   	push   %esi
80104334:	53                   	push   %ebx
80104335:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104338:	8d 73 04             	lea    0x4(%ebx),%esi
8010433b:	83 ec 0c             	sub    $0xc,%esp
8010433e:	56                   	push   %esi
8010433f:	e8 ac 02 00 00       	call   801045f0 <acquire>
  while (lk->locked) {
80104344:	8b 13                	mov    (%ebx),%edx
80104346:	83 c4 10             	add    $0x10,%esp
80104349:	85 d2                	test   %edx,%edx
8010434b:	74 16                	je     80104363 <acquiresleep+0x33>
8010434d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104350:	83 ec 08             	sub    $0x8,%esp
80104353:	56                   	push   %esi
80104354:	53                   	push   %ebx
80104355:	e8 36 fd ff ff       	call   80104090 <sleep>
  while (lk->locked) {
8010435a:	8b 03                	mov    (%ebx),%eax
8010435c:	83 c4 10             	add    $0x10,%esp
8010435f:	85 c0                	test   %eax,%eax
80104361:	75 ed                	jne    80104350 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104363:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104369:	e8 52 f6 ff ff       	call   801039c0 <myproc>
8010436e:	8b 40 10             	mov    0x10(%eax),%eax
80104371:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104374:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104377:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010437a:	5b                   	pop    %ebx
8010437b:	5e                   	pop    %esi
8010437c:	5d                   	pop    %ebp
  release(&lk->lk);
8010437d:	e9 0e 02 00 00       	jmp    80104590 <release>
80104382:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104390 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	56                   	push   %esi
80104394:	53                   	push   %ebx
80104395:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104398:	8d 73 04             	lea    0x4(%ebx),%esi
8010439b:	83 ec 0c             	sub    $0xc,%esp
8010439e:	56                   	push   %esi
8010439f:	e8 4c 02 00 00       	call   801045f0 <acquire>
  lk->locked = 0;
801043a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801043aa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801043b1:	89 1c 24             	mov    %ebx,(%esp)
801043b4:	e8 97 fd ff ff       	call   80104150 <wakeup>
  release(&lk->lk);
801043b9:	89 75 08             	mov    %esi,0x8(%ebp)
801043bc:	83 c4 10             	add    $0x10,%esp
}
801043bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043c2:	5b                   	pop    %ebx
801043c3:	5e                   	pop    %esi
801043c4:	5d                   	pop    %ebp
  release(&lk->lk);
801043c5:	e9 c6 01 00 00       	jmp    80104590 <release>
801043ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	57                   	push   %edi
801043d4:	31 ff                	xor    %edi,%edi
801043d6:	56                   	push   %esi
801043d7:	53                   	push   %ebx
801043d8:	83 ec 18             	sub    $0x18,%esp
801043db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801043de:	8d 73 04             	lea    0x4(%ebx),%esi
801043e1:	56                   	push   %esi
801043e2:	e8 09 02 00 00       	call   801045f0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801043e7:	8b 03                	mov    (%ebx),%eax
801043e9:	83 c4 10             	add    $0x10,%esp
801043ec:	85 c0                	test   %eax,%eax
801043ee:	75 18                	jne    80104408 <holdingsleep+0x38>
  release(&lk->lk);
801043f0:	83 ec 0c             	sub    $0xc,%esp
801043f3:	56                   	push   %esi
801043f4:	e8 97 01 00 00       	call   80104590 <release>
  return r;
}
801043f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043fc:	89 f8                	mov    %edi,%eax
801043fe:	5b                   	pop    %ebx
801043ff:	5e                   	pop    %esi
80104400:	5f                   	pop    %edi
80104401:	5d                   	pop    %ebp
80104402:	c3                   	ret    
80104403:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104407:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104408:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010440b:	e8 b0 f5 ff ff       	call   801039c0 <myproc>
80104410:	39 58 10             	cmp    %ebx,0x10(%eax)
80104413:	0f 94 c0             	sete   %al
80104416:	0f b6 c0             	movzbl %al,%eax
80104419:	89 c7                	mov    %eax,%edi
8010441b:	eb d3                	jmp    801043f0 <holdingsleep+0x20>
8010441d:	66 90                	xchg   %ax,%ax
8010441f:	90                   	nop

80104420 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104426:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104429:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010442f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104432:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104439:	5d                   	pop    %ebp
8010443a:	c3                   	ret    
8010443b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010443f:	90                   	nop

80104440 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104440:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104441:	31 d2                	xor    %edx,%edx
{
80104443:	89 e5                	mov    %esp,%ebp
80104445:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104446:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104449:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010444c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010444f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104450:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104456:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010445c:	77 1a                	ja     80104478 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010445e:	8b 58 04             	mov    0x4(%eax),%ebx
80104461:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104464:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104467:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104469:	83 fa 0a             	cmp    $0xa,%edx
8010446c:	75 e2                	jne    80104450 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010446e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104471:	c9                   	leave  
80104472:	c3                   	ret    
80104473:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104477:	90                   	nop
  for(; i < 10; i++)
80104478:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010447b:	8d 51 28             	lea    0x28(%ecx),%edx
8010447e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104480:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104486:	83 c0 04             	add    $0x4,%eax
80104489:	39 d0                	cmp    %edx,%eax
8010448b:	75 f3                	jne    80104480 <getcallerpcs+0x40>
}
8010448d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104490:	c9                   	leave  
80104491:	c3                   	ret    
80104492:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801044a0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	53                   	push   %ebx
801044a4:	83 ec 04             	sub    $0x4,%esp
801044a7:	9c                   	pushf  
801044a8:	5b                   	pop    %ebx
  asm volatile("cli");
801044a9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801044aa:	e8 91 f4 ff ff       	call   80103940 <mycpu>
801044af:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801044b5:	85 c0                	test   %eax,%eax
801044b7:	74 17                	je     801044d0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801044b9:	e8 82 f4 ff ff       	call   80103940 <mycpu>
801044be:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801044c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044c8:	c9                   	leave  
801044c9:	c3                   	ret    
801044ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801044d0:	e8 6b f4 ff ff       	call   80103940 <mycpu>
801044d5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801044db:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801044e1:	eb d6                	jmp    801044b9 <pushcli+0x19>
801044e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044f0 <popcli>:

void
popcli(void)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044f6:	9c                   	pushf  
801044f7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801044f8:	f6 c4 02             	test   $0x2,%ah
801044fb:	75 35                	jne    80104532 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801044fd:	e8 3e f4 ff ff       	call   80103940 <mycpu>
80104502:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104509:	78 34                	js     8010453f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010450b:	e8 30 f4 ff ff       	call   80103940 <mycpu>
80104510:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104516:	85 d2                	test   %edx,%edx
80104518:	74 06                	je     80104520 <popcli+0x30>
    sti();
}
8010451a:	c9                   	leave  
8010451b:	c3                   	ret    
8010451c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104520:	e8 1b f4 ff ff       	call   80103940 <mycpu>
80104525:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010452b:	85 c0                	test   %eax,%eax
8010452d:	74 eb                	je     8010451a <popcli+0x2a>
  asm volatile("sti");
8010452f:	fb                   	sti    
}
80104530:	c9                   	leave  
80104531:	c3                   	ret    
    panic("popcli - interruptible");
80104532:	83 ec 0c             	sub    $0xc,%esp
80104535:	68 ef 78 10 80       	push   $0x801078ef
8010453a:	e8 41 be ff ff       	call   80100380 <panic>
    panic("popcli");
8010453f:	83 ec 0c             	sub    $0xc,%esp
80104542:	68 06 79 10 80       	push   $0x80107906
80104547:	e8 34 be ff ff       	call   80100380 <panic>
8010454c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104550 <holding>:
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	56                   	push   %esi
80104554:	53                   	push   %ebx
80104555:	8b 75 08             	mov    0x8(%ebp),%esi
80104558:	31 db                	xor    %ebx,%ebx
  pushcli();
8010455a:	e8 41 ff ff ff       	call   801044a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010455f:	8b 06                	mov    (%esi),%eax
80104561:	85 c0                	test   %eax,%eax
80104563:	75 0b                	jne    80104570 <holding+0x20>
  popcli();
80104565:	e8 86 ff ff ff       	call   801044f0 <popcli>
}
8010456a:	89 d8                	mov    %ebx,%eax
8010456c:	5b                   	pop    %ebx
8010456d:	5e                   	pop    %esi
8010456e:	5d                   	pop    %ebp
8010456f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104570:	8b 5e 08             	mov    0x8(%esi),%ebx
80104573:	e8 c8 f3 ff ff       	call   80103940 <mycpu>
80104578:	39 c3                	cmp    %eax,%ebx
8010457a:	0f 94 c3             	sete   %bl
  popcli();
8010457d:	e8 6e ff ff ff       	call   801044f0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104582:	0f b6 db             	movzbl %bl,%ebx
}
80104585:	89 d8                	mov    %ebx,%eax
80104587:	5b                   	pop    %ebx
80104588:	5e                   	pop    %esi
80104589:	5d                   	pop    %ebp
8010458a:	c3                   	ret    
8010458b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010458f:	90                   	nop

80104590 <release>:
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	56                   	push   %esi
80104594:	53                   	push   %ebx
80104595:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104598:	e8 03 ff ff ff       	call   801044a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010459d:	8b 03                	mov    (%ebx),%eax
8010459f:	85 c0                	test   %eax,%eax
801045a1:	75 15                	jne    801045b8 <release+0x28>
  popcli();
801045a3:	e8 48 ff ff ff       	call   801044f0 <popcli>
    panic("release");
801045a8:	83 ec 0c             	sub    $0xc,%esp
801045ab:	68 0d 79 10 80       	push   $0x8010790d
801045b0:	e8 cb bd ff ff       	call   80100380 <panic>
801045b5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801045b8:	8b 73 08             	mov    0x8(%ebx),%esi
801045bb:	e8 80 f3 ff ff       	call   80103940 <mycpu>
801045c0:	39 c6                	cmp    %eax,%esi
801045c2:	75 df                	jne    801045a3 <release+0x13>
  popcli();
801045c4:	e8 27 ff ff ff       	call   801044f0 <popcli>
  lk->pcs[0] = 0;
801045c9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801045d0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801045d7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801045dc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801045e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045e5:	5b                   	pop    %ebx
801045e6:	5e                   	pop    %esi
801045e7:	5d                   	pop    %ebp
  popcli();
801045e8:	e9 03 ff ff ff       	jmp    801044f0 <popcli>
801045ed:	8d 76 00             	lea    0x0(%esi),%esi

801045f0 <acquire>:
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	53                   	push   %ebx
801045f4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801045f7:	e8 a4 fe ff ff       	call   801044a0 <pushcli>
  if(holding(lk))
801045fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801045ff:	e8 9c fe ff ff       	call   801044a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104604:	8b 03                	mov    (%ebx),%eax
80104606:	85 c0                	test   %eax,%eax
80104608:	75 7e                	jne    80104688 <acquire+0x98>
  popcli();
8010460a:	e8 e1 fe ff ff       	call   801044f0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010460f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104618:	8b 55 08             	mov    0x8(%ebp),%edx
8010461b:	89 c8                	mov    %ecx,%eax
8010461d:	f0 87 02             	lock xchg %eax,(%edx)
80104620:	85 c0                	test   %eax,%eax
80104622:	75 f4                	jne    80104618 <acquire+0x28>
  __sync_synchronize();
80104624:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104629:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010462c:	e8 0f f3 ff ff       	call   80103940 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104631:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104634:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104636:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104639:	31 c0                	xor    %eax,%eax
8010463b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010463f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104640:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104646:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010464c:	77 1a                	ja     80104668 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010464e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104651:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104655:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104658:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010465a:	83 f8 0a             	cmp    $0xa,%eax
8010465d:	75 e1                	jne    80104640 <acquire+0x50>
}
8010465f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104662:	c9                   	leave  
80104663:	c3                   	ret    
80104664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104668:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010466c:	8d 51 34             	lea    0x34(%ecx),%edx
8010466f:	90                   	nop
    pcs[i] = 0;
80104670:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104676:	83 c0 04             	add    $0x4,%eax
80104679:	39 c2                	cmp    %eax,%edx
8010467b:	75 f3                	jne    80104670 <acquire+0x80>
}
8010467d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104680:	c9                   	leave  
80104681:	c3                   	ret    
80104682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104688:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010468b:	e8 b0 f2 ff ff       	call   80103940 <mycpu>
80104690:	39 c3                	cmp    %eax,%ebx
80104692:	0f 85 72 ff ff ff    	jne    8010460a <acquire+0x1a>
  popcli();
80104698:	e8 53 fe ff ff       	call   801044f0 <popcli>
    panic("acquire");
8010469d:	83 ec 0c             	sub    $0xc,%esp
801046a0:	68 15 79 10 80       	push   $0x80107915
801046a5:	e8 d6 bc ff ff       	call   80100380 <panic>
801046aa:	66 90                	xchg   %ax,%ax
801046ac:	66 90                	xchg   %ax,%ax
801046ae:	66 90                	xchg   %ax,%ax

801046b0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	57                   	push   %edi
801046b4:	8b 55 08             	mov    0x8(%ebp),%edx
801046b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801046ba:	53                   	push   %ebx
801046bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801046be:	89 d7                	mov    %edx,%edi
801046c0:	09 cf                	or     %ecx,%edi
801046c2:	83 e7 03             	and    $0x3,%edi
801046c5:	75 29                	jne    801046f0 <memset+0x40>
    c &= 0xFF;
801046c7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801046ca:	c1 e0 18             	shl    $0x18,%eax
801046cd:	89 fb                	mov    %edi,%ebx
801046cf:	c1 e9 02             	shr    $0x2,%ecx
801046d2:	c1 e3 10             	shl    $0x10,%ebx
801046d5:	09 d8                	or     %ebx,%eax
801046d7:	09 f8                	or     %edi,%eax
801046d9:	c1 e7 08             	shl    $0x8,%edi
801046dc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801046de:	89 d7                	mov    %edx,%edi
801046e0:	fc                   	cld    
801046e1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801046e3:	5b                   	pop    %ebx
801046e4:	89 d0                	mov    %edx,%eax
801046e6:	5f                   	pop    %edi
801046e7:	5d                   	pop    %ebp
801046e8:	c3                   	ret    
801046e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801046f0:	89 d7                	mov    %edx,%edi
801046f2:	fc                   	cld    
801046f3:	f3 aa                	rep stos %al,%es:(%edi)
801046f5:	5b                   	pop    %ebx
801046f6:	89 d0                	mov    %edx,%eax
801046f8:	5f                   	pop    %edi
801046f9:	5d                   	pop    %ebp
801046fa:	c3                   	ret    
801046fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046ff:	90                   	nop

80104700 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	56                   	push   %esi
80104704:	8b 75 10             	mov    0x10(%ebp),%esi
80104707:	8b 55 08             	mov    0x8(%ebp),%edx
8010470a:	53                   	push   %ebx
8010470b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010470e:	85 f6                	test   %esi,%esi
80104710:	74 2e                	je     80104740 <memcmp+0x40>
80104712:	01 c6                	add    %eax,%esi
80104714:	eb 14                	jmp    8010472a <memcmp+0x2a>
80104716:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010471d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104720:	83 c0 01             	add    $0x1,%eax
80104723:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104726:	39 f0                	cmp    %esi,%eax
80104728:	74 16                	je     80104740 <memcmp+0x40>
    if(*s1 != *s2)
8010472a:	0f b6 0a             	movzbl (%edx),%ecx
8010472d:	0f b6 18             	movzbl (%eax),%ebx
80104730:	38 d9                	cmp    %bl,%cl
80104732:	74 ec                	je     80104720 <memcmp+0x20>
      return *s1 - *s2;
80104734:	0f b6 c1             	movzbl %cl,%eax
80104737:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104739:	5b                   	pop    %ebx
8010473a:	5e                   	pop    %esi
8010473b:	5d                   	pop    %ebp
8010473c:	c3                   	ret    
8010473d:	8d 76 00             	lea    0x0(%esi),%esi
80104740:	5b                   	pop    %ebx
  return 0;
80104741:	31 c0                	xor    %eax,%eax
}
80104743:	5e                   	pop    %esi
80104744:	5d                   	pop    %ebp
80104745:	c3                   	ret    
80104746:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010474d:	8d 76 00             	lea    0x0(%esi),%esi

80104750 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	57                   	push   %edi
80104754:	8b 55 08             	mov    0x8(%ebp),%edx
80104757:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010475a:	56                   	push   %esi
8010475b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010475e:	39 d6                	cmp    %edx,%esi
80104760:	73 26                	jae    80104788 <memmove+0x38>
80104762:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104765:	39 fa                	cmp    %edi,%edx
80104767:	73 1f                	jae    80104788 <memmove+0x38>
80104769:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010476c:	85 c9                	test   %ecx,%ecx
8010476e:	74 0c                	je     8010477c <memmove+0x2c>
      *--d = *--s;
80104770:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104774:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104777:	83 e8 01             	sub    $0x1,%eax
8010477a:	73 f4                	jae    80104770 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010477c:	5e                   	pop    %esi
8010477d:	89 d0                	mov    %edx,%eax
8010477f:	5f                   	pop    %edi
80104780:	5d                   	pop    %ebp
80104781:	c3                   	ret    
80104782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104788:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010478b:	89 d7                	mov    %edx,%edi
8010478d:	85 c9                	test   %ecx,%ecx
8010478f:	74 eb                	je     8010477c <memmove+0x2c>
80104791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104798:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104799:	39 c6                	cmp    %eax,%esi
8010479b:	75 fb                	jne    80104798 <memmove+0x48>
}
8010479d:	5e                   	pop    %esi
8010479e:	89 d0                	mov    %edx,%eax
801047a0:	5f                   	pop    %edi
801047a1:	5d                   	pop    %ebp
801047a2:	c3                   	ret    
801047a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047b0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801047b0:	eb 9e                	jmp    80104750 <memmove>
801047b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047c0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	56                   	push   %esi
801047c4:	8b 75 10             	mov    0x10(%ebp),%esi
801047c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801047ca:	53                   	push   %ebx
801047cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
801047ce:	85 f6                	test   %esi,%esi
801047d0:	74 2e                	je     80104800 <strncmp+0x40>
801047d2:	01 d6                	add    %edx,%esi
801047d4:	eb 18                	jmp    801047ee <strncmp+0x2e>
801047d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047dd:	8d 76 00             	lea    0x0(%esi),%esi
801047e0:	38 d8                	cmp    %bl,%al
801047e2:	75 14                	jne    801047f8 <strncmp+0x38>
    n--, p++, q++;
801047e4:	83 c2 01             	add    $0x1,%edx
801047e7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801047ea:	39 f2                	cmp    %esi,%edx
801047ec:	74 12                	je     80104800 <strncmp+0x40>
801047ee:	0f b6 01             	movzbl (%ecx),%eax
801047f1:	0f b6 1a             	movzbl (%edx),%ebx
801047f4:	84 c0                	test   %al,%al
801047f6:	75 e8                	jne    801047e0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801047f8:	29 d8                	sub    %ebx,%eax
}
801047fa:	5b                   	pop    %ebx
801047fb:	5e                   	pop    %esi
801047fc:	5d                   	pop    %ebp
801047fd:	c3                   	ret    
801047fe:	66 90                	xchg   %ax,%ax
80104800:	5b                   	pop    %ebx
    return 0;
80104801:	31 c0                	xor    %eax,%eax
}
80104803:	5e                   	pop    %esi
80104804:	5d                   	pop    %ebp
80104805:	c3                   	ret    
80104806:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010480d:	8d 76 00             	lea    0x0(%esi),%esi

80104810 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	57                   	push   %edi
80104814:	56                   	push   %esi
80104815:	8b 75 08             	mov    0x8(%ebp),%esi
80104818:	53                   	push   %ebx
80104819:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010481c:	89 f0                	mov    %esi,%eax
8010481e:	eb 15                	jmp    80104835 <strncpy+0x25>
80104820:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104824:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104827:	83 c0 01             	add    $0x1,%eax
8010482a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010482e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104831:	84 d2                	test   %dl,%dl
80104833:	74 09                	je     8010483e <strncpy+0x2e>
80104835:	89 cb                	mov    %ecx,%ebx
80104837:	83 e9 01             	sub    $0x1,%ecx
8010483a:	85 db                	test   %ebx,%ebx
8010483c:	7f e2                	jg     80104820 <strncpy+0x10>
    ;
  while(n-- > 0)
8010483e:	89 c2                	mov    %eax,%edx
80104840:	85 c9                	test   %ecx,%ecx
80104842:	7e 17                	jle    8010485b <strncpy+0x4b>
80104844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104848:	83 c2 01             	add    $0x1,%edx
8010484b:	89 c1                	mov    %eax,%ecx
8010484d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104851:	29 d1                	sub    %edx,%ecx
80104853:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104857:	85 c9                	test   %ecx,%ecx
80104859:	7f ed                	jg     80104848 <strncpy+0x38>
  return os;
}
8010485b:	5b                   	pop    %ebx
8010485c:	89 f0                	mov    %esi,%eax
8010485e:	5e                   	pop    %esi
8010485f:	5f                   	pop    %edi
80104860:	5d                   	pop    %ebp
80104861:	c3                   	ret    
80104862:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104870 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	56                   	push   %esi
80104874:	8b 55 10             	mov    0x10(%ebp),%edx
80104877:	8b 75 08             	mov    0x8(%ebp),%esi
8010487a:	53                   	push   %ebx
8010487b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010487e:	85 d2                	test   %edx,%edx
80104880:	7e 25                	jle    801048a7 <safestrcpy+0x37>
80104882:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104886:	89 f2                	mov    %esi,%edx
80104888:	eb 16                	jmp    801048a0 <safestrcpy+0x30>
8010488a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104890:	0f b6 08             	movzbl (%eax),%ecx
80104893:	83 c0 01             	add    $0x1,%eax
80104896:	83 c2 01             	add    $0x1,%edx
80104899:	88 4a ff             	mov    %cl,-0x1(%edx)
8010489c:	84 c9                	test   %cl,%cl
8010489e:	74 04                	je     801048a4 <safestrcpy+0x34>
801048a0:	39 d8                	cmp    %ebx,%eax
801048a2:	75 ec                	jne    80104890 <safestrcpy+0x20>
    ;
  *s = 0;
801048a4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801048a7:	89 f0                	mov    %esi,%eax
801048a9:	5b                   	pop    %ebx
801048aa:	5e                   	pop    %esi
801048ab:	5d                   	pop    %ebp
801048ac:	c3                   	ret    
801048ad:	8d 76 00             	lea    0x0(%esi),%esi

801048b0 <strlen>:

int
strlen(const char *s)
{
801048b0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801048b1:	31 c0                	xor    %eax,%eax
{
801048b3:	89 e5                	mov    %esp,%ebp
801048b5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801048b8:	80 3a 00             	cmpb   $0x0,(%edx)
801048bb:	74 0c                	je     801048c9 <strlen+0x19>
801048bd:	8d 76 00             	lea    0x0(%esi),%esi
801048c0:	83 c0 01             	add    $0x1,%eax
801048c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801048c7:	75 f7                	jne    801048c0 <strlen+0x10>
    ;
  return n;
}
801048c9:	5d                   	pop    %ebp
801048ca:	c3                   	ret    

801048cb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801048cb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801048cf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801048d3:	55                   	push   %ebp
  pushl %ebx
801048d4:	53                   	push   %ebx
  pushl %esi
801048d5:	56                   	push   %esi
  pushl %edi
801048d6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801048d7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801048d9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801048db:	5f                   	pop    %edi
  popl %esi
801048dc:	5e                   	pop    %esi
  popl %ebx
801048dd:	5b                   	pop    %ebx
  popl %ebp
801048de:	5d                   	pop    %ebp
  ret
801048df:	c3                   	ret    

801048e0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	53                   	push   %ebx
801048e4:	83 ec 04             	sub    $0x4,%esp
801048e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801048ea:	e8 d1 f0 ff ff       	call   801039c0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048ef:	8b 00                	mov    (%eax),%eax
801048f1:	39 d8                	cmp    %ebx,%eax
801048f3:	76 1b                	jbe    80104910 <fetchint+0x30>
801048f5:	8d 53 04             	lea    0x4(%ebx),%edx
801048f8:	39 d0                	cmp    %edx,%eax
801048fa:	72 14                	jb     80104910 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801048fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801048ff:	8b 13                	mov    (%ebx),%edx
80104901:	89 10                	mov    %edx,(%eax)
  return 0;
80104903:	31 c0                	xor    %eax,%eax
}
80104905:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104908:	c9                   	leave  
80104909:	c3                   	ret    
8010490a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104910:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104915:	eb ee                	jmp    80104905 <fetchint+0x25>
80104917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010491e:	66 90                	xchg   %ax,%ax

80104920 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	53                   	push   %ebx
80104924:	83 ec 04             	sub    $0x4,%esp
80104927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010492a:	e8 91 f0 ff ff       	call   801039c0 <myproc>

  if(addr >= curproc->sz)
8010492f:	39 18                	cmp    %ebx,(%eax)
80104931:	76 2d                	jbe    80104960 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104933:	8b 55 0c             	mov    0xc(%ebp),%edx
80104936:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104938:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010493a:	39 d3                	cmp    %edx,%ebx
8010493c:	73 22                	jae    80104960 <fetchstr+0x40>
8010493e:	89 d8                	mov    %ebx,%eax
80104940:	eb 0d                	jmp    8010494f <fetchstr+0x2f>
80104942:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104948:	83 c0 01             	add    $0x1,%eax
8010494b:	39 c2                	cmp    %eax,%edx
8010494d:	76 11                	jbe    80104960 <fetchstr+0x40>
    if(*s == 0)
8010494f:	80 38 00             	cmpb   $0x0,(%eax)
80104952:	75 f4                	jne    80104948 <fetchstr+0x28>
      return s - *pp;
80104954:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104956:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104959:	c9                   	leave  
8010495a:	c3                   	ret    
8010495b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010495f:	90                   	nop
80104960:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104963:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104968:	c9                   	leave  
80104969:	c3                   	ret    
8010496a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104970 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	56                   	push   %esi
80104974:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104975:	e8 46 f0 ff ff       	call   801039c0 <myproc>
8010497a:	8b 55 08             	mov    0x8(%ebp),%edx
8010497d:	8b 40 18             	mov    0x18(%eax),%eax
80104980:	8b 40 44             	mov    0x44(%eax),%eax
80104983:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104986:	e8 35 f0 ff ff       	call   801039c0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010498b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010498e:	8b 00                	mov    (%eax),%eax
80104990:	39 c6                	cmp    %eax,%esi
80104992:	73 1c                	jae    801049b0 <argint+0x40>
80104994:	8d 53 08             	lea    0x8(%ebx),%edx
80104997:	39 d0                	cmp    %edx,%eax
80104999:	72 15                	jb     801049b0 <argint+0x40>
  *ip = *(int*)(addr);
8010499b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010499e:	8b 53 04             	mov    0x4(%ebx),%edx
801049a1:	89 10                	mov    %edx,(%eax)
  return 0;
801049a3:	31 c0                	xor    %eax,%eax
}
801049a5:	5b                   	pop    %ebx
801049a6:	5e                   	pop    %esi
801049a7:	5d                   	pop    %ebp
801049a8:	c3                   	ret    
801049a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049b5:	eb ee                	jmp    801049a5 <argint+0x35>
801049b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049be:	66 90                	xchg   %ax,%ax

801049c0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	57                   	push   %edi
801049c4:	56                   	push   %esi
801049c5:	53                   	push   %ebx
801049c6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
801049c9:	e8 f2 ef ff ff       	call   801039c0 <myproc>
801049ce:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049d0:	e8 eb ef ff ff       	call   801039c0 <myproc>
801049d5:	8b 55 08             	mov    0x8(%ebp),%edx
801049d8:	8b 40 18             	mov    0x18(%eax),%eax
801049db:	8b 40 44             	mov    0x44(%eax),%eax
801049de:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801049e1:	e8 da ef ff ff       	call   801039c0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049e6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049e9:	8b 00                	mov    (%eax),%eax
801049eb:	39 c7                	cmp    %eax,%edi
801049ed:	73 31                	jae    80104a20 <argptr+0x60>
801049ef:	8d 4b 08             	lea    0x8(%ebx),%ecx
801049f2:	39 c8                	cmp    %ecx,%eax
801049f4:	72 2a                	jb     80104a20 <argptr+0x60>

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801049f6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
801049f9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801049fc:	85 d2                	test   %edx,%edx
801049fe:	78 20                	js     80104a20 <argptr+0x60>
80104a00:	8b 16                	mov    (%esi),%edx
80104a02:	39 c2                	cmp    %eax,%edx
80104a04:	76 1a                	jbe    80104a20 <argptr+0x60>
80104a06:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104a09:	01 c3                	add    %eax,%ebx
80104a0b:	39 da                	cmp    %ebx,%edx
80104a0d:	72 11                	jb     80104a20 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104a0f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a12:	89 02                	mov    %eax,(%edx)
  return 0;
80104a14:	31 c0                	xor    %eax,%eax
}
80104a16:	83 c4 0c             	add    $0xc,%esp
80104a19:	5b                   	pop    %ebx
80104a1a:	5e                   	pop    %esi
80104a1b:	5f                   	pop    %edi
80104a1c:	5d                   	pop    %ebp
80104a1d:	c3                   	ret    
80104a1e:	66 90                	xchg   %ax,%ax
    return -1;
80104a20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a25:	eb ef                	jmp    80104a16 <argptr+0x56>
80104a27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a2e:	66 90                	xchg   %ax,%ax

80104a30 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	56                   	push   %esi
80104a34:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a35:	e8 86 ef ff ff       	call   801039c0 <myproc>
80104a3a:	8b 55 08             	mov    0x8(%ebp),%edx
80104a3d:	8b 40 18             	mov    0x18(%eax),%eax
80104a40:	8b 40 44             	mov    0x44(%eax),%eax
80104a43:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a46:	e8 75 ef ff ff       	call   801039c0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a4b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a4e:	8b 00                	mov    (%eax),%eax
80104a50:	39 c6                	cmp    %eax,%esi
80104a52:	73 44                	jae    80104a98 <argstr+0x68>
80104a54:	8d 53 08             	lea    0x8(%ebx),%edx
80104a57:	39 d0                	cmp    %edx,%eax
80104a59:	72 3d                	jb     80104a98 <argstr+0x68>
  *ip = *(int*)(addr);
80104a5b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104a5e:	e8 5d ef ff ff       	call   801039c0 <myproc>
  if(addr >= curproc->sz)
80104a63:	3b 18                	cmp    (%eax),%ebx
80104a65:	73 31                	jae    80104a98 <argstr+0x68>
  *pp = (char*)addr;
80104a67:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a6a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a6c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a6e:	39 d3                	cmp    %edx,%ebx
80104a70:	73 26                	jae    80104a98 <argstr+0x68>
80104a72:	89 d8                	mov    %ebx,%eax
80104a74:	eb 11                	jmp    80104a87 <argstr+0x57>
80104a76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a7d:	8d 76 00             	lea    0x0(%esi),%esi
80104a80:	83 c0 01             	add    $0x1,%eax
80104a83:	39 c2                	cmp    %eax,%edx
80104a85:	76 11                	jbe    80104a98 <argstr+0x68>
    if(*s == 0)
80104a87:	80 38 00             	cmpb   $0x0,(%eax)
80104a8a:	75 f4                	jne    80104a80 <argstr+0x50>
      return s - *pp;
80104a8c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104a8e:	5b                   	pop    %ebx
80104a8f:	5e                   	pop    %esi
80104a90:	5d                   	pop    %ebp
80104a91:	c3                   	ret    
80104a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a98:	5b                   	pop    %ebx
    return -1;
80104a99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a9e:	5e                   	pop    %esi
80104a9f:	5d                   	pop    %ebp
80104aa0:	c3                   	ret    
80104aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aaf:	90                   	nop

80104ab0 <syscall>:
[SYS_getiostats] sys_getiostats,
};

void
syscall(void)
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	53                   	push   %ebx
80104ab4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104ab7:	e8 04 ef ff ff       	call   801039c0 <myproc>
80104abc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104abe:	8b 40 18             	mov    0x18(%eax),%eax
80104ac1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104ac4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104ac7:	83 fa 15             	cmp    $0x15,%edx
80104aca:	77 24                	ja     80104af0 <syscall+0x40>
80104acc:	8b 14 85 40 79 10 80 	mov    -0x7fef86c0(,%eax,4),%edx
80104ad3:	85 d2                	test   %edx,%edx
80104ad5:	74 19                	je     80104af0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104ad7:	ff d2                	call   *%edx
80104ad9:	89 c2                	mov    %eax,%edx
80104adb:	8b 43 18             	mov    0x18(%ebx),%eax
80104ade:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104ae1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ae4:	c9                   	leave  
80104ae5:	c3                   	ret    
80104ae6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aed:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104af0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104af1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104af4:	50                   	push   %eax
80104af5:	ff 73 10             	push   0x10(%ebx)
80104af8:	68 1d 79 10 80       	push   $0x8010791d
80104afd:	e8 9e bb ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104b02:	8b 43 18             	mov    0x18(%ebx),%eax
80104b05:	83 c4 10             	add    $0x10,%esp
80104b08:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104b0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b12:	c9                   	leave  
80104b13:	c3                   	ret    
80104b14:	66 90                	xchg   %ax,%ax
80104b16:	66 90                	xchg   %ax,%ax
80104b18:	66 90                	xchg   %ax,%ax
80104b1a:	66 90                	xchg   %ax,%ax
80104b1c:	66 90                	xchg   %ax,%ax
80104b1e:	66 90                	xchg   %ax,%ax

80104b20 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	57                   	push   %edi
80104b24:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104b25:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104b28:	53                   	push   %ebx
80104b29:	83 ec 34             	sub    $0x34,%esp
80104b2c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104b2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104b32:	57                   	push   %edi
80104b33:	50                   	push   %eax
{
80104b34:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104b37:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104b3a:	e8 d1 d5 ff ff       	call   80102110 <nameiparent>
80104b3f:	83 c4 10             	add    $0x10,%esp
80104b42:	85 c0                	test   %eax,%eax
80104b44:	0f 84 46 01 00 00    	je     80104c90 <create+0x170>
    return 0;
  ilock(dp);
80104b4a:	83 ec 0c             	sub    $0xc,%esp
80104b4d:	89 c3                	mov    %eax,%ebx
80104b4f:	50                   	push   %eax
80104b50:	e8 7b cc ff ff       	call   801017d0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104b55:	83 c4 0c             	add    $0xc,%esp
80104b58:	6a 00                	push   $0x0
80104b5a:	57                   	push   %edi
80104b5b:	53                   	push   %ebx
80104b5c:	e8 cf d1 ff ff       	call   80101d30 <dirlookup>
80104b61:	83 c4 10             	add    $0x10,%esp
80104b64:	89 c6                	mov    %eax,%esi
80104b66:	85 c0                	test   %eax,%eax
80104b68:	74 56                	je     80104bc0 <create+0xa0>
    iunlockput(dp);
80104b6a:	83 ec 0c             	sub    $0xc,%esp
80104b6d:	53                   	push   %ebx
80104b6e:	e8 ed ce ff ff       	call   80101a60 <iunlockput>
    ilock(ip);
80104b73:	89 34 24             	mov    %esi,(%esp)
80104b76:	e8 55 cc ff ff       	call   801017d0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104b7b:	83 c4 10             	add    $0x10,%esp
80104b7e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104b83:	75 1b                	jne    80104ba0 <create+0x80>
80104b85:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104b8a:	75 14                	jne    80104ba0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b8f:	89 f0                	mov    %esi,%eax
80104b91:	5b                   	pop    %ebx
80104b92:	5e                   	pop    %esi
80104b93:	5f                   	pop    %edi
80104b94:	5d                   	pop    %ebp
80104b95:	c3                   	ret    
80104b96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b9d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104ba0:	83 ec 0c             	sub    $0xc,%esp
80104ba3:	56                   	push   %esi
    return 0;
80104ba4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104ba6:	e8 b5 ce ff ff       	call   80101a60 <iunlockput>
    return 0;
80104bab:	83 c4 10             	add    $0x10,%esp
}
80104bae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bb1:	89 f0                	mov    %esi,%eax
80104bb3:	5b                   	pop    %ebx
80104bb4:	5e                   	pop    %esi
80104bb5:	5f                   	pop    %edi
80104bb6:	5d                   	pop    %ebp
80104bb7:	c3                   	ret    
80104bb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bbf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104bc0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104bc4:	83 ec 08             	sub    $0x8,%esp
80104bc7:	50                   	push   %eax
80104bc8:	ff 33                	push   (%ebx)
80104bca:	e8 91 ca ff ff       	call   80101660 <ialloc>
80104bcf:	83 c4 10             	add    $0x10,%esp
80104bd2:	89 c6                	mov    %eax,%esi
80104bd4:	85 c0                	test   %eax,%eax
80104bd6:	0f 84 cd 00 00 00    	je     80104ca9 <create+0x189>
  ilock(ip);
80104bdc:	83 ec 0c             	sub    $0xc,%esp
80104bdf:	50                   	push   %eax
80104be0:	e8 eb cb ff ff       	call   801017d0 <ilock>
  ip->major = major;
80104be5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104be9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104bed:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104bf1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104bf5:	b8 01 00 00 00       	mov    $0x1,%eax
80104bfa:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104bfe:	89 34 24             	mov    %esi,(%esp)
80104c01:	e8 1a cb ff ff       	call   80101720 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104c06:	83 c4 10             	add    $0x10,%esp
80104c09:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104c0e:	74 30                	je     80104c40 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104c10:	83 ec 04             	sub    $0x4,%esp
80104c13:	ff 76 04             	push   0x4(%esi)
80104c16:	57                   	push   %edi
80104c17:	53                   	push   %ebx
80104c18:	e8 13 d4 ff ff       	call   80102030 <dirlink>
80104c1d:	83 c4 10             	add    $0x10,%esp
80104c20:	85 c0                	test   %eax,%eax
80104c22:	78 78                	js     80104c9c <create+0x17c>
  iunlockput(dp);
80104c24:	83 ec 0c             	sub    $0xc,%esp
80104c27:	53                   	push   %ebx
80104c28:	e8 33 ce ff ff       	call   80101a60 <iunlockput>
  return ip;
80104c2d:	83 c4 10             	add    $0x10,%esp
}
80104c30:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c33:	89 f0                	mov    %esi,%eax
80104c35:	5b                   	pop    %ebx
80104c36:	5e                   	pop    %esi
80104c37:	5f                   	pop    %edi
80104c38:	5d                   	pop    %ebp
80104c39:	c3                   	ret    
80104c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104c40:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104c43:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104c48:	53                   	push   %ebx
80104c49:	e8 d2 ca ff ff       	call   80101720 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104c4e:	83 c4 0c             	add    $0xc,%esp
80104c51:	ff 76 04             	push   0x4(%esi)
80104c54:	68 b8 79 10 80       	push   $0x801079b8
80104c59:	56                   	push   %esi
80104c5a:	e8 d1 d3 ff ff       	call   80102030 <dirlink>
80104c5f:	83 c4 10             	add    $0x10,%esp
80104c62:	85 c0                	test   %eax,%eax
80104c64:	78 18                	js     80104c7e <create+0x15e>
80104c66:	83 ec 04             	sub    $0x4,%esp
80104c69:	ff 73 04             	push   0x4(%ebx)
80104c6c:	68 b7 79 10 80       	push   $0x801079b7
80104c71:	56                   	push   %esi
80104c72:	e8 b9 d3 ff ff       	call   80102030 <dirlink>
80104c77:	83 c4 10             	add    $0x10,%esp
80104c7a:	85 c0                	test   %eax,%eax
80104c7c:	79 92                	jns    80104c10 <create+0xf0>
      panic("create dots");
80104c7e:	83 ec 0c             	sub    $0xc,%esp
80104c81:	68 ab 79 10 80       	push   $0x801079ab
80104c86:	e8 f5 b6 ff ff       	call   80100380 <panic>
80104c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c8f:	90                   	nop
}
80104c90:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104c93:	31 f6                	xor    %esi,%esi
}
80104c95:	5b                   	pop    %ebx
80104c96:	89 f0                	mov    %esi,%eax
80104c98:	5e                   	pop    %esi
80104c99:	5f                   	pop    %edi
80104c9a:	5d                   	pop    %ebp
80104c9b:	c3                   	ret    
    panic("create: dirlink");
80104c9c:	83 ec 0c             	sub    $0xc,%esp
80104c9f:	68 ba 79 10 80       	push   $0x801079ba
80104ca4:	e8 d7 b6 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104ca9:	83 ec 0c             	sub    $0xc,%esp
80104cac:	68 9c 79 10 80       	push   $0x8010799c
80104cb1:	e8 ca b6 ff ff       	call   80100380 <panic>
80104cb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cbd:	8d 76 00             	lea    0x0(%esi),%esi

80104cc0 <sys_dup>:
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	56                   	push   %esi
80104cc4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104cc5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104cc8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ccb:	50                   	push   %eax
80104ccc:	6a 00                	push   $0x0
80104cce:	e8 9d fc ff ff       	call   80104970 <argint>
80104cd3:	83 c4 10             	add    $0x10,%esp
80104cd6:	85 c0                	test   %eax,%eax
80104cd8:	78 36                	js     80104d10 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104cda:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104cde:	77 30                	ja     80104d10 <sys_dup+0x50>
80104ce0:	e8 db ec ff ff       	call   801039c0 <myproc>
80104ce5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ce8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104cec:	85 f6                	test   %esi,%esi
80104cee:	74 20                	je     80104d10 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104cf0:	e8 cb ec ff ff       	call   801039c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104cf5:	31 db                	xor    %ebx,%ebx
80104cf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cfe:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104d00:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104d04:	85 d2                	test   %edx,%edx
80104d06:	74 18                	je     80104d20 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104d08:	83 c3 01             	add    $0x1,%ebx
80104d0b:	83 fb 10             	cmp    $0x10,%ebx
80104d0e:	75 f0                	jne    80104d00 <sys_dup+0x40>
}
80104d10:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104d13:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104d18:	89 d8                	mov    %ebx,%eax
80104d1a:	5b                   	pop    %ebx
80104d1b:	5e                   	pop    %esi
80104d1c:	5d                   	pop    %ebp
80104d1d:	c3                   	ret    
80104d1e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104d20:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104d23:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104d27:	56                   	push   %esi
80104d28:	e8 73 c1 ff ff       	call   80100ea0 <filedup>
  return fd;
80104d2d:	83 c4 10             	add    $0x10,%esp
}
80104d30:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d33:	89 d8                	mov    %ebx,%eax
80104d35:	5b                   	pop    %ebx
80104d36:	5e                   	pop    %esi
80104d37:	5d                   	pop    %ebp
80104d38:	c3                   	ret    
80104d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d40 <sys_read>:
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	56                   	push   %esi
80104d44:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104d45:	8d 75 f4             	lea    -0xc(%ebp),%esi
{
80104d48:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d4b:	56                   	push   %esi
80104d4c:	6a 00                	push   $0x0
80104d4e:	e8 1d fc ff ff       	call   80104970 <argint>
80104d53:	83 c4 10             	add    $0x10,%esp
80104d56:	85 c0                	test   %eax,%eax
80104d58:	78 66                	js     80104dc0 <sys_read+0x80>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d5a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d5e:	77 60                	ja     80104dc0 <sys_read+0x80>
80104d60:	e8 5b ec ff ff       	call   801039c0 <myproc>
80104d65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d68:	8b 5c 90 28          	mov    0x28(%eax,%edx,4),%ebx
80104d6c:	85 db                	test   %ebx,%ebx
80104d6e:	74 50                	je     80104dc0 <sys_read+0x80>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d70:	83 ec 08             	sub    $0x8,%esp
80104d73:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d76:	50                   	push   %eax
80104d77:	6a 02                	push   $0x2
80104d79:	e8 f2 fb ff ff       	call   80104970 <argint>
80104d7e:	83 c4 10             	add    $0x10,%esp
80104d81:	85 c0                	test   %eax,%eax
80104d83:	78 3b                	js     80104dc0 <sys_read+0x80>
80104d85:	83 ec 04             	sub    $0x4,%esp
80104d88:	ff 75 f0             	push   -0x10(%ebp)
80104d8b:	56                   	push   %esi
80104d8c:	6a 01                	push   $0x1
80104d8e:	e8 2d fc ff ff       	call   801049c0 <argptr>
80104d93:	83 c4 10             	add    $0x10,%esp
80104d96:	85 c0                	test   %eax,%eax
80104d98:	78 26                	js     80104dc0 <sys_read+0x80>
  int bytes_read = fileread(f, p, n);
80104d9a:	83 ec 04             	sub    $0x4,%esp
80104d9d:	ff 75 f0             	push   -0x10(%ebp)
80104da0:	ff 75 f4             	push   -0xc(%ebp)
80104da3:	53                   	push   %ebx
80104da4:	e8 77 c2 ff ff       	call   80101020 <fileread>
  if (bytes_read > 0)
80104da9:	83 c4 10             	add    $0x10,%esp
80104dac:	85 c0                	test   %eax,%eax
80104dae:	7e 03                	jle    80104db3 <sys_read+0x73>
    f->read_bytes += bytes_read;
80104db0:	01 43 18             	add    %eax,0x18(%ebx)
}
80104db3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104db6:	5b                   	pop    %ebx
80104db7:	5e                   	pop    %esi
80104db8:	5d                   	pop    %ebp
80104db9:	c3                   	ret    
80104dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dc5:	eb ec                	jmp    80104db3 <sys_read+0x73>
80104dc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dce:	66 90                	xchg   %ax,%ax

80104dd0 <sys_write>:
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	56                   	push   %esi
80104dd4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104dd5:	8d 75 f4             	lea    -0xc(%ebp),%esi
{
80104dd8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ddb:	56                   	push   %esi
80104ddc:	6a 00                	push   $0x0
80104dde:	e8 8d fb ff ff       	call   80104970 <argint>
80104de3:	83 c4 10             	add    $0x10,%esp
80104de6:	85 c0                	test   %eax,%eax
80104de8:	78 66                	js     80104e50 <sys_write+0x80>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104dea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104dee:	77 60                	ja     80104e50 <sys_write+0x80>
80104df0:	e8 cb eb ff ff       	call   801039c0 <myproc>
80104df5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104df8:	8b 5c 90 28          	mov    0x28(%eax,%edx,4),%ebx
80104dfc:	85 db                	test   %ebx,%ebx
80104dfe:	74 50                	je     80104e50 <sys_write+0x80>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e00:	83 ec 08             	sub    $0x8,%esp
80104e03:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e06:	50                   	push   %eax
80104e07:	6a 02                	push   $0x2
80104e09:	e8 62 fb ff ff       	call   80104970 <argint>
80104e0e:	83 c4 10             	add    $0x10,%esp
80104e11:	85 c0                	test   %eax,%eax
80104e13:	78 3b                	js     80104e50 <sys_write+0x80>
80104e15:	83 ec 04             	sub    $0x4,%esp
80104e18:	ff 75 f0             	push   -0x10(%ebp)
80104e1b:	56                   	push   %esi
80104e1c:	6a 01                	push   $0x1
80104e1e:	e8 9d fb ff ff       	call   801049c0 <argptr>
80104e23:	83 c4 10             	add    $0x10,%esp
80104e26:	85 c0                	test   %eax,%eax
80104e28:	78 26                	js     80104e50 <sys_write+0x80>
  int bytes_written = filewrite(f, p, n);
80104e2a:	83 ec 04             	sub    $0x4,%esp
80104e2d:	ff 75 f0             	push   -0x10(%ebp)
80104e30:	ff 75 f4             	push   -0xc(%ebp)
80104e33:	53                   	push   %ebx
80104e34:	e8 77 c2 ff ff       	call   801010b0 <filewrite>
  if (bytes_written > 0)
80104e39:	83 c4 10             	add    $0x10,%esp
80104e3c:	85 c0                	test   %eax,%eax
80104e3e:	7e 03                	jle    80104e43 <sys_write+0x73>
    f->write_bytes += bytes_written;
80104e40:	01 43 1c             	add    %eax,0x1c(%ebx)
}
80104e43:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e46:	5b                   	pop    %ebx
80104e47:	5e                   	pop    %esi
80104e48:	5d                   	pop    %ebp
80104e49:	c3                   	ret    
80104e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104e50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e55:	eb ec                	jmp    80104e43 <sys_write+0x73>
80104e57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e5e:	66 90                	xchg   %ax,%ax

80104e60 <sys_close>:
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	56                   	push   %esi
80104e64:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e65:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e68:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e6b:	50                   	push   %eax
80104e6c:	6a 00                	push   $0x0
80104e6e:	e8 fd fa ff ff       	call   80104970 <argint>
80104e73:	83 c4 10             	add    $0x10,%esp
80104e76:	85 c0                	test   %eax,%eax
80104e78:	78 3e                	js     80104eb8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e7a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e7e:	77 38                	ja     80104eb8 <sys_close+0x58>
80104e80:	e8 3b eb ff ff       	call   801039c0 <myproc>
80104e85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e88:	8d 5a 08             	lea    0x8(%edx),%ebx
80104e8b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104e8f:	85 f6                	test   %esi,%esi
80104e91:	74 25                	je     80104eb8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104e93:	e8 28 eb ff ff       	call   801039c0 <myproc>
  fileclose(f);
80104e98:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104e9b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104ea2:	00 
  fileclose(f);
80104ea3:	56                   	push   %esi
80104ea4:	e8 47 c0 ff ff       	call   80100ef0 <fileclose>
  return 0;
80104ea9:	83 c4 10             	add    $0x10,%esp
80104eac:	31 c0                	xor    %eax,%eax
}
80104eae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104eb1:	5b                   	pop    %ebx
80104eb2:	5e                   	pop    %esi
80104eb3:	5d                   	pop    %ebp
80104eb4:	c3                   	ret    
80104eb5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104eb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ebd:	eb ef                	jmp    80104eae <sys_close+0x4e>
80104ebf:	90                   	nop

80104ec0 <sys_fstat>:
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	56                   	push   %esi
80104ec4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ec5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104ec8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ecb:	53                   	push   %ebx
80104ecc:	6a 00                	push   $0x0
80104ece:	e8 9d fa ff ff       	call   80104970 <argint>
80104ed3:	83 c4 10             	add    $0x10,%esp
80104ed6:	85 c0                	test   %eax,%eax
80104ed8:	78 46                	js     80104f20 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eda:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ede:	77 40                	ja     80104f20 <sys_fstat+0x60>
80104ee0:	e8 db ea ff ff       	call   801039c0 <myproc>
80104ee5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ee8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104eec:	85 f6                	test   %esi,%esi
80104eee:	74 30                	je     80104f20 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ef0:	83 ec 04             	sub    $0x4,%esp
80104ef3:	6a 14                	push   $0x14
80104ef5:	53                   	push   %ebx
80104ef6:	6a 01                	push   $0x1
80104ef8:	e8 c3 fa ff ff       	call   801049c0 <argptr>
80104efd:	83 c4 10             	add    $0x10,%esp
80104f00:	85 c0                	test   %eax,%eax
80104f02:	78 1c                	js     80104f20 <sys_fstat+0x60>
  return filestat(f, st);
80104f04:	83 ec 08             	sub    $0x8,%esp
80104f07:	ff 75 f4             	push   -0xc(%ebp)
80104f0a:	56                   	push   %esi
80104f0b:	e8 c0 c0 ff ff       	call   80100fd0 <filestat>
80104f10:	83 c4 10             	add    $0x10,%esp
}
80104f13:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f16:	5b                   	pop    %ebx
80104f17:	5e                   	pop    %esi
80104f18:	5d                   	pop    %ebp
80104f19:	c3                   	ret    
80104f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f25:	eb ec                	jmp    80104f13 <sys_fstat+0x53>
80104f27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f2e:	66 90                	xchg   %ax,%ax

80104f30 <sys_link>:
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	57                   	push   %edi
80104f34:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f35:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104f38:	53                   	push   %ebx
80104f39:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f3c:	50                   	push   %eax
80104f3d:	6a 00                	push   $0x0
80104f3f:	e8 ec fa ff ff       	call   80104a30 <argstr>
80104f44:	83 c4 10             	add    $0x10,%esp
80104f47:	85 c0                	test   %eax,%eax
80104f49:	0f 88 fb 00 00 00    	js     8010504a <sys_link+0x11a>
80104f4f:	83 ec 08             	sub    $0x8,%esp
80104f52:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104f55:	50                   	push   %eax
80104f56:	6a 01                	push   $0x1
80104f58:	e8 d3 fa ff ff       	call   80104a30 <argstr>
80104f5d:	83 c4 10             	add    $0x10,%esp
80104f60:	85 c0                	test   %eax,%eax
80104f62:	0f 88 e2 00 00 00    	js     8010504a <sys_link+0x11a>
  begin_op();
80104f68:	e8 43 de ff ff       	call   80102db0 <begin_op>
  if((ip = namei(old)) == 0){
80104f6d:	83 ec 0c             	sub    $0xc,%esp
80104f70:	ff 75 d4             	push   -0x2c(%ebp)
80104f73:	e8 78 d1 ff ff       	call   801020f0 <namei>
80104f78:	83 c4 10             	add    $0x10,%esp
80104f7b:	89 c3                	mov    %eax,%ebx
80104f7d:	85 c0                	test   %eax,%eax
80104f7f:	0f 84 e4 00 00 00    	je     80105069 <sys_link+0x139>
  ilock(ip);
80104f85:	83 ec 0c             	sub    $0xc,%esp
80104f88:	50                   	push   %eax
80104f89:	e8 42 c8 ff ff       	call   801017d0 <ilock>
  if(ip->type == T_DIR){
80104f8e:	83 c4 10             	add    $0x10,%esp
80104f91:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f96:	0f 84 b5 00 00 00    	je     80105051 <sys_link+0x121>
  iupdate(ip);
80104f9c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104f9f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104fa4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104fa7:	53                   	push   %ebx
80104fa8:	e8 73 c7 ff ff       	call   80101720 <iupdate>
  iunlock(ip);
80104fad:	89 1c 24             	mov    %ebx,(%esp)
80104fb0:	e8 fb c8 ff ff       	call   801018b0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104fb5:	58                   	pop    %eax
80104fb6:	5a                   	pop    %edx
80104fb7:	57                   	push   %edi
80104fb8:	ff 75 d0             	push   -0x30(%ebp)
80104fbb:	e8 50 d1 ff ff       	call   80102110 <nameiparent>
80104fc0:	83 c4 10             	add    $0x10,%esp
80104fc3:	89 c6                	mov    %eax,%esi
80104fc5:	85 c0                	test   %eax,%eax
80104fc7:	74 5b                	je     80105024 <sys_link+0xf4>
  ilock(dp);
80104fc9:	83 ec 0c             	sub    $0xc,%esp
80104fcc:	50                   	push   %eax
80104fcd:	e8 fe c7 ff ff       	call   801017d0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104fd2:	8b 03                	mov    (%ebx),%eax
80104fd4:	83 c4 10             	add    $0x10,%esp
80104fd7:	39 06                	cmp    %eax,(%esi)
80104fd9:	75 3d                	jne    80105018 <sys_link+0xe8>
80104fdb:	83 ec 04             	sub    $0x4,%esp
80104fde:	ff 73 04             	push   0x4(%ebx)
80104fe1:	57                   	push   %edi
80104fe2:	56                   	push   %esi
80104fe3:	e8 48 d0 ff ff       	call   80102030 <dirlink>
80104fe8:	83 c4 10             	add    $0x10,%esp
80104feb:	85 c0                	test   %eax,%eax
80104fed:	78 29                	js     80105018 <sys_link+0xe8>
  iunlockput(dp);
80104fef:	83 ec 0c             	sub    $0xc,%esp
80104ff2:	56                   	push   %esi
80104ff3:	e8 68 ca ff ff       	call   80101a60 <iunlockput>
  iput(ip);
80104ff8:	89 1c 24             	mov    %ebx,(%esp)
80104ffb:	e8 00 c9 ff ff       	call   80101900 <iput>
  end_op();
80105000:	e8 1b de ff ff       	call   80102e20 <end_op>
  return 0;
80105005:	83 c4 10             	add    $0x10,%esp
80105008:	31 c0                	xor    %eax,%eax
}
8010500a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010500d:	5b                   	pop    %ebx
8010500e:	5e                   	pop    %esi
8010500f:	5f                   	pop    %edi
80105010:	5d                   	pop    %ebp
80105011:	c3                   	ret    
80105012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105018:	83 ec 0c             	sub    $0xc,%esp
8010501b:	56                   	push   %esi
8010501c:	e8 3f ca ff ff       	call   80101a60 <iunlockput>
    goto bad;
80105021:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105024:	83 ec 0c             	sub    $0xc,%esp
80105027:	53                   	push   %ebx
80105028:	e8 a3 c7 ff ff       	call   801017d0 <ilock>
  ip->nlink--;
8010502d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105032:	89 1c 24             	mov    %ebx,(%esp)
80105035:	e8 e6 c6 ff ff       	call   80101720 <iupdate>
  iunlockput(ip);
8010503a:	89 1c 24             	mov    %ebx,(%esp)
8010503d:	e8 1e ca ff ff       	call   80101a60 <iunlockput>
  end_op();
80105042:	e8 d9 dd ff ff       	call   80102e20 <end_op>
  return -1;
80105047:	83 c4 10             	add    $0x10,%esp
8010504a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010504f:	eb b9                	jmp    8010500a <sys_link+0xda>
    iunlockput(ip);
80105051:	83 ec 0c             	sub    $0xc,%esp
80105054:	53                   	push   %ebx
80105055:	e8 06 ca ff ff       	call   80101a60 <iunlockput>
    end_op();
8010505a:	e8 c1 dd ff ff       	call   80102e20 <end_op>
    return -1;
8010505f:	83 c4 10             	add    $0x10,%esp
80105062:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105067:	eb a1                	jmp    8010500a <sys_link+0xda>
    end_op();
80105069:	e8 b2 dd ff ff       	call   80102e20 <end_op>
    return -1;
8010506e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105073:	eb 95                	jmp    8010500a <sys_link+0xda>
80105075:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010507c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105080 <sys_unlink>:
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	57                   	push   %edi
80105084:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105085:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105088:	53                   	push   %ebx
80105089:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010508c:	50                   	push   %eax
8010508d:	6a 00                	push   $0x0
8010508f:	e8 9c f9 ff ff       	call   80104a30 <argstr>
80105094:	83 c4 10             	add    $0x10,%esp
80105097:	85 c0                	test   %eax,%eax
80105099:	0f 88 7a 01 00 00    	js     80105219 <sys_unlink+0x199>
  begin_op();
8010509f:	e8 0c dd ff ff       	call   80102db0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801050a4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801050a7:	83 ec 08             	sub    $0x8,%esp
801050aa:	53                   	push   %ebx
801050ab:	ff 75 c0             	push   -0x40(%ebp)
801050ae:	e8 5d d0 ff ff       	call   80102110 <nameiparent>
801050b3:	83 c4 10             	add    $0x10,%esp
801050b6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801050b9:	85 c0                	test   %eax,%eax
801050bb:	0f 84 62 01 00 00    	je     80105223 <sys_unlink+0x1a3>
  ilock(dp);
801050c1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801050c4:	83 ec 0c             	sub    $0xc,%esp
801050c7:	57                   	push   %edi
801050c8:	e8 03 c7 ff ff       	call   801017d0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801050cd:	58                   	pop    %eax
801050ce:	5a                   	pop    %edx
801050cf:	68 b8 79 10 80       	push   $0x801079b8
801050d4:	53                   	push   %ebx
801050d5:	e8 36 cc ff ff       	call   80101d10 <namecmp>
801050da:	83 c4 10             	add    $0x10,%esp
801050dd:	85 c0                	test   %eax,%eax
801050df:	0f 84 fb 00 00 00    	je     801051e0 <sys_unlink+0x160>
801050e5:	83 ec 08             	sub    $0x8,%esp
801050e8:	68 b7 79 10 80       	push   $0x801079b7
801050ed:	53                   	push   %ebx
801050ee:	e8 1d cc ff ff       	call   80101d10 <namecmp>
801050f3:	83 c4 10             	add    $0x10,%esp
801050f6:	85 c0                	test   %eax,%eax
801050f8:	0f 84 e2 00 00 00    	je     801051e0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801050fe:	83 ec 04             	sub    $0x4,%esp
80105101:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105104:	50                   	push   %eax
80105105:	53                   	push   %ebx
80105106:	57                   	push   %edi
80105107:	e8 24 cc ff ff       	call   80101d30 <dirlookup>
8010510c:	83 c4 10             	add    $0x10,%esp
8010510f:	89 c3                	mov    %eax,%ebx
80105111:	85 c0                	test   %eax,%eax
80105113:	0f 84 c7 00 00 00    	je     801051e0 <sys_unlink+0x160>
  ilock(ip);
80105119:	83 ec 0c             	sub    $0xc,%esp
8010511c:	50                   	push   %eax
8010511d:	e8 ae c6 ff ff       	call   801017d0 <ilock>
  if(ip->nlink < 1)
80105122:	83 c4 10             	add    $0x10,%esp
80105125:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010512a:	0f 8e 1c 01 00 00    	jle    8010524c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105130:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105135:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105138:	74 66                	je     801051a0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010513a:	83 ec 04             	sub    $0x4,%esp
8010513d:	6a 10                	push   $0x10
8010513f:	6a 00                	push   $0x0
80105141:	57                   	push   %edi
80105142:	e8 69 f5 ff ff       	call   801046b0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105147:	6a 10                	push   $0x10
80105149:	ff 75 c4             	push   -0x3c(%ebp)
8010514c:	57                   	push   %edi
8010514d:	ff 75 b4             	push   -0x4c(%ebp)
80105150:	e8 8b ca ff ff       	call   80101be0 <writei>
80105155:	83 c4 20             	add    $0x20,%esp
80105158:	83 f8 10             	cmp    $0x10,%eax
8010515b:	0f 85 de 00 00 00    	jne    8010523f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105161:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105166:	0f 84 94 00 00 00    	je     80105200 <sys_unlink+0x180>
  iunlockput(dp);
8010516c:	83 ec 0c             	sub    $0xc,%esp
8010516f:	ff 75 b4             	push   -0x4c(%ebp)
80105172:	e8 e9 c8 ff ff       	call   80101a60 <iunlockput>
  ip->nlink--;
80105177:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010517c:	89 1c 24             	mov    %ebx,(%esp)
8010517f:	e8 9c c5 ff ff       	call   80101720 <iupdate>
  iunlockput(ip);
80105184:	89 1c 24             	mov    %ebx,(%esp)
80105187:	e8 d4 c8 ff ff       	call   80101a60 <iunlockput>
  end_op();
8010518c:	e8 8f dc ff ff       	call   80102e20 <end_op>
  return 0;
80105191:	83 c4 10             	add    $0x10,%esp
80105194:	31 c0                	xor    %eax,%eax
}
80105196:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105199:	5b                   	pop    %ebx
8010519a:	5e                   	pop    %esi
8010519b:	5f                   	pop    %edi
8010519c:	5d                   	pop    %ebp
8010519d:	c3                   	ret    
8010519e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801051a0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801051a4:	76 94                	jbe    8010513a <sys_unlink+0xba>
801051a6:	be 20 00 00 00       	mov    $0x20,%esi
801051ab:	eb 0b                	jmp    801051b8 <sys_unlink+0x138>
801051ad:	8d 76 00             	lea    0x0(%esi),%esi
801051b0:	83 c6 10             	add    $0x10,%esi
801051b3:	3b 73 58             	cmp    0x58(%ebx),%esi
801051b6:	73 82                	jae    8010513a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051b8:	6a 10                	push   $0x10
801051ba:	56                   	push   %esi
801051bb:	57                   	push   %edi
801051bc:	53                   	push   %ebx
801051bd:	e8 1e c9 ff ff       	call   80101ae0 <readi>
801051c2:	83 c4 10             	add    $0x10,%esp
801051c5:	83 f8 10             	cmp    $0x10,%eax
801051c8:	75 68                	jne    80105232 <sys_unlink+0x1b2>
    if(de.inum != 0)
801051ca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801051cf:	74 df                	je     801051b0 <sys_unlink+0x130>
    iunlockput(ip);
801051d1:	83 ec 0c             	sub    $0xc,%esp
801051d4:	53                   	push   %ebx
801051d5:	e8 86 c8 ff ff       	call   80101a60 <iunlockput>
    goto bad;
801051da:	83 c4 10             	add    $0x10,%esp
801051dd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801051e0:	83 ec 0c             	sub    $0xc,%esp
801051e3:	ff 75 b4             	push   -0x4c(%ebp)
801051e6:	e8 75 c8 ff ff       	call   80101a60 <iunlockput>
  end_op();
801051eb:	e8 30 dc ff ff       	call   80102e20 <end_op>
  return -1;
801051f0:	83 c4 10             	add    $0x10,%esp
801051f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051f8:	eb 9c                	jmp    80105196 <sys_unlink+0x116>
801051fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105200:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105203:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105206:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010520b:	50                   	push   %eax
8010520c:	e8 0f c5 ff ff       	call   80101720 <iupdate>
80105211:	83 c4 10             	add    $0x10,%esp
80105214:	e9 53 ff ff ff       	jmp    8010516c <sys_unlink+0xec>
    return -1;
80105219:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010521e:	e9 73 ff ff ff       	jmp    80105196 <sys_unlink+0x116>
    end_op();
80105223:	e8 f8 db ff ff       	call   80102e20 <end_op>
    return -1;
80105228:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010522d:	e9 64 ff ff ff       	jmp    80105196 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105232:	83 ec 0c             	sub    $0xc,%esp
80105235:	68 dc 79 10 80       	push   $0x801079dc
8010523a:	e8 41 b1 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010523f:	83 ec 0c             	sub    $0xc,%esp
80105242:	68 ee 79 10 80       	push   $0x801079ee
80105247:	e8 34 b1 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010524c:	83 ec 0c             	sub    $0xc,%esp
8010524f:	68 ca 79 10 80       	push   $0x801079ca
80105254:	e8 27 b1 ff ff       	call   80100380 <panic>
80105259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105260 <sys_open>:

int
sys_open(void)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	57                   	push   %edi
80105264:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105265:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105268:	53                   	push   %ebx
80105269:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010526c:	50                   	push   %eax
8010526d:	6a 00                	push   $0x0
8010526f:	e8 bc f7 ff ff       	call   80104a30 <argstr>
80105274:	83 c4 10             	add    $0x10,%esp
80105277:	85 c0                	test   %eax,%eax
80105279:	0f 88 8e 00 00 00    	js     8010530d <sys_open+0xad>
8010527f:	83 ec 08             	sub    $0x8,%esp
80105282:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105285:	50                   	push   %eax
80105286:	6a 01                	push   $0x1
80105288:	e8 e3 f6 ff ff       	call   80104970 <argint>
8010528d:	83 c4 10             	add    $0x10,%esp
80105290:	85 c0                	test   %eax,%eax
80105292:	78 79                	js     8010530d <sys_open+0xad>
    return -1;

  begin_op();
80105294:	e8 17 db ff ff       	call   80102db0 <begin_op>

  if(omode & O_CREATE){
80105299:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010529d:	75 79                	jne    80105318 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010529f:	83 ec 0c             	sub    $0xc,%esp
801052a2:	ff 75 e0             	push   -0x20(%ebp)
801052a5:	e8 46 ce ff ff       	call   801020f0 <namei>
801052aa:	83 c4 10             	add    $0x10,%esp
801052ad:	89 c6                	mov    %eax,%esi
801052af:	85 c0                	test   %eax,%eax
801052b1:	0f 84 7e 00 00 00    	je     80105335 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801052b7:	83 ec 0c             	sub    $0xc,%esp
801052ba:	50                   	push   %eax
801052bb:	e8 10 c5 ff ff       	call   801017d0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801052c0:	83 c4 10             	add    $0x10,%esp
801052c3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801052c8:	0f 84 c2 00 00 00    	je     80105390 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801052ce:	e8 5d bb ff ff       	call   80100e30 <filealloc>
801052d3:	89 c7                	mov    %eax,%edi
801052d5:	85 c0                	test   %eax,%eax
801052d7:	74 23                	je     801052fc <sys_open+0x9c>
  struct proc *curproc = myproc();
801052d9:	e8 e2 e6 ff ff       	call   801039c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801052de:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801052e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801052e4:	85 d2                	test   %edx,%edx
801052e6:	74 60                	je     80105348 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801052e8:	83 c3 01             	add    $0x1,%ebx
801052eb:	83 fb 10             	cmp    $0x10,%ebx
801052ee:	75 f0                	jne    801052e0 <sys_open+0x80>
    if(f)
      fileclose(f);
801052f0:	83 ec 0c             	sub    $0xc,%esp
801052f3:	57                   	push   %edi
801052f4:	e8 f7 bb ff ff       	call   80100ef0 <fileclose>
801052f9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801052fc:	83 ec 0c             	sub    $0xc,%esp
801052ff:	56                   	push   %esi
80105300:	e8 5b c7 ff ff       	call   80101a60 <iunlockput>
    end_op();
80105305:	e8 16 db ff ff       	call   80102e20 <end_op>
    return -1;
8010530a:	83 c4 10             	add    $0x10,%esp
8010530d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105312:	eb 6d                	jmp    80105381 <sys_open+0x121>
80105314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105318:	83 ec 0c             	sub    $0xc,%esp
8010531b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010531e:	31 c9                	xor    %ecx,%ecx
80105320:	ba 02 00 00 00       	mov    $0x2,%edx
80105325:	6a 00                	push   $0x0
80105327:	e8 f4 f7 ff ff       	call   80104b20 <create>
    if(ip == 0){
8010532c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010532f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105331:	85 c0                	test   %eax,%eax
80105333:	75 99                	jne    801052ce <sys_open+0x6e>
      end_op();
80105335:	e8 e6 da ff ff       	call   80102e20 <end_op>
      return -1;
8010533a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010533f:	eb 40                	jmp    80105381 <sys_open+0x121>
80105341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105348:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010534b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010534f:	56                   	push   %esi
80105350:	e8 5b c5 ff ff       	call   801018b0 <iunlock>
  end_op();
80105355:	e8 c6 da ff ff       	call   80102e20 <end_op>

  f->type = FD_INODE;
8010535a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105360:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105363:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105366:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105369:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010536b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105372:	f7 d0                	not    %eax
80105374:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105377:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010537a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010537d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105381:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105384:	89 d8                	mov    %ebx,%eax
80105386:	5b                   	pop    %ebx
80105387:	5e                   	pop    %esi
80105388:	5f                   	pop    %edi
80105389:	5d                   	pop    %ebp
8010538a:	c3                   	ret    
8010538b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010538f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105390:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105393:	85 c9                	test   %ecx,%ecx
80105395:	0f 84 33 ff ff ff    	je     801052ce <sys_open+0x6e>
8010539b:	e9 5c ff ff ff       	jmp    801052fc <sys_open+0x9c>

801053a0 <sys_mkdir>:

int
sys_mkdir(void)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801053a6:	e8 05 da ff ff       	call   80102db0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801053ab:	83 ec 08             	sub    $0x8,%esp
801053ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053b1:	50                   	push   %eax
801053b2:	6a 00                	push   $0x0
801053b4:	e8 77 f6 ff ff       	call   80104a30 <argstr>
801053b9:	83 c4 10             	add    $0x10,%esp
801053bc:	85 c0                	test   %eax,%eax
801053be:	78 30                	js     801053f0 <sys_mkdir+0x50>
801053c0:	83 ec 0c             	sub    $0xc,%esp
801053c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053c6:	31 c9                	xor    %ecx,%ecx
801053c8:	ba 01 00 00 00       	mov    $0x1,%edx
801053cd:	6a 00                	push   $0x0
801053cf:	e8 4c f7 ff ff       	call   80104b20 <create>
801053d4:	83 c4 10             	add    $0x10,%esp
801053d7:	85 c0                	test   %eax,%eax
801053d9:	74 15                	je     801053f0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801053db:	83 ec 0c             	sub    $0xc,%esp
801053de:	50                   	push   %eax
801053df:	e8 7c c6 ff ff       	call   80101a60 <iunlockput>
  end_op();
801053e4:	e8 37 da ff ff       	call   80102e20 <end_op>
  return 0;
801053e9:	83 c4 10             	add    $0x10,%esp
801053ec:	31 c0                	xor    %eax,%eax
}
801053ee:	c9                   	leave  
801053ef:	c3                   	ret    
    end_op();
801053f0:	e8 2b da ff ff       	call   80102e20 <end_op>
    return -1;
801053f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053fa:	c9                   	leave  
801053fb:	c3                   	ret    
801053fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105400 <sys_mknod>:

int
sys_mknod(void)
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105406:	e8 a5 d9 ff ff       	call   80102db0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010540b:	83 ec 08             	sub    $0x8,%esp
8010540e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105411:	50                   	push   %eax
80105412:	6a 00                	push   $0x0
80105414:	e8 17 f6 ff ff       	call   80104a30 <argstr>
80105419:	83 c4 10             	add    $0x10,%esp
8010541c:	85 c0                	test   %eax,%eax
8010541e:	78 60                	js     80105480 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105420:	83 ec 08             	sub    $0x8,%esp
80105423:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105426:	50                   	push   %eax
80105427:	6a 01                	push   $0x1
80105429:	e8 42 f5 ff ff       	call   80104970 <argint>
  if((argstr(0, &path)) < 0 ||
8010542e:	83 c4 10             	add    $0x10,%esp
80105431:	85 c0                	test   %eax,%eax
80105433:	78 4b                	js     80105480 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105435:	83 ec 08             	sub    $0x8,%esp
80105438:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010543b:	50                   	push   %eax
8010543c:	6a 02                	push   $0x2
8010543e:	e8 2d f5 ff ff       	call   80104970 <argint>
     argint(1, &major) < 0 ||
80105443:	83 c4 10             	add    $0x10,%esp
80105446:	85 c0                	test   %eax,%eax
80105448:	78 36                	js     80105480 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010544a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010544e:	83 ec 0c             	sub    $0xc,%esp
80105451:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105455:	ba 03 00 00 00       	mov    $0x3,%edx
8010545a:	50                   	push   %eax
8010545b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010545e:	e8 bd f6 ff ff       	call   80104b20 <create>
     argint(2, &minor) < 0 ||
80105463:	83 c4 10             	add    $0x10,%esp
80105466:	85 c0                	test   %eax,%eax
80105468:	74 16                	je     80105480 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010546a:	83 ec 0c             	sub    $0xc,%esp
8010546d:	50                   	push   %eax
8010546e:	e8 ed c5 ff ff       	call   80101a60 <iunlockput>
  end_op();
80105473:	e8 a8 d9 ff ff       	call   80102e20 <end_op>
  return 0;
80105478:	83 c4 10             	add    $0x10,%esp
8010547b:	31 c0                	xor    %eax,%eax
}
8010547d:	c9                   	leave  
8010547e:	c3                   	ret    
8010547f:	90                   	nop
    end_op();
80105480:	e8 9b d9 ff ff       	call   80102e20 <end_op>
    return -1;
80105485:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010548a:	c9                   	leave  
8010548b:	c3                   	ret    
8010548c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105490 <sys_chdir>:

int
sys_chdir(void)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	56                   	push   %esi
80105494:	53                   	push   %ebx
80105495:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105498:	e8 23 e5 ff ff       	call   801039c0 <myproc>
8010549d:	89 c6                	mov    %eax,%esi

  begin_op();
8010549f:	e8 0c d9 ff ff       	call   80102db0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801054a4:	83 ec 08             	sub    $0x8,%esp
801054a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054aa:	50                   	push   %eax
801054ab:	6a 00                	push   $0x0
801054ad:	e8 7e f5 ff ff       	call   80104a30 <argstr>
801054b2:	83 c4 10             	add    $0x10,%esp
801054b5:	85 c0                	test   %eax,%eax
801054b7:	78 77                	js     80105530 <sys_chdir+0xa0>
801054b9:	83 ec 0c             	sub    $0xc,%esp
801054bc:	ff 75 f4             	push   -0xc(%ebp)
801054bf:	e8 2c cc ff ff       	call   801020f0 <namei>
801054c4:	83 c4 10             	add    $0x10,%esp
801054c7:	89 c3                	mov    %eax,%ebx
801054c9:	85 c0                	test   %eax,%eax
801054cb:	74 63                	je     80105530 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801054cd:	83 ec 0c             	sub    $0xc,%esp
801054d0:	50                   	push   %eax
801054d1:	e8 fa c2 ff ff       	call   801017d0 <ilock>
  if(ip->type != T_DIR){
801054d6:	83 c4 10             	add    $0x10,%esp
801054d9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054de:	75 30                	jne    80105510 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801054e0:	83 ec 0c             	sub    $0xc,%esp
801054e3:	53                   	push   %ebx
801054e4:	e8 c7 c3 ff ff       	call   801018b0 <iunlock>
  iput(curproc->cwd);
801054e9:	58                   	pop    %eax
801054ea:	ff 76 68             	push   0x68(%esi)
801054ed:	e8 0e c4 ff ff       	call   80101900 <iput>
  end_op();
801054f2:	e8 29 d9 ff ff       	call   80102e20 <end_op>
  curproc->cwd = ip;
801054f7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801054fa:	83 c4 10             	add    $0x10,%esp
801054fd:	31 c0                	xor    %eax,%eax
}
801054ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105502:	5b                   	pop    %ebx
80105503:	5e                   	pop    %esi
80105504:	5d                   	pop    %ebp
80105505:	c3                   	ret    
80105506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010550d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105510:	83 ec 0c             	sub    $0xc,%esp
80105513:	53                   	push   %ebx
80105514:	e8 47 c5 ff ff       	call   80101a60 <iunlockput>
    end_op();
80105519:	e8 02 d9 ff ff       	call   80102e20 <end_op>
    return -1;
8010551e:	83 c4 10             	add    $0x10,%esp
80105521:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105526:	eb d7                	jmp    801054ff <sys_chdir+0x6f>
80105528:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010552f:	90                   	nop
    end_op();
80105530:	e8 eb d8 ff ff       	call   80102e20 <end_op>
    return -1;
80105535:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010553a:	eb c3                	jmp    801054ff <sys_chdir+0x6f>
8010553c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105540 <sys_exec>:

int
sys_exec(void)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	57                   	push   %edi
80105544:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105545:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010554b:	53                   	push   %ebx
8010554c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105552:	50                   	push   %eax
80105553:	6a 00                	push   $0x0
80105555:	e8 d6 f4 ff ff       	call   80104a30 <argstr>
8010555a:	83 c4 10             	add    $0x10,%esp
8010555d:	85 c0                	test   %eax,%eax
8010555f:	0f 88 87 00 00 00    	js     801055ec <sys_exec+0xac>
80105565:	83 ec 08             	sub    $0x8,%esp
80105568:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010556e:	50                   	push   %eax
8010556f:	6a 01                	push   $0x1
80105571:	e8 fa f3 ff ff       	call   80104970 <argint>
80105576:	83 c4 10             	add    $0x10,%esp
80105579:	85 c0                	test   %eax,%eax
8010557b:	78 6f                	js     801055ec <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010557d:	83 ec 04             	sub    $0x4,%esp
80105580:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105586:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105588:	68 80 00 00 00       	push   $0x80
8010558d:	6a 00                	push   $0x0
8010558f:	56                   	push   %esi
80105590:	e8 1b f1 ff ff       	call   801046b0 <memset>
80105595:	83 c4 10             	add    $0x10,%esp
80105598:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010559f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801055a0:	83 ec 08             	sub    $0x8,%esp
801055a3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801055a9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801055b0:	50                   	push   %eax
801055b1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801055b7:	01 f8                	add    %edi,%eax
801055b9:	50                   	push   %eax
801055ba:	e8 21 f3 ff ff       	call   801048e0 <fetchint>
801055bf:	83 c4 10             	add    $0x10,%esp
801055c2:	85 c0                	test   %eax,%eax
801055c4:	78 26                	js     801055ec <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801055c6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801055cc:	85 c0                	test   %eax,%eax
801055ce:	74 30                	je     80105600 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801055d0:	83 ec 08             	sub    $0x8,%esp
801055d3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801055d6:	52                   	push   %edx
801055d7:	50                   	push   %eax
801055d8:	e8 43 f3 ff ff       	call   80104920 <fetchstr>
801055dd:	83 c4 10             	add    $0x10,%esp
801055e0:	85 c0                	test   %eax,%eax
801055e2:	78 08                	js     801055ec <sys_exec+0xac>
  for(i=0;; i++){
801055e4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801055e7:	83 fb 20             	cmp    $0x20,%ebx
801055ea:	75 b4                	jne    801055a0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801055ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801055ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055f4:	5b                   	pop    %ebx
801055f5:	5e                   	pop    %esi
801055f6:	5f                   	pop    %edi
801055f7:	5d                   	pop    %ebp
801055f8:	c3                   	ret    
801055f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105600:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105607:	00 00 00 00 
  return exec(path, argv);
8010560b:	83 ec 08             	sub    $0x8,%esp
8010560e:	56                   	push   %esi
8010560f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105615:	e8 96 b4 ff ff       	call   80100ab0 <exec>
8010561a:	83 c4 10             	add    $0x10,%esp
}
8010561d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105620:	5b                   	pop    %ebx
80105621:	5e                   	pop    %esi
80105622:	5f                   	pop    %edi
80105623:	5d                   	pop    %ebp
80105624:	c3                   	ret    
80105625:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010562c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105630 <sys_pipe>:

int
sys_pipe(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	57                   	push   %edi
80105634:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105635:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105638:	53                   	push   %ebx
80105639:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010563c:	6a 08                	push   $0x8
8010563e:	50                   	push   %eax
8010563f:	6a 00                	push   $0x0
80105641:	e8 7a f3 ff ff       	call   801049c0 <argptr>
80105646:	83 c4 10             	add    $0x10,%esp
80105649:	85 c0                	test   %eax,%eax
8010564b:	78 4a                	js     80105697 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010564d:	83 ec 08             	sub    $0x8,%esp
80105650:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105653:	50                   	push   %eax
80105654:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105657:	50                   	push   %eax
80105658:	e8 23 de ff ff       	call   80103480 <pipealloc>
8010565d:	83 c4 10             	add    $0x10,%esp
80105660:	85 c0                	test   %eax,%eax
80105662:	78 33                	js     80105697 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105664:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105667:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105669:	e8 52 e3 ff ff       	call   801039c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010566e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105670:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105674:	85 f6                	test   %esi,%esi
80105676:	74 28                	je     801056a0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105678:	83 c3 01             	add    $0x1,%ebx
8010567b:	83 fb 10             	cmp    $0x10,%ebx
8010567e:	75 f0                	jne    80105670 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105680:	83 ec 0c             	sub    $0xc,%esp
80105683:	ff 75 e0             	push   -0x20(%ebp)
80105686:	e8 65 b8 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
8010568b:	58                   	pop    %eax
8010568c:	ff 75 e4             	push   -0x1c(%ebp)
8010568f:	e8 5c b8 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105694:	83 c4 10             	add    $0x10,%esp
80105697:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010569c:	eb 53                	jmp    801056f1 <sys_pipe+0xc1>
8010569e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801056a0:	8d 73 08             	lea    0x8(%ebx),%esi
801056a3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801056a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801056aa:	e8 11 e3 ff ff       	call   801039c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801056af:	31 d2                	xor    %edx,%edx
801056b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801056b8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801056bc:	85 c9                	test   %ecx,%ecx
801056be:	74 20                	je     801056e0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801056c0:	83 c2 01             	add    $0x1,%edx
801056c3:	83 fa 10             	cmp    $0x10,%edx
801056c6:	75 f0                	jne    801056b8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801056c8:	e8 f3 e2 ff ff       	call   801039c0 <myproc>
801056cd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801056d4:	00 
801056d5:	eb a9                	jmp    80105680 <sys_pipe+0x50>
801056d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056de:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801056e0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801056e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056e7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801056e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056ec:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801056ef:	31 c0                	xor    %eax,%eax
}
801056f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056f4:	5b                   	pop    %ebx
801056f5:	5e                   	pop    %esi
801056f6:	5f                   	pop    %edi
801056f7:	5d                   	pop    %ebp
801056f8:	c3                   	ret    
801056f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105700 <sys_getiostats>:

void sys_getiostats(void) {
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	83 ec 20             	sub    $0x20,%esp
    int fd;
    struct iostats *iost;

    if (argint(0, &fd) < 0 || argptr(1, (void*)&iost, sizeof(*iost)) < 0)
80105706:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105709:	50                   	push   %eax
8010570a:	6a 00                	push   $0x0
8010570c:	e8 5f f2 ff ff       	call   80104970 <argint>
80105711:	83 c4 10             	add    $0x10,%esp
80105714:	85 c0                	test   %eax,%eax
80105716:	78 4a                	js     80105762 <sys_getiostats+0x62>
80105718:	83 ec 04             	sub    $0x4,%esp
8010571b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010571e:	6a 08                	push   $0x8
80105720:	50                   	push   %eax
80105721:	6a 01                	push   $0x1
80105723:	e8 98 f2 ff ff       	call   801049c0 <argptr>
80105728:	83 c4 10             	add    $0x10,%esp
8010572b:	85 c0                	test   %eax,%eax
8010572d:	78 33                	js     80105762 <sys_getiostats+0x62>
        return;

    if (fd < 0 || fd >= NOFILE || myproc()->ofile[fd] == 0)
8010572f:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80105733:	77 2d                	ja     80105762 <sys_getiostats+0x62>
80105735:	e8 86 e2 ff ff       	call   801039c0 <myproc>
8010573a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010573d:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105741:	85 c0                	test   %eax,%eax
80105743:	74 1d                	je     80105762 <sys_getiostats+0x62>
        return;

    struct file *f = myproc()->ofile[fd];
80105745:	e8 76 e2 ff ff       	call   801039c0 <myproc>
8010574a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010574d:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax


    iost->read_bytes = f->read_bytes;
80105751:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105754:	8b 48 18             	mov    0x18(%eax),%ecx
80105757:	89 0a                	mov    %ecx,(%edx)
    iost->write_bytes = f->write_bytes;
80105759:	8b 50 1c             	mov    0x1c(%eax),%edx
8010575c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010575f:	89 50 04             	mov    %edx,0x4(%eax)

}
80105762:	c9                   	leave  
80105763:	c3                   	ret    
80105764:	66 90                	xchg   %ax,%ax
80105766:	66 90                	xchg   %ax,%ax
80105768:	66 90                	xchg   %ax,%ax
8010576a:	66 90                	xchg   %ax,%ax
8010576c:	66 90                	xchg   %ax,%ax
8010576e:	66 90                	xchg   %ax,%ax

80105770 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105770:	e9 eb e3 ff ff       	jmp    80103b60 <fork>
80105775:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010577c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105780 <sys_exit>:
}

int
sys_exit(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	83 ec 08             	sub    $0x8,%esp
  exit();
80105786:	e8 55 e6 ff ff       	call   80103de0 <exit>
  return 0;  // not reached
}
8010578b:	31 c0                	xor    %eax,%eax
8010578d:	c9                   	leave  
8010578e:	c3                   	ret    
8010578f:	90                   	nop

80105790 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105790:	e9 7b e7 ff ff       	jmp    80103f10 <wait>
80105795:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010579c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057a0 <sys_kill>:
}

int
sys_kill(void)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801057a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057a9:	50                   	push   %eax
801057aa:	6a 00                	push   $0x0
801057ac:	e8 bf f1 ff ff       	call   80104970 <argint>
801057b1:	83 c4 10             	add    $0x10,%esp
801057b4:	85 c0                	test   %eax,%eax
801057b6:	78 18                	js     801057d0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801057b8:	83 ec 0c             	sub    $0xc,%esp
801057bb:	ff 75 f4             	push   -0xc(%ebp)
801057be:	e8 ed e9 ff ff       	call   801041b0 <kill>
801057c3:	83 c4 10             	add    $0x10,%esp
}
801057c6:	c9                   	leave  
801057c7:	c3                   	ret    
801057c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057cf:	90                   	nop
801057d0:	c9                   	leave  
    return -1;
801057d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057d6:	c3                   	ret    
801057d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057de:	66 90                	xchg   %ax,%ax

801057e0 <sys_getpid>:

int
sys_getpid(void)
{
801057e0:	55                   	push   %ebp
801057e1:	89 e5                	mov    %esp,%ebp
801057e3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801057e6:	e8 d5 e1 ff ff       	call   801039c0 <myproc>
801057eb:	8b 40 10             	mov    0x10(%eax),%eax
}
801057ee:	c9                   	leave  
801057ef:	c3                   	ret    

801057f0 <sys_sbrk>:

int
sys_sbrk(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801057f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057f7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801057fa:	50                   	push   %eax
801057fb:	6a 00                	push   $0x0
801057fd:	e8 6e f1 ff ff       	call   80104970 <argint>
80105802:	83 c4 10             	add    $0x10,%esp
80105805:	85 c0                	test   %eax,%eax
80105807:	78 27                	js     80105830 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105809:	e8 b2 e1 ff ff       	call   801039c0 <myproc>
  if(growproc(n) < 0)
8010580e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105811:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105813:	ff 75 f4             	push   -0xc(%ebp)
80105816:	e8 c5 e2 ff ff       	call   80103ae0 <growproc>
8010581b:	83 c4 10             	add    $0x10,%esp
8010581e:	85 c0                	test   %eax,%eax
80105820:	78 0e                	js     80105830 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105822:	89 d8                	mov    %ebx,%eax
80105824:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105827:	c9                   	leave  
80105828:	c3                   	ret    
80105829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105830:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105835:	eb eb                	jmp    80105822 <sys_sbrk+0x32>
80105837:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010583e:	66 90                	xchg   %ax,%ax

80105840 <sys_sleep>:

int
sys_sleep(void)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105844:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105847:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010584a:	50                   	push   %eax
8010584b:	6a 00                	push   $0x0
8010584d:	e8 1e f1 ff ff       	call   80104970 <argint>
80105852:	83 c4 10             	add    $0x10,%esp
80105855:	85 c0                	test   %eax,%eax
80105857:	0f 88 8a 00 00 00    	js     801058e7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010585d:	83 ec 0c             	sub    $0xc,%esp
80105860:	68 a0 3f 11 80       	push   $0x80113fa0
80105865:	e8 86 ed ff ff       	call   801045f0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010586a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010586d:	8b 1d 80 3f 11 80    	mov    0x80113f80,%ebx
  while(ticks - ticks0 < n){
80105873:	83 c4 10             	add    $0x10,%esp
80105876:	85 d2                	test   %edx,%edx
80105878:	75 27                	jne    801058a1 <sys_sleep+0x61>
8010587a:	eb 54                	jmp    801058d0 <sys_sleep+0x90>
8010587c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105880:	83 ec 08             	sub    $0x8,%esp
80105883:	68 a0 3f 11 80       	push   $0x80113fa0
80105888:	68 80 3f 11 80       	push   $0x80113f80
8010588d:	e8 fe e7 ff ff       	call   80104090 <sleep>
  while(ticks - ticks0 < n){
80105892:	a1 80 3f 11 80       	mov    0x80113f80,%eax
80105897:	83 c4 10             	add    $0x10,%esp
8010589a:	29 d8                	sub    %ebx,%eax
8010589c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010589f:	73 2f                	jae    801058d0 <sys_sleep+0x90>
    if(myproc()->killed){
801058a1:	e8 1a e1 ff ff       	call   801039c0 <myproc>
801058a6:	8b 40 24             	mov    0x24(%eax),%eax
801058a9:	85 c0                	test   %eax,%eax
801058ab:	74 d3                	je     80105880 <sys_sleep+0x40>
      release(&tickslock);
801058ad:	83 ec 0c             	sub    $0xc,%esp
801058b0:	68 a0 3f 11 80       	push   $0x80113fa0
801058b5:	e8 d6 ec ff ff       	call   80104590 <release>
  }
  release(&tickslock);
  return 0;
}
801058ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801058bd:	83 c4 10             	add    $0x10,%esp
801058c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058c5:	c9                   	leave  
801058c6:	c3                   	ret    
801058c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ce:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801058d0:	83 ec 0c             	sub    $0xc,%esp
801058d3:	68 a0 3f 11 80       	push   $0x80113fa0
801058d8:	e8 b3 ec ff ff       	call   80104590 <release>
  return 0;
801058dd:	83 c4 10             	add    $0x10,%esp
801058e0:	31 c0                	xor    %eax,%eax
}
801058e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058e5:	c9                   	leave  
801058e6:	c3                   	ret    
    return -1;
801058e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058ec:	eb f4                	jmp    801058e2 <sys_sleep+0xa2>
801058ee:	66 90                	xchg   %ax,%ax

801058f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	53                   	push   %ebx
801058f4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801058f7:	68 a0 3f 11 80       	push   $0x80113fa0
801058fc:	e8 ef ec ff ff       	call   801045f0 <acquire>
  xticks = ticks;
80105901:	8b 1d 80 3f 11 80    	mov    0x80113f80,%ebx
  release(&tickslock);
80105907:	c7 04 24 a0 3f 11 80 	movl   $0x80113fa0,(%esp)
8010590e:	e8 7d ec ff ff       	call   80104590 <release>
  return xticks;
}
80105913:	89 d8                	mov    %ebx,%eax
80105915:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105918:	c9                   	leave  
80105919:	c3                   	ret    

8010591a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010591a:	1e                   	push   %ds
  pushl %es
8010591b:	06                   	push   %es
  pushl %fs
8010591c:	0f a0                	push   %fs
  pushl %gs
8010591e:	0f a8                	push   %gs
  pushal
80105920:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105921:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105925:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105927:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105929:	54                   	push   %esp
  call trap
8010592a:	e8 c1 00 00 00       	call   801059f0 <trap>
  addl $4, %esp
8010592f:	83 c4 04             	add    $0x4,%esp

80105932 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105932:	61                   	popa   
  popl %gs
80105933:	0f a9                	pop    %gs
  popl %fs
80105935:	0f a1                	pop    %fs
  popl %es
80105937:	07                   	pop    %es
  popl %ds
80105938:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105939:	83 c4 08             	add    $0x8,%esp
  iret
8010593c:	cf                   	iret   
8010593d:	66 90                	xchg   %ax,%ax
8010593f:	90                   	nop

80105940 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105940:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105941:	31 c0                	xor    %eax,%eax
{
80105943:	89 e5                	mov    %esp,%ebp
80105945:	83 ec 08             	sub    $0x8,%esp
80105948:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010594f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105950:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105957:	c7 04 c5 e2 3f 11 80 	movl   $0x8e000008,-0x7feec01e(,%eax,8)
8010595e:	08 00 00 8e 
80105962:	66 89 14 c5 e0 3f 11 	mov    %dx,-0x7feec020(,%eax,8)
80105969:	80 
8010596a:	c1 ea 10             	shr    $0x10,%edx
8010596d:	66 89 14 c5 e6 3f 11 	mov    %dx,-0x7feec01a(,%eax,8)
80105974:	80 
  for(i = 0; i < 256; i++)
80105975:	83 c0 01             	add    $0x1,%eax
80105978:	3d 00 01 00 00       	cmp    $0x100,%eax
8010597d:	75 d1                	jne    80105950 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010597f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105982:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105987:	c7 05 e2 41 11 80 08 	movl   $0xef000008,0x801141e2
8010598e:	00 00 ef 
  initlock(&tickslock, "time");
80105991:	68 fd 79 10 80       	push   $0x801079fd
80105996:	68 a0 3f 11 80       	push   $0x80113fa0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010599b:	66 a3 e0 41 11 80    	mov    %ax,0x801141e0
801059a1:	c1 e8 10             	shr    $0x10,%eax
801059a4:	66 a3 e6 41 11 80    	mov    %ax,0x801141e6
  initlock(&tickslock, "time");
801059aa:	e8 71 ea ff ff       	call   80104420 <initlock>
}
801059af:	83 c4 10             	add    $0x10,%esp
801059b2:	c9                   	leave  
801059b3:	c3                   	ret    
801059b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059bf:	90                   	nop

801059c0 <idtinit>:

void
idtinit(void)
{
801059c0:	55                   	push   %ebp
  pd[0] = size-1;
801059c1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801059c6:	89 e5                	mov    %esp,%ebp
801059c8:	83 ec 10             	sub    $0x10,%esp
801059cb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801059cf:	b8 e0 3f 11 80       	mov    $0x80113fe0,%eax
801059d4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801059d8:	c1 e8 10             	shr    $0x10,%eax
801059db:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801059df:	8d 45 fa             	lea    -0x6(%ebp),%eax
801059e2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801059e5:	c9                   	leave  
801059e6:	c3                   	ret    
801059e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ee:	66 90                	xchg   %ax,%ax

801059f0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	57                   	push   %edi
801059f4:	56                   	push   %esi
801059f5:	53                   	push   %ebx
801059f6:	83 ec 1c             	sub    $0x1c,%esp
801059f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801059fc:	8b 43 30             	mov    0x30(%ebx),%eax
801059ff:	83 f8 40             	cmp    $0x40,%eax
80105a02:	0f 84 68 01 00 00    	je     80105b70 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105a08:	83 e8 20             	sub    $0x20,%eax
80105a0b:	83 f8 1f             	cmp    $0x1f,%eax
80105a0e:	0f 87 8c 00 00 00    	ja     80105aa0 <trap+0xb0>
80105a14:	ff 24 85 a4 7a 10 80 	jmp    *-0x7fef855c(,%eax,4)
80105a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a1f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105a20:	e8 6b c8 ff ff       	call   80102290 <ideintr>
    lapiceoi();
80105a25:	e8 36 cf ff ff       	call   80102960 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a2a:	e8 91 df ff ff       	call   801039c0 <myproc>
80105a2f:	85 c0                	test   %eax,%eax
80105a31:	74 1d                	je     80105a50 <trap+0x60>
80105a33:	e8 88 df ff ff       	call   801039c0 <myproc>
80105a38:	8b 50 24             	mov    0x24(%eax),%edx
80105a3b:	85 d2                	test   %edx,%edx
80105a3d:	74 11                	je     80105a50 <trap+0x60>
80105a3f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a43:	83 e0 03             	and    $0x3,%eax
80105a46:	66 83 f8 03          	cmp    $0x3,%ax
80105a4a:	0f 84 e8 01 00 00    	je     80105c38 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105a50:	e8 6b df ff ff       	call   801039c0 <myproc>
80105a55:	85 c0                	test   %eax,%eax
80105a57:	74 0f                	je     80105a68 <trap+0x78>
80105a59:	e8 62 df ff ff       	call   801039c0 <myproc>
80105a5e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105a62:	0f 84 b8 00 00 00    	je     80105b20 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a68:	e8 53 df ff ff       	call   801039c0 <myproc>
80105a6d:	85 c0                	test   %eax,%eax
80105a6f:	74 1d                	je     80105a8e <trap+0x9e>
80105a71:	e8 4a df ff ff       	call   801039c0 <myproc>
80105a76:	8b 40 24             	mov    0x24(%eax),%eax
80105a79:	85 c0                	test   %eax,%eax
80105a7b:	74 11                	je     80105a8e <trap+0x9e>
80105a7d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a81:	83 e0 03             	and    $0x3,%eax
80105a84:	66 83 f8 03          	cmp    $0x3,%ax
80105a88:	0f 84 0f 01 00 00    	je     80105b9d <trap+0x1ad>
    exit();
}
80105a8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a91:	5b                   	pop    %ebx
80105a92:	5e                   	pop    %esi
80105a93:	5f                   	pop    %edi
80105a94:	5d                   	pop    %ebp
80105a95:	c3                   	ret    
80105a96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a9d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105aa0:	e8 1b df ff ff       	call   801039c0 <myproc>
80105aa5:	8b 7b 38             	mov    0x38(%ebx),%edi
80105aa8:	85 c0                	test   %eax,%eax
80105aaa:	0f 84 a2 01 00 00    	je     80105c52 <trap+0x262>
80105ab0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105ab4:	0f 84 98 01 00 00    	je     80105c52 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105aba:	0f 20 d1             	mov    %cr2,%ecx
80105abd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ac0:	e8 db de ff ff       	call   801039a0 <cpuid>
80105ac5:	8b 73 30             	mov    0x30(%ebx),%esi
80105ac8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105acb:	8b 43 34             	mov    0x34(%ebx),%eax
80105ace:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105ad1:	e8 ea de ff ff       	call   801039c0 <myproc>
80105ad6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105ad9:	e8 e2 de ff ff       	call   801039c0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ade:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ae1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ae4:	51                   	push   %ecx
80105ae5:	57                   	push   %edi
80105ae6:	52                   	push   %edx
80105ae7:	ff 75 e4             	push   -0x1c(%ebp)
80105aea:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105aeb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105aee:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105af1:	56                   	push   %esi
80105af2:	ff 70 10             	push   0x10(%eax)
80105af5:	68 60 7a 10 80       	push   $0x80107a60
80105afa:	e8 a1 ab ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105aff:	83 c4 20             	add    $0x20,%esp
80105b02:	e8 b9 de ff ff       	call   801039c0 <myproc>
80105b07:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b0e:	e8 ad de ff ff       	call   801039c0 <myproc>
80105b13:	85 c0                	test   %eax,%eax
80105b15:	0f 85 18 ff ff ff    	jne    80105a33 <trap+0x43>
80105b1b:	e9 30 ff ff ff       	jmp    80105a50 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105b20:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105b24:	0f 85 3e ff ff ff    	jne    80105a68 <trap+0x78>
    yield();
80105b2a:	e8 11 e5 ff ff       	call   80104040 <yield>
80105b2f:	e9 34 ff ff ff       	jmp    80105a68 <trap+0x78>
80105b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105b38:	8b 7b 38             	mov    0x38(%ebx),%edi
80105b3b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105b3f:	e8 5c de ff ff       	call   801039a0 <cpuid>
80105b44:	57                   	push   %edi
80105b45:	56                   	push   %esi
80105b46:	50                   	push   %eax
80105b47:	68 08 7a 10 80       	push   $0x80107a08
80105b4c:	e8 4f ab ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105b51:	e8 0a ce ff ff       	call   80102960 <lapiceoi>
    break;
80105b56:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b59:	e8 62 de ff ff       	call   801039c0 <myproc>
80105b5e:	85 c0                	test   %eax,%eax
80105b60:	0f 85 cd fe ff ff    	jne    80105a33 <trap+0x43>
80105b66:	e9 e5 fe ff ff       	jmp    80105a50 <trap+0x60>
80105b6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b6f:	90                   	nop
    if(myproc()->killed)
80105b70:	e8 4b de ff ff       	call   801039c0 <myproc>
80105b75:	8b 70 24             	mov    0x24(%eax),%esi
80105b78:	85 f6                	test   %esi,%esi
80105b7a:	0f 85 c8 00 00 00    	jne    80105c48 <trap+0x258>
    myproc()->tf = tf;
80105b80:	e8 3b de ff ff       	call   801039c0 <myproc>
80105b85:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105b88:	e8 23 ef ff ff       	call   80104ab0 <syscall>
    if(myproc()->killed)
80105b8d:	e8 2e de ff ff       	call   801039c0 <myproc>
80105b92:	8b 48 24             	mov    0x24(%eax),%ecx
80105b95:	85 c9                	test   %ecx,%ecx
80105b97:	0f 84 f1 fe ff ff    	je     80105a8e <trap+0x9e>
}
80105b9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ba0:	5b                   	pop    %ebx
80105ba1:	5e                   	pop    %esi
80105ba2:	5f                   	pop    %edi
80105ba3:	5d                   	pop    %ebp
      exit();
80105ba4:	e9 37 e2 ff ff       	jmp    80103de0 <exit>
80105ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105bb0:	e8 3b 02 00 00       	call   80105df0 <uartintr>
    lapiceoi();
80105bb5:	e8 a6 cd ff ff       	call   80102960 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bba:	e8 01 de ff ff       	call   801039c0 <myproc>
80105bbf:	85 c0                	test   %eax,%eax
80105bc1:	0f 85 6c fe ff ff    	jne    80105a33 <trap+0x43>
80105bc7:	e9 84 fe ff ff       	jmp    80105a50 <trap+0x60>
80105bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105bd0:	e8 4b cc ff ff       	call   80102820 <kbdintr>
    lapiceoi();
80105bd5:	e8 86 cd ff ff       	call   80102960 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bda:	e8 e1 dd ff ff       	call   801039c0 <myproc>
80105bdf:	85 c0                	test   %eax,%eax
80105be1:	0f 85 4c fe ff ff    	jne    80105a33 <trap+0x43>
80105be7:	e9 64 fe ff ff       	jmp    80105a50 <trap+0x60>
80105bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105bf0:	e8 ab dd ff ff       	call   801039a0 <cpuid>
80105bf5:	85 c0                	test   %eax,%eax
80105bf7:	0f 85 28 fe ff ff    	jne    80105a25 <trap+0x35>
      acquire(&tickslock);
80105bfd:	83 ec 0c             	sub    $0xc,%esp
80105c00:	68 a0 3f 11 80       	push   $0x80113fa0
80105c05:	e8 e6 e9 ff ff       	call   801045f0 <acquire>
      wakeup(&ticks);
80105c0a:	c7 04 24 80 3f 11 80 	movl   $0x80113f80,(%esp)
      ticks++;
80105c11:	83 05 80 3f 11 80 01 	addl   $0x1,0x80113f80
      wakeup(&ticks);
80105c18:	e8 33 e5 ff ff       	call   80104150 <wakeup>
      release(&tickslock);
80105c1d:	c7 04 24 a0 3f 11 80 	movl   $0x80113fa0,(%esp)
80105c24:	e8 67 e9 ff ff       	call   80104590 <release>
80105c29:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105c2c:	e9 f4 fd ff ff       	jmp    80105a25 <trap+0x35>
80105c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105c38:	e8 a3 e1 ff ff       	call   80103de0 <exit>
80105c3d:	e9 0e fe ff ff       	jmp    80105a50 <trap+0x60>
80105c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105c48:	e8 93 e1 ff ff       	call   80103de0 <exit>
80105c4d:	e9 2e ff ff ff       	jmp    80105b80 <trap+0x190>
80105c52:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105c55:	e8 46 dd ff ff       	call   801039a0 <cpuid>
80105c5a:	83 ec 0c             	sub    $0xc,%esp
80105c5d:	56                   	push   %esi
80105c5e:	57                   	push   %edi
80105c5f:	50                   	push   %eax
80105c60:	ff 73 30             	push   0x30(%ebx)
80105c63:	68 2c 7a 10 80       	push   $0x80107a2c
80105c68:	e8 33 aa ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105c6d:	83 c4 14             	add    $0x14,%esp
80105c70:	68 02 7a 10 80       	push   $0x80107a02
80105c75:	e8 06 a7 ff ff       	call   80100380 <panic>
80105c7a:	66 90                	xchg   %ax,%ax
80105c7c:	66 90                	xchg   %ax,%ax
80105c7e:	66 90                	xchg   %ax,%ax

80105c80 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105c80:	a1 e0 47 11 80       	mov    0x801147e0,%eax
80105c85:	85 c0                	test   %eax,%eax
80105c87:	74 17                	je     80105ca0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c89:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c8e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105c8f:	a8 01                	test   $0x1,%al
80105c91:	74 0d                	je     80105ca0 <uartgetc+0x20>
80105c93:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c98:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105c99:	0f b6 c0             	movzbl %al,%eax
80105c9c:	c3                   	ret    
80105c9d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105ca0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ca5:	c3                   	ret    
80105ca6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cad:	8d 76 00             	lea    0x0(%esi),%esi

80105cb0 <uartinit>:
{
80105cb0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105cb1:	31 c9                	xor    %ecx,%ecx
80105cb3:	89 c8                	mov    %ecx,%eax
80105cb5:	89 e5                	mov    %esp,%ebp
80105cb7:	57                   	push   %edi
80105cb8:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105cbd:	56                   	push   %esi
80105cbe:	89 fa                	mov    %edi,%edx
80105cc0:	53                   	push   %ebx
80105cc1:	83 ec 1c             	sub    $0x1c,%esp
80105cc4:	ee                   	out    %al,(%dx)
80105cc5:	be fb 03 00 00       	mov    $0x3fb,%esi
80105cca:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105ccf:	89 f2                	mov    %esi,%edx
80105cd1:	ee                   	out    %al,(%dx)
80105cd2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105cd7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cdc:	ee                   	out    %al,(%dx)
80105cdd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105ce2:	89 c8                	mov    %ecx,%eax
80105ce4:	89 da                	mov    %ebx,%edx
80105ce6:	ee                   	out    %al,(%dx)
80105ce7:	b8 03 00 00 00       	mov    $0x3,%eax
80105cec:	89 f2                	mov    %esi,%edx
80105cee:	ee                   	out    %al,(%dx)
80105cef:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105cf4:	89 c8                	mov    %ecx,%eax
80105cf6:	ee                   	out    %al,(%dx)
80105cf7:	b8 01 00 00 00       	mov    $0x1,%eax
80105cfc:	89 da                	mov    %ebx,%edx
80105cfe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105cff:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d04:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105d05:	3c ff                	cmp    $0xff,%al
80105d07:	74 78                	je     80105d81 <uartinit+0xd1>
  uart = 1;
80105d09:	c7 05 e0 47 11 80 01 	movl   $0x1,0x801147e0
80105d10:	00 00 00 
80105d13:	89 fa                	mov    %edi,%edx
80105d15:	ec                   	in     (%dx),%al
80105d16:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d1b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105d1c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105d1f:	bf 24 7b 10 80       	mov    $0x80107b24,%edi
80105d24:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105d29:	6a 00                	push   $0x0
80105d2b:	6a 04                	push   $0x4
80105d2d:	e8 9e c7 ff ff       	call   801024d0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105d32:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105d36:	83 c4 10             	add    $0x10,%esp
80105d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80105d40:	a1 e0 47 11 80       	mov    0x801147e0,%eax
80105d45:	bb 80 00 00 00       	mov    $0x80,%ebx
80105d4a:	85 c0                	test   %eax,%eax
80105d4c:	75 14                	jne    80105d62 <uartinit+0xb2>
80105d4e:	eb 23                	jmp    80105d73 <uartinit+0xc3>
    microdelay(10);
80105d50:	83 ec 0c             	sub    $0xc,%esp
80105d53:	6a 0a                	push   $0xa
80105d55:	e8 26 cc ff ff       	call   80102980 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105d5a:	83 c4 10             	add    $0x10,%esp
80105d5d:	83 eb 01             	sub    $0x1,%ebx
80105d60:	74 07                	je     80105d69 <uartinit+0xb9>
80105d62:	89 f2                	mov    %esi,%edx
80105d64:	ec                   	in     (%dx),%al
80105d65:	a8 20                	test   $0x20,%al
80105d67:	74 e7                	je     80105d50 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105d69:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105d6d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d72:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105d73:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105d77:	83 c7 01             	add    $0x1,%edi
80105d7a:	88 45 e7             	mov    %al,-0x19(%ebp)
80105d7d:	84 c0                	test   %al,%al
80105d7f:	75 bf                	jne    80105d40 <uartinit+0x90>
}
80105d81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d84:	5b                   	pop    %ebx
80105d85:	5e                   	pop    %esi
80105d86:	5f                   	pop    %edi
80105d87:	5d                   	pop    %ebp
80105d88:	c3                   	ret    
80105d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d90 <uartputc>:
  if(!uart)
80105d90:	a1 e0 47 11 80       	mov    0x801147e0,%eax
80105d95:	85 c0                	test   %eax,%eax
80105d97:	74 47                	je     80105de0 <uartputc+0x50>
{
80105d99:	55                   	push   %ebp
80105d9a:	89 e5                	mov    %esp,%ebp
80105d9c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d9d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105da2:	53                   	push   %ebx
80105da3:	bb 80 00 00 00       	mov    $0x80,%ebx
80105da8:	eb 18                	jmp    80105dc2 <uartputc+0x32>
80105daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105db0:	83 ec 0c             	sub    $0xc,%esp
80105db3:	6a 0a                	push   $0xa
80105db5:	e8 c6 cb ff ff       	call   80102980 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105dba:	83 c4 10             	add    $0x10,%esp
80105dbd:	83 eb 01             	sub    $0x1,%ebx
80105dc0:	74 07                	je     80105dc9 <uartputc+0x39>
80105dc2:	89 f2                	mov    %esi,%edx
80105dc4:	ec                   	in     (%dx),%al
80105dc5:	a8 20                	test   $0x20,%al
80105dc7:	74 e7                	je     80105db0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105dc9:	8b 45 08             	mov    0x8(%ebp),%eax
80105dcc:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105dd1:	ee                   	out    %al,(%dx)
}
80105dd2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105dd5:	5b                   	pop    %ebx
80105dd6:	5e                   	pop    %esi
80105dd7:	5d                   	pop    %ebp
80105dd8:	c3                   	ret    
80105dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105de0:	c3                   	ret    
80105de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105de8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105def:	90                   	nop

80105df0 <uartintr>:

void
uartintr(void)
{
80105df0:	55                   	push   %ebp
80105df1:	89 e5                	mov    %esp,%ebp
80105df3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105df6:	68 80 5c 10 80       	push   $0x80105c80
80105dfb:	e8 80 aa ff ff       	call   80100880 <consoleintr>
}
80105e00:	83 c4 10             	add    $0x10,%esp
80105e03:	c9                   	leave  
80105e04:	c3                   	ret    

80105e05 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105e05:	6a 00                	push   $0x0
  pushl $0
80105e07:	6a 00                	push   $0x0
  jmp alltraps
80105e09:	e9 0c fb ff ff       	jmp    8010591a <alltraps>

80105e0e <vector1>:
.globl vector1
vector1:
  pushl $0
80105e0e:	6a 00                	push   $0x0
  pushl $1
80105e10:	6a 01                	push   $0x1
  jmp alltraps
80105e12:	e9 03 fb ff ff       	jmp    8010591a <alltraps>

80105e17 <vector2>:
.globl vector2
vector2:
  pushl $0
80105e17:	6a 00                	push   $0x0
  pushl $2
80105e19:	6a 02                	push   $0x2
  jmp alltraps
80105e1b:	e9 fa fa ff ff       	jmp    8010591a <alltraps>

80105e20 <vector3>:
.globl vector3
vector3:
  pushl $0
80105e20:	6a 00                	push   $0x0
  pushl $3
80105e22:	6a 03                	push   $0x3
  jmp alltraps
80105e24:	e9 f1 fa ff ff       	jmp    8010591a <alltraps>

80105e29 <vector4>:
.globl vector4
vector4:
  pushl $0
80105e29:	6a 00                	push   $0x0
  pushl $4
80105e2b:	6a 04                	push   $0x4
  jmp alltraps
80105e2d:	e9 e8 fa ff ff       	jmp    8010591a <alltraps>

80105e32 <vector5>:
.globl vector5
vector5:
  pushl $0
80105e32:	6a 00                	push   $0x0
  pushl $5
80105e34:	6a 05                	push   $0x5
  jmp alltraps
80105e36:	e9 df fa ff ff       	jmp    8010591a <alltraps>

80105e3b <vector6>:
.globl vector6
vector6:
  pushl $0
80105e3b:	6a 00                	push   $0x0
  pushl $6
80105e3d:	6a 06                	push   $0x6
  jmp alltraps
80105e3f:	e9 d6 fa ff ff       	jmp    8010591a <alltraps>

80105e44 <vector7>:
.globl vector7
vector7:
  pushl $0
80105e44:	6a 00                	push   $0x0
  pushl $7
80105e46:	6a 07                	push   $0x7
  jmp alltraps
80105e48:	e9 cd fa ff ff       	jmp    8010591a <alltraps>

80105e4d <vector8>:
.globl vector8
vector8:
  pushl $8
80105e4d:	6a 08                	push   $0x8
  jmp alltraps
80105e4f:	e9 c6 fa ff ff       	jmp    8010591a <alltraps>

80105e54 <vector9>:
.globl vector9
vector9:
  pushl $0
80105e54:	6a 00                	push   $0x0
  pushl $9
80105e56:	6a 09                	push   $0x9
  jmp alltraps
80105e58:	e9 bd fa ff ff       	jmp    8010591a <alltraps>

80105e5d <vector10>:
.globl vector10
vector10:
  pushl $10
80105e5d:	6a 0a                	push   $0xa
  jmp alltraps
80105e5f:	e9 b6 fa ff ff       	jmp    8010591a <alltraps>

80105e64 <vector11>:
.globl vector11
vector11:
  pushl $11
80105e64:	6a 0b                	push   $0xb
  jmp alltraps
80105e66:	e9 af fa ff ff       	jmp    8010591a <alltraps>

80105e6b <vector12>:
.globl vector12
vector12:
  pushl $12
80105e6b:	6a 0c                	push   $0xc
  jmp alltraps
80105e6d:	e9 a8 fa ff ff       	jmp    8010591a <alltraps>

80105e72 <vector13>:
.globl vector13
vector13:
  pushl $13
80105e72:	6a 0d                	push   $0xd
  jmp alltraps
80105e74:	e9 a1 fa ff ff       	jmp    8010591a <alltraps>

80105e79 <vector14>:
.globl vector14
vector14:
  pushl $14
80105e79:	6a 0e                	push   $0xe
  jmp alltraps
80105e7b:	e9 9a fa ff ff       	jmp    8010591a <alltraps>

80105e80 <vector15>:
.globl vector15
vector15:
  pushl $0
80105e80:	6a 00                	push   $0x0
  pushl $15
80105e82:	6a 0f                	push   $0xf
  jmp alltraps
80105e84:	e9 91 fa ff ff       	jmp    8010591a <alltraps>

80105e89 <vector16>:
.globl vector16
vector16:
  pushl $0
80105e89:	6a 00                	push   $0x0
  pushl $16
80105e8b:	6a 10                	push   $0x10
  jmp alltraps
80105e8d:	e9 88 fa ff ff       	jmp    8010591a <alltraps>

80105e92 <vector17>:
.globl vector17
vector17:
  pushl $17
80105e92:	6a 11                	push   $0x11
  jmp alltraps
80105e94:	e9 81 fa ff ff       	jmp    8010591a <alltraps>

80105e99 <vector18>:
.globl vector18
vector18:
  pushl $0
80105e99:	6a 00                	push   $0x0
  pushl $18
80105e9b:	6a 12                	push   $0x12
  jmp alltraps
80105e9d:	e9 78 fa ff ff       	jmp    8010591a <alltraps>

80105ea2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105ea2:	6a 00                	push   $0x0
  pushl $19
80105ea4:	6a 13                	push   $0x13
  jmp alltraps
80105ea6:	e9 6f fa ff ff       	jmp    8010591a <alltraps>

80105eab <vector20>:
.globl vector20
vector20:
  pushl $0
80105eab:	6a 00                	push   $0x0
  pushl $20
80105ead:	6a 14                	push   $0x14
  jmp alltraps
80105eaf:	e9 66 fa ff ff       	jmp    8010591a <alltraps>

80105eb4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105eb4:	6a 00                	push   $0x0
  pushl $21
80105eb6:	6a 15                	push   $0x15
  jmp alltraps
80105eb8:	e9 5d fa ff ff       	jmp    8010591a <alltraps>

80105ebd <vector22>:
.globl vector22
vector22:
  pushl $0
80105ebd:	6a 00                	push   $0x0
  pushl $22
80105ebf:	6a 16                	push   $0x16
  jmp alltraps
80105ec1:	e9 54 fa ff ff       	jmp    8010591a <alltraps>

80105ec6 <vector23>:
.globl vector23
vector23:
  pushl $0
80105ec6:	6a 00                	push   $0x0
  pushl $23
80105ec8:	6a 17                	push   $0x17
  jmp alltraps
80105eca:	e9 4b fa ff ff       	jmp    8010591a <alltraps>

80105ecf <vector24>:
.globl vector24
vector24:
  pushl $0
80105ecf:	6a 00                	push   $0x0
  pushl $24
80105ed1:	6a 18                	push   $0x18
  jmp alltraps
80105ed3:	e9 42 fa ff ff       	jmp    8010591a <alltraps>

80105ed8 <vector25>:
.globl vector25
vector25:
  pushl $0
80105ed8:	6a 00                	push   $0x0
  pushl $25
80105eda:	6a 19                	push   $0x19
  jmp alltraps
80105edc:	e9 39 fa ff ff       	jmp    8010591a <alltraps>

80105ee1 <vector26>:
.globl vector26
vector26:
  pushl $0
80105ee1:	6a 00                	push   $0x0
  pushl $26
80105ee3:	6a 1a                	push   $0x1a
  jmp alltraps
80105ee5:	e9 30 fa ff ff       	jmp    8010591a <alltraps>

80105eea <vector27>:
.globl vector27
vector27:
  pushl $0
80105eea:	6a 00                	push   $0x0
  pushl $27
80105eec:	6a 1b                	push   $0x1b
  jmp alltraps
80105eee:	e9 27 fa ff ff       	jmp    8010591a <alltraps>

80105ef3 <vector28>:
.globl vector28
vector28:
  pushl $0
80105ef3:	6a 00                	push   $0x0
  pushl $28
80105ef5:	6a 1c                	push   $0x1c
  jmp alltraps
80105ef7:	e9 1e fa ff ff       	jmp    8010591a <alltraps>

80105efc <vector29>:
.globl vector29
vector29:
  pushl $0
80105efc:	6a 00                	push   $0x0
  pushl $29
80105efe:	6a 1d                	push   $0x1d
  jmp alltraps
80105f00:	e9 15 fa ff ff       	jmp    8010591a <alltraps>

80105f05 <vector30>:
.globl vector30
vector30:
  pushl $0
80105f05:	6a 00                	push   $0x0
  pushl $30
80105f07:	6a 1e                	push   $0x1e
  jmp alltraps
80105f09:	e9 0c fa ff ff       	jmp    8010591a <alltraps>

80105f0e <vector31>:
.globl vector31
vector31:
  pushl $0
80105f0e:	6a 00                	push   $0x0
  pushl $31
80105f10:	6a 1f                	push   $0x1f
  jmp alltraps
80105f12:	e9 03 fa ff ff       	jmp    8010591a <alltraps>

80105f17 <vector32>:
.globl vector32
vector32:
  pushl $0
80105f17:	6a 00                	push   $0x0
  pushl $32
80105f19:	6a 20                	push   $0x20
  jmp alltraps
80105f1b:	e9 fa f9 ff ff       	jmp    8010591a <alltraps>

80105f20 <vector33>:
.globl vector33
vector33:
  pushl $0
80105f20:	6a 00                	push   $0x0
  pushl $33
80105f22:	6a 21                	push   $0x21
  jmp alltraps
80105f24:	e9 f1 f9 ff ff       	jmp    8010591a <alltraps>

80105f29 <vector34>:
.globl vector34
vector34:
  pushl $0
80105f29:	6a 00                	push   $0x0
  pushl $34
80105f2b:	6a 22                	push   $0x22
  jmp alltraps
80105f2d:	e9 e8 f9 ff ff       	jmp    8010591a <alltraps>

80105f32 <vector35>:
.globl vector35
vector35:
  pushl $0
80105f32:	6a 00                	push   $0x0
  pushl $35
80105f34:	6a 23                	push   $0x23
  jmp alltraps
80105f36:	e9 df f9 ff ff       	jmp    8010591a <alltraps>

80105f3b <vector36>:
.globl vector36
vector36:
  pushl $0
80105f3b:	6a 00                	push   $0x0
  pushl $36
80105f3d:	6a 24                	push   $0x24
  jmp alltraps
80105f3f:	e9 d6 f9 ff ff       	jmp    8010591a <alltraps>

80105f44 <vector37>:
.globl vector37
vector37:
  pushl $0
80105f44:	6a 00                	push   $0x0
  pushl $37
80105f46:	6a 25                	push   $0x25
  jmp alltraps
80105f48:	e9 cd f9 ff ff       	jmp    8010591a <alltraps>

80105f4d <vector38>:
.globl vector38
vector38:
  pushl $0
80105f4d:	6a 00                	push   $0x0
  pushl $38
80105f4f:	6a 26                	push   $0x26
  jmp alltraps
80105f51:	e9 c4 f9 ff ff       	jmp    8010591a <alltraps>

80105f56 <vector39>:
.globl vector39
vector39:
  pushl $0
80105f56:	6a 00                	push   $0x0
  pushl $39
80105f58:	6a 27                	push   $0x27
  jmp alltraps
80105f5a:	e9 bb f9 ff ff       	jmp    8010591a <alltraps>

80105f5f <vector40>:
.globl vector40
vector40:
  pushl $0
80105f5f:	6a 00                	push   $0x0
  pushl $40
80105f61:	6a 28                	push   $0x28
  jmp alltraps
80105f63:	e9 b2 f9 ff ff       	jmp    8010591a <alltraps>

80105f68 <vector41>:
.globl vector41
vector41:
  pushl $0
80105f68:	6a 00                	push   $0x0
  pushl $41
80105f6a:	6a 29                	push   $0x29
  jmp alltraps
80105f6c:	e9 a9 f9 ff ff       	jmp    8010591a <alltraps>

80105f71 <vector42>:
.globl vector42
vector42:
  pushl $0
80105f71:	6a 00                	push   $0x0
  pushl $42
80105f73:	6a 2a                	push   $0x2a
  jmp alltraps
80105f75:	e9 a0 f9 ff ff       	jmp    8010591a <alltraps>

80105f7a <vector43>:
.globl vector43
vector43:
  pushl $0
80105f7a:	6a 00                	push   $0x0
  pushl $43
80105f7c:	6a 2b                	push   $0x2b
  jmp alltraps
80105f7e:	e9 97 f9 ff ff       	jmp    8010591a <alltraps>

80105f83 <vector44>:
.globl vector44
vector44:
  pushl $0
80105f83:	6a 00                	push   $0x0
  pushl $44
80105f85:	6a 2c                	push   $0x2c
  jmp alltraps
80105f87:	e9 8e f9 ff ff       	jmp    8010591a <alltraps>

80105f8c <vector45>:
.globl vector45
vector45:
  pushl $0
80105f8c:	6a 00                	push   $0x0
  pushl $45
80105f8e:	6a 2d                	push   $0x2d
  jmp alltraps
80105f90:	e9 85 f9 ff ff       	jmp    8010591a <alltraps>

80105f95 <vector46>:
.globl vector46
vector46:
  pushl $0
80105f95:	6a 00                	push   $0x0
  pushl $46
80105f97:	6a 2e                	push   $0x2e
  jmp alltraps
80105f99:	e9 7c f9 ff ff       	jmp    8010591a <alltraps>

80105f9e <vector47>:
.globl vector47
vector47:
  pushl $0
80105f9e:	6a 00                	push   $0x0
  pushl $47
80105fa0:	6a 2f                	push   $0x2f
  jmp alltraps
80105fa2:	e9 73 f9 ff ff       	jmp    8010591a <alltraps>

80105fa7 <vector48>:
.globl vector48
vector48:
  pushl $0
80105fa7:	6a 00                	push   $0x0
  pushl $48
80105fa9:	6a 30                	push   $0x30
  jmp alltraps
80105fab:	e9 6a f9 ff ff       	jmp    8010591a <alltraps>

80105fb0 <vector49>:
.globl vector49
vector49:
  pushl $0
80105fb0:	6a 00                	push   $0x0
  pushl $49
80105fb2:	6a 31                	push   $0x31
  jmp alltraps
80105fb4:	e9 61 f9 ff ff       	jmp    8010591a <alltraps>

80105fb9 <vector50>:
.globl vector50
vector50:
  pushl $0
80105fb9:	6a 00                	push   $0x0
  pushl $50
80105fbb:	6a 32                	push   $0x32
  jmp alltraps
80105fbd:	e9 58 f9 ff ff       	jmp    8010591a <alltraps>

80105fc2 <vector51>:
.globl vector51
vector51:
  pushl $0
80105fc2:	6a 00                	push   $0x0
  pushl $51
80105fc4:	6a 33                	push   $0x33
  jmp alltraps
80105fc6:	e9 4f f9 ff ff       	jmp    8010591a <alltraps>

80105fcb <vector52>:
.globl vector52
vector52:
  pushl $0
80105fcb:	6a 00                	push   $0x0
  pushl $52
80105fcd:	6a 34                	push   $0x34
  jmp alltraps
80105fcf:	e9 46 f9 ff ff       	jmp    8010591a <alltraps>

80105fd4 <vector53>:
.globl vector53
vector53:
  pushl $0
80105fd4:	6a 00                	push   $0x0
  pushl $53
80105fd6:	6a 35                	push   $0x35
  jmp alltraps
80105fd8:	e9 3d f9 ff ff       	jmp    8010591a <alltraps>

80105fdd <vector54>:
.globl vector54
vector54:
  pushl $0
80105fdd:	6a 00                	push   $0x0
  pushl $54
80105fdf:	6a 36                	push   $0x36
  jmp alltraps
80105fe1:	e9 34 f9 ff ff       	jmp    8010591a <alltraps>

80105fe6 <vector55>:
.globl vector55
vector55:
  pushl $0
80105fe6:	6a 00                	push   $0x0
  pushl $55
80105fe8:	6a 37                	push   $0x37
  jmp alltraps
80105fea:	e9 2b f9 ff ff       	jmp    8010591a <alltraps>

80105fef <vector56>:
.globl vector56
vector56:
  pushl $0
80105fef:	6a 00                	push   $0x0
  pushl $56
80105ff1:	6a 38                	push   $0x38
  jmp alltraps
80105ff3:	e9 22 f9 ff ff       	jmp    8010591a <alltraps>

80105ff8 <vector57>:
.globl vector57
vector57:
  pushl $0
80105ff8:	6a 00                	push   $0x0
  pushl $57
80105ffa:	6a 39                	push   $0x39
  jmp alltraps
80105ffc:	e9 19 f9 ff ff       	jmp    8010591a <alltraps>

80106001 <vector58>:
.globl vector58
vector58:
  pushl $0
80106001:	6a 00                	push   $0x0
  pushl $58
80106003:	6a 3a                	push   $0x3a
  jmp alltraps
80106005:	e9 10 f9 ff ff       	jmp    8010591a <alltraps>

8010600a <vector59>:
.globl vector59
vector59:
  pushl $0
8010600a:	6a 00                	push   $0x0
  pushl $59
8010600c:	6a 3b                	push   $0x3b
  jmp alltraps
8010600e:	e9 07 f9 ff ff       	jmp    8010591a <alltraps>

80106013 <vector60>:
.globl vector60
vector60:
  pushl $0
80106013:	6a 00                	push   $0x0
  pushl $60
80106015:	6a 3c                	push   $0x3c
  jmp alltraps
80106017:	e9 fe f8 ff ff       	jmp    8010591a <alltraps>

8010601c <vector61>:
.globl vector61
vector61:
  pushl $0
8010601c:	6a 00                	push   $0x0
  pushl $61
8010601e:	6a 3d                	push   $0x3d
  jmp alltraps
80106020:	e9 f5 f8 ff ff       	jmp    8010591a <alltraps>

80106025 <vector62>:
.globl vector62
vector62:
  pushl $0
80106025:	6a 00                	push   $0x0
  pushl $62
80106027:	6a 3e                	push   $0x3e
  jmp alltraps
80106029:	e9 ec f8 ff ff       	jmp    8010591a <alltraps>

8010602e <vector63>:
.globl vector63
vector63:
  pushl $0
8010602e:	6a 00                	push   $0x0
  pushl $63
80106030:	6a 3f                	push   $0x3f
  jmp alltraps
80106032:	e9 e3 f8 ff ff       	jmp    8010591a <alltraps>

80106037 <vector64>:
.globl vector64
vector64:
  pushl $0
80106037:	6a 00                	push   $0x0
  pushl $64
80106039:	6a 40                	push   $0x40
  jmp alltraps
8010603b:	e9 da f8 ff ff       	jmp    8010591a <alltraps>

80106040 <vector65>:
.globl vector65
vector65:
  pushl $0
80106040:	6a 00                	push   $0x0
  pushl $65
80106042:	6a 41                	push   $0x41
  jmp alltraps
80106044:	e9 d1 f8 ff ff       	jmp    8010591a <alltraps>

80106049 <vector66>:
.globl vector66
vector66:
  pushl $0
80106049:	6a 00                	push   $0x0
  pushl $66
8010604b:	6a 42                	push   $0x42
  jmp alltraps
8010604d:	e9 c8 f8 ff ff       	jmp    8010591a <alltraps>

80106052 <vector67>:
.globl vector67
vector67:
  pushl $0
80106052:	6a 00                	push   $0x0
  pushl $67
80106054:	6a 43                	push   $0x43
  jmp alltraps
80106056:	e9 bf f8 ff ff       	jmp    8010591a <alltraps>

8010605b <vector68>:
.globl vector68
vector68:
  pushl $0
8010605b:	6a 00                	push   $0x0
  pushl $68
8010605d:	6a 44                	push   $0x44
  jmp alltraps
8010605f:	e9 b6 f8 ff ff       	jmp    8010591a <alltraps>

80106064 <vector69>:
.globl vector69
vector69:
  pushl $0
80106064:	6a 00                	push   $0x0
  pushl $69
80106066:	6a 45                	push   $0x45
  jmp alltraps
80106068:	e9 ad f8 ff ff       	jmp    8010591a <alltraps>

8010606d <vector70>:
.globl vector70
vector70:
  pushl $0
8010606d:	6a 00                	push   $0x0
  pushl $70
8010606f:	6a 46                	push   $0x46
  jmp alltraps
80106071:	e9 a4 f8 ff ff       	jmp    8010591a <alltraps>

80106076 <vector71>:
.globl vector71
vector71:
  pushl $0
80106076:	6a 00                	push   $0x0
  pushl $71
80106078:	6a 47                	push   $0x47
  jmp alltraps
8010607a:	e9 9b f8 ff ff       	jmp    8010591a <alltraps>

8010607f <vector72>:
.globl vector72
vector72:
  pushl $0
8010607f:	6a 00                	push   $0x0
  pushl $72
80106081:	6a 48                	push   $0x48
  jmp alltraps
80106083:	e9 92 f8 ff ff       	jmp    8010591a <alltraps>

80106088 <vector73>:
.globl vector73
vector73:
  pushl $0
80106088:	6a 00                	push   $0x0
  pushl $73
8010608a:	6a 49                	push   $0x49
  jmp alltraps
8010608c:	e9 89 f8 ff ff       	jmp    8010591a <alltraps>

80106091 <vector74>:
.globl vector74
vector74:
  pushl $0
80106091:	6a 00                	push   $0x0
  pushl $74
80106093:	6a 4a                	push   $0x4a
  jmp alltraps
80106095:	e9 80 f8 ff ff       	jmp    8010591a <alltraps>

8010609a <vector75>:
.globl vector75
vector75:
  pushl $0
8010609a:	6a 00                	push   $0x0
  pushl $75
8010609c:	6a 4b                	push   $0x4b
  jmp alltraps
8010609e:	e9 77 f8 ff ff       	jmp    8010591a <alltraps>

801060a3 <vector76>:
.globl vector76
vector76:
  pushl $0
801060a3:	6a 00                	push   $0x0
  pushl $76
801060a5:	6a 4c                	push   $0x4c
  jmp alltraps
801060a7:	e9 6e f8 ff ff       	jmp    8010591a <alltraps>

801060ac <vector77>:
.globl vector77
vector77:
  pushl $0
801060ac:	6a 00                	push   $0x0
  pushl $77
801060ae:	6a 4d                	push   $0x4d
  jmp alltraps
801060b0:	e9 65 f8 ff ff       	jmp    8010591a <alltraps>

801060b5 <vector78>:
.globl vector78
vector78:
  pushl $0
801060b5:	6a 00                	push   $0x0
  pushl $78
801060b7:	6a 4e                	push   $0x4e
  jmp alltraps
801060b9:	e9 5c f8 ff ff       	jmp    8010591a <alltraps>

801060be <vector79>:
.globl vector79
vector79:
  pushl $0
801060be:	6a 00                	push   $0x0
  pushl $79
801060c0:	6a 4f                	push   $0x4f
  jmp alltraps
801060c2:	e9 53 f8 ff ff       	jmp    8010591a <alltraps>

801060c7 <vector80>:
.globl vector80
vector80:
  pushl $0
801060c7:	6a 00                	push   $0x0
  pushl $80
801060c9:	6a 50                	push   $0x50
  jmp alltraps
801060cb:	e9 4a f8 ff ff       	jmp    8010591a <alltraps>

801060d0 <vector81>:
.globl vector81
vector81:
  pushl $0
801060d0:	6a 00                	push   $0x0
  pushl $81
801060d2:	6a 51                	push   $0x51
  jmp alltraps
801060d4:	e9 41 f8 ff ff       	jmp    8010591a <alltraps>

801060d9 <vector82>:
.globl vector82
vector82:
  pushl $0
801060d9:	6a 00                	push   $0x0
  pushl $82
801060db:	6a 52                	push   $0x52
  jmp alltraps
801060dd:	e9 38 f8 ff ff       	jmp    8010591a <alltraps>

801060e2 <vector83>:
.globl vector83
vector83:
  pushl $0
801060e2:	6a 00                	push   $0x0
  pushl $83
801060e4:	6a 53                	push   $0x53
  jmp alltraps
801060e6:	e9 2f f8 ff ff       	jmp    8010591a <alltraps>

801060eb <vector84>:
.globl vector84
vector84:
  pushl $0
801060eb:	6a 00                	push   $0x0
  pushl $84
801060ed:	6a 54                	push   $0x54
  jmp alltraps
801060ef:	e9 26 f8 ff ff       	jmp    8010591a <alltraps>

801060f4 <vector85>:
.globl vector85
vector85:
  pushl $0
801060f4:	6a 00                	push   $0x0
  pushl $85
801060f6:	6a 55                	push   $0x55
  jmp alltraps
801060f8:	e9 1d f8 ff ff       	jmp    8010591a <alltraps>

801060fd <vector86>:
.globl vector86
vector86:
  pushl $0
801060fd:	6a 00                	push   $0x0
  pushl $86
801060ff:	6a 56                	push   $0x56
  jmp alltraps
80106101:	e9 14 f8 ff ff       	jmp    8010591a <alltraps>

80106106 <vector87>:
.globl vector87
vector87:
  pushl $0
80106106:	6a 00                	push   $0x0
  pushl $87
80106108:	6a 57                	push   $0x57
  jmp alltraps
8010610a:	e9 0b f8 ff ff       	jmp    8010591a <alltraps>

8010610f <vector88>:
.globl vector88
vector88:
  pushl $0
8010610f:	6a 00                	push   $0x0
  pushl $88
80106111:	6a 58                	push   $0x58
  jmp alltraps
80106113:	e9 02 f8 ff ff       	jmp    8010591a <alltraps>

80106118 <vector89>:
.globl vector89
vector89:
  pushl $0
80106118:	6a 00                	push   $0x0
  pushl $89
8010611a:	6a 59                	push   $0x59
  jmp alltraps
8010611c:	e9 f9 f7 ff ff       	jmp    8010591a <alltraps>

80106121 <vector90>:
.globl vector90
vector90:
  pushl $0
80106121:	6a 00                	push   $0x0
  pushl $90
80106123:	6a 5a                	push   $0x5a
  jmp alltraps
80106125:	e9 f0 f7 ff ff       	jmp    8010591a <alltraps>

8010612a <vector91>:
.globl vector91
vector91:
  pushl $0
8010612a:	6a 00                	push   $0x0
  pushl $91
8010612c:	6a 5b                	push   $0x5b
  jmp alltraps
8010612e:	e9 e7 f7 ff ff       	jmp    8010591a <alltraps>

80106133 <vector92>:
.globl vector92
vector92:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $92
80106135:	6a 5c                	push   $0x5c
  jmp alltraps
80106137:	e9 de f7 ff ff       	jmp    8010591a <alltraps>

8010613c <vector93>:
.globl vector93
vector93:
  pushl $0
8010613c:	6a 00                	push   $0x0
  pushl $93
8010613e:	6a 5d                	push   $0x5d
  jmp alltraps
80106140:	e9 d5 f7 ff ff       	jmp    8010591a <alltraps>

80106145 <vector94>:
.globl vector94
vector94:
  pushl $0
80106145:	6a 00                	push   $0x0
  pushl $94
80106147:	6a 5e                	push   $0x5e
  jmp alltraps
80106149:	e9 cc f7 ff ff       	jmp    8010591a <alltraps>

8010614e <vector95>:
.globl vector95
vector95:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $95
80106150:	6a 5f                	push   $0x5f
  jmp alltraps
80106152:	e9 c3 f7 ff ff       	jmp    8010591a <alltraps>

80106157 <vector96>:
.globl vector96
vector96:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $96
80106159:	6a 60                	push   $0x60
  jmp alltraps
8010615b:	e9 ba f7 ff ff       	jmp    8010591a <alltraps>

80106160 <vector97>:
.globl vector97
vector97:
  pushl $0
80106160:	6a 00                	push   $0x0
  pushl $97
80106162:	6a 61                	push   $0x61
  jmp alltraps
80106164:	e9 b1 f7 ff ff       	jmp    8010591a <alltraps>

80106169 <vector98>:
.globl vector98
vector98:
  pushl $0
80106169:	6a 00                	push   $0x0
  pushl $98
8010616b:	6a 62                	push   $0x62
  jmp alltraps
8010616d:	e9 a8 f7 ff ff       	jmp    8010591a <alltraps>

80106172 <vector99>:
.globl vector99
vector99:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $99
80106174:	6a 63                	push   $0x63
  jmp alltraps
80106176:	e9 9f f7 ff ff       	jmp    8010591a <alltraps>

8010617b <vector100>:
.globl vector100
vector100:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $100
8010617d:	6a 64                	push   $0x64
  jmp alltraps
8010617f:	e9 96 f7 ff ff       	jmp    8010591a <alltraps>

80106184 <vector101>:
.globl vector101
vector101:
  pushl $0
80106184:	6a 00                	push   $0x0
  pushl $101
80106186:	6a 65                	push   $0x65
  jmp alltraps
80106188:	e9 8d f7 ff ff       	jmp    8010591a <alltraps>

8010618d <vector102>:
.globl vector102
vector102:
  pushl $0
8010618d:	6a 00                	push   $0x0
  pushl $102
8010618f:	6a 66                	push   $0x66
  jmp alltraps
80106191:	e9 84 f7 ff ff       	jmp    8010591a <alltraps>

80106196 <vector103>:
.globl vector103
vector103:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $103
80106198:	6a 67                	push   $0x67
  jmp alltraps
8010619a:	e9 7b f7 ff ff       	jmp    8010591a <alltraps>

8010619f <vector104>:
.globl vector104
vector104:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $104
801061a1:	6a 68                	push   $0x68
  jmp alltraps
801061a3:	e9 72 f7 ff ff       	jmp    8010591a <alltraps>

801061a8 <vector105>:
.globl vector105
vector105:
  pushl $0
801061a8:	6a 00                	push   $0x0
  pushl $105
801061aa:	6a 69                	push   $0x69
  jmp alltraps
801061ac:	e9 69 f7 ff ff       	jmp    8010591a <alltraps>

801061b1 <vector106>:
.globl vector106
vector106:
  pushl $0
801061b1:	6a 00                	push   $0x0
  pushl $106
801061b3:	6a 6a                	push   $0x6a
  jmp alltraps
801061b5:	e9 60 f7 ff ff       	jmp    8010591a <alltraps>

801061ba <vector107>:
.globl vector107
vector107:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $107
801061bc:	6a 6b                	push   $0x6b
  jmp alltraps
801061be:	e9 57 f7 ff ff       	jmp    8010591a <alltraps>

801061c3 <vector108>:
.globl vector108
vector108:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $108
801061c5:	6a 6c                	push   $0x6c
  jmp alltraps
801061c7:	e9 4e f7 ff ff       	jmp    8010591a <alltraps>

801061cc <vector109>:
.globl vector109
vector109:
  pushl $0
801061cc:	6a 00                	push   $0x0
  pushl $109
801061ce:	6a 6d                	push   $0x6d
  jmp alltraps
801061d0:	e9 45 f7 ff ff       	jmp    8010591a <alltraps>

801061d5 <vector110>:
.globl vector110
vector110:
  pushl $0
801061d5:	6a 00                	push   $0x0
  pushl $110
801061d7:	6a 6e                	push   $0x6e
  jmp alltraps
801061d9:	e9 3c f7 ff ff       	jmp    8010591a <alltraps>

801061de <vector111>:
.globl vector111
vector111:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $111
801061e0:	6a 6f                	push   $0x6f
  jmp alltraps
801061e2:	e9 33 f7 ff ff       	jmp    8010591a <alltraps>

801061e7 <vector112>:
.globl vector112
vector112:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $112
801061e9:	6a 70                	push   $0x70
  jmp alltraps
801061eb:	e9 2a f7 ff ff       	jmp    8010591a <alltraps>

801061f0 <vector113>:
.globl vector113
vector113:
  pushl $0
801061f0:	6a 00                	push   $0x0
  pushl $113
801061f2:	6a 71                	push   $0x71
  jmp alltraps
801061f4:	e9 21 f7 ff ff       	jmp    8010591a <alltraps>

801061f9 <vector114>:
.globl vector114
vector114:
  pushl $0
801061f9:	6a 00                	push   $0x0
  pushl $114
801061fb:	6a 72                	push   $0x72
  jmp alltraps
801061fd:	e9 18 f7 ff ff       	jmp    8010591a <alltraps>

80106202 <vector115>:
.globl vector115
vector115:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $115
80106204:	6a 73                	push   $0x73
  jmp alltraps
80106206:	e9 0f f7 ff ff       	jmp    8010591a <alltraps>

8010620b <vector116>:
.globl vector116
vector116:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $116
8010620d:	6a 74                	push   $0x74
  jmp alltraps
8010620f:	e9 06 f7 ff ff       	jmp    8010591a <alltraps>

80106214 <vector117>:
.globl vector117
vector117:
  pushl $0
80106214:	6a 00                	push   $0x0
  pushl $117
80106216:	6a 75                	push   $0x75
  jmp alltraps
80106218:	e9 fd f6 ff ff       	jmp    8010591a <alltraps>

8010621d <vector118>:
.globl vector118
vector118:
  pushl $0
8010621d:	6a 00                	push   $0x0
  pushl $118
8010621f:	6a 76                	push   $0x76
  jmp alltraps
80106221:	e9 f4 f6 ff ff       	jmp    8010591a <alltraps>

80106226 <vector119>:
.globl vector119
vector119:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $119
80106228:	6a 77                	push   $0x77
  jmp alltraps
8010622a:	e9 eb f6 ff ff       	jmp    8010591a <alltraps>

8010622f <vector120>:
.globl vector120
vector120:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $120
80106231:	6a 78                	push   $0x78
  jmp alltraps
80106233:	e9 e2 f6 ff ff       	jmp    8010591a <alltraps>

80106238 <vector121>:
.globl vector121
vector121:
  pushl $0
80106238:	6a 00                	push   $0x0
  pushl $121
8010623a:	6a 79                	push   $0x79
  jmp alltraps
8010623c:	e9 d9 f6 ff ff       	jmp    8010591a <alltraps>

80106241 <vector122>:
.globl vector122
vector122:
  pushl $0
80106241:	6a 00                	push   $0x0
  pushl $122
80106243:	6a 7a                	push   $0x7a
  jmp alltraps
80106245:	e9 d0 f6 ff ff       	jmp    8010591a <alltraps>

8010624a <vector123>:
.globl vector123
vector123:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $123
8010624c:	6a 7b                	push   $0x7b
  jmp alltraps
8010624e:	e9 c7 f6 ff ff       	jmp    8010591a <alltraps>

80106253 <vector124>:
.globl vector124
vector124:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $124
80106255:	6a 7c                	push   $0x7c
  jmp alltraps
80106257:	e9 be f6 ff ff       	jmp    8010591a <alltraps>

8010625c <vector125>:
.globl vector125
vector125:
  pushl $0
8010625c:	6a 00                	push   $0x0
  pushl $125
8010625e:	6a 7d                	push   $0x7d
  jmp alltraps
80106260:	e9 b5 f6 ff ff       	jmp    8010591a <alltraps>

80106265 <vector126>:
.globl vector126
vector126:
  pushl $0
80106265:	6a 00                	push   $0x0
  pushl $126
80106267:	6a 7e                	push   $0x7e
  jmp alltraps
80106269:	e9 ac f6 ff ff       	jmp    8010591a <alltraps>

8010626e <vector127>:
.globl vector127
vector127:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $127
80106270:	6a 7f                	push   $0x7f
  jmp alltraps
80106272:	e9 a3 f6 ff ff       	jmp    8010591a <alltraps>

80106277 <vector128>:
.globl vector128
vector128:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $128
80106279:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010627e:	e9 97 f6 ff ff       	jmp    8010591a <alltraps>

80106283 <vector129>:
.globl vector129
vector129:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $129
80106285:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010628a:	e9 8b f6 ff ff       	jmp    8010591a <alltraps>

8010628f <vector130>:
.globl vector130
vector130:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $130
80106291:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106296:	e9 7f f6 ff ff       	jmp    8010591a <alltraps>

8010629b <vector131>:
.globl vector131
vector131:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $131
8010629d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801062a2:	e9 73 f6 ff ff       	jmp    8010591a <alltraps>

801062a7 <vector132>:
.globl vector132
vector132:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $132
801062a9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801062ae:	e9 67 f6 ff ff       	jmp    8010591a <alltraps>

801062b3 <vector133>:
.globl vector133
vector133:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $133
801062b5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801062ba:	e9 5b f6 ff ff       	jmp    8010591a <alltraps>

801062bf <vector134>:
.globl vector134
vector134:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $134
801062c1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801062c6:	e9 4f f6 ff ff       	jmp    8010591a <alltraps>

801062cb <vector135>:
.globl vector135
vector135:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $135
801062cd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801062d2:	e9 43 f6 ff ff       	jmp    8010591a <alltraps>

801062d7 <vector136>:
.globl vector136
vector136:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $136
801062d9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801062de:	e9 37 f6 ff ff       	jmp    8010591a <alltraps>

801062e3 <vector137>:
.globl vector137
vector137:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $137
801062e5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801062ea:	e9 2b f6 ff ff       	jmp    8010591a <alltraps>

801062ef <vector138>:
.globl vector138
vector138:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $138
801062f1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801062f6:	e9 1f f6 ff ff       	jmp    8010591a <alltraps>

801062fb <vector139>:
.globl vector139
vector139:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $139
801062fd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106302:	e9 13 f6 ff ff       	jmp    8010591a <alltraps>

80106307 <vector140>:
.globl vector140
vector140:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $140
80106309:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010630e:	e9 07 f6 ff ff       	jmp    8010591a <alltraps>

80106313 <vector141>:
.globl vector141
vector141:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $141
80106315:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010631a:	e9 fb f5 ff ff       	jmp    8010591a <alltraps>

8010631f <vector142>:
.globl vector142
vector142:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $142
80106321:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106326:	e9 ef f5 ff ff       	jmp    8010591a <alltraps>

8010632b <vector143>:
.globl vector143
vector143:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $143
8010632d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106332:	e9 e3 f5 ff ff       	jmp    8010591a <alltraps>

80106337 <vector144>:
.globl vector144
vector144:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $144
80106339:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010633e:	e9 d7 f5 ff ff       	jmp    8010591a <alltraps>

80106343 <vector145>:
.globl vector145
vector145:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $145
80106345:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010634a:	e9 cb f5 ff ff       	jmp    8010591a <alltraps>

8010634f <vector146>:
.globl vector146
vector146:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $146
80106351:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106356:	e9 bf f5 ff ff       	jmp    8010591a <alltraps>

8010635b <vector147>:
.globl vector147
vector147:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $147
8010635d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106362:	e9 b3 f5 ff ff       	jmp    8010591a <alltraps>

80106367 <vector148>:
.globl vector148
vector148:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $148
80106369:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010636e:	e9 a7 f5 ff ff       	jmp    8010591a <alltraps>

80106373 <vector149>:
.globl vector149
vector149:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $149
80106375:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010637a:	e9 9b f5 ff ff       	jmp    8010591a <alltraps>

8010637f <vector150>:
.globl vector150
vector150:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $150
80106381:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106386:	e9 8f f5 ff ff       	jmp    8010591a <alltraps>

8010638b <vector151>:
.globl vector151
vector151:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $151
8010638d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106392:	e9 83 f5 ff ff       	jmp    8010591a <alltraps>

80106397 <vector152>:
.globl vector152
vector152:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $152
80106399:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010639e:	e9 77 f5 ff ff       	jmp    8010591a <alltraps>

801063a3 <vector153>:
.globl vector153
vector153:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $153
801063a5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801063aa:	e9 6b f5 ff ff       	jmp    8010591a <alltraps>

801063af <vector154>:
.globl vector154
vector154:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $154
801063b1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801063b6:	e9 5f f5 ff ff       	jmp    8010591a <alltraps>

801063bb <vector155>:
.globl vector155
vector155:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $155
801063bd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801063c2:	e9 53 f5 ff ff       	jmp    8010591a <alltraps>

801063c7 <vector156>:
.globl vector156
vector156:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $156
801063c9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801063ce:	e9 47 f5 ff ff       	jmp    8010591a <alltraps>

801063d3 <vector157>:
.globl vector157
vector157:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $157
801063d5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801063da:	e9 3b f5 ff ff       	jmp    8010591a <alltraps>

801063df <vector158>:
.globl vector158
vector158:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $158
801063e1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801063e6:	e9 2f f5 ff ff       	jmp    8010591a <alltraps>

801063eb <vector159>:
.globl vector159
vector159:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $159
801063ed:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801063f2:	e9 23 f5 ff ff       	jmp    8010591a <alltraps>

801063f7 <vector160>:
.globl vector160
vector160:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $160
801063f9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801063fe:	e9 17 f5 ff ff       	jmp    8010591a <alltraps>

80106403 <vector161>:
.globl vector161
vector161:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $161
80106405:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010640a:	e9 0b f5 ff ff       	jmp    8010591a <alltraps>

8010640f <vector162>:
.globl vector162
vector162:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $162
80106411:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106416:	e9 ff f4 ff ff       	jmp    8010591a <alltraps>

8010641b <vector163>:
.globl vector163
vector163:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $163
8010641d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106422:	e9 f3 f4 ff ff       	jmp    8010591a <alltraps>

80106427 <vector164>:
.globl vector164
vector164:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $164
80106429:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010642e:	e9 e7 f4 ff ff       	jmp    8010591a <alltraps>

80106433 <vector165>:
.globl vector165
vector165:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $165
80106435:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010643a:	e9 db f4 ff ff       	jmp    8010591a <alltraps>

8010643f <vector166>:
.globl vector166
vector166:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $166
80106441:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106446:	e9 cf f4 ff ff       	jmp    8010591a <alltraps>

8010644b <vector167>:
.globl vector167
vector167:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $167
8010644d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106452:	e9 c3 f4 ff ff       	jmp    8010591a <alltraps>

80106457 <vector168>:
.globl vector168
vector168:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $168
80106459:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010645e:	e9 b7 f4 ff ff       	jmp    8010591a <alltraps>

80106463 <vector169>:
.globl vector169
vector169:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $169
80106465:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010646a:	e9 ab f4 ff ff       	jmp    8010591a <alltraps>

8010646f <vector170>:
.globl vector170
vector170:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $170
80106471:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106476:	e9 9f f4 ff ff       	jmp    8010591a <alltraps>

8010647b <vector171>:
.globl vector171
vector171:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $171
8010647d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106482:	e9 93 f4 ff ff       	jmp    8010591a <alltraps>

80106487 <vector172>:
.globl vector172
vector172:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $172
80106489:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010648e:	e9 87 f4 ff ff       	jmp    8010591a <alltraps>

80106493 <vector173>:
.globl vector173
vector173:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $173
80106495:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010649a:	e9 7b f4 ff ff       	jmp    8010591a <alltraps>

8010649f <vector174>:
.globl vector174
vector174:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $174
801064a1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801064a6:	e9 6f f4 ff ff       	jmp    8010591a <alltraps>

801064ab <vector175>:
.globl vector175
vector175:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $175
801064ad:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801064b2:	e9 63 f4 ff ff       	jmp    8010591a <alltraps>

801064b7 <vector176>:
.globl vector176
vector176:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $176
801064b9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801064be:	e9 57 f4 ff ff       	jmp    8010591a <alltraps>

801064c3 <vector177>:
.globl vector177
vector177:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $177
801064c5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801064ca:	e9 4b f4 ff ff       	jmp    8010591a <alltraps>

801064cf <vector178>:
.globl vector178
vector178:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $178
801064d1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801064d6:	e9 3f f4 ff ff       	jmp    8010591a <alltraps>

801064db <vector179>:
.globl vector179
vector179:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $179
801064dd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801064e2:	e9 33 f4 ff ff       	jmp    8010591a <alltraps>

801064e7 <vector180>:
.globl vector180
vector180:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $180
801064e9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801064ee:	e9 27 f4 ff ff       	jmp    8010591a <alltraps>

801064f3 <vector181>:
.globl vector181
vector181:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $181
801064f5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801064fa:	e9 1b f4 ff ff       	jmp    8010591a <alltraps>

801064ff <vector182>:
.globl vector182
vector182:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $182
80106501:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106506:	e9 0f f4 ff ff       	jmp    8010591a <alltraps>

8010650b <vector183>:
.globl vector183
vector183:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $183
8010650d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106512:	e9 03 f4 ff ff       	jmp    8010591a <alltraps>

80106517 <vector184>:
.globl vector184
vector184:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $184
80106519:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010651e:	e9 f7 f3 ff ff       	jmp    8010591a <alltraps>

80106523 <vector185>:
.globl vector185
vector185:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $185
80106525:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010652a:	e9 eb f3 ff ff       	jmp    8010591a <alltraps>

8010652f <vector186>:
.globl vector186
vector186:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $186
80106531:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106536:	e9 df f3 ff ff       	jmp    8010591a <alltraps>

8010653b <vector187>:
.globl vector187
vector187:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $187
8010653d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106542:	e9 d3 f3 ff ff       	jmp    8010591a <alltraps>

80106547 <vector188>:
.globl vector188
vector188:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $188
80106549:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010654e:	e9 c7 f3 ff ff       	jmp    8010591a <alltraps>

80106553 <vector189>:
.globl vector189
vector189:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $189
80106555:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010655a:	e9 bb f3 ff ff       	jmp    8010591a <alltraps>

8010655f <vector190>:
.globl vector190
vector190:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $190
80106561:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106566:	e9 af f3 ff ff       	jmp    8010591a <alltraps>

8010656b <vector191>:
.globl vector191
vector191:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $191
8010656d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106572:	e9 a3 f3 ff ff       	jmp    8010591a <alltraps>

80106577 <vector192>:
.globl vector192
vector192:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $192
80106579:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010657e:	e9 97 f3 ff ff       	jmp    8010591a <alltraps>

80106583 <vector193>:
.globl vector193
vector193:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $193
80106585:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010658a:	e9 8b f3 ff ff       	jmp    8010591a <alltraps>

8010658f <vector194>:
.globl vector194
vector194:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $194
80106591:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106596:	e9 7f f3 ff ff       	jmp    8010591a <alltraps>

8010659b <vector195>:
.globl vector195
vector195:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $195
8010659d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801065a2:	e9 73 f3 ff ff       	jmp    8010591a <alltraps>

801065a7 <vector196>:
.globl vector196
vector196:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $196
801065a9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801065ae:	e9 67 f3 ff ff       	jmp    8010591a <alltraps>

801065b3 <vector197>:
.globl vector197
vector197:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $197
801065b5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801065ba:	e9 5b f3 ff ff       	jmp    8010591a <alltraps>

801065bf <vector198>:
.globl vector198
vector198:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $198
801065c1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801065c6:	e9 4f f3 ff ff       	jmp    8010591a <alltraps>

801065cb <vector199>:
.globl vector199
vector199:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $199
801065cd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801065d2:	e9 43 f3 ff ff       	jmp    8010591a <alltraps>

801065d7 <vector200>:
.globl vector200
vector200:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $200
801065d9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801065de:	e9 37 f3 ff ff       	jmp    8010591a <alltraps>

801065e3 <vector201>:
.globl vector201
vector201:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $201
801065e5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801065ea:	e9 2b f3 ff ff       	jmp    8010591a <alltraps>

801065ef <vector202>:
.globl vector202
vector202:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $202
801065f1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801065f6:	e9 1f f3 ff ff       	jmp    8010591a <alltraps>

801065fb <vector203>:
.globl vector203
vector203:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $203
801065fd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106602:	e9 13 f3 ff ff       	jmp    8010591a <alltraps>

80106607 <vector204>:
.globl vector204
vector204:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $204
80106609:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010660e:	e9 07 f3 ff ff       	jmp    8010591a <alltraps>

80106613 <vector205>:
.globl vector205
vector205:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $205
80106615:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010661a:	e9 fb f2 ff ff       	jmp    8010591a <alltraps>

8010661f <vector206>:
.globl vector206
vector206:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $206
80106621:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106626:	e9 ef f2 ff ff       	jmp    8010591a <alltraps>

8010662b <vector207>:
.globl vector207
vector207:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $207
8010662d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106632:	e9 e3 f2 ff ff       	jmp    8010591a <alltraps>

80106637 <vector208>:
.globl vector208
vector208:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $208
80106639:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010663e:	e9 d7 f2 ff ff       	jmp    8010591a <alltraps>

80106643 <vector209>:
.globl vector209
vector209:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $209
80106645:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010664a:	e9 cb f2 ff ff       	jmp    8010591a <alltraps>

8010664f <vector210>:
.globl vector210
vector210:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $210
80106651:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106656:	e9 bf f2 ff ff       	jmp    8010591a <alltraps>

8010665b <vector211>:
.globl vector211
vector211:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $211
8010665d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106662:	e9 b3 f2 ff ff       	jmp    8010591a <alltraps>

80106667 <vector212>:
.globl vector212
vector212:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $212
80106669:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010666e:	e9 a7 f2 ff ff       	jmp    8010591a <alltraps>

80106673 <vector213>:
.globl vector213
vector213:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $213
80106675:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010667a:	e9 9b f2 ff ff       	jmp    8010591a <alltraps>

8010667f <vector214>:
.globl vector214
vector214:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $214
80106681:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106686:	e9 8f f2 ff ff       	jmp    8010591a <alltraps>

8010668b <vector215>:
.globl vector215
vector215:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $215
8010668d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106692:	e9 83 f2 ff ff       	jmp    8010591a <alltraps>

80106697 <vector216>:
.globl vector216
vector216:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $216
80106699:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010669e:	e9 77 f2 ff ff       	jmp    8010591a <alltraps>

801066a3 <vector217>:
.globl vector217
vector217:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $217
801066a5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801066aa:	e9 6b f2 ff ff       	jmp    8010591a <alltraps>

801066af <vector218>:
.globl vector218
vector218:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $218
801066b1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801066b6:	e9 5f f2 ff ff       	jmp    8010591a <alltraps>

801066bb <vector219>:
.globl vector219
vector219:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $219
801066bd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801066c2:	e9 53 f2 ff ff       	jmp    8010591a <alltraps>

801066c7 <vector220>:
.globl vector220
vector220:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $220
801066c9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801066ce:	e9 47 f2 ff ff       	jmp    8010591a <alltraps>

801066d3 <vector221>:
.globl vector221
vector221:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $221
801066d5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801066da:	e9 3b f2 ff ff       	jmp    8010591a <alltraps>

801066df <vector222>:
.globl vector222
vector222:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $222
801066e1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801066e6:	e9 2f f2 ff ff       	jmp    8010591a <alltraps>

801066eb <vector223>:
.globl vector223
vector223:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $223
801066ed:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801066f2:	e9 23 f2 ff ff       	jmp    8010591a <alltraps>

801066f7 <vector224>:
.globl vector224
vector224:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $224
801066f9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801066fe:	e9 17 f2 ff ff       	jmp    8010591a <alltraps>

80106703 <vector225>:
.globl vector225
vector225:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $225
80106705:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010670a:	e9 0b f2 ff ff       	jmp    8010591a <alltraps>

8010670f <vector226>:
.globl vector226
vector226:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $226
80106711:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106716:	e9 ff f1 ff ff       	jmp    8010591a <alltraps>

8010671b <vector227>:
.globl vector227
vector227:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $227
8010671d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106722:	e9 f3 f1 ff ff       	jmp    8010591a <alltraps>

80106727 <vector228>:
.globl vector228
vector228:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $228
80106729:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010672e:	e9 e7 f1 ff ff       	jmp    8010591a <alltraps>

80106733 <vector229>:
.globl vector229
vector229:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $229
80106735:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010673a:	e9 db f1 ff ff       	jmp    8010591a <alltraps>

8010673f <vector230>:
.globl vector230
vector230:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $230
80106741:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106746:	e9 cf f1 ff ff       	jmp    8010591a <alltraps>

8010674b <vector231>:
.globl vector231
vector231:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $231
8010674d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106752:	e9 c3 f1 ff ff       	jmp    8010591a <alltraps>

80106757 <vector232>:
.globl vector232
vector232:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $232
80106759:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010675e:	e9 b7 f1 ff ff       	jmp    8010591a <alltraps>

80106763 <vector233>:
.globl vector233
vector233:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $233
80106765:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010676a:	e9 ab f1 ff ff       	jmp    8010591a <alltraps>

8010676f <vector234>:
.globl vector234
vector234:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $234
80106771:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106776:	e9 9f f1 ff ff       	jmp    8010591a <alltraps>

8010677b <vector235>:
.globl vector235
vector235:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $235
8010677d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106782:	e9 93 f1 ff ff       	jmp    8010591a <alltraps>

80106787 <vector236>:
.globl vector236
vector236:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $236
80106789:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010678e:	e9 87 f1 ff ff       	jmp    8010591a <alltraps>

80106793 <vector237>:
.globl vector237
vector237:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $237
80106795:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010679a:	e9 7b f1 ff ff       	jmp    8010591a <alltraps>

8010679f <vector238>:
.globl vector238
vector238:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $238
801067a1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801067a6:	e9 6f f1 ff ff       	jmp    8010591a <alltraps>

801067ab <vector239>:
.globl vector239
vector239:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $239
801067ad:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801067b2:	e9 63 f1 ff ff       	jmp    8010591a <alltraps>

801067b7 <vector240>:
.globl vector240
vector240:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $240
801067b9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801067be:	e9 57 f1 ff ff       	jmp    8010591a <alltraps>

801067c3 <vector241>:
.globl vector241
vector241:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $241
801067c5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801067ca:	e9 4b f1 ff ff       	jmp    8010591a <alltraps>

801067cf <vector242>:
.globl vector242
vector242:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $242
801067d1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801067d6:	e9 3f f1 ff ff       	jmp    8010591a <alltraps>

801067db <vector243>:
.globl vector243
vector243:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $243
801067dd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801067e2:	e9 33 f1 ff ff       	jmp    8010591a <alltraps>

801067e7 <vector244>:
.globl vector244
vector244:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $244
801067e9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801067ee:	e9 27 f1 ff ff       	jmp    8010591a <alltraps>

801067f3 <vector245>:
.globl vector245
vector245:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $245
801067f5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801067fa:	e9 1b f1 ff ff       	jmp    8010591a <alltraps>

801067ff <vector246>:
.globl vector246
vector246:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $246
80106801:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106806:	e9 0f f1 ff ff       	jmp    8010591a <alltraps>

8010680b <vector247>:
.globl vector247
vector247:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $247
8010680d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106812:	e9 03 f1 ff ff       	jmp    8010591a <alltraps>

80106817 <vector248>:
.globl vector248
vector248:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $248
80106819:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010681e:	e9 f7 f0 ff ff       	jmp    8010591a <alltraps>

80106823 <vector249>:
.globl vector249
vector249:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $249
80106825:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010682a:	e9 eb f0 ff ff       	jmp    8010591a <alltraps>

8010682f <vector250>:
.globl vector250
vector250:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $250
80106831:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106836:	e9 df f0 ff ff       	jmp    8010591a <alltraps>

8010683b <vector251>:
.globl vector251
vector251:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $251
8010683d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106842:	e9 d3 f0 ff ff       	jmp    8010591a <alltraps>

80106847 <vector252>:
.globl vector252
vector252:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $252
80106849:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010684e:	e9 c7 f0 ff ff       	jmp    8010591a <alltraps>

80106853 <vector253>:
.globl vector253
vector253:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $253
80106855:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010685a:	e9 bb f0 ff ff       	jmp    8010591a <alltraps>

8010685f <vector254>:
.globl vector254
vector254:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $254
80106861:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106866:	e9 af f0 ff ff       	jmp    8010591a <alltraps>

8010686b <vector255>:
.globl vector255
vector255:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $255
8010686d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106872:	e9 a3 f0 ff ff       	jmp    8010591a <alltraps>
80106877:	66 90                	xchg   %ax,%ax
80106879:	66 90                	xchg   %ax,%ax
8010687b:	66 90                	xchg   %ax,%ax
8010687d:	66 90                	xchg   %ax,%ax
8010687f:	90                   	nop

80106880 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106880:	55                   	push   %ebp
80106881:	89 e5                	mov    %esp,%ebp
80106883:	57                   	push   %edi
80106884:	56                   	push   %esi
80106885:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106886:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010688c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106892:	83 ec 1c             	sub    $0x1c,%esp
80106895:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106898:	39 d3                	cmp    %edx,%ebx
8010689a:	73 49                	jae    801068e5 <deallocuvm.part.0+0x65>
8010689c:	89 c7                	mov    %eax,%edi
8010689e:	eb 0c                	jmp    801068ac <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801068a0:	83 c0 01             	add    $0x1,%eax
801068a3:	c1 e0 16             	shl    $0x16,%eax
801068a6:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
801068a8:	39 da                	cmp    %ebx,%edx
801068aa:	76 39                	jbe    801068e5 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
801068ac:	89 d8                	mov    %ebx,%eax
801068ae:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801068b1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
801068b4:	f6 c1 01             	test   $0x1,%cl
801068b7:	74 e7                	je     801068a0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
801068b9:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801068bb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801068c1:	c1 ee 0a             	shr    $0xa,%esi
801068c4:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
801068ca:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
801068d1:	85 f6                	test   %esi,%esi
801068d3:	74 cb                	je     801068a0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
801068d5:	8b 06                	mov    (%esi),%eax
801068d7:	a8 01                	test   $0x1,%al
801068d9:	75 15                	jne    801068f0 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
801068db:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068e1:	39 da                	cmp    %ebx,%edx
801068e3:	77 c7                	ja     801068ac <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801068e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801068e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068eb:	5b                   	pop    %ebx
801068ec:	5e                   	pop    %esi
801068ed:	5f                   	pop    %edi
801068ee:	5d                   	pop    %ebp
801068ef:	c3                   	ret    
      if(pa == 0)
801068f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801068f5:	74 25                	je     8010691c <deallocuvm.part.0+0x9c>
      kfree(v);
801068f7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801068fa:	05 00 00 00 80       	add    $0x80000000,%eax
801068ff:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106902:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106908:	50                   	push   %eax
80106909:	e8 02 bc ff ff       	call   80102510 <kfree>
      *pte = 0;
8010690e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106914:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106917:	83 c4 10             	add    $0x10,%esp
8010691a:	eb 8c                	jmp    801068a8 <deallocuvm.part.0+0x28>
        panic("kfree");
8010691c:	83 ec 0c             	sub    $0xc,%esp
8010691f:	68 e6 74 10 80       	push   $0x801074e6
80106924:	e8 57 9a ff ff       	call   80100380 <panic>
80106929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106930 <mappages>:
{
80106930:	55                   	push   %ebp
80106931:	89 e5                	mov    %esp,%ebp
80106933:	57                   	push   %edi
80106934:	56                   	push   %esi
80106935:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106936:	89 d3                	mov    %edx,%ebx
80106938:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010693e:	83 ec 1c             	sub    $0x1c,%esp
80106941:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106944:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106948:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010694d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106950:	8b 45 08             	mov    0x8(%ebp),%eax
80106953:	29 d8                	sub    %ebx,%eax
80106955:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106958:	eb 3d                	jmp    80106997 <mappages+0x67>
8010695a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106960:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106962:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106967:	c1 ea 0a             	shr    $0xa,%edx
8010696a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106970:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106977:	85 c0                	test   %eax,%eax
80106979:	74 75                	je     801069f0 <mappages+0xc0>
    if(*pte & PTE_P)
8010697b:	f6 00 01             	testb  $0x1,(%eax)
8010697e:	0f 85 86 00 00 00    	jne    80106a0a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106984:	0b 75 0c             	or     0xc(%ebp),%esi
80106987:	83 ce 01             	or     $0x1,%esi
8010698a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010698c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
8010698f:	74 6f                	je     80106a00 <mappages+0xd0>
    a += PGSIZE;
80106991:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106997:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010699a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010699d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
801069a0:	89 d8                	mov    %ebx,%eax
801069a2:	c1 e8 16             	shr    $0x16,%eax
801069a5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
801069a8:	8b 07                	mov    (%edi),%eax
801069aa:	a8 01                	test   $0x1,%al
801069ac:	75 b2                	jne    80106960 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801069ae:	e8 1d bd ff ff       	call   801026d0 <kalloc>
801069b3:	85 c0                	test   %eax,%eax
801069b5:	74 39                	je     801069f0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
801069b7:	83 ec 04             	sub    $0x4,%esp
801069ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
801069bd:	68 00 10 00 00       	push   $0x1000
801069c2:	6a 00                	push   $0x0
801069c4:	50                   	push   %eax
801069c5:	e8 e6 dc ff ff       	call   801046b0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801069ca:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
801069cd:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801069d0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
801069d6:	83 c8 07             	or     $0x7,%eax
801069d9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
801069db:	89 d8                	mov    %ebx,%eax
801069dd:	c1 e8 0a             	shr    $0xa,%eax
801069e0:	25 fc 0f 00 00       	and    $0xffc,%eax
801069e5:	01 d0                	add    %edx,%eax
801069e7:	eb 92                	jmp    8010697b <mappages+0x4b>
801069e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801069f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801069f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801069f8:	5b                   	pop    %ebx
801069f9:	5e                   	pop    %esi
801069fa:	5f                   	pop    %edi
801069fb:	5d                   	pop    %ebp
801069fc:	c3                   	ret    
801069fd:	8d 76 00             	lea    0x0(%esi),%esi
80106a00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106a03:	31 c0                	xor    %eax,%eax
}
80106a05:	5b                   	pop    %ebx
80106a06:	5e                   	pop    %esi
80106a07:	5f                   	pop    %edi
80106a08:	5d                   	pop    %ebp
80106a09:	c3                   	ret    
      panic("remap");
80106a0a:	83 ec 0c             	sub    $0xc,%esp
80106a0d:	68 2c 7b 10 80       	push   $0x80107b2c
80106a12:	e8 69 99 ff ff       	call   80100380 <panic>
80106a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a1e:	66 90                	xchg   %ax,%ax

80106a20 <seginit>:
{
80106a20:	55                   	push   %ebp
80106a21:	89 e5                	mov    %esp,%ebp
80106a23:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106a26:	e8 75 cf ff ff       	call   801039a0 <cpuid>
  pd[0] = size-1;
80106a2b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106a30:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106a36:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106a3a:	c7 80 38 1b 11 80 ff 	movl   $0xffff,-0x7feee4c8(%eax)
80106a41:	ff 00 00 
80106a44:	c7 80 3c 1b 11 80 00 	movl   $0xcf9a00,-0x7feee4c4(%eax)
80106a4b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a4e:	c7 80 40 1b 11 80 ff 	movl   $0xffff,-0x7feee4c0(%eax)
80106a55:	ff 00 00 
80106a58:	c7 80 44 1b 11 80 00 	movl   $0xcf9200,-0x7feee4bc(%eax)
80106a5f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a62:	c7 80 48 1b 11 80 ff 	movl   $0xffff,-0x7feee4b8(%eax)
80106a69:	ff 00 00 
80106a6c:	c7 80 4c 1b 11 80 00 	movl   $0xcffa00,-0x7feee4b4(%eax)
80106a73:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a76:	c7 80 50 1b 11 80 ff 	movl   $0xffff,-0x7feee4b0(%eax)
80106a7d:	ff 00 00 
80106a80:	c7 80 54 1b 11 80 00 	movl   $0xcff200,-0x7feee4ac(%eax)
80106a87:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106a8a:	05 30 1b 11 80       	add    $0x80111b30,%eax
  pd[1] = (uint)p;
80106a8f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106a93:	c1 e8 10             	shr    $0x10,%eax
80106a96:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106a9a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106a9d:	0f 01 10             	lgdtl  (%eax)
}
80106aa0:	c9                   	leave  
80106aa1:	c3                   	ret    
80106aa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ab0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ab0:	a1 e4 47 11 80       	mov    0x801147e4,%eax
80106ab5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106aba:	0f 22 d8             	mov    %eax,%cr3
}
80106abd:	c3                   	ret    
80106abe:	66 90                	xchg   %ax,%ax

80106ac0 <switchuvm>:
{
80106ac0:	55                   	push   %ebp
80106ac1:	89 e5                	mov    %esp,%ebp
80106ac3:	57                   	push   %edi
80106ac4:	56                   	push   %esi
80106ac5:	53                   	push   %ebx
80106ac6:	83 ec 1c             	sub    $0x1c,%esp
80106ac9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106acc:	85 f6                	test   %esi,%esi
80106ace:	0f 84 cb 00 00 00    	je     80106b9f <switchuvm+0xdf>
  if(p->kstack == 0)
80106ad4:	8b 46 08             	mov    0x8(%esi),%eax
80106ad7:	85 c0                	test   %eax,%eax
80106ad9:	0f 84 da 00 00 00    	je     80106bb9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106adf:	8b 46 04             	mov    0x4(%esi),%eax
80106ae2:	85 c0                	test   %eax,%eax
80106ae4:	0f 84 c2 00 00 00    	je     80106bac <switchuvm+0xec>
  pushcli();
80106aea:	e8 b1 d9 ff ff       	call   801044a0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106aef:	e8 4c ce ff ff       	call   80103940 <mycpu>
80106af4:	89 c3                	mov    %eax,%ebx
80106af6:	e8 45 ce ff ff       	call   80103940 <mycpu>
80106afb:	89 c7                	mov    %eax,%edi
80106afd:	e8 3e ce ff ff       	call   80103940 <mycpu>
80106b02:	83 c7 08             	add    $0x8,%edi
80106b05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b08:	e8 33 ce ff ff       	call   80103940 <mycpu>
80106b0d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106b10:	ba 67 00 00 00       	mov    $0x67,%edx
80106b15:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106b1c:	83 c0 08             	add    $0x8,%eax
80106b1f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106b26:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106b2b:	83 c1 08             	add    $0x8,%ecx
80106b2e:	c1 e8 18             	shr    $0x18,%eax
80106b31:	c1 e9 10             	shr    $0x10,%ecx
80106b34:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106b3a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106b40:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106b45:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106b4c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106b51:	e8 ea cd ff ff       	call   80103940 <mycpu>
80106b56:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106b5d:	e8 de cd ff ff       	call   80103940 <mycpu>
80106b62:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106b66:	8b 5e 08             	mov    0x8(%esi),%ebx
80106b69:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b6f:	e8 cc cd ff ff       	call   80103940 <mycpu>
80106b74:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106b77:	e8 c4 cd ff ff       	call   80103940 <mycpu>
80106b7c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106b80:	b8 28 00 00 00       	mov    $0x28,%eax
80106b85:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106b88:	8b 46 04             	mov    0x4(%esi),%eax
80106b8b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b90:	0f 22 d8             	mov    %eax,%cr3
}
80106b93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b96:	5b                   	pop    %ebx
80106b97:	5e                   	pop    %esi
80106b98:	5f                   	pop    %edi
80106b99:	5d                   	pop    %ebp
  popcli();
80106b9a:	e9 51 d9 ff ff       	jmp    801044f0 <popcli>
    panic("switchuvm: no process");
80106b9f:	83 ec 0c             	sub    $0xc,%esp
80106ba2:	68 32 7b 10 80       	push   $0x80107b32
80106ba7:	e8 d4 97 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106bac:	83 ec 0c             	sub    $0xc,%esp
80106baf:	68 5d 7b 10 80       	push   $0x80107b5d
80106bb4:	e8 c7 97 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106bb9:	83 ec 0c             	sub    $0xc,%esp
80106bbc:	68 48 7b 10 80       	push   $0x80107b48
80106bc1:	e8 ba 97 ff ff       	call   80100380 <panic>
80106bc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bcd:	8d 76 00             	lea    0x0(%esi),%esi

80106bd0 <inituvm>:
{
80106bd0:	55                   	push   %ebp
80106bd1:	89 e5                	mov    %esp,%ebp
80106bd3:	57                   	push   %edi
80106bd4:	56                   	push   %esi
80106bd5:	53                   	push   %ebx
80106bd6:	83 ec 1c             	sub    $0x1c,%esp
80106bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bdc:	8b 75 10             	mov    0x10(%ebp),%esi
80106bdf:	8b 7d 08             	mov    0x8(%ebp),%edi
80106be2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106be5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106beb:	77 4b                	ja     80106c38 <inituvm+0x68>
  mem = kalloc();
80106bed:	e8 de ba ff ff       	call   801026d0 <kalloc>
  memset(mem, 0, PGSIZE);
80106bf2:	83 ec 04             	sub    $0x4,%esp
80106bf5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106bfa:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106bfc:	6a 00                	push   $0x0
80106bfe:	50                   	push   %eax
80106bff:	e8 ac da ff ff       	call   801046b0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106c04:	58                   	pop    %eax
80106c05:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c0b:	5a                   	pop    %edx
80106c0c:	6a 06                	push   $0x6
80106c0e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c13:	31 d2                	xor    %edx,%edx
80106c15:	50                   	push   %eax
80106c16:	89 f8                	mov    %edi,%eax
80106c18:	e8 13 fd ff ff       	call   80106930 <mappages>
  memmove(mem, init, sz);
80106c1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c20:	89 75 10             	mov    %esi,0x10(%ebp)
80106c23:	83 c4 10             	add    $0x10,%esp
80106c26:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106c29:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c2f:	5b                   	pop    %ebx
80106c30:	5e                   	pop    %esi
80106c31:	5f                   	pop    %edi
80106c32:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106c33:	e9 18 db ff ff       	jmp    80104750 <memmove>
    panic("inituvm: more than a page");
80106c38:	83 ec 0c             	sub    $0xc,%esp
80106c3b:	68 71 7b 10 80       	push   $0x80107b71
80106c40:	e8 3b 97 ff ff       	call   80100380 <panic>
80106c45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c50 <loaduvm>:
{
80106c50:	55                   	push   %ebp
80106c51:	89 e5                	mov    %esp,%ebp
80106c53:	57                   	push   %edi
80106c54:	56                   	push   %esi
80106c55:	53                   	push   %ebx
80106c56:	83 ec 1c             	sub    $0x1c,%esp
80106c59:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c5c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106c5f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106c64:	0f 85 bb 00 00 00    	jne    80106d25 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106c6a:	01 f0                	add    %esi,%eax
80106c6c:	89 f3                	mov    %esi,%ebx
80106c6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c71:	8b 45 14             	mov    0x14(%ebp),%eax
80106c74:	01 f0                	add    %esi,%eax
80106c76:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106c79:	85 f6                	test   %esi,%esi
80106c7b:	0f 84 87 00 00 00    	je     80106d08 <loaduvm+0xb8>
80106c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80106c88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106c8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106c8e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106c90:	89 c2                	mov    %eax,%edx
80106c92:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106c95:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106c98:	f6 c2 01             	test   $0x1,%dl
80106c9b:	75 13                	jne    80106cb0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106c9d:	83 ec 0c             	sub    $0xc,%esp
80106ca0:	68 8b 7b 10 80       	push   $0x80107b8b
80106ca5:	e8 d6 96 ff ff       	call   80100380 <panic>
80106caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106cb0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106cb3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106cb9:	25 fc 0f 00 00       	and    $0xffc,%eax
80106cbe:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106cc5:	85 c0                	test   %eax,%eax
80106cc7:	74 d4                	je     80106c9d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106cc9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ccb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106cce:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106cd3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106cd8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106cde:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ce1:	29 d9                	sub    %ebx,%ecx
80106ce3:	05 00 00 00 80       	add    $0x80000000,%eax
80106ce8:	57                   	push   %edi
80106ce9:	51                   	push   %ecx
80106cea:	50                   	push   %eax
80106ceb:	ff 75 10             	push   0x10(%ebp)
80106cee:	e8 ed ad ff ff       	call   80101ae0 <readi>
80106cf3:	83 c4 10             	add    $0x10,%esp
80106cf6:	39 f8                	cmp    %edi,%eax
80106cf8:	75 1e                	jne    80106d18 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106cfa:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106d00:	89 f0                	mov    %esi,%eax
80106d02:	29 d8                	sub    %ebx,%eax
80106d04:	39 c6                	cmp    %eax,%esi
80106d06:	77 80                	ja     80106c88 <loaduvm+0x38>
}
80106d08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106d0b:	31 c0                	xor    %eax,%eax
}
80106d0d:	5b                   	pop    %ebx
80106d0e:	5e                   	pop    %esi
80106d0f:	5f                   	pop    %edi
80106d10:	5d                   	pop    %ebp
80106d11:	c3                   	ret    
80106d12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d18:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106d1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d20:	5b                   	pop    %ebx
80106d21:	5e                   	pop    %esi
80106d22:	5f                   	pop    %edi
80106d23:	5d                   	pop    %ebp
80106d24:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80106d25:	83 ec 0c             	sub    $0xc,%esp
80106d28:	68 2c 7c 10 80       	push   $0x80107c2c
80106d2d:	e8 4e 96 ff ff       	call   80100380 <panic>
80106d32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d40 <allocuvm>:
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	57                   	push   %edi
80106d44:	56                   	push   %esi
80106d45:	53                   	push   %ebx
80106d46:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106d49:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106d4c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106d4f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d52:	85 c0                	test   %eax,%eax
80106d54:	0f 88 b6 00 00 00    	js     80106e10 <allocuvm+0xd0>
  if(newsz < oldsz)
80106d5a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106d60:	0f 82 9a 00 00 00    	jb     80106e00 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106d66:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106d6c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106d72:	39 75 10             	cmp    %esi,0x10(%ebp)
80106d75:	77 44                	ja     80106dbb <allocuvm+0x7b>
80106d77:	e9 87 00 00 00       	jmp    80106e03 <allocuvm+0xc3>
80106d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106d80:	83 ec 04             	sub    $0x4,%esp
80106d83:	68 00 10 00 00       	push   $0x1000
80106d88:	6a 00                	push   $0x0
80106d8a:	50                   	push   %eax
80106d8b:	e8 20 d9 ff ff       	call   801046b0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106d90:	58                   	pop    %eax
80106d91:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d97:	5a                   	pop    %edx
80106d98:	6a 06                	push   $0x6
80106d9a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d9f:	89 f2                	mov    %esi,%edx
80106da1:	50                   	push   %eax
80106da2:	89 f8                	mov    %edi,%eax
80106da4:	e8 87 fb ff ff       	call   80106930 <mappages>
80106da9:	83 c4 10             	add    $0x10,%esp
80106dac:	85 c0                	test   %eax,%eax
80106dae:	78 78                	js     80106e28 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80106db0:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106db6:	39 75 10             	cmp    %esi,0x10(%ebp)
80106db9:	76 48                	jbe    80106e03 <allocuvm+0xc3>
    mem = kalloc();
80106dbb:	e8 10 b9 ff ff       	call   801026d0 <kalloc>
80106dc0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106dc2:	85 c0                	test   %eax,%eax
80106dc4:	75 ba                	jne    80106d80 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106dc6:	83 ec 0c             	sub    $0xc,%esp
80106dc9:	68 a9 7b 10 80       	push   $0x80107ba9
80106dce:	e8 cd 98 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80106dd3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106dd6:	83 c4 10             	add    $0x10,%esp
80106dd9:	39 45 10             	cmp    %eax,0x10(%ebp)
80106ddc:	74 32                	je     80106e10 <allocuvm+0xd0>
80106dde:	8b 55 10             	mov    0x10(%ebp),%edx
80106de1:	89 c1                	mov    %eax,%ecx
80106de3:	89 f8                	mov    %edi,%eax
80106de5:	e8 96 fa ff ff       	call   80106880 <deallocuvm.part.0>
      return 0;
80106dea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106df1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106df4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106df7:	5b                   	pop    %ebx
80106df8:	5e                   	pop    %esi
80106df9:	5f                   	pop    %edi
80106dfa:	5d                   	pop    %ebp
80106dfb:	c3                   	ret    
80106dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80106e00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80106e03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e09:	5b                   	pop    %ebx
80106e0a:	5e                   	pop    %esi
80106e0b:	5f                   	pop    %edi
80106e0c:	5d                   	pop    %ebp
80106e0d:	c3                   	ret    
80106e0e:	66 90                	xchg   %ax,%ax
    return 0;
80106e10:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106e17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e1d:	5b                   	pop    %ebx
80106e1e:	5e                   	pop    %esi
80106e1f:	5f                   	pop    %edi
80106e20:	5d                   	pop    %ebp
80106e21:	c3                   	ret    
80106e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106e28:	83 ec 0c             	sub    $0xc,%esp
80106e2b:	68 c1 7b 10 80       	push   $0x80107bc1
80106e30:	e8 6b 98 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80106e35:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e38:	83 c4 10             	add    $0x10,%esp
80106e3b:	39 45 10             	cmp    %eax,0x10(%ebp)
80106e3e:	74 0c                	je     80106e4c <allocuvm+0x10c>
80106e40:	8b 55 10             	mov    0x10(%ebp),%edx
80106e43:	89 c1                	mov    %eax,%ecx
80106e45:	89 f8                	mov    %edi,%eax
80106e47:	e8 34 fa ff ff       	call   80106880 <deallocuvm.part.0>
      kfree(mem);
80106e4c:	83 ec 0c             	sub    $0xc,%esp
80106e4f:	53                   	push   %ebx
80106e50:	e8 bb b6 ff ff       	call   80102510 <kfree>
      return 0;
80106e55:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106e5c:	83 c4 10             	add    $0x10,%esp
}
80106e5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e62:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e65:	5b                   	pop    %ebx
80106e66:	5e                   	pop    %esi
80106e67:	5f                   	pop    %edi
80106e68:	5d                   	pop    %ebp
80106e69:	c3                   	ret    
80106e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e70 <deallocuvm>:
{
80106e70:	55                   	push   %ebp
80106e71:	89 e5                	mov    %esp,%ebp
80106e73:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e76:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106e79:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106e7c:	39 d1                	cmp    %edx,%ecx
80106e7e:	73 10                	jae    80106e90 <deallocuvm+0x20>
}
80106e80:	5d                   	pop    %ebp
80106e81:	e9 fa f9 ff ff       	jmp    80106880 <deallocuvm.part.0>
80106e86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e8d:	8d 76 00             	lea    0x0(%esi),%esi
80106e90:	89 d0                	mov    %edx,%eax
80106e92:	5d                   	pop    %ebp
80106e93:	c3                   	ret    
80106e94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e9f:	90                   	nop

80106ea0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
80106ea3:	57                   	push   %edi
80106ea4:	56                   	push   %esi
80106ea5:	53                   	push   %ebx
80106ea6:	83 ec 0c             	sub    $0xc,%esp
80106ea9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106eac:	85 f6                	test   %esi,%esi
80106eae:	74 59                	je     80106f09 <freevm+0x69>
  if(newsz >= oldsz)
80106eb0:	31 c9                	xor    %ecx,%ecx
80106eb2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106eb7:	89 f0                	mov    %esi,%eax
80106eb9:	89 f3                	mov    %esi,%ebx
80106ebb:	e8 c0 f9 ff ff       	call   80106880 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ec0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106ec6:	eb 0f                	jmp    80106ed7 <freevm+0x37>
80106ec8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ecf:	90                   	nop
80106ed0:	83 c3 04             	add    $0x4,%ebx
80106ed3:	39 df                	cmp    %ebx,%edi
80106ed5:	74 23                	je     80106efa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106ed7:	8b 03                	mov    (%ebx),%eax
80106ed9:	a8 01                	test   $0x1,%al
80106edb:	74 f3                	je     80106ed0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106edd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106ee2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106ee5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106ee8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106eed:	50                   	push   %eax
80106eee:	e8 1d b6 ff ff       	call   80102510 <kfree>
80106ef3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106ef6:	39 df                	cmp    %ebx,%edi
80106ef8:	75 dd                	jne    80106ed7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106efa:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106efd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f00:	5b                   	pop    %ebx
80106f01:	5e                   	pop    %esi
80106f02:	5f                   	pop    %edi
80106f03:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106f04:	e9 07 b6 ff ff       	jmp    80102510 <kfree>
    panic("freevm: no pgdir");
80106f09:	83 ec 0c             	sub    $0xc,%esp
80106f0c:	68 dd 7b 10 80       	push   $0x80107bdd
80106f11:	e8 6a 94 ff ff       	call   80100380 <panic>
80106f16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f1d:	8d 76 00             	lea    0x0(%esi),%esi

80106f20 <setupkvm>:
{
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	56                   	push   %esi
80106f24:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106f25:	e8 a6 b7 ff ff       	call   801026d0 <kalloc>
80106f2a:	89 c6                	mov    %eax,%esi
80106f2c:	85 c0                	test   %eax,%eax
80106f2e:	74 42                	je     80106f72 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106f30:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f33:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106f38:	68 00 10 00 00       	push   $0x1000
80106f3d:	6a 00                	push   $0x0
80106f3f:	50                   	push   %eax
80106f40:	e8 6b d7 ff ff       	call   801046b0 <memset>
80106f45:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106f48:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106f4b:	83 ec 08             	sub    $0x8,%esp
80106f4e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106f51:	ff 73 0c             	push   0xc(%ebx)
80106f54:	8b 13                	mov    (%ebx),%edx
80106f56:	50                   	push   %eax
80106f57:	29 c1                	sub    %eax,%ecx
80106f59:	89 f0                	mov    %esi,%eax
80106f5b:	e8 d0 f9 ff ff       	call   80106930 <mappages>
80106f60:	83 c4 10             	add    $0x10,%esp
80106f63:	85 c0                	test   %eax,%eax
80106f65:	78 19                	js     80106f80 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f67:	83 c3 10             	add    $0x10,%ebx
80106f6a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106f70:	75 d6                	jne    80106f48 <setupkvm+0x28>
}
80106f72:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f75:	89 f0                	mov    %esi,%eax
80106f77:	5b                   	pop    %ebx
80106f78:	5e                   	pop    %esi
80106f79:	5d                   	pop    %ebp
80106f7a:	c3                   	ret    
80106f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f7f:	90                   	nop
      freevm(pgdir);
80106f80:	83 ec 0c             	sub    $0xc,%esp
80106f83:	56                   	push   %esi
      return 0;
80106f84:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106f86:	e8 15 ff ff ff       	call   80106ea0 <freevm>
      return 0;
80106f8b:	83 c4 10             	add    $0x10,%esp
}
80106f8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f91:	89 f0                	mov    %esi,%eax
80106f93:	5b                   	pop    %ebx
80106f94:	5e                   	pop    %esi
80106f95:	5d                   	pop    %ebp
80106f96:	c3                   	ret    
80106f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f9e:	66 90                	xchg   %ax,%ax

80106fa0 <kvmalloc>:
{
80106fa0:	55                   	push   %ebp
80106fa1:	89 e5                	mov    %esp,%ebp
80106fa3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106fa6:	e8 75 ff ff ff       	call   80106f20 <setupkvm>
80106fab:	a3 e4 47 11 80       	mov    %eax,0x801147e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106fb0:	05 00 00 00 80       	add    $0x80000000,%eax
80106fb5:	0f 22 d8             	mov    %eax,%cr3
}
80106fb8:	c9                   	leave  
80106fb9:	c3                   	ret    
80106fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106fc0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106fc0:	55                   	push   %ebp
80106fc1:	89 e5                	mov    %esp,%ebp
80106fc3:	83 ec 08             	sub    $0x8,%esp
80106fc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106fc9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80106fcc:	89 c1                	mov    %eax,%ecx
80106fce:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106fd1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80106fd4:	f6 c2 01             	test   $0x1,%dl
80106fd7:	75 17                	jne    80106ff0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106fd9:	83 ec 0c             	sub    $0xc,%esp
80106fdc:	68 ee 7b 10 80       	push   $0x80107bee
80106fe1:	e8 9a 93 ff ff       	call   80100380 <panic>
80106fe6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fed:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106ff0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ff3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106ff9:	25 fc 0f 00 00       	and    $0xffc,%eax
80106ffe:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107005:	85 c0                	test   %eax,%eax
80107007:	74 d0                	je     80106fd9 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107009:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010700c:	c9                   	leave  
8010700d:	c3                   	ret    
8010700e:	66 90                	xchg   %ax,%ax

80107010 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	57                   	push   %edi
80107014:	56                   	push   %esi
80107015:	53                   	push   %ebx
80107016:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107019:	e8 02 ff ff ff       	call   80106f20 <setupkvm>
8010701e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107021:	85 c0                	test   %eax,%eax
80107023:	0f 84 bd 00 00 00    	je     801070e6 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107029:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010702c:	85 c9                	test   %ecx,%ecx
8010702e:	0f 84 b2 00 00 00    	je     801070e6 <copyuvm+0xd6>
80107034:	31 f6                	xor    %esi,%esi
80107036:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010703d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107040:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107043:	89 f0                	mov    %esi,%eax
80107045:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107048:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010704b:	a8 01                	test   $0x1,%al
8010704d:	75 11                	jne    80107060 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010704f:	83 ec 0c             	sub    $0xc,%esp
80107052:	68 f8 7b 10 80       	push   $0x80107bf8
80107057:	e8 24 93 ff ff       	call   80100380 <panic>
8010705c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107060:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107062:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107067:	c1 ea 0a             	shr    $0xa,%edx
8010706a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107070:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107077:	85 c0                	test   %eax,%eax
80107079:	74 d4                	je     8010704f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010707b:	8b 00                	mov    (%eax),%eax
8010707d:	a8 01                	test   $0x1,%al
8010707f:	0f 84 9f 00 00 00    	je     80107124 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107085:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107087:	25 ff 0f 00 00       	and    $0xfff,%eax
8010708c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010708f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107095:	e8 36 b6 ff ff       	call   801026d0 <kalloc>
8010709a:	89 c3                	mov    %eax,%ebx
8010709c:	85 c0                	test   %eax,%eax
8010709e:	74 64                	je     80107104 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801070a0:	83 ec 04             	sub    $0x4,%esp
801070a3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801070a9:	68 00 10 00 00       	push   $0x1000
801070ae:	57                   	push   %edi
801070af:	50                   	push   %eax
801070b0:	e8 9b d6 ff ff       	call   80104750 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801070b5:	58                   	pop    %eax
801070b6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801070bc:	5a                   	pop    %edx
801070bd:	ff 75 e4             	push   -0x1c(%ebp)
801070c0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801070c5:	89 f2                	mov    %esi,%edx
801070c7:	50                   	push   %eax
801070c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070cb:	e8 60 f8 ff ff       	call   80106930 <mappages>
801070d0:	83 c4 10             	add    $0x10,%esp
801070d3:	85 c0                	test   %eax,%eax
801070d5:	78 21                	js     801070f8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801070d7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801070dd:	39 75 0c             	cmp    %esi,0xc(%ebp)
801070e0:	0f 87 5a ff ff ff    	ja     80107040 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801070e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070ec:	5b                   	pop    %ebx
801070ed:	5e                   	pop    %esi
801070ee:	5f                   	pop    %edi
801070ef:	5d                   	pop    %ebp
801070f0:	c3                   	ret    
801070f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801070f8:	83 ec 0c             	sub    $0xc,%esp
801070fb:	53                   	push   %ebx
801070fc:	e8 0f b4 ff ff       	call   80102510 <kfree>
      goto bad;
80107101:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107104:	83 ec 0c             	sub    $0xc,%esp
80107107:	ff 75 e0             	push   -0x20(%ebp)
8010710a:	e8 91 fd ff ff       	call   80106ea0 <freevm>
  return 0;
8010710f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107116:	83 c4 10             	add    $0x10,%esp
}
80107119:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010711c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010711f:	5b                   	pop    %ebx
80107120:	5e                   	pop    %esi
80107121:	5f                   	pop    %edi
80107122:	5d                   	pop    %ebp
80107123:	c3                   	ret    
      panic("copyuvm: page not present");
80107124:	83 ec 0c             	sub    $0xc,%esp
80107127:	68 12 7c 10 80       	push   $0x80107c12
8010712c:	e8 4f 92 ff ff       	call   80100380 <panic>
80107131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107138:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010713f:	90                   	nop

80107140 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107146:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107149:	89 c1                	mov    %eax,%ecx
8010714b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010714e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107151:	f6 c2 01             	test   $0x1,%dl
80107154:	0f 84 00 01 00 00    	je     8010725a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010715a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010715d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107163:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107164:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107169:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107170:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107172:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107177:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010717a:	05 00 00 00 80       	add    $0x80000000,%eax
8010717f:	83 fa 05             	cmp    $0x5,%edx
80107182:	ba 00 00 00 00       	mov    $0x0,%edx
80107187:	0f 45 c2             	cmovne %edx,%eax
}
8010718a:	c3                   	ret    
8010718b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010718f:	90                   	nop

80107190 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107190:	55                   	push   %ebp
80107191:	89 e5                	mov    %esp,%ebp
80107193:	57                   	push   %edi
80107194:	56                   	push   %esi
80107195:	53                   	push   %ebx
80107196:	83 ec 0c             	sub    $0xc,%esp
80107199:	8b 75 14             	mov    0x14(%ebp),%esi
8010719c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010719f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801071a2:	85 f6                	test   %esi,%esi
801071a4:	75 51                	jne    801071f7 <copyout+0x67>
801071a6:	e9 a5 00 00 00       	jmp    80107250 <copyout+0xc0>
801071ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801071af:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
801071b0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801071b6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801071bc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801071c2:	74 75                	je     80107239 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
801071c4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801071c6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
801071c9:	29 c3                	sub    %eax,%ebx
801071cb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071d1:	39 f3                	cmp    %esi,%ebx
801071d3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801071d6:	29 f8                	sub    %edi,%eax
801071d8:	83 ec 04             	sub    $0x4,%esp
801071db:	01 c1                	add    %eax,%ecx
801071dd:	53                   	push   %ebx
801071de:	52                   	push   %edx
801071df:	51                   	push   %ecx
801071e0:	e8 6b d5 ff ff       	call   80104750 <memmove>
    len -= n;
    buf += n;
801071e5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801071e8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801071ee:	83 c4 10             	add    $0x10,%esp
    buf += n;
801071f1:	01 da                	add    %ebx,%edx
  while(len > 0){
801071f3:	29 de                	sub    %ebx,%esi
801071f5:	74 59                	je     80107250 <copyout+0xc0>
  if(*pde & PTE_P){
801071f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801071fa:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801071fc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801071fe:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107201:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107207:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010720a:	f6 c1 01             	test   $0x1,%cl
8010720d:	0f 84 4e 00 00 00    	je     80107261 <copyout.cold>
  return &pgtab[PTX(va)];
80107213:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107215:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010721b:	c1 eb 0c             	shr    $0xc,%ebx
8010721e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107224:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010722b:	89 d9                	mov    %ebx,%ecx
8010722d:	83 e1 05             	and    $0x5,%ecx
80107230:	83 f9 05             	cmp    $0x5,%ecx
80107233:	0f 84 77 ff ff ff    	je     801071b0 <copyout+0x20>
  }
  return 0;
}
80107239:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010723c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107241:	5b                   	pop    %ebx
80107242:	5e                   	pop    %esi
80107243:	5f                   	pop    %edi
80107244:	5d                   	pop    %ebp
80107245:	c3                   	ret    
80107246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010724d:	8d 76 00             	lea    0x0(%esi),%esi
80107250:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107253:	31 c0                	xor    %eax,%eax
}
80107255:	5b                   	pop    %ebx
80107256:	5e                   	pop    %esi
80107257:	5f                   	pop    %edi
80107258:	5d                   	pop    %ebp
80107259:	c3                   	ret    

8010725a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010725a:	a1 00 00 00 00       	mov    0x0,%eax
8010725f:	0f 0b                	ud2    

80107261 <copyout.cold>:
80107261:	a1 00 00 00 00       	mov    0x0,%eax
80107266:	0f 0b                	ud2    
