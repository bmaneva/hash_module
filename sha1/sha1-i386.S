	.text

	.local	message_digest
	.comm	message_digest,20,4
	.local	length_low
	.comm	length_low,4,4
	.local	length_high
	.comm	length_high,4,4
	.local	message_block
	.comm	message_block,64,32
	.local	message_block_index
	.comm	message_block_index,4,4
	.section	.rodata
	.align 4
	.type	K, @object
	.size	K, 16
K:
	.long	1518500249
	.long	1859775393
	.long	-1894007588
	.long	-899497514
	.local	temp
	.comm	temp,4,4
	.local	W
	.comm	W,320,32
	.local	A
	.comm	A,4,4
	.local	B
	.comm	B,4,4
	.local	C
	.comm	C,4,4
	.local	D
	.comm	D,4,4
	.local	E
	.comm	E,4,4
	.text
	.type	set_w, @function
set_w:
	pushl	%ebp	#
	pushl	%ebx
	movl	%esp, %ebp	#,
	#.    for(t = 0; t < 16; t++)
	movl	$0, %esi	#, t
	jmp	.L2	#
.L3:
	#.        W[t] = ((unsigned)  message_block[t * 4]) << 24;
	movl	%esi, %ecx	# t, t.86
	movl	%ecx, %ebx
	sall	$2, %ecx	#, D.1454
	movzbl	message_block(%ecx), %edx	# message_block, D.1455
	sall	$24, %edx	#, D.1457
	#.        W[t] |= ((unsigned) message_block[t * 4 + 1]) << 16;
	incl	%ecx	# D.1463
	movzbl	message_block(%ecx), %eax	# message_block, D.1464
	sall	$16, %eax	#, D.1466
	orl	%eax, %edx	# D.1466, D.1467
	#.        W[t] |= ((unsigned) message_block[t * 4 + 2]) << 8;
	incl	%ecx	# t, t.92
	movzbl	message_block(%ecx), %eax	# message_block, D.1474
	sall	$8, %eax	#, D.1476
	orl	%eax, %edx	# D.1476, D.1477
	#.        W[t] |= ((unsigned) message_block[t * 4 + 3]);
	incl	%ecx	#, D.1483
	movzbl	message_block(%ecx), %eax	# message_block, D.1484
	orl	%eax, %edx	# D.1480, D.1486
	movl	%edx, W(,%ebx,4)	# D.1486, W
	#.    for(t = 0; t < 16; t++)
	incl	%esi	# t.97
.L2:
	#.    for(t = 0; t < 16; t++)
	movl	%esi, %eax	# t, t.98
	cmpl	$15, %eax	#, t.98
	jle	.L3	#,
	#.    for(t = 16; t < 80; t++)
	movl	$16, %esi	#, t
	jmp	.L4	#
.L5:
	#.       W[t] = CIRCULAR_SHIFT(1, W[t-3] ^ W[t-8] ^ W[t-14] ^ W[t-16]);
	movl	%esi, %edx	# t, t.100
	movl	W-3*4(,%edx,4), %ecx	# W, D.1493
	xorl	W-8*4(,%edx,4), %ecx	# W, D.1496
	xorl	W-14*4(,%edx,4), %ecx	# W, D.1500
	xorl	W-16*4(,%edx,4), %ecx	# W, D.1504
	roll	%ecx	# D.1506
	movl	%ecx, W(,%edx,4)	# D.1506, W
	#.    for(t = 16; t < 80; t++)
	incl	%esi	# t.105
.L4:
	#.    for(t = 16; t < 80; t++)
	movl	%esi, %eax	# t, t.106
	cmpl	$79, %eax	#, t.106
	jle	.L5	#,
	#.}
	popl	%ebx
	popl	%ebp	#
.LCFI2:
	ret
.LFE0:
	.size	set_w, .-set_w
	.type	main_loop, @function
main_loop:
.LFB1:
	#.{
	pushl	%ebp	#
.LCFI3:
	movl	%esp, %ebp	#,
.LCFI4:
	pushl	%ebx	#
	#.    for (t = 0; t < 80; ++t) {
	movl	$0, %esi	#, t
	jmp	.L7	#
