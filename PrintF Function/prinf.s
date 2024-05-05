#
#	Name:		Miller, Ryan
#	Homework:	2
#	Due:		4/22/24
#	Course:		cs-2640-02-sp24
#
#	Description:
#		A program that takes a string input and replaces any %s with string paramters and %d with integer paramters
#
	.data
charP:	.asciiz	"%"
charS:	.asciiz	"s"
charD:	.asciiz	"d"

# paramaters
test1:	.asciiz	"%s is %d years old\n"
name:	.asciiz	"Ryan"
age:	.word	18

test2:	.asciiz	"I am %s to C%dde Malware %% In %s soon hopefully <%d %d%% %s\n"
var1:	.asciiz	"going"
var2:	.word	0
var3:	.asciiz	"Assembly"
var4:	.word	3
var5:	.word	9000
var6:	.asciiz	"for SWIFT"

test3:	.asciiz	"testing termination %z, hello %%"

	.text
main:
	la	$a0, test1	# test 1
	la	$t0, name	# load vars
	lw	$t1, age
	addiu	$sp, $sp, -8	# push vars
	sw	$t0, ($sp)
	sw	$t1, 4($sp)
	jal	printf

	la	$a0, test2	# test 2
	la	$t0, var1	# load vars
	lw	$t1, var2
	la	$t2, var3
	lw	$t3, var4
	lw	$t4, var5
	la	$t5, var6
	addiu	$sp, $sp, -24	# push vars
	sw	$t0, ($sp)
	sw	$t1, 4($sp)
	sw	$t2, 8($sp)
	sw	$t3, 12($sp)
	sw	$t4, 16($sp)
	sw	$t5, 20($sp)
	jal	printf

	la	$a0, test3	# test 3
	jal	printf

	li	$v0, 10		# exit
	syscall


printf:
	addiu	$sp, $sp, -4	# push a0
	sw	$a0, ($sp)
	addiu	$sp, $sp, 4	# adjust stack to be above a0

	la	$t1, charP	# load "%" byte to compare against
	lb	$t1, ($t1)	# get character from address

	la	$t2, charD	# load "d" byte
	lb	$t2, ($t2)

	la	$t3, charS	# load "s" byte
	lb	$t3, ($t3)
	
	move	$t4, $a0	# effective address
while:	
	lb	$t0, ($t4)
	beqz 	$t0, endw

if:	bne	$t0, $t1, else

	addiu	$t4, $t4, 1	# next character
	lb	$t0, ($t4)

caseP:
	bne	$t0, $t1, caseD
	move	$a0, $t0
	li	$v0, 11
	syscall

	b	endif		# break
	
caseD:
	bne	$t0, $t2, caseS
	lw	$a0, ($sp)
	li	$v0, 1
	syscall

	addiu	$sp, $sp, 4	# check char after "%"
	b	endif		# break

caseS:
	bne	$t0, $t3, default
	lw	$a0, ($sp)
	li	$v0, 4
	syscall

	addiu	$sp, $sp, 4	# check char after "%"
	b	endif		# break

default:
	li	$a0, '?'	# exit case if unknown code
	li	$v0, 11
	syscall

	move	$a0, $t0
	li	$v0, 11
	syscall

	li	$v0, 10		# terminate
	syscall

else:
	move	$a0, $t0	# else print regular char
	li	$v0, 11
	syscall

endif:
	addiu	$t4, $t4, 1	# next character
	b	while
	
endw:
	lw	$a0, ($sp)
	addiu	$sp, $sp, 4	# adjust stack to be above a0

	jr	$ra

