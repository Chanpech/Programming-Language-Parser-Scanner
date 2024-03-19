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
	blt $s0, $s1 less_than_equal1
	li $t2 0
	j blt_done1
less_than_equal1:
	li $t2 1
blt_done1:
	move $a0, $t2
	move $s4, $t2
	sw $s4, 16($gp)
	lw $s4, 16($gp)
	lw $a0, 16($gp)
	not $t3, $s4
	move $a0, $t3
	li $v0, 1
	syscall
	lw $s0, 0($gp)
	lw $a0, 0($gp)
	lw $s1, 4($gp)
	lw $a0, 4($gp)
	beq $s0, $s1 equal1
	li $t4 0
	j done1
equal1:
	li $t4 1
done1:
	move $a0, $t4
	li $v0, 1
	syscall
	lw $s0, 0($gp)
	lw $a0, 0($gp)
	lw $s0, 0($gp)
	lw $a0, 0($gp)
	beq $s0, $s0 equal2
	li $t5 0
	j done2
equal2:
	li $t5 1
done2:
	move $a0, $t5
	li $v0, 1
	syscall
	lw $s3, 12($gp)
	lw $a0, 12($gp)
	lw $s2, 8($gp)
	lw $a0, 8($gp)
	bgt $s3, $s2 greater_than1
	li $t6 0
	j bgt_done1
greater_than1:
	li $t6 1
bgt_done1:
	move $a0, $t6
	li $v0, 1
	syscall
	lw $s1, 4($gp)
	lw $a0, 4($gp)
	lw $s1, 4($gp)
	lw $a0, 4($gp)
	bge $s1, $s1 greater_than_equal1
	li $t7 0
	j bge_done1
greater_than_equal1:
	li $t7 1
bge_done1:
	move $a0, $t7
	li $v0, 1
	syscall
	lw $s2, 8($gp)
	lw $a0, 8($gp)
	lw $s0, 0($gp)
	lw $a0, 0($gp)
	ble $s2, $s0 less_than1
	li $t8 0
	j ble_done1
less_than1:
	li $t8 1
ble_done1:
	move $a0, $t8
	li $v0, 1
	syscall
	lw $s0, 0($gp)
	lw $a0, 0($gp)
	lw $s1, 4($gp)
	lw $a0, 4($gp)
	bne $s0, $s1 not_equal1
	li $t9 0
	j bne_done1
not_equal1:
	li $t9 1
bne_done1:
	move $a0, $t9
	li $v0, 1
	syscall
	li $v0, 10
	syscall
.data
data_start:
