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
	enter $0, $0					# implicit prologue									

	# welcome text
	leaq welcome_txt(%rip), %rdi	# pass address of the welcome text	
	call printf						# call printf

	# ask base
	leaq base_txt(%rip), %rdi		# pass address of ask base question
	call printf						# call printf
	call flush						# calling flush forces to display buffer

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

	mov exp(%rip), %rcx				# set loop counter argument to exponent
	mov base(%rip), %rdi			# set rdi argument to base
	call power						# do the calculations and store in %rax
	call print_result				# after calculations, output the result

	# epilogue
	leave
	ret

# *****************************************************************************
# * power calculations
# * the power, power_loop, power_finished act like 1 subroutine, hence        *
# * there being 1 enter, 1 leave and 1 ret (stack stays aligned).			  *
# *****************************************************************************
power:
	enter $0, $0
	movq $1, %rax					# set %rax (the answer of power) to 1

power_loop:	
	mul %rdi						# multiply result with base
	loop power_loop					# short for:
									#	dec %rcx
									#	jnz power_loop
power_exit:
	leave							# clear the stack frame
	ret								# return to where we left off in main

flush:
	enter $0, $0
	xor %rdi, %rdi					# set %rdi to 0 (flush parameter)
	call fflush						# call flush
	leave							# restore base pointer and collapse frame
	ret								# jump back to where flush was called from

# prints the result
print_result:
	enter $0, $0					# prologue

	leaq answer_txt(%rip), %rdi		# answer as text argument to printf
	mov base(%rip), %rsi			# pass base
	mov exp(%rip), %rdx				# pass exponent
	mov %rax, %rcx					# pass previously calculated result
	call printf						# call printf

	leave							# collapse stack frame
	ret								# return to main

