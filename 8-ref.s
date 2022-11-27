	.file	"8.c"
	.text
	.globl	f
	.type	f, @function
f:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movsd	%xmm0, %xmm3		#double a
	movsd	%xmm1, %xmm4	#double b
	movsd	%xmm2, %xmm5	#double x
	movsd	%xmm5, %xmm0	#take x
	mulsd	%xmm5, %xmm0	#x*x
	mulsd	%xmm5, %xmm0	#x*x*x
	mulsd	%xmm5, %xmm0	#x*x*x*x
	movsd	%xmm4, %xmm1	#take b
	divsd	%xmm0, %xmm1		#b / x(4)
	movapd	%xmm1, %xmm0	
	addsd	%xmm3, %xmm0		#a + b / x(4)
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	f, .-f
	.globl	S
	.type	S, @function
S:
.LFB6:
	.cfi_startproc
	pushq	%rbp			
	pushq	%r12			#r12 = A
	pushq	%r13			#r13 = B
	pushq	%r14			#r14 = n
	pushq	%r15			#r15 = i
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movsd	%xmm0, %xmm6		#a
	movsd	%xmm1, %xmm7		#b
	movq	%rdi, %r12		#A
	movq	%rsi, %r13		#B
	movq	$1000000000, %r14	#n
	movq	%r13, %rax			
	subq	%r12, %rax			# B - A
	cvtsi2ss	%eax, %xmm0		#convert to float
	cvtsi2ss	%r14, %xmm1	#n
	divss	%xmm1, %xmm0			
	cvtss2sd	%xmm0, %xmm0
	movsd	%xmm0, %xmm8			#h
	pxor	%xmm0, %xmm0
	movsd	%xmm0, %xmm9		#sum
	cvtsi2sd	%r12, %xmm1	# d
	movsd	%xmm8, %xmm0
	movsd	.LC1(%rip), %xmm2
	divsd	%xmm2, %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, %xmm10
	movq	$0, %r15
	jmp	.L4
.L5:
	movsd	%xmm10, %xmm1
	movsd	%xmm7, %xmm0
	movq	%xmm6, %rax
	movapd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	movq	%rax, %xmm11
	movsd	%xmm11, %xmm0
	call	f
	movapd	%xmm0, %xmm1
	movsd	%xmm9, %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, %xmm9
	movsd	%xmm10, %xmm0
	addsd	%xmm8, %xmm0
	movsd	%xmm0, %xmm10
	addq	$1, %r15
.L4:
	movq	%r14, %rax
	subl	$1, %eax
	cmpq	%rax, %r15
	jl	.L5
	movsd	%xmm8, %xmm0
	mulsd	%xmm9, %xmm0	#return h * sum
	movq	%rbp, %rsp
	popq	%r15
	popq	%r14
	popq	%r13
	popq	%r12
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	S, .-S
	.section	.rodata
	.align 8
.LC2:
	.string	"Incrorrect input, check README.md"
.LC3:
	.string	"-r"
.LC4:
	.string	"w"
.LC5:
	.string	"incorrect file"
	.align 8
.LC6:
	.string	"random numbers: a = %lf, b = %lf, A = %d, B = %d\n"
.LC8:
	.string	"root: %lf\ntime: %.6lf\n"
.LC9:
	.string	"-h"
.LC10:
	.string	"\n-h help"
	.align 8
.LC11:
	.string	"-r create random numbers (a, b, A, B)"
	.align 8
.LC12:
	.string	"-f use numbers from first file and save result in second file"
	.align 8
.LC13:
	.string	"-s take numbers from terminal and print result in file"
.LC14:
	.string	"-f"
.LC15:
	.string	"r"
.LC16:
	.string	"%lf"
.LC17:
	.string	"%d"
.LC18:
	.string	"integral = %lf\ntime: %.6lf\n"
.LC19:
	.string	"-s"
	.text
	.globl	main
	.type	main, @function
main:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$160, %rsp
	movl	%edi, -132(%rbp)		#argc
	movq	%rsi, -144(%rbp)		#argv
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	cmpl	$2, -132(%rbp)
	je	.L8
	cmpl	$4, -132(%rbp)
	je	.L8
	cmpl	$3, -132(%rbp)
	je	.L8
	leaq	.LC2(%rip), %rdi
	call	puts@PLT
	movl	$0, %eax
	jmp	.L9
.L8:
	movq	-144(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	leaq	.LC3(%rip), %rsi
	movq	%rax, %rdi
	call	strcmp@PLT			#correct input?
	testl	%eax, %eax
	jne	.L10
	cmpl	$3, -132(%rbp)
	je	.L11
	leaq	.LC2(%rip), %rdi
	call	puts@PLT
	movl	$0, %eax
	jmp	.L9
.L11:
	movl	$0, %edi
	call	time@PLT
	movl	%eax, %edi
	call	srand@PLT
	movq	-144(%rbp), %rax		
	addq	$16, %rax
	movq	(%rax), %rax
	leaq	.LC4(%rip), %rsi
	movq	%rax, %rdi
	call	fopen@PLT
	movq	%rax, -40(%rbp)
	cmpq	$0, -40(%rbp)
	jne	.L12
	leaq	.LC5(%rip), %rdi
	call	puts@PLT
	movl	$0, %eax
	jmp	.L9
.L12:
	call	rand@PLT
	movl	%eax, %ecx			#a
	movl	$1717986919, %edx
	movl	%ecx, %eax
	imull	%edx
	sarl	$2, %edx
	movl	%ecx, %eax
	sarl	$31, %eax
	subl	%eax, %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	subl	%eax, %ecx
	movl	%ecx, %edx
	cvtsi2sd	%edx, %xmm0
	movsd	%xmm0, -32(%rbp)
	call	rand@PLT
	movl	%eax, %ecx			#b
	movl	$-2004318071, %edx
	movl	%ecx, %eax
	imull	%edx
	leal	(%rdx,%rcx), %eax
	sarl	$3, %eax
	movl	%eax, %edx
	movl	%ecx, %eax
	sarl	$31, %eax
	subl	%eax, %edx
	movl	%edx, %eax
	sall	$4, %eax
	subl	%edx, %eax
	subl	%eax, %ecx
	movl	%ecx, %edx
	cvtsi2sd	%edx, %xmm0
	movsd	%xmm0, -24(%rbp)
	call	rand@PLT
	movl	%eax, %ecx			#A
	movl	$-2004318071, %edx
	movl	%ecx, %eax
	imull	%edx
	leal	(%rdx,%rcx), %eax
	sarl	$3, %eax
	movl	%eax, %edx
	movl	%ecx, %eax
	sarl	$31, %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, %edx
	sall	$4, %edx
	subl	%eax, %edx
	movl	%ecx, %eax
	subl	%edx, %eax
	addl	$2, %eax
	movl	%eax, -120(%rbp)
	call	rand@PLT
	movl	%eax, %ecx			#B
	movl	$-2004318071, %edx
	movl	%ecx, %eax
	imull	%edx
	leal	(%rdx,%rcx), %eax
	sarl	$3, %eax
	movl	%eax, %edx
	movl	%ecx, %eax
	sarl	$31, %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, %edx
	sall	$4, %edx
	subl	%eax, %edx
	movl	%ecx, %eax
	subl	%edx, %eax
	addl	$17, %eax
	movl	%eax, -116(%rbp)
	movl	-116(%rbp), %ecx
	movl	-120(%rbp), %edx
	movsd	-24(%rbp), %xmm0
	movq	-32(%rbp), %rsi
	movq	-40(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rsi, -152(%rbp)
	movsd	-152(%rbp), %xmm0
	leaq	.LC6(%rip), %rsi
	movq	%rax, %rdi
	movl	$2, %eax
	call	fprintf@PLT			#print random 
	call	clock@PLT
	movq	%rax, -88(%rbp)			#s
	movl	-116(%rbp), %ecx		#a to S
	movl	-120(%rbp), %edx		#b to S
	movsd	-24(%rbp), %xmm0		#A to S
	movq	-32(%rbp), %rax			#B to S
	movl	%ecx, %esi
	movl	%edx, %edi
	movapd	%xmm0, %xmm1
	movq	%rax, -152(%rbp)
	movsd	-152(%rbp), %xmm0
	call	S
	movq	%xmm0, %rax			#save result S (s)
	movq	%rax, -16(%rbp)
	call	clock@PLT
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	subq	-88(%rbp), %rax
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC7(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movq	-16(%rbp), %rdx
	movq	-40(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rdx, -152(%rbp)
	movsd	-152(%rbp), %xmm0
	leaq	.LC8(%rip), %rsi
	movq	%rax, %rdi
	movl	$2, %eax
	call	fprintf@PLT
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	fclose@PLT
	jmp	.L13
.L10:
	movq	-144(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	leaq	.LC9(%rip), %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L14
	leaq	.LC10(%rip), %rdi
	call	puts@PLT
	leaq	.LC11(%rip), %rdi
	call	puts@PLT
	leaq	.LC12(%rip), %rdi
	call	puts@PLT
	leaq	.LC13(%rip), %rdi
	call	puts@PLT
	jmp	.L13
.L14:
	movq	-144(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	leaq	.LC14(%rip), %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L15
	cmpl	$4, -132(%rbp)
	je	.L16
	leaq	.LC2(%rip), %rdi
	call	puts@PLT
	movl	$0, %eax
	jmp	.L9
.L16:
	movq	-144(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rax
	leaq	.LC15(%rip), %rsi
	movq	%rax, %rdi
	call	fopen@PLT
	movq	%rax, -64(%rbp)
	movq	-144(%rbp), %rax
	addq	$24, %rax
	movq	(%rax), %rax
	leaq	.LC4(%rip), %rsi
	movq	%rax, %rdi
	call	fopen@PLT
	movq	%rax, -56(%rbp)
	cmpq	$0, -64(%rbp)
	je	.L18
	cmpq	$0, -56(%rbp)
	jne	.L19
.L18:
	leaq	.LC5(%rip), %rdi
	call	puts@PLT
	movl	$0, %eax
	jmp	.L9
.L19:
	leaq	-112(%rbp), %rdx
	movq	-64(%rbp), %rax
	leaq	.LC16(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_fscanf@PLT
	leaq	-104(%rbp), %rdx		#a
	movq	-64(%rbp), %rax
	leaq	.LC16(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_fscanf@PLT
	leaq	-128(%rbp), %rdx		#b
	movq	-64(%rbp), %rax
	leaq	.LC17(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_fscanf@PLT
	leaq	-124(%rbp), %rdx		#A
	movq	-64(%rbp), %rax
	leaq	.LC17(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_fscanf@PLT
	call	clock@PLT
	movq	%rax, -88(%rbp)			#B
	movl	-124(%rbp), %ecx		#a to S
	movl	-128(%rbp), %edx		#b to S
	movsd	-104(%rbp), %xmm0		#A to S
	movq	-112(%rbp), %rax		#B to S
	movl	%ecx, %esi
	movl	%edx, %edi
	movapd	%xmm0, %xmm1
	movq	%rax, -152(%rbp)
	movsd	-152(%rbp), %xmm0
	call	S
	movq	%xmm0, %rax			#s from S
	movq	%rax, -48(%rbp)
	call	clock@PLT
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	subq	-88(%rbp), %rax
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC7(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movq	-48(%rbp), %rdx
	movq	-56(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rdx, -152(%rbp)
	movsd	-152(%rbp), %xmm0
	leaq	.LC18(%rip), %rsi
	movq	%rax, %rdi
	movl	$2, %eax
	call	fprintf@PLT
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	fclose@PLT
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	fclose@PLT
	jmp	.L13
.L15:
	movq	-144(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	leaq	.LC19(%rip), %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L13
	cmpl	$3, -132(%rbp)
	je	.L20
	leaq	.LC2(%rip), %rdi
	call	puts@PLT
	movl	$0, %eax
	jmp	.L9
.L20:
	movq	-144(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rax
	leaq	.LC4(%rip), %rsi
	movq	%rax, %rdi
	call	fopen@PLT
	movq	%rax, -96(%rbp)
	cmpq	$0, -96(%rbp)
	jne	.L22
	leaq	.LC5(%rip), %rdi
	call	puts@PLT
	movl	$0, %eax
	jmp	.L9
.L22:
	leaq	-112(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC16(%rip), %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	leaq	-104(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC16(%rip), %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	leaq	-128(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC17(%rip), %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	leaq	-124(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC17(%rip), %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	call	clock@PLT
	movq	%rax, -88(%rbp)
	movl	-124(%rbp), %ecx
	movl	-128(%rbp), %edx
	movsd	-104(%rbp), %xmm0
	movq	-112(%rbp), %rax
	movl	%ecx, %esi
	movl	%edx, %edi
	movapd	%xmm0, %xmm1
	movq	%rax, -152(%rbp)
	movsd	-152(%rbp), %xmm0
	call	S
	movq	%xmm0, %rax
	movq	%rax, -80(%rbp)
	call	clock@PLT
	movq	%rax, -72(%rbp)
	movq	-72(%rbp), %rax
	subq	-88(%rbp), %rax
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC7(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movq	-80(%rbp), %rdx
	movq	-96(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rdx, -152(%rbp)
	movsd	-152(%rbp), %xmm0
	leaq	.LC18(%rip), %rsi
	movq	%rax, %rdi
	movl	$2, %eax
	call	fprintf@PLT
	movq	-96(%rbp), %rax
	movq	%rax, %rdi
	call	fclose@PLT
.L13:
	movl	$0, %eax
.L9:
	movq	-8(%rbp), %rsi
	xorq	%fs:40, %rsi
	je	.L23
	call	__stack_chk_fail@PLT
.L23:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC1:
	.long	0
	.long	1073741824
	.align 8
.LC7:
	.long	0
	.long	1093567616
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
