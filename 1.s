.data
.text
.globl main


# $s4 = resultValue
# $a0 = m
# $a1 = n

main:

#declaring arguments
addi $a0,$0,3
addi $a1,$0,1

#call the function and store result in resultValue
jal ackerman
add $s4,$0,$v0 

#print message
li $v0,1
add $a0,$0,$s4
syscall

#exit
li $v0,10
syscall

ackerman:
addi $sp,$sp,-8 # 2 variables for the stack
sw $s0 0($sp) # store ra
sw $ra 4($sp) # store s0

#First case: m = 0 
bgtz $a0,ack1    # If it is not m=0 then go to the next instruction                    
add $v0,$a1,1       # n+1 if m = 0 
j fin         # - jump to end of conditional

# Second case: if m > 0 and n = 0 
# if m > 0 then it is already here, now check if n is eqal to 0, if not go to the ack2 the third condition
ack1:
bgtz $a1,ack2                             
sub $a0,$a0,1       # m = m-1
li $a1,1            # n = 1
jal ackerman 		#recursive
j fin

ack2:
# Third Case m>0 and n>0:
    # We need to make two recursive calls to Ackermann, but after the first,
    # our register $a0 holding m may be modified. So we hang onto a copy of m
    # in $s0.
move $s0,$a0        # copy m to $s0
sub $a1,$a1,1       # n = n-1
jal ackerman       # Do recusive with a0 = m and a1 = n - 1  
move $a1,$v0        # n = result of A(m, n-1)
sub $a0,$s0,1       #  m = m-1
jal ackerman

fin:
lw $s0, 0($sp)     #load $ra
lw $ra, 4($sp)     #load $s0
addi $sp,$sp,8     #remove those from stack 
jr $ra 			   #return to caller

