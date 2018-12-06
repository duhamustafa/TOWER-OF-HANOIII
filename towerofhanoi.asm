.text
.globl __start
 __start:

li  $v0,4           # System call code for print string
    la  $4,input        # Argument string as input
    syscall 

    #   Read an integer
 li $v0,5
 syscall

#   Move the integer to register $t0
    move $t9,$v0


la $a0, tower1
la $a1, tower2
la $a2, tower3
la $a3,($t9)

jal moveStack

jal PrintTowers


li  $v0, 10
syscall 

moveStack:
    sub $sp, $sp, 32
    sw $a0, 0($sp)
    sw $a1, 4($sp)
    sw $a2, 8($sp)
    sw $a3, 12($sp)
    sw $s0, 16($sp)
    sw $s1, 20($sp)
    sw $s2, 24($sp)
    sw $ra, 28($sp)


    beq $a3,1,moveOne


    move $s0, $a0
    move $s1, $a1
    move $s2, $a2


    move $a0, $s0
    move $a1, $s2
    move $a2, $s1
    sub $a3, $a3, 1
    jal moveStack

    move $a0, $s0
    move $a1, $s1
    jal moveRing

    move $a0, $s2
    move $a1, $s1
    move $a2, $s0
    jal moveStack

    j end



    moveOne:
        jal moveRing



    end:
        lw $a0, 0($sp)
        lw $a1, 4($sp)
        lw $a2, 8($sp)
        lw $a3, 12($sp)
        lw $s0, 16($sp)
        lw $s1, 20($sp)
        lw $s2, 24($sp)
        lw $ra, 28($sp)
        add $sp,$sp,32
        jr $ra


    moveRing:
        sub $sp,$sp,12
        sw $a0, 0($sp)
        sw $a1, 4($sp)
        sw $ra, 8($sp)

        jal PrintTowers

    finds: sub $a0, $a0,4
        lw $t0,($a0)
        beqz $t0 founds
        j finds

    founds: add $a0, $a0, 4
        lw $t0,($a0)
        sw $0,($a0)

    findd: sub $a1, $a1, 4
        lw $t1,($a1)
        beqz $t1 foundd
        j findd

    foundd: sw $t0($a1)
        lw $a0, 0($sp)
        lw $a1, 4($sp)
        lw $ra, 8($sp)
        add $sp, $sp, 12


        jr $ra




    PrintTowers:
        sub $sp, $sp, 28
        sw $v0, 0($sp)
        sw $a0, 4($sp)
        sw $s0, 8($sp)
        sw $s1, 12($sp)
        sw $s2, 16($sp)
        sw $s3, 20($sp)
        sw $ra, 24($sp)


        la $s1, tower1
        la $s2, tower2
        la $s3, tower3
        la $s0, ($t9)

        mul $s0, $s0, 4
        sub $s1, $s1, $s0
        sub $s2, $s2, $s0
        sub $s3, $s3, $s0

    Loop:   beqz $s0, exit
        la $a0,Blanks
        li $v0, 4
        syscall

        lw $a0,($s1)
        jal printOne
        lw $a0,($s2)
        jal printOne
        lw $a0,($s3)
        jal printOne

        la $a0, endl
        li $v0, 4
        syscall

        sub $s0, $s0, 4
        add $s1, $s1, 4
        add $s2, $s2, 4
        add $s3, $s3, 4
        j Loop

        exit: la $a0, Base
        li $v0, 4
        syscall

        lw $v0, 0($sp)
        lw $a0, 4($sp)
        lw $s0, 8($sp)
        lw $s1, 12($sp)
        lw $s2, 16($sp)
        lw $s3, 20($sp)
        lw $ra, 24($sp)
        add $sp, $sp, 28
        jr $ra



    printOne:
        sub $sp, $sp, 12
        sw $a0, 0($sp)
        sw $v0, 4($sp)
        sw $ra, 8($sp)

        bnez $a0, ring
        la $a0, Blank
        li $v0, 4
        syscall

        j spaces

    ring:   li $v0, 1
        syscall

    spaces: la $a0, Blanks
        li $v0, 4
        syscall

        lw $a0, 0($sp)
        lw $v0, 4($sp)
        lw $ra, 8($sp)
        add $sp, $sp, 12
        jr $ra




        .data 
    Blanks: .asciiz "     "
    Blank:  .asciiz "  "
    endl:   .asciiz "\n"
    Base:   .ascii "    ____    ____    ____\n"
        .asciiz "    T1  T2  T3\n\n\n"

        .align 2
    notused: .word 1,2,3    #   .word1,2,3,4,5,6,7,8,9,10,11,12,13
    tower1: .word 0,0,0,0,0,0,0,0,0,0,0,0,0
    tower2: .word 0,0,0,0,0,0,0,0,0,0,0,0,0
    tower3: .word 0


    input:  .asciiz "\nEnter number of disks:"