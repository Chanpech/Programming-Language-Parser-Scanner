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
	lw $s2, 8($gp)
	lw $a0, 8($gp)
	lw $s1, 4($gp)
	lw $a0, 4($gp)
	lw $s3, 12($gp)
	lw $a0, 12($gp)
	add $t2, $s1, $s3
	move $a0, $t2
	blt $s2, $t2 less_than_equal1
	li $t3 0
	j blt_done1
less_than_equal1:
	li $t3 1
blt_done1:
	move $a0, $t3
	move $s4, $t3
	sw $s4, 16($gp)
	lw $s4, 16($gp)
	lw $a0, 16($gp)
	li $v0, 1
	syscall
	lw $s0, 0($gp)
	lw $a0, 0($gp)
	lw $s3, 12($gp)
	lw $a0, 12($gp)
	mul $t4, $s0, $s3
	move $a0, $t4
	lw $s1, 4($gp)
	lw $a0, 4($gp)
	lw $s2, 8($gp)
	lw $a0, 8($gp)
	mul $t5, $s1, $s2
	move $a0, $t5
	bgt $t4, $t5 greater_than1
	li $t6 0
	j bgt_done1
greater_than1:
	li $t6 1
bgt_done1:
	move $a0, $t6
	li $v0, 1
	syscall
	li $v0, 10
	syscall
.data
data_start:
