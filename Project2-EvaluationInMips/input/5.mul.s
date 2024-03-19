	.data
i: .word 0
j: .word 4
k: .word 8
l: .word 12
	.text
	.globl main
main:	nop
	la $gp, data_start
	li $s5, 10
	li $s6, 20
	mul $s7, $s5, $s6
	move $a0, $s7
	li $v0, 1
	syscall
	li $t0, 7
	move $s0, $t0
	sw $s0, 0($gp)
	li $t1, 3
	move $s2, $t1
	sw $s2, 8($gp)
	li $t2, 4
	move $s3, $t2
	sw $s3, 12($gp)
	lw $s0, 0($gp)
	lw $s2, 8($gp)
	mul $t3, $s0, $s2
	move $a0, $t3
	lw $s3, 12($gp)
	mul $t4, $t3, $s3
	move $a0, $t4
	move $s1, $t4
	sw $s1, 4($gp)
	lw $s1, 4($gp)
	li $v0, 1
	syscall
	li $v0, 10
	syscall
.data
data_start:
