
# display text file on the screen
# file name is specified in the command line

	.data
ptfname:	.asciiz	"/Users/ryan/Documents/GitHub/MIPS_Assembly_Projects/Linked-List/enames.dat"
linebuf:	.space	64
	.text
main:	
	addiu	$sp, $sp, -8
	sw	$s0, 4($sp)	# s0:file descriptor (fd)
	sw 	$ra, 0($sp)
	
	# if main av[1] is the input file path
	#bne	$a0, 2, nofile
	#lw 	$a0, 4($a1)	# read-only

	la 	$a0, ptfname
	li	$a1, 0
	jal	open		# s0 = fopen(ptfname) for reading
	beq	$v0, -1, nofile
	move	$s0, $v0		# 
while:	move 	$a0, $s0		# while can read a line
	la 	$a1, linebuf
	jal 	fgetln
	blez	$v0, endw
	la 	$a0, linebuf 	# output the line
	li 	$v0, 4
	syscall
	b 	while
endw:	move	$a0, $s0
	jal	close		# close file

nofile:
	lw	$s0, 4($sp)
	lw 	$ra, 0($sp)	
	addiu	$sp, $sp, 8

	jr	$ra