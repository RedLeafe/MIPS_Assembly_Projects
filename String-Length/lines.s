#
#	Name:		Miller, Ryan
#	Project:	3
#	Due:		4/8/24
#	Course:		cs-2640-02-sp24
#
#	Description:
#		A program that takes up to 10 inputs of up to 40 characters each from the user and outputs their character count after.
#

	.data
intro:	.asciiz	"Lines by R. Miller\n\n"
prompt:	.asciiz	"Enter text? "
print1:	.asciiz	": "
lines:	.word	0:10
linebuf:
	.space	41


	.text
main:
	la	$a0, intro	# output intro
	li	$v0, 4
	syscall

	li	$t0, 0		# counter for maximum 10 inputs
	la	$t1, lines	# lines effective address
	li	$t2, 0		# number of inputs

while:	beq	$t0, 10, endw	# prompt user input
	la	$a0, prompt
	li	$v0, 4
	syscall

	la	$a0, linebuf	# get user input
	li	$a1, 41		# 41 to accept 40 actual characters
	li	$v0, 8
	syscall

	move	$s0, $t0	# save counter
	move	$s1, $t1	# save effective address
	move	$s2, $t2	# save number of inputs

	jal	cstrlen		# check if program should exit
	beq	$v0, 1, endw

	la	$a0, linebuf	# if there is text in the input, dupe it into a new memory location
	jal	cstrdup

	move	$t0, $s0	# restore counter 
	move	$t1, $s1	# restore effective address
	move	$t2, $s2	# restore number of inputs

	sw	$v0, ($t1)

	addi	$t0, $t0, 1	# increase counter
	addiu	$t1, $t1, 4	# get next address location
	addi	$t2, $t2, 1	# increase number of inputs
	
	b	while
endw:

	li	$a0, '\n'	# print new line
	li	$v0, 11
	syscall

	la	$t1, lines

printStrings:
	beqz	$t2, endStr	# check if there is any more strings left

	move	$s1, $t1	# save effective address
	move	$s2, $t2	# save number of inputs left

	lw	$a0, ($t1)	# load parameter with address
	jal	cstrlen
	move	$t0, $v0	# storing len value for later

	move	$t2, $s2	# restore line index
	move	$t1, $s1	# restore effective address

	move	$a0, $v0	# print length
	li	$v0, 1
	syscall

	li	$a0, ':'	# number formatting
	li	$v0, 11
	syscall

	lw	$a0, ($t1)	# print word
	li	$v0, 4
	syscall

	sub	$t2, $t2, 1	# subtract number of inputs left
	addiu	$t1, $t1, 4	# next word
	
	b	printStrings
endStr:
	
	li	$v0, 10		# exit
	syscall


# a0 : cstring
cstrlen:
	addiu	$sp, $sp, -4	# push a0
	sw	$a0, ($sp)

	li	$t0, 0		# reset counter in case this has been run before

while2:
	lb	$t1, 0($a0)
	beqz	$t1, endw2	# check for the 0 character
	addi	$t0, $t0, 1	# increase counter
	addi	$a0, $a0, 1	# check next character
	b	while2
endw2:
	move	$v0, $t0
	lw	$a0, ($sp)	# pop a0
	addiu	$sp, $sp, 4
	jr	$ra

# a0 : # of bytes
malloc:
	addiu	$sp, $sp, -4	# push a0
	sw	$a0, ($sp)

	addi	$a0, $a0, 3	# round up to the nearest 4
	srl	$a0, $a0, 2
	sll	$a0, $a0, 2
	li	$v0, 9
	syscall
	
	lw	$a0, ($sp)	# pop a0
	addiu	$sp, $sp, 4
	jr	$ra

# a0 : cstr
cstrdup:
	addiu	$sp, $sp, -8	#push ra, a0
	sw	$ra, 4($sp)
	sw	$a0, ($sp)

	jal	cstrlen		# calculate length for memory allocation
	addi	$a0, $v0, 1	# add zero byte for malloc
	jal	malloc		# returns v0 which holds the location of dupe string to return
	
	lw	$a0, ($sp)	# pop a0
	addiu	$sp, $sp, 4

	move	$t0, $a0	# location of original string
	move	$t1, $v0	# location of copy

while3:	
	lb	$t2, ($t0)
	sb	$t2, ($t1)

	beqz 	$t2, endw3
	addiu	$t0, $t0, 1	# next original character
	addiu	$t1, $t1, 1	# next dupe character
	b	while3
endw3:

	lw	$ra, ($sp)	# pop ra
	addiu	$sp, $sp, 4
	jr	$ra