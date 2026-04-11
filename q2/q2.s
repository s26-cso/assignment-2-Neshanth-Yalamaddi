.data
    array: .word 100                    # to store input
    result: .word 100                   # to store output
    stack: .word 100                    # our manual stack
    buffer: .space 400                  # Buffer for string input
    space: .asciz " "

.text
.globl main
.extern atoi

main:
    # Read the input
    la a0, buffer
    li a1, 400
    li a7, 8                            # Read string
    ecall

    la s0, array                        # s0 = array base address
    li s1, 0                            # s1 = count of elements
    la s2, buffer

loop:
    lb t0, 0(s2)
    li t1, 10                           # Newline
    beq t1, t0, nge
    beqz t0, nge
    li t1, 32                           # Space
    beq t1, t0, skip_space

    mv a0, s2
    jal ra, atoi                        # Returns integer in a0, end pointer in a1

    slli t0, s1, 2
    add t0, s0, t0
    sw a0, 0(t0)                        # Store converted integers
    addi s1, s1, 1                      # n++
    mv s2, a1                           # move buffer pointer to where atoi stopped
    j loop

skip_space:
    addi s2, s2, 1
    j loop

# Next Greater Element Algorithm
nge:
    la s3, result
    la s4, stack                        # Pointer to the base of your stack
    li s5, 0                            # s5 = current stack size (0 = empty)
    addi s6, s1, -1                     # i = n - 1

nge_loop:
    bltz s6, print_result

    # Load current element arr[i]
    slli t2, s6, 2
    add t2, s0, t2
    lw t2, 0(t2)                        # t2 = val_curr

while_pop:
    beqz s5, set_result                 # if stack size == 0, go to set_result
    
    # Peek at top: stack stores the VALUE of the element
    lw t1, 0(s4)                        # t1 = value at top of stack
    
    bgt t1, t2, set_result              # If top > curr, we found it!
    
    # Pop: move pointer back and decrease size
    addi s4, s4, -4
    addi s5, s5, -1
    j while_pop

set_result:
    slli t0, s6, 2
    add t0, s3, t0                      # addr of result[i]
    
    beqz s5, no_greater
    lw t1, 0(s4)                        # Get the value at top
    sw t1, 0(t0)                        # Store value in result
    j push_curr

no_greater:
    li t1, -1
    sw t1, 0(t0)

push_curr:
    # Push: move pointer forward and store value
    addi s4, s4, 4
    sw t2, 0(s4)                        # Push the current value onto stack
    addi s5, s5, 1

    addi s6, s6, -1
    j nge_loop

# Print result
print_result:
    li s6, 0
print_loop:
    bge s6, s1, exit
    slli t0, s6, 2
    add t0, s3, t0
    lw a0, 0(t0)
    li a7, 1
    ecall
    la a0, space
    li a7, 4
    ecall
    addi s6, s6, 1
    j print_loop

exit:
    li a7, 10
    ecall