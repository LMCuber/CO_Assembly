.data
	format_chr: .asciz "{{ %c }}\n"
	format_int: .asciz "[[ %lu ]]\n"
	format_chr_2: .asciz "{{ %c, %lu}}\n"
	hello: .asciz "Hello!\n"
	entering: .asciz "Entering: %lu\n"

.text
	
.include "memory_data.s"

.global main
main:
	enter $0, $0
	
	leaq MESSAGE(%rip), %rdi
	call decode

	leave
	ret

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
		
		leaq format_int(%rip), %rdi
		movl %ebx, %esi
		call printf

		cmp $0, %rbx
		jne traverse

	leave
	ret

# params:
# r12: (caller saved) loop counter
print_char_n:
	enter $0, $0

	leaq MESSAGE(%rip), %rdx					# save the message in %rdx
	mov $0, %r12								# clear %r12
	movb 1(%rdx, %rbx, 8), %r12b				# set lowest byte to the number of times to repeat print

	repeat:
		leaq MESSAGE(%rip), %rdx					# save the message in %rdx
		leaq format_chr(%rip), %rdi
		mov $0, %rsi							# clear %rsi (second printf argument)
		movb (%rdx, %rbx, 8), %sil				# put the character to print into lowest byte of %rsi argument

		call printf

		dec %r12
		cmp $0, %r12
		jg repeat

	leave
	ret