.L12:
	#.        if (t < 20)
	movl	%esi, %eax	# t, t.42
	cmpl	$19, %eax	#, t.42
	jg	.L8	#,
	#.            temp =  CIRCULAR_SHIFT(5, A) +
	movl	A, %ecx	# A, A.43
	roll	$5, %ecx	#, D.1368
	#.                    ((B & C) | ((~B) & D)) + E + W[t] + K[0];
	movl	B, %edx	# B, B.44
	andl	C, %edx	# C.45, D.1371
	movl	B, %eax	# B, B.46
	notl	%eax	# D.1373
	andl	D, %eax	# D, D.47
	orl	%edx, %eax	# D.1371, D.1376
	#.            temp =  CIRCULAR_SHIFT(5, A) +
	leal	(%ecx,%eax), %edx	#, D.1377
	#.                    ((B & C) | ((~B) & D)) + E + W[t] + K[0];
	addl	E, %edx	# E.48, D.1379
	movl	%esi, %eax	# t, t.49
	addl	W(,%eax,4), %edx	# W, D.1381
	addl	K, %edx	# K, D.1383
	#.            temp =  CIRCULAR_SHIFT(5, A) +
	movl	%edx, temp	# temp.50, temp
	jmp	.L9	#
.L8:
	#.        else if (t < 40)
	movl	%esi, %eax	# t, t.51
	cmpl	$39, %eax	#, t.51
	jg	.L10	#,
	#.            temp = CIRCULAR_SHIFT(5, A) + (B ^ C ^ D) + E + W[t] + K[1];
	movl	A, %ecx	# A, A.52
	roll	$5, %ecx	#, D.1390
	movl	B, %edx	# B, B.53
	xorl	C, %edx	# C.54, D.1393
	xorl	D, %edx	# D.1393, D.1395
	leal	(%ecx,%edx), %edx	#, D.1396
	addl	E, %edx	# E.56, D.1398
	movl	%esi, %eax	# t, t.57
	addl	W(,%eax,4), %edx	# W, D.1400
	addl	K+4, %edx	# K, D.1402
	movl	%edx, temp	# temp.58, temp
	jmp	.L9	#
.L10:
	#.        else if (t < 60)
	movl	%esi, %eax	# t, t.59
	cmpl	$59, %eax	#, t.59
	jg	.L11	#,
	#.            temp = CIRCULAR_SHIFT(5, A) +
	movl	A, %eax	# A, A.60
	movl	%eax, %ecx	# A.60, D.1409
	roll	$5, %ecx	#, D.1409
	#.                    ((B & C) | (B & D) | (C & D)) + E + W[t] + K[2];
	movl	C, %edx	# C, C.61
	movl	D, %eax	# D, D.62
	orl	%eax, %edx	# D.62, D.1412
	movl	B, %eax	# B, B.63
	movl	%edx, %ebx	# D.1412, D.1414
	andl	%eax, %ebx	# B.63, D.1414
	movl	C, %edx	# C, C.64
	movl	D, %eax	# D, D.65
	andl	%edx, %eax	# C.64, D.1417
	orl	%ebx, %eax	# D.1414, D.1418
	#.            temp = CIRCULAR_SHIFT(5, A) +
	leal	(%ecx,%eax), %edx	#, D.1419
	#.                    ((B & C) | (B & D) | (C & D)) + E + W[t] + K[2];
	movl	E, %eax	# E, E.66
	addl	%eax, %edx	# E.66, D.1421
	movl	%esi, %eax	# t, t.67
	movl	W(,%eax,4), %eax	# W, D.1423
	addl	%eax, %edx	# D.1423, D.1424
	movl	K+8, %eax	# K, D.1425
	addl	%edx, %eax	# D.1424, temp.68
	#.            temp = CIRCULAR_SHIFT(5, A) +
	movl	%eax, temp	# temp.68, temp
	jmp	.L9	#
.L11:
	#.            temp = CIRCULAR_SHIFT(5, A) + (B ^ C ^ D) + E + W[t] + K[3];
	movl	A, %eax	# A, A.69
	movl	%eax, %ecx	# A.69, D.1429
	roll	$5, %ecx	#, D.1429
	movl	B, %edx	# B, B.70
	movl	C, %eax	# C, C.71
	xorl	%eax, %edx	# C.71, D.1432
	movl	D, %eax	# D, D.72
	xorl	%edx, %eax	# D.1432, D.1434
	leal	(%ecx,%eax), %edx	#, D.1435
	movl	E, %eax	# E, E.73
	addl	%eax, %edx	# E.73, D.1437
	movl	%esi, %eax	# t, t.74
	movl	W(,%eax,4), %eax	# W, D.1439
	addl	%eax, %edx	# D.1439, D.1440
	movl	K+12, %eax	# K, D.1441
	addl	%edx, %eax	# D.1440, temp.75
	movl	%eax, temp	# temp.75, temp
.L9:
	#.        E = D;
	movl	D, %eax	# D, D.76
	movl	%eax, E	# D.76, E
	#.        D = C;
	movl	C, %eax	# C, C.77
	movl	%eax, D	# C.77, D
	#.        C = CIRCULAR_SHIFT(30,B);
	movl	B, %eax	# B, B.78
	roll	$30, %eax	#, C.79
	movl	%eax, C	# C.79, C
	#.        B = A;
	movl	A, %eax	# A, A.80
	movl	%eax, B	# A.80, B
	#.        A = temp;
	movl	temp, %eax	# temp, temp.81
	movl	%eax, A	# temp.81, A
	#.    for (t = 0; t < 80; ++t) {
	movl	%esi, %eax	# t, t.82
	incl	%eax	# t.83
	movl	%eax, %esi	# t.83, t
.L7:
	#.    for (t = 0; t < 80; ++t) {
	movl	%esi, %eax	# t, t.84
	cmpl	$79, %eax	#, t.84
	jle	.L12	#,
	#.}
	popl	%ebx	#
	popl	%ebp	#
.LCFI5:
	ret
.LFE1:
	.size	main_loop, .-main_loop
	.type	process_block, @function
process_block:
.LFB2:
	#.{
	pushl	%ebp	#
.LCFI6:
	movl	%esp, %ebp	#,
.LCFI7:
	#.    set_w();
	call	set_w	#
	#.    A = message_digest[0];
	movl	message_digest, %eax	# message_digest, A.32
	movl	%eax, A	# A.32, A
	#.    B = message_digest[1];
	movl	message_digest+4, %eax	# message_digest, B.33
	movl	%eax, B	# B.33, B
	#.    C = message_digest[2];
	movl	message_digest+8, %eax	# message_digest, C.34
	movl	%eax, C	# C.34, C
	#.    D = message_digest[3];
	movl	message_digest+12, %eax	# message_digest, D.35
	movl	%eax, D	# D.35, D
	#.    E = message_digest[4];
	movl	message_digest+16, %eax	# message_digest, E.36
	movl	%eax, E	# E.36, E
	#.    main_loop();
	call	main_loop	#
	#.    message_digest[0] = (message_digest[0] + A) & 0xFFFFFFFF;
	movl	message_digest, %edx	# message_digest, D.1349
	movl	A, %eax	# A, A.37
	addl	%edx, %eax	# D.1349, D.1351
	movl	%eax, message_digest	# D.1351, message_digest
	#.    message_digest[1] = (message_digest[1] + B) & 0xFFFFFFFF;
	movl	message_digest+4, %edx	# message_digest, D.1352
	movl	B, %eax	# B, B.38
	addl	%edx, %eax	# D.1352, D.1354
	movl	%eax, message_digest+4	# D.1354, message_digest
	#.    message_digest[2] = (message_digest[2] + C) & 0xFFFFFFFF;
	movl	message_digest+8, %edx	# message_digest, D.1355
	movl	C, %eax	# C, C.39
	addl	%edx, %eax	# D.1355, D.1357
	movl	%eax, message_digest+8	# D.1357, message_digest
	#.    message_digest[3] = (message_digest[3] + D) & 0xFFFFFFFF;
	movl	message_digest+12, %edx	# message_digest, D.1358
	movl	D, %eax	# D, D.40
	addl	%edx, %eax	# D.1358, D.1360
	movl	%eax, message_digest+12	# D.1360, message_digest
	#.    message_digest[4] = (message_digest[4] + E) & 0xFFFFFFFF;
	movl	message_digest+16, %edx	# message_digest, D.1361
	movl	E, %eax	# E, E.41
	addl	%edx, %eax	# D.1361, D.1363
	movl	%eax, message_digest+16	# D.1363, message_digest
	#.    message_block_index = 0;
	movl	$0, message_block_index	#, message_block_index
	#.}
	popl	%ebp	#
.LCFI8:
	ret
.LFE2:
	.size	process_block, .-process_block
	.globl	sha1
	.type	sha1, @function
sha1:
.LFB3:
	#.void sha1(const unsigned char *data, unsigned len, unsigned *digest) {
	pushl	%ebp	#
.LCFI9:
	movl	%esp, %ebp	#,
