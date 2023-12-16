.data
printIntsFirst: .asciiz "printInts: About to print "
printIntsSecond: .asciiz " elements.\n"
printIntsThird: .asciiz "printInts: About to print an unknown number of elements. Will stop at a zero element.\n"
printIntsArray: .asciiz "\n"
printSWap: .asciiz "Swap at: "
printWordss: .asciiz "printWords: There were "
printWords2: .asciiz " words.\n"
.text

.globl studentMain

studentMain: 
	addiu $sp, $sp, -24 		# allocate stack space -- default of 24 here
	sw $fp, 0($sp) 			# save callerís frame pointer
	sw $ra, 4($sp) 			# save return address
	addiu $fp, $sp, 20 		# setup mainís frame pointer
	
#if (printInts != 0)
#{
#	if (printInts_howToFindLen != 2)
#	{
#		int count;
#		if (printInts_howToFindLen == 0)
#			count = intsArray_len;
#		else
#			count = intsArray_END - intsArray; // remember to divide by 4!
#		printf("printInts: About to print %d elements.\n", count);
#		for (int i=0; i<count; i++)
#			printf("%d\n", intsArray[i]);
#	}
# REGISTERS
# t0  - printInts
# t1  - printInts_howToFindLen
# t2  - 2
# t3  - intsArray_len
# t4  - intsArray_len
# t4  - intsArray_END - intsArray
# t7  - 0 (i)
# t8  - t6 + t8
#
#
#

#TASK 1
	la $t0, printInts		# t0 = & printInts
	lb $t0, 0($t0)			# t0 = printInts
	
	la $t6, intsArray		# t6 = &intsArray
	
	beq $t0, $zero, FIRST		# if (t0 == 0 ) jump ahead
	
	la   $t1, printInts_howToFindLen# t1 = &printInts_howToFindLen
	lh   $t1, 0($t1) 		# t1 = printInts_howToFindLen
	
	addi $t2, $t2, 2		# t2 = 2
	beq  $t1, $t2, SECOND		# if (t1 == t2) jump ahead
	addi $t4, $zero, 0		# count = 0
	
	bne  $t1, $zero, THIRD		# if (t1 != 0 ) jump ahead
	la   $t3, intsArray_len		# t3 = &intsArray_len
	lw   $t3, 0($t3)			# t3 = intsArray_len
	
	
	add  $t4, $t4, $t3		# t4 = intsArray_len
	j    PRINTING
	
THIRD:
	la   $t5, intsArray_END		# t5 = &intsArray_END
	sub  $t4, $t5, $t6		# t4 = intsArray_END - intsArray
	srl  $t4, $t4, 2		# move right by 2


	
PRINTING:
	addi $v0, $zero, 4		#printing printIntsFirst
	la   $a0, printIntsFirst		
	syscall
	
	addi $v0, $zero, 1 		#printing count
	add  $a0, $t4, $zero 		
	syscall
	
	addi $v0, $zero, 4		#printing printIntsSecond
	la   $a0, printIntsSecond
	syscall
	

	addi $t7, $zero, 0		# t7 = 0


LOOP:
	slt  $t0, $t7, $t4		# t0 = 1 if (t7 < t4:)
	beq  $t0, $zero, EXIT		# if (t0 = 0) jump ahead
	
	sll  $t8, $t7, 2			# intsArray[i] shift by 2
	add  $t8, $t6, $t8		# t8 = t6 + t8
	lw   $t8, 0($t8)			# t8 =  t8
	
	
	addi $v0, $zero, 1 		# printing intsArray[i]
	add  $a0, $t8, $zero 		
	syscall
	
	addi $v0, $zero, 4		# printing PrintIntsArray
	la   $a0, printIntsArray
	syscall
	

	addi $t7, $t7, 1		# t7 = 1 (i++)
		
	j LOOP
	

EXIT:
	j FIRST	
	
