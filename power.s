.data
	welcome_txt:  .asciz "\n\t\033[34mWelcome to powers in assembly!\n\033[0m"  # blue text
	base_txt:     .asciz "\tEnter base: "
	exp_txt:      .asciz "\tEnter exponent: "
	input_format: .asciz "%ld"
	answer_txt:   .asciz "\t\033[32m\033[1mAnswer: %ld^%ld = %ld\n\n\033[0m\033[0m"  # bold green text

	base: .quad 0
	exp:  .quad 0

.text

.global main
main:
	# prologue
	enter $0, $0					# implicit prologue									

	# welcome text
	leaq welcome_txt(%rip), %rdi	# pass address of the welcome text	
	call printf						# call printf

	# ask base
	leaq base_txt(%rip), %rdi		# pass address of ask base question
	call printf						# call printf
	call flush						# calling flush forces to write buffer to the output terminal

	# capture base
	leaq input_format(%rip), %rdi	# pass address of input format string (usually "%lu")
	leaq base(%rip), %rsi			# pass address of ask base to capture it
	call scanf						# call scanf

	# ask exponent
	leaq exp_txt(%rip), %rdi		# pass address of the ask exponent text
	call printf						# call printf
	call flush						# call flush

	# capture exponent
	leaq input_format(%rip), %rdi	# pass address of input format
	leaq exp(%rip), %rsi			# pass address of exponent variable to capture
	call scanf						# call scanf

	call power
	
	leaq answer_txt(%rip), %rdi
	mov base(%rip), %rsi
	mov exp(%rip), %rdx
	mov %rax, %rcx
	call printf

	leave
	ret# implicit epilogue

power:							# this init arguments for the power calculation
	enter $0, $0

	movq $1, %rax					# set %rax (the answer of power) to 1
	movq exp(%rip), %rcx			# set %rcx (loop counter) to 0
	movq base(%rip), %rdi			# set first argument (of power) to base 

power_loop:	
	mulq %rdi						# multiply result with base (gets executed exp times)
	loop power_loop

power_finished:
	leave
	ret

flush:
	enter $0, $0
	xor %rdi, %rdi					# set %rdi to 0 (flush parameter)
	call fflush						# call flush
	leave							# restore base pointer etc.
	ret								# jump back to where flush was called from

