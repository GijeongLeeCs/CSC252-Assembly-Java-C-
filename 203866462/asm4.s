# Author : Gijeong Lee
.data


printLine: .asciiz "\n"

.text




.globl bst_init_node


#
# This function accepts a pointer to a BSTNode object
# node->key = key
# node->left = NULL;
# node->right = NULL;
#

bst_init_node:
	
    	addiu   $sp,    $sp,    -24             # allocate stack space -- default of 24 here
    	sw      $fp,    0($sp)                  # save callers frame pointer
   	sw      $ra,    4($sp)                  # save return address
   	addiu   $fp,    $sp,    20              # setup mains frame pointer
   	
   	sw	$a1,	0($a0)			# node ->key = key	
   	sw 	$zero,	4($a0)			# node ->left = Null
   	sw 	$zero,	8($a0)			# node ->right = Null

BSTINITDONE:

	lw      $ra,    4($sp)                  # get return address from stack
    	lw      $fp,    0($sp)                  # restore the callers frame pointer
    	addiu   $sp,    $sp,    24              # restore the callers stack pointer
    	jr      $ra                             # return to callers code   


.globl bst_search

# This function takes a pointer to the root of a tree
# and searches the tree for the key specified.
# If it finds the key, it returns the node which contains that key
# if it doesn’t, then it returns NULL
# BSTNode *bst_search(BSTNode *node, int key)
# { 
#   BSTNode *cur = node;
#   while (cur != NULL)
#   {
#	if (cur->key == key)
#	return cur;
#	if (key < cur->key)
#	cur = cur->left;
#	else
#	cur = cur->right;
#   }
#  return NULL;
#}
#
# REGISTER
# t1 - cur
# t2 - 1 or 0
# t3 - cur -> left
# t4 - cur -> right
# v0 - return 


bst_search:
    	addiu   $sp,    $sp,    -24             # allocate stack space -- default of 24 here
    	sw      $fp,    0($sp)                  # save callers frame pointer
   	sw      $ra,    4($sp)                  # save return address
   	addiu   $fp,    $sp,    20              # setup mains frame pointer
   	
  	add	$t0,	$a0,	$zero		# cur = node
  	
  	
LOOP:
	beq	$t0,	$zero,	OUT		# if(cur == NULL) jump ahead
	
	lw	$t1,	0($t0)			# t1 = cur -> key 
	beq	$t1,	$a1,	OUT2		# if(cur->key == key) jump ahead
	
	slt 	$t2,	$a1,	$t1		# if( key< cur->key) t2 = 1	
	beq	$t2,	$zero,	ELSE		# if ( key >= cur -> key) jump ahead
	lw	$t3,	4($t0)			# t3 = cur -> left
	add	$t0,	$t3,	$zero		# cur = cur -> left
	
	j 	LOOP
	
	

ELSE:
	lw	$t4,	8($t0)			# t4 = cur -> right
	add	$t0,	$t4,	$zero		# cur = cur->right
	j 	LOOP
	
	
OUT:
	add	$v0,	$zero,	$zero		# return NULL
	
	
OUT2:
	add	$v0,	$t0,	$zero		# return cur 
	

SEARCHDONE:

	lw      $ra,    4($sp)                  # get return address from stack
    	lw      $fp,    0($sp)                  # restore the callers frame pointer
    	addiu   $sp,    $sp,    24              # restore the callers stack pointer
    	jr      $ra                             # return to callers code   

.globl bst_count

# This function counts the number of nodes in a tree.
#int bst_count(BSTNode *node)
#{
#	if (node == NULL)
#	return 0;
#	return bst_count(node->left) + 1 + bst_count(node->right);
#}
# REGISTER
# t0 - t0 +1
# v0 - return

