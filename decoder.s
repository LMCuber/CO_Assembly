.data
	format_chr: .asciz "{{ %c }}\n"					# debug format for testing chars
	format_int: .asciz "\t next addr: [[ %lu ]]\n"	# debug format for integers (unsigned)
	format_chr_2: .asciz "{{ %c, %lu}}\n"			# debug format for 1 char 1 int

	welcome_txt: .asciz "The decoded message is: "  # shows decoded string
	format_decoded_chr: .asciz "%c"
	
	newline: .asciz "\n"

.text
	
.include "memory_data.s"

.global main
main:
	enter $0, $0									# prologue

	leaq welcome_txt(%rip), %rdi					# pass welcome text as first argument to printf
	call printf										# call printf
	call flush

	leaq MESSAGE(%rip), %rdi						# pass message pointer to %rdi
	call decode										# call the main decode subroutine

	leaq newline(%rip), %rdi						# after printing characters without newlines, add one newline to print
	call printf										# call printf

	leave											# epilogue
	
	mov $0, %rdi									# 0 as exit code for exit
	call exit										# finish execution

# params:
# %rdi: string message to decode
# %rbx: the current byte address
decode:
	enter $0, $0

	# initialize quad offset at 0
	mov $0, %rbx

	traverse:
		# print message number of times necessary
		call print_char_n

		# jump to next memory address
		leaq MESSAGE(%rip), %rdx
		mov $0, %rsi
		movl 2(%rdx, %rbx, 8), %ebx
		
		cmp $0, %rbx
		jne traverse

	leave
	ret

# params:
# %rdi: temporary storage for the entire message (to offset and get chunks from it)
# %rbx (a global register, managed by main): the current offset from the MESSAGE in quadwords. Basically the current memory address at the message.
# %r12: (caller saved) loop counter
print_char_n:
	enter $0, $0

	leaq MESSAGE(%rip), %rdx					# TEMPORARILY save the message in %rdx
	mov $0, %r12								# clear %r12
	movb 1(%rdx, %rbx, 8), %r12b				# set lowest byte to the number of times to repeat print

	repeat:
		leaq MESSAGE(%rip), %rdx				# TEMPORARILY save the message in %rdx
		leaq format_decoded_chr(%rip), %rdi		# pass the character format to %rdi (first printf argument)
		mov $0, %rsi							# clear %rsi (second printf argument)
		movb (%rdx, %rbx, 8), %sil				# put the character to print into lowest byte of %rsi argument

		

		call printf								# print the character that we found

		dec %r12								# decrement the counter for number of times printing
		cmp $0, %r12							# check whether it's zero
		jg repeat								# if the counter is > 0, then loop again
	
	leave										# epilogue
	ret											# return to main to potentially do same for different address

flush:
	enter $0, $0								# prologue

	mov $0, %rdi								# put $0 in %rdi for flush
	call fflush									# call flush

	leave										# epilogue
	ret											# return back to where we came from 
