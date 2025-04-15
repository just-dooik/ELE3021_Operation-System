
_rn_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    }

    printf(1, "rn_test6 finished successfully\n\n\n");
}

int main(int argc, char** argv) {
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 e4 f0             	and    $0xfffffff0,%esp
    rn_test1();
       6:	e8 05 01 00 00       	call   110 <rn_test1>
    rn_test2();
       b:	e8 a0 02 00 00       	call   2b0 <rn_test2>
    rn_test3();
      10:	e8 bb 04 00 00       	call   4d0 <rn_test3>
    rn_test4();
      15:	e8 66 07 00 00       	call   780 <rn_test4>
    rn_test5();
      1a:	e8 c1 09 00 00       	call   9e0 <rn_test5>
    rn_test6();
      1f:	e8 fc 0c 00 00       	call   d20 <rn_test6>

    exit();
      24:	e8 4a 13 00 00       	call   1373 <exit>
      29:	66 90                	xchg   %ax,%ax
      2b:	66 90                	xchg   %ax,%ax
      2d:	66 90                	xchg   %ax,%ax
      2f:	90                   	nop

00000030 <level_cnt_init>:
void level_cnt_init(int* level_cnt) {
      30:	55                   	push   %ebp
      31:	89 e5                	mov    %esp,%ebp
      33:	8b 45 08             	mov    0x8(%ebp),%eax
    level_cnt[0] = level_cnt[1] = level_cnt[2] = level_cnt[3] = level_cnt[4] = 0;
      36:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
      3d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
      44:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
      4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
      52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
      58:	5d                   	pop    %ebp
      59:	c3                   	ret    
      5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000060 <add_level_cnt>:
void add_level_cnt(int* level_cnt) {
      60:	55                   	push   %ebp
      61:	89 e5                	mov    %esp,%ebp
      63:	53                   	push   %ebx
      64:	83 ec 04             	sub    $0x4,%esp
      67:	8b 5d 08             	mov    0x8(%ebp),%ebx
    lev = getlev();
      6a:	e8 ac 13 00 00       	call   141b <getlev>
    if (lev == 99) ++level_cnt[4];
      6f:	83 f8 63             	cmp    $0x63,%eax
      72:	74 0c                	je     80 <add_level_cnt+0x20>
    else ++level_cnt[lev];
      74:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
}
      78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      7b:	c9                   	leave  
      7c:	c3                   	ret    
      7d:	8d 76 00             	lea    0x0(%esi),%esi
    if (lev == 99) ++level_cnt[4];
      80:	83 43 10 01          	addl   $0x1,0x10(%ebx)
}
      84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      87:	c9                   	leave  
      88:	c3                   	ret    
      89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000090 <print_level_cnt>:
void print_level_cnt(int* level_cnt, const char* pname) {
      90:	55                   	push   %ebp
      91:	89 e5                	mov    %esp,%ebp
      93:	53                   	push   %ebx
      94:	83 ec 04             	sub    $0x4,%esp
      97:	8b 5d 08             	mov    0x8(%ebp),%ebx
    printf(1, " [ process %d (%s) ]\n", getpid(), pname);
      9a:	e8 54 13 00 00       	call   13f3 <getpid>
      9f:	ff 75 0c             	push   0xc(%ebp)
      a2:	50                   	push   %eax
      a3:	68 28 18 00 00       	push   $0x1828
      a8:	6a 01                	push   $0x1
      aa:	e8 51 14 00 00       	call   1500 <printf>
    printf(1, "\t- L0:\t\t%d\n", level_cnt[0]);
      af:	83 c4 0c             	add    $0xc,%esp
      b2:	ff 33                	push   (%ebx)
      b4:	68 3e 18 00 00       	push   $0x183e
      b9:	6a 01                	push   $0x1
      bb:	e8 40 14 00 00       	call   1500 <printf>
    printf(1, "\t- L1:\t\t%d\n", level_cnt[1]);
      c0:	83 c4 0c             	add    $0xc,%esp
      c3:	ff 73 04             	push   0x4(%ebx)
      c6:	68 4a 18 00 00       	push   $0x184a
      cb:	6a 01                	push   $0x1
      cd:	e8 2e 14 00 00       	call   1500 <printf>
    printf(1, "\t- L2:\t\t%d\n", level_cnt[2]);
      d2:	83 c4 0c             	add    $0xc,%esp
      d5:	ff 73 08             	push   0x8(%ebx)
      d8:	68 56 18 00 00       	push   $0x1856
      dd:	6a 01                	push   $0x1
      df:	e8 1c 14 00 00       	call   1500 <printf>
    printf(1, "\t- L3:\t\t%d\n", level_cnt[3]);
      e4:	83 c4 0c             	add    $0xc,%esp
      e7:	ff 73 0c             	push   0xc(%ebx)
      ea:	68 62 18 00 00       	push   $0x1862
      ef:	6a 01                	push   $0x1
      f1:	e8 0a 14 00 00       	call   1500 <printf>
    printf(1, "\t- MONOPOLIZED:\t%d\n\n", level_cnt[4]);
      f6:	83 c4 0c             	add    $0xc,%esp
      f9:	ff 73 10             	push   0x10(%ebx)
      fc:	68 6e 18 00 00       	push   $0x186e
     101:	6a 01                	push   $0x1
     103:	e8 f8 13 00 00       	call   1500 <printf>
}
     108:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     10b:	83 c4 10             	add    $0x10,%esp
     10e:	c9                   	leave  
     10f:	c3                   	ret    

00000110 <rn_test1>:
void rn_test1() {
     110:	55                   	push   %ebp
     111:	89 e5                	mov    %esp,%ebp
     113:	56                   	push   %esi
     114:	53                   	push   %ebx
     115:	83 ec 28             	sub    $0x28,%esp
    printf(1, "rn_test1 [L0 Only]\n");
     118:	68 83 18 00 00       	push   $0x1883
     11d:	6a 01                	push   $0x1
     11f:	e8 dc 13 00 00       	call   1500 <printf>
    level_cnt[0] = level_cnt[1] = level_cnt[2] = level_cnt[3] = level_cnt[4] = 0;
     124:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     12b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     132:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     139:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
     140:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    p1 = fork();
     147:	e8 1f 12 00 00       	call   136b <fork>
    if (p1 == 0) {
     14c:	83 c4 10             	add    $0x10,%esp
     14f:	85 c0                	test   %eax,%eax
     151:	0f 84 f4 00 00 00    	je     24b <rn_test1+0x13b>
     157:	89 c3                	mov    %eax,%ebx
    p2 = fork();
     159:	e8 0d 12 00 00       	call   136b <fork>
     15e:	89 c6                	mov    %eax,%esi
    if (p2 == 0) {
     160:	85 c0                	test   %eax,%eax
     162:	0f 84 a5 00 00 00    	je     20d <rn_test1+0xfd>
    p3 = fork();
     168:	e8 fe 11 00 00       	call   136b <fork>
    if (p3 == 0) {
     16d:	85 c0                	test   %eax,%eax
     16f:	74 4d                	je     1be <rn_test1+0xae>
    w_list[0] = p3;
     171:	89 45 d8             	mov    %eax,-0x28(%ebp)
    w_list[1] = p2;
     174:	89 75 dc             	mov    %esi,-0x24(%ebp)
    w_list[2] = p1;
     177:	8d 75 e4             	lea    -0x1c(%ebp),%esi
     17a:	89 5d e0             	mov    %ebx,-0x20(%ebp)
    for (; w_cnt < 3; ) {
     17d:	8d 5d d8             	lea    -0x28(%ebp),%ebx
        p = wait();
     180:	e8 f6 11 00 00       	call   137b <wait>
        if (p == w_list[w_cnt]) ++w_cnt;
     185:	8b 13                	mov    (%ebx),%edx
     187:	39 c2                	cmp    %eax,%edx
     189:	75 20                	jne    1ab <rn_test1+0x9b>
    for (; w_cnt < 3; ) {
     18b:	83 c3 04             	add    $0x4,%ebx
     18e:	39 f3                	cmp    %esi,%ebx
     190:	75 ee                	jne    180 <rn_test1+0x70>
    printf(1, "rn_test1 finished successfully\n\n\n");
     192:	83 ec 08             	sub    $0x8,%esp
     195:	68 8c 19 00 00       	push   $0x198c
     19a:	6a 01                	push   $0x1
     19c:	e8 5f 13 00 00       	call   1500 <printf>
}
     1a1:	83 c4 10             	add    $0x10,%esp
     1a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
     1a7:	5b                   	pop    %ebx
     1a8:	5e                   	pop    %esi
     1a9:	5d                   	pop    %ebp
     1aa:	c3                   	ret    
            printf(1, "rn_test1 failed\n expected wait pid = %d, but wait pid = %d\n", w_list[w_cnt], p);
     1ab:	50                   	push   %eax
     1ac:	52                   	push   %edx
     1ad:	68 50 19 00 00       	push   $0x1950
     1b2:	6a 01                	push   $0x1
     1b4:	e8 47 13 00 00       	call   1500 <printf>
            exit();
     1b9:	e8 b5 11 00 00       	call   1373 <exit>
     1be:	be 64 00 00 00       	mov    $0x64,%esi
     1c3:	8d 5d e4             	lea    -0x1c(%ebp),%ebx
     1c6:	eb 16                	jmp    1de <rn_test1+0xce>
     1c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     1cf:	90                   	nop
    else ++level_cnt[lev];
     1d0:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
            yield();
     1d4:	e8 3a 12 00 00       	call   1413 <yield>
        for (int cnt = 100; cnt--; ) {
     1d9:	83 ee 01             	sub    $0x1,%esi
     1dc:	74 1d                	je     1fb <rn_test1+0xeb>
            rn_sleep(3);
     1de:	83 ec 0c             	sub    $0xc,%esp
     1e1:	6a 03                	push   $0x3
     1e3:	e8 5b 12 00 00       	call   1443 <rn_sleep>
    lev = getlev();
     1e8:	e8 2e 12 00 00       	call   141b <getlev>
    if (lev == 99) ++level_cnt[4];
     1ed:	83 c4 10             	add    $0x10,%esp
     1f0:	83 f8 63             	cmp    $0x63,%eax
     1f3:	75 db                	jne    1d0 <rn_test1+0xc0>
     1f5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     1f9:	eb d9                	jmp    1d4 <rn_test1+0xc4>
        print_level_cnt(level_cnt, "p3");
     1fb:	50                   	push   %eax
     1fc:	50                   	push   %eax
     1fd:	68 9d 18 00 00       	push   $0x189d
     202:	53                   	push   %ebx
     203:	e8 88 fe ff ff       	call   90 <print_level_cnt>
        exit();
     208:	e8 66 11 00 00       	call   1373 <exit>
     20d:	be f4 01 00 00       	mov    $0x1f4,%esi
     212:	8d 5d e4             	lea    -0x1c(%ebp),%ebx
     215:	eb 17                	jmp    22e <rn_test1+0x11e>
     217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     21e:	66 90                	xchg   %ax,%ax
    else ++level_cnt[lev];
     220:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
            yield();
     224:	e8 ea 11 00 00       	call   1413 <yield>
        for (int cnt = 500; cnt--; ) {
     229:	83 ee 01             	sub    $0x1,%esi
     22c:	74 55                	je     283 <rn_test1+0x173>
            rn_sleep(3);
     22e:	83 ec 0c             	sub    $0xc,%esp
     231:	6a 03                	push   $0x3
     233:	e8 0b 12 00 00       	call   1443 <rn_sleep>
    lev = getlev();
     238:	e8 de 11 00 00       	call   141b <getlev>
    if (lev == 99) ++level_cnt[4];
     23d:	83 c4 10             	add    $0x10,%esp
     240:	83 f8 63             	cmp    $0x63,%eax
     243:	75 db                	jne    220 <rn_test1+0x110>
     245:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     249:	eb d9                	jmp    224 <rn_test1+0x114>
     24b:	be e8 03 00 00       	mov    $0x3e8,%esi
     250:	8d 5d e4             	lea    -0x1c(%ebp),%ebx
     253:	eb 11                	jmp    266 <rn_test1+0x156>
     255:	8d 76 00             	lea    0x0(%esi),%esi
    else ++level_cnt[lev];
     258:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
            yield();
     25c:	e8 b2 11 00 00       	call   1413 <yield>
        for (int cnt = 1000; cnt--; ) {
     261:	83 ee 01             	sub    $0x1,%esi
     264:	74 2f                	je     295 <rn_test1+0x185>
            rn_sleep(3);
     266:	83 ec 0c             	sub    $0xc,%esp
     269:	6a 03                	push   $0x3
     26b:	e8 d3 11 00 00       	call   1443 <rn_sleep>
    lev = getlev();
     270:	e8 a6 11 00 00       	call   141b <getlev>
    if (lev == 99) ++level_cnt[4];
     275:	83 c4 10             	add    $0x10,%esp
     278:	83 f8 63             	cmp    $0x63,%eax
     27b:	75 db                	jne    258 <rn_test1+0x148>
     27d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     281:	eb d9                	jmp    25c <rn_test1+0x14c>
        print_level_cnt(level_cnt, "p2");
     283:	52                   	push   %edx
     284:	52                   	push   %edx
     285:	68 9a 18 00 00       	push   $0x189a
     28a:	53                   	push   %ebx
     28b:	e8 00 fe ff ff       	call   90 <print_level_cnt>
        exit();
     290:	e8 de 10 00 00       	call   1373 <exit>
        print_level_cnt(level_cnt, "p1");
     295:	51                   	push   %ecx
     296:	51                   	push   %ecx
     297:	68 97 18 00 00       	push   $0x1897
     29c:	53                   	push   %ebx
     29d:	e8 ee fd ff ff       	call   90 <print_level_cnt>
        exit();
     2a2:	e8 cc 10 00 00       	call   1373 <exit>
     2a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     2ae:	66 90                	xchg   %ax,%ax

000002b0 <rn_test2>:
void rn_test2() {
     2b0:	55                   	push   %ebp
     2b1:	89 e5                	mov    %esp,%ebp
     2b3:	57                   	push   %edi
     2b4:	56                   	push   %esi
     2b5:	53                   	push   %ebx
     2b6:	83 ec 44             	sub    $0x44,%esp
    printf(1, "rn_test2 [L1~L2 Only]\n");
     2b9:	68 a0 18 00 00       	push   $0x18a0
     2be:	6a 01                	push   $0x1
     2c0:	e8 3b 12 00 00       	call   1500 <printf>
    level_cnt[0] = level_cnt[1] = level_cnt[2] = level_cnt[3] = level_cnt[4] = 0;
     2c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
     2cc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
     2d3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
     2da:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
     2e1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    p1 = fork();
     2e8:	e8 7e 10 00 00       	call   136b <fork>
    if (p1 == 0) {
     2ed:	83 c4 10             	add    $0x10,%esp
     2f0:	85 c0                	test   %eax,%eax
     2f2:	0f 84 53 01 00 00    	je     44b <rn_test2+0x19b>
     2f8:	89 c6                	mov    %eax,%esi
    p2 = fork();
     2fa:	e8 6c 10 00 00       	call   136b <fork>
     2ff:	89 c3                	mov    %eax,%ebx
    if (p2 == 0) {
     301:	85 c0                	test   %eax,%eax
     303:	0f 84 c6 00 00 00    	je     3cf <rn_test2+0x11f>
    p3 = fork();
     309:	e8 5d 10 00 00       	call   136b <fork>
     30e:	89 c7                	mov    %eax,%edi
    if (p3 == 0) {
     310:	85 c0                	test   %eax,%eax
     312:	0f 84 f7 00 00 00    	je     40f <rn_test2+0x15f>
    p4 = fork();
     318:	e8 4e 10 00 00       	call   136b <fork>
    if (p4 == 0) {
     31d:	85 c0                	test   %eax,%eax
     31f:	74 6f                	je     390 <rn_test2+0xe0>
    if (p4 % 2 == 1) {
     321:	89 c1                	mov    %eax,%ecx
     323:	c1 e9 1f             	shr    $0x1f,%ecx
     326:	8d 14 08             	lea    (%eax,%ecx,1),%edx
     329:	83 e2 01             	and    $0x1,%edx
     32c:	29 ca                	sub    %ecx,%edx
     32e:	83 fa 01             	cmp    $0x1,%edx
     331:	75 0c                	jne    33f <rn_test2+0x8f>
     333:	89 c2                	mov    %eax,%edx
     335:	89 f8                	mov    %edi,%eax
     337:	89 d7                	mov    %edx,%edi
     339:	89 da                	mov    %ebx,%edx
     33b:	89 f3                	mov    %esi,%ebx
     33d:	89 d6                	mov    %edx,%esi
        w_list[0] = p4;
     33f:	89 7d c4             	mov    %edi,-0x3c(%ebp)
        w_list[2] = p3;
     342:	89 45 cc             	mov    %eax,-0x34(%ebp)
        w_list[1] = p2;
     345:	89 75 c8             	mov    %esi,-0x38(%ebp)
     348:	8d 75 d4             	lea    -0x2c(%ebp),%esi
        w_list[3] = p1;
     34b:	89 5d d0             	mov    %ebx,-0x30(%ebp)
     34e:	8d 5d c4             	lea    -0x3c(%ebp),%ebx
        p = wait();
     351:	e8 25 10 00 00       	call   137b <wait>
        if (p == w_list[w_cnt]) ++w_cnt;
     356:	8b 13                	mov    (%ebx),%edx
     358:	39 c2                	cmp    %eax,%edx
     35a:	75 21                	jne    37d <rn_test2+0xcd>
    for (; w_cnt < 4; ) {
     35c:	83 c3 04             	add    $0x4,%ebx
     35f:	39 de                	cmp    %ebx,%esi
     361:	75 ee                	jne    351 <rn_test2+0xa1>
    printf(1, "rn_test2 finished successfully\n\n\n");
     363:	83 ec 08             	sub    $0x8,%esp
     366:	68 ec 19 00 00       	push   $0x19ec
     36b:	6a 01                	push   $0x1
     36d:	e8 8e 11 00 00       	call   1500 <printf>
}
     372:	83 c4 10             	add    $0x10,%esp
     375:	8d 65 f4             	lea    -0xc(%ebp),%esp
     378:	5b                   	pop    %ebx
     379:	5e                   	pop    %esi
     37a:	5f                   	pop    %edi
     37b:	5d                   	pop    %ebp
     37c:	c3                   	ret    
            printf(1, "rn_test2 failed\n expected wait pid = %d, but wait pid = %d\n", w_list[w_cnt], p);
     37d:	50                   	push   %eax
     37e:	52                   	push   %edx
     37f:	68 b0 19 00 00       	push   $0x19b0
     384:	6a 01                	push   $0x1
     386:	e8 75 11 00 00       	call   1500 <printf>
            exit();
     38b:	e8 e3 0f 00 00       	call   1373 <exit>
     390:	be 32 00 00 00       	mov    $0x32,%esi
     395:	8d 5d d4             	lea    -0x2c(%ebp),%ebx
     398:	eb 18                	jmp    3b2 <rn_test2+0x102>
     39a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else ++level_cnt[lev];
     3a0:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
            yield();
     3a4:	e8 6a 10 00 00       	call   1413 <yield>
        for (int cnt = 50; cnt--; ) {
     3a9:	83 ee 01             	sub    $0x1,%esi
     3ac:	0f 84 d1 00 00 00    	je     483 <rn_test2+0x1d3>
            rn_sleep(20);
     3b2:	83 ec 0c             	sub    $0xc,%esp
     3b5:	6a 14                	push   $0x14
     3b7:	e8 87 10 00 00       	call   1443 <rn_sleep>
    lev = getlev();
     3bc:	e8 5a 10 00 00       	call   141b <getlev>
    if (lev == 99) ++level_cnt[4];
     3c1:	83 c4 10             	add    $0x10,%esp
     3c4:	83 f8 63             	cmp    $0x63,%eax
     3c7:	75 d7                	jne    3a0 <rn_test2+0xf0>
     3c9:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
     3cd:	eb d5                	jmp    3a4 <rn_test2+0xf4>
     3cf:	be c8 00 00 00       	mov    $0xc8,%esi
     3d4:	8d 5d d4             	lea    -0x2c(%ebp),%ebx
     3d7:	eb 19                	jmp    3f2 <rn_test2+0x142>
     3d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    else ++level_cnt[lev];
     3e0:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
            yield();
     3e4:	e8 2a 10 00 00       	call   1413 <yield>
        for (int cnt = 200; cnt--; ) {
     3e9:	83 ee 01             	sub    $0x1,%esi
     3ec:	0f 84 b5 00 00 00    	je     4a7 <rn_test2+0x1f7>
            rn_sleep(20);
     3f2:	83 ec 0c             	sub    $0xc,%esp
     3f5:	6a 14                	push   $0x14
     3f7:	e8 47 10 00 00       	call   1443 <rn_sleep>
    lev = getlev();
     3fc:	e8 1a 10 00 00       	call   141b <getlev>
    if (lev == 99) ++level_cnt[4];
     401:	83 c4 10             	add    $0x10,%esp
     404:	83 f8 63             	cmp    $0x63,%eax
     407:	75 d7                	jne    3e0 <rn_test2+0x130>
     409:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
     40d:	eb d5                	jmp    3e4 <rn_test2+0x134>
     40f:	be 64 00 00 00       	mov    $0x64,%esi
     414:	8d 5d d4             	lea    -0x2c(%ebp),%ebx
     417:	eb 15                	jmp    42e <rn_test2+0x17e>
     419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    else ++level_cnt[lev];
     420:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
            yield();
     424:	e8 ea 0f 00 00       	call   1413 <yield>
        for (int cnt = 100; cnt--; ) {
     429:	83 ee 01             	sub    $0x1,%esi
     42c:	74 67                	je     495 <rn_test2+0x1e5>
            rn_sleep(20);
     42e:	83 ec 0c             	sub    $0xc,%esp
     431:	6a 14                	push   $0x14
     433:	e8 0b 10 00 00       	call   1443 <rn_sleep>
    lev = getlev();
     438:	e8 de 0f 00 00       	call   141b <getlev>
    if (lev == 99) ++level_cnt[4];
     43d:	83 c4 10             	add    $0x10,%esp
     440:	83 f8 63             	cmp    $0x63,%eax
     443:	75 db                	jne    420 <rn_test2+0x170>
     445:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
     449:	eb d9                	jmp    424 <rn_test2+0x174>
     44b:	be 2c 01 00 00       	mov    $0x12c,%esi
     450:	8d 5d d4             	lea    -0x2c(%ebp),%ebx
     453:	eb 11                	jmp    466 <rn_test2+0x1b6>
     455:	8d 76 00             	lea    0x0(%esi),%esi
    else ++level_cnt[lev];
     458:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
            yield();
     45c:	e8 b2 0f 00 00       	call   1413 <yield>
        for (int cnt = 300; cnt--; ) {
     461:	83 ee 01             	sub    $0x1,%esi
     464:	74 53                	je     4b9 <rn_test2+0x209>
            rn_sleep(20);
     466:	83 ec 0c             	sub    $0xc,%esp
     469:	6a 14                	push   $0x14
     46b:	e8 d3 0f 00 00       	call   1443 <rn_sleep>
    lev = getlev();
     470:	e8 a6 0f 00 00       	call   141b <getlev>
    if (lev == 99) ++level_cnt[4];
     475:	83 c4 10             	add    $0x10,%esp
     478:	83 f8 63             	cmp    $0x63,%eax
     47b:	75 db                	jne    458 <rn_test2+0x1a8>
     47d:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
     481:	eb d9                	jmp    45c <rn_test2+0x1ac>
        print_level_cnt(level_cnt, "p4");
     483:	50                   	push   %eax
     484:	50                   	push   %eax
     485:	68 b7 18 00 00       	push   $0x18b7
     48a:	53                   	push   %ebx
     48b:	e8 00 fc ff ff       	call   90 <print_level_cnt>
        exit();
     490:	e8 de 0e 00 00       	call   1373 <exit>
        print_level_cnt(level_cnt, "p3");
     495:	52                   	push   %edx
     496:	52                   	push   %edx
     497:	68 9d 18 00 00       	push   $0x189d
     49c:	53                   	push   %ebx
     49d:	e8 ee fb ff ff       	call   90 <print_level_cnt>
        exit();
     4a2:	e8 cc 0e 00 00       	call   1373 <exit>
        print_level_cnt(level_cnt, "p2");
     4a7:	51                   	push   %ecx
     4a8:	51                   	push   %ecx
     4a9:	68 9a 18 00 00       	push   $0x189a
     4ae:	53                   	push   %ebx
     4af:	e8 dc fb ff ff       	call   90 <print_level_cnt>
        exit();
     4b4:	e8 ba 0e 00 00       	call   1373 <exit>
        print_level_cnt(level_cnt, "p1");
     4b9:	56                   	push   %esi
     4ba:	56                   	push   %esi
     4bb:	68 97 18 00 00       	push   $0x1897
     4c0:	53                   	push   %ebx
     4c1:	e8 ca fb ff ff       	call   90 <print_level_cnt>
        exit();
     4c6:	e8 a8 0e 00 00       	call   1373 <exit>
     4cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     4cf:	90                   	nop

000004d0 <rn_test3>:
void rn_test3() {
     4d0:	55                   	push   %ebp
     4d1:	89 e5                	mov    %esp,%ebp
     4d3:	57                   	push   %edi
     4d4:	56                   	push   %esi
     4d5:	53                   	push   %ebx
     4d6:	83 ec 44             	sub    $0x44,%esp
    printf(1, "rn_test3 [L3 Only]\n");
     4d9:	68 ba 18 00 00       	push   $0x18ba
     4de:	6a 01                	push   $0x1
     4e0:	e8 1b 10 00 00       	call   1500 <printf>
    level_cnt[0] = level_cnt[1] = level_cnt[2] = level_cnt[3] = level_cnt[4] = 0;
     4e5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
     4ec:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
     4f3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
     4fa:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
     501:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    p1 = fork();
     508:	e8 5e 0e 00 00       	call   136b <fork>
    if (p1 == 0) {
     50d:	83 c4 10             	add    $0x10,%esp
     510:	85 c0                	test   %eax,%eax
     512:	0f 84 d2 01 00 00    	je     6ea <rn_test3+0x21a>
     518:	89 c3                	mov    %eax,%ebx
    p2 = fork();
     51a:	e8 4c 0e 00 00       	call   136b <fork>
     51f:	89 c7                	mov    %eax,%edi
    if (p2 == 0) {
     521:	85 c0                	test   %eax,%eax
     523:	0f 84 59 01 00 00    	je     682 <rn_test3+0x1b2>
    p3 = fork();
     529:	e8 3d 0e 00 00       	call   136b <fork>
     52e:	89 c6                	mov    %eax,%esi
    if (p3 == 0) {
     530:	85 c0                	test   %eax,%eax
     532:	0f 84 c2 00 00 00    	je     5fa <rn_test3+0x12a>
    p4 = fork();
     538:	e8 2e 0e 00 00       	call   136b <fork>
    if (p4 == 0) {
     53d:	85 c0                	test   %eax,%eax
     53f:	74 51                	je     592 <rn_test3+0xc2>
    w_list[0] = p2;
     541:	89 7d c4             	mov    %edi,-0x3c(%ebp)
    w_list[1] = p4;
     544:	89 45 c8             	mov    %eax,-0x38(%ebp)
    w_list[2] = p3;
     547:	89 75 cc             	mov    %esi,-0x34(%ebp)
    w_list[3] = p1;
     54a:	8d 75 d4             	lea    -0x2c(%ebp),%esi
     54d:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    for (; w_cnt < 4; ) {
     550:	8d 5d c4             	lea    -0x3c(%ebp),%ebx
        p = wait();
     553:	e8 23 0e 00 00       	call   137b <wait>
        if (p == w_list[w_cnt]) ++w_cnt;
     558:	8b 13                	mov    (%ebx),%edx
     55a:	39 c2                	cmp    %eax,%edx
     55c:	75 21                	jne    57f <rn_test3+0xaf>
    for (; w_cnt < 4; ) {
     55e:	83 c3 04             	add    $0x4,%ebx
     561:	39 f3                	cmp    %esi,%ebx
     563:	75 ee                	jne    553 <rn_test3+0x83>
    printf(1, "rn_test3 finished successfully\n\n\n");
     565:	83 ec 08             	sub    $0x8,%esp
     568:	68 4c 1a 00 00       	push   $0x1a4c
     56d:	6a 01                	push   $0x1
     56f:	e8 8c 0f 00 00       	call   1500 <printf>
}
     574:	83 c4 10             	add    $0x10,%esp
     577:	8d 65 f4             	lea    -0xc(%ebp),%esp
     57a:	5b                   	pop    %ebx
     57b:	5e                   	pop    %esi
     57c:	5f                   	pop    %edi
     57d:	5d                   	pop    %ebp
     57e:	c3                   	ret    
            printf(1, "rn_test3 failed\n expected wait pid = %d, but wait pid = %d\n", w_list[w_cnt], p);
     57f:	50                   	push   %eax
     580:	52                   	push   %edx
     581:	68 10 1a 00 00       	push   $0x1a10
     586:	6a 01                	push   $0x1
     588:	e8 73 0f 00 00       	call   1500 <printf>
            exit();
     58d:	e8 e1 0d 00 00       	call   1373 <exit>
     592:	be 3c 00 00 00       	mov    $0x3c,%esi
     597:	8d 5d d4             	lea    -0x2c(%ebp),%ebx
     59a:	eb 2d                	jmp    5c9 <rn_test3+0xf9>
     59c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else ++level_cnt[lev];
     5a0:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
            if (setpriority(getpid(), 7) < 0) printf(1, "setpriority failed\n");
     5a4:	e8 4a 0e 00 00       	call   13f3 <getpid>
     5a9:	83 ec 08             	sub    $0x8,%esp
     5ac:	6a 07                	push   $0x7
     5ae:	50                   	push   %eax
     5af:	e8 6f 0e 00 00       	call   1423 <setpriority>
     5b4:	83 c4 10             	add    $0x10,%esp
     5b7:	85 c0                	test   %eax,%eax
     5b9:	78 2b                	js     5e6 <rn_test3+0x116>
            yield();
     5bb:	e8 53 0e 00 00       	call   1413 <yield>
        for (int cnt = 60; cnt--; ) {
     5c0:	83 ee 01             	sub    $0x1,%esi
     5c3:	0f 84 95 00 00 00    	je     65e <rn_test3+0x18e>
            rn_sleep(60);
     5c9:	83 ec 0c             	sub    $0xc,%esp
     5cc:	6a 3c                	push   $0x3c
     5ce:	e8 70 0e 00 00       	call   1443 <rn_sleep>
    lev = getlev();
     5d3:	e8 43 0e 00 00       	call   141b <getlev>
    if (lev == 99) ++level_cnt[4];
     5d8:	83 c4 10             	add    $0x10,%esp
     5db:	83 f8 63             	cmp    $0x63,%eax
     5de:	75 c0                	jne    5a0 <rn_test3+0xd0>
     5e0:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
     5e4:	eb be                	jmp    5a4 <rn_test3+0xd4>
            if (setpriority(getpid(), 7) < 0) printf(1, "setpriority failed\n");
     5e6:	83 ec 08             	sub    $0x8,%esp
     5e9:	68 ce 18 00 00       	push   $0x18ce
     5ee:	6a 01                	push   $0x1
     5f0:	e8 0b 0f 00 00       	call   1500 <printf>
     5f5:	83 c4 10             	add    $0x10,%esp
     5f8:	eb c1                	jmp    5bb <rn_test3+0xeb>
     5fa:	be 3c 00 00 00       	mov    $0x3c,%esi
     5ff:	8d 5d d4             	lea    -0x2c(%ebp),%ebx
     602:	eb 29                	jmp    62d <rn_test3+0x15d>
     604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else ++level_cnt[lev];
     608:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
            if (setpriority(getpid(), 4) < 0) printf(1, "setpriority failed\n");
     60c:	e8 e2 0d 00 00       	call   13f3 <getpid>
     611:	83 ec 08             	sub    $0x8,%esp
     614:	6a 04                	push   $0x4
     616:	50                   	push   %eax
     617:	e8 07 0e 00 00       	call   1423 <setpriority>
     61c:	83 c4 10             	add    $0x10,%esp
     61f:	85 c0                	test   %eax,%eax
     621:	78 27                	js     64a <rn_test3+0x17a>
            yield();
     623:	e8 eb 0d 00 00       	call   1413 <yield>
        for (int cnt = 60; cnt--; ) {
     628:	83 ee 01             	sub    $0x1,%esi
     62b:	74 43                	je     670 <rn_test3+0x1a0>
            rn_sleep(60);
     62d:	83 ec 0c             	sub    $0xc,%esp
     630:	6a 3c                	push   $0x3c
     632:	e8 0c 0e 00 00       	call   1443 <rn_sleep>
    lev = getlev();
     637:	e8 df 0d 00 00       	call   141b <getlev>
    if (lev == 99) ++level_cnt[4];
     63c:	83 c4 10             	add    $0x10,%esp
     63f:	83 f8 63             	cmp    $0x63,%eax
     642:	75 c4                	jne    608 <rn_test3+0x138>
     644:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
     648:	eb c2                	jmp    60c <rn_test3+0x13c>
            if (setpriority(getpid(), 4) < 0) printf(1, "setpriority failed\n");
     64a:	83 ec 08             	sub    $0x8,%esp
     64d:	68 ce 18 00 00       	push   $0x18ce
     652:	6a 01                	push   $0x1
     654:	e8 a7 0e 00 00       	call   1500 <printf>
     659:	83 c4 10             	add    $0x10,%esp
     65c:	eb c5                	jmp    623 <rn_test3+0x153>
        print_level_cnt(level_cnt, "p4");
     65e:	50                   	push   %eax
     65f:	50                   	push   %eax
     660:	68 b7 18 00 00       	push   $0x18b7
     665:	53                   	push   %ebx
     666:	e8 25 fa ff ff       	call   90 <print_level_cnt>
        exit();
     66b:	e8 03 0d 00 00       	call   1373 <exit>
        print_level_cnt(level_cnt, "p3");
     670:	52                   	push   %edx
     671:	52                   	push   %edx
     672:	68 9d 18 00 00       	push   $0x189d
     677:	53                   	push   %ebx
     678:	e8 13 fa ff ff       	call   90 <print_level_cnt>
        exit();
     67d:	e8 f1 0c 00 00       	call   1373 <exit>
     682:	be 3c 00 00 00       	mov    $0x3c,%esi
     687:	8d 5d d4             	lea    -0x2c(%ebp),%ebx
     68a:	eb 2d                	jmp    6b9 <rn_test3+0x1e9>
     68c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else ++level_cnt[lev];
     690:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
            if (setpriority(getpid(), 10) < 0) printf(1, "setpriority failed\n");
     694:	e8 5a 0d 00 00       	call   13f3 <getpid>
     699:	83 ec 08             	sub    $0x8,%esp
     69c:	6a 0a                	push   $0xa
     69e:	50                   	push   %eax
     69f:	e8 7f 0d 00 00       	call   1423 <setpriority>
     6a4:	83 c4 10             	add    $0x10,%esp
     6a7:	85 c0                	test   %eax,%eax
     6a9:	78 2b                	js     6d6 <rn_test3+0x206>
            yield();
     6ab:	e8 63 0d 00 00       	call   1413 <yield>
        for (int cnt = 60; cnt--; ) {
     6b0:	83 ee 01             	sub    $0x1,%esi
     6b3:	0f 84 95 00 00 00    	je     74e <rn_test3+0x27e>
            rn_sleep(60);
     6b9:	83 ec 0c             	sub    $0xc,%esp
     6bc:	6a 3c                	push   $0x3c
     6be:	e8 80 0d 00 00       	call   1443 <rn_sleep>
    lev = getlev();
     6c3:	e8 53 0d 00 00       	call   141b <getlev>
    if (lev == 99) ++level_cnt[4];
     6c8:	83 c4 10             	add    $0x10,%esp
     6cb:	83 f8 63             	cmp    $0x63,%eax
     6ce:	75 c0                	jne    690 <rn_test3+0x1c0>
     6d0:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
     6d4:	eb be                	jmp    694 <rn_test3+0x1c4>
            if (setpriority(getpid(), 10) < 0) printf(1, "setpriority failed\n");
     6d6:	83 ec 08             	sub    $0x8,%esp
     6d9:	68 ce 18 00 00       	push   $0x18ce
     6de:	6a 01                	push   $0x1
     6e0:	e8 1b 0e 00 00       	call   1500 <printf>
     6e5:	83 c4 10             	add    $0x10,%esp
     6e8:	eb c1                	jmp    6ab <rn_test3+0x1db>
     6ea:	be 3c 00 00 00       	mov    $0x3c,%esi
     6ef:	8d 5d d4             	lea    -0x2c(%ebp),%ebx
     6f2:	eb 29                	jmp    71d <rn_test3+0x24d>
     6f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else ++level_cnt[lev];
     6f8:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
            if (setpriority(getpid(), 1) < 0) printf(1, "setpriority failed\n");
     6fc:	e8 f2 0c 00 00       	call   13f3 <getpid>
     701:	83 ec 08             	sub    $0x8,%esp
     704:	6a 01                	push   $0x1
     706:	50                   	push   %eax
     707:	e8 17 0d 00 00       	call   1423 <setpriority>
     70c:	83 c4 10             	add    $0x10,%esp
     70f:	85 c0                	test   %eax,%eax
     711:	78 27                	js     73a <rn_test3+0x26a>
            yield();
     713:	e8 fb 0c 00 00       	call   1413 <yield>
        for (int cnt = 60; cnt--; ) {
     718:	83 ee 01             	sub    $0x1,%esi
     71b:	74 43                	je     760 <rn_test3+0x290>
            rn_sleep(60);
     71d:	83 ec 0c             	sub    $0xc,%esp
     720:	6a 3c                	push   $0x3c
     722:	e8 1c 0d 00 00       	call   1443 <rn_sleep>
    lev = getlev();
     727:	e8 ef 0c 00 00       	call   141b <getlev>
    if (lev == 99) ++level_cnt[4];
     72c:	83 c4 10             	add    $0x10,%esp
     72f:	83 f8 63             	cmp    $0x63,%eax
     732:	75 c4                	jne    6f8 <rn_test3+0x228>
     734:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
     738:	eb c2                	jmp    6fc <rn_test3+0x22c>
            if (setpriority(getpid(), 1) < 0) printf(1, "setpriority failed\n");
     73a:	83 ec 08             	sub    $0x8,%esp
     73d:	68 ce 18 00 00       	push   $0x18ce
     742:	6a 01                	push   $0x1
     744:	e8 b7 0d 00 00       	call   1500 <printf>
     749:	83 c4 10             	add    $0x10,%esp
     74c:	eb c5                	jmp    713 <rn_test3+0x243>
        print_level_cnt(level_cnt, "p2");
     74e:	51                   	push   %ecx
     74f:	51                   	push   %ecx
     750:	68 9a 18 00 00       	push   $0x189a
     755:	53                   	push   %ebx
     756:	e8 35 f9 ff ff       	call   90 <print_level_cnt>
        exit();
     75b:	e8 13 0c 00 00       	call   1373 <exit>
        print_level_cnt(level_cnt, "p1");
     760:	56                   	push   %esi
     761:	56                   	push   %esi
     762:	68 97 18 00 00       	push   $0x1897
     767:	53                   	push   %ebx
     768:	e8 23 f9 ff ff       	call   90 <print_level_cnt>
        exit();
     76d:	e8 01 0c 00 00       	call   1373 <exit>
     772:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000780 <rn_test4>:
void rn_test4() {
     780:	55                   	push   %ebp
     781:	89 e5                	mov    %esp,%ebp
     783:	57                   	push   %edi
     784:	56                   	push   %esi
     785:	53                   	push   %ebx
     786:	83 ec 34             	sub    $0x34,%esp
    printf(1, "rn_test4 [MoQ Only - wait 5sec]\n");
     789:	68 70 1a 00 00       	push   $0x1a70
     78e:	6a 01                	push   $0x1
     790:	e8 6b 0d 00 00       	call   1500 <printf>
    level_cnt[0] = level_cnt[1] = level_cnt[2] = level_cnt[3] = level_cnt[4] = 0;
     795:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
     79c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
     7a3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
     7aa:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
     7b1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    p1 = fork();
     7b8:	e8 ae 0b 00 00       	call   136b <fork>
    if (p1 == 0) {
     7bd:	83 c4 10             	add    $0x10,%esp
     7c0:	85 c0                	test   %eax,%eax
     7c2:	0f 84 82 01 00 00    	je     94a <rn_test4+0x1ca>
     7c8:	89 c7                	mov    %eax,%edi
    p2 = fork();
     7ca:	e8 9c 0b 00 00       	call   136b <fork>
     7cf:	89 c6                	mov    %eax,%esi
    if (p2 == 0) {
     7d1:	85 c0                	test   %eax,%eax
     7d3:	0f 84 ff 00 00 00    	je     8d8 <rn_test4+0x158>
    p3 = fork();
     7d9:	e8 8d 0b 00 00       	call   136b <fork>
     7de:	89 c3                	mov    %eax,%ebx
    if (p3 == 0) {
     7e0:	85 c0                	test   %eax,%eax
     7e2:	74 71                	je     855 <rn_test4+0xd5>
    rn_sleep(5000);
     7e4:	83 ec 0c             	sub    $0xc,%esp
     7e7:	68 88 13 00 00       	push   $0x1388
     7ec:	e8 52 0c 00 00       	call   1443 <rn_sleep>
    printf(1, "monopolize!\n");
     7f1:	58                   	pop    %eax
     7f2:	5a                   	pop    %edx
     7f3:	68 08 19 00 00       	push   $0x1908
     7f8:	6a 01                	push   $0x1
     7fa:	e8 01 0d 00 00       	call   1500 <printf>
    monopolize();
     7ff:	e8 2f 0c 00 00       	call   1433 <monopolize>
    w_list[0] = p1;
     804:	89 7d c8             	mov    %edi,-0x38(%ebp)
    w_list[1] = p2;
     807:	83 c4 10             	add    $0x10,%esp
     80a:	89 75 cc             	mov    %esi,-0x34(%ebp)
    w_list[2] = p3;
     80d:	8d 75 d4             	lea    -0x2c(%ebp),%esi
     810:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    for (; w_cnt < 3; ) {
     813:	8d 5d c8             	lea    -0x38(%ebp),%ebx
        p = wait();
     816:	e8 60 0b 00 00       	call   137b <wait>
        if (p == w_list[w_cnt]) ++w_cnt;
     81b:	8b 13                	mov    (%ebx),%edx
     81d:	39 c2                	cmp    %eax,%edx
     81f:	75 21                	jne    842 <rn_test4+0xc2>
    for (; w_cnt < 3; ) {
     821:	83 c3 04             	add    $0x4,%ebx
     824:	39 de                	cmp    %ebx,%esi
     826:	75 ee                	jne    816 <rn_test4+0x96>
    printf(1, "rn_test4 finished successfully\n\n\n");
     828:	83 ec 08             	sub    $0x8,%esp
     82b:	68 d0 1a 00 00       	push   $0x1ad0
     830:	6a 01                	push   $0x1
     832:	e8 c9 0c 00 00       	call   1500 <printf>
}
     837:	83 c4 10             	add    $0x10,%esp
     83a:	8d 65 f4             	lea    -0xc(%ebp),%esp
     83d:	5b                   	pop    %ebx
     83e:	5e                   	pop    %esi
     83f:	5f                   	pop    %edi
     840:	5d                   	pop    %ebp
     841:	c3                   	ret    
            printf(1, "rn_test4 failed\n expected wait pid = %d, but wait pid = %d\n", w_list[w_cnt], p);
     842:	50                   	push   %eax
     843:	52                   	push   %edx
     844:	68 94 1a 00 00       	push   $0x1a94
     849:	6a 01                	push   $0x1
     84b:	e8 b0 0c 00 00       	call   1500 <printf>
            exit();
     850:	e8 1e 0b 00 00       	call   1373 <exit>
        int r = setmonopoly(getpid(), RN_STUDENT_ID); 
     855:	e8 99 0b 00 00       	call   13f3 <getpid>
     85a:	53                   	push   %ebx
        printf(1, "monopolized process %d\n", getpid());
     85b:	be 1e 00 00 00       	mov    $0x1e,%esi
        int r = setmonopoly(getpid(), RN_STUDENT_ID); 
     860:	53                   	push   %ebx
     861:	8d 5d d4             	lea    -0x2c(%ebp),%ebx
     864:	68 9f 46 68 78       	push   $0x7868469f
     869:	50                   	push   %eax
     86a:	e8 bc 0b 00 00       	call   142b <setmonopoly>
        printf(1, "moq size: %d\n", r);    
     86f:	83 c4 0c             	add    $0xc,%esp
     872:	50                   	push   %eax
     873:	68 e2 18 00 00       	push   $0x18e2
     878:	6a 01                	push   $0x1
     87a:	e8 81 0c 00 00       	call   1500 <printf>
        printf(1, "monopolized process %d\n", getpid());
     87f:	e8 6f 0b 00 00       	call   13f3 <getpid>
     884:	83 c4 0c             	add    $0xc,%esp
     887:	50                   	push   %eax
     888:	68 f0 18 00 00       	push   $0x18f0
     88d:	6a 01                	push   $0x1
     88f:	e8 6c 0c 00 00       	call   1500 <printf>
     894:	83 c4 10             	add    $0x10,%esp
     897:	eb 10                	jmp    8a9 <rn_test4+0x129>
     899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    else ++level_cnt[lev];
     8a0:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
        for (int cnt = 30; cnt--; ) {
     8a4:	83 ee 01             	sub    $0x1,%esi
     8a7:	74 1d                	je     8c6 <rn_test4+0x146>
            rn_sleep(60);
     8a9:	83 ec 0c             	sub    $0xc,%esp
     8ac:	6a 3c                	push   $0x3c
     8ae:	e8 90 0b 00 00       	call   1443 <rn_sleep>
    lev = getlev();
     8b3:	e8 63 0b 00 00       	call   141b <getlev>
    if (lev == 99) ++level_cnt[4];
     8b8:	83 c4 10             	add    $0x10,%esp
     8bb:	83 f8 63             	cmp    $0x63,%eax
     8be:	75 e0                	jne    8a0 <rn_test4+0x120>
     8c0:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
     8c4:	eb de                	jmp    8a4 <rn_test4+0x124>
        print_level_cnt(level_cnt, "p3");
     8c6:	51                   	push   %ecx
     8c7:	51                   	push   %ecx
     8c8:	68 9d 18 00 00       	push   $0x189d
     8cd:	53                   	push   %ebx
     8ce:	e8 bd f7 ff ff       	call   90 <print_level_cnt>
        exit();
     8d3:	e8 9b 0a 00 00       	call   1373 <exit>
        int r = setmonopoly(getpid(), RN_STUDENT_ID);
     8d8:	e8 16 0b 00 00       	call   13f3 <getpid>
     8dd:	57                   	push   %edi
        printf(1, "monopolized process %d\n", getpid());
     8de:	be 3c 00 00 00       	mov    $0x3c,%esi
     8e3:	8d 5d d4             	lea    -0x2c(%ebp),%ebx
        int r = setmonopoly(getpid(), RN_STUDENT_ID);
     8e6:	57                   	push   %edi
     8e7:	68 9f 46 68 78       	push   $0x7868469f
     8ec:	50                   	push   %eax
     8ed:	e8 39 0b 00 00       	call   142b <setmonopoly>
        printf(1, "moq size: %d\n", r);    
     8f2:	83 c4 0c             	add    $0xc,%esp
     8f5:	50                   	push   %eax
     8f6:	68 e2 18 00 00       	push   $0x18e2
     8fb:	6a 01                	push   $0x1
     8fd:	e8 fe 0b 00 00       	call   1500 <printf>
        printf(1, "monopolized process %d\n", getpid());
     902:	e8 ec 0a 00 00       	call   13f3 <getpid>
     907:	83 c4 0c             	add    $0xc,%esp
     90a:	50                   	push   %eax
     90b:	68 f0 18 00 00       	push   $0x18f0
     910:	6a 01                	push   $0x1
     912:	e8 e9 0b 00 00       	call   1500 <printf>
     917:	83 c4 10             	add    $0x10,%esp
     91a:	eb 11                	jmp    92d <rn_test4+0x1ad>
     91c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else ++level_cnt[lev];
     920:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
        for (int cnt = 60; cnt--; ) {
     924:	83 ee 01             	sub    $0x1,%esi
     927:	0f 84 89 00 00 00    	je     9b6 <rn_test4+0x236>
            rn_sleep(60);
     92d:	83 ec 0c             	sub    $0xc,%esp
     930:	6a 3c                	push   $0x3c
     932:	e8 0c 0b 00 00       	call   1443 <rn_sleep>
    lev = getlev();
     937:	e8 df 0a 00 00       	call   141b <getlev>
    if (lev == 99) ++level_cnt[4];
     93c:	83 c4 10             	add    $0x10,%esp
     93f:	83 f8 63             	cmp    $0x63,%eax
     942:	75 dc                	jne    920 <rn_test4+0x1a0>
     944:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
     948:	eb da                	jmp    924 <rn_test4+0x1a4>
        int r = setmonopoly(getpid(), RN_STUDENT_ID);
     94a:	e8 a4 0a 00 00       	call   13f3 <getpid>
        printf(1, "monopolized process %d\n", getpid());
     94f:	be 64 00 00 00       	mov    $0x64,%esi
     954:	8d 5d d4             	lea    -0x2c(%ebp),%ebx
        int r = setmonopoly(getpid(), RN_STUDENT_ID);
     957:	52                   	push   %edx
     958:	52                   	push   %edx
     959:	68 9f 46 68 78       	push   $0x7868469f
     95e:	50                   	push   %eax
     95f:	e8 c7 0a 00 00       	call   142b <setmonopoly>
        printf(1, "moq size: %d\n", r);    
     964:	83 c4 0c             	add    $0xc,%esp
     967:	50                   	push   %eax
     968:	68 e2 18 00 00       	push   $0x18e2
     96d:	6a 01                	push   $0x1
     96f:	e8 8c 0b 00 00       	call   1500 <printf>
        printf(1, "monopolized process %d\n", getpid());
     974:	e8 7a 0a 00 00       	call   13f3 <getpid>
     979:	83 c4 0c             	add    $0xc,%esp
     97c:	50                   	push   %eax
     97d:	68 f0 18 00 00       	push   $0x18f0
     982:	6a 01                	push   $0x1
     984:	e8 77 0b 00 00       	call   1500 <printf>
     989:	83 c4 10             	add    $0x10,%esp
     98c:	eb 0b                	jmp    999 <rn_test4+0x219>
     98e:	66 90                	xchg   %ax,%ax
    else ++level_cnt[lev];
     990:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
        for (int cnt = 100; cnt--; ) {
     994:	83 ee 01             	sub    $0x1,%esi
     997:	74 2f                	je     9c8 <rn_test4+0x248>
            rn_sleep(60);
     999:	83 ec 0c             	sub    $0xc,%esp
     99c:	6a 3c                	push   $0x3c
     99e:	e8 a0 0a 00 00       	call   1443 <rn_sleep>
    lev = getlev();
     9a3:	e8 73 0a 00 00       	call   141b <getlev>
    if (lev == 99) ++level_cnt[4];
     9a8:	83 c4 10             	add    $0x10,%esp
     9ab:	83 f8 63             	cmp    $0x63,%eax
     9ae:	75 e0                	jne    990 <rn_test4+0x210>
     9b0:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
     9b4:	eb de                	jmp    994 <rn_test4+0x214>
        print_level_cnt(level_cnt, "p2");
     9b6:	56                   	push   %esi
     9b7:	56                   	push   %esi
     9b8:	68 9a 18 00 00       	push   $0x189a
     9bd:	53                   	push   %ebx
     9be:	e8 cd f6 ff ff       	call   90 <print_level_cnt>
        exit();
     9c3:	e8 ab 09 00 00       	call   1373 <exit>
        print_level_cnt(level_cnt, "p1");
     9c8:	50                   	push   %eax
     9c9:	50                   	push   %eax
     9ca:	68 97 18 00 00       	push   $0x1897
     9cf:	53                   	push   %ebx
     9d0:	e8 bb f6 ff ff       	call   90 <print_level_cnt>
        exit();
     9d5:	e8 99 09 00 00       	call   1373 <exit>
     9da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000009e0 <rn_test5>:
void rn_test5() {
     9e0:	55                   	push   %ebp
     9e1:	89 e5                	mov    %esp,%ebp
     9e3:	57                   	push   %edi
     9e4:	56                   	push   %esi
     9e5:	53                   	push   %ebx
     9e6:	83 ec 54             	sub    $0x54,%esp
    printf(1, "rn_test5 [L0, L1, L2, L3]\n");
     9e9:	68 15 19 00 00       	push   $0x1915
     9ee:	6a 01                	push   $0x1
     9f0:	e8 0b 0b 00 00       	call   1500 <printf>
    level_cnt[0] = level_cnt[1] = level_cnt[2] = level_cnt[3] = level_cnt[4] = 0;
     9f5:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
     9fc:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
     a03:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
     a0a:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
     a11:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    p1 = fork();
     a18:	e8 4e 09 00 00       	call   136b <fork>
    if (p1 == 0) {
     a1d:	83 c4 10             	add    $0x10,%esp
    p1 = fork();
     a20:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (p1 == 0) {
     a23:	85 c0                	test   %eax,%eax
     a25:	0f 84 07 02 00 00    	je     c32 <rn_test5+0x252>
    p2 = fork();
     a2b:	e8 3b 09 00 00       	call   136b <fork>
     a30:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (p2 == 0) {
     a33:	85 c0                	test   %eax,%eax
     a35:	0f 84 8c 01 00 00    	je     bc7 <rn_test5+0x1e7>
    p3 = fork();
     a3b:	e8 2b 09 00 00       	call   136b <fork>
     a40:	89 c3                	mov    %eax,%ebx
    if (p3 == 0) {
     a42:	85 c0                	test   %eax,%eax
     a44:	0f 84 70 02 00 00    	je     cba <rn_test5+0x2da>
    p4 = fork();
     a4a:	e8 1c 09 00 00       	call   136b <fork>
     a4f:	89 c6                	mov    %eax,%esi
    if (p4 == 0) {
     a51:	85 c0                	test   %eax,%eax
     a53:	0f 84 2e 01 00 00    	je     b87 <rn_test5+0x1a7>
    p5 = fork();
     a59:	e8 0d 09 00 00       	call   136b <fork>
     a5e:	89 c7                	mov    %eax,%edi
    if (p5 == 0) {
     a60:	85 c0                	test   %eax,%eax
     a62:	0f 84 c3 00 00 00    	je     b2b <rn_test5+0x14b>
    p6 = fork();
     a68:	e8 fe 08 00 00       	call   136b <fork>
     a6d:	89 c2                	mov    %eax,%edx
    if (p6 == 0) {
     a6f:	85 c0                	test   %eax,%eax
     a71:	74 7c                	je     aef <rn_test5+0x10f>
    if (p3 % 2 == 1) {
     a73:	89 d9                	mov    %ebx,%ecx
     a75:	c1 e9 1f             	shr    $0x1f,%ecx
     a78:	8d 04 0b             	lea    (%ebx,%ecx,1),%eax
     a7b:	83 e0 01             	and    $0x1,%eax
     a7e:	29 c8                	sub    %ecx,%eax
     a80:	83 f8 01             	cmp    $0x1,%eax
     a83:	75 06                	jne    a8b <rn_test5+0xab>
     a85:	89 d8                	mov    %ebx,%eax
     a87:	89 f3                	mov    %esi,%ebx
     a89:	89 c6                	mov    %eax,%esi
    w_list[4] = p1;
     a8b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    w_list[0] = p6;
     a8e:	89 55 d0             	mov    %edx,-0x30(%ebp)
    w_list[1] = p5;
     a91:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    w_list[4] = p1;
     a94:	89 45 e0             	mov    %eax,-0x20(%ebp)
    w_list[5] = p2;
     a97:	8b 45 b0             	mov    -0x50(%ebp),%eax
        w_list[2] = p3;
     a9a:	89 75 d8             	mov    %esi,-0x28(%ebp)
     a9d:	8d 75 e8             	lea    -0x18(%ebp),%esi
    w_list[5] = p2;
     aa0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        w_list[3] = p4;
     aa3:	89 5d dc             	mov    %ebx,-0x24(%ebp)
    for (; w_cnt < 6; ) {
     aa6:	8d 5d d0             	lea    -0x30(%ebp),%ebx
     aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        p = wait();
     ab0:	e8 c6 08 00 00       	call   137b <wait>
        if (p == w_list[w_cnt]) ++w_cnt;
     ab5:	8b 13                	mov    (%ebx),%edx
     ab7:	39 c2                	cmp    %eax,%edx
     ab9:	75 21                	jne    adc <rn_test5+0xfc>
    for (; w_cnt < 6; ) {
     abb:	83 c3 04             	add    $0x4,%ebx
     abe:	39 de                	cmp    %ebx,%esi
     ac0:	75 ee                	jne    ab0 <rn_test5+0xd0>
    printf(1, "rn_test5 finished successfully\n\n\n");
     ac2:	83 ec 08             	sub    $0x8,%esp
     ac5:	68 30 1b 00 00       	push   $0x1b30
     aca:	6a 01                	push   $0x1
     acc:	e8 2f 0a 00 00       	call   1500 <printf>
}
     ad1:	83 c4 10             	add    $0x10,%esp
     ad4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ad7:	5b                   	pop    %ebx
     ad8:	5e                   	pop    %esi
     ad9:	5f                   	pop    %edi
     ada:	5d                   	pop    %ebp
     adb:	c3                   	ret    
            printf(1, "rn_test5 failed\n expected wait pid = %d, but wait pid = %d\n", w_list[w_cnt], p);
     adc:	50                   	push   %eax
     add:	52                   	push   %edx
     ade:	68 f4 1a 00 00       	push   $0x1af4
     ae3:	6a 01                	push   $0x1
     ae5:	e8 16 0a 00 00       	call   1500 <printf>
            exit();
     aea:	e8 84 08 00 00       	call   1373 <exit>
     aef:	be f4 01 00 00       	mov    $0x1f4,%esi
     af4:	8d 5d bc             	lea    -0x44(%ebp),%ebx
     af7:	eb 15                	jmp    b0e <rn_test5+0x12e>
     af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    else ++level_cnt[lev];
     b00:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
            yield();
     b04:	e8 0a 09 00 00       	call   1413 <yield>
        for (int cnt = 500; cnt--; ) {
     b09:	83 ee 01             	sub    $0x1,%esi
     b0c:	74 55                	je     b63 <rn_test5+0x183>
            rn_sleep(3);
     b0e:	83 ec 0c             	sub    $0xc,%esp
     b11:	6a 03                	push   $0x3
     b13:	e8 2b 09 00 00       	call   1443 <rn_sleep>
    lev = getlev();
     b18:	e8 fe 08 00 00       	call   141b <getlev>
    if (lev == 99) ++level_cnt[4];
     b1d:	83 c4 10             	add    $0x10,%esp
     b20:	83 f8 63             	cmp    $0x63,%eax
     b23:	75 db                	jne    b00 <rn_test5+0x120>
     b25:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
     b29:	eb d9                	jmp    b04 <rn_test5+0x124>
     b2b:	be e8 03 00 00       	mov    $0x3e8,%esi
     b30:	8d 5d bc             	lea    -0x44(%ebp),%ebx
     b33:	eb 11                	jmp    b46 <rn_test5+0x166>
     b35:	8d 76 00             	lea    0x0(%esi),%esi
    else ++level_cnt[lev];
     b38:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
            yield();
     b3c:	e8 d2 08 00 00       	call   1413 <yield>
        for (int cnt = 1000; cnt--; ) {
     b41:	83 ee 01             	sub    $0x1,%esi
     b44:	74 2f                	je     b75 <rn_test5+0x195>
            rn_sleep(3);
     b46:	83 ec 0c             	sub    $0xc,%esp
     b49:	6a 03                	push   $0x3
     b4b:	e8 f3 08 00 00       	call   1443 <rn_sleep>
    lev = getlev();
     b50:	e8 c6 08 00 00       	call   141b <getlev>
    if (lev == 99) ++level_cnt[4];
     b55:	83 c4 10             	add    $0x10,%esp
     b58:	83 f8 63             	cmp    $0x63,%eax
     b5b:	75 db                	jne    b38 <rn_test5+0x158>
     b5d:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
     b61:	eb d9                	jmp    b3c <rn_test5+0x15c>
        print_level_cnt(level_cnt, "p6");
     b63:	50                   	push   %eax
     b64:	50                   	push   %eax
     b65:	68 33 19 00 00       	push   $0x1933
     b6a:	53                   	push   %ebx
     b6b:	e8 20 f5 ff ff       	call   90 <print_level_cnt>
        exit();
     b70:	e8 fe 07 00 00       	call   1373 <exit>
        print_level_cnt(level_cnt, "p5");
     b75:	52                   	push   %edx
     b76:	52                   	push   %edx
     b77:	68 30 19 00 00       	push   $0x1930
     b7c:	53                   	push   %ebx
     b7d:	e8 0e f5 ff ff       	call   90 <print_level_cnt>
        exit();
     b82:	e8 ec 07 00 00       	call   1373 <exit>
     b87:	be c8 00 00 00       	mov    $0xc8,%esi
     b8c:	8d 5d bc             	lea    -0x44(%ebp),%ebx
     b8f:	eb 19                	jmp    baa <rn_test5+0x1ca>
     b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    else ++level_cnt[lev];
     b98:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
            yield();
     b9c:	e8 72 08 00 00       	call   1413 <yield>
        for (int cnt = 200; cnt--; ) {
     ba1:	83 ee 01             	sub    $0x1,%esi
     ba4:	0f 84 49 01 00 00    	je     cf3 <rn_test5+0x313>
            rn_sleep(20);
     baa:	83 ec 0c             	sub    $0xc,%esp
     bad:	6a 14                	push   $0x14
     baf:	e8 8f 08 00 00       	call   1443 <rn_sleep>
    lev = getlev();
     bb4:	e8 62 08 00 00       	call   141b <getlev>
    if (lev == 99) ++level_cnt[4];
     bb9:	83 c4 10             	add    $0x10,%esp
     bbc:	83 f8 63             	cmp    $0x63,%eax
     bbf:	75 d7                	jne    b98 <rn_test5+0x1b8>
     bc1:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
     bc5:	eb d5                	jmp    b9c <rn_test5+0x1bc>
     bc7:	be 3c 00 00 00       	mov    $0x3c,%esi
     bcc:	8d 5d bc             	lea    -0x44(%ebp),%ebx
     bcf:	eb 30                	jmp    c01 <rn_test5+0x221>
     bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    else ++level_cnt[lev];
     bd8:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
            if (setpriority(getpid(), 4) < 0) printf(1, "setpriority failed\n");
     bdc:	e8 12 08 00 00       	call   13f3 <getpid>
     be1:	83 ec 08             	sub    $0x8,%esp
     be4:	6a 04                	push   $0x4
     be6:	50                   	push   %eax
     be7:	e8 37 08 00 00       	call   1423 <setpriority>
     bec:	83 c4 10             	add    $0x10,%esp
     bef:	85 c0                	test   %eax,%eax
     bf1:	78 2b                	js     c1e <rn_test5+0x23e>
            yield();
     bf3:	e8 1b 08 00 00       	call   1413 <yield>
        for (int cnt = 60; cnt--; ) {
     bf8:	83 ee 01             	sub    $0x1,%esi
     bfb:	0f 84 95 00 00 00    	je     c96 <rn_test5+0x2b6>
            rn_sleep(60);
     c01:	83 ec 0c             	sub    $0xc,%esp
     c04:	6a 3c                	push   $0x3c
     c06:	e8 38 08 00 00       	call   1443 <rn_sleep>
    lev = getlev();
     c0b:	e8 0b 08 00 00       	call   141b <getlev>
    if (lev == 99) ++level_cnt[4];
     c10:	83 c4 10             	add    $0x10,%esp
     c13:	83 f8 63             	cmp    $0x63,%eax
     c16:	75 c0                	jne    bd8 <rn_test5+0x1f8>
     c18:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
     c1c:	eb be                	jmp    bdc <rn_test5+0x1fc>
            if (setpriority(getpid(), 4) < 0) printf(1, "setpriority failed\n");
     c1e:	83 ec 08             	sub    $0x8,%esp
     c21:	68 ce 18 00 00       	push   $0x18ce
     c26:	6a 01                	push   $0x1
     c28:	e8 d3 08 00 00       	call   1500 <printf>
     c2d:	83 c4 10             	add    $0x10,%esp
     c30:	eb c1                	jmp    bf3 <rn_test5+0x213>
     c32:	be 3c 00 00 00       	mov    $0x3c,%esi
     c37:	8d 5d bc             	lea    -0x44(%ebp),%ebx
     c3a:	eb 29                	jmp    c65 <rn_test5+0x285>
     c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else ++level_cnt[lev];
     c40:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
            if (setpriority(getpid(), 10) < 0) printf(1, "setpriority failed\n");
     c44:	e8 aa 07 00 00       	call   13f3 <getpid>
     c49:	83 ec 08             	sub    $0x8,%esp
     c4c:	6a 0a                	push   $0xa
     c4e:	50                   	push   %eax
     c4f:	e8 cf 07 00 00       	call   1423 <setpriority>
     c54:	83 c4 10             	add    $0x10,%esp
     c57:	85 c0                	test   %eax,%eax
     c59:	78 27                	js     c82 <rn_test5+0x2a2>
            yield();
     c5b:	e8 b3 07 00 00       	call   1413 <yield>
        for (int cnt = 60; cnt--; ) {
     c60:	83 ee 01             	sub    $0x1,%esi
     c63:	74 43                	je     ca8 <rn_test5+0x2c8>
            rn_sleep(60);
     c65:	83 ec 0c             	sub    $0xc,%esp
     c68:	6a 3c                	push   $0x3c
     c6a:	e8 d4 07 00 00       	call   1443 <rn_sleep>
    lev = getlev();
     c6f:	e8 a7 07 00 00       	call   141b <getlev>
    if (lev == 99) ++level_cnt[4];
     c74:	83 c4 10             	add    $0x10,%esp
     c77:	83 f8 63             	cmp    $0x63,%eax
     c7a:	75 c4                	jne    c40 <rn_test5+0x260>
     c7c:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
     c80:	eb c2                	jmp    c44 <rn_test5+0x264>
            if (setpriority(getpid(), 10) < 0) printf(1, "setpriority failed\n");
     c82:	83 ec 08             	sub    $0x8,%esp
     c85:	68 ce 18 00 00       	push   $0x18ce
     c8a:	6a 01                	push   $0x1
     c8c:	e8 6f 08 00 00       	call   1500 <printf>
     c91:	83 c4 10             	add    $0x10,%esp
     c94:	eb c5                	jmp    c5b <rn_test5+0x27b>
        print_level_cnt(level_cnt, "p2");
     c96:	57                   	push   %edi
     c97:	57                   	push   %edi
     c98:	68 9a 18 00 00       	push   $0x189a
     c9d:	53                   	push   %ebx
     c9e:	e8 ed f3 ff ff       	call   90 <print_level_cnt>
        exit();
     ca3:	e8 cb 06 00 00       	call   1373 <exit>
        print_level_cnt(level_cnt, "p1");
     ca8:	50                   	push   %eax
     ca9:	50                   	push   %eax
     caa:	68 97 18 00 00       	push   $0x1897
     caf:	53                   	push   %ebx
     cb0:	e8 db f3 ff ff       	call   90 <print_level_cnt>
        exit();
     cb5:	e8 b9 06 00 00       	call   1373 <exit>
     cba:	be c8 00 00 00       	mov    $0xc8,%esi
     cbf:	8d 5d bc             	lea    -0x44(%ebp),%ebx
     cc2:	eb 12                	jmp    cd6 <rn_test5+0x2f6>
     cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else ++level_cnt[lev];
     cc8:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
            yield();
     ccc:	e8 42 07 00 00       	call   1413 <yield>
        for (int cnt = 200; cnt--; ) {
     cd1:	83 ee 01             	sub    $0x1,%esi
     cd4:	74 2f                	je     d05 <rn_test5+0x325>
            rn_sleep(20);
     cd6:	83 ec 0c             	sub    $0xc,%esp
     cd9:	6a 14                	push   $0x14
     cdb:	e8 63 07 00 00       	call   1443 <rn_sleep>
    lev = getlev();
     ce0:	e8 36 07 00 00       	call   141b <getlev>
    if (lev == 99) ++level_cnt[4];
     ce5:	83 c4 10             	add    $0x10,%esp
     ce8:	83 f8 63             	cmp    $0x63,%eax
     ceb:	75 db                	jne    cc8 <rn_test5+0x2e8>
     ced:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
     cf1:	eb d9                	jmp    ccc <rn_test5+0x2ec>
        print_level_cnt(level_cnt, "p4");
     cf3:	51                   	push   %ecx
     cf4:	51                   	push   %ecx
     cf5:	68 b7 18 00 00       	push   $0x18b7
     cfa:	53                   	push   %ebx
     cfb:	e8 90 f3 ff ff       	call   90 <print_level_cnt>
        exit();
     d00:	e8 6e 06 00 00       	call   1373 <exit>
        print_level_cnt(level_cnt, "p3");
     d05:	56                   	push   %esi
     d06:	56                   	push   %esi
     d07:	68 9d 18 00 00       	push   $0x189d
     d0c:	53                   	push   %ebx
     d0d:	e8 7e f3 ff ff       	call   90 <print_level_cnt>
        exit();
     d12:	e8 5c 06 00 00       	call   1373 <exit>
     d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     d1e:	66 90                	xchg   %ax,%ax

00000d20 <rn_test6>:
void rn_test6() {
     d20:	55                   	push   %ebp
     d21:	89 e5                	mov    %esp,%ebp
     d23:	57                   	push   %edi
     d24:	56                   	push   %esi
     d25:	53                   	push   %ebx
     d26:	83 ec 54             	sub    $0x54,%esp
    printf(1, "rn_test6 [L0, L1, L2, L3, MoQ]\n");
     d29:	68 54 1b 00 00       	push   $0x1b54
     d2e:	6a 01                	push   $0x1
     d30:	e8 cb 07 00 00       	call   1500 <printf>
    level_cnt[0] = level_cnt[1] = level_cnt[2] = level_cnt[3] = level_cnt[4] = 0;
     d35:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
     d3c:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
     d43:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
     d4a:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
     d51:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
    p1 = fork();
     d58:	e8 0e 06 00 00       	call   136b <fork>
    if (p1 == 0) {
     d5d:	83 c4 10             	add    $0x10,%esp
    p1 = fork();
     d60:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    if (p1 == 0) {
     d63:	85 c0                	test   %eax,%eax
     d65:	0f 84 cf 02 00 00    	je     103a <rn_test6+0x31a>
    p2 = fork();
     d6b:	e8 fb 05 00 00       	call   136b <fork>
     d70:	89 45 b0             	mov    %eax,-0x50(%ebp)
    if (p2 == 0) {
     d73:	85 c0                	test   %eax,%eax
     d75:	0f 84 54 02 00 00    	je     fcf <rn_test6+0x2af>
    p3 = fork();
     d7b:	e8 eb 05 00 00       	call   136b <fork>
     d80:	89 c3                	mov    %eax,%ebx
    if (p3 == 0) {
     d82:	85 c0                	test   %eax,%eax
     d84:	0f 84 38 03 00 00    	je     10c2 <rn_test6+0x3a2>
    p4 = fork();
     d8a:	e8 dc 05 00 00       	call   136b <fork>
     d8f:	89 c6                	mov    %eax,%esi
    if (p4 == 0) {
     d91:	85 c0                	test   %eax,%eax
     d93:	0f 84 f6 01 00 00    	je     f8f <rn_test6+0x26f>
    p5 = fork();
     d99:	e8 cd 05 00 00       	call   136b <fork>
     d9e:	89 45 ac             	mov    %eax,-0x54(%ebp)
    if (p5 == 0) {
     da1:	85 c0                	test   %eax,%eax
     da3:	0f 84 8a 01 00 00    	je     f33 <rn_test6+0x213>
    p6 = fork();
     da9:	e8 bd 05 00 00       	call   136b <fork>
     dae:	89 c7                	mov    %eax,%edi
    if (p6 == 0) {
     db0:	85 c0                	test   %eax,%eax
     db2:	0f 84 43 01 00 00    	je     efb <rn_test6+0x1db>
    p7 = fork();
     db8:	e8 ae 05 00 00       	call   136b <fork>
     dbd:	89 c2                	mov    %eax,%edx
    if (p7 == 0) {
     dbf:	85 c0                	test   %eax,%eax
     dc1:	0f 84 9d 00 00 00    	je     e64 <rn_test6+0x144>
    if (p3 % 2 == 1) {
     dc7:	89 d9                	mov    %ebx,%ecx
     dc9:	c1 e9 1f             	shr    $0x1f,%ecx
     dcc:	8d 04 0b             	lea    (%ebx,%ecx,1),%eax
     dcf:	83 e0 01             	and    $0x1,%eax
     dd2:	29 c8                	sub    %ecx,%eax
     dd4:	83 f8 01             	cmp    $0x1,%eax
     dd7:	75 06                	jne    ddf <rn_test6+0xbf>
     dd9:	89 d8                	mov    %ebx,%eax
     ddb:	89 f3                	mov    %esi,%ebx
     ddd:	89 c6                	mov    %eax,%esi
    w_list[1] = p5;
     ddf:	8b 45 ac             	mov    -0x54(%ebp),%eax
    w_list[0] = p6;
     de2:	89 7d cc             	mov    %edi,-0x34(%ebp)
        w_list[2] = p3;
     de5:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    w_list[1] = p5;
     de8:	89 45 d0             	mov    %eax,-0x30(%ebp)
    w_list[5] = p1;
     deb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    w_list[3] = p7;
     dee:	89 55 d8             	mov    %edx,-0x28(%ebp)
    w_list[5] = p1;
     df1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    w_list[6] = p2;
     df4:	8b 45 b0             	mov    -0x50(%ebp),%eax
        w_list[4] = p4;
     df7:	89 5d dc             	mov    %ebx,-0x24(%ebp)
    w_cnt = 0;
     dfa:	31 db                	xor    %ebx,%ebx
    w_list[6] = p2;
     dfc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for (; w_cnt < 7; ) {
     dff:	90                   	nop
        p = wait();
     e00:	e8 76 05 00 00       	call   137b <wait>
        if (p == w_list[w_cnt]) ++w_cnt;
     e05:	8b 54 9d cc          	mov    -0x34(%ebp,%ebx,4),%edx
     e09:	39 c2                	cmp    %eax,%edx
     e0b:	75 44                	jne    e51 <rn_test6+0x131>
     e0d:	83 c3 01             	add    $0x1,%ebx
        if (w_cnt == 3) {
     e10:	83 fb 03             	cmp    $0x3,%ebx
     e13:	74 23                	je     e38 <rn_test6+0x118>
    for (; w_cnt < 7; ) {
     e15:	83 fb 07             	cmp    $0x7,%ebx
     e18:	75 e6                	jne    e00 <rn_test6+0xe0>
    printf(1, "rn_test6 finished successfully\n\n\n");
     e1a:	83 ec 08             	sub    $0x8,%esp
     e1d:	68 b0 1b 00 00       	push   $0x1bb0
     e22:	6a 01                	push   $0x1
     e24:	e8 d7 06 00 00       	call   1500 <printf>
}
     e29:	83 c4 10             	add    $0x10,%esp
     e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
     e2f:	5b                   	pop    %ebx
     e30:	5e                   	pop    %esi
     e31:	5f                   	pop    %edi
     e32:	5d                   	pop    %ebp
     e33:	c3                   	ret    
     e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            printf(1, "monopolize!\n");
     e38:	83 ec 08             	sub    $0x8,%esp
     e3b:	68 08 19 00 00       	push   $0x1908
     e40:	6a 01                	push   $0x1
     e42:	e8 b9 06 00 00       	call   1500 <printf>
            monopolize();
     e47:	e8 e7 05 00 00       	call   1433 <monopolize>
     e4c:	83 c4 10             	add    $0x10,%esp
    for (; w_cnt < 7; ) {
     e4f:	eb af                	jmp    e00 <rn_test6+0xe0>
            printf(1, "rn_test6 failed\n expected wait pid = %d, but wait pid = %d\n", w_list[w_cnt], p);
     e51:	50                   	push   %eax
     e52:	52                   	push   %edx
     e53:	68 74 1b 00 00       	push   $0x1b74
     e58:	6a 01                	push   $0x1
     e5a:	e8 a1 06 00 00       	call   1500 <printf>
            exit();
     e5f:	e8 0f 05 00 00       	call   1373 <exit>
        if (setmonopoly(getpid(), RN_STUDENT_ID) < 0) printf(1, "setmonopoly failed\n");
     e64:	e8 8a 05 00 00       	call   13f3 <getpid>
     e69:	51                   	push   %ecx
     e6a:	51                   	push   %ecx
     e6b:	68 9f 46 68 78       	push   $0x7868469f
     e70:	50                   	push   %eax
     e71:	e8 b5 05 00 00       	call   142b <setmonopoly>
     e76:	83 c4 10             	add    $0x10,%esp
     e79:	85 c0                	test   %eax,%eax
     e7b:	78 59                	js     ed6 <rn_test6+0x1b6>
        rn_sleep(1000);
     e7d:	83 ec 0c             	sub    $0xc,%esp
        printf(1, "monopolized process %d\n", getpid());
     e80:	be 1e 00 00 00       	mov    $0x1e,%esi
     e85:	8d 5d b8             	lea    -0x48(%ebp),%ebx
        rn_sleep(1000);
     e88:	68 e8 03 00 00       	push   $0x3e8
     e8d:	e8 b1 05 00 00       	call   1443 <rn_sleep>
        printf(1, "monopolized process %d\n", getpid());
     e92:	e8 5c 05 00 00       	call   13f3 <getpid>
     e97:	83 c4 0c             	add    $0xc,%esp
     e9a:	50                   	push   %eax
     e9b:	68 f0 18 00 00       	push   $0x18f0
     ea0:	6a 01                	push   $0x1
     ea2:	e8 59 06 00 00       	call   1500 <printf>
     ea7:	83 c4 10             	add    $0x10,%esp
     eaa:	eb 0d                	jmp    eb9 <rn_test6+0x199>
     eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else ++level_cnt[lev];
     eb0:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
        for (int cnt = 30; cnt--; ) {
     eb4:	83 ee 01             	sub    $0x1,%esi
     eb7:	74 30                	je     ee9 <rn_test6+0x1c9>
            rn_sleep(60);
     eb9:	83 ec 0c             	sub    $0xc,%esp
     ebc:	6a 3c                	push   $0x3c
     ebe:	e8 80 05 00 00       	call   1443 <rn_sleep>
    lev = getlev();
     ec3:	e8 53 05 00 00       	call   141b <getlev>
    if (lev == 99) ++level_cnt[4];
     ec8:	83 c4 10             	add    $0x10,%esp
     ecb:	83 f8 63             	cmp    $0x63,%eax
     ece:	75 e0                	jne    eb0 <rn_test6+0x190>
     ed0:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
     ed4:	eb de                	jmp    eb4 <rn_test6+0x194>
        if (setmonopoly(getpid(), RN_STUDENT_ID) < 0) printf(1, "setmonopoly failed\n");
     ed6:	52                   	push   %edx
     ed7:	52                   	push   %edx
     ed8:	68 36 19 00 00       	push   $0x1936
     edd:	6a 01                	push   $0x1
     edf:	e8 1c 06 00 00       	call   1500 <printf>
     ee4:	83 c4 10             	add    $0x10,%esp
     ee7:	eb 94                	jmp    e7d <rn_test6+0x15d>
        print_level_cnt(level_cnt, "p7");
     ee9:	50                   	push   %eax
     eea:	50                   	push   %eax
     eeb:	68 4a 19 00 00       	push   $0x194a
     ef0:	53                   	push   %ebx
     ef1:	e8 9a f1 ff ff       	call   90 <print_level_cnt>
        exit();
     ef6:	e8 78 04 00 00       	call   1373 <exit>
     efb:	be f4 01 00 00       	mov    $0x1f4,%esi
     f00:	8d 5d b8             	lea    -0x48(%ebp),%ebx
     f03:	eb 11                	jmp    f16 <rn_test6+0x1f6>
     f05:	8d 76 00             	lea    0x0(%esi),%esi
    else ++level_cnt[lev];
     f08:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
            yield();
     f0c:	e8 02 05 00 00       	call   1413 <yield>
        for (int cnt = 500; cnt--; ) {
     f11:	83 ee 01             	sub    $0x1,%esi
     f14:	74 55                	je     f6b <rn_test6+0x24b>
            rn_sleep(3);
     f16:	83 ec 0c             	sub    $0xc,%esp
     f19:	6a 03                	push   $0x3
     f1b:	e8 23 05 00 00       	call   1443 <rn_sleep>
    lev = getlev();
     f20:	e8 f6 04 00 00       	call   141b <getlev>
    if (lev == 99) ++level_cnt[4];
     f25:	83 c4 10             	add    $0x10,%esp
     f28:	83 f8 63             	cmp    $0x63,%eax
     f2b:	75 db                	jne    f08 <rn_test6+0x1e8>
     f2d:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
     f31:	eb d9                	jmp    f0c <rn_test6+0x1ec>
     f33:	be e8 03 00 00       	mov    $0x3e8,%esi
     f38:	8d 5d b8             	lea    -0x48(%ebp),%ebx
     f3b:	eb 11                	jmp    f4e <rn_test6+0x22e>
     f3d:	8d 76 00             	lea    0x0(%esi),%esi
    else ++level_cnt[lev];
     f40:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
            yield();
     f44:	e8 ca 04 00 00       	call   1413 <yield>
        for (int cnt = 1000; cnt--; ) {
     f49:	83 ee 01             	sub    $0x1,%esi
     f4c:	74 2f                	je     f7d <rn_test6+0x25d>
            rn_sleep(3);
     f4e:	83 ec 0c             	sub    $0xc,%esp
     f51:	6a 03                	push   $0x3
     f53:	e8 eb 04 00 00       	call   1443 <rn_sleep>
    lev = getlev();
     f58:	e8 be 04 00 00       	call   141b <getlev>
    if (lev == 99) ++level_cnt[4];
     f5d:	83 c4 10             	add    $0x10,%esp
     f60:	83 f8 63             	cmp    $0x63,%eax
     f63:	75 db                	jne    f40 <rn_test6+0x220>
     f65:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
     f69:	eb d9                	jmp    f44 <rn_test6+0x224>
        print_level_cnt(level_cnt, "p6");
     f6b:	56                   	push   %esi
     f6c:	56                   	push   %esi
     f6d:	68 33 19 00 00       	push   $0x1933
     f72:	53                   	push   %ebx
     f73:	e8 18 f1 ff ff       	call   90 <print_level_cnt>
        exit();
     f78:	e8 f6 03 00 00       	call   1373 <exit>
        print_level_cnt(level_cnt, "p5");
     f7d:	57                   	push   %edi
     f7e:	57                   	push   %edi
     f7f:	68 30 19 00 00       	push   $0x1930
     f84:	53                   	push   %ebx
     f85:	e8 06 f1 ff ff       	call   90 <print_level_cnt>
        exit();
     f8a:	e8 e4 03 00 00       	call   1373 <exit>
     f8f:	be c8 00 00 00       	mov    $0xc8,%esi
     f94:	8d 5d b8             	lea    -0x48(%ebp),%ebx
     f97:	eb 19                	jmp    fb2 <rn_test6+0x292>
     f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    else ++level_cnt[lev];
     fa0:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
            yield();
     fa4:	e8 6a 04 00 00       	call   1413 <yield>
        for (int cnt = 200; cnt--; ) {
     fa9:	83 ee 01             	sub    $0x1,%esi
     fac:	0f 84 49 01 00 00    	je     10fb <rn_test6+0x3db>
            rn_sleep(20);
     fb2:	83 ec 0c             	sub    $0xc,%esp
     fb5:	6a 14                	push   $0x14
     fb7:	e8 87 04 00 00       	call   1443 <rn_sleep>
    lev = getlev();
     fbc:	e8 5a 04 00 00       	call   141b <getlev>
    if (lev == 99) ++level_cnt[4];
     fc1:	83 c4 10             	add    $0x10,%esp
     fc4:	83 f8 63             	cmp    $0x63,%eax
     fc7:	75 d7                	jne    fa0 <rn_test6+0x280>
     fc9:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
     fcd:	eb d5                	jmp    fa4 <rn_test6+0x284>
     fcf:	be 3c 00 00 00       	mov    $0x3c,%esi
     fd4:	8d 5d b8             	lea    -0x48(%ebp),%ebx
     fd7:	eb 30                	jmp    1009 <rn_test6+0x2e9>
     fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    else ++level_cnt[lev];
     fe0:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
            if (setpriority(getpid(), 4) < 0) printf(1, "setpriority failed\n");
     fe4:	e8 0a 04 00 00       	call   13f3 <getpid>
     fe9:	83 ec 08             	sub    $0x8,%esp
     fec:	6a 04                	push   $0x4
     fee:	50                   	push   %eax
     fef:	e8 2f 04 00 00       	call   1423 <setpriority>
     ff4:	83 c4 10             	add    $0x10,%esp
     ff7:	85 c0                	test   %eax,%eax
     ff9:	78 2b                	js     1026 <rn_test6+0x306>
            yield();
     ffb:	e8 13 04 00 00       	call   1413 <yield>
        for (int cnt = 60; cnt--; ) {
    1000:	83 ee 01             	sub    $0x1,%esi
    1003:	0f 84 95 00 00 00    	je     109e <rn_test6+0x37e>
            rn_sleep(60);
    1009:	83 ec 0c             	sub    $0xc,%esp
    100c:	6a 3c                	push   $0x3c
    100e:	e8 30 04 00 00       	call   1443 <rn_sleep>
    lev = getlev();
    1013:	e8 03 04 00 00       	call   141b <getlev>
    if (lev == 99) ++level_cnt[4];
    1018:	83 c4 10             	add    $0x10,%esp
    101b:	83 f8 63             	cmp    $0x63,%eax
    101e:	75 c0                	jne    fe0 <rn_test6+0x2c0>
    1020:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
    1024:	eb be                	jmp    fe4 <rn_test6+0x2c4>
            if (setpriority(getpid(), 4) < 0) printf(1, "setpriority failed\n");
    1026:	83 ec 08             	sub    $0x8,%esp
    1029:	68 ce 18 00 00       	push   $0x18ce
    102e:	6a 01                	push   $0x1
    1030:	e8 cb 04 00 00       	call   1500 <printf>
    1035:	83 c4 10             	add    $0x10,%esp
    1038:	eb c1                	jmp    ffb <rn_test6+0x2db>
    103a:	be 3c 00 00 00       	mov    $0x3c,%esi
    103f:	8d 5d b8             	lea    -0x48(%ebp),%ebx
    1042:	eb 29                	jmp    106d <rn_test6+0x34d>
    1044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else ++level_cnt[lev];
    1048:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
            if (setpriority(getpid(), 10) < 0) printf(1, "setpriority failed\n");
    104c:	e8 a2 03 00 00       	call   13f3 <getpid>
    1051:	83 ec 08             	sub    $0x8,%esp
    1054:	6a 0a                	push   $0xa
    1056:	50                   	push   %eax
    1057:	e8 c7 03 00 00       	call   1423 <setpriority>
    105c:	83 c4 10             	add    $0x10,%esp
    105f:	85 c0                	test   %eax,%eax
    1061:	78 27                	js     108a <rn_test6+0x36a>
            yield();
    1063:	e8 ab 03 00 00       	call   1413 <yield>
        for (int cnt = 60; cnt--; ) {
    1068:	83 ee 01             	sub    $0x1,%esi
    106b:	74 43                	je     10b0 <rn_test6+0x390>
            rn_sleep(60);
    106d:	83 ec 0c             	sub    $0xc,%esp
    1070:	6a 3c                	push   $0x3c
    1072:	e8 cc 03 00 00       	call   1443 <rn_sleep>
    lev = getlev();
    1077:	e8 9f 03 00 00       	call   141b <getlev>
    if (lev == 99) ++level_cnt[4];
    107c:	83 c4 10             	add    $0x10,%esp
    107f:	83 f8 63             	cmp    $0x63,%eax
    1082:	75 c4                	jne    1048 <rn_test6+0x328>
    1084:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
    1088:	eb c2                	jmp    104c <rn_test6+0x32c>
            if (setpriority(getpid(), 10) < 0) printf(1, "setpriority failed\n");
    108a:	83 ec 08             	sub    $0x8,%esp
    108d:	68 ce 18 00 00       	push   $0x18ce
    1092:	6a 01                	push   $0x1
    1094:	e8 67 04 00 00       	call   1500 <printf>
    1099:	83 c4 10             	add    $0x10,%esp
    109c:	eb c5                	jmp    1063 <rn_test6+0x343>
        print_level_cnt(level_cnt, "p2");
    109e:	50                   	push   %eax
    109f:	50                   	push   %eax
    10a0:	68 9a 18 00 00       	push   $0x189a
    10a5:	53                   	push   %ebx
    10a6:	e8 e5 ef ff ff       	call   90 <print_level_cnt>
        exit();
    10ab:	e8 c3 02 00 00       	call   1373 <exit>
        print_level_cnt(level_cnt, "p1");
    10b0:	50                   	push   %eax
    10b1:	50                   	push   %eax
    10b2:	68 97 18 00 00       	push   $0x1897
    10b7:	53                   	push   %ebx
    10b8:	e8 d3 ef ff ff       	call   90 <print_level_cnt>
        exit();
    10bd:	e8 b1 02 00 00       	call   1373 <exit>
    10c2:	be c8 00 00 00       	mov    $0xc8,%esi
    10c7:	8d 5d b8             	lea    -0x48(%ebp),%ebx
    10ca:	eb 12                	jmp    10de <rn_test6+0x3be>
    10cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else ++level_cnt[lev];
    10d0:	83 04 83 01          	addl   $0x1,(%ebx,%eax,4)
            yield();
    10d4:	e8 3a 03 00 00       	call   1413 <yield>
        for (int cnt = 200; cnt--; ) {
    10d9:	83 ee 01             	sub    $0x1,%esi
    10dc:	74 2f                	je     110d <rn_test6+0x3ed>
            rn_sleep(20);
    10de:	83 ec 0c             	sub    $0xc,%esp
    10e1:	6a 14                	push   $0x14
    10e3:	e8 5b 03 00 00       	call   1443 <rn_sleep>
    lev = getlev();
    10e8:	e8 2e 03 00 00       	call   141b <getlev>
    if (lev == 99) ++level_cnt[4];
    10ed:	83 c4 10             	add    $0x10,%esp
    10f0:	83 f8 63             	cmp    $0x63,%eax
    10f3:	75 db                	jne    10d0 <rn_test6+0x3b0>
    10f5:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
    10f9:	eb d9                	jmp    10d4 <rn_test6+0x3b4>
        print_level_cnt(level_cnt, "p4");
    10fb:	50                   	push   %eax
    10fc:	50                   	push   %eax
    10fd:	68 b7 18 00 00       	push   $0x18b7
    1102:	53                   	push   %ebx
    1103:	e8 88 ef ff ff       	call   90 <print_level_cnt>
        exit();
    1108:	e8 66 02 00 00       	call   1373 <exit>
        print_level_cnt(level_cnt, "p3");
    110d:	50                   	push   %eax
    110e:	50                   	push   %eax
    110f:	68 9d 18 00 00       	push   $0x189d
    1114:	53                   	push   %ebx
    1115:	e8 76 ef ff ff       	call   90 <print_level_cnt>
        exit();
    111a:	e8 54 02 00 00       	call   1373 <exit>
    111f:	90                   	nop

00001120 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    1120:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1121:	31 c0                	xor    %eax,%eax
{
    1123:	89 e5                	mov    %esp,%ebp
    1125:	53                   	push   %ebx
    1126:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1129:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    112c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
    1130:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
    1134:	88 14 01             	mov    %dl,(%ecx,%eax,1)
    1137:	83 c0 01             	add    $0x1,%eax
    113a:	84 d2                	test   %dl,%dl
    113c:	75 f2                	jne    1130 <strcpy+0x10>
    ;
  return os;
}
    113e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1141:	89 c8                	mov    %ecx,%eax
    1143:	c9                   	leave  
    1144:	c3                   	ret    
    1145:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    114c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001150 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1150:	55                   	push   %ebp
    1151:	89 e5                	mov    %esp,%ebp
    1153:	53                   	push   %ebx
    1154:	8b 55 08             	mov    0x8(%ebp),%edx
    1157:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
    115a:	0f b6 02             	movzbl (%edx),%eax
    115d:	84 c0                	test   %al,%al
    115f:	75 17                	jne    1178 <strcmp+0x28>
    1161:	eb 3a                	jmp    119d <strcmp+0x4d>
    1163:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1167:	90                   	nop
    1168:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
    116c:	83 c2 01             	add    $0x1,%edx
    116f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
    1172:	84 c0                	test   %al,%al
    1174:	74 1a                	je     1190 <strcmp+0x40>
    p++, q++;
    1176:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
    1178:	0f b6 19             	movzbl (%ecx),%ebx
    117b:	38 c3                	cmp    %al,%bl
    117d:	74 e9                	je     1168 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
    117f:	29 d8                	sub    %ebx,%eax
}
    1181:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1184:	c9                   	leave  
    1185:	c3                   	ret    
    1186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    118d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
    1190:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
    1194:	31 c0                	xor    %eax,%eax
    1196:	29 d8                	sub    %ebx,%eax
}
    1198:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    119b:	c9                   	leave  
    119c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
    119d:	0f b6 19             	movzbl (%ecx),%ebx
    11a0:	31 c0                	xor    %eax,%eax
    11a2:	eb db                	jmp    117f <strcmp+0x2f>
    11a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    11af:	90                   	nop

000011b0 <strlen>:

uint
strlen(const char *s)
{
    11b0:	55                   	push   %ebp
    11b1:	89 e5                	mov    %esp,%ebp
    11b3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
    11b6:	80 3a 00             	cmpb   $0x0,(%edx)
    11b9:	74 15                	je     11d0 <strlen+0x20>
    11bb:	31 c0                	xor    %eax,%eax
    11bd:	8d 76 00             	lea    0x0(%esi),%esi
    11c0:	83 c0 01             	add    $0x1,%eax
    11c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    11c7:	89 c1                	mov    %eax,%ecx
    11c9:	75 f5                	jne    11c0 <strlen+0x10>
    ;
  return n;
}
    11cb:	89 c8                	mov    %ecx,%eax
    11cd:	5d                   	pop    %ebp
    11ce:	c3                   	ret    
    11cf:	90                   	nop
  for(n = 0; s[n]; n++)
    11d0:	31 c9                	xor    %ecx,%ecx
}
    11d2:	5d                   	pop    %ebp
    11d3:	89 c8                	mov    %ecx,%eax
    11d5:	c3                   	ret    
    11d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11dd:	8d 76 00             	lea    0x0(%esi),%esi

000011e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11e0:	55                   	push   %ebp
    11e1:	89 e5                	mov    %esp,%ebp
    11e3:	57                   	push   %edi
    11e4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    11e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
    11ea:	8b 45 0c             	mov    0xc(%ebp),%eax
    11ed:	89 d7                	mov    %edx,%edi
    11ef:	fc                   	cld    
    11f0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    11f2:	8b 7d fc             	mov    -0x4(%ebp),%edi
    11f5:	89 d0                	mov    %edx,%eax
    11f7:	c9                   	leave  
    11f8:	c3                   	ret    
    11f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001200 <strchr>:

char*
strchr(const char *s, char c)
{
    1200:	55                   	push   %ebp
    1201:	89 e5                	mov    %esp,%ebp
    1203:	8b 45 08             	mov    0x8(%ebp),%eax
    1206:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    120a:	0f b6 10             	movzbl (%eax),%edx
    120d:	84 d2                	test   %dl,%dl
    120f:	75 12                	jne    1223 <strchr+0x23>
    1211:	eb 1d                	jmp    1230 <strchr+0x30>
    1213:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1217:	90                   	nop
    1218:	0f b6 50 01          	movzbl 0x1(%eax),%edx
    121c:	83 c0 01             	add    $0x1,%eax
    121f:	84 d2                	test   %dl,%dl
    1221:	74 0d                	je     1230 <strchr+0x30>
    if(*s == c)
    1223:	38 d1                	cmp    %dl,%cl
    1225:	75 f1                	jne    1218 <strchr+0x18>
      return (char*)s;
  return 0;
}
    1227:	5d                   	pop    %ebp
    1228:	c3                   	ret    
    1229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
    1230:	31 c0                	xor    %eax,%eax
}
    1232:	5d                   	pop    %ebp
    1233:	c3                   	ret    
    1234:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    123b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    123f:	90                   	nop

00001240 <gets>:

char*
gets(char *buf, int max)
{
    1240:	55                   	push   %ebp
    1241:	89 e5                	mov    %esp,%ebp
    1243:	57                   	push   %edi
    1244:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    1245:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
    1248:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
    1249:	31 db                	xor    %ebx,%ebx
{
    124b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
    124e:	eb 27                	jmp    1277 <gets+0x37>
    cc = read(0, &c, 1);
    1250:	83 ec 04             	sub    $0x4,%esp
    1253:	6a 01                	push   $0x1
    1255:	57                   	push   %edi
    1256:	6a 00                	push   $0x0
    1258:	e8 2e 01 00 00       	call   138b <read>
    if(cc < 1)
    125d:	83 c4 10             	add    $0x10,%esp
    1260:	85 c0                	test   %eax,%eax
    1262:	7e 1d                	jle    1281 <gets+0x41>
      break;
    buf[i++] = c;
    1264:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    1268:	8b 55 08             	mov    0x8(%ebp),%edx
    126b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
    126f:	3c 0a                	cmp    $0xa,%al
    1271:	74 1d                	je     1290 <gets+0x50>
    1273:	3c 0d                	cmp    $0xd,%al
    1275:	74 19                	je     1290 <gets+0x50>
  for(i=0; i+1 < max; ){
    1277:	89 de                	mov    %ebx,%esi
    1279:	83 c3 01             	add    $0x1,%ebx
    127c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    127f:	7c cf                	jl     1250 <gets+0x10>
      break;
  }
  buf[i] = '\0';
    1281:	8b 45 08             	mov    0x8(%ebp),%eax
    1284:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    1288:	8d 65 f4             	lea    -0xc(%ebp),%esp
    128b:	5b                   	pop    %ebx
    128c:	5e                   	pop    %esi
    128d:	5f                   	pop    %edi
    128e:	5d                   	pop    %ebp
    128f:	c3                   	ret    
  buf[i] = '\0';
    1290:	8b 45 08             	mov    0x8(%ebp),%eax
    1293:	89 de                	mov    %ebx,%esi
    1295:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
    1299:	8d 65 f4             	lea    -0xc(%ebp),%esp
    129c:	5b                   	pop    %ebx
    129d:	5e                   	pop    %esi
    129e:	5f                   	pop    %edi
    129f:	5d                   	pop    %ebp
    12a0:	c3                   	ret    
    12a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    12a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    12af:	90                   	nop

000012b0 <stat>:

int
stat(const char *n, struct stat *st)
{
    12b0:	55                   	push   %ebp
    12b1:	89 e5                	mov    %esp,%ebp
    12b3:	56                   	push   %esi
    12b4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12b5:	83 ec 08             	sub    $0x8,%esp
    12b8:	6a 00                	push   $0x0
    12ba:	ff 75 08             	push   0x8(%ebp)
    12bd:	e8 f1 00 00 00       	call   13b3 <open>
  if(fd < 0)
    12c2:	83 c4 10             	add    $0x10,%esp
    12c5:	85 c0                	test   %eax,%eax
    12c7:	78 27                	js     12f0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
    12c9:	83 ec 08             	sub    $0x8,%esp
    12cc:	ff 75 0c             	push   0xc(%ebp)
    12cf:	89 c3                	mov    %eax,%ebx
    12d1:	50                   	push   %eax
    12d2:	e8 f4 00 00 00       	call   13cb <fstat>
  close(fd);
    12d7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    12da:	89 c6                	mov    %eax,%esi
  close(fd);
    12dc:	e8 ba 00 00 00       	call   139b <close>
  return r;
    12e1:	83 c4 10             	add    $0x10,%esp
}
    12e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
    12e7:	89 f0                	mov    %esi,%eax
    12e9:	5b                   	pop    %ebx
    12ea:	5e                   	pop    %esi
    12eb:	5d                   	pop    %ebp
    12ec:	c3                   	ret    
    12ed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
    12f0:	be ff ff ff ff       	mov    $0xffffffff,%esi
    12f5:	eb ed                	jmp    12e4 <stat+0x34>
    12f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    12fe:	66 90                	xchg   %ax,%ax

00001300 <atoi>:

int
atoi(const char *s)
{
    1300:	55                   	push   %ebp
    1301:	89 e5                	mov    %esp,%ebp
    1303:	53                   	push   %ebx
    1304:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1307:	0f be 02             	movsbl (%edx),%eax
    130a:	8d 48 d0             	lea    -0x30(%eax),%ecx
    130d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
    1310:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
    1315:	77 1e                	ja     1335 <atoi+0x35>
    1317:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    131e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
    1320:	83 c2 01             	add    $0x1,%edx
    1323:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
    1326:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
    132a:	0f be 02             	movsbl (%edx),%eax
    132d:	8d 58 d0             	lea    -0x30(%eax),%ebx
    1330:	80 fb 09             	cmp    $0x9,%bl
    1333:	76 eb                	jbe    1320 <atoi+0x20>
  return n;
}
    1335:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1338:	89 c8                	mov    %ecx,%eax
    133a:	c9                   	leave  
    133b:	c3                   	ret    
    133c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001340 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1340:	55                   	push   %ebp
    1341:	89 e5                	mov    %esp,%ebp
    1343:	57                   	push   %edi
    1344:	8b 45 10             	mov    0x10(%ebp),%eax
    1347:	8b 55 08             	mov    0x8(%ebp),%edx
    134a:	56                   	push   %esi
    134b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    134e:	85 c0                	test   %eax,%eax
    1350:	7e 13                	jle    1365 <memmove+0x25>
    1352:	01 d0                	add    %edx,%eax
  dst = vdst;
    1354:	89 d7                	mov    %edx,%edi
    1356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    135d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
    1360:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    1361:	39 f8                	cmp    %edi,%eax
    1363:	75 fb                	jne    1360 <memmove+0x20>
  return vdst;
}
    1365:	5e                   	pop    %esi
    1366:	89 d0                	mov    %edx,%eax
    1368:	5f                   	pop    %edi
    1369:	5d                   	pop    %ebp
    136a:	c3                   	ret    

0000136b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    136b:	b8 01 00 00 00       	mov    $0x1,%eax
    1370:	cd 40                	int    $0x40
    1372:	c3                   	ret    

00001373 <exit>:
SYSCALL(exit)
    1373:	b8 02 00 00 00       	mov    $0x2,%eax
    1378:	cd 40                	int    $0x40
    137a:	c3                   	ret    

0000137b <wait>:
SYSCALL(wait)
    137b:	b8 03 00 00 00       	mov    $0x3,%eax
    1380:	cd 40                	int    $0x40
    1382:	c3                   	ret    

00001383 <pipe>:
SYSCALL(pipe)
    1383:	b8 04 00 00 00       	mov    $0x4,%eax
    1388:	cd 40                	int    $0x40
    138a:	c3                   	ret    

0000138b <read>:
SYSCALL(read)
    138b:	b8 05 00 00 00       	mov    $0x5,%eax
    1390:	cd 40                	int    $0x40
    1392:	c3                   	ret    

00001393 <write>:
SYSCALL(write)
    1393:	b8 10 00 00 00       	mov    $0x10,%eax
    1398:	cd 40                	int    $0x40
    139a:	c3                   	ret    

0000139b <close>:
SYSCALL(close)
    139b:	b8 15 00 00 00       	mov    $0x15,%eax
    13a0:	cd 40                	int    $0x40
    13a2:	c3                   	ret    

000013a3 <kill>:
SYSCALL(kill)
    13a3:	b8 06 00 00 00       	mov    $0x6,%eax
    13a8:	cd 40                	int    $0x40
    13aa:	c3                   	ret    

000013ab <exec>:
SYSCALL(exec)
    13ab:	b8 07 00 00 00       	mov    $0x7,%eax
    13b0:	cd 40                	int    $0x40
    13b2:	c3                   	ret    

000013b3 <open>:
SYSCALL(open)
    13b3:	b8 0f 00 00 00       	mov    $0xf,%eax
    13b8:	cd 40                	int    $0x40
    13ba:	c3                   	ret    

000013bb <mknod>:
SYSCALL(mknod)
    13bb:	b8 11 00 00 00       	mov    $0x11,%eax
    13c0:	cd 40                	int    $0x40
    13c2:	c3                   	ret    

000013c3 <unlink>:
SYSCALL(unlink)
    13c3:	b8 12 00 00 00       	mov    $0x12,%eax
    13c8:	cd 40                	int    $0x40
    13ca:	c3                   	ret    

000013cb <fstat>:
SYSCALL(fstat)
    13cb:	b8 08 00 00 00       	mov    $0x8,%eax
    13d0:	cd 40                	int    $0x40
    13d2:	c3                   	ret    

000013d3 <link>:
SYSCALL(link)
    13d3:	b8 13 00 00 00       	mov    $0x13,%eax
    13d8:	cd 40                	int    $0x40
    13da:	c3                   	ret    

000013db <mkdir>:
SYSCALL(mkdir)
    13db:	b8 14 00 00 00       	mov    $0x14,%eax
    13e0:	cd 40                	int    $0x40
    13e2:	c3                   	ret    

000013e3 <chdir>:
SYSCALL(chdir)
    13e3:	b8 09 00 00 00       	mov    $0x9,%eax
    13e8:	cd 40                	int    $0x40
    13ea:	c3                   	ret    

000013eb <dup>:
SYSCALL(dup)
    13eb:	b8 0a 00 00 00       	mov    $0xa,%eax
    13f0:	cd 40                	int    $0x40
    13f2:	c3                   	ret    

000013f3 <getpid>:
SYSCALL(getpid)
    13f3:	b8 0b 00 00 00       	mov    $0xb,%eax
    13f8:	cd 40                	int    $0x40
    13fa:	c3                   	ret    

000013fb <sbrk>:
SYSCALL(sbrk)
    13fb:	b8 0c 00 00 00       	mov    $0xc,%eax
    1400:	cd 40                	int    $0x40
    1402:	c3                   	ret    

00001403 <sleep>:
SYSCALL(sleep)
    1403:	b8 0d 00 00 00       	mov    $0xd,%eax
    1408:	cd 40                	int    $0x40
    140a:	c3                   	ret    

0000140b <uptime>:
SYSCALL(uptime)
    140b:	b8 0e 00 00 00       	mov    $0xe,%eax
    1410:	cd 40                	int    $0x40
    1412:	c3                   	ret    

00001413 <yield>:
SYSCALL(yield)
    1413:	b8 16 00 00 00       	mov    $0x16,%eax
    1418:	cd 40                	int    $0x40
    141a:	c3                   	ret    

0000141b <getlev>:
SYSCALL(getlev)
    141b:	b8 17 00 00 00       	mov    $0x17,%eax
    1420:	cd 40                	int    $0x40
    1422:	c3                   	ret    

00001423 <setpriority>:
SYSCALL(setpriority)
    1423:	b8 18 00 00 00       	mov    $0x18,%eax
    1428:	cd 40                	int    $0x40
    142a:	c3                   	ret    

0000142b <setmonopoly>:
SYSCALL(setmonopoly)
    142b:	b8 19 00 00 00       	mov    $0x19,%eax
    1430:	cd 40                	int    $0x40
    1432:	c3                   	ret    

00001433 <monopolize>:
SYSCALL(monopolize);
    1433:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1438:	cd 40                	int    $0x40
    143a:	c3                   	ret    

0000143b <unmonopolize>:
SYSCALL(unmonopolize);
    143b:	b8 1b 00 00 00       	mov    $0x1b,%eax
    1440:	cd 40                	int    $0x40
    1442:	c3                   	ret    

00001443 <rn_sleep>:
    1443:	b8 1c 00 00 00       	mov    $0x1c,%eax
    1448:	cd 40                	int    $0x40
    144a:	c3                   	ret    
    144b:	66 90                	xchg   %ax,%ax
    144d:	66 90                	xchg   %ax,%ax
    144f:	90                   	nop

00001450 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1450:	55                   	push   %ebp
    1451:	89 e5                	mov    %esp,%ebp
    1453:	57                   	push   %edi
    1454:	56                   	push   %esi
    1455:	53                   	push   %ebx
    1456:	83 ec 3c             	sub    $0x3c,%esp
    1459:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    145c:	89 d1                	mov    %edx,%ecx
{
    145e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
    1461:	85 d2                	test   %edx,%edx
    1463:	0f 89 7f 00 00 00    	jns    14e8 <printint+0x98>
    1469:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    146d:	74 79                	je     14e8 <printint+0x98>
    neg = 1;
    146f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
    1476:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
    1478:	31 db                	xor    %ebx,%ebx
    147a:	8d 75 d7             	lea    -0x29(%ebp),%esi
    147d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    1480:	89 c8                	mov    %ecx,%eax
    1482:	31 d2                	xor    %edx,%edx
    1484:	89 cf                	mov    %ecx,%edi
    1486:	f7 75 c4             	divl   -0x3c(%ebp)
    1489:	0f b6 92 34 1c 00 00 	movzbl 0x1c34(%edx),%edx
    1490:	89 45 c0             	mov    %eax,-0x40(%ebp)
    1493:	89 d8                	mov    %ebx,%eax
    1495:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
    1498:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
    149b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
    149e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
    14a1:	76 dd                	jbe    1480 <printint+0x30>
  if(neg)
    14a3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
    14a6:	85 c9                	test   %ecx,%ecx
    14a8:	74 0c                	je     14b6 <printint+0x66>
    buf[i++] = '-';
    14aa:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
    14af:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
    14b1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
    14b6:	8b 7d b8             	mov    -0x48(%ebp),%edi
    14b9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
    14bd:	eb 07                	jmp    14c6 <printint+0x76>
    14bf:	90                   	nop
    putc(fd, buf[i]);
    14c0:	0f b6 13             	movzbl (%ebx),%edx
    14c3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
    14c6:	83 ec 04             	sub    $0x4,%esp
    14c9:	88 55 d7             	mov    %dl,-0x29(%ebp)
    14cc:	6a 01                	push   $0x1
    14ce:	56                   	push   %esi
    14cf:	57                   	push   %edi
    14d0:	e8 be fe ff ff       	call   1393 <write>
  while(--i >= 0)
    14d5:	83 c4 10             	add    $0x10,%esp
    14d8:	39 de                	cmp    %ebx,%esi
    14da:	75 e4                	jne    14c0 <printint+0x70>
}
    14dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    14df:	5b                   	pop    %ebx
    14e0:	5e                   	pop    %esi
    14e1:	5f                   	pop    %edi
    14e2:	5d                   	pop    %ebp
    14e3:	c3                   	ret    
    14e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    14e8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    14ef:	eb 87                	jmp    1478 <printint+0x28>
    14f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    14f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    14ff:	90                   	nop

00001500 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1500:	55                   	push   %ebp
    1501:	89 e5                	mov    %esp,%ebp
    1503:	57                   	push   %edi
    1504:	56                   	push   %esi
    1505:	53                   	push   %ebx
    1506:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1509:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
    150c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
    150f:	0f b6 13             	movzbl (%ebx),%edx
    1512:	84 d2                	test   %dl,%dl
    1514:	74 6a                	je     1580 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
    1516:	8d 45 10             	lea    0x10(%ebp),%eax
    1519:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
    151c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    151f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
    1521:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1524:	eb 36                	jmp    155c <printf+0x5c>
    1526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    152d:	8d 76 00             	lea    0x0(%esi),%esi
    1530:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    1533:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
    1538:	83 f8 25             	cmp    $0x25,%eax
    153b:	74 15                	je     1552 <printf+0x52>
  write(fd, &c, 1);
    153d:	83 ec 04             	sub    $0x4,%esp
    1540:	88 55 e7             	mov    %dl,-0x19(%ebp)
    1543:	6a 01                	push   $0x1
    1545:	57                   	push   %edi
    1546:	56                   	push   %esi
    1547:	e8 47 fe ff ff       	call   1393 <write>
    154c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
    154f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    1552:	0f b6 13             	movzbl (%ebx),%edx
    1555:	83 c3 01             	add    $0x1,%ebx
    1558:	84 d2                	test   %dl,%dl
    155a:	74 24                	je     1580 <printf+0x80>
    c = fmt[i] & 0xff;
    155c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
    155f:	85 c9                	test   %ecx,%ecx
    1561:	74 cd                	je     1530 <printf+0x30>
      }
    } else if(state == '%'){
    1563:	83 f9 25             	cmp    $0x25,%ecx
    1566:	75 ea                	jne    1552 <printf+0x52>
      if(c == 'd'){
    1568:	83 f8 25             	cmp    $0x25,%eax
    156b:	0f 84 07 01 00 00    	je     1678 <printf+0x178>
    1571:	83 e8 63             	sub    $0x63,%eax
    1574:	83 f8 15             	cmp    $0x15,%eax
    1577:	77 17                	ja     1590 <printf+0x90>
    1579:	ff 24 85 dc 1b 00 00 	jmp    *0x1bdc(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1580:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1583:	5b                   	pop    %ebx
    1584:	5e                   	pop    %esi
    1585:	5f                   	pop    %edi
    1586:	5d                   	pop    %ebp
    1587:	c3                   	ret    
    1588:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    158f:	90                   	nop
  write(fd, &c, 1);
    1590:	83 ec 04             	sub    $0x4,%esp
    1593:	88 55 d4             	mov    %dl,-0x2c(%ebp)
    1596:	6a 01                	push   $0x1
    1598:	57                   	push   %edi
    1599:	56                   	push   %esi
    159a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    159e:	e8 f0 fd ff ff       	call   1393 <write>
        putc(fd, c);
    15a3:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
    15a7:	83 c4 0c             	add    $0xc,%esp
    15aa:	88 55 e7             	mov    %dl,-0x19(%ebp)
    15ad:	6a 01                	push   $0x1
    15af:	57                   	push   %edi
    15b0:	56                   	push   %esi
    15b1:	e8 dd fd ff ff       	call   1393 <write>
        putc(fd, c);
    15b6:	83 c4 10             	add    $0x10,%esp
      state = 0;
    15b9:	31 c9                	xor    %ecx,%ecx
    15bb:	eb 95                	jmp    1552 <printf+0x52>
    15bd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
    15c0:	83 ec 0c             	sub    $0xc,%esp
    15c3:	b9 10 00 00 00       	mov    $0x10,%ecx
    15c8:	6a 00                	push   $0x0
    15ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
    15cd:	8b 10                	mov    (%eax),%edx
    15cf:	89 f0                	mov    %esi,%eax
    15d1:	e8 7a fe ff ff       	call   1450 <printint>
        ap++;
    15d6:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
    15da:	83 c4 10             	add    $0x10,%esp
      state = 0;
    15dd:	31 c9                	xor    %ecx,%ecx
    15df:	e9 6e ff ff ff       	jmp    1552 <printf+0x52>
    15e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    15e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
    15eb:	8b 10                	mov    (%eax),%edx
        ap++;
    15ed:	83 c0 04             	add    $0x4,%eax
    15f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    15f3:	85 d2                	test   %edx,%edx
    15f5:	0f 84 8d 00 00 00    	je     1688 <printf+0x188>
        while(*s != 0){
    15fb:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
    15fe:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
    1600:	84 c0                	test   %al,%al
    1602:	0f 84 4a ff ff ff    	je     1552 <printf+0x52>
    1608:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    160b:	89 d3                	mov    %edx,%ebx
    160d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
    1610:	83 ec 04             	sub    $0x4,%esp
          s++;
    1613:	83 c3 01             	add    $0x1,%ebx
    1616:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1619:	6a 01                	push   $0x1
    161b:	57                   	push   %edi
    161c:	56                   	push   %esi
    161d:	e8 71 fd ff ff       	call   1393 <write>
        while(*s != 0){
    1622:	0f b6 03             	movzbl (%ebx),%eax
    1625:	83 c4 10             	add    $0x10,%esp
    1628:	84 c0                	test   %al,%al
    162a:	75 e4                	jne    1610 <printf+0x110>
      state = 0;
    162c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
    162f:	31 c9                	xor    %ecx,%ecx
    1631:	e9 1c ff ff ff       	jmp    1552 <printf+0x52>
    1636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    163d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
    1640:	83 ec 0c             	sub    $0xc,%esp
    1643:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1648:	6a 01                	push   $0x1
    164a:	e9 7b ff ff ff       	jmp    15ca <printf+0xca>
    164f:	90                   	nop
        putc(fd, *ap);
    1650:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
    1653:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    1656:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
    1658:	6a 01                	push   $0x1
    165a:	57                   	push   %edi
    165b:	56                   	push   %esi
        putc(fd, *ap);
    165c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    165f:	e8 2f fd ff ff       	call   1393 <write>
        ap++;
    1664:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
    1668:	83 c4 10             	add    $0x10,%esp
      state = 0;
    166b:	31 c9                	xor    %ecx,%ecx
    166d:	e9 e0 fe ff ff       	jmp    1552 <printf+0x52>
    1672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
    1678:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
    167b:	83 ec 04             	sub    $0x4,%esp
    167e:	e9 2a ff ff ff       	jmp    15ad <printf+0xad>
    1683:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1687:	90                   	nop
          s = "(null)";
    1688:	ba d2 1b 00 00       	mov    $0x1bd2,%edx
        while(*s != 0){
    168d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    1690:	b8 28 00 00 00       	mov    $0x28,%eax
    1695:	89 d3                	mov    %edx,%ebx
    1697:	e9 74 ff ff ff       	jmp    1610 <printf+0x110>
    169c:	66 90                	xchg   %ax,%ax
    169e:	66 90                	xchg   %ax,%ax

000016a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    16a0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16a1:	a1 60 20 00 00       	mov    0x2060,%eax
{
    16a6:	89 e5                	mov    %esp,%ebp
    16a8:	57                   	push   %edi
    16a9:	56                   	push   %esi
    16aa:	53                   	push   %ebx
    16ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    16ae:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    16b8:	89 c2                	mov    %eax,%edx
    16ba:	8b 00                	mov    (%eax),%eax
    16bc:	39 ca                	cmp    %ecx,%edx
    16be:	73 30                	jae    16f0 <free+0x50>
    16c0:	39 c1                	cmp    %eax,%ecx
    16c2:	72 04                	jb     16c8 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16c4:	39 c2                	cmp    %eax,%edx
    16c6:	72 f0                	jb     16b8 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
    16c8:	8b 73 fc             	mov    -0x4(%ebx),%esi
    16cb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    16ce:	39 f8                	cmp    %edi,%eax
    16d0:	74 30                	je     1702 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    16d2:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    16d5:	8b 42 04             	mov    0x4(%edx),%eax
    16d8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    16db:	39 f1                	cmp    %esi,%ecx
    16dd:	74 3a                	je     1719 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    16df:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
    16e1:	5b                   	pop    %ebx
  freep = p;
    16e2:	89 15 60 20 00 00    	mov    %edx,0x2060
}
    16e8:	5e                   	pop    %esi
    16e9:	5f                   	pop    %edi
    16ea:	5d                   	pop    %ebp
    16eb:	c3                   	ret    
    16ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16f0:	39 c2                	cmp    %eax,%edx
    16f2:	72 c4                	jb     16b8 <free+0x18>
    16f4:	39 c1                	cmp    %eax,%ecx
    16f6:	73 c0                	jae    16b8 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
    16f8:	8b 73 fc             	mov    -0x4(%ebx),%esi
    16fb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    16fe:	39 f8                	cmp    %edi,%eax
    1700:	75 d0                	jne    16d2 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
    1702:	03 70 04             	add    0x4(%eax),%esi
    1705:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1708:	8b 02                	mov    (%edx),%eax
    170a:	8b 00                	mov    (%eax),%eax
    170c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
    170f:	8b 42 04             	mov    0x4(%edx),%eax
    1712:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    1715:	39 f1                	cmp    %esi,%ecx
    1717:	75 c6                	jne    16df <free+0x3f>
    p->s.size += bp->s.size;
    1719:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
    171c:	89 15 60 20 00 00    	mov    %edx,0x2060
    p->s.size += bp->s.size;
    1722:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
    1725:	8b 4b f8             	mov    -0x8(%ebx),%ecx
    1728:	89 0a                	mov    %ecx,(%edx)
}
    172a:	5b                   	pop    %ebx
    172b:	5e                   	pop    %esi
    172c:	5f                   	pop    %edi
    172d:	5d                   	pop    %ebp
    172e:	c3                   	ret    
    172f:	90                   	nop

00001730 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1730:	55                   	push   %ebp
    1731:	89 e5                	mov    %esp,%ebp
    1733:	57                   	push   %edi
    1734:	56                   	push   %esi
    1735:	53                   	push   %ebx
    1736:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1739:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    173c:	8b 3d 60 20 00 00    	mov    0x2060,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1742:	8d 70 07             	lea    0x7(%eax),%esi
    1745:	c1 ee 03             	shr    $0x3,%esi
    1748:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    174b:	85 ff                	test   %edi,%edi
    174d:	0f 84 9d 00 00 00    	je     17f0 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1753:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
    1755:	8b 4a 04             	mov    0x4(%edx),%ecx
    1758:	39 f1                	cmp    %esi,%ecx
    175a:	73 6a                	jae    17c6 <malloc+0x96>
    175c:	bb 00 10 00 00       	mov    $0x1000,%ebx
    1761:	39 de                	cmp    %ebx,%esi
    1763:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    1766:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
    176d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    1770:	eb 17                	jmp    1789 <malloc+0x59>
    1772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1778:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    177a:	8b 48 04             	mov    0x4(%eax),%ecx
    177d:	39 f1                	cmp    %esi,%ecx
    177f:	73 4f                	jae    17d0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1781:	8b 3d 60 20 00 00    	mov    0x2060,%edi
    1787:	89 c2                	mov    %eax,%edx
    1789:	39 d7                	cmp    %edx,%edi
    178b:	75 eb                	jne    1778 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
    178d:	83 ec 0c             	sub    $0xc,%esp
    1790:	ff 75 e4             	push   -0x1c(%ebp)
    1793:	e8 63 fc ff ff       	call   13fb <sbrk>
  if(p == (char*)-1)
    1798:	83 c4 10             	add    $0x10,%esp
    179b:	83 f8 ff             	cmp    $0xffffffff,%eax
    179e:	74 1c                	je     17bc <malloc+0x8c>
  hp->s.size = nu;
    17a0:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    17a3:	83 ec 0c             	sub    $0xc,%esp
    17a6:	83 c0 08             	add    $0x8,%eax
    17a9:	50                   	push   %eax
    17aa:	e8 f1 fe ff ff       	call   16a0 <free>
  return freep;
    17af:	8b 15 60 20 00 00    	mov    0x2060,%edx
      if((p = morecore(nunits)) == 0)
    17b5:	83 c4 10             	add    $0x10,%esp
    17b8:	85 d2                	test   %edx,%edx
    17ba:	75 bc                	jne    1778 <malloc+0x48>
        return 0;
  }
}
    17bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    17bf:	31 c0                	xor    %eax,%eax
}
    17c1:	5b                   	pop    %ebx
    17c2:	5e                   	pop    %esi
    17c3:	5f                   	pop    %edi
    17c4:	5d                   	pop    %ebp
    17c5:	c3                   	ret    
    if(p->s.size >= nunits){
    17c6:	89 d0                	mov    %edx,%eax
    17c8:	89 fa                	mov    %edi,%edx
    17ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    17d0:	39 ce                	cmp    %ecx,%esi
    17d2:	74 4c                	je     1820 <malloc+0xf0>
        p->s.size -= nunits;
    17d4:	29 f1                	sub    %esi,%ecx
    17d6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    17d9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    17dc:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
    17df:	89 15 60 20 00 00    	mov    %edx,0x2060
}
    17e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    17e8:	83 c0 08             	add    $0x8,%eax
}
    17eb:	5b                   	pop    %ebx
    17ec:	5e                   	pop    %esi
    17ed:	5f                   	pop    %edi
    17ee:	5d                   	pop    %ebp
    17ef:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
    17f0:	c7 05 60 20 00 00 64 	movl   $0x2064,0x2060
    17f7:	20 00 00 
    base.s.size = 0;
    17fa:	bf 64 20 00 00       	mov    $0x2064,%edi
    base.s.ptr = freep = prevp = &base;
    17ff:	c7 05 64 20 00 00 64 	movl   $0x2064,0x2064
    1806:	20 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1809:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
    180b:	c7 05 68 20 00 00 00 	movl   $0x0,0x2068
    1812:	00 00 00 
    if(p->s.size >= nunits){
    1815:	e9 42 ff ff ff       	jmp    175c <malloc+0x2c>
    181a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    1820:	8b 08                	mov    (%eax),%ecx
    1822:	89 0a                	mov    %ecx,(%edx)
    1824:	eb b9                	jmp    17df <malloc+0xaf>
