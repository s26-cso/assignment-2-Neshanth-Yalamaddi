.data
    filename: .asciz "input.txt"
    buffer1: .space 1
    buffer2: .space 1
    Yes: .asciz "YES\n"
    No: .asciz "NO\n"
.text
.globl _start

_start:
    li a7,56
    li a0,-100
    la a1,filename
    li a2,0
    ecall
    mv s0, a0           # file descriptor
    
    li a7,62
    mv a0,s0
    li a1,0
    li a2,2
    ecall
    mv s1,a0            # s1 = file size

    li s2,0             # left pointer
    addi s3,s1,-1       # right pointer

loop:
    bge s2,s3, palindrome

    li a7,62            # left char
    mv a0,s0
    mv a1,s2
    li a2,0
    ecall

    li a7,63
    mv a0,s0
    la a1,buffer1
    li a2,1
    ecall

    li a7,62            # right char
    mv a0,s0
    mv a1,s3
    li a2,0
    ecall

    li a7,63
    mv a0,s0
    la a1,buffer2
    li a2,1
    ecall

    la t0,buffer1
    lb t1,0(t0)

    la t2,buffer2
    lb t3,0(t2)

    bne t1,t3,not_palindrome

    addi s2,s2,1
    addi s3,s3,-1
    j loop

palindrome:
    li a7,64
    li a0,1
    li a1,Yes
    li a2,4
    ecall
    j exit

not_palindrome:
    li a7,64
    li a0,1
    li a1,No
    li a2,3
    ecall

exit:
    li a7,93
    li a0,0
    ecall