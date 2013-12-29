	.file	"xor.c"

	.text
.Ltext0:
	.section	.rodata
	.type	ar, @object
	.size	ar, 16
ar:
	.byte	31
	.byte	-81
	.byte	85
	.byte	75
	.byte	-11
	.byte	-86
	.byte	17
	.byte	119
	.byte	0
	.byte	-1
	.byte	90
	.byte	73
	.byte	-127
	.byte	-103
	.byte	16
	.byte	-35
	.text
	.globl	xor
	.type	xor, @function
xor:
.LFB0:
	.file 1 "../xor/xor.c"
	#.{
	pushl	%ebp	#
	movl	%esp, %ebp	#,
	subl	$24, %esp	#,
	movl	%eax, -20(%ebp)	# data, data
	movl	%edx, -24(%ebp)	# len, len
	#.    unsigned int hash = (unsigned int)-1;
	movl	$-1, -12(%ebp)	#, hash
	#.    unsigned char xor = 0xF0;
	movb	$-16, -13(%ebp)	#, xor
	#.    unsigned int i = 0;
	movl	$0, -8(%ebp)	#, i
	#.    unsigned int shiftpos = 8;
	movl	$8, -4(%ebp)	#, shiftpos
	#.    while (len) {
	jmp	.L2	#
.L4:
	#.        len--;
	decl	-24(%ebp)	# len
	#.        xor += (data[len] ^ ar[i]);
	movl	-24(%ebp), %eax	# len, tmp69
	movl	-20(%ebp), %edx	# data, tmp70
	addl	%edx, %eax	# tmp70, D.1393
	movb	(%eax), %dl	# *_14, D.1394
	movl	-8(%ebp), %eax	# i, tmp72
	addl	$ar, %eax	#, tmp71
	movb	(%eax), %al	# ar, D.1394
	xorl	%edx, %eax	# D.1394, D.1395
	addb	%al, -13(%ebp)	# D.1396, xor
	#.        hash ^= ((unsigned int)(xor) << shiftpos);
	movzbl	-13(%ebp), %edx	# xor, D.1397
	movl	-4(%ebp), %eax	# shiftpos, shiftpos.0
	movb	%al, %cl	# shiftpos.0, tmp75
	sall	%cl, %edx	# tmp75, D.1397
	movl	%edx, %eax	# D.1397, D.1397
	xorl	%eax, -12(%ebp)	# D.1397, hash
	#.        ++i;
	incl	-8(%ebp)	# i
	#.        if (i == sizeof(ar))
	cmpl	$16, -8(%ebp)	#, i
	jne	.L3	#,
	#.            i = 0;
	movl	$0, -8(%ebp)	#, i
.L3:
	#.        shiftpos += 8;
	addl	$8, -4(%ebp)	#, shiftpos
	#.        if (shiftpos == 8 * sizeof(hash))
	cmpl	$32, -4(%ebp)	#, shiftpos
	jne	.L2	#,
	#.            shiftpos = 8;
	movl	$8, -4(%ebp)	#, shiftpos
.L2:
	#.    while (len) {
	cmpl	$0, -24(%ebp)	#, len
	jne	.L4	#,
	#.    return hash;
	movl	-12(%ebp), %eax	# hash, D.1397
	#.}
	leave
	ret
.LFE0:
	.size	xor, .-xor