.LCFI10:
	subl	$12, %esp	#,
	movl	%eax, -4(%ebp)	# data, data
	movl	%edx, -8(%ebp)	# len, len
	movl	%ecx, -12(%ebp)	# digest, digest
	#.    length_low             = 0;
	movl	$0, length_low	#, length_low
	#.    length_high            = 0;
	movl	$0, length_high	#, length_high
	#.    message_block_index    = 0;
	movl	$0, message_block_index	#, message_block_index
	#.    message_digest[0]      = 0x67452301;
	movl	$1732584193, message_digest	#, message_digest
	#.    message_digest[1]      = 0xEFCDAB89;
	movl	$-271733879, message_digest+4	#, message_digest
	#.    message_digest[2]      = 0x98BADCFE;
	movl	$-1732584194, message_digest+8	#, message_digest
	#.    message_digest[3]      = 0x10325476;
	movl	$271733878, message_digest+12	#, message_digest
	#.    message_digest[4]      = 0xC3D2E1F0;
	movl	$-1009589776, message_digest+16	#, message_digest
	#.    while(len--)
	jmp	.L15	#
.L18:
	#.        message_block[message_block_index++] =  (*data & 0xFF);
	movl	message_block_index, %eax	# message_block_index, message_block_index.0
	movl	-4(%ebp), %edx	# data, tmp116
	movb	(%edx), %dl	# *data_1, D.1282
	movb	%dl, message_block(%eax)	# D.1282, message_block
	incl	%eax	# message_block_index.1
	movl	%eax, message_block_index	# message_block_index.1, message_block_index
	#.        length_low += 8;
	movl	length_low, %eax	# length_low, length_low.2
	addl	$8, %eax	#, length_low.3
	movl	%eax, length_low	# length_low.3, length_low
	#.        length_low &= 0xFFFFFFFF;
	movl	length_low, %eax	# length_low, length_low.4
	movl	%eax, length_low	# length_low.4, length_low
	#.        if (length_low == 0)
	movl	length_low, %eax	# length_low, length_low.5
	testl	%eax, %eax	# length_low.5
	jne	.L16	#,
	#.            length_high++;
	movl	length_high, %eax	# length_high, length_high.6
	incl	%eax	# length_high.7
	movl	%eax, length_high	# length_high.7, length_high
	#.            length_high &= 0xFFFFFFFF;
	movl	length_high, %eax	# length_high, length_high.8
	movl	%eax, length_high	# length_high.8, length_high
.L16:
	#.        if (message_block_index == 64)
	movl	message_block_index, %eax	# message_block_index, message_block_index.9
	cmpl	$64, %eax	#, message_block_index.9
	jne	.L17	#,
	#.            process_block();
	call	process_block	#
.L17:
	#.        data++;
	incl	-4(%ebp)	# data
.L15:
	#.    while(len--)
	cmpl	$0, -8(%ebp)	#, len
	setne	%al	#, D.1295
	decl	-8(%ebp)	# len
	testb	%al, %al	# D.1295
	jne	.L18	#,
	#.    if (message_block_index > 55)
	movl	message_block_index, %eax	# message_block_index, message_block_index.10
	cmpl	$55, %eax	#, message_block_index.10
	jle	.L19	#,
	#.        message_block[message_block_index++] = 0x80;
	movl	message_block_index, %eax	# message_block_index, message_block_index.11
	movb	$-128, message_block(%eax)	#, message_block
	incl	%eax	# message_block_index.12
	movl	%eax, message_block_index	# message_block_index.12, message_block_index
	#.        while(message_block_index < 64)
	jmp	.L20	#
.L21:
	#.            message_block[message_block_index++] = 0;
	movl	message_block_index, %eax	# message_block_index, message_block_index.13
	movb	$0, message_block(%eax)	#, message_block
	incl	%eax	# message_block_index.14
	movl	%eax, message_block_index	# message_block_index.14, message_block_index
.L20:
	#.        while(message_block_index < 64)
	movl	message_block_index, %eax	# message_block_index, message_block_index.15
	cmpl	$63, %eax	#, message_block_index.15
	jle	.L21	#,
	#.        process_block();
	call	process_block	#
	#.        while(message_block_index < 56)
	jmp	.L22	#
.L23:
	#.            message_block[message_block_index++] = 0;
	movl	message_block_index, %eax	# message_block_index, message_block_index.16
	movb	$0, message_block(%eax)	#, message_block
	incl	%eax	# message_block_index.17
	movl	%eax, message_block_index	# message_block_index.17, message_block_index