bst_count:
    	addiu   $sp,    $sp,    -24             # allocate stack space -- default of 24 here
    	sw      $fp,    0($sp)                  # save callers frame pointer
   	sw      $ra,    4($sp)                  # save return address
   	addiu   $fp,    $sp,    20              # setup mains frame pointer
   
	
   	beq	$a0,	$zero,	NULLOUT		# if (node == NULL) jump ahead
   	
   	
   	sw	$a0,	12($sp)			# allocating a0 to stack
   	lw	$a0,	4($a0)			# t0 = node -> left
   	jal	bst_count
  
  	lw	$a0,	12($sp)			# loading 12($sp) to $a0
	addiu	$sp,	$sp,	-4		# adding extra space
	sw	$v0,	0($sp)			# saving node -> left to stack
	
	lw	$a0,	8($a0)			# a0 = node -> right
	jal	bst_count
	
	lw	$t0,	0($sp)			# t0 = 0($sp)
	addiu	$sp,	$sp,	4		# removing extra space
	
	addi	$t0,	$t0,	1		# t0 = t0 +1
	add	$t0,	$t0,	$v0		# t0 = t0 + v0
	
	add	$v0,	$t0,	$zero		# return bst_count(node->left) + 1 + bst_count(node->right)
	

	j COUNTDONE
	
  	
NULLOUT:
	add	$v0,	$zero,	$zero		# return 0


COUNTDONE:

	lw      $ra,    4($sp)                  # get return address from stack
    	lw      $fp,    0($sp)                  # restore the callers frame pointer
    	addiu   $sp,    $sp,    24              # restore the callers stack pointer
    	jr      $ra                             # return to callers code  
    	
.globl bst_in_order_traversal

#void bst_in_order_traversal(BSTNode *node)
#{
#	if (node == NULL)
#	return;
#	bst_in_order_traversal(node->left);
#	printf("%d\n", node->key);
#	bst_in_order_traversal(node->right);
#}
#
# Register
# v0 - return
# a0 - changing

bst_in_order_traversal:
    	addiu   $sp,    $sp,    -24             # allocate stack space -- default of 24 here
    	sw      $fp,    0($sp)                  # save callers frame pointer
   	sw      $ra,    4($sp)                  # save return address
   	addiu   $fp,    $sp,    20              # setup mains frame pointer
   	
   	beq	$a0,	$zero,	INORDERDONE	# if(a0 == NULL) jump ahead
   	
   	sw	$a0,	12($sp)			# save a0 to stack	
   	lw	$a0,	4($a0)			# a0 = node -> left
   	jal 	bst_in_order_traversal	
   	
   	
   	lw	$a0,	12($sp)			# a0 = a0 from stack 
   	lw	$t0,	0($a0)			# t0 = node -> key
   	
   	addi 	$v0, 	$zero, 	1 		#printing count
	add  	$a0, 	$t0, 	$zero 		
	syscall
	

	addi	$v0,	$zero,	4		#print line
	la	$a0,	printLine
	syscall
	
	
   	lw	$a0,	12($sp)			# a0 = a0 from stack
   	lw	$a0,	8($a0)			# a0 = node -> right
   	jal	bst_in_order_traversal
   	 

INORDERDONE:
	lw      $ra,    4($sp)                  # get return address from stack
    	lw      $fp,    0($sp)                  # restore the callers frame pointer
    	addiu   $sp,    $sp,    24              # restore the callers stack pointer
    	jr      $ra                             # return to callers code  
    	
.globl bst_pre_order_traversal

#void bst_pre_order_traversal(BSTNode *node)
#{
#	if (node == NULL)
#	return;
#	printf("%d\n", node->key);
#	bst_pre_order_traversal(node->left);
#	bst_pre_order_traversal(node->right);
#}
#
# Register
# v0 -return
# a0 - changing
bst_pre_order_traversal:
    	addiu   $sp,    $sp,    -24             # allocate stack space -- default of 24 here
    	sw      $fp,    0($sp)                  # save callers frame pointer
   	sw      $ra,    4($sp)                  # save return address
   	addiu   $fp,    $sp,    20              # setup mains frame pointer
   	
   	beq	$a0,	$zero,	PREORDERDONE	# if( a0 == NULL) jump ahead
   	   		
   	sw	$a0,	12($sp)			# save a0 to stack
   	lw	$t0,	0($a0)			# t0 = node -> key
   	
   	addi 	$v0, 	$zero, 	1 		#printing key
	add  	$a0, 	$t0, 	$zero 		
	syscall
	
	addi	$v0,	$zero,	4		#print line
	la	$a0,	printLine
	syscall
   	
   	lw	$a0,	12($sp)			# load a0
   	lw	$a0,	4($a0)			# a0 = node -> left
   	jal 	bst_pre_order_traversal
	
   	lw	$a0,	12($sp)			# load a0 from stack
   	lw	$a0,	8($a0)			# a0 = node -> right
   	jal	bst_pre_order_traversal
   	

