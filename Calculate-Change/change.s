#
#	Name:		Miller, Ryan
#	Project:	1
#	Due:		2/29/2024
#	Course:		cs-2640-02-sp24 
#
#	Description:
#		Take total cost and money given as input from the user and output the change in quarters, dimes, nickels, and pennies
#
	.data
intro:		.asciiz	"Change by R. Miller\n\n"
reciept:	.asciiz	"Enter the reciept amount? "
givenAmount:	.asciiz	"Enter the amount tendered? "
printQuarter:	.asciiz "\nQuarter: "
printDime:	.asciiz "\nDime: "
printNickel:	.asciiz "\nNickel: "
printPenny:	.asciiz "\nPenny: "
newLine:	.asciiz	"\n"

	.text
main:	la	$a0, intro		# print intro
	li	$v0, 4
	syscall

	la	$a0, reciept		# print request for total amount
	li	$v0, 4
	syscall

	li	$v0, 5			# get user input
	syscall

	move	$t0, $v0		# put user input into $t0
	la	$a0, givenAmount	# print request for money given
	li	$v0, 4
	syscall

	li	$v0, 5			# get user input
	syscall

	sub	$t0, $v0, $t0		# subtracts given money amount by the reciept to find out total change
	li	$t1, 100		# remove any dollar change
	div	$t0, $t1
	mfhi	$t0

	li	$t1, 25			# value to divide by for quarters
	div	$t0, $t1		# divide by 25
	mfhi	$t0			# replace remaining change with the remainder
	mflo	$t7			# store amount of quarters in $t7

	li	$t1, 10			# value to divide by for dimes	
	div	$t0, $t1
	mfhi	$t0
	mflo	$t6

	li	$t1, 5			# value to divide by for nickels
	div	$t0, $t1
	mfhi	$t0
	mflo	$t5

	la	$a0, printQuarter	# print the format for quarter output
	li	$v0, 4
	syscall

	move	$a0, $t7		# print the quarter amount
	li	$v0, 1
	syscall

	la	$a0, printDime		# print the format for dime output
	li	$v0, 4
	syscall

	move	$a0, $t6		# print the dime amount
	li	$v0, 1
	syscall

	la	$a0, printNickel	# print the format for nickel output
	li	$v0, 4
	syscall

	move	$a0, $t5		# print the nickel amount
	li	$v0, 1
	syscall

	la	$a0, printPenny		# print the format for penny output
	li	$v0, 4
	syscall

	move	$a0, $t0		# print the penny amount
	li	$v0, 1
	syscall

	la	$a0, newLine		# print new line
	li	$v0, 4
	syscall

	li	$v0, 10			# exit
	syscall