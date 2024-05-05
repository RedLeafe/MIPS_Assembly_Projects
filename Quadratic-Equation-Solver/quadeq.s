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
linearsolution:
	.asciiz "x = "
solution1:
	.asciiz	"x1 = "
solution2:
	.asciiz	"\nx2 = "

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

	li	$a0, '\n'
	li	$v0, 11
	syscall

# calculations

	li.d	$f18, 0.0
	c.eq.d	$f4, $f18		# if a = 0
	bc1f	elif
if:
	c.eq.d	$f6, $f18		# if b != 0
	bc1t	elif2

	la	$a0, linearsolution
	li	$v0, 4
	syscall

	neg.d	$f10, $f8		# x = -c / b
	div.d	$f12, $f10, $f6
	li	$v0, 3
	syscall
	b	endif

elif:
	mul.d	$f10, $f6, $f6		# if discriminant < 0 
	li.d	$f16, 4.0
	mul.d	$f16, $f16, $f4
	mul.d	$f16, $f16, $f8
	sub.d	$f16, $f10, $f16

	c.lt.d	$f16, $f18		# if less than 0
	bc1f	else
	la	$a0, discriminant
	li	$v0, 4
	syscall

	b	endif

elif2:					# if a = 0 && b == 0
	la	$a0, output
	li	$v0, 4
	syscall
	b	endif

else:
	neg.d	$f10, $f6
	li.d	$f18, 2.0
	mul.d	$f18, $f4, $f18		# 2(a)
	sqrt.d	$f16, $f16		# sqrt(b^2 - 4ac)

	la	$a0, solution1
	li	$v0, 4
	syscall

	add.d	$f12, $f10, $f16	# -b + sqrt(b^2 - 4ac)
	div.d	$f12, $f12, $f18	# / 2(a)
	li	$v0, 3
	syscall

	la	$a0, solution2
	li	$v0, 4
	syscall

	sub.d	$f12, $f10, $f16	# -b - sqrt(b^2 - 4ac)
	div.d	$f12, $f12, $f18	# / 2(a)
	li	$v0, 3
	syscall

endif:

	li	$a0, '\n'
	li	$v0, 11
	syscall

	li	$v0, 10
	syscall