#
#	Name:		Miller, Ryan
#	Project:	4
#	Due:		3/26/24
#	Course:		cs-2640-02-sp24
#
#	Description:
#		Reads elements from a file, puts them in a linked list, and then traverses the linked listed and prints each element
#

	.data
ptfname:	.asciiz	"/Users/ryan/Documents/GitHub/MIPS_Assembly_Projects/Linked-List/enames.dat"
linebuf:	.space	64

intro:	.asciiz	"Elements by R. Miller v0.1\n\n"
prompt:	.asciiz	" elements\n\n"

head:	.word	0
	.text
main:	
	la	$a0, intro
	li	$v0, 4
	syscall

	addiu	$sp, $sp, -8
	sw	$s0, 4($sp)	# s0:file descriptor (fd)
	sw 	$ra, 0($sp)

	la 	$a0, ptfname
	move	$a1, $zero
	jal	open		# s0 = fopen(ptfname) for reading
	beq	$v0, -1, nofile
	move	$s0, $v0

	addiu	$sp, $sp -4
	sw	$s1, ($sp)
	li	$s1, 0		# use saved register for counter

while:	

	move	$a0, $s0	# while can read a line
	la	$a1, linebuf
	jal	fgetln
	blez	$v0, endw

	la	$a0, linebuf	# add to list
	jal	cstrdup		# make new text from input

	move	$a0, $v0	# move new text address to input
	lw	$a1, head
	jal	getnode

	sw	$v0, head	# make new node the head

	addi	$s1, 1
	b	while
endw:	
	move	$a0, $s1	# restore saved register
	lw	$s1, ($sp)
	addiu	$sp, $sp, 4

	li	$v0, 1
	syscall

	la	$a0, prompt
	li	$v0, 4
	syscall

	move	$a0, $s0
	jal	close		# close file

	lw	$a0, head
	la	$a1, print
	jal	traverse

nofile:
	lw	$s0, 4($sp)
	lw	$ra, 0($sp)	
	addiu	$sp, $sp, 8

	jr	$ra

# Methods
# a0: address data, a1: adress node
getnode:
	addiu	$sp, $sp, -8	#push ra, a0
	sw	$ra, 4($sp)
	sw	$a0, 0($sp)

	move	$t0, $a0	# move data address to t0
	li	$a0, 8		# assign memory for node
	jal	malloc

	sw	$t0, 0($v0)	# store data into new node memory location
	sw	$a1, 4($v0)	# store the node address parameter into the next memory address

	lw	$a0, ($sp)	# pop a0
	lw	$ra, 4($sp)	# pop a0
	addiu	$sp, $sp, 8

	jr	$ra

# a0: head, a1: print method address
traverse:
	addiu	$sp, $sp, -8	#push ra, a0
	sw	$ra, 4($sp)
	sw	$a0, 0($sp)

	lw	$a0, 4($a0)
	beqz	$a0, endtrav	# if head is not 0

	jal	traverse	

endtrav:

	lw	$a0, 0($sp)	# restore a0 but dont pop
	lw	$a0, 0($a0)	# extract the string from the node
	jalr	$a1		# run print funciton

	lw	$a0, 0($sp)
	lw	$ra, 4($sp)
	addiu	$sp, $sp, 8	# restore ra, a0

	jr	$ra


# from last project

# a0 : cstring
print:
	addiu	$sp, $sp, -8	# push ra, a0
	sw	$a0, 0($sp)
	sw	$ra, 4($sp)

	jal	cstrlen
	move	$a0, $v0	# print length
	li	$v0, 1
	syscall

	li	$a0, ':'	# number formatting
	li	$v0, 11
	syscall

	lw	$a0, ($sp)
	addiu	$sp, $sp, 4	# pop a0
	li	$v0, 4
	syscall

	lw	$ra, ($sp)
	addiu	$sp, $sp, 4	# pop ra

	jr	$ra

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