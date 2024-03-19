	.data
i: .word 0
j: .word 4
k: .word 8
l: .word 12
m: .word 16
	.text
	.globl main
main:	nop
	la $gp, data_start
	li $s6, 1
	move $s0, $s6
	sw $s0, 0($gp)
	li $s7, 2
	move $s1, $s7
	sw $s1, 4($gp)
	li $t0, 3
	move $s2, $t0
	sw $s2, 8($gp)
	li $t1, 4
	move $s3, $t1
	sw $s3, 12($gp)
	lw $s0, 0($gp)
	lw $a0, 0($gp)
	lw $s1, 4($gp)
	lw $a0, 4($gp)
	add $t2, $s0, $s1
	move $a0, $t2
	lw $s2, 8($gp)
	lw $a0, 8($gp)
	lw $s3, 12($gp)
	lw $a0, 12($gp)
	mul $t3, $s2, $s3
	move $a0, $t3
	add $t4, $t2, $t3
	move $a0, $t4
	li $v0, 1
	syscall
	lw $s0, 0($gp)
	lw $a0, 0($gp)
	lw $s3, 12($gp)
	lw $a0, 12($gp)
	lw $s0, 0($gp)
	lw $a0, 0($gp)
	sub $t5, $s3, $s0
	move $a0, $t5
	lw $s2, 8($gp)
	lw $a0, 8($gp)
	div $t5, $s2
	mflo $t6
	move $a0, $t6
	add $t7, $s0, $t6
	move $a0, $t7
	lw $s1, 4($gp)
	lw $a0, 4($gp)
	add $t8, $t7, $s1
	move $a0, $t8
	li $v0, 1
	syscall
	li $v0, 10
	syscall
.data
data_start:
