	.data
i: .word 0
j: .word 4
k: .word 8
l: .word 12
	.text
	.globl main
main:	nop
	la $gp, data_start
	li $s5, 1
	move $s0, $s5
	sw $s0, 0($gp)
	li $s6, 0
	move $s1, $s6
	sw $s1, 4($gp)
	li $s7, 0
	move $s2, $s7
	sw $s2, 8($gp)
	li $t0, 1
	move $s3, $t0
	sw $s3, 12($gp)
	lw $s0, 0($gp)
	lw $s1, 4($gp)
	and $t1, $s0, $s1
	move $a0, $t1
	li $v0, 1
	syscall
	lw $s0, 0($gp)
	lw $s0, 0($gp)
	and $t2, $s0, $s0
	move $a0, $t2
	li $v0, 1
	syscall
	lw $s2, 8($gp)
	lw $s3, 12($gp)
	and $t3, $s2, $s3
	move $a0, $t3
	li $v0, 1
	syscall
	lw $s2, 8($gp)
	lw $s1, 4($gp)
	and $t4, $s2, $s1
	move $a0, $t4
	li $v0, 1
	syscall
	li $v0, 10
	syscall
.data
data_start:
