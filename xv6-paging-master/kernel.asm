
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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 40 30 10 80       	mov    $0x80103040,%eax
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
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 70 10 80       	push   $0x801070e0
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 05 43 00 00       	call   80104360 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 70 10 80       	push   $0x801070e7
80100097:	50                   	push   %eax
80100098:	e8 b3 41 00 00       	call   80104250 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <write_page_to_disk>:
/* Write 4096 bytes pg to the eight consecutive
 * starting at blk.
 */
void
write_page_to_disk(uint dev, char *pg, uint blk)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
}
801000d3:	5d                   	pop    %ebp
801000d4:	c3                   	ret    
801000d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801000d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000e0 <read_page_from_disk>:
801000e0:	55                   	push   %ebp
801000e1:	89 e5                	mov    %esp,%ebp
801000e3:	5d                   	pop    %ebp
801000e4:	c3                   	ret    
801000e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801000e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000f0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000f0:	55                   	push   %ebp
801000f1:	89 e5                	mov    %esp,%ebp
801000f3:	57                   	push   %edi
801000f4:	56                   	push   %esi
801000f5:	53                   	push   %ebx
801000f6:	83 ec 18             	sub    $0x18,%esp
801000f9:	8b 75 08             	mov    0x8(%ebp),%esi
801000fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000ff:	68 c0 b5 10 80       	push   $0x8010b5c0
80100104:	e8 47 43 00 00       	call   80104450 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100109:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
8010010f:	83 c4 10             	add    $0x10,%esp
80100112:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100118:	75 11                	jne    8010012b <bread+0x3b>
8010011a:	eb 24                	jmp    80100140 <bread+0x50>
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100120:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100123:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100129:	74 15                	je     80100140 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010012b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010012e:	75 f0                	jne    80100120 <bread+0x30>
80100130:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100133:	75 eb                	jne    80100120 <bread+0x30>
      b->refcnt++;
80100135:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100139:	eb 3f                	jmp    8010017a <bread+0x8a>
8010013b:	90                   	nop
8010013c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100140:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100146:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010014c:	75 0d                	jne    8010015b <bread+0x6b>
8010014e:	eb 60                	jmp    801001b0 <bread+0xc0>
80100150:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100153:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100159:	74 55                	je     801001b0 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010015b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010015e:	85 c0                	test   %eax,%eax
80100160:	75 ee                	jne    80100150 <bread+0x60>
80100162:	f6 03 04             	testb  $0x4,(%ebx)
80100165:	75 e9                	jne    80100150 <bread+0x60>
      b->dev = dev;
80100167:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010016a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010016d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100173:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100182:	e8 e9 43 00 00       	call   80104570 <release>
      acquiresleep(&b->lock);
80100187:	8d 43 0c             	lea    0xc(%ebx),%eax
8010018a:	89 04 24             	mov    %eax,(%esp)
8010018d:	e8 fe 40 00 00       	call   80104290 <acquiresleep>
80100192:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100195:	f6 03 02             	testb  $0x2,(%ebx)
80100198:	75 0c                	jne    801001a6 <bread+0xb6>
    iderw(b);
8010019a:	83 ec 0c             	sub    $0xc,%esp
8010019d:	53                   	push   %ebx
8010019e:	e8 1d 21 00 00       	call   801022c0 <iderw>
801001a3:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
801001a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801001a9:	89 d8                	mov    %ebx,%eax
801001ab:	5b                   	pop    %ebx
801001ac:	5e                   	pop    %esi
801001ad:	5f                   	pop    %edi
801001ae:	5d                   	pop    %ebp
801001af:	c3                   	ret    
  panic("bget: no buffers");
801001b0:	83 ec 0c             	sub    $0xc,%esp
801001b3:	68 ee 70 10 80       	push   $0x801070ee
801001b8:	e8 f3 01 00 00       	call   801003b0 <panic>
801001bd:	8d 76 00             	lea    0x0(%esi),%esi

801001c0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001c0:	55                   	push   %ebp
801001c1:	89 e5                	mov    %esp,%ebp
801001c3:	53                   	push   %ebx
801001c4:	83 ec 10             	sub    $0x10,%esp
801001c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ca:	8d 43 0c             	lea    0xc(%ebx),%eax
801001cd:	50                   	push   %eax
801001ce:	e8 5d 41 00 00       	call   80104330 <holdingsleep>
801001d3:	83 c4 10             	add    $0x10,%esp
801001d6:	85 c0                	test   %eax,%eax
801001d8:	74 0f                	je     801001e9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001da:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001dd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001e3:	c9                   	leave  
  iderw(b);
801001e4:	e9 d7 20 00 00       	jmp    801022c0 <iderw>
    panic("bwrite");
801001e9:	83 ec 0c             	sub    $0xc,%esp
801001ec:	68 ff 70 10 80       	push   $0x801070ff
801001f1:	e8 ba 01 00 00       	call   801003b0 <panic>
801001f6:	8d 76 00             	lea    0x0(%esi),%esi
801001f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100200 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100200:	55                   	push   %ebp
80100201:	89 e5                	mov    %esp,%ebp
80100203:	56                   	push   %esi
80100204:	53                   	push   %ebx
80100205:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
80100208:	83 ec 0c             	sub    $0xc,%esp
8010020b:	8d 73 0c             	lea    0xc(%ebx),%esi
8010020e:	56                   	push   %esi
8010020f:	e8 1c 41 00 00       	call   80104330 <holdingsleep>
80100214:	83 c4 10             	add    $0x10,%esp
80100217:	85 c0                	test   %eax,%eax
80100219:	74 66                	je     80100281 <brelse+0x81>
    panic("brelse");
	
  releasesleep(&b->lock);
8010021b:	83 ec 0c             	sub    $0xc,%esp
8010021e:	56                   	push   %esi
8010021f:	e8 cc 40 00 00       	call   801042f0 <releasesleep>

  acquire(&bcache.lock);
80100224:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010022b:	e8 20 42 00 00       	call   80104450 <acquire>
  b->refcnt--;
80100230:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100233:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100236:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100239:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010023b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010023e:	75 2f                	jne    8010026f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100240:	8b 43 54             	mov    0x54(%ebx),%eax
80100243:	8b 53 50             	mov    0x50(%ebx),%edx
80100246:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100249:	8b 43 50             	mov    0x50(%ebx),%eax
8010024c:	8b 53 54             	mov    0x54(%ebx),%edx
8010024f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100252:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100257:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
8010025e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100261:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100266:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100269:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010026f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100276:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100279:	5b                   	pop    %ebx
8010027a:	5e                   	pop    %esi
8010027b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010027c:	e9 ef 42 00 00       	jmp    80104570 <release>
    panic("brelse");
80100281:	83 ec 0c             	sub    $0xc,%esp
80100284:	68 06 71 10 80       	push   $0x80107106
80100289:	e8 22 01 00 00       	call   801003b0 <panic>
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	55                   	push   %ebp
80100291:	89 e5                	mov    %esp,%ebp
80100293:	57                   	push   %edi
80100294:	56                   	push   %esi
80100295:	53                   	push   %ebx
80100296:	83 ec 28             	sub    $0x28,%esp
80100299:	8b 7d 08             	mov    0x8(%ebp),%edi
8010029c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010029f:	57                   	push   %edi
801002a0:	e8 6b 16 00 00       	call   80101910 <iunlock>
  target = n;
  acquire(&cons.lock);
801002a5:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801002ac:	e8 9f 41 00 00       	call   80104450 <acquire>
  while(n > 0){
801002b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002b4:	83 c4 10             	add    $0x10,%esp
801002b7:	31 c0                	xor    %eax,%eax
801002b9:	85 db                	test   %ebx,%ebx
801002bb:	0f 8e a1 00 00 00    	jle    80100362 <consoleread+0xd2>
    while(input.r == input.w){
801002c1:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002c7:	39 15 a4 ff 10 80    	cmp    %edx,0x8010ffa4
801002cd:	74 2c                	je     801002fb <consoleread+0x6b>
801002cf:	eb 5f                	jmp    80100330 <consoleread+0xa0>
801002d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 a5 10 80       	push   $0x8010a520
801002e0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002e5:	e8 06 3c 00 00       	call   80103ef0 <sleep>
    while(input.r == input.w){
801002ea:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002f0:	83 c4 10             	add    $0x10,%esp
801002f3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801002f9:	75 35                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fb:	e8 80 36 00 00       	call   80103980 <myproc>
80100300:	8b 40 24             	mov    0x24(%eax),%eax
80100303:	85 c0                	test   %eax,%eax
80100305:	74 d1                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100307:	83 ec 0c             	sub    $0xc,%esp
8010030a:	68 20 a5 10 80       	push   $0x8010a520
8010030f:	e8 5c 42 00 00       	call   80104570 <release>
        ilock(ip);
80100314:	89 3c 24             	mov    %edi,(%esp)
80100317:	e8 14 15 00 00       	call   80101830 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 42 01             	lea    0x1(%edx),%eax
80100333:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100338:	89 d0                	mov    %edx,%eax
8010033a:	83 e0 7f             	and    $0x7f,%eax
8010033d:	0f be 80 20 ff 10 80 	movsbl -0x7fef00e0(%eax),%eax
    if(c == C('D')){  // EOF
80100344:	83 f8 04             	cmp    $0x4,%eax
80100347:	74 3f                	je     80100388 <consoleread+0xf8>
    *dst++ = c;
80100349:	83 c6 01             	add    $0x1,%esi
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010034f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100352:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100355:	74 43                	je     8010039a <consoleread+0x10a>
  while(n > 0){
80100357:	85 db                	test   %ebx,%ebx
80100359:	0f 85 62 ff ff ff    	jne    801002c1 <consoleread+0x31>
8010035f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100362:	83 ec 0c             	sub    $0xc,%esp
80100365:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100368:	68 20 a5 10 80       	push   $0x8010a520
8010036d:	e8 fe 41 00 00       	call   80104570 <release>
  ilock(ip);
80100372:	89 3c 24             	mov    %edi,(%esp)
80100375:	e8 b6 14 00 00       	call   80101830 <ilock>
  return target - n;
8010037a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010037d:	83 c4 10             	add    $0x10,%esp
}
80100380:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100383:	5b                   	pop    %ebx
80100384:	5e                   	pop    %esi
80100385:	5f                   	pop    %edi
80100386:	5d                   	pop    %ebp
80100387:	c3                   	ret    
80100388:	8b 45 10             	mov    0x10(%ebp),%eax
8010038b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010038d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100390:	73 d0                	jae    80100362 <consoleread+0xd2>
        input.r--;
80100392:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100398:	eb c8                	jmp    80100362 <consoleread+0xd2>
8010039a:	8b 45 10             	mov    0x10(%ebp),%eax
8010039d:	29 d8                	sub    %ebx,%eax
8010039f:	eb c1                	jmp    80100362 <consoleread+0xd2>
801003a1:	eb 0d                	jmp    801003b0 <panic>
801003a3:	90                   	nop
801003a4:	90                   	nop
801003a5:	90                   	nop
801003a6:	90                   	nop
801003a7:	90                   	nop
801003a8:	90                   	nop
801003a9:	90                   	nop
801003aa:	90                   	nop
801003ab:	90                   	nop
801003ac:	90                   	nop
801003ad:	90                   	nop
801003ae:	90                   	nop
801003af:	90                   	nop

801003b0 <panic>:
{
801003b0:	55                   	push   %ebp
801003b1:	89 e5                	mov    %esp,%ebp
801003b3:	56                   	push   %esi
801003b4:	53                   	push   %ebx
801003b5:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
801003b8:	fa                   	cli    
  cons.locking = 0;
801003b9:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003c0:	00 00 00 
  getcallerpcs(&s, pcs);
801003c3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003c6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003c9:	e8 02 25 00 00       	call   801028d0 <lapicid>
801003ce:	83 ec 08             	sub    $0x8,%esp
801003d1:	50                   	push   %eax
801003d2:	68 0d 71 10 80       	push   $0x8010710d
801003d7:	e8 a4 02 00 00       	call   80100680 <cprintf>
  cprintf(s);
801003dc:	58                   	pop    %eax
801003dd:	ff 75 08             	pushl  0x8(%ebp)
801003e0:	e8 9b 02 00 00       	call   80100680 <cprintf>
  cprintf("\n");
801003e5:	c7 04 24 07 72 10 80 	movl   $0x80107207,(%esp)
801003ec:	e8 8f 02 00 00       	call   80100680 <cprintf>
  getcallerpcs(&s, pcs);
801003f1:	5a                   	pop    %edx
801003f2:	8d 45 08             	lea    0x8(%ebp),%eax
801003f5:	59                   	pop    %ecx
801003f6:	53                   	push   %ebx
801003f7:	50                   	push   %eax
801003f8:	e8 83 3f 00 00       	call   80104380 <getcallerpcs>
801003fd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
80100400:	83 ec 08             	sub    $0x8,%esp
80100403:	ff 33                	pushl  (%ebx)
80100405:	83 c3 04             	add    $0x4,%ebx
80100408:	68 21 71 10 80       	push   $0x80107121
8010040d:	e8 6e 02 00 00       	call   80100680 <cprintf>
  for(i=0; i<10; i++)
80100412:	83 c4 10             	add    $0x10,%esp
80100415:	39 f3                	cmp    %esi,%ebx
80100417:	75 e7                	jne    80100400 <panic+0x50>
  panicked = 1; // freeze other CPU
80100419:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100420:	00 00 00 
80100423:	eb fe                	jmp    80100423 <panic+0x73>
80100425:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100430 <consputc>:
  if(panicked){
80100430:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100436:	85 c9                	test   %ecx,%ecx
80100438:	74 06                	je     80100440 <consputc+0x10>
8010043a:	fa                   	cli    
8010043b:	eb fe                	jmp    8010043b <consputc+0xb>
8010043d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100440:	55                   	push   %ebp
80100441:	89 e5                	mov    %esp,%ebp
80100443:	57                   	push   %edi
80100444:	56                   	push   %esi
80100445:	53                   	push   %ebx
80100446:	89 c6                	mov    %eax,%esi
80100448:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010044b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100450:	0f 84 b1 00 00 00    	je     80100507 <consputc+0xd7>
    uartputc(c);
80100456:	83 ec 0c             	sub    $0xc,%esp
80100459:	50                   	push   %eax
8010045a:	e8 71 58 00 00       	call   80105cd0 <uartputc>
8010045f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100462:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100467:	b8 0e 00 00 00       	mov    $0xe,%eax
8010046c:	89 da                	mov    %ebx,%edx
8010046e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010046f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100474:	89 ca                	mov    %ecx,%edx
80100476:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100477:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010047a:	89 da                	mov    %ebx,%edx
8010047c:	c1 e0 08             	shl    $0x8,%eax
8010047f:	89 c7                	mov    %eax,%edi
80100481:	b8 0f 00 00 00       	mov    $0xf,%eax
80100486:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100487:	89 ca                	mov    %ecx,%edx
80100489:	ec                   	in     (%dx),%al
8010048a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010048d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010048f:	83 fe 0a             	cmp    $0xa,%esi
80100492:	0f 84 f3 00 00 00    	je     8010058b <consputc+0x15b>
  else if(c == BACKSPACE){
80100498:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010049e:	0f 84 d7 00 00 00    	je     8010057b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004a4:	89 f0                	mov    %esi,%eax
801004a6:	0f b6 c0             	movzbl %al,%eax
801004a9:	80 cc 07             	or     $0x7,%ah
801004ac:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004b3:	80 
801004b4:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
801004b7:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
801004bd:	0f 8f ab 00 00 00    	jg     8010056e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004c3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004c9:	7f 66                	jg     80100531 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004cb:	be d4 03 00 00       	mov    $0x3d4,%esi
801004d0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004d5:	89 f2                	mov    %esi,%edx
801004d7:	ee                   	out    %al,(%dx)
801004d8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004dd:	89 d8                	mov    %ebx,%eax
801004df:	c1 f8 08             	sar    $0x8,%eax
801004e2:	89 ca                	mov    %ecx,%edx
801004e4:	ee                   	out    %al,(%dx)
801004e5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ea:	89 f2                	mov    %esi,%edx
801004ec:	ee                   	out    %al,(%dx)
801004ed:	89 d8                	mov    %ebx,%eax
801004ef:	89 ca                	mov    %ecx,%edx
801004f1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004f2:	b8 20 07 00 00       	mov    $0x720,%eax
801004f7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004fe:	80 
}
801004ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100502:	5b                   	pop    %ebx
80100503:	5e                   	pop    %esi
80100504:	5f                   	pop    %edi
80100505:	5d                   	pop    %ebp
80100506:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100507:	83 ec 0c             	sub    $0xc,%esp
8010050a:	6a 08                	push   $0x8
8010050c:	e8 bf 57 00 00       	call   80105cd0 <uartputc>
80100511:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100518:	e8 b3 57 00 00       	call   80105cd0 <uartputc>
8010051d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100524:	e8 a7 57 00 00       	call   80105cd0 <uartputc>
80100529:	83 c4 10             	add    $0x10,%esp
8010052c:	e9 31 ff ff ff       	jmp    80100462 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100531:	52                   	push   %edx
80100532:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100537:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010053a:	68 a0 80 0b 80       	push   $0x800b80a0
8010053f:	68 00 80 0b 80       	push   $0x800b8000
80100544:	e8 37 41 00 00       	call   80104680 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100549:	b8 80 07 00 00       	mov    $0x780,%eax
8010054e:	83 c4 0c             	add    $0xc,%esp
80100551:	29 d8                	sub    %ebx,%eax
80100553:	01 c0                	add    %eax,%eax
80100555:	50                   	push   %eax
80100556:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100559:	6a 00                	push   $0x0
8010055b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100560:	50                   	push   %eax
80100561:	e8 6a 40 00 00       	call   801045d0 <memset>
80100566:	83 c4 10             	add    $0x10,%esp
80100569:	e9 5d ff ff ff       	jmp    801004cb <consputc+0x9b>
    panic("pos under/overflow");
8010056e:	83 ec 0c             	sub    $0xc,%esp
80100571:	68 25 71 10 80       	push   $0x80107125
80100576:	e8 35 fe ff ff       	call   801003b0 <panic>
    if(pos > 0) --pos;
8010057b:	85 db                	test   %ebx,%ebx
8010057d:	0f 84 48 ff ff ff    	je     801004cb <consputc+0x9b>
80100583:	83 eb 01             	sub    $0x1,%ebx
80100586:	e9 2c ff ff ff       	jmp    801004b7 <consputc+0x87>
    pos += 80 - pos%80;
8010058b:	89 d8                	mov    %ebx,%eax
8010058d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100592:	99                   	cltd   
80100593:	f7 f9                	idiv   %ecx
80100595:	29 d1                	sub    %edx,%ecx
80100597:	01 cb                	add    %ecx,%ebx
80100599:	e9 19 ff ff ff       	jmp    801004b7 <consputc+0x87>
8010059e:	66 90                	xchg   %ax,%ax

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	89 d3                	mov    %edx,%ebx
801005a8:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
801005ab:	85 c9                	test   %ecx,%ecx
{
801005ad:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005b0:	74 04                	je     801005b6 <printint+0x16>
801005b2:	85 c0                	test   %eax,%eax
801005b4:	78 5a                	js     80100610 <printint+0x70>
    x = xx;
801005b6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
801005bd:	31 c9                	xor    %ecx,%ecx
801005bf:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005c2:	eb 06                	jmp    801005ca <printint+0x2a>
801005c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005c8:	89 f9                	mov    %edi,%ecx
801005ca:	31 d2                	xor    %edx,%edx
801005cc:	8d 79 01             	lea    0x1(%ecx),%edi
801005cf:	f7 f3                	div    %ebx
801005d1:	0f b6 92 50 71 10 80 	movzbl -0x7fef8eb0(%edx),%edx
  }while((x /= base) != 0);
801005d8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005da:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005dd:	75 e9                	jne    801005c8 <printint+0x28>
  if(sign)
801005df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005e2:	85 c0                	test   %eax,%eax
801005e4:	74 08                	je     801005ee <printint+0x4e>
    buf[i++] = '-';
801005e6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005eb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ee:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005f8:	0f be 03             	movsbl (%ebx),%eax
801005fb:	83 eb 01             	sub    $0x1,%ebx
801005fe:	e8 2d fe ff ff       	call   80100430 <consputc>
  while(--i >= 0)
80100603:	39 f3                	cmp    %esi,%ebx
80100605:	75 f1                	jne    801005f8 <printint+0x58>
}
80100607:	83 c4 2c             	add    $0x2c,%esp
8010060a:	5b                   	pop    %ebx
8010060b:	5e                   	pop    %esi
8010060c:	5f                   	pop    %edi
8010060d:	5d                   	pop    %ebp
8010060e:	c3                   	ret    
8010060f:	90                   	nop
    x = -xx;
80100610:	f7 d8                	neg    %eax
80100612:	eb a9                	jmp    801005bd <printint+0x1d>
80100614:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010061a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100620 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	53                   	push   %ebx
80100626:	83 ec 18             	sub    $0x18,%esp
80100629:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010062c:	ff 75 08             	pushl  0x8(%ebp)
8010062f:	e8 dc 12 00 00       	call   80101910 <iunlock>
  acquire(&cons.lock);
80100634:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010063b:	e8 10 3e 00 00       	call   80104450 <acquire>
  for(i = 0; i < n; i++)
80100640:	83 c4 10             	add    $0x10,%esp
80100643:	85 f6                	test   %esi,%esi
80100645:	7e 18                	jle    8010065f <consolewrite+0x3f>
80100647:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010064a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010064d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100650:	0f b6 07             	movzbl (%edi),%eax
80100653:	83 c7 01             	add    $0x1,%edi
80100656:	e8 d5 fd ff ff       	call   80100430 <consputc>
  for(i = 0; i < n; i++)
8010065b:	39 fb                	cmp    %edi,%ebx
8010065d:	75 f1                	jne    80100650 <consolewrite+0x30>
  release(&cons.lock);
8010065f:	83 ec 0c             	sub    $0xc,%esp
80100662:	68 20 a5 10 80       	push   $0x8010a520
80100667:	e8 04 3f 00 00       	call   80104570 <release>
  ilock(ip);
8010066c:	58                   	pop    %eax
8010066d:	ff 75 08             	pushl  0x8(%ebp)
80100670:	e8 bb 11 00 00       	call   80101830 <ilock>

  return n;
}
80100675:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100678:	89 f0                	mov    %esi,%eax
8010067a:	5b                   	pop    %ebx
8010067b:	5e                   	pop    %esi
8010067c:	5f                   	pop    %edi
8010067d:	5d                   	pop    %ebp
8010067e:	c3                   	ret    
8010067f:	90                   	nop

80100680 <cprintf>:
{
80100680:	55                   	push   %ebp
80100681:	89 e5                	mov    %esp,%ebp
80100683:	57                   	push   %edi
80100684:	56                   	push   %esi
80100685:	53                   	push   %ebx
80100686:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100689:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010068e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100690:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100693:	0f 85 6f 01 00 00    	jne    80100808 <cprintf+0x188>
  if (fmt == 0)
80100699:	8b 45 08             	mov    0x8(%ebp),%eax
8010069c:	85 c0                	test   %eax,%eax
8010069e:	89 c7                	mov    %eax,%edi
801006a0:	0f 84 77 01 00 00    	je     8010081d <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006a6:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006a9:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ac:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
801006ae:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006b1:	85 c0                	test   %eax,%eax
801006b3:	75 56                	jne    8010070b <cprintf+0x8b>
801006b5:	eb 79                	jmp    80100730 <cprintf+0xb0>
801006b7:	89 f6                	mov    %esi,%esi
801006b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006c0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006c3:	85 d2                	test   %edx,%edx
801006c5:	74 69                	je     80100730 <cprintf+0xb0>
801006c7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006ca:	83 fa 70             	cmp    $0x70,%edx
801006cd:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006d0:	0f 84 84 00 00 00    	je     8010075a <cprintf+0xda>
801006d6:	7f 78                	jg     80100750 <cprintf+0xd0>
801006d8:	83 fa 25             	cmp    $0x25,%edx
801006db:	0f 84 ff 00 00 00    	je     801007e0 <cprintf+0x160>
801006e1:	83 fa 64             	cmp    $0x64,%edx
801006e4:	0f 85 8e 00 00 00    	jne    80100778 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006ed:	ba 0a 00 00 00       	mov    $0xa,%edx
801006f2:	8d 48 04             	lea    0x4(%eax),%ecx
801006f5:	8b 00                	mov    (%eax),%eax
801006f7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006fa:	b9 01 00 00 00       	mov    $0x1,%ecx
801006ff:	e8 9c fe ff ff       	call   801005a0 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100704:	0f b6 06             	movzbl (%esi),%eax
80100707:	85 c0                	test   %eax,%eax
80100709:	74 25                	je     80100730 <cprintf+0xb0>
8010070b:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
8010070e:	83 f8 25             	cmp    $0x25,%eax
80100711:	8d 34 17             	lea    (%edi,%edx,1),%esi
80100714:	74 aa                	je     801006c0 <cprintf+0x40>
80100716:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
80100719:	e8 12 fd ff ff       	call   80100430 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071e:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100721:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100724:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100726:	85 c0                	test   %eax,%eax
80100728:	75 e1                	jne    8010070b <cprintf+0x8b>
8010072a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100730:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100733:	85 c0                	test   %eax,%eax
80100735:	74 10                	je     80100747 <cprintf+0xc7>
    release(&cons.lock);
80100737:	83 ec 0c             	sub    $0xc,%esp
8010073a:	68 20 a5 10 80       	push   $0x8010a520
8010073f:	e8 2c 3e 00 00       	call   80104570 <release>
80100744:	83 c4 10             	add    $0x10,%esp
}
80100747:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010074a:	5b                   	pop    %ebx
8010074b:	5e                   	pop    %esi
8010074c:	5f                   	pop    %edi
8010074d:	5d                   	pop    %ebp
8010074e:	c3                   	ret    
8010074f:	90                   	nop
    switch(c){
80100750:	83 fa 73             	cmp    $0x73,%edx
80100753:	74 43                	je     80100798 <cprintf+0x118>
80100755:	83 fa 78             	cmp    $0x78,%edx
80100758:	75 1e                	jne    80100778 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010075a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010075d:	ba 10 00 00 00       	mov    $0x10,%edx
80100762:	8d 48 04             	lea    0x4(%eax),%ecx
80100765:	8b 00                	mov    (%eax),%eax
80100767:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010076a:	31 c9                	xor    %ecx,%ecx
8010076c:	e8 2f fe ff ff       	call   801005a0 <printint>
      break;
80100771:	eb 91                	jmp    80100704 <cprintf+0x84>
80100773:	90                   	nop
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100778:	b8 25 00 00 00       	mov    $0x25,%eax
8010077d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100780:	e8 ab fc ff ff       	call   80100430 <consputc>
      consputc(c);
80100785:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100788:	89 d0                	mov    %edx,%eax
8010078a:	e8 a1 fc ff ff       	call   80100430 <consputc>
      break;
8010078f:	e9 70 ff ff ff       	jmp    80100704 <cprintf+0x84>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100798:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010079b:	8b 10                	mov    (%eax),%edx
8010079d:	8d 48 04             	lea    0x4(%eax),%ecx
801007a0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801007a3:	85 d2                	test   %edx,%edx
801007a5:	74 49                	je     801007f0 <cprintf+0x170>
      for(; *s; s++)
801007a7:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
801007aa:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
801007ad:	84 c0                	test   %al,%al
801007af:	0f 84 4f ff ff ff    	je     80100704 <cprintf+0x84>
801007b5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007b8:	89 d3                	mov    %edx,%ebx
801007ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007c0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007c3:	e8 68 fc ff ff       	call   80100430 <consputc>
      for(; *s; s++)
801007c8:	0f be 03             	movsbl (%ebx),%eax
801007cb:	84 c0                	test   %al,%al
801007cd:	75 f1                	jne    801007c0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007d2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007d8:	e9 27 ff ff ff       	jmp    80100704 <cprintf+0x84>
801007dd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007e0:	b8 25 00 00 00       	mov    $0x25,%eax
801007e5:	e8 46 fc ff ff       	call   80100430 <consputc>
      break;
801007ea:	e9 15 ff ff ff       	jmp    80100704 <cprintf+0x84>
801007ef:	90                   	nop
        s = "(null)";
801007f0:	ba 38 71 10 80       	mov    $0x80107138,%edx
      for(; *s; s++)
801007f5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007f8:	b8 28 00 00 00       	mov    $0x28,%eax
801007fd:	89 d3                	mov    %edx,%ebx
801007ff:	eb bf                	jmp    801007c0 <cprintf+0x140>
80100801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
80100808:	83 ec 0c             	sub    $0xc,%esp
8010080b:	68 20 a5 10 80       	push   $0x8010a520
80100810:	e8 3b 3c 00 00       	call   80104450 <acquire>
80100815:	83 c4 10             	add    $0x10,%esp
80100818:	e9 7c fe ff ff       	jmp    80100699 <cprintf+0x19>
    panic("null fmt");
8010081d:	83 ec 0c             	sub    $0xc,%esp
80100820:	68 3f 71 10 80       	push   $0x8010713f
80100825:	e8 86 fb ff ff       	call   801003b0 <panic>
8010082a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100830 <consoleintr>:
{
80100830:	55                   	push   %ebp
80100831:	89 e5                	mov    %esp,%ebp
80100833:	57                   	push   %edi
80100834:	56                   	push   %esi
80100835:	53                   	push   %ebx
  int c, doprocdump = 0;
80100836:	31 f6                	xor    %esi,%esi
{
80100838:	83 ec 18             	sub    $0x18,%esp
8010083b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010083e:	68 20 a5 10 80       	push   $0x8010a520
80100843:	e8 08 3c 00 00       	call   80104450 <acquire>
  while((c = getc()) >= 0){
80100848:	83 c4 10             	add    $0x10,%esp
8010084b:	90                   	nop
8010084c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	78 48                	js     801008a0 <consoleintr+0x70>
    switch(c){
80100858:	83 ff 10             	cmp    $0x10,%edi
8010085b:	0f 84 e7 00 00 00    	je     80100948 <consoleintr+0x118>
80100861:	7e 5d                	jle    801008c0 <consoleintr+0x90>
80100863:	83 ff 15             	cmp    $0x15,%edi
80100866:	0f 84 ec 00 00 00    	je     80100958 <consoleintr+0x128>
8010086c:	83 ff 7f             	cmp    $0x7f,%edi
8010086f:	75 54                	jne    801008c5 <consoleintr+0x95>
      if(input.e != input.w){
80100871:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100876:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010087c:	74 d2                	je     80100850 <consoleintr+0x20>
        input.e--;
8010087e:	83 e8 01             	sub    $0x1,%eax
80100881:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100886:	b8 00 01 00 00       	mov    $0x100,%eax
8010088b:	e8 a0 fb ff ff       	call   80100430 <consputc>
  while((c = getc()) >= 0){
80100890:	ff d3                	call   *%ebx
80100892:	85 c0                	test   %eax,%eax
80100894:	89 c7                	mov    %eax,%edi
80100896:	79 c0                	jns    80100858 <consoleintr+0x28>
80100898:	90                   	nop
80100899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801008a0:	83 ec 0c             	sub    $0xc,%esp
801008a3:	68 20 a5 10 80       	push   $0x8010a520
801008a8:	e8 c3 3c 00 00       	call   80104570 <release>
  if(doprocdump) {
801008ad:	83 c4 10             	add    $0x10,%esp
801008b0:	85 f6                	test   %esi,%esi
801008b2:	0f 85 f8 00 00 00    	jne    801009b0 <consoleintr+0x180>
}
801008b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801008bb:	5b                   	pop    %ebx
801008bc:	5e                   	pop    %esi
801008bd:	5f                   	pop    %edi
801008be:	5d                   	pop    %ebp
801008bf:	c3                   	ret    
    switch(c){
801008c0:	83 ff 08             	cmp    $0x8,%edi
801008c3:	74 ac                	je     80100871 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008c5:	85 ff                	test   %edi,%edi
801008c7:	74 87                	je     80100850 <consoleintr+0x20>
801008c9:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ce:	89 c2                	mov    %eax,%edx
801008d0:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008d6:	83 fa 7f             	cmp    $0x7f,%edx
801008d9:	0f 87 71 ff ff ff    	ja     80100850 <consoleintr+0x20>
801008df:	8d 50 01             	lea    0x1(%eax),%edx
801008e2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008e5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008e8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008ee:	0f 84 cc 00 00 00    	je     801009c0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008f4:	89 f9                	mov    %edi,%ecx
801008f6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801008fc:	89 f8                	mov    %edi,%eax
801008fe:	e8 2d fb ff ff       	call   80100430 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100903:	83 ff 0a             	cmp    $0xa,%edi
80100906:	0f 84 c5 00 00 00    	je     801009d1 <consoleintr+0x1a1>
8010090c:	83 ff 04             	cmp    $0x4,%edi
8010090f:	0f 84 bc 00 00 00    	je     801009d1 <consoleintr+0x1a1>
80100915:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
8010091a:	83 e8 80             	sub    $0xffffff80,%eax
8010091d:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100923:	0f 85 27 ff ff ff    	jne    80100850 <consoleintr+0x20>
          wakeup(&input.r);
80100929:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010092c:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100931:	68 a0 ff 10 80       	push   $0x8010ffa0
80100936:	e8 75 37 00 00       	call   801040b0 <wakeup>
8010093b:	83 c4 10             	add    $0x10,%esp
8010093e:	e9 0d ff ff ff       	jmp    80100850 <consoleintr+0x20>
80100943:	90                   	nop
80100944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100948:	be 01 00 00 00       	mov    $0x1,%esi
8010094d:	e9 fe fe ff ff       	jmp    80100850 <consoleintr+0x20>
80100952:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100958:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010095d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100963:	75 2b                	jne    80100990 <consoleintr+0x160>
80100965:	e9 e6 fe ff ff       	jmp    80100850 <consoleintr+0x20>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100970:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100975:	b8 00 01 00 00       	mov    $0x100,%eax
8010097a:	e8 b1 fa ff ff       	call   80100430 <consputc>
      while(input.e != input.w &&
8010097f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100984:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010098a:	0f 84 c0 fe ff ff    	je     80100850 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100990:	83 e8 01             	sub    $0x1,%eax
80100993:	89 c2                	mov    %eax,%edx
80100995:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100998:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010099f:	75 cf                	jne    80100970 <consoleintr+0x140>
801009a1:	e9 aa fe ff ff       	jmp    80100850 <consoleintr+0x20>
801009a6:	8d 76 00             	lea    0x0(%esi),%esi
801009a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
801009b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009b3:	5b                   	pop    %ebx
801009b4:	5e                   	pop    %esi
801009b5:	5f                   	pop    %edi
801009b6:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009b7:	e9 d4 37 00 00       	jmp    80104190 <procdump>
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009c0:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
801009c7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009cc:	e8 5f fa ff ff       	call   80100430 <consputc>
801009d1:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801009d6:	e9 4e ff ff ff       	jmp    80100929 <consoleintr+0xf9>
801009db:	90                   	nop
801009dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009e0 <consoleinit>:

void
consoleinit(void)
{
801009e0:	55                   	push   %ebp
801009e1:	89 e5                	mov    %esp,%ebp
801009e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009e6:	68 48 71 10 80       	push   $0x80107148
801009eb:	68 20 a5 10 80       	push   $0x8010a520
801009f0:	e8 6b 39 00 00       	call   80104360 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009f5:	58                   	pop    %eax
801009f6:	5a                   	pop    %edx
801009f7:	6a 00                	push   $0x0
801009f9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009fb:	c7 05 6c 09 11 80 20 	movl   $0x80100620,0x8011096c
80100a02:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a05:	c7 05 68 09 11 80 90 	movl   $0x80100290,0x80110968
80100a0c:	02 10 80 
  cons.locking = 1;
80100a0f:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100a16:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a19:	e8 52 1a 00 00       	call   80102470 <ioapicenable>
}
80100a1e:	83 c4 10             	add    $0x10,%esp
80100a21:	c9                   	leave  
80100a22:	c3                   	ret    
80100a23:	66 90                	xchg   %ax,%ax
80100a25:	66 90                	xchg   %ax,%ax
80100a27:	66 90                	xchg   %ax,%ax
80100a29:	66 90                	xchg   %ax,%ax
80100a2b:	66 90                	xchg   %ax,%ax
80100a2d:	66 90                	xchg   %ax,%ax
80100a2f:	90                   	nop

80100a30 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a30:	55                   	push   %ebp
80100a31:	89 e5                	mov    %esp,%ebp
80100a33:	57                   	push   %edi
80100a34:	56                   	push   %esi
80100a35:	53                   	push   %ebx
80100a36:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a3c:	e8 3f 2f 00 00       	call   80103980 <myproc>
80100a41:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a47:	e8 f4 22 00 00       	call   80102d40 <begin_op>

  if((ip = namei(path)) == 0){
80100a4c:	83 ec 0c             	sub    $0xc,%esp
80100a4f:	ff 75 08             	pushl  0x8(%ebp)
80100a52:	e8 39 16 00 00       	call   80102090 <namei>
80100a57:	83 c4 10             	add    $0x10,%esp
80100a5a:	85 c0                	test   %eax,%eax
80100a5c:	0f 84 91 01 00 00    	je     80100bf3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a62:	83 ec 0c             	sub    $0xc,%esp
80100a65:	89 c3                	mov    %eax,%ebx
80100a67:	50                   	push   %eax
80100a68:	e8 c3 0d 00 00       	call   80101830 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a6d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a73:	6a 34                	push   $0x34
80100a75:	6a 00                	push   $0x0
80100a77:	50                   	push   %eax
80100a78:	53                   	push   %ebx
80100a79:	e8 92 10 00 00       	call   80101b10 <readi>
80100a7e:	83 c4 20             	add    $0x20,%esp
80100a81:	83 f8 34             	cmp    $0x34,%eax
80100a84:	74 22                	je     80100aa8 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a86:	83 ec 0c             	sub    $0xc,%esp
80100a89:	53                   	push   %ebx
80100a8a:	e8 31 10 00 00       	call   80101ac0 <iunlockput>
    end_op();
80100a8f:	e8 1c 23 00 00       	call   80102db0 <end_op>
80100a94:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a9f:	5b                   	pop    %ebx
80100aa0:	5e                   	pop    %esi
80100aa1:	5f                   	pop    %edi
80100aa2:	5d                   	pop    %ebp
80100aa3:	c3                   	ret    
80100aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100aa8:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100aaf:	45 4c 46 
80100ab2:	75 d2                	jne    80100a86 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100ab4:	e8 37 63 00 00       	call   80106df0 <setupkvm>
80100ab9:	85 c0                	test   %eax,%eax
80100abb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100ac1:	74 c3                	je     80100a86 <exec+0x56>
  sz = 0;
80100ac3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ac5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100acc:	00 
80100acd:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ad3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ad9:	0f 84 8c 02 00 00    	je     80100d6b <exec+0x33b>
80100adf:	31 f6                	xor    %esi,%esi
80100ae1:	eb 7f                	jmp    80100b62 <exec+0x132>
80100ae3:	90                   	nop
80100ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ae8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aef:	75 63                	jne    80100b54 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100af1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100af7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100afd:	0f 82 86 00 00 00    	jb     80100b89 <exec+0x159>
80100b03:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b09:	72 7e                	jb     80100b89 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b0b:	83 ec 04             	sub    $0x4,%esp
80100b0e:	50                   	push   %eax
80100b0f:	57                   	push   %edi
80100b10:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b16:	e8 25 61 00 00       	call   80106c40 <allocuvm>
80100b1b:	83 c4 10             	add    $0x10,%esp
80100b1e:	85 c0                	test   %eax,%eax
80100b20:	89 c7                	mov    %eax,%edi
80100b22:	74 65                	je     80100b89 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b24:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b2a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b2f:	75 58                	jne    80100b89 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b31:	83 ec 0c             	sub    $0xc,%esp
80100b34:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b3a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b40:	53                   	push   %ebx
80100b41:	50                   	push   %eax
80100b42:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b48:	e8 33 60 00 00       	call   80106b80 <loaduvm>
80100b4d:	83 c4 20             	add    $0x20,%esp
80100b50:	85 c0                	test   %eax,%eax
80100b52:	78 35                	js     80100b89 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b54:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b5b:	83 c6 01             	add    $0x1,%esi
80100b5e:	39 f0                	cmp    %esi,%eax
80100b60:	7e 3d                	jle    80100b9f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b62:	89 f0                	mov    %esi,%eax
80100b64:	6a 20                	push   $0x20
80100b66:	c1 e0 05             	shl    $0x5,%eax
80100b69:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b6f:	50                   	push   %eax
80100b70:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b76:	50                   	push   %eax
80100b77:	53                   	push   %ebx
80100b78:	e8 93 0f 00 00       	call   80101b10 <readi>
80100b7d:	83 c4 10             	add    $0x10,%esp
80100b80:	83 f8 20             	cmp    $0x20,%eax
80100b83:	0f 84 5f ff ff ff    	je     80100ae8 <exec+0xb8>
    freevm(pgdir);
80100b89:	83 ec 0c             	sub    $0xc,%esp
80100b8c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b92:	e8 d9 61 00 00       	call   80106d70 <freevm>
80100b97:	83 c4 10             	add    $0x10,%esp
80100b9a:	e9 e7 fe ff ff       	jmp    80100a86 <exec+0x56>
80100b9f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100ba5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100bab:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100bb1:	83 ec 0c             	sub    $0xc,%esp
80100bb4:	53                   	push   %ebx
80100bb5:	e8 06 0f 00 00       	call   80101ac0 <iunlockput>
  end_op();
80100bba:	e8 f1 21 00 00       	call   80102db0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100bbf:	83 c4 0c             	add    $0xc,%esp
80100bc2:	56                   	push   %esi
80100bc3:	57                   	push   %edi
80100bc4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bca:	e8 71 60 00 00       	call   80106c40 <allocuvm>
80100bcf:	83 c4 10             	add    $0x10,%esp
80100bd2:	85 c0                	test   %eax,%eax
80100bd4:	89 c6                	mov    %eax,%esi
80100bd6:	75 3a                	jne    80100c12 <exec+0x1e2>
    freevm(pgdir);
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100be1:	e8 8a 61 00 00       	call   80106d70 <freevm>
80100be6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100be9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bee:	e9 a9 fe ff ff       	jmp    80100a9c <exec+0x6c>
    end_op();
80100bf3:	e8 b8 21 00 00       	call   80102db0 <end_op>
    cprintf("exec: fail\n");
80100bf8:	83 ec 0c             	sub    $0xc,%esp
80100bfb:	68 61 71 10 80       	push   $0x80107161
80100c00:	e8 7b fa ff ff       	call   80100680 <cprintf>
    return -1;
80100c05:	83 c4 10             	add    $0x10,%esp
80100c08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c0d:	e9 8a fe ff ff       	jmp    80100a9c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c12:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100c18:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100c1b:	31 ff                	xor    %edi,%edi
80100c1d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c1f:	50                   	push   %eax
80100c20:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c26:	e8 95 62 00 00       	call   80106ec0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c2e:	83 c4 10             	add    $0x10,%esp
80100c31:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c37:	8b 00                	mov    (%eax),%eax
80100c39:	85 c0                	test   %eax,%eax
80100c3b:	74 70                	je     80100cad <exec+0x27d>
80100c3d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c43:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c49:	eb 0a                	jmp    80100c55 <exec+0x225>
80100c4b:	90                   	nop
80100c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c50:	83 ff 20             	cmp    $0x20,%edi
80100c53:	74 83                	je     80100bd8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c55:	83 ec 0c             	sub    $0xc,%esp
80100c58:	50                   	push   %eax
80100c59:	e8 92 3b 00 00       	call   801047f0 <strlen>
80100c5e:	f7 d0                	not    %eax
80100c60:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c62:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c65:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c66:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c69:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c6c:	e8 7f 3b 00 00       	call   801047f0 <strlen>
80100c71:	83 c0 01             	add    $0x1,%eax
80100c74:	50                   	push   %eax
80100c75:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c78:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c7b:	53                   	push   %ebx
80100c7c:	56                   	push   %esi
80100c7d:	e8 ae 63 00 00       	call   80107030 <copyout>
80100c82:	83 c4 20             	add    $0x20,%esp
80100c85:	85 c0                	test   %eax,%eax
80100c87:	0f 88 4b ff ff ff    	js     80100bd8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c90:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c97:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c9a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100ca0:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100ca3:	85 c0                	test   %eax,%eax
80100ca5:	75 a9                	jne    80100c50 <exec+0x220>
80100ca7:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cad:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100cb4:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100cb6:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100cbd:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100cc1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100cc8:	ff ff ff 
  ustack[1] = argc;
80100ccb:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cd1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cd3:	83 c0 0c             	add    $0xc,%eax
80100cd6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cd8:	50                   	push   %eax
80100cd9:	52                   	push   %edx
80100cda:	53                   	push   %ebx
80100cdb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ce1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ce7:	e8 44 63 00 00       	call   80107030 <copyout>
80100cec:	83 c4 10             	add    $0x10,%esp
80100cef:	85 c0                	test   %eax,%eax
80100cf1:	0f 88 e1 fe ff ff    	js     80100bd8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cf7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cfa:	0f b6 00             	movzbl (%eax),%eax
80100cfd:	84 c0                	test   %al,%al
80100cff:	74 17                	je     80100d18 <exec+0x2e8>
80100d01:	8b 55 08             	mov    0x8(%ebp),%edx
80100d04:	89 d1                	mov    %edx,%ecx
80100d06:	83 c1 01             	add    $0x1,%ecx
80100d09:	3c 2f                	cmp    $0x2f,%al
80100d0b:	0f b6 01             	movzbl (%ecx),%eax
80100d0e:	0f 44 d1             	cmove  %ecx,%edx
80100d11:	84 c0                	test   %al,%al
80100d13:	75 f1                	jne    80100d06 <exec+0x2d6>
80100d15:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d18:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100d1e:	50                   	push   %eax
80100d1f:	6a 10                	push   $0x10
80100d21:	ff 75 08             	pushl  0x8(%ebp)
80100d24:	89 f8                	mov    %edi,%eax
80100d26:	83 c0 6c             	add    $0x6c,%eax
80100d29:	50                   	push   %eax
80100d2a:	e8 81 3a 00 00       	call   801047b0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d2f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d35:	89 f9                	mov    %edi,%ecx
80100d37:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d3a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d3d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d3f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d42:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d48:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d4b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d4e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d51:	89 0c 24             	mov    %ecx,(%esp)
80100d54:	e8 97 5c 00 00       	call   801069f0 <switchuvm>
  freevm(oldpgdir);
80100d59:	89 3c 24             	mov    %edi,(%esp)
80100d5c:	e8 0f 60 00 00       	call   80106d70 <freevm>
  return 0;
80100d61:	83 c4 10             	add    $0x10,%esp
80100d64:	31 c0                	xor    %eax,%eax
80100d66:	e9 31 fd ff ff       	jmp    80100a9c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d6b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d70:	e9 3c fe ff ff       	jmp    80100bb1 <exec+0x181>
80100d75:	66 90                	xchg   %ax,%ax
80100d77:	66 90                	xchg   %ax,%ax
80100d79:	66 90                	xchg   %ax,%ax
80100d7b:	66 90                	xchg   %ax,%ax
80100d7d:	66 90                	xchg   %ax,%ax
80100d7f:	90                   	nop

80100d80 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d86:	68 6d 71 10 80       	push   $0x8010716d
80100d8b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d90:	e8 cb 35 00 00       	call   80104360 <initlock>
}
80100d95:	83 c4 10             	add    $0x10,%esp
80100d98:	c9                   	leave  
80100d99:	c3                   	ret    
80100d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100da0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100da0:	55                   	push   %ebp
80100da1:	89 e5                	mov    %esp,%ebp
80100da3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da4:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100da9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100dac:	68 c0 ff 10 80       	push   $0x8010ffc0
80100db1:	e8 9a 36 00 00       	call   80104450 <acquire>
80100db6:	83 c4 10             	add    $0x10,%esp
80100db9:	eb 10                	jmp    80100dcb <filealloc+0x2b>
80100dbb:	90                   	nop
80100dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100dc0:	83 c3 18             	add    $0x18,%ebx
80100dc3:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100dc9:	73 25                	jae    80100df0 <filealloc+0x50>
    if(f->ref == 0){
80100dcb:	8b 43 04             	mov    0x4(%ebx),%eax
80100dce:	85 c0                	test   %eax,%eax
80100dd0:	75 ee                	jne    80100dc0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100dd2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100dd5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100ddc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100de1:	e8 8a 37 00 00       	call   80104570 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100de6:	89 d8                	mov    %ebx,%eax
      return f;
80100de8:	83 c4 10             	add    $0x10,%esp
}
80100deb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dee:	c9                   	leave  
80100def:	c3                   	ret    
  release(&ftable.lock);
80100df0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100df3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100df5:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dfa:	e8 71 37 00 00       	call   80104570 <release>
}
80100dff:	89 d8                	mov    %ebx,%eax
  return 0;
80100e01:	83 c4 10             	add    $0x10,%esp
}
80100e04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e07:	c9                   	leave  
80100e08:	c3                   	ret    
80100e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e10 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	53                   	push   %ebx
80100e14:	83 ec 10             	sub    $0x10,%esp
80100e17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e1a:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e1f:	e8 2c 36 00 00       	call   80104450 <acquire>
  if(f->ref < 1)
80100e24:	8b 43 04             	mov    0x4(%ebx),%eax
80100e27:	83 c4 10             	add    $0x10,%esp
80100e2a:	85 c0                	test   %eax,%eax
80100e2c:	7e 1a                	jle    80100e48 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e2e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e31:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e34:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e37:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e3c:	e8 2f 37 00 00       	call   80104570 <release>
  return f;
}
80100e41:	89 d8                	mov    %ebx,%eax
80100e43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e46:	c9                   	leave  
80100e47:	c3                   	ret    
    panic("filedup");
80100e48:	83 ec 0c             	sub    $0xc,%esp
80100e4b:	68 74 71 10 80       	push   $0x80107174
80100e50:	e8 5b f5 ff ff       	call   801003b0 <panic>
80100e55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e60 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e60:	55                   	push   %ebp
80100e61:	89 e5                	mov    %esp,%ebp
80100e63:	57                   	push   %edi
80100e64:	56                   	push   %esi
80100e65:	53                   	push   %ebx
80100e66:	83 ec 28             	sub    $0x28,%esp
80100e69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e6c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e71:	e8 da 35 00 00       	call   80104450 <acquire>
  if(f->ref < 1)
80100e76:	8b 43 04             	mov    0x4(%ebx),%eax
80100e79:	83 c4 10             	add    $0x10,%esp
80100e7c:	85 c0                	test   %eax,%eax
80100e7e:	0f 8e 9b 00 00 00    	jle    80100f1f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e84:	83 e8 01             	sub    $0x1,%eax
80100e87:	85 c0                	test   %eax,%eax
80100e89:	89 43 04             	mov    %eax,0x4(%ebx)
80100e8c:	74 1a                	je     80100ea8 <fileclose+0x48>
    release(&ftable.lock);
80100e8e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e95:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e98:	5b                   	pop    %ebx
80100e99:	5e                   	pop    %esi
80100e9a:	5f                   	pop    %edi
80100e9b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e9c:	e9 cf 36 00 00       	jmp    80104570 <release>
80100ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100ea8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100eac:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100eae:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100eb1:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100eb4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eba:	88 45 e7             	mov    %al,-0x19(%ebp)
80100ebd:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ec0:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100ec5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ec8:	e8 a3 36 00 00       	call   80104570 <release>
  if(ff.type == FD_PIPE)
80100ecd:	83 c4 10             	add    $0x10,%esp
80100ed0:	83 ff 01             	cmp    $0x1,%edi
80100ed3:	74 13                	je     80100ee8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100ed5:	83 ff 02             	cmp    $0x2,%edi
80100ed8:	74 26                	je     80100f00 <fileclose+0xa0>
}
80100eda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100edd:	5b                   	pop    %ebx
80100ede:	5e                   	pop    %esi
80100edf:	5f                   	pop    %edi
80100ee0:	5d                   	pop    %ebp
80100ee1:	c3                   	ret    
80100ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ee8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100eec:	83 ec 08             	sub    $0x8,%esp
80100eef:	53                   	push   %ebx
80100ef0:	56                   	push   %esi
80100ef1:	e8 fa 25 00 00       	call   801034f0 <pipeclose>
80100ef6:	83 c4 10             	add    $0x10,%esp
80100ef9:	eb df                	jmp    80100eda <fileclose+0x7a>
80100efb:	90                   	nop
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f00:	e8 3b 1e 00 00       	call   80102d40 <begin_op>
    iput(ff.ip);
80100f05:	83 ec 0c             	sub    $0xc,%esp
80100f08:	ff 75 e0             	pushl  -0x20(%ebp)
80100f0b:	e8 50 0a 00 00       	call   80101960 <iput>
    end_op();
80100f10:	83 c4 10             	add    $0x10,%esp
}
80100f13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f16:	5b                   	pop    %ebx
80100f17:	5e                   	pop    %esi
80100f18:	5f                   	pop    %edi
80100f19:	5d                   	pop    %ebp
    end_op();
80100f1a:	e9 91 1e 00 00       	jmp    80102db0 <end_op>
    panic("fileclose");
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	68 7c 71 10 80       	push   $0x8010717c
80100f27:	e8 84 f4 ff ff       	call   801003b0 <panic>
80100f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f30 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	53                   	push   %ebx
80100f34:	83 ec 04             	sub    $0x4,%esp
80100f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f3a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f3d:	75 31                	jne    80100f70 <filestat+0x40>
    ilock(f->ip);
80100f3f:	83 ec 0c             	sub    $0xc,%esp
80100f42:	ff 73 10             	pushl  0x10(%ebx)
80100f45:	e8 e6 08 00 00       	call   80101830 <ilock>
    stati(f->ip, st);
80100f4a:	58                   	pop    %eax
80100f4b:	5a                   	pop    %edx
80100f4c:	ff 75 0c             	pushl  0xc(%ebp)
80100f4f:	ff 73 10             	pushl  0x10(%ebx)
80100f52:	e8 89 0b 00 00       	call   80101ae0 <stati>
    iunlock(f->ip);
80100f57:	59                   	pop    %ecx
80100f58:	ff 73 10             	pushl  0x10(%ebx)
80100f5b:	e8 b0 09 00 00       	call   80101910 <iunlock>
    return 0;
80100f60:	83 c4 10             	add    $0x10,%esp
80100f63:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f68:	c9                   	leave  
80100f69:	c3                   	ret    
80100f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f75:	eb ee                	jmp    80100f65 <filestat+0x35>
80100f77:	89 f6                	mov    %esi,%esi
80100f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f80 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f80:	55                   	push   %ebp
80100f81:	89 e5                	mov    %esp,%ebp
80100f83:	57                   	push   %edi
80100f84:	56                   	push   %esi
80100f85:	53                   	push   %ebx
80100f86:	83 ec 0c             	sub    $0xc,%esp
80100f89:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f8c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f8f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f92:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f96:	74 60                	je     80100ff8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f98:	8b 03                	mov    (%ebx),%eax
80100f9a:	83 f8 01             	cmp    $0x1,%eax
80100f9d:	74 41                	je     80100fe0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f9f:	83 f8 02             	cmp    $0x2,%eax
80100fa2:	75 5b                	jne    80100fff <fileread+0x7f>
    ilock(f->ip);
80100fa4:	83 ec 0c             	sub    $0xc,%esp
80100fa7:	ff 73 10             	pushl  0x10(%ebx)
80100faa:	e8 81 08 00 00       	call   80101830 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100faf:	57                   	push   %edi
80100fb0:	ff 73 14             	pushl  0x14(%ebx)
80100fb3:	56                   	push   %esi
80100fb4:	ff 73 10             	pushl  0x10(%ebx)
80100fb7:	e8 54 0b 00 00       	call   80101b10 <readi>
80100fbc:	83 c4 20             	add    $0x20,%esp
80100fbf:	85 c0                	test   %eax,%eax
80100fc1:	89 c6                	mov    %eax,%esi
80100fc3:	7e 03                	jle    80100fc8 <fileread+0x48>
      f->off += r;
80100fc5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fc8:	83 ec 0c             	sub    $0xc,%esp
80100fcb:	ff 73 10             	pushl  0x10(%ebx)
80100fce:	e8 3d 09 00 00       	call   80101910 <iunlock>
    return r;
80100fd3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fd9:	89 f0                	mov    %esi,%eax
80100fdb:	5b                   	pop    %ebx
80100fdc:	5e                   	pop    %esi
80100fdd:	5f                   	pop    %edi
80100fde:	5d                   	pop    %ebp
80100fdf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fe0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fe3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fe6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fe9:	5b                   	pop    %ebx
80100fea:	5e                   	pop    %esi
80100feb:	5f                   	pop    %edi
80100fec:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fed:	e9 ae 26 00 00       	jmp    801036a0 <piperead>
80100ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100ff8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100ffd:	eb d7                	jmp    80100fd6 <fileread+0x56>
  panic("fileread");
80100fff:	83 ec 0c             	sub    $0xc,%esp
80101002:	68 86 71 10 80       	push   $0x80107186
80101007:	e8 a4 f3 ff ff       	call   801003b0 <panic>
8010100c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101010 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101010:	55                   	push   %ebp
80101011:	89 e5                	mov    %esp,%ebp
80101013:	57                   	push   %edi
80101014:	56                   	push   %esi
80101015:	53                   	push   %ebx
80101016:	83 ec 1c             	sub    $0x1c,%esp
80101019:	8b 75 08             	mov    0x8(%ebp),%esi
8010101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010101f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101023:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101026:	8b 45 10             	mov    0x10(%ebp),%eax
80101029:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010102c:	0f 84 aa 00 00 00    	je     801010dc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101032:	8b 06                	mov    (%esi),%eax
80101034:	83 f8 01             	cmp    $0x1,%eax
80101037:	0f 84 c3 00 00 00    	je     80101100 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103d:	83 f8 02             	cmp    $0x2,%eax
80101040:	0f 85 d9 00 00 00    	jne    8010111f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101046:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101049:	31 ff                	xor    %edi,%edi
    while(i < n){
8010104b:	85 c0                	test   %eax,%eax
8010104d:	7f 34                	jg     80101083 <filewrite+0x73>
8010104f:	e9 9c 00 00 00       	jmp    801010f0 <filewrite+0xe0>
80101054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101058:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010105b:	83 ec 0c             	sub    $0xc,%esp
8010105e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101061:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101064:	e8 a7 08 00 00       	call   80101910 <iunlock>
      end_op();
80101069:	e8 42 1d 00 00       	call   80102db0 <end_op>
8010106e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101071:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101074:	39 c3                	cmp    %eax,%ebx
80101076:	0f 85 96 00 00 00    	jne    80101112 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010107c:	01 df                	add    %ebx,%edi
    while(i < n){
8010107e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101081:	7e 6d                	jle    801010f0 <filewrite+0xe0>
      int n1 = n - i;
80101083:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101086:	b8 00 06 00 00       	mov    $0x600,%eax
8010108b:	29 fb                	sub    %edi,%ebx
8010108d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101093:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101096:	e8 a5 1c 00 00       	call   80102d40 <begin_op>
      ilock(f->ip);
8010109b:	83 ec 0c             	sub    $0xc,%esp
8010109e:	ff 76 10             	pushl  0x10(%esi)
801010a1:	e8 8a 07 00 00       	call   80101830 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801010a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010a9:	53                   	push   %ebx
801010aa:	ff 76 14             	pushl  0x14(%esi)
801010ad:	01 f8                	add    %edi,%eax
801010af:	50                   	push   %eax
801010b0:	ff 76 10             	pushl  0x10(%esi)
801010b3:	e8 58 0b 00 00       	call   80101c10 <writei>
801010b8:	83 c4 20             	add    $0x20,%esp
801010bb:	85 c0                	test   %eax,%eax
801010bd:	7f 99                	jg     80101058 <filewrite+0x48>
      iunlock(f->ip);
801010bf:	83 ec 0c             	sub    $0xc,%esp
801010c2:	ff 76 10             	pushl  0x10(%esi)
801010c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010c8:	e8 43 08 00 00       	call   80101910 <iunlock>
      end_op();
801010cd:	e8 de 1c 00 00       	call   80102db0 <end_op>
      if(r < 0)
801010d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010d5:	83 c4 10             	add    $0x10,%esp
801010d8:	85 c0                	test   %eax,%eax
801010da:	74 98                	je     80101074 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010df:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010e4:	89 f8                	mov    %edi,%eax
801010e6:	5b                   	pop    %ebx
801010e7:	5e                   	pop    %esi
801010e8:	5f                   	pop    %edi
801010e9:	5d                   	pop    %ebp
801010ea:	c3                   	ret    
801010eb:	90                   	nop
801010ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010f0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010f3:	75 e7                	jne    801010dc <filewrite+0xcc>
}
801010f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010f8:	89 f8                	mov    %edi,%eax
801010fa:	5b                   	pop    %ebx
801010fb:	5e                   	pop    %esi
801010fc:	5f                   	pop    %edi
801010fd:	5d                   	pop    %ebp
801010fe:	c3                   	ret    
801010ff:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101100:	8b 46 0c             	mov    0xc(%esi),%eax
80101103:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101106:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101109:	5b                   	pop    %ebx
8010110a:	5e                   	pop    %esi
8010110b:	5f                   	pop    %edi
8010110c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010110d:	e9 7e 24 00 00       	jmp    80103590 <pipewrite>
        panic("short filewrite");
80101112:	83 ec 0c             	sub    $0xc,%esp
80101115:	68 8f 71 10 80       	push   $0x8010718f
8010111a:	e8 91 f2 ff ff       	call   801003b0 <panic>
  panic("filewrite");
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	68 95 71 10 80       	push   $0x80107195
80101127:	e8 84 f2 ff ff       	call   801003b0 <panic>
8010112c:	66 90                	xchg   %ax,%ax
8010112e:	66 90                	xchg   %ax,%ax

80101130 <bzero>:
}

// Zero a block.
static void
bzero(int dev, int bno)
{
80101130:	55                   	push   %ebp
80101131:	89 e5                	mov    %esp,%ebp
80101133:	53                   	push   %ebx
80101134:	83 ec 0c             	sub    $0xc,%esp
  struct buf *bp;

  bp = bread(dev, bno);
80101137:	52                   	push   %edx
80101138:	50                   	push   %eax
80101139:	e8 b2 ef ff ff       	call   801000f0 <bread>
8010113e:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101140:	8d 40 5c             	lea    0x5c(%eax),%eax
80101143:	83 c4 0c             	add    $0xc,%esp
80101146:	68 00 02 00 00       	push   $0x200
8010114b:	6a 00                	push   $0x0
8010114d:	50                   	push   %eax
8010114e:	e8 7d 34 00 00       	call   801045d0 <memset>
  log_write(bp);
80101153:	89 1c 24             	mov    %ebx,(%esp)
80101156:	e8 b5 1d 00 00       	call   80102f10 <log_write>
  brelse(bp);
8010115b:	89 1c 24             	mov    %ebx,(%esp)
8010115e:	e8 9d f0 ff ff       	call   80100200 <brelse>
}
80101163:	83 c4 10             	add    $0x10,%esp
80101166:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101169:	c9                   	leave  
8010116a:	c3                   	ret    
8010116b:	90                   	nop
8010116c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101170 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101170:	55                   	push   %ebp
80101171:	89 e5                	mov    %esp,%ebp
80101173:	57                   	push   %edi
80101174:	56                   	push   %esi
80101175:	53                   	push   %ebx
80101176:	83 ec 1c             	sub    $0x1c,%esp
80101179:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010117c:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101181:	85 c0                	test   %eax,%eax
80101183:	0f 84 8c 00 00 00    	je     80101215 <balloc+0xa5>
80101189:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101190:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101193:	83 ec 08             	sub    $0x8,%esp
80101196:	89 f0                	mov    %esi,%eax
80101198:	c1 f8 0c             	sar    $0xc,%eax
8010119b:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011a1:	50                   	push   %eax
801011a2:	ff 75 d8             	pushl  -0x28(%ebp)
801011a5:	e8 46 ef ff ff       	call   801000f0 <bread>
801011aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ad:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011b2:	83 c4 10             	add    $0x10,%esp
801011b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011b8:	31 c0                	xor    %eax,%eax
801011ba:	eb 30                	jmp    801011ec <balloc+0x7c>
801011bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
801011c0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011c5:	bb 01 00 00 00       	mov    $0x1,%ebx
801011ca:	83 e1 07             	and    $0x7,%ecx
801011cd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011cf:	89 c1                	mov    %eax,%ecx
801011d1:	c1 f9 03             	sar    $0x3,%ecx
801011d4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801011d9:	85 df                	test   %ebx,%edi
801011db:	89 fa                	mov    %edi,%edx
801011dd:	74 49                	je     80101228 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011df:	83 c0 01             	add    $0x1,%eax
801011e2:	83 c6 01             	add    $0x1,%esi
801011e5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011ea:	74 05                	je     801011f1 <balloc+0x81>
801011ec:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801011ef:	77 cf                	ja     801011c0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801011f1:	83 ec 0c             	sub    $0xc,%esp
801011f4:	ff 75 e4             	pushl  -0x1c(%ebp)
801011f7:	e8 04 f0 ff ff       	call   80100200 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801011fc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101203:	83 c4 10             	add    $0x10,%esp
80101206:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101209:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010120f:	0f 87 7b ff ff ff    	ja     80101190 <balloc+0x20>
  }
  panic("balloc: out of blocks");
80101215:	83 ec 0c             	sub    $0xc,%esp
80101218:	68 9f 71 10 80       	push   $0x8010719f
8010121d:	e8 8e f1 ff ff       	call   801003b0 <panic>
80101222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101228:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
8010122b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
8010122e:	09 da                	or     %ebx,%edx
80101230:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80101234:	57                   	push   %edi
80101235:	e8 d6 1c 00 00       	call   80102f10 <log_write>
        brelse(bp);
8010123a:	89 3c 24             	mov    %edi,(%esp)
8010123d:	e8 be ef ff ff       	call   80100200 <brelse>
        bzero(dev, b + bi);
80101242:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101245:	89 f2                	mov    %esi,%edx
80101247:	e8 e4 fe ff ff       	call   80101130 <bzero>
}
8010124c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010124f:	89 f0                	mov    %esi,%eax
80101251:	5b                   	pop    %ebx
80101252:	5e                   	pop    %esi
80101253:	5f                   	pop    %edi
80101254:	5d                   	pop    %ebp
80101255:	c3                   	ret    
80101256:	8d 76 00             	lea    0x0(%esi),%esi
80101259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101260 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101260:	55                   	push   %ebp
80101261:	89 e5                	mov    %esp,%ebp
80101263:	57                   	push   %edi
80101264:	56                   	push   %esi
80101265:	53                   	push   %ebx
80101266:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101268:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010126a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010126f:	83 ec 28             	sub    $0x28,%esp
80101272:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101275:	68 e0 09 11 80       	push   $0x801109e0
8010127a:	e8 d1 31 00 00       	call   80104450 <acquire>
8010127f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101282:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101285:	eb 17                	jmp    8010129e <iget+0x3e>
80101287:	89 f6                	mov    %esi,%esi
80101289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101290:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101296:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010129c:	73 22                	jae    801012c0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010129e:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012a1:	85 c9                	test   %ecx,%ecx
801012a3:	7e 04                	jle    801012a9 <iget+0x49>
801012a5:	39 3b                	cmp    %edi,(%ebx)
801012a7:	74 4f                	je     801012f8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012a9:	85 f6                	test   %esi,%esi
801012ab:	75 e3                	jne    80101290 <iget+0x30>
801012ad:	85 c9                	test   %ecx,%ecx
801012af:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012b2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012b8:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012be:	72 de                	jb     8010129e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012c0:	85 f6                	test   %esi,%esi
801012c2:	74 5b                	je     8010131f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012c4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801012c7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012c9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012cc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012d3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012da:	68 e0 09 11 80       	push   $0x801109e0
801012df:	e8 8c 32 00 00       	call   80104570 <release>

  return ip;
801012e4:	83 c4 10             	add    $0x10,%esp
}
801012e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ea:	89 f0                	mov    %esi,%eax
801012ec:	5b                   	pop    %ebx
801012ed:	5e                   	pop    %esi
801012ee:	5f                   	pop    %edi
801012ef:	5d                   	pop    %ebp
801012f0:	c3                   	ret    
801012f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012f8:	39 53 04             	cmp    %edx,0x4(%ebx)
801012fb:	75 ac                	jne    801012a9 <iget+0x49>
      release(&icache.lock);
801012fd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101300:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101303:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101305:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
8010130a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010130d:	e8 5e 32 00 00       	call   80104570 <release>
      return ip;
80101312:	83 c4 10             	add    $0x10,%esp
}
80101315:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101318:	89 f0                	mov    %esi,%eax
8010131a:	5b                   	pop    %ebx
8010131b:	5e                   	pop    %esi
8010131c:	5f                   	pop    %edi
8010131d:	5d                   	pop    %ebp
8010131e:	c3                   	ret    
    panic("iget: no inodes");
8010131f:	83 ec 0c             	sub    $0xc,%esp
80101322:	68 b5 71 10 80       	push   $0x801071b5
80101327:	e8 84 f0 ff ff       	call   801003b0 <panic>
8010132c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101330 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101330:	55                   	push   %ebp
80101331:	89 e5                	mov    %esp,%ebp
80101333:	57                   	push   %edi
80101334:	56                   	push   %esi
80101335:	53                   	push   %ebx
80101336:	89 c6                	mov    %eax,%esi
80101338:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010133b:	83 fa 0b             	cmp    $0xb,%edx
8010133e:	77 18                	ja     80101358 <bmap+0x28>
80101340:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101343:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101346:	85 db                	test   %ebx,%ebx
80101348:	74 76                	je     801013c0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010134a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010134d:	89 d8                	mov    %ebx,%eax
8010134f:	5b                   	pop    %ebx
80101350:	5e                   	pop    %esi
80101351:	5f                   	pop    %edi
80101352:	5d                   	pop    %ebp
80101353:	c3                   	ret    
80101354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101358:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010135b:	83 fb 7f             	cmp    $0x7f,%ebx
8010135e:	0f 87 90 00 00 00    	ja     801013f4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101364:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010136a:	8b 00                	mov    (%eax),%eax
8010136c:	85 d2                	test   %edx,%edx
8010136e:	74 70                	je     801013e0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101370:	83 ec 08             	sub    $0x8,%esp
80101373:	52                   	push   %edx
80101374:	50                   	push   %eax
80101375:	e8 76 ed ff ff       	call   801000f0 <bread>
    if((addr = a[bn]) == 0){
8010137a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010137e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101381:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101383:	8b 1a                	mov    (%edx),%ebx
80101385:	85 db                	test   %ebx,%ebx
80101387:	75 1d                	jne    801013a6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101389:	8b 06                	mov    (%esi),%eax
8010138b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010138e:	e8 dd fd ff ff       	call   80101170 <balloc>
80101393:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101396:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101399:	89 c3                	mov    %eax,%ebx
8010139b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010139d:	57                   	push   %edi
8010139e:	e8 6d 1b 00 00       	call   80102f10 <log_write>
801013a3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801013a6:	83 ec 0c             	sub    $0xc,%esp
801013a9:	57                   	push   %edi
801013aa:	e8 51 ee ff ff       	call   80100200 <brelse>
801013af:	83 c4 10             	add    $0x10,%esp
}
801013b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013b5:	89 d8                	mov    %ebx,%eax
801013b7:	5b                   	pop    %ebx
801013b8:	5e                   	pop    %esi
801013b9:	5f                   	pop    %edi
801013ba:	5d                   	pop    %ebp
801013bb:	c3                   	ret    
801013bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801013c0:	8b 00                	mov    (%eax),%eax
801013c2:	e8 a9 fd ff ff       	call   80101170 <balloc>
801013c7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801013ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801013cd:	89 c3                	mov    %eax,%ebx
}
801013cf:	89 d8                	mov    %ebx,%eax
801013d1:	5b                   	pop    %ebx
801013d2:	5e                   	pop    %esi
801013d3:	5f                   	pop    %edi
801013d4:	5d                   	pop    %ebp
801013d5:	c3                   	ret    
801013d6:	8d 76 00             	lea    0x0(%esi),%esi
801013d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013e0:	e8 8b fd ff ff       	call   80101170 <balloc>
801013e5:	89 c2                	mov    %eax,%edx
801013e7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013ed:	8b 06                	mov    (%esi),%eax
801013ef:	e9 7c ff ff ff       	jmp    80101370 <bmap+0x40>
  panic("bmap: out of range");
801013f4:	83 ec 0c             	sub    $0xc,%esp
801013f7:	68 c5 71 10 80       	push   $0x801071c5
801013fc:	e8 af ef ff ff       	call   801003b0 <panic>
80101401:	eb 0d                	jmp    80101410 <readsb>
80101403:	90                   	nop
80101404:	90                   	nop
80101405:	90                   	nop
80101406:	90                   	nop
80101407:	90                   	nop
80101408:	90                   	nop
80101409:	90                   	nop
8010140a:	90                   	nop
8010140b:	90                   	nop
8010140c:	90                   	nop
8010140d:	90                   	nop
8010140e:	90                   	nop
8010140f:	90                   	nop

80101410 <readsb>:
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	56                   	push   %esi
80101414:	53                   	push   %ebx
80101415:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101418:	83 ec 08             	sub    $0x8,%esp
8010141b:	6a 01                	push   $0x1
8010141d:	ff 75 08             	pushl  0x8(%ebp)
80101420:	e8 cb ec ff ff       	call   801000f0 <bread>
80101425:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101427:	8d 40 5c             	lea    0x5c(%eax),%eax
8010142a:	83 c4 0c             	add    $0xc,%esp
8010142d:	6a 1c                	push   $0x1c
8010142f:	50                   	push   %eax
80101430:	56                   	push   %esi
80101431:	e8 4a 32 00 00       	call   80104680 <memmove>
  brelse(bp);
80101436:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101439:	83 c4 10             	add    $0x10,%esp
}
8010143c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010143f:	5b                   	pop    %ebx
80101440:	5e                   	pop    %esi
80101441:	5d                   	pop    %ebp
  brelse(bp);
80101442:	e9 b9 ed ff ff       	jmp    80100200 <brelse>
80101447:	89 f6                	mov    %esi,%esi
80101449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101450 <bfree>:
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	56                   	push   %esi
80101454:	53                   	push   %ebx
80101455:	89 d3                	mov    %edx,%ebx
80101457:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101459:	83 ec 08             	sub    $0x8,%esp
8010145c:	68 c0 09 11 80       	push   $0x801109c0
80101461:	50                   	push   %eax
80101462:	e8 a9 ff ff ff       	call   80101410 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101467:	58                   	pop    %eax
80101468:	5a                   	pop    %edx
80101469:	89 da                	mov    %ebx,%edx
8010146b:	c1 ea 0c             	shr    $0xc,%edx
8010146e:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101474:	52                   	push   %edx
80101475:	56                   	push   %esi
80101476:	e8 75 ec ff ff       	call   801000f0 <bread>
  m = 1 << (bi % 8);
8010147b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010147d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101480:	ba 01 00 00 00       	mov    $0x1,%edx
80101485:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101488:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010148e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101491:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101493:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101498:	85 d1                	test   %edx,%ecx
8010149a:	74 25                	je     801014c1 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010149c:	f7 d2                	not    %edx
8010149e:	89 c6                	mov    %eax,%esi
  log_write(bp);
801014a0:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801014a3:	21 ca                	and    %ecx,%edx
801014a5:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
801014a9:	56                   	push   %esi
801014aa:	e8 61 1a 00 00       	call   80102f10 <log_write>
  brelse(bp);
801014af:	89 34 24             	mov    %esi,(%esp)
801014b2:	e8 49 ed ff ff       	call   80100200 <brelse>
}
801014b7:	83 c4 10             	add    $0x10,%esp
801014ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014bd:	5b                   	pop    %ebx
801014be:	5e                   	pop    %esi
801014bf:	5d                   	pop    %ebp
801014c0:	c3                   	ret    
    panic("freeing free block");
801014c1:	83 ec 0c             	sub    $0xc,%esp
801014c4:	68 d8 71 10 80       	push   $0x801071d8
801014c9:	e8 e2 ee ff ff       	call   801003b0 <panic>
801014ce:	66 90                	xchg   %ax,%ax

801014d0 <balloc_page>:
{
801014d0:	55                   	push   %ebp
801014d1:	89 e5                	mov    %esp,%ebp
801014d3:	57                   	push   %edi
801014d4:	56                   	push   %esi
801014d5:	53                   	push   %ebx
801014d6:	83 ec 28             	sub    $0x28,%esp
  cprintf("balloc page\n");
801014d9:	68 eb 71 10 80       	push   $0x801071eb
801014de:	e8 9d f1 ff ff       	call   80100680 <cprintf>
  begin_op();
801014e3:	e8 58 18 00 00       	call   80102d40 <begin_op>
  for(b = 0; b < sb.size; b += BPB){
801014e8:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801014ed:	83 c4 10             	add    $0x10,%esp
801014f0:	85 c0                	test   %eax,%eax
801014f2:	74 64                	je     80101558 <balloc_page+0x88>
801014f4:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
801014f6:	89 f8                	mov    %edi,%eax
801014f8:	83 ec 08             	sub    $0x8,%esp
801014fb:	89 fb                	mov    %edi,%ebx
801014fd:	c1 f8 0c             	sar    $0xc,%eax
80101500:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101506:	50                   	push   %eax
80101507:	ff 75 08             	pushl  0x8(%ebp)
8010150a:	e8 e1 eb ff ff       	call   801000f0 <bread>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010150f:	8b 35 c0 09 11 80    	mov    0x801109c0,%esi
80101515:	83 c4 10             	add    $0x10,%esp
80101518:	31 d2                	xor    %edx,%edx
8010151a:	eb 1e                	jmp    8010153a <balloc_page+0x6a>
8010151c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((bp->data[bi/8] & m) == 0){  // Are 8 consecutive block free?
80101520:	89 d1                	mov    %edx,%ecx
80101522:	c1 f9 03             	sar    $0x3,%ecx
80101525:	80 7c 08 5c 00       	cmpb   $0x0,0x5c(%eax,%ecx,1)
8010152a:	74 3c                	je     80101568 <balloc_page+0x98>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010152c:	83 c2 01             	add    $0x1,%edx
8010152f:	83 c3 01             	add    $0x1,%ebx
80101532:	81 fa 00 10 00 00    	cmp    $0x1000,%edx
80101538:	74 04                	je     8010153e <balloc_page+0x6e>
8010153a:	39 de                	cmp    %ebx,%esi
8010153c:	77 e2                	ja     80101520 <balloc_page+0x50>
    brelse(bp);
8010153e:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
80101541:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
80101547:	50                   	push   %eax
80101548:	e8 b3 ec ff ff       	call   80100200 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010154d:	83 c4 10             	add    $0x10,%esp
80101550:	39 3d c0 09 11 80    	cmp    %edi,0x801109c0
80101556:	77 9e                	ja     801014f6 <balloc_page+0x26>
  panic("balloc: out of blocks");
80101558:	83 ec 0c             	sub    $0xc,%esp
8010155b:	68 9f 71 10 80       	push   $0x8010719f
80101560:	e8 4b ee ff ff       	call   801003b0 <panic>
80101565:	8d 76 00             	lea    0x0(%esi),%esi
	cprintf("%d",bp->data[bi/8]);        
80101568:	83 ec 08             	sub    $0x8,%esp
        bp->data[bi/8] |= m;  // Mark blocks in use.
8010156b:	c6 44 08 5c ff       	movb   $0xff,0x5c(%eax,%ecx,1)
80101570:	89 c6                	mov    %eax,%esi
	cprintf("%d",bp->data[bi/8]);        
80101572:	68 ff 00 00 00       	push   $0xff
80101577:	68 f8 71 10 80       	push   $0x801071f8
8010157c:	e8 ff f0 ff ff       	call   80100680 <cprintf>
	log_write(bp);
80101581:	89 34 24             	mov    %esi,(%esp)
80101584:	e8 87 19 00 00       	call   80102f10 <log_write>
        brelse(bp);
80101589:	89 34 24             	mov    %esi,(%esp)
8010158c:	8d b3 00 10 00 00    	lea    0x1000(%ebx),%esi
80101592:	e8 69 ec ff ff       	call   80100200 <brelse>
80101597:	8b 7d 08             	mov    0x8(%ebp),%edi
8010159a:	83 c4 10             	add    $0x10,%esp
8010159d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
        bzero(dev, b + bi + (BSIZE*i));
801015a0:	89 da                	mov    %ebx,%edx
801015a2:	89 f8                	mov    %edi,%eax
801015a4:	81 c3 00 02 00 00    	add    $0x200,%ebx
801015aa:	e8 81 fb ff ff       	call   80101130 <bzero>
        for(int i=0; i<8;i++){  //Set blocks to 0
801015af:	39 de                	cmp    %ebx,%esi
801015b1:	75 ed                	jne    801015a0 <balloc_page+0xd0>
        cprintf("allocated \n");
801015b3:	83 ec 0c             	sub    $0xc,%esp
801015b6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801015b9:	68 fd 71 10 80       	push   $0x801071fd
801015be:	e8 bd f0 ff ff       	call   80100680 <cprintf>
        end_op();
801015c3:	e8 e8 17 00 00       	call   80102db0 <end_op>
}
801015c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015cb:	89 d8                	mov    %ebx,%eax
801015cd:	5b                   	pop    %ebx
801015ce:	5e                   	pop    %esi
801015cf:	5f                   	pop    %edi
801015d0:	5d                   	pop    %ebp
801015d1:	c3                   	ret    
801015d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801015e0 <bfree_page>:
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	57                   	push   %edi
801015e4:	56                   	push   %esi
801015e5:	53                   	push   %ebx
801015e6:	83 ec 0c             	sub    $0xc,%esp
801015e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801015ec:	8b 7d 08             	mov    0x8(%ebp),%edi
  begin_op();
801015ef:	e8 4c 17 00 00       	call   80102d40 <begin_op>
801015f4:	8d 73 08             	lea    0x8(%ebx),%esi
801015f7:	89 f6                	mov    %esi,%esi
801015f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
cprintf("deallocated \n");
80101600:	83 ec 0c             	sub    $0xc,%esp
80101603:	68 fb 71 10 80       	push   $0x801071fb
80101608:	e8 73 f0 ff ff       	call   80100680 <cprintf>
   bfree(dev,b+i);
8010160d:	89 da                	mov    %ebx,%edx
8010160f:	89 f8                	mov    %edi,%eax
80101611:	83 c3 01             	add    $0x1,%ebx
80101614:	e8 37 fe ff ff       	call   80101450 <bfree>
  for(uint i=0; i<8;i++){
80101619:	83 c4 10             	add    $0x10,%esp
8010161c:	39 f3                	cmp    %esi,%ebx
8010161e:	75 e0                	jne    80101600 <bfree_page+0x20>
}
80101620:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101623:	5b                   	pop    %ebx
80101624:	5e                   	pop    %esi
80101625:	5f                   	pop    %edi
80101626:	5d                   	pop    %ebp
  end_op();
80101627:	e9 84 17 00 00       	jmp    80102db0 <end_op>
8010162c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101630 <iinit>:
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	53                   	push   %ebx
80101634:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101639:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010163c:	68 09 72 10 80       	push   $0x80107209
80101641:	68 e0 09 11 80       	push   $0x801109e0
80101646:	e8 15 2d 00 00       	call   80104360 <initlock>
8010164b:	83 c4 10             	add    $0x10,%esp
8010164e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101650:	83 ec 08             	sub    $0x8,%esp
80101653:	68 10 72 10 80       	push   $0x80107210
80101658:	53                   	push   %ebx
80101659:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010165f:	e8 ec 2b 00 00       	call   80104250 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101664:	83 c4 10             	add    $0x10,%esp
80101667:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010166d:	75 e1                	jne    80101650 <iinit+0x20>
  readsb(dev, &sb);
8010166f:	83 ec 08             	sub    $0x8,%esp
80101672:	68 c0 09 11 80       	push   $0x801109c0
80101677:	ff 75 08             	pushl  0x8(%ebp)
8010167a:	e8 91 fd ff ff       	call   80101410 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010167f:	ff 35 d8 09 11 80    	pushl  0x801109d8
80101685:	ff 35 d4 09 11 80    	pushl  0x801109d4
8010168b:	ff 35 d0 09 11 80    	pushl  0x801109d0
80101691:	ff 35 cc 09 11 80    	pushl  0x801109cc
80101697:	ff 35 c8 09 11 80    	pushl  0x801109c8
8010169d:	ff 35 c4 09 11 80    	pushl  0x801109c4
801016a3:	ff 35 c0 09 11 80    	pushl  0x801109c0
801016a9:	68 74 72 10 80       	push   $0x80107274
801016ae:	e8 cd ef ff ff       	call   80100680 <cprintf>
}
801016b3:	83 c4 30             	add    $0x30,%esp
801016b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016b9:	c9                   	leave  
801016ba:	c3                   	ret    
801016bb:	90                   	nop
801016bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016c0 <ialloc>:
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	57                   	push   %edi
801016c4:	56                   	push   %esi
801016c5:	53                   	push   %ebx
801016c6:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801016c9:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
801016d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801016d3:	8b 75 08             	mov    0x8(%ebp),%esi
801016d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801016d9:	0f 86 91 00 00 00    	jbe    80101770 <ialloc+0xb0>
801016df:	bb 01 00 00 00       	mov    $0x1,%ebx
801016e4:	eb 21                	jmp    80101707 <ialloc+0x47>
801016e6:	8d 76 00             	lea    0x0(%esi),%esi
801016e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
801016f0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801016f3:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
801016f6:	57                   	push   %edi
801016f7:	e8 04 eb ff ff       	call   80100200 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801016fc:	83 c4 10             	add    $0x10,%esp
801016ff:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101705:	76 69                	jbe    80101770 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101707:	89 d8                	mov    %ebx,%eax
80101709:	83 ec 08             	sub    $0x8,%esp
8010170c:	c1 e8 03             	shr    $0x3,%eax
8010170f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101715:	50                   	push   %eax
80101716:	56                   	push   %esi
80101717:	e8 d4 e9 ff ff       	call   801000f0 <bread>
8010171c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010171e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101720:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101723:	83 e0 07             	and    $0x7,%eax
80101726:	c1 e0 06             	shl    $0x6,%eax
80101729:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010172d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101731:	75 bd                	jne    801016f0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101733:	83 ec 04             	sub    $0x4,%esp
80101736:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101739:	6a 40                	push   $0x40
8010173b:	6a 00                	push   $0x0
8010173d:	51                   	push   %ecx
8010173e:	e8 8d 2e 00 00       	call   801045d0 <memset>
      dip->type = type;
80101743:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101747:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010174a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010174d:	89 3c 24             	mov    %edi,(%esp)
80101750:	e8 bb 17 00 00       	call   80102f10 <log_write>
      brelse(bp);
80101755:	89 3c 24             	mov    %edi,(%esp)
80101758:	e8 a3 ea ff ff       	call   80100200 <brelse>
      return iget(dev, inum);
8010175d:	83 c4 10             	add    $0x10,%esp
}
80101760:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101763:	89 da                	mov    %ebx,%edx
80101765:	89 f0                	mov    %esi,%eax
}
80101767:	5b                   	pop    %ebx
80101768:	5e                   	pop    %esi
80101769:	5f                   	pop    %edi
8010176a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010176b:	e9 f0 fa ff ff       	jmp    80101260 <iget>
  panic("ialloc: no inodes");
80101770:	83 ec 0c             	sub    $0xc,%esp
80101773:	68 16 72 10 80       	push   $0x80107216
80101778:	e8 33 ec ff ff       	call   801003b0 <panic>
8010177d:	8d 76 00             	lea    0x0(%esi),%esi

80101780 <iupdate>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101788:	83 ec 08             	sub    $0x8,%esp
8010178b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010178e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101791:	c1 e8 03             	shr    $0x3,%eax
80101794:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010179a:	50                   	push   %eax
8010179b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010179e:	e8 4d e9 ff ff       	call   801000f0 <bread>
801017a3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017a5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801017a8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017ac:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017af:	83 e0 07             	and    $0x7,%eax
801017b2:	c1 e0 06             	shl    $0x6,%eax
801017b5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801017b9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801017bc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017c0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801017c3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801017c7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801017cb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801017cf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801017d3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801017d7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801017da:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017dd:	6a 34                	push   $0x34
801017df:	53                   	push   %ebx
801017e0:	50                   	push   %eax
801017e1:	e8 9a 2e 00 00       	call   80104680 <memmove>
  log_write(bp);
801017e6:	89 34 24             	mov    %esi,(%esp)
801017e9:	e8 22 17 00 00       	call   80102f10 <log_write>
  brelse(bp);
801017ee:	89 75 08             	mov    %esi,0x8(%ebp)
801017f1:	83 c4 10             	add    $0x10,%esp
}
801017f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017f7:	5b                   	pop    %ebx
801017f8:	5e                   	pop    %esi
801017f9:	5d                   	pop    %ebp
  brelse(bp);
801017fa:	e9 01 ea ff ff       	jmp    80100200 <brelse>
801017ff:	90                   	nop

80101800 <idup>:
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	53                   	push   %ebx
80101804:	83 ec 10             	sub    $0x10,%esp
80101807:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010180a:	68 e0 09 11 80       	push   $0x801109e0
8010180f:	e8 3c 2c 00 00       	call   80104450 <acquire>
  ip->ref++;
80101814:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101818:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010181f:	e8 4c 2d 00 00       	call   80104570 <release>
}
80101824:	89 d8                	mov    %ebx,%eax
80101826:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101829:	c9                   	leave  
8010182a:	c3                   	ret    
8010182b:	90                   	nop
8010182c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101830 <ilock>:
{
80101830:	55                   	push   %ebp
80101831:	89 e5                	mov    %esp,%ebp
80101833:	56                   	push   %esi
80101834:	53                   	push   %ebx
80101835:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101838:	85 db                	test   %ebx,%ebx
8010183a:	0f 84 b7 00 00 00    	je     801018f7 <ilock+0xc7>
80101840:	8b 53 08             	mov    0x8(%ebx),%edx
80101843:	85 d2                	test   %edx,%edx
80101845:	0f 8e ac 00 00 00    	jle    801018f7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010184b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010184e:	83 ec 0c             	sub    $0xc,%esp
80101851:	50                   	push   %eax
80101852:	e8 39 2a 00 00       	call   80104290 <acquiresleep>
  if(ip->valid == 0){
80101857:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010185a:	83 c4 10             	add    $0x10,%esp
8010185d:	85 c0                	test   %eax,%eax
8010185f:	74 0f                	je     80101870 <ilock+0x40>
}
80101861:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101864:	5b                   	pop    %ebx
80101865:	5e                   	pop    %esi
80101866:	5d                   	pop    %ebp
80101867:	c3                   	ret    
80101868:	90                   	nop
80101869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101870:	8b 43 04             	mov    0x4(%ebx),%eax
80101873:	83 ec 08             	sub    $0x8,%esp
80101876:	c1 e8 03             	shr    $0x3,%eax
80101879:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010187f:	50                   	push   %eax
80101880:	ff 33                	pushl  (%ebx)
80101882:	e8 69 e8 ff ff       	call   801000f0 <bread>
80101887:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101889:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010188c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010188f:	83 e0 07             	and    $0x7,%eax
80101892:	c1 e0 06             	shl    $0x6,%eax
80101895:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101899:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010189c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010189f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801018a3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801018a7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801018ab:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801018af:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801018b3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801018b7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801018bb:	8b 50 fc             	mov    -0x4(%eax),%edx
801018be:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018c1:	6a 34                	push   $0x34
801018c3:	50                   	push   %eax
801018c4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801018c7:	50                   	push   %eax
801018c8:	e8 b3 2d 00 00       	call   80104680 <memmove>
    brelse(bp);
801018cd:	89 34 24             	mov    %esi,(%esp)
801018d0:	e8 2b e9 ff ff       	call   80100200 <brelse>
    if(ip->type == 0)
801018d5:	83 c4 10             	add    $0x10,%esp
801018d8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801018dd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801018e4:	0f 85 77 ff ff ff    	jne    80101861 <ilock+0x31>
      panic("ilock: no type");
801018ea:	83 ec 0c             	sub    $0xc,%esp
801018ed:	68 2e 72 10 80       	push   $0x8010722e
801018f2:	e8 b9 ea ff ff       	call   801003b0 <panic>
    panic("ilock");
801018f7:	83 ec 0c             	sub    $0xc,%esp
801018fa:	68 28 72 10 80       	push   $0x80107228
801018ff:	e8 ac ea ff ff       	call   801003b0 <panic>
80101904:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010190a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101910 <iunlock>:
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	56                   	push   %esi
80101914:	53                   	push   %ebx
80101915:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101918:	85 db                	test   %ebx,%ebx
8010191a:	74 28                	je     80101944 <iunlock+0x34>
8010191c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010191f:	83 ec 0c             	sub    $0xc,%esp
80101922:	56                   	push   %esi
80101923:	e8 08 2a 00 00       	call   80104330 <holdingsleep>
80101928:	83 c4 10             	add    $0x10,%esp
8010192b:	85 c0                	test   %eax,%eax
8010192d:	74 15                	je     80101944 <iunlock+0x34>
8010192f:	8b 43 08             	mov    0x8(%ebx),%eax
80101932:	85 c0                	test   %eax,%eax
80101934:	7e 0e                	jle    80101944 <iunlock+0x34>
  releasesleep(&ip->lock);
80101936:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101939:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010193c:	5b                   	pop    %ebx
8010193d:	5e                   	pop    %esi
8010193e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010193f:	e9 ac 29 00 00       	jmp    801042f0 <releasesleep>
    panic("iunlock");
80101944:	83 ec 0c             	sub    $0xc,%esp
80101947:	68 3d 72 10 80       	push   $0x8010723d
8010194c:	e8 5f ea ff ff       	call   801003b0 <panic>
80101951:	eb 0d                	jmp    80101960 <iput>
80101953:	90                   	nop
80101954:	90                   	nop
80101955:	90                   	nop
80101956:	90                   	nop
80101957:	90                   	nop
80101958:	90                   	nop
80101959:	90                   	nop
8010195a:	90                   	nop
8010195b:	90                   	nop
8010195c:	90                   	nop
8010195d:	90                   	nop
8010195e:	90                   	nop
8010195f:	90                   	nop

80101960 <iput>:
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 28             	sub    $0x28,%esp
80101969:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010196c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010196f:	57                   	push   %edi
80101970:	e8 1b 29 00 00       	call   80104290 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101975:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101978:	83 c4 10             	add    $0x10,%esp
8010197b:	85 d2                	test   %edx,%edx
8010197d:	74 07                	je     80101986 <iput+0x26>
8010197f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101984:	74 32                	je     801019b8 <iput+0x58>
  releasesleep(&ip->lock);
80101986:	83 ec 0c             	sub    $0xc,%esp
80101989:	57                   	push   %edi
8010198a:	e8 61 29 00 00       	call   801042f0 <releasesleep>
  acquire(&icache.lock);
8010198f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101996:	e8 b5 2a 00 00       	call   80104450 <acquire>
  ip->ref--;
8010199b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010199f:	83 c4 10             	add    $0x10,%esp
801019a2:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801019a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019ac:	5b                   	pop    %ebx
801019ad:	5e                   	pop    %esi
801019ae:	5f                   	pop    %edi
801019af:	5d                   	pop    %ebp
  release(&icache.lock);
801019b0:	e9 bb 2b 00 00       	jmp    80104570 <release>
801019b5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801019b8:	83 ec 0c             	sub    $0xc,%esp
801019bb:	68 e0 09 11 80       	push   $0x801109e0
801019c0:	e8 8b 2a 00 00       	call   80104450 <acquire>
    int r = ip->ref;
801019c5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801019c8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801019cf:	e8 9c 2b 00 00       	call   80104570 <release>
    if(r == 1){
801019d4:	83 c4 10             	add    $0x10,%esp
801019d7:	83 fe 01             	cmp    $0x1,%esi
801019da:	75 aa                	jne    80101986 <iput+0x26>
801019dc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801019e2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019e5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801019e8:	89 cf                	mov    %ecx,%edi
801019ea:	eb 0b                	jmp    801019f7 <iput+0x97>
801019ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019f0:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801019f3:	39 fe                	cmp    %edi,%esi
801019f5:	74 19                	je     80101a10 <iput+0xb0>
    if(ip->addrs[i]){
801019f7:	8b 16                	mov    (%esi),%edx
801019f9:	85 d2                	test   %edx,%edx
801019fb:	74 f3                	je     801019f0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801019fd:	8b 03                	mov    (%ebx),%eax
801019ff:	e8 4c fa ff ff       	call   80101450 <bfree>
      ip->addrs[i] = 0;
80101a04:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101a0a:	eb e4                	jmp    801019f0 <iput+0x90>
80101a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101a10:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101a16:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a19:	85 c0                	test   %eax,%eax
80101a1b:	75 33                	jne    80101a50 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101a1d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101a20:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101a27:	53                   	push   %ebx
80101a28:	e8 53 fd ff ff       	call   80101780 <iupdate>
      ip->type = 0;
80101a2d:	31 c0                	xor    %eax,%eax
80101a2f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101a33:	89 1c 24             	mov    %ebx,(%esp)
80101a36:	e8 45 fd ff ff       	call   80101780 <iupdate>
      ip->valid = 0;
80101a3b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101a42:	83 c4 10             	add    $0x10,%esp
80101a45:	e9 3c ff ff ff       	jmp    80101986 <iput+0x26>
80101a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a50:	83 ec 08             	sub    $0x8,%esp
80101a53:	50                   	push   %eax
80101a54:	ff 33                	pushl  (%ebx)
80101a56:	e8 95 e6 ff ff       	call   801000f0 <bread>
80101a5b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a61:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101a67:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a6a:	83 c4 10             	add    $0x10,%esp
80101a6d:	89 cf                	mov    %ecx,%edi
80101a6f:	eb 0e                	jmp    80101a7f <iput+0x11f>
80101a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a78:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
80101a7b:	39 fe                	cmp    %edi,%esi
80101a7d:	74 0f                	je     80101a8e <iput+0x12e>
      if(a[j])
80101a7f:	8b 16                	mov    (%esi),%edx
80101a81:	85 d2                	test   %edx,%edx
80101a83:	74 f3                	je     80101a78 <iput+0x118>
        bfree(ip->dev, a[j]);
80101a85:	8b 03                	mov    (%ebx),%eax
80101a87:	e8 c4 f9 ff ff       	call   80101450 <bfree>
80101a8c:	eb ea                	jmp    80101a78 <iput+0x118>
    brelse(bp);
80101a8e:	83 ec 0c             	sub    $0xc,%esp
80101a91:	ff 75 e4             	pushl  -0x1c(%ebp)
80101a94:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a97:	e8 64 e7 ff ff       	call   80100200 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a9c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101aa2:	8b 03                	mov    (%ebx),%eax
80101aa4:	e8 a7 f9 ff ff       	call   80101450 <bfree>
    ip->addrs[NDIRECT] = 0;
80101aa9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101ab0:	00 00 00 
80101ab3:	83 c4 10             	add    $0x10,%esp
80101ab6:	e9 62 ff ff ff       	jmp    80101a1d <iput+0xbd>
80101abb:	90                   	nop
80101abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ac0 <iunlockput>:
{
80101ac0:	55                   	push   %ebp
80101ac1:	89 e5                	mov    %esp,%ebp
80101ac3:	53                   	push   %ebx
80101ac4:	83 ec 10             	sub    $0x10,%esp
80101ac7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101aca:	53                   	push   %ebx
80101acb:	e8 40 fe ff ff       	call   80101910 <iunlock>
  iput(ip);
80101ad0:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101ad3:	83 c4 10             	add    $0x10,%esp
}
80101ad6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101ad9:	c9                   	leave  
  iput(ip);
80101ada:	e9 81 fe ff ff       	jmp    80101960 <iput>
80101adf:	90                   	nop

80101ae0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ae0:	55                   	push   %ebp
80101ae1:	89 e5                	mov    %esp,%ebp
80101ae3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101ae9:	8b 0a                	mov    (%edx),%ecx
80101aeb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101aee:	8b 4a 04             	mov    0x4(%edx),%ecx
80101af1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101af4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101af8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101afb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101aff:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101b03:	8b 52 58             	mov    0x58(%edx),%edx
80101b06:	89 50 10             	mov    %edx,0x10(%eax)
}
80101b09:	5d                   	pop    %ebp
80101b0a:	c3                   	ret    
80101b0b:	90                   	nop
80101b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b10 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b10:	55                   	push   %ebp
80101b11:	89 e5                	mov    %esp,%ebp
80101b13:	57                   	push   %edi
80101b14:	56                   	push   %esi
80101b15:	53                   	push   %ebx
80101b16:	83 ec 1c             	sub    $0x1c,%esp
80101b19:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b1f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b22:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b27:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101b2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b2d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b30:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101b33:	0f 84 a7 00 00 00    	je     80101be0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3c:	8b 40 58             	mov    0x58(%eax),%eax
80101b3f:	39 c6                	cmp    %eax,%esi
80101b41:	0f 87 ba 00 00 00    	ja     80101c01 <readi+0xf1>
80101b47:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101b4a:	89 f9                	mov    %edi,%ecx
80101b4c:	01 f1                	add    %esi,%ecx
80101b4e:	0f 82 ad 00 00 00    	jb     80101c01 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b54:	89 c2                	mov    %eax,%edx
80101b56:	29 f2                	sub    %esi,%edx
80101b58:	39 c8                	cmp    %ecx,%eax
80101b5a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b5d:	31 ff                	xor    %edi,%edi
80101b5f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101b61:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b64:	74 6c                	je     80101bd2 <readi+0xc2>
80101b66:	8d 76 00             	lea    0x0(%esi),%esi
80101b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b70:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b73:	89 f2                	mov    %esi,%edx
80101b75:	c1 ea 09             	shr    $0x9,%edx
80101b78:	89 d8                	mov    %ebx,%eax
80101b7a:	e8 b1 f7 ff ff       	call   80101330 <bmap>
80101b7f:	83 ec 08             	sub    $0x8,%esp
80101b82:	50                   	push   %eax
80101b83:	ff 33                	pushl  (%ebx)
80101b85:	e8 66 e5 ff ff       	call   801000f0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b8a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b8d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b8f:	89 f0                	mov    %esi,%eax
80101b91:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b96:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b9b:	83 c4 0c             	add    $0xc,%esp
80101b9e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101ba0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101ba4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101ba7:	29 fb                	sub    %edi,%ebx
80101ba9:	39 d9                	cmp    %ebx,%ecx
80101bab:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101bae:	53                   	push   %ebx
80101baf:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bb0:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101bb2:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bb5:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101bb7:	e8 c4 2a 00 00       	call   80104680 <memmove>
    brelse(bp);
80101bbc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101bbf:	89 14 24             	mov    %edx,(%esp)
80101bc2:	e8 39 e6 ff ff       	call   80100200 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bc7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101bca:	83 c4 10             	add    $0x10,%esp
80101bcd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101bd0:	77 9e                	ja     80101b70 <readi+0x60>
  }
  return n;
80101bd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101bd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bd8:	5b                   	pop    %ebx
80101bd9:	5e                   	pop    %esi
80101bda:	5f                   	pop    %edi
80101bdb:	5d                   	pop    %ebp
80101bdc:	c3                   	ret    
80101bdd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101be0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101be4:	66 83 f8 09          	cmp    $0x9,%ax
80101be8:	77 17                	ja     80101c01 <readi+0xf1>
80101bea:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101bf1:	85 c0                	test   %eax,%eax
80101bf3:	74 0c                	je     80101c01 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101bf5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101bf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bfb:	5b                   	pop    %ebx
80101bfc:	5e                   	pop    %esi
80101bfd:	5f                   	pop    %edi
80101bfe:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101bff:	ff e0                	jmp    *%eax
      return -1;
80101c01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c06:	eb cd                	jmp    80101bd5 <readi+0xc5>
80101c08:	90                   	nop
80101c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c10 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c10:	55                   	push   %ebp
80101c11:	89 e5                	mov    %esp,%ebp
80101c13:	57                   	push   %edi
80101c14:	56                   	push   %esi
80101c15:	53                   	push   %ebx
80101c16:	83 ec 1c             	sub    $0x1c,%esp
80101c19:	8b 45 08             	mov    0x8(%ebp),%eax
80101c1c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101c1f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c22:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c27:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101c2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c2d:	8b 75 10             	mov    0x10(%ebp),%esi
80101c30:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101c33:	0f 84 b7 00 00 00    	je     80101cf0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c3c:	39 70 58             	cmp    %esi,0x58(%eax)
80101c3f:	0f 82 eb 00 00 00    	jb     80101d30 <writei+0x120>
80101c45:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c48:	31 d2                	xor    %edx,%edx
80101c4a:	89 f8                	mov    %edi,%eax
80101c4c:	01 f0                	add    %esi,%eax
80101c4e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c51:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101c56:	0f 87 d4 00 00 00    	ja     80101d30 <writei+0x120>
80101c5c:	85 d2                	test   %edx,%edx
80101c5e:	0f 85 cc 00 00 00    	jne    80101d30 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c64:	85 ff                	test   %edi,%edi
80101c66:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101c6d:	74 72                	je     80101ce1 <writei+0xd1>
80101c6f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c70:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c73:	89 f2                	mov    %esi,%edx
80101c75:	c1 ea 09             	shr    $0x9,%edx
80101c78:	89 f8                	mov    %edi,%eax
80101c7a:	e8 b1 f6 ff ff       	call   80101330 <bmap>
80101c7f:	83 ec 08             	sub    $0x8,%esp
80101c82:	50                   	push   %eax
80101c83:	ff 37                	pushl  (%edi)
80101c85:	e8 66 e4 ff ff       	call   801000f0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c8a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c8d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c90:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c92:	89 f0                	mov    %esi,%eax
80101c94:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c99:	83 c4 0c             	add    $0xc,%esp
80101c9c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ca1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ca3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101ca7:	39 d9                	cmp    %ebx,%ecx
80101ca9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101cac:	53                   	push   %ebx
80101cad:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cb0:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101cb2:	50                   	push   %eax
80101cb3:	e8 c8 29 00 00       	call   80104680 <memmove>
    log_write(bp);
80101cb8:	89 3c 24             	mov    %edi,(%esp)
80101cbb:	e8 50 12 00 00       	call   80102f10 <log_write>
    brelse(bp);
80101cc0:	89 3c 24             	mov    %edi,(%esp)
80101cc3:	e8 38 e5 ff ff       	call   80100200 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cc8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101ccb:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101cce:	83 c4 10             	add    $0x10,%esp
80101cd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101cd4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101cd7:	77 97                	ja     80101c70 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101cd9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cdc:	3b 70 58             	cmp    0x58(%eax),%esi
80101cdf:	77 37                	ja     80101d18 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101ce1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ce4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ce7:	5b                   	pop    %ebx
80101ce8:	5e                   	pop    %esi
80101ce9:	5f                   	pop    %edi
80101cea:	5d                   	pop    %ebp
80101ceb:	c3                   	ret    
80101cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101cf0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101cf4:	66 83 f8 09          	cmp    $0x9,%ax
80101cf8:	77 36                	ja     80101d30 <writei+0x120>
80101cfa:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101d01:	85 c0                	test   %eax,%eax
80101d03:	74 2b                	je     80101d30 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101d05:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101d08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d0b:	5b                   	pop    %ebx
80101d0c:	5e                   	pop    %esi
80101d0d:	5f                   	pop    %edi
80101d0e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d0f:	ff e0                	jmp    *%eax
80101d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101d18:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101d1b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101d1e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101d21:	50                   	push   %eax
80101d22:	e8 59 fa ff ff       	call   80101780 <iupdate>
80101d27:	83 c4 10             	add    $0x10,%esp
80101d2a:	eb b5                	jmp    80101ce1 <writei+0xd1>
80101d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101d30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d35:	eb ad                	jmp    80101ce4 <writei+0xd4>
80101d37:	89 f6                	mov    %esi,%esi
80101d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101d40 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d40:	55                   	push   %ebp
80101d41:	89 e5                	mov    %esp,%ebp
80101d43:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d46:	6a 0e                	push   $0xe
80101d48:	ff 75 0c             	pushl  0xc(%ebp)
80101d4b:	ff 75 08             	pushl  0x8(%ebp)
80101d4e:	e8 9d 29 00 00       	call   801046f0 <strncmp>
}
80101d53:	c9                   	leave  
80101d54:	c3                   	ret    
80101d55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101d60 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d60:	55                   	push   %ebp
80101d61:	89 e5                	mov    %esp,%ebp
80101d63:	57                   	push   %edi
80101d64:	56                   	push   %esi
80101d65:	53                   	push   %ebx
80101d66:	83 ec 1c             	sub    $0x1c,%esp
80101d69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d6c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d71:	0f 85 85 00 00 00    	jne    80101dfc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d77:	8b 53 58             	mov    0x58(%ebx),%edx
80101d7a:	31 ff                	xor    %edi,%edi
80101d7c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d7f:	85 d2                	test   %edx,%edx
80101d81:	74 3e                	je     80101dc1 <dirlookup+0x61>
80101d83:	90                   	nop
80101d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d88:	6a 10                	push   $0x10
80101d8a:	57                   	push   %edi
80101d8b:	56                   	push   %esi
80101d8c:	53                   	push   %ebx
80101d8d:	e8 7e fd ff ff       	call   80101b10 <readi>
80101d92:	83 c4 10             	add    $0x10,%esp
80101d95:	83 f8 10             	cmp    $0x10,%eax
80101d98:	75 55                	jne    80101def <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d9a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d9f:	74 18                	je     80101db9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101da1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101da4:	83 ec 04             	sub    $0x4,%esp
80101da7:	6a 0e                	push   $0xe
80101da9:	50                   	push   %eax
80101daa:	ff 75 0c             	pushl  0xc(%ebp)
80101dad:	e8 3e 29 00 00       	call   801046f0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101db2:	83 c4 10             	add    $0x10,%esp
80101db5:	85 c0                	test   %eax,%eax
80101db7:	74 17                	je     80101dd0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101db9:	83 c7 10             	add    $0x10,%edi
80101dbc:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101dbf:	72 c7                	jb     80101d88 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101dc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101dc4:	31 c0                	xor    %eax,%eax
}
80101dc6:	5b                   	pop    %ebx
80101dc7:	5e                   	pop    %esi
80101dc8:	5f                   	pop    %edi
80101dc9:	5d                   	pop    %ebp
80101dca:	c3                   	ret    
80101dcb:	90                   	nop
80101dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101dd0:	8b 45 10             	mov    0x10(%ebp),%eax
80101dd3:	85 c0                	test   %eax,%eax
80101dd5:	74 05                	je     80101ddc <dirlookup+0x7c>
        *poff = off;
80101dd7:	8b 45 10             	mov    0x10(%ebp),%eax
80101dda:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101ddc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101de0:	8b 03                	mov    (%ebx),%eax
80101de2:	e8 79 f4 ff ff       	call   80101260 <iget>
}
80101de7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dea:	5b                   	pop    %ebx
80101deb:	5e                   	pop    %esi
80101dec:	5f                   	pop    %edi
80101ded:	5d                   	pop    %ebp
80101dee:	c3                   	ret    
      panic("dirlookup read");
80101def:	83 ec 0c             	sub    $0xc,%esp
80101df2:	68 57 72 10 80       	push   $0x80107257
80101df7:	e8 b4 e5 ff ff       	call   801003b0 <panic>
    panic("dirlookup not DIR");
80101dfc:	83 ec 0c             	sub    $0xc,%esp
80101dff:	68 45 72 10 80       	push   $0x80107245
80101e04:	e8 a7 e5 ff ff       	call   801003b0 <panic>
80101e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e10 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e10:	55                   	push   %ebp
80101e11:	89 e5                	mov    %esp,%ebp
80101e13:	57                   	push   %edi
80101e14:	56                   	push   %esi
80101e15:	53                   	push   %ebx
80101e16:	89 cf                	mov    %ecx,%edi
80101e18:	89 c3                	mov    %eax,%ebx
80101e1a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e1d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101e20:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101e23:	0f 84 67 01 00 00    	je     80101f90 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e29:	e8 52 1b 00 00       	call   80103980 <myproc>
  acquire(&icache.lock);
80101e2e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101e31:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101e34:	68 e0 09 11 80       	push   $0x801109e0
80101e39:	e8 12 26 00 00       	call   80104450 <acquire>
  ip->ref++;
80101e3e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e42:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101e49:	e8 22 27 00 00       	call   80104570 <release>
80101e4e:	83 c4 10             	add    $0x10,%esp
80101e51:	eb 08                	jmp    80101e5b <namex+0x4b>
80101e53:	90                   	nop
80101e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e58:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e5b:	0f b6 03             	movzbl (%ebx),%eax
80101e5e:	3c 2f                	cmp    $0x2f,%al
80101e60:	74 f6                	je     80101e58 <namex+0x48>
  if(*path == 0)
80101e62:	84 c0                	test   %al,%al
80101e64:	0f 84 ee 00 00 00    	je     80101f58 <namex+0x148>
  while(*path != '/' && *path != 0)
80101e6a:	0f b6 03             	movzbl (%ebx),%eax
80101e6d:	3c 2f                	cmp    $0x2f,%al
80101e6f:	0f 84 b3 00 00 00    	je     80101f28 <namex+0x118>
80101e75:	84 c0                	test   %al,%al
80101e77:	89 da                	mov    %ebx,%edx
80101e79:	75 09                	jne    80101e84 <namex+0x74>
80101e7b:	e9 a8 00 00 00       	jmp    80101f28 <namex+0x118>
80101e80:	84 c0                	test   %al,%al
80101e82:	74 0a                	je     80101e8e <namex+0x7e>
    path++;
80101e84:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101e87:	0f b6 02             	movzbl (%edx),%eax
80101e8a:	3c 2f                	cmp    $0x2f,%al
80101e8c:	75 f2                	jne    80101e80 <namex+0x70>
80101e8e:	89 d1                	mov    %edx,%ecx
80101e90:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101e92:	83 f9 0d             	cmp    $0xd,%ecx
80101e95:	0f 8e 91 00 00 00    	jle    80101f2c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101e9b:	83 ec 04             	sub    $0x4,%esp
80101e9e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101ea1:	6a 0e                	push   $0xe
80101ea3:	53                   	push   %ebx
80101ea4:	57                   	push   %edi
80101ea5:	e8 d6 27 00 00       	call   80104680 <memmove>
    path++;
80101eaa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101ead:	83 c4 10             	add    $0x10,%esp
    path++;
80101eb0:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101eb2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101eb5:	75 11                	jne    80101ec8 <namex+0xb8>
80101eb7:	89 f6                	mov    %esi,%esi
80101eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101ec0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ec3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101ec6:	74 f8                	je     80101ec0 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101ec8:	83 ec 0c             	sub    $0xc,%esp
80101ecb:	56                   	push   %esi
80101ecc:	e8 5f f9 ff ff       	call   80101830 <ilock>
    if(ip->type != T_DIR){
80101ed1:	83 c4 10             	add    $0x10,%esp
80101ed4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ed9:	0f 85 91 00 00 00    	jne    80101f70 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101edf:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ee2:	85 d2                	test   %edx,%edx
80101ee4:	74 09                	je     80101eef <namex+0xdf>
80101ee6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ee9:	0f 84 b7 00 00 00    	je     80101fa6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101eef:	83 ec 04             	sub    $0x4,%esp
80101ef2:	6a 00                	push   $0x0
80101ef4:	57                   	push   %edi
80101ef5:	56                   	push   %esi
80101ef6:	e8 65 fe ff ff       	call   80101d60 <dirlookup>
80101efb:	83 c4 10             	add    $0x10,%esp
80101efe:	85 c0                	test   %eax,%eax
80101f00:	74 6e                	je     80101f70 <namex+0x160>
  iunlock(ip);
80101f02:	83 ec 0c             	sub    $0xc,%esp
80101f05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101f08:	56                   	push   %esi
80101f09:	e8 02 fa ff ff       	call   80101910 <iunlock>
  iput(ip);
80101f0e:	89 34 24             	mov    %esi,(%esp)
80101f11:	e8 4a fa ff ff       	call   80101960 <iput>
80101f16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f19:	83 c4 10             	add    $0x10,%esp
80101f1c:	89 c6                	mov    %eax,%esi
80101f1e:	e9 38 ff ff ff       	jmp    80101e5b <namex+0x4b>
80101f23:	90                   	nop
80101f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101f28:	89 da                	mov    %ebx,%edx
80101f2a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101f2c:	83 ec 04             	sub    $0x4,%esp
80101f2f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101f32:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101f35:	51                   	push   %ecx
80101f36:	53                   	push   %ebx
80101f37:	57                   	push   %edi
80101f38:	e8 43 27 00 00       	call   80104680 <memmove>
    name[len] = 0;
80101f3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f40:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101f43:	83 c4 10             	add    $0x10,%esp
80101f46:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101f4a:	89 d3                	mov    %edx,%ebx
80101f4c:	e9 61 ff ff ff       	jmp    80101eb2 <namex+0xa2>
80101f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f58:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101f5b:	85 c0                	test   %eax,%eax
80101f5d:	75 5d                	jne    80101fbc <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f62:	89 f0                	mov    %esi,%eax
80101f64:	5b                   	pop    %ebx
80101f65:	5e                   	pop    %esi
80101f66:	5f                   	pop    %edi
80101f67:	5d                   	pop    %ebp
80101f68:	c3                   	ret    
80101f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101f70:	83 ec 0c             	sub    $0xc,%esp
80101f73:	56                   	push   %esi
80101f74:	e8 97 f9 ff ff       	call   80101910 <iunlock>
  iput(ip);
80101f79:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f7c:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f7e:	e8 dd f9 ff ff       	call   80101960 <iput>
      return 0;
80101f83:	83 c4 10             	add    $0x10,%esp
}
80101f86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f89:	89 f0                	mov    %esi,%eax
80101f8b:	5b                   	pop    %ebx
80101f8c:	5e                   	pop    %esi
80101f8d:	5f                   	pop    %edi
80101f8e:	5d                   	pop    %ebp
80101f8f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101f90:	ba 01 00 00 00       	mov    $0x1,%edx
80101f95:	b8 01 00 00 00       	mov    $0x1,%eax
80101f9a:	e8 c1 f2 ff ff       	call   80101260 <iget>
80101f9f:	89 c6                	mov    %eax,%esi
80101fa1:	e9 b5 fe ff ff       	jmp    80101e5b <namex+0x4b>
      iunlock(ip);
80101fa6:	83 ec 0c             	sub    $0xc,%esp
80101fa9:	56                   	push   %esi
80101faa:	e8 61 f9 ff ff       	call   80101910 <iunlock>
      return ip;
80101faf:	83 c4 10             	add    $0x10,%esp
}
80101fb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb5:	89 f0                	mov    %esi,%eax
80101fb7:	5b                   	pop    %ebx
80101fb8:	5e                   	pop    %esi
80101fb9:	5f                   	pop    %edi
80101fba:	5d                   	pop    %ebp
80101fbb:	c3                   	ret    
    iput(ip);
80101fbc:	83 ec 0c             	sub    $0xc,%esp
80101fbf:	56                   	push   %esi
    return 0;
80101fc0:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fc2:	e8 99 f9 ff ff       	call   80101960 <iput>
    return 0;
80101fc7:	83 c4 10             	add    $0x10,%esp
80101fca:	eb 93                	jmp    80101f5f <namex+0x14f>
80101fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101fd0 <dirlink>:
{
80101fd0:	55                   	push   %ebp
80101fd1:	89 e5                	mov    %esp,%ebp
80101fd3:	57                   	push   %edi
80101fd4:	56                   	push   %esi
80101fd5:	53                   	push   %ebx
80101fd6:	83 ec 20             	sub    $0x20,%esp
80101fd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fdc:	6a 00                	push   $0x0
80101fde:	ff 75 0c             	pushl  0xc(%ebp)
80101fe1:	53                   	push   %ebx
80101fe2:	e8 79 fd ff ff       	call   80101d60 <dirlookup>
80101fe7:	83 c4 10             	add    $0x10,%esp
80101fea:	85 c0                	test   %eax,%eax
80101fec:	75 67                	jne    80102055 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fee:	8b 7b 58             	mov    0x58(%ebx),%edi
80101ff1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ff4:	85 ff                	test   %edi,%edi
80101ff6:	74 29                	je     80102021 <dirlink+0x51>
80101ff8:	31 ff                	xor    %edi,%edi
80101ffa:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ffd:	eb 09                	jmp    80102008 <dirlink+0x38>
80101fff:	90                   	nop
80102000:	83 c7 10             	add    $0x10,%edi
80102003:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102006:	73 19                	jae    80102021 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102008:	6a 10                	push   $0x10
8010200a:	57                   	push   %edi
8010200b:	56                   	push   %esi
8010200c:	53                   	push   %ebx
8010200d:	e8 fe fa ff ff       	call   80101b10 <readi>
80102012:	83 c4 10             	add    $0x10,%esp
80102015:	83 f8 10             	cmp    $0x10,%eax
80102018:	75 4e                	jne    80102068 <dirlink+0x98>
    if(de.inum == 0)
8010201a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010201f:	75 df                	jne    80102000 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102021:	8d 45 da             	lea    -0x26(%ebp),%eax
80102024:	83 ec 04             	sub    $0x4,%esp
80102027:	6a 0e                	push   $0xe
80102029:	ff 75 0c             	pushl  0xc(%ebp)
8010202c:	50                   	push   %eax
8010202d:	e8 1e 27 00 00       	call   80104750 <strncpy>
  de.inum = inum;
80102032:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102035:	6a 10                	push   $0x10
80102037:	57                   	push   %edi
80102038:	56                   	push   %esi
80102039:	53                   	push   %ebx
  de.inum = inum;
8010203a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010203e:	e8 cd fb ff ff       	call   80101c10 <writei>
80102043:	83 c4 20             	add    $0x20,%esp
80102046:	83 f8 10             	cmp    $0x10,%eax
80102049:	75 2a                	jne    80102075 <dirlink+0xa5>
  return 0;
8010204b:	31 c0                	xor    %eax,%eax
}
8010204d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102050:	5b                   	pop    %ebx
80102051:	5e                   	pop    %esi
80102052:	5f                   	pop    %edi
80102053:	5d                   	pop    %ebp
80102054:	c3                   	ret    
    iput(ip);
80102055:	83 ec 0c             	sub    $0xc,%esp
80102058:	50                   	push   %eax
80102059:	e8 02 f9 ff ff       	call   80101960 <iput>
    return -1;
8010205e:	83 c4 10             	add    $0x10,%esp
80102061:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102066:	eb e5                	jmp    8010204d <dirlink+0x7d>
      panic("dirlink read");
80102068:	83 ec 0c             	sub    $0xc,%esp
8010206b:	68 66 72 10 80       	push   $0x80107266
80102070:	e8 3b e3 ff ff       	call   801003b0 <panic>
    panic("dirlink");
80102075:	83 ec 0c             	sub    $0xc,%esp
80102078:	68 66 78 10 80       	push   $0x80107866
8010207d:	e8 2e e3 ff ff       	call   801003b0 <panic>
80102082:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102090 <namei>:

struct inode*
namei(char *path)
{
80102090:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102091:	31 d2                	xor    %edx,%edx
{
80102093:	89 e5                	mov    %esp,%ebp
80102095:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102098:	8b 45 08             	mov    0x8(%ebp),%eax
8010209b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010209e:	e8 6d fd ff ff       	call   80101e10 <namex>
}
801020a3:	c9                   	leave  
801020a4:	c3                   	ret    
801020a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801020b0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020b0:	55                   	push   %ebp
  return namex(path, 1, name);
801020b1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020b6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020be:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020bf:	e9 4c fd ff ff       	jmp    80101e10 <namex>
801020c4:	66 90                	xchg   %ax,%ax
801020c6:	66 90                	xchg   %ax,%ax
801020c8:	66 90                	xchg   %ax,%ax
801020ca:	66 90                	xchg   %ax,%ax
801020cc:	66 90                	xchg   %ax,%ax
801020ce:	66 90                	xchg   %ax,%ax

801020d0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020d0:	55                   	push   %ebp
  if(b == 0)
801020d1:	85 c0                	test   %eax,%eax
{
801020d3:	89 e5                	mov    %esp,%ebp
801020d5:	56                   	push   %esi
801020d6:	53                   	push   %ebx
  if(b == 0)
801020d7:	0f 84 af 00 00 00    	je     8010218c <idestart+0xbc>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020dd:	8b 58 08             	mov    0x8(%eax),%ebx
801020e0:	89 c6                	mov    %eax,%esi
801020e2:	81 fb ff f3 01 00    	cmp    $0x1f3ff,%ebx
801020e8:	0f 87 91 00 00 00    	ja     8010217f <idestart+0xaf>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020ee:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801020f3:	90                   	nop
801020f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020f8:	89 ca                	mov    %ecx,%edx
801020fa:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020fb:	83 e0 c0             	and    $0xffffffc0,%eax
801020fe:	3c 40                	cmp    $0x40,%al
80102100:	75 f6                	jne    801020f8 <idestart+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102102:	31 c0                	xor    %eax,%eax
80102104:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102109:	ee                   	out    %al,(%dx)
8010210a:	b8 01 00 00 00       	mov    $0x1,%eax
8010210f:	ba f2 01 00 00       	mov    $0x1f2,%edx
80102114:	ee                   	out    %al,(%dx)
80102115:	ba f3 01 00 00       	mov    $0x1f3,%edx
8010211a:	89 d8                	mov    %ebx,%eax
8010211c:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
8010211d:	89 d8                	mov    %ebx,%eax
8010211f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80102124:	c1 f8 08             	sar    $0x8,%eax
80102127:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
80102128:	89 d8                	mov    %ebx,%eax
8010212a:	ba f5 01 00 00       	mov    $0x1f5,%edx
8010212f:	c1 f8 10             	sar    $0x10,%eax
80102132:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102133:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80102137:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010213c:	c1 e0 04             	shl    $0x4,%eax
8010213f:	83 e0 10             	and    $0x10,%eax
80102142:	83 c8 e0             	or     $0xffffffe0,%eax
80102145:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80102146:	f6 06 04             	testb  $0x4,(%esi)
80102149:	75 15                	jne    80102160 <idestart+0x90>
8010214b:	b8 20 00 00 00       	mov    $0x20,%eax
80102150:	89 ca                	mov    %ecx,%edx
80102152:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102153:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102156:	5b                   	pop    %ebx
80102157:	5e                   	pop    %esi
80102158:	5d                   	pop    %ebp
80102159:	c3                   	ret    
8010215a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102160:	b8 30 00 00 00       	mov    $0x30,%eax
80102165:	89 ca                	mov    %ecx,%edx
80102167:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102168:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
8010216d:	83 c6 5c             	add    $0x5c,%esi
80102170:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102175:	fc                   	cld    
80102176:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102178:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010217b:	5b                   	pop    %ebx
8010217c:	5e                   	pop    %esi
8010217d:	5d                   	pop    %ebp
8010217e:	c3                   	ret    
    panic("incorrect blockno");
8010217f:	83 ec 0c             	sub    $0xc,%esp
80102182:	68 d0 72 10 80       	push   $0x801072d0
80102187:	e8 24 e2 ff ff       	call   801003b0 <panic>
    panic("idestart");
8010218c:	83 ec 0c             	sub    $0xc,%esp
8010218f:	68 c7 72 10 80       	push   $0x801072c7
80102194:	e8 17 e2 ff ff       	call   801003b0 <panic>
80102199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021a0 <ideinit>:
{
801021a0:	55                   	push   %ebp
801021a1:	89 e5                	mov    %esp,%ebp
801021a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021a6:	68 e2 72 10 80       	push   $0x801072e2
801021ab:	68 80 a5 10 80       	push   $0x8010a580
801021b0:	e8 ab 21 00 00       	call   80104360 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021b5:	58                   	pop    %eax
801021b6:	a1 00 2d 11 80       	mov    0x80112d00,%eax
801021bb:	5a                   	pop    %edx
801021bc:	83 e8 01             	sub    $0x1,%eax
801021bf:	50                   	push   %eax
801021c0:	6a 0e                	push   $0xe
801021c2:	e8 a9 02 00 00       	call   80102470 <ioapicenable>
801021c7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ca:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021cf:	90                   	nop
801021d0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021d1:	83 e0 c0             	and    $0xffffffc0,%eax
801021d4:	3c 40                	cmp    $0x40,%al
801021d6:	75 f8                	jne    801021d0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021d8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021dd:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021e2:	ee                   	out    %al,(%dx)
801021e3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021e8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ed:	eb 06                	jmp    801021f5 <ideinit+0x55>
801021ef:	90                   	nop
  for(i=0; i<1000; i++){
801021f0:	83 e9 01             	sub    $0x1,%ecx
801021f3:	74 0f                	je     80102204 <ideinit+0x64>
801021f5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021f6:	84 c0                	test   %al,%al
801021f8:	74 f6                	je     801021f0 <ideinit+0x50>
      havedisk1 = 1;
801021fa:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102201:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102204:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102209:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010220e:	ee                   	out    %al,(%dx)
}
8010220f:	c9                   	leave  
80102210:	c3                   	ret    
80102211:	eb 0d                	jmp    80102220 <ideintr>
80102213:	90                   	nop
80102214:	90                   	nop
80102215:	90                   	nop
80102216:	90                   	nop
80102217:	90                   	nop
80102218:	90                   	nop
80102219:	90                   	nop
8010221a:	90                   	nop
8010221b:	90                   	nop
8010221c:	90                   	nop
8010221d:	90                   	nop
8010221e:	90                   	nop
8010221f:	90                   	nop

80102220 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102220:	55                   	push   %ebp
80102221:	89 e5                	mov    %esp,%ebp
80102223:	57                   	push   %edi
80102224:	56                   	push   %esi
80102225:	53                   	push   %ebx
80102226:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102229:	68 80 a5 10 80       	push   $0x8010a580
8010222e:	e8 1d 22 00 00       	call   80104450 <acquire>

  if((b = idequeue) == 0){
80102233:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102239:	83 c4 10             	add    $0x10,%esp
8010223c:	85 db                	test   %ebx,%ebx
8010223e:	74 67                	je     801022a7 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102240:	8b 43 58             	mov    0x58(%ebx),%eax
80102243:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102248:	8b 3b                	mov    (%ebx),%edi
8010224a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102250:	75 31                	jne    80102283 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102252:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102257:	89 f6                	mov    %esi,%esi
80102259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102260:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102261:	89 c6                	mov    %eax,%esi
80102263:	83 e6 c0             	and    $0xffffffc0,%esi
80102266:	89 f1                	mov    %esi,%ecx
80102268:	80 f9 40             	cmp    $0x40,%cl
8010226b:	75 f3                	jne    80102260 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010226d:	a8 21                	test   $0x21,%al
8010226f:	75 12                	jne    80102283 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102271:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102274:	b9 80 00 00 00       	mov    $0x80,%ecx
80102279:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010227e:	fc                   	cld    
8010227f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102281:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102283:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102286:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102289:	89 f9                	mov    %edi,%ecx
8010228b:	83 c9 02             	or     $0x2,%ecx
8010228e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102290:	53                   	push   %ebx
80102291:	e8 1a 1e 00 00       	call   801040b0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102296:	a1 64 a5 10 80       	mov    0x8010a564,%eax
8010229b:	83 c4 10             	add    $0x10,%esp
8010229e:	85 c0                	test   %eax,%eax
801022a0:	74 05                	je     801022a7 <ideintr+0x87>
    idestart(idequeue);
801022a2:	e8 29 fe ff ff       	call   801020d0 <idestart>
    release(&idelock);
801022a7:	83 ec 0c             	sub    $0xc,%esp
801022aa:	68 80 a5 10 80       	push   $0x8010a580
801022af:	e8 bc 22 00 00       	call   80104570 <release>

  release(&idelock);
}
801022b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022b7:	5b                   	pop    %ebx
801022b8:	5e                   	pop    %esi
801022b9:	5f                   	pop    %edi
801022ba:	5d                   	pop    %ebp
801022bb:	c3                   	ret    
801022bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801022c0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	53                   	push   %ebx
801022c4:	83 ec 10             	sub    $0x10,%esp
801022c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ca:	8d 43 0c             	lea    0xc(%ebx),%eax
801022cd:	50                   	push   %eax
801022ce:	e8 5d 20 00 00       	call   80104330 <holdingsleep>
801022d3:	83 c4 10             	add    $0x10,%esp
801022d6:	85 c0                	test   %eax,%eax
801022d8:	0f 84 c6 00 00 00    	je     801023a4 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022de:	8b 03                	mov    (%ebx),%eax
801022e0:	83 e0 06             	and    $0x6,%eax
801022e3:	83 f8 02             	cmp    $0x2,%eax
801022e6:	0f 84 ab 00 00 00    	je     80102397 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022ec:	8b 53 04             	mov    0x4(%ebx),%edx
801022ef:	85 d2                	test   %edx,%edx
801022f1:	74 0d                	je     80102300 <iderw+0x40>
801022f3:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801022f8:	85 c0                	test   %eax,%eax
801022fa:	0f 84 b1 00 00 00    	je     801023b1 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102300:	83 ec 0c             	sub    $0xc,%esp
80102303:	68 80 a5 10 80       	push   $0x8010a580
80102308:	e8 43 21 00 00       	call   80104450 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010230d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102313:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102316:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010231d:	85 d2                	test   %edx,%edx
8010231f:	75 09                	jne    8010232a <iderw+0x6a>
80102321:	eb 6d                	jmp    80102390 <iderw+0xd0>
80102323:	90                   	nop
80102324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102328:	89 c2                	mov    %eax,%edx
8010232a:	8b 42 58             	mov    0x58(%edx),%eax
8010232d:	85 c0                	test   %eax,%eax
8010232f:	75 f7                	jne    80102328 <iderw+0x68>
80102331:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102334:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102336:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010233c:	74 42                	je     80102380 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010233e:	8b 03                	mov    (%ebx),%eax
80102340:	83 e0 06             	and    $0x6,%eax
80102343:	83 f8 02             	cmp    $0x2,%eax
80102346:	74 23                	je     8010236b <iderw+0xab>
80102348:	90                   	nop
80102349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102350:	83 ec 08             	sub    $0x8,%esp
80102353:	68 80 a5 10 80       	push   $0x8010a580
80102358:	53                   	push   %ebx
80102359:	e8 92 1b 00 00       	call   80103ef0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010235e:	8b 03                	mov    (%ebx),%eax
80102360:	83 c4 10             	add    $0x10,%esp
80102363:	83 e0 06             	and    $0x6,%eax
80102366:	83 f8 02             	cmp    $0x2,%eax
80102369:	75 e5                	jne    80102350 <iderw+0x90>
  }


  release(&idelock);
8010236b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102372:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102375:	c9                   	leave  
  release(&idelock);
80102376:	e9 f5 21 00 00       	jmp    80104570 <release>
8010237b:	90                   	nop
8010237c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102380:	89 d8                	mov    %ebx,%eax
80102382:	e8 49 fd ff ff       	call   801020d0 <idestart>
80102387:	eb b5                	jmp    8010233e <iderw+0x7e>
80102389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102390:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102395:	eb 9d                	jmp    80102334 <iderw+0x74>
    panic("iderw: nothing to do");
80102397:	83 ec 0c             	sub    $0xc,%esp
8010239a:	68 fc 72 10 80       	push   $0x801072fc
8010239f:	e8 0c e0 ff ff       	call   801003b0 <panic>
    panic("iderw: buf not locked");
801023a4:	83 ec 0c             	sub    $0xc,%esp
801023a7:	68 e6 72 10 80       	push   $0x801072e6
801023ac:	e8 ff df ff ff       	call   801003b0 <panic>
    panic("iderw: ide disk 1 not present");
801023b1:	83 ec 0c             	sub    $0xc,%esp
801023b4:	68 11 73 10 80       	push   $0x80107311
801023b9:	e8 f2 df ff ff       	call   801003b0 <panic>
801023be:	66 90                	xchg   %ax,%ax

801023c0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023c0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023c1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023c8:	00 c0 fe 
{
801023cb:	89 e5                	mov    %esp,%ebp
801023cd:	56                   	push   %esi
801023ce:	53                   	push   %ebx
  ioapic->reg = reg;
801023cf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023d6:	00 00 00 
  return ioapic->data;
801023d9:	a1 34 26 11 80       	mov    0x80112634,%eax
801023de:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
801023e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
801023e7:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023ed:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023f4:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
801023f7:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023fa:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
801023fd:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102400:	39 c2                	cmp    %eax,%edx
80102402:	74 16                	je     8010241a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102404:	83 ec 0c             	sub    $0xc,%esp
80102407:	68 30 73 10 80       	push   $0x80107330
8010240c:	e8 6f e2 ff ff       	call   80100680 <cprintf>
80102411:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102417:	83 c4 10             	add    $0x10,%esp
8010241a:	83 c3 21             	add    $0x21,%ebx
{
8010241d:	ba 10 00 00 00       	mov    $0x10,%edx
80102422:	b8 20 00 00 00       	mov    $0x20,%eax
80102427:	89 f6                	mov    %esi,%esi
80102429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102430:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102432:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102438:	89 c6                	mov    %eax,%esi
8010243a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102440:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102443:	89 71 10             	mov    %esi,0x10(%ecx)
80102446:	8d 72 01             	lea    0x1(%edx),%esi
80102449:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010244c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010244e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102450:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102456:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010245d:	75 d1                	jne    80102430 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010245f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102462:	5b                   	pop    %ebx
80102463:	5e                   	pop    %esi
80102464:	5d                   	pop    %ebp
80102465:	c3                   	ret    
80102466:	8d 76 00             	lea    0x0(%esi),%esi
80102469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102470 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102470:	55                   	push   %ebp
  ioapic->reg = reg;
80102471:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102477:	89 e5                	mov    %esp,%ebp
80102479:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010247c:	8d 50 20             	lea    0x20(%eax),%edx
8010247f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102483:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102485:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010248b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010248e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102491:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102494:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102496:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010249e:	89 50 10             	mov    %edx,0x10(%eax)
}
801024a1:	5d                   	pop    %ebp
801024a2:	c3                   	ret    
801024a3:	66 90                	xchg   %ax,%ax
801024a5:	66 90                	xchg   %ax,%ax
801024a7:	66 90                	xchg   %ax,%ax
801024a9:	66 90                	xchg   %ax,%ax
801024ab:	66 90                	xchg   %ax,%ax
801024ad:	66 90                	xchg   %ax,%ax
801024af:	90                   	nop

801024b0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024b0:	55                   	push   %ebp
801024b1:	89 e5                	mov    %esp,%ebp
801024b3:	53                   	push   %ebx
801024b4:	83 ec 04             	sub    $0x4,%esp
801024b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ba:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024c0:	75 70                	jne    80102532 <kfree+0x82>
801024c2:	81 fb a8 54 11 80    	cmp    $0x801154a8,%ebx
801024c8:	72 68                	jb     80102532 <kfree+0x82>
801024ca:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024d0:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
801024d5:	77 5b                	ja     80102532 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024d7:	83 ec 04             	sub    $0x4,%esp
801024da:	68 00 10 00 00       	push   $0x1000
801024df:	6a 01                	push   $0x1
801024e1:	53                   	push   %ebx
801024e2:	e8 e9 20 00 00       	call   801045d0 <memset>

  if(kmem.use_lock)
801024e7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801024ed:	83 c4 10             	add    $0x10,%esp
801024f0:	85 d2                	test   %edx,%edx
801024f2:	75 2c                	jne    80102520 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024f4:	a1 78 26 11 80       	mov    0x80112678,%eax
801024f9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024fb:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102500:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102506:	85 c0                	test   %eax,%eax
80102508:	75 06                	jne    80102510 <kfree+0x60>
    release(&kmem.lock);
}
8010250a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010250d:	c9                   	leave  
8010250e:	c3                   	ret    
8010250f:	90                   	nop
    release(&kmem.lock);
80102510:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102517:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010251a:	c9                   	leave  
    release(&kmem.lock);
8010251b:	e9 50 20 00 00       	jmp    80104570 <release>
    acquire(&kmem.lock);
80102520:	83 ec 0c             	sub    $0xc,%esp
80102523:	68 40 26 11 80       	push   $0x80112640
80102528:	e8 23 1f 00 00       	call   80104450 <acquire>
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	eb c2                	jmp    801024f4 <kfree+0x44>
    panic("kfree");
80102532:	83 ec 0c             	sub    $0xc,%esp
80102535:	68 62 73 10 80       	push   $0x80107362
8010253a:	e8 71 de ff ff       	call   801003b0 <panic>
8010253f:	90                   	nop

80102540 <freerange>:
{
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	56                   	push   %esi
80102544:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102545:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102548:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010254b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102551:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102557:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010255d:	39 de                	cmp    %ebx,%esi
8010255f:	72 23                	jb     80102584 <freerange+0x44>
80102561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102568:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010256e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102571:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102577:	50                   	push   %eax
80102578:	e8 33 ff ff ff       	call   801024b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010257d:	83 c4 10             	add    $0x10,%esp
80102580:	39 f3                	cmp    %esi,%ebx
80102582:	76 e4                	jbe    80102568 <freerange+0x28>
}
80102584:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102587:	5b                   	pop    %ebx
80102588:	5e                   	pop    %esi
80102589:	5d                   	pop    %ebp
8010258a:	c3                   	ret    
8010258b:	90                   	nop
8010258c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102590 <kinit1>:
{
80102590:	55                   	push   %ebp
80102591:	89 e5                	mov    %esp,%ebp
80102593:	56                   	push   %esi
80102594:	53                   	push   %ebx
80102595:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102598:	83 ec 08             	sub    $0x8,%esp
8010259b:	68 68 73 10 80       	push   $0x80107368
801025a0:	68 40 26 11 80       	push   $0x80112640
801025a5:	e8 b6 1d 00 00       	call   80104360 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801025aa:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ad:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801025b0:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801025b7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801025ba:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025c0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025cc:	39 de                	cmp    %ebx,%esi
801025ce:	72 1c                	jb     801025ec <kinit1+0x5c>
    kfree(p);
801025d0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801025d6:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025d9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025df:	50                   	push   %eax
801025e0:	e8 cb fe ff ff       	call   801024b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e5:	83 c4 10             	add    $0x10,%esp
801025e8:	39 de                	cmp    %ebx,%esi
801025ea:	73 e4                	jae    801025d0 <kinit1+0x40>
}
801025ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025ef:	5b                   	pop    %ebx
801025f0:	5e                   	pop    %esi
801025f1:	5d                   	pop    %ebp
801025f2:	c3                   	ret    
801025f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801025f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102600 <kinit2>:
{
80102600:	55                   	push   %ebp
80102601:	89 e5                	mov    %esp,%ebp
80102603:	56                   	push   %esi
80102604:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102605:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102608:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010260b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102611:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102617:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010261d:	39 de                	cmp    %ebx,%esi
8010261f:	72 23                	jb     80102644 <kinit2+0x44>
80102621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102628:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010262e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102631:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102637:	50                   	push   %eax
80102638:	e8 73 fe ff ff       	call   801024b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010263d:	83 c4 10             	add    $0x10,%esp
80102640:	39 de                	cmp    %ebx,%esi
80102642:	73 e4                	jae    80102628 <kinit2+0x28>
  kmem.use_lock = 1;
80102644:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010264b:	00 00 00 
}
8010264e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102651:	5b                   	pop    %ebx
80102652:	5e                   	pop    %esi
80102653:	5d                   	pop    %ebp
80102654:	c3                   	ret    
80102655:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102660 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102660:	a1 74 26 11 80       	mov    0x80112674,%eax
80102665:	85 c0                	test   %eax,%eax
80102667:	75 1f                	jne    80102688 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102669:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010266e:	85 c0                	test   %eax,%eax
80102670:	74 0e                	je     80102680 <kalloc+0x20>
    kmem.freelist = r->next;
80102672:	8b 10                	mov    (%eax),%edx
80102674:	89 15 78 26 11 80    	mov    %edx,0x80112678
8010267a:	c3                   	ret    
8010267b:	90                   	nop
8010267c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102680:	f3 c3                	repz ret 
80102682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102688:	55                   	push   %ebp
80102689:	89 e5                	mov    %esp,%ebp
8010268b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010268e:	68 40 26 11 80       	push   $0x80112640
80102693:	e8 b8 1d 00 00       	call   80104450 <acquire>
  r = kmem.freelist;
80102698:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010269d:	83 c4 10             	add    $0x10,%esp
801026a0:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801026a6:	85 c0                	test   %eax,%eax
801026a8:	74 08                	je     801026b2 <kalloc+0x52>
    kmem.freelist = r->next;
801026aa:	8b 08                	mov    (%eax),%ecx
801026ac:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
801026b2:	85 d2                	test   %edx,%edx
801026b4:	74 16                	je     801026cc <kalloc+0x6c>
    release(&kmem.lock);
801026b6:	83 ec 0c             	sub    $0xc,%esp
801026b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026bc:	68 40 26 11 80       	push   $0x80112640
801026c1:	e8 aa 1e 00 00       	call   80104570 <release>
  return (char*)r;
801026c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026c9:	83 c4 10             	add    $0x10,%esp
}
801026cc:	c9                   	leave  
801026cd:	c3                   	ret    
801026ce:	66 90                	xchg   %ax,%ax

801026d0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026d0:	ba 64 00 00 00       	mov    $0x64,%edx
801026d5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026d6:	a8 01                	test   $0x1,%al
801026d8:	0f 84 c2 00 00 00    	je     801027a0 <kbdgetc+0xd0>
801026de:	ba 60 00 00 00       	mov    $0x60,%edx
801026e3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801026e4:	0f b6 d0             	movzbl %al,%edx
801026e7:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx

  if(data == 0xE0){
801026ed:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801026f3:	0f 84 7f 00 00 00    	je     80102778 <kbdgetc+0xa8>
{
801026f9:	55                   	push   %ebp
801026fa:	89 e5                	mov    %esp,%ebp
801026fc:	53                   	push   %ebx
801026fd:	89 cb                	mov    %ecx,%ebx
801026ff:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102702:	84 c0                	test   %al,%al
80102704:	78 4a                	js     80102750 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102706:	85 db                	test   %ebx,%ebx
80102708:	74 09                	je     80102713 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010270a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010270d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102710:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102713:	0f b6 82 a0 74 10 80 	movzbl -0x7fef8b60(%edx),%eax
8010271a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010271c:	0f b6 82 a0 73 10 80 	movzbl -0x7fef8c60(%edx),%eax
80102723:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102725:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102727:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010272d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102730:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102733:	8b 04 85 80 73 10 80 	mov    -0x7fef8c80(,%eax,4),%eax
8010273a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010273e:	74 31                	je     80102771 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102740:	8d 50 9f             	lea    -0x61(%eax),%edx
80102743:	83 fa 19             	cmp    $0x19,%edx
80102746:	77 40                	ja     80102788 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102748:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010274b:	5b                   	pop    %ebx
8010274c:	5d                   	pop    %ebp
8010274d:	c3                   	ret    
8010274e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102750:	83 e0 7f             	and    $0x7f,%eax
80102753:	85 db                	test   %ebx,%ebx
80102755:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102758:	0f b6 82 a0 74 10 80 	movzbl -0x7fef8b60(%edx),%eax
8010275f:	83 c8 40             	or     $0x40,%eax
80102762:	0f b6 c0             	movzbl %al,%eax
80102765:	f7 d0                	not    %eax
80102767:	21 c1                	and    %eax,%ecx
    return 0;
80102769:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010276b:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102771:	5b                   	pop    %ebx
80102772:	5d                   	pop    %ebp
80102773:	c3                   	ret    
80102774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102778:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010277b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010277d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
    return 0;
80102783:	c3                   	ret    
80102784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102788:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010278b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010278e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010278f:	83 f9 1a             	cmp    $0x1a,%ecx
80102792:	0f 42 c2             	cmovb  %edx,%eax
}
80102795:	5d                   	pop    %ebp
80102796:	c3                   	ret    
80102797:	89 f6                	mov    %esi,%esi
80102799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801027a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027a5:	c3                   	ret    
801027a6:	8d 76 00             	lea    0x0(%esi),%esi
801027a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027b0 <kbdintr>:

void
kbdintr(void)
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
801027b3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027b6:	68 d0 26 10 80       	push   $0x801026d0
801027bb:	e8 70 e0 ff ff       	call   80100830 <consoleintr>
}
801027c0:	83 c4 10             	add    $0x10,%esp
801027c3:	c9                   	leave  
801027c4:	c3                   	ret    
801027c5:	66 90                	xchg   %ax,%ax
801027c7:	66 90                	xchg   %ax,%ax
801027c9:	66 90                	xchg   %ax,%ax
801027cb:	66 90                	xchg   %ax,%ax
801027cd:	66 90                	xchg   %ax,%ax
801027cf:	90                   	nop

801027d0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801027d0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
801027d5:	55                   	push   %ebp
801027d6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801027d8:	85 c0                	test   %eax,%eax
801027da:	0f 84 c8 00 00 00    	je     801028a8 <lapicinit+0xd8>
  lapic[index] = value;
801027e0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027e7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027ea:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027ed:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027fa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102801:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102804:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102807:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010280e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102811:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102814:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010281b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010281e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102821:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102828:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010282b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010282e:	8b 50 30             	mov    0x30(%eax),%edx
80102831:	c1 ea 10             	shr    $0x10,%edx
80102834:	80 fa 03             	cmp    $0x3,%dl
80102837:	77 77                	ja     801028b0 <lapicinit+0xe0>
  lapic[index] = value;
80102839:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102840:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102843:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102846:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010284d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102850:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102853:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010285a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010285d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102860:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102867:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010286a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010286d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102874:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102877:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010287a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102881:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102884:	8b 50 20             	mov    0x20(%eax),%edx
80102887:	89 f6                	mov    %esi,%esi
80102889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102890:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102896:	80 e6 10             	and    $0x10,%dh
80102899:	75 f5                	jne    80102890 <lapicinit+0xc0>
  lapic[index] = value;
8010289b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028a2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028a5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028a8:	5d                   	pop    %ebp
801028a9:	c3                   	ret    
801028aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
801028b0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028b7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028ba:	8b 50 20             	mov    0x20(%eax),%edx
801028bd:	e9 77 ff ff ff       	jmp    80102839 <lapicinit+0x69>
801028c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028d0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801028d0:	8b 15 7c 26 11 80    	mov    0x8011267c,%edx
{
801028d6:	55                   	push   %ebp
801028d7:	31 c0                	xor    %eax,%eax
801028d9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801028db:	85 d2                	test   %edx,%edx
801028dd:	74 06                	je     801028e5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
801028df:	8b 42 20             	mov    0x20(%edx),%eax
801028e2:	c1 e8 18             	shr    $0x18,%eax
}
801028e5:	5d                   	pop    %ebp
801028e6:	c3                   	ret    
801028e7:	89 f6                	mov    %esi,%esi
801028e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028f0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801028f0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
801028f5:	55                   	push   %ebp
801028f6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801028f8:	85 c0                	test   %eax,%eax
801028fa:	74 0d                	je     80102909 <lapiceoi+0x19>
  lapic[index] = value;
801028fc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102903:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102906:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102909:	5d                   	pop    %ebp
8010290a:	c3                   	ret    
8010290b:	90                   	nop
8010290c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102910 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102910:	55                   	push   %ebp
80102911:	89 e5                	mov    %esp,%ebp
}
80102913:	5d                   	pop    %ebp
80102914:	c3                   	ret    
80102915:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102920 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102920:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102921:	b8 0f 00 00 00       	mov    $0xf,%eax
80102926:	ba 70 00 00 00       	mov    $0x70,%edx
8010292b:	89 e5                	mov    %esp,%ebp
8010292d:	53                   	push   %ebx
8010292e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102931:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102934:	ee                   	out    %al,(%dx)
80102935:	b8 0a 00 00 00       	mov    $0xa,%eax
8010293a:	ba 71 00 00 00       	mov    $0x71,%edx
8010293f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102940:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102942:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102945:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010294b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010294d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102950:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102953:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102955:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102958:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010295e:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102963:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102969:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102973:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102976:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102979:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102980:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102983:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102986:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010298c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010298f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102995:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102998:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010299e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029a1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029a7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029aa:	5b                   	pop    %ebx
801029ab:	5d                   	pop    %ebp
801029ac:	c3                   	ret    
801029ad:	8d 76 00             	lea    0x0(%esi),%esi

801029b0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801029b0:	55                   	push   %ebp
801029b1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029b6:	ba 70 00 00 00       	mov    $0x70,%edx
801029bb:	89 e5                	mov    %esp,%ebp
801029bd:	57                   	push   %edi
801029be:	56                   	push   %esi
801029bf:	53                   	push   %ebx
801029c0:	83 ec 4c             	sub    $0x4c,%esp
801029c3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029c4:	ba 71 00 00 00       	mov    $0x71,%edx
801029c9:	ec                   	in     (%dx),%al
801029ca:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029cd:	bb 70 00 00 00       	mov    $0x70,%ebx
801029d2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029d5:	8d 76 00             	lea    0x0(%esi),%esi
801029d8:	31 c0                	xor    %eax,%eax
801029da:	89 da                	mov    %ebx,%edx
801029dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029dd:	b9 71 00 00 00       	mov    $0x71,%ecx
801029e2:	89 ca                	mov    %ecx,%edx
801029e4:	ec                   	in     (%dx),%al
801029e5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e8:	89 da                	mov    %ebx,%edx
801029ea:	b8 02 00 00 00       	mov    $0x2,%eax
801029ef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f0:	89 ca                	mov    %ecx,%edx
801029f2:	ec                   	in     (%dx),%al
801029f3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f6:	89 da                	mov    %ebx,%edx
801029f8:	b8 04 00 00 00       	mov    $0x4,%eax
801029fd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fe:	89 ca                	mov    %ecx,%edx
80102a00:	ec                   	in     (%dx),%al
80102a01:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a04:	89 da                	mov    %ebx,%edx
80102a06:	b8 07 00 00 00       	mov    $0x7,%eax
80102a0b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0c:	89 ca                	mov    %ecx,%edx
80102a0e:	ec                   	in     (%dx),%al
80102a0f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a12:	89 da                	mov    %ebx,%edx
80102a14:	b8 08 00 00 00       	mov    $0x8,%eax
80102a19:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1a:	89 ca                	mov    %ecx,%edx
80102a1c:	ec                   	in     (%dx),%al
80102a1d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a1f:	89 da                	mov    %ebx,%edx
80102a21:	b8 09 00 00 00       	mov    $0x9,%eax
80102a26:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a27:	89 ca                	mov    %ecx,%edx
80102a29:	ec                   	in     (%dx),%al
80102a2a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a2c:	89 da                	mov    %ebx,%edx
80102a2e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a33:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a34:	89 ca                	mov    %ecx,%edx
80102a36:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a37:	84 c0                	test   %al,%al
80102a39:	78 9d                	js     801029d8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a3b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a3f:	89 fa                	mov    %edi,%edx
80102a41:	0f b6 fa             	movzbl %dl,%edi
80102a44:	89 f2                	mov    %esi,%edx
80102a46:	0f b6 f2             	movzbl %dl,%esi
80102a49:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4c:	89 da                	mov    %ebx,%edx
80102a4e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a51:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a54:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a58:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a5b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a5f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a62:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a66:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a69:	31 c0                	xor    %eax,%eax
80102a6b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a6c:	89 ca                	mov    %ecx,%edx
80102a6e:	ec                   	in     (%dx),%al
80102a6f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a72:	89 da                	mov    %ebx,%edx
80102a74:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a77:	b8 02 00 00 00       	mov    $0x2,%eax
80102a7c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a7d:	89 ca                	mov    %ecx,%edx
80102a7f:	ec                   	in     (%dx),%al
80102a80:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a83:	89 da                	mov    %ebx,%edx
80102a85:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a88:	b8 04 00 00 00       	mov    $0x4,%eax
80102a8d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8e:	89 ca                	mov    %ecx,%edx
80102a90:	ec                   	in     (%dx),%al
80102a91:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a94:	89 da                	mov    %ebx,%edx
80102a96:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a99:	b8 07 00 00 00       	mov    $0x7,%eax
80102a9e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9f:	89 ca                	mov    %ecx,%edx
80102aa1:	ec                   	in     (%dx),%al
80102aa2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa5:	89 da                	mov    %ebx,%edx
80102aa7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aaa:	b8 08 00 00 00       	mov    $0x8,%eax
80102aaf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab0:	89 ca                	mov    %ecx,%edx
80102ab2:	ec                   	in     (%dx),%al
80102ab3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab6:	89 da                	mov    %ebx,%edx
80102ab8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102abb:	b8 09 00 00 00       	mov    $0x9,%eax
80102ac0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac1:	89 ca                	mov    %ecx,%edx
80102ac3:	ec                   	in     (%dx),%al
80102ac4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ac7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102aca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102acd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ad0:	6a 18                	push   $0x18
80102ad2:	50                   	push   %eax
80102ad3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ad6:	50                   	push   %eax
80102ad7:	e8 44 1b 00 00       	call   80104620 <memcmp>
80102adc:	83 c4 10             	add    $0x10,%esp
80102adf:	85 c0                	test   %eax,%eax
80102ae1:	0f 85 f1 fe ff ff    	jne    801029d8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102ae7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102aeb:	75 78                	jne    80102b65 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102aed:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102af0:	89 c2                	mov    %eax,%edx
80102af2:	83 e0 0f             	and    $0xf,%eax
80102af5:	c1 ea 04             	shr    $0x4,%edx
80102af8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102afb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102afe:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b01:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b04:	89 c2                	mov    %eax,%edx
80102b06:	83 e0 0f             	and    $0xf,%eax
80102b09:	c1 ea 04             	shr    $0x4,%edx
80102b0c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b0f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b12:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b15:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b18:	89 c2                	mov    %eax,%edx
80102b1a:	83 e0 0f             	and    $0xf,%eax
80102b1d:	c1 ea 04             	shr    $0x4,%edx
80102b20:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b23:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b26:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b29:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b2c:	89 c2                	mov    %eax,%edx
80102b2e:	83 e0 0f             	and    $0xf,%eax
80102b31:	c1 ea 04             	shr    $0x4,%edx
80102b34:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b37:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b3a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b3d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b40:	89 c2                	mov    %eax,%edx
80102b42:	83 e0 0f             	and    $0xf,%eax
80102b45:	c1 ea 04             	shr    $0x4,%edx
80102b48:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b4b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b4e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b51:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b54:	89 c2                	mov    %eax,%edx
80102b56:	83 e0 0f             	and    $0xf,%eax
80102b59:	c1 ea 04             	shr    $0x4,%edx
80102b5c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b5f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b62:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b65:	8b 75 08             	mov    0x8(%ebp),%esi
80102b68:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b6b:	89 06                	mov    %eax,(%esi)
80102b6d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b70:	89 46 04             	mov    %eax,0x4(%esi)
80102b73:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b76:	89 46 08             	mov    %eax,0x8(%esi)
80102b79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b7c:	89 46 0c             	mov    %eax,0xc(%esi)
80102b7f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b82:	89 46 10             	mov    %eax,0x10(%esi)
80102b85:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b88:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b8b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b95:	5b                   	pop    %ebx
80102b96:	5e                   	pop    %esi
80102b97:	5f                   	pop    %edi
80102b98:	5d                   	pop    %ebp
80102b99:	c3                   	ret    
80102b9a:	66 90                	xchg   %ax,%ax
80102b9c:	66 90                	xchg   %ax,%ax
80102b9e:	66 90                	xchg   %ax,%ax

80102ba0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ba0:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102ba6:	85 c9                	test   %ecx,%ecx
80102ba8:	0f 8e 8a 00 00 00    	jle    80102c38 <install_trans+0x98>
{
80102bae:	55                   	push   %ebp
80102baf:	89 e5                	mov    %esp,%ebp
80102bb1:	57                   	push   %edi
80102bb2:	56                   	push   %esi
80102bb3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102bb4:	31 db                	xor    %ebx,%ebx
{
80102bb6:	83 ec 0c             	sub    $0xc,%esp
80102bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bc0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102bc5:	83 ec 08             	sub    $0x8,%esp
80102bc8:	01 d8                	add    %ebx,%eax
80102bca:	83 c0 01             	add    $0x1,%eax
80102bcd:	50                   	push   %eax
80102bce:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102bd4:	e8 17 d5 ff ff       	call   801000f0 <bread>
80102bd9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bdb:	58                   	pop    %eax
80102bdc:	5a                   	pop    %edx
80102bdd:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102be4:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102bea:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bed:	e8 fe d4 ff ff       	call   801000f0 <bread>
80102bf2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102bf7:	83 c4 0c             	add    $0xc,%esp
80102bfa:	68 00 02 00 00       	push   $0x200
80102bff:	50                   	push   %eax
80102c00:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c03:	50                   	push   %eax
80102c04:	e8 77 1a 00 00       	call   80104680 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c09:	89 34 24             	mov    %esi,(%esp)
80102c0c:	e8 af d5 ff ff       	call   801001c0 <bwrite>
    brelse(lbuf);
80102c11:	89 3c 24             	mov    %edi,(%esp)
80102c14:	e8 e7 d5 ff ff       	call   80100200 <brelse>
    brelse(dbuf);
80102c19:	89 34 24             	mov    %esi,(%esp)
80102c1c:	e8 df d5 ff ff       	call   80100200 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c21:	83 c4 10             	add    $0x10,%esp
80102c24:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102c2a:	7f 94                	jg     80102bc0 <install_trans+0x20>
  }
}
80102c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c2f:	5b                   	pop    %ebx
80102c30:	5e                   	pop    %esi
80102c31:	5f                   	pop    %edi
80102c32:	5d                   	pop    %ebp
80102c33:	c3                   	ret    
80102c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c38:	f3 c3                	repz ret 
80102c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102c40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	56                   	push   %esi
80102c44:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102c45:	83 ec 08             	sub    $0x8,%esp
80102c48:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102c4e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102c54:	e8 97 d4 ff ff       	call   801000f0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102c59:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102c5f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c62:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102c64:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102c66:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102c69:	7e 16                	jle    80102c81 <write_head+0x41>
80102c6b:	c1 e3 02             	shl    $0x2,%ebx
80102c6e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102c70:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102c76:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102c7a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102c7d:	39 da                	cmp    %ebx,%edx
80102c7f:	75 ef                	jne    80102c70 <write_head+0x30>
  }
  bwrite(buf);
80102c81:	83 ec 0c             	sub    $0xc,%esp
80102c84:	56                   	push   %esi
80102c85:	e8 36 d5 ff ff       	call   801001c0 <bwrite>
  brelse(buf);
80102c8a:	89 34 24             	mov    %esi,(%esp)
80102c8d:	e8 6e d5 ff ff       	call   80100200 <brelse>
}
80102c92:	83 c4 10             	add    $0x10,%esp
80102c95:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c98:	5b                   	pop    %ebx
80102c99:	5e                   	pop    %esi
80102c9a:	5d                   	pop    %ebp
80102c9b:	c3                   	ret    
80102c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ca0 <initlog>:
{
80102ca0:	55                   	push   %ebp
80102ca1:	89 e5                	mov    %esp,%ebp
80102ca3:	53                   	push   %ebx
80102ca4:	83 ec 2c             	sub    $0x2c,%esp
80102ca7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102caa:	68 a0 75 10 80       	push   $0x801075a0
80102caf:	68 80 26 11 80       	push   $0x80112680
80102cb4:	e8 a7 16 00 00       	call   80104360 <initlock>
  readsb(dev, &sb);
80102cb9:	58                   	pop    %eax
80102cba:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cbd:	5a                   	pop    %edx
80102cbe:	50                   	push   %eax
80102cbf:	53                   	push   %ebx
80102cc0:	e8 4b e7 ff ff       	call   80101410 <readsb>
  log.size = sb.nlog;
80102cc5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ccb:	59                   	pop    %ecx
  log.dev = dev;
80102ccc:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102cd2:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102cd8:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102cdd:	5a                   	pop    %edx
80102cde:	50                   	push   %eax
80102cdf:	53                   	push   %ebx
80102ce0:	e8 0b d4 ff ff       	call   801000f0 <bread>
  log.lh.n = lh->n;
80102ce5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102ce8:	83 c4 10             	add    $0x10,%esp
80102ceb:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102ced:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102cf3:	7e 1c                	jle    80102d11 <initlog+0x71>
80102cf5:	c1 e3 02             	shl    $0x2,%ebx
80102cf8:	31 d2                	xor    %edx,%edx
80102cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102d00:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102d04:	83 c2 04             	add    $0x4,%edx
80102d07:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102d0d:	39 d3                	cmp    %edx,%ebx
80102d0f:	75 ef                	jne    80102d00 <initlog+0x60>
  brelse(buf);
80102d11:	83 ec 0c             	sub    $0xc,%esp
80102d14:	50                   	push   %eax
80102d15:	e8 e6 d4 ff ff       	call   80100200 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d1a:	e8 81 fe ff ff       	call   80102ba0 <install_trans>
  log.lh.n = 0;
80102d1f:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102d26:	00 00 00 
  write_head(); // clear the log
80102d29:	e8 12 ff ff ff       	call   80102c40 <write_head>
}
80102d2e:	83 c4 10             	add    $0x10,%esp
80102d31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d34:	c9                   	leave  
80102d35:	c3                   	ret    
80102d36:	8d 76 00             	lea    0x0(%esi),%esi
80102d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d40:	55                   	push   %ebp
80102d41:	89 e5                	mov    %esp,%ebp
80102d43:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d46:	68 80 26 11 80       	push   $0x80112680
80102d4b:	e8 00 17 00 00       	call   80104450 <acquire>
80102d50:	83 c4 10             	add    $0x10,%esp
80102d53:	eb 18                	jmp    80102d6d <begin_op+0x2d>
80102d55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d58:	83 ec 08             	sub    $0x8,%esp
80102d5b:	68 80 26 11 80       	push   $0x80112680
80102d60:	68 80 26 11 80       	push   $0x80112680
80102d65:	e8 86 11 00 00       	call   80103ef0 <sleep>
80102d6a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d6d:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102d72:	85 c0                	test   %eax,%eax
80102d74:	75 e2                	jne    80102d58 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d76:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102d7b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d81:	83 c0 01             	add    $0x1,%eax
80102d84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d8a:	83 fa 1e             	cmp    $0x1e,%edx
80102d8d:	7f c9                	jg     80102d58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d8f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d92:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102d97:	68 80 26 11 80       	push   $0x80112680
80102d9c:	e8 cf 17 00 00       	call   80104570 <release>
      break;
    }
  }
}
80102da1:	83 c4 10             	add    $0x10,%esp
80102da4:	c9                   	leave  
80102da5:	c3                   	ret    
80102da6:	8d 76 00             	lea    0x0(%esi),%esi
80102da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102db0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	57                   	push   %edi
80102db4:	56                   	push   %esi
80102db5:	53                   	push   %ebx
80102db6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102db9:	68 80 26 11 80       	push   $0x80112680
80102dbe:	e8 8d 16 00 00       	call   80104450 <acquire>
  log.outstanding -= 1;
80102dc3:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102dc8:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102dce:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102dd1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102dd4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102dd6:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102ddc:	0f 85 1a 01 00 00    	jne    80102efc <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102de2:	85 db                	test   %ebx,%ebx
80102de4:	0f 85 ee 00 00 00    	jne    80102ed8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102dea:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102ded:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102df4:	00 00 00 
  release(&log.lock);
80102df7:	68 80 26 11 80       	push   $0x80112680
80102dfc:	e8 6f 17 00 00       	call   80104570 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e01:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102e07:	83 c4 10             	add    $0x10,%esp
80102e0a:	85 c9                	test   %ecx,%ecx
80102e0c:	0f 8e 85 00 00 00    	jle    80102e97 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e12:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102e17:	83 ec 08             	sub    $0x8,%esp
80102e1a:	01 d8                	add    %ebx,%eax
80102e1c:	83 c0 01             	add    $0x1,%eax
80102e1f:	50                   	push   %eax
80102e20:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102e26:	e8 c5 d2 ff ff       	call   801000f0 <bread>
80102e2b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e2d:	58                   	pop    %eax
80102e2e:	5a                   	pop    %edx
80102e2f:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102e36:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e3c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e3f:	e8 ac d2 ff ff       	call   801000f0 <bread>
80102e44:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e46:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e49:	83 c4 0c             	add    $0xc,%esp
80102e4c:	68 00 02 00 00       	push   $0x200
80102e51:	50                   	push   %eax
80102e52:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e55:	50                   	push   %eax
80102e56:	e8 25 18 00 00       	call   80104680 <memmove>
    bwrite(to);  // write the log
80102e5b:	89 34 24             	mov    %esi,(%esp)
80102e5e:	e8 5d d3 ff ff       	call   801001c0 <bwrite>
    brelse(from);
80102e63:	89 3c 24             	mov    %edi,(%esp)
80102e66:	e8 95 d3 ff ff       	call   80100200 <brelse>
    brelse(to);
80102e6b:	89 34 24             	mov    %esi,(%esp)
80102e6e:	e8 8d d3 ff ff       	call   80100200 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e73:	83 c4 10             	add    $0x10,%esp
80102e76:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102e7c:	7c 94                	jl     80102e12 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102e7e:	e8 bd fd ff ff       	call   80102c40 <write_head>
    install_trans(); // Now install writes to home locations
80102e83:	e8 18 fd ff ff       	call   80102ba0 <install_trans>
    log.lh.n = 0;
80102e88:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102e8f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102e92:	e8 a9 fd ff ff       	call   80102c40 <write_head>
    acquire(&log.lock);
80102e97:	83 ec 0c             	sub    $0xc,%esp
80102e9a:	68 80 26 11 80       	push   $0x80112680
80102e9f:	e8 ac 15 00 00       	call   80104450 <acquire>
    wakeup(&log);
80102ea4:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102eab:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102eb2:	00 00 00 
    wakeup(&log);
80102eb5:	e8 f6 11 00 00       	call   801040b0 <wakeup>
    release(&log.lock);
80102eba:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ec1:	e8 aa 16 00 00       	call   80104570 <release>
80102ec6:	83 c4 10             	add    $0x10,%esp
}
80102ec9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ecc:	5b                   	pop    %ebx
80102ecd:	5e                   	pop    %esi
80102ece:	5f                   	pop    %edi
80102ecf:	5d                   	pop    %ebp
80102ed0:	c3                   	ret    
80102ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102ed8:	83 ec 0c             	sub    $0xc,%esp
80102edb:	68 80 26 11 80       	push   $0x80112680
80102ee0:	e8 cb 11 00 00       	call   801040b0 <wakeup>
  release(&log.lock);
80102ee5:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102eec:	e8 7f 16 00 00       	call   80104570 <release>
80102ef1:	83 c4 10             	add    $0x10,%esp
}
80102ef4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ef7:	5b                   	pop    %ebx
80102ef8:	5e                   	pop    %esi
80102ef9:	5f                   	pop    %edi
80102efa:	5d                   	pop    %ebp
80102efb:	c3                   	ret    
    panic("log.committing");
80102efc:	83 ec 0c             	sub    $0xc,%esp
80102eff:	68 a4 75 10 80       	push   $0x801075a4
80102f04:	e8 a7 d4 ff ff       	call   801003b0 <panic>
80102f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f10 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f10:	55                   	push   %ebp
80102f11:	89 e5                	mov    %esp,%ebp
80102f13:	53                   	push   %ebx
80102f14:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f17:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102f1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f20:	83 fa 1d             	cmp    $0x1d,%edx
80102f23:	0f 8f 9d 00 00 00    	jg     80102fc6 <log_write+0xb6>
80102f29:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102f2e:	83 e8 01             	sub    $0x1,%eax
80102f31:	39 c2                	cmp    %eax,%edx
80102f33:	0f 8d 8d 00 00 00    	jge    80102fc6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f39:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102f3e:	85 c0                	test   %eax,%eax
80102f40:	0f 8e 8d 00 00 00    	jle    80102fd3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f46:	83 ec 0c             	sub    $0xc,%esp
80102f49:	68 80 26 11 80       	push   $0x80112680
80102f4e:	e8 fd 14 00 00       	call   80104450 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f53:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102f59:	83 c4 10             	add    $0x10,%esp
80102f5c:	83 f9 00             	cmp    $0x0,%ecx
80102f5f:	7e 57                	jle    80102fb8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f61:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102f64:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f66:	3b 15 cc 26 11 80    	cmp    0x801126cc,%edx
80102f6c:	75 0b                	jne    80102f79 <log_write+0x69>
80102f6e:	eb 38                	jmp    80102fa8 <log_write+0x98>
80102f70:	39 14 85 cc 26 11 80 	cmp    %edx,-0x7feed934(,%eax,4)
80102f77:	74 2f                	je     80102fa8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102f79:	83 c0 01             	add    $0x1,%eax
80102f7c:	39 c1                	cmp    %eax,%ecx
80102f7e:	75 f0                	jne    80102f70 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f80:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102f87:	83 c0 01             	add    $0x1,%eax
80102f8a:	a3 c8 26 11 80       	mov    %eax,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102f8f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102f92:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102f99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f9c:	c9                   	leave  
  release(&log.lock);
80102f9d:	e9 ce 15 00 00       	jmp    80104570 <release>
80102fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fa8:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
80102faf:	eb de                	jmp    80102f8f <log_write+0x7f>
80102fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fb8:	8b 43 08             	mov    0x8(%ebx),%eax
80102fbb:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102fc0:	75 cd                	jne    80102f8f <log_write+0x7f>
80102fc2:	31 c0                	xor    %eax,%eax
80102fc4:	eb c1                	jmp    80102f87 <log_write+0x77>
    panic("too big a transaction");
80102fc6:	83 ec 0c             	sub    $0xc,%esp
80102fc9:	68 b3 75 10 80       	push   $0x801075b3
80102fce:	e8 dd d3 ff ff       	call   801003b0 <panic>
    panic("log_write outside of trans");
80102fd3:	83 ec 0c             	sub    $0xc,%esp
80102fd6:	68 c9 75 10 80       	push   $0x801075c9
80102fdb:	e8 d0 d3 ff ff       	call   801003b0 <panic>

80102fe0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	53                   	push   %ebx
80102fe4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102fe7:	e8 74 09 00 00       	call   80103960 <cpuid>
80102fec:	89 c3                	mov    %eax,%ebx
80102fee:	e8 6d 09 00 00       	call   80103960 <cpuid>
80102ff3:	83 ec 04             	sub    $0x4,%esp
80102ff6:	53                   	push   %ebx
80102ff7:	50                   	push   %eax
80102ff8:	68 e4 75 10 80       	push   $0x801075e4
80102ffd:	e8 7e d6 ff ff       	call   80100680 <cprintf>
  idtinit();       // load idt register
80103002:	e8 79 28 00 00       	call   80105880 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103007:	e8 d4 08 00 00       	call   801038e0 <mycpu>
8010300c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010300e:	b8 01 00 00 00       	mov    $0x1,%eax
80103013:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010301a:	e8 f1 0b 00 00       	call   80103c10 <scheduler>
8010301f:	90                   	nop

80103020 <mpenter>:
{
80103020:	55                   	push   %ebp
80103021:	89 e5                	mov    %esp,%ebp
80103023:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103026:	e8 a5 39 00 00       	call   801069d0 <switchkvm>
  seginit();
8010302b:	e8 10 39 00 00       	call   80106940 <seginit>
  lapicinit();
80103030:	e8 9b f7 ff ff       	call   801027d0 <lapicinit>
  mpmain();
80103035:	e8 a6 ff ff ff       	call   80102fe0 <mpmain>
8010303a:	66 90                	xchg   %ax,%ax
8010303c:	66 90                	xchg   %ax,%ax
8010303e:	66 90                	xchg   %ax,%ax

80103040 <main>:
{
80103040:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103044:	83 e4 f0             	and    $0xfffffff0,%esp
80103047:	ff 71 fc             	pushl  -0x4(%ecx)
8010304a:	55                   	push   %ebp
8010304b:	89 e5                	mov    %esp,%ebp
8010304d:	53                   	push   %ebx
8010304e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010304f:	83 ec 08             	sub    $0x8,%esp
80103052:	68 00 00 40 80       	push   $0x80400000
80103057:	68 a8 54 11 80       	push   $0x801154a8
8010305c:	e8 2f f5 ff ff       	call   80102590 <kinit1>
  kvmalloc();      // kernel page table
80103061:	e8 0a 3e 00 00       	call   80106e70 <kvmalloc>
  mpinit();        // detect other processors
80103066:	e8 75 01 00 00       	call   801031e0 <mpinit>
  lapicinit();     // interrupt controller
8010306b:	e8 60 f7 ff ff       	call   801027d0 <lapicinit>
  seginit();       // segment descriptors
80103070:	e8 cb 38 00 00       	call   80106940 <seginit>
  picinit();       // disable pic
80103075:	e8 46 03 00 00       	call   801033c0 <picinit>
  ioapicinit();    // another interrupt controller
8010307a:	e8 41 f3 ff ff       	call   801023c0 <ioapicinit>
  consoleinit();   // console hardware
8010307f:	e8 5c d9 ff ff       	call   801009e0 <consoleinit>
  uartinit();      // serial port
80103084:	e8 87 2b 00 00       	call   80105c10 <uartinit>
  pinit();         // process table
80103089:	e8 32 08 00 00       	call   801038c0 <pinit>
  tvinit();        // trap vectors
8010308e:	e8 6d 27 00 00       	call   80105800 <tvinit>
  binit();         // buffer cache
80103093:	e8 a8 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103098:	e8 e3 dc ff ff       	call   80100d80 <fileinit>
  ideinit();       // disk 
8010309d:	e8 fe f0 ff ff       	call   801021a0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030a2:	83 c4 0c             	add    $0xc,%esp
801030a5:	68 8a 00 00 00       	push   $0x8a
801030aa:	68 8c a4 10 80       	push   $0x8010a48c
801030af:	68 00 70 00 80       	push   $0x80007000
801030b4:	e8 c7 15 00 00       	call   80104680 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030b9:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
801030c0:	00 00 00 
801030c3:	83 c4 10             	add    $0x10,%esp
801030c6:	05 80 27 11 80       	add    $0x80112780,%eax
801030cb:	3d 80 27 11 80       	cmp    $0x80112780,%eax
801030d0:	76 71                	jbe    80103143 <main+0x103>
801030d2:	bb 80 27 11 80       	mov    $0x80112780,%ebx
801030d7:	89 f6                	mov    %esi,%esi
801030d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
801030e0:	e8 fb 07 00 00       	call   801038e0 <mycpu>
801030e5:	39 d8                	cmp    %ebx,%eax
801030e7:	74 41                	je     8010312a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801030e9:	e8 72 f5 ff ff       	call   80102660 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801030ee:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
801030f3:	c7 05 f8 6f 00 80 20 	movl   $0x80103020,0x80006ff8
801030fa:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801030fd:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80103104:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103107:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010310c:	0f b6 03             	movzbl (%ebx),%eax
8010310f:	83 ec 08             	sub    $0x8,%esp
80103112:	68 00 70 00 00       	push   $0x7000
80103117:	50                   	push   %eax
80103118:	e8 03 f8 ff ff       	call   80102920 <lapicstartap>
8010311d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103120:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103126:	85 c0                	test   %eax,%eax
80103128:	74 f6                	je     80103120 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010312a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103131:	00 00 00 
80103134:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010313a:	05 80 27 11 80       	add    $0x80112780,%eax
8010313f:	39 c3                	cmp    %eax,%ebx
80103141:	72 9d                	jb     801030e0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103143:	83 ec 08             	sub    $0x8,%esp
80103146:	68 00 00 40 80       	push   $0x80400000
8010314b:	68 00 00 40 80       	push   $0x80400000
80103150:	e8 ab f4 ff ff       	call   80102600 <kinit2>
  userinit();      // first user process
80103155:	e8 56 08 00 00       	call   801039b0 <userinit>
  mpmain();        // finish this processor's setup
8010315a:	e8 81 fe ff ff       	call   80102fe0 <mpmain>
8010315f:	90                   	nop

80103160 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	57                   	push   %edi
80103164:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103165:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010316b:	53                   	push   %ebx
  e = addr+len;
8010316c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010316f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103172:	39 de                	cmp    %ebx,%esi
80103174:	72 10                	jb     80103186 <mpsearch1+0x26>
80103176:	eb 50                	jmp    801031c8 <mpsearch1+0x68>
80103178:	90                   	nop
80103179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103180:	39 fb                	cmp    %edi,%ebx
80103182:	89 fe                	mov    %edi,%esi
80103184:	76 42                	jbe    801031c8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103186:	83 ec 04             	sub    $0x4,%esp
80103189:	8d 7e 10             	lea    0x10(%esi),%edi
8010318c:	6a 04                	push   $0x4
8010318e:	68 f8 75 10 80       	push   $0x801075f8
80103193:	56                   	push   %esi
80103194:	e8 87 14 00 00       	call   80104620 <memcmp>
80103199:	83 c4 10             	add    $0x10,%esp
8010319c:	85 c0                	test   %eax,%eax
8010319e:	75 e0                	jne    80103180 <mpsearch1+0x20>
801031a0:	89 f1                	mov    %esi,%ecx
801031a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031a8:	0f b6 11             	movzbl (%ecx),%edx
801031ab:	83 c1 01             	add    $0x1,%ecx
801031ae:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801031b0:	39 f9                	cmp    %edi,%ecx
801031b2:	75 f4                	jne    801031a8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b4:	84 c0                	test   %al,%al
801031b6:	75 c8                	jne    80103180 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031bb:	89 f0                	mov    %esi,%eax
801031bd:	5b                   	pop    %ebx
801031be:	5e                   	pop    %esi
801031bf:	5f                   	pop    %edi
801031c0:	5d                   	pop    %ebp
801031c1:	c3                   	ret    
801031c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031cb:	31 f6                	xor    %esi,%esi
}
801031cd:	89 f0                	mov    %esi,%eax
801031cf:	5b                   	pop    %ebx
801031d0:	5e                   	pop    %esi
801031d1:	5f                   	pop    %edi
801031d2:	5d                   	pop    %ebp
801031d3:	c3                   	ret    
801031d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801031e0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801031e0:	55                   	push   %ebp
801031e1:	89 e5                	mov    %esp,%ebp
801031e3:	57                   	push   %edi
801031e4:	56                   	push   %esi
801031e5:	53                   	push   %ebx
801031e6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801031e9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801031f0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801031f7:	c1 e0 08             	shl    $0x8,%eax
801031fa:	09 d0                	or     %edx,%eax
801031fc:	c1 e0 04             	shl    $0x4,%eax
801031ff:	85 c0                	test   %eax,%eax
80103201:	75 1b                	jne    8010321e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103203:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010320a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103211:	c1 e0 08             	shl    $0x8,%eax
80103214:	09 d0                	or     %edx,%eax
80103216:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103219:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010321e:	ba 00 04 00 00       	mov    $0x400,%edx
80103223:	e8 38 ff ff ff       	call   80103160 <mpsearch1>
80103228:	85 c0                	test   %eax,%eax
8010322a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010322d:	0f 84 3d 01 00 00    	je     80103370 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103236:	8b 58 04             	mov    0x4(%eax),%ebx
80103239:	85 db                	test   %ebx,%ebx
8010323b:	0f 84 4f 01 00 00    	je     80103390 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103241:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103247:	83 ec 04             	sub    $0x4,%esp
8010324a:	6a 04                	push   $0x4
8010324c:	68 15 76 10 80       	push   $0x80107615
80103251:	56                   	push   %esi
80103252:	e8 c9 13 00 00       	call   80104620 <memcmp>
80103257:	83 c4 10             	add    $0x10,%esp
8010325a:	85 c0                	test   %eax,%eax
8010325c:	0f 85 2e 01 00 00    	jne    80103390 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103262:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103269:	3c 01                	cmp    $0x1,%al
8010326b:	0f 95 c2             	setne  %dl
8010326e:	3c 04                	cmp    $0x4,%al
80103270:	0f 95 c0             	setne  %al
80103273:	20 c2                	and    %al,%dl
80103275:	0f 85 15 01 00 00    	jne    80103390 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010327b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103282:	66 85 ff             	test   %di,%di
80103285:	74 1a                	je     801032a1 <mpinit+0xc1>
80103287:	89 f0                	mov    %esi,%eax
80103289:	01 f7                	add    %esi,%edi
  sum = 0;
8010328b:	31 d2                	xor    %edx,%edx
8010328d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103290:	0f b6 08             	movzbl (%eax),%ecx
80103293:	83 c0 01             	add    $0x1,%eax
80103296:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103298:	39 c7                	cmp    %eax,%edi
8010329a:	75 f4                	jne    80103290 <mpinit+0xb0>
8010329c:	84 d2                	test   %dl,%dl
8010329e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801032a1:	85 f6                	test   %esi,%esi
801032a3:	0f 84 e7 00 00 00    	je     80103390 <mpinit+0x1b0>
801032a9:	84 d2                	test   %dl,%dl
801032ab:	0f 85 df 00 00 00    	jne    80103390 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032b1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801032b7:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032bc:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801032c3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801032c9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032ce:	01 d6                	add    %edx,%esi
801032d0:	39 c6                	cmp    %eax,%esi
801032d2:	76 23                	jbe    801032f7 <mpinit+0x117>
    switch(*p){
801032d4:	0f b6 10             	movzbl (%eax),%edx
801032d7:	80 fa 04             	cmp    $0x4,%dl
801032da:	0f 87 ca 00 00 00    	ja     801033aa <mpinit+0x1ca>
801032e0:	ff 24 95 3c 76 10 80 	jmp    *-0x7fef89c4(,%edx,4)
801032e7:	89 f6                	mov    %esi,%esi
801032e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801032f0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032f3:	39 c6                	cmp    %eax,%esi
801032f5:	77 dd                	ja     801032d4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801032f7:	85 db                	test   %ebx,%ebx
801032f9:	0f 84 9e 00 00 00    	je     8010339d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801032ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103302:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103306:	74 15                	je     8010331d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103308:	b8 70 00 00 00       	mov    $0x70,%eax
8010330d:	ba 22 00 00 00       	mov    $0x22,%edx
80103312:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103313:	ba 23 00 00 00       	mov    $0x23,%edx
80103318:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103319:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010331c:	ee                   	out    %al,(%dx)
  }
}
8010331d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103320:	5b                   	pop    %ebx
80103321:	5e                   	pop    %esi
80103322:	5f                   	pop    %edi
80103323:	5d                   	pop    %ebp
80103324:	c3                   	ret    
80103325:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103328:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
8010332e:	83 f9 07             	cmp    $0x7,%ecx
80103331:	7f 19                	jg     8010334c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103333:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103337:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010333d:	83 c1 01             	add    $0x1,%ecx
80103340:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103346:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
8010334c:	83 c0 14             	add    $0x14,%eax
      continue;
8010334f:	e9 7c ff ff ff       	jmp    801032d0 <mpinit+0xf0>
80103354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103358:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010335c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010335f:	88 15 60 27 11 80    	mov    %dl,0x80112760
      continue;
80103365:	e9 66 ff ff ff       	jmp    801032d0 <mpinit+0xf0>
8010336a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103370:	ba 00 00 01 00       	mov    $0x10000,%edx
80103375:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010337a:	e8 e1 fd ff ff       	call   80103160 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010337f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103381:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103384:	0f 85 a9 fe ff ff    	jne    80103233 <mpinit+0x53>
8010338a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103390:	83 ec 0c             	sub    $0xc,%esp
80103393:	68 fd 75 10 80       	push   $0x801075fd
80103398:	e8 13 d0 ff ff       	call   801003b0 <panic>
    panic("Didn't find a suitable machine");
8010339d:	83 ec 0c             	sub    $0xc,%esp
801033a0:	68 1c 76 10 80       	push   $0x8010761c
801033a5:	e8 06 d0 ff ff       	call   801003b0 <panic>
      ismp = 0;
801033aa:	31 db                	xor    %ebx,%ebx
801033ac:	e9 26 ff ff ff       	jmp    801032d7 <mpinit+0xf7>
801033b1:	66 90                	xchg   %ax,%ax
801033b3:	66 90                	xchg   %ax,%ax
801033b5:	66 90                	xchg   %ax,%ax
801033b7:	66 90                	xchg   %ax,%ax
801033b9:	66 90                	xchg   %ax,%ax
801033bb:	66 90                	xchg   %ax,%ax
801033bd:	66 90                	xchg   %ax,%ax
801033bf:	90                   	nop

801033c0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801033c0:	55                   	push   %ebp
801033c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033c6:	ba 21 00 00 00       	mov    $0x21,%edx
801033cb:	89 e5                	mov    %esp,%ebp
801033cd:	ee                   	out    %al,(%dx)
801033ce:	ba a1 00 00 00       	mov    $0xa1,%edx
801033d3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801033d4:	5d                   	pop    %ebp
801033d5:	c3                   	ret    
801033d6:	66 90                	xchg   %ax,%ax
801033d8:	66 90                	xchg   %ax,%ax
801033da:	66 90                	xchg   %ax,%ax
801033dc:	66 90                	xchg   %ax,%ax
801033de:	66 90                	xchg   %ax,%ax

801033e0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801033e0:	55                   	push   %ebp
801033e1:	89 e5                	mov    %esp,%ebp
801033e3:	57                   	push   %edi
801033e4:	56                   	push   %esi
801033e5:	53                   	push   %ebx
801033e6:	83 ec 0c             	sub    $0xc,%esp
801033e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801033ef:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801033f5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801033fb:	e8 a0 d9 ff ff       	call   80100da0 <filealloc>
80103400:	85 c0                	test   %eax,%eax
80103402:	89 03                	mov    %eax,(%ebx)
80103404:	74 22                	je     80103428 <pipealloc+0x48>
80103406:	e8 95 d9 ff ff       	call   80100da0 <filealloc>
8010340b:	85 c0                	test   %eax,%eax
8010340d:	89 06                	mov    %eax,(%esi)
8010340f:	74 3f                	je     80103450 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103411:	e8 4a f2 ff ff       	call   80102660 <kalloc>
80103416:	85 c0                	test   %eax,%eax
80103418:	89 c7                	mov    %eax,%edi
8010341a:	75 54                	jne    80103470 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010341c:	8b 03                	mov    (%ebx),%eax
8010341e:	85 c0                	test   %eax,%eax
80103420:	75 34                	jne    80103456 <pipealloc+0x76>
80103422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103428:	8b 06                	mov    (%esi),%eax
8010342a:	85 c0                	test   %eax,%eax
8010342c:	74 0c                	je     8010343a <pipealloc+0x5a>
    fileclose(*f1);
8010342e:	83 ec 0c             	sub    $0xc,%esp
80103431:	50                   	push   %eax
80103432:	e8 29 da ff ff       	call   80100e60 <fileclose>
80103437:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010343a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010343d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103442:	5b                   	pop    %ebx
80103443:	5e                   	pop    %esi
80103444:	5f                   	pop    %edi
80103445:	5d                   	pop    %ebp
80103446:	c3                   	ret    
80103447:	89 f6                	mov    %esi,%esi
80103449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103450:	8b 03                	mov    (%ebx),%eax
80103452:	85 c0                	test   %eax,%eax
80103454:	74 e4                	je     8010343a <pipealloc+0x5a>
    fileclose(*f0);
80103456:	83 ec 0c             	sub    $0xc,%esp
80103459:	50                   	push   %eax
8010345a:	e8 01 da ff ff       	call   80100e60 <fileclose>
  if(*f1)
8010345f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103461:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103464:	85 c0                	test   %eax,%eax
80103466:	75 c6                	jne    8010342e <pipealloc+0x4e>
80103468:	eb d0                	jmp    8010343a <pipealloc+0x5a>
8010346a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103470:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103473:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010347a:	00 00 00 
  p->writeopen = 1;
8010347d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103484:	00 00 00 
  p->nwrite = 0;
80103487:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010348e:	00 00 00 
  p->nread = 0;
80103491:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103498:	00 00 00 
  initlock(&p->lock, "pipe");
8010349b:	68 50 76 10 80       	push   $0x80107650
801034a0:	50                   	push   %eax
801034a1:	e8 ba 0e 00 00       	call   80104360 <initlock>
  (*f0)->type = FD_PIPE;
801034a6:	8b 03                	mov    (%ebx),%eax
  return 0;
801034a8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034ab:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034b1:	8b 03                	mov    (%ebx),%eax
801034b3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034b7:	8b 03                	mov    (%ebx),%eax
801034b9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034bd:	8b 03                	mov    (%ebx),%eax
801034bf:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034c2:	8b 06                	mov    (%esi),%eax
801034c4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034ca:	8b 06                	mov    (%esi),%eax
801034cc:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034d0:	8b 06                	mov    (%esi),%eax
801034d2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034d6:	8b 06                	mov    (%esi),%eax
801034d8:	89 78 0c             	mov    %edi,0xc(%eax)
}
801034db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034de:	31 c0                	xor    %eax,%eax
}
801034e0:	5b                   	pop    %ebx
801034e1:	5e                   	pop    %esi
801034e2:	5f                   	pop    %edi
801034e3:	5d                   	pop    %ebp
801034e4:	c3                   	ret    
801034e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801034f0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801034f0:	55                   	push   %ebp
801034f1:	89 e5                	mov    %esp,%ebp
801034f3:	56                   	push   %esi
801034f4:	53                   	push   %ebx
801034f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801034f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801034fb:	83 ec 0c             	sub    $0xc,%esp
801034fe:	53                   	push   %ebx
801034ff:	e8 4c 0f 00 00       	call   80104450 <acquire>
  if(writable){
80103504:	83 c4 10             	add    $0x10,%esp
80103507:	85 f6                	test   %esi,%esi
80103509:	74 45                	je     80103550 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010350b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103511:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103514:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010351b:	00 00 00 
    wakeup(&p->nread);
8010351e:	50                   	push   %eax
8010351f:	e8 8c 0b 00 00       	call   801040b0 <wakeup>
80103524:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103527:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010352d:	85 d2                	test   %edx,%edx
8010352f:	75 0a                	jne    8010353b <pipeclose+0x4b>
80103531:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103537:	85 c0                	test   %eax,%eax
80103539:	74 35                	je     80103570 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010353b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010353e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103541:	5b                   	pop    %ebx
80103542:	5e                   	pop    %esi
80103543:	5d                   	pop    %ebp
    release(&p->lock);
80103544:	e9 27 10 00 00       	jmp    80104570 <release>
80103549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103550:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103556:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103559:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103560:	00 00 00 
    wakeup(&p->nwrite);
80103563:	50                   	push   %eax
80103564:	e8 47 0b 00 00       	call   801040b0 <wakeup>
80103569:	83 c4 10             	add    $0x10,%esp
8010356c:	eb b9                	jmp    80103527 <pipeclose+0x37>
8010356e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103570:	83 ec 0c             	sub    $0xc,%esp
80103573:	53                   	push   %ebx
80103574:	e8 f7 0f 00 00       	call   80104570 <release>
    kfree((char*)p);
80103579:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010357c:	83 c4 10             	add    $0x10,%esp
}
8010357f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103582:	5b                   	pop    %ebx
80103583:	5e                   	pop    %esi
80103584:	5d                   	pop    %ebp
    kfree((char*)p);
80103585:	e9 26 ef ff ff       	jmp    801024b0 <kfree>
8010358a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103590 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103590:	55                   	push   %ebp
80103591:	89 e5                	mov    %esp,%ebp
80103593:	57                   	push   %edi
80103594:	56                   	push   %esi
80103595:	53                   	push   %ebx
80103596:	83 ec 28             	sub    $0x28,%esp
80103599:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010359c:	53                   	push   %ebx
8010359d:	e8 ae 0e 00 00       	call   80104450 <acquire>
  for(i = 0; i < n; i++){
801035a2:	8b 45 10             	mov    0x10(%ebp),%eax
801035a5:	83 c4 10             	add    $0x10,%esp
801035a8:	85 c0                	test   %eax,%eax
801035aa:	0f 8e c9 00 00 00    	jle    80103679 <pipewrite+0xe9>
801035b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801035b3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035b9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035bf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801035c2:	03 4d 10             	add    0x10(%ebp),%ecx
801035c5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035c8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801035ce:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801035d4:	39 d0                	cmp    %edx,%eax
801035d6:	75 71                	jne    80103649 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801035d8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801035de:	85 c0                	test   %eax,%eax
801035e0:	74 4e                	je     80103630 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035e2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801035e8:	eb 3a                	jmp    80103624 <pipewrite+0x94>
801035ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
801035f0:	83 ec 0c             	sub    $0xc,%esp
801035f3:	57                   	push   %edi
801035f4:	e8 b7 0a 00 00       	call   801040b0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035f9:	5a                   	pop    %edx
801035fa:	59                   	pop    %ecx
801035fb:	53                   	push   %ebx
801035fc:	56                   	push   %esi
801035fd:	e8 ee 08 00 00       	call   80103ef0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103602:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103608:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010360e:	83 c4 10             	add    $0x10,%esp
80103611:	05 00 02 00 00       	add    $0x200,%eax
80103616:	39 c2                	cmp    %eax,%edx
80103618:	75 36                	jne    80103650 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010361a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103620:	85 c0                	test   %eax,%eax
80103622:	74 0c                	je     80103630 <pipewrite+0xa0>
80103624:	e8 57 03 00 00       	call   80103980 <myproc>
80103629:	8b 40 24             	mov    0x24(%eax),%eax
8010362c:	85 c0                	test   %eax,%eax
8010362e:	74 c0                	je     801035f0 <pipewrite+0x60>
        release(&p->lock);
80103630:	83 ec 0c             	sub    $0xc,%esp
80103633:	53                   	push   %ebx
80103634:	e8 37 0f 00 00       	call   80104570 <release>
        return -1;
80103639:	83 c4 10             	add    $0x10,%esp
8010363c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103641:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103644:	5b                   	pop    %ebx
80103645:	5e                   	pop    %esi
80103646:	5f                   	pop    %edi
80103647:	5d                   	pop    %ebp
80103648:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103649:	89 c2                	mov    %eax,%edx
8010364b:	90                   	nop
8010364c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103650:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103653:	8d 42 01             	lea    0x1(%edx),%eax
80103656:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010365c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103662:	83 c6 01             	add    $0x1,%esi
80103665:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103669:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010366c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010366f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103673:	0f 85 4f ff ff ff    	jne    801035c8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103679:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010367f:	83 ec 0c             	sub    $0xc,%esp
80103682:	50                   	push   %eax
80103683:	e8 28 0a 00 00       	call   801040b0 <wakeup>
  release(&p->lock);
80103688:	89 1c 24             	mov    %ebx,(%esp)
8010368b:	e8 e0 0e 00 00       	call   80104570 <release>
  return n;
80103690:	83 c4 10             	add    $0x10,%esp
80103693:	8b 45 10             	mov    0x10(%ebp),%eax
80103696:	eb a9                	jmp    80103641 <pipewrite+0xb1>
80103698:	90                   	nop
80103699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801036a0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	57                   	push   %edi
801036a4:	56                   	push   %esi
801036a5:	53                   	push   %ebx
801036a6:	83 ec 18             	sub    $0x18,%esp
801036a9:	8b 75 08             	mov    0x8(%ebp),%esi
801036ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036af:	56                   	push   %esi
801036b0:	e8 9b 0d 00 00       	call   80104450 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036b5:	83 c4 10             	add    $0x10,%esp
801036b8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801036be:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801036c4:	75 6a                	jne    80103730 <piperead+0x90>
801036c6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801036cc:	85 db                	test   %ebx,%ebx
801036ce:	0f 84 c4 00 00 00    	je     80103798 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801036d4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036da:	eb 2d                	jmp    80103709 <piperead+0x69>
801036dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036e0:	83 ec 08             	sub    $0x8,%esp
801036e3:	56                   	push   %esi
801036e4:	53                   	push   %ebx
801036e5:	e8 06 08 00 00       	call   80103ef0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036ea:	83 c4 10             	add    $0x10,%esp
801036ed:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801036f3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801036f9:	75 35                	jne    80103730 <piperead+0x90>
801036fb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103701:	85 d2                	test   %edx,%edx
80103703:	0f 84 8f 00 00 00    	je     80103798 <piperead+0xf8>
    if(myproc()->killed){
80103709:	e8 72 02 00 00       	call   80103980 <myproc>
8010370e:	8b 48 24             	mov    0x24(%eax),%ecx
80103711:	85 c9                	test   %ecx,%ecx
80103713:	74 cb                	je     801036e0 <piperead+0x40>
      release(&p->lock);
80103715:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103718:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010371d:	56                   	push   %esi
8010371e:	e8 4d 0e 00 00       	call   80104570 <release>
      return -1;
80103723:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103726:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103729:	89 d8                	mov    %ebx,%eax
8010372b:	5b                   	pop    %ebx
8010372c:	5e                   	pop    %esi
8010372d:	5f                   	pop    %edi
8010372e:	5d                   	pop    %ebp
8010372f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103730:	8b 45 10             	mov    0x10(%ebp),%eax
80103733:	85 c0                	test   %eax,%eax
80103735:	7e 61                	jle    80103798 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103737:	31 db                	xor    %ebx,%ebx
80103739:	eb 13                	jmp    8010374e <piperead+0xae>
8010373b:	90                   	nop
8010373c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103740:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103746:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010374c:	74 1f                	je     8010376d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010374e:	8d 41 01             	lea    0x1(%ecx),%eax
80103751:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103757:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010375d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103762:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103765:	83 c3 01             	add    $0x1,%ebx
80103768:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010376b:	75 d3                	jne    80103740 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010376d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103773:	83 ec 0c             	sub    $0xc,%esp
80103776:	50                   	push   %eax
80103777:	e8 34 09 00 00       	call   801040b0 <wakeup>
  release(&p->lock);
8010377c:	89 34 24             	mov    %esi,(%esp)
8010377f:	e8 ec 0d 00 00       	call   80104570 <release>
  return i;
80103784:	83 c4 10             	add    $0x10,%esp
}
80103787:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010378a:	89 d8                	mov    %ebx,%eax
8010378c:	5b                   	pop    %ebx
8010378d:	5e                   	pop    %esi
8010378e:	5f                   	pop    %edi
8010378f:	5d                   	pop    %ebp
80103790:	c3                   	ret    
80103791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103798:	31 db                	xor    %ebx,%ebx
8010379a:	eb d1                	jmp    8010376d <piperead+0xcd>
8010379c:	66 90                	xchg   %ax,%ax
8010379e:	66 90                	xchg   %ax,%ax

801037a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037a4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801037a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037ac:	68 20 2d 11 80       	push   $0x80112d20
801037b1:	e8 9a 0c 00 00       	call   80104450 <acquire>
801037b6:	83 c4 10             	add    $0x10,%esp
801037b9:	eb 10                	jmp    801037cb <allocproc+0x2b>
801037bb:	90                   	nop
801037bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037c0:	83 c3 7c             	add    $0x7c,%ebx
801037c3:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801037c9:	73 75                	jae    80103840 <allocproc+0xa0>
    if(p->state == UNUSED)
801037cb:	8b 43 0c             	mov    0xc(%ebx),%eax
801037ce:	85 c0                	test   %eax,%eax
801037d0:	75 ee                	jne    801037c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037d2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801037d7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037da:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801037e1:	8d 50 01             	lea    0x1(%eax),%edx
801037e4:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801037e7:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
801037ec:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
801037f2:	e8 79 0d 00 00       	call   80104570 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801037f7:	e8 64 ee ff ff       	call   80102660 <kalloc>
801037fc:	83 c4 10             	add    $0x10,%esp
801037ff:	85 c0                	test   %eax,%eax
80103801:	89 43 08             	mov    %eax,0x8(%ebx)
80103804:	74 53                	je     80103859 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103806:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010380c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010380f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103814:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103817:	c7 40 14 f2 57 10 80 	movl   $0x801057f2,0x14(%eax)
  p->context = (struct context*)sp;
8010381e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103821:	6a 14                	push   $0x14
80103823:	6a 00                	push   $0x0
80103825:	50                   	push   %eax
80103826:	e8 a5 0d 00 00       	call   801045d0 <memset>
  p->context->eip = (uint)forkret;
8010382b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010382e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103831:	c7 40 10 70 38 10 80 	movl   $0x80103870,0x10(%eax)
}
80103838:	89 d8                	mov    %ebx,%eax
8010383a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010383d:	c9                   	leave  
8010383e:	c3                   	ret    
8010383f:	90                   	nop
  release(&ptable.lock);
80103840:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103843:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103845:	68 20 2d 11 80       	push   $0x80112d20
8010384a:	e8 21 0d 00 00       	call   80104570 <release>
}
8010384f:	89 d8                	mov    %ebx,%eax
  return 0;
80103851:	83 c4 10             	add    $0x10,%esp
}
80103854:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103857:	c9                   	leave  
80103858:	c3                   	ret    
    p->state = UNUSED;
80103859:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103860:	31 db                	xor    %ebx,%ebx
80103862:	eb d4                	jmp    80103838 <allocproc+0x98>
80103864:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010386a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103870 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103876:	68 20 2d 11 80       	push   $0x80112d20
8010387b:	e8 f0 0c 00 00       	call   80104570 <release>

  if (first) {
80103880:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103885:	83 c4 10             	add    $0x10,%esp
80103888:	85 c0                	test   %eax,%eax
8010388a:	75 04                	jne    80103890 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010388c:	c9                   	leave  
8010388d:	c3                   	ret    
8010388e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103890:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103893:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010389a:	00 00 00 
    iinit(ROOTDEV);
8010389d:	6a 01                	push   $0x1
8010389f:	e8 8c dd ff ff       	call   80101630 <iinit>
    initlog(ROOTDEV);
801038a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038ab:	e8 f0 f3 ff ff       	call   80102ca0 <initlog>
801038b0:	83 c4 10             	add    $0x10,%esp
}
801038b3:	c9                   	leave  
801038b4:	c3                   	ret    
801038b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038c0 <pinit>:
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038c6:	68 55 76 10 80       	push   $0x80107655
801038cb:	68 20 2d 11 80       	push   $0x80112d20
801038d0:	e8 8b 0a 00 00       	call   80104360 <initlock>
}
801038d5:	83 c4 10             	add    $0x10,%esp
801038d8:	c9                   	leave  
801038d9:	c3                   	ret    
801038da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801038e0 <mycpu>:
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	56                   	push   %esi
801038e4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801038e5:	9c                   	pushf  
801038e6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801038e7:	f6 c4 02             	test   $0x2,%ah
801038ea:	75 5e                	jne    8010394a <mycpu+0x6a>
  apicid = lapicid();
801038ec:	e8 df ef ff ff       	call   801028d0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801038f1:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801038f7:	85 f6                	test   %esi,%esi
801038f9:	7e 42                	jle    8010393d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801038fb:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103902:	39 d0                	cmp    %edx,%eax
80103904:	74 30                	je     80103936 <mycpu+0x56>
80103906:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
8010390b:	31 d2                	xor    %edx,%edx
8010390d:	8d 76 00             	lea    0x0(%esi),%esi
80103910:	83 c2 01             	add    $0x1,%edx
80103913:	39 f2                	cmp    %esi,%edx
80103915:	74 26                	je     8010393d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103917:	0f b6 19             	movzbl (%ecx),%ebx
8010391a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103920:	39 c3                	cmp    %eax,%ebx
80103922:	75 ec                	jne    80103910 <mycpu+0x30>
80103924:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010392a:	05 80 27 11 80       	add    $0x80112780,%eax
}
8010392f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103932:	5b                   	pop    %ebx
80103933:	5e                   	pop    %esi
80103934:	5d                   	pop    %ebp
80103935:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103936:	b8 80 27 11 80       	mov    $0x80112780,%eax
      return &cpus[i];
8010393b:	eb f2                	jmp    8010392f <mycpu+0x4f>
  panic("unknown apicid\n");
8010393d:	83 ec 0c             	sub    $0xc,%esp
80103940:	68 5c 76 10 80       	push   $0x8010765c
80103945:	e8 66 ca ff ff       	call   801003b0 <panic>
    panic("mycpu called with interrupts enabled\n");
8010394a:	83 ec 0c             	sub    $0xc,%esp
8010394d:	68 38 77 10 80       	push   $0x80107738
80103952:	e8 59 ca ff ff       	call   801003b0 <panic>
80103957:	89 f6                	mov    %esi,%esi
80103959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103960 <cpuid>:
cpuid() {
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103966:	e8 75 ff ff ff       	call   801038e0 <mycpu>
8010396b:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
80103970:	c9                   	leave  
  return mycpu()-cpus;
80103971:	c1 f8 04             	sar    $0x4,%eax
80103974:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010397a:	c3                   	ret    
8010397b:	90                   	nop
8010397c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103980 <myproc>:
myproc(void) {
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	53                   	push   %ebx
80103984:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103987:	e8 84 0a 00 00       	call   80104410 <pushcli>
  c = mycpu();
8010398c:	e8 4f ff ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80103991:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103997:	e8 74 0b 00 00       	call   80104510 <popcli>
}
8010399c:	83 c4 04             	add    $0x4,%esp
8010399f:	89 d8                	mov    %ebx,%eax
801039a1:	5b                   	pop    %ebx
801039a2:	5d                   	pop    %ebp
801039a3:	c3                   	ret    
801039a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801039b0 <userinit>:
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	53                   	push   %ebx
801039b4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039b7:	e8 e4 fd ff ff       	call   801037a0 <allocproc>
801039bc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039be:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801039c3:	e8 28 34 00 00       	call   80106df0 <setupkvm>
801039c8:	85 c0                	test   %eax,%eax
801039ca:	89 43 04             	mov    %eax,0x4(%ebx)
801039cd:	0f 84 bd 00 00 00    	je     80103a90 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039d3:	83 ec 04             	sub    $0x4,%esp
801039d6:	68 2c 00 00 00       	push   $0x2c
801039db:	68 60 a4 10 80       	push   $0x8010a460
801039e0:	50                   	push   %eax
801039e1:	e8 1a 31 00 00       	call   80106b00 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039e6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039e9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039ef:	6a 4c                	push   $0x4c
801039f1:	6a 00                	push   $0x0
801039f3:	ff 73 18             	pushl  0x18(%ebx)
801039f6:	e8 d5 0b 00 00       	call   801045d0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039fb:	8b 43 18             	mov    0x18(%ebx),%eax
801039fe:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a03:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a08:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a0b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a0f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a12:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a16:	8b 43 18             	mov    0x18(%ebx),%eax
80103a19:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a1d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a21:	8b 43 18             	mov    0x18(%ebx),%eax
80103a24:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a28:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a2c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a2f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a36:	8b 43 18             	mov    0x18(%ebx),%eax
80103a39:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a40:	8b 43 18             	mov    0x18(%ebx),%eax
80103a43:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a4a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a4d:	6a 10                	push   $0x10
80103a4f:	68 85 76 10 80       	push   $0x80107685
80103a54:	50                   	push   %eax
80103a55:	e8 56 0d 00 00       	call   801047b0 <safestrcpy>
  p->cwd = namei("/");
80103a5a:	c7 04 24 8e 76 10 80 	movl   $0x8010768e,(%esp)
80103a61:	e8 2a e6 ff ff       	call   80102090 <namei>
80103a66:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a69:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a70:	e8 db 09 00 00       	call   80104450 <acquire>
  p->state = RUNNABLE;
80103a75:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a7c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a83:	e8 e8 0a 00 00       	call   80104570 <release>
}
80103a88:	83 c4 10             	add    $0x10,%esp
80103a8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a8e:	c9                   	leave  
80103a8f:	c3                   	ret    
    panic("userinit: out of memory?");
80103a90:	83 ec 0c             	sub    $0xc,%esp
80103a93:	68 6c 76 10 80       	push   $0x8010766c
80103a98:	e8 13 c9 ff ff       	call   801003b0 <panic>
80103a9d:	8d 76 00             	lea    0x0(%esi),%esi

80103aa0 <growproc>:
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	56                   	push   %esi
80103aa4:	53                   	push   %ebx
80103aa5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103aa8:	e8 63 09 00 00       	call   80104410 <pushcli>
  c = mycpu();
80103aad:	e8 2e fe ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80103ab2:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ab8:	e8 53 0a 00 00       	call   80104510 <popcli>
  if (n < 0 || n > KERNBASE || curproc->sz + n > KERNBASE)
80103abd:	85 db                	test   %ebx,%ebx
80103abf:	78 1f                	js     80103ae0 <growproc+0x40>
80103ac1:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80103ac7:	77 17                	ja     80103ae0 <growproc+0x40>
80103ac9:	03 1e                	add    (%esi),%ebx
80103acb:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80103ad1:	77 0d                	ja     80103ae0 <growproc+0x40>
  curproc->sz += n;
80103ad3:	89 1e                	mov    %ebx,(%esi)
  return 0;
80103ad5:	31 c0                	xor    %eax,%eax
}
80103ad7:	5b                   	pop    %ebx
80103ad8:	5e                   	pop    %esi
80103ad9:	5d                   	pop    %ebp
80103ada:	c3                   	ret    
80103adb:	90                   	nop
80103adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	  return -1;
80103ae0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ae5:	eb f0                	jmp    80103ad7 <growproc+0x37>
80103ae7:	89 f6                	mov    %esi,%esi
80103ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103af0 <fork>:
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	57                   	push   %edi
80103af4:	56                   	push   %esi
80103af5:	53                   	push   %ebx
80103af6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103af9:	e8 12 09 00 00       	call   80104410 <pushcli>
  c = mycpu();
80103afe:	e8 dd fd ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80103b03:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b09:	e8 02 0a 00 00       	call   80104510 <popcli>
  if((np = allocproc()) == 0){
80103b0e:	e8 8d fc ff ff       	call   801037a0 <allocproc>
80103b13:	85 c0                	test   %eax,%eax
80103b15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b18:	0f 84 b7 00 00 00    	je     80103bd5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b1e:	83 ec 08             	sub    $0x8,%esp
80103b21:	ff 33                	pushl  (%ebx)
80103b23:	ff 73 04             	pushl  0x4(%ebx)
80103b26:	89 c7                	mov    %eax,%edi
80103b28:	e8 c3 33 00 00       	call   80106ef0 <copyuvm>
80103b2d:	83 c4 10             	add    $0x10,%esp
80103b30:	85 c0                	test   %eax,%eax
80103b32:	89 47 04             	mov    %eax,0x4(%edi)
80103b35:	0f 84 a1 00 00 00    	je     80103bdc <fork+0xec>
  np->sz = curproc->sz;
80103b3b:	8b 03                	mov    (%ebx),%eax
80103b3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b40:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103b42:	89 59 14             	mov    %ebx,0x14(%ecx)
80103b45:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103b47:	8b 79 18             	mov    0x18(%ecx),%edi
80103b4a:	8b 73 18             	mov    0x18(%ebx),%esi
80103b4d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b52:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b54:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b56:	8b 40 18             	mov    0x18(%eax),%eax
80103b59:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103b60:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b64:	85 c0                	test   %eax,%eax
80103b66:	74 13                	je     80103b7b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b68:	83 ec 0c             	sub    $0xc,%esp
80103b6b:	50                   	push   %eax
80103b6c:	e8 9f d2 ff ff       	call   80100e10 <filedup>
80103b71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b74:	83 c4 10             	add    $0x10,%esp
80103b77:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103b7b:	83 c6 01             	add    $0x1,%esi
80103b7e:	83 fe 10             	cmp    $0x10,%esi
80103b81:	75 dd                	jne    80103b60 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103b83:	83 ec 0c             	sub    $0xc,%esp
80103b86:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b89:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103b8c:	e8 6f dc ff ff       	call   80101800 <idup>
80103b91:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b94:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103b97:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b9a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103b9d:	6a 10                	push   $0x10
80103b9f:	53                   	push   %ebx
80103ba0:	50                   	push   %eax
80103ba1:	e8 0a 0c 00 00       	call   801047b0 <safestrcpy>
  pid = np->pid;
80103ba6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103ba9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bb0:	e8 9b 08 00 00       	call   80104450 <acquire>
  np->state = RUNNABLE;
80103bb5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103bbc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bc3:	e8 a8 09 00 00       	call   80104570 <release>
  return pid;
80103bc8:	83 c4 10             	add    $0x10,%esp
}
80103bcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bce:	89 d8                	mov    %ebx,%eax
80103bd0:	5b                   	pop    %ebx
80103bd1:	5e                   	pop    %esi
80103bd2:	5f                   	pop    %edi
80103bd3:	5d                   	pop    %ebp
80103bd4:	c3                   	ret    
    return -1;
80103bd5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103bda:	eb ef                	jmp    80103bcb <fork+0xdb>
    kfree(np->kstack);
80103bdc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103bdf:	83 ec 0c             	sub    $0xc,%esp
80103be2:	ff 73 08             	pushl  0x8(%ebx)
80103be5:	e8 c6 e8 ff ff       	call   801024b0 <kfree>
    np->kstack = 0;
80103bea:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103bf1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103bf8:	83 c4 10             	add    $0x10,%esp
80103bfb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c00:	eb c9                	jmp    80103bcb <fork+0xdb>
80103c02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c10 <scheduler>:
{
80103c10:	55                   	push   %ebp
80103c11:	89 e5                	mov    %esp,%ebp
80103c13:	57                   	push   %edi
80103c14:	56                   	push   %esi
80103c15:	53                   	push   %ebx
80103c16:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c19:	e8 c2 fc ff ff       	call   801038e0 <mycpu>
80103c1e:	8d 78 04             	lea    0x4(%eax),%edi
80103c21:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c23:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c2a:	00 00 00 
80103c2d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103c30:	fb                   	sti    
    acquire(&ptable.lock);
80103c31:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c34:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103c39:	68 20 2d 11 80       	push   $0x80112d20
80103c3e:	e8 0d 08 00 00       	call   80104450 <acquire>
80103c43:	83 c4 10             	add    $0x10,%esp
80103c46:	8d 76 00             	lea    0x0(%esi),%esi
80103c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103c50:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c54:	75 33                	jne    80103c89 <scheduler+0x79>
      switchuvm(p);
80103c56:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c59:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103c5f:	53                   	push   %ebx
80103c60:	e8 8b 2d 00 00       	call   801069f0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103c65:	58                   	pop    %eax
80103c66:	5a                   	pop    %edx
80103c67:	ff 73 1c             	pushl  0x1c(%ebx)
80103c6a:	57                   	push   %edi
      p->state = RUNNING;
80103c6b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103c72:	e8 94 0b 00 00       	call   8010480b <swtch>
      switchkvm();
80103c77:	e8 54 2d 00 00       	call   801069d0 <switchkvm>
      c->proc = 0;
80103c7c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103c83:	00 00 00 
80103c86:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c89:	83 c3 7c             	add    $0x7c,%ebx
80103c8c:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103c92:	72 bc                	jb     80103c50 <scheduler+0x40>
    release(&ptable.lock);
80103c94:	83 ec 0c             	sub    $0xc,%esp
80103c97:	68 20 2d 11 80       	push   $0x80112d20
80103c9c:	e8 cf 08 00 00       	call   80104570 <release>
    sti();
80103ca1:	83 c4 10             	add    $0x10,%esp
80103ca4:	eb 8a                	jmp    80103c30 <scheduler+0x20>
80103ca6:	8d 76 00             	lea    0x0(%esi),%esi
80103ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103cb0 <sched>:
{
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	56                   	push   %esi
80103cb4:	53                   	push   %ebx
  pushcli();
80103cb5:	e8 56 07 00 00       	call   80104410 <pushcli>
  c = mycpu();
80103cba:	e8 21 fc ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80103cbf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cc5:	e8 46 08 00 00       	call   80104510 <popcli>
  if(!holding(&ptable.lock))
80103cca:	83 ec 0c             	sub    $0xc,%esp
80103ccd:	68 20 2d 11 80       	push   $0x80112d20
80103cd2:	e8 f9 06 00 00       	call   801043d0 <holding>
80103cd7:	83 c4 10             	add    $0x10,%esp
80103cda:	85 c0                	test   %eax,%eax
80103cdc:	74 4f                	je     80103d2d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103cde:	e8 fd fb ff ff       	call   801038e0 <mycpu>
80103ce3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103cea:	75 68                	jne    80103d54 <sched+0xa4>
  if(p->state == RUNNING)
80103cec:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103cf0:	74 55                	je     80103d47 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103cf2:	9c                   	pushf  
80103cf3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103cf4:	f6 c4 02             	test   $0x2,%ah
80103cf7:	75 41                	jne    80103d3a <sched+0x8a>
  intena = mycpu()->intena;
80103cf9:	e8 e2 fb ff ff       	call   801038e0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103cfe:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d01:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d07:	e8 d4 fb ff ff       	call   801038e0 <mycpu>
80103d0c:	83 ec 08             	sub    $0x8,%esp
80103d0f:	ff 70 04             	pushl  0x4(%eax)
80103d12:	53                   	push   %ebx
80103d13:	e8 f3 0a 00 00       	call   8010480b <swtch>
  mycpu()->intena = intena;
80103d18:	e8 c3 fb ff ff       	call   801038e0 <mycpu>
}
80103d1d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d20:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d26:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d29:	5b                   	pop    %ebx
80103d2a:	5e                   	pop    %esi
80103d2b:	5d                   	pop    %ebp
80103d2c:	c3                   	ret    
    panic("sched ptable.lock");
80103d2d:	83 ec 0c             	sub    $0xc,%esp
80103d30:	68 90 76 10 80       	push   $0x80107690
80103d35:	e8 76 c6 ff ff       	call   801003b0 <panic>
    panic("sched interruptible");
80103d3a:	83 ec 0c             	sub    $0xc,%esp
80103d3d:	68 bc 76 10 80       	push   $0x801076bc
80103d42:	e8 69 c6 ff ff       	call   801003b0 <panic>
    panic("sched running");
80103d47:	83 ec 0c             	sub    $0xc,%esp
80103d4a:	68 ae 76 10 80       	push   $0x801076ae
80103d4f:	e8 5c c6 ff ff       	call   801003b0 <panic>
    panic("sched locks");
80103d54:	83 ec 0c             	sub    $0xc,%esp
80103d57:	68 a2 76 10 80       	push   $0x801076a2
80103d5c:	e8 4f c6 ff ff       	call   801003b0 <panic>
80103d61:	eb 0d                	jmp    80103d70 <exit>
80103d63:	90                   	nop
80103d64:	90                   	nop
80103d65:	90                   	nop
80103d66:	90                   	nop
80103d67:	90                   	nop
80103d68:	90                   	nop
80103d69:	90                   	nop
80103d6a:	90                   	nop
80103d6b:	90                   	nop
80103d6c:	90                   	nop
80103d6d:	90                   	nop
80103d6e:	90                   	nop
80103d6f:	90                   	nop

80103d70 <exit>:
{
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	57                   	push   %edi
80103d74:	56                   	push   %esi
80103d75:	53                   	push   %ebx
80103d76:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103d79:	e8 92 06 00 00       	call   80104410 <pushcli>
  c = mycpu();
80103d7e:	e8 5d fb ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80103d83:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103d89:	e8 82 07 00 00       	call   80104510 <popcli>
  if(curproc == initproc)
80103d8e:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103d94:	8d 5e 28             	lea    0x28(%esi),%ebx
80103d97:	8d 7e 68             	lea    0x68(%esi),%edi
80103d9a:	0f 84 e7 00 00 00    	je     80103e87 <exit+0x117>
    if(curproc->ofile[fd]){
80103da0:	8b 03                	mov    (%ebx),%eax
80103da2:	85 c0                	test   %eax,%eax
80103da4:	74 12                	je     80103db8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103da6:	83 ec 0c             	sub    $0xc,%esp
80103da9:	50                   	push   %eax
80103daa:	e8 b1 d0 ff ff       	call   80100e60 <fileclose>
      curproc->ofile[fd] = 0;
80103daf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103db5:	83 c4 10             	add    $0x10,%esp
80103db8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103dbb:	39 fb                	cmp    %edi,%ebx
80103dbd:	75 e1                	jne    80103da0 <exit+0x30>
  begin_op();
80103dbf:	e8 7c ef ff ff       	call   80102d40 <begin_op>
  iput(curproc->cwd);
80103dc4:	83 ec 0c             	sub    $0xc,%esp
80103dc7:	ff 76 68             	pushl  0x68(%esi)
80103dca:	e8 91 db ff ff       	call   80101960 <iput>
  end_op();
80103dcf:	e8 dc ef ff ff       	call   80102db0 <end_op>
  curproc->cwd = 0;
80103dd4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103ddb:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103de2:	e8 69 06 00 00       	call   80104450 <acquire>
  wakeup1(curproc->parent);
80103de7:	8b 56 14             	mov    0x14(%esi),%edx
80103dea:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ded:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103df2:	eb 0e                	jmp    80103e02 <exit+0x92>
80103df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103df8:	83 c0 7c             	add    $0x7c,%eax
80103dfb:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103e00:	73 1c                	jae    80103e1e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103e02:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e06:	75 f0                	jne    80103df8 <exit+0x88>
80103e08:	3b 50 20             	cmp    0x20(%eax),%edx
80103e0b:	75 eb                	jne    80103df8 <exit+0x88>
      p->state = RUNNABLE;
80103e0d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e14:	83 c0 7c             	add    $0x7c,%eax
80103e17:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103e1c:	72 e4                	jb     80103e02 <exit+0x92>
      p->parent = initproc;
80103e1e:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e24:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103e29:	eb 10                	jmp    80103e3b <exit+0xcb>
80103e2b:	90                   	nop
80103e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e30:	83 c2 7c             	add    $0x7c,%edx
80103e33:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103e39:	73 33                	jae    80103e6e <exit+0xfe>
    if(p->parent == curproc){
80103e3b:	39 72 14             	cmp    %esi,0x14(%edx)
80103e3e:	75 f0                	jne    80103e30 <exit+0xc0>
      if(p->state == ZOMBIE)
80103e40:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103e44:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e47:	75 e7                	jne    80103e30 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e49:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e4e:	eb 0a                	jmp    80103e5a <exit+0xea>
80103e50:	83 c0 7c             	add    $0x7c,%eax
80103e53:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103e58:	73 d6                	jae    80103e30 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103e5a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e5e:	75 f0                	jne    80103e50 <exit+0xe0>
80103e60:	3b 48 20             	cmp    0x20(%eax),%ecx
80103e63:	75 eb                	jne    80103e50 <exit+0xe0>
      p->state = RUNNABLE;
80103e65:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e6c:	eb e2                	jmp    80103e50 <exit+0xe0>
  curproc->state = ZOMBIE;
80103e6e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103e75:	e8 36 fe ff ff       	call   80103cb0 <sched>
  panic("zombie exit");
80103e7a:	83 ec 0c             	sub    $0xc,%esp
80103e7d:	68 dd 76 10 80       	push   $0x801076dd
80103e82:	e8 29 c5 ff ff       	call   801003b0 <panic>
    panic("init exiting");
80103e87:	83 ec 0c             	sub    $0xc,%esp
80103e8a:	68 d0 76 10 80       	push   $0x801076d0
80103e8f:	e8 1c c5 ff ff       	call   801003b0 <panic>
80103e94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103ea0 <yield>:
{
80103ea0:	55                   	push   %ebp
80103ea1:	89 e5                	mov    %esp,%ebp
80103ea3:	53                   	push   %ebx
80103ea4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103ea7:	68 20 2d 11 80       	push   $0x80112d20
80103eac:	e8 9f 05 00 00       	call   80104450 <acquire>
  pushcli();
80103eb1:	e8 5a 05 00 00       	call   80104410 <pushcli>
  c = mycpu();
80103eb6:	e8 25 fa ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80103ebb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ec1:	e8 4a 06 00 00       	call   80104510 <popcli>
  myproc()->state = RUNNABLE;
80103ec6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103ecd:	e8 de fd ff ff       	call   80103cb0 <sched>
  release(&ptable.lock);
80103ed2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ed9:	e8 92 06 00 00       	call   80104570 <release>
}
80103ede:	83 c4 10             	add    $0x10,%esp
80103ee1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ee4:	c9                   	leave  
80103ee5:	c3                   	ret    
80103ee6:	8d 76 00             	lea    0x0(%esi),%esi
80103ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ef0 <sleep>:
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	57                   	push   %edi
80103ef4:	56                   	push   %esi
80103ef5:	53                   	push   %ebx
80103ef6:	83 ec 0c             	sub    $0xc,%esp
80103ef9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103efc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103eff:	e8 0c 05 00 00       	call   80104410 <pushcli>
  c = mycpu();
80103f04:	e8 d7 f9 ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80103f09:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f0f:	e8 fc 05 00 00       	call   80104510 <popcli>
  if(p == 0)
80103f14:	85 db                	test   %ebx,%ebx
80103f16:	0f 84 87 00 00 00    	je     80103fa3 <sleep+0xb3>
  if(lk == 0)
80103f1c:	85 f6                	test   %esi,%esi
80103f1e:	74 76                	je     80103f96 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103f20:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103f26:	74 50                	je     80103f78 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103f28:	83 ec 0c             	sub    $0xc,%esp
80103f2b:	68 20 2d 11 80       	push   $0x80112d20
80103f30:	e8 1b 05 00 00       	call   80104450 <acquire>
    release(lk);
80103f35:	89 34 24             	mov    %esi,(%esp)
80103f38:	e8 33 06 00 00       	call   80104570 <release>
  p->chan = chan;
80103f3d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f40:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f47:	e8 64 fd ff ff       	call   80103cb0 <sched>
  p->chan = 0;
80103f4c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103f53:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f5a:	e8 11 06 00 00       	call   80104570 <release>
    acquire(lk);
80103f5f:	89 75 08             	mov    %esi,0x8(%ebp)
80103f62:	83 c4 10             	add    $0x10,%esp
}
80103f65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f68:	5b                   	pop    %ebx
80103f69:	5e                   	pop    %esi
80103f6a:	5f                   	pop    %edi
80103f6b:	5d                   	pop    %ebp
    acquire(lk);
80103f6c:	e9 df 04 00 00       	jmp    80104450 <acquire>
80103f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103f78:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f7b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f82:	e8 29 fd ff ff       	call   80103cb0 <sched>
  p->chan = 0;
80103f87:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f91:	5b                   	pop    %ebx
80103f92:	5e                   	pop    %esi
80103f93:	5f                   	pop    %edi
80103f94:	5d                   	pop    %ebp
80103f95:	c3                   	ret    
    panic("sleep without lk");
80103f96:	83 ec 0c             	sub    $0xc,%esp
80103f99:	68 ef 76 10 80       	push   $0x801076ef
80103f9e:	e8 0d c4 ff ff       	call   801003b0 <panic>
    panic("sleep");
80103fa3:	83 ec 0c             	sub    $0xc,%esp
80103fa6:	68 e9 76 10 80       	push   $0x801076e9
80103fab:	e8 00 c4 ff ff       	call   801003b0 <panic>

80103fb0 <wait>:
{
80103fb0:	55                   	push   %ebp
80103fb1:	89 e5                	mov    %esp,%ebp
80103fb3:	57                   	push   %edi
80103fb4:	56                   	push   %esi
80103fb5:	53                   	push   %ebx
80103fb6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103fb9:	e8 52 04 00 00       	call   80104410 <pushcli>
  c = mycpu();
80103fbe:	e8 1d f9 ff ff       	call   801038e0 <mycpu>
  p = c->proc;
80103fc3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103fc9:	e8 42 05 00 00       	call   80104510 <popcli>
  acquire(&ptable.lock);
80103fce:	83 ec 0c             	sub    $0xc,%esp
80103fd1:	68 20 2d 11 80       	push   $0x80112d20
80103fd6:	e8 75 04 00 00       	call   80104450 <acquire>
80103fdb:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103fde:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fe0:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103fe5:	eb 14                	jmp    80103ffb <wait+0x4b>
80103fe7:	89 f6                	mov    %esi,%esi
80103fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80103ff0:	83 c3 7c             	add    $0x7c,%ebx
80103ff3:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103ff9:	73 1b                	jae    80104016 <wait+0x66>
      if(p->parent != curproc)
80103ffb:	39 73 14             	cmp    %esi,0x14(%ebx)
80103ffe:	75 f0                	jne    80103ff0 <wait+0x40>
      if(p->state == ZOMBIE){
80104000:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104004:	74 32                	je     80104038 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104006:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104009:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010400e:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80104014:	72 e5                	jb     80103ffb <wait+0x4b>
    if(!havekids || curproc->killed){
80104016:	85 c0                	test   %eax,%eax
80104018:	74 7e                	je     80104098 <wait+0xe8>
8010401a:	8b 46 24             	mov    0x24(%esi),%eax
8010401d:	85 c0                	test   %eax,%eax
8010401f:	75 77                	jne    80104098 <wait+0xe8>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104021:	83 ec 08             	sub    $0x8,%esp
80104024:	68 20 2d 11 80       	push   $0x80112d20
80104029:	56                   	push   %esi
8010402a:	e8 c1 fe ff ff       	call   80103ef0 <sleep>
    havekids = 0;
8010402f:	83 c4 10             	add    $0x10,%esp
80104032:	eb aa                	jmp    80103fde <wait+0x2e>
80104034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104038:	83 ec 0c             	sub    $0xc,%esp
8010403b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010403e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104041:	e8 6a e4 ff ff       	call   801024b0 <kfree>
        pgdir = p->pgdir;
80104046:	8b 7b 04             	mov    0x4(%ebx),%edi
        release(&ptable.lock);
80104049:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->kstack = 0;
80104050:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        p->pgdir = 0;
80104057:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
        p->pid = 0;
8010405e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104065:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010406c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104070:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104077:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010407e:	e8 ed 04 00 00       	call   80104570 <release>
        freevm(pgdir);
80104083:	89 3c 24             	mov    %edi,(%esp)
80104086:	e8 e5 2c 00 00       	call   80106d70 <freevm>
        return pid;
8010408b:	83 c4 10             	add    $0x10,%esp
}
8010408e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104091:	89 f0                	mov    %esi,%eax
80104093:	5b                   	pop    %ebx
80104094:	5e                   	pop    %esi
80104095:	5f                   	pop    %edi
80104096:	5d                   	pop    %ebp
80104097:	c3                   	ret    
      release(&ptable.lock);
80104098:	83 ec 0c             	sub    $0xc,%esp
      return -1;
8010409b:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801040a0:	68 20 2d 11 80       	push   $0x80112d20
801040a5:	e8 c6 04 00 00       	call   80104570 <release>
      return -1;
801040aa:	83 c4 10             	add    $0x10,%esp
801040ad:	eb df                	jmp    8010408e <wait+0xde>
801040af:	90                   	nop

801040b0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	53                   	push   %ebx
801040b4:	83 ec 10             	sub    $0x10,%esp
801040b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801040ba:	68 20 2d 11 80       	push   $0x80112d20
801040bf:	e8 8c 03 00 00       	call   80104450 <acquire>
801040c4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040c7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801040cc:	eb 0c                	jmp    801040da <wakeup+0x2a>
801040ce:	66 90                	xchg   %ax,%ax
801040d0:	83 c0 7c             	add    $0x7c,%eax
801040d3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801040d8:	73 1c                	jae    801040f6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801040da:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040de:	75 f0                	jne    801040d0 <wakeup+0x20>
801040e0:	3b 58 20             	cmp    0x20(%eax),%ebx
801040e3:	75 eb                	jne    801040d0 <wakeup+0x20>
      p->state = RUNNABLE;
801040e5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040ec:	83 c0 7c             	add    $0x7c,%eax
801040ef:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801040f4:	72 e4                	jb     801040da <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801040f6:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
801040fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104100:	c9                   	leave  
  release(&ptable.lock);
80104101:	e9 6a 04 00 00       	jmp    80104570 <release>
80104106:	8d 76 00             	lea    0x0(%esi),%esi
80104109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104110 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104110:	55                   	push   %ebp
80104111:	89 e5                	mov    %esp,%ebp
80104113:	53                   	push   %ebx
80104114:	83 ec 10             	sub    $0x10,%esp
80104117:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010411a:	68 20 2d 11 80       	push   $0x80112d20
8010411f:	e8 2c 03 00 00       	call   80104450 <acquire>
80104124:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104127:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010412c:	eb 0c                	jmp    8010413a <kill+0x2a>
8010412e:	66 90                	xchg   %ax,%ax
80104130:	83 c0 7c             	add    $0x7c,%eax
80104133:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104138:	73 36                	jae    80104170 <kill+0x60>
    if(p->pid == pid){
8010413a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010413d:	75 f1                	jne    80104130 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010413f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104143:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010414a:	75 07                	jne    80104153 <kill+0x43>
        p->state = RUNNABLE;
8010414c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104153:	83 ec 0c             	sub    $0xc,%esp
80104156:	68 20 2d 11 80       	push   $0x80112d20
8010415b:	e8 10 04 00 00       	call   80104570 <release>
      return 0;
80104160:	83 c4 10             	add    $0x10,%esp
80104163:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104165:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104168:	c9                   	leave  
80104169:	c3                   	ret    
8010416a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104170:	83 ec 0c             	sub    $0xc,%esp
80104173:	68 20 2d 11 80       	push   $0x80112d20
80104178:	e8 f3 03 00 00       	call   80104570 <release>
  return -1;
8010417d:	83 c4 10             	add    $0x10,%esp
80104180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104185:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104188:	c9                   	leave  
80104189:	c3                   	ret    
8010418a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104190 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	57                   	push   %edi
80104194:	56                   	push   %esi
80104195:	53                   	push   %ebx
80104196:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104199:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
8010419e:	83 ec 3c             	sub    $0x3c,%esp
801041a1:	eb 24                	jmp    801041c7 <procdump+0x37>
801041a3:	90                   	nop
801041a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801041a8:	83 ec 0c             	sub    $0xc,%esp
801041ab:	68 07 72 10 80       	push   $0x80107207
801041b0:	e8 cb c4 ff ff       	call   80100680 <cprintf>
801041b5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041b8:	83 c3 7c             	add    $0x7c,%ebx
801041bb:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801041c1:	0f 83 81 00 00 00    	jae    80104248 <procdump+0xb8>
    if(p->state == UNUSED)
801041c7:	8b 43 0c             	mov    0xc(%ebx),%eax
801041ca:	85 c0                	test   %eax,%eax
801041cc:	74 ea                	je     801041b8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801041ce:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801041d1:	ba 00 77 10 80       	mov    $0x80107700,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801041d6:	77 11                	ja     801041e9 <procdump+0x59>
801041d8:	8b 14 85 60 77 10 80 	mov    -0x7fef88a0(,%eax,4),%edx
      state = "???";
801041df:	b8 00 77 10 80       	mov    $0x80107700,%eax
801041e4:	85 d2                	test   %edx,%edx
801041e6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801041e9:	8d 43 6c             	lea    0x6c(%ebx),%eax
801041ec:	50                   	push   %eax
801041ed:	52                   	push   %edx
801041ee:	ff 73 10             	pushl  0x10(%ebx)
801041f1:	68 04 77 10 80       	push   $0x80107704
801041f6:	e8 85 c4 ff ff       	call   80100680 <cprintf>
    if(p->state == SLEEPING){
801041fb:	83 c4 10             	add    $0x10,%esp
801041fe:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104202:	75 a4                	jne    801041a8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104204:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104207:	83 ec 08             	sub    $0x8,%esp
8010420a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010420d:	50                   	push   %eax
8010420e:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104211:	8b 40 0c             	mov    0xc(%eax),%eax
80104214:	83 c0 08             	add    $0x8,%eax
80104217:	50                   	push   %eax
80104218:	e8 63 01 00 00       	call   80104380 <getcallerpcs>
8010421d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104220:	8b 17                	mov    (%edi),%edx
80104222:	85 d2                	test   %edx,%edx
80104224:	74 82                	je     801041a8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104226:	83 ec 08             	sub    $0x8,%esp
80104229:	83 c7 04             	add    $0x4,%edi
8010422c:	52                   	push   %edx
8010422d:	68 21 71 10 80       	push   $0x80107121
80104232:	e8 49 c4 ff ff       	call   80100680 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104237:	83 c4 10             	add    $0x10,%esp
8010423a:	39 fe                	cmp    %edi,%esi
8010423c:	75 e2                	jne    80104220 <procdump+0x90>
8010423e:	e9 65 ff ff ff       	jmp    801041a8 <procdump+0x18>
80104243:	90                   	nop
80104244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
80104248:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010424b:	5b                   	pop    %ebx
8010424c:	5e                   	pop    %esi
8010424d:	5f                   	pop    %edi
8010424e:	5d                   	pop    %ebp
8010424f:	c3                   	ret    

80104250 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	53                   	push   %ebx
80104254:	83 ec 0c             	sub    $0xc,%esp
80104257:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010425a:	68 78 77 10 80       	push   $0x80107778
8010425f:	8d 43 04             	lea    0x4(%ebx),%eax
80104262:	50                   	push   %eax
80104263:	e8 f8 00 00 00       	call   80104360 <initlock>
  lk->name = name;
80104268:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010426b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104271:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104274:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010427b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010427e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104281:	c9                   	leave  
80104282:	c3                   	ret    
80104283:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104290 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	56                   	push   %esi
80104294:	53                   	push   %ebx
80104295:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104298:	83 ec 0c             	sub    $0xc,%esp
8010429b:	8d 73 04             	lea    0x4(%ebx),%esi
8010429e:	56                   	push   %esi
8010429f:	e8 ac 01 00 00       	call   80104450 <acquire>
  while (lk->locked) {
801042a4:	8b 13                	mov    (%ebx),%edx
801042a6:	83 c4 10             	add    $0x10,%esp
801042a9:	85 d2                	test   %edx,%edx
801042ab:	74 16                	je     801042c3 <acquiresleep+0x33>
801042ad:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801042b0:	83 ec 08             	sub    $0x8,%esp
801042b3:	56                   	push   %esi
801042b4:	53                   	push   %ebx
801042b5:	e8 36 fc ff ff       	call   80103ef0 <sleep>
  while (lk->locked) {
801042ba:	8b 03                	mov    (%ebx),%eax
801042bc:	83 c4 10             	add    $0x10,%esp
801042bf:	85 c0                	test   %eax,%eax
801042c1:	75 ed                	jne    801042b0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801042c3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801042c9:	e8 b2 f6 ff ff       	call   80103980 <myproc>
801042ce:	8b 40 10             	mov    0x10(%eax),%eax
801042d1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801042d4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801042d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042da:	5b                   	pop    %ebx
801042db:	5e                   	pop    %esi
801042dc:	5d                   	pop    %ebp
  release(&lk->lk);
801042dd:	e9 8e 02 00 00       	jmp    80104570 <release>
801042e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042f0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	56                   	push   %esi
801042f4:	53                   	push   %ebx
801042f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801042f8:	83 ec 0c             	sub    $0xc,%esp
801042fb:	8d 73 04             	lea    0x4(%ebx),%esi
801042fe:	56                   	push   %esi
801042ff:	e8 4c 01 00 00       	call   80104450 <acquire>
  lk->locked = 0;
80104304:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010430a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104311:	89 1c 24             	mov    %ebx,(%esp)
80104314:	e8 97 fd ff ff       	call   801040b0 <wakeup>
  release(&lk->lk);
80104319:	89 75 08             	mov    %esi,0x8(%ebp)
8010431c:	83 c4 10             	add    $0x10,%esp
}
8010431f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104322:	5b                   	pop    %ebx
80104323:	5e                   	pop    %esi
80104324:	5d                   	pop    %ebp
  release(&lk->lk);
80104325:	e9 46 02 00 00       	jmp    80104570 <release>
8010432a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104330 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	56                   	push   %esi
80104334:	53                   	push   %ebx
80104335:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104338:	83 ec 0c             	sub    $0xc,%esp
8010433b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010433e:	53                   	push   %ebx
8010433f:	e8 0c 01 00 00       	call   80104450 <acquire>
  r = lk->locked;
80104344:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104346:	89 1c 24             	mov    %ebx,(%esp)
80104349:	e8 22 02 00 00       	call   80104570 <release>
  return r;
}
8010434e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104351:	89 f0                	mov    %esi,%eax
80104353:	5b                   	pop    %ebx
80104354:	5e                   	pop    %esi
80104355:	5d                   	pop    %ebp
80104356:	c3                   	ret    
80104357:	66 90                	xchg   %ax,%ax
80104359:	66 90                	xchg   %ax,%ax
8010435b:	66 90                	xchg   %ax,%ax
8010435d:	66 90                	xchg   %ax,%ax
8010435f:	90                   	nop

80104360 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104366:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104369:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010436f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104372:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104379:	5d                   	pop    %ebp
8010437a:	c3                   	ret    
8010437b:	90                   	nop
8010437c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104380 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104380:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104381:	31 d2                	xor    %edx,%edx
{
80104383:	89 e5                	mov    %esp,%ebp
80104385:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104386:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104389:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010438c:	83 e8 08             	sub    $0x8,%eax
8010438f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104390:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104396:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010439c:	77 1a                	ja     801043b8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010439e:	8b 58 04             	mov    0x4(%eax),%ebx
801043a1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801043a4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801043a7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801043a9:	83 fa 0a             	cmp    $0xa,%edx
801043ac:	75 e2                	jne    80104390 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801043ae:	5b                   	pop    %ebx
801043af:	5d                   	pop    %ebp
801043b0:	c3                   	ret    
801043b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043b8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801043bb:	83 c1 28             	add    $0x28,%ecx
801043be:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801043c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801043c6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801043c9:	39 c1                	cmp    %eax,%ecx
801043cb:	75 f3                	jne    801043c0 <getcallerpcs+0x40>
}
801043cd:	5b                   	pop    %ebx
801043ce:	5d                   	pop    %ebp
801043cf:	c3                   	ret    

801043d0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	53                   	push   %ebx
801043d4:	83 ec 04             	sub    $0x4,%esp
801043d7:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801043da:	8b 02                	mov    (%edx),%eax
801043dc:	85 c0                	test   %eax,%eax
801043de:	75 10                	jne    801043f0 <holding+0x20>
}
801043e0:	83 c4 04             	add    $0x4,%esp
801043e3:	31 c0                	xor    %eax,%eax
801043e5:	5b                   	pop    %ebx
801043e6:	5d                   	pop    %ebp
801043e7:	c3                   	ret    
801043e8:	90                   	nop
801043e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
801043f0:	8b 5a 08             	mov    0x8(%edx),%ebx
801043f3:	e8 e8 f4 ff ff       	call   801038e0 <mycpu>
801043f8:	39 c3                	cmp    %eax,%ebx
801043fa:	0f 94 c0             	sete   %al
}
801043fd:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104400:	0f b6 c0             	movzbl %al,%eax
}
80104403:	5b                   	pop    %ebx
80104404:	5d                   	pop    %ebp
80104405:	c3                   	ret    
80104406:	8d 76 00             	lea    0x0(%esi),%esi
80104409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104410 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	53                   	push   %ebx
80104414:	83 ec 04             	sub    $0x4,%esp
80104417:	9c                   	pushf  
80104418:	5b                   	pop    %ebx
  asm volatile("cli");
80104419:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010441a:	e8 c1 f4 ff ff       	call   801038e0 <mycpu>
8010441f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104425:	85 c0                	test   %eax,%eax
80104427:	75 11                	jne    8010443a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104429:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010442f:	e8 ac f4 ff ff       	call   801038e0 <mycpu>
80104434:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010443a:	e8 a1 f4 ff ff       	call   801038e0 <mycpu>
8010443f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104446:	83 c4 04             	add    $0x4,%esp
80104449:	5b                   	pop    %ebx
8010444a:	5d                   	pop    %ebp
8010444b:	c3                   	ret    
8010444c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104450 <acquire>:
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	56                   	push   %esi
80104454:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104455:	e8 b6 ff ff ff       	call   80104410 <pushcli>
  if(holding(lk))
8010445a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
8010445d:	8b 03                	mov    (%ebx),%eax
8010445f:	85 c0                	test   %eax,%eax
80104461:	0f 85 81 00 00 00    	jne    801044e8 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
80104467:	ba 01 00 00 00       	mov    $0x1,%edx
8010446c:	eb 05                	jmp    80104473 <acquire+0x23>
8010446e:	66 90                	xchg   %ax,%ax
80104470:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104473:	89 d0                	mov    %edx,%eax
80104475:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104478:	85 c0                	test   %eax,%eax
8010447a:	75 f4                	jne    80104470 <acquire+0x20>
  __sync_synchronize();
8010447c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104481:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104484:	e8 57 f4 ff ff       	call   801038e0 <mycpu>
  for(i = 0; i < 10; i++){
80104489:	31 d2                	xor    %edx,%edx
  getcallerpcs(&lk, lk->pcs);
8010448b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  lk->cpu = mycpu();
8010448e:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104491:	89 e8                	mov    %ebp,%eax
80104493:	90                   	nop
80104494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104498:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010449e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801044a4:	77 1a                	ja     801044c0 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
801044a6:	8b 58 04             	mov    0x4(%eax),%ebx
801044a9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801044ac:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801044af:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801044b1:	83 fa 0a             	cmp    $0xa,%edx
801044b4:	75 e2                	jne    80104498 <acquire+0x48>
}
801044b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044b9:	5b                   	pop    %ebx
801044ba:	5e                   	pop    %esi
801044bb:	5d                   	pop    %ebp
801044bc:	c3                   	ret    
801044bd:	8d 76 00             	lea    0x0(%esi),%esi
801044c0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801044c3:	83 c1 28             	add    $0x28,%ecx
801044c6:	8d 76 00             	lea    0x0(%esi),%esi
801044c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801044d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801044d6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801044d9:	39 c8                	cmp    %ecx,%eax
801044db:	75 f3                	jne    801044d0 <acquire+0x80>
}
801044dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044e0:	5b                   	pop    %ebx
801044e1:	5e                   	pop    %esi
801044e2:	5d                   	pop    %ebp
801044e3:	c3                   	ret    
801044e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
801044e8:	8b 73 08             	mov    0x8(%ebx),%esi
801044eb:	e8 f0 f3 ff ff       	call   801038e0 <mycpu>
801044f0:	39 c6                	cmp    %eax,%esi
801044f2:	0f 85 6f ff ff ff    	jne    80104467 <acquire+0x17>
    panic("acquire");
801044f8:	83 ec 0c             	sub    $0xc,%esp
801044fb:	68 83 77 10 80       	push   $0x80107783
80104500:	e8 ab be ff ff       	call   801003b0 <panic>
80104505:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104510 <popcli>:

void
popcli(void)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104516:	9c                   	pushf  
80104517:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104518:	f6 c4 02             	test   $0x2,%ah
8010451b:	75 35                	jne    80104552 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010451d:	e8 be f3 ff ff       	call   801038e0 <mycpu>
80104522:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104529:	78 34                	js     8010455f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010452b:	e8 b0 f3 ff ff       	call   801038e0 <mycpu>
80104530:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104536:	85 d2                	test   %edx,%edx
80104538:	74 06                	je     80104540 <popcli+0x30>
    sti();
}
8010453a:	c9                   	leave  
8010453b:	c3                   	ret    
8010453c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104540:	e8 9b f3 ff ff       	call   801038e0 <mycpu>
80104545:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010454b:	85 c0                	test   %eax,%eax
8010454d:	74 eb                	je     8010453a <popcli+0x2a>
  asm volatile("sti");
8010454f:	fb                   	sti    
}
80104550:	c9                   	leave  
80104551:	c3                   	ret    
    panic("popcli - interruptible");
80104552:	83 ec 0c             	sub    $0xc,%esp
80104555:	68 8b 77 10 80       	push   $0x8010778b
8010455a:	e8 51 be ff ff       	call   801003b0 <panic>
    panic("popcli");
8010455f:	83 ec 0c             	sub    $0xc,%esp
80104562:	68 a2 77 10 80       	push   $0x801077a2
80104567:	e8 44 be ff ff       	call   801003b0 <panic>
8010456c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104570 <release>:
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	56                   	push   %esi
80104574:	53                   	push   %ebx
80104575:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104578:	8b 03                	mov    (%ebx),%eax
8010457a:	85 c0                	test   %eax,%eax
8010457c:	74 0c                	je     8010458a <release+0x1a>
8010457e:	8b 73 08             	mov    0x8(%ebx),%esi
80104581:	e8 5a f3 ff ff       	call   801038e0 <mycpu>
80104586:	39 c6                	cmp    %eax,%esi
80104588:	74 16                	je     801045a0 <release+0x30>
    panic("release");
8010458a:	83 ec 0c             	sub    $0xc,%esp
8010458d:	68 a9 77 10 80       	push   $0x801077a9
80104592:	e8 19 be ff ff       	call   801003b0 <panic>
80104597:	89 f6                	mov    %esi,%esi
80104599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lk->pcs[0] = 0;
801045a0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801045a7:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801045ae:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801045b3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801045b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045bc:	5b                   	pop    %ebx
801045bd:	5e                   	pop    %esi
801045be:	5d                   	pop    %ebp
  popcli();
801045bf:	e9 4c ff ff ff       	jmp    80104510 <popcli>
801045c4:	66 90                	xchg   %ax,%ax
801045c6:	66 90                	xchg   %ax,%ax
801045c8:	66 90                	xchg   %ax,%ax
801045ca:	66 90                	xchg   %ax,%ax
801045cc:	66 90                	xchg   %ax,%ax
801045ce:	66 90                	xchg   %ax,%ax

801045d0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	57                   	push   %edi
801045d4:	53                   	push   %ebx
801045d5:	8b 55 08             	mov    0x8(%ebp),%edx
801045d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801045db:	f6 c2 03             	test   $0x3,%dl
801045de:	75 05                	jne    801045e5 <memset+0x15>
801045e0:	f6 c1 03             	test   $0x3,%cl
801045e3:	74 13                	je     801045f8 <memset+0x28>
  asm volatile("cld; rep stosb" :
801045e5:	89 d7                	mov    %edx,%edi
801045e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801045ea:	fc                   	cld    
801045eb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801045ed:	5b                   	pop    %ebx
801045ee:	89 d0                	mov    %edx,%eax
801045f0:	5f                   	pop    %edi
801045f1:	5d                   	pop    %ebp
801045f2:	c3                   	ret    
801045f3:	90                   	nop
801045f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
801045f8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801045fc:	c1 e9 02             	shr    $0x2,%ecx
801045ff:	89 f8                	mov    %edi,%eax
80104601:	89 fb                	mov    %edi,%ebx
80104603:	c1 e0 18             	shl    $0x18,%eax
80104606:	c1 e3 10             	shl    $0x10,%ebx
80104609:	09 d8                	or     %ebx,%eax
8010460b:	09 f8                	or     %edi,%eax
8010460d:	c1 e7 08             	shl    $0x8,%edi
80104610:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104612:	89 d7                	mov    %edx,%edi
80104614:	fc                   	cld    
80104615:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104617:	5b                   	pop    %ebx
80104618:	89 d0                	mov    %edx,%eax
8010461a:	5f                   	pop    %edi
8010461b:	5d                   	pop    %ebp
8010461c:	c3                   	ret    
8010461d:	8d 76 00             	lea    0x0(%esi),%esi

80104620 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	57                   	push   %edi
80104624:	56                   	push   %esi
80104625:	53                   	push   %ebx
80104626:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104629:	8b 75 08             	mov    0x8(%ebp),%esi
8010462c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010462f:	85 db                	test   %ebx,%ebx
80104631:	74 29                	je     8010465c <memcmp+0x3c>
    if(*s1 != *s2)
80104633:	0f b6 16             	movzbl (%esi),%edx
80104636:	0f b6 0f             	movzbl (%edi),%ecx
80104639:	38 d1                	cmp    %dl,%cl
8010463b:	75 2b                	jne    80104668 <memcmp+0x48>
8010463d:	b8 01 00 00 00       	mov    $0x1,%eax
80104642:	eb 14                	jmp    80104658 <memcmp+0x38>
80104644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104648:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010464c:	83 c0 01             	add    $0x1,%eax
8010464f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104654:	38 ca                	cmp    %cl,%dl
80104656:	75 10                	jne    80104668 <memcmp+0x48>
  while(n-- > 0){
80104658:	39 d8                	cmp    %ebx,%eax
8010465a:	75 ec                	jne    80104648 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010465c:	5b                   	pop    %ebx
  return 0;
8010465d:	31 c0                	xor    %eax,%eax
}
8010465f:	5e                   	pop    %esi
80104660:	5f                   	pop    %edi
80104661:	5d                   	pop    %ebp
80104662:	c3                   	ret    
80104663:	90                   	nop
80104664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104668:	0f b6 c2             	movzbl %dl,%eax
}
8010466b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010466c:	29 c8                	sub    %ecx,%eax
}
8010466e:	5e                   	pop    %esi
8010466f:	5f                   	pop    %edi
80104670:	5d                   	pop    %ebp
80104671:	c3                   	ret    
80104672:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104680 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	56                   	push   %esi
80104684:	53                   	push   %ebx
80104685:	8b 45 08             	mov    0x8(%ebp),%eax
80104688:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010468b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010468e:	39 c3                	cmp    %eax,%ebx
80104690:	73 26                	jae    801046b8 <memmove+0x38>
80104692:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104695:	39 c8                	cmp    %ecx,%eax
80104697:	73 1f                	jae    801046b8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104699:	85 f6                	test   %esi,%esi
8010469b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010469e:	74 0f                	je     801046af <memmove+0x2f>
      *--d = *--s;
801046a0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801046a4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801046a7:	83 ea 01             	sub    $0x1,%edx
801046aa:	83 fa ff             	cmp    $0xffffffff,%edx
801046ad:	75 f1                	jne    801046a0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801046af:	5b                   	pop    %ebx
801046b0:	5e                   	pop    %esi
801046b1:	5d                   	pop    %ebp
801046b2:	c3                   	ret    
801046b3:	90                   	nop
801046b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801046b8:	31 d2                	xor    %edx,%edx
801046ba:	85 f6                	test   %esi,%esi
801046bc:	74 f1                	je     801046af <memmove+0x2f>
801046be:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801046c0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801046c4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801046c7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
801046ca:	39 d6                	cmp    %edx,%esi
801046cc:	75 f2                	jne    801046c0 <memmove+0x40>
}
801046ce:	5b                   	pop    %ebx
801046cf:	5e                   	pop    %esi
801046d0:	5d                   	pop    %ebp
801046d1:	c3                   	ret    
801046d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046e0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801046e3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
801046e4:	eb 9a                	jmp    80104680 <memmove>
801046e6:	8d 76 00             	lea    0x0(%esi),%esi
801046e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046f0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	57                   	push   %edi
801046f4:	56                   	push   %esi
801046f5:	8b 7d 10             	mov    0x10(%ebp),%edi
801046f8:	53                   	push   %ebx
801046f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801046fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
801046ff:	85 ff                	test   %edi,%edi
80104701:	74 2f                	je     80104732 <strncmp+0x42>
80104703:	0f b6 01             	movzbl (%ecx),%eax
80104706:	0f b6 1e             	movzbl (%esi),%ebx
80104709:	84 c0                	test   %al,%al
8010470b:	74 37                	je     80104744 <strncmp+0x54>
8010470d:	38 c3                	cmp    %al,%bl
8010470f:	75 33                	jne    80104744 <strncmp+0x54>
80104711:	01 f7                	add    %esi,%edi
80104713:	eb 13                	jmp    80104728 <strncmp+0x38>
80104715:	8d 76 00             	lea    0x0(%esi),%esi
80104718:	0f b6 01             	movzbl (%ecx),%eax
8010471b:	84 c0                	test   %al,%al
8010471d:	74 21                	je     80104740 <strncmp+0x50>
8010471f:	0f b6 1a             	movzbl (%edx),%ebx
80104722:	89 d6                	mov    %edx,%esi
80104724:	38 d8                	cmp    %bl,%al
80104726:	75 1c                	jne    80104744 <strncmp+0x54>
    n--, p++, q++;
80104728:	8d 56 01             	lea    0x1(%esi),%edx
8010472b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010472e:	39 fa                	cmp    %edi,%edx
80104730:	75 e6                	jne    80104718 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104732:	5b                   	pop    %ebx
    return 0;
80104733:	31 c0                	xor    %eax,%eax
}
80104735:	5e                   	pop    %esi
80104736:	5f                   	pop    %edi
80104737:	5d                   	pop    %ebp
80104738:	c3                   	ret    
80104739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104740:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104744:	29 d8                	sub    %ebx,%eax
}
80104746:	5b                   	pop    %ebx
80104747:	5e                   	pop    %esi
80104748:	5f                   	pop    %edi
80104749:	5d                   	pop    %ebp
8010474a:	c3                   	ret    
8010474b:	90                   	nop
8010474c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104750 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	56                   	push   %esi
80104754:	53                   	push   %ebx
80104755:	8b 45 08             	mov    0x8(%ebp),%eax
80104758:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010475b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010475e:	89 c2                	mov    %eax,%edx
80104760:	eb 19                	jmp    8010477b <strncpy+0x2b>
80104762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104768:	83 c3 01             	add    $0x1,%ebx
8010476b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010476f:	83 c2 01             	add    $0x1,%edx
80104772:	84 c9                	test   %cl,%cl
80104774:	88 4a ff             	mov    %cl,-0x1(%edx)
80104777:	74 09                	je     80104782 <strncpy+0x32>
80104779:	89 f1                	mov    %esi,%ecx
8010477b:	85 c9                	test   %ecx,%ecx
8010477d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104780:	7f e6                	jg     80104768 <strncpy+0x18>
    ;
  while(n-- > 0)
80104782:	31 c9                	xor    %ecx,%ecx
80104784:	85 f6                	test   %esi,%esi
80104786:	7e 17                	jle    8010479f <strncpy+0x4f>
80104788:	90                   	nop
80104789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104790:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104794:	89 f3                	mov    %esi,%ebx
80104796:	83 c1 01             	add    $0x1,%ecx
80104799:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010479b:	85 db                	test   %ebx,%ebx
8010479d:	7f f1                	jg     80104790 <strncpy+0x40>
  return os;
}
8010479f:	5b                   	pop    %ebx
801047a0:	5e                   	pop    %esi
801047a1:	5d                   	pop    %ebp
801047a2:	c3                   	ret    
801047a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047b0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	56                   	push   %esi
801047b4:	53                   	push   %ebx
801047b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801047b8:	8b 45 08             	mov    0x8(%ebp),%eax
801047bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801047be:	85 c9                	test   %ecx,%ecx
801047c0:	7e 26                	jle    801047e8 <safestrcpy+0x38>
801047c2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801047c6:	89 c1                	mov    %eax,%ecx
801047c8:	eb 17                	jmp    801047e1 <safestrcpy+0x31>
801047ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801047d0:	83 c2 01             	add    $0x1,%edx
801047d3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801047d7:	83 c1 01             	add    $0x1,%ecx
801047da:	84 db                	test   %bl,%bl
801047dc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801047df:	74 04                	je     801047e5 <safestrcpy+0x35>
801047e1:	39 f2                	cmp    %esi,%edx
801047e3:	75 eb                	jne    801047d0 <safestrcpy+0x20>
    ;
  *s = 0;
801047e5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801047e8:	5b                   	pop    %ebx
801047e9:	5e                   	pop    %esi
801047ea:	5d                   	pop    %ebp
801047eb:	c3                   	ret    
801047ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047f0 <strlen>:

int
strlen(const char *s)
{
801047f0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801047f1:	31 c0                	xor    %eax,%eax
{
801047f3:	89 e5                	mov    %esp,%ebp
801047f5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801047f8:	80 3a 00             	cmpb   $0x0,(%edx)
801047fb:	74 0c                	je     80104809 <strlen+0x19>
801047fd:	8d 76 00             	lea    0x0(%esi),%esi
80104800:	83 c0 01             	add    $0x1,%eax
80104803:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104807:	75 f7                	jne    80104800 <strlen+0x10>
    ;
  return n;
}
80104809:	5d                   	pop    %ebp
8010480a:	c3                   	ret    

8010480b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010480b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010480f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104813:	55                   	push   %ebp
  pushl %ebx
80104814:	53                   	push   %ebx
  pushl %esi
80104815:	56                   	push   %esi
  pushl %edi
80104816:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104817:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104819:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010481b:	5f                   	pop    %edi
  popl %esi
8010481c:	5e                   	pop    %esi
  popl %ebx
8010481d:	5b                   	pop    %ebx
  popl %ebp
8010481e:	5d                   	pop    %ebp
  ret
8010481f:	c3                   	ret    

80104820 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	53                   	push   %ebx
80104824:	83 ec 04             	sub    $0x4,%esp
80104827:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010482a:	e8 51 f1 ff ff       	call   80103980 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010482f:	8b 00                	mov    (%eax),%eax
80104831:	39 d8                	cmp    %ebx,%eax
80104833:	76 1b                	jbe    80104850 <fetchint+0x30>
80104835:	8d 53 04             	lea    0x4(%ebx),%edx
80104838:	39 d0                	cmp    %edx,%eax
8010483a:	72 14                	jb     80104850 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010483c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010483f:	8b 13                	mov    (%ebx),%edx
80104841:	89 10                	mov    %edx,(%eax)
  return 0;
80104843:	31 c0                	xor    %eax,%eax
}
80104845:	83 c4 04             	add    $0x4,%esp
80104848:	5b                   	pop    %ebx
80104849:	5d                   	pop    %ebp
8010484a:	c3                   	ret    
8010484b:	90                   	nop
8010484c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104850:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104855:	eb ee                	jmp    80104845 <fetchint+0x25>
80104857:	89 f6                	mov    %esi,%esi
80104859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104860 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	53                   	push   %ebx
80104864:	83 ec 04             	sub    $0x4,%esp
80104867:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010486a:	e8 11 f1 ff ff       	call   80103980 <myproc>

  if(addr >= curproc->sz)
8010486f:	39 18                	cmp    %ebx,(%eax)
80104871:	76 29                	jbe    8010489c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104873:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104876:	89 da                	mov    %ebx,%edx
80104878:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010487a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010487c:	39 c3                	cmp    %eax,%ebx
8010487e:	73 1c                	jae    8010489c <fetchstr+0x3c>
    if(*s == 0)
80104880:	80 3b 00             	cmpb   $0x0,(%ebx)
80104883:	75 10                	jne    80104895 <fetchstr+0x35>
80104885:	eb 39                	jmp    801048c0 <fetchstr+0x60>
80104887:	89 f6                	mov    %esi,%esi
80104889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104890:	80 3a 00             	cmpb   $0x0,(%edx)
80104893:	74 1b                	je     801048b0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104895:	83 c2 01             	add    $0x1,%edx
80104898:	39 d0                	cmp    %edx,%eax
8010489a:	77 f4                	ja     80104890 <fetchstr+0x30>
    return -1;
8010489c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
801048a1:	83 c4 04             	add    $0x4,%esp
801048a4:	5b                   	pop    %ebx
801048a5:	5d                   	pop    %ebp
801048a6:	c3                   	ret    
801048a7:	89 f6                	mov    %esi,%esi
801048a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801048b0:	83 c4 04             	add    $0x4,%esp
801048b3:	89 d0                	mov    %edx,%eax
801048b5:	29 d8                	sub    %ebx,%eax
801048b7:	5b                   	pop    %ebx
801048b8:	5d                   	pop    %ebp
801048b9:	c3                   	ret    
801048ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
801048c0:	31 c0                	xor    %eax,%eax
      return s - *pp;
801048c2:	eb dd                	jmp    801048a1 <fetchstr+0x41>
801048c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801048d0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	56                   	push   %esi
801048d4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801048d5:	e8 a6 f0 ff ff       	call   80103980 <myproc>
801048da:	8b 40 18             	mov    0x18(%eax),%eax
801048dd:	8b 55 08             	mov    0x8(%ebp),%edx
801048e0:	8b 40 44             	mov    0x44(%eax),%eax
801048e3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801048e6:	e8 95 f0 ff ff       	call   80103980 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048eb:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801048ed:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048f0:	39 c6                	cmp    %eax,%esi
801048f2:	73 1c                	jae    80104910 <argint+0x40>
801048f4:	8d 53 08             	lea    0x8(%ebx),%edx
801048f7:	39 d0                	cmp    %edx,%eax
801048f9:	72 15                	jb     80104910 <argint+0x40>
  *ip = *(int*)(addr);
801048fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801048fe:	8b 53 04             	mov    0x4(%ebx),%edx
80104901:	89 10                	mov    %edx,(%eax)
  return 0;
80104903:	31 c0                	xor    %eax,%eax
}
80104905:	5b                   	pop    %ebx
80104906:	5e                   	pop    %esi
80104907:	5d                   	pop    %ebp
80104908:	c3                   	ret    
80104909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104910:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104915:	eb ee                	jmp    80104905 <argint+0x35>
80104917:	89 f6                	mov    %esi,%esi
80104919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104920 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	56                   	push   %esi
80104924:	53                   	push   %ebx
80104925:	83 ec 10             	sub    $0x10,%esp
80104928:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010492b:	e8 50 f0 ff ff       	call   80103980 <myproc>
80104930:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104932:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104935:	83 ec 08             	sub    $0x8,%esp
80104938:	50                   	push   %eax
80104939:	ff 75 08             	pushl  0x8(%ebp)
8010493c:	e8 8f ff ff ff       	call   801048d0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104941:	83 c4 10             	add    $0x10,%esp
80104944:	85 c0                	test   %eax,%eax
80104946:	78 28                	js     80104970 <argptr+0x50>
80104948:	85 db                	test   %ebx,%ebx
8010494a:	78 24                	js     80104970 <argptr+0x50>
8010494c:	8b 16                	mov    (%esi),%edx
8010494e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104951:	39 c2                	cmp    %eax,%edx
80104953:	76 1b                	jbe    80104970 <argptr+0x50>
80104955:	01 c3                	add    %eax,%ebx
80104957:	39 da                	cmp    %ebx,%edx
80104959:	72 15                	jb     80104970 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010495b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010495e:	89 02                	mov    %eax,(%edx)
  return 0;
80104960:	31 c0                	xor    %eax,%eax
}
80104962:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104965:	5b                   	pop    %ebx
80104966:	5e                   	pop    %esi
80104967:	5d                   	pop    %ebp
80104968:	c3                   	ret    
80104969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104970:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104975:	eb eb                	jmp    80104962 <argptr+0x42>
80104977:	89 f6                	mov    %esi,%esi
80104979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104980 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104986:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104989:	50                   	push   %eax
8010498a:	ff 75 08             	pushl  0x8(%ebp)
8010498d:	e8 3e ff ff ff       	call   801048d0 <argint>
80104992:	83 c4 10             	add    $0x10,%esp
80104995:	85 c0                	test   %eax,%eax
80104997:	78 17                	js     801049b0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104999:	83 ec 08             	sub    $0x8,%esp
8010499c:	ff 75 0c             	pushl  0xc(%ebp)
8010499f:	ff 75 f4             	pushl  -0xc(%ebp)
801049a2:	e8 b9 fe ff ff       	call   80104860 <fetchstr>
801049a7:	83 c4 10             	add    $0x10,%esp
}
801049aa:	c9                   	leave  
801049ab:	c3                   	ret    
801049ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049b5:	c9                   	leave  
801049b6:	c3                   	ret    
801049b7:	89 f6                	mov    %esi,%esi
801049b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049c0 <syscall>:
[SYS_swap]    sys_swap,
};

void
syscall(void)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	53                   	push   %ebx
801049c4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801049c7:	e8 b4 ef ff ff       	call   80103980 <myproc>
801049cc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801049ce:	8b 40 18             	mov    0x18(%eax),%eax
801049d1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801049d4:	8d 50 ff             	lea    -0x1(%eax),%edx
801049d7:	83 fa 16             	cmp    $0x16,%edx
801049da:	77 1c                	ja     801049f8 <syscall+0x38>
801049dc:	8b 14 85 e0 77 10 80 	mov    -0x7fef8820(,%eax,4),%edx
801049e3:	85 d2                	test   %edx,%edx
801049e5:	74 11                	je     801049f8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801049e7:	ff d2                	call   *%edx
801049e9:	8b 53 18             	mov    0x18(%ebx),%edx
801049ec:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801049ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049f2:	c9                   	leave  
801049f3:	c3                   	ret    
801049f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
801049f8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801049f9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801049fc:	50                   	push   %eax
801049fd:	ff 73 10             	pushl  0x10(%ebx)
80104a00:	68 b1 77 10 80       	push   $0x801077b1
80104a05:	e8 76 bc ff ff       	call   80100680 <cprintf>
    curproc->tf->eax = -1;
80104a0a:	8b 43 18             	mov    0x18(%ebx),%eax
80104a0d:	83 c4 10             	add    $0x10,%esp
80104a10:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104a17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a1a:	c9                   	leave  
80104a1b:	c3                   	ret    
80104a1c:	66 90                	xchg   %ax,%ax
80104a1e:	66 90                	xchg   %ax,%ax

80104a20 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	57                   	push   %edi
80104a24:	56                   	push   %esi
80104a25:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104a26:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104a29:	83 ec 44             	sub    $0x44,%esp
80104a2c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104a2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104a32:	56                   	push   %esi
80104a33:	50                   	push   %eax
{
80104a34:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104a37:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104a3a:	e8 71 d6 ff ff       	call   801020b0 <nameiparent>
80104a3f:	83 c4 10             	add    $0x10,%esp
80104a42:	85 c0                	test   %eax,%eax
80104a44:	0f 84 46 01 00 00    	je     80104b90 <create+0x170>
    return 0;
  ilock(dp);
80104a4a:	83 ec 0c             	sub    $0xc,%esp
80104a4d:	89 c3                	mov    %eax,%ebx
80104a4f:	50                   	push   %eax
80104a50:	e8 db cd ff ff       	call   80101830 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104a55:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104a58:	83 c4 0c             	add    $0xc,%esp
80104a5b:	50                   	push   %eax
80104a5c:	56                   	push   %esi
80104a5d:	53                   	push   %ebx
80104a5e:	e8 fd d2 ff ff       	call   80101d60 <dirlookup>
80104a63:	83 c4 10             	add    $0x10,%esp
80104a66:	85 c0                	test   %eax,%eax
80104a68:	89 c7                	mov    %eax,%edi
80104a6a:	74 34                	je     80104aa0 <create+0x80>
    iunlockput(dp);
80104a6c:	83 ec 0c             	sub    $0xc,%esp
80104a6f:	53                   	push   %ebx
80104a70:	e8 4b d0 ff ff       	call   80101ac0 <iunlockput>
    ilock(ip);
80104a75:	89 3c 24             	mov    %edi,(%esp)
80104a78:	e8 b3 cd ff ff       	call   80101830 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104a7d:	83 c4 10             	add    $0x10,%esp
80104a80:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104a85:	0f 85 95 00 00 00    	jne    80104b20 <create+0x100>
80104a8b:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104a90:	0f 85 8a 00 00 00    	jne    80104b20 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104a96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a99:	89 f8                	mov    %edi,%eax
80104a9b:	5b                   	pop    %ebx
80104a9c:	5e                   	pop    %esi
80104a9d:	5f                   	pop    %edi
80104a9e:	5d                   	pop    %ebp
80104a9f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104aa0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104aa4:	83 ec 08             	sub    $0x8,%esp
80104aa7:	50                   	push   %eax
80104aa8:	ff 33                	pushl  (%ebx)
80104aaa:	e8 11 cc ff ff       	call   801016c0 <ialloc>
80104aaf:	83 c4 10             	add    $0x10,%esp
80104ab2:	85 c0                	test   %eax,%eax
80104ab4:	89 c7                	mov    %eax,%edi
80104ab6:	0f 84 e8 00 00 00    	je     80104ba4 <create+0x184>
  ilock(ip);
80104abc:	83 ec 0c             	sub    $0xc,%esp
80104abf:	50                   	push   %eax
80104ac0:	e8 6b cd ff ff       	call   80101830 <ilock>
  ip->major = major;
80104ac5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104ac9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104acd:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104ad1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104ad5:	b8 01 00 00 00       	mov    $0x1,%eax
80104ada:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104ade:	89 3c 24             	mov    %edi,(%esp)
80104ae1:	e8 9a cc ff ff       	call   80101780 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104ae6:	83 c4 10             	add    $0x10,%esp
80104ae9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104aee:	74 50                	je     80104b40 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104af0:	83 ec 04             	sub    $0x4,%esp
80104af3:	ff 77 04             	pushl  0x4(%edi)
80104af6:	56                   	push   %esi
80104af7:	53                   	push   %ebx
80104af8:	e8 d3 d4 ff ff       	call   80101fd0 <dirlink>
80104afd:	83 c4 10             	add    $0x10,%esp
80104b00:	85 c0                	test   %eax,%eax
80104b02:	0f 88 8f 00 00 00    	js     80104b97 <create+0x177>
  iunlockput(dp);
80104b08:	83 ec 0c             	sub    $0xc,%esp
80104b0b:	53                   	push   %ebx
80104b0c:	e8 af cf ff ff       	call   80101ac0 <iunlockput>
  return ip;
80104b11:	83 c4 10             	add    $0x10,%esp
}
80104b14:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b17:	89 f8                	mov    %edi,%eax
80104b19:	5b                   	pop    %ebx
80104b1a:	5e                   	pop    %esi
80104b1b:	5f                   	pop    %edi
80104b1c:	5d                   	pop    %ebp
80104b1d:	c3                   	ret    
80104b1e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104b20:	83 ec 0c             	sub    $0xc,%esp
80104b23:	57                   	push   %edi
    return 0;
80104b24:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104b26:	e8 95 cf ff ff       	call   80101ac0 <iunlockput>
    return 0;
80104b2b:	83 c4 10             	add    $0x10,%esp
}
80104b2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b31:	89 f8                	mov    %edi,%eax
80104b33:	5b                   	pop    %ebx
80104b34:	5e                   	pop    %esi
80104b35:	5f                   	pop    %edi
80104b36:	5d                   	pop    %ebp
80104b37:	c3                   	ret    
80104b38:	90                   	nop
80104b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104b40:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104b45:	83 ec 0c             	sub    $0xc,%esp
80104b48:	53                   	push   %ebx
80104b49:	e8 32 cc ff ff       	call   80101780 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104b4e:	83 c4 0c             	add    $0xc,%esp
80104b51:	ff 77 04             	pushl  0x4(%edi)
80104b54:	68 5c 78 10 80       	push   $0x8010785c
80104b59:	57                   	push   %edi
80104b5a:	e8 71 d4 ff ff       	call   80101fd0 <dirlink>
80104b5f:	83 c4 10             	add    $0x10,%esp
80104b62:	85 c0                	test   %eax,%eax
80104b64:	78 1c                	js     80104b82 <create+0x162>
80104b66:	83 ec 04             	sub    $0x4,%esp
80104b69:	ff 73 04             	pushl  0x4(%ebx)
80104b6c:	68 5b 78 10 80       	push   $0x8010785b
80104b71:	57                   	push   %edi
80104b72:	e8 59 d4 ff ff       	call   80101fd0 <dirlink>
80104b77:	83 c4 10             	add    $0x10,%esp
80104b7a:	85 c0                	test   %eax,%eax
80104b7c:	0f 89 6e ff ff ff    	jns    80104af0 <create+0xd0>
      panic("create dots");
80104b82:	83 ec 0c             	sub    $0xc,%esp
80104b85:	68 4f 78 10 80       	push   $0x8010784f
80104b8a:	e8 21 b8 ff ff       	call   801003b0 <panic>
80104b8f:	90                   	nop
    return 0;
80104b90:	31 ff                	xor    %edi,%edi
80104b92:	e9 ff fe ff ff       	jmp    80104a96 <create+0x76>
    panic("create: dirlink");
80104b97:	83 ec 0c             	sub    $0xc,%esp
80104b9a:	68 5e 78 10 80       	push   $0x8010785e
80104b9f:	e8 0c b8 ff ff       	call   801003b0 <panic>
    panic("create: ialloc");
80104ba4:	83 ec 0c             	sub    $0xc,%esp
80104ba7:	68 40 78 10 80       	push   $0x80107840
80104bac:	e8 ff b7 ff ff       	call   801003b0 <panic>
80104bb1:	eb 0d                	jmp    80104bc0 <argfd.constprop.0>
80104bb3:	90                   	nop
80104bb4:	90                   	nop
80104bb5:	90                   	nop
80104bb6:	90                   	nop
80104bb7:	90                   	nop
80104bb8:	90                   	nop
80104bb9:	90                   	nop
80104bba:	90                   	nop
80104bbb:	90                   	nop
80104bbc:	90                   	nop
80104bbd:	90                   	nop
80104bbe:	90                   	nop
80104bbf:	90                   	nop

80104bc0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	56                   	push   %esi
80104bc4:	53                   	push   %ebx
80104bc5:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104bc7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104bca:	89 d6                	mov    %edx,%esi
80104bcc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104bcf:	50                   	push   %eax
80104bd0:	6a 00                	push   $0x0
80104bd2:	e8 f9 fc ff ff       	call   801048d0 <argint>
80104bd7:	83 c4 10             	add    $0x10,%esp
80104bda:	85 c0                	test   %eax,%eax
80104bdc:	78 2a                	js     80104c08 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104bde:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104be2:	77 24                	ja     80104c08 <argfd.constprop.0+0x48>
80104be4:	e8 97 ed ff ff       	call   80103980 <myproc>
80104be9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104bec:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104bf0:	85 c0                	test   %eax,%eax
80104bf2:	74 14                	je     80104c08 <argfd.constprop.0+0x48>
  if(pfd)
80104bf4:	85 db                	test   %ebx,%ebx
80104bf6:	74 02                	je     80104bfa <argfd.constprop.0+0x3a>
    *pfd = fd;
80104bf8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104bfa:	89 06                	mov    %eax,(%esi)
  return 0;
80104bfc:	31 c0                	xor    %eax,%eax
}
80104bfe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c01:	5b                   	pop    %ebx
80104c02:	5e                   	pop    %esi
80104c03:	5d                   	pop    %ebp
80104c04:	c3                   	ret    
80104c05:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104c08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c0d:	eb ef                	jmp    80104bfe <argfd.constprop.0+0x3e>
80104c0f:	90                   	nop

80104c10 <sys_dup>:
{
80104c10:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104c11:	31 c0                	xor    %eax,%eax
{
80104c13:	89 e5                	mov    %esp,%ebp
80104c15:	56                   	push   %esi
80104c16:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104c17:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104c1a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104c1d:	e8 9e ff ff ff       	call   80104bc0 <argfd.constprop.0>
80104c22:	85 c0                	test   %eax,%eax
80104c24:	78 42                	js     80104c68 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104c26:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104c29:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104c2b:	e8 50 ed ff ff       	call   80103980 <myproc>
80104c30:	eb 0e                	jmp    80104c40 <sys_dup+0x30>
80104c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104c38:	83 c3 01             	add    $0x1,%ebx
80104c3b:	83 fb 10             	cmp    $0x10,%ebx
80104c3e:	74 28                	je     80104c68 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104c40:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104c44:	85 d2                	test   %edx,%edx
80104c46:	75 f0                	jne    80104c38 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104c48:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104c4c:	83 ec 0c             	sub    $0xc,%esp
80104c4f:	ff 75 f4             	pushl  -0xc(%ebp)
80104c52:	e8 b9 c1 ff ff       	call   80100e10 <filedup>
  return fd;
80104c57:	83 c4 10             	add    $0x10,%esp
}
80104c5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c5d:	89 d8                	mov    %ebx,%eax
80104c5f:	5b                   	pop    %ebx
80104c60:	5e                   	pop    %esi
80104c61:	5d                   	pop    %ebp
80104c62:	c3                   	ret    
80104c63:	90                   	nop
80104c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c68:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104c6b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104c70:	89 d8                	mov    %ebx,%eax
80104c72:	5b                   	pop    %ebx
80104c73:	5e                   	pop    %esi
80104c74:	5d                   	pop    %ebp
80104c75:	c3                   	ret    
80104c76:	8d 76 00             	lea    0x0(%esi),%esi
80104c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c80 <sys_read>:
{
80104c80:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c81:	31 c0                	xor    %eax,%eax
{
80104c83:	89 e5                	mov    %esp,%ebp
80104c85:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c88:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104c8b:	e8 30 ff ff ff       	call   80104bc0 <argfd.constprop.0>
80104c90:	85 c0                	test   %eax,%eax
80104c92:	78 4c                	js     80104ce0 <sys_read+0x60>
80104c94:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c97:	83 ec 08             	sub    $0x8,%esp
80104c9a:	50                   	push   %eax
80104c9b:	6a 02                	push   $0x2
80104c9d:	e8 2e fc ff ff       	call   801048d0 <argint>
80104ca2:	83 c4 10             	add    $0x10,%esp
80104ca5:	85 c0                	test   %eax,%eax
80104ca7:	78 37                	js     80104ce0 <sys_read+0x60>
80104ca9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cac:	83 ec 04             	sub    $0x4,%esp
80104caf:	ff 75 f0             	pushl  -0x10(%ebp)
80104cb2:	50                   	push   %eax
80104cb3:	6a 01                	push   $0x1
80104cb5:	e8 66 fc ff ff       	call   80104920 <argptr>
80104cba:	83 c4 10             	add    $0x10,%esp
80104cbd:	85 c0                	test   %eax,%eax
80104cbf:	78 1f                	js     80104ce0 <sys_read+0x60>
  return fileread(f, p, n);
80104cc1:	83 ec 04             	sub    $0x4,%esp
80104cc4:	ff 75 f0             	pushl  -0x10(%ebp)
80104cc7:	ff 75 f4             	pushl  -0xc(%ebp)
80104cca:	ff 75 ec             	pushl  -0x14(%ebp)
80104ccd:	e8 ae c2 ff ff       	call   80100f80 <fileread>
80104cd2:	83 c4 10             	add    $0x10,%esp
}
80104cd5:	c9                   	leave  
80104cd6:	c3                   	ret    
80104cd7:	89 f6                	mov    %esi,%esi
80104cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104ce0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ce5:	c9                   	leave  
80104ce6:	c3                   	ret    
80104ce7:	89 f6                	mov    %esi,%esi
80104ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cf0 <sys_write>:
{
80104cf0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104cf1:	31 c0                	xor    %eax,%eax
{
80104cf3:	89 e5                	mov    %esp,%ebp
80104cf5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104cf8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104cfb:	e8 c0 fe ff ff       	call   80104bc0 <argfd.constprop.0>
80104d00:	85 c0                	test   %eax,%eax
80104d02:	78 4c                	js     80104d50 <sys_write+0x60>
80104d04:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d07:	83 ec 08             	sub    $0x8,%esp
80104d0a:	50                   	push   %eax
80104d0b:	6a 02                	push   $0x2
80104d0d:	e8 be fb ff ff       	call   801048d0 <argint>
80104d12:	83 c4 10             	add    $0x10,%esp
80104d15:	85 c0                	test   %eax,%eax
80104d17:	78 37                	js     80104d50 <sys_write+0x60>
80104d19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d1c:	83 ec 04             	sub    $0x4,%esp
80104d1f:	ff 75 f0             	pushl  -0x10(%ebp)
80104d22:	50                   	push   %eax
80104d23:	6a 01                	push   $0x1
80104d25:	e8 f6 fb ff ff       	call   80104920 <argptr>
80104d2a:	83 c4 10             	add    $0x10,%esp
80104d2d:	85 c0                	test   %eax,%eax
80104d2f:	78 1f                	js     80104d50 <sys_write+0x60>
  return filewrite(f, p, n);
80104d31:	83 ec 04             	sub    $0x4,%esp
80104d34:	ff 75 f0             	pushl  -0x10(%ebp)
80104d37:	ff 75 f4             	pushl  -0xc(%ebp)
80104d3a:	ff 75 ec             	pushl  -0x14(%ebp)
80104d3d:	e8 ce c2 ff ff       	call   80101010 <filewrite>
80104d42:	83 c4 10             	add    $0x10,%esp
}
80104d45:	c9                   	leave  
80104d46:	c3                   	ret    
80104d47:	89 f6                	mov    %esi,%esi
80104d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d55:	c9                   	leave  
80104d56:	c3                   	ret    
80104d57:	89 f6                	mov    %esi,%esi
80104d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d60 <sys_close>:
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104d66:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104d69:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d6c:	e8 4f fe ff ff       	call   80104bc0 <argfd.constprop.0>
80104d71:	85 c0                	test   %eax,%eax
80104d73:	78 2b                	js     80104da0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104d75:	e8 06 ec ff ff       	call   80103980 <myproc>
80104d7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104d7d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104d80:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104d87:	00 
  fileclose(f);
80104d88:	ff 75 f4             	pushl  -0xc(%ebp)
80104d8b:	e8 d0 c0 ff ff       	call   80100e60 <fileclose>
  return 0;
80104d90:	83 c4 10             	add    $0x10,%esp
80104d93:	31 c0                	xor    %eax,%eax
}
80104d95:	c9                   	leave  
80104d96:	c3                   	ret    
80104d97:	89 f6                	mov    %esi,%esi
80104d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104da0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104da5:	c9                   	leave  
80104da6:	c3                   	ret    
80104da7:	89 f6                	mov    %esi,%esi
80104da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104db0 <sys_fstat>:
{
80104db0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104db1:	31 c0                	xor    %eax,%eax
{
80104db3:	89 e5                	mov    %esp,%ebp
80104db5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104db8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104dbb:	e8 00 fe ff ff       	call   80104bc0 <argfd.constprop.0>
80104dc0:	85 c0                	test   %eax,%eax
80104dc2:	78 2c                	js     80104df0 <sys_fstat+0x40>
80104dc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dc7:	83 ec 04             	sub    $0x4,%esp
80104dca:	6a 14                	push   $0x14
80104dcc:	50                   	push   %eax
80104dcd:	6a 01                	push   $0x1
80104dcf:	e8 4c fb ff ff       	call   80104920 <argptr>
80104dd4:	83 c4 10             	add    $0x10,%esp
80104dd7:	85 c0                	test   %eax,%eax
80104dd9:	78 15                	js     80104df0 <sys_fstat+0x40>
  return filestat(f, st);
80104ddb:	83 ec 08             	sub    $0x8,%esp
80104dde:	ff 75 f4             	pushl  -0xc(%ebp)
80104de1:	ff 75 f0             	pushl  -0x10(%ebp)
80104de4:	e8 47 c1 ff ff       	call   80100f30 <filestat>
80104de9:	83 c4 10             	add    $0x10,%esp
}
80104dec:	c9                   	leave  
80104ded:	c3                   	ret    
80104dee:	66 90                	xchg   %ax,%ax
    return -1;
80104df0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104df5:	c9                   	leave  
80104df6:	c3                   	ret    
80104df7:	89 f6                	mov    %esi,%esi
80104df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e00 <sys_link>:
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	57                   	push   %edi
80104e04:	56                   	push   %esi
80104e05:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104e06:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104e09:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104e0c:	50                   	push   %eax
80104e0d:	6a 00                	push   $0x0
80104e0f:	e8 6c fb ff ff       	call   80104980 <argstr>
80104e14:	83 c4 10             	add    $0x10,%esp
80104e17:	85 c0                	test   %eax,%eax
80104e19:	0f 88 fb 00 00 00    	js     80104f1a <sys_link+0x11a>
80104e1f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104e22:	83 ec 08             	sub    $0x8,%esp
80104e25:	50                   	push   %eax
80104e26:	6a 01                	push   $0x1
80104e28:	e8 53 fb ff ff       	call   80104980 <argstr>
80104e2d:	83 c4 10             	add    $0x10,%esp
80104e30:	85 c0                	test   %eax,%eax
80104e32:	0f 88 e2 00 00 00    	js     80104f1a <sys_link+0x11a>
  begin_op();
80104e38:	e8 03 df ff ff       	call   80102d40 <begin_op>
  if((ip = namei(old)) == 0){
80104e3d:	83 ec 0c             	sub    $0xc,%esp
80104e40:	ff 75 d4             	pushl  -0x2c(%ebp)
80104e43:	e8 48 d2 ff ff       	call   80102090 <namei>
80104e48:	83 c4 10             	add    $0x10,%esp
80104e4b:	85 c0                	test   %eax,%eax
80104e4d:	89 c3                	mov    %eax,%ebx
80104e4f:	0f 84 ea 00 00 00    	je     80104f3f <sys_link+0x13f>
  ilock(ip);
80104e55:	83 ec 0c             	sub    $0xc,%esp
80104e58:	50                   	push   %eax
80104e59:	e8 d2 c9 ff ff       	call   80101830 <ilock>
  if(ip->type == T_DIR){
80104e5e:	83 c4 10             	add    $0x10,%esp
80104e61:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e66:	0f 84 bb 00 00 00    	je     80104f27 <sys_link+0x127>
  ip->nlink++;
80104e6c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104e71:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80104e74:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104e77:	53                   	push   %ebx
80104e78:	e8 03 c9 ff ff       	call   80101780 <iupdate>
  iunlock(ip);
80104e7d:	89 1c 24             	mov    %ebx,(%esp)
80104e80:	e8 8b ca ff ff       	call   80101910 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104e85:	58                   	pop    %eax
80104e86:	5a                   	pop    %edx
80104e87:	57                   	push   %edi
80104e88:	ff 75 d0             	pushl  -0x30(%ebp)
80104e8b:	e8 20 d2 ff ff       	call   801020b0 <nameiparent>
80104e90:	83 c4 10             	add    $0x10,%esp
80104e93:	85 c0                	test   %eax,%eax
80104e95:	89 c6                	mov    %eax,%esi
80104e97:	74 5b                	je     80104ef4 <sys_link+0xf4>
  ilock(dp);
80104e99:	83 ec 0c             	sub    $0xc,%esp
80104e9c:	50                   	push   %eax
80104e9d:	e8 8e c9 ff ff       	call   80101830 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104ea2:	83 c4 10             	add    $0x10,%esp
80104ea5:	8b 03                	mov    (%ebx),%eax
80104ea7:	39 06                	cmp    %eax,(%esi)
80104ea9:	75 3d                	jne    80104ee8 <sys_link+0xe8>
80104eab:	83 ec 04             	sub    $0x4,%esp
80104eae:	ff 73 04             	pushl  0x4(%ebx)
80104eb1:	57                   	push   %edi
80104eb2:	56                   	push   %esi
80104eb3:	e8 18 d1 ff ff       	call   80101fd0 <dirlink>
80104eb8:	83 c4 10             	add    $0x10,%esp
80104ebb:	85 c0                	test   %eax,%eax
80104ebd:	78 29                	js     80104ee8 <sys_link+0xe8>
  iunlockput(dp);
80104ebf:	83 ec 0c             	sub    $0xc,%esp
80104ec2:	56                   	push   %esi
80104ec3:	e8 f8 cb ff ff       	call   80101ac0 <iunlockput>
  iput(ip);
80104ec8:	89 1c 24             	mov    %ebx,(%esp)
80104ecb:	e8 90 ca ff ff       	call   80101960 <iput>
  end_op();
80104ed0:	e8 db de ff ff       	call   80102db0 <end_op>
  return 0;
80104ed5:	83 c4 10             	add    $0x10,%esp
80104ed8:	31 c0                	xor    %eax,%eax
}
80104eda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104edd:	5b                   	pop    %ebx
80104ede:	5e                   	pop    %esi
80104edf:	5f                   	pop    %edi
80104ee0:	5d                   	pop    %ebp
80104ee1:	c3                   	ret    
80104ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104ee8:	83 ec 0c             	sub    $0xc,%esp
80104eeb:	56                   	push   %esi
80104eec:	e8 cf cb ff ff       	call   80101ac0 <iunlockput>
    goto bad;
80104ef1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104ef4:	83 ec 0c             	sub    $0xc,%esp
80104ef7:	53                   	push   %ebx
80104ef8:	e8 33 c9 ff ff       	call   80101830 <ilock>
  ip->nlink--;
80104efd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f02:	89 1c 24             	mov    %ebx,(%esp)
80104f05:	e8 76 c8 ff ff       	call   80101780 <iupdate>
  iunlockput(ip);
80104f0a:	89 1c 24             	mov    %ebx,(%esp)
80104f0d:	e8 ae cb ff ff       	call   80101ac0 <iunlockput>
  end_op();
80104f12:	e8 99 de ff ff       	call   80102db0 <end_op>
  return -1;
80104f17:	83 c4 10             	add    $0x10,%esp
}
80104f1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80104f1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f22:	5b                   	pop    %ebx
80104f23:	5e                   	pop    %esi
80104f24:	5f                   	pop    %edi
80104f25:	5d                   	pop    %ebp
80104f26:	c3                   	ret    
    iunlockput(ip);
80104f27:	83 ec 0c             	sub    $0xc,%esp
80104f2a:	53                   	push   %ebx
80104f2b:	e8 90 cb ff ff       	call   80101ac0 <iunlockput>
    end_op();
80104f30:	e8 7b de ff ff       	call   80102db0 <end_op>
    return -1;
80104f35:	83 c4 10             	add    $0x10,%esp
80104f38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f3d:	eb 9b                	jmp    80104eda <sys_link+0xda>
    end_op();
80104f3f:	e8 6c de ff ff       	call   80102db0 <end_op>
    return -1;
80104f44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f49:	eb 8f                	jmp    80104eda <sys_link+0xda>
80104f4b:	90                   	nop
80104f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f50 <sys_unlink>:
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	57                   	push   %edi
80104f54:	56                   	push   %esi
80104f55:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80104f56:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80104f59:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80104f5c:	50                   	push   %eax
80104f5d:	6a 00                	push   $0x0
80104f5f:	e8 1c fa ff ff       	call   80104980 <argstr>
80104f64:	83 c4 10             	add    $0x10,%esp
80104f67:	85 c0                	test   %eax,%eax
80104f69:	0f 88 77 01 00 00    	js     801050e6 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
80104f6f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80104f72:	e8 c9 dd ff ff       	call   80102d40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104f77:	83 ec 08             	sub    $0x8,%esp
80104f7a:	53                   	push   %ebx
80104f7b:	ff 75 c0             	pushl  -0x40(%ebp)
80104f7e:	e8 2d d1 ff ff       	call   801020b0 <nameiparent>
80104f83:	83 c4 10             	add    $0x10,%esp
80104f86:	85 c0                	test   %eax,%eax
80104f88:	89 c6                	mov    %eax,%esi
80104f8a:	0f 84 60 01 00 00    	je     801050f0 <sys_unlink+0x1a0>
  ilock(dp);
80104f90:	83 ec 0c             	sub    $0xc,%esp
80104f93:	50                   	push   %eax
80104f94:	e8 97 c8 ff ff       	call   80101830 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104f99:	58                   	pop    %eax
80104f9a:	5a                   	pop    %edx
80104f9b:	68 5c 78 10 80       	push   $0x8010785c
80104fa0:	53                   	push   %ebx
80104fa1:	e8 9a cd ff ff       	call   80101d40 <namecmp>
80104fa6:	83 c4 10             	add    $0x10,%esp
80104fa9:	85 c0                	test   %eax,%eax
80104fab:	0f 84 03 01 00 00    	je     801050b4 <sys_unlink+0x164>
80104fb1:	83 ec 08             	sub    $0x8,%esp
80104fb4:	68 5b 78 10 80       	push   $0x8010785b
80104fb9:	53                   	push   %ebx
80104fba:	e8 81 cd ff ff       	call   80101d40 <namecmp>
80104fbf:	83 c4 10             	add    $0x10,%esp
80104fc2:	85 c0                	test   %eax,%eax
80104fc4:	0f 84 ea 00 00 00    	je     801050b4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104fca:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104fcd:	83 ec 04             	sub    $0x4,%esp
80104fd0:	50                   	push   %eax
80104fd1:	53                   	push   %ebx
80104fd2:	56                   	push   %esi
80104fd3:	e8 88 cd ff ff       	call   80101d60 <dirlookup>
80104fd8:	83 c4 10             	add    $0x10,%esp
80104fdb:	85 c0                	test   %eax,%eax
80104fdd:	89 c3                	mov    %eax,%ebx
80104fdf:	0f 84 cf 00 00 00    	je     801050b4 <sys_unlink+0x164>
  ilock(ip);
80104fe5:	83 ec 0c             	sub    $0xc,%esp
80104fe8:	50                   	push   %eax
80104fe9:	e8 42 c8 ff ff       	call   80101830 <ilock>
  if(ip->nlink < 1)
80104fee:	83 c4 10             	add    $0x10,%esp
80104ff1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104ff6:	0f 8e 10 01 00 00    	jle    8010510c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104ffc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105001:	74 6d                	je     80105070 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105003:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105006:	83 ec 04             	sub    $0x4,%esp
80105009:	6a 10                	push   $0x10
8010500b:	6a 00                	push   $0x0
8010500d:	50                   	push   %eax
8010500e:	e8 bd f5 ff ff       	call   801045d0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105013:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105016:	6a 10                	push   $0x10
80105018:	ff 75 c4             	pushl  -0x3c(%ebp)
8010501b:	50                   	push   %eax
8010501c:	56                   	push   %esi
8010501d:	e8 ee cb ff ff       	call   80101c10 <writei>
80105022:	83 c4 20             	add    $0x20,%esp
80105025:	83 f8 10             	cmp    $0x10,%eax
80105028:	0f 85 eb 00 00 00    	jne    80105119 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010502e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105033:	0f 84 97 00 00 00    	je     801050d0 <sys_unlink+0x180>
  iunlockput(dp);
80105039:	83 ec 0c             	sub    $0xc,%esp
8010503c:	56                   	push   %esi
8010503d:	e8 7e ca ff ff       	call   80101ac0 <iunlockput>
  ip->nlink--;
80105042:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105047:	89 1c 24             	mov    %ebx,(%esp)
8010504a:	e8 31 c7 ff ff       	call   80101780 <iupdate>
  iunlockput(ip);
8010504f:	89 1c 24             	mov    %ebx,(%esp)
80105052:	e8 69 ca ff ff       	call   80101ac0 <iunlockput>
  end_op();
80105057:	e8 54 dd ff ff       	call   80102db0 <end_op>
  return 0;
8010505c:	83 c4 10             	add    $0x10,%esp
8010505f:	31 c0                	xor    %eax,%eax
}
80105061:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105064:	5b                   	pop    %ebx
80105065:	5e                   	pop    %esi
80105066:	5f                   	pop    %edi
80105067:	5d                   	pop    %ebp
80105068:	c3                   	ret    
80105069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105070:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105074:	76 8d                	jbe    80105003 <sys_unlink+0xb3>
80105076:	bf 20 00 00 00       	mov    $0x20,%edi
8010507b:	eb 0f                	jmp    8010508c <sys_unlink+0x13c>
8010507d:	8d 76 00             	lea    0x0(%esi),%esi
80105080:	83 c7 10             	add    $0x10,%edi
80105083:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105086:	0f 83 77 ff ff ff    	jae    80105003 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010508c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010508f:	6a 10                	push   $0x10
80105091:	57                   	push   %edi
80105092:	50                   	push   %eax
80105093:	53                   	push   %ebx
80105094:	e8 77 ca ff ff       	call   80101b10 <readi>
80105099:	83 c4 10             	add    $0x10,%esp
8010509c:	83 f8 10             	cmp    $0x10,%eax
8010509f:	75 5e                	jne    801050ff <sys_unlink+0x1af>
    if(de.inum != 0)
801050a1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801050a6:	74 d8                	je     80105080 <sys_unlink+0x130>
    iunlockput(ip);
801050a8:	83 ec 0c             	sub    $0xc,%esp
801050ab:	53                   	push   %ebx
801050ac:	e8 0f ca ff ff       	call   80101ac0 <iunlockput>
    goto bad;
801050b1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801050b4:	83 ec 0c             	sub    $0xc,%esp
801050b7:	56                   	push   %esi
801050b8:	e8 03 ca ff ff       	call   80101ac0 <iunlockput>
  end_op();
801050bd:	e8 ee dc ff ff       	call   80102db0 <end_op>
  return -1;
801050c2:	83 c4 10             	add    $0x10,%esp
801050c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050ca:	eb 95                	jmp    80105061 <sys_unlink+0x111>
801050cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
801050d0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801050d5:	83 ec 0c             	sub    $0xc,%esp
801050d8:	56                   	push   %esi
801050d9:	e8 a2 c6 ff ff       	call   80101780 <iupdate>
801050de:	83 c4 10             	add    $0x10,%esp
801050e1:	e9 53 ff ff ff       	jmp    80105039 <sys_unlink+0xe9>
    return -1;
801050e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050eb:	e9 71 ff ff ff       	jmp    80105061 <sys_unlink+0x111>
    end_op();
801050f0:	e8 bb dc ff ff       	call   80102db0 <end_op>
    return -1;
801050f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050fa:	e9 62 ff ff ff       	jmp    80105061 <sys_unlink+0x111>
      panic("isdirempty: readi");
801050ff:	83 ec 0c             	sub    $0xc,%esp
80105102:	68 80 78 10 80       	push   $0x80107880
80105107:	e8 a4 b2 ff ff       	call   801003b0 <panic>
    panic("unlink: nlink < 1");
8010510c:	83 ec 0c             	sub    $0xc,%esp
8010510f:	68 6e 78 10 80       	push   $0x8010786e
80105114:	e8 97 b2 ff ff       	call   801003b0 <panic>
    panic("unlink: writei");
80105119:	83 ec 0c             	sub    $0xc,%esp
8010511c:	68 92 78 10 80       	push   $0x80107892
80105121:	e8 8a b2 ff ff       	call   801003b0 <panic>
80105126:	8d 76 00             	lea    0x0(%esi),%esi
80105129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105130 <sys_open>:

int
sys_open(void)
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	57                   	push   %edi
80105134:	56                   	push   %esi
80105135:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105136:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105139:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010513c:	50                   	push   %eax
8010513d:	6a 00                	push   $0x0
8010513f:	e8 3c f8 ff ff       	call   80104980 <argstr>
80105144:	83 c4 10             	add    $0x10,%esp
80105147:	85 c0                	test   %eax,%eax
80105149:	0f 88 1d 01 00 00    	js     8010526c <sys_open+0x13c>
8010514f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105152:	83 ec 08             	sub    $0x8,%esp
80105155:	50                   	push   %eax
80105156:	6a 01                	push   $0x1
80105158:	e8 73 f7 ff ff       	call   801048d0 <argint>
8010515d:	83 c4 10             	add    $0x10,%esp
80105160:	85 c0                	test   %eax,%eax
80105162:	0f 88 04 01 00 00    	js     8010526c <sys_open+0x13c>
    return -1;

  begin_op();
80105168:	e8 d3 db ff ff       	call   80102d40 <begin_op>

  if(omode & O_CREATE){
8010516d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105171:	0f 85 a9 00 00 00    	jne    80105220 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105177:	83 ec 0c             	sub    $0xc,%esp
8010517a:	ff 75 e0             	pushl  -0x20(%ebp)
8010517d:	e8 0e cf ff ff       	call   80102090 <namei>
80105182:	83 c4 10             	add    $0x10,%esp
80105185:	85 c0                	test   %eax,%eax
80105187:	89 c6                	mov    %eax,%esi
80105189:	0f 84 b2 00 00 00    	je     80105241 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010518f:	83 ec 0c             	sub    $0xc,%esp
80105192:	50                   	push   %eax
80105193:	e8 98 c6 ff ff       	call   80101830 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105198:	83 c4 10             	add    $0x10,%esp
8010519b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801051a0:	0f 84 aa 00 00 00    	je     80105250 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801051a6:	e8 f5 bb ff ff       	call   80100da0 <filealloc>
801051ab:	85 c0                	test   %eax,%eax
801051ad:	89 c7                	mov    %eax,%edi
801051af:	0f 84 a6 00 00 00    	je     8010525b <sys_open+0x12b>
  struct proc *curproc = myproc();
801051b5:	e8 c6 e7 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801051ba:	31 db                	xor    %ebx,%ebx
801051bc:	eb 0e                	jmp    801051cc <sys_open+0x9c>
801051be:	66 90                	xchg   %ax,%ax
801051c0:	83 c3 01             	add    $0x1,%ebx
801051c3:	83 fb 10             	cmp    $0x10,%ebx
801051c6:	0f 84 ac 00 00 00    	je     80105278 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801051cc:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801051d0:	85 d2                	test   %edx,%edx
801051d2:	75 ec                	jne    801051c0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801051d4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801051d7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801051db:	56                   	push   %esi
801051dc:	e8 2f c7 ff ff       	call   80101910 <iunlock>
  end_op();
801051e1:	e8 ca db ff ff       	call   80102db0 <end_op>

  f->type = FD_INODE;
801051e6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801051ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801051ef:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801051f2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801051f5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801051fc:	89 d0                	mov    %edx,%eax
801051fe:	f7 d0                	not    %eax
80105200:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105203:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105206:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105209:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010520d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105210:	89 d8                	mov    %ebx,%eax
80105212:	5b                   	pop    %ebx
80105213:	5e                   	pop    %esi
80105214:	5f                   	pop    %edi
80105215:	5d                   	pop    %ebp
80105216:	c3                   	ret    
80105217:	89 f6                	mov    %esi,%esi
80105219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105220:	83 ec 0c             	sub    $0xc,%esp
80105223:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105226:	31 c9                	xor    %ecx,%ecx
80105228:	6a 00                	push   $0x0
8010522a:	ba 02 00 00 00       	mov    $0x2,%edx
8010522f:	e8 ec f7 ff ff       	call   80104a20 <create>
    if(ip == 0){
80105234:	83 c4 10             	add    $0x10,%esp
80105237:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105239:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010523b:	0f 85 65 ff ff ff    	jne    801051a6 <sys_open+0x76>
      end_op();
80105241:	e8 6a db ff ff       	call   80102db0 <end_op>
      return -1;
80105246:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010524b:	eb c0                	jmp    8010520d <sys_open+0xdd>
8010524d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105250:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105253:	85 c9                	test   %ecx,%ecx
80105255:	0f 84 4b ff ff ff    	je     801051a6 <sys_open+0x76>
    iunlockput(ip);
8010525b:	83 ec 0c             	sub    $0xc,%esp
8010525e:	56                   	push   %esi
8010525f:	e8 5c c8 ff ff       	call   80101ac0 <iunlockput>
    end_op();
80105264:	e8 47 db ff ff       	call   80102db0 <end_op>
    return -1;
80105269:	83 c4 10             	add    $0x10,%esp
8010526c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105271:	eb 9a                	jmp    8010520d <sys_open+0xdd>
80105273:	90                   	nop
80105274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105278:	83 ec 0c             	sub    $0xc,%esp
8010527b:	57                   	push   %edi
8010527c:	e8 df bb ff ff       	call   80100e60 <fileclose>
80105281:	83 c4 10             	add    $0x10,%esp
80105284:	eb d5                	jmp    8010525b <sys_open+0x12b>
80105286:	8d 76 00             	lea    0x0(%esi),%esi
80105289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105290 <sys_mkdir>:

int
sys_mkdir(void)
{
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105296:	e8 a5 da ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010529b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010529e:	83 ec 08             	sub    $0x8,%esp
801052a1:	50                   	push   %eax
801052a2:	6a 00                	push   $0x0
801052a4:	e8 d7 f6 ff ff       	call   80104980 <argstr>
801052a9:	83 c4 10             	add    $0x10,%esp
801052ac:	85 c0                	test   %eax,%eax
801052ae:	78 30                	js     801052e0 <sys_mkdir+0x50>
801052b0:	83 ec 0c             	sub    $0xc,%esp
801052b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052b6:	31 c9                	xor    %ecx,%ecx
801052b8:	6a 00                	push   $0x0
801052ba:	ba 01 00 00 00       	mov    $0x1,%edx
801052bf:	e8 5c f7 ff ff       	call   80104a20 <create>
801052c4:	83 c4 10             	add    $0x10,%esp
801052c7:	85 c0                	test   %eax,%eax
801052c9:	74 15                	je     801052e0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801052cb:	83 ec 0c             	sub    $0xc,%esp
801052ce:	50                   	push   %eax
801052cf:	e8 ec c7 ff ff       	call   80101ac0 <iunlockput>
  end_op();
801052d4:	e8 d7 da ff ff       	call   80102db0 <end_op>
  return 0;
801052d9:	83 c4 10             	add    $0x10,%esp
801052dc:	31 c0                	xor    %eax,%eax
}
801052de:	c9                   	leave  
801052df:	c3                   	ret    
    end_op();
801052e0:	e8 cb da ff ff       	call   80102db0 <end_op>
    return -1;
801052e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052ea:	c9                   	leave  
801052eb:	c3                   	ret    
801052ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052f0 <sys_mknod>:

int
sys_mknod(void)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801052f6:	e8 45 da ff ff       	call   80102d40 <begin_op>
  if((argstr(0, &path)) < 0 ||
801052fb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801052fe:	83 ec 08             	sub    $0x8,%esp
80105301:	50                   	push   %eax
80105302:	6a 00                	push   $0x0
80105304:	e8 77 f6 ff ff       	call   80104980 <argstr>
80105309:	83 c4 10             	add    $0x10,%esp
8010530c:	85 c0                	test   %eax,%eax
8010530e:	78 60                	js     80105370 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105310:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105313:	83 ec 08             	sub    $0x8,%esp
80105316:	50                   	push   %eax
80105317:	6a 01                	push   $0x1
80105319:	e8 b2 f5 ff ff       	call   801048d0 <argint>
  if((argstr(0, &path)) < 0 ||
8010531e:	83 c4 10             	add    $0x10,%esp
80105321:	85 c0                	test   %eax,%eax
80105323:	78 4b                	js     80105370 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105325:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105328:	83 ec 08             	sub    $0x8,%esp
8010532b:	50                   	push   %eax
8010532c:	6a 02                	push   $0x2
8010532e:	e8 9d f5 ff ff       	call   801048d0 <argint>
     argint(1, &major) < 0 ||
80105333:	83 c4 10             	add    $0x10,%esp
80105336:	85 c0                	test   %eax,%eax
80105338:	78 36                	js     80105370 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010533a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010533e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105341:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105345:	ba 03 00 00 00       	mov    $0x3,%edx
8010534a:	50                   	push   %eax
8010534b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010534e:	e8 cd f6 ff ff       	call   80104a20 <create>
80105353:	83 c4 10             	add    $0x10,%esp
80105356:	85 c0                	test   %eax,%eax
80105358:	74 16                	je     80105370 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010535a:	83 ec 0c             	sub    $0xc,%esp
8010535d:	50                   	push   %eax
8010535e:	e8 5d c7 ff ff       	call   80101ac0 <iunlockput>
  end_op();
80105363:	e8 48 da ff ff       	call   80102db0 <end_op>
  return 0;
80105368:	83 c4 10             	add    $0x10,%esp
8010536b:	31 c0                	xor    %eax,%eax
}
8010536d:	c9                   	leave  
8010536e:	c3                   	ret    
8010536f:	90                   	nop
    end_op();
80105370:	e8 3b da ff ff       	call   80102db0 <end_op>
    return -1;
80105375:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010537a:	c9                   	leave  
8010537b:	c3                   	ret    
8010537c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105380 <sys_chdir>:

int
sys_chdir(void)
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	56                   	push   %esi
80105384:	53                   	push   %ebx
80105385:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105388:	e8 f3 e5 ff ff       	call   80103980 <myproc>
8010538d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010538f:	e8 ac d9 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105394:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105397:	83 ec 08             	sub    $0x8,%esp
8010539a:	50                   	push   %eax
8010539b:	6a 00                	push   $0x0
8010539d:	e8 de f5 ff ff       	call   80104980 <argstr>
801053a2:	83 c4 10             	add    $0x10,%esp
801053a5:	85 c0                	test   %eax,%eax
801053a7:	78 77                	js     80105420 <sys_chdir+0xa0>
801053a9:	83 ec 0c             	sub    $0xc,%esp
801053ac:	ff 75 f4             	pushl  -0xc(%ebp)
801053af:	e8 dc cc ff ff       	call   80102090 <namei>
801053b4:	83 c4 10             	add    $0x10,%esp
801053b7:	85 c0                	test   %eax,%eax
801053b9:	89 c3                	mov    %eax,%ebx
801053bb:	74 63                	je     80105420 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801053bd:	83 ec 0c             	sub    $0xc,%esp
801053c0:	50                   	push   %eax
801053c1:	e8 6a c4 ff ff       	call   80101830 <ilock>
  if(ip->type != T_DIR){
801053c6:	83 c4 10             	add    $0x10,%esp
801053c9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053ce:	75 30                	jne    80105400 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801053d0:	83 ec 0c             	sub    $0xc,%esp
801053d3:	53                   	push   %ebx
801053d4:	e8 37 c5 ff ff       	call   80101910 <iunlock>
  iput(curproc->cwd);
801053d9:	58                   	pop    %eax
801053da:	ff 76 68             	pushl  0x68(%esi)
801053dd:	e8 7e c5 ff ff       	call   80101960 <iput>
  end_op();
801053e2:	e8 c9 d9 ff ff       	call   80102db0 <end_op>
  curproc->cwd = ip;
801053e7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801053ea:	83 c4 10             	add    $0x10,%esp
801053ed:	31 c0                	xor    %eax,%eax
}
801053ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053f2:	5b                   	pop    %ebx
801053f3:	5e                   	pop    %esi
801053f4:	5d                   	pop    %ebp
801053f5:	c3                   	ret    
801053f6:	8d 76 00             	lea    0x0(%esi),%esi
801053f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105400:	83 ec 0c             	sub    $0xc,%esp
80105403:	53                   	push   %ebx
80105404:	e8 b7 c6 ff ff       	call   80101ac0 <iunlockput>
    end_op();
80105409:	e8 a2 d9 ff ff       	call   80102db0 <end_op>
    return -1;
8010540e:	83 c4 10             	add    $0x10,%esp
80105411:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105416:	eb d7                	jmp    801053ef <sys_chdir+0x6f>
80105418:	90                   	nop
80105419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105420:	e8 8b d9 ff ff       	call   80102db0 <end_op>
    return -1;
80105425:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010542a:	eb c3                	jmp    801053ef <sys_chdir+0x6f>
8010542c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105430 <sys_exec>:

int
sys_exec(void)
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	57                   	push   %edi
80105434:	56                   	push   %esi
80105435:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105436:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010543c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105442:	50                   	push   %eax
80105443:	6a 00                	push   $0x0
80105445:	e8 36 f5 ff ff       	call   80104980 <argstr>
8010544a:	83 c4 10             	add    $0x10,%esp
8010544d:	85 c0                	test   %eax,%eax
8010544f:	0f 88 87 00 00 00    	js     801054dc <sys_exec+0xac>
80105455:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010545b:	83 ec 08             	sub    $0x8,%esp
8010545e:	50                   	push   %eax
8010545f:	6a 01                	push   $0x1
80105461:	e8 6a f4 ff ff       	call   801048d0 <argint>
80105466:	83 c4 10             	add    $0x10,%esp
80105469:	85 c0                	test   %eax,%eax
8010546b:	78 6f                	js     801054dc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010546d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105473:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105476:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105478:	68 80 00 00 00       	push   $0x80
8010547d:	6a 00                	push   $0x0
8010547f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105485:	50                   	push   %eax
80105486:	e8 45 f1 ff ff       	call   801045d0 <memset>
8010548b:	83 c4 10             	add    $0x10,%esp
8010548e:	eb 2c                	jmp    801054bc <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105490:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105496:	85 c0                	test   %eax,%eax
80105498:	74 56                	je     801054f0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010549a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801054a0:	83 ec 08             	sub    $0x8,%esp
801054a3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801054a6:	52                   	push   %edx
801054a7:	50                   	push   %eax
801054a8:	e8 b3 f3 ff ff       	call   80104860 <fetchstr>
801054ad:	83 c4 10             	add    $0x10,%esp
801054b0:	85 c0                	test   %eax,%eax
801054b2:	78 28                	js     801054dc <sys_exec+0xac>
  for(i=0;; i++){
801054b4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801054b7:	83 fb 20             	cmp    $0x20,%ebx
801054ba:	74 20                	je     801054dc <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801054bc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801054c2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801054c9:	83 ec 08             	sub    $0x8,%esp
801054cc:	57                   	push   %edi
801054cd:	01 f0                	add    %esi,%eax
801054cf:	50                   	push   %eax
801054d0:	e8 4b f3 ff ff       	call   80104820 <fetchint>
801054d5:	83 c4 10             	add    $0x10,%esp
801054d8:	85 c0                	test   %eax,%eax
801054da:	79 b4                	jns    80105490 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801054dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801054df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054e4:	5b                   	pop    %ebx
801054e5:	5e                   	pop    %esi
801054e6:	5f                   	pop    %edi
801054e7:	5d                   	pop    %ebp
801054e8:	c3                   	ret    
801054e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801054f0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801054f6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
801054f9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105500:	00 00 00 00 
  return exec(path, argv);
80105504:	50                   	push   %eax
80105505:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010550b:	e8 20 b5 ff ff       	call   80100a30 <exec>
80105510:	83 c4 10             	add    $0x10,%esp
}
80105513:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105516:	5b                   	pop    %ebx
80105517:	5e                   	pop    %esi
80105518:	5f                   	pop    %edi
80105519:	5d                   	pop    %ebp
8010551a:	c3                   	ret    
8010551b:	90                   	nop
8010551c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105520 <sys_pipe>:

int
sys_pipe(void)
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	57                   	push   %edi
80105524:	56                   	push   %esi
80105525:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105526:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105529:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010552c:	6a 08                	push   $0x8
8010552e:	50                   	push   %eax
8010552f:	6a 00                	push   $0x0
80105531:	e8 ea f3 ff ff       	call   80104920 <argptr>
80105536:	83 c4 10             	add    $0x10,%esp
80105539:	85 c0                	test   %eax,%eax
8010553b:	0f 88 ae 00 00 00    	js     801055ef <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105541:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105544:	83 ec 08             	sub    $0x8,%esp
80105547:	50                   	push   %eax
80105548:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010554b:	50                   	push   %eax
8010554c:	e8 8f de ff ff       	call   801033e0 <pipealloc>
80105551:	83 c4 10             	add    $0x10,%esp
80105554:	85 c0                	test   %eax,%eax
80105556:	0f 88 93 00 00 00    	js     801055ef <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010555c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010555f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105561:	e8 1a e4 ff ff       	call   80103980 <myproc>
80105566:	eb 10                	jmp    80105578 <sys_pipe+0x58>
80105568:	90                   	nop
80105569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105570:	83 c3 01             	add    $0x1,%ebx
80105573:	83 fb 10             	cmp    $0x10,%ebx
80105576:	74 60                	je     801055d8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105578:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010557c:	85 f6                	test   %esi,%esi
8010557e:	75 f0                	jne    80105570 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105580:	8d 73 08             	lea    0x8(%ebx),%esi
80105583:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105587:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010558a:	e8 f1 e3 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010558f:	31 d2                	xor    %edx,%edx
80105591:	eb 0d                	jmp    801055a0 <sys_pipe+0x80>
80105593:	90                   	nop
80105594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105598:	83 c2 01             	add    $0x1,%edx
8010559b:	83 fa 10             	cmp    $0x10,%edx
8010559e:	74 28                	je     801055c8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
801055a0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801055a4:	85 c9                	test   %ecx,%ecx
801055a6:	75 f0                	jne    80105598 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
801055a8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801055ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
801055af:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801055b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801055b4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801055b7:	31 c0                	xor    %eax,%eax
}
801055b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055bc:	5b                   	pop    %ebx
801055bd:	5e                   	pop    %esi
801055be:	5f                   	pop    %edi
801055bf:	5d                   	pop    %ebp
801055c0:	c3                   	ret    
801055c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
801055c8:	e8 b3 e3 ff ff       	call   80103980 <myproc>
801055cd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801055d4:	00 
801055d5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
801055d8:	83 ec 0c             	sub    $0xc,%esp
801055db:	ff 75 e0             	pushl  -0x20(%ebp)
801055de:	e8 7d b8 ff ff       	call   80100e60 <fileclose>
    fileclose(wf);
801055e3:	58                   	pop    %eax
801055e4:	ff 75 e4             	pushl  -0x1c(%ebp)
801055e7:	e8 74 b8 ff ff       	call   80100e60 <fileclose>
    return -1;
801055ec:	83 c4 10             	add    $0x10,%esp
801055ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055f4:	eb c3                	jmp    801055b9 <sys_pipe+0x99>
801055f6:	8d 76 00             	lea    0x0(%esi),%esi
801055f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105600 <sys_bstat>:

/* returns the number of swapped pages
 */
int
sys_bstat(void)
{
80105600:	55                   	push   %ebp
	return numallocblocks;
}
80105601:	a1 5c a5 10 80       	mov    0x8010a55c,%eax
{
80105606:	89 e5                	mov    %esp,%ebp
}
80105608:	5d                   	pop    %ebp
80105609:	c3                   	ret    
8010560a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105610 <sys_swap>:

/* swap system call handler.
 */
int
sys_swap(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	83 ec 20             	sub    $0x20,%esp
  uint addr;

  if(argint(0, (int*)&addr) < 0)
80105616:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105619:	50                   	push   %eax
8010561a:	6a 00                	push   $0x0
8010561c:	e8 af f2 ff ff       	call   801048d0 <argint>
    return -1;
  // swap addr
  return 0;
}
80105621:	c9                   	leave  
  if(argint(0, (int*)&addr) < 0)
80105622:	c1 f8 1f             	sar    $0x1f,%eax
}
80105625:	c3                   	ret    
80105626:	66 90                	xchg   %ax,%ax
80105628:	66 90                	xchg   %ax,%ax
8010562a:	66 90                	xchg   %ax,%ax
8010562c:	66 90                	xchg   %ax,%ax
8010562e:	66 90                	xchg   %ax,%ax

80105630 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105633:	5d                   	pop    %ebp
  return fork();
80105634:	e9 b7 e4 ff ff       	jmp    80103af0 <fork>
80105639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105640 <sys_exit>:

int
sys_exit(void)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	83 ec 08             	sub    $0x8,%esp
  exit();
80105646:	e8 25 e7 ff ff       	call   80103d70 <exit>
  return 0;  // not reached
}
8010564b:	31 c0                	xor    %eax,%eax
8010564d:	c9                   	leave  
8010564e:	c3                   	ret    
8010564f:	90                   	nop

80105650 <sys_wait>:

int
sys_wait(void)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105653:	5d                   	pop    %ebp
  return wait();
80105654:	e9 57 e9 ff ff       	jmp    80103fb0 <wait>
80105659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105660 <sys_kill>:

int
sys_kill(void)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105666:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105669:	50                   	push   %eax
8010566a:	6a 00                	push   $0x0
8010566c:	e8 5f f2 ff ff       	call   801048d0 <argint>
80105671:	83 c4 10             	add    $0x10,%esp
80105674:	85 c0                	test   %eax,%eax
80105676:	78 18                	js     80105690 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105678:	83 ec 0c             	sub    $0xc,%esp
8010567b:	ff 75 f4             	pushl  -0xc(%ebp)
8010567e:	e8 8d ea ff ff       	call   80104110 <kill>
80105683:	83 c4 10             	add    $0x10,%esp
}
80105686:	c9                   	leave  
80105687:	c3                   	ret    
80105688:	90                   	nop
80105689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105690:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105695:	c9                   	leave  
80105696:	c3                   	ret    
80105697:	89 f6                	mov    %esi,%esi
80105699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056a0 <sys_getpid>:

int
sys_getpid(void)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801056a6:	e8 d5 e2 ff ff       	call   80103980 <myproc>
801056ab:	8b 40 10             	mov    0x10(%eax),%eax
}
801056ae:	c9                   	leave  
801056af:	c3                   	ret    

801056b0 <sys_sbrk>:

int
sys_sbrk(void)
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801056b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801056b7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801056ba:	50                   	push   %eax
801056bb:	6a 00                	push   $0x0
801056bd:	e8 0e f2 ff ff       	call   801048d0 <argint>
801056c2:	83 c4 10             	add    $0x10,%esp
801056c5:	85 c0                	test   %eax,%eax
801056c7:	78 27                	js     801056f0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801056c9:	e8 b2 e2 ff ff       	call   80103980 <myproc>
  if(growproc(n) < 0)
801056ce:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801056d1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801056d3:	ff 75 f4             	pushl  -0xc(%ebp)
801056d6:	e8 c5 e3 ff ff       	call   80103aa0 <growproc>
801056db:	83 c4 10             	add    $0x10,%esp
801056de:	85 c0                	test   %eax,%eax
801056e0:	78 0e                	js     801056f0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801056e2:	89 d8                	mov    %ebx,%eax
801056e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056e7:	c9                   	leave  
801056e8:	c3                   	ret    
801056e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801056f0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801056f5:	eb eb                	jmp    801056e2 <sys_sbrk+0x32>
801056f7:	89 f6                	mov    %esi,%esi
801056f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105700 <sys_sleep>:

int
sys_sleep(void)
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105704:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105707:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010570a:	50                   	push   %eax
8010570b:	6a 00                	push   $0x0
8010570d:	e8 be f1 ff ff       	call   801048d0 <argint>
80105712:	83 c4 10             	add    $0x10,%esp
80105715:	85 c0                	test   %eax,%eax
80105717:	0f 88 8a 00 00 00    	js     801057a7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010571d:	83 ec 0c             	sub    $0xc,%esp
80105720:	68 60 4c 11 80       	push   $0x80114c60
80105725:	e8 26 ed ff ff       	call   80104450 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010572a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010572d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105730:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  while(ticks - ticks0 < n){
80105736:	85 d2                	test   %edx,%edx
80105738:	75 27                	jne    80105761 <sys_sleep+0x61>
8010573a:	eb 54                	jmp    80105790 <sys_sleep+0x90>
8010573c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105740:	83 ec 08             	sub    $0x8,%esp
80105743:	68 60 4c 11 80       	push   $0x80114c60
80105748:	68 a0 54 11 80       	push   $0x801154a0
8010574d:	e8 9e e7 ff ff       	call   80103ef0 <sleep>
  while(ticks - ticks0 < n){
80105752:	a1 a0 54 11 80       	mov    0x801154a0,%eax
80105757:	83 c4 10             	add    $0x10,%esp
8010575a:	29 d8                	sub    %ebx,%eax
8010575c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010575f:	73 2f                	jae    80105790 <sys_sleep+0x90>
    if(myproc()->killed){
80105761:	e8 1a e2 ff ff       	call   80103980 <myproc>
80105766:	8b 40 24             	mov    0x24(%eax),%eax
80105769:	85 c0                	test   %eax,%eax
8010576b:	74 d3                	je     80105740 <sys_sleep+0x40>
      release(&tickslock);
8010576d:	83 ec 0c             	sub    $0xc,%esp
80105770:	68 60 4c 11 80       	push   $0x80114c60
80105775:	e8 f6 ed ff ff       	call   80104570 <release>
      return -1;
8010577a:	83 c4 10             	add    $0x10,%esp
8010577d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105782:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105785:	c9                   	leave  
80105786:	c3                   	ret    
80105787:	89 f6                	mov    %esi,%esi
80105789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105790:	83 ec 0c             	sub    $0xc,%esp
80105793:	68 60 4c 11 80       	push   $0x80114c60
80105798:	e8 d3 ed ff ff       	call   80104570 <release>
  return 0;
8010579d:	83 c4 10             	add    $0x10,%esp
801057a0:	31 c0                	xor    %eax,%eax
}
801057a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057a5:	c9                   	leave  
801057a6:	c3                   	ret    
    return -1;
801057a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ac:	eb f4                	jmp    801057a2 <sys_sleep+0xa2>
801057ae:	66 90                	xchg   %ax,%ax

801057b0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
801057b3:	53                   	push   %ebx
801057b4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801057b7:	68 60 4c 11 80       	push   $0x80114c60
801057bc:	e8 8f ec ff ff       	call   80104450 <acquire>
  xticks = ticks;
801057c1:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  release(&tickslock);
801057c7:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801057ce:	e8 9d ed ff ff       	call   80104570 <release>
  return xticks;
}
801057d3:	89 d8                	mov    %ebx,%eax
801057d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057d8:	c9                   	leave  
801057d9:	c3                   	ret    

801057da <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801057da:	1e                   	push   %ds
  pushl %es
801057db:	06                   	push   %es
  pushl %fs
801057dc:	0f a0                	push   %fs
  pushl %gs
801057de:	0f a8                	push   %gs
  pushal
801057e0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801057e1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801057e5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801057e7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801057e9:	54                   	push   %esp
  call trap
801057ea:	e8 c1 00 00 00       	call   801058b0 <trap>
  addl $4, %esp
801057ef:	83 c4 04             	add    $0x4,%esp

801057f2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801057f2:	61                   	popa   
  popl %gs
801057f3:	0f a9                	pop    %gs
  popl %fs
801057f5:	0f a1                	pop    %fs
  popl %es
801057f7:	07                   	pop    %es
  popl %ds
801057f8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801057f9:	83 c4 08             	add    $0x8,%esp
  iret
801057fc:	cf                   	iret   
801057fd:	66 90                	xchg   %ax,%ax
801057ff:	90                   	nop

80105800 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105800:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105801:	31 c0                	xor    %eax,%eax
{
80105803:	89 e5                	mov    %esp,%ebp
80105805:	83 ec 08             	sub    $0x8,%esp
80105808:	90                   	nop
80105809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105810:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105817:	c7 04 c5 a2 4c 11 80 	movl   $0x8e000008,-0x7feeb35e(,%eax,8)
8010581e:	08 00 00 8e 
80105822:	66 89 14 c5 a0 4c 11 	mov    %dx,-0x7feeb360(,%eax,8)
80105829:	80 
8010582a:	c1 ea 10             	shr    $0x10,%edx
8010582d:	66 89 14 c5 a6 4c 11 	mov    %dx,-0x7feeb35a(,%eax,8)
80105834:	80 
  for(i = 0; i < 256; i++)
80105835:	83 c0 01             	add    $0x1,%eax
80105838:	3d 00 01 00 00       	cmp    $0x100,%eax
8010583d:	75 d1                	jne    80105810 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010583f:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105844:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105847:	c7 05 a2 4e 11 80 08 	movl   $0xef000008,0x80114ea2
8010584e:	00 00 ef 
  initlock(&tickslock, "time");
80105851:	68 a1 78 10 80       	push   $0x801078a1
80105856:	68 60 4c 11 80       	push   $0x80114c60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010585b:	66 a3 a0 4e 11 80    	mov    %ax,0x80114ea0
80105861:	c1 e8 10             	shr    $0x10,%eax
80105864:	66 a3 a6 4e 11 80    	mov    %ax,0x80114ea6
  initlock(&tickslock, "time");
8010586a:	e8 f1 ea ff ff       	call   80104360 <initlock>
}
8010586f:	83 c4 10             	add    $0x10,%esp
80105872:	c9                   	leave  
80105873:	c3                   	ret    
80105874:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010587a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105880 <idtinit>:

void
idtinit(void)
{
80105880:	55                   	push   %ebp
  pd[0] = size-1;
80105881:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105886:	89 e5                	mov    %esp,%ebp
80105888:	83 ec 10             	sub    $0x10,%esp
8010588b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010588f:	b8 a0 4c 11 80       	mov    $0x80114ca0,%eax
80105894:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105898:	c1 e8 10             	shr    $0x10,%eax
8010589b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010589f:	8d 45 fa             	lea    -0x6(%ebp),%eax
801058a2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801058a5:	c9                   	leave  
801058a6:	c3                   	ret    
801058a7:	89 f6                	mov    %esi,%esi
801058a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058b0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	57                   	push   %edi
801058b4:	56                   	push   %esi
801058b5:	53                   	push   %ebx
801058b6:	83 ec 1c             	sub    $0x1c,%esp
801058b9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801058bc:	8b 47 30             	mov    0x30(%edi),%eax
801058bf:	83 f8 40             	cmp    $0x40,%eax
801058c2:	0f 84 f0 00 00 00    	je     801059b8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801058c8:	83 e8 0e             	sub    $0xe,%eax
801058cb:	83 f8 31             	cmp    $0x31,%eax
801058ce:	77 10                	ja     801058e0 <trap+0x30>
801058d0:	ff 24 85 48 79 10 80 	jmp    *-0x7fef86b8(,%eax,4)
801058d7:	89 f6                	mov    %esi,%esi
801058d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801058e0:	e8 9b e0 ff ff       	call   80103980 <myproc>
801058e5:	85 c0                	test   %eax,%eax
801058e7:	8b 5f 38             	mov    0x38(%edi),%ebx
801058ea:	0f 84 04 02 00 00    	je     80105af4 <trap+0x244>
801058f0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801058f4:	0f 84 fa 01 00 00    	je     80105af4 <trap+0x244>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801058fa:	0f 20 d1             	mov    %cr2,%ecx
801058fd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105900:	e8 5b e0 ff ff       	call   80103960 <cpuid>
80105905:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105908:	8b 47 34             	mov    0x34(%edi),%eax
8010590b:	8b 77 30             	mov    0x30(%edi),%esi
8010590e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105911:	e8 6a e0 ff ff       	call   80103980 <myproc>
80105916:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105919:	e8 62 e0 ff ff       	call   80103980 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010591e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105921:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105924:	51                   	push   %ecx
80105925:	53                   	push   %ebx
80105926:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105927:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010592a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010592d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010592e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105931:	52                   	push   %edx
80105932:	ff 70 10             	pushl  0x10(%eax)
80105935:	68 04 79 10 80       	push   $0x80107904
8010593a:	e8 41 ad ff ff       	call   80100680 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010593f:	83 c4 20             	add    $0x20,%esp
80105942:	e8 39 e0 ff ff       	call   80103980 <myproc>
80105947:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010594e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105950:	e8 2b e0 ff ff       	call   80103980 <myproc>
80105955:	85 c0                	test   %eax,%eax
80105957:	74 1d                	je     80105976 <trap+0xc6>
80105959:	e8 22 e0 ff ff       	call   80103980 <myproc>
8010595e:	8b 50 24             	mov    0x24(%eax),%edx
80105961:	85 d2                	test   %edx,%edx
80105963:	74 11                	je     80105976 <trap+0xc6>
80105965:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105969:	83 e0 03             	and    $0x3,%eax
8010596c:	66 83 f8 03          	cmp    $0x3,%ax
80105970:	0f 84 3a 01 00 00    	je     80105ab0 <trap+0x200>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105976:	e8 05 e0 ff ff       	call   80103980 <myproc>
8010597b:	85 c0                	test   %eax,%eax
8010597d:	74 0b                	je     8010598a <trap+0xda>
8010597f:	e8 fc df ff ff       	call   80103980 <myproc>
80105984:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105988:	74 66                	je     801059f0 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010598a:	e8 f1 df ff ff       	call   80103980 <myproc>
8010598f:	85 c0                	test   %eax,%eax
80105991:	74 19                	je     801059ac <trap+0xfc>
80105993:	e8 e8 df ff ff       	call   80103980 <myproc>
80105998:	8b 40 24             	mov    0x24(%eax),%eax
8010599b:	85 c0                	test   %eax,%eax
8010599d:	74 0d                	je     801059ac <trap+0xfc>
8010599f:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801059a3:	83 e0 03             	and    $0x3,%eax
801059a6:	66 83 f8 03          	cmp    $0x3,%ax
801059aa:	74 35                	je     801059e1 <trap+0x131>
    exit();
}
801059ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059af:	5b                   	pop    %ebx
801059b0:	5e                   	pop    %esi
801059b1:	5f                   	pop    %edi
801059b2:	5d                   	pop    %ebp
801059b3:	c3                   	ret    
801059b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
801059b8:	e8 c3 df ff ff       	call   80103980 <myproc>
801059bd:	8b 58 24             	mov    0x24(%eax),%ebx
801059c0:	85 db                	test   %ebx,%ebx
801059c2:	0f 85 d8 00 00 00    	jne    80105aa0 <trap+0x1f0>
    myproc()->tf = tf;
801059c8:	e8 b3 df ff ff       	call   80103980 <myproc>
801059cd:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
801059d0:	e8 eb ef ff ff       	call   801049c0 <syscall>
    if(myproc()->killed)
801059d5:	e8 a6 df ff ff       	call   80103980 <myproc>
801059da:	8b 48 24             	mov    0x24(%eax),%ecx
801059dd:	85 c9                	test   %ecx,%ecx
801059df:	74 cb                	je     801059ac <trap+0xfc>
}
801059e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059e4:	5b                   	pop    %ebx
801059e5:	5e                   	pop    %esi
801059e6:	5f                   	pop    %edi
801059e7:	5d                   	pop    %ebp
      exit();
801059e8:	e9 83 e3 ff ff       	jmp    80103d70 <exit>
801059ed:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
801059f0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801059f4:	75 94                	jne    8010598a <trap+0xda>
    yield();
801059f6:	e8 a5 e4 ff ff       	call   80103ea0 <yield>
801059fb:	eb 8d                	jmp    8010598a <trap+0xda>
801059fd:	8d 76 00             	lea    0x0(%esi),%esi
  	handle_pgfault();
80105a00:	e8 6b 01 00 00       	call   80105b70 <handle_pgfault>
  	break;
80105a05:	e9 46 ff ff ff       	jmp    80105950 <trap+0xa0>
80105a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105a10:	e8 4b df ff ff       	call   80103960 <cpuid>
80105a15:	85 c0                	test   %eax,%eax
80105a17:	0f 84 a3 00 00 00    	je     80105ac0 <trap+0x210>
    lapiceoi();
80105a1d:	e8 ce ce ff ff       	call   801028f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a22:	e8 59 df ff ff       	call   80103980 <myproc>
80105a27:	85 c0                	test   %eax,%eax
80105a29:	0f 85 2a ff ff ff    	jne    80105959 <trap+0xa9>
80105a2f:	e9 42 ff ff ff       	jmp    80105976 <trap+0xc6>
80105a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105a38:	e8 73 cd ff ff       	call   801027b0 <kbdintr>
    lapiceoi();
80105a3d:	e8 ae ce ff ff       	call   801028f0 <lapiceoi>
    break;
80105a42:	e9 09 ff ff ff       	jmp    80105950 <trap+0xa0>
80105a47:	89 f6                	mov    %esi,%esi
80105a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    uartintr();
80105a50:	e8 ab 02 00 00       	call   80105d00 <uartintr>
    lapiceoi();
80105a55:	e8 96 ce ff ff       	call   801028f0 <lapiceoi>
    break;
80105a5a:	e9 f1 fe ff ff       	jmp    80105950 <trap+0xa0>
80105a5f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105a60:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105a64:	8b 77 38             	mov    0x38(%edi),%esi
80105a67:	e8 f4 de ff ff       	call   80103960 <cpuid>
80105a6c:	56                   	push   %esi
80105a6d:	53                   	push   %ebx
80105a6e:	50                   	push   %eax
80105a6f:	68 ac 78 10 80       	push   $0x801078ac
80105a74:	e8 07 ac ff ff       	call   80100680 <cprintf>
    lapiceoi();
80105a79:	e8 72 ce ff ff       	call   801028f0 <lapiceoi>
    break;
80105a7e:	83 c4 10             	add    $0x10,%esp
80105a81:	e9 ca fe ff ff       	jmp    80105950 <trap+0xa0>
80105a86:	8d 76 00             	lea    0x0(%esi),%esi
80105a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
80105a90:	e8 8b c7 ff ff       	call   80102220 <ideintr>
80105a95:	eb 86                	jmp    80105a1d <trap+0x16d>
80105a97:	89 f6                	mov    %esi,%esi
80105a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exit();
80105aa0:	e8 cb e2 ff ff       	call   80103d70 <exit>
80105aa5:	e9 1e ff ff ff       	jmp    801059c8 <trap+0x118>
80105aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105ab0:	e8 bb e2 ff ff       	call   80103d70 <exit>
80105ab5:	e9 bc fe ff ff       	jmp    80105976 <trap+0xc6>
80105aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105ac0:	83 ec 0c             	sub    $0xc,%esp
80105ac3:	68 60 4c 11 80       	push   $0x80114c60
80105ac8:	e8 83 e9 ff ff       	call   80104450 <acquire>
      wakeup(&ticks);
80105acd:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
      ticks++;
80105ad4:	83 05 a0 54 11 80 01 	addl   $0x1,0x801154a0
      wakeup(&ticks);
80105adb:	e8 d0 e5 ff ff       	call   801040b0 <wakeup>
      release(&tickslock);
80105ae0:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105ae7:	e8 84 ea ff ff       	call   80104570 <release>
80105aec:	83 c4 10             	add    $0x10,%esp
80105aef:	e9 29 ff ff ff       	jmp    80105a1d <trap+0x16d>
80105af4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105af7:	e8 64 de ff ff       	call   80103960 <cpuid>
80105afc:	83 ec 0c             	sub    $0xc,%esp
80105aff:	56                   	push   %esi
80105b00:	53                   	push   %ebx
80105b01:	50                   	push   %eax
80105b02:	ff 77 30             	pushl  0x30(%edi)
80105b05:	68 d0 78 10 80       	push   $0x801078d0
80105b0a:	e8 71 ab ff ff       	call   80100680 <cprintf>
      panic("trap");
80105b0f:	83 c4 14             	add    $0x14,%esp
80105b12:	68 a6 78 10 80       	push   $0x801078a6
80105b17:	e8 94 a8 ff ff       	call   801003b0 <panic>
80105b1c:	66 90                	xchg   %ax,%ax
80105b1e:	66 90                	xchg   %ax,%ax

80105b20 <swap_page_from_pte>:
 * to the disk blocks and save the block-id into the
 * pte.
 */
void
swap_page_from_pte(pte_t *pte)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
}
80105b23:	5d                   	pop    %ebp
80105b24:	c3                   	ret    
80105b25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b30 <swap_page>:

/* Select a victim and swap the contents to the disk.
 */
int
swap_page(pde_t *pgdir)
{
80105b30:	55                   	push   %ebp
80105b31:	89 e5                	mov    %esp,%ebp
80105b33:	83 ec 14             	sub    $0x14,%esp
	panic("swap_page is not implemented");
80105b36:	68 10 7a 10 80       	push   $0x80107a10
80105b3b:	e8 70 a8 ff ff       	call   801003b0 <panic>

80105b40 <map_address>:
 * restore the content of the page from the swapped
 * block and free the swapped block.
 */
void
map_address(pde_t *pgdir, uint addr)
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	83 ec 14             	sub    $0x14,%esp
	
	uint b=balloc_page(ROOTDEV);
80105b46:	6a 01                	push   $0x1
80105b48:	e8 83 b9 ff ff       	call   801014d0 <balloc_page>
	bfree_page(ROOTDEV,b);
80105b4d:	5a                   	pop    %edx
80105b4e:	59                   	pop    %ecx
80105b4f:	50                   	push   %eax
80105b50:	6a 01                	push   $0x1
80105b52:	e8 89 ba ff ff       	call   801015e0 <bfree_page>
	// cprintf("abc\n");	
	panic("map_address is not implemented");
80105b57:	c7 04 24 30 7a 10 80 	movl   $0x80107a30,(%esp)
80105b5e:	e8 4d a8 ff ff       	call   801003b0 <panic>
80105b63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b70 <handle_pgfault>:
}

/* page fault handler */
void
handle_pgfault()
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	83 ec 08             	sub    $0x8,%esp
	unsigned addr;
	struct proc *curproc = myproc();
80105b76:	e8 05 de ff ff       	call   80103980 <myproc>

	asm volatile ("movl %%cr2, %0 \n\t" : "=r" (addr));
80105b7b:	0f 20 d2             	mov    %cr2,%edx
	addr &= ~0xfff;
	map_address(curproc->pgdir, addr);
80105b7e:	83 ec 08             	sub    $0x8,%esp
	addr &= ~0xfff;
80105b81:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	map_address(curproc->pgdir, addr);
80105b87:	52                   	push   %edx
80105b88:	ff 70 04             	pushl  0x4(%eax)
80105b8b:	e8 b0 ff ff ff       	call   80105b40 <map_address>

80105b90 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105b90:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105b95:	55                   	push   %ebp
80105b96:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105b98:	85 c0                	test   %eax,%eax
80105b9a:	74 1c                	je     80105bb8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b9c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ba1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105ba2:	a8 01                	test   $0x1,%al
80105ba4:	74 12                	je     80105bb8 <uartgetc+0x28>
80105ba6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105bab:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105bac:	0f b6 c0             	movzbl %al,%eax
}
80105baf:	5d                   	pop    %ebp
80105bb0:	c3                   	ret    
80105bb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105bb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bbd:	5d                   	pop    %ebp
80105bbe:	c3                   	ret    
80105bbf:	90                   	nop

80105bc0 <uartputc.part.0>:
uartputc(int c)
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
80105bc3:	57                   	push   %edi
80105bc4:	56                   	push   %esi
80105bc5:	53                   	push   %ebx
80105bc6:	89 c7                	mov    %eax,%edi
80105bc8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105bcd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105bd2:	83 ec 0c             	sub    $0xc,%esp
80105bd5:	eb 1b                	jmp    80105bf2 <uartputc.part.0+0x32>
80105bd7:	89 f6                	mov    %esi,%esi
80105bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105be0:	83 ec 0c             	sub    $0xc,%esp
80105be3:	6a 0a                	push   $0xa
80105be5:	e8 26 cd ff ff       	call   80102910 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105bea:	83 c4 10             	add    $0x10,%esp
80105bed:	83 eb 01             	sub    $0x1,%ebx
80105bf0:	74 07                	je     80105bf9 <uartputc.part.0+0x39>
80105bf2:	89 f2                	mov    %esi,%edx
80105bf4:	ec                   	in     (%dx),%al
80105bf5:	a8 20                	test   $0x20,%al
80105bf7:	74 e7                	je     80105be0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105bf9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105bfe:	89 f8                	mov    %edi,%eax
80105c00:	ee                   	out    %al,(%dx)
}
80105c01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c04:	5b                   	pop    %ebx
80105c05:	5e                   	pop    %esi
80105c06:	5f                   	pop    %edi
80105c07:	5d                   	pop    %ebp
80105c08:	c3                   	ret    
80105c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c10 <uartinit>:
{
80105c10:	55                   	push   %ebp
80105c11:	31 c9                	xor    %ecx,%ecx
80105c13:	89 c8                	mov    %ecx,%eax
80105c15:	89 e5                	mov    %esp,%ebp
80105c17:	57                   	push   %edi
80105c18:	56                   	push   %esi
80105c19:	53                   	push   %ebx
80105c1a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105c1f:	89 da                	mov    %ebx,%edx
80105c21:	83 ec 0c             	sub    $0xc,%esp
80105c24:	ee                   	out    %al,(%dx)
80105c25:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105c2a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105c2f:	89 fa                	mov    %edi,%edx
80105c31:	ee                   	out    %al,(%dx)
80105c32:	b8 0c 00 00 00       	mov    $0xc,%eax
80105c37:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c3c:	ee                   	out    %al,(%dx)
80105c3d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105c42:	89 c8                	mov    %ecx,%eax
80105c44:	89 f2                	mov    %esi,%edx
80105c46:	ee                   	out    %al,(%dx)
80105c47:	b8 03 00 00 00       	mov    $0x3,%eax
80105c4c:	89 fa                	mov    %edi,%edx
80105c4e:	ee                   	out    %al,(%dx)
80105c4f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105c54:	89 c8                	mov    %ecx,%eax
80105c56:	ee                   	out    %al,(%dx)
80105c57:	b8 01 00 00 00       	mov    $0x1,%eax
80105c5c:	89 f2                	mov    %esi,%edx
80105c5e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c5f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c64:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105c65:	3c ff                	cmp    $0xff,%al
80105c67:	74 5a                	je     80105cc3 <uartinit+0xb3>
  uart = 1;
80105c69:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105c70:	00 00 00 
80105c73:	89 da                	mov    %ebx,%edx
80105c75:	ec                   	in     (%dx),%al
80105c76:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c7b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105c7c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105c7f:	bb 4f 7a 10 80       	mov    $0x80107a4f,%ebx
  ioapicenable(IRQ_COM1, 0);
80105c84:	6a 00                	push   $0x0
80105c86:	6a 04                	push   $0x4
80105c88:	e8 e3 c7 ff ff       	call   80102470 <ioapicenable>
80105c8d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105c90:	b8 78 00 00 00       	mov    $0x78,%eax
80105c95:	eb 13                	jmp    80105caa <uartinit+0x9a>
80105c97:	89 f6                	mov    %esi,%esi
80105c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105ca0:	83 c3 01             	add    $0x1,%ebx
80105ca3:	0f be 03             	movsbl (%ebx),%eax
80105ca6:	84 c0                	test   %al,%al
80105ca8:	74 19                	je     80105cc3 <uartinit+0xb3>
  if(!uart)
80105caa:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105cb0:	85 d2                	test   %edx,%edx
80105cb2:	74 ec                	je     80105ca0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80105cb4:	83 c3 01             	add    $0x1,%ebx
80105cb7:	e8 04 ff ff ff       	call   80105bc0 <uartputc.part.0>
80105cbc:	0f be 03             	movsbl (%ebx),%eax
80105cbf:	84 c0                	test   %al,%al
80105cc1:	75 e7                	jne    80105caa <uartinit+0x9a>
}
80105cc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cc6:	5b                   	pop    %ebx
80105cc7:	5e                   	pop    %esi
80105cc8:	5f                   	pop    %edi
80105cc9:	5d                   	pop    %ebp
80105cca:	c3                   	ret    
80105ccb:	90                   	nop
80105ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105cd0 <uartputc>:
  if(!uart)
80105cd0:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105cd6:	55                   	push   %ebp
80105cd7:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105cd9:	85 d2                	test   %edx,%edx
{
80105cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105cde:	74 10                	je     80105cf0 <uartputc+0x20>
}
80105ce0:	5d                   	pop    %ebp
80105ce1:	e9 da fe ff ff       	jmp    80105bc0 <uartputc.part.0>
80105ce6:	8d 76 00             	lea    0x0(%esi),%esi
80105ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105cf0:	5d                   	pop    %ebp
80105cf1:	c3                   	ret    
80105cf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d00 <uartintr>:

void
uartintr(void)
{
80105d00:	55                   	push   %ebp
80105d01:	89 e5                	mov    %esp,%ebp
80105d03:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105d06:	68 90 5b 10 80       	push   $0x80105b90
80105d0b:	e8 20 ab ff ff       	call   80100830 <consoleintr>
}
80105d10:	83 c4 10             	add    $0x10,%esp
80105d13:	c9                   	leave  
80105d14:	c3                   	ret    

80105d15 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105d15:	6a 00                	push   $0x0
  pushl $0
80105d17:	6a 00                	push   $0x0
  jmp alltraps
80105d19:	e9 bc fa ff ff       	jmp    801057da <alltraps>

80105d1e <vector1>:
.globl vector1
vector1:
  pushl $0
80105d1e:	6a 00                	push   $0x0
  pushl $1
80105d20:	6a 01                	push   $0x1
  jmp alltraps
80105d22:	e9 b3 fa ff ff       	jmp    801057da <alltraps>

80105d27 <vector2>:
.globl vector2
vector2:
  pushl $0
80105d27:	6a 00                	push   $0x0
  pushl $2
80105d29:	6a 02                	push   $0x2
  jmp alltraps
80105d2b:	e9 aa fa ff ff       	jmp    801057da <alltraps>

80105d30 <vector3>:
.globl vector3
vector3:
  pushl $0
80105d30:	6a 00                	push   $0x0
  pushl $3
80105d32:	6a 03                	push   $0x3
  jmp alltraps
80105d34:	e9 a1 fa ff ff       	jmp    801057da <alltraps>

80105d39 <vector4>:
.globl vector4
vector4:
  pushl $0
80105d39:	6a 00                	push   $0x0
  pushl $4
80105d3b:	6a 04                	push   $0x4
  jmp alltraps
80105d3d:	e9 98 fa ff ff       	jmp    801057da <alltraps>

80105d42 <vector5>:
.globl vector5
vector5:
  pushl $0
80105d42:	6a 00                	push   $0x0
  pushl $5
80105d44:	6a 05                	push   $0x5
  jmp alltraps
80105d46:	e9 8f fa ff ff       	jmp    801057da <alltraps>

80105d4b <vector6>:
.globl vector6
vector6:
  pushl $0
80105d4b:	6a 00                	push   $0x0
  pushl $6
80105d4d:	6a 06                	push   $0x6
  jmp alltraps
80105d4f:	e9 86 fa ff ff       	jmp    801057da <alltraps>

80105d54 <vector7>:
.globl vector7
vector7:
  pushl $0
80105d54:	6a 00                	push   $0x0
  pushl $7
80105d56:	6a 07                	push   $0x7
  jmp alltraps
80105d58:	e9 7d fa ff ff       	jmp    801057da <alltraps>

80105d5d <vector8>:
.globl vector8
vector8:
  pushl $8
80105d5d:	6a 08                	push   $0x8
  jmp alltraps
80105d5f:	e9 76 fa ff ff       	jmp    801057da <alltraps>

80105d64 <vector9>:
.globl vector9
vector9:
  pushl $0
80105d64:	6a 00                	push   $0x0
  pushl $9
80105d66:	6a 09                	push   $0x9
  jmp alltraps
80105d68:	e9 6d fa ff ff       	jmp    801057da <alltraps>

80105d6d <vector10>:
.globl vector10
vector10:
  pushl $10
80105d6d:	6a 0a                	push   $0xa
  jmp alltraps
80105d6f:	e9 66 fa ff ff       	jmp    801057da <alltraps>

80105d74 <vector11>:
.globl vector11
vector11:
  pushl $11
80105d74:	6a 0b                	push   $0xb
  jmp alltraps
80105d76:	e9 5f fa ff ff       	jmp    801057da <alltraps>

80105d7b <vector12>:
.globl vector12
vector12:
  pushl $12
80105d7b:	6a 0c                	push   $0xc
  jmp alltraps
80105d7d:	e9 58 fa ff ff       	jmp    801057da <alltraps>

80105d82 <vector13>:
.globl vector13
vector13:
  pushl $13
80105d82:	6a 0d                	push   $0xd
  jmp alltraps
80105d84:	e9 51 fa ff ff       	jmp    801057da <alltraps>

80105d89 <vector14>:
.globl vector14
vector14:
  pushl $14
80105d89:	6a 0e                	push   $0xe
  jmp alltraps
80105d8b:	e9 4a fa ff ff       	jmp    801057da <alltraps>

80105d90 <vector15>:
.globl vector15
vector15:
  pushl $0
80105d90:	6a 00                	push   $0x0
  pushl $15
80105d92:	6a 0f                	push   $0xf
  jmp alltraps
80105d94:	e9 41 fa ff ff       	jmp    801057da <alltraps>

80105d99 <vector16>:
.globl vector16
vector16:
  pushl $0
80105d99:	6a 00                	push   $0x0
  pushl $16
80105d9b:	6a 10                	push   $0x10
  jmp alltraps
80105d9d:	e9 38 fa ff ff       	jmp    801057da <alltraps>

80105da2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105da2:	6a 11                	push   $0x11
  jmp alltraps
80105da4:	e9 31 fa ff ff       	jmp    801057da <alltraps>

80105da9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105da9:	6a 00                	push   $0x0
  pushl $18
80105dab:	6a 12                	push   $0x12
  jmp alltraps
80105dad:	e9 28 fa ff ff       	jmp    801057da <alltraps>

80105db2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105db2:	6a 00                	push   $0x0
  pushl $19
80105db4:	6a 13                	push   $0x13
  jmp alltraps
80105db6:	e9 1f fa ff ff       	jmp    801057da <alltraps>

80105dbb <vector20>:
.globl vector20
vector20:
  pushl $0
80105dbb:	6a 00                	push   $0x0
  pushl $20
80105dbd:	6a 14                	push   $0x14
  jmp alltraps
80105dbf:	e9 16 fa ff ff       	jmp    801057da <alltraps>

80105dc4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105dc4:	6a 00                	push   $0x0
  pushl $21
80105dc6:	6a 15                	push   $0x15
  jmp alltraps
80105dc8:	e9 0d fa ff ff       	jmp    801057da <alltraps>

80105dcd <vector22>:
.globl vector22
vector22:
  pushl $0
80105dcd:	6a 00                	push   $0x0
  pushl $22
80105dcf:	6a 16                	push   $0x16
  jmp alltraps
80105dd1:	e9 04 fa ff ff       	jmp    801057da <alltraps>

80105dd6 <vector23>:
.globl vector23
vector23:
  pushl $0
80105dd6:	6a 00                	push   $0x0
  pushl $23
80105dd8:	6a 17                	push   $0x17
  jmp alltraps
80105dda:	e9 fb f9 ff ff       	jmp    801057da <alltraps>

80105ddf <vector24>:
.globl vector24
vector24:
  pushl $0
80105ddf:	6a 00                	push   $0x0
  pushl $24
80105de1:	6a 18                	push   $0x18
  jmp alltraps
80105de3:	e9 f2 f9 ff ff       	jmp    801057da <alltraps>

80105de8 <vector25>:
.globl vector25
vector25:
  pushl $0
80105de8:	6a 00                	push   $0x0
  pushl $25
80105dea:	6a 19                	push   $0x19
  jmp alltraps
80105dec:	e9 e9 f9 ff ff       	jmp    801057da <alltraps>

80105df1 <vector26>:
.globl vector26
vector26:
  pushl $0
80105df1:	6a 00                	push   $0x0
  pushl $26
80105df3:	6a 1a                	push   $0x1a
  jmp alltraps
80105df5:	e9 e0 f9 ff ff       	jmp    801057da <alltraps>

80105dfa <vector27>:
.globl vector27
vector27:
  pushl $0
80105dfa:	6a 00                	push   $0x0
  pushl $27
80105dfc:	6a 1b                	push   $0x1b
  jmp alltraps
80105dfe:	e9 d7 f9 ff ff       	jmp    801057da <alltraps>

80105e03 <vector28>:
.globl vector28
vector28:
  pushl $0
80105e03:	6a 00                	push   $0x0
  pushl $28
80105e05:	6a 1c                	push   $0x1c
  jmp alltraps
80105e07:	e9 ce f9 ff ff       	jmp    801057da <alltraps>

80105e0c <vector29>:
.globl vector29
vector29:
  pushl $0
80105e0c:	6a 00                	push   $0x0
  pushl $29
80105e0e:	6a 1d                	push   $0x1d
  jmp alltraps
80105e10:	e9 c5 f9 ff ff       	jmp    801057da <alltraps>

80105e15 <vector30>:
.globl vector30
vector30:
  pushl $0
80105e15:	6a 00                	push   $0x0
  pushl $30
80105e17:	6a 1e                	push   $0x1e
  jmp alltraps
80105e19:	e9 bc f9 ff ff       	jmp    801057da <alltraps>

80105e1e <vector31>:
.globl vector31
vector31:
  pushl $0
80105e1e:	6a 00                	push   $0x0
  pushl $31
80105e20:	6a 1f                	push   $0x1f
  jmp alltraps
80105e22:	e9 b3 f9 ff ff       	jmp    801057da <alltraps>

80105e27 <vector32>:
.globl vector32
vector32:
  pushl $0
80105e27:	6a 00                	push   $0x0
  pushl $32
80105e29:	6a 20                	push   $0x20
  jmp alltraps
80105e2b:	e9 aa f9 ff ff       	jmp    801057da <alltraps>

80105e30 <vector33>:
.globl vector33
vector33:
  pushl $0
80105e30:	6a 00                	push   $0x0
  pushl $33
80105e32:	6a 21                	push   $0x21
  jmp alltraps
80105e34:	e9 a1 f9 ff ff       	jmp    801057da <alltraps>

80105e39 <vector34>:
.globl vector34
vector34:
  pushl $0
80105e39:	6a 00                	push   $0x0
  pushl $34
80105e3b:	6a 22                	push   $0x22
  jmp alltraps
80105e3d:	e9 98 f9 ff ff       	jmp    801057da <alltraps>

80105e42 <vector35>:
.globl vector35
vector35:
  pushl $0
80105e42:	6a 00                	push   $0x0
  pushl $35
80105e44:	6a 23                	push   $0x23
  jmp alltraps
80105e46:	e9 8f f9 ff ff       	jmp    801057da <alltraps>

80105e4b <vector36>:
.globl vector36
vector36:
  pushl $0
80105e4b:	6a 00                	push   $0x0
  pushl $36
80105e4d:	6a 24                	push   $0x24
  jmp alltraps
80105e4f:	e9 86 f9 ff ff       	jmp    801057da <alltraps>

80105e54 <vector37>:
.globl vector37
vector37:
  pushl $0
80105e54:	6a 00                	push   $0x0
  pushl $37
80105e56:	6a 25                	push   $0x25
  jmp alltraps
80105e58:	e9 7d f9 ff ff       	jmp    801057da <alltraps>

80105e5d <vector38>:
.globl vector38
vector38:
  pushl $0
80105e5d:	6a 00                	push   $0x0
  pushl $38
80105e5f:	6a 26                	push   $0x26
  jmp alltraps
80105e61:	e9 74 f9 ff ff       	jmp    801057da <alltraps>

80105e66 <vector39>:
.globl vector39
vector39:
  pushl $0
80105e66:	6a 00                	push   $0x0
  pushl $39
80105e68:	6a 27                	push   $0x27
  jmp alltraps
80105e6a:	e9 6b f9 ff ff       	jmp    801057da <alltraps>

80105e6f <vector40>:
.globl vector40
vector40:
  pushl $0
80105e6f:	6a 00                	push   $0x0
  pushl $40
80105e71:	6a 28                	push   $0x28
  jmp alltraps
80105e73:	e9 62 f9 ff ff       	jmp    801057da <alltraps>

80105e78 <vector41>:
.globl vector41
vector41:
  pushl $0
80105e78:	6a 00                	push   $0x0
  pushl $41
80105e7a:	6a 29                	push   $0x29
  jmp alltraps
80105e7c:	e9 59 f9 ff ff       	jmp    801057da <alltraps>

80105e81 <vector42>:
.globl vector42
vector42:
  pushl $0
80105e81:	6a 00                	push   $0x0
  pushl $42
80105e83:	6a 2a                	push   $0x2a
  jmp alltraps
80105e85:	e9 50 f9 ff ff       	jmp    801057da <alltraps>

80105e8a <vector43>:
.globl vector43
vector43:
  pushl $0
80105e8a:	6a 00                	push   $0x0
  pushl $43
80105e8c:	6a 2b                	push   $0x2b
  jmp alltraps
80105e8e:	e9 47 f9 ff ff       	jmp    801057da <alltraps>

80105e93 <vector44>:
.globl vector44
vector44:
  pushl $0
80105e93:	6a 00                	push   $0x0
  pushl $44
80105e95:	6a 2c                	push   $0x2c
  jmp alltraps
80105e97:	e9 3e f9 ff ff       	jmp    801057da <alltraps>

80105e9c <vector45>:
.globl vector45
vector45:
  pushl $0
80105e9c:	6a 00                	push   $0x0
  pushl $45
80105e9e:	6a 2d                	push   $0x2d
  jmp alltraps
80105ea0:	e9 35 f9 ff ff       	jmp    801057da <alltraps>

80105ea5 <vector46>:
.globl vector46
vector46:
  pushl $0
80105ea5:	6a 00                	push   $0x0
  pushl $46
80105ea7:	6a 2e                	push   $0x2e
  jmp alltraps
80105ea9:	e9 2c f9 ff ff       	jmp    801057da <alltraps>

80105eae <vector47>:
.globl vector47
vector47:
  pushl $0
80105eae:	6a 00                	push   $0x0
  pushl $47
80105eb0:	6a 2f                	push   $0x2f
  jmp alltraps
80105eb2:	e9 23 f9 ff ff       	jmp    801057da <alltraps>

80105eb7 <vector48>:
.globl vector48
vector48:
  pushl $0
80105eb7:	6a 00                	push   $0x0
  pushl $48
80105eb9:	6a 30                	push   $0x30
  jmp alltraps
80105ebb:	e9 1a f9 ff ff       	jmp    801057da <alltraps>

80105ec0 <vector49>:
.globl vector49
vector49:
  pushl $0
80105ec0:	6a 00                	push   $0x0
  pushl $49
80105ec2:	6a 31                	push   $0x31
  jmp alltraps
80105ec4:	e9 11 f9 ff ff       	jmp    801057da <alltraps>

80105ec9 <vector50>:
.globl vector50
vector50:
  pushl $0
80105ec9:	6a 00                	push   $0x0
  pushl $50
80105ecb:	6a 32                	push   $0x32
  jmp alltraps
80105ecd:	e9 08 f9 ff ff       	jmp    801057da <alltraps>

80105ed2 <vector51>:
.globl vector51
vector51:
  pushl $0
80105ed2:	6a 00                	push   $0x0
  pushl $51
80105ed4:	6a 33                	push   $0x33
  jmp alltraps
80105ed6:	e9 ff f8 ff ff       	jmp    801057da <alltraps>

80105edb <vector52>:
.globl vector52
vector52:
  pushl $0
80105edb:	6a 00                	push   $0x0
  pushl $52
80105edd:	6a 34                	push   $0x34
  jmp alltraps
80105edf:	e9 f6 f8 ff ff       	jmp    801057da <alltraps>

80105ee4 <vector53>:
.globl vector53
vector53:
  pushl $0
80105ee4:	6a 00                	push   $0x0
  pushl $53
80105ee6:	6a 35                	push   $0x35
  jmp alltraps
80105ee8:	e9 ed f8 ff ff       	jmp    801057da <alltraps>

80105eed <vector54>:
.globl vector54
vector54:
  pushl $0
80105eed:	6a 00                	push   $0x0
  pushl $54
80105eef:	6a 36                	push   $0x36
  jmp alltraps
80105ef1:	e9 e4 f8 ff ff       	jmp    801057da <alltraps>

80105ef6 <vector55>:
.globl vector55
vector55:
  pushl $0
80105ef6:	6a 00                	push   $0x0
  pushl $55
80105ef8:	6a 37                	push   $0x37
  jmp alltraps
80105efa:	e9 db f8 ff ff       	jmp    801057da <alltraps>

80105eff <vector56>:
.globl vector56
vector56:
  pushl $0
80105eff:	6a 00                	push   $0x0
  pushl $56
80105f01:	6a 38                	push   $0x38
  jmp alltraps
80105f03:	e9 d2 f8 ff ff       	jmp    801057da <alltraps>

80105f08 <vector57>:
.globl vector57
vector57:
  pushl $0
80105f08:	6a 00                	push   $0x0
  pushl $57
80105f0a:	6a 39                	push   $0x39
  jmp alltraps
80105f0c:	e9 c9 f8 ff ff       	jmp    801057da <alltraps>

80105f11 <vector58>:
.globl vector58
vector58:
  pushl $0
80105f11:	6a 00                	push   $0x0
  pushl $58
80105f13:	6a 3a                	push   $0x3a
  jmp alltraps
80105f15:	e9 c0 f8 ff ff       	jmp    801057da <alltraps>

80105f1a <vector59>:
.globl vector59
vector59:
  pushl $0
80105f1a:	6a 00                	push   $0x0
  pushl $59
80105f1c:	6a 3b                	push   $0x3b
  jmp alltraps
80105f1e:	e9 b7 f8 ff ff       	jmp    801057da <alltraps>

80105f23 <vector60>:
.globl vector60
vector60:
  pushl $0
80105f23:	6a 00                	push   $0x0
  pushl $60
80105f25:	6a 3c                	push   $0x3c
  jmp alltraps
80105f27:	e9 ae f8 ff ff       	jmp    801057da <alltraps>

80105f2c <vector61>:
.globl vector61
vector61:
  pushl $0
80105f2c:	6a 00                	push   $0x0
  pushl $61
80105f2e:	6a 3d                	push   $0x3d
  jmp alltraps
80105f30:	e9 a5 f8 ff ff       	jmp    801057da <alltraps>

80105f35 <vector62>:
.globl vector62
vector62:
  pushl $0
80105f35:	6a 00                	push   $0x0
  pushl $62
80105f37:	6a 3e                	push   $0x3e
  jmp alltraps
80105f39:	e9 9c f8 ff ff       	jmp    801057da <alltraps>

80105f3e <vector63>:
.globl vector63
vector63:
  pushl $0
80105f3e:	6a 00                	push   $0x0
  pushl $63
80105f40:	6a 3f                	push   $0x3f
  jmp alltraps
80105f42:	e9 93 f8 ff ff       	jmp    801057da <alltraps>

80105f47 <vector64>:
.globl vector64
vector64:
  pushl $0
80105f47:	6a 00                	push   $0x0
  pushl $64
80105f49:	6a 40                	push   $0x40
  jmp alltraps
80105f4b:	e9 8a f8 ff ff       	jmp    801057da <alltraps>

80105f50 <vector65>:
.globl vector65
vector65:
  pushl $0
80105f50:	6a 00                	push   $0x0
  pushl $65
80105f52:	6a 41                	push   $0x41
  jmp alltraps
80105f54:	e9 81 f8 ff ff       	jmp    801057da <alltraps>

80105f59 <vector66>:
.globl vector66
vector66:
  pushl $0
80105f59:	6a 00                	push   $0x0
  pushl $66
80105f5b:	6a 42                	push   $0x42
  jmp alltraps
80105f5d:	e9 78 f8 ff ff       	jmp    801057da <alltraps>

80105f62 <vector67>:
.globl vector67
vector67:
  pushl $0
80105f62:	6a 00                	push   $0x0
  pushl $67
80105f64:	6a 43                	push   $0x43
  jmp alltraps
80105f66:	e9 6f f8 ff ff       	jmp    801057da <alltraps>

80105f6b <vector68>:
.globl vector68
vector68:
  pushl $0
80105f6b:	6a 00                	push   $0x0
  pushl $68
80105f6d:	6a 44                	push   $0x44
  jmp alltraps
80105f6f:	e9 66 f8 ff ff       	jmp    801057da <alltraps>

80105f74 <vector69>:
.globl vector69
vector69:
  pushl $0
80105f74:	6a 00                	push   $0x0
  pushl $69
80105f76:	6a 45                	push   $0x45
  jmp alltraps
80105f78:	e9 5d f8 ff ff       	jmp    801057da <alltraps>

80105f7d <vector70>:
.globl vector70
vector70:
  pushl $0
80105f7d:	6a 00                	push   $0x0
  pushl $70
80105f7f:	6a 46                	push   $0x46
  jmp alltraps
80105f81:	e9 54 f8 ff ff       	jmp    801057da <alltraps>

80105f86 <vector71>:
.globl vector71
vector71:
  pushl $0
80105f86:	6a 00                	push   $0x0
  pushl $71
80105f88:	6a 47                	push   $0x47
  jmp alltraps
80105f8a:	e9 4b f8 ff ff       	jmp    801057da <alltraps>

80105f8f <vector72>:
.globl vector72
vector72:
  pushl $0
80105f8f:	6a 00                	push   $0x0
  pushl $72
80105f91:	6a 48                	push   $0x48
  jmp alltraps
80105f93:	e9 42 f8 ff ff       	jmp    801057da <alltraps>

80105f98 <vector73>:
.globl vector73
vector73:
  pushl $0
80105f98:	6a 00                	push   $0x0
  pushl $73
80105f9a:	6a 49                	push   $0x49
  jmp alltraps
80105f9c:	e9 39 f8 ff ff       	jmp    801057da <alltraps>

80105fa1 <vector74>:
.globl vector74
vector74:
  pushl $0
80105fa1:	6a 00                	push   $0x0
  pushl $74
80105fa3:	6a 4a                	push   $0x4a
  jmp alltraps
80105fa5:	e9 30 f8 ff ff       	jmp    801057da <alltraps>

80105faa <vector75>:
.globl vector75
vector75:
  pushl $0
80105faa:	6a 00                	push   $0x0
  pushl $75
80105fac:	6a 4b                	push   $0x4b
  jmp alltraps
80105fae:	e9 27 f8 ff ff       	jmp    801057da <alltraps>

80105fb3 <vector76>:
.globl vector76
vector76:
  pushl $0
80105fb3:	6a 00                	push   $0x0
  pushl $76
80105fb5:	6a 4c                	push   $0x4c
  jmp alltraps
80105fb7:	e9 1e f8 ff ff       	jmp    801057da <alltraps>

80105fbc <vector77>:
.globl vector77
vector77:
  pushl $0
80105fbc:	6a 00                	push   $0x0
  pushl $77
80105fbe:	6a 4d                	push   $0x4d
  jmp alltraps
80105fc0:	e9 15 f8 ff ff       	jmp    801057da <alltraps>

80105fc5 <vector78>:
.globl vector78
vector78:
  pushl $0
80105fc5:	6a 00                	push   $0x0
  pushl $78
80105fc7:	6a 4e                	push   $0x4e
  jmp alltraps
80105fc9:	e9 0c f8 ff ff       	jmp    801057da <alltraps>

80105fce <vector79>:
.globl vector79
vector79:
  pushl $0
80105fce:	6a 00                	push   $0x0
  pushl $79
80105fd0:	6a 4f                	push   $0x4f
  jmp alltraps
80105fd2:	e9 03 f8 ff ff       	jmp    801057da <alltraps>

80105fd7 <vector80>:
.globl vector80
vector80:
  pushl $0
80105fd7:	6a 00                	push   $0x0
  pushl $80
80105fd9:	6a 50                	push   $0x50
  jmp alltraps
80105fdb:	e9 fa f7 ff ff       	jmp    801057da <alltraps>

80105fe0 <vector81>:
.globl vector81
vector81:
  pushl $0
80105fe0:	6a 00                	push   $0x0
  pushl $81
80105fe2:	6a 51                	push   $0x51
  jmp alltraps
80105fe4:	e9 f1 f7 ff ff       	jmp    801057da <alltraps>

80105fe9 <vector82>:
.globl vector82
vector82:
  pushl $0
80105fe9:	6a 00                	push   $0x0
  pushl $82
80105feb:	6a 52                	push   $0x52
  jmp alltraps
80105fed:	e9 e8 f7 ff ff       	jmp    801057da <alltraps>

80105ff2 <vector83>:
.globl vector83
vector83:
  pushl $0
80105ff2:	6a 00                	push   $0x0
  pushl $83
80105ff4:	6a 53                	push   $0x53
  jmp alltraps
80105ff6:	e9 df f7 ff ff       	jmp    801057da <alltraps>

80105ffb <vector84>:
.globl vector84
vector84:
  pushl $0
80105ffb:	6a 00                	push   $0x0
  pushl $84
80105ffd:	6a 54                	push   $0x54
  jmp alltraps
80105fff:	e9 d6 f7 ff ff       	jmp    801057da <alltraps>

80106004 <vector85>:
.globl vector85
vector85:
  pushl $0
80106004:	6a 00                	push   $0x0
  pushl $85
80106006:	6a 55                	push   $0x55
  jmp alltraps
80106008:	e9 cd f7 ff ff       	jmp    801057da <alltraps>

8010600d <vector86>:
.globl vector86
vector86:
  pushl $0
8010600d:	6a 00                	push   $0x0
  pushl $86
8010600f:	6a 56                	push   $0x56
  jmp alltraps
80106011:	e9 c4 f7 ff ff       	jmp    801057da <alltraps>

80106016 <vector87>:
.globl vector87
vector87:
  pushl $0
80106016:	6a 00                	push   $0x0
  pushl $87
80106018:	6a 57                	push   $0x57
  jmp alltraps
8010601a:	e9 bb f7 ff ff       	jmp    801057da <alltraps>

8010601f <vector88>:
.globl vector88
vector88:
  pushl $0
8010601f:	6a 00                	push   $0x0
  pushl $88
80106021:	6a 58                	push   $0x58
  jmp alltraps
80106023:	e9 b2 f7 ff ff       	jmp    801057da <alltraps>

80106028 <vector89>:
.globl vector89
vector89:
  pushl $0
80106028:	6a 00                	push   $0x0
  pushl $89
8010602a:	6a 59                	push   $0x59
  jmp alltraps
8010602c:	e9 a9 f7 ff ff       	jmp    801057da <alltraps>

80106031 <vector90>:
.globl vector90
vector90:
  pushl $0
80106031:	6a 00                	push   $0x0
  pushl $90
80106033:	6a 5a                	push   $0x5a
  jmp alltraps
80106035:	e9 a0 f7 ff ff       	jmp    801057da <alltraps>

8010603a <vector91>:
.globl vector91
vector91:
  pushl $0
8010603a:	6a 00                	push   $0x0
  pushl $91
8010603c:	6a 5b                	push   $0x5b
  jmp alltraps
8010603e:	e9 97 f7 ff ff       	jmp    801057da <alltraps>

80106043 <vector92>:
.globl vector92
vector92:
  pushl $0
80106043:	6a 00                	push   $0x0
  pushl $92
80106045:	6a 5c                	push   $0x5c
  jmp alltraps
80106047:	e9 8e f7 ff ff       	jmp    801057da <alltraps>

8010604c <vector93>:
.globl vector93
vector93:
  pushl $0
8010604c:	6a 00                	push   $0x0
  pushl $93
8010604e:	6a 5d                	push   $0x5d
  jmp alltraps
80106050:	e9 85 f7 ff ff       	jmp    801057da <alltraps>

80106055 <vector94>:
.globl vector94
vector94:
  pushl $0
80106055:	6a 00                	push   $0x0
  pushl $94
80106057:	6a 5e                	push   $0x5e
  jmp alltraps
80106059:	e9 7c f7 ff ff       	jmp    801057da <alltraps>

8010605e <vector95>:
.globl vector95
vector95:
  pushl $0
8010605e:	6a 00                	push   $0x0
  pushl $95
80106060:	6a 5f                	push   $0x5f
  jmp alltraps
80106062:	e9 73 f7 ff ff       	jmp    801057da <alltraps>

80106067 <vector96>:
.globl vector96
vector96:
  pushl $0
80106067:	6a 00                	push   $0x0
  pushl $96
80106069:	6a 60                	push   $0x60
  jmp alltraps
8010606b:	e9 6a f7 ff ff       	jmp    801057da <alltraps>

80106070 <vector97>:
.globl vector97
vector97:
  pushl $0
80106070:	6a 00                	push   $0x0
  pushl $97
80106072:	6a 61                	push   $0x61
  jmp alltraps
80106074:	e9 61 f7 ff ff       	jmp    801057da <alltraps>

80106079 <vector98>:
.globl vector98
vector98:
  pushl $0
80106079:	6a 00                	push   $0x0
  pushl $98
8010607b:	6a 62                	push   $0x62
  jmp alltraps
8010607d:	e9 58 f7 ff ff       	jmp    801057da <alltraps>

80106082 <vector99>:
.globl vector99
vector99:
  pushl $0
80106082:	6a 00                	push   $0x0
  pushl $99
80106084:	6a 63                	push   $0x63
  jmp alltraps
80106086:	e9 4f f7 ff ff       	jmp    801057da <alltraps>

8010608b <vector100>:
.globl vector100
vector100:
  pushl $0
8010608b:	6a 00                	push   $0x0
  pushl $100
8010608d:	6a 64                	push   $0x64
  jmp alltraps
8010608f:	e9 46 f7 ff ff       	jmp    801057da <alltraps>

80106094 <vector101>:
.globl vector101
vector101:
  pushl $0
80106094:	6a 00                	push   $0x0
  pushl $101
80106096:	6a 65                	push   $0x65
  jmp alltraps
80106098:	e9 3d f7 ff ff       	jmp    801057da <alltraps>

8010609d <vector102>:
.globl vector102
vector102:
  pushl $0
8010609d:	6a 00                	push   $0x0
  pushl $102
8010609f:	6a 66                	push   $0x66
  jmp alltraps
801060a1:	e9 34 f7 ff ff       	jmp    801057da <alltraps>

801060a6 <vector103>:
.globl vector103
vector103:
  pushl $0
801060a6:	6a 00                	push   $0x0
  pushl $103
801060a8:	6a 67                	push   $0x67
  jmp alltraps
801060aa:	e9 2b f7 ff ff       	jmp    801057da <alltraps>

801060af <vector104>:
.globl vector104
vector104:
  pushl $0
801060af:	6a 00                	push   $0x0
  pushl $104
801060b1:	6a 68                	push   $0x68
  jmp alltraps
801060b3:	e9 22 f7 ff ff       	jmp    801057da <alltraps>

801060b8 <vector105>:
.globl vector105
vector105:
  pushl $0
801060b8:	6a 00                	push   $0x0
  pushl $105
801060ba:	6a 69                	push   $0x69
  jmp alltraps
801060bc:	e9 19 f7 ff ff       	jmp    801057da <alltraps>

801060c1 <vector106>:
.globl vector106
vector106:
  pushl $0
801060c1:	6a 00                	push   $0x0
  pushl $106
801060c3:	6a 6a                	push   $0x6a
  jmp alltraps
801060c5:	e9 10 f7 ff ff       	jmp    801057da <alltraps>

801060ca <vector107>:
.globl vector107
vector107:
  pushl $0
801060ca:	6a 00                	push   $0x0
  pushl $107
801060cc:	6a 6b                	push   $0x6b
  jmp alltraps
801060ce:	e9 07 f7 ff ff       	jmp    801057da <alltraps>

801060d3 <vector108>:
.globl vector108
vector108:
  pushl $0
801060d3:	6a 00                	push   $0x0
  pushl $108
801060d5:	6a 6c                	push   $0x6c
  jmp alltraps
801060d7:	e9 fe f6 ff ff       	jmp    801057da <alltraps>

801060dc <vector109>:
.globl vector109
vector109:
  pushl $0
801060dc:	6a 00                	push   $0x0
  pushl $109
801060de:	6a 6d                	push   $0x6d
  jmp alltraps
801060e0:	e9 f5 f6 ff ff       	jmp    801057da <alltraps>

801060e5 <vector110>:
.globl vector110
vector110:
  pushl $0
801060e5:	6a 00                	push   $0x0
  pushl $110
801060e7:	6a 6e                	push   $0x6e
  jmp alltraps
801060e9:	e9 ec f6 ff ff       	jmp    801057da <alltraps>

801060ee <vector111>:
.globl vector111
vector111:
  pushl $0
801060ee:	6a 00                	push   $0x0
  pushl $111
801060f0:	6a 6f                	push   $0x6f
  jmp alltraps
801060f2:	e9 e3 f6 ff ff       	jmp    801057da <alltraps>

801060f7 <vector112>:
.globl vector112
vector112:
  pushl $0
801060f7:	6a 00                	push   $0x0
  pushl $112
801060f9:	6a 70                	push   $0x70
  jmp alltraps
801060fb:	e9 da f6 ff ff       	jmp    801057da <alltraps>

80106100 <vector113>:
.globl vector113
vector113:
  pushl $0
80106100:	6a 00                	push   $0x0
  pushl $113
80106102:	6a 71                	push   $0x71
  jmp alltraps
80106104:	e9 d1 f6 ff ff       	jmp    801057da <alltraps>

80106109 <vector114>:
.globl vector114
vector114:
  pushl $0
80106109:	6a 00                	push   $0x0
  pushl $114
8010610b:	6a 72                	push   $0x72
  jmp alltraps
8010610d:	e9 c8 f6 ff ff       	jmp    801057da <alltraps>

80106112 <vector115>:
.globl vector115
vector115:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $115
80106114:	6a 73                	push   $0x73
  jmp alltraps
80106116:	e9 bf f6 ff ff       	jmp    801057da <alltraps>

8010611b <vector116>:
.globl vector116
vector116:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $116
8010611d:	6a 74                	push   $0x74
  jmp alltraps
8010611f:	e9 b6 f6 ff ff       	jmp    801057da <alltraps>

80106124 <vector117>:
.globl vector117
vector117:
  pushl $0
80106124:	6a 00                	push   $0x0
  pushl $117
80106126:	6a 75                	push   $0x75
  jmp alltraps
80106128:	e9 ad f6 ff ff       	jmp    801057da <alltraps>

8010612d <vector118>:
.globl vector118
vector118:
  pushl $0
8010612d:	6a 00                	push   $0x0
  pushl $118
8010612f:	6a 76                	push   $0x76
  jmp alltraps
80106131:	e9 a4 f6 ff ff       	jmp    801057da <alltraps>

80106136 <vector119>:
.globl vector119
vector119:
  pushl $0
80106136:	6a 00                	push   $0x0
  pushl $119
80106138:	6a 77                	push   $0x77
  jmp alltraps
8010613a:	e9 9b f6 ff ff       	jmp    801057da <alltraps>

8010613f <vector120>:
.globl vector120
vector120:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $120
80106141:	6a 78                	push   $0x78
  jmp alltraps
80106143:	e9 92 f6 ff ff       	jmp    801057da <alltraps>

80106148 <vector121>:
.globl vector121
vector121:
  pushl $0
80106148:	6a 00                	push   $0x0
  pushl $121
8010614a:	6a 79                	push   $0x79
  jmp alltraps
8010614c:	e9 89 f6 ff ff       	jmp    801057da <alltraps>

80106151 <vector122>:
.globl vector122
vector122:
  pushl $0
80106151:	6a 00                	push   $0x0
  pushl $122
80106153:	6a 7a                	push   $0x7a
  jmp alltraps
80106155:	e9 80 f6 ff ff       	jmp    801057da <alltraps>

8010615a <vector123>:
.globl vector123
vector123:
  pushl $0
8010615a:	6a 00                	push   $0x0
  pushl $123
8010615c:	6a 7b                	push   $0x7b
  jmp alltraps
8010615e:	e9 77 f6 ff ff       	jmp    801057da <alltraps>

80106163 <vector124>:
.globl vector124
vector124:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $124
80106165:	6a 7c                	push   $0x7c
  jmp alltraps
80106167:	e9 6e f6 ff ff       	jmp    801057da <alltraps>

8010616c <vector125>:
.globl vector125
vector125:
  pushl $0
8010616c:	6a 00                	push   $0x0
  pushl $125
8010616e:	6a 7d                	push   $0x7d
  jmp alltraps
80106170:	e9 65 f6 ff ff       	jmp    801057da <alltraps>

80106175 <vector126>:
.globl vector126
vector126:
  pushl $0
80106175:	6a 00                	push   $0x0
  pushl $126
80106177:	6a 7e                	push   $0x7e
  jmp alltraps
80106179:	e9 5c f6 ff ff       	jmp    801057da <alltraps>

8010617e <vector127>:
.globl vector127
vector127:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $127
80106180:	6a 7f                	push   $0x7f
  jmp alltraps
80106182:	e9 53 f6 ff ff       	jmp    801057da <alltraps>

80106187 <vector128>:
.globl vector128
vector128:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $128
80106189:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010618e:	e9 47 f6 ff ff       	jmp    801057da <alltraps>

80106193 <vector129>:
.globl vector129
vector129:
  pushl $0
80106193:	6a 00                	push   $0x0
  pushl $129
80106195:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010619a:	e9 3b f6 ff ff       	jmp    801057da <alltraps>

8010619f <vector130>:
.globl vector130
vector130:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $130
801061a1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801061a6:	e9 2f f6 ff ff       	jmp    801057da <alltraps>

801061ab <vector131>:
.globl vector131
vector131:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $131
801061ad:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801061b2:	e9 23 f6 ff ff       	jmp    801057da <alltraps>

801061b7 <vector132>:
.globl vector132
vector132:
  pushl $0
801061b7:	6a 00                	push   $0x0
  pushl $132
801061b9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801061be:	e9 17 f6 ff ff       	jmp    801057da <alltraps>

801061c3 <vector133>:
.globl vector133
vector133:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $133
801061c5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801061ca:	e9 0b f6 ff ff       	jmp    801057da <alltraps>

801061cf <vector134>:
.globl vector134
vector134:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $134
801061d1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801061d6:	e9 ff f5 ff ff       	jmp    801057da <alltraps>

801061db <vector135>:
.globl vector135
vector135:
  pushl $0
801061db:	6a 00                	push   $0x0
  pushl $135
801061dd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801061e2:	e9 f3 f5 ff ff       	jmp    801057da <alltraps>

801061e7 <vector136>:
.globl vector136
vector136:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $136
801061e9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801061ee:	e9 e7 f5 ff ff       	jmp    801057da <alltraps>

801061f3 <vector137>:
.globl vector137
vector137:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $137
801061f5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801061fa:	e9 db f5 ff ff       	jmp    801057da <alltraps>

801061ff <vector138>:
.globl vector138
vector138:
  pushl $0
801061ff:	6a 00                	push   $0x0
  pushl $138
80106201:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106206:	e9 cf f5 ff ff       	jmp    801057da <alltraps>

8010620b <vector139>:
.globl vector139
vector139:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $139
8010620d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106212:	e9 c3 f5 ff ff       	jmp    801057da <alltraps>

80106217 <vector140>:
.globl vector140
vector140:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $140
80106219:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010621e:	e9 b7 f5 ff ff       	jmp    801057da <alltraps>

80106223 <vector141>:
.globl vector141
vector141:
  pushl $0
80106223:	6a 00                	push   $0x0
  pushl $141
80106225:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010622a:	e9 ab f5 ff ff       	jmp    801057da <alltraps>

8010622f <vector142>:
.globl vector142
vector142:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $142
80106231:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106236:	e9 9f f5 ff ff       	jmp    801057da <alltraps>

8010623b <vector143>:
.globl vector143
vector143:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $143
8010623d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106242:	e9 93 f5 ff ff       	jmp    801057da <alltraps>

80106247 <vector144>:
.globl vector144
vector144:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $144
80106249:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010624e:	e9 87 f5 ff ff       	jmp    801057da <alltraps>

80106253 <vector145>:
.globl vector145
vector145:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $145
80106255:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010625a:	e9 7b f5 ff ff       	jmp    801057da <alltraps>

8010625f <vector146>:
.globl vector146
vector146:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $146
80106261:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106266:	e9 6f f5 ff ff       	jmp    801057da <alltraps>

8010626b <vector147>:
.globl vector147
vector147:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $147
8010626d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106272:	e9 63 f5 ff ff       	jmp    801057da <alltraps>

80106277 <vector148>:
.globl vector148
vector148:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $148
80106279:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010627e:	e9 57 f5 ff ff       	jmp    801057da <alltraps>

80106283 <vector149>:
.globl vector149
vector149:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $149
80106285:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010628a:	e9 4b f5 ff ff       	jmp    801057da <alltraps>

8010628f <vector150>:
.globl vector150
vector150:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $150
80106291:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106296:	e9 3f f5 ff ff       	jmp    801057da <alltraps>

8010629b <vector151>:
.globl vector151
vector151:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $151
8010629d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801062a2:	e9 33 f5 ff ff       	jmp    801057da <alltraps>

801062a7 <vector152>:
.globl vector152
vector152:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $152
801062a9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801062ae:	e9 27 f5 ff ff       	jmp    801057da <alltraps>

801062b3 <vector153>:
.globl vector153
vector153:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $153
801062b5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801062ba:	e9 1b f5 ff ff       	jmp    801057da <alltraps>

801062bf <vector154>:
.globl vector154
vector154:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $154
801062c1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801062c6:	e9 0f f5 ff ff       	jmp    801057da <alltraps>

801062cb <vector155>:
.globl vector155
vector155:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $155
801062cd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801062d2:	e9 03 f5 ff ff       	jmp    801057da <alltraps>

801062d7 <vector156>:
.globl vector156
vector156:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $156
801062d9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801062de:	e9 f7 f4 ff ff       	jmp    801057da <alltraps>

801062e3 <vector157>:
.globl vector157
vector157:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $157
801062e5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801062ea:	e9 eb f4 ff ff       	jmp    801057da <alltraps>

801062ef <vector158>:
.globl vector158
vector158:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $158
801062f1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801062f6:	e9 df f4 ff ff       	jmp    801057da <alltraps>

801062fb <vector159>:
.globl vector159
vector159:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $159
801062fd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106302:	e9 d3 f4 ff ff       	jmp    801057da <alltraps>

80106307 <vector160>:
.globl vector160
vector160:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $160
80106309:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010630e:	e9 c7 f4 ff ff       	jmp    801057da <alltraps>

80106313 <vector161>:
.globl vector161
vector161:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $161
80106315:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010631a:	e9 bb f4 ff ff       	jmp    801057da <alltraps>

8010631f <vector162>:
.globl vector162
vector162:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $162
80106321:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106326:	e9 af f4 ff ff       	jmp    801057da <alltraps>

8010632b <vector163>:
.globl vector163
vector163:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $163
8010632d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106332:	e9 a3 f4 ff ff       	jmp    801057da <alltraps>

80106337 <vector164>:
.globl vector164
vector164:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $164
80106339:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010633e:	e9 97 f4 ff ff       	jmp    801057da <alltraps>

80106343 <vector165>:
.globl vector165
vector165:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $165
80106345:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010634a:	e9 8b f4 ff ff       	jmp    801057da <alltraps>

8010634f <vector166>:
.globl vector166
vector166:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $166
80106351:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106356:	e9 7f f4 ff ff       	jmp    801057da <alltraps>

8010635b <vector167>:
.globl vector167
vector167:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $167
8010635d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106362:	e9 73 f4 ff ff       	jmp    801057da <alltraps>

80106367 <vector168>:
.globl vector168
vector168:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $168
80106369:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010636e:	e9 67 f4 ff ff       	jmp    801057da <alltraps>

80106373 <vector169>:
.globl vector169
vector169:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $169
80106375:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010637a:	e9 5b f4 ff ff       	jmp    801057da <alltraps>

8010637f <vector170>:
.globl vector170
vector170:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $170
80106381:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106386:	e9 4f f4 ff ff       	jmp    801057da <alltraps>

8010638b <vector171>:
.globl vector171
vector171:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $171
8010638d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106392:	e9 43 f4 ff ff       	jmp    801057da <alltraps>

80106397 <vector172>:
.globl vector172
vector172:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $172
80106399:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010639e:	e9 37 f4 ff ff       	jmp    801057da <alltraps>

801063a3 <vector173>:
.globl vector173
vector173:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $173
801063a5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801063aa:	e9 2b f4 ff ff       	jmp    801057da <alltraps>

801063af <vector174>:
.globl vector174
vector174:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $174
801063b1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801063b6:	e9 1f f4 ff ff       	jmp    801057da <alltraps>

801063bb <vector175>:
.globl vector175
vector175:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $175
801063bd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801063c2:	e9 13 f4 ff ff       	jmp    801057da <alltraps>

801063c7 <vector176>:
.globl vector176
vector176:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $176
801063c9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801063ce:	e9 07 f4 ff ff       	jmp    801057da <alltraps>

801063d3 <vector177>:
.globl vector177
vector177:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $177
801063d5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801063da:	e9 fb f3 ff ff       	jmp    801057da <alltraps>

801063df <vector178>:
.globl vector178
vector178:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $178
801063e1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801063e6:	e9 ef f3 ff ff       	jmp    801057da <alltraps>

801063eb <vector179>:
.globl vector179
vector179:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $179
801063ed:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801063f2:	e9 e3 f3 ff ff       	jmp    801057da <alltraps>

801063f7 <vector180>:
.globl vector180
vector180:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $180
801063f9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801063fe:	e9 d7 f3 ff ff       	jmp    801057da <alltraps>

80106403 <vector181>:
.globl vector181
vector181:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $181
80106405:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010640a:	e9 cb f3 ff ff       	jmp    801057da <alltraps>

8010640f <vector182>:
.globl vector182
vector182:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $182
80106411:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106416:	e9 bf f3 ff ff       	jmp    801057da <alltraps>

8010641b <vector183>:
.globl vector183
vector183:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $183
8010641d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106422:	e9 b3 f3 ff ff       	jmp    801057da <alltraps>

80106427 <vector184>:
.globl vector184
vector184:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $184
80106429:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010642e:	e9 a7 f3 ff ff       	jmp    801057da <alltraps>

80106433 <vector185>:
.globl vector185
vector185:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $185
80106435:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010643a:	e9 9b f3 ff ff       	jmp    801057da <alltraps>

8010643f <vector186>:
.globl vector186
vector186:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $186
80106441:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106446:	e9 8f f3 ff ff       	jmp    801057da <alltraps>

8010644b <vector187>:
.globl vector187
vector187:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $187
8010644d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106452:	e9 83 f3 ff ff       	jmp    801057da <alltraps>

80106457 <vector188>:
.globl vector188
vector188:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $188
80106459:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010645e:	e9 77 f3 ff ff       	jmp    801057da <alltraps>

80106463 <vector189>:
.globl vector189
vector189:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $189
80106465:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010646a:	e9 6b f3 ff ff       	jmp    801057da <alltraps>

8010646f <vector190>:
.globl vector190
vector190:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $190
80106471:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106476:	e9 5f f3 ff ff       	jmp    801057da <alltraps>

8010647b <vector191>:
.globl vector191
vector191:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $191
8010647d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106482:	e9 53 f3 ff ff       	jmp    801057da <alltraps>

80106487 <vector192>:
.globl vector192
vector192:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $192
80106489:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010648e:	e9 47 f3 ff ff       	jmp    801057da <alltraps>

80106493 <vector193>:
.globl vector193
vector193:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $193
80106495:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010649a:	e9 3b f3 ff ff       	jmp    801057da <alltraps>

8010649f <vector194>:
.globl vector194
vector194:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $194
801064a1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801064a6:	e9 2f f3 ff ff       	jmp    801057da <alltraps>

801064ab <vector195>:
.globl vector195
vector195:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $195
801064ad:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801064b2:	e9 23 f3 ff ff       	jmp    801057da <alltraps>

801064b7 <vector196>:
.globl vector196
vector196:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $196
801064b9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801064be:	e9 17 f3 ff ff       	jmp    801057da <alltraps>

801064c3 <vector197>:
.globl vector197
vector197:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $197
801064c5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801064ca:	e9 0b f3 ff ff       	jmp    801057da <alltraps>

801064cf <vector198>:
.globl vector198
vector198:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $198
801064d1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801064d6:	e9 ff f2 ff ff       	jmp    801057da <alltraps>

801064db <vector199>:
.globl vector199
vector199:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $199
801064dd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801064e2:	e9 f3 f2 ff ff       	jmp    801057da <alltraps>

801064e7 <vector200>:
.globl vector200
vector200:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $200
801064e9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801064ee:	e9 e7 f2 ff ff       	jmp    801057da <alltraps>

801064f3 <vector201>:
.globl vector201
vector201:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $201
801064f5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801064fa:	e9 db f2 ff ff       	jmp    801057da <alltraps>

801064ff <vector202>:
.globl vector202
vector202:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $202
80106501:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106506:	e9 cf f2 ff ff       	jmp    801057da <alltraps>

8010650b <vector203>:
.globl vector203
vector203:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $203
8010650d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106512:	e9 c3 f2 ff ff       	jmp    801057da <alltraps>

80106517 <vector204>:
.globl vector204
vector204:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $204
80106519:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010651e:	e9 b7 f2 ff ff       	jmp    801057da <alltraps>

80106523 <vector205>:
.globl vector205
vector205:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $205
80106525:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010652a:	e9 ab f2 ff ff       	jmp    801057da <alltraps>

8010652f <vector206>:
.globl vector206
vector206:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $206
80106531:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106536:	e9 9f f2 ff ff       	jmp    801057da <alltraps>

8010653b <vector207>:
.globl vector207
vector207:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $207
8010653d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106542:	e9 93 f2 ff ff       	jmp    801057da <alltraps>

80106547 <vector208>:
.globl vector208
vector208:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $208
80106549:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010654e:	e9 87 f2 ff ff       	jmp    801057da <alltraps>

80106553 <vector209>:
.globl vector209
vector209:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $209
80106555:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010655a:	e9 7b f2 ff ff       	jmp    801057da <alltraps>

8010655f <vector210>:
.globl vector210
vector210:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $210
80106561:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106566:	e9 6f f2 ff ff       	jmp    801057da <alltraps>

8010656b <vector211>:
.globl vector211
vector211:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $211
8010656d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106572:	e9 63 f2 ff ff       	jmp    801057da <alltraps>

80106577 <vector212>:
.globl vector212
vector212:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $212
80106579:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010657e:	e9 57 f2 ff ff       	jmp    801057da <alltraps>

80106583 <vector213>:
.globl vector213
vector213:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $213
80106585:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010658a:	e9 4b f2 ff ff       	jmp    801057da <alltraps>

8010658f <vector214>:
.globl vector214
vector214:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $214
80106591:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106596:	e9 3f f2 ff ff       	jmp    801057da <alltraps>

8010659b <vector215>:
.globl vector215
vector215:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $215
8010659d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801065a2:	e9 33 f2 ff ff       	jmp    801057da <alltraps>

801065a7 <vector216>:
.globl vector216
vector216:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $216
801065a9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801065ae:	e9 27 f2 ff ff       	jmp    801057da <alltraps>

801065b3 <vector217>:
.globl vector217
vector217:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $217
801065b5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801065ba:	e9 1b f2 ff ff       	jmp    801057da <alltraps>

801065bf <vector218>:
.globl vector218
vector218:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $218
801065c1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801065c6:	e9 0f f2 ff ff       	jmp    801057da <alltraps>

801065cb <vector219>:
.globl vector219
vector219:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $219
801065cd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801065d2:	e9 03 f2 ff ff       	jmp    801057da <alltraps>

801065d7 <vector220>:
.globl vector220
vector220:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $220
801065d9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801065de:	e9 f7 f1 ff ff       	jmp    801057da <alltraps>

801065e3 <vector221>:
.globl vector221
vector221:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $221
801065e5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801065ea:	e9 eb f1 ff ff       	jmp    801057da <alltraps>

801065ef <vector222>:
.globl vector222
vector222:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $222
801065f1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801065f6:	e9 df f1 ff ff       	jmp    801057da <alltraps>

801065fb <vector223>:
.globl vector223
vector223:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $223
801065fd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106602:	e9 d3 f1 ff ff       	jmp    801057da <alltraps>

80106607 <vector224>:
.globl vector224
vector224:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $224
80106609:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010660e:	e9 c7 f1 ff ff       	jmp    801057da <alltraps>

80106613 <vector225>:
.globl vector225
vector225:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $225
80106615:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010661a:	e9 bb f1 ff ff       	jmp    801057da <alltraps>

8010661f <vector226>:
.globl vector226
vector226:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $226
80106621:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106626:	e9 af f1 ff ff       	jmp    801057da <alltraps>

8010662b <vector227>:
.globl vector227
vector227:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $227
8010662d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106632:	e9 a3 f1 ff ff       	jmp    801057da <alltraps>

80106637 <vector228>:
.globl vector228
vector228:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $228
80106639:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010663e:	e9 97 f1 ff ff       	jmp    801057da <alltraps>

80106643 <vector229>:
.globl vector229
vector229:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $229
80106645:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010664a:	e9 8b f1 ff ff       	jmp    801057da <alltraps>

8010664f <vector230>:
.globl vector230
vector230:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $230
80106651:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106656:	e9 7f f1 ff ff       	jmp    801057da <alltraps>

8010665b <vector231>:
.globl vector231
vector231:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $231
8010665d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106662:	e9 73 f1 ff ff       	jmp    801057da <alltraps>

80106667 <vector232>:
.globl vector232
vector232:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $232
80106669:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010666e:	e9 67 f1 ff ff       	jmp    801057da <alltraps>

80106673 <vector233>:
.globl vector233
vector233:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $233
80106675:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010667a:	e9 5b f1 ff ff       	jmp    801057da <alltraps>

8010667f <vector234>:
.globl vector234
vector234:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $234
80106681:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106686:	e9 4f f1 ff ff       	jmp    801057da <alltraps>

8010668b <vector235>:
.globl vector235
vector235:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $235
8010668d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106692:	e9 43 f1 ff ff       	jmp    801057da <alltraps>

80106697 <vector236>:
.globl vector236
vector236:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $236
80106699:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010669e:	e9 37 f1 ff ff       	jmp    801057da <alltraps>

801066a3 <vector237>:
.globl vector237
vector237:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $237
801066a5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801066aa:	e9 2b f1 ff ff       	jmp    801057da <alltraps>

801066af <vector238>:
.globl vector238
vector238:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $238
801066b1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801066b6:	e9 1f f1 ff ff       	jmp    801057da <alltraps>

801066bb <vector239>:
.globl vector239
vector239:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $239
801066bd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801066c2:	e9 13 f1 ff ff       	jmp    801057da <alltraps>

801066c7 <vector240>:
.globl vector240
vector240:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $240
801066c9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801066ce:	e9 07 f1 ff ff       	jmp    801057da <alltraps>

801066d3 <vector241>:
.globl vector241
vector241:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $241
801066d5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801066da:	e9 fb f0 ff ff       	jmp    801057da <alltraps>

801066df <vector242>:
.globl vector242
vector242:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $242
801066e1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801066e6:	e9 ef f0 ff ff       	jmp    801057da <alltraps>

801066eb <vector243>:
.globl vector243
vector243:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $243
801066ed:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801066f2:	e9 e3 f0 ff ff       	jmp    801057da <alltraps>

801066f7 <vector244>:
.globl vector244
vector244:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $244
801066f9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801066fe:	e9 d7 f0 ff ff       	jmp    801057da <alltraps>

80106703 <vector245>:
.globl vector245
vector245:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $245
80106705:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010670a:	e9 cb f0 ff ff       	jmp    801057da <alltraps>

8010670f <vector246>:
.globl vector246
vector246:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $246
80106711:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106716:	e9 bf f0 ff ff       	jmp    801057da <alltraps>

8010671b <vector247>:
.globl vector247
vector247:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $247
8010671d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106722:	e9 b3 f0 ff ff       	jmp    801057da <alltraps>

80106727 <vector248>:
.globl vector248
vector248:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $248
80106729:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010672e:	e9 a7 f0 ff ff       	jmp    801057da <alltraps>

80106733 <vector249>:
.globl vector249
vector249:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $249
80106735:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010673a:	e9 9b f0 ff ff       	jmp    801057da <alltraps>

8010673f <vector250>:
.globl vector250
vector250:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $250
80106741:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106746:	e9 8f f0 ff ff       	jmp    801057da <alltraps>

8010674b <vector251>:
.globl vector251
vector251:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $251
8010674d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106752:	e9 83 f0 ff ff       	jmp    801057da <alltraps>

80106757 <vector252>:
.globl vector252
vector252:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $252
80106759:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010675e:	e9 77 f0 ff ff       	jmp    801057da <alltraps>

80106763 <vector253>:
.globl vector253
vector253:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $253
80106765:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010676a:	e9 6b f0 ff ff       	jmp    801057da <alltraps>

8010676f <vector254>:
.globl vector254
vector254:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $254
80106771:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106776:	e9 5f f0 ff ff       	jmp    801057da <alltraps>

8010677b <vector255>:
.globl vector255
vector255:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $255
8010677d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106782:	e9 53 f0 ff ff       	jmp    801057da <alltraps>
80106787:	66 90                	xchg   %ax,%ax
80106789:	66 90                	xchg   %ax,%ax
8010678b:	66 90                	xchg   %ax,%ax
8010678d:	66 90                	xchg   %ax,%ax
8010678f:	90                   	nop

80106790 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106790:	55                   	push   %ebp
80106791:	89 e5                	mov    %esp,%ebp
80106793:	57                   	push   %edi
80106794:	56                   	push   %esi
80106795:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106796:	89 d3                	mov    %edx,%ebx
{
80106798:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010679a:	c1 eb 16             	shr    $0x16,%ebx
8010679d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
801067a0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801067a3:	8b 06                	mov    (%esi),%eax
801067a5:	a8 01                	test   $0x1,%al
801067a7:	74 27                	je     801067d0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801067a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801067ae:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801067b4:	c1 ef 0a             	shr    $0xa,%edi
}
801067b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801067ba:	89 fa                	mov    %edi,%edx
801067bc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801067c2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801067c5:	5b                   	pop    %ebx
801067c6:	5e                   	pop    %esi
801067c7:	5f                   	pop    %edi
801067c8:	5d                   	pop    %ebp
801067c9:	c3                   	ret    
801067ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801067d0:	85 c9                	test   %ecx,%ecx
801067d2:	74 2c                	je     80106800 <walkpgdir+0x70>
801067d4:	e8 87 be ff ff       	call   80102660 <kalloc>
801067d9:	85 c0                	test   %eax,%eax
801067db:	89 c3                	mov    %eax,%ebx
801067dd:	74 21                	je     80106800 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801067df:	83 ec 04             	sub    $0x4,%esp
801067e2:	68 00 10 00 00       	push   $0x1000
801067e7:	6a 00                	push   $0x0
801067e9:	50                   	push   %eax
801067ea:	e8 e1 dd ff ff       	call   801045d0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801067ef:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801067f5:	83 c4 10             	add    $0x10,%esp
801067f8:	83 c8 07             	or     $0x7,%eax
801067fb:	89 06                	mov    %eax,(%esi)
801067fd:	eb b5                	jmp    801067b4 <walkpgdir+0x24>
801067ff:	90                   	nop
}
80106800:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106803:	31 c0                	xor    %eax,%eax
}
80106805:	5b                   	pop    %ebx
80106806:	5e                   	pop    %esi
80106807:	5f                   	pop    %edi
80106808:	5d                   	pop    %ebp
80106809:	c3                   	ret    
8010680a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106810 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106810:	55                   	push   %ebp
80106811:	89 e5                	mov    %esp,%ebp
80106813:	57                   	push   %edi
80106814:	56                   	push   %esi
80106815:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106816:	89 d3                	mov    %edx,%ebx
80106818:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010681e:	83 ec 1c             	sub    $0x1c,%esp
80106821:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106824:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106828:	8b 7d 08             	mov    0x8(%ebp),%edi
8010682b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106830:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106833:	8b 45 0c             	mov    0xc(%ebp),%eax
80106836:	29 df                	sub    %ebx,%edi
80106838:	83 c8 01             	or     $0x1,%eax
8010683b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010683e:	eb 15                	jmp    80106855 <mappages+0x45>
    if(*pte & PTE_P)
80106840:	f6 00 01             	testb  $0x1,(%eax)
80106843:	75 45                	jne    8010688a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106845:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106848:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010684b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010684d:	74 31                	je     80106880 <mappages+0x70>
      break;
    a += PGSIZE;
8010684f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106855:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106858:	b9 01 00 00 00       	mov    $0x1,%ecx
8010685d:	89 da                	mov    %ebx,%edx
8010685f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106862:	e8 29 ff ff ff       	call   80106790 <walkpgdir>
80106867:	85 c0                	test   %eax,%eax
80106869:	75 d5                	jne    80106840 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010686b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010686e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106873:	5b                   	pop    %ebx
80106874:	5e                   	pop    %esi
80106875:	5f                   	pop    %edi
80106876:	5d                   	pop    %ebp
80106877:	c3                   	ret    
80106878:	90                   	nop
80106879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106880:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106883:	31 c0                	xor    %eax,%eax
}
80106885:	5b                   	pop    %ebx
80106886:	5e                   	pop    %esi
80106887:	5f                   	pop    %edi
80106888:	5d                   	pop    %ebp
80106889:	c3                   	ret    
      panic("remap");
8010688a:	83 ec 0c             	sub    $0xc,%esp
8010688d:	68 57 7a 10 80       	push   $0x80107a57
80106892:	e8 19 9b ff ff       	call   801003b0 <panic>
80106897:	89 f6                	mov    %esi,%esi
80106899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068a0 <deallocuvm.part.0>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
// If the page was swapped free the corresponding disk block.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801068a0:	55                   	push   %ebp
801068a1:	89 e5                	mov    %esp,%ebp
801068a3:	57                   	push   %edi
801068a4:	56                   	push   %esi
801068a5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801068a6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801068ac:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
801068ae:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801068b4:	83 ec 1c             	sub    $0x1c,%esp
801068b7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801068ba:	39 d3                	cmp    %edx,%ebx
801068bc:	73 66                	jae    80106924 <deallocuvm.part.0+0x84>
801068be:	89 d6                	mov    %edx,%esi
801068c0:	eb 3d                	jmp    801068ff <deallocuvm.part.0+0x5f>
801068c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801068c8:	8b 10                	mov    (%eax),%edx
801068ca:	f6 c2 01             	test   $0x1,%dl
801068cd:	74 26                	je     801068f5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801068cf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801068d5:	74 58                	je     8010692f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801068d7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801068da:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801068e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
801068e3:	52                   	push   %edx
801068e4:	e8 c7 bb ff ff       	call   801024b0 <kfree>
      *pte = 0;
801068e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801068ec:	83 c4 10             	add    $0x10,%esp
801068ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801068f5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068fb:	39 f3                	cmp    %esi,%ebx
801068fd:	73 25                	jae    80106924 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
801068ff:	31 c9                	xor    %ecx,%ecx
80106901:	89 da                	mov    %ebx,%edx
80106903:	89 f8                	mov    %edi,%eax
80106905:	e8 86 fe ff ff       	call   80106790 <walkpgdir>
    if(!pte)
8010690a:	85 c0                	test   %eax,%eax
8010690c:	75 ba                	jne    801068c8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010690e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106914:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010691a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106920:	39 f3                	cmp    %esi,%ebx
80106922:	72 db                	jb     801068ff <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106924:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106927:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010692a:	5b                   	pop    %ebx
8010692b:	5e                   	pop    %esi
8010692c:	5f                   	pop    %edi
8010692d:	5d                   	pop    %ebp
8010692e:	c3                   	ret    
        panic("kfree");
8010692f:	83 ec 0c             	sub    $0xc,%esp
80106932:	68 62 73 10 80       	push   $0x80107362
80106937:	e8 74 9a ff ff       	call   801003b0 <panic>
8010693c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106940 <seginit>:
{
80106940:	55                   	push   %ebp
80106941:	89 e5                	mov    %esp,%ebp
80106943:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106946:	e8 15 d0 ff ff       	call   80103960 <cpuid>
8010694b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106951:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106956:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010695a:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106961:	ff 00 00 
80106964:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
8010696b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010696e:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106975:	ff 00 00 
80106978:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
8010697f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106982:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106989:	ff 00 00 
8010698c:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106993:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106996:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
8010699d:	ff 00 00 
801069a0:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
801069a7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801069aa:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
801069af:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801069b3:	c1 e8 10             	shr    $0x10,%eax
801069b6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801069ba:	8d 45 f2             	lea    -0xe(%ebp),%eax
801069bd:	0f 01 10             	lgdtl  (%eax)
}
801069c0:	c9                   	leave  
801069c1:	c3                   	ret    
801069c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069d0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801069d0:	a1 a4 54 11 80       	mov    0x801154a4,%eax
{
801069d5:	55                   	push   %ebp
801069d6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801069d8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801069dd:	0f 22 d8             	mov    %eax,%cr3
}
801069e0:	5d                   	pop    %ebp
801069e1:	c3                   	ret    
801069e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069f0 <switchuvm>:
{
801069f0:	55                   	push   %ebp
801069f1:	89 e5                	mov    %esp,%ebp
801069f3:	57                   	push   %edi
801069f4:	56                   	push   %esi
801069f5:	53                   	push   %ebx
801069f6:	83 ec 1c             	sub    $0x1c,%esp
801069f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
801069fc:	85 db                	test   %ebx,%ebx
801069fe:	0f 84 cb 00 00 00    	je     80106acf <switchuvm+0xdf>
  if(p->kstack == 0)
80106a04:	8b 43 08             	mov    0x8(%ebx),%eax
80106a07:	85 c0                	test   %eax,%eax
80106a09:	0f 84 da 00 00 00    	je     80106ae9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106a0f:	8b 43 04             	mov    0x4(%ebx),%eax
80106a12:	85 c0                	test   %eax,%eax
80106a14:	0f 84 c2 00 00 00    	je     80106adc <switchuvm+0xec>
  pushcli();
80106a1a:	e8 f1 d9 ff ff       	call   80104410 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106a1f:	e8 bc ce ff ff       	call   801038e0 <mycpu>
80106a24:	89 c6                	mov    %eax,%esi
80106a26:	e8 b5 ce ff ff       	call   801038e0 <mycpu>
80106a2b:	89 c7                	mov    %eax,%edi
80106a2d:	e8 ae ce ff ff       	call   801038e0 <mycpu>
80106a32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a35:	83 c7 08             	add    $0x8,%edi
80106a38:	e8 a3 ce ff ff       	call   801038e0 <mycpu>
80106a3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106a40:	83 c0 08             	add    $0x8,%eax
80106a43:	ba 67 00 00 00       	mov    $0x67,%edx
80106a48:	c1 e8 18             	shr    $0x18,%eax
80106a4b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106a52:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106a59:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106a5f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106a64:	83 c1 08             	add    $0x8,%ecx
80106a67:	c1 e9 10             	shr    $0x10,%ecx
80106a6a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106a70:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106a75:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106a7c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106a81:	e8 5a ce ff ff       	call   801038e0 <mycpu>
80106a86:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106a8d:	e8 4e ce ff ff       	call   801038e0 <mycpu>
80106a92:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106a96:	8b 73 08             	mov    0x8(%ebx),%esi
80106a99:	e8 42 ce ff ff       	call   801038e0 <mycpu>
80106a9e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106aa4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106aa7:	e8 34 ce ff ff       	call   801038e0 <mycpu>
80106aac:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106ab0:	b8 28 00 00 00       	mov    $0x28,%eax
80106ab5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106ab8:	8b 43 04             	mov    0x4(%ebx),%eax
80106abb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ac0:	0f 22 d8             	mov    %eax,%cr3
}
80106ac3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ac6:	5b                   	pop    %ebx
80106ac7:	5e                   	pop    %esi
80106ac8:	5f                   	pop    %edi
80106ac9:	5d                   	pop    %ebp
  popcli();
80106aca:	e9 41 da ff ff       	jmp    80104510 <popcli>
    panic("switchuvm: no process");
80106acf:	83 ec 0c             	sub    $0xc,%esp
80106ad2:	68 5d 7a 10 80       	push   $0x80107a5d
80106ad7:	e8 d4 98 ff ff       	call   801003b0 <panic>
    panic("switchuvm: no pgdir");
80106adc:	83 ec 0c             	sub    $0xc,%esp
80106adf:	68 88 7a 10 80       	push   $0x80107a88
80106ae4:	e8 c7 98 ff ff       	call   801003b0 <panic>
    panic("switchuvm: no kstack");
80106ae9:	83 ec 0c             	sub    $0xc,%esp
80106aec:	68 73 7a 10 80       	push   $0x80107a73
80106af1:	e8 ba 98 ff ff       	call   801003b0 <panic>
80106af6:	8d 76 00             	lea    0x0(%esi),%esi
80106af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b00 <inituvm>:
{
80106b00:	55                   	push   %ebp
80106b01:	89 e5                	mov    %esp,%ebp
80106b03:	57                   	push   %edi
80106b04:	56                   	push   %esi
80106b05:	53                   	push   %ebx
80106b06:	83 ec 1c             	sub    $0x1c,%esp
80106b09:	8b 75 10             	mov    0x10(%ebp),%esi
80106b0c:	8b 45 08             	mov    0x8(%ebp),%eax
80106b0f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106b12:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106b18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106b1b:	77 49                	ja     80106b66 <inituvm+0x66>
  mem = kalloc();
80106b1d:	e8 3e bb ff ff       	call   80102660 <kalloc>
  memset(mem, 0, PGSIZE);
80106b22:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106b25:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106b27:	68 00 10 00 00       	push   $0x1000
80106b2c:	6a 00                	push   $0x0
80106b2e:	50                   	push   %eax
80106b2f:	e8 9c da ff ff       	call   801045d0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106b34:	58                   	pop    %eax
80106b35:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b3b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106b40:	5a                   	pop    %edx
80106b41:	6a 06                	push   $0x6
80106b43:	50                   	push   %eax
80106b44:	31 d2                	xor    %edx,%edx
80106b46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b49:	e8 c2 fc ff ff       	call   80106810 <mappages>
  memmove(mem, init, sz);
80106b4e:	89 75 10             	mov    %esi,0x10(%ebp)
80106b51:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106b54:	83 c4 10             	add    $0x10,%esp
80106b57:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106b5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b5d:	5b                   	pop    %ebx
80106b5e:	5e                   	pop    %esi
80106b5f:	5f                   	pop    %edi
80106b60:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106b61:	e9 1a db ff ff       	jmp    80104680 <memmove>
    panic("inituvm: more than a page");
80106b66:	83 ec 0c             	sub    $0xc,%esp
80106b69:	68 9c 7a 10 80       	push   $0x80107a9c
80106b6e:	e8 3d 98 ff ff       	call   801003b0 <panic>
80106b73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b80 <loaduvm>:
{
80106b80:	55                   	push   %ebp
80106b81:	89 e5                	mov    %esp,%ebp
80106b83:	57                   	push   %edi
80106b84:	56                   	push   %esi
80106b85:	53                   	push   %ebx
80106b86:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106b89:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106b90:	0f 85 91 00 00 00    	jne    80106c27 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106b96:	8b 75 18             	mov    0x18(%ebp),%esi
80106b99:	31 db                	xor    %ebx,%ebx
80106b9b:	85 f6                	test   %esi,%esi
80106b9d:	75 1a                	jne    80106bb9 <loaduvm+0x39>
80106b9f:	eb 6f                	jmp    80106c10 <loaduvm+0x90>
80106ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ba8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bae:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106bb4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106bb7:	76 57                	jbe    80106c10 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106bb9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106bbc:	8b 45 08             	mov    0x8(%ebp),%eax
80106bbf:	31 c9                	xor    %ecx,%ecx
80106bc1:	01 da                	add    %ebx,%edx
80106bc3:	e8 c8 fb ff ff       	call   80106790 <walkpgdir>
80106bc8:	85 c0                	test   %eax,%eax
80106bca:	74 4e                	je     80106c1a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106bcc:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106bce:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106bd1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106bd6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106bdb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106be1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106be4:	01 d9                	add    %ebx,%ecx
80106be6:	05 00 00 00 80       	add    $0x80000000,%eax
80106beb:	57                   	push   %edi
80106bec:	51                   	push   %ecx
80106bed:	50                   	push   %eax
80106bee:	ff 75 10             	pushl  0x10(%ebp)
80106bf1:	e8 1a af ff ff       	call   80101b10 <readi>
80106bf6:	83 c4 10             	add    $0x10,%esp
80106bf9:	39 f8                	cmp    %edi,%eax
80106bfb:	74 ab                	je     80106ba8 <loaduvm+0x28>
}
80106bfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106c00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c05:	5b                   	pop    %ebx
80106c06:	5e                   	pop    %esi
80106c07:	5f                   	pop    %edi
80106c08:	5d                   	pop    %ebp
80106c09:	c3                   	ret    
80106c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106c13:	31 c0                	xor    %eax,%eax
}
80106c15:	5b                   	pop    %ebx
80106c16:	5e                   	pop    %esi
80106c17:	5f                   	pop    %edi
80106c18:	5d                   	pop    %ebp
80106c19:	c3                   	ret    
      panic("loaduvm: address should exist");
80106c1a:	83 ec 0c             	sub    $0xc,%esp
80106c1d:	68 b6 7a 10 80       	push   $0x80107ab6
80106c22:	e8 89 97 ff ff       	call   801003b0 <panic>
    panic("loaduvm: addr must be page aligned");
80106c27:	83 ec 0c             	sub    $0xc,%esp
80106c2a:	68 24 7b 10 80       	push   $0x80107b24
80106c2f:	e8 7c 97 ff ff       	call   801003b0 <panic>
80106c34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106c40 <allocuvm>:
{
80106c40:	55                   	push   %ebp
80106c41:	89 e5                	mov    %esp,%ebp
80106c43:	57                   	push   %edi
80106c44:	56                   	push   %esi
80106c45:	53                   	push   %ebx
80106c46:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106c49:	8b 7d 10             	mov    0x10(%ebp),%edi
80106c4c:	85 ff                	test   %edi,%edi
80106c4e:	78 76                	js     80106cc6 <allocuvm+0x86>
  if(newsz < oldsz)
80106c50:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106c53:	0f 82 7f 00 00 00    	jb     80106cd8 <allocuvm+0x98>
  a = PGROUNDUP(oldsz);
80106c59:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c5c:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106c62:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106c68:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106c6b:	76 6e                	jbe    80106cdb <allocuvm+0x9b>
80106c6d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106c70:	8b 7d 08             	mov    0x8(%ebp),%edi
80106c73:	eb 3e                	jmp    80106cb3 <allocuvm+0x73>
80106c75:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106c78:	83 ec 04             	sub    $0x4,%esp
80106c7b:	68 00 10 00 00       	push   $0x1000
80106c80:	6a 00                	push   $0x0
80106c82:	50                   	push   %eax
80106c83:	e8 48 d9 ff ff       	call   801045d0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106c88:	58                   	pop    %eax
80106c89:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106c8f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c94:	5a                   	pop    %edx
80106c95:	6a 06                	push   $0x6
80106c97:	50                   	push   %eax
80106c98:	89 da                	mov    %ebx,%edx
80106c9a:	89 f8                	mov    %edi,%eax
80106c9c:	e8 6f fb ff ff       	call   80106810 <mappages>
80106ca1:	83 c4 10             	add    $0x10,%esp
80106ca4:	85 c0                	test   %eax,%eax
80106ca6:	78 40                	js     80106ce8 <allocuvm+0xa8>
  for(; a < newsz; a += PGSIZE){
80106ca8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cae:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106cb1:	76 65                	jbe    80106d18 <allocuvm+0xd8>
    mem = kalloc();
80106cb3:	e8 a8 b9 ff ff       	call   80102660 <kalloc>
    if(mem == 0){
80106cb8:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106cba:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106cbc:	75 ba                	jne    80106c78 <allocuvm+0x38>
  if(newsz >= oldsz)
80106cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
80106cc1:	39 45 10             	cmp    %eax,0x10(%ebp)
80106cc4:	77 62                	ja     80106d28 <allocuvm+0xe8>
}
80106cc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106cc9:	31 ff                	xor    %edi,%edi
}
80106ccb:	89 f8                	mov    %edi,%eax
80106ccd:	5b                   	pop    %ebx
80106cce:	5e                   	pop    %esi
80106ccf:	5f                   	pop    %edi
80106cd0:	5d                   	pop    %ebp
80106cd1:	c3                   	ret    
80106cd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return oldsz;
80106cd8:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106cdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cde:	89 f8                	mov    %edi,%eax
80106ce0:	5b                   	pop    %ebx
80106ce1:	5e                   	pop    %esi
80106ce2:	5f                   	pop    %edi
80106ce3:	5d                   	pop    %ebp
80106ce4:	c3                   	ret    
80106ce5:	8d 76 00             	lea    0x0(%esi),%esi
  if(newsz >= oldsz)
80106ce8:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ceb:	39 45 10             	cmp    %eax,0x10(%ebp)
80106cee:	76 0d                	jbe    80106cfd <allocuvm+0xbd>
80106cf0:	89 c1                	mov    %eax,%ecx
80106cf2:	8b 55 10             	mov    0x10(%ebp),%edx
80106cf5:	8b 45 08             	mov    0x8(%ebp),%eax
80106cf8:	e8 a3 fb ff ff       	call   801068a0 <deallocuvm.part.0>
      kfree(mem);
80106cfd:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80106d00:	31 ff                	xor    %edi,%edi
      kfree(mem);
80106d02:	56                   	push   %esi
80106d03:	e8 a8 b7 ff ff       	call   801024b0 <kfree>
      return 0;
80106d08:	83 c4 10             	add    $0x10,%esp
}
80106d0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d0e:	89 f8                	mov    %edi,%eax
80106d10:	5b                   	pop    %ebx
80106d11:	5e                   	pop    %esi
80106d12:	5f                   	pop    %edi
80106d13:	5d                   	pop    %ebp
80106d14:	c3                   	ret    
80106d15:	8d 76 00             	lea    0x0(%esi),%esi
80106d18:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106d1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d1e:	5b                   	pop    %ebx
80106d1f:	89 f8                	mov    %edi,%eax
80106d21:	5e                   	pop    %esi
80106d22:	5f                   	pop    %edi
80106d23:	5d                   	pop    %ebp
80106d24:	c3                   	ret    
80106d25:	8d 76 00             	lea    0x0(%esi),%esi
80106d28:	89 c1                	mov    %eax,%ecx
80106d2a:	8b 55 10             	mov    0x10(%ebp),%edx
80106d2d:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80106d30:	31 ff                	xor    %edi,%edi
80106d32:	e8 69 fb ff ff       	call   801068a0 <deallocuvm.part.0>
80106d37:	eb a2                	jmp    80106cdb <allocuvm+0x9b>
80106d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d40 <deallocuvm>:
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d46:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106d49:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106d4c:	39 d1                	cmp    %edx,%ecx
80106d4e:	73 10                	jae    80106d60 <deallocuvm+0x20>
}
80106d50:	5d                   	pop    %ebp
80106d51:	e9 4a fb ff ff       	jmp    801068a0 <deallocuvm.part.0>
80106d56:	8d 76 00             	lea    0x0(%esi),%esi
80106d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106d60:	89 d0                	mov    %edx,%eax
80106d62:	5d                   	pop    %ebp
80106d63:	c3                   	ret    
80106d64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d70 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	57                   	push   %edi
80106d74:	56                   	push   %esi
80106d75:	53                   	push   %ebx
80106d76:	83 ec 0c             	sub    $0xc,%esp
80106d79:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106d7c:	85 f6                	test   %esi,%esi
80106d7e:	74 59                	je     80106dd9 <freevm+0x69>
80106d80:	31 c9                	xor    %ecx,%ecx
80106d82:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106d87:	89 f0                	mov    %esi,%eax
80106d89:	e8 12 fb ff ff       	call   801068a0 <deallocuvm.part.0>
80106d8e:	89 f3                	mov    %esi,%ebx
80106d90:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106d96:	eb 0f                	jmp    80106da7 <freevm+0x37>
80106d98:	90                   	nop
80106d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106da0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106da3:	39 fb                	cmp    %edi,%ebx
80106da5:	74 23                	je     80106dca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106da7:	8b 03                	mov    (%ebx),%eax
80106da9:	a8 01                	test   $0x1,%al
80106dab:	74 f3                	je     80106da0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106dad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106db2:	83 ec 0c             	sub    $0xc,%esp
80106db5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106db8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106dbd:	50                   	push   %eax
80106dbe:	e8 ed b6 ff ff       	call   801024b0 <kfree>
80106dc3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106dc6:	39 fb                	cmp    %edi,%ebx
80106dc8:	75 dd                	jne    80106da7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106dca:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106dcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dd0:	5b                   	pop    %ebx
80106dd1:	5e                   	pop    %esi
80106dd2:	5f                   	pop    %edi
80106dd3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106dd4:	e9 d7 b6 ff ff       	jmp    801024b0 <kfree>
    panic("freevm: no pgdir");
80106dd9:	83 ec 0c             	sub    $0xc,%esp
80106ddc:	68 d4 7a 10 80       	push   $0x80107ad4
80106de1:	e8 ca 95 ff ff       	call   801003b0 <panic>
80106de6:	8d 76 00             	lea    0x0(%esi),%esi
80106de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106df0 <setupkvm>:
{
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	56                   	push   %esi
80106df4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106df5:	e8 66 b8 ff ff       	call   80102660 <kalloc>
80106dfa:	85 c0                	test   %eax,%eax
80106dfc:	89 c6                	mov    %eax,%esi
80106dfe:	74 42                	je     80106e42 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106e00:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106e03:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106e08:	68 00 10 00 00       	push   $0x1000
80106e0d:	6a 00                	push   $0x0
80106e0f:	50                   	push   %eax
80106e10:	e8 bb d7 ff ff       	call   801045d0 <memset>
80106e15:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106e18:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106e1b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106e1e:	83 ec 08             	sub    $0x8,%esp
80106e21:	8b 13                	mov    (%ebx),%edx
80106e23:	ff 73 0c             	pushl  0xc(%ebx)
80106e26:	50                   	push   %eax
80106e27:	29 c1                	sub    %eax,%ecx
80106e29:	89 f0                	mov    %esi,%eax
80106e2b:	e8 e0 f9 ff ff       	call   80106810 <mappages>
80106e30:	83 c4 10             	add    $0x10,%esp
80106e33:	85 c0                	test   %eax,%eax
80106e35:	78 19                	js     80106e50 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106e37:	83 c3 10             	add    $0x10,%ebx
80106e3a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106e40:	75 d6                	jne    80106e18 <setupkvm+0x28>
}
80106e42:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106e45:	89 f0                	mov    %esi,%eax
80106e47:	5b                   	pop    %ebx
80106e48:	5e                   	pop    %esi
80106e49:	5d                   	pop    %ebp
80106e4a:	c3                   	ret    
80106e4b:	90                   	nop
80106e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80106e50:	83 ec 0c             	sub    $0xc,%esp
80106e53:	56                   	push   %esi
      return 0;
80106e54:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106e56:	e8 15 ff ff ff       	call   80106d70 <freevm>
      return 0;
80106e5b:	83 c4 10             	add    $0x10,%esp
}
80106e5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106e61:	89 f0                	mov    %esi,%eax
80106e63:	5b                   	pop    %ebx
80106e64:	5e                   	pop    %esi
80106e65:	5d                   	pop    %ebp
80106e66:	c3                   	ret    
80106e67:	89 f6                	mov    %esi,%esi
80106e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e70 <kvmalloc>:
{
80106e70:	55                   	push   %ebp
80106e71:	89 e5                	mov    %esp,%ebp
80106e73:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106e76:	e8 75 ff ff ff       	call   80106df0 <setupkvm>
80106e7b:	a3 a4 54 11 80       	mov    %eax,0x801154a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e80:	05 00 00 00 80       	add    $0x80000000,%eax
80106e85:	0f 22 d8             	mov    %eax,%cr3
}
80106e88:	c9                   	leave  
80106e89:	c3                   	ret    
80106e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e90 <select_a_victim>:
// Select a page-table entry which is mapped
// but not accessed. Notice that the user memory
// is mapped between 0...KERNBASE.
pte_t*
select_a_victim(pde_t *pgdir)
{
80106e90:	55                   	push   %ebp
	return 0;
}
80106e91:	31 c0                	xor    %eax,%eax
{
80106e93:	89 e5                	mov    %esp,%ebp
}
80106e95:	5d                   	pop    %ebp
80106e96:	c3                   	ret    
80106e97:	89 f6                	mov    %esi,%esi
80106e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ea0 <clearaccessbit>:

// Clear access bit of a random pte.
void
clearaccessbit(pde_t *pgdir)
{
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
}
80106ea3:	5d                   	pop    %ebp
80106ea4:	c3                   	ret    
80106ea5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106eb0 <getswappedblk>:

// return the disk block-id, if the virtual address
// was swapped, -1 otherwise.
int
getswappedblk(pde_t *pgdir, uint va)
{
80106eb0:	55                   	push   %ebp
  return -1;
}
80106eb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
{
80106eb6:	89 e5                	mov    %esp,%ebp
}
80106eb8:	5d                   	pop    %ebp
80106eb9:	c3                   	ret    
80106eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ec0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106ec0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ec1:	31 c9                	xor    %ecx,%ecx
{
80106ec3:	89 e5                	mov    %esp,%ebp
80106ec5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106ec8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ecb:	8b 45 08             	mov    0x8(%ebp),%eax
80106ece:	e8 bd f8 ff ff       	call   80106790 <walkpgdir>
  if(pte == 0)
80106ed3:	85 c0                	test   %eax,%eax
80106ed5:	74 05                	je     80106edc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106ed7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106eda:	c9                   	leave  
80106edb:	c3                   	ret    
    panic("clearpteu");
80106edc:	83 ec 0c             	sub    $0xc,%esp
80106edf:	68 e5 7a 10 80       	push   $0x80107ae5
80106ee4:	e8 c7 94 ff ff       	call   801003b0 <panic>
80106ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ef0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106ef0:	55                   	push   %ebp
80106ef1:	89 e5                	mov    %esp,%ebp
80106ef3:	57                   	push   %edi
80106ef4:	56                   	push   %esi
80106ef5:	53                   	push   %ebx
80106ef6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106ef9:	e8 f2 fe ff ff       	call   80106df0 <setupkvm>
80106efe:	85 c0                	test   %eax,%eax
80106f00:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106f03:	0f 84 a0 00 00 00    	je     80106fa9 <copyuvm+0xb9>
    return 0;

  for(i = 0; i < sz; i += PGSIZE){
80106f09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106f0c:	85 c9                	test   %ecx,%ecx
80106f0e:	0f 84 95 00 00 00    	je     80106fa9 <copyuvm+0xb9>
80106f14:	31 f6                	xor    %esi,%esi
80106f16:	eb 4e                	jmp    80106f66 <copyuvm+0x76>
80106f18:	90                   	nop
80106f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;

    memmove(mem, (char*)P2V(pa), PGSIZE);
80106f20:	83 ec 04             	sub    $0x4,%esp
80106f23:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106f29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f2c:	68 00 10 00 00       	push   $0x1000
80106f31:	57                   	push   %edi
80106f32:	50                   	push   %eax
80106f33:	e8 48 d7 ff ff       	call   80104680 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106f38:	58                   	pop    %eax
80106f39:	5a                   	pop    %edx
80106f3a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106f3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f40:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f45:	53                   	push   %ebx
80106f46:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106f4c:	52                   	push   %edx
80106f4d:	89 f2                	mov    %esi,%edx
80106f4f:	e8 bc f8 ff ff       	call   80106810 <mappages>
80106f54:	83 c4 10             	add    $0x10,%esp
80106f57:	85 c0                	test   %eax,%eax
80106f59:	78 39                	js     80106f94 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
80106f5b:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106f61:	39 75 0c             	cmp    %esi,0xc(%ebp)
80106f64:	76 43                	jbe    80106fa9 <copyuvm+0xb9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106f66:	8b 45 08             	mov    0x8(%ebp),%eax
80106f69:	31 c9                	xor    %ecx,%ecx
80106f6b:	89 f2                	mov    %esi,%edx
80106f6d:	e8 1e f8 ff ff       	call   80106790 <walkpgdir>
80106f72:	85 c0                	test   %eax,%eax
80106f74:	74 3e                	je     80106fb4 <copyuvm+0xc4>
    if(!(*pte & PTE_P))
80106f76:	8b 18                	mov    (%eax),%ebx
80106f78:	f6 c3 01             	test   $0x1,%bl
80106f7b:	74 44                	je     80106fc1 <copyuvm+0xd1>
    pa = PTE_ADDR(*pte);
80106f7d:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80106f7f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80106f85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80106f8b:	e8 d0 b6 ff ff       	call   80102660 <kalloc>
80106f90:	85 c0                	test   %eax,%eax
80106f92:	75 8c                	jne    80106f20 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106f94:	83 ec 0c             	sub    $0xc,%esp
80106f97:	ff 75 e0             	pushl  -0x20(%ebp)
80106f9a:	e8 d1 fd ff ff       	call   80106d70 <freevm>
  return 0;
80106f9f:	83 c4 10             	add    $0x10,%esp
80106fa2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80106fa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106fac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106faf:	5b                   	pop    %ebx
80106fb0:	5e                   	pop    %esi
80106fb1:	5f                   	pop    %edi
80106fb2:	5d                   	pop    %ebp
80106fb3:	c3                   	ret    
      panic("copyuvm: pte should exist");
80106fb4:	83 ec 0c             	sub    $0xc,%esp
80106fb7:	68 ef 7a 10 80       	push   $0x80107aef
80106fbc:	e8 ef 93 ff ff       	call   801003b0 <panic>
      panic("copyuvm: page not present");
80106fc1:	83 ec 0c             	sub    $0xc,%esp
80106fc4:	68 09 7b 10 80       	push   $0x80107b09
80106fc9:	e8 e2 93 ff ff       	call   801003b0 <panic>
80106fce:	66 90                	xchg   %ax,%ax

80106fd0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106fd0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106fd1:	31 c9                	xor    %ecx,%ecx
{
80106fd3:	89 e5                	mov    %esp,%ebp
80106fd5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106fd8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fdb:	8b 45 08             	mov    0x8(%ebp),%eax
80106fde:	e8 ad f7 ff ff       	call   80106790 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106fe3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80106fe5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80106fe6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106fe8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80106fed:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106ff0:	05 00 00 00 80       	add    $0x80000000,%eax
80106ff5:	83 fa 05             	cmp    $0x5,%edx
80106ff8:	ba 00 00 00 00       	mov    $0x0,%edx
80106ffd:	0f 45 c2             	cmovne %edx,%eax
}
80107000:	c3                   	ret    
80107001:	eb 0d                	jmp    80107010 <uva2pte>
80107003:	90                   	nop
80107004:	90                   	nop
80107005:	90                   	nop
80107006:	90                   	nop
80107007:	90                   	nop
80107008:	90                   	nop
80107009:	90                   	nop
8010700a:	90                   	nop
8010700b:	90                   	nop
8010700c:	90                   	nop
8010700d:	90                   	nop
8010700e:	90                   	nop
8010700f:	90                   	nop

80107010 <uva2pte>:

// returns the page table entry corresponding
// to a virtual address.
pte_t*
uva2pte(pde_t *pgdir, uint uva)
{
80107010:	55                   	push   %ebp
  return walkpgdir(pgdir, (void*)uva, 0);
80107011:	31 c9                	xor    %ecx,%ecx
{
80107013:	89 e5                	mov    %esp,%ebp
  return walkpgdir(pgdir, (void*)uva, 0);
80107015:	8b 55 0c             	mov    0xc(%ebp),%edx
80107018:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010701b:	5d                   	pop    %ebp
  return walkpgdir(pgdir, (void*)uva, 0);
8010701c:	e9 6f f7 ff ff       	jmp    80106790 <walkpgdir>
80107021:	eb 0d                	jmp    80107030 <copyout>
80107023:	90                   	nop
80107024:	90                   	nop
80107025:	90                   	nop
80107026:	90                   	nop
80107027:	90                   	nop
80107028:	90                   	nop
80107029:	90                   	nop
8010702a:	90                   	nop
8010702b:	90                   	nop
8010702c:	90                   	nop
8010702d:	90                   	nop
8010702e:	90                   	nop
8010702f:	90                   	nop

80107030 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107030:	55                   	push   %ebp
80107031:	89 e5                	mov    %esp,%ebp
80107033:	57                   	push   %edi
80107034:	56                   	push   %esi
80107035:	53                   	push   %ebx
80107036:	83 ec 1c             	sub    $0x1c,%esp
80107039:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010703c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010703f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107042:	85 db                	test   %ebx,%ebx
80107044:	75 40                	jne    80107086 <copyout+0x56>
80107046:	eb 70                	jmp    801070b8 <copyout+0x88>
80107048:	90                   	nop
80107049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107050:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107053:	89 f1                	mov    %esi,%ecx
80107055:	29 d1                	sub    %edx,%ecx
80107057:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010705d:	39 d9                	cmp    %ebx,%ecx
8010705f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107062:	29 f2                	sub    %esi,%edx
80107064:	83 ec 04             	sub    $0x4,%esp
80107067:	01 d0                	add    %edx,%eax
80107069:	51                   	push   %ecx
8010706a:	57                   	push   %edi
8010706b:	50                   	push   %eax
8010706c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010706f:	e8 0c d6 ff ff       	call   80104680 <memmove>
    len -= n;
    buf += n;
80107074:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107077:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010707a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107080:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107082:	29 cb                	sub    %ecx,%ebx
80107084:	74 32                	je     801070b8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107086:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107088:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010708b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010708e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107094:	56                   	push   %esi
80107095:	ff 75 08             	pushl  0x8(%ebp)
80107098:	e8 33 ff ff ff       	call   80106fd0 <uva2ka>
    if(pa0 == 0)
8010709d:	83 c4 10             	add    $0x10,%esp
801070a0:	85 c0                	test   %eax,%eax
801070a2:	75 ac                	jne    80107050 <copyout+0x20>
  }
  return 0;
}
801070a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801070a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801070ac:	5b                   	pop    %ebx
801070ad:	5e                   	pop    %esi
801070ae:	5f                   	pop    %edi
801070af:	5d                   	pop    %ebp
801070b0:	c3                   	ret    
801070b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801070bb:	31 c0                	xor    %eax,%eax
}
801070bd:	5b                   	pop    %ebx
801070be:	5e                   	pop    %esi
801070bf:	5f                   	pop    %edi
801070c0:	5d                   	pop    %ebp
801070c1:	c3                   	ret    
