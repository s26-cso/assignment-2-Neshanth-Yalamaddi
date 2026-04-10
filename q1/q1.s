.text
.globl make_node
.globl insert
.globl get
.globl getAtMost

make_node:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd a0, 0(sp)          # Save val
    li a0, 24             # 4(int)+4(pad)+8(left)+8(right)
    call malloc
    ld t0, 0(sp)          # Restore val
    sw t0, 0(a0)          # Store 32-bit int
    sd zero, 8(a0)        # left = NULL
    sd zero, 16(a0)       # right = NULL
    ld ra, 8(sp)
    addi sp, sp, 16
    ret

insert:
    addi sp, sp, -16
    sd ra, 8(sp)
    beq a0, zero, insert_create
    sd a0, 0(sp)          # Save root
    lw t0, 0(a0)          # t0 = root->val
    blt a1, t0, insert_left
    bgt a1, t0, insert_right
    # Value already exists
    ld ra, 8(sp)
    addi sp, sp, 16
    ret

insert_left:
    ld a0, 8(a0)          # a0 = root->left
    call insert
    ld t1, 0(sp)          # t1 = original root
    sd a0, 8(t1)          # root->left = new node
    mv a0, t1             # return original root
    j insert_exit

insert_right:
    ld a0, 16(a0)         # a0 = root->right
    call insert
    ld t1, 0(sp)          # t1 = original root
    sd a0, 16(t1)         # root->right = new node
    mv a0, t1             # return original root

insert_exit:
    ld ra, 8(sp)
    addi sp, sp, 16
    ret

insert_create:
    mv a0, a1             # a0 = val for make_node
    call make_node
    ld ra, 8(sp)
    addi sp, sp, 16
    ret

get:
    beq a0, zero, get_null
    lw t0, 0(a0)
    beq t0, a1, get_done
    blt a1, t0, go_left
    ld a0, 16(a0)         # go right
    j get
go_left:
    ld a0, 8(a0)          # go left
    j get
get_null:
    li a0, 0
get_done:
    ret

getAtMost:
    li t2, -1             # Default return if none found

loop_atmost:
    beq a1, zero, done_atmost
    lw t0, 0(a1)          # t0 = current->val
    
    beq t0, a0, exact_match
    blt t0, a0, update_best
    
    # Case: current->val > target
    ld a1, 8(a1)          # Go left
    j loop_atmost

update_best:
    mv t2, t0             # Current is a candidate
    ld a1, 16(a1)         # Try to find a larger one on the right
    j loop_atmost

exact_match:
    mv a0, t0
    ret

done_atmost:
    mv a0, t2
    ret