PREORDERDONE:
	lw      $ra,    4($sp)                  # get return address from stack
    	lw      $fp,    0($sp)                  # restore the callers frame pointer
    	addiu   $sp,    $sp,    24              # restore the callers stack pointer
    	jr      $ra                             # return to callers code  
    	
    	
.globl bst_insert

#BSTNode *bst_insert(BSTNode *root, BSTNode *newNode)
#{
#	if (root == NULL)
#	return newNode;
#	if (newNode->key < root->key)
#	root->left = bst_insert(root->left, newNode);
#	else
#	root->right = bst_insert(root->right, newNode);
#	return root;
#}
#
# Register
# t1 - root -> left
# t3 - v0
# t0 - newNode
bst_insert:
    	addiu   $sp,    $sp,    -24             # allocate stack space -- default of 24 here
    	sw      $fp,    0($sp)                  # save callers frame pointer
   	sw      $ra,    4($sp)                  # save return address
   	addiu   $fp,    $sp,    20              # setup mains frame pointer
   	
   	beq	$a0,	$zero,	NEWNODE		# if( root == NULL) jump ahead
   	
   	sw	$a0,	12($sp)			# save a0 to stack 
   	lw	$t1,	0($a0)			# t1 = root -> key
   	lw	$t0,	0($a1)			# t0 = newNode
   	
   	slt	$t2,	$t0,	$t1		# if( t0 < t1) t2 = 1
   	beq	$t2,	$zero,	ELSE1		# if( t0 >= t1) jump ahead
   	
   	lw	$a0,	4($a0)			# a0 = root -> left
 	jal	bst_insert
 	
 	lw	$a0,	12($sp)			# load a0 from stack
 	addiu	$sp,	$sp,	-4		# create extra space to stack
 	sw	$v0,	0($sp)			# save v0 to stack
 	
 	lw	$t0,	0($sp)			# load 0($sp) to t0
 	addiu	$sp,	$sp,	4		# remove the extra space in stack
 	add	$t3,	$v0,	$zero		# t3 = v0
 	
   	sw	$t3,	4($a0)			# root-> left =  bst_insert(root->left, newNode)
   	
   	j FINAL
   	
ELSE1:

	lw	$a0,	8($a0)			# a0 = root -> right
 	jal	bst_insert
 	
 	lw	$a0,	12($sp)			# load a0 from stack
 	addiu	$sp,	$sp,	-4		# create extra space to stack
 	sw	$v0,	0($sp)			# save v0 to stack
 	
 	lw	$t0,	0($sp)			# load 0($sp) to t0
 	addiu	$sp,	$sp,	4		# remove the extra space in stack
 	add	$t3,	$v0,	$zero		# t3 = v0
 	
   	sw	$t3,	8($a0)			# root-> right =  bst_insert(root->left, newNode)
  	
	j	FINAL
	
NEWNODE:
	add	$v0,	$a1,	$zero		# return newNode
	j	INSERTDONE
	
	
FINAL:
	add	$v0,	$a0,	$zero		# return root

INSERTDONE:
	lw      $ra,    4($sp)                  # get return address from stack
    	lw      $fp,    0($sp)                  # restore the callers frame pointer
    	addiu   $sp,    $sp,    24              # restore the callers stack pointer
    	jr      $ra                             # return to callers code  
	
