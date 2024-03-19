	.data
i: .word 0
j: .word 4
k: .word 8
l: .word 12
m: .word 16
s0: .word 20
	.text
	.globl main
main:	nop
	la $gp, data_start
	li $s7, 1
	move $s0, $s7
	sw $s0, 0($gp)
	li $t0, 2
	move $s1, $t0
	sw $s1, 4($gp)
	li $t1, 3
	move $s2, $t1
	sw $s2, 8($gp)
	li $t2, 4
	move $s3, $t2
	sw $s3, 12($gp)
	lw $s0, 0($gp)
	lw $a0, 0($gp)
	li $t3, 7
	add $t4, $s0, $t3
	move $a0, $t4
	move $s4, $t4
	sw $s4, 16($gp)
	lw $s4, 16($gp)
	lw $a0, 16($gp)
	li $v0, 1
	syscall
	lw $s3, 12($gp)
	lw $a0, 12($gp)
	li $t5, 5
	sub $t6, $s3, $t5
	move $a0, $t6
	move $s5, $t6
	sw $s5, 20($gp)
	lw $s5, 20($gp)
	lw $a0, 20($gp)
	li $v0, 1
	syscall
	lw $s1, 4($gp)
	lw $a0, 4($gp)
	lw $s2, 8($gp)
	lw $a0, 8($gp)
	mul $t7, $s1, $s2
	move $a0, $t7
	lw $s3, 12($gp)
	lw $a0, 12($gp)
	mul $t8, $t7, $s3
	move $a0, $t8
	li $v0, 1
	syscall
	li $v0, 10
	syscall
.data
data_start:
