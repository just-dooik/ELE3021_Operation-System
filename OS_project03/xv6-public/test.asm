
_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    exit();
  while (wait() != -1);
}

int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  int count[MAX_LEVEL] = {0};
  13:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  1a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  21:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  28:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  2f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

  parent = getpid();
  36:	e8 88 07 00 00       	call   7c3 <getpid>

  printf(1,"MLFQ test start\n");
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	68 39 0c 00 00       	push   $0xc39
  43:	6a 01                	push   $0x1
  parent = getpid();
  45:	a3 04 11 00 00       	mov    %eax,0x1104
  printf(1,"MLFQ test start\n");
  4a:	e8 81 08 00 00       	call   8d0 <printf>

  printf(1, "[Test 1] default\n");
  4f:	5e                   	pop    %esi
  50:	58                   	pop    %eax
  51:	68 4a 0c 00 00       	push   $0xc4a
  56:	6a 01                	push   $0x1
  58:	e8 73 08 00 00       	call   8d0 <printf>
  pid = fork_children();
  5d:	e8 ee 02 00 00       	call   350 <fork_children>

  if (pid != parent)
  62:	83 c4 10             	add    $0x10,%esp
  65:	39 05 04 11 00 00    	cmp    %eax,0x1104
  6b:	74 7d                	je     ea <main+0xea>
  6d:	89 c6                	mov    %eax,%esi
  6f:	bb a0 86 01 00       	mov    $0x186a0,%ebx
  74:	eb 1c                	jmp    92 <main+0x92>
  76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  7d:	8d 76 00             	lea    0x0(%esi),%esi
    for (i = 0; i < NUM_LOOP; i++)
    {
      int x = getlev();
      if (x < 0 || x > 3)
      {
	if(x != 99){
  80:	83 f8 63             	cmp    $0x63,%eax
  83:	0f 85 c7 00 00 00    	jne    150 <main+0x150>
          printf(1, "Wrong level: %d\n", x);
          exit();
	} 
      }
      if(x == 99) count[4]++;
  89:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    for (i = 0; i < NUM_LOOP; i++)
  8d:	83 eb 01             	sub    $0x1,%ebx
  90:	74 14                	je     a6 <main+0xa6>
      int x = getlev();
  92:	e8 54 07 00 00       	call   7eb <getlev>
      if (x < 0 || x > 3)
  97:	83 f8 03             	cmp    $0x3,%eax
  9a:	77 e4                	ja     80 <main+0x80>
      else count[x]++;
  9c:	83 44 85 d4 01       	addl   $0x1,-0x2c(%ebp,%eax,4)
    for (i = 0; i < NUM_LOOP; i++)
  a1:	83 eb 01             	sub    $0x1,%ebx
  a4:	75 ec                	jne    92 <main+0x92>
    }
    printf(1, "Process %d\n", pid);
  a6:	53                   	push   %ebx
    for (i = 0; i < MAX_LEVEL - 1; i++)
  a7:	31 db                	xor    %ebx,%ebx
    printf(1, "Process %d\n", pid);
  a9:	56                   	push   %esi
  aa:	8d 75 d4             	lea    -0x2c(%ebp),%esi
  ad:	68 6d 0c 00 00       	push   $0xc6d
  b2:	6a 01                	push   $0x1
  b4:	e8 17 08 00 00       	call   8d0 <printf>
  b9:	83 c4 10             	add    $0x10,%esp
      printf(1, "L%d: %d\n", i, count[i]);
  bc:	ff 34 9e             	push   (%esi,%ebx,4)
  bf:	53                   	push   %ebx
    for (i = 0; i < MAX_LEVEL - 1; i++)
  c0:	83 c3 01             	add    $0x1,%ebx
      printf(1, "L%d: %d\n", i, count[i]);
  c3:	68 79 0c 00 00       	push   $0xc79
  c8:	6a 01                	push   $0x1
  ca:	e8 01 08 00 00       	call   8d0 <printf>
    for (i = 0; i < MAX_LEVEL - 1; i++)
  cf:	83 c4 10             	add    $0x10,%esp
  d2:	83 fb 04             	cmp    $0x4,%ebx
  d5:	75 e5                	jne    bc <main+0xbc>
    printf(1, "MoQ: %d\n", count[4]);
  d7:	51                   	push   %ecx
  d8:	ff 75 e4             	push   -0x1c(%ebp)
  db:	68 82 0c 00 00       	push   $0xc82
  e0:	6a 01                	push   $0x1
  e2:	e8 e9 07 00 00       	call   8d0 <printf>
  e7:	83 c4 10             	add    $0x10,%esp
  }
  exit_children();
  ea:	e8 d1 03 00 00       	call   4c0 <exit_children>
  printf(1, "[Test 1] finished\n");
  ef:	56                   	push   %esi
  f0:	56                   	push   %esi
  f1:	68 8b 0c 00 00       	push   $0xc8b
  f6:	6a 01                	push   $0x1
  f8:	e8 d3 07 00 00       	call   8d0 <printf>

  printf(1, "[Test 2] priorities\n");
  fd:	58                   	pop    %eax
  fe:	5a                   	pop    %edx
  ff:	68 9e 0c 00 00       	push   $0xc9e
 104:	6a 01                	push   $0x1
 106:	e8 c5 07 00 00       	call   8d0 <printf>
  pid = fork_children2();
 10b:	e8 90 02 00 00       	call   3a0 <fork_children2>

  if (pid != parent)
 110:	83 c4 10             	add    $0x10,%esp
  pid = fork_children2();
 113:	89 c6                	mov    %eax,%esi
  if (pid != parent)
 115:	39 05 04 11 00 00    	cmp    %eax,0x1104
 11b:	0f 84 88 00 00 00    	je     1a9 <main+0x1a9>
 121:	bb a0 86 01 00       	mov    $0x186a0,%ebx
 126:	eb 16                	jmp    13e <main+0x13e>
 128:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 12f:	90                   	nop
    for (i = 0; i < NUM_LOOP; i++)
    {
      int x = getlev();
      if (x < 0 || x > 3)
      {
	if(x != 99){
 130:	83 f8 63             	cmp    $0x63,%eax
 133:	75 1b                	jne    150 <main+0x150>
          printf(1, "Wrong level: %d\n", x);
          exit();
	}
      }
      if(x == 99) count[4]++;
 135:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    for (i = 0; i < NUM_LOOP; i++)
 139:	83 eb 01             	sub    $0x1,%ebx
 13c:	74 27                	je     165 <main+0x165>
      int x = getlev();
 13e:	e8 a8 06 00 00       	call   7eb <getlev>
      if (x < 0 || x > 3)
 143:	83 f8 03             	cmp    $0x3,%eax
 146:	77 e8                	ja     130 <main+0x130>
      else count[x]++;
 148:	83 44 85 d4 01       	addl   $0x1,-0x2c(%ebp,%eax,4)
 14d:	eb ea                	jmp    139 <main+0x139>
 14f:	90                   	nop
      int x = getlev();
      if(x < 0 || x > 3)
      {
        if(x != 99)
        {
	  printf(1, "Wrong level: %d\n", x);
 150:	83 ec 04             	sub    $0x4,%esp
 153:	50                   	push   %eax
 154:	68 5c 0c 00 00       	push   $0xc5c
 159:	6a 01                	push   $0x1
 15b:	e8 70 07 00 00       	call   8d0 <printf>
	  exit();
 160:	e8 de 05 00 00       	call   743 <exit>
    printf(1, "Process %d\n", pid);
 165:	53                   	push   %ebx
    for (i = 0; i < MAX_LEVEL - 1; i++)
 166:	31 db                	xor    %ebx,%ebx
    printf(1, "Process %d\n", pid);
 168:	56                   	push   %esi
 169:	8d 75 d4             	lea    -0x2c(%ebp),%esi
 16c:	68 6d 0c 00 00       	push   $0xc6d
 171:	6a 01                	push   $0x1
 173:	e8 58 07 00 00       	call   8d0 <printf>
 178:	83 c4 10             	add    $0x10,%esp
      printf(1, "L%d: %d\n", i, count[i]);
 17b:	ff 34 9e             	push   (%esi,%ebx,4)
 17e:	53                   	push   %ebx
    for (i = 0; i < MAX_LEVEL - 1; i++)
 17f:	83 c3 01             	add    $0x1,%ebx
      printf(1, "L%d: %d\n", i, count[i]);
 182:	68 79 0c 00 00       	push   $0xc79
 187:	6a 01                	push   $0x1
 189:	e8 42 07 00 00       	call   8d0 <printf>
    for (i = 0; i < MAX_LEVEL - 1; i++)
 18e:	83 c4 10             	add    $0x10,%esp
 191:	83 fb 04             	cmp    $0x4,%ebx
 194:	75 e5                	jne    17b <main+0x17b>
    printf(1, "MoQ: %d\n", count[4]);
 196:	51                   	push   %ecx
 197:	ff 75 e4             	push   -0x1c(%ebp)
 19a:	68 82 0c 00 00       	push   $0xc82
 19f:	6a 01                	push   $0x1
 1a1:	e8 2a 07 00 00       	call   8d0 <printf>
 1a6:	83 c4 10             	add    $0x10,%esp
  exit_children();
 1a9:	e8 12 03 00 00       	call   4c0 <exit_children>
  printf(1, "[Test 2] finished\n");
 1ae:	56                   	push   %esi
 1af:	56                   	push   %esi
 1b0:	68 b3 0c 00 00       	push   $0xcb3
 1b5:	6a 01                	push   $0x1
 1b7:	e8 14 07 00 00       	call   8d0 <printf>
  printf(1, "[Test 3] sleep\n");
 1bc:	58                   	pop    %eax
 1bd:	5a                   	pop    %edx
 1be:	68 c6 0c 00 00       	push   $0xcc6
 1c3:	6a 01                	push   $0x1
 1c5:	e8 06 07 00 00       	call   8d0 <printf>
  pid = fork_children2();
 1ca:	e8 d1 01 00 00       	call   3a0 <fork_children2>
  if (pid != parent)
 1cf:	83 c4 10             	add    $0x10,%esp
  pid = fork_children2();
 1d2:	89 c6                	mov    %eax,%esi
  if (pid != parent)
 1d4:	39 05 04 11 00 00    	cmp    %eax,0x1104
 1da:	0f 84 84 00 00 00    	je     264 <main+0x264>
 1e0:	bb f4 01 00 00       	mov    $0x1f4,%ebx
 1e5:	eb 28                	jmp    20f <main+0x20f>
 1e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ee:	66 90                	xchg   %ax,%ax
	if(x != 99){
 1f0:	83 f8 63             	cmp    $0x63,%eax
 1f3:	0f 85 57 ff ff ff    	jne    150 <main+0x150>
      if(x == 99) count[4]++;
 1f9:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
      sleep(1);
 1fd:	83 ec 0c             	sub    $0xc,%esp
 200:	6a 01                	push   $0x1
 202:	e8 cc 05 00 00       	call   7d3 <sleep>
    for (i = 0; i < NUM_SLEEP; i++)
 207:	83 c4 10             	add    $0x10,%esp
 20a:	83 eb 01             	sub    $0x1,%ebx
 20d:	74 11                	je     220 <main+0x220>
      int x = getlev();
 20f:	e8 d7 05 00 00       	call   7eb <getlev>
      if (x < 0 || x > 3)
 214:	83 f8 03             	cmp    $0x3,%eax
 217:	77 d7                	ja     1f0 <main+0x1f0>
      else count[x]++;
 219:	83 44 85 d4 01       	addl   $0x1,-0x2c(%ebp,%eax,4)
 21e:	eb dd                	jmp    1fd <main+0x1fd>
    printf(1, "Process %d\n", pid);
 220:	53                   	push   %ebx
    for (i = 0; i < MAX_LEVEL - 1; i++)
 221:	31 db                	xor    %ebx,%ebx
    printf(1, "Process %d\n", pid);
 223:	56                   	push   %esi
 224:	8d 75 d4             	lea    -0x2c(%ebp),%esi
 227:	68 6d 0c 00 00       	push   $0xc6d
 22c:	6a 01                	push   $0x1
 22e:	e8 9d 06 00 00       	call   8d0 <printf>
 233:	83 c4 10             	add    $0x10,%esp
      printf(1, "L%d: %d\n", i, count[i]);
 236:	ff 34 9e             	push   (%esi,%ebx,4)
 239:	53                   	push   %ebx
    for (i = 0; i < MAX_LEVEL - 1; i++)
 23a:	83 c3 01             	add    $0x1,%ebx
      printf(1, "L%d: %d\n", i, count[i]);
 23d:	68 79 0c 00 00       	push   $0xc79
 242:	6a 01                	push   $0x1
 244:	e8 87 06 00 00       	call   8d0 <printf>
    for (i = 0; i < MAX_LEVEL - 1; i++)
 249:	83 c4 10             	add    $0x10,%esp
 24c:	83 fb 04             	cmp    $0x4,%ebx
 24f:	75 e5                	jne    236 <main+0x236>
    printf(1, "MoQ: %d\n", count[4]);
 251:	51                   	push   %ecx
 252:	ff 75 e4             	push   -0x1c(%ebp)
 255:	68 82 0c 00 00       	push   $0xc82
 25a:	6a 01                	push   $0x1
 25c:	e8 6f 06 00 00       	call   8d0 <printf>
 261:	83 c4 10             	add    $0x10,%esp
  exit_children();
 264:	e8 57 02 00 00       	call   4c0 <exit_children>
  printf(1, "[Test 3] finished\n");
 269:	56                   	push   %esi
 26a:	56                   	push   %esi
 26b:	68 d6 0c 00 00       	push   $0xcd6
 270:	6a 01                	push   $0x1
 272:	e8 59 06 00 00       	call   8d0 <printf>
  printf(1, "[Test 4] MoQ\n");
 277:	58                   	pop    %eax
 278:	5a                   	pop    %edx
 279:	68 e9 0c 00 00       	push   $0xce9
 27e:	6a 01                	push   $0x1
 280:	e8 4b 06 00 00       	call   8d0 <printf>
  pid = fork_children3();
 285:	e8 86 01 00 00       	call   410 <fork_children3>
  printf(1, "pid: %d\n", pid);
 28a:	83 c4 0c             	add    $0xc,%esp
 28d:	50                   	push   %eax
  pid = fork_children3();
 28e:	89 c6                	mov    %eax,%esi
  printf(1, "pid: %d\n", pid);
 290:	68 f7 0c 00 00       	push   $0xcf7
 295:	6a 01                	push   $0x1
 297:	e8 34 06 00 00       	call   8d0 <printf>
  if(pid != parent)
 29c:	83 c4 10             	add    $0x10,%esp
 29f:	39 35 04 11 00 00    	cmp    %esi,0x1104
 2a5:	0f 84 89 00 00 00    	je     334 <main+0x334>
    if(pid == 36)
 2ab:	bb a0 86 01 00       	mov    $0x186a0,%ebx
 2b0:	83 fe 24             	cmp    $0x24,%esi
 2b3:	75 2a                	jne    2df <main+0x2df>
      monopolize();
 2b5:	e8 49 05 00 00       	call   803 <monopolize>
      printf(1, "Monopolize\n");
 2ba:	53                   	push   %ebx
 2bb:	53                   	push   %ebx
 2bc:	68 00 0d 00 00       	push   $0xd00
 2c1:	6a 01                	push   $0x1
 2c3:	e8 08 06 00 00       	call   8d0 <printf>
      exit();
 2c8:	e8 76 04 00 00       	call   743 <exit>
        if(x != 99)
 2cd:	83 f8 63             	cmp    $0x63,%eax
 2d0:	0f 85 7a fe ff ff    	jne    150 <main+0x150>
	}
      }
      if(x == 99) count[4]++;
 2d6:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
    for(i = 0; i < NUM_LOOP; i++)
 2da:	83 eb 01             	sub    $0x1,%ebx
 2dd:	74 11                	je     2f0 <main+0x2f0>
      int x = getlev();
 2df:	e8 07 05 00 00       	call   7eb <getlev>
      if(x < 0 || x > 3)
 2e4:	83 f8 03             	cmp    $0x3,%eax
 2e7:	77 e4                	ja     2cd <main+0x2cd>
      else count[x]++;
 2e9:	83 44 85 d4 01       	addl   $0x1,-0x2c(%ebp,%eax,4)
 2ee:	eb ea                	jmp    2da <main+0x2da>
    }
    printf(1, "Process %d\n", pid);
 2f0:	51                   	push   %ecx
    for(i = 0; i < MAX_LEVEL - 1; i++)
 2f1:	31 db                	xor    %ebx,%ebx
    printf(1, "Process %d\n", pid);
 2f3:	56                   	push   %esi
 2f4:	8d 75 d4             	lea    -0x2c(%ebp),%esi
 2f7:	68 6d 0c 00 00       	push   $0xc6d
 2fc:	6a 01                	push   $0x1
 2fe:	e8 cd 05 00 00       	call   8d0 <printf>
 303:	83 c4 10             	add    $0x10,%esp
      printf(1, "L%d: %d\n",i,count[i]);
 306:	ff 34 9e             	push   (%esi,%ebx,4)
 309:	53                   	push   %ebx
    for(i = 0; i < MAX_LEVEL - 1; i++)
 30a:	83 c3 01             	add    $0x1,%ebx
      printf(1, "L%d: %d\n",i,count[i]);
 30d:	68 79 0c 00 00       	push   $0xc79
 312:	6a 01                	push   $0x1
 314:	e8 b7 05 00 00       	call   8d0 <printf>
    for(i = 0; i < MAX_LEVEL - 1; i++)
 319:	83 c4 10             	add    $0x10,%esp
 31c:	83 fb 04             	cmp    $0x4,%ebx
 31f:	75 e5                	jne    306 <main+0x306>
    printf(1, "MoQ: %d\n", count[i]);
 321:	52                   	push   %edx
 322:	ff 75 e4             	push   -0x1c(%ebp)
 325:	68 82 0c 00 00       	push   $0xc82
 32a:	6a 01                	push   $0x1
 32c:	e8 9f 05 00 00       	call   8d0 <printf>
 331:	83 c4 10             	add    $0x10,%esp
  }
  exit_children();
 334:	e8 87 01 00 00       	call   4c0 <exit_children>
  printf(1, "[Test 4] finished\n");
 339:	50                   	push   %eax
 33a:	50                   	push   %eax
 33b:	68 0c 0d 00 00       	push   $0xd0c
 340:	6a 01                	push   $0x1
 342:	e8 89 05 00 00       	call   8d0 <printf>

  exit();
 347:	e8 f7 03 00 00       	call   743 <exit>
 34c:	66 90                	xchg   %ax,%ax
 34e:	66 90                	xchg   %ax,%ax

00000350 <fork_children>:
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	53                   	push   %ebx
 354:	bb 08 00 00 00       	mov    $0x8,%ebx
 359:	83 ec 04             	sub    $0x4,%esp
 35c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if ((p = fork()) == 0)
 360:	e8 d6 03 00 00       	call   73b <fork>
 365:	85 c0                	test   %eax,%eax
 367:	74 17                	je     380 <fork_children+0x30>
  for (i = 0; i < NUM_THREAD; i++)
 369:	83 eb 01             	sub    $0x1,%ebx
 36c:	75 f2                	jne    360 <fork_children+0x10>
}
 36e:	a1 04 11 00 00       	mov    0x1104,%eax
 373:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 376:	c9                   	leave  
 377:	c3                   	ret    
 378:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 37f:	90                   	nop
      sleep(10);
 380:	83 ec 0c             	sub    $0xc,%esp
 383:	6a 0a                	push   $0xa
 385:	e8 49 04 00 00       	call   7d3 <sleep>
}
 38a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return getpid();
 38d:	83 c4 10             	add    $0x10,%esp
}
 390:	c9                   	leave  
      return getpid();
 391:	e9 2d 04 00 00       	jmp    7c3 <getpid>
 396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 39d:	8d 76 00             	lea    0x0(%esi),%esi

