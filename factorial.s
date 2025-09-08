.data
	welcome_txt:  .asciz "\n\tWelcome to factorial in assembly!\n"  # blue text
	num_txt:	  .asciz "\tEnter number to factorialize: "	
	input_format: .asciz "%ld"

	num: .quad 0

.text

.global main
main:
	# prologue
	enter $0, $0					# implicit prologue									

	# welcome text
	leaq welcome_txt(%rip), %rdi	# pass address of the welcome text	
	call printf						# call printf

	# ask factorial
	leaq num_txt(%rip), %rdi
	call printf
	call flush

	# capture factorial
	leaq input_format(%rip), %rdi
	leaq num(%rip), %rsi
	call scanf

	leave

factorial_init:
	sub $8, %rsp
	leaq welcome_txt(%rip), %rdi
	call printf
	call flush

	xor %rdi, %rdi
	call exit

flush:
	enter $0, $0
	xor %rdi, %rdi
	call fflush
	leave
	ret