.L22:
	#.        while(message_block_index < 56)
	movl	message_block_index, %eax	# message_block_index, message_block_index.18
	cmpl	$55, %eax	#, message_block_index.18
	jle	.L23	#,
	#.        while(message_block_index < 56)
	jmp	.L24	#
.L19:
	#.        message_block[message_block_index++] = 0x80;
	movl	message_block_index, %eax	# message_block_index, message_block_index.19
	movb	$-128, message_block(%eax)	#, message_block
	incl	%eax	# message_block_index.20
	movl	%eax, message_block_index	# message_block_index.20, message_block_index
	#.        while(message_block_index < 56)
	jmp	.L25	#
.L26:
	#.            message_block[message_block_index++] = 0;
	movl	message_block_index, %eax	# message_block_index, message_block_index.21
	movb	$0, message_block(%eax)	#, message_block
	incl	%eax	# message_block_index.22
	movl	%eax, message_block_index	# message_block_index.22, message_block_index
.L25:
	#.        while(message_block_index < 56)
	movl	message_block_index, %eax	# message_block_index, message_block_index.23
	cmpl	$55, %eax	#, message_block_index.23
	jle	.L26	#,
.L24:
	#.    message_block[56] = (length_high >> 24) & 0xFF;
	movl	length_high, %eax	# length_high, length_high.24
	shrl	$24, %eax	#, D.1314
	movb	%al, message_block+56	# D.1315, message_block
	#.    message_block[57] = (length_high >> 16) & 0xFF;
	movl	length_high, %eax	# length_high, length_high.25
	shrl	$16, %eax	#, D.1317
	movb	%al, message_block+57	# D.1318, message_block
	#.    message_block[58] = (length_high >> 8) & 0xFF;
	movl	length_high, %eax	# length_high, length_high.26
	shrl	$8, %eax	#, D.1320
	movb	%al, message_block+58	# D.1321, message_block
	#.    message_block[59] = (length_high) & 0xFF;
	movl	length_high, %eax	# length_high, length_high.27
	movb	%al, message_block+59	# D.1323, message_block
	#.    message_block[60] = (length_low >> 24) & 0xFF;
	movl	length_low, %eax	# length_low, length_low.28
	shrl	$24, %eax	#, D.1325
	movb	%al, message_block+60	# D.1326, message_block
	#.    message_block[61] = (length_low >> 16) & 0xFF;
	movl	length_low, %eax	# length_low, length_low.29
	shrl	$16, %eax	#, D.1328
	movb	%al, message_block+61	# D.1329, message_block
	#.    message_block[62] = (length_low >> 8) & 0xFF;
	movl	length_low, %eax	# length_low, length_low.30
	shrl	$8, %eax	#, D.1331
	movb	%al, message_block+62	# D.1332, message_block
	#.    message_block[63] = (length_low) & 0xFF;
	movl	length_low, %eax	# length_low, length_low.31
	movb	%al, message_block+63	# D.1334, message_block
	#.    process_block();
	call	process_block	#
	#.    digest[0] = message_digest[0];
	movl	message_digest, %edx	# message_digest, D.1335
	movl	-12(%ebp), %eax	# digest, tmp117
	movl	%edx, (%eax)	# D.1335, *digest_56(D)
	#.    digest[1] = message_digest[1];
	movl	-12(%ebp), %eax	# digest, tmp118
	leal	4(%eax), %edx	#, D.1336
	movl	message_digest+4, %eax	# message_digest, D.1337
	movl	%eax, (%edx)	# D.1337, *D.1336_57
	#.    digest[2] = message_digest[2];
	movl	-12(%ebp), %eax	# digest, tmp119
	leal	8(%eax), %edx	#, D.1338
	movl	message_digest+8, %eax	# message_digest, D.1339
	movl	%eax, (%edx)	# D.1339, *D.1338_59
	#.    digest[3] = message_digest[3];
	movl	-12(%ebp), %eax	# digest, tmp120
	leal	12(%eax), %edx	#, D.1340
	movl	message_digest+12, %eax	# message_digest, D.1341
	movl	%eax, (%edx)	# D.1341, *D.1340_61
	#.    digest[4] = message_digest[4];
	movl	-12(%ebp), %eax	# digest, tmp121
	leal	16(%eax), %edx	#, D.1342
	movl	message_digest+16, %eax	# message_digest, D.1343
	movl	%eax, (%edx)	# D.1343, *D.1342_63
	#.}
	leave
.LCFI11:
	ret
.LFE3:
	.size	sha1, .-sha1