000003a0 <fork_children2>:
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	53                   	push   %ebx
  for (i = 0; i < NUM_THREAD; i++)
 3a4:	31 db                	xor    %ebx,%ebx
{
 3a6:	83 ec 04             	sub    $0x4,%esp
 3a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if ((p = fork()) == 0)
 3b0:	e8 86 03 00 00       	call   73b <fork>
 3b5:	85 c0                	test   %eax,%eax
 3b7:	74 27                	je     3e0 <fork_children2+0x40>
      int r = setpriority(p, i + 1);
 3b9:	83 ec 08             	sub    $0x8,%esp
 3bc:	83 c3 01             	add    $0x1,%ebx
 3bf:	53                   	push   %ebx
 3c0:	50                   	push   %eax
 3c1:	e8 2d 04 00 00       	call   7f3 <setpriority>
      if (r < 0)
 3c6:	83 c4 10             	add    $0x10,%esp
 3c9:	85 c0                	test   %eax,%eax
 3cb:	78 29                	js     3f6 <fork_children2+0x56>
  for (i = 0; i < NUM_THREAD; i++)
 3cd:	83 fb 08             	cmp    $0x8,%ebx
 3d0:	75 de                	jne    3b0 <fork_children2+0x10>
}
 3d2:	a1 04 11 00 00       	mov    0x1104,%eax
 3d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3da:	c9                   	leave  
 3db:	c3                   	ret    
 3dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      sleep(10);
 3e0:	83 ec 0c             	sub    $0xc,%esp
 3e3:	6a 0a                	push   $0xa
 3e5:	e8 e9 03 00 00       	call   7d3 <sleep>
}
 3ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return getpid();
 3ed:	83 c4 10             	add    $0x10,%esp
}
 3f0:	c9                   	leave  
      return getpid();
 3f1:	e9 cd 03 00 00       	jmp    7c3 <getpid>
        printf(1, "setpriority returned %d\n", r);
 3f6:	83 ec 04             	sub    $0x4,%esp
 3f9:	50                   	push   %eax
 3fa:	68 f8 0b 00 00       	push   $0xbf8
 3ff:	6a 01                	push   $0x1
 401:	e8 ca 04 00 00       	call   8d0 <printf>
        exit();
 406:	e8 38 03 00 00       	call   743 <exit>
 40b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 40f:	90                   	nop

