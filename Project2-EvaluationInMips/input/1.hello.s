	.data
.string0: .asciiz "Hello world!"
	.text
	.globl main
main:	nop
	li $v0 4
	la $a0 .string0
	syscall
	li $v0, 10
	syscall
