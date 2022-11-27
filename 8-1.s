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
	movsd	%xmm0, -8(%rbp)		#double a
	movsd	%xmm1, -16(%rbp)	#double b
	movsd	%xmm2, -24(%rbp)	#double x
	movsd	-24(%rbp), %xmm0	#take x
	mulsd	-24(%rbp), %xmm0	#x*x
	mulsd	-24(%rbp), %xmm0	#x*x*x
	mulsd	-24(%rbp), %xmm0	#x*x*x*x
	movsd	-16(%rbp), %xmm1	#take b
	divsd	%xmm0, %xmm1		#b / x(4)
	movapd	%xmm1, %xmm0	
	addsd	-8(%rbp), %xmm0		#a + b / x(4)
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
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movsd	%xmm0, -40(%rbp)		#a
	movsd	%xmm1, -48(%rbp)		#b
	movl	%edi, -52(%rbp)			#A
	movl	%esi, -56(%rbp)			#B
	movl	$1000000000, -28(%rbp)		#n
	movl	-56(%rbp), %eax			
	subl	-52(%rbp), %eax			# B - A
	cvtsi2ss	%eax, %xmm0		#convert to float
	cvtsi2ss	-28(%rbp), %xmm1	#n
	divss	%xmm1, %xmm0			
	cvtss2sd	%xmm0, %xmm0
	movsd	%xmm0, -8(%rbp)			#h
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -24(%rbp)		#sum
	cvtsi2sd	-52(%rbp), %xmm1	# d
	movsd	-8(%rbp), %xmm0
	movsd	.LC1(%rip), %xmm2
	divsd	%xmm2, %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
	movl	$0, -32(%rbp)
	jmp	.L4
.L5:
	movsd	-16(%rbp), %xmm1
	movsd	-48(%rbp), %xmm0
	movq	-40(%rbp), %rax
	movapd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	movq	%rax, -64(%rbp)
	movsd	-64(%rbp), %xmm0
	call	f
	movapd	%xmm0, %xmm1
	movsd	-24(%rbp), %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	movsd	-16(%rbp), %xmm0
	addsd	-8(%rbp), %xmm0
	movsd	%xmm0, -16(%rbp)
	addl	$1, -32(%rbp)
.L4:
	movl	-28(%rbp), %eax
	subl	$1, %eax
	cmpl	%eax, -32(%rbp)
	jl	.L5
	movsd	-8(%rbp), %xmm0
	mulsd	-24(%rbp), %xmm0	#return h * sum
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	S, .-S
	.section	.rodata
	.align 8
.LC1:
	.long	0
	.long	1073741824
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