00000410 <fork_children3>:
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	56                   	push   %esi
 414:	53                   	push   %ebx
 415:	bb 09 00 00 00       	mov    $0x9,%ebx
 41a:	eb 09                	jmp    425 <fork_children3+0x15>
 41c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0;i<=NUM_THREAD;i++){
 420:	83 eb 01             	sub    $0x1,%ebx
 423:	74 5b                	je     480 <fork_children3+0x70>
    if((p = fork()) == 0)
 425:	e8 11 03 00 00       	call   73b <fork>
 42a:	85 c0                	test   %eax,%eax
 42c:	74 62                	je     490 <fork_children3+0x80>
      if(p % 2 == 1)
 42e:	89 c1                	mov    %eax,%ecx
 430:	c1 e9 1f             	shr    $0x1f,%ecx
 433:	8d 14 08             	lea    (%eax,%ecx,1),%edx
 436:	83 e2 01             	and    $0x1,%edx
 439:	29 ca                	sub    %ecx,%edx
 43b:	83 fa 01             	cmp    $0x1,%edx
 43e:	75 e0                	jne    420 <fork_children3+0x10>
        r = setmonopoly(p,2020099743); // input your student number
 440:	83 ec 08             	sub    $0x8,%esp
 443:	68 9f 46 68 78       	push   $0x7868469f
 448:	50                   	push   %eax
 449:	e8 ad 03 00 00       	call   7fb <setmonopoly>
        printf(1, "Number of processes in MoQ: %d\n",r);
 44e:	83 c4 0c             	add    $0xc,%esp
 451:	50                   	push   %eax
        r = setmonopoly(p,2020099743); // input your student number
 452:	89 c6                	mov    %eax,%esi
        printf(1, "Number of processes in MoQ: %d\n",r);
 454:	68 20 0d 00 00       	push   $0xd20
 459:	6a 01                	push   $0x1
 45b:	e8 70 04 00 00       	call   8d0 <printf>
      if(r < 0)
 460:	83 c4 10             	add    $0x10,%esp
 463:	85 f6                	test   %esi,%esi
 465:	79 b9                	jns    420 <fork_children3+0x10>
        printf(1, "setmonopoly returned %d\n", r);
 467:	50                   	push   %eax
 468:	56                   	push   %esi
 469:	68 20 0c 00 00       	push   $0xc20
 46e:	6a 01                	push   $0x1
 470:	e8 5b 04 00 00       	call   8d0 <printf>
        exit();
 475:	e8 c9 02 00 00       	call   743 <exit>
 47a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
 480:	a1 04 11 00 00       	mov    0x1104,%eax
 485:	8d 65 f8             	lea    -0x8(%ebp),%esp
 488:	5b                   	pop    %ebx
 489:	5e                   	pop    %esi
 48a:	5d                   	pop    %ebp
 48b:	c3                   	ret    
 48c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "sleeps 10: %d\n", getpid());
 490:	e8 2e 03 00 00       	call   7c3 <getpid>
 495:	83 ec 04             	sub    $0x4,%esp
 498:	50                   	push   %eax
 499:	68 11 0c 00 00       	push   $0xc11
 49e:	6a 01                	push   $0x1
 4a0:	e8 2b 04 00 00       	call   8d0 <printf>
      sleep(10);
 4a5:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
 4ac:	e8 22 03 00 00       	call   7d3 <sleep>
      return getpid();
 4b1:	83 c4 10             	add    $0x10,%esp
}
 4b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4b7:	5b                   	pop    %ebx
 4b8:	5e                   	pop    %esi
 4b9:	5d                   	pop    %ebp
      return getpid();
 4ba:	e9 04 03 00 00       	jmp    7c3 <getpid>
 4bf:	90                   	nop

000004c0 <exit_children>:
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	83 ec 08             	sub    $0x8,%esp
  if (getpid() != parent)
 4c6:	e8 f8 02 00 00       	call   7c3 <getpid>
 4cb:	3b 05 04 11 00 00    	cmp    0x1104,%eax
 4d1:	75 11                	jne    4e4 <exit_children+0x24>
 4d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4d7:	90                   	nop
  while (wait() != -1);
 4d8:	e8 6e 02 00 00       	call   74b <wait>
 4dd:	83 f8 ff             	cmp    $0xffffffff,%eax
 4e0:	75 f6                	jne    4d8 <exit_children+0x18>
}
 4e2:	c9                   	leave  
 4e3:	c3                   	ret    
    exit();
 4e4:	e8 5a 02 00 00       	call   743 <exit>
 4e9:	66 90                	xchg   %ax,%ax
 4eb:	66 90                	xchg   %ax,%ax
 4ed:	66 90                	xchg   %ax,%ax
 4ef:	90                   	nop

000004f0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 4f0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4f1:	31 c0                	xor    %eax,%eax
{
 4f3:	89 e5                	mov    %esp,%ebp
 4f5:	53                   	push   %ebx
 4f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 4f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 4fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 500:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 504:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 507:	83 c0 01             	add    $0x1,%eax
 50a:	84 d2                	test   %dl,%dl
 50c:	75 f2                	jne    500 <strcpy+0x10>
    ;
  return os;
}
 50e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 511:	89 c8                	mov    %ecx,%eax
 513:	c9                   	leave  
 514:	c3                   	ret    
 515:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 51c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000520 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	53                   	push   %ebx
 524:	8b 55 08             	mov    0x8(%ebp),%edx
 527:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 52a:	0f b6 02             	movzbl (%edx),%eax
 52d:	84 c0                	test   %al,%al
 52f:	75 17                	jne    548 <strcmp+0x28>
 531:	eb 3a                	jmp    56d <strcmp+0x4d>
 533:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 537:	90                   	nop
 538:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 53c:	83 c2 01             	add    $0x1,%edx
 53f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 542:	84 c0                	test   %al,%al
 544:	74 1a                	je     560 <strcmp+0x40>
    p++, q++;
 546:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 548:	0f b6 19             	movzbl (%ecx),%ebx
 54b:	38 c3                	cmp    %al,%bl
 54d:	74 e9                	je     538 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 54f:	29 d8                	sub    %ebx,%eax
}
 551:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 554:	c9                   	leave  
 555:	c3                   	ret    
 556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 55d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 560:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 564:	31 c0                	xor    %eax,%eax
 566:	29 d8                	sub    %ebx,%eax
}
 568:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 56b:	c9                   	leave  
 56c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 56d:	0f b6 19             	movzbl (%ecx),%ebx
 570:	31 c0                	xor    %eax,%eax
 572:	eb db                	jmp    54f <strcmp+0x2f>
 574:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 57b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 57f:	90                   	nop

00000580 <strlen>:

uint
strlen(const char *s)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 586:	80 3a 00             	cmpb   $0x0,(%edx)
 589:	74 15                	je     5a0 <strlen+0x20>
 58b:	31 c0                	xor    %eax,%eax
 58d:	8d 76 00             	lea    0x0(%esi),%esi
 590:	83 c0 01             	add    $0x1,%eax
 593:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 597:	89 c1                	mov    %eax,%ecx
 599:	75 f5                	jne    590 <strlen+0x10>
    ;
  return n;
}
 59b:	89 c8                	mov    %ecx,%eax
 59d:	5d                   	pop    %ebp
 59e:	c3                   	ret    
 59f:	90                   	nop
  for(n = 0; s[n]; n++)
 5a0:	31 c9                	xor    %ecx,%ecx
}
 5a2:	5d                   	pop    %ebp
 5a3:	89 c8                	mov    %ecx,%eax
 5a5:	c3                   	ret    
 5a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ad:	8d 76 00             	lea    0x0(%esi),%esi

