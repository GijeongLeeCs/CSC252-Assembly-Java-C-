# AUTHOR: GIJEONG LEE

.data

printSpace: .asciiz " "
printLine: .asciiz "\n"
printCollatz: .asciiz "collatz("
printCollatzs: .asciiz ") completed after "
printCollatzss: .asciiz " calls to collatz_line()."

.text


.globl collatz_line

collatz_line:
    	addiu   $sp,    $sp,    -24             # allocate stack space -- default of 24 here
    	sw      $fp,    0($sp)                  # save callers frame pointer
   	sw      $ra,    4($sp)                  # save return address
   	addiu   $fp,    $sp,    20              # setup mains frame pointer
	
	add	$t0, 	$a0,	$zero		# t0 = val
	andi 	$t1,	$t0,	0x1		# val % 2
	beq	$t1,	$zero,	EVEN		# if(val %2 == 0) jump ahead
	
	addi	$v0,	$zero,	1		#print val
	add	$a0,	$t0,	$zero		
	syscall
	
	addi	$v0,	$zero,	4		#print line
	la	$a0,	printLine
	syscall
	
	add	$v0,	$t0,	$zero		#return val
	j	RETURN


EVEN:
	addi	$v0,	$zero,	1		# print val
	add	$a0,	$t0,	$zero
	syscall

	add	$t3,	$t0,	$zero		# cur = val

#	while(cur%2==0)
#	{
#		cur /=2;
#		printf(" %d", cur);
#	}
#REGISTERS
# t0 -val
# t1 - t0 and 1
# v0 - return
# t3 - cur
# t5 - cur and 1

LOOP:		
	andi	$t5,	$t3,	0x1		# check whether it is odd or even
	bne	$t5,	$zero,	ODD		# if(cur is odd) jump ahead
	
	sra	$t3,	$t3,	1
	addi	$v0,	$zero,	4		# print space
	la	$a0,	printSpace
	syscall	
	
	addi	$v0,	$zero,	1		# print cur
	add	$a0,	$t3,	$zero
	syscall	
	
	j LOOP

ODD:
	addi	$v0,	$zero,	4		#print line
	la	$a0,	printLine
	syscall
	
	add	$v0,	$t3,	$zero		# return cur
	
RETURN:

LINEDONE:
	
	lw      $ra,    4($sp)                  # get return address from stack
    	lw      $fp,    0($sp)                  # restore the callers frame pointer
    	addiu   $sp,    $sp,    24              # restore the callers stack pointer
    	jr      $ra                             # return to callers code                            

.globl collatz

collatz:
	addiu   $sp,    $sp,    -24             # allocate stack space -- default of 24 here
    	sw      $fp,    0($sp)                  # save callers frame pointer
   	sw      $ra,    4($sp)                  # save return address
   	addiu   $fp,    $sp,    20              # setup mains frame pointer
	
	add	$t8,	$a0,	$zero		# t8 = val
	add	$t0,	$t8,	$zero		# cur = val
	add	$t6,	$zero,	$zero		# calls = 0
	
	add	$a0,	$t0,	$zero		
	jal	collatz_line
	add	$t0,	$v0,	$zero		# cur = collatz_line(cur)
		
	addi	$t4,	$zero,	1		# t4 = 1

#	while (cur !=1)
#	{
#		cur = 3*cur +1;
#		cur = collatz_line(cur);
#		calls++;
#	}
#REGISTER
# t8 - val
# t0 - cur
# t6 - calls
# t4 - i
# t0 - collatz_line(cur)
# t7 - t0

CURLOOP:
	beq	$t0,	$t4,	OUT		# if( cur == 1) jump ahead
	
	add	$t7,	$t0,	$zero		# t7 = t0
	add	$t0,	$t0,	$t0		# t0 = t0+t0 (2*t0)
	add	$t0,	$t0,	$t7		# t0 = t0*3
	
	addi	$t0,	$t0,	1		# t0 = 3*cur + 1
	
	add	$a0,	$t0,	$zero		# a0 = t0
	jal 	collatz_line			# call collatz_line
	
	add	$t0,	$v0,	$zero		# t0 = v0
	addi	$t6,	$t6,	1		# calls++
	
	j CURLOOP
	
OUT:
	
	addi	$v0,	$zero,	4		#print printCollatz
	la	$a0,	printCollatz
	syscall
	
	addi	$v0,	$zero,	1		#print val
	add	$a0,	$t8,	$zero
	syscall
	
	addi	$v0,	$zero,	4		#print printCollatzs
	la	$a0,	printCollatzs
	syscall
	
	addi	$v0,	$zero,	1		#print calls
	add	$a0,	$t6,	$zero
	syscall
	
	addi	$v0,	$zero,	4		#print printCollatzss
	la	$a0,	printCollatzss
	syscall
	
	addi	$v0,	$zero,	4		#print line
	la	$a0,	printLine
	syscall
		
	addi	$v0,	$zero,	4		#print line
	la	$a0,	printLine
	syscall	
	
COLLTAZDONE:
	lw      $ra,    4($sp)                  # get return address from stack
    	lw      $fp,    0($sp)                  # restore the callers frame pointer
    	addiu   $sp,    $sp,    24              # restore the callers stack pointer
    	jr      $ra                             # return to callers code

.globl percentSearch

percentSearch:
	addiu   $sp,    $sp,    -24             # allocate stack space -- default of 24 here
    	sw      $fp,    0($sp)                  # save callers frame pointer
   	sw      $ra,    4($sp)                  # save return address
   	addiu   $fp,    $sp,    20              # setup mains frame pointer
	
	add	$t0,	$a0,	$zero		# t0 = String
	addi	$t5,	$zero,	37		# t5 = '%'
	addi	$t7,	$zero,	0		# t7 = 0

#	for(int i=0; i< string.length; i++)
#	{
#		if(  string.charAt(i)=='%')
#		{
#			return i
#
#		}
#	}	
#	return -1
#
#REGISTER
# t0 - String
# t5 - '%'
# t7 - i
# t8 - &t0
#


SEARCHLOOP:
	lb	$t8,	0($t0)			# t8 = &t0
	beq	$t8,	$zero,	NOTFOUND	# if(t8 == 0) jump ahead
	beq	$t8,	$t5,	FOUND		# if(t8 == t5) jump ahead
	
	
	addi	$t0,	$t0,	1		# t0 +=1
	addi	$t7,	$t7,	1		# t7 +=1
	j SEARCHLOOP
	

FOUND:
	add	$v0,	$t7,	$zero		#return index
	j	EXITFIND
	

NOTFOUND:
	addi	$v0,	$zero,	-1		#return -1

EXITFIND:

PERCENTDONE:
	lw      $ra,    4($sp)                  # get return address from stack
    	lw      $fp,    0($sp)                  # restore the callers frame pointer
    	addiu   $sp,    $sp,    24              # restore the callers stack pointer
    	jr      $ra                             # return to callers code


	
.globl letterTree

letterTree:
	addiu   $sp,    $sp,    -24             # allocate stack space -- default of 24 here
    	sw      $fp,    0($sp)                  # save callers frame pointer
   	sw      $ra,    4($sp)                  # save return address
   	addiu   $fp,    $sp,    20              # setup mains frame pointer	
	
	
	add 	$t0,	$a0,	$zero		# t0 = step
	addi 	$t1,	$zero,	0		# count = 0
	addi	$t2,	$zero,	0		# pos = 0

#	while(1)
#	{
#		char c = getNextLetter(pos);
#		if (c == '\0')
#			break;
#		for(int i =0; i<=count; i++)
#			printf("%c", c);
#		printf("\n");
#		count++;
#		pos+= step;
#	}
#	return pos;
#
#REGISTER
# t0 - step
# t1 - count
# t2 - pos
# a0 - pos
# t3 - getNextLetter(pos
# t4 - i
# t5 - if( count <i)
# v0 - t2

WHILELOOP:

	add	$a0,	$t2,	$zero		# a0 = pos
	jal	getNextLetter			# call getNextLetter
	
	add	$t3,	$v0,	$zero		# c = getNextLetter(pos)
	beq	$t3,	$zero,	BREAK		# if(t3==0) jump ahead
	
	
	addi	$t4,	$zero,	0		# i = 0
	
FORLOOP:
	slt 	$t5,	$t1,	$t4		# if( count < i) t5 = 1
	bne	$t5,	$zero,	OUTFOR		# if( i > count ) jump ahead
			
	addi 	$v0, 	$zero, 	11		# printing c
	add	$a0,	$t3,	$zero
	syscall
	
	
	addi 	$t4,	$t4,	1		# i++
	
	j FORLOOP
	
OUTFOR:
	addi	$v0,	$zero,	4		#print line
	la	$a0,	printLine
	syscall
	
	addi	$t1,	$t1,	1		# count++
	add	$t2,	$t2,	$t0		# pos += step
	j WHILELOOP

BREAK:
	add	$v0,	$t2,	$zero		# v0 = t2
	
	
LETTERDONE:
	lw      $ra,    4($sp)                  # get return address from stack
    	lw      $fp,    0($sp)                  # restore the callers frame pointer
    	addiu   $sp,    $sp,    24              # restore the callers stack pointer
    	jr      $ra                             # return to callers code      

	
	
