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
	li $s6, 2
	move $s1, $s6
	sw $s1, 4($gp)
	li $s7, 3
	move $s2, $s7
	sw $s2, 8($gp)
	li $t0, 4
	move $s3, $t0
	sw $s3, 12($gp)
	lw $s0, 0($gp)
	lw $s1, 4($gp)
	bgt $s0, $s1 greater_than1
	li $t1 0
	j bgt_done1
greater_than1:
	li $t1 1
bgt_done1:
	move $a0, $t1
	li $v0, 1
	syscall
	lw $s0, 0($gp)
	lw $s0, 0($gp)
	bge $s0, $s0 greater_than_equal1
	li $t2 0
	j bge_done1
greater_than_equal1:
	li $t2 1
bge_done1:
	move $a0, $t2
	li $v0, 1
	syscall
	lw $s3, 12($gp)
	lw $s2, 8($gp)
	bgt $s3, $s2 greater_than2
	li $t3 0
	j bgt_done2
greater_than2:
	li $t3 1
bgt_done2:
	move $a0, $t3
	li $v0, 1
	syscall
	lw $s1, 4($gp)
	lw $s2, 8($gp)
	bge $s1, $s2 greater_than_equal2
	li $t4 0
	j bge_done2
greater_than_equal2:
	li $t4 1
bge_done2:
	move $a0, $t4
	li $v0, 1
	syscall
	li $v0, 10
	syscall
.data
data_start:
