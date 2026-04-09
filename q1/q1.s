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
    addi sp,sp,-16
    sd ra,8(sp)
    sd a0,0(sp)
    beq a0,zero, insert_create
    # root->val
    lw t0,0(a0)
    blt a1,t0, insert_left
    bgt a1,t0, insert_right
    ld ra,8(sp)
    addi sp,sp,16
    ret

insert_left:
    ld t1,8(a0)        # root->left
    sd a0,0(sp)        # save root
    mv a0,t1
    call insert
    ld t2,0(sp)        # restore root
    sd a0,8(t2)        # root->left = returned node
    mv a0,t2
    ld ra,8(sp)
    addi sp,sp,16
    ret

insert_right:
    ld t1,16(a0)       # root->right
    sd a0,0(sp)
    mv a0,t1
    call insert
    ld t2,0(sp)
    sd a0,16(t2)
    mv a0,t2
    ld ra,8(sp)
    addi sp,sp,16
    ret

insert_create:
    mv a0,a1
    call make_node
    ld ra,8(sp)
    addi sp,sp,16
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
    ld a1,8(a1)
    j loop_atmost

update_best:
    mv t2,t0
    ld a1, 16(a1)
    j loop_atmost

done_atmost:
    mv a0,t2
    ret