#else
#{
# 	int *cur = intsArray; 
#	printf("printInts: About to print an unknown number of elements. "
#	"Will stop at a zero element.\n"); // all one line!
#	while (*cur != 0)
#	{
#		printf("%d\n", *cur);
#		cur++;
#	}
#}
#}
#
#	
#
#
#

SECOND:
	la   $a0, intsArray		# a0 = &intsArray
	ori  $t0, $zero, 0
	la   $t1, intsArray		# t1 = &intsArray
	
	addi $t0, $zero, 0		# t0 = 0
	
	addi $v0, $zero, 4		# printing printIntsThird
	la   $a0, printIntsThird
	syscall	
	
	
	
LOOP2:
	lw   $t2, ($t1)			# t2 = t1
	bne  $t2, $zero, PRINTV		# if (t6 ==0) jump ahead
	
	
	j DONE
	
PRINTV:
	li   $v0, 1          		# Code for printing an integer
    	srl  $a0, $t2, 0   		# Shift right logical to copy $t2 to $a0
    	syscall

	li   $v0, 4         		# Code for printing a string
   	la   $a0, printIntsArray   	# Load the address of the newline string
    	syscall
    	
    	addi $t1, $t1, 4		# t1 = t1 + 4
    	addi $t0, $t0, 1		# t0 = t0 + 1 
    	
    	j LOOP2
    	
DONE:

FIRST:
	
#TASK2

    	la   $a0, theString		# a0 = &theString
    	lb   $t0, printWords		# t0 = &printWords

	beq  $t0, $zero, DONE3		# if(t0 == 0) jump ahead
	
	la   $t1, theString		#t1 = start
	la   $t2, theString		#t2 = cur
		
	
	addi $t3, $t3, 1		# t3 = t3+1
	
# while (*cur != ’\0’) // null terminator. ASCII value is 0x00
# {
#	if (*cur == ’ ’)
#	{
#		*cur = ’\0’;
#		count++;
#	}
#	cur++;
#}

#REGISTER
# t3  - count
# t1  - start
# t2  - cur
WORDSLOOP:
	lb   $t4, ($t2)			#t4 = t2
	beq  $t4, $zero, PRINTC		# if( t4 ==0 ) jump ahead
	
	addi $t5, $5, 32		# SPACE
	beq  $t4, $t5, SPACE		# if (t4 ==  32) jump ahead
	
	addi $t2, $t2, 1		# t2 = t2+1
	j    WORDSLOOP
	
SPACE:
	sb   $zero, ($t2)		# t2 = 0
	addi $t3, $t3, 1		# t3 = t3 + 1
	addi $t2, $t2, 1		# t2 = t2 +1
	j    WORDSLOOP
	
PRINTC:
	addi $v0, $zero, 4		# printing printWordss
	la   $a0, printWordss
	syscall
	
	addi $v0, $zero, 1		# printing count
	add  $a0, $t3, $zero
	syscall
	
	addi $v0, $zero, 4		#printing printWords2
	la   $a0, printWords2
	syscall
	
# while (cur >= start)
# {
# 	if (cur == start || cur[-1] == ’\0’)
#		print("%s\n", cur);
#	cur--;
# }
# Register SAME
#
#
#
LOOPCUR:
	slt   $s0, $t2, $t1		# if( t2 < t1) s0 =1
	bne   $s0, $zero, DONE3		# if( s0 ==0) jump ahead
	
	beq   $t1, $t2, CUR1		# if( t1 == t2) jump ahead
	lb    $t3, -1($t2)		# move backwards
	beq   $t3, $zero, CUR		# if (t3 ==0) jump ahead
	
	addi  $t2, $t2, -1		# t2 = t2-1
	
	j     LOOPCUR
	
CUR1:
	add   $a0, $zero, $t2		# printing cur
	addi  $v0, $zero, 4		
	syscall 
	
	addi  $v0, $zero, 4		# printing printintsArray	
	la    $a0, printIntsArray		
	syscall
	
	addi $t2, $t2, -1		# t2 = t2 -1
	
	j LOOPCUR

