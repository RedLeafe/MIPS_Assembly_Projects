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

monthLengths:	.word	31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31

outline:	.asciiz	"Sun Mon Tue Wed Thu Fri Sat\n"

spaces3:	.asciiz	"   "
spaces2:	.asciiz	"  "
spaces1:	.asciiz	" "

newLine:	.asciiz	"\n"

	.text

# month - $t0
# year - $t1
# a - $t2
# y (for days) - $t3
# m (for days) - $t4
# day of the week - $t5
# temp reg - $t6
# temp reg - $t7
# 

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

	la	$a0, year		# print request for year
	li	$v0, 4
	syscall
	
	li	$v0, 5			# get user input
	syscall
	move	$t1, $v0		# put years into $t1

	la	$a0, newLine		# output new line
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
	sub	$t0, $t0, 1		# subtract months by 1 to turn it into array index
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



	li	$t6, 0			# use t6 for counter
	while:	bge $t6, $t5, endw	# loop according to day of the week
	la	$a0, spaces3		# print 3 spaces for empty days
	li	$v0, 4
	syscall

	la	$a0, spaces1		# space between every day
	li	$v0, 4
	syscall

	addi	$t6, $t6, 1
	b while
	endw:

	la	$t6, monthLengths
	sll	$t7, $t0, 2
	addu	$t6, $t6, $t7
	lw	$t8, ($t6)		# put total number of days in the month in $t8

	if3:	bne $t0, 1, endif3	# if month is february
	
	and	$t7, $t1, 0x3
	if4:	bne $t7, $zero, endif4	# if year is divisble by 4

	rem	$t7, $t1, 100
	rem	$t9, $t1, 400
	add	$t7, $t7, $t9
	if5:	beq $t7, $zero, endif5	# if year is divisble by 100 or 400
	
	addi	$t8, $t8, 1		# add 1 to februrary days if not divisble by 100 or 400
	
	endif5:
	endif4:
	endif3:

	li	$t6, 1			# reset t6 counter
	while2:	bgt $t6, $t8, endw2	# loop the days in the month

	rem	$t7, $t5, 7
	if:	bne $t7, $zero, endif	# if day of the week is sunday, print new line before printing the day
	la	$a0, newLine		
	li	$v0, 4
	syscall
	endif:

	if2:	bge $t6, 10, endif2
	la	$a0, spaces1		# print an extra space for single digit numbers
	li	$v0, 4
	syscall
	
	endif2:
	la	$a0, spaces1		# print at least one space for all numbers
	li	$v0, 4
	syscall

	move	$a0, $t6		# print day of the week
	li	$v0, 1
	syscall

	la	$a0, spaces1		# print space between each day
	li	$v0, 4
	syscall

	addi	$t5, $t5, 1		# increase day of the week
	addi	$t6, $t6, 1		# increase day
	b while2
	endw2:

	la	$a0, newLine		# print new line
	li	$v0, 4
	syscall

	li	$v0, 10			# exit
	syscall