	.text

	.section	.rodata
	.align 32
	.type	k, @object
	.size	k, 256
k:
	.long	-680876936
	.long	-389564586
	.long	606105819
	.long	-1044525330
	.long	-176418897
	.long	1200080426
	.long	-1473231341
	.long	-45705983
	.long	1770035416
	.long	-1958414417
	.long	-42063
	.long	-1990404162
	.long	1804603682
	.long	-40341101
	.long	-1502002290
	.long	1236535329
	.long	-165796510
	.long	-1069501632
	.long	643717713
	.long	-373897302
	.long	-701558691
	.long	38016083
	.long	-660478335
	.long	-405537848
	.long	568446438
	.long	-1019803690
	.long	-187363961
	.long	1163531501
	.long	-1444681467
	.long	-51403784
	.long	1735328473
	.long	-1926607734
	.long	-378558
	.long	-2022574463
	.long	1839030562
	.long	-35309556
	.long	-1530992060
	.long	1272893353
	.long	-155497632
	.long	-1094730640
	.long	681279174
	.long	-358537222
	.long	-722521979
	.long	76029189
	.long	-640364487
	.long	-421815835
	.long	530742520
	.long	-995338651
	.long	-198630844
	.long	1126891415
	.long	-1416354905
	.long	-57434055
	.long	1700485571
	.long	-1894986606
	.long	-1051523
	.long	-2054922799
	.long	1873313359
	.long	-30611744
	.long	-1560198380
	.long	1309151649
	.long	-145523070
	.long	-1120210379
	.long	718787259
	.long	-343485551
	.align 32
	.type	r, @object
	.size	r, 256
r:
	.long	7
	.long	12
	.long	17
	.long	22
	.long	7
	.long	12
	.long	17
	.long	22
	.long	7
	.long	12
	.long	17
	.long	22
	.long	7
	.long	12
	.long	17
	.long	22
	.long	5
	.long	9
	.long	14
	.long	20
	.long	5
	.long	9
	.long	14
	.long	20
	.long	5
	.long	9
	.long	14
	.long	20
	.long	5
	.long	9
	.long	14
	.long	20
	.long	4
	.long	11
	.long	16
	.long	23
	.long	4
	.long	11
	.long	16
	.long	23
	.long	4
	.long	11
	.long	16
	.long	23
	.long	4
	.long	11
	.long	16
	.long	23
	.long	6
	.long	10
	.long	15
	.long	21
	.long	6
	.long	10
	.long	15
	.long	21
	.long	6
	.long	10
	.long	15
	.long	21
	.long	6
	.long	10
	.long	15
	.long	21
	.local	msg
	.comm	msg,512,32

	.data
	.align 4
	.type	h0, @object
	.size	h0, 4
h0:
	.long	1732584193
	.align 4
	.type	h1, @object
	.size	h1, 4
h1:
	.long	-271733879
	.align 4
	.type	h2, @object
	.size	h2, 4
h2:
	.long	-1732584194
	.align 4
	.type	h3, @object
	.size	h3, 4
h3:
	.long	271733878
	.local	new_len
	.comm	new_len,4,4
	.local	offset
	.comm	offset,4,4
	.local	w
	.comm	w,64,32
	.local	a
	.comm	a,4,4
	.local	b
	.comm	b,4,4
	.local	c
	.comm	c,4,4
	.local	d
	.comm	d,4,4
	.local	f
	.comm	f,4,4
	.local	g
	.comm	g,4,4
	.local	temp
	.comm	temp,4,4

	.text
	.type	to_bytes, @function
to_bytes:
	movl	%eax, (%edx)	# tmp60, MEM[(uint32_t *)bytes_1(D)]
	ret

	.type	to_int32, @function
to_int32:
	movl	(%eax), %eax	# MEM[(uint32_t *)bytes_1(D)], D.2560
	ret

	.type	main_loop, @function
main_loop:
	#.        a = h0;
	movl	h0, %eax	# h0, h0.31
	movl	%eax, a	# h0.31, a
	#.        b = h1;
	movl	h1, %eax	# h1, h1.32
	movl	%eax, b	# h1.32, b
	#.        c = h2;
	movl	h2, %eax	# h2, h2.33
	movl	%eax, c	# h2.33, c
	#.        d = h3;
	movl	h3, %eax	# h3, h3.34
	movl	%eax, d	# h3.34, d
	#.        for (i = 0; i < 64; i++) {
	movl	$0, %esi	#, i
	jmp	.L4	#
.L9:
	#.            if (i < 16) {
	movl	%esi, %eax	# i, i.35
	cmpl	$15, %eax	#, i.35
	ja	.L5	#,
	#.                f = (b & c) | ((~b) & d);
	movl	b, %edx	# b, b.36
	andl	c, %edx	# c.37, D.2481
	movl	b, %ecx	# b, b.38
	notl	%ecx	# D.2483
	andl	d, %ecx	# D.2483, D.2485
	orl	%edx, %ecx	# D.2481, f.40
	movl	%ecx, f	# f.40, f
	#.                g = i;
	movl	%eax, g	# i.41, g
	jmp	.L6	#
