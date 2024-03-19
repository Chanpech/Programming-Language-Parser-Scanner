	.data
i: .word 0
j: .word 4
	.text
	.globl main
main:	nop
	la $gp, data_start
	li $s3, 1
	move $s0, $s3
	sw $s0, 0($gp)
	li $s4, 0
	move $s1, $s4
	sw $s1, 4($gp)
	lw $s0, 0($gp)
	lw $a0, 0($gp)
	li $v0, 1
	syscall
	lw $s1, 4($gp)
	lw $a0, 4($gp)
	not $s5, $s1
	move $a0, $s5
	li $v0, 1
	syscall
	lw $s1, 4($gp)
	lw $a0, 4($gp)
	li $v0, 1
	syscall
	lw $s0, 0($gp)
	lw $a0, 0($gp)
	not $s6, $s0
	move $a0, $s6
	li $v0, 1
	syscall
	lw $s0, 0($gp)
	lw $a0, 0($gp)
	li $v0, 1
	syscall
	lw $s1, 4($gp)
	lw $a0, 4($gp)
	not $s7, $s1
	move $a0, $s7
	li $v0, 1
	syscall
	li $v0, 10
	syscall
.data
data_start:
