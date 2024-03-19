T: 0T: 1T: 2T: 3T: 4	.data
i: .word 0
j: .word 4
k: .word 8
l: .word 12
m: .word 16
n: .word 20
.string0: .asciiz "i = "
.string1: .asciiz "j = "
.string2: .asciiz "k = "
.string3: .asciiz "l = "
.string4: .asciiz "m = "
	.text
	.globl main
main:	nop
	la $gp, data_start
	li $v0, 4
	la $a0, .string0
	syscall
	li $v0, 5
	syscall
	sw $v0, i
	li $v0, 4
	la $a0, .string1
	syscall
	li $v0, 5
	syscall
	sw $v0, j
	li $v0, 4
	la $a0, .string2
	syscall
	li $v0, 5
	syscall
	sw $v0, k
	li $v0, 4
	la $a0, .string3
	syscall
	li $v0, 5
	syscall
	sw $v0, l
	li $v0, 4
	la $a0, .string4
	syscall
	li $v0, 5
	syscall
	sw $v0, m
	lw $s2, 8($gp)
	lw $a0, 8($gp)
	lw $s1, 4($gp)
	lw $a0, 4($gp)
	lw $s3, 12($gp)
	lw $a0, 12($gp)
	add $t4, $s1, $s3
	move $a0, $t4
	blt $s2, $t4 less_than_equal1
	li $t5 0
	j blt_done1
less_than_equal1:
	li $t5 1
blt_done1:
	move $a0, $t5
	lw $s0, 0($gp)
	lw $a0, 0($gp)
	lw $s2, 8($gp)
	lw $a0, 8($gp)
	bne $s0, $s2 not_equal1
	li $t6 0
	j bne_done1
not_equal1:
	li $t6 1
bne_done1:
	move $a0, $t6
	not $t7, $t6
	move $a0, $t7
	and $t8, $t5, $t7
	move $a0, $t8
	move $s5, $t8
	sw $s5, 20($gp)
	lw $s5, 20($gp)
	lw $a0, 20($gp)
	li $v0, 1
	syscall
	li $v0, 10
	syscall
.data
data_start:
