# Gijeong Lee 
# ASM5

.data
printDash: .asciiz "----------------"
printLine: .asciiz "\n"
printCol: .asciiz ": "
printStuff: .asciiz "<other>: "

.text


.globl countLetters
countLetters:

    addiu   $sp, $sp, 	-24             # allocate stack space -- default of 24 here
    sw      $fp, 0($sp)               	# save callers frame pointer
    sw      $ra, 4($sp)               	# save return address
    addiu   $fp, $sp, 	20              # setup mains frame pointer

    addiu   $sp, $sp, 	-104            # allocating space on stack

    add     $t0, $zero, $zero         	# t0 = 0
    addi    $t2, $zero, 26            	# t2 = 26

#while (*cur != ’\0’)
#{
#if (*cur >= ’a’ && *cur <= ’z’)
#letters[*cur-’a’]++;
#else if (*cur >= ’A’ && *cur <= ’Z’)
#letters[*cur-’A’]++;
#else
#other++;
#cur++;
#}
#REGISTER
# t1 = 1 or 0
# t3= stack[i]


   
LOOP:
    slt     $t1, $t0, 	$t2		# if (t0 < t2) then t1 = 1
    beq     $t1, $zero, BREAK		# if (t1 == 0) jump ahead
    add     $t3, $zero, $t0           	# t3 = t0
    sll     $t3, $t3, 	2               # shifting the stack by 4

    add     $t3, $sp, 	$t3             # stack[i]
    sw      $zero, 0($t3)		# t3 = zero
    addi    $t0, $t0, 	1              	# t0++
    j       LOOP	
    
    
BREAK:

    add     $t0, $zero, $a0           	# t0 = a0
    addi    $t1, $zero, 0             	# t1 = 0

    addi    $v0, $zero, 4             	# printing Dash
    la      $a0, printDash
    syscall 

    addi    $v0, $zero, 4             	# printing Line
    la      $a0, printLine
    syscall 

    addi    $v0, $zero, 4             	# printing the str
    add     $a0, $zero, $t0
    syscall 

    addi    $v0, $zero, 4             	# printing Line
    la      $a0, printLine
    syscall 

    addi    $v0, $zero, 4             	# printing dash
    la      $a0, printDash
    syscall 

    addi    $v0, $zero, 4             	# printing line
    la      $a0, printLine
    syscall 

    add     $t8, $zero, $t0           	# t8 = t0

    # this loop to loop through the array to check for the letter and increase the count
    
LOOP1:
    lb      $t4, 0($t8)               	# gets cur letter
    beq     $t4, $zero, PRINT         	# if(t4 == zero) jump ahead

    slti    $t5, $t4, 	'a'             # if( t4 < 'a') then t5 = 1

    bne     $t5, $zero, CASE1     	# if(t5 == zero) jump ahead

    addi    $t3, $zero, 'z'		# t3 = 'z'
    slt     $t5, $t3, 	$t4             # if(t3 < t4) then t5 = 1
    bne     $t5, $zero, CASE1     	# if( t5 == zero) jump ahead

    addi    $t2, $zero, 'a'           	# t2  = a
    sub     $t5, $t4, 	$t2             # t5 = t4 - t2

    sll     $t5, $t5, 	2               # shift t5

    add     $t6, $sp, 	$t5             # t6 = sp+ t5
    lw      $t7, 0($t6)               	# t7=  0(t6)

    addi    $t7, $t7, 	1               # t7++
    sw      $t7, 0($t6)               	# store t7 to stack

    j       INCREMENT

CASE1:
    slti    $t5, $t4, 	'A'             # if( t5 < 'A') then t5 = 1
    bne     $t5, $zero, CASE2 		# if( t5 == zero) jump ahead
        
    addi    $t3, $zero, 'Z'             # t3 = 'Z'
    slt     $t5, $t3, 	$t4             # if( t3 < t4) then t5 = 1
    bne     $t5, $zero, CASE2 		# if(t5 == zero) jump ahead

    addi    $t2, $zero, 'A'           	# t2 = 'A'
    sub     $t5, $t4, 	$t2             # t5 = t4 - t2

    sll     $t5, $t5, 	2               # shift t5

    add     $t6, $sp, 	$t5             # t6 = sp + t5
    lw      $t7, 0($t6)               	# loading the address of the stack pointer to t7

    addi    $t7, $t7, 	1               # t7++
    sw      $t7, 0($t6)              	# storing the new value into t7

    j       INCREMENT

CASE2:
    addi    $t1, $t1, 	1               # t1++
    

INCREMENT:
    addi    $t8, $t8, 	1               # t8++
    j       LOOP1

PRINT:
    addi    $t8, $zero, 0             	# t8 = 0


# for (int i=0; i<26; i++)
# printf("%c: %d\n", ’a’+i, letters[i]);
LOOPEND:
    slti    $t9, $t8, 	26              # if (t8 < 26) then t9 = 1
    beq     $t9, $zero, COUNTDONE   	# if(t9 == 0) jump ahead

    addi    $t9, $t8, 	'a'             # t9 = a + i

    addi    $v0, $zero, 11
    add     $a0, $zero, $t9           	# printing a+i
    syscall 

    addi    $v0, $zero, 4
    la      $a0, printCol             	# prints col
    syscall 

    sll     $t5, $t8, 	2               # shifts by 2 which is multiple by 4
    add     $t9, $sp, 	$t5             # t9  =  sp + t5

    lw      $t2, 0($t9)               	# loading the stack pointer address into t2

    addi    $v0, $zero, 1
    add     $a0, $zero, $t2           	# printing letters[i]
    syscall 

    addi    $v0, $zero, 4
    la      $a0, printLine            	# printing line
    syscall 

    addi    $t8, $t8, 1               	# i++
    j       LOOPEND


COUNTDONE:
    addi    $v0, $zero, 4
    la      $a0, printStuff           	# printing <other>
    syscall 

    addi    $v0, $zero, 1
    add     $a0, $zero, $t1           	# printing other
    syscall 

    addi    $v0, $zero, 4
    la      $a0, printLine            	# printing line
    syscall 

    addiu   $sp, $sp, 	104		# delete stack

    lw      $ra, 4($sp)               	# get return address from stack
    lw      $fp, 0($sp)              	# restore the callerï¿½s frame pointer
    addiu   $sp, $sp, 	24              # restore the callerï¿½s stack pointer
    jr      $ra                        	# return to callerï¿½s code


.globl subsCipher
subsCipher:

    addiu   $sp, $sp, 	-24             # allocate stack space -- default of 24 here
    sw      $fp, 0($sp)              	# save callers frame pointer
    sw      $ra, 4($sp)              	# save return address
    addiu   $fp, $sp, 	20              # setup mains frame pointer

    sw      $a0, 8($sp)               	# saving the first parameter
    sw      $a1, 12($sp)              	# saving the second parameter

    jal     strLen

    lw      $a0, 8($sp)			# load to a0
    lw      $a1, 12($sp)		# load to a1 

    add     $t0, $a0, 	$zero           # t0 = a0
    add     $t1, $a1, 	$zero           # t1 = a1

    addi    $t2, $v0, 	1               # t2 = v0 + 1

    addi    $t3, $zero, 0xffff        	# gets first 16 bits of mask
    sll     $t3, $t3, 	16              # shifts mask by 16 to get 32 bits
    ori     $t3, $t3, 	0xfffc          # gets the right mask

    addi    $t4, $t2, 	3               # gets len + 3
    and     $t4, $t4, 	$t3             # t4 = t4 & t3

    sub     $sp, $sp, 	$t4             # sp = sp - t4

    addi    $t5, $zero, 0             	# i = 0

    addi    $t6, $t2, 	-1              # t6 = t2 -1

	
# for (int i=0; i<len-1; i++)
# dup[i] = map[str[i]];	
LOOP3:
    slt     $t7, $t5, 	$t6             # if(i< len-1) then t7  = 1
    beq     $t7, $zero, OUTT		# if(t7 ==0 ) jump ahead

    add     $t8, $t0, 	$t5             # gets the current char in string
    lb      $t8, 0($t8)
    add     $t9, $t1, 	$t8             # gets map[str[i]]
    lb      $t9, 0($t9)

    add     $t3, $sp, 	$t5             # dup[i] = map[(int)str[i]]
    sb      $t9, 0($t3)

    addi    $t5, $t5, 	1               # i++
    j       LOOP3

OUTT:
    addi    $t3, $zero, '\0'          	# t3 = null
    add     $t5, $sp, 	$t6             # t5 = sp + t6

    sb      $t3, 0($t5) 	      	# dup[len-1] = '\0'

    add     $a0, $sp, 	$zero           # a0 = sp

    sw      $t4, 0($fp)               	# saves the t4 on the frame pointer
    jal     printSubstitutedString

    lw      $t4, 0($fp)               	# loading the t4 after calling the method

DONE:

    add     $sp, $sp, 	$t4             # deallocates space from the stack

    lw      $ra, 4($sp)              	# get return address from stack
    lw      $fp, 0($sp)               	# restore the callerï¿½s frame pointer
    addiu   $sp, $sp, 	24              # restore the callerï¿½s stack pointer
    jr      $ra                        	# return to callerï¿½s code

.globl strLen
strLen:

    addiu   $sp, $sp, 	-24             # allocate stack space -- default of 24 here
    sw      $fp, 0($sp)               	# save callers frame pointer
    sw      $ra, 4($sp)               	# save return address
    addiu   $fp, $sp, 	20              # setup mains frame pointer

    addi    $t0, $zero, 0             	# count = 0
    addi    $t1, $zero, 0             	# i = 0
    add     $t2, $zero, $a0           	# t2  = a0
    addi    $t3, $zero, '\0'          	# saving null pointer into $s0

    # this loop is to loop through the string to count the len of the string
LOOP4:
    add     $t4, $zero, $t1           	# t4 = t1
    add     $t5, $t2, 	$t4             # str[i]
    lb      $t6, 0($t5)               	#loading the bit
    beq     $t3, $t6, 	STRLENDONE      # while str[i]!= null
    addi    $t0, $t0, 	1               # count++
    addi    $t1, $t1, 	1               # i +=1
    j       LOOP4

STRLENDONE:
    add     $v0, $t0, 	$zero           # saves the count into v0
    lw      $ra, 4($sp)               	# get return address from stack
    lw      $fp, 0($sp)               	# restore the callerï¿½s frame pointer
    addiu   $sp, $sp, 	24              # restore the callerï¿½s stack pointer
    jr      $ra                         # return to callerï¿½s code

