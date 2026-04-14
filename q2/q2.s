.data
    array: .space 400                  # to store input array
    result: .space 400                 # to store output indices
    stack: .space 400                  # manual stack storing indices
    buffer: .space 400                 # Buffer for string input
    space: .asciz " "
    newline: .asciz "\n"

.text
.globl main
.extern atoi

main:
    # Read the input string
    la a0, buffer
    li a1, 400
    li a7, 8                            # Read string syscall
    ecall

    la s0, array                        # s0 = array base address
    li s1, 0                            # s1 = count of elements
    la s2, buffer                       # pointer to traverse buffer

loop:
    lb t0, 0(s2)
    li t1, 10                           # Newline
    beq t1, t0, nge
    beqz t0, nge

    li t1, 32                           # Space
    beq t1, t0, skip_space

    mv a0, s2
    jal ra, atoi                        # a0 = integer, a1 = next char pointer

    slli t0, s1, 2
    add t0, s0, t0
    sw a0, 0(t0)                        # Store integer in array

    addi s1, s1, 1                      # n++
    mv s2, a1                           # move pointer to end of parsed number
    j loop

skip_space:
    addi s2, s2, 1
    j loop

nge:
    la s3, result                       # result array base
    la s4, stack                        # stack base
    li s5, -1                           # stack top index (-1 = empty)

    addi s6, s1, -1                     # i = n - 1

nge_loop:
    bltz s6, print_result

    # Load arr[i]
    slli t2, s6, 2
    add t2, s0, t2
    lw t2, 0(t2)                        # t2 = arr[i]

while_pop:
    bltz s5, set_result                 # if stack empty → set result

    # Get index stored at stack[top]
    slli t0, s5, 2
    add t0, s4, t0
    lw t1, 0(t0)                        # t1 = index at stack[top]

    # Load arr[stack[top]]
    slli t3, t1, 2
    add t3, s0, t3
    lw t4, 0(t3)                        # t4 = arr[index]

    ble t4, t2, pop_stack               # pop if <= arr[i]
    j set_result

pop_stack:
    addi s5, s5, -1                     # pop
    j while_pop


set_result:
    slli t0, s6, 2
    add t0, s3, t0                      # result[i] address

    bltz s5, no_greater

    # store index of next greater element
    slli t1, s5, 2
    add t1, s4, t1
    lw t3, 0(t1)
    sw t3, 0(t0)

    j push_curr

no_greater:
    li t1, -1
    sw t1, 0(t0)


push_curr:
    # Push current index onto stack
    addi s5, s5, 1
    slli t1, s5, 2
    add t1, s4, t1
    sw s6, 0(t1)

    addi s6, s6, -1                     # i--
    j nge_loop

print_result:
    li s6, 0

print_loop:
    slli t0, s6, 2
    add t0, s3, t0
    lw a0, 0(t0)

    li a7, 1                            # print integer
    ecall

    addi s6, s6, 1

    bge s6, s1, print_newline
    la a0, space
    li a7, 4                            # print space
    ecall

    j print_loop

print_newline:
    la a0, newline                      # ensure newline at end
    li a7, 4
    ecall

exit:
    li a7, 10                           # exit program
    ecall