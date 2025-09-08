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

	leave							# implicit epilogue

pow_init:							# this init arguments for the power calculation
	# pow_loop needs:
	# - %rcx for loop counter (starts equal to the exponent)
	# - %rdi for base
	sub $8, %rsp
	call printf
	movq $1, %rax					# set %rax (the answer of power) to 1
	movq exp(%rip), %rcx			# set %rcx (loop counter) to 0
	movq base(%rip), %rdi			# set first argument (of power) to base 

pow_loop:							# this is the self-referential loop
	mulq %rdi						# multiply result with base (gets executed exp times)
	dec %rcx						# decrease the counter by 1
	jnz pow_loop					# if zero flag (affected by dec) is NOT flagged, then repeat pow_loop
	
pow_finished:
	enter $0, $0					# prologue

	leaq answer_txt(%rip), %rdi		# pass answer template to print
	movq base(%rip), %rsi			# pass the inputted base
	movq exp(%rip), %rdx			# pass the inputted exponent
	movq %rax, %rcx					# pass the %rax (return value of power)
	call printf						# call printf

	leave							# epilogue
	ret

	xor %rdi, %rdi					# set exit param to 0
	call exit						# exit

flush:
	enter $0, $0
	xor %rdi, %rdi					# set %rdi to 0 (flush parameter)
	call fflush						# call flush
	leave							# restore base pointer etc.
	ret								# jump back to where flush was called from