000005b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	57                   	push   %edi
 5b4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 5b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 5bd:	89 d7                	mov    %edx,%edi
 5bf:	fc                   	cld    
 5c0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 5c2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 5c5:	89 d0                	mov    %edx,%eax
 5c7:	c9                   	leave  
 5c8:	c3                   	ret    
 5c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000005d0 <strchr>:

char*
strchr(const char *s, char c)
{
 5d0:	55                   	push   %ebp
 5d1:	89 e5                	mov    %esp,%ebp
 5d3:	8b 45 08             	mov    0x8(%ebp),%eax
 5d6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 5da:	0f b6 10             	movzbl (%eax),%edx
 5dd:	84 d2                	test   %dl,%dl
 5df:	75 12                	jne    5f3 <strchr+0x23>
 5e1:	eb 1d                	jmp    600 <strchr+0x30>
 5e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5e7:	90                   	nop
 5e8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 5ec:	83 c0 01             	add    $0x1,%eax
 5ef:	84 d2                	test   %dl,%dl
 5f1:	74 0d                	je     600 <strchr+0x30>
    if(*s == c)
 5f3:	38 d1                	cmp    %dl,%cl
 5f5:	75 f1                	jne    5e8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 5f7:	5d                   	pop    %ebp
 5f8:	c3                   	ret    
 5f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 600:	31 c0                	xor    %eax,%eax
}
 602:	5d                   	pop    %ebp
 603:	c3                   	ret    
 604:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 60b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 60f:	90                   	nop

00000610 <gets>:

char*
gets(char *buf, int max)
{
 610:	55                   	push   %ebp
 611:	89 e5                	mov    %esp,%ebp
 613:	57                   	push   %edi
 614:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 615:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 618:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 619:	31 db                	xor    %ebx,%ebx
{
 61b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 61e:	eb 27                	jmp    647 <gets+0x37>
    cc = read(0, &c, 1);
 620:	83 ec 04             	sub    $0x4,%esp
 623:	6a 01                	push   $0x1
 625:	57                   	push   %edi
 626:	6a 00                	push   $0x0
 628:	e8 2e 01 00 00       	call   75b <read>
    if(cc < 1)
 62d:	83 c4 10             	add    $0x10,%esp
 630:	85 c0                	test   %eax,%eax
 632:	7e 1d                	jle    651 <gets+0x41>
      break;
    buf[i++] = c;
 634:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 638:	8b 55 08             	mov    0x8(%ebp),%edx
 63b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 63f:	3c 0a                	cmp    $0xa,%al
 641:	74 1d                	je     660 <gets+0x50>
 643:	3c 0d                	cmp    $0xd,%al
 645:	74 19                	je     660 <gets+0x50>
  for(i=0; i+1 < max; ){
 647:	89 de                	mov    %ebx,%esi
 649:	83 c3 01             	add    $0x1,%ebx
 64c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 64f:	7c cf                	jl     620 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 651:	8b 45 08             	mov    0x8(%ebp),%eax
 654:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 658:	8d 65 f4             	lea    -0xc(%ebp),%esp
 65b:	5b                   	pop    %ebx
 65c:	5e                   	pop    %esi
 65d:	5f                   	pop    %edi
 65e:	5d                   	pop    %ebp
 65f:	c3                   	ret    
  buf[i] = '\0';
 660:	8b 45 08             	mov    0x8(%ebp),%eax
 663:	89 de                	mov    %ebx,%esi
 665:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 669:	8d 65 f4             	lea    -0xc(%ebp),%esp
 66c:	5b                   	pop    %ebx
 66d:	5e                   	pop    %esi
 66e:	5f                   	pop    %edi
 66f:	5d                   	pop    %ebp
 670:	c3                   	ret    
 671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 678:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 67f:	90                   	nop

00000680 <stat>:

int
stat(const char *n, struct stat *st)
{
 680:	55                   	push   %ebp
 681:	89 e5                	mov    %esp,%ebp
 683:	56                   	push   %esi
 684:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 685:	83 ec 08             	sub    $0x8,%esp
 688:	6a 00                	push   $0x0
 68a:	ff 75 08             	push   0x8(%ebp)
 68d:	e8 f1 00 00 00       	call   783 <open>
  if(fd < 0)
 692:	83 c4 10             	add    $0x10,%esp
 695:	85 c0                	test   %eax,%eax
 697:	78 27                	js     6c0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 699:	83 ec 08             	sub    $0x8,%esp
 69c:	ff 75 0c             	push   0xc(%ebp)
 69f:	89 c3                	mov    %eax,%ebx
 6a1:	50                   	push   %eax
 6a2:	e8 f4 00 00 00       	call   79b <fstat>
  close(fd);
 6a7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 6aa:	89 c6                	mov    %eax,%esi
  close(fd);
 6ac:	e8 ba 00 00 00       	call   76b <close>
  return r;
 6b1:	83 c4 10             	add    $0x10,%esp
}
 6b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 6b7:	89 f0                	mov    %esi,%eax
 6b9:	5b                   	pop    %ebx
 6ba:	5e                   	pop    %esi
 6bb:	5d                   	pop    %ebp
 6bc:	c3                   	ret    
 6bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 6c0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 6c5:	eb ed                	jmp    6b4 <stat+0x34>
 6c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6ce:	66 90                	xchg   %ax,%ax

000006d0 <atoi>:

int
atoi(const char *s)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	53                   	push   %ebx
 6d4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6d7:	0f be 02             	movsbl (%edx),%eax
 6da:	8d 48 d0             	lea    -0x30(%eax),%ecx
 6dd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 6e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 6e5:	77 1e                	ja     705 <atoi+0x35>
 6e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6ee:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 6f0:	83 c2 01             	add    $0x1,%edx
 6f3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 6f6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 6fa:	0f be 02             	movsbl (%edx),%eax
 6fd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 700:	80 fb 09             	cmp    $0x9,%bl
 703:	76 eb                	jbe    6f0 <atoi+0x20>
  return n;
}
 705:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 708:	89 c8                	mov    %ecx,%eax
 70a:	c9                   	leave  
 70b:	c3                   	ret    
 70c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000710 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	57                   	push   %edi
 714:	8b 45 10             	mov    0x10(%ebp),%eax
 717:	8b 55 08             	mov    0x8(%ebp),%edx
 71a:	56                   	push   %esi
 71b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 71e:	85 c0                	test   %eax,%eax
 720:	7e 13                	jle    735 <memmove+0x25>
 722:	01 d0                	add    %edx,%eax
  dst = vdst;
 724:	89 d7                	mov    %edx,%edi
 726:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 72d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 730:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 731:	39 f8                	cmp    %edi,%eax
 733:	75 fb                	jne    730 <memmove+0x20>
  return vdst;
}
 735:	5e                   	pop    %esi
 736:	89 d0                	mov    %edx,%eax
 738:	5f                   	pop    %edi
 739:	5d                   	pop    %ebp
 73a:	c3                   	ret    

0000073b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 73b:	b8 01 00 00 00       	mov    $0x1,%eax
 740:	cd 40                	int    $0x40
 742:	c3                   	ret    

00000743 <exit>:
SYSCALL(exit)
 743:	b8 02 00 00 00       	mov    $0x2,%eax
 748:	cd 40                	int    $0x40
 74a:	c3                   	ret    

0000074b <wait>:
SYSCALL(wait)
 74b:	b8 03 00 00 00       	mov    $0x3,%eax
 750:	cd 40                	int    $0x40
 752:	c3                   	ret    

00000753 <pipe>:
SYSCALL(pipe)
 753:	b8 04 00 00 00       	mov    $0x4,%eax
 758:	cd 40                	int    $0x40
 75a:	c3                   	ret    

0000075b <read>:
SYSCALL(read)
 75b:	b8 05 00 00 00       	mov    $0x5,%eax
 760:	cd 40                	int    $0x40
 762:	c3                   	ret    

00000763 <write>:
SYSCALL(write)
 763:	b8 10 00 00 00       	mov    $0x10,%eax
 768:	cd 40                	int    $0x40
 76a:	c3                   	ret    

0000076b <close>:
SYSCALL(close)
 76b:	b8 15 00 00 00       	mov    $0x15,%eax
 770:	cd 40                	int    $0x40
 772:	c3                   	ret    

00000773 <kill>:
SYSCALL(kill)
 773:	b8 06 00 00 00       	mov    $0x6,%eax
 778:	cd 40                	int    $0x40
 77a:	c3                   	ret    

0000077b <exec>:
SYSCALL(exec)
 77b:	b8 07 00 00 00       	mov    $0x7,%eax
 780:	cd 40                	int    $0x40
 782:	c3                   	ret    

00000783 <open>:
SYSCALL(open)
 783:	b8 0f 00 00 00       	mov    $0xf,%eax
 788:	cd 40                	int    $0x40
 78a:	c3                   	ret    

0000078b <mknod>:
SYSCALL(mknod)
 78b:	b8 11 00 00 00       	mov    $0x11,%eax
 790:	cd 40                	int    $0x40
 792:	c3                   	ret    

00000793 <unlink>:
SYSCALL(unlink)
 793:	b8 12 00 00 00       	mov    $0x12,%eax
 798:	cd 40                	int    $0x40
 79a:	c3                   	ret    

0000079b <fstat>:
SYSCALL(fstat)
 79b:	b8 08 00 00 00       	mov    $0x8,%eax
 7a0:	cd 40                	int    $0x40
 7a2:	c3                   	ret    

000007a3 <link>:
SYSCALL(link)
 7a3:	b8 13 00 00 00       	mov    $0x13,%eax
 7a8:	cd 40                	int    $0x40
 7aa:	c3                   	ret    

000007ab <mkdir>:
SYSCALL(mkdir)
 7ab:	b8 14 00 00 00       	mov    $0x14,%eax
 7b0:	cd 40                	int    $0x40
 7b2:	c3                   	ret    

000007b3 <chdir>:
SYSCALL(chdir)
 7b3:	b8 09 00 00 00       	mov    $0x9,%eax
 7b8:	cd 40                	int    $0x40
 7ba:	c3                   	ret    

000007bb <dup>:
SYSCALL(dup)
 7bb:	b8 0a 00 00 00       	mov    $0xa,%eax
 7c0:	cd 40                	int    $0x40
 7c2:	c3                   	ret    

000007c3 <getpid>:
SYSCALL(getpid)
 7c3:	b8 0b 00 00 00       	mov    $0xb,%eax
 7c8:	cd 40                	int    $0x40
 7ca:	c3                   	ret    

000007cb <sbrk>:
SYSCALL(sbrk)
 7cb:	b8 0c 00 00 00       	mov    $0xc,%eax
 7d0:	cd 40                	int    $0x40
 7d2:	c3                   	ret    

000007d3 <sleep>:
SYSCALL(sleep)
 7d3:	b8 0d 00 00 00       	mov    $0xd,%eax
 7d8:	cd 40                	int    $0x40
 7da:	c3                   	ret    

000007db <uptime>:
SYSCALL(uptime)
 7db:	b8 0e 00 00 00       	mov    $0xe,%eax
 7e0:	cd 40                	int    $0x40
 7e2:	c3                   	ret    

000007e3 <yield>:
SYSCALL(yield)
 7e3:	b8 16 00 00 00       	mov    $0x16,%eax
 7e8:	cd 40                	int    $0x40
 7ea:	c3                   	ret    

000007eb <getlev>:
SYSCALL(getlev)
 7eb:	b8 17 00 00 00       	mov    $0x17,%eax
 7f0:	cd 40                	int    $0x40
 7f2:	c3                   	ret    

000007f3 <setpriority>:
SYSCALL(setpriority)
 7f3:	b8 18 00 00 00       	mov    $0x18,%eax
 7f8:	cd 40                	int    $0x40
 7fa:	c3                   	ret    

000007fb <setmonopoly>:
SYSCALL(setmonopoly)
 7fb:	b8 19 00 00 00       	mov    $0x19,%eax
 800:	cd 40                	int    $0x40
 802:	c3                   	ret    

00000803 <monopolize>:
SYSCALL(monopolize);
 803:	b8 1a 00 00 00       	mov    $0x1a,%eax
 808:	cd 40                	int    $0x40
 80a:	c3                   	ret    

0000080b <unmonopolize>:
SYSCALL(unmonopolize);
 80b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 810:	cd 40                	int    $0x40
 812:	c3                   	ret    

00000813 <rn_sleep>:
 813:	b8 1c 00 00 00       	mov    $0x1c,%eax
 818:	cd 40                	int    $0x40
 81a:	c3                   	ret    
 81b:	66 90                	xchg   %ax,%ax
 81d:	66 90                	xchg   %ax,%ax
 81f:	90                   	nop

00000820 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 820:	55                   	push   %ebp
 821:	89 e5                	mov    %esp,%ebp
 823:	57                   	push   %edi
 824:	56                   	push   %esi
 825:	53                   	push   %ebx
 826:	83 ec 3c             	sub    $0x3c,%esp
 829:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 82c:	89 d1                	mov    %edx,%ecx
{
 82e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 831:	85 d2                	test   %edx,%edx
 833:	0f 89 7f 00 00 00    	jns    8b8 <printint+0x98>
 839:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 83d:	74 79                	je     8b8 <printint+0x98>
    neg = 1;
 83f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 846:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 848:	31 db                	xor    %ebx,%ebx
 84a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 84d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 850:	89 c8                	mov    %ecx,%eax
 852:	31 d2                	xor    %edx,%edx
 854:	89 cf                	mov    %ecx,%edi
 856:	f7 75 c4             	divl   -0x3c(%ebp)
 859:	0f b6 92 a0 0d 00 00 	movzbl 0xda0(%edx),%edx
 860:	89 45 c0             	mov    %eax,-0x40(%ebp)
 863:	89 d8                	mov    %ebx,%eax
 865:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 868:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 86b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 86e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 871:	76 dd                	jbe    850 <printint+0x30>
  if(neg)
 873:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 876:	85 c9                	test   %ecx,%ecx
 878:	74 0c                	je     886 <printint+0x66>
    buf[i++] = '-';
 87a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 87f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 881:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 886:	8b 7d b8             	mov    -0x48(%ebp),%edi
 889:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 88d:	eb 07                	jmp    896 <printint+0x76>
 88f:	90                   	nop
    putc(fd, buf[i]);
 890:	0f b6 13             	movzbl (%ebx),%edx
 893:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 896:	83 ec 04             	sub    $0x4,%esp
 899:	88 55 d7             	mov    %dl,-0x29(%ebp)
 89c:	6a 01                	push   $0x1
 89e:	56                   	push   %esi
 89f:	57                   	push   %edi
 8a0:	e8 be fe ff ff       	call   763 <write>
  while(--i >= 0)
 8a5:	83 c4 10             	add    $0x10,%esp
 8a8:	39 de                	cmp    %ebx,%esi
 8aa:	75 e4                	jne    890 <printint+0x70>
}
 8ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
 8af:	5b                   	pop    %ebx
 8b0:	5e                   	pop    %esi
 8b1:	5f                   	pop    %edi
 8b2:	5d                   	pop    %ebp
 8b3:	c3                   	ret    
 8b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 8b8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 8bf:	eb 87                	jmp    848 <printint+0x28>
 8c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8cf:	90                   	nop

000008d0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 8d0:	55                   	push   %ebp
 8d1:	89 e5                	mov    %esp,%ebp
 8d3:	57                   	push   %edi
 8d4:	56                   	push   %esi
 8d5:	53                   	push   %ebx
 8d6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 8dc:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 8df:	0f b6 13             	movzbl (%ebx),%edx
 8e2:	84 d2                	test   %dl,%dl
 8e4:	74 6a                	je     950 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 8e6:	8d 45 10             	lea    0x10(%ebp),%eax
 8e9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 8ec:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 8ef:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 8f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 8f4:	eb 36                	jmp    92c <printf+0x5c>
 8f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8fd:	8d 76 00             	lea    0x0(%esi),%esi
 900:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 903:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 908:	83 f8 25             	cmp    $0x25,%eax
 90b:	74 15                	je     922 <printf+0x52>
  write(fd, &c, 1);
 90d:	83 ec 04             	sub    $0x4,%esp
 910:	88 55 e7             	mov    %dl,-0x19(%ebp)
 913:	6a 01                	push   $0x1
 915:	57                   	push   %edi
 916:	56                   	push   %esi
 917:	e8 47 fe ff ff       	call   763 <write>
 91c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 91f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 922:	0f b6 13             	movzbl (%ebx),%edx
 925:	83 c3 01             	add    $0x1,%ebx
 928:	84 d2                	test   %dl,%dl
 92a:	74 24                	je     950 <printf+0x80>
    c = fmt[i] & 0xff;
 92c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 92f:	85 c9                	test   %ecx,%ecx
 931:	74 cd                	je     900 <printf+0x30>
      }
    } else if(state == '%'){
 933:	83 f9 25             	cmp    $0x25,%ecx
 936:	75 ea                	jne    922 <printf+0x52>
      if(c == 'd'){
 938:	83 f8 25             	cmp    $0x25,%eax
 93b:	0f 84 07 01 00 00    	je     a48 <printf+0x178>
 941:	83 e8 63             	sub    $0x63,%eax
 944:	83 f8 15             	cmp    $0x15,%eax
 947:	77 17                	ja     960 <printf+0x90>
 949:	ff 24 85 48 0d 00 00 	jmp    *0xd48(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 950:	8d 65 f4             	lea    -0xc(%ebp),%esp
 953:	5b                   	pop    %ebx
 954:	5e                   	pop    %esi
 955:	5f                   	pop    %edi
 956:	5d                   	pop    %ebp
 957:	c3                   	ret    
 958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 95f:	90                   	nop
  write(fd, &c, 1);
 960:	83 ec 04             	sub    $0x4,%esp
 963:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 966:	6a 01                	push   $0x1
 968:	57                   	push   %edi
 969:	56                   	push   %esi
 96a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 96e:	e8 f0 fd ff ff       	call   763 <write>
        putc(fd, c);
 973:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 977:	83 c4 0c             	add    $0xc,%esp
 97a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 97d:	6a 01                	push   $0x1
 97f:	57                   	push   %edi
 980:	56                   	push   %esi
 981:	e8 dd fd ff ff       	call   763 <write>
        putc(fd, c);
 986:	83 c4 10             	add    $0x10,%esp
      state = 0;
 989:	31 c9                	xor    %ecx,%ecx
 98b:	eb 95                	jmp    922 <printf+0x52>
 98d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 990:	83 ec 0c             	sub    $0xc,%esp
 993:	b9 10 00 00 00       	mov    $0x10,%ecx
 998:	6a 00                	push   $0x0
 99a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 99d:	8b 10                	mov    (%eax),%edx
 99f:	89 f0                	mov    %esi,%eax
 9a1:	e8 7a fe ff ff       	call   820 <printint>
        ap++;
 9a6:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 9aa:	83 c4 10             	add    $0x10,%esp
      state = 0;
 9ad:	31 c9                	xor    %ecx,%ecx
 9af:	e9 6e ff ff ff       	jmp    922 <printf+0x52>
 9b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 9b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
 9bb:	8b 10                	mov    (%eax),%edx
        ap++;
 9bd:	83 c0 04             	add    $0x4,%eax
 9c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 9c3:	85 d2                	test   %edx,%edx
 9c5:	0f 84 8d 00 00 00    	je     a58 <printf+0x188>
        while(*s != 0){
 9cb:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 9ce:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 9d0:	84 c0                	test   %al,%al
 9d2:	0f 84 4a ff ff ff    	je     922 <printf+0x52>
 9d8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 9db:	89 d3                	mov    %edx,%ebx
 9dd:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 9e0:	83 ec 04             	sub    $0x4,%esp
          s++;
 9e3:	83 c3 01             	add    $0x1,%ebx
 9e6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 9e9:	6a 01                	push   $0x1
 9eb:	57                   	push   %edi
 9ec:	56                   	push   %esi
 9ed:	e8 71 fd ff ff       	call   763 <write>
        while(*s != 0){
 9f2:	0f b6 03             	movzbl (%ebx),%eax
 9f5:	83 c4 10             	add    $0x10,%esp
 9f8:	84 c0                	test   %al,%al
 9fa:	75 e4                	jne    9e0 <printf+0x110>
      state = 0;
 9fc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 9ff:	31 c9                	xor    %ecx,%ecx
 a01:	e9 1c ff ff ff       	jmp    922 <printf+0x52>
 a06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a0d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 a10:	83 ec 0c             	sub    $0xc,%esp
 a13:	b9 0a 00 00 00       	mov    $0xa,%ecx
 a18:	6a 01                	push   $0x1
 a1a:	e9 7b ff ff ff       	jmp    99a <printf+0xca>
 a1f:	90                   	nop
        putc(fd, *ap);
 a20:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 a23:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 a26:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 a28:	6a 01                	push   $0x1
 a2a:	57                   	push   %edi
 a2b:	56                   	push   %esi
        putc(fd, *ap);
 a2c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 a2f:	e8 2f fd ff ff       	call   763 <write>
        ap++;
 a34:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 a38:	83 c4 10             	add    $0x10,%esp
      state = 0;
 a3b:	31 c9                	xor    %ecx,%ecx
 a3d:	e9 e0 fe ff ff       	jmp    922 <printf+0x52>
 a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 a48:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 a4b:	83 ec 04             	sub    $0x4,%esp
 a4e:	e9 2a ff ff ff       	jmp    97d <printf+0xad>
 a53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 a57:	90                   	nop
          s = "(null)";
 a58:	ba 40 0d 00 00       	mov    $0xd40,%edx
        while(*s != 0){
 a5d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 a60:	b8 28 00 00 00       	mov    $0x28,%eax
 a65:	89 d3                	mov    %edx,%ebx
 a67:	e9 74 ff ff ff       	jmp    9e0 <printf+0x110>
 a6c:	66 90                	xchg   %ax,%ax
 a6e:	66 90                	xchg   %ax,%ax

00000a70 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a70:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a71:	a1 08 11 00 00       	mov    0x1108,%eax
{
 a76:	89 e5                	mov    %esp,%ebp
 a78:	57                   	push   %edi
 a79:	56                   	push   %esi
 a7a:	53                   	push   %ebx
 a7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 a7e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a88:	89 c2                	mov    %eax,%edx
 a8a:	8b 00                	mov    (%eax),%eax
 a8c:	39 ca                	cmp    %ecx,%edx
 a8e:	73 30                	jae    ac0 <free+0x50>
 a90:	39 c1                	cmp    %eax,%ecx
 a92:	72 04                	jb     a98 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a94:	39 c2                	cmp    %eax,%edx
 a96:	72 f0                	jb     a88 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 a98:	8b 73 fc             	mov    -0x4(%ebx),%esi
 a9b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 a9e:	39 f8                	cmp    %edi,%eax
 aa0:	74 30                	je     ad2 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 aa2:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 aa5:	8b 42 04             	mov    0x4(%edx),%eax
 aa8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 aab:	39 f1                	cmp    %esi,%ecx
 aad:	74 3a                	je     ae9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 aaf:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 ab1:	5b                   	pop    %ebx
  freep = p;
 ab2:	89 15 08 11 00 00    	mov    %edx,0x1108
}
 ab8:	5e                   	pop    %esi
 ab9:	5f                   	pop    %edi
 aba:	5d                   	pop    %ebp
 abb:	c3                   	ret    
 abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ac0:	39 c2                	cmp    %eax,%edx
 ac2:	72 c4                	jb     a88 <free+0x18>
 ac4:	39 c1                	cmp    %eax,%ecx
 ac6:	73 c0                	jae    a88 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 ac8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 acb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 ace:	39 f8                	cmp    %edi,%eax
 ad0:	75 d0                	jne    aa2 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 ad2:	03 70 04             	add    0x4(%eax),%esi
 ad5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 ad8:	8b 02                	mov    (%edx),%eax
 ada:	8b 00                	mov    (%eax),%eax
 adc:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 adf:	8b 42 04             	mov    0x4(%edx),%eax
 ae2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 ae5:	39 f1                	cmp    %esi,%ecx
 ae7:	75 c6                	jne    aaf <free+0x3f>
    p->s.size += bp->s.size;
 ae9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 aec:	89 15 08 11 00 00    	mov    %edx,0x1108
    p->s.size += bp->s.size;
 af2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 af5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 af8:	89 0a                	mov    %ecx,(%edx)
}
 afa:	5b                   	pop    %ebx
 afb:	5e                   	pop    %esi
 afc:	5f                   	pop    %edi
 afd:	5d                   	pop    %ebp
 afe:	c3                   	ret    
 aff:	90                   	nop

00000b00 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b00:	55                   	push   %ebp
 b01:	89 e5                	mov    %esp,%ebp
 b03:	57                   	push   %edi
 b04:	56                   	push   %esi
 b05:	53                   	push   %ebx
 b06:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b09:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 b0c:	8b 3d 08 11 00 00    	mov    0x1108,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b12:	8d 70 07             	lea    0x7(%eax),%esi
 b15:	c1 ee 03             	shr    $0x3,%esi
 b18:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 b1b:	85 ff                	test   %edi,%edi
 b1d:	0f 84 9d 00 00 00    	je     bc0 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b23:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 b25:	8b 4a 04             	mov    0x4(%edx),%ecx
 b28:	39 f1                	cmp    %esi,%ecx
 b2a:	73 6a                	jae    b96 <malloc+0x96>
 b2c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 b31:	39 de                	cmp    %ebx,%esi
 b33:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 b36:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 b3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 b40:	eb 17                	jmp    b59 <malloc+0x59>
 b42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b48:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 b4a:	8b 48 04             	mov    0x4(%eax),%ecx
 b4d:	39 f1                	cmp    %esi,%ecx
 b4f:	73 4f                	jae    ba0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b51:	8b 3d 08 11 00 00    	mov    0x1108,%edi
 b57:	89 c2                	mov    %eax,%edx
 b59:	39 d7                	cmp    %edx,%edi
 b5b:	75 eb                	jne    b48 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 b5d:	83 ec 0c             	sub    $0xc,%esp
 b60:	ff 75 e4             	push   -0x1c(%ebp)
 b63:	e8 63 fc ff ff       	call   7cb <sbrk>
  if(p == (char*)-1)
 b68:	83 c4 10             	add    $0x10,%esp
 b6b:	83 f8 ff             	cmp    $0xffffffff,%eax
 b6e:	74 1c                	je     b8c <malloc+0x8c>
  hp->s.size = nu;
 b70:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 b73:	83 ec 0c             	sub    $0xc,%esp
 b76:	83 c0 08             	add    $0x8,%eax
 b79:	50                   	push   %eax
 b7a:	e8 f1 fe ff ff       	call   a70 <free>
  return freep;
 b7f:	8b 15 08 11 00 00    	mov    0x1108,%edx
      if((p = morecore(nunits)) == 0)
 b85:	83 c4 10             	add    $0x10,%esp
 b88:	85 d2                	test   %edx,%edx
 b8a:	75 bc                	jne    b48 <malloc+0x48>
        return 0;
  }
}
 b8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 b8f:	31 c0                	xor    %eax,%eax
}
 b91:	5b                   	pop    %ebx
 b92:	5e                   	pop    %esi
 b93:	5f                   	pop    %edi
 b94:	5d                   	pop    %ebp
 b95:	c3                   	ret    
    if(p->s.size >= nunits){
 b96:	89 d0                	mov    %edx,%eax
 b98:	89 fa                	mov    %edi,%edx
 b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 ba0:	39 ce                	cmp    %ecx,%esi
 ba2:	74 4c                	je     bf0 <malloc+0xf0>
        p->s.size -= nunits;
 ba4:	29 f1                	sub    %esi,%ecx
 ba6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 ba9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 bac:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 baf:	89 15 08 11 00 00    	mov    %edx,0x1108
}
 bb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 bb8:	83 c0 08             	add    $0x8,%eax
}
 bbb:	5b                   	pop    %ebx
 bbc:	5e                   	pop    %esi
 bbd:	5f                   	pop    %edi
 bbe:	5d                   	pop    %ebp
 bbf:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 bc0:	c7 05 08 11 00 00 0c 	movl   $0x110c,0x1108
 bc7:	11 00 00 
    base.s.size = 0;
 bca:	bf 0c 11 00 00       	mov    $0x110c,%edi
    base.s.ptr = freep = prevp = &base;
 bcf:	c7 05 0c 11 00 00 0c 	movl   $0x110c,0x110c
 bd6:	11 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bd9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 bdb:	c7 05 10 11 00 00 00 	movl   $0x0,0x1110
 be2:	00 00 00 
    if(p->s.size >= nunits){
 be5:	e9 42 ff ff ff       	jmp    b2c <malloc+0x2c>
 bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 bf0:	8b 08                	mov    (%eax),%ecx
 bf2:	89 0a                	mov    %ecx,(%edx)
 bf4:	eb b9                	jmp    baf <malloc+0xaf>
