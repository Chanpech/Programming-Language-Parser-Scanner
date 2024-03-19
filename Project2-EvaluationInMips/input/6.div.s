	.data
i: .word 0
j: .word 4
k: .word 8
l: .word 12
	.text
	.globl main
main:	nop
	la $gp, data_start
	li $s5, 51
	li $s6, 17
	div $s5, $s6
	mflo $s7
	move $a0, $s7
	li $v0, 1
	syscall
	li $t0, 100
	move $s0, $t0
	sw $s0, 0($gp)
	li $t1, 2
	move $s2, $t1
	sw $s2, 8($gp)
	li $t2, 5
	move $s3, $t2
	sw $s3, 12($gp)
	lw $s0, 0($gp)
	lw $s2, 8($gp)
	div $s0, $s2
	mflo $t3
	move $a0, $t3
	lw $s3, 12($gp)
	div $t3, $s3
	mflo $t4
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
