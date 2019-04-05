
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
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 10 31 10 80       	mov    $0x80103110,%eax
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
80100044:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 a0 75 10 80       	push   $0x801075a0
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 d5 43 00 00       	call   80104430 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 0c 11 80       	mov    $0x80110cbc,%edx
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
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 75 10 80       	push   $0x801075a7
80100097:	50                   	push   %eax
80100098:	e8 83 42 00 00       	call   80104320 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 0c 11 80       	cmp    $0x80110cbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:


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
801000df:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e4:	e8 37 44 00 00       	call   80104520 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
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
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 d9 44 00 00       	call   80104640 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ee 41 00 00       	call   80104360 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 0d 22 00 00       	call   80102390 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ae 75 10 80       	push   $0x801075ae
80100198:	e8 f3 02 00 00       	call   80100490 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 4d 42 00 00       	call   80104400 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 c7 21 00 00       	jmp    80102390 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 bf 75 10 80       	push   $0x801075bf
801001d1:	e8 ba 02 00 00       	call   80100490 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 0c 42 00 00       	call   80104400 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");
  
  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 bc 41 00 00       	call   801043c0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 10 43 00 00       	call   80104520 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 0d 11 80       	mov    0x80110d10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 df 43 00 00       	jmp    80104640 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 c6 75 10 80       	push   $0x801075c6
80100269:	e8 22 02 00 00       	call   80100490 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <write_page_to_disk>:
/* Write 4096 bytes pg to the eight consecutive
 * starting at blk.
 */
void
write_page_to_disk(uint dev, char *pg, uint blk)
{ 
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 45 08             	mov    0x8(%ebp),%eax
8010027c:	8b 7d 10             	mov    0x10(%ebp),%edi
  cprintf("Writing page to disk");
8010027f:	68 cd 75 10 80       	push   $0x801075cd
{ 
80100284:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100287:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  cprintf("Writing page to disk");
8010028a:	e8 d1 04 00 00       	call   80100760 <cprintf>
  struct buf *b;
  for(uint i=blk;i<blk+8;i++){
8010028f:	83 c4 10             	add    $0x10,%esp
80100292:	83 ff f7             	cmp    $0xfffffff7,%edi
80100295:	77 4a                	ja     801002e1 <write_page_to_disk+0x71>
80100297:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010029d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    b=bread(dev,i);
801002a0:	83 ec 08             	sub    $0x8,%esp
801002a3:	57                   	push   %edi
801002a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  for(uint i=blk;i<blk+8;i++){
801002a7:	83 c7 01             	add    $0x1,%edi
    b=bread(dev,i);
801002aa:	e8 21 fe ff ff       	call   801000d0 <bread>
801002af:	89 c6                	mov    %eax,%esi
    memmove(b->data,pg,BSIZE);
801002b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801002b4:	83 c4 0c             	add    $0xc,%esp
801002b7:	68 00 02 00 00       	push   $0x200
801002bc:	53                   	push   %ebx
    pg+=BSIZE;
801002bd:	81 c3 00 02 00 00    	add    $0x200,%ebx
    memmove(b->data,pg,BSIZE);
801002c3:	50                   	push   %eax
801002c4:	e8 87 44 00 00       	call   80104750 <memmove>
    bwrite(b);
801002c9:	89 34 24             	mov    %esi,(%esp)
801002cc:	e8 cf fe ff ff       	call   801001a0 <bwrite>
    brelse(b);
801002d1:	89 34 24             	mov    %esi,(%esp)
801002d4:	e8 07 ff ff ff       	call   801001e0 <brelse>
  for(uint i=blk;i<blk+8;i++){
801002d9:	83 c4 10             	add    $0x10,%esp
801002dc:	39 5d e0             	cmp    %ebx,-0x20(%ebp)
801002df:	75 bf                	jne    801002a0 <write_page_to_disk+0x30>
  }
  cprintf("written to disk\n");
801002e1:	c7 45 08 e2 75 10 80 	movl   $0x801075e2,0x8(%ebp)
}
801002e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002eb:	5b                   	pop    %ebx
801002ec:	5e                   	pop    %esi
801002ed:	5f                   	pop    %edi
801002ee:	5d                   	pop    %ebp
  cprintf("written to disk\n");
801002ef:	e9 6c 04 00 00       	jmp    80100760 <cprintf>
801002f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801002fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100300 <read_page_from_disk>:
/* Read 4096 bytes from the eight consecutive
 * starting at blk into pg.
 */
void
read_page_from_disk(uint dev, char *pg, uint blk)
{
80100300:	55                   	push   %ebp
80100301:	89 e5                	mov    %esp,%ebp
80100303:	57                   	push   %edi
80100304:	56                   	push   %esi
80100305:	53                   	push   %ebx
80100306:	83 ec 1c             	sub    $0x1c,%esp
80100309:	8b 7d 10             	mov    0x10(%ebp),%edi
8010030c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char* temp=pg;
  struct buf *b;

  for(uint i=blk;i<blk+8;i++){
8010030f:	83 ff f7             	cmp    $0xfffffff7,%edi
80100312:	77 45                	ja     80100359 <read_page_from_disk+0x59>
80100314:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010031a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010031d:	8d 76 00             	lea    0x0(%esi),%esi
    
    b=bread(dev,i);
80100320:	83 ec 08             	sub    $0x8,%esp
80100323:	57                   	push   %edi
80100324:	ff 75 08             	pushl  0x8(%ebp)
  for(uint i=blk;i<blk+8;i++){
80100327:	83 c7 01             	add    $0x1,%edi
    b=bread(dev,i);
8010032a:	e8 a1 fd ff ff       	call   801000d0 <bread>
8010032f:	89 c6                	mov    %eax,%esi
    memmove(temp,b->data,512);
80100331:	8d 40 5c             	lea    0x5c(%eax),%eax
80100334:	83 c4 0c             	add    $0xc,%esp
80100337:	68 00 02 00 00       	push   $0x200
8010033c:	50                   	push   %eax
8010033d:	53                   	push   %ebx
    temp+=512;
8010033e:	81 c3 00 02 00 00    	add    $0x200,%ebx
    memmove(temp,b->data,512);
80100344:	e8 07 44 00 00       	call   80104750 <memmove>
    //bwrite(b);
    brelse(b);
80100349:	89 34 24             	mov    %esi,(%esp)
8010034c:	e8 8f fe ff ff       	call   801001e0 <brelse>
  for(uint i=blk;i<blk+8;i++){
80100351:	83 c4 10             	add    $0x10,%esp
80100354:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80100357:	75 c7                	jne    80100320 <read_page_from_disk+0x20>
   // cprintf("written to disk\n");
  }
}
80100359:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010035c:	5b                   	pop    %ebx
8010035d:	5e                   	pop    %esi
8010035e:	5f                   	pop    %edi
8010035f:	5d                   	pop    %ebp
80100360:	c3                   	ret    
80100361:	66 90                	xchg   %ax,%ax
80100363:	66 90                	xchg   %ax,%ax
80100365:	66 90                	xchg   %ax,%ax
80100367:	66 90                	xchg   %ax,%ax
80100369:	66 90                	xchg   %ax,%ax
8010036b:	66 90                	xchg   %ax,%ax
8010036d:	66 90                	xchg   %ax,%ax
8010036f:	90                   	nop

80100370 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	57                   	push   %edi
80100374:	56                   	push   %esi
80100375:	53                   	push   %ebx
80100376:	83 ec 28             	sub    $0x28,%esp
80100379:	8b 7d 08             	mov    0x8(%ebp),%edi
8010037c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010037f:	57                   	push   %edi
80100380:	e8 5b 16 00 00       	call   801019e0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100385:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010038c:	e8 8f 41 00 00       	call   80104520 <acquire>
  while(n > 0){
80100391:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100394:	83 c4 10             	add    $0x10,%esp
80100397:	31 c0                	xor    %eax,%eax
80100399:	85 db                	test   %ebx,%ebx
8010039b:	0f 8e a1 00 00 00    	jle    80100442 <consoleread+0xd2>
    while(input.r == input.w){
801003a1:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801003a7:	39 15 a4 0f 11 80    	cmp    %edx,0x80110fa4
801003ad:	74 2c                	je     801003db <consoleread+0x6b>
801003af:	eb 5f                	jmp    80100410 <consoleread+0xa0>
801003b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801003b8:	83 ec 08             	sub    $0x8,%esp
801003bb:	68 20 b5 10 80       	push   $0x8010b520
801003c0:	68 a0 0f 11 80       	push   $0x80110fa0
801003c5:	e8 f6 3b 00 00       	call   80103fc0 <sleep>
    while(input.r == input.w){
801003ca:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801003d0:	83 c4 10             	add    $0x10,%esp
801003d3:	3b 15 a4 0f 11 80    	cmp    0x80110fa4,%edx
801003d9:	75 35                	jne    80100410 <consoleread+0xa0>
      if(myproc()->killed){
801003db:	e8 70 36 00 00       	call   80103a50 <myproc>
801003e0:	8b 40 24             	mov    0x24(%eax),%eax
801003e3:	85 c0                	test   %eax,%eax
801003e5:	74 d1                	je     801003b8 <consoleread+0x48>
        release(&cons.lock);
801003e7:	83 ec 0c             	sub    $0xc,%esp
801003ea:	68 20 b5 10 80       	push   $0x8010b520
801003ef:	e8 4c 42 00 00       	call   80104640 <release>
        ilock(ip);
801003f4:	89 3c 24             	mov    %edi,(%esp)
801003f7:	e8 04 15 00 00       	call   80101900 <ilock>
        return -1;
801003fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801003ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100402:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100407:	5b                   	pop    %ebx
80100408:	5e                   	pop    %esi
80100409:	5f                   	pop    %edi
8010040a:	5d                   	pop    %ebp
8010040b:	c3                   	ret    
8010040c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100410:	8d 42 01             	lea    0x1(%edx),%eax
80100413:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
80100418:	89 d0                	mov    %edx,%eax
8010041a:	83 e0 7f             	and    $0x7f,%eax
8010041d:	0f be 80 20 0f 11 80 	movsbl -0x7feef0e0(%eax),%eax
    if(c == C('D')){  // EOF
80100424:	83 f8 04             	cmp    $0x4,%eax
80100427:	74 3f                	je     80100468 <consoleread+0xf8>
    *dst++ = c;
80100429:	83 c6 01             	add    $0x1,%esi
    --n;
8010042c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010042f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100432:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100435:	74 43                	je     8010047a <consoleread+0x10a>
  while(n > 0){
80100437:	85 db                	test   %ebx,%ebx
80100439:	0f 85 62 ff ff ff    	jne    801003a1 <consoleread+0x31>
8010043f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100442:	83 ec 0c             	sub    $0xc,%esp
80100445:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100448:	68 20 b5 10 80       	push   $0x8010b520
8010044d:	e8 ee 41 00 00       	call   80104640 <release>
  ilock(ip);
80100452:	89 3c 24             	mov    %edi,(%esp)
80100455:	e8 a6 14 00 00       	call   80101900 <ilock>
  return target - n;
8010045a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010045d:	83 c4 10             	add    $0x10,%esp
}
80100460:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100463:	5b                   	pop    %ebx
80100464:	5e                   	pop    %esi
80100465:	5f                   	pop    %edi
80100466:	5d                   	pop    %ebp
80100467:	c3                   	ret    
80100468:	8b 45 10             	mov    0x10(%ebp),%eax
8010046b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010046d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100470:	73 d0                	jae    80100442 <consoleread+0xd2>
        input.r--;
80100472:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100478:	eb c8                	jmp    80100442 <consoleread+0xd2>
8010047a:	8b 45 10             	mov    0x10(%ebp),%eax
8010047d:	29 d8                	sub    %ebx,%eax
8010047f:	eb c1                	jmp    80100442 <consoleread+0xd2>
80100481:	eb 0d                	jmp    80100490 <panic>
80100483:	90                   	nop
80100484:	90                   	nop
80100485:	90                   	nop
80100486:	90                   	nop
80100487:	90                   	nop
80100488:	90                   	nop
80100489:	90                   	nop
8010048a:	90                   	nop
8010048b:	90                   	nop
8010048c:	90                   	nop
8010048d:	90                   	nop
8010048e:	90                   	nop
8010048f:	90                   	nop

80100490 <panic>:
{
80100490:	55                   	push   %ebp
80100491:	89 e5                	mov    %esp,%ebp
80100493:	56                   	push   %esi
80100494:	53                   	push   %ebx
80100495:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100498:	fa                   	cli    
  cons.locking = 0;
80100499:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801004a0:	00 00 00 
  getcallerpcs(&s, pcs);
801004a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801004a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801004a9:	e8 f2 24 00 00       	call   801029a0 <lapicid>
801004ae:	83 ec 08             	sub    $0x8,%esp
801004b1:	50                   	push   %eax
801004b2:	68 f3 75 10 80       	push   $0x801075f3
801004b7:	e8 a4 02 00 00       	call   80100760 <cprintf>
  cprintf(s);
801004bc:	58                   	pop    %eax
801004bd:	ff 75 08             	pushl  0x8(%ebp)
801004c0:	e8 9b 02 00 00       	call   80100760 <cprintf>
  cprintf("\n");
801004c5:	c7 04 24 ea 76 10 80 	movl   $0x801076ea,(%esp)
801004cc:	e8 8f 02 00 00       	call   80100760 <cprintf>
  getcallerpcs(&s, pcs);
801004d1:	5a                   	pop    %edx
801004d2:	8d 45 08             	lea    0x8(%ebp),%eax
801004d5:	59                   	pop    %ecx
801004d6:	53                   	push   %ebx
801004d7:	50                   	push   %eax
801004d8:	e8 73 3f 00 00       	call   80104450 <getcallerpcs>
801004dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801004e0:	83 ec 08             	sub    $0x8,%esp
801004e3:	ff 33                	pushl  (%ebx)
801004e5:	83 c3 04             	add    $0x4,%ebx
801004e8:	68 07 76 10 80       	push   $0x80107607
801004ed:	e8 6e 02 00 00       	call   80100760 <cprintf>
  for(i=0; i<10; i++)
801004f2:	83 c4 10             	add    $0x10,%esp
801004f5:	39 f3                	cmp    %esi,%ebx
801004f7:	75 e7                	jne    801004e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801004f9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100500:	00 00 00 
80100503:	eb fe                	jmp    80100503 <panic+0x73>
80100505:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100510 <consputc>:
  if(panicked){
80100510:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100516:	85 c9                	test   %ecx,%ecx
80100518:	74 06                	je     80100520 <consputc+0x10>
8010051a:	fa                   	cli    
8010051b:	eb fe                	jmp    8010051b <consputc+0xb>
8010051d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100520:	55                   	push   %ebp
80100521:	89 e5                	mov    %esp,%ebp
80100523:	57                   	push   %edi
80100524:	56                   	push   %esi
80100525:	53                   	push   %ebx
80100526:	89 c6                	mov    %eax,%esi
80100528:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010052b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100530:	0f 84 b1 00 00 00    	je     801005e7 <consputc+0xd7>
    uartputc(c);
80100536:	83 ec 0c             	sub    $0xc,%esp
80100539:	50                   	push   %eax
8010053a:	e8 71 5b 00 00       	call   801060b0 <uartputc>
8010053f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100542:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100547:	b8 0e 00 00 00       	mov    $0xe,%eax
8010054c:	89 da                	mov    %ebx,%edx
8010054e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010054f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100554:	89 ca                	mov    %ecx,%edx
80100556:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100557:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010055a:	89 da                	mov    %ebx,%edx
8010055c:	c1 e0 08             	shl    $0x8,%eax
8010055f:	89 c7                	mov    %eax,%edi
80100561:	b8 0f 00 00 00       	mov    $0xf,%eax
80100566:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100567:	89 ca                	mov    %ecx,%edx
80100569:	ec                   	in     (%dx),%al
8010056a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010056d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010056f:	83 fe 0a             	cmp    $0xa,%esi
80100572:	0f 84 f3 00 00 00    	je     8010066b <consputc+0x15b>
  else if(c == BACKSPACE){
80100578:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010057e:	0f 84 d7 00 00 00    	je     8010065b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100584:	89 f0                	mov    %esi,%eax
80100586:	0f b6 c0             	movzbl %al,%eax
80100589:	80 cc 07             	or     $0x7,%ah
8010058c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100593:	80 
80100594:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100597:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010059d:	0f 8f ab 00 00 00    	jg     8010064e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801005a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801005a9:	7f 66                	jg     80100611 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801005ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801005b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801005b5:	89 f2                	mov    %esi,%edx
801005b7:	ee                   	out    %al,(%dx)
801005b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801005bd:	89 d8                	mov    %ebx,%eax
801005bf:	c1 f8 08             	sar    $0x8,%eax
801005c2:	89 ca                	mov    %ecx,%edx
801005c4:	ee                   	out    %al,(%dx)
801005c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801005ca:	89 f2                	mov    %esi,%edx
801005cc:	ee                   	out    %al,(%dx)
801005cd:	89 d8                	mov    %ebx,%eax
801005cf:	89 ca                	mov    %ecx,%edx
801005d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801005d2:	b8 20 07 00 00       	mov    $0x720,%eax
801005d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801005de:	80 
}
801005df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005e2:	5b                   	pop    %ebx
801005e3:	5e                   	pop    %esi
801005e4:	5f                   	pop    %edi
801005e5:	5d                   	pop    %ebp
801005e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801005e7:	83 ec 0c             	sub    $0xc,%esp
801005ea:	6a 08                	push   $0x8
801005ec:	e8 bf 5a 00 00       	call   801060b0 <uartputc>
801005f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801005f8:	e8 b3 5a 00 00       	call   801060b0 <uartputc>
801005fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100604:	e8 a7 5a 00 00       	call   801060b0 <uartputc>
80100609:	83 c4 10             	add    $0x10,%esp
8010060c:	e9 31 ff ff ff       	jmp    80100542 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100611:	52                   	push   %edx
80100612:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100617:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010061a:	68 a0 80 0b 80       	push   $0x800b80a0
8010061f:	68 00 80 0b 80       	push   $0x800b8000
80100624:	e8 27 41 00 00       	call   80104750 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100629:	b8 80 07 00 00       	mov    $0x780,%eax
8010062e:	83 c4 0c             	add    $0xc,%esp
80100631:	29 d8                	sub    %ebx,%eax
80100633:	01 c0                	add    %eax,%eax
80100635:	50                   	push   %eax
80100636:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100639:	6a 00                	push   $0x0
8010063b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100640:	50                   	push   %eax
80100641:	e8 5a 40 00 00       	call   801046a0 <memset>
80100646:	83 c4 10             	add    $0x10,%esp
80100649:	e9 5d ff ff ff       	jmp    801005ab <consputc+0x9b>
    panic("pos under/overflow");
8010064e:	83 ec 0c             	sub    $0xc,%esp
80100651:	68 0b 76 10 80       	push   $0x8010760b
80100656:	e8 35 fe ff ff       	call   80100490 <panic>
    if(pos > 0) --pos;
8010065b:	85 db                	test   %ebx,%ebx
8010065d:	0f 84 48 ff ff ff    	je     801005ab <consputc+0x9b>
80100663:	83 eb 01             	sub    $0x1,%ebx
80100666:	e9 2c ff ff ff       	jmp    80100597 <consputc+0x87>
    pos += 80 - pos%80;
8010066b:	89 d8                	mov    %ebx,%eax
8010066d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100672:	99                   	cltd   
80100673:	f7 f9                	idiv   %ecx
80100675:	29 d1                	sub    %edx,%ecx
80100677:	01 cb                	add    %ecx,%ebx
80100679:	e9 19 ff ff ff       	jmp    80100597 <consputc+0x87>
8010067e:	66 90                	xchg   %ax,%ax

80100680 <printint>:
{
80100680:	55                   	push   %ebp
80100681:	89 e5                	mov    %esp,%ebp
80100683:	57                   	push   %edi
80100684:	56                   	push   %esi
80100685:	53                   	push   %ebx
80100686:	89 d3                	mov    %edx,%ebx
80100688:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010068b:	85 c9                	test   %ecx,%ecx
{
8010068d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100690:	74 04                	je     80100696 <printint+0x16>
80100692:	85 c0                	test   %eax,%eax
80100694:	78 5a                	js     801006f0 <printint+0x70>
    x = xx;
80100696:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010069d:	31 c9                	xor    %ecx,%ecx
8010069f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801006a2:	eb 06                	jmp    801006aa <printint+0x2a>
801006a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801006a8:	89 f9                	mov    %edi,%ecx
801006aa:	31 d2                	xor    %edx,%edx
801006ac:	8d 79 01             	lea    0x1(%ecx),%edi
801006af:	f7 f3                	div    %ebx
801006b1:	0f b6 92 38 76 10 80 	movzbl -0x7fef89c8(%edx),%edx
  }while((x /= base) != 0);
801006b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801006ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801006bd:	75 e9                	jne    801006a8 <printint+0x28>
  if(sign)
801006bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801006c2:	85 c0                	test   %eax,%eax
801006c4:	74 08                	je     801006ce <printint+0x4e>
    buf[i++] = '-';
801006c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801006cb:	8d 79 02             	lea    0x2(%ecx),%edi
801006ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801006d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801006d8:	0f be 03             	movsbl (%ebx),%eax
801006db:	83 eb 01             	sub    $0x1,%ebx
801006de:	e8 2d fe ff ff       	call   80100510 <consputc>
  while(--i >= 0)
801006e3:	39 f3                	cmp    %esi,%ebx
801006e5:	75 f1                	jne    801006d8 <printint+0x58>
}
801006e7:	83 c4 2c             	add    $0x2c,%esp
801006ea:	5b                   	pop    %ebx
801006eb:	5e                   	pop    %esi
801006ec:	5f                   	pop    %edi
801006ed:	5d                   	pop    %ebp
801006ee:	c3                   	ret    
801006ef:	90                   	nop
    x = -xx;
801006f0:	f7 d8                	neg    %eax
801006f2:	eb a9                	jmp    8010069d <printint+0x1d>
801006f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801006fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100700 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100700:	55                   	push   %ebp
80100701:	89 e5                	mov    %esp,%ebp
80100703:	57                   	push   %edi
80100704:	56                   	push   %esi
80100705:	53                   	push   %ebx
80100706:	83 ec 18             	sub    $0x18,%esp
80100709:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010070c:	ff 75 08             	pushl  0x8(%ebp)
8010070f:	e8 cc 12 00 00       	call   801019e0 <iunlock>
  acquire(&cons.lock);
80100714:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010071b:	e8 00 3e 00 00       	call   80104520 <acquire>
  for(i = 0; i < n; i++)
80100720:	83 c4 10             	add    $0x10,%esp
80100723:	85 f6                	test   %esi,%esi
80100725:	7e 18                	jle    8010073f <consolewrite+0x3f>
80100727:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010072a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010072d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100730:	0f b6 07             	movzbl (%edi),%eax
80100733:	83 c7 01             	add    $0x1,%edi
80100736:	e8 d5 fd ff ff       	call   80100510 <consputc>
  for(i = 0; i < n; i++)
8010073b:	39 fb                	cmp    %edi,%ebx
8010073d:	75 f1                	jne    80100730 <consolewrite+0x30>
  release(&cons.lock);
8010073f:	83 ec 0c             	sub    $0xc,%esp
80100742:	68 20 b5 10 80       	push   $0x8010b520
80100747:	e8 f4 3e 00 00       	call   80104640 <release>
  ilock(ip);
8010074c:	58                   	pop    %eax
8010074d:	ff 75 08             	pushl  0x8(%ebp)
80100750:	e8 ab 11 00 00       	call   80101900 <ilock>

  return n;
}
80100755:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100758:	89 f0                	mov    %esi,%eax
8010075a:	5b                   	pop    %ebx
8010075b:	5e                   	pop    %esi
8010075c:	5f                   	pop    %edi
8010075d:	5d                   	pop    %ebp
8010075e:	c3                   	ret    
8010075f:	90                   	nop

80100760 <cprintf>:
{
80100760:	55                   	push   %ebp
80100761:	89 e5                	mov    %esp,%ebp
80100763:	57                   	push   %edi
80100764:	56                   	push   %esi
80100765:	53                   	push   %ebx
80100766:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100769:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010076e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100770:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100773:	0f 85 6f 01 00 00    	jne    801008e8 <cprintf+0x188>
  if (fmt == 0)
80100779:	8b 45 08             	mov    0x8(%ebp),%eax
8010077c:	85 c0                	test   %eax,%eax
8010077e:	89 c7                	mov    %eax,%edi
80100780:	0f 84 77 01 00 00    	je     801008fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100786:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100789:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010078c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010078e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100791:	85 c0                	test   %eax,%eax
80100793:	75 56                	jne    801007eb <cprintf+0x8b>
80100795:	eb 79                	jmp    80100810 <cprintf+0xb0>
80100797:	89 f6                	mov    %esi,%esi
80100799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801007a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801007a3:	85 d2                	test   %edx,%edx
801007a5:	74 69                	je     80100810 <cprintf+0xb0>
801007a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801007aa:	83 fa 70             	cmp    $0x70,%edx
801007ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801007b0:	0f 84 84 00 00 00    	je     8010083a <cprintf+0xda>
801007b6:	7f 78                	jg     80100830 <cprintf+0xd0>
801007b8:	83 fa 25             	cmp    $0x25,%edx
801007bb:	0f 84 ff 00 00 00    	je     801008c0 <cprintf+0x160>
801007c1:	83 fa 64             	cmp    $0x64,%edx
801007c4:	0f 85 8e 00 00 00    	jne    80100858 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801007ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801007cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801007d2:	8d 48 04             	lea    0x4(%eax),%ecx
801007d5:	8b 00                	mov    (%eax),%eax
801007d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801007da:	b9 01 00 00 00       	mov    $0x1,%ecx
801007df:	e8 9c fe ff ff       	call   80100680 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007e4:	0f b6 06             	movzbl (%esi),%eax
801007e7:	85 c0                	test   %eax,%eax
801007e9:	74 25                	je     80100810 <cprintf+0xb0>
801007eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801007ee:	83 f8 25             	cmp    $0x25,%eax
801007f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801007f4:	74 aa                	je     801007a0 <cprintf+0x40>
801007f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801007f9:	e8 12 fd ff ff       	call   80100510 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100801:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100804:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100806:	85 c0                	test   %eax,%eax
80100808:	75 e1                	jne    801007eb <cprintf+0x8b>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100810:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100813:	85 c0                	test   %eax,%eax
80100815:	74 10                	je     80100827 <cprintf+0xc7>
    release(&cons.lock);
80100817:	83 ec 0c             	sub    $0xc,%esp
8010081a:	68 20 b5 10 80       	push   $0x8010b520
8010081f:	e8 1c 3e 00 00       	call   80104640 <release>
80100824:	83 c4 10             	add    $0x10,%esp
}
80100827:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010082a:	5b                   	pop    %ebx
8010082b:	5e                   	pop    %esi
8010082c:	5f                   	pop    %edi
8010082d:	5d                   	pop    %ebp
8010082e:	c3                   	ret    
8010082f:	90                   	nop
    switch(c){
80100830:	83 fa 73             	cmp    $0x73,%edx
80100833:	74 43                	je     80100878 <cprintf+0x118>
80100835:	83 fa 78             	cmp    $0x78,%edx
80100838:	75 1e                	jne    80100858 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010083a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010083d:	ba 10 00 00 00       	mov    $0x10,%edx
80100842:	8d 48 04             	lea    0x4(%eax),%ecx
80100845:	8b 00                	mov    (%eax),%eax
80100847:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010084a:	31 c9                	xor    %ecx,%ecx
8010084c:	e8 2f fe ff ff       	call   80100680 <printint>
      break;
80100851:	eb 91                	jmp    801007e4 <cprintf+0x84>
80100853:	90                   	nop
80100854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100858:	b8 25 00 00 00       	mov    $0x25,%eax
8010085d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100860:	e8 ab fc ff ff       	call   80100510 <consputc>
      consputc(c);
80100865:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100868:	89 d0                	mov    %edx,%eax
8010086a:	e8 a1 fc ff ff       	call   80100510 <consputc>
      break;
8010086f:	e9 70 ff ff ff       	jmp    801007e4 <cprintf+0x84>
80100874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100878:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010087b:	8b 10                	mov    (%eax),%edx
8010087d:	8d 48 04             	lea    0x4(%eax),%ecx
80100880:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100883:	85 d2                	test   %edx,%edx
80100885:	74 49                	je     801008d0 <cprintf+0x170>
      for(; *s; s++)
80100887:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010088a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010088d:	84 c0                	test   %al,%al
8010088f:	0f 84 4f ff ff ff    	je     801007e4 <cprintf+0x84>
80100895:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100898:	89 d3                	mov    %edx,%ebx
8010089a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801008a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801008a3:	e8 68 fc ff ff       	call   80100510 <consputc>
      for(; *s; s++)
801008a8:	0f be 03             	movsbl (%ebx),%eax
801008ab:	84 c0                	test   %al,%al
801008ad:	75 f1                	jne    801008a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801008af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801008b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801008b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801008b8:	e9 27 ff ff ff       	jmp    801007e4 <cprintf+0x84>
801008bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801008c0:	b8 25 00 00 00       	mov    $0x25,%eax
801008c5:	e8 46 fc ff ff       	call   80100510 <consputc>
      break;
801008ca:	e9 15 ff ff ff       	jmp    801007e4 <cprintf+0x84>
801008cf:	90                   	nop
        s = "(null)";
801008d0:	ba 1e 76 10 80       	mov    $0x8010761e,%edx
      for(; *s; s++)
801008d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801008d8:	b8 28 00 00 00       	mov    $0x28,%eax
801008dd:	89 d3                	mov    %edx,%ebx
801008df:	eb bf                	jmp    801008a0 <cprintf+0x140>
801008e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801008e8:	83 ec 0c             	sub    $0xc,%esp
801008eb:	68 20 b5 10 80       	push   $0x8010b520
801008f0:	e8 2b 3c 00 00       	call   80104520 <acquire>
801008f5:	83 c4 10             	add    $0x10,%esp
801008f8:	e9 7c fe ff ff       	jmp    80100779 <cprintf+0x19>
    panic("null fmt");
801008fd:	83 ec 0c             	sub    $0xc,%esp
80100900:	68 25 76 10 80       	push   $0x80107625
80100905:	e8 86 fb ff ff       	call   80100490 <panic>
8010090a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100910 <consoleintr>:
{
80100910:	55                   	push   %ebp
80100911:	89 e5                	mov    %esp,%ebp
80100913:	57                   	push   %edi
80100914:	56                   	push   %esi
80100915:	53                   	push   %ebx
  int c, doprocdump = 0;
80100916:	31 f6                	xor    %esi,%esi
{
80100918:	83 ec 18             	sub    $0x18,%esp
8010091b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010091e:	68 20 b5 10 80       	push   $0x8010b520
80100923:	e8 f8 3b 00 00       	call   80104520 <acquire>
  while((c = getc()) >= 0){
80100928:	83 c4 10             	add    $0x10,%esp
8010092b:	90                   	nop
8010092c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100930:	ff d3                	call   *%ebx
80100932:	85 c0                	test   %eax,%eax
80100934:	89 c7                	mov    %eax,%edi
80100936:	78 48                	js     80100980 <consoleintr+0x70>
    switch(c){
80100938:	83 ff 10             	cmp    $0x10,%edi
8010093b:	0f 84 e7 00 00 00    	je     80100a28 <consoleintr+0x118>
80100941:	7e 5d                	jle    801009a0 <consoleintr+0x90>
80100943:	83 ff 15             	cmp    $0x15,%edi
80100946:	0f 84 ec 00 00 00    	je     80100a38 <consoleintr+0x128>
8010094c:	83 ff 7f             	cmp    $0x7f,%edi
8010094f:	75 54                	jne    801009a5 <consoleintr+0x95>
      if(input.e != input.w){
80100951:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100956:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010095c:	74 d2                	je     80100930 <consoleintr+0x20>
        input.e--;
8010095e:	83 e8 01             	sub    $0x1,%eax
80100961:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100966:	b8 00 01 00 00       	mov    $0x100,%eax
8010096b:	e8 a0 fb ff ff       	call   80100510 <consputc>
  while((c = getc()) >= 0){
80100970:	ff d3                	call   *%ebx
80100972:	85 c0                	test   %eax,%eax
80100974:	89 c7                	mov    %eax,%edi
80100976:	79 c0                	jns    80100938 <consoleintr+0x28>
80100978:	90                   	nop
80100979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100980:	83 ec 0c             	sub    $0xc,%esp
80100983:	68 20 b5 10 80       	push   $0x8010b520
80100988:	e8 b3 3c 00 00       	call   80104640 <release>
  if(doprocdump) {
8010098d:	83 c4 10             	add    $0x10,%esp
80100990:	85 f6                	test   %esi,%esi
80100992:	0f 85 f8 00 00 00    	jne    80100a90 <consoleintr+0x180>
}
80100998:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010099b:	5b                   	pop    %ebx
8010099c:	5e                   	pop    %esi
8010099d:	5f                   	pop    %edi
8010099e:	5d                   	pop    %ebp
8010099f:	c3                   	ret    
    switch(c){
801009a0:	83 ff 08             	cmp    $0x8,%edi
801009a3:	74 ac                	je     80100951 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a5:	85 ff                	test   %edi,%edi
801009a7:	74 87                	je     80100930 <consoleintr+0x20>
801009a9:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801009ae:	89 c2                	mov    %eax,%edx
801009b0:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
801009b6:	83 fa 7f             	cmp    $0x7f,%edx
801009b9:	0f 87 71 ff ff ff    	ja     80100930 <consoleintr+0x20>
801009bf:	8d 50 01             	lea    0x1(%eax),%edx
801009c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801009c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801009c8:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
        c = (c == '\r') ? '\n' : c;
801009ce:	0f 84 cc 00 00 00    	je     80100aa0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801009d4:	89 f9                	mov    %edi,%ecx
801009d6:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
        consputc(c);
801009dc:	89 f8                	mov    %edi,%eax
801009de:	e8 2d fb ff ff       	call   80100510 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009e3:	83 ff 0a             	cmp    $0xa,%edi
801009e6:	0f 84 c5 00 00 00    	je     80100ab1 <consoleintr+0x1a1>
801009ec:	83 ff 04             	cmp    $0x4,%edi
801009ef:	0f 84 bc 00 00 00    	je     80100ab1 <consoleintr+0x1a1>
801009f5:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801009fa:	83 e8 80             	sub    $0xffffff80,%eax
801009fd:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80100a03:	0f 85 27 ff ff ff    	jne    80100930 <consoleintr+0x20>
          wakeup(&input.r);
80100a09:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a0c:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
80100a11:	68 a0 0f 11 80       	push   $0x80110fa0
80100a16:	e8 65 37 00 00       	call   80104180 <wakeup>
80100a1b:	83 c4 10             	add    $0x10,%esp
80100a1e:	e9 0d ff ff ff       	jmp    80100930 <consoleintr+0x20>
80100a23:	90                   	nop
80100a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100a28:	be 01 00 00 00       	mov    $0x1,%esi
80100a2d:	e9 fe fe ff ff       	jmp    80100930 <consoleintr+0x20>
80100a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100a38:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100a3d:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
80100a43:	75 2b                	jne    80100a70 <consoleintr+0x160>
80100a45:	e9 e6 fe ff ff       	jmp    80100930 <consoleintr+0x20>
80100a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100a50:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100a55:	b8 00 01 00 00       	mov    $0x100,%eax
80100a5a:	e8 b1 fa ff ff       	call   80100510 <consputc>
      while(input.e != input.w &&
80100a5f:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100a64:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
80100a6a:	0f 84 c0 fe ff ff    	je     80100930 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100a70:	83 e8 01             	sub    $0x1,%eax
80100a73:	89 c2                	mov    %eax,%edx
80100a75:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100a78:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
80100a7f:	75 cf                	jne    80100a50 <consoleintr+0x140>
80100a81:	e9 aa fe ff ff       	jmp    80100930 <consoleintr+0x20>
80100a86:	8d 76 00             	lea    0x0(%esi),%esi
80100a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100a90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a93:	5b                   	pop    %ebx
80100a94:	5e                   	pop    %esi
80100a95:	5f                   	pop    %edi
80100a96:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a97:	e9 c4 37 00 00       	jmp    80104260 <procdump>
80100a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
80100aa0:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
        consputc(c);
80100aa7:	b8 0a 00 00 00       	mov    $0xa,%eax
80100aac:	e8 5f fa ff ff       	call   80100510 <consputc>
80100ab1:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100ab6:	e9 4e ff ff ff       	jmp    80100a09 <consoleintr+0xf9>
80100abb:	90                   	nop
80100abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ac0 <consoleinit>:

void
consoleinit(void)
{
80100ac0:	55                   	push   %ebp
80100ac1:	89 e5                	mov    %esp,%ebp
80100ac3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100ac6:	68 2e 76 10 80       	push   $0x8010762e
80100acb:	68 20 b5 10 80       	push   $0x8010b520
80100ad0:	e8 5b 39 00 00       	call   80104430 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100ad5:	58                   	pop    %eax
80100ad6:	5a                   	pop    %edx
80100ad7:	6a 00                	push   $0x0
80100ad9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100adb:	c7 05 6c 19 11 80 00 	movl   $0x80100700,0x8011196c
80100ae2:	07 10 80 
  devsw[CONSOLE].read = consoleread;
80100ae5:	c7 05 68 19 11 80 70 	movl   $0x80100370,0x80111968
80100aec:	03 10 80 
  cons.locking = 1;
80100aef:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100af6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100af9:	e8 42 1a 00 00       	call   80102540 <ioapicenable>
}
80100afe:	83 c4 10             	add    $0x10,%esp
80100b01:	c9                   	leave  
80100b02:	c3                   	ret    
80100b03:	66 90                	xchg   %ax,%ax
80100b05:	66 90                	xchg   %ax,%ax
80100b07:	66 90                	xchg   %ax,%ax
80100b09:	66 90                	xchg   %ax,%ax
80100b0b:	66 90                	xchg   %ax,%ax
80100b0d:	66 90                	xchg   %ax,%ax
80100b0f:	90                   	nop

80100b10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b10:	55                   	push   %ebp
80100b11:	89 e5                	mov    %esp,%ebp
80100b13:	57                   	push   %edi
80100b14:	56                   	push   %esi
80100b15:	53                   	push   %ebx
80100b16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100b1c:	e8 2f 2f 00 00       	call   80103a50 <myproc>
80100b21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100b27:	e8 e4 22 00 00       	call   80102e10 <begin_op>

  if((ip = namei(path)) == 0){
80100b2c:	83 ec 0c             	sub    $0xc,%esp
80100b2f:	ff 75 08             	pushl  0x8(%ebp)
80100b32:	e8 29 16 00 00       	call   80102160 <namei>
80100b37:	83 c4 10             	add    $0x10,%esp
80100b3a:	85 c0                	test   %eax,%eax
80100b3c:	0f 84 91 01 00 00    	je     80100cd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b42:	83 ec 0c             	sub    $0xc,%esp
80100b45:	89 c3                	mov    %eax,%ebx
80100b47:	50                   	push   %eax
80100b48:	e8 b3 0d 00 00       	call   80101900 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b53:	6a 34                	push   $0x34
80100b55:	6a 00                	push   $0x0
80100b57:	50                   	push   %eax
80100b58:	53                   	push   %ebx
80100b59:	e8 82 10 00 00       	call   80101be0 <readi>
80100b5e:	83 c4 20             	add    $0x20,%esp
80100b61:	83 f8 34             	cmp    $0x34,%eax
80100b64:	74 22                	je     80100b88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b66:	83 ec 0c             	sub    $0xc,%esp
80100b69:	53                   	push   %ebx
80100b6a:	e8 21 10 00 00       	call   80101b90 <iunlockput>
    end_op();
80100b6f:	e8 0c 23 00 00       	call   80102e80 <end_op>
80100b74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b7f:	5b                   	pop    %ebx
80100b80:	5e                   	pop    %esi
80100b81:	5f                   	pop    %edi
80100b82:	5d                   	pop    %ebp
80100b83:	c3                   	ret    
80100b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b8f:	45 4c 46 
80100b92:	75 d2                	jne    80100b66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b94:	e8 37 66 00 00       	call   801071d0 <setupkvm>
80100b99:	85 c0                	test   %eax,%eax
80100b9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100ba1:	74 c3                	je     80100b66 <exec+0x56>
  sz = 0;
80100ba3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ba5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100bac:	00 
80100bad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100bb3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100bb9:	0f 84 8c 02 00 00    	je     80100e4b <exec+0x33b>
80100bbf:	31 f6                	xor    %esi,%esi
80100bc1:	eb 7f                	jmp    80100c42 <exec+0x132>
80100bc3:	90                   	nop
80100bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100bc8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100bcf:	75 63                	jne    80100c34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100bd1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100bd7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100bdd:	0f 82 86 00 00 00    	jb     80100c69 <exec+0x159>
80100be3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100be9:	72 7e                	jb     80100c69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100beb:	83 ec 04             	sub    $0x4,%esp
80100bee:	50                   	push   %eax
80100bef:	57                   	push   %edi
80100bf0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bf6:	e8 25 64 00 00       	call   80107020 <allocuvm>
80100bfb:	83 c4 10             	add    $0x10,%esp
80100bfe:	85 c0                	test   %eax,%eax
80100c00:	89 c7                	mov    %eax,%edi
80100c02:	74 65                	je     80100c69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100c04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100c0f:	75 58                	jne    80100c69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c11:	83 ec 0c             	sub    $0xc,%esp
80100c14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100c1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100c20:	53                   	push   %ebx
80100c21:	50                   	push   %eax
80100c22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c28:	e8 33 63 00 00       	call   80106f60 <loaduvm>
80100c2d:	83 c4 20             	add    $0x20,%esp
80100c30:	85 c0                	test   %eax,%eax
80100c32:	78 35                	js     80100c69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100c3b:	83 c6 01             	add    $0x1,%esi
80100c3e:	39 f0                	cmp    %esi,%eax
80100c40:	7e 3d                	jle    80100c7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c42:	89 f0                	mov    %esi,%eax
80100c44:	6a 20                	push   $0x20
80100c46:	c1 e0 05             	shl    $0x5,%eax
80100c49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100c4f:	50                   	push   %eax
80100c50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c56:	50                   	push   %eax
80100c57:	53                   	push   %ebx
80100c58:	e8 83 0f 00 00       	call   80101be0 <readi>
80100c5d:	83 c4 10             	add    $0x10,%esp
80100c60:	83 f8 20             	cmp    $0x20,%eax
80100c63:	0f 84 5f ff ff ff    	je     80100bc8 <exec+0xb8>
    freevm(pgdir);
80100c69:	83 ec 0c             	sub    $0xc,%esp
80100c6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c72:	e8 d9 64 00 00       	call   80107150 <freevm>
80100c77:	83 c4 10             	add    $0x10,%esp
80100c7a:	e9 e7 fe ff ff       	jmp    80100b66 <exec+0x56>
80100c7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c91:	83 ec 0c             	sub    $0xc,%esp
80100c94:	53                   	push   %ebx
80100c95:	e8 f6 0e 00 00       	call   80101b90 <iunlockput>
  end_op();
80100c9a:	e8 e1 21 00 00       	call   80102e80 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c9f:	83 c4 0c             	add    $0xc,%esp
80100ca2:	56                   	push   %esi
80100ca3:	57                   	push   %edi
80100ca4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100caa:	e8 71 63 00 00       	call   80107020 <allocuvm>
80100caf:	83 c4 10             	add    $0x10,%esp
80100cb2:	85 c0                	test   %eax,%eax
80100cb4:	89 c6                	mov    %eax,%esi
80100cb6:	75 3a                	jne    80100cf2 <exec+0x1e2>
    freevm(pgdir);
80100cb8:	83 ec 0c             	sub    $0xc,%esp
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100cc1:	e8 8a 64 00 00       	call   80107150 <freevm>
80100cc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100cc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cce:	e9 a9 fe ff ff       	jmp    80100b7c <exec+0x6c>
    end_op();
80100cd3:	e8 a8 21 00 00       	call   80102e80 <end_op>
    cprintf("exec: fail\n");
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	68 49 76 10 80       	push   $0x80107649
80100ce0:	e8 7b fa ff ff       	call   80100760 <cprintf>
    return -1;
80100ce5:	83 c4 10             	add    $0x10,%esp
80100ce8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ced:	e9 8a fe ff ff       	jmp    80100b7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100cf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100cfb:	31 ff                	xor    %edi,%edi
80100cfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cff:	50                   	push   %eax
80100d00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100d06:	e8 85 66 00 00       	call   80107390 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d0e:	83 c4 10             	add    $0x10,%esp
80100d11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100d17:	8b 00                	mov    (%eax),%eax
80100d19:	85 c0                	test   %eax,%eax
80100d1b:	74 70                	je     80100d8d <exec+0x27d>
80100d1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100d29:	eb 0a                	jmp    80100d35 <exec+0x225>
80100d2b:	90                   	nop
80100d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100d30:	83 ff 20             	cmp    $0x20,%edi
80100d33:	74 83                	je     80100cb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d35:	83 ec 0c             	sub    $0xc,%esp
80100d38:	50                   	push   %eax
80100d39:	e8 82 3b 00 00       	call   801048c0 <strlen>
80100d3e:	f7 d0                	not    %eax
80100d40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100d4c:	e8 6f 3b 00 00       	call   801048c0 <strlen>
80100d51:	83 c0 01             	add    $0x1,%eax
80100d54:	50                   	push   %eax
80100d55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100d5b:	53                   	push   %ebx
80100d5c:	56                   	push   %esi
80100d5d:	e8 9e 67 00 00       	call   80107500 <copyout>
80100d62:	83 c4 20             	add    $0x20,%esp
80100d65:	85 c0                	test   %eax,%eax
80100d67:	0f 88 4b ff ff ff    	js     80100cb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100d70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100d77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100d7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100d80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100d83:	85 c0                	test   %eax,%eax
80100d85:	75 a9                	jne    80100d30 <exec+0x220>
80100d87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100da1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100da8:	ff ff ff 
  ustack[1] = argc;
80100dab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100db1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100db3:	83 c0 0c             	add    $0xc,%eax
80100db6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100db8:	50                   	push   %eax
80100db9:	52                   	push   %edx
80100dba:	53                   	push   %ebx
80100dbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100dc7:	e8 34 67 00 00       	call   80107500 <copyout>
80100dcc:	83 c4 10             	add    $0x10,%esp
80100dcf:	85 c0                	test   %eax,%eax
80100dd1:	0f 88 e1 fe ff ff    	js     80100cb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100dd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100dda:	0f b6 00             	movzbl (%eax),%eax
80100ddd:	84 c0                	test   %al,%al
80100ddf:	74 17                	je     80100df8 <exec+0x2e8>
80100de1:	8b 55 08             	mov    0x8(%ebp),%edx
80100de4:	89 d1                	mov    %edx,%ecx
80100de6:	83 c1 01             	add    $0x1,%ecx
80100de9:	3c 2f                	cmp    $0x2f,%al
80100deb:	0f b6 01             	movzbl (%ecx),%eax
80100dee:	0f 44 d1             	cmove  %ecx,%edx
80100df1:	84 c0                	test   %al,%al
80100df3:	75 f1                	jne    80100de6 <exec+0x2d6>
80100df5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100df8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100dfe:	50                   	push   %eax
80100dff:	6a 10                	push   $0x10
80100e01:	ff 75 08             	pushl  0x8(%ebp)
80100e04:	89 f8                	mov    %edi,%eax
80100e06:	83 c0 6c             	add    $0x6c,%eax
80100e09:	50                   	push   %eax
80100e0a:	e8 71 3a 00 00       	call   80104880 <safestrcpy>
  curproc->pgdir = pgdir;
80100e0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100e15:	89 f9                	mov    %edi,%ecx
80100e17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100e1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100e1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100e1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100e22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100e28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100e2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100e2e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100e31:	89 0c 24             	mov    %ecx,(%esp)
80100e34:	e8 97 5f 00 00       	call   80106dd0 <switchuvm>
  freevm(oldpgdir);
80100e39:	89 3c 24             	mov    %edi,(%esp)
80100e3c:	e8 0f 63 00 00       	call   80107150 <freevm>
  return 0;
80100e41:	83 c4 10             	add    $0x10,%esp
80100e44:	31 c0                	xor    %eax,%eax
80100e46:	e9 31 fd ff ff       	jmp    80100b7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100e50:	e9 3c fe ff ff       	jmp    80100c91 <exec+0x181>
80100e55:	66 90                	xchg   %ax,%ax
80100e57:	66 90                	xchg   %ax,%ax
80100e59:	66 90                	xchg   %ax,%ax
80100e5b:	66 90                	xchg   %ax,%ax
80100e5d:	66 90                	xchg   %ax,%ax
80100e5f:	90                   	nop

80100e60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e60:	55                   	push   %ebp
80100e61:	89 e5                	mov    %esp,%ebp
80100e63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e66:	68 55 76 10 80       	push   $0x80107655
80100e6b:	68 c0 0f 11 80       	push   $0x80110fc0
80100e70:	e8 bb 35 00 00       	call   80104430 <initlock>
}
80100e75:	83 c4 10             	add    $0x10,%esp
80100e78:	c9                   	leave  
80100e79:	c3                   	ret    
80100e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e80:	55                   	push   %ebp
80100e81:	89 e5                	mov    %esp,%ebp
80100e83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e84:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100e89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e8c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e91:	e8 8a 36 00 00       	call   80104520 <acquire>
80100e96:	83 c4 10             	add    $0x10,%esp
80100e99:	eb 10                	jmp    80100eab <filealloc+0x2b>
80100e9b:	90                   	nop
80100e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ea0:	83 c3 18             	add    $0x18,%ebx
80100ea3:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100ea9:	73 25                	jae    80100ed0 <filealloc+0x50>
    if(f->ref == 0){
80100eab:	8b 43 04             	mov    0x4(%ebx),%eax
80100eae:	85 c0                	test   %eax,%eax
80100eb0:	75 ee                	jne    80100ea0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100eb2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100eb5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100ebc:	68 c0 0f 11 80       	push   $0x80110fc0
80100ec1:	e8 7a 37 00 00       	call   80104640 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ec6:	89 d8                	mov    %ebx,%eax
      return f;
80100ec8:	83 c4 10             	add    $0x10,%esp
}
80100ecb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ece:	c9                   	leave  
80100ecf:	c3                   	ret    
  release(&ftable.lock);
80100ed0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ed3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ed5:	68 c0 0f 11 80       	push   $0x80110fc0
80100eda:	e8 61 37 00 00       	call   80104640 <release>
}
80100edf:	89 d8                	mov    %ebx,%eax
  return 0;
80100ee1:	83 c4 10             	add    $0x10,%esp
}
80100ee4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ee7:	c9                   	leave  
80100ee8:	c3                   	ret    
80100ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 10             	sub    $0x10,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100efa:	68 c0 0f 11 80       	push   $0x80110fc0
80100eff:	e8 1c 36 00 00       	call   80104520 <acquire>
  if(f->ref < 1)
80100f04:	8b 43 04             	mov    0x4(%ebx),%eax
80100f07:	83 c4 10             	add    $0x10,%esp
80100f0a:	85 c0                	test   %eax,%eax
80100f0c:	7e 1a                	jle    80100f28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f17:	68 c0 0f 11 80       	push   $0x80110fc0
80100f1c:	e8 1f 37 00 00       	call   80104640 <release>
  return f;
}
80100f21:	89 d8                	mov    %ebx,%eax
80100f23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f26:	c9                   	leave  
80100f27:	c3                   	ret    
    panic("filedup");
80100f28:	83 ec 0c             	sub    $0xc,%esp
80100f2b:	68 5c 76 10 80       	push   $0x8010765c
80100f30:	e8 5b f5 ff ff       	call   80100490 <panic>
80100f35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 28             	sub    $0x28,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f4c:	68 c0 0f 11 80       	push   $0x80110fc0
80100f51:	e8 ca 35 00 00       	call   80104520 <acquire>
  if(f->ref < 1)
80100f56:	8b 43 04             	mov    0x4(%ebx),%eax
80100f59:	83 c4 10             	add    $0x10,%esp
80100f5c:	85 c0                	test   %eax,%eax
80100f5e:	0f 8e 9b 00 00 00    	jle    80100fff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100f64:	83 e8 01             	sub    $0x1,%eax
80100f67:	85 c0                	test   %eax,%eax
80100f69:	89 43 04             	mov    %eax,0x4(%ebx)
80100f6c:	74 1a                	je     80100f88 <fileclose+0x48>
    release(&ftable.lock);
80100f6e:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f78:	5b                   	pop    %ebx
80100f79:	5e                   	pop    %esi
80100f7a:	5f                   	pop    %edi
80100f7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f7c:	e9 bf 36 00 00       	jmp    80104640 <release>
80100f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100f88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100f8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100f8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100f94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100fa0:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100fa5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100fa8:	e8 93 36 00 00       	call   80104640 <release>
  if(ff.type == FD_PIPE)
80100fad:	83 c4 10             	add    $0x10,%esp
80100fb0:	83 ff 01             	cmp    $0x1,%edi
80100fb3:	74 13                	je     80100fc8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100fb5:	83 ff 02             	cmp    $0x2,%edi
80100fb8:	74 26                	je     80100fe0 <fileclose+0xa0>
}
80100fba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fbd:	5b                   	pop    %ebx
80100fbe:	5e                   	pop    %esi
80100fbf:	5f                   	pop    %edi
80100fc0:	5d                   	pop    %ebp
80100fc1:	c3                   	ret    
80100fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100fc8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fcc:	83 ec 08             	sub    $0x8,%esp
80100fcf:	53                   	push   %ebx
80100fd0:	56                   	push   %esi
80100fd1:	e8 ea 25 00 00       	call   801035c0 <pipeclose>
80100fd6:	83 c4 10             	add    $0x10,%esp
80100fd9:	eb df                	jmp    80100fba <fileclose+0x7a>
80100fdb:	90                   	nop
80100fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100fe0:	e8 2b 1e 00 00       	call   80102e10 <begin_op>
    iput(ff.ip);
80100fe5:	83 ec 0c             	sub    $0xc,%esp
80100fe8:	ff 75 e0             	pushl  -0x20(%ebp)
80100feb:	e8 40 0a 00 00       	call   80101a30 <iput>
    end_op();
80100ff0:	83 c4 10             	add    $0x10,%esp
}
80100ff3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ff6:	5b                   	pop    %ebx
80100ff7:	5e                   	pop    %esi
80100ff8:	5f                   	pop    %edi
80100ff9:	5d                   	pop    %ebp
    end_op();
80100ffa:	e9 81 1e 00 00       	jmp    80102e80 <end_op>
    panic("fileclose");
80100fff:	83 ec 0c             	sub    $0xc,%esp
80101002:	68 64 76 10 80       	push   $0x80107664
80101007:	e8 84 f4 ff ff       	call   80100490 <panic>
8010100c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101010 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101010:	55                   	push   %ebp
80101011:	89 e5                	mov    %esp,%ebp
80101013:	53                   	push   %ebx
80101014:	83 ec 04             	sub    $0x4,%esp
80101017:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010101a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010101d:	75 31                	jne    80101050 <filestat+0x40>
    ilock(f->ip);
8010101f:	83 ec 0c             	sub    $0xc,%esp
80101022:	ff 73 10             	pushl  0x10(%ebx)
80101025:	e8 d6 08 00 00       	call   80101900 <ilock>
    stati(f->ip, st);
8010102a:	58                   	pop    %eax
8010102b:	5a                   	pop    %edx
8010102c:	ff 75 0c             	pushl  0xc(%ebp)
8010102f:	ff 73 10             	pushl  0x10(%ebx)
80101032:	e8 79 0b 00 00       	call   80101bb0 <stati>
    iunlock(f->ip);
80101037:	59                   	pop    %ecx
80101038:	ff 73 10             	pushl  0x10(%ebx)
8010103b:	e8 a0 09 00 00       	call   801019e0 <iunlock>
    return 0;
80101040:	83 c4 10             	add    $0x10,%esp
80101043:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101045:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101048:	c9                   	leave  
80101049:	c3                   	ret    
8010104a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80101050:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101055:	eb ee                	jmp    80101045 <filestat+0x35>
80101057:	89 f6                	mov    %esi,%esi
80101059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101060 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101060:	55                   	push   %ebp
80101061:	89 e5                	mov    %esp,%ebp
80101063:	57                   	push   %edi
80101064:	56                   	push   %esi
80101065:	53                   	push   %ebx
80101066:	83 ec 0c             	sub    $0xc,%esp
80101069:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010106c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010106f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101072:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101076:	74 60                	je     801010d8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101078:	8b 03                	mov    (%ebx),%eax
8010107a:	83 f8 01             	cmp    $0x1,%eax
8010107d:	74 41                	je     801010c0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010107f:	83 f8 02             	cmp    $0x2,%eax
80101082:	75 5b                	jne    801010df <fileread+0x7f>
    ilock(f->ip);
80101084:	83 ec 0c             	sub    $0xc,%esp
80101087:	ff 73 10             	pushl  0x10(%ebx)
8010108a:	e8 71 08 00 00       	call   80101900 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010108f:	57                   	push   %edi
80101090:	ff 73 14             	pushl  0x14(%ebx)
80101093:	56                   	push   %esi
80101094:	ff 73 10             	pushl  0x10(%ebx)
80101097:	e8 44 0b 00 00       	call   80101be0 <readi>
8010109c:	83 c4 20             	add    $0x20,%esp
8010109f:	85 c0                	test   %eax,%eax
801010a1:	89 c6                	mov    %eax,%esi
801010a3:	7e 03                	jle    801010a8 <fileread+0x48>
      f->off += r;
801010a5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010a8:	83 ec 0c             	sub    $0xc,%esp
801010ab:	ff 73 10             	pushl  0x10(%ebx)
801010ae:	e8 2d 09 00 00       	call   801019e0 <iunlock>
    return r;
801010b3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801010b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010b9:	89 f0                	mov    %esi,%eax
801010bb:	5b                   	pop    %ebx
801010bc:	5e                   	pop    %esi
801010bd:	5f                   	pop    %edi
801010be:	5d                   	pop    %ebp
801010bf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801010c0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010c3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c9:	5b                   	pop    %ebx
801010ca:	5e                   	pop    %esi
801010cb:	5f                   	pop    %edi
801010cc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010cd:	e9 9e 26 00 00       	jmp    80103770 <piperead>
801010d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010d8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010dd:	eb d7                	jmp    801010b6 <fileread+0x56>
  panic("fileread");
801010df:	83 ec 0c             	sub    $0xc,%esp
801010e2:	68 6e 76 10 80       	push   $0x8010766e
801010e7:	e8 a4 f3 ff ff       	call   80100490 <panic>
801010ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010f0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010f0:	55                   	push   %ebp
801010f1:	89 e5                	mov    %esp,%ebp
801010f3:	57                   	push   %edi
801010f4:	56                   	push   %esi
801010f5:	53                   	push   %ebx
801010f6:	83 ec 1c             	sub    $0x1c,%esp
801010f9:	8b 75 08             	mov    0x8(%ebp),%esi
801010fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
801010ff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101103:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101106:	8b 45 10             	mov    0x10(%ebp),%eax
80101109:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010110c:	0f 84 aa 00 00 00    	je     801011bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101112:	8b 06                	mov    (%esi),%eax
80101114:	83 f8 01             	cmp    $0x1,%eax
80101117:	0f 84 c3 00 00 00    	je     801011e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010111d:	83 f8 02             	cmp    $0x2,%eax
80101120:	0f 85 d9 00 00 00    	jne    801011ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101126:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101129:	31 ff                	xor    %edi,%edi
    while(i < n){
8010112b:	85 c0                	test   %eax,%eax
8010112d:	7f 34                	jg     80101163 <filewrite+0x73>
8010112f:	e9 9c 00 00 00       	jmp    801011d0 <filewrite+0xe0>
80101134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101138:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010113b:	83 ec 0c             	sub    $0xc,%esp
8010113e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101141:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101144:	e8 97 08 00 00       	call   801019e0 <iunlock>
      end_op();
80101149:	e8 32 1d 00 00       	call   80102e80 <end_op>
8010114e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101151:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101154:	39 c3                	cmp    %eax,%ebx
80101156:	0f 85 96 00 00 00    	jne    801011f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010115c:	01 df                	add    %ebx,%edi
    while(i < n){
8010115e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101161:	7e 6d                	jle    801011d0 <filewrite+0xe0>
      int n1 = n - i;
80101163:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101166:	b8 00 06 00 00       	mov    $0x600,%eax
8010116b:	29 fb                	sub    %edi,%ebx
8010116d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101173:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101176:	e8 95 1c 00 00       	call   80102e10 <begin_op>
      ilock(f->ip);
8010117b:	83 ec 0c             	sub    $0xc,%esp
8010117e:	ff 76 10             	pushl  0x10(%esi)
80101181:	e8 7a 07 00 00       	call   80101900 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101186:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101189:	53                   	push   %ebx
8010118a:	ff 76 14             	pushl  0x14(%esi)
8010118d:	01 f8                	add    %edi,%eax
8010118f:	50                   	push   %eax
80101190:	ff 76 10             	pushl  0x10(%esi)
80101193:	e8 48 0b 00 00       	call   80101ce0 <writei>
80101198:	83 c4 20             	add    $0x20,%esp
8010119b:	85 c0                	test   %eax,%eax
8010119d:	7f 99                	jg     80101138 <filewrite+0x48>
      iunlock(f->ip);
8010119f:	83 ec 0c             	sub    $0xc,%esp
801011a2:	ff 76 10             	pushl  0x10(%esi)
801011a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011a8:	e8 33 08 00 00       	call   801019e0 <iunlock>
      end_op();
801011ad:	e8 ce 1c 00 00       	call   80102e80 <end_op>
      if(r < 0)
801011b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011b5:	83 c4 10             	add    $0x10,%esp
801011b8:	85 c0                	test   %eax,%eax
801011ba:	74 98                	je     80101154 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801011bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801011bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801011c4:	89 f8                	mov    %edi,%eax
801011c6:	5b                   	pop    %ebx
801011c7:	5e                   	pop    %esi
801011c8:	5f                   	pop    %edi
801011c9:	5d                   	pop    %ebp
801011ca:	c3                   	ret    
801011cb:	90                   	nop
801011cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801011d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801011d3:	75 e7                	jne    801011bc <filewrite+0xcc>
}
801011d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011d8:	89 f8                	mov    %edi,%eax
801011da:	5b                   	pop    %ebx
801011db:	5e                   	pop    %esi
801011dc:	5f                   	pop    %edi
801011dd:	5d                   	pop    %ebp
801011de:	c3                   	ret    
801011df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801011e0:	8b 46 0c             	mov    0xc(%esi),%eax
801011e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011e9:	5b                   	pop    %ebx
801011ea:	5e                   	pop    %esi
801011eb:	5f                   	pop    %edi
801011ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011ed:	e9 6e 24 00 00       	jmp    80103660 <pipewrite>
        panic("short filewrite");
801011f2:	83 ec 0c             	sub    $0xc,%esp
801011f5:	68 77 76 10 80       	push   $0x80107677
801011fa:	e8 91 f2 ff ff       	call   80100490 <panic>
  panic("filewrite");
801011ff:	83 ec 0c             	sub    $0xc,%esp
80101202:	68 7d 76 10 80       	push   $0x8010767d
80101207:	e8 84 f2 ff ff       	call   80100490 <panic>
8010120c:	66 90                	xchg   %ax,%ax
8010120e:	66 90                	xchg   %ax,%ax

80101210 <bzero>:
}

// Zero a block.
static void
bzero(int dev, int bno)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	53                   	push   %ebx
80101214:	83 ec 0c             	sub    $0xc,%esp
  struct buf *bp;

  bp = bread(dev, bno);
80101217:	52                   	push   %edx
80101218:	50                   	push   %eax
80101219:	e8 b2 ee ff ff       	call   801000d0 <bread>
8010121e:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101220:	8d 40 5c             	lea    0x5c(%eax),%eax
80101223:	83 c4 0c             	add    $0xc,%esp
80101226:	68 00 02 00 00       	push   $0x200
8010122b:	6a 00                	push   $0x0
8010122d:	50                   	push   %eax
8010122e:	e8 6d 34 00 00       	call   801046a0 <memset>
  log_write(bp);
80101233:	89 1c 24             	mov    %ebx,(%esp)
80101236:	e8 a5 1d 00 00       	call   80102fe0 <log_write>
  brelse(bp);
8010123b:	89 1c 24             	mov    %ebx,(%esp)
8010123e:	e8 9d ef ff ff       	call   801001e0 <brelse>
}
80101243:	83 c4 10             	add    $0x10,%esp
80101246:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101249:	c9                   	leave  
8010124a:	c3                   	ret    
8010124b:	90                   	nop
8010124c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101250 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101250:	55                   	push   %ebp
80101251:	89 e5                	mov    %esp,%ebp
80101253:	57                   	push   %edi
80101254:	56                   	push   %esi
80101255:	53                   	push   %ebx
80101256:	83 ec 1c             	sub    $0x1c,%esp
80101259:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010125c:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101261:	85 c0                	test   %eax,%eax
80101263:	0f 84 8c 00 00 00    	je     801012f5 <balloc+0xa5>
80101269:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101270:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101273:	83 ec 08             	sub    $0x8,%esp
80101276:	89 f0                	mov    %esi,%eax
80101278:	c1 f8 0c             	sar    $0xc,%eax
8010127b:	03 05 d8 19 11 80    	add    0x801119d8,%eax
80101281:	50                   	push   %eax
80101282:	ff 75 d8             	pushl  -0x28(%ebp)
80101285:	e8 46 ee ff ff       	call   801000d0 <bread>
8010128a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010128d:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101292:	83 c4 10             	add    $0x10,%esp
80101295:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101298:	31 c0                	xor    %eax,%eax
8010129a:	eb 30                	jmp    801012cc <balloc+0x7c>
8010129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
801012a0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801012a5:	bb 01 00 00 00       	mov    $0x1,%ebx
801012aa:	83 e1 07             	and    $0x7,%ecx
801012ad:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012af:	89 c1                	mov    %eax,%ecx
801012b1:	c1 f9 03             	sar    $0x3,%ecx
801012b4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012b9:	85 df                	test   %ebx,%edi
801012bb:	89 fa                	mov    %edi,%edx
801012bd:	74 49                	je     80101308 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012bf:	83 c0 01             	add    $0x1,%eax
801012c2:	83 c6 01             	add    $0x1,%esi
801012c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ca:	74 05                	je     801012d1 <balloc+0x81>
801012cc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012cf:	77 cf                	ja     801012a0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012d7:	e8 04 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012dc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012e3:	83 c4 10             	add    $0x10,%esp
801012e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012e9:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
801012ef:	0f 87 7b ff ff ff    	ja     80101270 <balloc+0x20>
  }
  panic("balloc: out of blocks");
801012f5:	83 ec 0c             	sub    $0xc,%esp
801012f8:	68 87 76 10 80       	push   $0x80107687
801012fd:	e8 8e f1 ff ff       	call   80100490 <panic>
80101302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101308:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
8010130b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
8010130e:	09 da                	or     %ebx,%edx
80101310:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80101314:	57                   	push   %edi
80101315:	e8 c6 1c 00 00       	call   80102fe0 <log_write>
        brelse(bp);
8010131a:	89 3c 24             	mov    %edi,(%esp)
8010131d:	e8 be ee ff ff       	call   801001e0 <brelse>
        bzero(dev, b + bi);
80101322:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101325:	89 f2                	mov    %esi,%edx
80101327:	e8 e4 fe ff ff       	call   80101210 <bzero>
}
8010132c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010132f:	89 f0                	mov    %esi,%eax
80101331:	5b                   	pop    %ebx
80101332:	5e                   	pop    %esi
80101333:	5f                   	pop    %edi
80101334:	5d                   	pop    %ebp
80101335:	c3                   	ret    
80101336:	8d 76 00             	lea    0x0(%esi),%esi
80101339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101340 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101340:	55                   	push   %ebp
80101341:	89 e5                	mov    %esp,%ebp
80101343:	57                   	push   %edi
80101344:	56                   	push   %esi
80101345:	53                   	push   %ebx
80101346:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101348:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010134a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
{
8010134f:	83 ec 28             	sub    $0x28,%esp
80101352:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101355:	68 e0 19 11 80       	push   $0x801119e0
8010135a:	e8 c1 31 00 00       	call   80104520 <acquire>
8010135f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101362:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101365:	eb 17                	jmp    8010137e <iget+0x3e>
80101367:	89 f6                	mov    %esi,%esi
80101369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101370:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101376:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
8010137c:	73 22                	jae    801013a0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010137e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101381:	85 c9                	test   %ecx,%ecx
80101383:	7e 04                	jle    80101389 <iget+0x49>
80101385:	39 3b                	cmp    %edi,(%ebx)
80101387:	74 4f                	je     801013d8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101389:	85 f6                	test   %esi,%esi
8010138b:	75 e3                	jne    80101370 <iget+0x30>
8010138d:	85 c9                	test   %ecx,%ecx
8010138f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101392:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101398:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
8010139e:	72 de                	jb     8010137e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013a0:	85 f6                	test   %esi,%esi
801013a2:	74 5b                	je     801013ff <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013a4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013a7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013a9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013ac:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013b3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013ba:	68 e0 19 11 80       	push   $0x801119e0
801013bf:	e8 7c 32 00 00       	call   80104640 <release>

  return ip;
801013c4:	83 c4 10             	add    $0x10,%esp
}
801013c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013ca:	89 f0                	mov    %esi,%eax
801013cc:	5b                   	pop    %ebx
801013cd:	5e                   	pop    %esi
801013ce:	5f                   	pop    %edi
801013cf:	5d                   	pop    %ebp
801013d0:	c3                   	ret    
801013d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013d8:	39 53 04             	cmp    %edx,0x4(%ebx)
801013db:	75 ac                	jne    80101389 <iget+0x49>
      release(&icache.lock);
801013dd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013e0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013e3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013e5:	68 e0 19 11 80       	push   $0x801119e0
      ip->ref++;
801013ea:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801013ed:	e8 4e 32 00 00       	call   80104640 <release>
      return ip;
801013f2:	83 c4 10             	add    $0x10,%esp
}
801013f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013f8:	89 f0                	mov    %esi,%eax
801013fa:	5b                   	pop    %ebx
801013fb:	5e                   	pop    %esi
801013fc:	5f                   	pop    %edi
801013fd:	5d                   	pop    %ebp
801013fe:	c3                   	ret    
    panic("iget: no inodes");
801013ff:	83 ec 0c             	sub    $0xc,%esp
80101402:	68 9d 76 10 80       	push   $0x8010769d
80101407:	e8 84 f0 ff ff       	call   80100490 <panic>
8010140c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101410 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	57                   	push   %edi
80101414:	56                   	push   %esi
80101415:	53                   	push   %ebx
80101416:	89 c6                	mov    %eax,%esi
80101418:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010141b:	83 fa 0b             	cmp    $0xb,%edx
8010141e:	77 18                	ja     80101438 <bmap+0x28>
80101420:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101423:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101426:	85 db                	test   %ebx,%ebx
80101428:	74 76                	je     801014a0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010142a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010142d:	89 d8                	mov    %ebx,%eax
8010142f:	5b                   	pop    %ebx
80101430:	5e                   	pop    %esi
80101431:	5f                   	pop    %edi
80101432:	5d                   	pop    %ebp
80101433:	c3                   	ret    
80101434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101438:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010143b:	83 fb 7f             	cmp    $0x7f,%ebx
8010143e:	0f 87 90 00 00 00    	ja     801014d4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101444:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010144a:	8b 00                	mov    (%eax),%eax
8010144c:	85 d2                	test   %edx,%edx
8010144e:	74 70                	je     801014c0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101450:	83 ec 08             	sub    $0x8,%esp
80101453:	52                   	push   %edx
80101454:	50                   	push   %eax
80101455:	e8 76 ec ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010145a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010145e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101461:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101463:	8b 1a                	mov    (%edx),%ebx
80101465:	85 db                	test   %ebx,%ebx
80101467:	75 1d                	jne    80101486 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101469:	8b 06                	mov    (%esi),%eax
8010146b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010146e:	e8 dd fd ff ff       	call   80101250 <balloc>
80101473:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101476:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101479:	89 c3                	mov    %eax,%ebx
8010147b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010147d:	57                   	push   %edi
8010147e:	e8 5d 1b 00 00       	call   80102fe0 <log_write>
80101483:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101486:	83 ec 0c             	sub    $0xc,%esp
80101489:	57                   	push   %edi
8010148a:	e8 51 ed ff ff       	call   801001e0 <brelse>
8010148f:	83 c4 10             	add    $0x10,%esp
}
80101492:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101495:	89 d8                	mov    %ebx,%eax
80101497:	5b                   	pop    %ebx
80101498:	5e                   	pop    %esi
80101499:	5f                   	pop    %edi
8010149a:	5d                   	pop    %ebp
8010149b:	c3                   	ret    
8010149c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801014a0:	8b 00                	mov    (%eax),%eax
801014a2:	e8 a9 fd ff ff       	call   80101250 <balloc>
801014a7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801014aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801014ad:	89 c3                	mov    %eax,%ebx
}
801014af:	89 d8                	mov    %ebx,%eax
801014b1:	5b                   	pop    %ebx
801014b2:	5e                   	pop    %esi
801014b3:	5f                   	pop    %edi
801014b4:	5d                   	pop    %ebp
801014b5:	c3                   	ret    
801014b6:	8d 76 00             	lea    0x0(%esi),%esi
801014b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014c0:	e8 8b fd ff ff       	call   80101250 <balloc>
801014c5:	89 c2                	mov    %eax,%edx
801014c7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014cd:	8b 06                	mov    (%esi),%eax
801014cf:	e9 7c ff ff ff       	jmp    80101450 <bmap+0x40>
  panic("bmap: out of range");
801014d4:	83 ec 0c             	sub    $0xc,%esp
801014d7:	68 ad 76 10 80       	push   $0x801076ad
801014dc:	e8 af ef ff ff       	call   80100490 <panic>
801014e1:	eb 0d                	jmp    801014f0 <readsb>
801014e3:	90                   	nop
801014e4:	90                   	nop
801014e5:	90                   	nop
801014e6:	90                   	nop
801014e7:	90                   	nop
801014e8:	90                   	nop
801014e9:	90                   	nop
801014ea:	90                   	nop
801014eb:	90                   	nop
801014ec:	90                   	nop
801014ed:	90                   	nop
801014ee:	90                   	nop
801014ef:	90                   	nop

801014f0 <readsb>:
{
801014f0:	55                   	push   %ebp
801014f1:	89 e5                	mov    %esp,%ebp
801014f3:	56                   	push   %esi
801014f4:	53                   	push   %ebx
801014f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801014f8:	83 ec 08             	sub    $0x8,%esp
801014fb:	6a 01                	push   $0x1
801014fd:	ff 75 08             	pushl  0x8(%ebp)
80101500:	e8 cb eb ff ff       	call   801000d0 <bread>
80101505:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101507:	8d 40 5c             	lea    0x5c(%eax),%eax
8010150a:	83 c4 0c             	add    $0xc,%esp
8010150d:	6a 1c                	push   $0x1c
8010150f:	50                   	push   %eax
80101510:	56                   	push   %esi
80101511:	e8 3a 32 00 00       	call   80104750 <memmove>
  brelse(bp);
80101516:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101519:	83 c4 10             	add    $0x10,%esp
}
8010151c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010151f:	5b                   	pop    %ebx
80101520:	5e                   	pop    %esi
80101521:	5d                   	pop    %ebp
  brelse(bp);
80101522:	e9 b9 ec ff ff       	jmp    801001e0 <brelse>
80101527:	89 f6                	mov    %esi,%esi
80101529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101530 <bfree>:
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	56                   	push   %esi
80101534:	53                   	push   %ebx
80101535:	89 d3                	mov    %edx,%ebx
80101537:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101539:	83 ec 08             	sub    $0x8,%esp
8010153c:	68 c0 19 11 80       	push   $0x801119c0
80101541:	50                   	push   %eax
80101542:	e8 a9 ff ff ff       	call   801014f0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101547:	58                   	pop    %eax
80101548:	5a                   	pop    %edx
80101549:	89 da                	mov    %ebx,%edx
8010154b:	c1 ea 0c             	shr    $0xc,%edx
8010154e:	03 15 d8 19 11 80    	add    0x801119d8,%edx
80101554:	52                   	push   %edx
80101555:	56                   	push   %esi
80101556:	e8 75 eb ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010155b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010155d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101560:	ba 01 00 00 00       	mov    $0x1,%edx
80101565:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101568:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010156e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101571:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101573:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101578:	85 d1                	test   %edx,%ecx
8010157a:	74 25                	je     801015a1 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010157c:	f7 d2                	not    %edx
8010157e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101580:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101583:	21 ca                	and    %ecx,%edx
80101585:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101589:	56                   	push   %esi
8010158a:	e8 51 1a 00 00       	call   80102fe0 <log_write>
  brelse(bp);
8010158f:	89 34 24             	mov    %esi,(%esp)
80101592:	e8 49 ec ff ff       	call   801001e0 <brelse>
}
80101597:	83 c4 10             	add    $0x10,%esp
8010159a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010159d:	5b                   	pop    %ebx
8010159e:	5e                   	pop    %esi
8010159f:	5d                   	pop    %ebp
801015a0:	c3                   	ret    
    panic("freeing free block");
801015a1:	83 ec 0c             	sub    $0xc,%esp
801015a4:	68 c0 76 10 80       	push   $0x801076c0
801015a9:	e8 e2 ee ff ff       	call   80100490 <panic>
801015ae:	66 90                	xchg   %ax,%ax

801015b0 <balloc_page>:
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	57                   	push   %edi
801015b4:	56                   	push   %esi
801015b5:	53                   	push   %ebx
801015b6:	83 ec 28             	sub    $0x28,%esp
  cprintf("balloc page\n");
801015b9:	68 d3 76 10 80       	push   $0x801076d3
801015be:	e8 9d f1 ff ff       	call   80100760 <cprintf>
  begin_op();
801015c3:	e8 48 18 00 00       	call   80102e10 <begin_op>
  for(b = 0; b < sb.size; b += BPB){
801015c8:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
801015ce:	83 c4 10             	add    $0x10,%esp
801015d1:	85 c9                	test   %ecx,%ecx
801015d3:	74 63                	je     80101638 <balloc_page+0x88>
801015d5:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
801015d7:	89 f8                	mov    %edi,%eax
801015d9:	83 ec 08             	sub    $0x8,%esp
801015dc:	89 fb                	mov    %edi,%ebx
801015de:	c1 f8 0c             	sar    $0xc,%eax
801015e1:	03 05 d8 19 11 80    	add    0x801119d8,%eax
801015e7:	50                   	push   %eax
801015e8:	ff 75 08             	pushl  0x8(%ebp)
801015eb:	e8 e0 ea ff ff       	call   801000d0 <bread>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015f0:	8b 35 c0 19 11 80    	mov    0x801119c0,%esi
801015f6:	83 c4 10             	add    $0x10,%esp
801015f9:	31 d2                	xor    %edx,%edx
801015fb:	eb 1d                	jmp    8010161a <balloc_page+0x6a>
801015fd:	8d 76 00             	lea    0x0(%esi),%esi
      if((bp->data[bi/8] & m) == 0){  // Are 8 consecutive block free?
80101600:	89 d1                	mov    %edx,%ecx
80101602:	c1 f9 03             	sar    $0x3,%ecx
80101605:	80 7c 08 5c 00       	cmpb   $0x0,0x5c(%eax,%ecx,1)
8010160a:	74 44                	je     80101650 <balloc_page+0xa0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010160c:	83 c2 01             	add    $0x1,%edx
8010160f:	83 c3 01             	add    $0x1,%ebx
80101612:	81 fa 00 10 00 00    	cmp    $0x1000,%edx
80101618:	74 04                	je     8010161e <balloc_page+0x6e>
8010161a:	39 de                	cmp    %ebx,%esi
8010161c:	77 e2                	ja     80101600 <balloc_page+0x50>
    brelse(bp);
8010161e:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
80101621:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
80101627:	50                   	push   %eax
80101628:	e8 b3 eb ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010162d:	83 c4 10             	add    $0x10,%esp
80101630:	39 3d c0 19 11 80    	cmp    %edi,0x801119c0
80101636:	77 9f                	ja     801015d7 <balloc_page+0x27>
  end_op();
80101638:	e8 43 18 00 00       	call   80102e80 <end_op>
  panic("balloc: out of blocks");
8010163d:	83 ec 0c             	sub    $0xc,%esp
80101640:	68 87 76 10 80       	push   $0x80107687
80101645:	e8 46 ee ff ff       	call   80100490 <panic>
8010164a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	      log_write(bp);
80101650:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark blocks in use.
80101653:	c6 44 08 5c ff       	movb   $0xff,0x5c(%eax,%ecx,1)
80101658:	89 c6                	mov    %eax,%esi
	      log_write(bp);
8010165a:	50                   	push   %eax
8010165b:	e8 80 19 00 00       	call   80102fe0 <log_write>
        brelse(bp);
80101660:	89 34 24             	mov    %esi,(%esp)
80101663:	8d b3 00 10 00 00    	lea    0x1000(%ebx),%esi
80101669:	e8 72 eb ff ff       	call   801001e0 <brelse>
8010166e:	8b 7d 08             	mov    0x8(%ebp),%edi
80101671:	83 c4 10             	add    $0x10,%esp
80101674:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101677:	89 f6                	mov    %esi,%esi
80101679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        bzero(dev, b + bi + (BSIZE*i));
80101680:	89 da                	mov    %ebx,%edx
80101682:	89 f8                	mov    %edi,%eax
80101684:	81 c3 00 02 00 00    	add    $0x200,%ebx
8010168a:	e8 81 fb ff ff       	call   80101210 <bzero>
        for(int i=0; i<8;i++){  //Set blocks to 0
8010168f:	39 de                	cmp    %ebx,%esi
80101691:	75 ed                	jne    80101680 <balloc_page+0xd0>
        cprintf("allocated \n");
80101693:	83 ec 0c             	sub    $0xc,%esp
80101696:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101699:	68 e0 76 10 80       	push   $0x801076e0
8010169e:	e8 bd f0 ff ff       	call   80100760 <cprintf>
        end_op();
801016a3:	e8 d8 17 00 00       	call   80102e80 <end_op>
        cprintf("%d\n",b+bi);
801016a8:	58                   	pop    %eax
801016a9:	5a                   	pop    %edx
801016aa:	53                   	push   %ebx
801016ab:	68 20 80 10 80       	push   $0x80108020
801016b0:	e8 ab f0 ff ff       	call   80100760 <cprintf>
}
801016b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016b8:	89 d8                	mov    %ebx,%eax
801016ba:	5b                   	pop    %ebx
801016bb:	5e                   	pop    %esi
801016bc:	5f                   	pop    %edi
801016bd:	5d                   	pop    %ebp
801016be:	c3                   	ret    
801016bf:	90                   	nop

801016c0 <bfree_page>:
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	57                   	push   %edi
801016c4:	56                   	push   %esi
801016c5:	53                   	push   %ebx
801016c6:	83 ec 0c             	sub    $0xc,%esp
801016c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801016cc:	8b 7d 08             	mov    0x8(%ebp),%edi
  begin_op();
801016cf:	e8 3c 17 00 00       	call   80102e10 <begin_op>
801016d4:	8d 73 08             	lea    0x8(%ebx),%esi
801016d7:	89 f6                	mov    %esi,%esi
801016d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
   bfree(dev,b+i);
801016e0:	89 da                	mov    %ebx,%edx
801016e2:	89 f8                	mov    %edi,%eax
801016e4:	83 c3 01             	add    $0x1,%ebx
801016e7:	e8 44 fe ff ff       	call   80101530 <bfree>
  for(uint i=0; i<8;i++){
801016ec:	39 f3                	cmp    %esi,%ebx
801016ee:	75 f0                	jne    801016e0 <bfree_page+0x20>
}
801016f0:	83 c4 0c             	add    $0xc,%esp
801016f3:	5b                   	pop    %ebx
801016f4:	5e                   	pop    %esi
801016f5:	5f                   	pop    %edi
801016f6:	5d                   	pop    %ebp
  end_op();
801016f7:	e9 84 17 00 00       	jmp    80102e80 <end_op>
801016fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101700 <iinit>:
{
80101700:	55                   	push   %ebp
80101701:	89 e5                	mov    %esp,%ebp
80101703:	53                   	push   %ebx
80101704:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
80101709:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010170c:	68 ec 76 10 80       	push   $0x801076ec
80101711:	68 e0 19 11 80       	push   $0x801119e0
80101716:	e8 15 2d 00 00       	call   80104430 <initlock>
8010171b:	83 c4 10             	add    $0x10,%esp
8010171e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101720:	83 ec 08             	sub    $0x8,%esp
80101723:	68 f3 76 10 80       	push   $0x801076f3
80101728:	53                   	push   %ebx
80101729:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010172f:	e8 ec 2b 00 00       	call   80104320 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101734:	83 c4 10             	add    $0x10,%esp
80101737:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
8010173d:	75 e1                	jne    80101720 <iinit+0x20>
  readsb(dev, &sb);
8010173f:	83 ec 08             	sub    $0x8,%esp
80101742:	68 c0 19 11 80       	push   $0x801119c0
80101747:	ff 75 08             	pushl  0x8(%ebp)
8010174a:	e8 a1 fd ff ff       	call   801014f0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010174f:	ff 35 d8 19 11 80    	pushl  0x801119d8
80101755:	ff 35 d4 19 11 80    	pushl  0x801119d4
8010175b:	ff 35 d0 19 11 80    	pushl  0x801119d0
80101761:	ff 35 cc 19 11 80    	pushl  0x801119cc
80101767:	ff 35 c8 19 11 80    	pushl  0x801119c8
8010176d:	ff 35 c4 19 11 80    	pushl  0x801119c4
80101773:	ff 35 c0 19 11 80    	pushl  0x801119c0
80101779:	68 58 77 10 80       	push   $0x80107758
8010177e:	e8 dd ef ff ff       	call   80100760 <cprintf>
}
80101783:	83 c4 30             	add    $0x30,%esp
80101786:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101789:	c9                   	leave  
8010178a:	c3                   	ret    
8010178b:	90                   	nop
8010178c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101790 <ialloc>:
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	57                   	push   %edi
80101794:	56                   	push   %esi
80101795:	53                   	push   %ebx
80101796:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101799:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
{
801017a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801017a3:	8b 75 08             	mov    0x8(%ebp),%esi
801017a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801017a9:	0f 86 91 00 00 00    	jbe    80101840 <ialloc+0xb0>
801017af:	bb 01 00 00 00       	mov    $0x1,%ebx
801017b4:	eb 21                	jmp    801017d7 <ialloc+0x47>
801017b6:	8d 76 00             	lea    0x0(%esi),%esi
801017b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
801017c0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801017c3:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
801017c6:	57                   	push   %edi
801017c7:	e8 14 ea ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801017cc:	83 c4 10             	add    $0x10,%esp
801017cf:	39 1d c8 19 11 80    	cmp    %ebx,0x801119c8
801017d5:	76 69                	jbe    80101840 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801017d7:	89 d8                	mov    %ebx,%eax
801017d9:	83 ec 08             	sub    $0x8,%esp
801017dc:	c1 e8 03             	shr    $0x3,%eax
801017df:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801017e5:	50                   	push   %eax
801017e6:	56                   	push   %esi
801017e7:	e8 e4 e8 ff ff       	call   801000d0 <bread>
801017ec:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801017ee:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801017f0:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
801017f3:	83 e0 07             	and    $0x7,%eax
801017f6:	c1 e0 06             	shl    $0x6,%eax
801017f9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801017fd:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101801:	75 bd                	jne    801017c0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101803:	83 ec 04             	sub    $0x4,%esp
80101806:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101809:	6a 40                	push   $0x40
8010180b:	6a 00                	push   $0x0
8010180d:	51                   	push   %ecx
8010180e:	e8 8d 2e 00 00       	call   801046a0 <memset>
      dip->type = type;
80101813:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101817:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010181a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010181d:	89 3c 24             	mov    %edi,(%esp)
80101820:	e8 bb 17 00 00       	call   80102fe0 <log_write>
      brelse(bp);
80101825:	89 3c 24             	mov    %edi,(%esp)
80101828:	e8 b3 e9 ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010182d:	83 c4 10             	add    $0x10,%esp
}
80101830:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101833:	89 da                	mov    %ebx,%edx
80101835:	89 f0                	mov    %esi,%eax
}
80101837:	5b                   	pop    %ebx
80101838:	5e                   	pop    %esi
80101839:	5f                   	pop    %edi
8010183a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010183b:	e9 00 fb ff ff       	jmp    80101340 <iget>
  panic("ialloc: no inodes");
80101840:	83 ec 0c             	sub    $0xc,%esp
80101843:	68 f9 76 10 80       	push   $0x801076f9
80101848:	e8 43 ec ff ff       	call   80100490 <panic>
8010184d:	8d 76 00             	lea    0x0(%esi),%esi

80101850 <iupdate>:
{
80101850:	55                   	push   %ebp
80101851:	89 e5                	mov    %esp,%ebp
80101853:	56                   	push   %esi
80101854:	53                   	push   %ebx
80101855:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101858:	83 ec 08             	sub    $0x8,%esp
8010185b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010185e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101861:	c1 e8 03             	shr    $0x3,%eax
80101864:	03 05 d4 19 11 80    	add    0x801119d4,%eax
8010186a:	50                   	push   %eax
8010186b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010186e:	e8 5d e8 ff ff       	call   801000d0 <bread>
80101873:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101875:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101878:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010187c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010187f:	83 e0 07             	and    $0x7,%eax
80101882:	c1 e0 06             	shl    $0x6,%eax
80101885:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101889:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010188c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101890:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101893:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101897:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010189b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010189f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801018a3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801018a7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801018aa:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018ad:	6a 34                	push   $0x34
801018af:	53                   	push   %ebx
801018b0:	50                   	push   %eax
801018b1:	e8 9a 2e 00 00       	call   80104750 <memmove>
  log_write(bp);
801018b6:	89 34 24             	mov    %esi,(%esp)
801018b9:	e8 22 17 00 00       	call   80102fe0 <log_write>
  brelse(bp);
801018be:	89 75 08             	mov    %esi,0x8(%ebp)
801018c1:	83 c4 10             	add    $0x10,%esp
}
801018c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018c7:	5b                   	pop    %ebx
801018c8:	5e                   	pop    %esi
801018c9:	5d                   	pop    %ebp
  brelse(bp);
801018ca:	e9 11 e9 ff ff       	jmp    801001e0 <brelse>
801018cf:	90                   	nop

801018d0 <idup>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	53                   	push   %ebx
801018d4:	83 ec 10             	sub    $0x10,%esp
801018d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801018da:	68 e0 19 11 80       	push   $0x801119e0
801018df:	e8 3c 2c 00 00       	call   80104520 <acquire>
  ip->ref++;
801018e4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018e8:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801018ef:	e8 4c 2d 00 00       	call   80104640 <release>
}
801018f4:	89 d8                	mov    %ebx,%eax
801018f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018f9:	c9                   	leave  
801018fa:	c3                   	ret    
801018fb:	90                   	nop
801018fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101900 <ilock>:
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	56                   	push   %esi
80101904:	53                   	push   %ebx
80101905:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101908:	85 db                	test   %ebx,%ebx
8010190a:	0f 84 b7 00 00 00    	je     801019c7 <ilock+0xc7>
80101910:	8b 53 08             	mov    0x8(%ebx),%edx
80101913:	85 d2                	test   %edx,%edx
80101915:	0f 8e ac 00 00 00    	jle    801019c7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010191b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010191e:	83 ec 0c             	sub    $0xc,%esp
80101921:	50                   	push   %eax
80101922:	e8 39 2a 00 00       	call   80104360 <acquiresleep>
  if(ip->valid == 0){
80101927:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010192a:	83 c4 10             	add    $0x10,%esp
8010192d:	85 c0                	test   %eax,%eax
8010192f:	74 0f                	je     80101940 <ilock+0x40>
}
80101931:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101934:	5b                   	pop    %ebx
80101935:	5e                   	pop    %esi
80101936:	5d                   	pop    %ebp
80101937:	c3                   	ret    
80101938:	90                   	nop
80101939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101940:	8b 43 04             	mov    0x4(%ebx),%eax
80101943:	83 ec 08             	sub    $0x8,%esp
80101946:	c1 e8 03             	shr    $0x3,%eax
80101949:	03 05 d4 19 11 80    	add    0x801119d4,%eax
8010194f:	50                   	push   %eax
80101950:	ff 33                	pushl  (%ebx)
80101952:	e8 79 e7 ff ff       	call   801000d0 <bread>
80101957:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101959:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010195c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010195f:	83 e0 07             	and    $0x7,%eax
80101962:	c1 e0 06             	shl    $0x6,%eax
80101965:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101969:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010196c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010196f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101973:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101977:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010197b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010197f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101983:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101987:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010198b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010198e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101991:	6a 34                	push   $0x34
80101993:	50                   	push   %eax
80101994:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101997:	50                   	push   %eax
80101998:	e8 b3 2d 00 00       	call   80104750 <memmove>
    brelse(bp);
8010199d:	89 34 24             	mov    %esi,(%esp)
801019a0:	e8 3b e8 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
801019a5:	83 c4 10             	add    $0x10,%esp
801019a8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801019ad:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801019b4:	0f 85 77 ff ff ff    	jne    80101931 <ilock+0x31>
      panic("ilock: no type");
801019ba:	83 ec 0c             	sub    $0xc,%esp
801019bd:	68 11 77 10 80       	push   $0x80107711
801019c2:	e8 c9 ea ff ff       	call   80100490 <panic>
    panic("ilock");
801019c7:	83 ec 0c             	sub    $0xc,%esp
801019ca:	68 0b 77 10 80       	push   $0x8010770b
801019cf:	e8 bc ea ff ff       	call   80100490 <panic>
801019d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801019da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801019e0 <iunlock>:
{
801019e0:	55                   	push   %ebp
801019e1:	89 e5                	mov    %esp,%ebp
801019e3:	56                   	push   %esi
801019e4:	53                   	push   %ebx
801019e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801019e8:	85 db                	test   %ebx,%ebx
801019ea:	74 28                	je     80101a14 <iunlock+0x34>
801019ec:	8d 73 0c             	lea    0xc(%ebx),%esi
801019ef:	83 ec 0c             	sub    $0xc,%esp
801019f2:	56                   	push   %esi
801019f3:	e8 08 2a 00 00       	call   80104400 <holdingsleep>
801019f8:	83 c4 10             	add    $0x10,%esp
801019fb:	85 c0                	test   %eax,%eax
801019fd:	74 15                	je     80101a14 <iunlock+0x34>
801019ff:	8b 43 08             	mov    0x8(%ebx),%eax
80101a02:	85 c0                	test   %eax,%eax
80101a04:	7e 0e                	jle    80101a14 <iunlock+0x34>
  releasesleep(&ip->lock);
80101a06:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101a09:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a0c:	5b                   	pop    %ebx
80101a0d:	5e                   	pop    %esi
80101a0e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101a0f:	e9 ac 29 00 00       	jmp    801043c0 <releasesleep>
    panic("iunlock");
80101a14:	83 ec 0c             	sub    $0xc,%esp
80101a17:	68 20 77 10 80       	push   $0x80107720
80101a1c:	e8 6f ea ff ff       	call   80100490 <panic>
80101a21:	eb 0d                	jmp    80101a30 <iput>
80101a23:	90                   	nop
80101a24:	90                   	nop
80101a25:	90                   	nop
80101a26:	90                   	nop
80101a27:	90                   	nop
80101a28:	90                   	nop
80101a29:	90                   	nop
80101a2a:	90                   	nop
80101a2b:	90                   	nop
80101a2c:	90                   	nop
80101a2d:	90                   	nop
80101a2e:	90                   	nop
80101a2f:	90                   	nop

80101a30 <iput>:
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	57                   	push   %edi
80101a34:	56                   	push   %esi
80101a35:	53                   	push   %ebx
80101a36:	83 ec 28             	sub    $0x28,%esp
80101a39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101a3c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101a3f:	57                   	push   %edi
80101a40:	e8 1b 29 00 00       	call   80104360 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101a45:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101a48:	83 c4 10             	add    $0x10,%esp
80101a4b:	85 d2                	test   %edx,%edx
80101a4d:	74 07                	je     80101a56 <iput+0x26>
80101a4f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101a54:	74 32                	je     80101a88 <iput+0x58>
  releasesleep(&ip->lock);
80101a56:	83 ec 0c             	sub    $0xc,%esp
80101a59:	57                   	push   %edi
80101a5a:	e8 61 29 00 00       	call   801043c0 <releasesleep>
  acquire(&icache.lock);
80101a5f:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101a66:	e8 b5 2a 00 00       	call   80104520 <acquire>
  ip->ref--;
80101a6b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a6f:	83 c4 10             	add    $0x10,%esp
80101a72:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
80101a79:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a7c:	5b                   	pop    %ebx
80101a7d:	5e                   	pop    %esi
80101a7e:	5f                   	pop    %edi
80101a7f:	5d                   	pop    %ebp
  release(&icache.lock);
80101a80:	e9 bb 2b 00 00       	jmp    80104640 <release>
80101a85:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101a88:	83 ec 0c             	sub    $0xc,%esp
80101a8b:	68 e0 19 11 80       	push   $0x801119e0
80101a90:	e8 8b 2a 00 00       	call   80104520 <acquire>
    int r = ip->ref;
80101a95:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101a98:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101a9f:	e8 9c 2b 00 00       	call   80104640 <release>
    if(r == 1){
80101aa4:	83 c4 10             	add    $0x10,%esp
80101aa7:	83 fe 01             	cmp    $0x1,%esi
80101aaa:	75 aa                	jne    80101a56 <iput+0x26>
80101aac:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101ab2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101ab5:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101ab8:	89 cf                	mov    %ecx,%edi
80101aba:	eb 0b                	jmp    80101ac7 <iput+0x97>
80101abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ac0:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101ac3:	39 fe                	cmp    %edi,%esi
80101ac5:	74 19                	je     80101ae0 <iput+0xb0>
    if(ip->addrs[i]){
80101ac7:	8b 16                	mov    (%esi),%edx
80101ac9:	85 d2                	test   %edx,%edx
80101acb:	74 f3                	je     80101ac0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101acd:	8b 03                	mov    (%ebx),%eax
80101acf:	e8 5c fa ff ff       	call   80101530 <bfree>
      ip->addrs[i] = 0;
80101ad4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101ada:	eb e4                	jmp    80101ac0 <iput+0x90>
80101adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101ae0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101ae6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101ae9:	85 c0                	test   %eax,%eax
80101aeb:	75 33                	jne    80101b20 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101aed:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101af0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101af7:	53                   	push   %ebx
80101af8:	e8 53 fd ff ff       	call   80101850 <iupdate>
      ip->type = 0;
80101afd:	31 c0                	xor    %eax,%eax
80101aff:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101b03:	89 1c 24             	mov    %ebx,(%esp)
80101b06:	e8 45 fd ff ff       	call   80101850 <iupdate>
      ip->valid = 0;
80101b0b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101b12:	83 c4 10             	add    $0x10,%esp
80101b15:	e9 3c ff ff ff       	jmp    80101a56 <iput+0x26>
80101b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101b20:	83 ec 08             	sub    $0x8,%esp
80101b23:	50                   	push   %eax
80101b24:	ff 33                	pushl  (%ebx)
80101b26:	e8 a5 e5 ff ff       	call   801000d0 <bread>
80101b2b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101b31:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101b34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101b37:	8d 70 5c             	lea    0x5c(%eax),%esi
80101b3a:	83 c4 10             	add    $0x10,%esp
80101b3d:	89 cf                	mov    %ecx,%edi
80101b3f:	eb 0e                	jmp    80101b4f <iput+0x11f>
80101b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b48:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
80101b4b:	39 fe                	cmp    %edi,%esi
80101b4d:	74 0f                	je     80101b5e <iput+0x12e>
      if(a[j])
80101b4f:	8b 16                	mov    (%esi),%edx
80101b51:	85 d2                	test   %edx,%edx
80101b53:	74 f3                	je     80101b48 <iput+0x118>
        bfree(ip->dev, a[j]);
80101b55:	8b 03                	mov    (%ebx),%eax
80101b57:	e8 d4 f9 ff ff       	call   80101530 <bfree>
80101b5c:	eb ea                	jmp    80101b48 <iput+0x118>
    brelse(bp);
80101b5e:	83 ec 0c             	sub    $0xc,%esp
80101b61:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b64:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b67:	e8 74 e6 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101b6c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101b72:	8b 03                	mov    (%ebx),%eax
80101b74:	e8 b7 f9 ff ff       	call   80101530 <bfree>
    ip->addrs[NDIRECT] = 0;
80101b79:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101b80:	00 00 00 
80101b83:	83 c4 10             	add    $0x10,%esp
80101b86:	e9 62 ff ff ff       	jmp    80101aed <iput+0xbd>
80101b8b:	90                   	nop
80101b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b90 <iunlockput>:
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	53                   	push   %ebx
80101b94:	83 ec 10             	sub    $0x10,%esp
80101b97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101b9a:	53                   	push   %ebx
80101b9b:	e8 40 fe ff ff       	call   801019e0 <iunlock>
  iput(ip);
80101ba0:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101ba3:	83 c4 10             	add    $0x10,%esp
}
80101ba6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101ba9:	c9                   	leave  
  iput(ip);
80101baa:	e9 81 fe ff ff       	jmp    80101a30 <iput>
80101baf:	90                   	nop

80101bb0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	8b 55 08             	mov    0x8(%ebp),%edx
80101bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101bb9:	8b 0a                	mov    (%edx),%ecx
80101bbb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101bbe:	8b 4a 04             	mov    0x4(%edx),%ecx
80101bc1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101bc4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101bc8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101bcb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101bcf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101bd3:	8b 52 58             	mov    0x58(%edx),%edx
80101bd6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101bd9:	5d                   	pop    %ebp
80101bda:	c3                   	ret    
80101bdb:	90                   	nop
80101bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101be0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101be0:	55                   	push   %ebp
80101be1:	89 e5                	mov    %esp,%ebp
80101be3:	57                   	push   %edi
80101be4:	56                   	push   %esi
80101be5:	53                   	push   %ebx
80101be6:	83 ec 1c             	sub    $0x1c,%esp
80101be9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bec:	8b 75 0c             	mov    0xc(%ebp),%esi
80101bef:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bf2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bf7:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101bfa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bfd:	8b 75 10             	mov    0x10(%ebp),%esi
80101c00:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101c03:	0f 84 a7 00 00 00    	je     80101cb0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101c09:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c0c:	8b 40 58             	mov    0x58(%eax),%eax
80101c0f:	39 c6                	cmp    %eax,%esi
80101c11:	0f 87 ba 00 00 00    	ja     80101cd1 <readi+0xf1>
80101c17:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101c1a:	89 f9                	mov    %edi,%ecx
80101c1c:	01 f1                	add    %esi,%ecx
80101c1e:	0f 82 ad 00 00 00    	jb     80101cd1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101c24:	89 c2                	mov    %eax,%edx
80101c26:	29 f2                	sub    %esi,%edx
80101c28:	39 c8                	cmp    %ecx,%eax
80101c2a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c2d:	31 ff                	xor    %edi,%edi
80101c2f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101c31:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c34:	74 6c                	je     80101ca2 <readi+0xc2>
80101c36:	8d 76 00             	lea    0x0(%esi),%esi
80101c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c40:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101c43:	89 f2                	mov    %esi,%edx
80101c45:	c1 ea 09             	shr    $0x9,%edx
80101c48:	89 d8                	mov    %ebx,%eax
80101c4a:	e8 c1 f7 ff ff       	call   80101410 <bmap>
80101c4f:	83 ec 08             	sub    $0x8,%esp
80101c52:	50                   	push   %eax
80101c53:	ff 33                	pushl  (%ebx)
80101c55:	e8 76 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c5a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c5d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101c5f:	89 f0                	mov    %esi,%eax
80101c61:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c66:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c6b:	83 c4 0c             	add    $0xc,%esp
80101c6e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101c70:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101c74:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101c77:	29 fb                	sub    %edi,%ebx
80101c79:	39 d9                	cmp    %ebx,%ecx
80101c7b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c7e:	53                   	push   %ebx
80101c7f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c80:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101c82:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c85:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101c87:	e8 c4 2a 00 00       	call   80104750 <memmove>
    brelse(bp);
80101c8c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101c8f:	89 14 24             	mov    %edx,(%esp)
80101c92:	e8 49 e5 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c97:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101c9a:	83 c4 10             	add    $0x10,%esp
80101c9d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ca0:	77 9e                	ja     80101c40 <readi+0x60>
  }
  return n;
80101ca2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ca5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ca8:	5b                   	pop    %ebx
80101ca9:	5e                   	pop    %esi
80101caa:	5f                   	pop    %edi
80101cab:	5d                   	pop    %ebp
80101cac:	c3                   	ret    
80101cad:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101cb0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101cb4:	66 83 f8 09          	cmp    $0x9,%ax
80101cb8:	77 17                	ja     80101cd1 <readi+0xf1>
80101cba:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101cc1:	85 c0                	test   %eax,%eax
80101cc3:	74 0c                	je     80101cd1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101cc5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101cc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ccb:	5b                   	pop    %ebx
80101ccc:	5e                   	pop    %esi
80101ccd:	5f                   	pop    %edi
80101cce:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101ccf:	ff e0                	jmp    *%eax
      return -1;
80101cd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cd6:	eb cd                	jmp    80101ca5 <readi+0xc5>
80101cd8:	90                   	nop
80101cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ce0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cec:	8b 75 0c             	mov    0xc(%ebp),%esi
80101cef:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101cf2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101cf7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101cfa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101cfd:	8b 75 10             	mov    0x10(%ebp),%esi
80101d00:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101d03:	0f 84 b7 00 00 00    	je     80101dc0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101d09:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d0c:	39 70 58             	cmp    %esi,0x58(%eax)
80101d0f:	0f 82 eb 00 00 00    	jb     80101e00 <writei+0x120>
80101d15:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101d18:	31 d2                	xor    %edx,%edx
80101d1a:	89 f8                	mov    %edi,%eax
80101d1c:	01 f0                	add    %esi,%eax
80101d1e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101d21:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101d26:	0f 87 d4 00 00 00    	ja     80101e00 <writei+0x120>
80101d2c:	85 d2                	test   %edx,%edx
80101d2e:	0f 85 cc 00 00 00    	jne    80101e00 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d34:	85 ff                	test   %edi,%edi
80101d36:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101d3d:	74 72                	je     80101db1 <writei+0xd1>
80101d3f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d40:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101d43:	89 f2                	mov    %esi,%edx
80101d45:	c1 ea 09             	shr    $0x9,%edx
80101d48:	89 f8                	mov    %edi,%eax
80101d4a:	e8 c1 f6 ff ff       	call   80101410 <bmap>
80101d4f:	83 ec 08             	sub    $0x8,%esp
80101d52:	50                   	push   %eax
80101d53:	ff 37                	pushl  (%edi)
80101d55:	e8 76 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101d5a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101d5d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d60:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101d62:	89 f0                	mov    %esi,%eax
80101d64:	b9 00 02 00 00       	mov    $0x200,%ecx
80101d69:	83 c4 0c             	add    $0xc,%esp
80101d6c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d71:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101d73:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101d77:	39 d9                	cmp    %ebx,%ecx
80101d79:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101d7c:	53                   	push   %ebx
80101d7d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d80:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101d82:	50                   	push   %eax
80101d83:	e8 c8 29 00 00       	call   80104750 <memmove>
    log_write(bp);
80101d88:	89 3c 24             	mov    %edi,(%esp)
80101d8b:	e8 50 12 00 00       	call   80102fe0 <log_write>
    brelse(bp);
80101d90:	89 3c 24             	mov    %edi,(%esp)
80101d93:	e8 48 e4 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d98:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101d9b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101d9e:	83 c4 10             	add    $0x10,%esp
80101da1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101da4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101da7:	77 97                	ja     80101d40 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101da9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101dac:	3b 70 58             	cmp    0x58(%eax),%esi
80101daf:	77 37                	ja     80101de8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101db1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101db4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101db7:	5b                   	pop    %ebx
80101db8:	5e                   	pop    %esi
80101db9:	5f                   	pop    %edi
80101dba:	5d                   	pop    %ebp
80101dbb:	c3                   	ret    
80101dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101dc0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101dc4:	66 83 f8 09          	cmp    $0x9,%ax
80101dc8:	77 36                	ja     80101e00 <writei+0x120>
80101dca:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101dd1:	85 c0                	test   %eax,%eax
80101dd3:	74 2b                	je     80101e00 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101dd5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101dd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ddb:	5b                   	pop    %ebx
80101ddc:	5e                   	pop    %esi
80101ddd:	5f                   	pop    %edi
80101dde:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101ddf:	ff e0                	jmp    *%eax
80101de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101de8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101deb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101dee:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101df1:	50                   	push   %eax
80101df2:	e8 59 fa ff ff       	call   80101850 <iupdate>
80101df7:	83 c4 10             	add    $0x10,%esp
80101dfa:	eb b5                	jmp    80101db1 <writei+0xd1>
80101dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101e00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e05:	eb ad                	jmp    80101db4 <writei+0xd4>
80101e07:	89 f6                	mov    %esi,%esi
80101e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e10 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101e10:	55                   	push   %ebp
80101e11:	89 e5                	mov    %esp,%ebp
80101e13:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101e16:	6a 0e                	push   $0xe
80101e18:	ff 75 0c             	pushl  0xc(%ebp)
80101e1b:	ff 75 08             	pushl  0x8(%ebp)
80101e1e:	e8 9d 29 00 00       	call   801047c0 <strncmp>
}
80101e23:	c9                   	leave  
80101e24:	c3                   	ret    
80101e25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e30 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	57                   	push   %edi
80101e34:	56                   	push   %esi
80101e35:	53                   	push   %ebx
80101e36:	83 ec 1c             	sub    $0x1c,%esp
80101e39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101e3c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101e41:	0f 85 85 00 00 00    	jne    80101ecc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101e47:	8b 53 58             	mov    0x58(%ebx),%edx
80101e4a:	31 ff                	xor    %edi,%edi
80101e4c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e4f:	85 d2                	test   %edx,%edx
80101e51:	74 3e                	je     80101e91 <dirlookup+0x61>
80101e53:	90                   	nop
80101e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e58:	6a 10                	push   $0x10
80101e5a:	57                   	push   %edi
80101e5b:	56                   	push   %esi
80101e5c:	53                   	push   %ebx
80101e5d:	e8 7e fd ff ff       	call   80101be0 <readi>
80101e62:	83 c4 10             	add    $0x10,%esp
80101e65:	83 f8 10             	cmp    $0x10,%eax
80101e68:	75 55                	jne    80101ebf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101e6a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e6f:	74 18                	je     80101e89 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101e71:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e74:	83 ec 04             	sub    $0x4,%esp
80101e77:	6a 0e                	push   $0xe
80101e79:	50                   	push   %eax
80101e7a:	ff 75 0c             	pushl  0xc(%ebp)
80101e7d:	e8 3e 29 00 00       	call   801047c0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101e82:	83 c4 10             	add    $0x10,%esp
80101e85:	85 c0                	test   %eax,%eax
80101e87:	74 17                	je     80101ea0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e89:	83 c7 10             	add    $0x10,%edi
80101e8c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e8f:	72 c7                	jb     80101e58 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101e91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101e94:	31 c0                	xor    %eax,%eax
}
80101e96:	5b                   	pop    %ebx
80101e97:	5e                   	pop    %esi
80101e98:	5f                   	pop    %edi
80101e99:	5d                   	pop    %ebp
80101e9a:	c3                   	ret    
80101e9b:	90                   	nop
80101e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101ea0:	8b 45 10             	mov    0x10(%ebp),%eax
80101ea3:	85 c0                	test   %eax,%eax
80101ea5:	74 05                	je     80101eac <dirlookup+0x7c>
        *poff = off;
80101ea7:	8b 45 10             	mov    0x10(%ebp),%eax
80101eaa:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101eac:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101eb0:	8b 03                	mov    (%ebx),%eax
80101eb2:	e8 89 f4 ff ff       	call   80101340 <iget>
}
80101eb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eba:	5b                   	pop    %ebx
80101ebb:	5e                   	pop    %esi
80101ebc:	5f                   	pop    %edi
80101ebd:	5d                   	pop    %ebp
80101ebe:	c3                   	ret    
      panic("dirlookup read");
80101ebf:	83 ec 0c             	sub    $0xc,%esp
80101ec2:	68 3a 77 10 80       	push   $0x8010773a
80101ec7:	e8 c4 e5 ff ff       	call   80100490 <panic>
    panic("dirlookup not DIR");
80101ecc:	83 ec 0c             	sub    $0xc,%esp
80101ecf:	68 28 77 10 80       	push   $0x80107728
80101ed4:	e8 b7 e5 ff ff       	call   80100490 <panic>
80101ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ee0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ee0:	55                   	push   %ebp
80101ee1:	89 e5                	mov    %esp,%ebp
80101ee3:	57                   	push   %edi
80101ee4:	56                   	push   %esi
80101ee5:	53                   	push   %ebx
80101ee6:	89 cf                	mov    %ecx,%edi
80101ee8:	89 c3                	mov    %eax,%ebx
80101eea:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101eed:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101ef0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101ef3:	0f 84 67 01 00 00    	je     80102060 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ef9:	e8 52 1b 00 00       	call   80103a50 <myproc>
  acquire(&icache.lock);
80101efe:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101f01:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101f04:	68 e0 19 11 80       	push   $0x801119e0
80101f09:	e8 12 26 00 00       	call   80104520 <acquire>
  ip->ref++;
80101f0e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101f12:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101f19:	e8 22 27 00 00       	call   80104640 <release>
80101f1e:	83 c4 10             	add    $0x10,%esp
80101f21:	eb 08                	jmp    80101f2b <namex+0x4b>
80101f23:	90                   	nop
80101f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f28:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f2b:	0f b6 03             	movzbl (%ebx),%eax
80101f2e:	3c 2f                	cmp    $0x2f,%al
80101f30:	74 f6                	je     80101f28 <namex+0x48>
  if(*path == 0)
80101f32:	84 c0                	test   %al,%al
80101f34:	0f 84 ee 00 00 00    	je     80102028 <namex+0x148>
  while(*path != '/' && *path != 0)
80101f3a:	0f b6 03             	movzbl (%ebx),%eax
80101f3d:	3c 2f                	cmp    $0x2f,%al
80101f3f:	0f 84 b3 00 00 00    	je     80101ff8 <namex+0x118>
80101f45:	84 c0                	test   %al,%al
80101f47:	89 da                	mov    %ebx,%edx
80101f49:	75 09                	jne    80101f54 <namex+0x74>
80101f4b:	e9 a8 00 00 00       	jmp    80101ff8 <namex+0x118>
80101f50:	84 c0                	test   %al,%al
80101f52:	74 0a                	je     80101f5e <namex+0x7e>
    path++;
80101f54:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101f57:	0f b6 02             	movzbl (%edx),%eax
80101f5a:	3c 2f                	cmp    $0x2f,%al
80101f5c:	75 f2                	jne    80101f50 <namex+0x70>
80101f5e:	89 d1                	mov    %edx,%ecx
80101f60:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101f62:	83 f9 0d             	cmp    $0xd,%ecx
80101f65:	0f 8e 91 00 00 00    	jle    80101ffc <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101f6b:	83 ec 04             	sub    $0x4,%esp
80101f6e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f71:	6a 0e                	push   $0xe
80101f73:	53                   	push   %ebx
80101f74:	57                   	push   %edi
80101f75:	e8 d6 27 00 00       	call   80104750 <memmove>
    path++;
80101f7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101f7d:	83 c4 10             	add    $0x10,%esp
    path++;
80101f80:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101f82:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101f85:	75 11                	jne    80101f98 <namex+0xb8>
80101f87:	89 f6                	mov    %esi,%esi
80101f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101f90:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f93:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101f96:	74 f8                	je     80101f90 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101f98:	83 ec 0c             	sub    $0xc,%esp
80101f9b:	56                   	push   %esi
80101f9c:	e8 5f f9 ff ff       	call   80101900 <ilock>
    if(ip->type != T_DIR){
80101fa1:	83 c4 10             	add    $0x10,%esp
80101fa4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101fa9:	0f 85 91 00 00 00    	jne    80102040 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101faf:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101fb2:	85 d2                	test   %edx,%edx
80101fb4:	74 09                	je     80101fbf <namex+0xdf>
80101fb6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101fb9:	0f 84 b7 00 00 00    	je     80102076 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101fbf:	83 ec 04             	sub    $0x4,%esp
80101fc2:	6a 00                	push   $0x0
80101fc4:	57                   	push   %edi
80101fc5:	56                   	push   %esi
80101fc6:	e8 65 fe ff ff       	call   80101e30 <dirlookup>
80101fcb:	83 c4 10             	add    $0x10,%esp
80101fce:	85 c0                	test   %eax,%eax
80101fd0:	74 6e                	je     80102040 <namex+0x160>
  iunlock(ip);
80101fd2:	83 ec 0c             	sub    $0xc,%esp
80101fd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101fd8:	56                   	push   %esi
80101fd9:	e8 02 fa ff ff       	call   801019e0 <iunlock>
  iput(ip);
80101fde:	89 34 24             	mov    %esi,(%esp)
80101fe1:	e8 4a fa ff ff       	call   80101a30 <iput>
80101fe6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101fe9:	83 c4 10             	add    $0x10,%esp
80101fec:	89 c6                	mov    %eax,%esi
80101fee:	e9 38 ff ff ff       	jmp    80101f2b <namex+0x4b>
80101ff3:	90                   	nop
80101ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101ff8:	89 da                	mov    %ebx,%edx
80101ffa:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101ffc:	83 ec 04             	sub    $0x4,%esp
80101fff:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102002:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80102005:	51                   	push   %ecx
80102006:	53                   	push   %ebx
80102007:	57                   	push   %edi
80102008:	e8 43 27 00 00       	call   80104750 <memmove>
    name[len] = 0;
8010200d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80102010:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102013:	83 c4 10             	add    $0x10,%esp
80102016:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
8010201a:	89 d3                	mov    %edx,%ebx
8010201c:	e9 61 ff ff ff       	jmp    80101f82 <namex+0xa2>
80102021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102028:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010202b:	85 c0                	test   %eax,%eax
8010202d:	75 5d                	jne    8010208c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
8010202f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102032:	89 f0                	mov    %esi,%eax
80102034:	5b                   	pop    %ebx
80102035:	5e                   	pop    %esi
80102036:	5f                   	pop    %edi
80102037:	5d                   	pop    %ebp
80102038:	c3                   	ret    
80102039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102040:	83 ec 0c             	sub    $0xc,%esp
80102043:	56                   	push   %esi
80102044:	e8 97 f9 ff ff       	call   801019e0 <iunlock>
  iput(ip);
80102049:	89 34 24             	mov    %esi,(%esp)
      return 0;
8010204c:	31 f6                	xor    %esi,%esi
  iput(ip);
8010204e:	e8 dd f9 ff ff       	call   80101a30 <iput>
      return 0;
80102053:	83 c4 10             	add    $0x10,%esp
}
80102056:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102059:	89 f0                	mov    %esi,%eax
8010205b:	5b                   	pop    %ebx
8010205c:	5e                   	pop    %esi
8010205d:	5f                   	pop    %edi
8010205e:	5d                   	pop    %ebp
8010205f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80102060:	ba 01 00 00 00       	mov    $0x1,%edx
80102065:	b8 01 00 00 00       	mov    $0x1,%eax
8010206a:	e8 d1 f2 ff ff       	call   80101340 <iget>
8010206f:	89 c6                	mov    %eax,%esi
80102071:	e9 b5 fe ff ff       	jmp    80101f2b <namex+0x4b>
      iunlock(ip);
80102076:	83 ec 0c             	sub    $0xc,%esp
80102079:	56                   	push   %esi
8010207a:	e8 61 f9 ff ff       	call   801019e0 <iunlock>
      return ip;
8010207f:	83 c4 10             	add    $0x10,%esp
}
80102082:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102085:	89 f0                	mov    %esi,%eax
80102087:	5b                   	pop    %ebx
80102088:	5e                   	pop    %esi
80102089:	5f                   	pop    %edi
8010208a:	5d                   	pop    %ebp
8010208b:	c3                   	ret    
    iput(ip);
8010208c:	83 ec 0c             	sub    $0xc,%esp
8010208f:	56                   	push   %esi
    return 0;
80102090:	31 f6                	xor    %esi,%esi
    iput(ip);
80102092:	e8 99 f9 ff ff       	call   80101a30 <iput>
    return 0;
80102097:	83 c4 10             	add    $0x10,%esp
8010209a:	eb 93                	jmp    8010202f <namex+0x14f>
8010209c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020a0 <dirlink>:
{
801020a0:	55                   	push   %ebp
801020a1:	89 e5                	mov    %esp,%ebp
801020a3:	57                   	push   %edi
801020a4:	56                   	push   %esi
801020a5:	53                   	push   %ebx
801020a6:	83 ec 20             	sub    $0x20,%esp
801020a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801020ac:	6a 00                	push   $0x0
801020ae:	ff 75 0c             	pushl  0xc(%ebp)
801020b1:	53                   	push   %ebx
801020b2:	e8 79 fd ff ff       	call   80101e30 <dirlookup>
801020b7:	83 c4 10             	add    $0x10,%esp
801020ba:	85 c0                	test   %eax,%eax
801020bc:	75 67                	jne    80102125 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801020be:	8b 7b 58             	mov    0x58(%ebx),%edi
801020c1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801020c4:	85 ff                	test   %edi,%edi
801020c6:	74 29                	je     801020f1 <dirlink+0x51>
801020c8:	31 ff                	xor    %edi,%edi
801020ca:	8d 75 d8             	lea    -0x28(%ebp),%esi
801020cd:	eb 09                	jmp    801020d8 <dirlink+0x38>
801020cf:	90                   	nop
801020d0:	83 c7 10             	add    $0x10,%edi
801020d3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801020d6:	73 19                	jae    801020f1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020d8:	6a 10                	push   $0x10
801020da:	57                   	push   %edi
801020db:	56                   	push   %esi
801020dc:	53                   	push   %ebx
801020dd:	e8 fe fa ff ff       	call   80101be0 <readi>
801020e2:	83 c4 10             	add    $0x10,%esp
801020e5:	83 f8 10             	cmp    $0x10,%eax
801020e8:	75 4e                	jne    80102138 <dirlink+0x98>
    if(de.inum == 0)
801020ea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801020ef:	75 df                	jne    801020d0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801020f1:	8d 45 da             	lea    -0x26(%ebp),%eax
801020f4:	83 ec 04             	sub    $0x4,%esp
801020f7:	6a 0e                	push   $0xe
801020f9:	ff 75 0c             	pushl  0xc(%ebp)
801020fc:	50                   	push   %eax
801020fd:	e8 1e 27 00 00       	call   80104820 <strncpy>
  de.inum = inum;
80102102:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102105:	6a 10                	push   $0x10
80102107:	57                   	push   %edi
80102108:	56                   	push   %esi
80102109:	53                   	push   %ebx
  de.inum = inum;
8010210a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010210e:	e8 cd fb ff ff       	call   80101ce0 <writei>
80102113:	83 c4 20             	add    $0x20,%esp
80102116:	83 f8 10             	cmp    $0x10,%eax
80102119:	75 2a                	jne    80102145 <dirlink+0xa5>
  return 0;
8010211b:	31 c0                	xor    %eax,%eax
}
8010211d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102120:	5b                   	pop    %ebx
80102121:	5e                   	pop    %esi
80102122:	5f                   	pop    %edi
80102123:	5d                   	pop    %ebp
80102124:	c3                   	ret    
    iput(ip);
80102125:	83 ec 0c             	sub    $0xc,%esp
80102128:	50                   	push   %eax
80102129:	e8 02 f9 ff ff       	call   80101a30 <iput>
    return -1;
8010212e:	83 c4 10             	add    $0x10,%esp
80102131:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102136:	eb e5                	jmp    8010211d <dirlink+0x7d>
      panic("dirlink read");
80102138:	83 ec 0c             	sub    $0xc,%esp
8010213b:	68 49 77 10 80       	push   $0x80107749
80102140:	e8 4b e3 ff ff       	call   80100490 <panic>
    panic("dirlink");
80102145:	83 ec 0c             	sub    $0xc,%esp
80102148:	68 46 7d 10 80       	push   $0x80107d46
8010214d:	e8 3e e3 ff ff       	call   80100490 <panic>
80102152:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102160 <namei>:

struct inode*
namei(char *path)
{
80102160:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102161:	31 d2                	xor    %edx,%edx
{
80102163:	89 e5                	mov    %esp,%ebp
80102165:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102168:	8b 45 08             	mov    0x8(%ebp),%eax
8010216b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010216e:	e8 6d fd ff ff       	call   80101ee0 <namex>
}
80102173:	c9                   	leave  
80102174:	c3                   	ret    
80102175:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102180 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102180:	55                   	push   %ebp
  return namex(path, 1, name);
80102181:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102186:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102188:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010218b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010218e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010218f:	e9 4c fd ff ff       	jmp    80101ee0 <namex>
80102194:	66 90                	xchg   %ax,%ax
80102196:	66 90                	xchg   %ax,%ax
80102198:	66 90                	xchg   %ax,%ax
8010219a:	66 90                	xchg   %ax,%ax
8010219c:	66 90                	xchg   %ax,%ax
8010219e:	66 90                	xchg   %ax,%ax

801021a0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801021a0:	55                   	push   %ebp
  if(b == 0)
801021a1:	85 c0                	test   %eax,%eax
{
801021a3:	89 e5                	mov    %esp,%ebp
801021a5:	56                   	push   %esi
801021a6:	53                   	push   %ebx
  if(b == 0)
801021a7:	0f 84 af 00 00 00    	je     8010225c <idestart+0xbc>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801021ad:	8b 58 08             	mov    0x8(%eax),%ebx
801021b0:	89 c6                	mov    %eax,%esi
801021b2:	81 fb ff f3 01 00    	cmp    $0x1f3ff,%ebx
801021b8:	0f 87 91 00 00 00    	ja     8010224f <idestart+0xaf>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021be:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801021c3:	90                   	nop
801021c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021c8:	89 ca                	mov    %ecx,%edx
801021ca:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021cb:	83 e0 c0             	and    $0xffffffc0,%eax
801021ce:	3c 40                	cmp    $0x40,%al
801021d0:	75 f6                	jne    801021c8 <idestart+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021d2:	31 c0                	xor    %eax,%eax
801021d4:	ba f6 03 00 00       	mov    $0x3f6,%edx
801021d9:	ee                   	out    %al,(%dx)
801021da:	b8 01 00 00 00       	mov    $0x1,%eax
801021df:	ba f2 01 00 00       	mov    $0x1f2,%edx
801021e4:	ee                   	out    %al,(%dx)
801021e5:	ba f3 01 00 00       	mov    $0x1f3,%edx
801021ea:	89 d8                	mov    %ebx,%eax
801021ec:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801021ed:	89 d8                	mov    %ebx,%eax
801021ef:	ba f4 01 00 00       	mov    $0x1f4,%edx
801021f4:	c1 f8 08             	sar    $0x8,%eax
801021f7:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
801021f8:	89 d8                	mov    %ebx,%eax
801021fa:	ba f5 01 00 00       	mov    $0x1f5,%edx
801021ff:	c1 f8 10             	sar    $0x10,%eax
80102202:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102203:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80102207:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010220c:	c1 e0 04             	shl    $0x4,%eax
8010220f:	83 e0 10             	and    $0x10,%eax
80102212:	83 c8 e0             	or     $0xffffffe0,%eax
80102215:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80102216:	f6 06 04             	testb  $0x4,(%esi)
80102219:	75 15                	jne    80102230 <idestart+0x90>
8010221b:	b8 20 00 00 00       	mov    $0x20,%eax
80102220:	89 ca                	mov    %ecx,%edx
80102222:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102223:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102226:	5b                   	pop    %ebx
80102227:	5e                   	pop    %esi
80102228:	5d                   	pop    %ebp
80102229:	c3                   	ret    
8010222a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102230:	b8 30 00 00 00       	mov    $0x30,%eax
80102235:	89 ca                	mov    %ecx,%edx
80102237:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102238:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
8010223d:	83 c6 5c             	add    $0x5c,%esi
80102240:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102245:	fc                   	cld    
80102246:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102248:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010224b:	5b                   	pop    %ebx
8010224c:	5e                   	pop    %esi
8010224d:	5d                   	pop    %ebp
8010224e:	c3                   	ret    
    panic("incorrect blockno");
8010224f:	83 ec 0c             	sub    $0xc,%esp
80102252:	68 b4 77 10 80       	push   $0x801077b4
80102257:	e8 34 e2 ff ff       	call   80100490 <panic>
    panic("idestart");
8010225c:	83 ec 0c             	sub    $0xc,%esp
8010225f:	68 ab 77 10 80       	push   $0x801077ab
80102264:	e8 27 e2 ff ff       	call   80100490 <panic>
80102269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102270 <ideinit>:
{
80102270:	55                   	push   %ebp
80102271:	89 e5                	mov    %esp,%ebp
80102273:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102276:	68 c6 77 10 80       	push   $0x801077c6
8010227b:	68 80 b5 10 80       	push   $0x8010b580
80102280:	e8 ab 21 00 00       	call   80104430 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102285:	58                   	pop    %eax
80102286:	a1 00 3d 11 80       	mov    0x80113d00,%eax
8010228b:	5a                   	pop    %edx
8010228c:	83 e8 01             	sub    $0x1,%eax
8010228f:	50                   	push   %eax
80102290:	6a 0e                	push   $0xe
80102292:	e8 a9 02 00 00       	call   80102540 <ioapicenable>
80102297:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010229a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010229f:	90                   	nop
801022a0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022a1:	83 e0 c0             	and    $0xffffffc0,%eax
801022a4:	3c 40                	cmp    $0x40,%al
801022a6:	75 f8                	jne    801022a0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022a8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801022ad:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022b2:	ee                   	out    %al,(%dx)
801022b3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022b8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022bd:	eb 06                	jmp    801022c5 <ideinit+0x55>
801022bf:	90                   	nop
  for(i=0; i<1000; i++){
801022c0:	83 e9 01             	sub    $0x1,%ecx
801022c3:	74 0f                	je     801022d4 <ideinit+0x64>
801022c5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801022c6:	84 c0                	test   %al,%al
801022c8:	74 f6                	je     801022c0 <ideinit+0x50>
      havedisk1 = 1;
801022ca:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801022d1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022d4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801022d9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022de:	ee                   	out    %al,(%dx)
}
801022df:	c9                   	leave  
801022e0:	c3                   	ret    
801022e1:	eb 0d                	jmp    801022f0 <ideintr>
801022e3:	90                   	nop
801022e4:	90                   	nop
801022e5:	90                   	nop
801022e6:	90                   	nop
801022e7:	90                   	nop
801022e8:	90                   	nop
801022e9:	90                   	nop
801022ea:	90                   	nop
801022eb:	90                   	nop
801022ec:	90                   	nop
801022ed:	90                   	nop
801022ee:	90                   	nop
801022ef:	90                   	nop

801022f0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	57                   	push   %edi
801022f4:	56                   	push   %esi
801022f5:	53                   	push   %ebx
801022f6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801022f9:	68 80 b5 10 80       	push   $0x8010b580
801022fe:	e8 1d 22 00 00       	call   80104520 <acquire>

  if((b = idequeue) == 0){
80102303:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102309:	83 c4 10             	add    $0x10,%esp
8010230c:	85 db                	test   %ebx,%ebx
8010230e:	74 67                	je     80102377 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102310:	8b 43 58             	mov    0x58(%ebx),%eax
80102313:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102318:	8b 3b                	mov    (%ebx),%edi
8010231a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102320:	75 31                	jne    80102353 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102322:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102327:	89 f6                	mov    %esi,%esi
80102329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102330:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102331:	89 c6                	mov    %eax,%esi
80102333:	83 e6 c0             	and    $0xffffffc0,%esi
80102336:	89 f1                	mov    %esi,%ecx
80102338:	80 f9 40             	cmp    $0x40,%cl
8010233b:	75 f3                	jne    80102330 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010233d:	a8 21                	test   $0x21,%al
8010233f:	75 12                	jne    80102353 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102341:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102344:	b9 80 00 00 00       	mov    $0x80,%ecx
80102349:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010234e:	fc                   	cld    
8010234f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102351:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102353:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102356:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102359:	89 f9                	mov    %edi,%ecx
8010235b:	83 c9 02             	or     $0x2,%ecx
8010235e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102360:	53                   	push   %ebx
80102361:	e8 1a 1e 00 00       	call   80104180 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102366:	a1 64 b5 10 80       	mov    0x8010b564,%eax
8010236b:	83 c4 10             	add    $0x10,%esp
8010236e:	85 c0                	test   %eax,%eax
80102370:	74 05                	je     80102377 <ideintr+0x87>
    idestart(idequeue);
80102372:	e8 29 fe ff ff       	call   801021a0 <idestart>
    release(&idelock);
80102377:	83 ec 0c             	sub    $0xc,%esp
8010237a:	68 80 b5 10 80       	push   $0x8010b580
8010237f:	e8 bc 22 00 00       	call   80104640 <release>

  release(&idelock);
}
80102384:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102387:	5b                   	pop    %ebx
80102388:	5e                   	pop    %esi
80102389:	5f                   	pop    %edi
8010238a:	5d                   	pop    %ebp
8010238b:	c3                   	ret    
8010238c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102390 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102390:	55                   	push   %ebp
80102391:	89 e5                	mov    %esp,%ebp
80102393:	53                   	push   %ebx
80102394:	83 ec 10             	sub    $0x10,%esp
80102397:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010239a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010239d:	50                   	push   %eax
8010239e:	e8 5d 20 00 00       	call   80104400 <holdingsleep>
801023a3:	83 c4 10             	add    $0x10,%esp
801023a6:	85 c0                	test   %eax,%eax
801023a8:	0f 84 c6 00 00 00    	je     80102474 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801023ae:	8b 03                	mov    (%ebx),%eax
801023b0:	83 e0 06             	and    $0x6,%eax
801023b3:	83 f8 02             	cmp    $0x2,%eax
801023b6:	0f 84 ab 00 00 00    	je     80102467 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801023bc:	8b 53 04             	mov    0x4(%ebx),%edx
801023bf:	85 d2                	test   %edx,%edx
801023c1:	74 0d                	je     801023d0 <iderw+0x40>
801023c3:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801023c8:	85 c0                	test   %eax,%eax
801023ca:	0f 84 b1 00 00 00    	je     80102481 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801023d0:	83 ec 0c             	sub    $0xc,%esp
801023d3:	68 80 b5 10 80       	push   $0x8010b580
801023d8:	e8 43 21 00 00       	call   80104520 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023dd:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
801023e3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801023e6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023ed:	85 d2                	test   %edx,%edx
801023ef:	75 09                	jne    801023fa <iderw+0x6a>
801023f1:	eb 6d                	jmp    80102460 <iderw+0xd0>
801023f3:	90                   	nop
801023f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023f8:	89 c2                	mov    %eax,%edx
801023fa:	8b 42 58             	mov    0x58(%edx),%eax
801023fd:	85 c0                	test   %eax,%eax
801023ff:	75 f7                	jne    801023f8 <iderw+0x68>
80102401:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102404:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102406:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010240c:	74 42                	je     80102450 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010240e:	8b 03                	mov    (%ebx),%eax
80102410:	83 e0 06             	and    $0x6,%eax
80102413:	83 f8 02             	cmp    $0x2,%eax
80102416:	74 23                	je     8010243b <iderw+0xab>
80102418:	90                   	nop
80102419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102420:	83 ec 08             	sub    $0x8,%esp
80102423:	68 80 b5 10 80       	push   $0x8010b580
80102428:	53                   	push   %ebx
80102429:	e8 92 1b 00 00       	call   80103fc0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010242e:	8b 03                	mov    (%ebx),%eax
80102430:	83 c4 10             	add    $0x10,%esp
80102433:	83 e0 06             	and    $0x6,%eax
80102436:	83 f8 02             	cmp    $0x2,%eax
80102439:	75 e5                	jne    80102420 <iderw+0x90>
  }


  release(&idelock);
8010243b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102442:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102445:	c9                   	leave  
  release(&idelock);
80102446:	e9 f5 21 00 00       	jmp    80104640 <release>
8010244b:	90                   	nop
8010244c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102450:	89 d8                	mov    %ebx,%eax
80102452:	e8 49 fd ff ff       	call   801021a0 <idestart>
80102457:	eb b5                	jmp    8010240e <iderw+0x7e>
80102459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102460:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102465:	eb 9d                	jmp    80102404 <iderw+0x74>
    panic("iderw: nothing to do");
80102467:	83 ec 0c             	sub    $0xc,%esp
8010246a:	68 e0 77 10 80       	push   $0x801077e0
8010246f:	e8 1c e0 ff ff       	call   80100490 <panic>
    panic("iderw: buf not locked");
80102474:	83 ec 0c             	sub    $0xc,%esp
80102477:	68 ca 77 10 80       	push   $0x801077ca
8010247c:	e8 0f e0 ff ff       	call   80100490 <panic>
    panic("iderw: ide disk 1 not present");
80102481:	83 ec 0c             	sub    $0xc,%esp
80102484:	68 f5 77 10 80       	push   $0x801077f5
80102489:	e8 02 e0 ff ff       	call   80100490 <panic>
8010248e:	66 90                	xchg   %ax,%ax

80102490 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102490:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102491:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
80102498:	00 c0 fe 
{
8010249b:	89 e5                	mov    %esp,%ebp
8010249d:	56                   	push   %esi
8010249e:	53                   	push   %ebx
  ioapic->reg = reg;
8010249f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801024a6:	00 00 00 
  return ioapic->data;
801024a9:	a1 34 36 11 80       	mov    0x80113634,%eax
801024ae:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
801024b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
801024b7:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801024bd:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801024c4:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
801024c7:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801024ca:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
801024cd:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801024d0:	39 c2                	cmp    %eax,%edx
801024d2:	74 16                	je     801024ea <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801024d4:	83 ec 0c             	sub    $0xc,%esp
801024d7:	68 14 78 10 80       	push   $0x80107814
801024dc:	e8 7f e2 ff ff       	call   80100760 <cprintf>
801024e1:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801024e7:	83 c4 10             	add    $0x10,%esp
801024ea:	83 c3 21             	add    $0x21,%ebx
{
801024ed:	ba 10 00 00 00       	mov    $0x10,%edx
801024f2:	b8 20 00 00 00       	mov    $0x20,%eax
801024f7:	89 f6                	mov    %esi,%esi
801024f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102500:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102502:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102508:	89 c6                	mov    %eax,%esi
8010250a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102510:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102513:	89 71 10             	mov    %esi,0x10(%ecx)
80102516:	8d 72 01             	lea    0x1(%edx),%esi
80102519:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010251c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010251e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102520:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102526:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010252d:	75 d1                	jne    80102500 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010252f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102532:	5b                   	pop    %ebx
80102533:	5e                   	pop    %esi
80102534:	5d                   	pop    %ebp
80102535:	c3                   	ret    
80102536:	8d 76 00             	lea    0x0(%esi),%esi
80102539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102540 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102540:	55                   	push   %ebp
  ioapic->reg = reg;
80102541:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
{
80102547:	89 e5                	mov    %esp,%ebp
80102549:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010254c:	8d 50 20             	lea    0x20(%eax),%edx
8010254f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102553:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102555:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010255b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010255e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102561:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102564:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102566:	a1 34 36 11 80       	mov    0x80113634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010256b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010256e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102571:	5d                   	pop    %ebp
80102572:	c3                   	ret    
80102573:	66 90                	xchg   %ax,%ax
80102575:	66 90                	xchg   %ax,%ax
80102577:	66 90                	xchg   %ax,%ax
80102579:	66 90                	xchg   %ax,%ax
8010257b:	66 90                	xchg   %ax,%ax
8010257d:	66 90                	xchg   %ax,%ax
8010257f:	90                   	nop

80102580 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	53                   	push   %ebx
80102584:	83 ec 04             	sub    $0x4,%esp
80102587:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010258a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102590:	75 70                	jne    80102602 <kfree+0x82>
80102592:	81 fb a8 64 11 80    	cmp    $0x801164a8,%ebx
80102598:	72 68                	jb     80102602 <kfree+0x82>
8010259a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801025a0:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
801025a5:	77 5b                	ja     80102602 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801025a7:	83 ec 04             	sub    $0x4,%esp
801025aa:	68 00 10 00 00       	push   $0x1000
801025af:	6a 01                	push   $0x1
801025b1:	53                   	push   %ebx
801025b2:	e8 e9 20 00 00       	call   801046a0 <memset>

  if(kmem.use_lock)
801025b7:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801025bd:	83 c4 10             	add    $0x10,%esp
801025c0:	85 d2                	test   %edx,%edx
801025c2:	75 2c                	jne    801025f0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801025c4:	a1 78 36 11 80       	mov    0x80113678,%eax
801025c9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801025cb:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
801025d0:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
801025d6:	85 c0                	test   %eax,%eax
801025d8:	75 06                	jne    801025e0 <kfree+0x60>
    release(&kmem.lock);
}
801025da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025dd:	c9                   	leave  
801025de:	c3                   	ret    
801025df:	90                   	nop
    release(&kmem.lock);
801025e0:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
801025e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025ea:	c9                   	leave  
    release(&kmem.lock);
801025eb:	e9 50 20 00 00       	jmp    80104640 <release>
    acquire(&kmem.lock);
801025f0:	83 ec 0c             	sub    $0xc,%esp
801025f3:	68 40 36 11 80       	push   $0x80113640
801025f8:	e8 23 1f 00 00       	call   80104520 <acquire>
801025fd:	83 c4 10             	add    $0x10,%esp
80102600:	eb c2                	jmp    801025c4 <kfree+0x44>
    panic("kfree");
80102602:	83 ec 0c             	sub    $0xc,%esp
80102605:	68 46 78 10 80       	push   $0x80107846
8010260a:	e8 81 de ff ff       	call   80100490 <panic>
8010260f:	90                   	nop

80102610 <freerange>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102615:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102618:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010261b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102621:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102627:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010262d:	39 de                	cmp    %ebx,%esi
8010262f:	72 23                	jb     80102654 <freerange+0x44>
80102631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102638:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010263e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102641:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102647:	50                   	push   %eax
80102648:	e8 33 ff ff ff       	call   80102580 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010264d:	83 c4 10             	add    $0x10,%esp
80102650:	39 f3                	cmp    %esi,%ebx
80102652:	76 e4                	jbe    80102638 <freerange+0x28>
}
80102654:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102657:	5b                   	pop    %ebx
80102658:	5e                   	pop    %esi
80102659:	5d                   	pop    %ebp
8010265a:	c3                   	ret    
8010265b:	90                   	nop
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
8010266b:	68 4c 78 10 80       	push   $0x8010784c
80102670:	68 40 36 11 80       	push   $0x80113640
80102675:	e8 b6 1d 00 00       	call   80104430 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010267a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010267d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102680:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
80102687:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010268a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102690:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102696:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010269c:	39 de                	cmp    %ebx,%esi
8010269e:	72 1c                	jb     801026bc <kinit1+0x5c>
    kfree(p);
801026a0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801026a6:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026a9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026af:	50                   	push   %eax
801026b0:	e8 cb fe ff ff       	call   80102580 <kfree>
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
801026c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801026c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026d0 <kinit2>:
{
801026d0:	55                   	push   %ebp
801026d1:	89 e5                	mov    %esp,%ebp
801026d3:	56                   	push   %esi
801026d4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801026d5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801026d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801026db:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026e1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026ed:	39 de                	cmp    %ebx,%esi
801026ef:	72 23                	jb     80102714 <kinit2+0x44>
801026f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801026f8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801026fe:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102701:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102707:	50                   	push   %eax
80102708:	e8 73 fe ff ff       	call   80102580 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010270d:	83 c4 10             	add    $0x10,%esp
80102710:	39 de                	cmp    %ebx,%esi
80102712:	73 e4                	jae    801026f8 <kinit2+0x28>
  kmem.use_lock = 1;
80102714:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
8010271b:	00 00 00 
}
8010271e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102721:	5b                   	pop    %ebx
80102722:	5e                   	pop    %esi
80102723:	5d                   	pop    %ebp
80102724:	c3                   	ret    
80102725:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102730 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102730:	a1 74 36 11 80       	mov    0x80113674,%eax
80102735:	85 c0                	test   %eax,%eax
80102737:	75 1f                	jne    80102758 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102739:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
8010273e:	85 c0                	test   %eax,%eax
80102740:	74 0e                	je     80102750 <kalloc+0x20>
    kmem.freelist = r->next;
80102742:	8b 10                	mov    (%eax),%edx
80102744:	89 15 78 36 11 80    	mov    %edx,0x80113678
8010274a:	c3                   	ret    
8010274b:	90                   	nop
8010274c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102750:	f3 c3                	repz ret 
80102752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102758:	55                   	push   %ebp
80102759:	89 e5                	mov    %esp,%ebp
8010275b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010275e:	68 40 36 11 80       	push   $0x80113640
80102763:	e8 b8 1d 00 00       	call   80104520 <acquire>
  r = kmem.freelist;
80102768:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
8010276d:	83 c4 10             	add    $0x10,%esp
80102770:	8b 15 74 36 11 80    	mov    0x80113674,%edx
80102776:	85 c0                	test   %eax,%eax
80102778:	74 08                	je     80102782 <kalloc+0x52>
    kmem.freelist = r->next;
8010277a:	8b 08                	mov    (%eax),%ecx
8010277c:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
80102782:	85 d2                	test   %edx,%edx
80102784:	74 16                	je     8010279c <kalloc+0x6c>
    release(&kmem.lock);
80102786:	83 ec 0c             	sub    $0xc,%esp
80102789:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010278c:	68 40 36 11 80       	push   $0x80113640
80102791:	e8 aa 1e 00 00       	call   80104640 <release>
  return (char*)r;
80102796:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102799:	83 c4 10             	add    $0x10,%esp
}
8010279c:	c9                   	leave  
8010279d:	c3                   	ret    
8010279e:	66 90                	xchg   %ax,%ax

801027a0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027a0:	ba 64 00 00 00       	mov    $0x64,%edx
801027a5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801027a6:	a8 01                	test   $0x1,%al
801027a8:	0f 84 c2 00 00 00    	je     80102870 <kbdgetc+0xd0>
801027ae:	ba 60 00 00 00       	mov    $0x60,%edx
801027b3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801027b4:	0f b6 d0             	movzbl %al,%edx
801027b7:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
801027bd:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801027c3:	0f 84 7f 00 00 00    	je     80102848 <kbdgetc+0xa8>
{
801027c9:	55                   	push   %ebp
801027ca:	89 e5                	mov    %esp,%ebp
801027cc:	53                   	push   %ebx
801027cd:	89 cb                	mov    %ecx,%ebx
801027cf:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801027d2:	84 c0                	test   %al,%al
801027d4:	78 4a                	js     80102820 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801027d6:	85 db                	test   %ebx,%ebx
801027d8:	74 09                	je     801027e3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801027da:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801027dd:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
801027e0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801027e3:	0f b6 82 80 79 10 80 	movzbl -0x7fef8680(%edx),%eax
801027ea:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801027ec:	0f b6 82 80 78 10 80 	movzbl -0x7fef8780(%edx),%eax
801027f3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801027f5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801027f7:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801027fd:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102800:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102803:	8b 04 85 60 78 10 80 	mov    -0x7fef87a0(,%eax,4),%eax
8010280a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010280e:	74 31                	je     80102841 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102810:	8d 50 9f             	lea    -0x61(%eax),%edx
80102813:	83 fa 19             	cmp    $0x19,%edx
80102816:	77 40                	ja     80102858 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102818:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010281b:	5b                   	pop    %ebx
8010281c:	5d                   	pop    %ebp
8010281d:	c3                   	ret    
8010281e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102820:	83 e0 7f             	and    $0x7f,%eax
80102823:	85 db                	test   %ebx,%ebx
80102825:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102828:	0f b6 82 80 79 10 80 	movzbl -0x7fef8680(%edx),%eax
8010282f:	83 c8 40             	or     $0x40,%eax
80102832:	0f b6 c0             	movzbl %al,%eax
80102835:	f7 d0                	not    %eax
80102837:	21 c1                	and    %eax,%ecx
    return 0;
80102839:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010283b:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102841:	5b                   	pop    %ebx
80102842:	5d                   	pop    %ebp
80102843:	c3                   	ret    
80102844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102848:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010284b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010284d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
80102853:	c3                   	ret    
80102854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102858:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010285b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010285e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010285f:	83 f9 1a             	cmp    $0x1a,%ecx
80102862:	0f 42 c2             	cmovb  %edx,%eax
}
80102865:	5d                   	pop    %ebp
80102866:	c3                   	ret    
80102867:	89 f6                	mov    %esi,%esi
80102869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102870:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102875:	c3                   	ret    
80102876:	8d 76 00             	lea    0x0(%esi),%esi
80102879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102880 <kbdintr>:

void
kbdintr(void)
{
80102880:	55                   	push   %ebp
80102881:	89 e5                	mov    %esp,%ebp
80102883:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102886:	68 a0 27 10 80       	push   $0x801027a0
8010288b:	e8 80 e0 ff ff       	call   80100910 <consoleintr>
}
80102890:	83 c4 10             	add    $0x10,%esp
80102893:	c9                   	leave  
80102894:	c3                   	ret    
80102895:	66 90                	xchg   %ax,%ax
80102897:	66 90                	xchg   %ax,%ax
80102899:	66 90                	xchg   %ax,%ax
8010289b:	66 90                	xchg   %ax,%ax
8010289d:	66 90                	xchg   %ax,%ax
8010289f:	90                   	nop

801028a0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801028a0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
{
801028a5:	55                   	push   %ebp
801028a6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801028a8:	85 c0                	test   %eax,%eax
801028aa:	0f 84 c8 00 00 00    	je     80102978 <lapicinit+0xd8>
  lapic[index] = value;
801028b0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801028b7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028ba:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028bd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801028c4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ca:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801028d1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801028d4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028d7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801028de:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801028e1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028e4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801028eb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028ee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028f1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801028f8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028fb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801028fe:	8b 50 30             	mov    0x30(%eax),%edx
80102901:	c1 ea 10             	shr    $0x10,%edx
80102904:	80 fa 03             	cmp    $0x3,%dl
80102907:	77 77                	ja     80102980 <lapicinit+0xe0>
  lapic[index] = value;
80102909:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102910:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102913:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102916:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010291d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102920:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102923:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010292a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010292d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102930:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102937:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010293a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010293d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102944:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102947:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010294a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102951:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102954:	8b 50 20             	mov    0x20(%eax),%edx
80102957:	89 f6                	mov    %esi,%esi
80102959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102960:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102966:	80 e6 10             	and    $0x10,%dh
80102969:	75 f5                	jne    80102960 <lapicinit+0xc0>
  lapic[index] = value;
8010296b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102972:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102975:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102978:	5d                   	pop    %ebp
80102979:	c3                   	ret    
8010297a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102980:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102987:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010298a:	8b 50 20             	mov    0x20(%eax),%edx
8010298d:	e9 77 ff ff ff       	jmp    80102909 <lapicinit+0x69>
80102992:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029a0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801029a0:	8b 15 7c 36 11 80    	mov    0x8011367c,%edx
{
801029a6:	55                   	push   %ebp
801029a7:	31 c0                	xor    %eax,%eax
801029a9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801029ab:	85 d2                	test   %edx,%edx
801029ad:	74 06                	je     801029b5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
801029af:	8b 42 20             	mov    0x20(%edx),%eax
801029b2:	c1 e8 18             	shr    $0x18,%eax
}
801029b5:	5d                   	pop    %ebp
801029b6:	c3                   	ret    
801029b7:	89 f6                	mov    %esi,%esi
801029b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029c0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801029c0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
{
801029c5:	55                   	push   %ebp
801029c6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801029c8:	85 c0                	test   %eax,%eax
801029ca:	74 0d                	je     801029d9 <lapiceoi+0x19>
  lapic[index] = value;
801029cc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801029d3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029d6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801029d9:	5d                   	pop    %ebp
801029da:	c3                   	ret    
801029db:	90                   	nop
801029dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801029e0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801029e0:	55                   	push   %ebp
801029e1:	89 e5                	mov    %esp,%ebp
}
801029e3:	5d                   	pop    %ebp
801029e4:	c3                   	ret    
801029e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029f0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801029f0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f1:	b8 0f 00 00 00       	mov    $0xf,%eax
801029f6:	ba 70 00 00 00       	mov    $0x70,%edx
801029fb:	89 e5                	mov    %esp,%ebp
801029fd:	53                   	push   %ebx
801029fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102a01:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102a04:	ee                   	out    %al,(%dx)
80102a05:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a0a:	ba 71 00 00 00       	mov    $0x71,%edx
80102a0f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102a10:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102a12:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102a15:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102a1b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a1d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102a20:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102a23:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a25:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102a28:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102a2e:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102a33:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a39:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a3c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102a43:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a46:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a49:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102a50:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a53:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a56:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a5c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a5f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a65:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a68:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a6e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a71:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a77:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102a7a:	5b                   	pop    %ebx
80102a7b:	5d                   	pop    %ebp
80102a7c:	c3                   	ret    
80102a7d:	8d 76 00             	lea    0x0(%esi),%esi

80102a80 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102a80:	55                   	push   %ebp
80102a81:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a86:	ba 70 00 00 00       	mov    $0x70,%edx
80102a8b:	89 e5                	mov    %esp,%ebp
80102a8d:	57                   	push   %edi
80102a8e:	56                   	push   %esi
80102a8f:	53                   	push   %ebx
80102a90:	83 ec 4c             	sub    $0x4c,%esp
80102a93:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a94:	ba 71 00 00 00       	mov    $0x71,%edx
80102a99:	ec                   	in     (%dx),%al
80102a9a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102aa2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102aa5:	8d 76 00             	lea    0x0(%esi),%esi
80102aa8:	31 c0                	xor    %eax,%eax
80102aaa:	89 da                	mov    %ebx,%edx
80102aac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aad:	b9 71 00 00 00       	mov    $0x71,%ecx
80102ab2:	89 ca                	mov    %ecx,%edx
80102ab4:	ec                   	in     (%dx),%al
80102ab5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab8:	89 da                	mov    %ebx,%edx
80102aba:	b8 02 00 00 00       	mov    $0x2,%eax
80102abf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac0:	89 ca                	mov    %ecx,%edx
80102ac2:	ec                   	in     (%dx),%al
80102ac3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac6:	89 da                	mov    %ebx,%edx
80102ac8:	b8 04 00 00 00       	mov    $0x4,%eax
80102acd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ace:	89 ca                	mov    %ecx,%edx
80102ad0:	ec                   	in     (%dx),%al
80102ad1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad4:	89 da                	mov    %ebx,%edx
80102ad6:	b8 07 00 00 00       	mov    $0x7,%eax
80102adb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102adc:	89 ca                	mov    %ecx,%edx
80102ade:	ec                   	in     (%dx),%al
80102adf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae2:	89 da                	mov    %ebx,%edx
80102ae4:	b8 08 00 00 00       	mov    $0x8,%eax
80102ae9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aea:	89 ca                	mov    %ecx,%edx
80102aec:	ec                   	in     (%dx),%al
80102aed:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aef:	89 da                	mov    %ebx,%edx
80102af1:	b8 09 00 00 00       	mov    $0x9,%eax
80102af6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af7:	89 ca                	mov    %ecx,%edx
80102af9:	ec                   	in     (%dx),%al
80102afa:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102afc:	89 da                	mov    %ebx,%edx
80102afe:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b03:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b04:	89 ca                	mov    %ecx,%edx
80102b06:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102b07:	84 c0                	test   %al,%al
80102b09:	78 9d                	js     80102aa8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102b0b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102b0f:	89 fa                	mov    %edi,%edx
80102b11:	0f b6 fa             	movzbl %dl,%edi
80102b14:	89 f2                	mov    %esi,%edx
80102b16:	0f b6 f2             	movzbl %dl,%esi
80102b19:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b1c:	89 da                	mov    %ebx,%edx
80102b1e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102b21:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102b24:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102b28:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102b2b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102b2f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102b32:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102b36:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102b39:	31 c0                	xor    %eax,%eax
80102b3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b3c:	89 ca                	mov    %ecx,%edx
80102b3e:	ec                   	in     (%dx),%al
80102b3f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b42:	89 da                	mov    %ebx,%edx
80102b44:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102b47:	b8 02 00 00 00       	mov    $0x2,%eax
80102b4c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4d:	89 ca                	mov    %ecx,%edx
80102b4f:	ec                   	in     (%dx),%al
80102b50:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b53:	89 da                	mov    %ebx,%edx
80102b55:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b58:	b8 04 00 00 00       	mov    $0x4,%eax
80102b5d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b5e:	89 ca                	mov    %ecx,%edx
80102b60:	ec                   	in     (%dx),%al
80102b61:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b64:	89 da                	mov    %ebx,%edx
80102b66:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b69:	b8 07 00 00 00       	mov    $0x7,%eax
80102b6e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b6f:	89 ca                	mov    %ecx,%edx
80102b71:	ec                   	in     (%dx),%al
80102b72:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b75:	89 da                	mov    %ebx,%edx
80102b77:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b7a:	b8 08 00 00 00       	mov    $0x8,%eax
80102b7f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b80:	89 ca                	mov    %ecx,%edx
80102b82:	ec                   	in     (%dx),%al
80102b83:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b86:	89 da                	mov    %ebx,%edx
80102b88:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b8b:	b8 09 00 00 00       	mov    $0x9,%eax
80102b90:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b91:	89 ca                	mov    %ecx,%edx
80102b93:	ec                   	in     (%dx),%al
80102b94:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b97:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b9d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ba0:	6a 18                	push   $0x18
80102ba2:	50                   	push   %eax
80102ba3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ba6:	50                   	push   %eax
80102ba7:	e8 44 1b 00 00       	call   801046f0 <memcmp>
80102bac:	83 c4 10             	add    $0x10,%esp
80102baf:	85 c0                	test   %eax,%eax
80102bb1:	0f 85 f1 fe ff ff    	jne    80102aa8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102bb7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102bbb:	75 78                	jne    80102c35 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102bbd:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bc0:	89 c2                	mov    %eax,%edx
80102bc2:	83 e0 0f             	and    $0xf,%eax
80102bc5:	c1 ea 04             	shr    $0x4,%edx
80102bc8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bcb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bce:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102bd1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bd4:	89 c2                	mov    %eax,%edx
80102bd6:	83 e0 0f             	and    $0xf,%eax
80102bd9:	c1 ea 04             	shr    $0x4,%edx
80102bdc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bdf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102be2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102be5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102be8:	89 c2                	mov    %eax,%edx
80102bea:	83 e0 0f             	and    $0xf,%eax
80102bed:	c1 ea 04             	shr    $0x4,%edx
80102bf0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bf3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bf6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102bf9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bfc:	89 c2                	mov    %eax,%edx
80102bfe:	83 e0 0f             	and    $0xf,%eax
80102c01:	c1 ea 04             	shr    $0x4,%edx
80102c04:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c07:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c0a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102c0d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c10:	89 c2                	mov    %eax,%edx
80102c12:	83 e0 0f             	and    $0xf,%eax
80102c15:	c1 ea 04             	shr    $0x4,%edx
80102c18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c1e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102c21:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c24:	89 c2                	mov    %eax,%edx
80102c26:	83 e0 0f             	and    $0xf,%eax
80102c29:	c1 ea 04             	shr    $0x4,%edx
80102c2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c32:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102c35:	8b 75 08             	mov    0x8(%ebp),%esi
80102c38:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c3b:	89 06                	mov    %eax,(%esi)
80102c3d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c40:	89 46 04             	mov    %eax,0x4(%esi)
80102c43:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c46:	89 46 08             	mov    %eax,0x8(%esi)
80102c49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c4c:	89 46 0c             	mov    %eax,0xc(%esi)
80102c4f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c52:	89 46 10             	mov    %eax,0x10(%esi)
80102c55:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c58:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102c5b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102c62:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c65:	5b                   	pop    %ebx
80102c66:	5e                   	pop    %esi
80102c67:	5f                   	pop    %edi
80102c68:	5d                   	pop    %ebp
80102c69:	c3                   	ret    
80102c6a:	66 90                	xchg   %ax,%ax
80102c6c:	66 90                	xchg   %ax,%ax
80102c6e:	66 90                	xchg   %ax,%ax

80102c70 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c70:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102c76:	85 c9                	test   %ecx,%ecx
80102c78:	0f 8e 8a 00 00 00    	jle    80102d08 <install_trans+0x98>
{
80102c7e:	55                   	push   %ebp
80102c7f:	89 e5                	mov    %esp,%ebp
80102c81:	57                   	push   %edi
80102c82:	56                   	push   %esi
80102c83:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102c84:	31 db                	xor    %ebx,%ebx
{
80102c86:	83 ec 0c             	sub    $0xc,%esp
80102c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c90:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102c95:	83 ec 08             	sub    $0x8,%esp
80102c98:	01 d8                	add    %ebx,%eax
80102c9a:	83 c0 01             	add    $0x1,%eax
80102c9d:	50                   	push   %eax
80102c9e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102ca4:	e8 27 d4 ff ff       	call   801000d0 <bread>
80102ca9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cab:	58                   	pop    %eax
80102cac:	5a                   	pop    %edx
80102cad:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102cb4:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102cba:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cbd:	e8 0e d4 ff ff       	call   801000d0 <bread>
80102cc2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102cc4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102cc7:	83 c4 0c             	add    $0xc,%esp
80102cca:	68 00 02 00 00       	push   $0x200
80102ccf:	50                   	push   %eax
80102cd0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cd3:	50                   	push   %eax
80102cd4:	e8 77 1a 00 00       	call   80104750 <memmove>
    bwrite(dbuf);  // write dst to disk
80102cd9:	89 34 24             	mov    %esi,(%esp)
80102cdc:	e8 bf d4 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102ce1:	89 3c 24             	mov    %edi,(%esp)
80102ce4:	e8 f7 d4 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102ce9:	89 34 24             	mov    %esi,(%esp)
80102cec:	e8 ef d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cf1:	83 c4 10             	add    $0x10,%esp
80102cf4:	39 1d c8 36 11 80    	cmp    %ebx,0x801136c8
80102cfa:	7f 94                	jg     80102c90 <install_trans+0x20>
  }
}
80102cfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cff:	5b                   	pop    %ebx
80102d00:	5e                   	pop    %esi
80102d01:	5f                   	pop    %edi
80102d02:	5d                   	pop    %ebp
80102d03:	c3                   	ret    
80102d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d08:	f3 c3                	repz ret 
80102d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102d10 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102d10:	55                   	push   %ebp
80102d11:	89 e5                	mov    %esp,%ebp
80102d13:	56                   	push   %esi
80102d14:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102d15:	83 ec 08             	sub    $0x8,%esp
80102d18:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102d1e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102d24:	e8 a7 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102d29:	8b 1d c8 36 11 80    	mov    0x801136c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102d2f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d32:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102d34:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102d36:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102d39:	7e 16                	jle    80102d51 <write_head+0x41>
80102d3b:	c1 e3 02             	shl    $0x2,%ebx
80102d3e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102d40:	8b 8a cc 36 11 80    	mov    -0x7feec934(%edx),%ecx
80102d46:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102d4a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102d4d:	39 da                	cmp    %ebx,%edx
80102d4f:	75 ef                	jne    80102d40 <write_head+0x30>
  }
  bwrite(buf);
80102d51:	83 ec 0c             	sub    $0xc,%esp
80102d54:	56                   	push   %esi
80102d55:	e8 46 d4 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102d5a:	89 34 24             	mov    %esi,(%esp)
80102d5d:	e8 7e d4 ff ff       	call   801001e0 <brelse>
}
80102d62:	83 c4 10             	add    $0x10,%esp
80102d65:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102d68:	5b                   	pop    %ebx
80102d69:	5e                   	pop    %esi
80102d6a:	5d                   	pop    %ebp
80102d6b:	c3                   	ret    
80102d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102d70 <initlog>:
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 2c             	sub    $0x2c,%esp
80102d77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d7a:	68 80 7a 10 80       	push   $0x80107a80
80102d7f:	68 80 36 11 80       	push   $0x80113680
80102d84:	e8 a7 16 00 00       	call   80104430 <initlock>
  readsb(dev, &sb);
80102d89:	58                   	pop    %eax
80102d8a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d8d:	5a                   	pop    %edx
80102d8e:	50                   	push   %eax
80102d8f:	53                   	push   %ebx
80102d90:	e8 5b e7 ff ff       	call   801014f0 <readsb>
  log.size = sb.nlog;
80102d95:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d9b:	59                   	pop    %ecx
  log.dev = dev;
80102d9c:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4
  log.size = sb.nlog;
80102da2:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
  log.start = sb.logstart;
80102da8:	a3 b4 36 11 80       	mov    %eax,0x801136b4
  struct buf *buf = bread(log.dev, log.start);
80102dad:	5a                   	pop    %edx
80102dae:	50                   	push   %eax
80102daf:	53                   	push   %ebx
80102db0:	e8 1b d3 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102db5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102db8:	83 c4 10             	add    $0x10,%esp
80102dbb:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102dbd:	89 1d c8 36 11 80    	mov    %ebx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102dc3:	7e 1c                	jle    80102de1 <initlog+0x71>
80102dc5:	c1 e3 02             	shl    $0x2,%ebx
80102dc8:	31 d2                	xor    %edx,%edx
80102dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102dd0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102dd4:	83 c2 04             	add    $0x4,%edx
80102dd7:	89 8a c8 36 11 80    	mov    %ecx,-0x7feec938(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102ddd:	39 d3                	cmp    %edx,%ebx
80102ddf:	75 ef                	jne    80102dd0 <initlog+0x60>
  brelse(buf);
80102de1:	83 ec 0c             	sub    $0xc,%esp
80102de4:	50                   	push   %eax
80102de5:	e8 f6 d3 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102dea:	e8 81 fe ff ff       	call   80102c70 <install_trans>
  log.lh.n = 0;
80102def:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102df6:	00 00 00 
  write_head(); // clear the log
80102df9:	e8 12 ff ff ff       	call   80102d10 <write_head>
}
80102dfe:	83 c4 10             	add    $0x10,%esp
80102e01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e04:	c9                   	leave  
80102e05:	c3                   	ret    
80102e06:	8d 76 00             	lea    0x0(%esi),%esi
80102e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e10 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102e10:	55                   	push   %ebp
80102e11:	89 e5                	mov    %esp,%ebp
80102e13:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102e16:	68 80 36 11 80       	push   $0x80113680
80102e1b:	e8 00 17 00 00       	call   80104520 <acquire>
80102e20:	83 c4 10             	add    $0x10,%esp
80102e23:	eb 18                	jmp    80102e3d <begin_op+0x2d>
80102e25:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102e28:	83 ec 08             	sub    $0x8,%esp
80102e2b:	68 80 36 11 80       	push   $0x80113680
80102e30:	68 80 36 11 80       	push   $0x80113680
80102e35:	e8 86 11 00 00       	call   80103fc0 <sleep>
80102e3a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102e3d:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102e42:	85 c0                	test   %eax,%eax
80102e44:	75 e2                	jne    80102e28 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102e46:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102e4b:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102e51:	83 c0 01             	add    $0x1,%eax
80102e54:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102e57:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102e5a:	83 fa 1e             	cmp    $0x1e,%edx
80102e5d:	7f c9                	jg     80102e28 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e5f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e62:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102e67:	68 80 36 11 80       	push   $0x80113680
80102e6c:	e8 cf 17 00 00       	call   80104640 <release>
      break;
    }
  }
}
80102e71:	83 c4 10             	add    $0x10,%esp
80102e74:	c9                   	leave  
80102e75:	c3                   	ret    
80102e76:	8d 76 00             	lea    0x0(%esi),%esi
80102e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e80 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	57                   	push   %edi
80102e84:	56                   	push   %esi
80102e85:	53                   	push   %ebx
80102e86:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e89:	68 80 36 11 80       	push   $0x80113680
80102e8e:	e8 8d 16 00 00       	call   80104520 <acquire>
  log.outstanding -= 1;
80102e93:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102e98:	8b 35 c0 36 11 80    	mov    0x801136c0,%esi
80102e9e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102ea1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102ea4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102ea6:	89 1d bc 36 11 80    	mov    %ebx,0x801136bc
  if(log.committing)
80102eac:	0f 85 1a 01 00 00    	jne    80102fcc <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102eb2:	85 db                	test   %ebx,%ebx
80102eb4:	0f 85 ee 00 00 00    	jne    80102fa8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102eba:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102ebd:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102ec4:	00 00 00 
  release(&log.lock);
80102ec7:	68 80 36 11 80       	push   $0x80113680
80102ecc:	e8 6f 17 00 00       	call   80104640 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102ed1:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102ed7:	83 c4 10             	add    $0x10,%esp
80102eda:	85 c9                	test   %ecx,%ecx
80102edc:	0f 8e 85 00 00 00    	jle    80102f67 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ee2:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102ee7:	83 ec 08             	sub    $0x8,%esp
80102eea:	01 d8                	add    %ebx,%eax
80102eec:	83 c0 01             	add    $0x1,%eax
80102eef:	50                   	push   %eax
80102ef0:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102ef6:	e8 d5 d1 ff ff       	call   801000d0 <bread>
80102efb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102efd:	58                   	pop    %eax
80102efe:	5a                   	pop    %edx
80102eff:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102f06:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102f0c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f0f:	e8 bc d1 ff ff       	call   801000d0 <bread>
80102f14:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102f16:	8d 40 5c             	lea    0x5c(%eax),%eax
80102f19:	83 c4 0c             	add    $0xc,%esp
80102f1c:	68 00 02 00 00       	push   $0x200
80102f21:	50                   	push   %eax
80102f22:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f25:	50                   	push   %eax
80102f26:	e8 25 18 00 00       	call   80104750 <memmove>
    bwrite(to);  // write the log
80102f2b:	89 34 24             	mov    %esi,(%esp)
80102f2e:	e8 6d d2 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102f33:	89 3c 24             	mov    %edi,(%esp)
80102f36:	e8 a5 d2 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102f3b:	89 34 24             	mov    %esi,(%esp)
80102f3e:	e8 9d d2 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f43:	83 c4 10             	add    $0x10,%esp
80102f46:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80102f4c:	7c 94                	jl     80102ee2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f4e:	e8 bd fd ff ff       	call   80102d10 <write_head>
    install_trans(); // Now install writes to home locations
80102f53:	e8 18 fd ff ff       	call   80102c70 <install_trans>
    log.lh.n = 0;
80102f58:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102f5f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f62:	e8 a9 fd ff ff       	call   80102d10 <write_head>
    acquire(&log.lock);
80102f67:	83 ec 0c             	sub    $0xc,%esp
80102f6a:	68 80 36 11 80       	push   $0x80113680
80102f6f:	e8 ac 15 00 00       	call   80104520 <acquire>
    wakeup(&log);
80102f74:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
80102f7b:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102f82:	00 00 00 
    wakeup(&log);
80102f85:	e8 f6 11 00 00       	call   80104180 <wakeup>
    release(&log.lock);
80102f8a:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102f91:	e8 aa 16 00 00       	call   80104640 <release>
80102f96:	83 c4 10             	add    $0x10,%esp
}
80102f99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f9c:	5b                   	pop    %ebx
80102f9d:	5e                   	pop    %esi
80102f9e:	5f                   	pop    %edi
80102f9f:	5d                   	pop    %ebp
80102fa0:	c3                   	ret    
80102fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102fa8:	83 ec 0c             	sub    $0xc,%esp
80102fab:	68 80 36 11 80       	push   $0x80113680
80102fb0:	e8 cb 11 00 00       	call   80104180 <wakeup>
  release(&log.lock);
80102fb5:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102fbc:	e8 7f 16 00 00       	call   80104640 <release>
80102fc1:	83 c4 10             	add    $0x10,%esp
}
80102fc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fc7:	5b                   	pop    %ebx
80102fc8:	5e                   	pop    %esi
80102fc9:	5f                   	pop    %edi
80102fca:	5d                   	pop    %ebp
80102fcb:	c3                   	ret    
    panic("log.committing");
80102fcc:	83 ec 0c             	sub    $0xc,%esp
80102fcf:	68 84 7a 10 80       	push   $0x80107a84
80102fd4:	e8 b7 d4 ff ff       	call   80100490 <panic>
80102fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102fe0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	53                   	push   %ebx
80102fe4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fe7:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
{
80102fed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ff0:	83 fa 1d             	cmp    $0x1d,%edx
80102ff3:	0f 8f 9d 00 00 00    	jg     80103096 <log_write+0xb6>
80102ff9:	a1 b8 36 11 80       	mov    0x801136b8,%eax
80102ffe:	83 e8 01             	sub    $0x1,%eax
80103001:	39 c2                	cmp    %eax,%edx
80103003:	0f 8d 8d 00 00 00    	jge    80103096 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103009:	a1 bc 36 11 80       	mov    0x801136bc,%eax
8010300e:	85 c0                	test   %eax,%eax
80103010:	0f 8e 8d 00 00 00    	jle    801030a3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103016:	83 ec 0c             	sub    $0xc,%esp
80103019:	68 80 36 11 80       	push   $0x80113680
8010301e:	e8 fd 14 00 00       	call   80104520 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103023:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80103029:	83 c4 10             	add    $0x10,%esp
8010302c:	83 f9 00             	cmp    $0x0,%ecx
8010302f:	7e 57                	jle    80103088 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103031:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103034:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103036:	3b 15 cc 36 11 80    	cmp    0x801136cc,%edx
8010303c:	75 0b                	jne    80103049 <log_write+0x69>
8010303e:	eb 38                	jmp    80103078 <log_write+0x98>
80103040:	39 14 85 cc 36 11 80 	cmp    %edx,-0x7feec934(,%eax,4)
80103047:	74 2f                	je     80103078 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103049:	83 c0 01             	add    $0x1,%eax
8010304c:	39 c1                	cmp    %eax,%ecx
8010304e:	75 f0                	jne    80103040 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103050:	89 14 85 cc 36 11 80 	mov    %edx,-0x7feec934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103057:	83 c0 01             	add    $0x1,%eax
8010305a:	a3 c8 36 11 80       	mov    %eax,0x801136c8
  b->flags |= B_DIRTY; // prevent eviction
8010305f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103062:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80103069:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010306c:	c9                   	leave  
  release(&log.lock);
8010306d:	e9 ce 15 00 00       	jmp    80104640 <release>
80103072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103078:	89 14 85 cc 36 11 80 	mov    %edx,-0x7feec934(,%eax,4)
8010307f:	eb de                	jmp    8010305f <log_write+0x7f>
80103081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103088:	8b 43 08             	mov    0x8(%ebx),%eax
8010308b:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80103090:	75 cd                	jne    8010305f <log_write+0x7f>
80103092:	31 c0                	xor    %eax,%eax
80103094:	eb c1                	jmp    80103057 <log_write+0x77>
    panic("too big a transaction");
80103096:	83 ec 0c             	sub    $0xc,%esp
80103099:	68 93 7a 10 80       	push   $0x80107a93
8010309e:	e8 ed d3 ff ff       	call   80100490 <panic>
    panic("log_write outside of trans");
801030a3:	83 ec 0c             	sub    $0xc,%esp
801030a6:	68 a9 7a 10 80       	push   $0x80107aa9
801030ab:	e8 e0 d3 ff ff       	call   80100490 <panic>

801030b0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801030b0:	55                   	push   %ebp
801030b1:	89 e5                	mov    %esp,%ebp
801030b3:	53                   	push   %ebx
801030b4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801030b7:	e8 74 09 00 00       	call   80103a30 <cpuid>
801030bc:	89 c3                	mov    %eax,%ebx
801030be:	e8 6d 09 00 00       	call   80103a30 <cpuid>
801030c3:	83 ec 04             	sub    $0x4,%esp
801030c6:	53                   	push   %ebx
801030c7:	50                   	push   %eax
801030c8:	68 c4 7a 10 80       	push   $0x80107ac4
801030cd:	e8 8e d6 ff ff       	call   80100760 <cprintf>
  idtinit();       // load idt register
801030d2:	e8 99 28 00 00       	call   80105970 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801030d7:	e8 d4 08 00 00       	call   801039b0 <mycpu>
801030dc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801030de:	b8 01 00 00 00       	mov    $0x1,%eax
801030e3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801030ea:	e8 f1 0b 00 00       	call   80103ce0 <scheduler>
801030ef:	90                   	nop

801030f0 <mpenter>:
{
801030f0:	55                   	push   %ebp
801030f1:	89 e5                	mov    %esp,%ebp
801030f3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801030f6:	e8 b5 3c 00 00       	call   80106db0 <switchkvm>
  seginit();
801030fb:	e8 20 3c 00 00       	call   80106d20 <seginit>
  lapicinit();
80103100:	e8 9b f7 ff ff       	call   801028a0 <lapicinit>
  mpmain();
80103105:	e8 a6 ff ff ff       	call   801030b0 <mpmain>
8010310a:	66 90                	xchg   %ax,%ax
8010310c:	66 90                	xchg   %ax,%ax
8010310e:	66 90                	xchg   %ax,%ax

80103110 <main>:
{
80103110:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103114:	83 e4 f0             	and    $0xfffffff0,%esp
80103117:	ff 71 fc             	pushl  -0x4(%ecx)
8010311a:	55                   	push   %ebp
8010311b:	89 e5                	mov    %esp,%ebp
8010311d:	53                   	push   %ebx
8010311e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010311f:	83 ec 08             	sub    $0x8,%esp
80103122:	68 00 00 40 80       	push   $0x80400000
80103127:	68 a8 64 11 80       	push   $0x801164a8
8010312c:	e8 2f f5 ff ff       	call   80102660 <kinit1>
  kvmalloc();      // kernel page table
80103131:	e8 1a 41 00 00       	call   80107250 <kvmalloc>
  mpinit();        // detect other processors
80103136:	e8 75 01 00 00       	call   801032b0 <mpinit>
  lapicinit();     // interrupt controller
8010313b:	e8 60 f7 ff ff       	call   801028a0 <lapicinit>
  seginit();       // segment descriptors
80103140:	e8 db 3b 00 00       	call   80106d20 <seginit>
  picinit();       // disable pic
80103145:	e8 46 03 00 00       	call   80103490 <picinit>
  ioapicinit();    // another interrupt controller
8010314a:	e8 41 f3 ff ff       	call   80102490 <ioapicinit>
  consoleinit();   // console hardware
8010314f:	e8 6c d9 ff ff       	call   80100ac0 <consoleinit>
  uartinit();      // serial port
80103154:	e8 97 2e 00 00       	call   80105ff0 <uartinit>
  pinit();         // process table
80103159:	e8 32 08 00 00       	call   80103990 <pinit>
  tvinit();        // trap vectors
8010315e:	e8 8d 27 00 00       	call   801058f0 <tvinit>
  binit();         // buffer cache
80103163:	e8 d8 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103168:	e8 f3 dc ff ff       	call   80100e60 <fileinit>
  ideinit();       // disk 
8010316d:	e8 fe f0 ff ff       	call   80102270 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103172:	83 c4 0c             	add    $0xc,%esp
80103175:	68 8a 00 00 00       	push   $0x8a
8010317a:	68 8c b4 10 80       	push   $0x8010b48c
8010317f:	68 00 70 00 80       	push   $0x80007000
80103184:	e8 c7 15 00 00       	call   80104750 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103189:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80103190:	00 00 00 
80103193:	83 c4 10             	add    $0x10,%esp
80103196:	05 80 37 11 80       	add    $0x80113780,%eax
8010319b:	3d 80 37 11 80       	cmp    $0x80113780,%eax
801031a0:	76 71                	jbe    80103213 <main+0x103>
801031a2:	bb 80 37 11 80       	mov    $0x80113780,%ebx
801031a7:	89 f6                	mov    %esi,%esi
801031a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
801031b0:	e8 fb 07 00 00       	call   801039b0 <mycpu>
801031b5:	39 d8                	cmp    %ebx,%eax
801031b7:	74 41                	je     801031fa <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801031b9:	e8 72 f5 ff ff       	call   80102730 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801031be:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
801031c3:	c7 05 f8 6f 00 80 f0 	movl   $0x801030f0,0x80006ff8
801031ca:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801031cd:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801031d4:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801031d7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
801031dc:	0f b6 03             	movzbl (%ebx),%eax
801031df:	83 ec 08             	sub    $0x8,%esp
801031e2:	68 00 70 00 00       	push   $0x7000
801031e7:	50                   	push   %eax
801031e8:	e8 03 f8 ff ff       	call   801029f0 <lapicstartap>
801031ed:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801031f0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801031f6:	85 c0                	test   %eax,%eax
801031f8:	74 f6                	je     801031f0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
801031fa:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80103201:	00 00 00 
80103204:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010320a:	05 80 37 11 80       	add    $0x80113780,%eax
8010320f:	39 c3                	cmp    %eax,%ebx
80103211:	72 9d                	jb     801031b0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103213:	83 ec 08             	sub    $0x8,%esp
80103216:	68 00 00 40 80       	push   $0x80400000
8010321b:	68 00 00 40 80       	push   $0x80400000
80103220:	e8 ab f4 ff ff       	call   801026d0 <kinit2>
  userinit();      // first user process
80103225:	e8 56 08 00 00       	call   80103a80 <userinit>
  mpmain();        // finish this processor's setup
8010322a:	e8 81 fe ff ff       	call   801030b0 <mpmain>
8010322f:	90                   	nop

80103230 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103230:	55                   	push   %ebp
80103231:	89 e5                	mov    %esp,%ebp
80103233:	57                   	push   %edi
80103234:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103235:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010323b:	53                   	push   %ebx
  e = addr+len;
8010323c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010323f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103242:	39 de                	cmp    %ebx,%esi
80103244:	72 10                	jb     80103256 <mpsearch1+0x26>
80103246:	eb 50                	jmp    80103298 <mpsearch1+0x68>
80103248:	90                   	nop
80103249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103250:	39 fb                	cmp    %edi,%ebx
80103252:	89 fe                	mov    %edi,%esi
80103254:	76 42                	jbe    80103298 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103256:	83 ec 04             	sub    $0x4,%esp
80103259:	8d 7e 10             	lea    0x10(%esi),%edi
8010325c:	6a 04                	push   $0x4
8010325e:	68 d8 7a 10 80       	push   $0x80107ad8
80103263:	56                   	push   %esi
80103264:	e8 87 14 00 00       	call   801046f0 <memcmp>
80103269:	83 c4 10             	add    $0x10,%esp
8010326c:	85 c0                	test   %eax,%eax
8010326e:	75 e0                	jne    80103250 <mpsearch1+0x20>
80103270:	89 f1                	mov    %esi,%ecx
80103272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103278:	0f b6 11             	movzbl (%ecx),%edx
8010327b:	83 c1 01             	add    $0x1,%ecx
8010327e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103280:	39 f9                	cmp    %edi,%ecx
80103282:	75 f4                	jne    80103278 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103284:	84 c0                	test   %al,%al
80103286:	75 c8                	jne    80103250 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103288:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010328b:	89 f0                	mov    %esi,%eax
8010328d:	5b                   	pop    %ebx
8010328e:	5e                   	pop    %esi
8010328f:	5f                   	pop    %edi
80103290:	5d                   	pop    %ebp
80103291:	c3                   	ret    
80103292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103298:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010329b:	31 f6                	xor    %esi,%esi
}
8010329d:	89 f0                	mov    %esi,%eax
8010329f:	5b                   	pop    %ebx
801032a0:	5e                   	pop    %esi
801032a1:	5f                   	pop    %edi
801032a2:	5d                   	pop    %ebp
801032a3:	c3                   	ret    
801032a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801032aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801032b0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801032b0:	55                   	push   %ebp
801032b1:	89 e5                	mov    %esp,%ebp
801032b3:	57                   	push   %edi
801032b4:	56                   	push   %esi
801032b5:	53                   	push   %ebx
801032b6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801032b9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801032c0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801032c7:	c1 e0 08             	shl    $0x8,%eax
801032ca:	09 d0                	or     %edx,%eax
801032cc:	c1 e0 04             	shl    $0x4,%eax
801032cf:	85 c0                	test   %eax,%eax
801032d1:	75 1b                	jne    801032ee <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801032d3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801032da:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801032e1:	c1 e0 08             	shl    $0x8,%eax
801032e4:	09 d0                	or     %edx,%eax
801032e6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801032e9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801032ee:	ba 00 04 00 00       	mov    $0x400,%edx
801032f3:	e8 38 ff ff ff       	call   80103230 <mpsearch1>
801032f8:	85 c0                	test   %eax,%eax
801032fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801032fd:	0f 84 3d 01 00 00    	je     80103440 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103303:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103306:	8b 58 04             	mov    0x4(%eax),%ebx
80103309:	85 db                	test   %ebx,%ebx
8010330b:	0f 84 4f 01 00 00    	je     80103460 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103311:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103317:	83 ec 04             	sub    $0x4,%esp
8010331a:	6a 04                	push   $0x4
8010331c:	68 f5 7a 10 80       	push   $0x80107af5
80103321:	56                   	push   %esi
80103322:	e8 c9 13 00 00       	call   801046f0 <memcmp>
80103327:	83 c4 10             	add    $0x10,%esp
8010332a:	85 c0                	test   %eax,%eax
8010332c:	0f 85 2e 01 00 00    	jne    80103460 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103332:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103339:	3c 01                	cmp    $0x1,%al
8010333b:	0f 95 c2             	setne  %dl
8010333e:	3c 04                	cmp    $0x4,%al
80103340:	0f 95 c0             	setne  %al
80103343:	20 c2                	and    %al,%dl
80103345:	0f 85 15 01 00 00    	jne    80103460 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010334b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103352:	66 85 ff             	test   %di,%di
80103355:	74 1a                	je     80103371 <mpinit+0xc1>
80103357:	89 f0                	mov    %esi,%eax
80103359:	01 f7                	add    %esi,%edi
  sum = 0;
8010335b:	31 d2                	xor    %edx,%edx
8010335d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103360:	0f b6 08             	movzbl (%eax),%ecx
80103363:	83 c0 01             	add    $0x1,%eax
80103366:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103368:	39 c7                	cmp    %eax,%edi
8010336a:	75 f4                	jne    80103360 <mpinit+0xb0>
8010336c:	84 d2                	test   %dl,%dl
8010336e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103371:	85 f6                	test   %esi,%esi
80103373:	0f 84 e7 00 00 00    	je     80103460 <mpinit+0x1b0>
80103379:	84 d2                	test   %dl,%dl
8010337b:	0f 85 df 00 00 00    	jne    80103460 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103381:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103387:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010338c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103393:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103399:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010339e:	01 d6                	add    %edx,%esi
801033a0:	39 c6                	cmp    %eax,%esi
801033a2:	76 23                	jbe    801033c7 <mpinit+0x117>
    switch(*p){
801033a4:	0f b6 10             	movzbl (%eax),%edx
801033a7:	80 fa 04             	cmp    $0x4,%dl
801033aa:	0f 87 ca 00 00 00    	ja     8010347a <mpinit+0x1ca>
801033b0:	ff 24 95 1c 7b 10 80 	jmp    *-0x7fef84e4(,%edx,4)
801033b7:	89 f6                	mov    %esi,%esi
801033b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801033c0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033c3:	39 c6                	cmp    %eax,%esi
801033c5:	77 dd                	ja     801033a4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801033c7:	85 db                	test   %ebx,%ebx
801033c9:	0f 84 9e 00 00 00    	je     8010346d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801033cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801033d2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801033d6:	74 15                	je     801033ed <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033d8:	b8 70 00 00 00       	mov    $0x70,%eax
801033dd:	ba 22 00 00 00       	mov    $0x22,%edx
801033e2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033e3:	ba 23 00 00 00       	mov    $0x23,%edx
801033e8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801033e9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033ec:	ee                   	out    %al,(%dx)
  }
}
801033ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033f0:	5b                   	pop    %ebx
801033f1:	5e                   	pop    %esi
801033f2:	5f                   	pop    %edi
801033f3:	5d                   	pop    %ebp
801033f4:	c3                   	ret    
801033f5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801033f8:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
801033fe:	83 f9 07             	cmp    $0x7,%ecx
80103401:	7f 19                	jg     8010341c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103403:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103407:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010340d:	83 c1 01             	add    $0x1,%ecx
80103410:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103416:	88 97 80 37 11 80    	mov    %dl,-0x7feec880(%edi)
      p += sizeof(struct mpproc);
8010341c:	83 c0 14             	add    $0x14,%eax
      continue;
8010341f:	e9 7c ff ff ff       	jmp    801033a0 <mpinit+0xf0>
80103424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103428:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010342c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010342f:	88 15 60 37 11 80    	mov    %dl,0x80113760
      continue;
80103435:	e9 66 ff ff ff       	jmp    801033a0 <mpinit+0xf0>
8010343a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103440:	ba 00 00 01 00       	mov    $0x10000,%edx
80103445:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010344a:	e8 e1 fd ff ff       	call   80103230 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010344f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103451:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103454:	0f 85 a9 fe ff ff    	jne    80103303 <mpinit+0x53>
8010345a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103460:	83 ec 0c             	sub    $0xc,%esp
80103463:	68 dd 7a 10 80       	push   $0x80107add
80103468:	e8 23 d0 ff ff       	call   80100490 <panic>
    panic("Didn't find a suitable machine");
8010346d:	83 ec 0c             	sub    $0xc,%esp
80103470:	68 fc 7a 10 80       	push   $0x80107afc
80103475:	e8 16 d0 ff ff       	call   80100490 <panic>
      ismp = 0;
8010347a:	31 db                	xor    %ebx,%ebx
8010347c:	e9 26 ff ff ff       	jmp    801033a7 <mpinit+0xf7>
80103481:	66 90                	xchg   %ax,%ax
80103483:	66 90                	xchg   %ax,%ax
80103485:	66 90                	xchg   %ax,%ax
80103487:	66 90                	xchg   %ax,%ax
80103489:	66 90                	xchg   %ax,%ax
8010348b:	66 90                	xchg   %ax,%ax
8010348d:	66 90                	xchg   %ax,%ax
8010348f:	90                   	nop

80103490 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103490:	55                   	push   %ebp
80103491:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103496:	ba 21 00 00 00       	mov    $0x21,%edx
8010349b:	89 e5                	mov    %esp,%ebp
8010349d:	ee                   	out    %al,(%dx)
8010349e:	ba a1 00 00 00       	mov    $0xa1,%edx
801034a3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801034a4:	5d                   	pop    %ebp
801034a5:	c3                   	ret    
801034a6:	66 90                	xchg   %ax,%ax
801034a8:	66 90                	xchg   %ax,%ax
801034aa:	66 90                	xchg   %ax,%ax
801034ac:	66 90                	xchg   %ax,%ax
801034ae:	66 90                	xchg   %ax,%ax

801034b0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801034b0:	55                   	push   %ebp
801034b1:	89 e5                	mov    %esp,%ebp
801034b3:	57                   	push   %edi
801034b4:	56                   	push   %esi
801034b5:	53                   	push   %ebx
801034b6:	83 ec 0c             	sub    $0xc,%esp
801034b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801034bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801034bf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801034c5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801034cb:	e8 b0 d9 ff ff       	call   80100e80 <filealloc>
801034d0:	85 c0                	test   %eax,%eax
801034d2:	89 03                	mov    %eax,(%ebx)
801034d4:	74 22                	je     801034f8 <pipealloc+0x48>
801034d6:	e8 a5 d9 ff ff       	call   80100e80 <filealloc>
801034db:	85 c0                	test   %eax,%eax
801034dd:	89 06                	mov    %eax,(%esi)
801034df:	74 3f                	je     80103520 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801034e1:	e8 4a f2 ff ff       	call   80102730 <kalloc>
801034e6:	85 c0                	test   %eax,%eax
801034e8:	89 c7                	mov    %eax,%edi
801034ea:	75 54                	jne    80103540 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801034ec:	8b 03                	mov    (%ebx),%eax
801034ee:	85 c0                	test   %eax,%eax
801034f0:	75 34                	jne    80103526 <pipealloc+0x76>
801034f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801034f8:	8b 06                	mov    (%esi),%eax
801034fa:	85 c0                	test   %eax,%eax
801034fc:	74 0c                	je     8010350a <pipealloc+0x5a>
    fileclose(*f1);
801034fe:	83 ec 0c             	sub    $0xc,%esp
80103501:	50                   	push   %eax
80103502:	e8 39 da ff ff       	call   80100f40 <fileclose>
80103507:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010350a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010350d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103512:	5b                   	pop    %ebx
80103513:	5e                   	pop    %esi
80103514:	5f                   	pop    %edi
80103515:	5d                   	pop    %ebp
80103516:	c3                   	ret    
80103517:	89 f6                	mov    %esi,%esi
80103519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103520:	8b 03                	mov    (%ebx),%eax
80103522:	85 c0                	test   %eax,%eax
80103524:	74 e4                	je     8010350a <pipealloc+0x5a>
    fileclose(*f0);
80103526:	83 ec 0c             	sub    $0xc,%esp
80103529:	50                   	push   %eax
8010352a:	e8 11 da ff ff       	call   80100f40 <fileclose>
  if(*f1)
8010352f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103531:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103534:	85 c0                	test   %eax,%eax
80103536:	75 c6                	jne    801034fe <pipealloc+0x4e>
80103538:	eb d0                	jmp    8010350a <pipealloc+0x5a>
8010353a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103540:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103543:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010354a:	00 00 00 
  p->writeopen = 1;
8010354d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103554:	00 00 00 
  p->nwrite = 0;
80103557:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010355e:	00 00 00 
  p->nread = 0;
80103561:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103568:	00 00 00 
  initlock(&p->lock, "pipe");
8010356b:	68 30 7b 10 80       	push   $0x80107b30
80103570:	50                   	push   %eax
80103571:	e8 ba 0e 00 00       	call   80104430 <initlock>
  (*f0)->type = FD_PIPE;
80103576:	8b 03                	mov    (%ebx),%eax
  return 0;
80103578:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010357b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103581:	8b 03                	mov    (%ebx),%eax
80103583:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103587:	8b 03                	mov    (%ebx),%eax
80103589:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010358d:	8b 03                	mov    (%ebx),%eax
8010358f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103592:	8b 06                	mov    (%esi),%eax
80103594:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010359a:	8b 06                	mov    (%esi),%eax
8010359c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801035a0:	8b 06                	mov    (%esi),%eax
801035a2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801035a6:	8b 06                	mov    (%esi),%eax
801035a8:	89 78 0c             	mov    %edi,0xc(%eax)
}
801035ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801035ae:	31 c0                	xor    %eax,%eax
}
801035b0:	5b                   	pop    %ebx
801035b1:	5e                   	pop    %esi
801035b2:	5f                   	pop    %edi
801035b3:	5d                   	pop    %ebp
801035b4:	c3                   	ret    
801035b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801035c0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801035c0:	55                   	push   %ebp
801035c1:	89 e5                	mov    %esp,%ebp
801035c3:	56                   	push   %esi
801035c4:	53                   	push   %ebx
801035c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801035cb:	83 ec 0c             	sub    $0xc,%esp
801035ce:	53                   	push   %ebx
801035cf:	e8 4c 0f 00 00       	call   80104520 <acquire>
  if(writable){
801035d4:	83 c4 10             	add    $0x10,%esp
801035d7:	85 f6                	test   %esi,%esi
801035d9:	74 45                	je     80103620 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801035db:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801035e1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801035e4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801035eb:	00 00 00 
    wakeup(&p->nread);
801035ee:	50                   	push   %eax
801035ef:	e8 8c 0b 00 00       	call   80104180 <wakeup>
801035f4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801035f7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801035fd:	85 d2                	test   %edx,%edx
801035ff:	75 0a                	jne    8010360b <pipeclose+0x4b>
80103601:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103607:	85 c0                	test   %eax,%eax
80103609:	74 35                	je     80103640 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010360b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010360e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103611:	5b                   	pop    %ebx
80103612:	5e                   	pop    %esi
80103613:	5d                   	pop    %ebp
    release(&p->lock);
80103614:	e9 27 10 00 00       	jmp    80104640 <release>
80103619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103620:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103626:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103629:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103630:	00 00 00 
    wakeup(&p->nwrite);
80103633:	50                   	push   %eax
80103634:	e8 47 0b 00 00       	call   80104180 <wakeup>
80103639:	83 c4 10             	add    $0x10,%esp
8010363c:	eb b9                	jmp    801035f7 <pipeclose+0x37>
8010363e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103640:	83 ec 0c             	sub    $0xc,%esp
80103643:	53                   	push   %ebx
80103644:	e8 f7 0f 00 00       	call   80104640 <release>
    kfree((char*)p);
80103649:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010364c:	83 c4 10             	add    $0x10,%esp
}
8010364f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103652:	5b                   	pop    %ebx
80103653:	5e                   	pop    %esi
80103654:	5d                   	pop    %ebp
    kfree((char*)p);
80103655:	e9 26 ef ff ff       	jmp    80102580 <kfree>
8010365a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103660 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103660:	55                   	push   %ebp
80103661:	89 e5                	mov    %esp,%ebp
80103663:	57                   	push   %edi
80103664:	56                   	push   %esi
80103665:	53                   	push   %ebx
80103666:	83 ec 28             	sub    $0x28,%esp
80103669:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010366c:	53                   	push   %ebx
8010366d:	e8 ae 0e 00 00       	call   80104520 <acquire>
  for(i = 0; i < n; i++){
80103672:	8b 45 10             	mov    0x10(%ebp),%eax
80103675:	83 c4 10             	add    $0x10,%esp
80103678:	85 c0                	test   %eax,%eax
8010367a:	0f 8e c9 00 00 00    	jle    80103749 <pipewrite+0xe9>
80103680:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103683:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103689:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010368f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103692:	03 4d 10             	add    0x10(%ebp),%ecx
80103695:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103698:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010369e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801036a4:	39 d0                	cmp    %edx,%eax
801036a6:	75 71                	jne    80103719 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801036a8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801036ae:	85 c0                	test   %eax,%eax
801036b0:	74 4e                	je     80103700 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036b2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801036b8:	eb 3a                	jmp    801036f4 <pipewrite+0x94>
801036ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
801036c0:	83 ec 0c             	sub    $0xc,%esp
801036c3:	57                   	push   %edi
801036c4:	e8 b7 0a 00 00       	call   80104180 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036c9:	5a                   	pop    %edx
801036ca:	59                   	pop    %ecx
801036cb:	53                   	push   %ebx
801036cc:	56                   	push   %esi
801036cd:	e8 ee 08 00 00       	call   80103fc0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036d2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801036d8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801036de:	83 c4 10             	add    $0x10,%esp
801036e1:	05 00 02 00 00       	add    $0x200,%eax
801036e6:	39 c2                	cmp    %eax,%edx
801036e8:	75 36                	jne    80103720 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801036ea:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801036f0:	85 c0                	test   %eax,%eax
801036f2:	74 0c                	je     80103700 <pipewrite+0xa0>
801036f4:	e8 57 03 00 00       	call   80103a50 <myproc>
801036f9:	8b 40 24             	mov    0x24(%eax),%eax
801036fc:	85 c0                	test   %eax,%eax
801036fe:	74 c0                	je     801036c0 <pipewrite+0x60>
        release(&p->lock);
80103700:	83 ec 0c             	sub    $0xc,%esp
80103703:	53                   	push   %ebx
80103704:	e8 37 0f 00 00       	call   80104640 <release>
        return -1;
80103709:	83 c4 10             	add    $0x10,%esp
8010370c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103711:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103714:	5b                   	pop    %ebx
80103715:	5e                   	pop    %esi
80103716:	5f                   	pop    %edi
80103717:	5d                   	pop    %ebp
80103718:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103719:	89 c2                	mov    %eax,%edx
8010371b:	90                   	nop
8010371c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103720:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103723:	8d 42 01             	lea    0x1(%edx),%eax
80103726:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010372c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103732:	83 c6 01             	add    $0x1,%esi
80103735:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103739:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010373c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010373f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103743:	0f 85 4f ff ff ff    	jne    80103698 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103749:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010374f:	83 ec 0c             	sub    $0xc,%esp
80103752:	50                   	push   %eax
80103753:	e8 28 0a 00 00       	call   80104180 <wakeup>
  release(&p->lock);
80103758:	89 1c 24             	mov    %ebx,(%esp)
8010375b:	e8 e0 0e 00 00       	call   80104640 <release>
  return n;
80103760:	83 c4 10             	add    $0x10,%esp
80103763:	8b 45 10             	mov    0x10(%ebp),%eax
80103766:	eb a9                	jmp    80103711 <pipewrite+0xb1>
80103768:	90                   	nop
80103769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103770 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103770:	55                   	push   %ebp
80103771:	89 e5                	mov    %esp,%ebp
80103773:	57                   	push   %edi
80103774:	56                   	push   %esi
80103775:	53                   	push   %ebx
80103776:	83 ec 18             	sub    $0x18,%esp
80103779:	8b 75 08             	mov    0x8(%ebp),%esi
8010377c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010377f:	56                   	push   %esi
80103780:	e8 9b 0d 00 00       	call   80104520 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103785:	83 c4 10             	add    $0x10,%esp
80103788:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010378e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103794:	75 6a                	jne    80103800 <piperead+0x90>
80103796:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010379c:	85 db                	test   %ebx,%ebx
8010379e:	0f 84 c4 00 00 00    	je     80103868 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801037a4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801037aa:	eb 2d                	jmp    801037d9 <piperead+0x69>
801037ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037b0:	83 ec 08             	sub    $0x8,%esp
801037b3:	56                   	push   %esi
801037b4:	53                   	push   %ebx
801037b5:	e8 06 08 00 00       	call   80103fc0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037ba:	83 c4 10             	add    $0x10,%esp
801037bd:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801037c3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801037c9:	75 35                	jne    80103800 <piperead+0x90>
801037cb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801037d1:	85 d2                	test   %edx,%edx
801037d3:	0f 84 8f 00 00 00    	je     80103868 <piperead+0xf8>
    if(myproc()->killed){
801037d9:	e8 72 02 00 00       	call   80103a50 <myproc>
801037de:	8b 48 24             	mov    0x24(%eax),%ecx
801037e1:	85 c9                	test   %ecx,%ecx
801037e3:	74 cb                	je     801037b0 <piperead+0x40>
      release(&p->lock);
801037e5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037e8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037ed:	56                   	push   %esi
801037ee:	e8 4d 0e 00 00       	call   80104640 <release>
      return -1;
801037f3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801037f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037f9:	89 d8                	mov    %ebx,%eax
801037fb:	5b                   	pop    %ebx
801037fc:	5e                   	pop    %esi
801037fd:	5f                   	pop    %edi
801037fe:	5d                   	pop    %ebp
801037ff:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103800:	8b 45 10             	mov    0x10(%ebp),%eax
80103803:	85 c0                	test   %eax,%eax
80103805:	7e 61                	jle    80103868 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103807:	31 db                	xor    %ebx,%ebx
80103809:	eb 13                	jmp    8010381e <piperead+0xae>
8010380b:	90                   	nop
8010380c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103810:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103816:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010381c:	74 1f                	je     8010383d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010381e:	8d 41 01             	lea    0x1(%ecx),%eax
80103821:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103827:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010382d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103832:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103835:	83 c3 01             	add    $0x1,%ebx
80103838:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010383b:	75 d3                	jne    80103810 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010383d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103843:	83 ec 0c             	sub    $0xc,%esp
80103846:	50                   	push   %eax
80103847:	e8 34 09 00 00       	call   80104180 <wakeup>
  release(&p->lock);
8010384c:	89 34 24             	mov    %esi,(%esp)
8010384f:	e8 ec 0d 00 00       	call   80104640 <release>
  return i;
80103854:	83 c4 10             	add    $0x10,%esp
}
80103857:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010385a:	89 d8                	mov    %ebx,%eax
8010385c:	5b                   	pop    %ebx
8010385d:	5e                   	pop    %esi
8010385e:	5f                   	pop    %edi
8010385f:	5d                   	pop    %ebp
80103860:	c3                   	ret    
80103861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103868:	31 db                	xor    %ebx,%ebx
8010386a:	eb d1                	jmp    8010383d <piperead+0xcd>
8010386c:	66 90                	xchg   %ax,%ax
8010386e:	66 90                	xchg   %ax,%ax

80103870 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103874:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
80103879:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010387c:	68 20 3d 11 80       	push   $0x80113d20
80103881:	e8 9a 0c 00 00       	call   80104520 <acquire>
80103886:	83 c4 10             	add    $0x10,%esp
80103889:	eb 10                	jmp    8010389b <allocproc+0x2b>
8010388b:	90                   	nop
8010388c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103890:	83 c3 7c             	add    $0x7c,%ebx
80103893:	81 fb 54 5c 11 80    	cmp    $0x80115c54,%ebx
80103899:	73 75                	jae    80103910 <allocproc+0xa0>
    if(p->state == UNUSED)
8010389b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010389e:	85 c0                	test   %eax,%eax
801038a0:	75 ee                	jne    80103890 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801038a2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801038a7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801038aa:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801038b1:	8d 50 01             	lea    0x1(%eax),%edx
801038b4:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801038b7:	68 20 3d 11 80       	push   $0x80113d20
  p->pid = nextpid++;
801038bc:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801038c2:	e8 79 0d 00 00       	call   80104640 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801038c7:	e8 64 ee ff ff       	call   80102730 <kalloc>
801038cc:	83 c4 10             	add    $0x10,%esp
801038cf:	85 c0                	test   %eax,%eax
801038d1:	89 43 08             	mov    %eax,0x8(%ebx)
801038d4:	74 53                	je     80103929 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801038d6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801038dc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801038df:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801038e4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801038e7:	c7 40 14 e2 58 10 80 	movl   $0x801058e2,0x14(%eax)
  p->context = (struct context*)sp;
801038ee:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801038f1:	6a 14                	push   $0x14
801038f3:	6a 00                	push   $0x0
801038f5:	50                   	push   %eax
801038f6:	e8 a5 0d 00 00       	call   801046a0 <memset>
  p->context->eip = (uint)forkret;
801038fb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801038fe:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103901:	c7 40 10 40 39 10 80 	movl   $0x80103940,0x10(%eax)
}
80103908:	89 d8                	mov    %ebx,%eax
8010390a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010390d:	c9                   	leave  
8010390e:	c3                   	ret    
8010390f:	90                   	nop
  release(&ptable.lock);
80103910:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103913:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103915:	68 20 3d 11 80       	push   $0x80113d20
8010391a:	e8 21 0d 00 00       	call   80104640 <release>
}
8010391f:	89 d8                	mov    %ebx,%eax
  return 0;
80103921:	83 c4 10             	add    $0x10,%esp
}
80103924:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103927:	c9                   	leave  
80103928:	c3                   	ret    
    p->state = UNUSED;
80103929:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103930:	31 db                	xor    %ebx,%ebx
80103932:	eb d4                	jmp    80103908 <allocproc+0x98>
80103934:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010393a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103940 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103946:	68 20 3d 11 80       	push   $0x80113d20
8010394b:	e8 f0 0c 00 00       	call   80104640 <release>

  if (first) {
80103950:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103955:	83 c4 10             	add    $0x10,%esp
80103958:	85 c0                	test   %eax,%eax
8010395a:	75 04                	jne    80103960 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010395c:	c9                   	leave  
8010395d:	c3                   	ret    
8010395e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103960:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103963:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010396a:	00 00 00 
    iinit(ROOTDEV);
8010396d:	6a 01                	push   $0x1
8010396f:	e8 8c dd ff ff       	call   80101700 <iinit>
    initlog(ROOTDEV);
80103974:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010397b:	e8 f0 f3 ff ff       	call   80102d70 <initlog>
80103980:	83 c4 10             	add    $0x10,%esp
}
80103983:	c9                   	leave  
80103984:	c3                   	ret    
80103985:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103990 <pinit>:
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103996:	68 35 7b 10 80       	push   $0x80107b35
8010399b:	68 20 3d 11 80       	push   $0x80113d20
801039a0:	e8 8b 0a 00 00       	call   80104430 <initlock>
}
801039a5:	83 c4 10             	add    $0x10,%esp
801039a8:	c9                   	leave  
801039a9:	c3                   	ret    
801039aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039b0 <mycpu>:
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	56                   	push   %esi
801039b4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801039b5:	9c                   	pushf  
801039b6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801039b7:	f6 c4 02             	test   $0x2,%ah
801039ba:	75 5e                	jne    80103a1a <mycpu+0x6a>
  apicid = lapicid();
801039bc:	e8 df ef ff ff       	call   801029a0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801039c1:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
801039c7:	85 f6                	test   %esi,%esi
801039c9:	7e 42                	jle    80103a0d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801039cb:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
801039d2:	39 d0                	cmp    %edx,%eax
801039d4:	74 30                	je     80103a06 <mycpu+0x56>
801039d6:	b9 30 38 11 80       	mov    $0x80113830,%ecx
  for (i = 0; i < ncpu; ++i) {
801039db:	31 d2                	xor    %edx,%edx
801039dd:	8d 76 00             	lea    0x0(%esi),%esi
801039e0:	83 c2 01             	add    $0x1,%edx
801039e3:	39 f2                	cmp    %esi,%edx
801039e5:	74 26                	je     80103a0d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801039e7:	0f b6 19             	movzbl (%ecx),%ebx
801039ea:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801039f0:	39 c3                	cmp    %eax,%ebx
801039f2:	75 ec                	jne    801039e0 <mycpu+0x30>
801039f4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801039fa:	05 80 37 11 80       	add    $0x80113780,%eax
}
801039ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a02:	5b                   	pop    %ebx
80103a03:	5e                   	pop    %esi
80103a04:	5d                   	pop    %ebp
80103a05:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103a06:	b8 80 37 11 80       	mov    $0x80113780,%eax
      return &cpus[i];
80103a0b:	eb f2                	jmp    801039ff <mycpu+0x4f>
  panic("unknown apicid\n");
80103a0d:	83 ec 0c             	sub    $0xc,%esp
80103a10:	68 3c 7b 10 80       	push   $0x80107b3c
80103a15:	e8 76 ca ff ff       	call   80100490 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a1a:	83 ec 0c             	sub    $0xc,%esp
80103a1d:	68 18 7c 10 80       	push   $0x80107c18
80103a22:	e8 69 ca ff ff       	call   80100490 <panic>
80103a27:	89 f6                	mov    %esi,%esi
80103a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a30 <cpuid>:
cpuid() {
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a36:	e8 75 ff ff ff       	call   801039b0 <mycpu>
80103a3b:	2d 80 37 11 80       	sub    $0x80113780,%eax
}
80103a40:	c9                   	leave  
  return mycpu()-cpus;
80103a41:	c1 f8 04             	sar    $0x4,%eax
80103a44:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a4a:	c3                   	ret    
80103a4b:	90                   	nop
80103a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a50 <myproc>:
myproc(void) {
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	53                   	push   %ebx
80103a54:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a57:	e8 84 0a 00 00       	call   801044e0 <pushcli>
  c = mycpu();
80103a5c:	e8 4f ff ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103a61:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a67:	e8 74 0b 00 00       	call   801045e0 <popcli>
}
80103a6c:	83 c4 04             	add    $0x4,%esp
80103a6f:	89 d8                	mov    %ebx,%eax
80103a71:	5b                   	pop    %ebx
80103a72:	5d                   	pop    %ebp
80103a73:	c3                   	ret    
80103a74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103a80 <userinit>:
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	53                   	push   %ebx
80103a84:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a87:	e8 e4 fd ff ff       	call   80103870 <allocproc>
80103a8c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a8e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103a93:	e8 38 37 00 00       	call   801071d0 <setupkvm>
80103a98:	85 c0                	test   %eax,%eax
80103a9a:	89 43 04             	mov    %eax,0x4(%ebx)
80103a9d:	0f 84 bd 00 00 00    	je     80103b60 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103aa3:	83 ec 04             	sub    $0x4,%esp
80103aa6:	68 2c 00 00 00       	push   $0x2c
80103aab:	68 60 b4 10 80       	push   $0x8010b460
80103ab0:	50                   	push   %eax
80103ab1:	e8 2a 34 00 00       	call   80106ee0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103ab6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103ab9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103abf:	6a 4c                	push   $0x4c
80103ac1:	6a 00                	push   $0x0
80103ac3:	ff 73 18             	pushl  0x18(%ebx)
80103ac6:	e8 d5 0b 00 00       	call   801046a0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103acb:	8b 43 18             	mov    0x18(%ebx),%eax
80103ace:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ad3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ad8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103adb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103adf:	8b 43 18             	mov    0x18(%ebx),%eax
80103ae2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103ae6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ae9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103aed:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103af1:	8b 43 18             	mov    0x18(%ebx),%eax
80103af4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103af8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103afc:	8b 43 18             	mov    0x18(%ebx),%eax
80103aff:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b06:	8b 43 18             	mov    0x18(%ebx),%eax
80103b09:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b10:	8b 43 18             	mov    0x18(%ebx),%eax
80103b13:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b1a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b1d:	6a 10                	push   $0x10
80103b1f:	68 65 7b 10 80       	push   $0x80107b65
80103b24:	50                   	push   %eax
80103b25:	e8 56 0d 00 00       	call   80104880 <safestrcpy>
  p->cwd = namei("/");
80103b2a:	c7 04 24 6e 7b 10 80 	movl   $0x80107b6e,(%esp)
80103b31:	e8 2a e6 ff ff       	call   80102160 <namei>
80103b36:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103b39:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103b40:	e8 db 09 00 00       	call   80104520 <acquire>
  p->state = RUNNABLE;
80103b45:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103b4c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103b53:	e8 e8 0a 00 00       	call   80104640 <release>
}
80103b58:	83 c4 10             	add    $0x10,%esp
80103b5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b5e:	c9                   	leave  
80103b5f:	c3                   	ret    
    panic("userinit: out of memory?");
80103b60:	83 ec 0c             	sub    $0xc,%esp
80103b63:	68 4c 7b 10 80       	push   $0x80107b4c
80103b68:	e8 23 c9 ff ff       	call   80100490 <panic>
80103b6d:	8d 76 00             	lea    0x0(%esi),%esi

80103b70 <growproc>:
{
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	56                   	push   %esi
80103b74:	53                   	push   %ebx
80103b75:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103b78:	e8 63 09 00 00       	call   801044e0 <pushcli>
  c = mycpu();
80103b7d:	e8 2e fe ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103b82:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103b88:	e8 53 0a 00 00       	call   801045e0 <popcli>
  if (n < 0 || n > KERNBASE || curproc->sz + n > KERNBASE)
80103b8d:	85 db                	test   %ebx,%ebx
80103b8f:	78 1f                	js     80103bb0 <growproc+0x40>
80103b91:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80103b97:	77 17                	ja     80103bb0 <growproc+0x40>
80103b99:	03 1e                	add    (%esi),%ebx
80103b9b:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80103ba1:	77 0d                	ja     80103bb0 <growproc+0x40>
  curproc->sz += n;
80103ba3:	89 1e                	mov    %ebx,(%esi)
  return 0;
80103ba5:	31 c0                	xor    %eax,%eax
}
80103ba7:	5b                   	pop    %ebx
80103ba8:	5e                   	pop    %esi
80103ba9:	5d                   	pop    %ebp
80103baa:	c3                   	ret    
80103bab:	90                   	nop
80103bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	  return -1;
80103bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bb5:	eb f0                	jmp    80103ba7 <growproc+0x37>
80103bb7:	89 f6                	mov    %esi,%esi
80103bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103bc0 <fork>:
{
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	57                   	push   %edi
80103bc4:	56                   	push   %esi
80103bc5:	53                   	push   %ebx
80103bc6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103bc9:	e8 12 09 00 00       	call   801044e0 <pushcli>
  c = mycpu();
80103bce:	e8 dd fd ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103bd3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bd9:	e8 02 0a 00 00       	call   801045e0 <popcli>
  if((np = allocproc()) == 0){
80103bde:	e8 8d fc ff ff       	call   80103870 <allocproc>
80103be3:	85 c0                	test   %eax,%eax
80103be5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103be8:	0f 84 b7 00 00 00    	je     80103ca5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103bee:	83 ec 08             	sub    $0x8,%esp
80103bf1:	ff 33                	pushl  (%ebx)
80103bf3:	ff 73 04             	pushl  0x4(%ebx)
80103bf6:	89 c7                	mov    %eax,%edi
80103bf8:	e8 c3 37 00 00       	call   801073c0 <copyuvm>
80103bfd:	83 c4 10             	add    $0x10,%esp
80103c00:	85 c0                	test   %eax,%eax
80103c02:	89 47 04             	mov    %eax,0x4(%edi)
80103c05:	0f 84 a1 00 00 00    	je     80103cac <fork+0xec>
  np->sz = curproc->sz;
80103c0b:	8b 03                	mov    (%ebx),%eax
80103c0d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103c10:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103c12:	89 59 14             	mov    %ebx,0x14(%ecx)
80103c15:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103c17:	8b 79 18             	mov    0x18(%ecx),%edi
80103c1a:	8b 73 18             	mov    0x18(%ebx),%esi
80103c1d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103c22:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103c24:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103c26:	8b 40 18             	mov    0x18(%eax),%eax
80103c29:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103c30:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c34:	85 c0                	test   %eax,%eax
80103c36:	74 13                	je     80103c4b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c38:	83 ec 0c             	sub    $0xc,%esp
80103c3b:	50                   	push   %eax
80103c3c:	e8 af d2 ff ff       	call   80100ef0 <filedup>
80103c41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c44:	83 c4 10             	add    $0x10,%esp
80103c47:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103c4b:	83 c6 01             	add    $0x1,%esi
80103c4e:	83 fe 10             	cmp    $0x10,%esi
80103c51:	75 dd                	jne    80103c30 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103c53:	83 ec 0c             	sub    $0xc,%esp
80103c56:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c59:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103c5c:	e8 6f dc ff ff       	call   801018d0 <idup>
80103c61:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c64:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c67:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c6a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c6d:	6a 10                	push   $0x10
80103c6f:	53                   	push   %ebx
80103c70:	50                   	push   %eax
80103c71:	e8 0a 0c 00 00       	call   80104880 <safestrcpy>
  pid = np->pid;
80103c76:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c79:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c80:	e8 9b 08 00 00       	call   80104520 <acquire>
  np->state = RUNNABLE;
80103c85:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c8c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c93:	e8 a8 09 00 00       	call   80104640 <release>
  return pid;
80103c98:	83 c4 10             	add    $0x10,%esp
}
80103c9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c9e:	89 d8                	mov    %ebx,%eax
80103ca0:	5b                   	pop    %ebx
80103ca1:	5e                   	pop    %esi
80103ca2:	5f                   	pop    %edi
80103ca3:	5d                   	pop    %ebp
80103ca4:	c3                   	ret    
    return -1;
80103ca5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103caa:	eb ef                	jmp    80103c9b <fork+0xdb>
    kfree(np->kstack);
80103cac:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103caf:	83 ec 0c             	sub    $0xc,%esp
80103cb2:	ff 73 08             	pushl  0x8(%ebx)
80103cb5:	e8 c6 e8 ff ff       	call   80102580 <kfree>
    np->kstack = 0;
80103cba:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103cc1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103cc8:	83 c4 10             	add    $0x10,%esp
80103ccb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103cd0:	eb c9                	jmp    80103c9b <fork+0xdb>
80103cd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ce0 <scheduler>:
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	57                   	push   %edi
80103ce4:	56                   	push   %esi
80103ce5:	53                   	push   %ebx
80103ce6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103ce9:	e8 c2 fc ff ff       	call   801039b0 <mycpu>
80103cee:	8d 78 04             	lea    0x4(%eax),%edi
80103cf1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103cf3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103cfa:	00 00 00 
80103cfd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103d00:	fb                   	sti    
    acquire(&ptable.lock);
80103d01:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d04:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
    acquire(&ptable.lock);
80103d09:	68 20 3d 11 80       	push   $0x80113d20
80103d0e:	e8 0d 08 00 00       	call   80104520 <acquire>
80103d13:	83 c4 10             	add    $0x10,%esp
80103d16:	8d 76 00             	lea    0x0(%esi),%esi
80103d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103d20:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103d24:	75 33                	jne    80103d59 <scheduler+0x79>
      switchuvm(p);
80103d26:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103d29:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103d2f:	53                   	push   %ebx
80103d30:	e8 9b 30 00 00       	call   80106dd0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103d35:	58                   	pop    %eax
80103d36:	5a                   	pop    %edx
80103d37:	ff 73 1c             	pushl  0x1c(%ebx)
80103d3a:	57                   	push   %edi
      p->state = RUNNING;
80103d3b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103d42:	e8 94 0b 00 00       	call   801048db <swtch>
      switchkvm();
80103d47:	e8 64 30 00 00       	call   80106db0 <switchkvm>
      c->proc = 0;
80103d4c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103d53:	00 00 00 
80103d56:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d59:	83 c3 7c             	add    $0x7c,%ebx
80103d5c:	81 fb 54 5c 11 80    	cmp    $0x80115c54,%ebx
80103d62:	72 bc                	jb     80103d20 <scheduler+0x40>
    release(&ptable.lock);
80103d64:	83 ec 0c             	sub    $0xc,%esp
80103d67:	68 20 3d 11 80       	push   $0x80113d20
80103d6c:	e8 cf 08 00 00       	call   80104640 <release>
    sti();
80103d71:	83 c4 10             	add    $0x10,%esp
80103d74:	eb 8a                	jmp    80103d00 <scheduler+0x20>
80103d76:	8d 76 00             	lea    0x0(%esi),%esi
80103d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d80 <sched>:
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	56                   	push   %esi
80103d84:	53                   	push   %ebx
  pushcli();
80103d85:	e8 56 07 00 00       	call   801044e0 <pushcli>
  c = mycpu();
80103d8a:	e8 21 fc ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103d8f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d95:	e8 46 08 00 00       	call   801045e0 <popcli>
  if(!holding(&ptable.lock))
80103d9a:	83 ec 0c             	sub    $0xc,%esp
80103d9d:	68 20 3d 11 80       	push   $0x80113d20
80103da2:	e8 f9 06 00 00       	call   801044a0 <holding>
80103da7:	83 c4 10             	add    $0x10,%esp
80103daa:	85 c0                	test   %eax,%eax
80103dac:	74 4f                	je     80103dfd <sched+0x7d>
  if(mycpu()->ncli != 1)
80103dae:	e8 fd fb ff ff       	call   801039b0 <mycpu>
80103db3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103dba:	75 68                	jne    80103e24 <sched+0xa4>
  if(p->state == RUNNING)
80103dbc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103dc0:	74 55                	je     80103e17 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103dc2:	9c                   	pushf  
80103dc3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103dc4:	f6 c4 02             	test   $0x2,%ah
80103dc7:	75 41                	jne    80103e0a <sched+0x8a>
  intena = mycpu()->intena;
80103dc9:	e8 e2 fb ff ff       	call   801039b0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103dce:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103dd1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103dd7:	e8 d4 fb ff ff       	call   801039b0 <mycpu>
80103ddc:	83 ec 08             	sub    $0x8,%esp
80103ddf:	ff 70 04             	pushl  0x4(%eax)
80103de2:	53                   	push   %ebx
80103de3:	e8 f3 0a 00 00       	call   801048db <swtch>
  mycpu()->intena = intena;
80103de8:	e8 c3 fb ff ff       	call   801039b0 <mycpu>
}
80103ded:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103df0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103df6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103df9:	5b                   	pop    %ebx
80103dfa:	5e                   	pop    %esi
80103dfb:	5d                   	pop    %ebp
80103dfc:	c3                   	ret    
    panic("sched ptable.lock");
80103dfd:	83 ec 0c             	sub    $0xc,%esp
80103e00:	68 70 7b 10 80       	push   $0x80107b70
80103e05:	e8 86 c6 ff ff       	call   80100490 <panic>
    panic("sched interruptible");
80103e0a:	83 ec 0c             	sub    $0xc,%esp
80103e0d:	68 9c 7b 10 80       	push   $0x80107b9c
80103e12:	e8 79 c6 ff ff       	call   80100490 <panic>
    panic("sched running");
80103e17:	83 ec 0c             	sub    $0xc,%esp
80103e1a:	68 8e 7b 10 80       	push   $0x80107b8e
80103e1f:	e8 6c c6 ff ff       	call   80100490 <panic>
    panic("sched locks");
80103e24:	83 ec 0c             	sub    $0xc,%esp
80103e27:	68 82 7b 10 80       	push   $0x80107b82
80103e2c:	e8 5f c6 ff ff       	call   80100490 <panic>
80103e31:	eb 0d                	jmp    80103e40 <exit>
80103e33:	90                   	nop
80103e34:	90                   	nop
80103e35:	90                   	nop
80103e36:	90                   	nop
80103e37:	90                   	nop
80103e38:	90                   	nop
80103e39:	90                   	nop
80103e3a:	90                   	nop
80103e3b:	90                   	nop
80103e3c:	90                   	nop
80103e3d:	90                   	nop
80103e3e:	90                   	nop
80103e3f:	90                   	nop

80103e40 <exit>:
{
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	57                   	push   %edi
80103e44:	56                   	push   %esi
80103e45:	53                   	push   %ebx
80103e46:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103e49:	e8 92 06 00 00       	call   801044e0 <pushcli>
  c = mycpu();
80103e4e:	e8 5d fb ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103e53:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103e59:	e8 82 07 00 00       	call   801045e0 <popcli>
  if(curproc == initproc)
80103e5e:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80103e64:	8d 5e 28             	lea    0x28(%esi),%ebx
80103e67:	8d 7e 68             	lea    0x68(%esi),%edi
80103e6a:	0f 84 e7 00 00 00    	je     80103f57 <exit+0x117>
    if(curproc->ofile[fd]){
80103e70:	8b 03                	mov    (%ebx),%eax
80103e72:	85 c0                	test   %eax,%eax
80103e74:	74 12                	je     80103e88 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103e76:	83 ec 0c             	sub    $0xc,%esp
80103e79:	50                   	push   %eax
80103e7a:	e8 c1 d0 ff ff       	call   80100f40 <fileclose>
      curproc->ofile[fd] = 0;
80103e7f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103e85:	83 c4 10             	add    $0x10,%esp
80103e88:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103e8b:	39 fb                	cmp    %edi,%ebx
80103e8d:	75 e1                	jne    80103e70 <exit+0x30>
  begin_op();
80103e8f:	e8 7c ef ff ff       	call   80102e10 <begin_op>
  iput(curproc->cwd);
80103e94:	83 ec 0c             	sub    $0xc,%esp
80103e97:	ff 76 68             	pushl  0x68(%esi)
80103e9a:	e8 91 db ff ff       	call   80101a30 <iput>
  end_op();
80103e9f:	e8 dc ef ff ff       	call   80102e80 <end_op>
  curproc->cwd = 0;
80103ea4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103eab:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103eb2:	e8 69 06 00 00       	call   80104520 <acquire>
  wakeup1(curproc->parent);
80103eb7:	8b 56 14             	mov    0x14(%esi),%edx
80103eba:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ebd:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103ec2:	eb 0e                	jmp    80103ed2 <exit+0x92>
80103ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ec8:	83 c0 7c             	add    $0x7c,%eax
80103ecb:	3d 54 5c 11 80       	cmp    $0x80115c54,%eax
80103ed0:	73 1c                	jae    80103eee <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103ed2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ed6:	75 f0                	jne    80103ec8 <exit+0x88>
80103ed8:	3b 50 20             	cmp    0x20(%eax),%edx
80103edb:	75 eb                	jne    80103ec8 <exit+0x88>
      p->state = RUNNABLE;
80103edd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ee4:	83 c0 7c             	add    $0x7c,%eax
80103ee7:	3d 54 5c 11 80       	cmp    $0x80115c54,%eax
80103eec:	72 e4                	jb     80103ed2 <exit+0x92>
      p->parent = initproc;
80103eee:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ef4:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80103ef9:	eb 10                	jmp    80103f0b <exit+0xcb>
80103efb:	90                   	nop
80103efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f00:	83 c2 7c             	add    $0x7c,%edx
80103f03:	81 fa 54 5c 11 80    	cmp    $0x80115c54,%edx
80103f09:	73 33                	jae    80103f3e <exit+0xfe>
    if(p->parent == curproc){
80103f0b:	39 72 14             	cmp    %esi,0x14(%edx)
80103f0e:	75 f0                	jne    80103f00 <exit+0xc0>
      if(p->state == ZOMBIE)
80103f10:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103f14:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103f17:	75 e7                	jne    80103f00 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f19:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103f1e:	eb 0a                	jmp    80103f2a <exit+0xea>
80103f20:	83 c0 7c             	add    $0x7c,%eax
80103f23:	3d 54 5c 11 80       	cmp    $0x80115c54,%eax
80103f28:	73 d6                	jae    80103f00 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103f2a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f2e:	75 f0                	jne    80103f20 <exit+0xe0>
80103f30:	3b 48 20             	cmp    0x20(%eax),%ecx
80103f33:	75 eb                	jne    80103f20 <exit+0xe0>
      p->state = RUNNABLE;
80103f35:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f3c:	eb e2                	jmp    80103f20 <exit+0xe0>
  curproc->state = ZOMBIE;
80103f3e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103f45:	e8 36 fe ff ff       	call   80103d80 <sched>
  panic("zombie exit");
80103f4a:	83 ec 0c             	sub    $0xc,%esp
80103f4d:	68 bd 7b 10 80       	push   $0x80107bbd
80103f52:	e8 39 c5 ff ff       	call   80100490 <panic>
    panic("init exiting");
80103f57:	83 ec 0c             	sub    $0xc,%esp
80103f5a:	68 b0 7b 10 80       	push   $0x80107bb0
80103f5f:	e8 2c c5 ff ff       	call   80100490 <panic>
80103f64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103f6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103f70 <yield>:
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	53                   	push   %ebx
80103f74:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103f77:	68 20 3d 11 80       	push   $0x80113d20
80103f7c:	e8 9f 05 00 00       	call   80104520 <acquire>
  pushcli();
80103f81:	e8 5a 05 00 00       	call   801044e0 <pushcli>
  c = mycpu();
80103f86:	e8 25 fa ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103f8b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f91:	e8 4a 06 00 00       	call   801045e0 <popcli>
  myproc()->state = RUNNABLE;
80103f96:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103f9d:	e8 de fd ff ff       	call   80103d80 <sched>
  release(&ptable.lock);
80103fa2:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103fa9:	e8 92 06 00 00       	call   80104640 <release>
}
80103fae:	83 c4 10             	add    $0x10,%esp
80103fb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fb4:	c9                   	leave  
80103fb5:	c3                   	ret    
80103fb6:	8d 76 00             	lea    0x0(%esi),%esi
80103fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fc0 <sleep>:
{
80103fc0:	55                   	push   %ebp
80103fc1:	89 e5                	mov    %esp,%ebp
80103fc3:	57                   	push   %edi
80103fc4:	56                   	push   %esi
80103fc5:	53                   	push   %ebx
80103fc6:	83 ec 0c             	sub    $0xc,%esp
80103fc9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103fcc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103fcf:	e8 0c 05 00 00       	call   801044e0 <pushcli>
  c = mycpu();
80103fd4:	e8 d7 f9 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103fd9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fdf:	e8 fc 05 00 00       	call   801045e0 <popcli>
  if(p == 0)
80103fe4:	85 db                	test   %ebx,%ebx
80103fe6:	0f 84 87 00 00 00    	je     80104073 <sleep+0xb3>
  if(lk == 0)
80103fec:	85 f6                	test   %esi,%esi
80103fee:	74 76                	je     80104066 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103ff0:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
80103ff6:	74 50                	je     80104048 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103ff8:	83 ec 0c             	sub    $0xc,%esp
80103ffb:	68 20 3d 11 80       	push   $0x80113d20
80104000:	e8 1b 05 00 00       	call   80104520 <acquire>
    release(lk);
80104005:	89 34 24             	mov    %esi,(%esp)
80104008:	e8 33 06 00 00       	call   80104640 <release>
  p->chan = chan;
8010400d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104010:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104017:	e8 64 fd ff ff       	call   80103d80 <sched>
  p->chan = 0;
8010401c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104023:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010402a:	e8 11 06 00 00       	call   80104640 <release>
    acquire(lk);
8010402f:	89 75 08             	mov    %esi,0x8(%ebp)
80104032:	83 c4 10             	add    $0x10,%esp
}
80104035:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104038:	5b                   	pop    %ebx
80104039:	5e                   	pop    %esi
8010403a:	5f                   	pop    %edi
8010403b:	5d                   	pop    %ebp
    acquire(lk);
8010403c:	e9 df 04 00 00       	jmp    80104520 <acquire>
80104041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104048:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010404b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104052:	e8 29 fd ff ff       	call   80103d80 <sched>
  p->chan = 0;
80104057:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010405e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104061:	5b                   	pop    %ebx
80104062:	5e                   	pop    %esi
80104063:	5f                   	pop    %edi
80104064:	5d                   	pop    %ebp
80104065:	c3                   	ret    
    panic("sleep without lk");
80104066:	83 ec 0c             	sub    $0xc,%esp
80104069:	68 cf 7b 10 80       	push   $0x80107bcf
8010406e:	e8 1d c4 ff ff       	call   80100490 <panic>
    panic("sleep");
80104073:	83 ec 0c             	sub    $0xc,%esp
80104076:	68 c9 7b 10 80       	push   $0x80107bc9
8010407b:	e8 10 c4 ff ff       	call   80100490 <panic>

80104080 <wait>:
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	57                   	push   %edi
80104084:	56                   	push   %esi
80104085:	53                   	push   %ebx
80104086:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104089:	e8 52 04 00 00       	call   801044e0 <pushcli>
  c = mycpu();
8010408e:	e8 1d f9 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80104093:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104099:	e8 42 05 00 00       	call   801045e0 <popcli>
  acquire(&ptable.lock);
8010409e:	83 ec 0c             	sub    $0xc,%esp
801040a1:	68 20 3d 11 80       	push   $0x80113d20
801040a6:	e8 75 04 00 00       	call   80104520 <acquire>
801040ab:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801040ae:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040b0:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
801040b5:	eb 14                	jmp    801040cb <wait+0x4b>
801040b7:	89 f6                	mov    %esi,%esi
801040b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801040c0:	83 c3 7c             	add    $0x7c,%ebx
801040c3:	81 fb 54 5c 11 80    	cmp    $0x80115c54,%ebx
801040c9:	73 1b                	jae    801040e6 <wait+0x66>
      if(p->parent != curproc)
801040cb:	39 73 14             	cmp    %esi,0x14(%ebx)
801040ce:	75 f0                	jne    801040c0 <wait+0x40>
      if(p->state == ZOMBIE){
801040d0:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801040d4:	74 32                	je     80104108 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040d6:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801040d9:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040de:	81 fb 54 5c 11 80    	cmp    $0x80115c54,%ebx
801040e4:	72 e5                	jb     801040cb <wait+0x4b>
    if(!havekids || curproc->killed){
801040e6:	85 c0                	test   %eax,%eax
801040e8:	74 7e                	je     80104168 <wait+0xe8>
801040ea:	8b 46 24             	mov    0x24(%esi),%eax
801040ed:	85 c0                	test   %eax,%eax
801040ef:	75 77                	jne    80104168 <wait+0xe8>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801040f1:	83 ec 08             	sub    $0x8,%esp
801040f4:	68 20 3d 11 80       	push   $0x80113d20
801040f9:	56                   	push   %esi
801040fa:	e8 c1 fe ff ff       	call   80103fc0 <sleep>
    havekids = 0;
801040ff:	83 c4 10             	add    $0x10,%esp
80104102:	eb aa                	jmp    801040ae <wait+0x2e>
80104104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104108:	83 ec 0c             	sub    $0xc,%esp
8010410b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010410e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104111:	e8 6a e4 ff ff       	call   80102580 <kfree>
        pgdir = p->pgdir;
80104116:	8b 7b 04             	mov    0x4(%ebx),%edi
        release(&ptable.lock);
80104119:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
        p->kstack = 0;
80104120:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        p->pgdir = 0;
80104127:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
        p->pid = 0;
8010412e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104135:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010413c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104140:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104147:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010414e:	e8 ed 04 00 00       	call   80104640 <release>
        freevm(pgdir);
80104153:	89 3c 24             	mov    %edi,(%esp)
80104156:	e8 f5 2f 00 00       	call   80107150 <freevm>
        return pid;
8010415b:	83 c4 10             	add    $0x10,%esp
}
8010415e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104161:	89 f0                	mov    %esi,%eax
80104163:	5b                   	pop    %ebx
80104164:	5e                   	pop    %esi
80104165:	5f                   	pop    %edi
80104166:	5d                   	pop    %ebp
80104167:	c3                   	ret    
      release(&ptable.lock);
80104168:	83 ec 0c             	sub    $0xc,%esp
      return -1;
8010416b:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104170:	68 20 3d 11 80       	push   $0x80113d20
80104175:	e8 c6 04 00 00       	call   80104640 <release>
      return -1;
8010417a:	83 c4 10             	add    $0x10,%esp
8010417d:	eb df                	jmp    8010415e <wait+0xde>
8010417f:	90                   	nop

80104180 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	53                   	push   %ebx
80104184:	83 ec 10             	sub    $0x10,%esp
80104187:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010418a:	68 20 3d 11 80       	push   $0x80113d20
8010418f:	e8 8c 03 00 00       	call   80104520 <acquire>
80104194:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104197:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010419c:	eb 0c                	jmp    801041aa <wakeup+0x2a>
8010419e:	66 90                	xchg   %ax,%ax
801041a0:	83 c0 7c             	add    $0x7c,%eax
801041a3:	3d 54 5c 11 80       	cmp    $0x80115c54,%eax
801041a8:	73 1c                	jae    801041c6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801041aa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041ae:	75 f0                	jne    801041a0 <wakeup+0x20>
801041b0:	3b 58 20             	cmp    0x20(%eax),%ebx
801041b3:	75 eb                	jne    801041a0 <wakeup+0x20>
      p->state = RUNNABLE;
801041b5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041bc:	83 c0 7c             	add    $0x7c,%eax
801041bf:	3d 54 5c 11 80       	cmp    $0x80115c54,%eax
801041c4:	72 e4                	jb     801041aa <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801041c6:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
801041cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041d0:	c9                   	leave  
  release(&ptable.lock);
801041d1:	e9 6a 04 00 00       	jmp    80104640 <release>
801041d6:	8d 76 00             	lea    0x0(%esi),%esi
801041d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041e0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	53                   	push   %ebx
801041e4:	83 ec 10             	sub    $0x10,%esp
801041e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801041ea:	68 20 3d 11 80       	push   $0x80113d20
801041ef:	e8 2c 03 00 00       	call   80104520 <acquire>
801041f4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041f7:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801041fc:	eb 0c                	jmp    8010420a <kill+0x2a>
801041fe:	66 90                	xchg   %ax,%ax
80104200:	83 c0 7c             	add    $0x7c,%eax
80104203:	3d 54 5c 11 80       	cmp    $0x80115c54,%eax
80104208:	73 36                	jae    80104240 <kill+0x60>
    if(p->pid == pid){
8010420a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010420d:	75 f1                	jne    80104200 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010420f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104213:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010421a:	75 07                	jne    80104223 <kill+0x43>
        p->state = RUNNABLE;
8010421c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104223:	83 ec 0c             	sub    $0xc,%esp
80104226:	68 20 3d 11 80       	push   $0x80113d20
8010422b:	e8 10 04 00 00       	call   80104640 <release>
      return 0;
80104230:	83 c4 10             	add    $0x10,%esp
80104233:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104235:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104238:	c9                   	leave  
80104239:	c3                   	ret    
8010423a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104240:	83 ec 0c             	sub    $0xc,%esp
80104243:	68 20 3d 11 80       	push   $0x80113d20
80104248:	e8 f3 03 00 00       	call   80104640 <release>
  return -1;
8010424d:	83 c4 10             	add    $0x10,%esp
80104250:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104255:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104258:	c9                   	leave  
80104259:	c3                   	ret    
8010425a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104260 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	57                   	push   %edi
80104264:	56                   	push   %esi
80104265:	53                   	push   %ebx
80104266:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104269:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
8010426e:	83 ec 3c             	sub    $0x3c,%esp
80104271:	eb 24                	jmp    80104297 <procdump+0x37>
80104273:	90                   	nop
80104274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104278:	83 ec 0c             	sub    $0xc,%esp
8010427b:	68 ea 76 10 80       	push   $0x801076ea
80104280:	e8 db c4 ff ff       	call   80100760 <cprintf>
80104285:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104288:	83 c3 7c             	add    $0x7c,%ebx
8010428b:	81 fb 54 5c 11 80    	cmp    $0x80115c54,%ebx
80104291:	0f 83 81 00 00 00    	jae    80104318 <procdump+0xb8>
    if(p->state == UNUSED)
80104297:	8b 43 0c             	mov    0xc(%ebx),%eax
8010429a:	85 c0                	test   %eax,%eax
8010429c:	74 ea                	je     80104288 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010429e:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801042a1:	ba e0 7b 10 80       	mov    $0x80107be0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801042a6:	77 11                	ja     801042b9 <procdump+0x59>
801042a8:	8b 14 85 40 7c 10 80 	mov    -0x7fef83c0(,%eax,4),%edx
      state = "???";
801042af:	b8 e0 7b 10 80       	mov    $0x80107be0,%eax
801042b4:	85 d2                	test   %edx,%edx
801042b6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801042b9:	8d 43 6c             	lea    0x6c(%ebx),%eax
801042bc:	50                   	push   %eax
801042bd:	52                   	push   %edx
801042be:	ff 73 10             	pushl  0x10(%ebx)
801042c1:	68 e4 7b 10 80       	push   $0x80107be4
801042c6:	e8 95 c4 ff ff       	call   80100760 <cprintf>
    if(p->state == SLEEPING){
801042cb:	83 c4 10             	add    $0x10,%esp
801042ce:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801042d2:	75 a4                	jne    80104278 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801042d4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801042d7:	83 ec 08             	sub    $0x8,%esp
801042da:	8d 7d c0             	lea    -0x40(%ebp),%edi
801042dd:	50                   	push   %eax
801042de:	8b 43 1c             	mov    0x1c(%ebx),%eax
801042e1:	8b 40 0c             	mov    0xc(%eax),%eax
801042e4:	83 c0 08             	add    $0x8,%eax
801042e7:	50                   	push   %eax
801042e8:	e8 63 01 00 00       	call   80104450 <getcallerpcs>
801042ed:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801042f0:	8b 17                	mov    (%edi),%edx
801042f2:	85 d2                	test   %edx,%edx
801042f4:	74 82                	je     80104278 <procdump+0x18>
        cprintf(" %p", pc[i]);
801042f6:	83 ec 08             	sub    $0x8,%esp
801042f9:	83 c7 04             	add    $0x4,%edi
801042fc:	52                   	push   %edx
801042fd:	68 07 76 10 80       	push   $0x80107607
80104302:	e8 59 c4 ff ff       	call   80100760 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104307:	83 c4 10             	add    $0x10,%esp
8010430a:	39 fe                	cmp    %edi,%esi
8010430c:	75 e2                	jne    801042f0 <procdump+0x90>
8010430e:	e9 65 ff ff ff       	jmp    80104278 <procdump+0x18>
80104313:	90                   	nop
80104314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
80104318:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010431b:	5b                   	pop    %ebx
8010431c:	5e                   	pop    %esi
8010431d:	5f                   	pop    %edi
8010431e:	5d                   	pop    %ebp
8010431f:	c3                   	ret    

80104320 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	53                   	push   %ebx
80104324:	83 ec 0c             	sub    $0xc,%esp
80104327:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010432a:	68 58 7c 10 80       	push   $0x80107c58
8010432f:	8d 43 04             	lea    0x4(%ebx),%eax
80104332:	50                   	push   %eax
80104333:	e8 f8 00 00 00       	call   80104430 <initlock>
  lk->name = name;
80104338:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010433b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104341:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104344:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010434b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010434e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104351:	c9                   	leave  
80104352:	c3                   	ret    
80104353:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104360 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	56                   	push   %esi
80104364:	53                   	push   %ebx
80104365:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104368:	83 ec 0c             	sub    $0xc,%esp
8010436b:	8d 73 04             	lea    0x4(%ebx),%esi
8010436e:	56                   	push   %esi
8010436f:	e8 ac 01 00 00       	call   80104520 <acquire>
  while (lk->locked) {
80104374:	8b 13                	mov    (%ebx),%edx
80104376:	83 c4 10             	add    $0x10,%esp
80104379:	85 d2                	test   %edx,%edx
8010437b:	74 16                	je     80104393 <acquiresleep+0x33>
8010437d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104380:	83 ec 08             	sub    $0x8,%esp
80104383:	56                   	push   %esi
80104384:	53                   	push   %ebx
80104385:	e8 36 fc ff ff       	call   80103fc0 <sleep>
  while (lk->locked) {
8010438a:	8b 03                	mov    (%ebx),%eax
8010438c:	83 c4 10             	add    $0x10,%esp
8010438f:	85 c0                	test   %eax,%eax
80104391:	75 ed                	jne    80104380 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104393:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104399:	e8 b2 f6 ff ff       	call   80103a50 <myproc>
8010439e:	8b 40 10             	mov    0x10(%eax),%eax
801043a1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801043a4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801043a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043aa:	5b                   	pop    %ebx
801043ab:	5e                   	pop    %esi
801043ac:	5d                   	pop    %ebp
  release(&lk->lk);
801043ad:	e9 8e 02 00 00       	jmp    80104640 <release>
801043b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043c0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	56                   	push   %esi
801043c4:	53                   	push   %ebx
801043c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801043c8:	83 ec 0c             	sub    $0xc,%esp
801043cb:	8d 73 04             	lea    0x4(%ebx),%esi
801043ce:	56                   	push   %esi
801043cf:	e8 4c 01 00 00       	call   80104520 <acquire>
  lk->locked = 0;
801043d4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801043da:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801043e1:	89 1c 24             	mov    %ebx,(%esp)
801043e4:	e8 97 fd ff ff       	call   80104180 <wakeup>
  release(&lk->lk);
801043e9:	89 75 08             	mov    %esi,0x8(%ebp)
801043ec:	83 c4 10             	add    $0x10,%esp
}
801043ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043f2:	5b                   	pop    %ebx
801043f3:	5e                   	pop    %esi
801043f4:	5d                   	pop    %ebp
  release(&lk->lk);
801043f5:	e9 46 02 00 00       	jmp    80104640 <release>
801043fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104400 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	56                   	push   %esi
80104404:	53                   	push   %ebx
80104405:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104408:	83 ec 0c             	sub    $0xc,%esp
8010440b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010440e:	53                   	push   %ebx
8010440f:	e8 0c 01 00 00       	call   80104520 <acquire>
  r = lk->locked;
80104414:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104416:	89 1c 24             	mov    %ebx,(%esp)
80104419:	e8 22 02 00 00       	call   80104640 <release>
  return r;
}
8010441e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104421:	89 f0                	mov    %esi,%eax
80104423:	5b                   	pop    %ebx
80104424:	5e                   	pop    %esi
80104425:	5d                   	pop    %ebp
80104426:	c3                   	ret    
80104427:	66 90                	xchg   %ax,%ax
80104429:	66 90                	xchg   %ax,%ax
8010442b:	66 90                	xchg   %ax,%ax
8010442d:	66 90                	xchg   %ax,%ax
8010442f:	90                   	nop

80104430 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104436:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104439:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010443f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104442:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104449:	5d                   	pop    %ebp
8010444a:	c3                   	ret    
8010444b:	90                   	nop
8010444c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104450 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104450:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104451:	31 d2                	xor    %edx,%edx
{
80104453:	89 e5                	mov    %esp,%ebp
80104455:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104456:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104459:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010445c:	83 e8 08             	sub    $0x8,%eax
8010445f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104460:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104466:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010446c:	77 1a                	ja     80104488 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010446e:	8b 58 04             	mov    0x4(%eax),%ebx
80104471:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104474:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104477:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104479:	83 fa 0a             	cmp    $0xa,%edx
8010447c:	75 e2                	jne    80104460 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010447e:	5b                   	pop    %ebx
8010447f:	5d                   	pop    %ebp
80104480:	c3                   	ret    
80104481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104488:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010448b:	83 c1 28             	add    $0x28,%ecx
8010448e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104490:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104496:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104499:	39 c1                	cmp    %eax,%ecx
8010449b:	75 f3                	jne    80104490 <getcallerpcs+0x40>
}
8010449d:	5b                   	pop    %ebx
8010449e:	5d                   	pop    %ebp
8010449f:	c3                   	ret    

801044a0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	53                   	push   %ebx
801044a4:	83 ec 04             	sub    $0x4,%esp
801044a7:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801044aa:	8b 02                	mov    (%edx),%eax
801044ac:	85 c0                	test   %eax,%eax
801044ae:	75 10                	jne    801044c0 <holding+0x20>
}
801044b0:	83 c4 04             	add    $0x4,%esp
801044b3:	31 c0                	xor    %eax,%eax
801044b5:	5b                   	pop    %ebx
801044b6:	5d                   	pop    %ebp
801044b7:	c3                   	ret    
801044b8:	90                   	nop
801044b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
801044c0:	8b 5a 08             	mov    0x8(%edx),%ebx
801044c3:	e8 e8 f4 ff ff       	call   801039b0 <mycpu>
801044c8:	39 c3                	cmp    %eax,%ebx
801044ca:	0f 94 c0             	sete   %al
}
801044cd:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
801044d0:	0f b6 c0             	movzbl %al,%eax
}
801044d3:	5b                   	pop    %ebx
801044d4:	5d                   	pop    %ebp
801044d5:	c3                   	ret    
801044d6:	8d 76 00             	lea    0x0(%esi),%esi
801044d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044e0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	53                   	push   %ebx
801044e4:	83 ec 04             	sub    $0x4,%esp
801044e7:	9c                   	pushf  
801044e8:	5b                   	pop    %ebx
  asm volatile("cli");
801044e9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801044ea:	e8 c1 f4 ff ff       	call   801039b0 <mycpu>
801044ef:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801044f5:	85 c0                	test   %eax,%eax
801044f7:	75 11                	jne    8010450a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801044f9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801044ff:	e8 ac f4 ff ff       	call   801039b0 <mycpu>
80104504:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010450a:	e8 a1 f4 ff ff       	call   801039b0 <mycpu>
8010450f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104516:	83 c4 04             	add    $0x4,%esp
80104519:	5b                   	pop    %ebx
8010451a:	5d                   	pop    %ebp
8010451b:	c3                   	ret    
8010451c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104520 <acquire>:
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	56                   	push   %esi
80104524:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104525:	e8 b6 ff ff ff       	call   801044e0 <pushcli>
  if(holding(lk))
8010452a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
8010452d:	8b 03                	mov    (%ebx),%eax
8010452f:	85 c0                	test   %eax,%eax
80104531:	0f 85 81 00 00 00    	jne    801045b8 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
80104537:	ba 01 00 00 00       	mov    $0x1,%edx
8010453c:	eb 05                	jmp    80104543 <acquire+0x23>
8010453e:	66 90                	xchg   %ax,%ax
80104540:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104543:	89 d0                	mov    %edx,%eax
80104545:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104548:	85 c0                	test   %eax,%eax
8010454a:	75 f4                	jne    80104540 <acquire+0x20>
  __sync_synchronize();
8010454c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104551:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104554:	e8 57 f4 ff ff       	call   801039b0 <mycpu>
  for(i = 0; i < 10; i++){
80104559:	31 d2                	xor    %edx,%edx
  getcallerpcs(&lk, lk->pcs);
8010455b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  lk->cpu = mycpu();
8010455e:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104561:	89 e8                	mov    %ebp,%eax
80104563:	90                   	nop
80104564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104568:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010456e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104574:	77 1a                	ja     80104590 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
80104576:	8b 58 04             	mov    0x4(%eax),%ebx
80104579:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010457c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010457f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104581:	83 fa 0a             	cmp    $0xa,%edx
80104584:	75 e2                	jne    80104568 <acquire+0x48>
}
80104586:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104589:	5b                   	pop    %ebx
8010458a:	5e                   	pop    %esi
8010458b:	5d                   	pop    %ebp
8010458c:	c3                   	ret    
8010458d:	8d 76 00             	lea    0x0(%esi),%esi
80104590:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104593:	83 c1 28             	add    $0x28,%ecx
80104596:	8d 76 00             	lea    0x0(%esi),%esi
80104599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801045a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801045a6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801045a9:	39 c8                	cmp    %ecx,%eax
801045ab:	75 f3                	jne    801045a0 <acquire+0x80>
}
801045ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045b0:	5b                   	pop    %ebx
801045b1:	5e                   	pop    %esi
801045b2:	5d                   	pop    %ebp
801045b3:	c3                   	ret    
801045b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
801045b8:	8b 73 08             	mov    0x8(%ebx),%esi
801045bb:	e8 f0 f3 ff ff       	call   801039b0 <mycpu>
801045c0:	39 c6                	cmp    %eax,%esi
801045c2:	0f 85 6f ff ff ff    	jne    80104537 <acquire+0x17>
    panic("acquire");
801045c8:	83 ec 0c             	sub    $0xc,%esp
801045cb:	68 63 7c 10 80       	push   $0x80107c63
801045d0:	e8 bb be ff ff       	call   80100490 <panic>
801045d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045e0 <popcli>:

void
popcli(void)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045e6:	9c                   	pushf  
801045e7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801045e8:	f6 c4 02             	test   $0x2,%ah
801045eb:	75 35                	jne    80104622 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801045ed:	e8 be f3 ff ff       	call   801039b0 <mycpu>
801045f2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801045f9:	78 34                	js     8010462f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045fb:	e8 b0 f3 ff ff       	call   801039b0 <mycpu>
80104600:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104606:	85 d2                	test   %edx,%edx
80104608:	74 06                	je     80104610 <popcli+0x30>
    sti();
}
8010460a:	c9                   	leave  
8010460b:	c3                   	ret    
8010460c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104610:	e8 9b f3 ff ff       	call   801039b0 <mycpu>
80104615:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010461b:	85 c0                	test   %eax,%eax
8010461d:	74 eb                	je     8010460a <popcli+0x2a>
  asm volatile("sti");
8010461f:	fb                   	sti    
}
80104620:	c9                   	leave  
80104621:	c3                   	ret    
    panic("popcli - interruptible");
80104622:	83 ec 0c             	sub    $0xc,%esp
80104625:	68 6b 7c 10 80       	push   $0x80107c6b
8010462a:	e8 61 be ff ff       	call   80100490 <panic>
    panic("popcli");
8010462f:	83 ec 0c             	sub    $0xc,%esp
80104632:	68 82 7c 10 80       	push   $0x80107c82
80104637:	e8 54 be ff ff       	call   80100490 <panic>
8010463c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104640 <release>:
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	56                   	push   %esi
80104644:	53                   	push   %ebx
80104645:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104648:	8b 03                	mov    (%ebx),%eax
8010464a:	85 c0                	test   %eax,%eax
8010464c:	74 0c                	je     8010465a <release+0x1a>
8010464e:	8b 73 08             	mov    0x8(%ebx),%esi
80104651:	e8 5a f3 ff ff       	call   801039b0 <mycpu>
80104656:	39 c6                	cmp    %eax,%esi
80104658:	74 16                	je     80104670 <release+0x30>
    panic("release");
8010465a:	83 ec 0c             	sub    $0xc,%esp
8010465d:	68 89 7c 10 80       	push   $0x80107c89
80104662:	e8 29 be ff ff       	call   80100490 <panic>
80104667:	89 f6                	mov    %esi,%esi
80104669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lk->pcs[0] = 0;
80104670:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104677:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
8010467e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104683:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104689:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010468c:	5b                   	pop    %ebx
8010468d:	5e                   	pop    %esi
8010468e:	5d                   	pop    %ebp
  popcli();
8010468f:	e9 4c ff ff ff       	jmp    801045e0 <popcli>
80104694:	66 90                	xchg   %ax,%ax
80104696:	66 90                	xchg   %ax,%ax
80104698:	66 90                	xchg   %ax,%ax
8010469a:	66 90                	xchg   %ax,%ax
8010469c:	66 90                	xchg   %ax,%ax
8010469e:	66 90                	xchg   %ax,%ax

801046a0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	57                   	push   %edi
801046a4:	53                   	push   %ebx
801046a5:	8b 55 08             	mov    0x8(%ebp),%edx
801046a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801046ab:	f6 c2 03             	test   $0x3,%dl
801046ae:	75 05                	jne    801046b5 <memset+0x15>
801046b0:	f6 c1 03             	test   $0x3,%cl
801046b3:	74 13                	je     801046c8 <memset+0x28>
  asm volatile("cld; rep stosb" :
801046b5:	89 d7                	mov    %edx,%edi
801046b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801046ba:	fc                   	cld    
801046bb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801046bd:	5b                   	pop    %ebx
801046be:	89 d0                	mov    %edx,%eax
801046c0:	5f                   	pop    %edi
801046c1:	5d                   	pop    %ebp
801046c2:	c3                   	ret    
801046c3:	90                   	nop
801046c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
801046c8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801046cc:	c1 e9 02             	shr    $0x2,%ecx
801046cf:	89 f8                	mov    %edi,%eax
801046d1:	89 fb                	mov    %edi,%ebx
801046d3:	c1 e0 18             	shl    $0x18,%eax
801046d6:	c1 e3 10             	shl    $0x10,%ebx
801046d9:	09 d8                	or     %ebx,%eax
801046db:	09 f8                	or     %edi,%eax
801046dd:	c1 e7 08             	shl    $0x8,%edi
801046e0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801046e2:	89 d7                	mov    %edx,%edi
801046e4:	fc                   	cld    
801046e5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801046e7:	5b                   	pop    %ebx
801046e8:	89 d0                	mov    %edx,%eax
801046ea:	5f                   	pop    %edi
801046eb:	5d                   	pop    %ebp
801046ec:	c3                   	ret    
801046ed:	8d 76 00             	lea    0x0(%esi),%esi

801046f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	57                   	push   %edi
801046f4:	56                   	push   %esi
801046f5:	53                   	push   %ebx
801046f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801046f9:	8b 75 08             	mov    0x8(%ebp),%esi
801046fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801046ff:	85 db                	test   %ebx,%ebx
80104701:	74 29                	je     8010472c <memcmp+0x3c>
    if(*s1 != *s2)
80104703:	0f b6 16             	movzbl (%esi),%edx
80104706:	0f b6 0f             	movzbl (%edi),%ecx
80104709:	38 d1                	cmp    %dl,%cl
8010470b:	75 2b                	jne    80104738 <memcmp+0x48>
8010470d:	b8 01 00 00 00       	mov    $0x1,%eax
80104712:	eb 14                	jmp    80104728 <memcmp+0x38>
80104714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104718:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010471c:	83 c0 01             	add    $0x1,%eax
8010471f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104724:	38 ca                	cmp    %cl,%dl
80104726:	75 10                	jne    80104738 <memcmp+0x48>
  while(n-- > 0){
80104728:	39 d8                	cmp    %ebx,%eax
8010472a:	75 ec                	jne    80104718 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010472c:	5b                   	pop    %ebx
  return 0;
8010472d:	31 c0                	xor    %eax,%eax
}
8010472f:	5e                   	pop    %esi
80104730:	5f                   	pop    %edi
80104731:	5d                   	pop    %ebp
80104732:	c3                   	ret    
80104733:	90                   	nop
80104734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104738:	0f b6 c2             	movzbl %dl,%eax
}
8010473b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010473c:	29 c8                	sub    %ecx,%eax
}
8010473e:	5e                   	pop    %esi
8010473f:	5f                   	pop    %edi
80104740:	5d                   	pop    %ebp
80104741:	c3                   	ret    
80104742:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104750 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	56                   	push   %esi
80104754:	53                   	push   %ebx
80104755:	8b 45 08             	mov    0x8(%ebp),%eax
80104758:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010475b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010475e:	39 c3                	cmp    %eax,%ebx
80104760:	73 26                	jae    80104788 <memmove+0x38>
80104762:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104765:	39 c8                	cmp    %ecx,%eax
80104767:	73 1f                	jae    80104788 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104769:	85 f6                	test   %esi,%esi
8010476b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010476e:	74 0f                	je     8010477f <memmove+0x2f>
      *--d = *--s;
80104770:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104774:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104777:	83 ea 01             	sub    $0x1,%edx
8010477a:	83 fa ff             	cmp    $0xffffffff,%edx
8010477d:	75 f1                	jne    80104770 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010477f:	5b                   	pop    %ebx
80104780:	5e                   	pop    %esi
80104781:	5d                   	pop    %ebp
80104782:	c3                   	ret    
80104783:	90                   	nop
80104784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104788:	31 d2                	xor    %edx,%edx
8010478a:	85 f6                	test   %esi,%esi
8010478c:	74 f1                	je     8010477f <memmove+0x2f>
8010478e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104790:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104794:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104797:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010479a:	39 d6                	cmp    %edx,%esi
8010479c:	75 f2                	jne    80104790 <memmove+0x40>
}
8010479e:	5b                   	pop    %ebx
8010479f:	5e                   	pop    %esi
801047a0:	5d                   	pop    %ebp
801047a1:	c3                   	ret    
801047a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047b0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801047b3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
801047b4:	eb 9a                	jmp    80104750 <memmove>
801047b6:	8d 76 00             	lea    0x0(%esi),%esi
801047b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047c0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	57                   	push   %edi
801047c4:	56                   	push   %esi
801047c5:	8b 7d 10             	mov    0x10(%ebp),%edi
801047c8:	53                   	push   %ebx
801047c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801047cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
801047cf:	85 ff                	test   %edi,%edi
801047d1:	74 2f                	je     80104802 <strncmp+0x42>
801047d3:	0f b6 01             	movzbl (%ecx),%eax
801047d6:	0f b6 1e             	movzbl (%esi),%ebx
801047d9:	84 c0                	test   %al,%al
801047db:	74 37                	je     80104814 <strncmp+0x54>
801047dd:	38 c3                	cmp    %al,%bl
801047df:	75 33                	jne    80104814 <strncmp+0x54>
801047e1:	01 f7                	add    %esi,%edi
801047e3:	eb 13                	jmp    801047f8 <strncmp+0x38>
801047e5:	8d 76 00             	lea    0x0(%esi),%esi
801047e8:	0f b6 01             	movzbl (%ecx),%eax
801047eb:	84 c0                	test   %al,%al
801047ed:	74 21                	je     80104810 <strncmp+0x50>
801047ef:	0f b6 1a             	movzbl (%edx),%ebx
801047f2:	89 d6                	mov    %edx,%esi
801047f4:	38 d8                	cmp    %bl,%al
801047f6:	75 1c                	jne    80104814 <strncmp+0x54>
    n--, p++, q++;
801047f8:	8d 56 01             	lea    0x1(%esi),%edx
801047fb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801047fe:	39 fa                	cmp    %edi,%edx
80104800:	75 e6                	jne    801047e8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104802:	5b                   	pop    %ebx
    return 0;
80104803:	31 c0                	xor    %eax,%eax
}
80104805:	5e                   	pop    %esi
80104806:	5f                   	pop    %edi
80104807:	5d                   	pop    %ebp
80104808:	c3                   	ret    
80104809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104810:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104814:	29 d8                	sub    %ebx,%eax
}
80104816:	5b                   	pop    %ebx
80104817:	5e                   	pop    %esi
80104818:	5f                   	pop    %edi
80104819:	5d                   	pop    %ebp
8010481a:	c3                   	ret    
8010481b:	90                   	nop
8010481c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104820 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	56                   	push   %esi
80104824:	53                   	push   %ebx
80104825:	8b 45 08             	mov    0x8(%ebp),%eax
80104828:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010482b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010482e:	89 c2                	mov    %eax,%edx
80104830:	eb 19                	jmp    8010484b <strncpy+0x2b>
80104832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104838:	83 c3 01             	add    $0x1,%ebx
8010483b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010483f:	83 c2 01             	add    $0x1,%edx
80104842:	84 c9                	test   %cl,%cl
80104844:	88 4a ff             	mov    %cl,-0x1(%edx)
80104847:	74 09                	je     80104852 <strncpy+0x32>
80104849:	89 f1                	mov    %esi,%ecx
8010484b:	85 c9                	test   %ecx,%ecx
8010484d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104850:	7f e6                	jg     80104838 <strncpy+0x18>
    ;
  while(n-- > 0)
80104852:	31 c9                	xor    %ecx,%ecx
80104854:	85 f6                	test   %esi,%esi
80104856:	7e 17                	jle    8010486f <strncpy+0x4f>
80104858:	90                   	nop
80104859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104860:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104864:	89 f3                	mov    %esi,%ebx
80104866:	83 c1 01             	add    $0x1,%ecx
80104869:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010486b:	85 db                	test   %ebx,%ebx
8010486d:	7f f1                	jg     80104860 <strncpy+0x40>
  return os;
}
8010486f:	5b                   	pop    %ebx
80104870:	5e                   	pop    %esi
80104871:	5d                   	pop    %ebp
80104872:	c3                   	ret    
80104873:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104880 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	56                   	push   %esi
80104884:	53                   	push   %ebx
80104885:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104888:	8b 45 08             	mov    0x8(%ebp),%eax
8010488b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010488e:	85 c9                	test   %ecx,%ecx
80104890:	7e 26                	jle    801048b8 <safestrcpy+0x38>
80104892:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104896:	89 c1                	mov    %eax,%ecx
80104898:	eb 17                	jmp    801048b1 <safestrcpy+0x31>
8010489a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801048a0:	83 c2 01             	add    $0x1,%edx
801048a3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801048a7:	83 c1 01             	add    $0x1,%ecx
801048aa:	84 db                	test   %bl,%bl
801048ac:	88 59 ff             	mov    %bl,-0x1(%ecx)
801048af:	74 04                	je     801048b5 <safestrcpy+0x35>
801048b1:	39 f2                	cmp    %esi,%edx
801048b3:	75 eb                	jne    801048a0 <safestrcpy+0x20>
    ;
  *s = 0;
801048b5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801048b8:	5b                   	pop    %ebx
801048b9:	5e                   	pop    %esi
801048ba:	5d                   	pop    %ebp
801048bb:	c3                   	ret    
801048bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048c0 <strlen>:

int
strlen(const char *s)
{
801048c0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801048c1:	31 c0                	xor    %eax,%eax
{
801048c3:	89 e5                	mov    %esp,%ebp
801048c5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801048c8:	80 3a 00             	cmpb   $0x0,(%edx)
801048cb:	74 0c                	je     801048d9 <strlen+0x19>
801048cd:	8d 76 00             	lea    0x0(%esi),%esi
801048d0:	83 c0 01             	add    $0x1,%eax
801048d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801048d7:	75 f7                	jne    801048d0 <strlen+0x10>
    ;
  return n;
}
801048d9:	5d                   	pop    %ebp
801048da:	c3                   	ret    

801048db <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801048db:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801048df:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801048e3:	55                   	push   %ebp
  pushl %ebx
801048e4:	53                   	push   %ebx
  pushl %esi
801048e5:	56                   	push   %esi
  pushl %edi
801048e6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801048e7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801048e9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801048eb:	5f                   	pop    %edi
  popl %esi
801048ec:	5e                   	pop    %esi
  popl %ebx
801048ed:	5b                   	pop    %ebx
  popl %ebp
801048ee:	5d                   	pop    %ebp
  ret
801048ef:	c3                   	ret    

801048f0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	53                   	push   %ebx
801048f4:	83 ec 04             	sub    $0x4,%esp
801048f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801048fa:	e8 51 f1 ff ff       	call   80103a50 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048ff:	8b 00                	mov    (%eax),%eax
80104901:	39 d8                	cmp    %ebx,%eax
80104903:	76 1b                	jbe    80104920 <fetchint+0x30>
80104905:	8d 53 04             	lea    0x4(%ebx),%edx
80104908:	39 d0                	cmp    %edx,%eax
8010490a:	72 14                	jb     80104920 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010490c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010490f:	8b 13                	mov    (%ebx),%edx
80104911:	89 10                	mov    %edx,(%eax)
  return 0;
80104913:	31 c0                	xor    %eax,%eax
}
80104915:	83 c4 04             	add    $0x4,%esp
80104918:	5b                   	pop    %ebx
80104919:	5d                   	pop    %ebp
8010491a:	c3                   	ret    
8010491b:	90                   	nop
8010491c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104920:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104925:	eb ee                	jmp    80104915 <fetchint+0x25>
80104927:	89 f6                	mov    %esi,%esi
80104929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104930 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	53                   	push   %ebx
80104934:	83 ec 04             	sub    $0x4,%esp
80104937:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010493a:	e8 11 f1 ff ff       	call   80103a50 <myproc>

  if(addr >= curproc->sz)
8010493f:	39 18                	cmp    %ebx,(%eax)
80104941:	76 29                	jbe    8010496c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104943:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104946:	89 da                	mov    %ebx,%edx
80104948:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010494a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010494c:	39 c3                	cmp    %eax,%ebx
8010494e:	73 1c                	jae    8010496c <fetchstr+0x3c>
    if(*s == 0)
80104950:	80 3b 00             	cmpb   $0x0,(%ebx)
80104953:	75 10                	jne    80104965 <fetchstr+0x35>
80104955:	eb 39                	jmp    80104990 <fetchstr+0x60>
80104957:	89 f6                	mov    %esi,%esi
80104959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104960:	80 3a 00             	cmpb   $0x0,(%edx)
80104963:	74 1b                	je     80104980 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104965:	83 c2 01             	add    $0x1,%edx
80104968:	39 d0                	cmp    %edx,%eax
8010496a:	77 f4                	ja     80104960 <fetchstr+0x30>
    return -1;
8010496c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104971:	83 c4 04             	add    $0x4,%esp
80104974:	5b                   	pop    %ebx
80104975:	5d                   	pop    %ebp
80104976:	c3                   	ret    
80104977:	89 f6                	mov    %esi,%esi
80104979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104980:	83 c4 04             	add    $0x4,%esp
80104983:	89 d0                	mov    %edx,%eax
80104985:	29 d8                	sub    %ebx,%eax
80104987:	5b                   	pop    %ebx
80104988:	5d                   	pop    %ebp
80104989:	c3                   	ret    
8010498a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104990:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104992:	eb dd                	jmp    80104971 <fetchstr+0x41>
80104994:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010499a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801049a0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	56                   	push   %esi
801049a4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049a5:	e8 a6 f0 ff ff       	call   80103a50 <myproc>
801049aa:	8b 40 18             	mov    0x18(%eax),%eax
801049ad:	8b 55 08             	mov    0x8(%ebp),%edx
801049b0:	8b 40 44             	mov    0x44(%eax),%eax
801049b3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801049b6:	e8 95 f0 ff ff       	call   80103a50 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049bb:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049bd:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049c0:	39 c6                	cmp    %eax,%esi
801049c2:	73 1c                	jae    801049e0 <argint+0x40>
801049c4:	8d 53 08             	lea    0x8(%ebx),%edx
801049c7:	39 d0                	cmp    %edx,%eax
801049c9:	72 15                	jb     801049e0 <argint+0x40>
  *ip = *(int*)(addr);
801049cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801049ce:	8b 53 04             	mov    0x4(%ebx),%edx
801049d1:	89 10                	mov    %edx,(%eax)
  return 0;
801049d3:	31 c0                	xor    %eax,%eax
}
801049d5:	5b                   	pop    %ebx
801049d6:	5e                   	pop    %esi
801049d7:	5d                   	pop    %ebp
801049d8:	c3                   	ret    
801049d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049e5:	eb ee                	jmp    801049d5 <argint+0x35>
801049e7:	89 f6                	mov    %esi,%esi
801049e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049f0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	56                   	push   %esi
801049f4:	53                   	push   %ebx
801049f5:	83 ec 10             	sub    $0x10,%esp
801049f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801049fb:	e8 50 f0 ff ff       	call   80103a50 <myproc>
80104a00:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104a02:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a05:	83 ec 08             	sub    $0x8,%esp
80104a08:	50                   	push   %eax
80104a09:	ff 75 08             	pushl  0x8(%ebp)
80104a0c:	e8 8f ff ff ff       	call   801049a0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104a11:	83 c4 10             	add    $0x10,%esp
80104a14:	85 c0                	test   %eax,%eax
80104a16:	78 28                	js     80104a40 <argptr+0x50>
80104a18:	85 db                	test   %ebx,%ebx
80104a1a:	78 24                	js     80104a40 <argptr+0x50>
80104a1c:	8b 16                	mov    (%esi),%edx
80104a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a21:	39 c2                	cmp    %eax,%edx
80104a23:	76 1b                	jbe    80104a40 <argptr+0x50>
80104a25:	01 c3                	add    %eax,%ebx
80104a27:	39 da                	cmp    %ebx,%edx
80104a29:	72 15                	jb     80104a40 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104a2b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a2e:	89 02                	mov    %eax,(%edx)
  return 0;
80104a30:	31 c0                	xor    %eax,%eax
}
80104a32:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a35:	5b                   	pop    %ebx
80104a36:	5e                   	pop    %esi
80104a37:	5d                   	pop    %ebp
80104a38:	c3                   	ret    
80104a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a45:	eb eb                	jmp    80104a32 <argptr+0x42>
80104a47:	89 f6                	mov    %esi,%esi
80104a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a50 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104a56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a59:	50                   	push   %eax
80104a5a:	ff 75 08             	pushl  0x8(%ebp)
80104a5d:	e8 3e ff ff ff       	call   801049a0 <argint>
80104a62:	83 c4 10             	add    $0x10,%esp
80104a65:	85 c0                	test   %eax,%eax
80104a67:	78 17                	js     80104a80 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104a69:	83 ec 08             	sub    $0x8,%esp
80104a6c:	ff 75 0c             	pushl  0xc(%ebp)
80104a6f:	ff 75 f4             	pushl  -0xc(%ebp)
80104a72:	e8 b9 fe ff ff       	call   80104930 <fetchstr>
80104a77:	83 c4 10             	add    $0x10,%esp
}
80104a7a:	c9                   	leave  
80104a7b:	c3                   	ret    
80104a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a85:	c9                   	leave  
80104a86:	c3                   	ret    
80104a87:	89 f6                	mov    %esi,%esi
80104a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a90 <syscall>:
[SYS_swap]    sys_swap,
};

void
syscall(void)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	53                   	push   %ebx
80104a94:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104a97:	e8 b4 ef ff ff       	call   80103a50 <myproc>
80104a9c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104a9e:	8b 40 18             	mov    0x18(%eax),%eax
80104aa1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104aa4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104aa7:	83 fa 16             	cmp    $0x16,%edx
80104aaa:	77 1c                	ja     80104ac8 <syscall+0x38>
80104aac:	8b 14 85 c0 7c 10 80 	mov    -0x7fef8340(,%eax,4),%edx
80104ab3:	85 d2                	test   %edx,%edx
80104ab5:	74 11                	je     80104ac8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104ab7:	ff d2                	call   *%edx
80104ab9:	8b 53 18             	mov    0x18(%ebx),%edx
80104abc:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104abf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ac2:	c9                   	leave  
80104ac3:	c3                   	ret    
80104ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104ac8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104ac9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104acc:	50                   	push   %eax
80104acd:	ff 73 10             	pushl  0x10(%ebx)
80104ad0:	68 91 7c 10 80       	push   $0x80107c91
80104ad5:	e8 86 bc ff ff       	call   80100760 <cprintf>
    curproc->tf->eax = -1;
80104ada:	8b 43 18             	mov    0x18(%ebx),%eax
80104add:	83 c4 10             	add    $0x10,%esp
80104ae0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104ae7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104aea:	c9                   	leave  
80104aeb:	c3                   	ret    
80104aec:	66 90                	xchg   %ax,%ax
80104aee:	66 90                	xchg   %ax,%ax

80104af0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	57                   	push   %edi
80104af4:	56                   	push   %esi
80104af5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104af6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104af9:	83 ec 44             	sub    $0x44,%esp
80104afc:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104aff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104b02:	56                   	push   %esi
80104b03:	50                   	push   %eax
{
80104b04:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104b07:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104b0a:	e8 71 d6 ff ff       	call   80102180 <nameiparent>
80104b0f:	83 c4 10             	add    $0x10,%esp
80104b12:	85 c0                	test   %eax,%eax
80104b14:	0f 84 46 01 00 00    	je     80104c60 <create+0x170>
    return 0;
  ilock(dp);
80104b1a:	83 ec 0c             	sub    $0xc,%esp
80104b1d:	89 c3                	mov    %eax,%ebx
80104b1f:	50                   	push   %eax
80104b20:	e8 db cd ff ff       	call   80101900 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104b25:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104b28:	83 c4 0c             	add    $0xc,%esp
80104b2b:	50                   	push   %eax
80104b2c:	56                   	push   %esi
80104b2d:	53                   	push   %ebx
80104b2e:	e8 fd d2 ff ff       	call   80101e30 <dirlookup>
80104b33:	83 c4 10             	add    $0x10,%esp
80104b36:	85 c0                	test   %eax,%eax
80104b38:	89 c7                	mov    %eax,%edi
80104b3a:	74 34                	je     80104b70 <create+0x80>
    iunlockput(dp);
80104b3c:	83 ec 0c             	sub    $0xc,%esp
80104b3f:	53                   	push   %ebx
80104b40:	e8 4b d0 ff ff       	call   80101b90 <iunlockput>
    ilock(ip);
80104b45:	89 3c 24             	mov    %edi,(%esp)
80104b48:	e8 b3 cd ff ff       	call   80101900 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104b4d:	83 c4 10             	add    $0x10,%esp
80104b50:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104b55:	0f 85 95 00 00 00    	jne    80104bf0 <create+0x100>
80104b5b:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104b60:	0f 85 8a 00 00 00    	jne    80104bf0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b69:	89 f8                	mov    %edi,%eax
80104b6b:	5b                   	pop    %ebx
80104b6c:	5e                   	pop    %esi
80104b6d:	5f                   	pop    %edi
80104b6e:	5d                   	pop    %ebp
80104b6f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104b70:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104b74:	83 ec 08             	sub    $0x8,%esp
80104b77:	50                   	push   %eax
80104b78:	ff 33                	pushl  (%ebx)
80104b7a:	e8 11 cc ff ff       	call   80101790 <ialloc>
80104b7f:	83 c4 10             	add    $0x10,%esp
80104b82:	85 c0                	test   %eax,%eax
80104b84:	89 c7                	mov    %eax,%edi
80104b86:	0f 84 e8 00 00 00    	je     80104c74 <create+0x184>
  ilock(ip);
80104b8c:	83 ec 0c             	sub    $0xc,%esp
80104b8f:	50                   	push   %eax
80104b90:	e8 6b cd ff ff       	call   80101900 <ilock>
  ip->major = major;
80104b95:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104b99:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104b9d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104ba1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104ba5:	b8 01 00 00 00       	mov    $0x1,%eax
80104baa:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104bae:	89 3c 24             	mov    %edi,(%esp)
80104bb1:	e8 9a cc ff ff       	call   80101850 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104bb6:	83 c4 10             	add    $0x10,%esp
80104bb9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104bbe:	74 50                	je     80104c10 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104bc0:	83 ec 04             	sub    $0x4,%esp
80104bc3:	ff 77 04             	pushl  0x4(%edi)
80104bc6:	56                   	push   %esi
80104bc7:	53                   	push   %ebx
80104bc8:	e8 d3 d4 ff ff       	call   801020a0 <dirlink>
80104bcd:	83 c4 10             	add    $0x10,%esp
80104bd0:	85 c0                	test   %eax,%eax
80104bd2:	0f 88 8f 00 00 00    	js     80104c67 <create+0x177>
  iunlockput(dp);
80104bd8:	83 ec 0c             	sub    $0xc,%esp
80104bdb:	53                   	push   %ebx
80104bdc:	e8 af cf ff ff       	call   80101b90 <iunlockput>
  return ip;
80104be1:	83 c4 10             	add    $0x10,%esp
}
80104be4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104be7:	89 f8                	mov    %edi,%eax
80104be9:	5b                   	pop    %ebx
80104bea:	5e                   	pop    %esi
80104beb:	5f                   	pop    %edi
80104bec:	5d                   	pop    %ebp
80104bed:	c3                   	ret    
80104bee:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104bf0:	83 ec 0c             	sub    $0xc,%esp
80104bf3:	57                   	push   %edi
    return 0;
80104bf4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104bf6:	e8 95 cf ff ff       	call   80101b90 <iunlockput>
    return 0;
80104bfb:	83 c4 10             	add    $0x10,%esp
}
80104bfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c01:	89 f8                	mov    %edi,%eax
80104c03:	5b                   	pop    %ebx
80104c04:	5e                   	pop    %esi
80104c05:	5f                   	pop    %edi
80104c06:	5d                   	pop    %ebp
80104c07:	c3                   	ret    
80104c08:	90                   	nop
80104c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104c10:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104c15:	83 ec 0c             	sub    $0xc,%esp
80104c18:	53                   	push   %ebx
80104c19:	e8 32 cc ff ff       	call   80101850 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104c1e:	83 c4 0c             	add    $0xc,%esp
80104c21:	ff 77 04             	pushl  0x4(%edi)
80104c24:	68 3c 7d 10 80       	push   $0x80107d3c
80104c29:	57                   	push   %edi
80104c2a:	e8 71 d4 ff ff       	call   801020a0 <dirlink>
80104c2f:	83 c4 10             	add    $0x10,%esp
80104c32:	85 c0                	test   %eax,%eax
80104c34:	78 1c                	js     80104c52 <create+0x162>
80104c36:	83 ec 04             	sub    $0x4,%esp
80104c39:	ff 73 04             	pushl  0x4(%ebx)
80104c3c:	68 3b 7d 10 80       	push   $0x80107d3b
80104c41:	57                   	push   %edi
80104c42:	e8 59 d4 ff ff       	call   801020a0 <dirlink>
80104c47:	83 c4 10             	add    $0x10,%esp
80104c4a:	85 c0                	test   %eax,%eax
80104c4c:	0f 89 6e ff ff ff    	jns    80104bc0 <create+0xd0>
      panic("create dots");
80104c52:	83 ec 0c             	sub    $0xc,%esp
80104c55:	68 2f 7d 10 80       	push   $0x80107d2f
80104c5a:	e8 31 b8 ff ff       	call   80100490 <panic>
80104c5f:	90                   	nop
    return 0;
80104c60:	31 ff                	xor    %edi,%edi
80104c62:	e9 ff fe ff ff       	jmp    80104b66 <create+0x76>
    panic("create: dirlink");
80104c67:	83 ec 0c             	sub    $0xc,%esp
80104c6a:	68 3e 7d 10 80       	push   $0x80107d3e
80104c6f:	e8 1c b8 ff ff       	call   80100490 <panic>
    panic("create: ialloc");
80104c74:	83 ec 0c             	sub    $0xc,%esp
80104c77:	68 20 7d 10 80       	push   $0x80107d20
80104c7c:	e8 0f b8 ff ff       	call   80100490 <panic>
80104c81:	eb 0d                	jmp    80104c90 <argfd.constprop.0>
80104c83:	90                   	nop
80104c84:	90                   	nop
80104c85:	90                   	nop
80104c86:	90                   	nop
80104c87:	90                   	nop
80104c88:	90                   	nop
80104c89:	90                   	nop
80104c8a:	90                   	nop
80104c8b:	90                   	nop
80104c8c:	90                   	nop
80104c8d:	90                   	nop
80104c8e:	90                   	nop
80104c8f:	90                   	nop

80104c90 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	56                   	push   %esi
80104c94:	53                   	push   %ebx
80104c95:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104c97:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104c9a:	89 d6                	mov    %edx,%esi
80104c9c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104c9f:	50                   	push   %eax
80104ca0:	6a 00                	push   $0x0
80104ca2:	e8 f9 fc ff ff       	call   801049a0 <argint>
80104ca7:	83 c4 10             	add    $0x10,%esp
80104caa:	85 c0                	test   %eax,%eax
80104cac:	78 2a                	js     80104cd8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104cae:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104cb2:	77 24                	ja     80104cd8 <argfd.constprop.0+0x48>
80104cb4:	e8 97 ed ff ff       	call   80103a50 <myproc>
80104cb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104cbc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104cc0:	85 c0                	test   %eax,%eax
80104cc2:	74 14                	je     80104cd8 <argfd.constprop.0+0x48>
  if(pfd)
80104cc4:	85 db                	test   %ebx,%ebx
80104cc6:	74 02                	je     80104cca <argfd.constprop.0+0x3a>
    *pfd = fd;
80104cc8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104cca:	89 06                	mov    %eax,(%esi)
  return 0;
80104ccc:	31 c0                	xor    %eax,%eax
}
80104cce:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cd1:	5b                   	pop    %ebx
80104cd2:	5e                   	pop    %esi
80104cd3:	5d                   	pop    %ebp
80104cd4:	c3                   	ret    
80104cd5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104cd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cdd:	eb ef                	jmp    80104cce <argfd.constprop.0+0x3e>
80104cdf:	90                   	nop

80104ce0 <sys_dup>:
{
80104ce0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104ce1:	31 c0                	xor    %eax,%eax
{
80104ce3:	89 e5                	mov    %esp,%ebp
80104ce5:	56                   	push   %esi
80104ce6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104ce7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104cea:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104ced:	e8 9e ff ff ff       	call   80104c90 <argfd.constprop.0>
80104cf2:	85 c0                	test   %eax,%eax
80104cf4:	78 42                	js     80104d38 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104cf6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104cf9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104cfb:	e8 50 ed ff ff       	call   80103a50 <myproc>
80104d00:	eb 0e                	jmp    80104d10 <sys_dup+0x30>
80104d02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104d08:	83 c3 01             	add    $0x1,%ebx
80104d0b:	83 fb 10             	cmp    $0x10,%ebx
80104d0e:	74 28                	je     80104d38 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104d10:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104d14:	85 d2                	test   %edx,%edx
80104d16:	75 f0                	jne    80104d08 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104d18:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104d1c:	83 ec 0c             	sub    $0xc,%esp
80104d1f:	ff 75 f4             	pushl  -0xc(%ebp)
80104d22:	e8 c9 c1 ff ff       	call   80100ef0 <filedup>
  return fd;
80104d27:	83 c4 10             	add    $0x10,%esp
}
80104d2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d2d:	89 d8                	mov    %ebx,%eax
80104d2f:	5b                   	pop    %ebx
80104d30:	5e                   	pop    %esi
80104d31:	5d                   	pop    %ebp
80104d32:	c3                   	ret    
80104d33:	90                   	nop
80104d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d38:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104d3b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104d40:	89 d8                	mov    %ebx,%eax
80104d42:	5b                   	pop    %ebx
80104d43:	5e                   	pop    %esi
80104d44:	5d                   	pop    %ebp
80104d45:	c3                   	ret    
80104d46:	8d 76 00             	lea    0x0(%esi),%esi
80104d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d50 <sys_read>:
{
80104d50:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d51:	31 c0                	xor    %eax,%eax
{
80104d53:	89 e5                	mov    %esp,%ebp
80104d55:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d58:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d5b:	e8 30 ff ff ff       	call   80104c90 <argfd.constprop.0>
80104d60:	85 c0                	test   %eax,%eax
80104d62:	78 4c                	js     80104db0 <sys_read+0x60>
80104d64:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d67:	83 ec 08             	sub    $0x8,%esp
80104d6a:	50                   	push   %eax
80104d6b:	6a 02                	push   $0x2
80104d6d:	e8 2e fc ff ff       	call   801049a0 <argint>
80104d72:	83 c4 10             	add    $0x10,%esp
80104d75:	85 c0                	test   %eax,%eax
80104d77:	78 37                	js     80104db0 <sys_read+0x60>
80104d79:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d7c:	83 ec 04             	sub    $0x4,%esp
80104d7f:	ff 75 f0             	pushl  -0x10(%ebp)
80104d82:	50                   	push   %eax
80104d83:	6a 01                	push   $0x1
80104d85:	e8 66 fc ff ff       	call   801049f0 <argptr>
80104d8a:	83 c4 10             	add    $0x10,%esp
80104d8d:	85 c0                	test   %eax,%eax
80104d8f:	78 1f                	js     80104db0 <sys_read+0x60>
  return fileread(f, p, n);
80104d91:	83 ec 04             	sub    $0x4,%esp
80104d94:	ff 75 f0             	pushl  -0x10(%ebp)
80104d97:	ff 75 f4             	pushl  -0xc(%ebp)
80104d9a:	ff 75 ec             	pushl  -0x14(%ebp)
80104d9d:	e8 be c2 ff ff       	call   80101060 <fileread>
80104da2:	83 c4 10             	add    $0x10,%esp
}
80104da5:	c9                   	leave  
80104da6:	c3                   	ret    
80104da7:	89 f6                	mov    %esi,%esi
80104da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104db0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104db5:	c9                   	leave  
80104db6:	c3                   	ret    
80104db7:	89 f6                	mov    %esi,%esi
80104db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104dc0 <sys_write>:
{
80104dc0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104dc1:	31 c0                	xor    %eax,%eax
{
80104dc3:	89 e5                	mov    %esp,%ebp
80104dc5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104dc8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104dcb:	e8 c0 fe ff ff       	call   80104c90 <argfd.constprop.0>
80104dd0:	85 c0                	test   %eax,%eax
80104dd2:	78 4c                	js     80104e20 <sys_write+0x60>
80104dd4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104dd7:	83 ec 08             	sub    $0x8,%esp
80104dda:	50                   	push   %eax
80104ddb:	6a 02                	push   $0x2
80104ddd:	e8 be fb ff ff       	call   801049a0 <argint>
80104de2:	83 c4 10             	add    $0x10,%esp
80104de5:	85 c0                	test   %eax,%eax
80104de7:	78 37                	js     80104e20 <sys_write+0x60>
80104de9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dec:	83 ec 04             	sub    $0x4,%esp
80104def:	ff 75 f0             	pushl  -0x10(%ebp)
80104df2:	50                   	push   %eax
80104df3:	6a 01                	push   $0x1
80104df5:	e8 f6 fb ff ff       	call   801049f0 <argptr>
80104dfa:	83 c4 10             	add    $0x10,%esp
80104dfd:	85 c0                	test   %eax,%eax
80104dff:	78 1f                	js     80104e20 <sys_write+0x60>
  return filewrite(f, p, n);
80104e01:	83 ec 04             	sub    $0x4,%esp
80104e04:	ff 75 f0             	pushl  -0x10(%ebp)
80104e07:	ff 75 f4             	pushl  -0xc(%ebp)
80104e0a:	ff 75 ec             	pushl  -0x14(%ebp)
80104e0d:	e8 de c2 ff ff       	call   801010f0 <filewrite>
80104e12:	83 c4 10             	add    $0x10,%esp
}
80104e15:	c9                   	leave  
80104e16:	c3                   	ret    
80104e17:	89 f6                	mov    %esi,%esi
80104e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104e20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e25:	c9                   	leave  
80104e26:	c3                   	ret    
80104e27:	89 f6                	mov    %esi,%esi
80104e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e30 <sys_close>:
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104e36:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104e39:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e3c:	e8 4f fe ff ff       	call   80104c90 <argfd.constprop.0>
80104e41:	85 c0                	test   %eax,%eax
80104e43:	78 2b                	js     80104e70 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104e45:	e8 06 ec ff ff       	call   80103a50 <myproc>
80104e4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104e4d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104e50:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104e57:	00 
  fileclose(f);
80104e58:	ff 75 f4             	pushl  -0xc(%ebp)
80104e5b:	e8 e0 c0 ff ff       	call   80100f40 <fileclose>
  return 0;
80104e60:	83 c4 10             	add    $0x10,%esp
80104e63:	31 c0                	xor    %eax,%eax
}
80104e65:	c9                   	leave  
80104e66:	c3                   	ret    
80104e67:	89 f6                	mov    %esi,%esi
80104e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104e70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e75:	c9                   	leave  
80104e76:	c3                   	ret    
80104e77:	89 f6                	mov    %esi,%esi
80104e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e80 <sys_fstat>:
{
80104e80:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e81:	31 c0                	xor    %eax,%eax
{
80104e83:	89 e5                	mov    %esp,%ebp
80104e85:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e88:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104e8b:	e8 00 fe ff ff       	call   80104c90 <argfd.constprop.0>
80104e90:	85 c0                	test   %eax,%eax
80104e92:	78 2c                	js     80104ec0 <sys_fstat+0x40>
80104e94:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e97:	83 ec 04             	sub    $0x4,%esp
80104e9a:	6a 14                	push   $0x14
80104e9c:	50                   	push   %eax
80104e9d:	6a 01                	push   $0x1
80104e9f:	e8 4c fb ff ff       	call   801049f0 <argptr>
80104ea4:	83 c4 10             	add    $0x10,%esp
80104ea7:	85 c0                	test   %eax,%eax
80104ea9:	78 15                	js     80104ec0 <sys_fstat+0x40>
  return filestat(f, st);
80104eab:	83 ec 08             	sub    $0x8,%esp
80104eae:	ff 75 f4             	pushl  -0xc(%ebp)
80104eb1:	ff 75 f0             	pushl  -0x10(%ebp)
80104eb4:	e8 57 c1 ff ff       	call   80101010 <filestat>
80104eb9:	83 c4 10             	add    $0x10,%esp
}
80104ebc:	c9                   	leave  
80104ebd:	c3                   	ret    
80104ebe:	66 90                	xchg   %ax,%ax
    return -1;
80104ec0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ec5:	c9                   	leave  
80104ec6:	c3                   	ret    
80104ec7:	89 f6                	mov    %esi,%esi
80104ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ed0 <sys_link>:
{
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	57                   	push   %edi
80104ed4:	56                   	push   %esi
80104ed5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ed6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104ed9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104edc:	50                   	push   %eax
80104edd:	6a 00                	push   $0x0
80104edf:	e8 6c fb ff ff       	call   80104a50 <argstr>
80104ee4:	83 c4 10             	add    $0x10,%esp
80104ee7:	85 c0                	test   %eax,%eax
80104ee9:	0f 88 fb 00 00 00    	js     80104fea <sys_link+0x11a>
80104eef:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104ef2:	83 ec 08             	sub    $0x8,%esp
80104ef5:	50                   	push   %eax
80104ef6:	6a 01                	push   $0x1
80104ef8:	e8 53 fb ff ff       	call   80104a50 <argstr>
80104efd:	83 c4 10             	add    $0x10,%esp
80104f00:	85 c0                	test   %eax,%eax
80104f02:	0f 88 e2 00 00 00    	js     80104fea <sys_link+0x11a>
  begin_op();
80104f08:	e8 03 df ff ff       	call   80102e10 <begin_op>
  if((ip = namei(old)) == 0){
80104f0d:	83 ec 0c             	sub    $0xc,%esp
80104f10:	ff 75 d4             	pushl  -0x2c(%ebp)
80104f13:	e8 48 d2 ff ff       	call   80102160 <namei>
80104f18:	83 c4 10             	add    $0x10,%esp
80104f1b:	85 c0                	test   %eax,%eax
80104f1d:	89 c3                	mov    %eax,%ebx
80104f1f:	0f 84 ea 00 00 00    	je     8010500f <sys_link+0x13f>
  ilock(ip);
80104f25:	83 ec 0c             	sub    $0xc,%esp
80104f28:	50                   	push   %eax
80104f29:	e8 d2 c9 ff ff       	call   80101900 <ilock>
  if(ip->type == T_DIR){
80104f2e:	83 c4 10             	add    $0x10,%esp
80104f31:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f36:	0f 84 bb 00 00 00    	je     80104ff7 <sys_link+0x127>
  ip->nlink++;
80104f3c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f41:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80104f44:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104f47:	53                   	push   %ebx
80104f48:	e8 03 c9 ff ff       	call   80101850 <iupdate>
  iunlock(ip);
80104f4d:	89 1c 24             	mov    %ebx,(%esp)
80104f50:	e8 8b ca ff ff       	call   801019e0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104f55:	58                   	pop    %eax
80104f56:	5a                   	pop    %edx
80104f57:	57                   	push   %edi
80104f58:	ff 75 d0             	pushl  -0x30(%ebp)
80104f5b:	e8 20 d2 ff ff       	call   80102180 <nameiparent>
80104f60:	83 c4 10             	add    $0x10,%esp
80104f63:	85 c0                	test   %eax,%eax
80104f65:	89 c6                	mov    %eax,%esi
80104f67:	74 5b                	je     80104fc4 <sys_link+0xf4>
  ilock(dp);
80104f69:	83 ec 0c             	sub    $0xc,%esp
80104f6c:	50                   	push   %eax
80104f6d:	e8 8e c9 ff ff       	call   80101900 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104f72:	83 c4 10             	add    $0x10,%esp
80104f75:	8b 03                	mov    (%ebx),%eax
80104f77:	39 06                	cmp    %eax,(%esi)
80104f79:	75 3d                	jne    80104fb8 <sys_link+0xe8>
80104f7b:	83 ec 04             	sub    $0x4,%esp
80104f7e:	ff 73 04             	pushl  0x4(%ebx)
80104f81:	57                   	push   %edi
80104f82:	56                   	push   %esi
80104f83:	e8 18 d1 ff ff       	call   801020a0 <dirlink>
80104f88:	83 c4 10             	add    $0x10,%esp
80104f8b:	85 c0                	test   %eax,%eax
80104f8d:	78 29                	js     80104fb8 <sys_link+0xe8>
  iunlockput(dp);
80104f8f:	83 ec 0c             	sub    $0xc,%esp
80104f92:	56                   	push   %esi
80104f93:	e8 f8 cb ff ff       	call   80101b90 <iunlockput>
  iput(ip);
80104f98:	89 1c 24             	mov    %ebx,(%esp)
80104f9b:	e8 90 ca ff ff       	call   80101a30 <iput>
  end_op();
80104fa0:	e8 db de ff ff       	call   80102e80 <end_op>
  return 0;
80104fa5:	83 c4 10             	add    $0x10,%esp
80104fa8:	31 c0                	xor    %eax,%eax
}
80104faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fad:	5b                   	pop    %ebx
80104fae:	5e                   	pop    %esi
80104faf:	5f                   	pop    %edi
80104fb0:	5d                   	pop    %ebp
80104fb1:	c3                   	ret    
80104fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104fb8:	83 ec 0c             	sub    $0xc,%esp
80104fbb:	56                   	push   %esi
80104fbc:	e8 cf cb ff ff       	call   80101b90 <iunlockput>
    goto bad;
80104fc1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104fc4:	83 ec 0c             	sub    $0xc,%esp
80104fc7:	53                   	push   %ebx
80104fc8:	e8 33 c9 ff ff       	call   80101900 <ilock>
  ip->nlink--;
80104fcd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104fd2:	89 1c 24             	mov    %ebx,(%esp)
80104fd5:	e8 76 c8 ff ff       	call   80101850 <iupdate>
  iunlockput(ip);
80104fda:	89 1c 24             	mov    %ebx,(%esp)
80104fdd:	e8 ae cb ff ff       	call   80101b90 <iunlockput>
  end_op();
80104fe2:	e8 99 de ff ff       	call   80102e80 <end_op>
  return -1;
80104fe7:	83 c4 10             	add    $0x10,%esp
}
80104fea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80104fed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ff2:	5b                   	pop    %ebx
80104ff3:	5e                   	pop    %esi
80104ff4:	5f                   	pop    %edi
80104ff5:	5d                   	pop    %ebp
80104ff6:	c3                   	ret    
    iunlockput(ip);
80104ff7:	83 ec 0c             	sub    $0xc,%esp
80104ffa:	53                   	push   %ebx
80104ffb:	e8 90 cb ff ff       	call   80101b90 <iunlockput>
    end_op();
80105000:	e8 7b de ff ff       	call   80102e80 <end_op>
    return -1;
80105005:	83 c4 10             	add    $0x10,%esp
80105008:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010500d:	eb 9b                	jmp    80104faa <sys_link+0xda>
    end_op();
8010500f:	e8 6c de ff ff       	call   80102e80 <end_op>
    return -1;
80105014:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105019:	eb 8f                	jmp    80104faa <sys_link+0xda>
8010501b:	90                   	nop
8010501c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105020 <sys_unlink>:
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	57                   	push   %edi
80105024:	56                   	push   %esi
80105025:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105026:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105029:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010502c:	50                   	push   %eax
8010502d:	6a 00                	push   $0x0
8010502f:	e8 1c fa ff ff       	call   80104a50 <argstr>
80105034:	83 c4 10             	add    $0x10,%esp
80105037:	85 c0                	test   %eax,%eax
80105039:	0f 88 77 01 00 00    	js     801051b6 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010503f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105042:	e8 c9 dd ff ff       	call   80102e10 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105047:	83 ec 08             	sub    $0x8,%esp
8010504a:	53                   	push   %ebx
8010504b:	ff 75 c0             	pushl  -0x40(%ebp)
8010504e:	e8 2d d1 ff ff       	call   80102180 <nameiparent>
80105053:	83 c4 10             	add    $0x10,%esp
80105056:	85 c0                	test   %eax,%eax
80105058:	89 c6                	mov    %eax,%esi
8010505a:	0f 84 60 01 00 00    	je     801051c0 <sys_unlink+0x1a0>
  ilock(dp);
80105060:	83 ec 0c             	sub    $0xc,%esp
80105063:	50                   	push   %eax
80105064:	e8 97 c8 ff ff       	call   80101900 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105069:	58                   	pop    %eax
8010506a:	5a                   	pop    %edx
8010506b:	68 3c 7d 10 80       	push   $0x80107d3c
80105070:	53                   	push   %ebx
80105071:	e8 9a cd ff ff       	call   80101e10 <namecmp>
80105076:	83 c4 10             	add    $0x10,%esp
80105079:	85 c0                	test   %eax,%eax
8010507b:	0f 84 03 01 00 00    	je     80105184 <sys_unlink+0x164>
80105081:	83 ec 08             	sub    $0x8,%esp
80105084:	68 3b 7d 10 80       	push   $0x80107d3b
80105089:	53                   	push   %ebx
8010508a:	e8 81 cd ff ff       	call   80101e10 <namecmp>
8010508f:	83 c4 10             	add    $0x10,%esp
80105092:	85 c0                	test   %eax,%eax
80105094:	0f 84 ea 00 00 00    	je     80105184 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010509a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010509d:	83 ec 04             	sub    $0x4,%esp
801050a0:	50                   	push   %eax
801050a1:	53                   	push   %ebx
801050a2:	56                   	push   %esi
801050a3:	e8 88 cd ff ff       	call   80101e30 <dirlookup>
801050a8:	83 c4 10             	add    $0x10,%esp
801050ab:	85 c0                	test   %eax,%eax
801050ad:	89 c3                	mov    %eax,%ebx
801050af:	0f 84 cf 00 00 00    	je     80105184 <sys_unlink+0x164>
  ilock(ip);
801050b5:	83 ec 0c             	sub    $0xc,%esp
801050b8:	50                   	push   %eax
801050b9:	e8 42 c8 ff ff       	call   80101900 <ilock>
  if(ip->nlink < 1)
801050be:	83 c4 10             	add    $0x10,%esp
801050c1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801050c6:	0f 8e 10 01 00 00    	jle    801051dc <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801050cc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050d1:	74 6d                	je     80105140 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801050d3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801050d6:	83 ec 04             	sub    $0x4,%esp
801050d9:	6a 10                	push   $0x10
801050db:	6a 00                	push   $0x0
801050dd:	50                   	push   %eax
801050de:	e8 bd f5 ff ff       	call   801046a0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801050e3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801050e6:	6a 10                	push   $0x10
801050e8:	ff 75 c4             	pushl  -0x3c(%ebp)
801050eb:	50                   	push   %eax
801050ec:	56                   	push   %esi
801050ed:	e8 ee cb ff ff       	call   80101ce0 <writei>
801050f2:	83 c4 20             	add    $0x20,%esp
801050f5:	83 f8 10             	cmp    $0x10,%eax
801050f8:	0f 85 eb 00 00 00    	jne    801051e9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
801050fe:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105103:	0f 84 97 00 00 00    	je     801051a0 <sys_unlink+0x180>
  iunlockput(dp);
80105109:	83 ec 0c             	sub    $0xc,%esp
8010510c:	56                   	push   %esi
8010510d:	e8 7e ca ff ff       	call   80101b90 <iunlockput>
  ip->nlink--;
80105112:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105117:	89 1c 24             	mov    %ebx,(%esp)
8010511a:	e8 31 c7 ff ff       	call   80101850 <iupdate>
  iunlockput(ip);
8010511f:	89 1c 24             	mov    %ebx,(%esp)
80105122:	e8 69 ca ff ff       	call   80101b90 <iunlockput>
  end_op();
80105127:	e8 54 dd ff ff       	call   80102e80 <end_op>
  return 0;
8010512c:	83 c4 10             	add    $0x10,%esp
8010512f:	31 c0                	xor    %eax,%eax
}
80105131:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105134:	5b                   	pop    %ebx
80105135:	5e                   	pop    %esi
80105136:	5f                   	pop    %edi
80105137:	5d                   	pop    %ebp
80105138:	c3                   	ret    
80105139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105140:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105144:	76 8d                	jbe    801050d3 <sys_unlink+0xb3>
80105146:	bf 20 00 00 00       	mov    $0x20,%edi
8010514b:	eb 0f                	jmp    8010515c <sys_unlink+0x13c>
8010514d:	8d 76 00             	lea    0x0(%esi),%esi
80105150:	83 c7 10             	add    $0x10,%edi
80105153:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105156:	0f 83 77 ff ff ff    	jae    801050d3 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010515c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010515f:	6a 10                	push   $0x10
80105161:	57                   	push   %edi
80105162:	50                   	push   %eax
80105163:	53                   	push   %ebx
80105164:	e8 77 ca ff ff       	call   80101be0 <readi>
80105169:	83 c4 10             	add    $0x10,%esp
8010516c:	83 f8 10             	cmp    $0x10,%eax
8010516f:	75 5e                	jne    801051cf <sys_unlink+0x1af>
    if(de.inum != 0)
80105171:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105176:	74 d8                	je     80105150 <sys_unlink+0x130>
    iunlockput(ip);
80105178:	83 ec 0c             	sub    $0xc,%esp
8010517b:	53                   	push   %ebx
8010517c:	e8 0f ca ff ff       	call   80101b90 <iunlockput>
    goto bad;
80105181:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105184:	83 ec 0c             	sub    $0xc,%esp
80105187:	56                   	push   %esi
80105188:	e8 03 ca ff ff       	call   80101b90 <iunlockput>
  end_op();
8010518d:	e8 ee dc ff ff       	call   80102e80 <end_op>
  return -1;
80105192:	83 c4 10             	add    $0x10,%esp
80105195:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010519a:	eb 95                	jmp    80105131 <sys_unlink+0x111>
8010519c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
801051a0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801051a5:	83 ec 0c             	sub    $0xc,%esp
801051a8:	56                   	push   %esi
801051a9:	e8 a2 c6 ff ff       	call   80101850 <iupdate>
801051ae:	83 c4 10             	add    $0x10,%esp
801051b1:	e9 53 ff ff ff       	jmp    80105109 <sys_unlink+0xe9>
    return -1;
801051b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051bb:	e9 71 ff ff ff       	jmp    80105131 <sys_unlink+0x111>
    end_op();
801051c0:	e8 bb dc ff ff       	call   80102e80 <end_op>
    return -1;
801051c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051ca:	e9 62 ff ff ff       	jmp    80105131 <sys_unlink+0x111>
      panic("isdirempty: readi");
801051cf:	83 ec 0c             	sub    $0xc,%esp
801051d2:	68 60 7d 10 80       	push   $0x80107d60
801051d7:	e8 b4 b2 ff ff       	call   80100490 <panic>
    panic("unlink: nlink < 1");
801051dc:	83 ec 0c             	sub    $0xc,%esp
801051df:	68 4e 7d 10 80       	push   $0x80107d4e
801051e4:	e8 a7 b2 ff ff       	call   80100490 <panic>
    panic("unlink: writei");
801051e9:	83 ec 0c             	sub    $0xc,%esp
801051ec:	68 72 7d 10 80       	push   $0x80107d72
801051f1:	e8 9a b2 ff ff       	call   80100490 <panic>
801051f6:	8d 76 00             	lea    0x0(%esi),%esi
801051f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105200 <sys_open>:

int
sys_open(void)
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	57                   	push   %edi
80105204:	56                   	push   %esi
80105205:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105206:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105209:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010520c:	50                   	push   %eax
8010520d:	6a 00                	push   $0x0
8010520f:	e8 3c f8 ff ff       	call   80104a50 <argstr>
80105214:	83 c4 10             	add    $0x10,%esp
80105217:	85 c0                	test   %eax,%eax
80105219:	0f 88 1d 01 00 00    	js     8010533c <sys_open+0x13c>
8010521f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105222:	83 ec 08             	sub    $0x8,%esp
80105225:	50                   	push   %eax
80105226:	6a 01                	push   $0x1
80105228:	e8 73 f7 ff ff       	call   801049a0 <argint>
8010522d:	83 c4 10             	add    $0x10,%esp
80105230:	85 c0                	test   %eax,%eax
80105232:	0f 88 04 01 00 00    	js     8010533c <sys_open+0x13c>
    return -1;

  begin_op();
80105238:	e8 d3 db ff ff       	call   80102e10 <begin_op>

  if(omode & O_CREATE){
8010523d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105241:	0f 85 a9 00 00 00    	jne    801052f0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105247:	83 ec 0c             	sub    $0xc,%esp
8010524a:	ff 75 e0             	pushl  -0x20(%ebp)
8010524d:	e8 0e cf ff ff       	call   80102160 <namei>
80105252:	83 c4 10             	add    $0x10,%esp
80105255:	85 c0                	test   %eax,%eax
80105257:	89 c6                	mov    %eax,%esi
80105259:	0f 84 b2 00 00 00    	je     80105311 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010525f:	83 ec 0c             	sub    $0xc,%esp
80105262:	50                   	push   %eax
80105263:	e8 98 c6 ff ff       	call   80101900 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105268:	83 c4 10             	add    $0x10,%esp
8010526b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105270:	0f 84 aa 00 00 00    	je     80105320 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105276:	e8 05 bc ff ff       	call   80100e80 <filealloc>
8010527b:	85 c0                	test   %eax,%eax
8010527d:	89 c7                	mov    %eax,%edi
8010527f:	0f 84 a6 00 00 00    	je     8010532b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105285:	e8 c6 e7 ff ff       	call   80103a50 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010528a:	31 db                	xor    %ebx,%ebx
8010528c:	eb 0e                	jmp    8010529c <sys_open+0x9c>
8010528e:	66 90                	xchg   %ax,%ax
80105290:	83 c3 01             	add    $0x1,%ebx
80105293:	83 fb 10             	cmp    $0x10,%ebx
80105296:	0f 84 ac 00 00 00    	je     80105348 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010529c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801052a0:	85 d2                	test   %edx,%edx
801052a2:	75 ec                	jne    80105290 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801052a4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801052a7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801052ab:	56                   	push   %esi
801052ac:	e8 2f c7 ff ff       	call   801019e0 <iunlock>
  end_op();
801052b1:	e8 ca db ff ff       	call   80102e80 <end_op>

  f->type = FD_INODE;
801052b6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801052bc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801052bf:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801052c2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801052c5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801052cc:	89 d0                	mov    %edx,%eax
801052ce:	f7 d0                	not    %eax
801052d0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801052d3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801052d6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801052d9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801052dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052e0:	89 d8                	mov    %ebx,%eax
801052e2:	5b                   	pop    %ebx
801052e3:	5e                   	pop    %esi
801052e4:	5f                   	pop    %edi
801052e5:	5d                   	pop    %ebp
801052e6:	c3                   	ret    
801052e7:	89 f6                	mov    %esi,%esi
801052e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
801052f0:	83 ec 0c             	sub    $0xc,%esp
801052f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801052f6:	31 c9                	xor    %ecx,%ecx
801052f8:	6a 00                	push   $0x0
801052fa:	ba 02 00 00 00       	mov    $0x2,%edx
801052ff:	e8 ec f7 ff ff       	call   80104af0 <create>
    if(ip == 0){
80105304:	83 c4 10             	add    $0x10,%esp
80105307:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105309:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010530b:	0f 85 65 ff ff ff    	jne    80105276 <sys_open+0x76>
      end_op();
80105311:	e8 6a db ff ff       	call   80102e80 <end_op>
      return -1;
80105316:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010531b:	eb c0                	jmp    801052dd <sys_open+0xdd>
8010531d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105320:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105323:	85 c9                	test   %ecx,%ecx
80105325:	0f 84 4b ff ff ff    	je     80105276 <sys_open+0x76>
    iunlockput(ip);
8010532b:	83 ec 0c             	sub    $0xc,%esp
8010532e:	56                   	push   %esi
8010532f:	e8 5c c8 ff ff       	call   80101b90 <iunlockput>
    end_op();
80105334:	e8 47 db ff ff       	call   80102e80 <end_op>
    return -1;
80105339:	83 c4 10             	add    $0x10,%esp
8010533c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105341:	eb 9a                	jmp    801052dd <sys_open+0xdd>
80105343:	90                   	nop
80105344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105348:	83 ec 0c             	sub    $0xc,%esp
8010534b:	57                   	push   %edi
8010534c:	e8 ef bb ff ff       	call   80100f40 <fileclose>
80105351:	83 c4 10             	add    $0x10,%esp
80105354:	eb d5                	jmp    8010532b <sys_open+0x12b>
80105356:	8d 76 00             	lea    0x0(%esi),%esi
80105359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105360 <sys_mkdir>:

int
sys_mkdir(void)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105366:	e8 a5 da ff ff       	call   80102e10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010536b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010536e:	83 ec 08             	sub    $0x8,%esp
80105371:	50                   	push   %eax
80105372:	6a 00                	push   $0x0
80105374:	e8 d7 f6 ff ff       	call   80104a50 <argstr>
80105379:	83 c4 10             	add    $0x10,%esp
8010537c:	85 c0                	test   %eax,%eax
8010537e:	78 30                	js     801053b0 <sys_mkdir+0x50>
80105380:	83 ec 0c             	sub    $0xc,%esp
80105383:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105386:	31 c9                	xor    %ecx,%ecx
80105388:	6a 00                	push   $0x0
8010538a:	ba 01 00 00 00       	mov    $0x1,%edx
8010538f:	e8 5c f7 ff ff       	call   80104af0 <create>
80105394:	83 c4 10             	add    $0x10,%esp
80105397:	85 c0                	test   %eax,%eax
80105399:	74 15                	je     801053b0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010539b:	83 ec 0c             	sub    $0xc,%esp
8010539e:	50                   	push   %eax
8010539f:	e8 ec c7 ff ff       	call   80101b90 <iunlockput>
  end_op();
801053a4:	e8 d7 da ff ff       	call   80102e80 <end_op>
  return 0;
801053a9:	83 c4 10             	add    $0x10,%esp
801053ac:	31 c0                	xor    %eax,%eax
}
801053ae:	c9                   	leave  
801053af:	c3                   	ret    
    end_op();
801053b0:	e8 cb da ff ff       	call   80102e80 <end_op>
    return -1;
801053b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053ba:	c9                   	leave  
801053bb:	c3                   	ret    
801053bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053c0 <sys_mknod>:

int
sys_mknod(void)
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801053c6:	e8 45 da ff ff       	call   80102e10 <begin_op>
  if((argstr(0, &path)) < 0 ||
801053cb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801053ce:	83 ec 08             	sub    $0x8,%esp
801053d1:	50                   	push   %eax
801053d2:	6a 00                	push   $0x0
801053d4:	e8 77 f6 ff ff       	call   80104a50 <argstr>
801053d9:	83 c4 10             	add    $0x10,%esp
801053dc:	85 c0                	test   %eax,%eax
801053de:	78 60                	js     80105440 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801053e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053e3:	83 ec 08             	sub    $0x8,%esp
801053e6:	50                   	push   %eax
801053e7:	6a 01                	push   $0x1
801053e9:	e8 b2 f5 ff ff       	call   801049a0 <argint>
  if((argstr(0, &path)) < 0 ||
801053ee:	83 c4 10             	add    $0x10,%esp
801053f1:	85 c0                	test   %eax,%eax
801053f3:	78 4b                	js     80105440 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801053f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053f8:	83 ec 08             	sub    $0x8,%esp
801053fb:	50                   	push   %eax
801053fc:	6a 02                	push   $0x2
801053fe:	e8 9d f5 ff ff       	call   801049a0 <argint>
     argint(1, &major) < 0 ||
80105403:	83 c4 10             	add    $0x10,%esp
80105406:	85 c0                	test   %eax,%eax
80105408:	78 36                	js     80105440 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010540a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010540e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105411:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105415:	ba 03 00 00 00       	mov    $0x3,%edx
8010541a:	50                   	push   %eax
8010541b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010541e:	e8 cd f6 ff ff       	call   80104af0 <create>
80105423:	83 c4 10             	add    $0x10,%esp
80105426:	85 c0                	test   %eax,%eax
80105428:	74 16                	je     80105440 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010542a:	83 ec 0c             	sub    $0xc,%esp
8010542d:	50                   	push   %eax
8010542e:	e8 5d c7 ff ff       	call   80101b90 <iunlockput>
  end_op();
80105433:	e8 48 da ff ff       	call   80102e80 <end_op>
  return 0;
80105438:	83 c4 10             	add    $0x10,%esp
8010543b:	31 c0                	xor    %eax,%eax
}
8010543d:	c9                   	leave  
8010543e:	c3                   	ret    
8010543f:	90                   	nop
    end_op();
80105440:	e8 3b da ff ff       	call   80102e80 <end_op>
    return -1;
80105445:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010544a:	c9                   	leave  
8010544b:	c3                   	ret    
8010544c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105450 <sys_chdir>:

int
sys_chdir(void)
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	56                   	push   %esi
80105454:	53                   	push   %ebx
80105455:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105458:	e8 f3 e5 ff ff       	call   80103a50 <myproc>
8010545d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010545f:	e8 ac d9 ff ff       	call   80102e10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105464:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105467:	83 ec 08             	sub    $0x8,%esp
8010546a:	50                   	push   %eax
8010546b:	6a 00                	push   $0x0
8010546d:	e8 de f5 ff ff       	call   80104a50 <argstr>
80105472:	83 c4 10             	add    $0x10,%esp
80105475:	85 c0                	test   %eax,%eax
80105477:	78 77                	js     801054f0 <sys_chdir+0xa0>
80105479:	83 ec 0c             	sub    $0xc,%esp
8010547c:	ff 75 f4             	pushl  -0xc(%ebp)
8010547f:	e8 dc cc ff ff       	call   80102160 <namei>
80105484:	83 c4 10             	add    $0x10,%esp
80105487:	85 c0                	test   %eax,%eax
80105489:	89 c3                	mov    %eax,%ebx
8010548b:	74 63                	je     801054f0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010548d:	83 ec 0c             	sub    $0xc,%esp
80105490:	50                   	push   %eax
80105491:	e8 6a c4 ff ff       	call   80101900 <ilock>
  if(ip->type != T_DIR){
80105496:	83 c4 10             	add    $0x10,%esp
80105499:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010549e:	75 30                	jne    801054d0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801054a0:	83 ec 0c             	sub    $0xc,%esp
801054a3:	53                   	push   %ebx
801054a4:	e8 37 c5 ff ff       	call   801019e0 <iunlock>
  iput(curproc->cwd);
801054a9:	58                   	pop    %eax
801054aa:	ff 76 68             	pushl  0x68(%esi)
801054ad:	e8 7e c5 ff ff       	call   80101a30 <iput>
  end_op();
801054b2:	e8 c9 d9 ff ff       	call   80102e80 <end_op>
  curproc->cwd = ip;
801054b7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801054ba:	83 c4 10             	add    $0x10,%esp
801054bd:	31 c0                	xor    %eax,%eax
}
801054bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054c2:	5b                   	pop    %ebx
801054c3:	5e                   	pop    %esi
801054c4:	5d                   	pop    %ebp
801054c5:	c3                   	ret    
801054c6:	8d 76 00             	lea    0x0(%esi),%esi
801054c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
801054d0:	83 ec 0c             	sub    $0xc,%esp
801054d3:	53                   	push   %ebx
801054d4:	e8 b7 c6 ff ff       	call   80101b90 <iunlockput>
    end_op();
801054d9:	e8 a2 d9 ff ff       	call   80102e80 <end_op>
    return -1;
801054de:	83 c4 10             	add    $0x10,%esp
801054e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054e6:	eb d7                	jmp    801054bf <sys_chdir+0x6f>
801054e8:	90                   	nop
801054e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801054f0:	e8 8b d9 ff ff       	call   80102e80 <end_op>
    return -1;
801054f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054fa:	eb c3                	jmp    801054bf <sys_chdir+0x6f>
801054fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105500 <sys_exec>:

int
sys_exec(void)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	57                   	push   %edi
80105504:	56                   	push   %esi
80105505:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105506:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010550c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105512:	50                   	push   %eax
80105513:	6a 00                	push   $0x0
80105515:	e8 36 f5 ff ff       	call   80104a50 <argstr>
8010551a:	83 c4 10             	add    $0x10,%esp
8010551d:	85 c0                	test   %eax,%eax
8010551f:	0f 88 87 00 00 00    	js     801055ac <sys_exec+0xac>
80105525:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010552b:	83 ec 08             	sub    $0x8,%esp
8010552e:	50                   	push   %eax
8010552f:	6a 01                	push   $0x1
80105531:	e8 6a f4 ff ff       	call   801049a0 <argint>
80105536:	83 c4 10             	add    $0x10,%esp
80105539:	85 c0                	test   %eax,%eax
8010553b:	78 6f                	js     801055ac <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010553d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105543:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105546:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105548:	68 80 00 00 00       	push   $0x80
8010554d:	6a 00                	push   $0x0
8010554f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105555:	50                   	push   %eax
80105556:	e8 45 f1 ff ff       	call   801046a0 <memset>
8010555b:	83 c4 10             	add    $0x10,%esp
8010555e:	eb 2c                	jmp    8010558c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105560:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105566:	85 c0                	test   %eax,%eax
80105568:	74 56                	je     801055c0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010556a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105570:	83 ec 08             	sub    $0x8,%esp
80105573:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105576:	52                   	push   %edx
80105577:	50                   	push   %eax
80105578:	e8 b3 f3 ff ff       	call   80104930 <fetchstr>
8010557d:	83 c4 10             	add    $0x10,%esp
80105580:	85 c0                	test   %eax,%eax
80105582:	78 28                	js     801055ac <sys_exec+0xac>
  for(i=0;; i++){
80105584:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105587:	83 fb 20             	cmp    $0x20,%ebx
8010558a:	74 20                	je     801055ac <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010558c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105592:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105599:	83 ec 08             	sub    $0x8,%esp
8010559c:	57                   	push   %edi
8010559d:	01 f0                	add    %esi,%eax
8010559f:	50                   	push   %eax
801055a0:	e8 4b f3 ff ff       	call   801048f0 <fetchint>
801055a5:	83 c4 10             	add    $0x10,%esp
801055a8:	85 c0                	test   %eax,%eax
801055aa:	79 b4                	jns    80105560 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801055ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801055af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055b4:	5b                   	pop    %ebx
801055b5:	5e                   	pop    %esi
801055b6:	5f                   	pop    %edi
801055b7:	5d                   	pop    %ebp
801055b8:	c3                   	ret    
801055b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801055c0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801055c6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
801055c9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801055d0:	00 00 00 00 
  return exec(path, argv);
801055d4:	50                   	push   %eax
801055d5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801055db:	e8 30 b5 ff ff       	call   80100b10 <exec>
801055e0:	83 c4 10             	add    $0x10,%esp
}
801055e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055e6:	5b                   	pop    %ebx
801055e7:	5e                   	pop    %esi
801055e8:	5f                   	pop    %edi
801055e9:	5d                   	pop    %ebp
801055ea:	c3                   	ret    
801055eb:	90                   	nop
801055ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055f0 <sys_pipe>:

int
sys_pipe(void)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	57                   	push   %edi
801055f4:	56                   	push   %esi
801055f5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801055f6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801055f9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801055fc:	6a 08                	push   $0x8
801055fe:	50                   	push   %eax
801055ff:	6a 00                	push   $0x0
80105601:	e8 ea f3 ff ff       	call   801049f0 <argptr>
80105606:	83 c4 10             	add    $0x10,%esp
80105609:	85 c0                	test   %eax,%eax
8010560b:	0f 88 ae 00 00 00    	js     801056bf <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105611:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105614:	83 ec 08             	sub    $0x8,%esp
80105617:	50                   	push   %eax
80105618:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010561b:	50                   	push   %eax
8010561c:	e8 8f de ff ff       	call   801034b0 <pipealloc>
80105621:	83 c4 10             	add    $0x10,%esp
80105624:	85 c0                	test   %eax,%eax
80105626:	0f 88 93 00 00 00    	js     801056bf <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010562c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010562f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105631:	e8 1a e4 ff ff       	call   80103a50 <myproc>
80105636:	eb 10                	jmp    80105648 <sys_pipe+0x58>
80105638:	90                   	nop
80105639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105640:	83 c3 01             	add    $0x1,%ebx
80105643:	83 fb 10             	cmp    $0x10,%ebx
80105646:	74 60                	je     801056a8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105648:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010564c:	85 f6                	test   %esi,%esi
8010564e:	75 f0                	jne    80105640 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105650:	8d 73 08             	lea    0x8(%ebx),%esi
80105653:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105657:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010565a:	e8 f1 e3 ff ff       	call   80103a50 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010565f:	31 d2                	xor    %edx,%edx
80105661:	eb 0d                	jmp    80105670 <sys_pipe+0x80>
80105663:	90                   	nop
80105664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105668:	83 c2 01             	add    $0x1,%edx
8010566b:	83 fa 10             	cmp    $0x10,%edx
8010566e:	74 28                	je     80105698 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105670:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105674:	85 c9                	test   %ecx,%ecx
80105676:	75 f0                	jne    80105668 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105678:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010567c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010567f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105681:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105684:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105687:	31 c0                	xor    %eax,%eax
}
80105689:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010568c:	5b                   	pop    %ebx
8010568d:	5e                   	pop    %esi
8010568e:	5f                   	pop    %edi
8010568f:	5d                   	pop    %ebp
80105690:	c3                   	ret    
80105691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105698:	e8 b3 e3 ff ff       	call   80103a50 <myproc>
8010569d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801056a4:	00 
801056a5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
801056a8:	83 ec 0c             	sub    $0xc,%esp
801056ab:	ff 75 e0             	pushl  -0x20(%ebp)
801056ae:	e8 8d b8 ff ff       	call   80100f40 <fileclose>
    fileclose(wf);
801056b3:	58                   	pop    %eax
801056b4:	ff 75 e4             	pushl  -0x1c(%ebp)
801056b7:	e8 84 b8 ff ff       	call   80100f40 <fileclose>
    return -1;
801056bc:	83 c4 10             	add    $0x10,%esp
801056bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056c4:	eb c3                	jmp    80105689 <sys_pipe+0x99>
801056c6:	8d 76 00             	lea    0x0(%esi),%esi
801056c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056d0 <sys_bstat>:

/* returns the number of swapped pages
 */
int
sys_bstat(void)
{
801056d0:	55                   	push   %ebp
	return numallocblocks;
}
801056d1:	a1 5c b5 10 80       	mov    0x8010b55c,%eax
{
801056d6:	89 e5                	mov    %esp,%ebp
}
801056d8:	5d                   	pop    %ebp
801056d9:	c3                   	ret    
801056da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801056e0 <sys_swap>:

/* swap system call handler.
 */
int
sys_swap(void)
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	83 ec 20             	sub    $0x20,%esp
  uint addr;

  if(argint(0, (int*)&addr) < 0)
801056e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056e9:	50                   	push   %eax
801056ea:	6a 00                	push   $0x0
801056ec:	e8 af f2 ff ff       	call   801049a0 <argint>
801056f1:	83 c4 10             	add    $0x10,%esp
801056f4:	85 c0                	test   %eax,%eax
801056f6:	78 18                	js     80105710 <sys_swap+0x30>
    return -1;
  swap_page(myproc()->pgdir);
801056f8:	e8 53 e3 ff ff       	call   80103a50 <myproc>
801056fd:	83 ec 0c             	sub    $0xc,%esp
80105700:	ff 70 04             	pushl  0x4(%eax)
80105703:	e8 d8 05 00 00       	call   80105ce0 <swap_page>
  return 0;
80105708:	83 c4 10             	add    $0x10,%esp
8010570b:	31 c0                	xor    %eax,%eax
}
8010570d:	c9                   	leave  
8010570e:	c3                   	ret    
8010570f:	90                   	nop
    return -1;
80105710:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105715:	c9                   	leave  
80105716:	c3                   	ret    
80105717:	66 90                	xchg   %ax,%ax
80105719:	66 90                	xchg   %ax,%ax
8010571b:	66 90                	xchg   %ax,%ax
8010571d:	66 90                	xchg   %ax,%ax
8010571f:	90                   	nop

80105720 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105723:	5d                   	pop    %ebp
  return fork();
80105724:	e9 97 e4 ff ff       	jmp    80103bc0 <fork>
80105729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105730 <sys_exit>:

int
sys_exit(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	83 ec 08             	sub    $0x8,%esp
  exit();
80105736:	e8 05 e7 ff ff       	call   80103e40 <exit>
  return 0;  // not reached
}
8010573b:	31 c0                	xor    %eax,%eax
8010573d:	c9                   	leave  
8010573e:	c3                   	ret    
8010573f:	90                   	nop

80105740 <sys_wait>:

int
sys_wait(void)
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105743:	5d                   	pop    %ebp
  return wait();
80105744:	e9 37 e9 ff ff       	jmp    80104080 <wait>
80105749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105750 <sys_kill>:

int
sys_kill(void)
{
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105756:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105759:	50                   	push   %eax
8010575a:	6a 00                	push   $0x0
8010575c:	e8 3f f2 ff ff       	call   801049a0 <argint>
80105761:	83 c4 10             	add    $0x10,%esp
80105764:	85 c0                	test   %eax,%eax
80105766:	78 18                	js     80105780 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105768:	83 ec 0c             	sub    $0xc,%esp
8010576b:	ff 75 f4             	pushl  -0xc(%ebp)
8010576e:	e8 6d ea ff ff       	call   801041e0 <kill>
80105773:	83 c4 10             	add    $0x10,%esp
}
80105776:	c9                   	leave  
80105777:	c3                   	ret    
80105778:	90                   	nop
80105779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105780:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105785:	c9                   	leave  
80105786:	c3                   	ret    
80105787:	89 f6                	mov    %esi,%esi
80105789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105790 <sys_getpid>:

int
sys_getpid(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105796:	e8 b5 e2 ff ff       	call   80103a50 <myproc>
8010579b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010579e:	c9                   	leave  
8010579f:	c3                   	ret    

801057a0 <sys_sbrk>:

int
sys_sbrk(void)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801057a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057a7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801057aa:	50                   	push   %eax
801057ab:	6a 00                	push   $0x0
801057ad:	e8 ee f1 ff ff       	call   801049a0 <argint>
801057b2:	83 c4 10             	add    $0x10,%esp
801057b5:	85 c0                	test   %eax,%eax
801057b7:	78 27                	js     801057e0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801057b9:	e8 92 e2 ff ff       	call   80103a50 <myproc>
  if(growproc(n) < 0)
801057be:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801057c1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801057c3:	ff 75 f4             	pushl  -0xc(%ebp)
801057c6:	e8 a5 e3 ff ff       	call   80103b70 <growproc>
801057cb:	83 c4 10             	add    $0x10,%esp
801057ce:	85 c0                	test   %eax,%eax
801057d0:	78 0e                	js     801057e0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801057d2:	89 d8                	mov    %ebx,%eax
801057d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057d7:	c9                   	leave  
801057d8:	c3                   	ret    
801057d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801057e0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801057e5:	eb eb                	jmp    801057d2 <sys_sbrk+0x32>
801057e7:	89 f6                	mov    %esi,%esi
801057e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057f0 <sys_sleep>:

int
sys_sleep(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801057f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057f7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801057fa:	50                   	push   %eax
801057fb:	6a 00                	push   $0x0
801057fd:	e8 9e f1 ff ff       	call   801049a0 <argint>
80105802:	83 c4 10             	add    $0x10,%esp
80105805:	85 c0                	test   %eax,%eax
80105807:	0f 88 8a 00 00 00    	js     80105897 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010580d:	83 ec 0c             	sub    $0xc,%esp
80105810:	68 60 5c 11 80       	push   $0x80115c60
80105815:	e8 06 ed ff ff       	call   80104520 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010581a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010581d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105820:	8b 1d a0 64 11 80    	mov    0x801164a0,%ebx
  while(ticks - ticks0 < n){
80105826:	85 d2                	test   %edx,%edx
80105828:	75 27                	jne    80105851 <sys_sleep+0x61>
8010582a:	eb 54                	jmp    80105880 <sys_sleep+0x90>
8010582c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105830:	83 ec 08             	sub    $0x8,%esp
80105833:	68 60 5c 11 80       	push   $0x80115c60
80105838:	68 a0 64 11 80       	push   $0x801164a0
8010583d:	e8 7e e7 ff ff       	call   80103fc0 <sleep>
  while(ticks - ticks0 < n){
80105842:	a1 a0 64 11 80       	mov    0x801164a0,%eax
80105847:	83 c4 10             	add    $0x10,%esp
8010584a:	29 d8                	sub    %ebx,%eax
8010584c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010584f:	73 2f                	jae    80105880 <sys_sleep+0x90>
    if(myproc()->killed){
80105851:	e8 fa e1 ff ff       	call   80103a50 <myproc>
80105856:	8b 40 24             	mov    0x24(%eax),%eax
80105859:	85 c0                	test   %eax,%eax
8010585b:	74 d3                	je     80105830 <sys_sleep+0x40>
      release(&tickslock);
8010585d:	83 ec 0c             	sub    $0xc,%esp
80105860:	68 60 5c 11 80       	push   $0x80115c60
80105865:	e8 d6 ed ff ff       	call   80104640 <release>
      return -1;
8010586a:	83 c4 10             	add    $0x10,%esp
8010586d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105872:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105875:	c9                   	leave  
80105876:	c3                   	ret    
80105877:	89 f6                	mov    %esi,%esi
80105879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105880:	83 ec 0c             	sub    $0xc,%esp
80105883:	68 60 5c 11 80       	push   $0x80115c60
80105888:	e8 b3 ed ff ff       	call   80104640 <release>
  return 0;
8010588d:	83 c4 10             	add    $0x10,%esp
80105890:	31 c0                	xor    %eax,%eax
}
80105892:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105895:	c9                   	leave  
80105896:	c3                   	ret    
    return -1;
80105897:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010589c:	eb f4                	jmp    80105892 <sys_sleep+0xa2>
8010589e:	66 90                	xchg   %ax,%ax

801058a0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	53                   	push   %ebx
801058a4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801058a7:	68 60 5c 11 80       	push   $0x80115c60
801058ac:	e8 6f ec ff ff       	call   80104520 <acquire>
  xticks = ticks;
801058b1:	8b 1d a0 64 11 80    	mov    0x801164a0,%ebx
  release(&tickslock);
801058b7:	c7 04 24 60 5c 11 80 	movl   $0x80115c60,(%esp)
801058be:	e8 7d ed ff ff       	call   80104640 <release>
  return xticks;
}
801058c3:	89 d8                	mov    %ebx,%eax
801058c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058c8:	c9                   	leave  
801058c9:	c3                   	ret    

801058ca <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801058ca:	1e                   	push   %ds
  pushl %es
801058cb:	06                   	push   %es
  pushl %fs
801058cc:	0f a0                	push   %fs
  pushl %gs
801058ce:	0f a8                	push   %gs
  pushal
801058d0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801058d1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801058d5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801058d7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801058d9:	54                   	push   %esp
  call trap
801058da:	e8 c1 00 00 00       	call   801059a0 <trap>
  addl $4, %esp
801058df:	83 c4 04             	add    $0x4,%esp

801058e2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801058e2:	61                   	popa   
  popl %gs
801058e3:	0f a9                	pop    %gs
  popl %fs
801058e5:	0f a1                	pop    %fs
  popl %es
801058e7:	07                   	pop    %es
  popl %ds
801058e8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801058e9:	83 c4 08             	add    $0x8,%esp
  iret
801058ec:	cf                   	iret   
801058ed:	66 90                	xchg   %ax,%ax
801058ef:	90                   	nop

801058f0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801058f0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801058f1:	31 c0                	xor    %eax,%eax
{
801058f3:	89 e5                	mov    %esp,%ebp
801058f5:	83 ec 08             	sub    $0x8,%esp
801058f8:	90                   	nop
801058f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105900:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105907:	c7 04 c5 a2 5c 11 80 	movl   $0x8e000008,-0x7feea35e(,%eax,8)
8010590e:	08 00 00 8e 
80105912:	66 89 14 c5 a0 5c 11 	mov    %dx,-0x7feea360(,%eax,8)
80105919:	80 
8010591a:	c1 ea 10             	shr    $0x10,%edx
8010591d:	66 89 14 c5 a6 5c 11 	mov    %dx,-0x7feea35a(,%eax,8)
80105924:	80 
  for(i = 0; i < 256; i++)
80105925:	83 c0 01             	add    $0x1,%eax
80105928:	3d 00 01 00 00       	cmp    $0x100,%eax
8010592d:	75 d1                	jne    80105900 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010592f:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105934:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105937:	c7 05 a2 5e 11 80 08 	movl   $0xef000008,0x80115ea2
8010593e:	00 00 ef 
  initlock(&tickslock, "time");
80105941:	68 81 7d 10 80       	push   $0x80107d81
80105946:	68 60 5c 11 80       	push   $0x80115c60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010594b:	66 a3 a0 5e 11 80    	mov    %ax,0x80115ea0
80105951:	c1 e8 10             	shr    $0x10,%eax
80105954:	66 a3 a6 5e 11 80    	mov    %ax,0x80115ea6
  initlock(&tickslock, "time");
8010595a:	e8 d1 ea ff ff       	call   80104430 <initlock>
}
8010595f:	83 c4 10             	add    $0x10,%esp
80105962:	c9                   	leave  
80105963:	c3                   	ret    
80105964:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010596a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105970 <idtinit>:

void
idtinit(void)
{
80105970:	55                   	push   %ebp
  pd[0] = size-1;
80105971:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105976:	89 e5                	mov    %esp,%ebp
80105978:	83 ec 10             	sub    $0x10,%esp
8010597b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010597f:	b8 a0 5c 11 80       	mov    $0x80115ca0,%eax
80105984:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105988:	c1 e8 10             	shr    $0x10,%eax
8010598b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010598f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105992:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105995:	c9                   	leave  
80105996:	c3                   	ret    
80105997:	89 f6                	mov    %esi,%esi
80105999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059a0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	57                   	push   %edi
801059a4:	56                   	push   %esi
801059a5:	53                   	push   %ebx
801059a6:	83 ec 1c             	sub    $0x1c,%esp
801059a9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801059ac:	8b 47 30             	mov    0x30(%edi),%eax
801059af:	83 f8 40             	cmp    $0x40,%eax
801059b2:	0f 84 f0 00 00 00    	je     80105aa8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801059b8:	83 e8 0e             	sub    $0xe,%eax
801059bb:	83 f8 31             	cmp    $0x31,%eax
801059be:	77 10                	ja     801059d0 <trap+0x30>
801059c0:	ff 24 85 28 7e 10 80 	jmp    *-0x7fef81d8(,%eax,4)
801059c7:	89 f6                	mov    %esi,%esi
801059c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801059d0:	e8 7b e0 ff ff       	call   80103a50 <myproc>
801059d5:	85 c0                	test   %eax,%eax
801059d7:	8b 5f 38             	mov    0x38(%edi),%ebx
801059da:	0f 84 04 02 00 00    	je     80105be4 <trap+0x244>
801059e0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801059e4:	0f 84 fa 01 00 00    	je     80105be4 <trap+0x244>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801059ea:	0f 20 d1             	mov    %cr2,%ecx
801059ed:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801059f0:	e8 3b e0 ff ff       	call   80103a30 <cpuid>
801059f5:	89 45 dc             	mov    %eax,-0x24(%ebp)
801059f8:	8b 47 34             	mov    0x34(%edi),%eax
801059fb:	8b 77 30             	mov    0x30(%edi),%esi
801059fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105a01:	e8 4a e0 ff ff       	call   80103a50 <myproc>
80105a06:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105a09:	e8 42 e0 ff ff       	call   80103a50 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a0e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105a11:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105a14:	51                   	push   %ecx
80105a15:	53                   	push   %ebx
80105a16:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105a17:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a1a:	ff 75 e4             	pushl  -0x1c(%ebp)
80105a1d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105a1e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a21:	52                   	push   %edx
80105a22:	ff 70 10             	pushl  0x10(%eax)
80105a25:	68 e4 7d 10 80       	push   $0x80107de4
80105a2a:	e8 31 ad ff ff       	call   80100760 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105a2f:	83 c4 20             	add    $0x20,%esp
80105a32:	e8 19 e0 ff ff       	call   80103a50 <myproc>
80105a37:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105a3e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a40:	e8 0b e0 ff ff       	call   80103a50 <myproc>
80105a45:	85 c0                	test   %eax,%eax
80105a47:	74 1d                	je     80105a66 <trap+0xc6>
80105a49:	e8 02 e0 ff ff       	call   80103a50 <myproc>
80105a4e:	8b 50 24             	mov    0x24(%eax),%edx
80105a51:	85 d2                	test   %edx,%edx
80105a53:	74 11                	je     80105a66 <trap+0xc6>
80105a55:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105a59:	83 e0 03             	and    $0x3,%eax
80105a5c:	66 83 f8 03          	cmp    $0x3,%ax
80105a60:	0f 84 3a 01 00 00    	je     80105ba0 <trap+0x200>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105a66:	e8 e5 df ff ff       	call   80103a50 <myproc>
80105a6b:	85 c0                	test   %eax,%eax
80105a6d:	74 0b                	je     80105a7a <trap+0xda>
80105a6f:	e8 dc df ff ff       	call   80103a50 <myproc>
80105a74:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105a78:	74 66                	je     80105ae0 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a7a:	e8 d1 df ff ff       	call   80103a50 <myproc>
80105a7f:	85 c0                	test   %eax,%eax
80105a81:	74 19                	je     80105a9c <trap+0xfc>
80105a83:	e8 c8 df ff ff       	call   80103a50 <myproc>
80105a88:	8b 40 24             	mov    0x24(%eax),%eax
80105a8b:	85 c0                	test   %eax,%eax
80105a8d:	74 0d                	je     80105a9c <trap+0xfc>
80105a8f:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105a93:	83 e0 03             	and    $0x3,%eax
80105a96:	66 83 f8 03          	cmp    $0x3,%ax
80105a9a:	74 35                	je     80105ad1 <trap+0x131>
    exit();
}
80105a9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a9f:	5b                   	pop    %ebx
80105aa0:	5e                   	pop    %esi
80105aa1:	5f                   	pop    %edi
80105aa2:	5d                   	pop    %ebp
80105aa3:	c3                   	ret    
80105aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105aa8:	e8 a3 df ff ff       	call   80103a50 <myproc>
80105aad:	8b 58 24             	mov    0x24(%eax),%ebx
80105ab0:	85 db                	test   %ebx,%ebx
80105ab2:	0f 85 d8 00 00 00    	jne    80105b90 <trap+0x1f0>
    myproc()->tf = tf;
80105ab8:	e8 93 df ff ff       	call   80103a50 <myproc>
80105abd:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105ac0:	e8 cb ef ff ff       	call   80104a90 <syscall>
    if(myproc()->killed)
80105ac5:	e8 86 df ff ff       	call   80103a50 <myproc>
80105aca:	8b 48 24             	mov    0x24(%eax),%ecx
80105acd:	85 c9                	test   %ecx,%ecx
80105acf:	74 cb                	je     80105a9c <trap+0xfc>
}
80105ad1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ad4:	5b                   	pop    %ebx
80105ad5:	5e                   	pop    %esi
80105ad6:	5f                   	pop    %edi
80105ad7:	5d                   	pop    %ebp
      exit();
80105ad8:	e9 63 e3 ff ff       	jmp    80103e40 <exit>
80105add:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105ae0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105ae4:	75 94                	jne    80105a7a <trap+0xda>
    yield();
80105ae6:	e8 85 e4 ff ff       	call   80103f70 <yield>
80105aeb:	eb 8d                	jmp    80105a7a <trap+0xda>
80105aed:	8d 76 00             	lea    0x0(%esi),%esi
  	handle_pgfault();
80105af0:	e8 4b 04 00 00       	call   80105f40 <handle_pgfault>
  	break;
80105af5:	e9 46 ff ff ff       	jmp    80105a40 <trap+0xa0>
80105afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105b00:	e8 2b df ff ff       	call   80103a30 <cpuid>
80105b05:	85 c0                	test   %eax,%eax
80105b07:	0f 84 a3 00 00 00    	je     80105bb0 <trap+0x210>
    lapiceoi();
80105b0d:	e8 ae ce ff ff       	call   801029c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b12:	e8 39 df ff ff       	call   80103a50 <myproc>
80105b17:	85 c0                	test   %eax,%eax
80105b19:	0f 85 2a ff ff ff    	jne    80105a49 <trap+0xa9>
80105b1f:	e9 42 ff ff ff       	jmp    80105a66 <trap+0xc6>
80105b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105b28:	e8 53 cd ff ff       	call   80102880 <kbdintr>
    lapiceoi();
80105b2d:	e8 8e ce ff ff       	call   801029c0 <lapiceoi>
    break;
80105b32:	e9 09 ff ff ff       	jmp    80105a40 <trap+0xa0>
80105b37:	89 f6                	mov    %esi,%esi
80105b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    uartintr();
80105b40:	e8 9b 05 00 00       	call   801060e0 <uartintr>
    lapiceoi();
80105b45:	e8 76 ce ff ff       	call   801029c0 <lapiceoi>
    break;
80105b4a:	e9 f1 fe ff ff       	jmp    80105a40 <trap+0xa0>
80105b4f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105b50:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105b54:	8b 77 38             	mov    0x38(%edi),%esi
80105b57:	e8 d4 de ff ff       	call   80103a30 <cpuid>
80105b5c:	56                   	push   %esi
80105b5d:	53                   	push   %ebx
80105b5e:	50                   	push   %eax
80105b5f:	68 8c 7d 10 80       	push   $0x80107d8c
80105b64:	e8 f7 ab ff ff       	call   80100760 <cprintf>
    lapiceoi();
80105b69:	e8 52 ce ff ff       	call   801029c0 <lapiceoi>
    break;
80105b6e:	83 c4 10             	add    $0x10,%esp
80105b71:	e9 ca fe ff ff       	jmp    80105a40 <trap+0xa0>
80105b76:	8d 76 00             	lea    0x0(%esi),%esi
80105b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
80105b80:	e8 6b c7 ff ff       	call   801022f0 <ideintr>
80105b85:	eb 86                	jmp    80105b0d <trap+0x16d>
80105b87:	89 f6                	mov    %esi,%esi
80105b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exit();
80105b90:	e8 ab e2 ff ff       	call   80103e40 <exit>
80105b95:	e9 1e ff ff ff       	jmp    80105ab8 <trap+0x118>
80105b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105ba0:	e8 9b e2 ff ff       	call   80103e40 <exit>
80105ba5:	e9 bc fe ff ff       	jmp    80105a66 <trap+0xc6>
80105baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105bb0:	83 ec 0c             	sub    $0xc,%esp
80105bb3:	68 60 5c 11 80       	push   $0x80115c60
80105bb8:	e8 63 e9 ff ff       	call   80104520 <acquire>
      wakeup(&ticks);
80105bbd:	c7 04 24 a0 64 11 80 	movl   $0x801164a0,(%esp)
      ticks++;
80105bc4:	83 05 a0 64 11 80 01 	addl   $0x1,0x801164a0
      wakeup(&ticks);
80105bcb:	e8 b0 e5 ff ff       	call   80104180 <wakeup>
      release(&tickslock);
80105bd0:	c7 04 24 60 5c 11 80 	movl   $0x80115c60,(%esp)
80105bd7:	e8 64 ea ff ff       	call   80104640 <release>
80105bdc:	83 c4 10             	add    $0x10,%esp
80105bdf:	e9 29 ff ff ff       	jmp    80105b0d <trap+0x16d>
80105be4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105be7:	e8 44 de ff ff       	call   80103a30 <cpuid>
80105bec:	83 ec 0c             	sub    $0xc,%esp
80105bef:	56                   	push   %esi
80105bf0:	53                   	push   %ebx
80105bf1:	50                   	push   %eax
80105bf2:	ff 77 30             	pushl  0x30(%edi)
80105bf5:	68 b0 7d 10 80       	push   $0x80107db0
80105bfa:	e8 61 ab ff ff       	call   80100760 <cprintf>
      panic("trap");
80105bff:	83 c4 14             	add    $0x14,%esp
80105c02:	68 86 7d 10 80       	push   $0x80107d86
80105c07:	e8 84 a8 ff ff       	call   80100490 <panic>
80105c0c:	66 90                	xchg   %ax,%ax
80105c0e:	66 90                	xchg   %ax,%ax

80105c10 <swap_page_from_pte>:
 * to the disk blocks and save the block-id into the
 * pte.
 */
void
swap_page_from_pte(pte_t *pte)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	57                   	push   %edi
80105c14:	56                   	push   %esi
80105c15:	53                   	push   %ebx
80105c16:	83 ec 18             	sub    $0x18,%esp
80105c19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  cprintf("swap page from pte\n");
80105c1c:	68 f0 7e 10 80       	push   $0x80107ef0
80105c21:	e8 3a ab ff ff       	call   80100760 <cprintf>
	uint blk = balloc_page(ROOTDEV);
80105c26:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105c2d:	e8 7e b9 ff ff       	call   801015b0 <balloc_page>
	char *va = (char *)P2V(PTE_ADDR(*pte));
80105c32:	8b 33                	mov    (%ebx),%esi
	write_page_to_disk(ROOTDEV, va, blk);
80105c34:	83 c4 0c             	add    $0xc,%esp
	uint blk = balloc_page(ROOTDEV);
80105c37:	89 c7                	mov    %eax,%edi
	write_page_to_disk(ROOTDEV, va, blk);
80105c39:	50                   	push   %eax
	char *va = (char *)P2V(PTE_ADDR(*pte));
80105c3a:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80105c40:	81 c6 00 00 00 80    	add    $0x80000000,%esi
	write_page_to_disk(ROOTDEV, va, blk);
80105c46:	56                   	push   %esi
80105c47:	6a 01                	push   $0x1
80105c49:	e8 22 a6 ff ff       	call   80100270 <write_page_to_disk>

	//mark pte not present
	cprintf("%d\n",blk);
80105c4e:	58                   	pop    %eax
80105c4f:	5a                   	pop    %edx
80105c50:	57                   	push   %edi
80105c51:	68 20 80 10 80       	push   $0x80108020
	blk=blk<<12;
80105c56:	c1 e7 0c             	shl    $0xc,%edi
	cprintf("%d\n",blk);
80105c59:	e8 02 ab ff ff       	call   80100760 <cprintf>
	cprintf("%d\n",blk);
80105c5e:	59                   	pop    %ecx
80105c5f:	58                   	pop    %eax
80105c60:	57                   	push   %edi
80105c61:	68 20 80 10 80       	push   $0x80108020
80105c66:	e8 f5 aa ff ff       	call   80100760 <cprintf>
	*pte=blk| PTE_FLAGS(*pte);
80105c6b:	8b 03                	mov    (%ebx),%eax
80105c6d:	25 ff 0f 00 00       	and    $0xfff,%eax
80105c72:	09 f8                	or     %edi,%eax
80105c74:	89 03                	mov    %eax,(%ebx)
  cprintf("%d\n",PTE_FLAGS(*pte));
80105c76:	25 ff 0f 00 00       	and    $0xfff,%eax
80105c7b:	5a                   	pop    %edx
80105c7c:	59                   	pop    %ecx
80105c7d:	50                   	push   %eax
80105c7e:	68 20 80 10 80       	push   $0x80108020
80105c83:	e8 d8 aa ff ff       	call   80100760 <cprintf>
  cprintf("a %d\n",*pte);
80105c88:	5f                   	pop    %edi
80105c89:	58                   	pop    %eax
80105c8a:	ff 33                	pushl  (%ebx)
80105c8c:	68 04 7f 10 80       	push   $0x80107f04
80105c91:	e8 ca aa ff ff       	call   80100760 <cprintf>
	*pte &= ~PTE_P;
80105c96:	8b 03                	mov    (%ebx),%eax
80105c98:	83 e0 fe             	and    $0xfffffffe,%eax
80105c9b:	89 03                	mov    %eax,(%ebx)
  cprintf("b %d\n",*pte);
80105c9d:	5a                   	pop    %edx
80105c9e:	59                   	pop    %ecx
80105c9f:	50                   	push   %eax
80105ca0:	68 0a 7f 10 80       	push   $0x80107f0a
80105ca5:	e8 b6 aa ff ff       	call   80100760 <cprintf>
	//store blk in higher 20 bits
	//use one bit in lower 12 bits to mark pte as swapped
	asm volatile("invlpg (%0)" ::"r" ((unsigned long)P2V(PTE_ADDR(*pte))) : "memory");
80105caa:	8b 03                	mov    (%ebx),%eax
80105cac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80105cb1:	05 00 00 00 80       	add    $0x80000000,%eax
80105cb6:	0f 01 38             	invlpg (%eax)
	kfree (va);
80105cb9:	89 34 24             	mov    %esi,(%esp)
80105cbc:	e8 bf c8 ff ff       	call   80102580 <kfree>
	cprintf("swap page from pte success\n");
80105cc1:	c7 45 08 10 7f 10 80 	movl   $0x80107f10,0x8(%ebp)
80105cc8:	83 c4 10             	add    $0x10,%esp
}
80105ccb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cce:	5b                   	pop    %ebx
80105ccf:	5e                   	pop    %esi
80105cd0:	5f                   	pop    %edi
80105cd1:	5d                   	pop    %ebp
	cprintf("swap page from pte success\n");
80105cd2:	e9 89 aa ff ff       	jmp    80100760 <cprintf>
80105cd7:	89 f6                	mov    %esi,%esi
80105cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ce0 <swap_page>:

/* Select a victim and swap the contents to the disk.
 */
int
swap_page(pde_t *pgdir)
{	
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	56                   	push   %esi
80105ce4:	53                   	push   %ebx
80105ce5:	8b 75 08             	mov    0x8(%ebp),%esi
  cprintf("Swap page\n");
80105ce8:	83 ec 0c             	sub    $0xc,%esp
80105ceb:	68 2c 7f 10 80       	push   $0x80107f2c
80105cf0:	e8 6b aa ff ff       	call   80100760 <cprintf>
	pte_t* p=select_a_victim(pgdir);
80105cf5:	89 34 24             	mov    %esi,(%esp)
80105cf8:	e8 73 15 00 00       	call   80107270 <select_a_victim>
  cprintf("%d\n",p);
80105cfd:	59                   	pop    %ecx
80105cfe:	5a                   	pop    %edx
80105cff:	50                   	push   %eax
80105d00:	68 20 80 10 80       	push   $0x80108020
	pte_t* p=select_a_victim(pgdir);
80105d05:	89 c3                	mov    %eax,%ebx
  cprintf("%d\n",p);
80105d07:	e8 54 aa ff ff       	call   80100760 <cprintf>
  cprintf("%d\n",*p);
80105d0c:	59                   	pop    %ecx
80105d0d:	58                   	pop    %eax
80105d0e:	ff 33                	pushl  (%ebx)
80105d10:	68 20 80 10 80       	push   $0x80108020
80105d15:	e8 46 aa ff ff       	call   80100760 <cprintf>

	if(*p==0){
80105d1a:	8b 03                	mov    (%ebx),%eax
80105d1c:	83 c4 10             	add    $0x10,%esp
80105d1f:	85 c0                	test   %eax,%eax
80105d21:	75 24                	jne    80105d47 <swap_page+0x67>
		cprintf("here2");
80105d23:	83 ec 0c             	sub    $0xc,%esp
80105d26:	68 37 7f 10 80       	push   $0x80107f37
80105d2b:	e8 30 aa ff ff       	call   80100760 <cprintf>
		clearaccessbit(pgdir);
80105d30:	89 34 24             	mov    %esi,(%esp)
80105d33:	e8 e8 15 00 00       	call   80107320 <clearaccessbit>
		p=select_a_victim(pgdir);
80105d38:	89 34 24             	mov    %esi,(%esp)
80105d3b:	e8 30 15 00 00       	call   80107270 <select_a_victim>
80105d40:	89 c3                	mov    %eax,%ebx
80105d42:	8b 00                	mov    (%eax),%eax
80105d44:	83 c4 10             	add    $0x10,%esp
		//cprintf("getting victim");
	}
	cprintf("%d\n",*p);
80105d47:	83 ec 08             	sub    $0x8,%esp
80105d4a:	50                   	push   %eax
80105d4b:	68 20 80 10 80       	push   $0x80108020
80105d50:	e8 0b aa ff ff       	call   80100760 <cprintf>
	swap_page_from_pte(p);
80105d55:	89 1c 24             	mov    %ebx,(%esp)
80105d58:	e8 b3 fe ff ff       	call   80105c10 <swap_page_from_pte>
   cprintf("new value %d\n",*p);
80105d5d:	58                   	pop    %eax
80105d5e:	5a                   	pop    %edx
80105d5f:	ff 33                	pushl  (%ebx)
80105d61:	68 3d 7f 10 80       	push   $0x80107f3d
80105d66:	e8 f5 a9 ff ff       	call   80100760 <cprintf>
 cprintf("Swap page end\n");
80105d6b:	c7 04 24 4b 7f 10 80 	movl   $0x80107f4b,(%esp)
80105d72:	e8 e9 a9 ff ff       	call   80100760 <cprintf>
	//panic("swap_page is not implemented");
	return 1;
}
80105d77:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d7a:	b8 01 00 00 00       	mov    $0x1,%eax
80105d7f:	5b                   	pop    %ebx
80105d80:	5e                   	pop    %esi
80105d81:	5d                   	pop    %ebp
80105d82:	c3                   	ret    
80105d83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d90 <map_address>:
 * restore the content of the page from the swapped
 * block and free the swapped block.
 */
void
map_address(pde_t *pgdir, uint addr)
{	
80105d90:	55                   	push   %ebp
80105d91:	89 e5                	mov    %esp,%ebp
80105d93:	57                   	push   %edi
80105d94:	56                   	push   %esi
80105d95:	53                   	push   %ebx
80105d96:	83 ec 30             	sub    $0x30,%esp
80105d99:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80105d9c:	8b 7d 08             	mov    0x8(%ebp),%edi
	
//  struct proc *curproc=myproc();
 
  int ret=allocuvm(pgdir, addr, addr+PGSIZE);
80105d9f:	8d b3 00 10 00 00    	lea    0x1000(%ebx),%esi
80105da5:	56                   	push   %esi
80105da6:	53                   	push   %ebx
80105da7:	57                   	push   %edi
80105da8:	e8 73 12 00 00       	call   80107020 <allocuvm>
  if(ret==0){
80105dad:	83 c4 10             	add    $0x10,%esp
80105db0:	85 c0                	test   %eax,%eax
80105db2:	74 0c                	je     80105dc0 <map_address+0x30>
  // if blk was not -1, read_page_from_disk
 
  
  // bfree_page
  //panic("map_address is not implemented");
}
80105db4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105db7:	5b                   	pop    %ebx
80105db8:	5e                   	pop    %esi
80105db9:	5f                   	pop    %edi
80105dba:	5d                   	pop    %ebp
80105dbb:	c3                   	ret    
80105dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    swap_page(pgdir);
80105dc0:	83 ec 0c             	sub    $0xc,%esp
80105dc3:	57                   	push   %edi
80105dc4:	e8 17 ff ff ff       	call   80105ce0 <swap_page>
    cprintf("2c\n");
80105dc9:	c7 04 24 5a 7f 10 80 	movl   $0x80107f5a,(%esp)
80105dd0:	e8 8b a9 ff ff       	call   80100760 <cprintf>
  pde = &pgdir[PDX(va)];    
80105dd5:	89 d8                	mov    %ebx,%eax
  if(*pde & PTE_P){
80105dd7:	83 c4 10             	add    $0x10,%esp
  pde = &pgdir[PDX(va)];    
80105dda:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80105ddd:	8b 04 87             	mov    (%edi,%eax,4),%eax
80105de0:	a8 01                	test   $0x1,%al
80105de2:	0f 84 f8 00 00 00    	je     80105ee0 <map_address+0x150>
  return &pgtab[PTX(va)];
80105de8:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80105dea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80105def:	c1 ea 0c             	shr    $0xc,%edx
80105df2:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
    if(*p==0){
80105df8:	8b 84 90 00 00 00 80 	mov    -0x80000000(%eax,%edx,4),%eax
80105dff:	85 c0                	test   %eax,%eax
80105e01:	0f 84 e9 00 00 00    	je     80105ef0 <map_address+0x160>
      int blk=getswappedblk(pgdir, addr);
80105e07:	83 ec 08             	sub    $0x8,%esp
80105e0a:	53                   	push   %ebx
80105e0b:	57                   	push   %edi
80105e0c:	e8 4f 15 00 00       	call   80107360 <getswappedblk>
80105e11:	89 45 d4             	mov    %eax,-0x2c(%ebp)
      char* mem=kalloc();
80105e14:	e8 17 c9 ff ff       	call   80102730 <kalloc>
      read_page_from_disk(ROOTDEV, mem, blk);
80105e19:	83 c4 0c             	add    $0xc,%esp
80105e1c:	ff 75 d4             	pushl  -0x2c(%ebp)
      char* mem=kalloc();
80105e1f:	89 c6                	mov    %eax,%esi
      read_page_from_disk(ROOTDEV, mem, blk);
80105e21:	50                   	push   %eax
80105e22:	6a 01                	push   $0x1
80105e24:	e8 d7 a4 ff ff       	call   80100300 <read_page_from_disk>
  a = (char*)PGROUNDDOWN((uint)va);
80105e29:	89 da                	mov    %ebx,%edx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80105e2b:	81 c3 ff 0f 00 00    	add    $0xfff,%ebx
80105e31:	89 7d e0             	mov    %edi,-0x20(%ebp)
  a = (char*)PGROUNDDOWN((uint)va);
80105e34:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80105e3a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80105e40:	83 c4 10             	add    $0x10,%esp
80105e43:	29 d6                	sub    %edx,%esi
80105e45:	89 5d dc             	mov    %ebx,-0x24(%ebp)
80105e48:	89 d7                	mov    %edx,%edi
80105e4a:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80105e50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105e53:	eb 3e                	jmp    80105e93 <map_address+0x103>
80105e55:	8d 76 00             	lea    0x0(%esi),%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80105e58:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80105e5e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
  return &pgtab[PTX(va)];
80105e64:	89 f8                	mov    %edi,%eax
80105e66:	c1 e8 0a             	shr    $0xa,%eax
80105e69:	25 fc 0f 00 00       	and    $0xffc,%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105e6e:	01 c3                	add    %eax,%ebx
80105e70:	0f 84 9a 00 00 00    	je     80105f10 <map_address+0x180>
    if(*pte & PTE_P)
80105e76:	f6 03 01             	testb  $0x1,(%ebx)
80105e79:	0f 85 aa 00 00 00    	jne    80105f29 <map_address+0x199>
    *pte = pa | perm | PTE_P;
80105e7f:	83 ce 07             	or     $0x7,%esi
    if(a == last)
80105e82:	39 7d dc             	cmp    %edi,-0x24(%ebp)
    *pte = pa | perm | PTE_P;
80105e85:	89 33                	mov    %esi,(%ebx)
    if(a == last)
80105e87:	0f 84 83 00 00 00    	je     80105f10 <map_address+0x180>
    a += PGSIZE;
80105e8d:	81 c7 00 10 00 00    	add    $0x1000,%edi
80105e93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];    
80105e96:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105e99:	8d 34 38             	lea    (%eax,%edi,1),%esi
80105e9c:	89 f8                	mov    %edi,%eax
80105e9e:	c1 e8 16             	shr    $0x16,%eax
80105ea1:	8d 0c 82             	lea    (%edx,%eax,4),%ecx
  if(*pde & PTE_P){
80105ea4:	8b 19                	mov    (%ecx),%ebx
80105ea6:	f6 c3 01             	test   $0x1,%bl
80105ea9:	75 ad                	jne    80105e58 <map_address+0xc8>
80105eab:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80105eae:	e8 7d c8 ff ff       	call   80102730 <kalloc>
80105eb3:	85 c0                	test   %eax,%eax
80105eb5:	89 c3                	mov    %eax,%ebx
80105eb7:	74 57                	je     80105f10 <map_address+0x180>
    memset(pgtab, 0, PGSIZE);
80105eb9:	83 ec 04             	sub    $0x4,%esp
80105ebc:	68 00 10 00 00       	push   $0x1000
80105ec1:	6a 00                	push   $0x0
80105ec3:	50                   	push   %eax
80105ec4:	e8 d7 e7 ff ff       	call   801046a0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80105ec9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80105ecf:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ed2:	83 c4 10             	add    $0x10,%esp
80105ed5:	83 c8 07             	or     $0x7,%eax
80105ed8:	89 01                	mov    %eax,(%ecx)
80105eda:	eb 88                	jmp    80105e64 <map_address+0xd4>
80105edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*p==0){
80105ee0:	a1 00 00 00 00       	mov    0x0,%eax
80105ee5:	0f 0b                	ud2    
80105ee7:	89 f6                	mov    %esi,%esi
80105ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      allocuvm(pgdir, addr, addr+PGSIZE);
80105ef0:	83 ec 04             	sub    $0x4,%esp
80105ef3:	56                   	push   %esi
80105ef4:	53                   	push   %ebx
80105ef5:	57                   	push   %edi
80105ef6:	e8 25 11 00 00       	call   80107020 <allocuvm>
80105efb:	83 c4 10             	add    $0x10,%esp
}
80105efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f01:	5b                   	pop    %ebx
80105f02:	5e                   	pop    %esi
80105f03:	5f                   	pop    %edi
80105f04:	5d                   	pop    %ebp
80105f05:	c3                   	ret    
80105f06:	8d 76 00             	lea    0x0(%esi),%esi
80105f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      bfree_page(ROOTDEV,blk);
80105f10:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105f13:	c7 45 08 01 00 00 00 	movl   $0x1,0x8(%ebp)
80105f1a:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80105f1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f20:	5b                   	pop    %ebx
80105f21:	5e                   	pop    %esi
80105f22:	5f                   	pop    %edi
80105f23:	5d                   	pop    %ebp
      bfree_page(ROOTDEV,blk);
80105f24:	e9 97 b7 ff ff       	jmp    801016c0 <bfree_page>
      panic("remap");
80105f29:	83 ec 0c             	sub    $0xc,%esp
80105f2c:	68 5e 7f 10 80       	push   $0x80107f5e
80105f31:	e8 5a a5 ff ff       	call   80100490 <panic>
80105f36:	8d 76 00             	lea    0x0(%esi),%esi
80105f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f40 <handle_pgfault>:

/* page fault handler */
void
handle_pgfault()
{
80105f40:	55                   	push   %ebp
80105f41:	89 e5                	mov    %esp,%ebp
80105f43:	83 ec 08             	sub    $0x8,%esp
	unsigned addr;
	struct proc *curproc = myproc();
80105f46:	e8 05 db ff ff       	call   80103a50 <myproc>

	asm volatile ("movl %%cr2, %0 \n\t" : "=r" (addr));
80105f4b:	0f 20 d2             	mov    %cr2,%edx
	addr &= ~0xfff;
	map_address(curproc->pgdir, addr);
80105f4e:	83 ec 08             	sub    $0x8,%esp
	addr &= ~0xfff;
80105f51:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	map_address(curproc->pgdir, addr);
80105f57:	52                   	push   %edx
80105f58:	ff 70 04             	pushl  0x4(%eax)
80105f5b:	e8 30 fe ff ff       	call   80105d90 <map_address>
}
80105f60:	83 c4 10             	add    $0x10,%esp
80105f63:	c9                   	leave  
80105f64:	c3                   	ret    
80105f65:	66 90                	xchg   %ax,%ax
80105f67:	66 90                	xchg   %ax,%ax
80105f69:	66 90                	xchg   %ax,%ax
80105f6b:	66 90                	xchg   %ax,%ax
80105f6d:	66 90                	xchg   %ax,%ax
80105f6f:	90                   	nop

80105f70 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105f70:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
80105f75:	55                   	push   %ebp
80105f76:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105f78:	85 c0                	test   %eax,%eax
80105f7a:	74 1c                	je     80105f98 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f7c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f81:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105f82:	a8 01                	test   $0x1,%al
80105f84:	74 12                	je     80105f98 <uartgetc+0x28>
80105f86:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f8b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105f8c:	0f b6 c0             	movzbl %al,%eax
}
80105f8f:	5d                   	pop    %ebp
80105f90:	c3                   	ret    
80105f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105f98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f9d:	5d                   	pop    %ebp
80105f9e:	c3                   	ret    
80105f9f:	90                   	nop

80105fa0 <uartputc.part.0>:
uartputc(int c)
80105fa0:	55                   	push   %ebp
80105fa1:	89 e5                	mov    %esp,%ebp
80105fa3:	57                   	push   %edi
80105fa4:	56                   	push   %esi
80105fa5:	53                   	push   %ebx
80105fa6:	89 c7                	mov    %eax,%edi
80105fa8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105fad:	be fd 03 00 00       	mov    $0x3fd,%esi
80105fb2:	83 ec 0c             	sub    $0xc,%esp
80105fb5:	eb 1b                	jmp    80105fd2 <uartputc.part.0+0x32>
80105fb7:	89 f6                	mov    %esi,%esi
80105fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105fc0:	83 ec 0c             	sub    $0xc,%esp
80105fc3:	6a 0a                	push   $0xa
80105fc5:	e8 16 ca ff ff       	call   801029e0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105fca:	83 c4 10             	add    $0x10,%esp
80105fcd:	83 eb 01             	sub    $0x1,%ebx
80105fd0:	74 07                	je     80105fd9 <uartputc.part.0+0x39>
80105fd2:	89 f2                	mov    %esi,%edx
80105fd4:	ec                   	in     (%dx),%al
80105fd5:	a8 20                	test   $0x20,%al
80105fd7:	74 e7                	je     80105fc0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105fd9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fde:	89 f8                	mov    %edi,%eax
80105fe0:	ee                   	out    %al,(%dx)
}
80105fe1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fe4:	5b                   	pop    %ebx
80105fe5:	5e                   	pop    %esi
80105fe6:	5f                   	pop    %edi
80105fe7:	5d                   	pop    %ebp
80105fe8:	c3                   	ret    
80105fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ff0 <uartinit>:
{
80105ff0:	55                   	push   %ebp
80105ff1:	31 c9                	xor    %ecx,%ecx
80105ff3:	89 c8                	mov    %ecx,%eax
80105ff5:	89 e5                	mov    %esp,%ebp
80105ff7:	57                   	push   %edi
80105ff8:	56                   	push   %esi
80105ff9:	53                   	push   %ebx
80105ffa:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105fff:	89 da                	mov    %ebx,%edx
80106001:	83 ec 0c             	sub    $0xc,%esp
80106004:	ee                   	out    %al,(%dx)
80106005:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010600a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010600f:	89 fa                	mov    %edi,%edx
80106011:	ee                   	out    %al,(%dx)
80106012:	b8 0c 00 00 00       	mov    $0xc,%eax
80106017:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010601c:	ee                   	out    %al,(%dx)
8010601d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106022:	89 c8                	mov    %ecx,%eax
80106024:	89 f2                	mov    %esi,%edx
80106026:	ee                   	out    %al,(%dx)
80106027:	b8 03 00 00 00       	mov    $0x3,%eax
8010602c:	89 fa                	mov    %edi,%edx
8010602e:	ee                   	out    %al,(%dx)
8010602f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106034:	89 c8                	mov    %ecx,%eax
80106036:	ee                   	out    %al,(%dx)
80106037:	b8 01 00 00 00       	mov    $0x1,%eax
8010603c:	89 f2                	mov    %esi,%edx
8010603e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010603f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106044:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106045:	3c ff                	cmp    $0xff,%al
80106047:	74 5a                	je     801060a3 <uartinit+0xb3>
  uart = 1;
80106049:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106050:	00 00 00 
80106053:	89 da                	mov    %ebx,%edx
80106055:	ec                   	in     (%dx),%al
80106056:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010605b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010605c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010605f:	bb 64 7f 10 80       	mov    $0x80107f64,%ebx
  ioapicenable(IRQ_COM1, 0);
80106064:	6a 00                	push   $0x0
80106066:	6a 04                	push   $0x4
80106068:	e8 d3 c4 ff ff       	call   80102540 <ioapicenable>
8010606d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106070:	b8 78 00 00 00       	mov    $0x78,%eax
80106075:	eb 13                	jmp    8010608a <uartinit+0x9a>
80106077:	89 f6                	mov    %esi,%esi
80106079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106080:	83 c3 01             	add    $0x1,%ebx
80106083:	0f be 03             	movsbl (%ebx),%eax
80106086:	84 c0                	test   %al,%al
80106088:	74 19                	je     801060a3 <uartinit+0xb3>
  if(!uart)
8010608a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106090:	85 d2                	test   %edx,%edx
80106092:	74 ec                	je     80106080 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106094:	83 c3 01             	add    $0x1,%ebx
80106097:	e8 04 ff ff ff       	call   80105fa0 <uartputc.part.0>
8010609c:	0f be 03             	movsbl (%ebx),%eax
8010609f:	84 c0                	test   %al,%al
801060a1:	75 e7                	jne    8010608a <uartinit+0x9a>
}
801060a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060a6:	5b                   	pop    %ebx
801060a7:	5e                   	pop    %esi
801060a8:	5f                   	pop    %edi
801060a9:	5d                   	pop    %ebp
801060aa:	c3                   	ret    
801060ab:	90                   	nop
801060ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060b0 <uartputc>:
  if(!uart)
801060b0:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
801060b6:	55                   	push   %ebp
801060b7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801060b9:	85 d2                	test   %edx,%edx
{
801060bb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801060be:	74 10                	je     801060d0 <uartputc+0x20>
}
801060c0:	5d                   	pop    %ebp
801060c1:	e9 da fe ff ff       	jmp    80105fa0 <uartputc.part.0>
801060c6:	8d 76 00             	lea    0x0(%esi),%esi
801060c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801060d0:	5d                   	pop    %ebp
801060d1:	c3                   	ret    
801060d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801060e0 <uartintr>:

void
uartintr(void)
{
801060e0:	55                   	push   %ebp
801060e1:	89 e5                	mov    %esp,%ebp
801060e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801060e6:	68 70 5f 10 80       	push   $0x80105f70
801060eb:	e8 20 a8 ff ff       	call   80100910 <consoleintr>
}
801060f0:	83 c4 10             	add    $0x10,%esp
801060f3:	c9                   	leave  
801060f4:	c3                   	ret    

801060f5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801060f5:	6a 00                	push   $0x0
  pushl $0
801060f7:	6a 00                	push   $0x0
  jmp alltraps
801060f9:	e9 cc f7 ff ff       	jmp    801058ca <alltraps>

801060fe <vector1>:
.globl vector1
vector1:
  pushl $0
801060fe:	6a 00                	push   $0x0
  pushl $1
80106100:	6a 01                	push   $0x1
  jmp alltraps
80106102:	e9 c3 f7 ff ff       	jmp    801058ca <alltraps>

80106107 <vector2>:
.globl vector2
vector2:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $2
80106109:	6a 02                	push   $0x2
  jmp alltraps
8010610b:	e9 ba f7 ff ff       	jmp    801058ca <alltraps>

80106110 <vector3>:
.globl vector3
vector3:
  pushl $0
80106110:	6a 00                	push   $0x0
  pushl $3
80106112:	6a 03                	push   $0x3
  jmp alltraps
80106114:	e9 b1 f7 ff ff       	jmp    801058ca <alltraps>

80106119 <vector4>:
.globl vector4
vector4:
  pushl $0
80106119:	6a 00                	push   $0x0
  pushl $4
8010611b:	6a 04                	push   $0x4
  jmp alltraps
8010611d:	e9 a8 f7 ff ff       	jmp    801058ca <alltraps>

80106122 <vector5>:
.globl vector5
vector5:
  pushl $0
80106122:	6a 00                	push   $0x0
  pushl $5
80106124:	6a 05                	push   $0x5
  jmp alltraps
80106126:	e9 9f f7 ff ff       	jmp    801058ca <alltraps>

8010612b <vector6>:
.globl vector6
vector6:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $6
8010612d:	6a 06                	push   $0x6
  jmp alltraps
8010612f:	e9 96 f7 ff ff       	jmp    801058ca <alltraps>

80106134 <vector7>:
.globl vector7
vector7:
  pushl $0
80106134:	6a 00                	push   $0x0
  pushl $7
80106136:	6a 07                	push   $0x7
  jmp alltraps
80106138:	e9 8d f7 ff ff       	jmp    801058ca <alltraps>

8010613d <vector8>:
.globl vector8
vector8:
  pushl $8
8010613d:	6a 08                	push   $0x8
  jmp alltraps
8010613f:	e9 86 f7 ff ff       	jmp    801058ca <alltraps>

80106144 <vector9>:
.globl vector9
vector9:
  pushl $0
80106144:	6a 00                	push   $0x0
  pushl $9
80106146:	6a 09                	push   $0x9
  jmp alltraps
80106148:	e9 7d f7 ff ff       	jmp    801058ca <alltraps>

8010614d <vector10>:
.globl vector10
vector10:
  pushl $10
8010614d:	6a 0a                	push   $0xa
  jmp alltraps
8010614f:	e9 76 f7 ff ff       	jmp    801058ca <alltraps>

80106154 <vector11>:
.globl vector11
vector11:
  pushl $11
80106154:	6a 0b                	push   $0xb
  jmp alltraps
80106156:	e9 6f f7 ff ff       	jmp    801058ca <alltraps>

8010615b <vector12>:
.globl vector12
vector12:
  pushl $12
8010615b:	6a 0c                	push   $0xc
  jmp alltraps
8010615d:	e9 68 f7 ff ff       	jmp    801058ca <alltraps>

80106162 <vector13>:
.globl vector13
vector13:
  pushl $13
80106162:	6a 0d                	push   $0xd
  jmp alltraps
80106164:	e9 61 f7 ff ff       	jmp    801058ca <alltraps>

80106169 <vector14>:
.globl vector14
vector14:
  pushl $14
80106169:	6a 0e                	push   $0xe
  jmp alltraps
8010616b:	e9 5a f7 ff ff       	jmp    801058ca <alltraps>

80106170 <vector15>:
.globl vector15
vector15:
  pushl $0
80106170:	6a 00                	push   $0x0
  pushl $15
80106172:	6a 0f                	push   $0xf
  jmp alltraps
80106174:	e9 51 f7 ff ff       	jmp    801058ca <alltraps>

80106179 <vector16>:
.globl vector16
vector16:
  pushl $0
80106179:	6a 00                	push   $0x0
  pushl $16
8010617b:	6a 10                	push   $0x10
  jmp alltraps
8010617d:	e9 48 f7 ff ff       	jmp    801058ca <alltraps>

80106182 <vector17>:
.globl vector17
vector17:
  pushl $17
80106182:	6a 11                	push   $0x11
  jmp alltraps
80106184:	e9 41 f7 ff ff       	jmp    801058ca <alltraps>

80106189 <vector18>:
.globl vector18
vector18:
  pushl $0
80106189:	6a 00                	push   $0x0
  pushl $18
8010618b:	6a 12                	push   $0x12
  jmp alltraps
8010618d:	e9 38 f7 ff ff       	jmp    801058ca <alltraps>

80106192 <vector19>:
.globl vector19
vector19:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $19
80106194:	6a 13                	push   $0x13
  jmp alltraps
80106196:	e9 2f f7 ff ff       	jmp    801058ca <alltraps>

8010619b <vector20>:
.globl vector20
vector20:
  pushl $0
8010619b:	6a 00                	push   $0x0
  pushl $20
8010619d:	6a 14                	push   $0x14
  jmp alltraps
8010619f:	e9 26 f7 ff ff       	jmp    801058ca <alltraps>

801061a4 <vector21>:
.globl vector21
vector21:
  pushl $0
801061a4:	6a 00                	push   $0x0
  pushl $21
801061a6:	6a 15                	push   $0x15
  jmp alltraps
801061a8:	e9 1d f7 ff ff       	jmp    801058ca <alltraps>

801061ad <vector22>:
.globl vector22
vector22:
  pushl $0
801061ad:	6a 00                	push   $0x0
  pushl $22
801061af:	6a 16                	push   $0x16
  jmp alltraps
801061b1:	e9 14 f7 ff ff       	jmp    801058ca <alltraps>

801061b6 <vector23>:
.globl vector23
vector23:
  pushl $0
801061b6:	6a 00                	push   $0x0
  pushl $23
801061b8:	6a 17                	push   $0x17
  jmp alltraps
801061ba:	e9 0b f7 ff ff       	jmp    801058ca <alltraps>

801061bf <vector24>:
.globl vector24
vector24:
  pushl $0
801061bf:	6a 00                	push   $0x0
  pushl $24
801061c1:	6a 18                	push   $0x18
  jmp alltraps
801061c3:	e9 02 f7 ff ff       	jmp    801058ca <alltraps>

801061c8 <vector25>:
.globl vector25
vector25:
  pushl $0
801061c8:	6a 00                	push   $0x0
  pushl $25
801061ca:	6a 19                	push   $0x19
  jmp alltraps
801061cc:	e9 f9 f6 ff ff       	jmp    801058ca <alltraps>

801061d1 <vector26>:
.globl vector26
vector26:
  pushl $0
801061d1:	6a 00                	push   $0x0
  pushl $26
801061d3:	6a 1a                	push   $0x1a
  jmp alltraps
801061d5:	e9 f0 f6 ff ff       	jmp    801058ca <alltraps>

801061da <vector27>:
.globl vector27
vector27:
  pushl $0
801061da:	6a 00                	push   $0x0
  pushl $27
801061dc:	6a 1b                	push   $0x1b
  jmp alltraps
801061de:	e9 e7 f6 ff ff       	jmp    801058ca <alltraps>

801061e3 <vector28>:
.globl vector28
vector28:
  pushl $0
801061e3:	6a 00                	push   $0x0
  pushl $28
801061e5:	6a 1c                	push   $0x1c
  jmp alltraps
801061e7:	e9 de f6 ff ff       	jmp    801058ca <alltraps>

801061ec <vector29>:
.globl vector29
vector29:
  pushl $0
801061ec:	6a 00                	push   $0x0
  pushl $29
801061ee:	6a 1d                	push   $0x1d
  jmp alltraps
801061f0:	e9 d5 f6 ff ff       	jmp    801058ca <alltraps>

801061f5 <vector30>:
.globl vector30
vector30:
  pushl $0
801061f5:	6a 00                	push   $0x0
  pushl $30
801061f7:	6a 1e                	push   $0x1e
  jmp alltraps
801061f9:	e9 cc f6 ff ff       	jmp    801058ca <alltraps>

801061fe <vector31>:
.globl vector31
vector31:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $31
80106200:	6a 1f                	push   $0x1f
  jmp alltraps
80106202:	e9 c3 f6 ff ff       	jmp    801058ca <alltraps>

80106207 <vector32>:
.globl vector32
vector32:
  pushl $0
80106207:	6a 00                	push   $0x0
  pushl $32
80106209:	6a 20                	push   $0x20
  jmp alltraps
8010620b:	e9 ba f6 ff ff       	jmp    801058ca <alltraps>

80106210 <vector33>:
.globl vector33
vector33:
  pushl $0
80106210:	6a 00                	push   $0x0
  pushl $33
80106212:	6a 21                	push   $0x21
  jmp alltraps
80106214:	e9 b1 f6 ff ff       	jmp    801058ca <alltraps>

80106219 <vector34>:
.globl vector34
vector34:
  pushl $0
80106219:	6a 00                	push   $0x0
  pushl $34
8010621b:	6a 22                	push   $0x22
  jmp alltraps
8010621d:	e9 a8 f6 ff ff       	jmp    801058ca <alltraps>

80106222 <vector35>:
.globl vector35
vector35:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $35
80106224:	6a 23                	push   $0x23
  jmp alltraps
80106226:	e9 9f f6 ff ff       	jmp    801058ca <alltraps>

8010622b <vector36>:
.globl vector36
vector36:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $36
8010622d:	6a 24                	push   $0x24
  jmp alltraps
8010622f:	e9 96 f6 ff ff       	jmp    801058ca <alltraps>

80106234 <vector37>:
.globl vector37
vector37:
  pushl $0
80106234:	6a 00                	push   $0x0
  pushl $37
80106236:	6a 25                	push   $0x25
  jmp alltraps
80106238:	e9 8d f6 ff ff       	jmp    801058ca <alltraps>

8010623d <vector38>:
.globl vector38
vector38:
  pushl $0
8010623d:	6a 00                	push   $0x0
  pushl $38
8010623f:	6a 26                	push   $0x26
  jmp alltraps
80106241:	e9 84 f6 ff ff       	jmp    801058ca <alltraps>

80106246 <vector39>:
.globl vector39
vector39:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $39
80106248:	6a 27                	push   $0x27
  jmp alltraps
8010624a:	e9 7b f6 ff ff       	jmp    801058ca <alltraps>

8010624f <vector40>:
.globl vector40
vector40:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $40
80106251:	6a 28                	push   $0x28
  jmp alltraps
80106253:	e9 72 f6 ff ff       	jmp    801058ca <alltraps>

80106258 <vector41>:
.globl vector41
vector41:
  pushl $0
80106258:	6a 00                	push   $0x0
  pushl $41
8010625a:	6a 29                	push   $0x29
  jmp alltraps
8010625c:	e9 69 f6 ff ff       	jmp    801058ca <alltraps>

80106261 <vector42>:
.globl vector42
vector42:
  pushl $0
80106261:	6a 00                	push   $0x0
  pushl $42
80106263:	6a 2a                	push   $0x2a
  jmp alltraps
80106265:	e9 60 f6 ff ff       	jmp    801058ca <alltraps>

8010626a <vector43>:
.globl vector43
vector43:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $43
8010626c:	6a 2b                	push   $0x2b
  jmp alltraps
8010626e:	e9 57 f6 ff ff       	jmp    801058ca <alltraps>

80106273 <vector44>:
.globl vector44
vector44:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $44
80106275:	6a 2c                	push   $0x2c
  jmp alltraps
80106277:	e9 4e f6 ff ff       	jmp    801058ca <alltraps>

8010627c <vector45>:
.globl vector45
vector45:
  pushl $0
8010627c:	6a 00                	push   $0x0
  pushl $45
8010627e:	6a 2d                	push   $0x2d
  jmp alltraps
80106280:	e9 45 f6 ff ff       	jmp    801058ca <alltraps>

80106285 <vector46>:
.globl vector46
vector46:
  pushl $0
80106285:	6a 00                	push   $0x0
  pushl $46
80106287:	6a 2e                	push   $0x2e
  jmp alltraps
80106289:	e9 3c f6 ff ff       	jmp    801058ca <alltraps>

8010628e <vector47>:
.globl vector47
vector47:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $47
80106290:	6a 2f                	push   $0x2f
  jmp alltraps
80106292:	e9 33 f6 ff ff       	jmp    801058ca <alltraps>

80106297 <vector48>:
.globl vector48
vector48:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $48
80106299:	6a 30                	push   $0x30
  jmp alltraps
8010629b:	e9 2a f6 ff ff       	jmp    801058ca <alltraps>

801062a0 <vector49>:
.globl vector49
vector49:
  pushl $0
801062a0:	6a 00                	push   $0x0
  pushl $49
801062a2:	6a 31                	push   $0x31
  jmp alltraps
801062a4:	e9 21 f6 ff ff       	jmp    801058ca <alltraps>

801062a9 <vector50>:
.globl vector50
vector50:
  pushl $0
801062a9:	6a 00                	push   $0x0
  pushl $50
801062ab:	6a 32                	push   $0x32
  jmp alltraps
801062ad:	e9 18 f6 ff ff       	jmp    801058ca <alltraps>

801062b2 <vector51>:
.globl vector51
vector51:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $51
801062b4:	6a 33                	push   $0x33
  jmp alltraps
801062b6:	e9 0f f6 ff ff       	jmp    801058ca <alltraps>

801062bb <vector52>:
.globl vector52
vector52:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $52
801062bd:	6a 34                	push   $0x34
  jmp alltraps
801062bf:	e9 06 f6 ff ff       	jmp    801058ca <alltraps>

801062c4 <vector53>:
.globl vector53
vector53:
  pushl $0
801062c4:	6a 00                	push   $0x0
  pushl $53
801062c6:	6a 35                	push   $0x35
  jmp alltraps
801062c8:	e9 fd f5 ff ff       	jmp    801058ca <alltraps>

801062cd <vector54>:
.globl vector54
vector54:
  pushl $0
801062cd:	6a 00                	push   $0x0
  pushl $54
801062cf:	6a 36                	push   $0x36
  jmp alltraps
801062d1:	e9 f4 f5 ff ff       	jmp    801058ca <alltraps>

801062d6 <vector55>:
.globl vector55
vector55:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $55
801062d8:	6a 37                	push   $0x37
  jmp alltraps
801062da:	e9 eb f5 ff ff       	jmp    801058ca <alltraps>

801062df <vector56>:
.globl vector56
vector56:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $56
801062e1:	6a 38                	push   $0x38
  jmp alltraps
801062e3:	e9 e2 f5 ff ff       	jmp    801058ca <alltraps>

801062e8 <vector57>:
.globl vector57
vector57:
  pushl $0
801062e8:	6a 00                	push   $0x0
  pushl $57
801062ea:	6a 39                	push   $0x39
  jmp alltraps
801062ec:	e9 d9 f5 ff ff       	jmp    801058ca <alltraps>

801062f1 <vector58>:
.globl vector58
vector58:
  pushl $0
801062f1:	6a 00                	push   $0x0
  pushl $58
801062f3:	6a 3a                	push   $0x3a
  jmp alltraps
801062f5:	e9 d0 f5 ff ff       	jmp    801058ca <alltraps>

801062fa <vector59>:
.globl vector59
vector59:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $59
801062fc:	6a 3b                	push   $0x3b
  jmp alltraps
801062fe:	e9 c7 f5 ff ff       	jmp    801058ca <alltraps>

80106303 <vector60>:
.globl vector60
vector60:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $60
80106305:	6a 3c                	push   $0x3c
  jmp alltraps
80106307:	e9 be f5 ff ff       	jmp    801058ca <alltraps>

8010630c <vector61>:
.globl vector61
vector61:
  pushl $0
8010630c:	6a 00                	push   $0x0
  pushl $61
8010630e:	6a 3d                	push   $0x3d
  jmp alltraps
80106310:	e9 b5 f5 ff ff       	jmp    801058ca <alltraps>

80106315 <vector62>:
.globl vector62
vector62:
  pushl $0
80106315:	6a 00                	push   $0x0
  pushl $62
80106317:	6a 3e                	push   $0x3e
  jmp alltraps
80106319:	e9 ac f5 ff ff       	jmp    801058ca <alltraps>

8010631e <vector63>:
.globl vector63
vector63:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $63
80106320:	6a 3f                	push   $0x3f
  jmp alltraps
80106322:	e9 a3 f5 ff ff       	jmp    801058ca <alltraps>

80106327 <vector64>:
.globl vector64
vector64:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $64
80106329:	6a 40                	push   $0x40
  jmp alltraps
8010632b:	e9 9a f5 ff ff       	jmp    801058ca <alltraps>

80106330 <vector65>:
.globl vector65
vector65:
  pushl $0
80106330:	6a 00                	push   $0x0
  pushl $65
80106332:	6a 41                	push   $0x41
  jmp alltraps
80106334:	e9 91 f5 ff ff       	jmp    801058ca <alltraps>

80106339 <vector66>:
.globl vector66
vector66:
  pushl $0
80106339:	6a 00                	push   $0x0
  pushl $66
8010633b:	6a 42                	push   $0x42
  jmp alltraps
8010633d:	e9 88 f5 ff ff       	jmp    801058ca <alltraps>

80106342 <vector67>:
.globl vector67
vector67:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $67
80106344:	6a 43                	push   $0x43
  jmp alltraps
80106346:	e9 7f f5 ff ff       	jmp    801058ca <alltraps>

8010634b <vector68>:
.globl vector68
vector68:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $68
8010634d:	6a 44                	push   $0x44
  jmp alltraps
8010634f:	e9 76 f5 ff ff       	jmp    801058ca <alltraps>

80106354 <vector69>:
.globl vector69
vector69:
  pushl $0
80106354:	6a 00                	push   $0x0
  pushl $69
80106356:	6a 45                	push   $0x45
  jmp alltraps
80106358:	e9 6d f5 ff ff       	jmp    801058ca <alltraps>

8010635d <vector70>:
.globl vector70
vector70:
  pushl $0
8010635d:	6a 00                	push   $0x0
  pushl $70
8010635f:	6a 46                	push   $0x46
  jmp alltraps
80106361:	e9 64 f5 ff ff       	jmp    801058ca <alltraps>

80106366 <vector71>:
.globl vector71
vector71:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $71
80106368:	6a 47                	push   $0x47
  jmp alltraps
8010636a:	e9 5b f5 ff ff       	jmp    801058ca <alltraps>

8010636f <vector72>:
.globl vector72
vector72:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $72
80106371:	6a 48                	push   $0x48
  jmp alltraps
80106373:	e9 52 f5 ff ff       	jmp    801058ca <alltraps>

80106378 <vector73>:
.globl vector73
vector73:
  pushl $0
80106378:	6a 00                	push   $0x0
  pushl $73
8010637a:	6a 49                	push   $0x49
  jmp alltraps
8010637c:	e9 49 f5 ff ff       	jmp    801058ca <alltraps>

80106381 <vector74>:
.globl vector74
vector74:
  pushl $0
80106381:	6a 00                	push   $0x0
  pushl $74
80106383:	6a 4a                	push   $0x4a
  jmp alltraps
80106385:	e9 40 f5 ff ff       	jmp    801058ca <alltraps>

8010638a <vector75>:
.globl vector75
vector75:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $75
8010638c:	6a 4b                	push   $0x4b
  jmp alltraps
8010638e:	e9 37 f5 ff ff       	jmp    801058ca <alltraps>

80106393 <vector76>:
.globl vector76
vector76:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $76
80106395:	6a 4c                	push   $0x4c
  jmp alltraps
80106397:	e9 2e f5 ff ff       	jmp    801058ca <alltraps>

8010639c <vector77>:
.globl vector77
vector77:
  pushl $0
8010639c:	6a 00                	push   $0x0
  pushl $77
8010639e:	6a 4d                	push   $0x4d
  jmp alltraps
801063a0:	e9 25 f5 ff ff       	jmp    801058ca <alltraps>

801063a5 <vector78>:
.globl vector78
vector78:
  pushl $0
801063a5:	6a 00                	push   $0x0
  pushl $78
801063a7:	6a 4e                	push   $0x4e
  jmp alltraps
801063a9:	e9 1c f5 ff ff       	jmp    801058ca <alltraps>

801063ae <vector79>:
.globl vector79
vector79:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $79
801063b0:	6a 4f                	push   $0x4f
  jmp alltraps
801063b2:	e9 13 f5 ff ff       	jmp    801058ca <alltraps>

801063b7 <vector80>:
.globl vector80
vector80:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $80
801063b9:	6a 50                	push   $0x50
  jmp alltraps
801063bb:	e9 0a f5 ff ff       	jmp    801058ca <alltraps>

801063c0 <vector81>:
.globl vector81
vector81:
  pushl $0
801063c0:	6a 00                	push   $0x0
  pushl $81
801063c2:	6a 51                	push   $0x51
  jmp alltraps
801063c4:	e9 01 f5 ff ff       	jmp    801058ca <alltraps>

801063c9 <vector82>:
.globl vector82
vector82:
  pushl $0
801063c9:	6a 00                	push   $0x0
  pushl $82
801063cb:	6a 52                	push   $0x52
  jmp alltraps
801063cd:	e9 f8 f4 ff ff       	jmp    801058ca <alltraps>

801063d2 <vector83>:
.globl vector83
vector83:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $83
801063d4:	6a 53                	push   $0x53
  jmp alltraps
801063d6:	e9 ef f4 ff ff       	jmp    801058ca <alltraps>

801063db <vector84>:
.globl vector84
vector84:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $84
801063dd:	6a 54                	push   $0x54
  jmp alltraps
801063df:	e9 e6 f4 ff ff       	jmp    801058ca <alltraps>

801063e4 <vector85>:
.globl vector85
vector85:
  pushl $0
801063e4:	6a 00                	push   $0x0
  pushl $85
801063e6:	6a 55                	push   $0x55
  jmp alltraps
801063e8:	e9 dd f4 ff ff       	jmp    801058ca <alltraps>

801063ed <vector86>:
.globl vector86
vector86:
  pushl $0
801063ed:	6a 00                	push   $0x0
  pushl $86
801063ef:	6a 56                	push   $0x56
  jmp alltraps
801063f1:	e9 d4 f4 ff ff       	jmp    801058ca <alltraps>

801063f6 <vector87>:
.globl vector87
vector87:
  pushl $0
801063f6:	6a 00                	push   $0x0
  pushl $87
801063f8:	6a 57                	push   $0x57
  jmp alltraps
801063fa:	e9 cb f4 ff ff       	jmp    801058ca <alltraps>

801063ff <vector88>:
.globl vector88
vector88:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $88
80106401:	6a 58                	push   $0x58
  jmp alltraps
80106403:	e9 c2 f4 ff ff       	jmp    801058ca <alltraps>

80106408 <vector89>:
.globl vector89
vector89:
  pushl $0
80106408:	6a 00                	push   $0x0
  pushl $89
8010640a:	6a 59                	push   $0x59
  jmp alltraps
8010640c:	e9 b9 f4 ff ff       	jmp    801058ca <alltraps>

80106411 <vector90>:
.globl vector90
vector90:
  pushl $0
80106411:	6a 00                	push   $0x0
  pushl $90
80106413:	6a 5a                	push   $0x5a
  jmp alltraps
80106415:	e9 b0 f4 ff ff       	jmp    801058ca <alltraps>

8010641a <vector91>:
.globl vector91
vector91:
  pushl $0
8010641a:	6a 00                	push   $0x0
  pushl $91
8010641c:	6a 5b                	push   $0x5b
  jmp alltraps
8010641e:	e9 a7 f4 ff ff       	jmp    801058ca <alltraps>

80106423 <vector92>:
.globl vector92
vector92:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $92
80106425:	6a 5c                	push   $0x5c
  jmp alltraps
80106427:	e9 9e f4 ff ff       	jmp    801058ca <alltraps>

8010642c <vector93>:
.globl vector93
vector93:
  pushl $0
8010642c:	6a 00                	push   $0x0
  pushl $93
8010642e:	6a 5d                	push   $0x5d
  jmp alltraps
80106430:	e9 95 f4 ff ff       	jmp    801058ca <alltraps>

80106435 <vector94>:
.globl vector94
vector94:
  pushl $0
80106435:	6a 00                	push   $0x0
  pushl $94
80106437:	6a 5e                	push   $0x5e
  jmp alltraps
80106439:	e9 8c f4 ff ff       	jmp    801058ca <alltraps>

8010643e <vector95>:
.globl vector95
vector95:
  pushl $0
8010643e:	6a 00                	push   $0x0
  pushl $95
80106440:	6a 5f                	push   $0x5f
  jmp alltraps
80106442:	e9 83 f4 ff ff       	jmp    801058ca <alltraps>

80106447 <vector96>:
.globl vector96
vector96:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $96
80106449:	6a 60                	push   $0x60
  jmp alltraps
8010644b:	e9 7a f4 ff ff       	jmp    801058ca <alltraps>

80106450 <vector97>:
.globl vector97
vector97:
  pushl $0
80106450:	6a 00                	push   $0x0
  pushl $97
80106452:	6a 61                	push   $0x61
  jmp alltraps
80106454:	e9 71 f4 ff ff       	jmp    801058ca <alltraps>

80106459 <vector98>:
.globl vector98
vector98:
  pushl $0
80106459:	6a 00                	push   $0x0
  pushl $98
8010645b:	6a 62                	push   $0x62
  jmp alltraps
8010645d:	e9 68 f4 ff ff       	jmp    801058ca <alltraps>

80106462 <vector99>:
.globl vector99
vector99:
  pushl $0
80106462:	6a 00                	push   $0x0
  pushl $99
80106464:	6a 63                	push   $0x63
  jmp alltraps
80106466:	e9 5f f4 ff ff       	jmp    801058ca <alltraps>

8010646b <vector100>:
.globl vector100
vector100:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $100
8010646d:	6a 64                	push   $0x64
  jmp alltraps
8010646f:	e9 56 f4 ff ff       	jmp    801058ca <alltraps>

80106474 <vector101>:
.globl vector101
vector101:
  pushl $0
80106474:	6a 00                	push   $0x0
  pushl $101
80106476:	6a 65                	push   $0x65
  jmp alltraps
80106478:	e9 4d f4 ff ff       	jmp    801058ca <alltraps>

8010647d <vector102>:
.globl vector102
vector102:
  pushl $0
8010647d:	6a 00                	push   $0x0
  pushl $102
8010647f:	6a 66                	push   $0x66
  jmp alltraps
80106481:	e9 44 f4 ff ff       	jmp    801058ca <alltraps>

80106486 <vector103>:
.globl vector103
vector103:
  pushl $0
80106486:	6a 00                	push   $0x0
  pushl $103
80106488:	6a 67                	push   $0x67
  jmp alltraps
8010648a:	e9 3b f4 ff ff       	jmp    801058ca <alltraps>

8010648f <vector104>:
.globl vector104
vector104:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $104
80106491:	6a 68                	push   $0x68
  jmp alltraps
80106493:	e9 32 f4 ff ff       	jmp    801058ca <alltraps>

80106498 <vector105>:
.globl vector105
vector105:
  pushl $0
80106498:	6a 00                	push   $0x0
  pushl $105
8010649a:	6a 69                	push   $0x69
  jmp alltraps
8010649c:	e9 29 f4 ff ff       	jmp    801058ca <alltraps>

801064a1 <vector106>:
.globl vector106
vector106:
  pushl $0
801064a1:	6a 00                	push   $0x0
  pushl $106
801064a3:	6a 6a                	push   $0x6a
  jmp alltraps
801064a5:	e9 20 f4 ff ff       	jmp    801058ca <alltraps>

801064aa <vector107>:
.globl vector107
vector107:
  pushl $0
801064aa:	6a 00                	push   $0x0
  pushl $107
801064ac:	6a 6b                	push   $0x6b
  jmp alltraps
801064ae:	e9 17 f4 ff ff       	jmp    801058ca <alltraps>

801064b3 <vector108>:
.globl vector108
vector108:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $108
801064b5:	6a 6c                	push   $0x6c
  jmp alltraps
801064b7:	e9 0e f4 ff ff       	jmp    801058ca <alltraps>

801064bc <vector109>:
.globl vector109
vector109:
  pushl $0
801064bc:	6a 00                	push   $0x0
  pushl $109
801064be:	6a 6d                	push   $0x6d
  jmp alltraps
801064c0:	e9 05 f4 ff ff       	jmp    801058ca <alltraps>

801064c5 <vector110>:
.globl vector110
vector110:
  pushl $0
801064c5:	6a 00                	push   $0x0
  pushl $110
801064c7:	6a 6e                	push   $0x6e
  jmp alltraps
801064c9:	e9 fc f3 ff ff       	jmp    801058ca <alltraps>

801064ce <vector111>:
.globl vector111
vector111:
  pushl $0
801064ce:	6a 00                	push   $0x0
  pushl $111
801064d0:	6a 6f                	push   $0x6f
  jmp alltraps
801064d2:	e9 f3 f3 ff ff       	jmp    801058ca <alltraps>

801064d7 <vector112>:
.globl vector112
vector112:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $112
801064d9:	6a 70                	push   $0x70
  jmp alltraps
801064db:	e9 ea f3 ff ff       	jmp    801058ca <alltraps>

801064e0 <vector113>:
.globl vector113
vector113:
  pushl $0
801064e0:	6a 00                	push   $0x0
  pushl $113
801064e2:	6a 71                	push   $0x71
  jmp alltraps
801064e4:	e9 e1 f3 ff ff       	jmp    801058ca <alltraps>

801064e9 <vector114>:
.globl vector114
vector114:
  pushl $0
801064e9:	6a 00                	push   $0x0
  pushl $114
801064eb:	6a 72                	push   $0x72
  jmp alltraps
801064ed:	e9 d8 f3 ff ff       	jmp    801058ca <alltraps>

801064f2 <vector115>:
.globl vector115
vector115:
  pushl $0
801064f2:	6a 00                	push   $0x0
  pushl $115
801064f4:	6a 73                	push   $0x73
  jmp alltraps
801064f6:	e9 cf f3 ff ff       	jmp    801058ca <alltraps>

801064fb <vector116>:
.globl vector116
vector116:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $116
801064fd:	6a 74                	push   $0x74
  jmp alltraps
801064ff:	e9 c6 f3 ff ff       	jmp    801058ca <alltraps>

80106504 <vector117>:
.globl vector117
vector117:
  pushl $0
80106504:	6a 00                	push   $0x0
  pushl $117
80106506:	6a 75                	push   $0x75
  jmp alltraps
80106508:	e9 bd f3 ff ff       	jmp    801058ca <alltraps>

8010650d <vector118>:
.globl vector118
vector118:
  pushl $0
8010650d:	6a 00                	push   $0x0
  pushl $118
8010650f:	6a 76                	push   $0x76
  jmp alltraps
80106511:	e9 b4 f3 ff ff       	jmp    801058ca <alltraps>

80106516 <vector119>:
.globl vector119
vector119:
  pushl $0
80106516:	6a 00                	push   $0x0
  pushl $119
80106518:	6a 77                	push   $0x77
  jmp alltraps
8010651a:	e9 ab f3 ff ff       	jmp    801058ca <alltraps>

8010651f <vector120>:
.globl vector120
vector120:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $120
80106521:	6a 78                	push   $0x78
  jmp alltraps
80106523:	e9 a2 f3 ff ff       	jmp    801058ca <alltraps>

80106528 <vector121>:
.globl vector121
vector121:
  pushl $0
80106528:	6a 00                	push   $0x0
  pushl $121
8010652a:	6a 79                	push   $0x79
  jmp alltraps
8010652c:	e9 99 f3 ff ff       	jmp    801058ca <alltraps>

80106531 <vector122>:
.globl vector122
vector122:
  pushl $0
80106531:	6a 00                	push   $0x0
  pushl $122
80106533:	6a 7a                	push   $0x7a
  jmp alltraps
80106535:	e9 90 f3 ff ff       	jmp    801058ca <alltraps>

8010653a <vector123>:
.globl vector123
vector123:
  pushl $0
8010653a:	6a 00                	push   $0x0
  pushl $123
8010653c:	6a 7b                	push   $0x7b
  jmp alltraps
8010653e:	e9 87 f3 ff ff       	jmp    801058ca <alltraps>

80106543 <vector124>:
.globl vector124
vector124:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $124
80106545:	6a 7c                	push   $0x7c
  jmp alltraps
80106547:	e9 7e f3 ff ff       	jmp    801058ca <alltraps>

8010654c <vector125>:
.globl vector125
vector125:
  pushl $0
8010654c:	6a 00                	push   $0x0
  pushl $125
8010654e:	6a 7d                	push   $0x7d
  jmp alltraps
80106550:	e9 75 f3 ff ff       	jmp    801058ca <alltraps>

80106555 <vector126>:
.globl vector126
vector126:
  pushl $0
80106555:	6a 00                	push   $0x0
  pushl $126
80106557:	6a 7e                	push   $0x7e
  jmp alltraps
80106559:	e9 6c f3 ff ff       	jmp    801058ca <alltraps>

8010655e <vector127>:
.globl vector127
vector127:
  pushl $0
8010655e:	6a 00                	push   $0x0
  pushl $127
80106560:	6a 7f                	push   $0x7f
  jmp alltraps
80106562:	e9 63 f3 ff ff       	jmp    801058ca <alltraps>

80106567 <vector128>:
.globl vector128
vector128:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $128
80106569:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010656e:	e9 57 f3 ff ff       	jmp    801058ca <alltraps>

80106573 <vector129>:
.globl vector129
vector129:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $129
80106575:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010657a:	e9 4b f3 ff ff       	jmp    801058ca <alltraps>

8010657f <vector130>:
.globl vector130
vector130:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $130
80106581:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106586:	e9 3f f3 ff ff       	jmp    801058ca <alltraps>

8010658b <vector131>:
.globl vector131
vector131:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $131
8010658d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106592:	e9 33 f3 ff ff       	jmp    801058ca <alltraps>

80106597 <vector132>:
.globl vector132
vector132:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $132
80106599:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010659e:	e9 27 f3 ff ff       	jmp    801058ca <alltraps>

801065a3 <vector133>:
.globl vector133
vector133:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $133
801065a5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801065aa:	e9 1b f3 ff ff       	jmp    801058ca <alltraps>

801065af <vector134>:
.globl vector134
vector134:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $134
801065b1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801065b6:	e9 0f f3 ff ff       	jmp    801058ca <alltraps>

801065bb <vector135>:
.globl vector135
vector135:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $135
801065bd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801065c2:	e9 03 f3 ff ff       	jmp    801058ca <alltraps>

801065c7 <vector136>:
.globl vector136
vector136:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $136
801065c9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801065ce:	e9 f7 f2 ff ff       	jmp    801058ca <alltraps>

801065d3 <vector137>:
.globl vector137
vector137:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $137
801065d5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801065da:	e9 eb f2 ff ff       	jmp    801058ca <alltraps>

801065df <vector138>:
.globl vector138
vector138:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $138
801065e1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801065e6:	e9 df f2 ff ff       	jmp    801058ca <alltraps>

801065eb <vector139>:
.globl vector139
vector139:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $139
801065ed:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801065f2:	e9 d3 f2 ff ff       	jmp    801058ca <alltraps>

801065f7 <vector140>:
.globl vector140
vector140:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $140
801065f9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801065fe:	e9 c7 f2 ff ff       	jmp    801058ca <alltraps>

80106603 <vector141>:
.globl vector141
vector141:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $141
80106605:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010660a:	e9 bb f2 ff ff       	jmp    801058ca <alltraps>

8010660f <vector142>:
.globl vector142
vector142:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $142
80106611:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106616:	e9 af f2 ff ff       	jmp    801058ca <alltraps>

8010661b <vector143>:
.globl vector143
vector143:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $143
8010661d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106622:	e9 a3 f2 ff ff       	jmp    801058ca <alltraps>

80106627 <vector144>:
.globl vector144
vector144:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $144
80106629:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010662e:	e9 97 f2 ff ff       	jmp    801058ca <alltraps>

80106633 <vector145>:
.globl vector145
vector145:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $145
80106635:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010663a:	e9 8b f2 ff ff       	jmp    801058ca <alltraps>

8010663f <vector146>:
.globl vector146
vector146:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $146
80106641:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106646:	e9 7f f2 ff ff       	jmp    801058ca <alltraps>

8010664b <vector147>:
.globl vector147
vector147:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $147
8010664d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106652:	e9 73 f2 ff ff       	jmp    801058ca <alltraps>

80106657 <vector148>:
.globl vector148
vector148:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $148
80106659:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010665e:	e9 67 f2 ff ff       	jmp    801058ca <alltraps>

80106663 <vector149>:
.globl vector149
vector149:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $149
80106665:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010666a:	e9 5b f2 ff ff       	jmp    801058ca <alltraps>

8010666f <vector150>:
.globl vector150
vector150:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $150
80106671:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106676:	e9 4f f2 ff ff       	jmp    801058ca <alltraps>

8010667b <vector151>:
.globl vector151
vector151:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $151
8010667d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106682:	e9 43 f2 ff ff       	jmp    801058ca <alltraps>

80106687 <vector152>:
.globl vector152
vector152:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $152
80106689:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010668e:	e9 37 f2 ff ff       	jmp    801058ca <alltraps>

80106693 <vector153>:
.globl vector153
vector153:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $153
80106695:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010669a:	e9 2b f2 ff ff       	jmp    801058ca <alltraps>

8010669f <vector154>:
.globl vector154
vector154:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $154
801066a1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801066a6:	e9 1f f2 ff ff       	jmp    801058ca <alltraps>

801066ab <vector155>:
.globl vector155
vector155:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $155
801066ad:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801066b2:	e9 13 f2 ff ff       	jmp    801058ca <alltraps>

801066b7 <vector156>:
.globl vector156
vector156:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $156
801066b9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801066be:	e9 07 f2 ff ff       	jmp    801058ca <alltraps>

801066c3 <vector157>:
.globl vector157
vector157:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $157
801066c5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801066ca:	e9 fb f1 ff ff       	jmp    801058ca <alltraps>

801066cf <vector158>:
.globl vector158
vector158:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $158
801066d1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801066d6:	e9 ef f1 ff ff       	jmp    801058ca <alltraps>

801066db <vector159>:
.globl vector159
vector159:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $159
801066dd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801066e2:	e9 e3 f1 ff ff       	jmp    801058ca <alltraps>

801066e7 <vector160>:
.globl vector160
vector160:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $160
801066e9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801066ee:	e9 d7 f1 ff ff       	jmp    801058ca <alltraps>

801066f3 <vector161>:
.globl vector161
vector161:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $161
801066f5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801066fa:	e9 cb f1 ff ff       	jmp    801058ca <alltraps>

801066ff <vector162>:
.globl vector162
vector162:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $162
80106701:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106706:	e9 bf f1 ff ff       	jmp    801058ca <alltraps>

8010670b <vector163>:
.globl vector163
vector163:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $163
8010670d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106712:	e9 b3 f1 ff ff       	jmp    801058ca <alltraps>

80106717 <vector164>:
.globl vector164
vector164:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $164
80106719:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010671e:	e9 a7 f1 ff ff       	jmp    801058ca <alltraps>

80106723 <vector165>:
.globl vector165
vector165:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $165
80106725:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010672a:	e9 9b f1 ff ff       	jmp    801058ca <alltraps>

8010672f <vector166>:
.globl vector166
vector166:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $166
80106731:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106736:	e9 8f f1 ff ff       	jmp    801058ca <alltraps>

8010673b <vector167>:
.globl vector167
vector167:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $167
8010673d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106742:	e9 83 f1 ff ff       	jmp    801058ca <alltraps>

80106747 <vector168>:
.globl vector168
vector168:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $168
80106749:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010674e:	e9 77 f1 ff ff       	jmp    801058ca <alltraps>

80106753 <vector169>:
.globl vector169
vector169:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $169
80106755:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010675a:	e9 6b f1 ff ff       	jmp    801058ca <alltraps>

8010675f <vector170>:
.globl vector170
vector170:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $170
80106761:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106766:	e9 5f f1 ff ff       	jmp    801058ca <alltraps>

8010676b <vector171>:
.globl vector171
vector171:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $171
8010676d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106772:	e9 53 f1 ff ff       	jmp    801058ca <alltraps>

80106777 <vector172>:
.globl vector172
vector172:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $172
80106779:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010677e:	e9 47 f1 ff ff       	jmp    801058ca <alltraps>

80106783 <vector173>:
.globl vector173
vector173:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $173
80106785:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010678a:	e9 3b f1 ff ff       	jmp    801058ca <alltraps>

8010678f <vector174>:
.globl vector174
vector174:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $174
80106791:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106796:	e9 2f f1 ff ff       	jmp    801058ca <alltraps>

8010679b <vector175>:
.globl vector175
vector175:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $175
8010679d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801067a2:	e9 23 f1 ff ff       	jmp    801058ca <alltraps>

801067a7 <vector176>:
.globl vector176
vector176:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $176
801067a9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801067ae:	e9 17 f1 ff ff       	jmp    801058ca <alltraps>

801067b3 <vector177>:
.globl vector177
vector177:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $177
801067b5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801067ba:	e9 0b f1 ff ff       	jmp    801058ca <alltraps>

801067bf <vector178>:
.globl vector178
vector178:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $178
801067c1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801067c6:	e9 ff f0 ff ff       	jmp    801058ca <alltraps>

801067cb <vector179>:
.globl vector179
vector179:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $179
801067cd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801067d2:	e9 f3 f0 ff ff       	jmp    801058ca <alltraps>

801067d7 <vector180>:
.globl vector180
vector180:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $180
801067d9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801067de:	e9 e7 f0 ff ff       	jmp    801058ca <alltraps>

801067e3 <vector181>:
.globl vector181
vector181:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $181
801067e5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801067ea:	e9 db f0 ff ff       	jmp    801058ca <alltraps>

801067ef <vector182>:
.globl vector182
vector182:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $182
801067f1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801067f6:	e9 cf f0 ff ff       	jmp    801058ca <alltraps>

801067fb <vector183>:
.globl vector183
vector183:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $183
801067fd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106802:	e9 c3 f0 ff ff       	jmp    801058ca <alltraps>

80106807 <vector184>:
.globl vector184
vector184:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $184
80106809:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010680e:	e9 b7 f0 ff ff       	jmp    801058ca <alltraps>

80106813 <vector185>:
.globl vector185
vector185:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $185
80106815:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010681a:	e9 ab f0 ff ff       	jmp    801058ca <alltraps>

8010681f <vector186>:
.globl vector186
vector186:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $186
80106821:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106826:	e9 9f f0 ff ff       	jmp    801058ca <alltraps>

8010682b <vector187>:
.globl vector187
vector187:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $187
8010682d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106832:	e9 93 f0 ff ff       	jmp    801058ca <alltraps>

80106837 <vector188>:
.globl vector188
vector188:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $188
80106839:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010683e:	e9 87 f0 ff ff       	jmp    801058ca <alltraps>

80106843 <vector189>:
.globl vector189
vector189:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $189
80106845:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010684a:	e9 7b f0 ff ff       	jmp    801058ca <alltraps>

8010684f <vector190>:
.globl vector190
vector190:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $190
80106851:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106856:	e9 6f f0 ff ff       	jmp    801058ca <alltraps>

8010685b <vector191>:
.globl vector191
vector191:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $191
8010685d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106862:	e9 63 f0 ff ff       	jmp    801058ca <alltraps>

80106867 <vector192>:
.globl vector192
vector192:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $192
80106869:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010686e:	e9 57 f0 ff ff       	jmp    801058ca <alltraps>

80106873 <vector193>:
.globl vector193
vector193:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $193
80106875:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010687a:	e9 4b f0 ff ff       	jmp    801058ca <alltraps>

8010687f <vector194>:
.globl vector194
vector194:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $194
80106881:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106886:	e9 3f f0 ff ff       	jmp    801058ca <alltraps>

8010688b <vector195>:
.globl vector195
vector195:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $195
8010688d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106892:	e9 33 f0 ff ff       	jmp    801058ca <alltraps>

80106897 <vector196>:
.globl vector196
vector196:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $196
80106899:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010689e:	e9 27 f0 ff ff       	jmp    801058ca <alltraps>

801068a3 <vector197>:
.globl vector197
vector197:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $197
801068a5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801068aa:	e9 1b f0 ff ff       	jmp    801058ca <alltraps>

801068af <vector198>:
.globl vector198
vector198:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $198
801068b1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801068b6:	e9 0f f0 ff ff       	jmp    801058ca <alltraps>

801068bb <vector199>:
.globl vector199
vector199:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $199
801068bd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801068c2:	e9 03 f0 ff ff       	jmp    801058ca <alltraps>

801068c7 <vector200>:
.globl vector200
vector200:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $200
801068c9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801068ce:	e9 f7 ef ff ff       	jmp    801058ca <alltraps>

801068d3 <vector201>:
.globl vector201
vector201:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $201
801068d5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801068da:	e9 eb ef ff ff       	jmp    801058ca <alltraps>

801068df <vector202>:
.globl vector202
vector202:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $202
801068e1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801068e6:	e9 df ef ff ff       	jmp    801058ca <alltraps>

801068eb <vector203>:
.globl vector203
vector203:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $203
801068ed:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801068f2:	e9 d3 ef ff ff       	jmp    801058ca <alltraps>

801068f7 <vector204>:
.globl vector204
vector204:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $204
801068f9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801068fe:	e9 c7 ef ff ff       	jmp    801058ca <alltraps>

80106903 <vector205>:
.globl vector205
vector205:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $205
80106905:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010690a:	e9 bb ef ff ff       	jmp    801058ca <alltraps>

8010690f <vector206>:
.globl vector206
vector206:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $206
80106911:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106916:	e9 af ef ff ff       	jmp    801058ca <alltraps>

8010691b <vector207>:
.globl vector207
vector207:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $207
8010691d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106922:	e9 a3 ef ff ff       	jmp    801058ca <alltraps>

80106927 <vector208>:
.globl vector208
vector208:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $208
80106929:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010692e:	e9 97 ef ff ff       	jmp    801058ca <alltraps>

80106933 <vector209>:
.globl vector209
vector209:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $209
80106935:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010693a:	e9 8b ef ff ff       	jmp    801058ca <alltraps>

8010693f <vector210>:
.globl vector210
vector210:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $210
80106941:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106946:	e9 7f ef ff ff       	jmp    801058ca <alltraps>

8010694b <vector211>:
.globl vector211
vector211:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $211
8010694d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106952:	e9 73 ef ff ff       	jmp    801058ca <alltraps>

80106957 <vector212>:
.globl vector212
vector212:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $212
80106959:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010695e:	e9 67 ef ff ff       	jmp    801058ca <alltraps>

80106963 <vector213>:
.globl vector213
vector213:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $213
80106965:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010696a:	e9 5b ef ff ff       	jmp    801058ca <alltraps>

8010696f <vector214>:
.globl vector214
vector214:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $214
80106971:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106976:	e9 4f ef ff ff       	jmp    801058ca <alltraps>

8010697b <vector215>:
.globl vector215
vector215:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $215
8010697d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106982:	e9 43 ef ff ff       	jmp    801058ca <alltraps>

80106987 <vector216>:
.globl vector216
vector216:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $216
80106989:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010698e:	e9 37 ef ff ff       	jmp    801058ca <alltraps>

80106993 <vector217>:
.globl vector217
vector217:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $217
80106995:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010699a:	e9 2b ef ff ff       	jmp    801058ca <alltraps>

8010699f <vector218>:
.globl vector218
vector218:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $218
801069a1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801069a6:	e9 1f ef ff ff       	jmp    801058ca <alltraps>

801069ab <vector219>:
.globl vector219
vector219:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $219
801069ad:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801069b2:	e9 13 ef ff ff       	jmp    801058ca <alltraps>

801069b7 <vector220>:
.globl vector220
vector220:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $220
801069b9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801069be:	e9 07 ef ff ff       	jmp    801058ca <alltraps>

801069c3 <vector221>:
.globl vector221
vector221:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $221
801069c5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801069ca:	e9 fb ee ff ff       	jmp    801058ca <alltraps>

801069cf <vector222>:
.globl vector222
vector222:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $222
801069d1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801069d6:	e9 ef ee ff ff       	jmp    801058ca <alltraps>

801069db <vector223>:
.globl vector223
vector223:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $223
801069dd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801069e2:	e9 e3 ee ff ff       	jmp    801058ca <alltraps>

801069e7 <vector224>:
.globl vector224
vector224:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $224
801069e9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801069ee:	e9 d7 ee ff ff       	jmp    801058ca <alltraps>

801069f3 <vector225>:
.globl vector225
vector225:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $225
801069f5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801069fa:	e9 cb ee ff ff       	jmp    801058ca <alltraps>

801069ff <vector226>:
.globl vector226
vector226:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $226
80106a01:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106a06:	e9 bf ee ff ff       	jmp    801058ca <alltraps>

80106a0b <vector227>:
.globl vector227
vector227:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $227
80106a0d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106a12:	e9 b3 ee ff ff       	jmp    801058ca <alltraps>

80106a17 <vector228>:
.globl vector228
vector228:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $228
80106a19:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106a1e:	e9 a7 ee ff ff       	jmp    801058ca <alltraps>

80106a23 <vector229>:
.globl vector229
vector229:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $229
80106a25:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106a2a:	e9 9b ee ff ff       	jmp    801058ca <alltraps>

80106a2f <vector230>:
.globl vector230
vector230:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $230
80106a31:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106a36:	e9 8f ee ff ff       	jmp    801058ca <alltraps>

80106a3b <vector231>:
.globl vector231
vector231:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $231
80106a3d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106a42:	e9 83 ee ff ff       	jmp    801058ca <alltraps>

80106a47 <vector232>:
.globl vector232
vector232:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $232
80106a49:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106a4e:	e9 77 ee ff ff       	jmp    801058ca <alltraps>

80106a53 <vector233>:
.globl vector233
vector233:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $233
80106a55:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106a5a:	e9 6b ee ff ff       	jmp    801058ca <alltraps>

80106a5f <vector234>:
.globl vector234
vector234:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $234
80106a61:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106a66:	e9 5f ee ff ff       	jmp    801058ca <alltraps>

80106a6b <vector235>:
.globl vector235
vector235:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $235
80106a6d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106a72:	e9 53 ee ff ff       	jmp    801058ca <alltraps>

80106a77 <vector236>:
.globl vector236
vector236:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $236
80106a79:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106a7e:	e9 47 ee ff ff       	jmp    801058ca <alltraps>

80106a83 <vector237>:
.globl vector237
vector237:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $237
80106a85:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106a8a:	e9 3b ee ff ff       	jmp    801058ca <alltraps>

80106a8f <vector238>:
.globl vector238
vector238:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $238
80106a91:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106a96:	e9 2f ee ff ff       	jmp    801058ca <alltraps>

80106a9b <vector239>:
.globl vector239
vector239:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $239
80106a9d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106aa2:	e9 23 ee ff ff       	jmp    801058ca <alltraps>

80106aa7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $240
80106aa9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106aae:	e9 17 ee ff ff       	jmp    801058ca <alltraps>

80106ab3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $241
80106ab5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106aba:	e9 0b ee ff ff       	jmp    801058ca <alltraps>

80106abf <vector242>:
.globl vector242
vector242:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $242
80106ac1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106ac6:	e9 ff ed ff ff       	jmp    801058ca <alltraps>

80106acb <vector243>:
.globl vector243
vector243:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $243
80106acd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106ad2:	e9 f3 ed ff ff       	jmp    801058ca <alltraps>

80106ad7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $244
80106ad9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106ade:	e9 e7 ed ff ff       	jmp    801058ca <alltraps>

80106ae3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $245
80106ae5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106aea:	e9 db ed ff ff       	jmp    801058ca <alltraps>

80106aef <vector246>:
.globl vector246
vector246:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $246
80106af1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106af6:	e9 cf ed ff ff       	jmp    801058ca <alltraps>

80106afb <vector247>:
.globl vector247
vector247:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $247
80106afd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106b02:	e9 c3 ed ff ff       	jmp    801058ca <alltraps>

80106b07 <vector248>:
.globl vector248
vector248:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $248
80106b09:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106b0e:	e9 b7 ed ff ff       	jmp    801058ca <alltraps>

80106b13 <vector249>:
.globl vector249
vector249:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $249
80106b15:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106b1a:	e9 ab ed ff ff       	jmp    801058ca <alltraps>

80106b1f <vector250>:
.globl vector250
vector250:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $250
80106b21:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106b26:	e9 9f ed ff ff       	jmp    801058ca <alltraps>

80106b2b <vector251>:
.globl vector251
vector251:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $251
80106b2d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106b32:	e9 93 ed ff ff       	jmp    801058ca <alltraps>

80106b37 <vector252>:
.globl vector252
vector252:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $252
80106b39:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106b3e:	e9 87 ed ff ff       	jmp    801058ca <alltraps>

80106b43 <vector253>:
.globl vector253
vector253:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $253
80106b45:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106b4a:	e9 7b ed ff ff       	jmp    801058ca <alltraps>

80106b4f <vector254>:
.globl vector254
vector254:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $254
80106b51:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106b56:	e9 6f ed ff ff       	jmp    801058ca <alltraps>

80106b5b <vector255>:
.globl vector255
vector255:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $255
80106b5d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106b62:	e9 63 ed ff ff       	jmp    801058ca <alltraps>
80106b67:	66 90                	xchg   %ax,%ax
80106b69:	66 90                	xchg   %ax,%ax
80106b6b:	66 90                	xchg   %ax,%ax
80106b6d:	66 90                	xchg   %ax,%ax
80106b6f:	90                   	nop

80106b70 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106b70:	55                   	push   %ebp
80106b71:	89 e5                	mov    %esp,%ebp
80106b73:	57                   	push   %edi
80106b74:	56                   	push   %esi
80106b75:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];    
80106b76:	89 d3                	mov    %edx,%ebx
{
80106b78:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];    
80106b7a:	c1 eb 16             	shr    $0x16,%ebx
80106b7d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106b80:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106b83:	8b 06                	mov    (%esi),%eax
80106b85:	a8 01                	test   $0x1,%al
80106b87:	74 27                	je     80106bb0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b89:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b8e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106b94:	c1 ef 0a             	shr    $0xa,%edi
}
80106b97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106b9a:	89 fa                	mov    %edi,%edx
80106b9c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106ba2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106ba5:	5b                   	pop    %ebx
80106ba6:	5e                   	pop    %esi
80106ba7:	5f                   	pop    %edi
80106ba8:	5d                   	pop    %ebp
80106ba9:	c3                   	ret    
80106baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106bb0:	85 c9                	test   %ecx,%ecx
80106bb2:	74 2c                	je     80106be0 <walkpgdir+0x70>
80106bb4:	e8 77 bb ff ff       	call   80102730 <kalloc>
80106bb9:	85 c0                	test   %eax,%eax
80106bbb:	89 c3                	mov    %eax,%ebx
80106bbd:	74 21                	je     80106be0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106bbf:	83 ec 04             	sub    $0x4,%esp
80106bc2:	68 00 10 00 00       	push   $0x1000
80106bc7:	6a 00                	push   $0x0
80106bc9:	50                   	push   %eax
80106bca:	e8 d1 da ff ff       	call   801046a0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106bcf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106bd5:	83 c4 10             	add    $0x10,%esp
80106bd8:	83 c8 07             	or     $0x7,%eax
80106bdb:	89 06                	mov    %eax,(%esi)
80106bdd:	eb b5                	jmp    80106b94 <walkpgdir+0x24>
80106bdf:	90                   	nop
}
80106be0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106be3:	31 c0                	xor    %eax,%eax
}
80106be5:	5b                   	pop    %ebx
80106be6:	5e                   	pop    %esi
80106be7:	5f                   	pop    %edi
80106be8:	5d                   	pop    %ebp
80106be9:	c3                   	ret    
80106bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106bf0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	57                   	push   %edi
80106bf4:	56                   	push   %esi
80106bf5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106bf6:	89 d3                	mov    %edx,%ebx
80106bf8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106bfe:	83 ec 1c             	sub    $0x1c,%esp
80106c01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c04:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106c08:	8b 7d 08             	mov    0x8(%ebp),%edi
80106c0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c10:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106c13:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c16:	29 df                	sub    %ebx,%edi
80106c18:	83 c8 01             	or     $0x1,%eax
80106c1b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106c1e:	eb 15                	jmp    80106c35 <mappages+0x45>
    if(*pte & PTE_P)
80106c20:	f6 00 01             	testb  $0x1,(%eax)
80106c23:	75 45                	jne    80106c6a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106c25:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106c28:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106c2b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106c2d:	74 31                	je     80106c60 <mappages+0x70>
      break;
    a += PGSIZE;
80106c2f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106c35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c38:	b9 01 00 00 00       	mov    $0x1,%ecx
80106c3d:	89 da                	mov    %ebx,%edx
80106c3f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106c42:	e8 29 ff ff ff       	call   80106b70 <walkpgdir>
80106c47:	85 c0                	test   %eax,%eax
80106c49:	75 d5                	jne    80106c20 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106c4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106c4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c53:	5b                   	pop    %ebx
80106c54:	5e                   	pop    %esi
80106c55:	5f                   	pop    %edi
80106c56:	5d                   	pop    %ebp
80106c57:	c3                   	ret    
80106c58:	90                   	nop
80106c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106c63:	31 c0                	xor    %eax,%eax
}
80106c65:	5b                   	pop    %ebx
80106c66:	5e                   	pop    %esi
80106c67:	5f                   	pop    %edi
80106c68:	5d                   	pop    %ebp
80106c69:	c3                   	ret    
      panic("remap");
80106c6a:	83 ec 0c             	sub    $0xc,%esp
80106c6d:	68 5e 7f 10 80       	push   $0x80107f5e
80106c72:	e8 19 98 ff ff       	call   80100490 <panic>
80106c77:	89 f6                	mov    %esi,%esi
80106c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c80 <deallocuvm.part.0>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
// If the page was swapped free the corresponding disk block.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	57                   	push   %edi
80106c84:	56                   	push   %esi
80106c85:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106c86:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c8c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106c8e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c94:	83 ec 1c             	sub    $0x1c,%esp
80106c97:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106c9a:	39 d3                	cmp    %edx,%ebx
80106c9c:	73 66                	jae    80106d04 <deallocuvm.part.0+0x84>
80106c9e:	89 d6                	mov    %edx,%esi
80106ca0:	eb 3d                	jmp    80106cdf <deallocuvm.part.0+0x5f>
80106ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106ca8:	8b 10                	mov    (%eax),%edx
80106caa:	f6 c2 01             	test   $0x1,%dl
80106cad:	74 26                	je     80106cd5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106caf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106cb5:	74 58                	je     80106d0f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106cb7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106cba:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106cc0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106cc3:	52                   	push   %edx
80106cc4:	e8 b7 b8 ff ff       	call   80102580 <kfree>
      *pte = 0;
80106cc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ccc:	83 c4 10             	add    $0x10,%esp
80106ccf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106cd5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cdb:	39 f3                	cmp    %esi,%ebx
80106cdd:	73 25                	jae    80106d04 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106cdf:	31 c9                	xor    %ecx,%ecx
80106ce1:	89 da                	mov    %ebx,%edx
80106ce3:	89 f8                	mov    %edi,%eax
80106ce5:	e8 86 fe ff ff       	call   80106b70 <walkpgdir>
    if(!pte)
80106cea:	85 c0                	test   %eax,%eax
80106cec:	75 ba                	jne    80106ca8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106cee:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106cf4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106cfa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d00:	39 f3                	cmp    %esi,%ebx
80106d02:	72 db                	jb     80106cdf <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106d04:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d0a:	5b                   	pop    %ebx
80106d0b:	5e                   	pop    %esi
80106d0c:	5f                   	pop    %edi
80106d0d:	5d                   	pop    %ebp
80106d0e:	c3                   	ret    
        panic("kfree");
80106d0f:	83 ec 0c             	sub    $0xc,%esp
80106d12:	68 46 78 10 80       	push   $0x80107846
80106d17:	e8 74 97 ff ff       	call   80100490 <panic>
80106d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d20 <seginit>:
{
80106d20:	55                   	push   %ebp
80106d21:	89 e5                	mov    %esp,%ebp
80106d23:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106d26:	e8 05 cd ff ff       	call   80103a30 <cpuid>
80106d2b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106d31:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106d36:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106d3a:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
80106d41:	ff 00 00 
80106d44:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
80106d4b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d4e:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
80106d55:	ff 00 00 
80106d58:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
80106d5f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106d62:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
80106d69:	ff 00 00 
80106d6c:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
80106d73:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106d76:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
80106d7d:	ff 00 00 
80106d80:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
80106d87:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106d8a:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
80106d8f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106d93:	c1 e8 10             	shr    $0x10,%eax
80106d96:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106d9a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106d9d:	0f 01 10             	lgdtl  (%eax)
}
80106da0:	c9                   	leave  
80106da1:	c3                   	ret    
80106da2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106db0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106db0:	a1 a4 64 11 80       	mov    0x801164a4,%eax
{
80106db5:	55                   	push   %ebp
80106db6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106db8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106dbd:	0f 22 d8             	mov    %eax,%cr3
}
80106dc0:	5d                   	pop    %ebp
80106dc1:	c3                   	ret    
80106dc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106dd0 <switchuvm>:
{
80106dd0:	55                   	push   %ebp
80106dd1:	89 e5                	mov    %esp,%ebp
80106dd3:	57                   	push   %edi
80106dd4:	56                   	push   %esi
80106dd5:	53                   	push   %ebx
80106dd6:	83 ec 1c             	sub    $0x1c,%esp
80106dd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106ddc:	85 db                	test   %ebx,%ebx
80106dde:	0f 84 cb 00 00 00    	je     80106eaf <switchuvm+0xdf>
  if(p->kstack == 0)
80106de4:	8b 43 08             	mov    0x8(%ebx),%eax
80106de7:	85 c0                	test   %eax,%eax
80106de9:	0f 84 da 00 00 00    	je     80106ec9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106def:	8b 43 04             	mov    0x4(%ebx),%eax
80106df2:	85 c0                	test   %eax,%eax
80106df4:	0f 84 c2 00 00 00    	je     80106ebc <switchuvm+0xec>
  pushcli();
80106dfa:	e8 e1 d6 ff ff       	call   801044e0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106dff:	e8 ac cb ff ff       	call   801039b0 <mycpu>
80106e04:	89 c6                	mov    %eax,%esi
80106e06:	e8 a5 cb ff ff       	call   801039b0 <mycpu>
80106e0b:	89 c7                	mov    %eax,%edi
80106e0d:	e8 9e cb ff ff       	call   801039b0 <mycpu>
80106e12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e15:	83 c7 08             	add    $0x8,%edi
80106e18:	e8 93 cb ff ff       	call   801039b0 <mycpu>
80106e1d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e20:	83 c0 08             	add    $0x8,%eax
80106e23:	ba 67 00 00 00       	mov    $0x67,%edx
80106e28:	c1 e8 18             	shr    $0x18,%eax
80106e2b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106e32:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106e39:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e3f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e44:	83 c1 08             	add    $0x8,%ecx
80106e47:	c1 e9 10             	shr    $0x10,%ecx
80106e4a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106e50:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106e55:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e5c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106e61:	e8 4a cb ff ff       	call   801039b0 <mycpu>
80106e66:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e6d:	e8 3e cb ff ff       	call   801039b0 <mycpu>
80106e72:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106e76:	8b 73 08             	mov    0x8(%ebx),%esi
80106e79:	e8 32 cb ff ff       	call   801039b0 <mycpu>
80106e7e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106e84:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e87:	e8 24 cb ff ff       	call   801039b0 <mycpu>
80106e8c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106e90:	b8 28 00 00 00       	mov    $0x28,%eax
80106e95:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106e98:	8b 43 04             	mov    0x4(%ebx),%eax
80106e9b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ea0:	0f 22 d8             	mov    %eax,%cr3
}
80106ea3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ea6:	5b                   	pop    %ebx
80106ea7:	5e                   	pop    %esi
80106ea8:	5f                   	pop    %edi
80106ea9:	5d                   	pop    %ebp
  popcli();
80106eaa:	e9 31 d7 ff ff       	jmp    801045e0 <popcli>
    panic("switchuvm: no process");
80106eaf:	83 ec 0c             	sub    $0xc,%esp
80106eb2:	68 6c 7f 10 80       	push   $0x80107f6c
80106eb7:	e8 d4 95 ff ff       	call   80100490 <panic>
    panic("switchuvm: no pgdir");
80106ebc:	83 ec 0c             	sub    $0xc,%esp
80106ebf:	68 97 7f 10 80       	push   $0x80107f97
80106ec4:	e8 c7 95 ff ff       	call   80100490 <panic>
    panic("switchuvm: no kstack");
80106ec9:	83 ec 0c             	sub    $0xc,%esp
80106ecc:	68 82 7f 10 80       	push   $0x80107f82
80106ed1:	e8 ba 95 ff ff       	call   80100490 <panic>
80106ed6:	8d 76 00             	lea    0x0(%esi),%esi
80106ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ee0 <inituvm>:
{
80106ee0:	55                   	push   %ebp
80106ee1:	89 e5                	mov    %esp,%ebp
80106ee3:	57                   	push   %edi
80106ee4:	56                   	push   %esi
80106ee5:	53                   	push   %ebx
80106ee6:	83 ec 1c             	sub    $0x1c,%esp
80106ee9:	8b 75 10             	mov    0x10(%ebp),%esi
80106eec:	8b 45 08             	mov    0x8(%ebp),%eax
80106eef:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106ef2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106ef8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106efb:	77 49                	ja     80106f46 <inituvm+0x66>
  mem = kalloc();
80106efd:	e8 2e b8 ff ff       	call   80102730 <kalloc>
  memset(mem, 0, PGSIZE);
80106f02:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106f05:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106f07:	68 00 10 00 00       	push   $0x1000
80106f0c:	6a 00                	push   $0x0
80106f0e:	50                   	push   %eax
80106f0f:	e8 8c d7 ff ff       	call   801046a0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106f14:	58                   	pop    %eax
80106f15:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f1b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f20:	5a                   	pop    %edx
80106f21:	6a 06                	push   $0x6
80106f23:	50                   	push   %eax
80106f24:	31 d2                	xor    %edx,%edx
80106f26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f29:	e8 c2 fc ff ff       	call   80106bf0 <mappages>
  memmove(mem, init, sz);
80106f2e:	89 75 10             	mov    %esi,0x10(%ebp)
80106f31:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106f34:	83 c4 10             	add    $0x10,%esp
80106f37:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106f3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f3d:	5b                   	pop    %ebx
80106f3e:	5e                   	pop    %esi
80106f3f:	5f                   	pop    %edi
80106f40:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106f41:	e9 0a d8 ff ff       	jmp    80104750 <memmove>
    panic("inituvm: more than a page");
80106f46:	83 ec 0c             	sub    $0xc,%esp
80106f49:	68 ab 7f 10 80       	push   $0x80107fab
80106f4e:	e8 3d 95 ff ff       	call   80100490 <panic>
80106f53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f60 <loaduvm>:
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	57                   	push   %edi
80106f64:	56                   	push   %esi
80106f65:	53                   	push   %ebx
80106f66:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106f69:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106f70:	0f 85 91 00 00 00    	jne    80107007 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106f76:	8b 75 18             	mov    0x18(%ebp),%esi
80106f79:	31 db                	xor    %ebx,%ebx
80106f7b:	85 f6                	test   %esi,%esi
80106f7d:	75 1a                	jne    80106f99 <loaduvm+0x39>
80106f7f:	eb 6f                	jmp    80106ff0 <loaduvm+0x90>
80106f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f88:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f8e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106f94:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106f97:	76 57                	jbe    80106ff0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106f99:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f9c:	8b 45 08             	mov    0x8(%ebp),%eax
80106f9f:	31 c9                	xor    %ecx,%ecx
80106fa1:	01 da                	add    %ebx,%edx
80106fa3:	e8 c8 fb ff ff       	call   80106b70 <walkpgdir>
80106fa8:	85 c0                	test   %eax,%eax
80106faa:	74 4e                	je     80106ffa <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106fac:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106fae:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106fb1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106fb6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106fbb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106fc1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106fc4:	01 d9                	add    %ebx,%ecx
80106fc6:	05 00 00 00 80       	add    $0x80000000,%eax
80106fcb:	57                   	push   %edi
80106fcc:	51                   	push   %ecx
80106fcd:	50                   	push   %eax
80106fce:	ff 75 10             	pushl  0x10(%ebp)
80106fd1:	e8 0a ac ff ff       	call   80101be0 <readi>
80106fd6:	83 c4 10             	add    $0x10,%esp
80106fd9:	39 f8                	cmp    %edi,%eax
80106fdb:	74 ab                	je     80106f88 <loaduvm+0x28>
}
80106fdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106fe5:	5b                   	pop    %ebx
80106fe6:	5e                   	pop    %esi
80106fe7:	5f                   	pop    %edi
80106fe8:	5d                   	pop    %ebp
80106fe9:	c3                   	ret    
80106fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ff0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ff3:	31 c0                	xor    %eax,%eax
}
80106ff5:	5b                   	pop    %ebx
80106ff6:	5e                   	pop    %esi
80106ff7:	5f                   	pop    %edi
80106ff8:	5d                   	pop    %ebp
80106ff9:	c3                   	ret    
      panic("loaduvm: address should exist");
80106ffa:	83 ec 0c             	sub    $0xc,%esp
80106ffd:	68 c5 7f 10 80       	push   $0x80107fc5
80107002:	e8 89 94 ff ff       	call   80100490 <panic>
    panic("loaduvm: addr must be page aligned");
80107007:	83 ec 0c             	sub    $0xc,%esp
8010700a:	68 64 80 10 80       	push   $0x80108064
8010700f:	e8 7c 94 ff ff       	call   80100490 <panic>
80107014:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010701a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107020 <allocuvm>:
{
80107020:	55                   	push   %ebp
80107021:	89 e5                	mov    %esp,%ebp
80107023:	57                   	push   %edi
80107024:	56                   	push   %esi
80107025:	53                   	push   %ebx
80107026:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107029:	8b 7d 10             	mov    0x10(%ebp),%edi
8010702c:	85 ff                	test   %edi,%edi
8010702e:	78 76                	js     801070a6 <allocuvm+0x86>
  if(newsz < oldsz)
80107030:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107033:	0f 82 7f 00 00 00    	jb     801070b8 <allocuvm+0x98>
  a = PGROUNDUP(oldsz);
80107039:	8b 45 0c             	mov    0xc(%ebp),%eax
8010703c:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107042:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80107048:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010704b:	76 6e                	jbe    801070bb <allocuvm+0x9b>
8010704d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107050:	8b 7d 08             	mov    0x8(%ebp),%edi
80107053:	eb 3e                	jmp    80107093 <allocuvm+0x73>
80107055:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107058:	83 ec 04             	sub    $0x4,%esp
8010705b:	68 00 10 00 00       	push   $0x1000
80107060:	6a 00                	push   $0x0
80107062:	50                   	push   %eax
80107063:	e8 38 d6 ff ff       	call   801046a0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107068:	58                   	pop    %eax
80107069:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010706f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107074:	5a                   	pop    %edx
80107075:	6a 06                	push   $0x6
80107077:	50                   	push   %eax
80107078:	89 da                	mov    %ebx,%edx
8010707a:	89 f8                	mov    %edi,%eax
8010707c:	e8 6f fb ff ff       	call   80106bf0 <mappages>
80107081:	83 c4 10             	add    $0x10,%esp
80107084:	85 c0                	test   %eax,%eax
80107086:	78 40                	js     801070c8 <allocuvm+0xa8>
  for(; a < newsz; a += PGSIZE){
80107088:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010708e:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107091:	76 65                	jbe    801070f8 <allocuvm+0xd8>
    mem = kalloc();
80107093:	e8 98 b6 ff ff       	call   80102730 <kalloc>
    if(mem == 0){
80107098:	85 c0                	test   %eax,%eax
    mem = kalloc();
8010709a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
8010709c:	75 ba                	jne    80107058 <allocuvm+0x38>
  if(newsz >= oldsz)
8010709e:	8b 45 0c             	mov    0xc(%ebp),%eax
801070a1:	39 45 10             	cmp    %eax,0x10(%ebp)
801070a4:	77 62                	ja     80107108 <allocuvm+0xe8>
}
801070a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801070a9:	31 ff                	xor    %edi,%edi
}
801070ab:	89 f8                	mov    %edi,%eax
801070ad:	5b                   	pop    %ebx
801070ae:	5e                   	pop    %esi
801070af:	5f                   	pop    %edi
801070b0:	5d                   	pop    %ebp
801070b1:	c3                   	ret    
801070b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return oldsz;
801070b8:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801070bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070be:	89 f8                	mov    %edi,%eax
801070c0:	5b                   	pop    %ebx
801070c1:	5e                   	pop    %esi
801070c2:	5f                   	pop    %edi
801070c3:	5d                   	pop    %ebp
801070c4:	c3                   	ret    
801070c5:	8d 76 00             	lea    0x0(%esi),%esi
  if(newsz >= oldsz)
801070c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801070cb:	39 45 10             	cmp    %eax,0x10(%ebp)
801070ce:	76 0d                	jbe    801070dd <allocuvm+0xbd>
801070d0:	89 c1                	mov    %eax,%ecx
801070d2:	8b 55 10             	mov    0x10(%ebp),%edx
801070d5:	8b 45 08             	mov    0x8(%ebp),%eax
801070d8:	e8 a3 fb ff ff       	call   80106c80 <deallocuvm.part.0>
      kfree(mem);
801070dd:	83 ec 0c             	sub    $0xc,%esp
      return 0;
801070e0:	31 ff                	xor    %edi,%edi
      kfree(mem);
801070e2:	56                   	push   %esi
801070e3:	e8 98 b4 ff ff       	call   80102580 <kfree>
      return 0;
801070e8:	83 c4 10             	add    $0x10,%esp
}
801070eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070ee:	89 f8                	mov    %edi,%eax
801070f0:	5b                   	pop    %ebx
801070f1:	5e                   	pop    %esi
801070f2:	5f                   	pop    %edi
801070f3:	5d                   	pop    %ebp
801070f4:	c3                   	ret    
801070f5:	8d 76 00             	lea    0x0(%esi),%esi
801070f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801070fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070fe:	5b                   	pop    %ebx
801070ff:	89 f8                	mov    %edi,%eax
80107101:	5e                   	pop    %esi
80107102:	5f                   	pop    %edi
80107103:	5d                   	pop    %ebp
80107104:	c3                   	ret    
80107105:	8d 76 00             	lea    0x0(%esi),%esi
80107108:	89 c1                	mov    %eax,%ecx
8010710a:	8b 55 10             	mov    0x10(%ebp),%edx
8010710d:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107110:	31 ff                	xor    %edi,%edi
80107112:	e8 69 fb ff ff       	call   80106c80 <deallocuvm.part.0>
80107117:	eb a2                	jmp    801070bb <allocuvm+0x9b>
80107119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107120 <deallocuvm>:
{
80107120:	55                   	push   %ebp
80107121:	89 e5                	mov    %esp,%ebp
80107123:	8b 55 0c             	mov    0xc(%ebp),%edx
80107126:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107129:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010712c:	39 d1                	cmp    %edx,%ecx
8010712e:	73 10                	jae    80107140 <deallocuvm+0x20>
}
80107130:	5d                   	pop    %ebp
80107131:	e9 4a fb ff ff       	jmp    80106c80 <deallocuvm.part.0>
80107136:	8d 76 00             	lea    0x0(%esi),%esi
80107139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107140:	89 d0                	mov    %edx,%eax
80107142:	5d                   	pop    %ebp
80107143:	c3                   	ret    
80107144:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010714a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107150 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107150:	55                   	push   %ebp
80107151:	89 e5                	mov    %esp,%ebp
80107153:	57                   	push   %edi
80107154:	56                   	push   %esi
80107155:	53                   	push   %ebx
80107156:	83 ec 0c             	sub    $0xc,%esp
80107159:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010715c:	85 f6                	test   %esi,%esi
8010715e:	74 59                	je     801071b9 <freevm+0x69>
80107160:	31 c9                	xor    %ecx,%ecx
80107162:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107167:	89 f0                	mov    %esi,%eax
80107169:	e8 12 fb ff ff       	call   80106c80 <deallocuvm.part.0>
8010716e:	89 f3                	mov    %esi,%ebx
80107170:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107176:	eb 0f                	jmp    80107187 <freevm+0x37>
80107178:	90                   	nop
80107179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107180:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107183:	39 fb                	cmp    %edi,%ebx
80107185:	74 23                	je     801071aa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107187:	8b 03                	mov    (%ebx),%eax
80107189:	a8 01                	test   $0x1,%al
8010718b:	74 f3                	je     80107180 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010718d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107192:	83 ec 0c             	sub    $0xc,%esp
80107195:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107198:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010719d:	50                   	push   %eax
8010719e:	e8 dd b3 ff ff       	call   80102580 <kfree>
801071a3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801071a6:	39 fb                	cmp    %edi,%ebx
801071a8:	75 dd                	jne    80107187 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801071aa:	89 75 08             	mov    %esi,0x8(%ebp)
}
801071ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071b0:	5b                   	pop    %ebx
801071b1:	5e                   	pop    %esi
801071b2:	5f                   	pop    %edi
801071b3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801071b4:	e9 c7 b3 ff ff       	jmp    80102580 <kfree>
    panic("freevm: no pgdir");
801071b9:	83 ec 0c             	sub    $0xc,%esp
801071bc:	68 e3 7f 10 80       	push   $0x80107fe3
801071c1:	e8 ca 92 ff ff       	call   80100490 <panic>
801071c6:	8d 76 00             	lea    0x0(%esi),%esi
801071c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071d0 <setupkvm>:
{
801071d0:	55                   	push   %ebp
801071d1:	89 e5                	mov    %esp,%ebp
801071d3:	56                   	push   %esi
801071d4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801071d5:	e8 56 b5 ff ff       	call   80102730 <kalloc>
801071da:	85 c0                	test   %eax,%eax
801071dc:	89 c6                	mov    %eax,%esi
801071de:	74 42                	je     80107222 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801071e0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801071e3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801071e8:	68 00 10 00 00       	push   $0x1000
801071ed:	6a 00                	push   $0x0
801071ef:	50                   	push   %eax
801071f0:	e8 ab d4 ff ff       	call   801046a0 <memset>
801071f5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801071f8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801071fb:	8b 4b 08             	mov    0x8(%ebx),%ecx
801071fe:	83 ec 08             	sub    $0x8,%esp
80107201:	8b 13                	mov    (%ebx),%edx
80107203:	ff 73 0c             	pushl  0xc(%ebx)
80107206:	50                   	push   %eax
80107207:	29 c1                	sub    %eax,%ecx
80107209:	89 f0                	mov    %esi,%eax
8010720b:	e8 e0 f9 ff ff       	call   80106bf0 <mappages>
80107210:	83 c4 10             	add    $0x10,%esp
80107213:	85 c0                	test   %eax,%eax
80107215:	78 19                	js     80107230 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107217:	83 c3 10             	add    $0x10,%ebx
8010721a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107220:	75 d6                	jne    801071f8 <setupkvm+0x28>
}
80107222:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107225:	89 f0                	mov    %esi,%eax
80107227:	5b                   	pop    %ebx
80107228:	5e                   	pop    %esi
80107229:	5d                   	pop    %ebp
8010722a:	c3                   	ret    
8010722b:	90                   	nop
8010722c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107230:	83 ec 0c             	sub    $0xc,%esp
80107233:	56                   	push   %esi
      return 0;
80107234:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107236:	e8 15 ff ff ff       	call   80107150 <freevm>
      return 0;
8010723b:	83 c4 10             	add    $0x10,%esp
}
8010723e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107241:	89 f0                	mov    %esi,%eax
80107243:	5b                   	pop    %ebx
80107244:	5e                   	pop    %esi
80107245:	5d                   	pop    %ebp
80107246:	c3                   	ret    
80107247:	89 f6                	mov    %esi,%esi
80107249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107250 <kvmalloc>:
{
80107250:	55                   	push   %ebp
80107251:	89 e5                	mov    %esp,%ebp
80107253:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107256:	e8 75 ff ff ff       	call   801071d0 <setupkvm>
8010725b:	a3 a4 64 11 80       	mov    %eax,0x801164a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107260:	05 00 00 00 80       	add    $0x80000000,%eax
80107265:	0f 22 d8             	mov    %eax,%cr3
}
80107268:	c9                   	leave  
80107269:	c3                   	ret    
8010726a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107270 <select_a_victim>:
// Select a page-table entry which is mapped
// but not accessed. Notice that the user memory
// is mapped between 0...KERNBASE.
pte_t*
select_a_victim(pde_t *pgdir)
{
80107270:	55                   	push   %ebp
80107271:	89 e5                	mov    %esp,%ebp
80107273:	57                   	push   %edi
80107274:	56                   	push   %esi
80107275:	53                   	push   %ebx
  cprintf("sselect a victim\n");
  //uint flag=4095;
  uint mid;
  pte_t *addr;
  for(uint a=0;a<=KERNBASE;a+=PGSIZE){
80107276:	31 db                	xor    %ebx,%ebx
{
80107278:	83 ec 18             	sub    $0x18,%esp
8010727b:	8b 75 08             	mov    0x8(%ebp),%esi
  cprintf("sselect a victim\n");
8010727e:	68 f4 7f 10 80       	push   $0x80107ff4
80107283:	e8 d8 94 ff ff       	call   80100760 <cprintf>
80107288:	83 c4 10             	add    $0x10,%esp
8010728b:	eb 19                	jmp    801072a6 <select_a_victim+0x36>
8010728d:	8d 76 00             	lea    0x0(%esi),%esi
        return (pte_t*)(addr);
       mid=PTE_FLAGS(*addr);
    // cprintf("mid %d\n",mid);
    // cprintf("ptep %d",mid & PTE_P);
    // cprintf("ptea %d",mid & PTE_A);
    if(((mid & PTE_P)==1)&&((mid & PTE_A)==0)){
80107290:	83 e2 21             	and    $0x21,%edx
80107293:	83 fa 01             	cmp    $0x1,%edx
80107296:	74 40                	je     801072d8 <select_a_victim+0x68>
  for(uint a=0;a<=KERNBASE;a+=PGSIZE){
80107298:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010729e:	81 fb 00 10 00 80    	cmp    $0x80001000,%ebx
801072a4:	74 6a                	je     80107310 <select_a_victim+0xa0>
    addr=walkpgdir(pgdir, (char*)a, 0);
801072a6:	31 c9                	xor    %ecx,%ecx
801072a8:	89 da                	mov    %ebx,%edx
801072aa:	89 f0                	mov    %esi,%eax
801072ac:	e8 bf f8 ff ff       	call   80106b70 <walkpgdir>
    cprintf("addr %d\n",*addr);
801072b1:	83 ec 08             	sub    $0x8,%esp
801072b4:	ff 30                	pushl  (%eax)
    addr=walkpgdir(pgdir, (char*)a, 0);
801072b6:	89 c7                	mov    %eax,%edi
    cprintf("addr %d\n",*addr);
801072b8:	68 06 80 10 80       	push   $0x80108006
801072bd:	e8 9e 94 ff ff       	call   80100760 <cprintf>
      if(*addr==0)
801072c2:	8b 17                	mov    (%edi),%edx
801072c4:	83 c4 10             	add    $0x10,%esp
801072c7:	85 d2                	test   %edx,%edx
801072c9:	75 c5                	jne    80107290 <select_a_victim+0x20>
    }
   
  }
	
  return  0;
}
801072cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072ce:	89 f8                	mov    %edi,%eax
801072d0:	5b                   	pop    %ebx
801072d1:	5e                   	pop    %esi
801072d2:	5f                   	pop    %edi
801072d3:	5d                   	pop    %ebp
801072d4:	c3                   	ret    
801072d5:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("found %d\n",a);
801072d8:	83 ec 08             	sub    $0x8,%esp
801072db:	53                   	push   %ebx
801072dc:	68 0f 80 10 80       	push   $0x8010800f
801072e1:	e8 7a 94 ff ff       	call   80100760 <cprintf>
      cprintf("found %d\n",addr);
801072e6:	58                   	pop    %eax
801072e7:	5a                   	pop    %edx
801072e8:	57                   	push   %edi
801072e9:	68 0f 80 10 80       	push   $0x8010800f
801072ee:	e8 6d 94 ff ff       	call   80100760 <cprintf>
      cprintf("found2 %d\n",*addr);
801072f3:	59                   	pop    %ecx
801072f4:	5b                   	pop    %ebx
801072f5:	ff 37                	pushl  (%edi)
801072f7:	68 19 80 10 80       	push   $0x80108019
801072fc:	e8 5f 94 ff ff       	call   80100760 <cprintf>
      return (pte_t*)(addr);
80107301:	83 c4 10             	add    $0x10,%esp
}
80107304:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107307:	89 f8                	mov    %edi,%eax
80107309:	5b                   	pop    %ebx
8010730a:	5e                   	pop    %esi
8010730b:	5f                   	pop    %edi
8010730c:	5d                   	pop    %ebp
8010730d:	c3                   	ret    
8010730e:	66 90                	xchg   %ax,%ax
  return  0;
80107310:	31 ff                	xor    %edi,%edi
80107312:	eb b7                	jmp    801072cb <select_a_victim+0x5b>
80107314:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010731a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107320 <clearaccessbit>:

// Clear access bit of a random pte.
void
clearaccessbit(pde_t *pgdir)
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	56                   	push   %esi
80107324:	53                   	push   %ebx
80107325:	8b 75 08             	mov    0x8(%ebp),%esi
  int flag=4095;
  int mid;
  pte_t *addr;
  for(int a=0;a<=KERNBASE;a+=PGSIZE){
80107328:	bb 17 93 00 00       	mov    $0x9317,%ebx
8010732d:	eb 07                	jmp    80107336 <clearaccessbit+0x16>
8010732f:	90                   	nop
80107330:	81 c3 17 a3 00 00    	add    $0xa317,%ebx
    a =(a+37655)%KERNBASE;
    addr=walkpgdir(pgdir, (char*)a, 0);
80107336:	31 c9                	xor    %ecx,%ecx
80107338:	89 da                	mov    %ebx,%edx
8010733a:	89 f0                	mov    %esi,%eax
8010733c:	e8 2f f8 ff ff       	call   80106b70 <walkpgdir>
    if(addr!=0){
80107341:	85 c0                	test   %eax,%eax
80107343:	74 eb                	je     80107330 <clearaccessbit+0x10>
       mid=*addr & flag;
80107345:	8b 10                	mov    (%eax),%edx
    if(((mid & PTE_P)==1)&&((mid & PTE_A)==32)){
80107347:	89 d1                	mov    %edx,%ecx
80107349:	83 e1 21             	and    $0x21,%ecx
8010734c:	83 f9 21             	cmp    $0x21,%ecx
8010734f:	75 df                	jne    80107330 <clearaccessbit+0x10>
      *addr &= ~PTE_A;
80107351:	83 e2 df             	and    $0xffffffdf,%edx
80107354:	89 10                	mov    %edx,(%eax)
    }
   
    }
  }
  return;
}
80107356:	5b                   	pop    %ebx
80107357:	5e                   	pop    %esi
80107358:	5d                   	pop    %ebp
80107359:	c3                   	ret    
8010735a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107360 <getswappedblk>:

// return the disk block-id, if the virtual address
// was swapped, -1 otherwise.
int
getswappedblk(pde_t *pgdir, uint va)
{
80107360:	55                   	push   %ebp
  pte_t *pte=walkpgdir(pgdir,(char *)va,0);
80107361:	31 c9                	xor    %ecx,%ecx
{
80107363:	89 e5                	mov    %esp,%ebp
80107365:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte=walkpgdir(pgdir,(char *)va,0);
80107368:	8b 55 0c             	mov    0xc(%ebp),%edx
8010736b:	8b 45 08             	mov    0x8(%ebp),%eax
8010736e:	e8 fd f7 ff ff       	call   80106b70 <walkpgdir>
  if(*pte==0){
80107373:	8b 00                	mov    (%eax),%eax
    //cprintf("getswapblk wrong\n");
   // cprintf("%d \n", pte[31]);
  }
  if((*pte & PTE_P) == 0){
80107375:	a8 01                	test   $0x1,%al
80107377:	75 07                	jne    80107380 <getswappedblk+0x20>
  
    int t=*pte>>12;
80107379:	c1 e8 0c             	shr    $0xc,%eax
    //  cprintf("%d \n",*pte);
    // cprintf("ik whats wrong \n");
    return t;
  }
  return -1;
}
8010737c:	c9                   	leave  
8010737d:	c3                   	ret    
8010737e:	66 90                	xchg   %ax,%ax
  return -1;
80107380:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107385:	c9                   	leave  
80107386:	c3                   	ret    
80107387:	89 f6                	mov    %esi,%esi
80107389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107390 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107390:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107391:	31 c9                	xor    %ecx,%ecx
{
80107393:	89 e5                	mov    %esp,%ebp
80107395:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107398:	8b 55 0c             	mov    0xc(%ebp),%edx
8010739b:	8b 45 08             	mov    0x8(%ebp),%eax
8010739e:	e8 cd f7 ff ff       	call   80106b70 <walkpgdir>
  if(pte == 0)
801073a3:	85 c0                	test   %eax,%eax
801073a5:	74 05                	je     801073ac <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801073a7:	83 20 fb             	andl   $0xfffffffb,(%eax)





}
801073aa:	c9                   	leave  
801073ab:	c3                   	ret    
    panic("clearpteu");
801073ac:	83 ec 0c             	sub    $0xc,%esp
801073af:	68 24 80 10 80       	push   $0x80108024
801073b4:	e8 d7 90 ff ff       	call   80100490 <panic>
801073b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801073c0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801073c0:	55                   	push   %ebp
801073c1:	89 e5                	mov    %esp,%ebp
801073c3:	57                   	push   %edi
801073c4:	56                   	push   %esi
801073c5:	53                   	push   %ebx
801073c6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801073c9:	e8 02 fe ff ff       	call   801071d0 <setupkvm>
801073ce:	85 c0                	test   %eax,%eax
801073d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801073d3:	0f 84 a0 00 00 00    	je     80107479 <copyuvm+0xb9>
    return 0;

  for(i = 0; i < sz; i += PGSIZE){
801073d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801073dc:	85 c9                	test   %ecx,%ecx
801073de:	0f 84 95 00 00 00    	je     80107479 <copyuvm+0xb9>
801073e4:	31 f6                	xor    %esi,%esi
801073e6:	eb 4e                	jmp    80107436 <copyuvm+0x76>
801073e8:	90                   	nop
801073e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;

    memmove(mem, (char*)P2V(pa), PGSIZE);
801073f0:	83 ec 04             	sub    $0x4,%esp
801073f3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801073f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801073fc:	68 00 10 00 00       	push   $0x1000
80107401:	57                   	push   %edi
80107402:	50                   	push   %eax
80107403:	e8 48 d3 ff ff       	call   80104750 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107408:	58                   	pop    %eax
80107409:	5a                   	pop    %edx
8010740a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010740d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107410:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107415:	53                   	push   %ebx
80107416:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010741c:	52                   	push   %edx
8010741d:	89 f2                	mov    %esi,%edx
8010741f:	e8 cc f7 ff ff       	call   80106bf0 <mappages>
80107424:	83 c4 10             	add    $0x10,%esp
80107427:	85 c0                	test   %eax,%eax
80107429:	78 39                	js     80107464 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
8010742b:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107431:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107434:	76 43                	jbe    80107479 <copyuvm+0xb9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107436:	8b 45 08             	mov    0x8(%ebp),%eax
80107439:	31 c9                	xor    %ecx,%ecx
8010743b:	89 f2                	mov    %esi,%edx
8010743d:	e8 2e f7 ff ff       	call   80106b70 <walkpgdir>
80107442:	85 c0                	test   %eax,%eax
80107444:	74 3e                	je     80107484 <copyuvm+0xc4>
    if(!(*pte & PTE_P))
80107446:	8b 18                	mov    (%eax),%ebx
80107448:	f6 c3 01             	test   $0x1,%bl
8010744b:	74 44                	je     80107491 <copyuvm+0xd1>
    pa = PTE_ADDR(*pte);
8010744d:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
8010744f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80107455:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
8010745b:	e8 d0 b2 ff ff       	call   80102730 <kalloc>
80107460:	85 c0                	test   %eax,%eax
80107462:	75 8c                	jne    801073f0 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80107464:	83 ec 0c             	sub    $0xc,%esp
80107467:	ff 75 e0             	pushl  -0x20(%ebp)
8010746a:	e8 e1 fc ff ff       	call   80107150 <freevm>
  return 0;
8010746f:	83 c4 10             	add    $0x10,%esp
80107472:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107479:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010747c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010747f:	5b                   	pop    %ebx
80107480:	5e                   	pop    %esi
80107481:	5f                   	pop    %edi
80107482:	5d                   	pop    %ebp
80107483:	c3                   	ret    
      panic("copyuvm: pte should exist");
80107484:	83 ec 0c             	sub    $0xc,%esp
80107487:	68 2e 80 10 80       	push   $0x8010802e
8010748c:	e8 ff 8f ff ff       	call   80100490 <panic>
      panic("copyuvm: page not present");
80107491:	83 ec 0c             	sub    $0xc,%esp
80107494:	68 48 80 10 80       	push   $0x80108048
80107499:	e8 f2 8f ff ff       	call   80100490 <panic>
8010749e:	66 90                	xchg   %ax,%ax

801074a0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801074a0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801074a1:	31 c9                	xor    %ecx,%ecx
{
801074a3:	89 e5                	mov    %esp,%ebp
801074a5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801074a8:	8b 55 0c             	mov    0xc(%ebp),%edx
801074ab:	8b 45 08             	mov    0x8(%ebp),%eax
801074ae:	e8 bd f6 ff ff       	call   80106b70 <walkpgdir>
  if((*pte & PTE_P) == 0)
801074b3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801074b5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801074b6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801074b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801074bd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801074c0:	05 00 00 00 80       	add    $0x80000000,%eax
801074c5:	83 fa 05             	cmp    $0x5,%edx
801074c8:	ba 00 00 00 00       	mov    $0x0,%edx
801074cd:	0f 45 c2             	cmovne %edx,%eax
}
801074d0:	c3                   	ret    
801074d1:	eb 0d                	jmp    801074e0 <uva2pte>
801074d3:	90                   	nop
801074d4:	90                   	nop
801074d5:	90                   	nop
801074d6:	90                   	nop
801074d7:	90                   	nop
801074d8:	90                   	nop
801074d9:	90                   	nop
801074da:	90                   	nop
801074db:	90                   	nop
801074dc:	90                   	nop
801074dd:	90                   	nop
801074de:	90                   	nop
801074df:	90                   	nop

801074e0 <uva2pte>:

// returns the page table entry corresponding
// to a virtual address.
pte_t*
uva2pte(pde_t *pgdir, uint uva)
{
801074e0:	55                   	push   %ebp
  return walkpgdir(pgdir, (void*)uva, 0);
801074e1:	31 c9                	xor    %ecx,%ecx
{
801074e3:	89 e5                	mov    %esp,%ebp
  return walkpgdir(pgdir, (void*)uva, 0);
801074e5:	8b 55 0c             	mov    0xc(%ebp),%edx
801074e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
801074eb:	5d                   	pop    %ebp
  return walkpgdir(pgdir, (void*)uva, 0);
801074ec:	e9 7f f6 ff ff       	jmp    80106b70 <walkpgdir>
801074f1:	eb 0d                	jmp    80107500 <copyout>
801074f3:	90                   	nop
801074f4:	90                   	nop
801074f5:	90                   	nop
801074f6:	90                   	nop
801074f7:	90                   	nop
801074f8:	90                   	nop
801074f9:	90                   	nop
801074fa:	90                   	nop
801074fb:	90                   	nop
801074fc:	90                   	nop
801074fd:	90                   	nop
801074fe:	90                   	nop
801074ff:	90                   	nop

80107500 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107500:	55                   	push   %ebp
80107501:	89 e5                	mov    %esp,%ebp
80107503:	57                   	push   %edi
80107504:	56                   	push   %esi
80107505:	53                   	push   %ebx
80107506:	83 ec 1c             	sub    $0x1c,%esp
80107509:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010750c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010750f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107512:	85 db                	test   %ebx,%ebx
80107514:	75 40                	jne    80107556 <copyout+0x56>
80107516:	eb 70                	jmp    80107588 <copyout+0x88>
80107518:	90                   	nop
80107519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107520:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107523:	89 f1                	mov    %esi,%ecx
80107525:	29 d1                	sub    %edx,%ecx
80107527:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010752d:	39 d9                	cmp    %ebx,%ecx
8010752f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107532:	29 f2                	sub    %esi,%edx
80107534:	83 ec 04             	sub    $0x4,%esp
80107537:	01 d0                	add    %edx,%eax
80107539:	51                   	push   %ecx
8010753a:	57                   	push   %edi
8010753b:	50                   	push   %eax
8010753c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010753f:	e8 0c d2 ff ff       	call   80104750 <memmove>
    len -= n;
    buf += n;
80107544:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107547:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010754a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107550:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107552:	29 cb                	sub    %ecx,%ebx
80107554:	74 32                	je     80107588 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107556:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107558:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010755b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010755e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107564:	56                   	push   %esi
80107565:	ff 75 08             	pushl  0x8(%ebp)
80107568:	e8 33 ff ff ff       	call   801074a0 <uva2ka>
    if(pa0 == 0)
8010756d:	83 c4 10             	add    $0x10,%esp
80107570:	85 c0                	test   %eax,%eax
80107572:	75 ac                	jne    80107520 <copyout+0x20>
  }
  return 0;
}
80107574:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107577:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010757c:	5b                   	pop    %ebx
8010757d:	5e                   	pop    %esi
8010757e:	5f                   	pop    %edi
8010757f:	5d                   	pop    %ebp
80107580:	c3                   	ret    
80107581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107588:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010758b:	31 c0                	xor    %eax,%eax
}
8010758d:	5b                   	pop    %ebx
8010758e:	5e                   	pop    %esi
8010758f:	5f                   	pop    %edi
80107590:	5d                   	pop    %ebp
80107591:	c3                   	ret    
