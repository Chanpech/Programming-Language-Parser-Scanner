T: 0	.data
a: .word 0
.string0: .asciiz "input an integer:"
	.text
	.globl main
main:	nop
	la $gp, data_start
	li $v0, 4
	la $a0, .string0
	syscall
	li $v0, 5
	syscall
	sw $v0, a
	add $s3, $gp, 4
	lw $s4, 0($s3)
	li $a0, 0
	li $v0, 1
	syscall
	li $a0, 1
	li $v0, 1
	syscall
	lw $s6, 0($fp)
	sub $s5, $fp, 4
	lw $s7, 0($s5)
	add $t0, $s6, $s7
	move $a0, $t0
	li $v0, 1
	syscall
	li $a0, 3
	li $v0, 1
	syscall
	li $v0, 10
	syscall
.data
data_start:
