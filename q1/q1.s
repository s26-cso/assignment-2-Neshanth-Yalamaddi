.text
.globl make_node
.globl insert
.globl get
.globl getAtMost

make_node:
    #stack pointer
    addi sp,sp,-16
    sd ra,8(sp)
    sd a0,0(sp)

    # creates node 
    li a0,24
    call malloc

    # node->val=val
    ld t0,0(sp)
    sw t0,0(a0)

    # node->left=NULL, node->right=NULL
    sd zero,8(a0)
    sd zero,16(a0)

    #return
    ld ra,8(sp)
    addi sp,sp,16
    ret

insert:
    beq a0,zero, insert_create
    # root->val
    lw t0,0(a0)
    blt a1,t0, insert_left
    bgt a1,t0, insert_right
    ret

insert_left:
    # t1 = root->left
    ld t1,8(a0)
    mv a0,t1        # a0 = root->left
    call insert
    sd a0,8(sp)
    ret

insert_right:
    # t1 = root->right
    ld t1,16(a0)
    mv a0,t1        # a0 = root->right
    call insert
    sd a0,8(sp)
    ret

insert_create:
    mv a0,a1
    call make_node
    ret

get:
    beq a0,zero, get_NULL

    lw t0,0(a0)
    beq t0,a1, get_found
    blt a1,t0, get_left

get_right:
    ld a0,16(a0)
    j get

get_left:
    ld a0,8(a0)
    j get

get_found:
    ret

get_NULL:
    mv a0,zero
    ret

getAtMost:
    li t2,-1

loop_atmost:
    beq a1,zero ,done_atmost
    lw t0,0(a1)
    ble t0,a0, update_best
    lw a1,8(a1)
    j loop_atmost

update_best:
    mv t2,t0
    ld a1, 16(a1)
    j loop_atmost

done_atmost:
    mv a0,t2
    ret