CUR:	
	add   $a0, $zero, $t2		#printing cur
	addi  $v0, $zero, 4
	syscall 
	
	addi  $v0, $zero, 4		# printing printIntsArray
	la    $a0, printIntsArray
	syscall

	addi  $t2, $t2, -1		# t2 = t2 -1
	j LOOPCUR
	
DONE3:
#TASK3

	la    $t0, bubbleSort		# t0 = &bubbleSort
	lb    $t0, 0($t0)			# t0 = bubbleSort
	
	la    $t6, intsArray		# t6 = intsArray
	
	beq   $t0, $zero, BUBBLE		# if( t0 ==0) jump ahead
	
	addi  $t1, $zero, 0		# i =0
	
	la    $t2, intsArray_len		# t2 = &intsArray_len
	lw    $t2, 0($t2)			# t2 = intsArray_len


# for (int i=0; i<intsArray_len; i++)
#	for (int j=0; j<intsArray_len-1; j++)
#		if (intsArray[j] > intsArray[j+1])
#		{
#			print("Swap at: %d\n", j);
#			int tmp = intsArray[j];
#			intsArray[j] = intsArray[j+1];
#			intsArray[j+1] = tmp;
#		}
# REGISTER
# t3 - j
# t1-  i
# t5 - j+1
ILOOP:
	slt   $s0, $t1,   $t2  		# if (t1<t2) s0 =1 
	beq   $s0, $zero, IOUT
	
	addi  $t3, $zero, 0		# j = 0
	
	
JLOOP:
	addi  $t4, $t2,   -1		# intsArray_len -1
	slt   $s1, $t3,   $t4		# if( t3< t2) s1 =1
	beq   $s1, $zero, JOUT		# if (s1 = 0) jump ahead
	
	sll   $t8, $t3,   2
	add   $t8, $t6,   $t8
	lw    $t8, 0($t8)		# intsArray[j]
	
	addi  $t5, $t3,   1		# t5 = j + 1
	sll   $t7, $t5,   2
	add   $t7, $t6,   $t7
	lw    $t7, 0($t7)			# intsArray[j+1]
	
	slt   $s4, $t7,   $t8		# if( intsArray[j+1] <intsArray[j]) s4 =1
	beq   $s4, $zero, ARRAYIF	# if( s4 = 0) jump ahead
	 
	addi  $v0, $zero, 4		# printing printSWap
	la    $a0, printSWap
	syscall
	
	add   $a0, $zero, $t3		# printing j 
	addi  $v0, $zero, 1
	syscall 
	
	addi $v0, $zero,  4		# printing printIntsArray
	la   $a0, printIntsArray
	syscall
	
	
	add  $t0, $t8,    $zero 	# int tmp = intsArray[j]
	add  $t8, $t7,    $zero		# intsArray[j] = intsArray[j+1]
	add  $t7, $t0,    $zero		# intsArray[j+1] = tmp
	
	sll  $t0, $t3,    2		#calculataing offset by shifting
	add  $t0, $t6,    $t0		#getting address + offsset
	sw   $t8, 0($t0)		#storing

	sll  $t0, $t5,    2		#calculataing offset by shifting
	add  $t0, $t6,    $t0		#getting address + offsset
	sw   $t7, 0($t0)		#storing
	
	
	addi $t3, $t3 ,   1		# t3 = t3 +1
	j JLOOP
	
ARRAYIF:
	addi $t3, $t3 ,   1		# t3 = t3 +1
	j JLOOP

JOUT:
	addi $t1, $t1,    1		# t1 = t1 + 1
	j ILOOP

IOUT:
	
BUBBLE:

	
REVSDONE:
	lw    $ra, 4($sp)  		# get return address from stack
	lw    $fp, 0($sp) 		# restore the callerís frame pointer
	addiu $sp, $sp,   24 		# restore the callerís stack pointer
	jr    $ra 			# return to callerís code