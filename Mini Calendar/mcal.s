#
#	Name: 		Miller, Ryan
#	Project:	2
#	Due:		3/18/24
#	Course:		cs-2640-0x-sp24
#
#	Description:
#		A brief description of the project.
#

	.data
intro:	.asciiz	"Mini Calendar by R. Miller\n\n"
month:	.asciiz	"Enter the month? "
year:	.asciiz	"Enter the year? "

a1:	.asciiz	"January "	
a2:	.asciiz	"February "
a3:	.asciiz	"March "
a4:	.asciiz	"April "
a5:	.asciiz	"May "
a6:	.asciiz	"June "
a7:	.asciiz	"July "
a8:	.asciiz	"August "
a9:	.asciiz	"September "
a10:	.asciiz	"October "
a11:	.asciiz	"November "
a12:	.asciiz	"December "
months:	.word	a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12

outline:	.asciiz	"Sun Mon Tue Wed Thu Fri Sat\n"

newLine:	.asciiz	"\n"

	.text

# month - $t0
# year - $t1
# a - $t2
# y (for days) - $t3
# m (for days) - $t4
# day of the week - $t5

main:
	la	$a0, intro		# print intro
	li	$v0, 4
	syscall

	la	$a0, month		# print request for month
	li	$v0, 4
	syscall

	li	$v0, 5			# get user input
	syscall
	move	$t0, $v0		# put months into $t0

	la	$a0, year	# print request for year
	li	$v0, 4
	syscall
	
	li	$v0, 5			# get user input
	syscall
	move	$t1, $v0		# put years into $t1

	la	$a0, newLine	# output 2 new lines
	li	$v0, 4
	syscall

	li	$t2, 14			# a calculation
	sub	$t2, $t2, $t0
	div	$t2, $t2, 12		

	sub	$t3, $t1, $t2		# years y calculation

	mul	$t4, $t2, 12
	add	$t4, $t0, $t4
	sub	$t4, $t4, 2		# months m calculation

	# day of the week calculation
	addi	$t5, $t3, 1		# day + y
	div	$t6, $t3, 4		# y / 4
	add	$t5, $t5, $t6
	div	$t6, $t3, 100		# y / 100
	sub	$t5, $t5, $t6
	div	$t6, $t3, 400		# y / 400
	add	$t5, $t5, $t6
	mul	$t6, $t4, 31
	div	$t6, $t6, 12		# 31m / 12
	add	$t5, $t5, $t6
	rem	$t5, $t5, 7		# everything % 7

	la	$t6, months		# load months array address
	sll	$t7, $t0, 2		# multiply month index by 4 for address
	addu	$t6, $t6, $t7		# get address for specific month
	lw	$a0, ($t6)
	li	$v0, 4
	syscall

	move	$a0, $t1		# move year to a0
	li	$v0, 1
	syscall

	la	$a0, newLine
	li	$v0, 4
	syscall

	la	$a0, outline
	li	$v0, 4
	syscall




	la	$a0, newLine		# print new line
	li	$v0, 4
	syscall

	li	$v0, 10			# exit
	syscall