.L5:
	#.            } else if (i < 32) {
	movl	%esi, %eax	# i, i.42
	cmpl	$31, %eax	#, i.42
	ja	.L7	#,
	#.                f = (d & b) | ((~d) & c);
	movl	d, %edx	# d, d.43
	andl	b, %edx	# b.44, D.2494
	movl	d, %ecx	# d, d.45
	notl	%ecx	# D.2496
	andl	c, %ecx	# D.2496, D.2498
	orl	%edx, %ecx	# D.2494, f.47
	movl	%ecx, f	# f.47, f
	#.                g = (5 * i + 1) % 16;
	movl	%eax, %edx	# i, i.48
	sall	$2, %eax	#, tmp138
	addl	%edx, %eax	# i.48, D.2501
	incl	%eax	# D.2502
	andl	$15, %eax	#, g.49
	movl	%eax, g	# g.49, g
	jmp	.L6	#
.L7:
	#.            } else if (i < 48) {
	movl	%esi, %eax	# i, i.50
	cmpl	$47, %eax	#, i.50
	ja	.L8	#,
	#.                f = b ^ c ^ d;
	movl	b, %edx	# b, b.51
	xorl	c, %edx	# c.52, D.2510
	xorl	d, %edx	# D.2510, f.54
	movl	%edx, f	# f.54, f
	#.                g = (3 * i + 5) % 16;
	movl	%eax, %edx	# i, i.55
	sall	%eax	# tmp139
	addl	%edx, %eax	# i.55, D.2514
	addl	$5, %eax	#, D.2515
	andl	$15, %eax	#, g.56
	movl	%eax, g	# g.56, g
	jmp	.L6	#
.L8:
	#.                f = c ^ (b | (~d));
	movl	d, %eax	# d, d.57
	notl	%eax	# D.2519
	orl	b, %eax	# b.58, D.2521
	xorl	c, %eax	# D.2521, f.60
	movl	%eax, f	# f.60, f
	#.                g = (7 * i) % 16;
	movl	%esi, %edx
	movl	%edx, %eax	# i.61, tmp140
	sall	$3, %eax	#, tmp141
	subl	%edx, %eax	# i.61, D.2525
	andl	$15, %eax	#, g.62
	movl	%eax, g	# g.62, g
.L6:
	#.            temp = d;
	movl	d, %eax	# d, d.63
	movl	%eax, temp	# d.63, temp
	#.            d = c;
	movl	c, %eax	# c, c.64
	movl	%eax, d	# c.64, d
	#.            c = b;
	movl	b, %eax	# b, b.65
	movl	%eax, c	# b.65, c
	#.            b = b + LEFTROTATE((a + f + k[i] + w[g]), r[i]);
	movl	a, %edx	# a, a.66
	addl	f, %edx	# f.67, D.2532
	movl	%esi, %eax	# i, i.68
	addl	k(,%eax,4), %edx	# k, D.2534
	movl	g, %eax	# g, g.69
	addl	w(,%eax,4), %edx	# w, D.2537
	movl	%esi, %eax	# i, i.70
	movl	r(,%eax,4), %ecx	# r, D.2540
	roll	%cl, %edx	#, D.2541
	addl	b, %edx	# D.2541, b.72
	movl	%edx, b	# b.72, b
	#.            a = temp;
	movl	temp, %eax	# temp, temp.73
	movl	%eax, a	# temp.73, a
	#.        for (i = 0; i < 64; i++) {
	incl	%esi	# i.75
.L4:
	#.        for (i = 0; i < 64; i++) {
	movl	%esi, %eax	# i, i.76
	cmpl	$63, %eax	#, i.76
	jbe	.L9	#,
	#.        h0 += a;
	movl	h0, %edx	# h0, h0.77
	addl	a, %edx	# h0.77, h0.79
	movl	%edx, h0	# h0.79, h0
	#.        h1 += b;
	movl	h1, %edx	# h1, h1.80
	addl	b, %edx	# h1.80, h1.82
	movl	%edx, h1	# h1.82, h1
	#.        h2 += c;
	movl	h2, %edx	# h2, h2.83
	addl	c, %edx	# h2.83, h2.85
	movl	%edx, h2	# h2.85, h2
	#.        h3 += d;
	movl	h3, %edx	# h3, h3.86
	addl	d, %edx	# h3.86, h3.88
	movl	%edx, h3	# h3.88, h3

	ret

	.globl	md5
	.type	md5, @function
md5:
	pushl	%ebp	#
	pushl	%esi	#

	movl	%esp, %ebp	#,
	pushl	%ebx	#
	subl	$12, %esp	#,
	movl	%eax, -8(%ebp)	# initial_msg, initial_msg
	movl	%edx, -12(%ebp)	# initial_len, initial_len
	movl	%ecx, -16(%ebp)	# digest, digest
	#.    for (new_len = initial_len + 1; new_len % (512 / 8) != 448 / 8; new_len++) ;
	movl	-12(%ebp), %eax	# initial_len, tmp106
	incl	%eax	# new_len.0
	movl	%eax, new_len	# new_len.0, new_len
	jmp	.L11	#
.L12:
	#.    for (new_len = initial_len + 1; new_len % (512 / 8) != 448 / 8; new_len++) ;
	incl	new_len	# new_len, new_len.1
.L11:
	#.    for (new_len = initial_len + 1; new_len % (512 / 8) != 448 / 8; new_len++) ;
	movl	new_len, %eax	# new_len, new_len.3
	andl	$63, %eax	#, D.2429
	cmpl	$56, %eax	#, D.2429
	jne	.L12	#,

	#.    for (i = 0; i < initial_len; ++i)
	movl	$0, %esi	#, i
	jmp	.L13	#
.L14:
	#.        msg[i] = initial_msg[i];
	movl	%esi, %eax	# i, i.4
	movl	%esi, %edx	# i, i.5
	addl	-8(%ebp), %edx	# initial_msg, D.2432
	movb	(%edx), %dl	# *D.2432_11, D.2433
	movb	%dl, msg(%eax)	# D.2434, msg
	#.    for (i = 0; i < initial_len; ++i)
	incl	%esi	# i.7
.L13:
	#.    for (i = 0; i < initial_len; ++i)
	movl	%esi, %eax	# i, i.8
	cmpl	-12(%ebp), %eax	# initial_len, i.8
	jb	.L14	#,

	#.    msg[initial_len] = 0x80;
	addl	$msg, %eax	#, tmp107
	movb	$-128, (%eax)	#, msg

	#.    for (offset = initial_len + 1; offset < new_len; offset++)
	movl	-12(%ebp), %eax	# initial_len, tmp109
	incl	%eax	# offset.9
	movl	%eax, offset	# offset.9, offset
	jmp	.L15	#
.L16:
	#.        msg[offset] = 0;
	movl	offset, %eax	# offset, offset.10
	movb	$0, msg(%eax)	#, msg
	#.    for (offset = initial_len + 1; offset < new_len; offset++)
	incl	offset	# offset.12
.L15:
	#.    for (offset = initial_len + 1; offset < new_len; offset++)
	movl	offset, %edx	# offset, offset.13
	cmpl	new_len, %edx	# new_len.14, offset.13
	jb	.L16	#,

	#.    to_bytes(initial_len * 8, msg + new_len);
	movl	new_len, %eax	# new_len, new_len.15
	leal	msg(%eax), %edx	#, D.2445
	movl	-12(%ebp), %eax	# initial_len, tmp110
	sall	$3, %eax	#, D.2446
	call	to_bytes	#
	#.    to_bytes(initial_len >> 29, msg + new_len + 4);
	addl	$4, %edx	#, D.2448
	movl	-12(%ebp), %eax	# initial_len, tmp111
	shrl	$29, %eax	#, D.2450
	call	to_bytes	#
	#.    for (offset = 0; offset < new_len; offset += (512 / 8)) {
	movl	$0, offset	#, offset
	jmp	.L17	#
.L20:
	#.        for (i = 0; i < 16; i++)
	movl	$0, %esi	#, i
	jmp	.L18	#
.L19:
	#.            w[i] = to_int32(msg + offset + i * 4);
	movl	%esi, %ebx	# i, i.17
	movl	%esi, %eax	# i, i.18
	leal	0(,%eax,4), %edx	#, D.2453
	movl	offset, %eax	# offset, offset.19
	addl	%edx, %eax	# D.2453, D.2455
	addl	$msg, %eax	#, D.2456
	call	to_int32	#
	movl	%eax, w(,%ebx,4)	# D.2457, w
	#.        for (i = 0; i < 16; i++)
	incl	%esi	# i.21
.L18:
	#.        for (i = 0; i < 16; i++)
	movl	%esi, %eax	# i, i.22
	cmpl	$15, %eax	#, i.22
	jbe	.L19	#,
	#.	main_loop();
	call	main_loop	#
	#.    for (offset = 0; offset < new_len; offset += (512 / 8)) {
	addl	$64, offset	#, offset.24
.L17:
	#.    for (offset = 0; offset < new_len; offset += (512 / 8)) {
	movl	offset, %edx	# offset, offset.25
	cmpl	new_len, %edx	# new_len.26, offset.25
	jb	.L20	#,

	#.    to_bytes(h0, digest);
	movl	h0, %eax	# h0, h0.27
	movl	-16(%ebp), %edx	# digest, tmp112
	call	to_bytes	#
	#.    to_bytes(h1, digest + 4);
	addl	$4, %edx	#, D.2466
	movl	h1, %eax	# h1, h1.28
	call	to_bytes	#
	#.    to_bytes(h2, digest + 8);
	addl	$4, %edx	#, D.2466
	movl	h2, %eax	# h2, h2.29
	call	to_bytes	#
	#.    to_bytes(h3, digest + 12);
	addl	$4, %edx	#, D.2466
	movl	h3, %eax	# h3, h3.30
	call	to_bytes	#
	#.}
	addl	$12, %esp	#,
	popl	%ebx	#
	popl	%esi	#
	popl	%ebp	#

	ret
