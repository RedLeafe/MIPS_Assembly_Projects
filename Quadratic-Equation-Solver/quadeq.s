#
#	Name:		Miller, Ryan
#	Project:	2
#	Due:		3/18/24
#	Course:		cs-2640-02-sp24
#
#	Description:
#		A program that outputs a miniture calendar of the month given an input month and year
#

	.data
intro:	.asciiz	"Quadratic Equation Solver v0.1 by R. Miller\n\n"
prompt1:
	.asciiz	"Enter value for a? "
prompt2:
	.asciiz	"Enter value for b? "
prompt3:
	.asciiz	"Enter value for c? "
output:	.asciiz	"Not a quadratic equation."
discriminant:
	.asciiz	"Roots are imaginary."

	.text
main:
	la	$a0, intro	# print intro
	li	$v0, 4
	syscall

	la	$a0, prompt1	# print request for 1st value
	li	$v0, 4
	syscall

	li	$v0, 7		# get user input
	syscall
	mov.d	$f4, $f0	

	la	$a0, prompt2	# print request for 2nd value
	li	$v0, 4
	syscall

	li	$v0, 7		# get user input
	syscall
	mov.d	$f6, $f0	

	la	$a0, prompt3	# print request for 3rd value
	li	$v0, 4
	syscall

	li	$v0, 7		# get user input
	syscall
	mov.d	$f8, $f0	

	# neg.d	$f4, $f4
#	li.d	$f16, 2.0
#	div.d	$f12, $f4, $f16
#	li	$v0, 3
#	syscall
#	li.d	$f16, 2.0
#	li.d	$f18, 4.0
#	c.lt.d	$f16, $f18
#	bc1f	bruh
#	li	$a0, 'b'
#	li	$v0, 11
#	syscall

bruh:


#	mov.d	$f12, $f4
#	li	$v0, 3
#	syscall
#
#	li	$a0, '\n'
#	li	$v0, 11
#	syscall
#
#	mov.d	$f12, $f6
#	li	$v0, 3
#	syscall
#	
#	li	$a0, '\n'
#	li	$v0, 11
#	syscall
#
#	mov.d	$f12, $f8
#	li	$v0, 3
#	syscall
#
#	li	$a0, '\n'
#	li	$v0, 11
#	syscall

	li.d	$f18, 0.0
	c.eq.d	$f4, $f18
	bc1f	endif
if:
	c.eq.d	$f6, $f18
	bc1t	elif

	neg.d	$f8, $f8
	div.d	$f12, $f8, $f6
	li	$v0, 3
	syscall
	b	endif

elif:

	mul.d	$f10, $f6, $f6
	li.d	$f16, 4.0
	mul.d	$f16, $f16, $f4
	mul.d	$f16, $f16, $f8
	c.lt.d	$f16, $f18		# if less than 0
	bc1f	else
	la	$a0, discriminant
	li	$v0, 4
	syscall

else:
	la	$a0, output
	li	$v0, 4
	syscall

endif:

	li	$v0, 10
	syscall