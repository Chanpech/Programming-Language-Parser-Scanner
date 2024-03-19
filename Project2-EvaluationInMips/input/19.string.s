	.data
.string0: .asciiz "Your grader"
.string1: .asciiz "will put"
.string2: .asciiz "a random"
.string3: .asciiz "string here"
	.text
	.globl main
main:	nop
	la $gp, data_start
	li $v0, 4
	la $a0, .string0
	syscall
	li $v0, 4
	la $a0, .string1
	syscall
	li $v0, 4
	la $a0, .string2
	syscall
	li $v0, 4
	la $a0, .string3
	syscall
	li $v0, 10
	syscall
.data
data_start:
