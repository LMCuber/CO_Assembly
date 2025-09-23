.data
	welcome_txt: .asciz "The decoded message is: "  # shows decoded string
	format_decoded_chr_colored: .asciz "\033[38;5;%d;48;5;%dm%c"

	format_decoded_chr_reset: .asciz "\033[0m%c"
	format_decoded_chr_stopblink: .asciz "\033[25m%c"
	format_decoded_chr_bold: .asciz "\033[1m%c"
	format_decoded_chr_faint: .asciz "\033[2m%c"
	format_decoded_chr_conceal: .asciz "\033[8m%c"
	format_decoded_chr_reveal: .asciz "\033[28m%c"
	format_decoded_chr_blink:   .asciz "\033[5m%c"
	

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
		leaq MESSAGE(%rip), %r8
		mov $0, %rsi
		movl 2(%r8, %rbx, 8), %ebx
		
		cmp $0, %rbx
		jne traverse

	leave
	ret

# params:
# %rdi: the formatted text (result)
# %rsi: cmd
# %rdx: temporary storage for the entire message (to offset and get chunks from it)
# %rbx (a global register, managed by main): the current offset from the MESSAGE in quadwords. Basically the current memory address at the message.
# %r12: (caller saved) loop counter
print_char_n:
	enter $0, $0

	leaq MESSAGE(%rip), %r8					# TEMPORARILY save the message in %rdx
	mov $0, %r12								# clear %r12
	movb 1(%r8, %rbx, 8), %r12b				# set lowest byte to the number of times to repeat print

	repeat:
		leaq MESSAGE(%rip), %r8

		mov $0, %rsi
		movb 6(%r8, %rbx, 8), %sil

		mov $0, %rdx
		movb 7(%r8, %rbx, 8), %dl

		cmp %sil, %dl
		jne colored_output

		# effect
			# compares the given color to each possible case, jumping when it finds one or going to the standard endcase if it doesn't
			effect:				
			cmpb $0, %sil
			je reset
			cmpb $37, %sil
			je stopblink
			cmpb $42, %sil
			je bold
			cmpb $66, %sil
			je faint
			cmpb $105, %sil
			je conceal
			cmpb $153, %sil
			je reveal
			cmpb $182, %sil
			je blink
			jmp endcase
			reset:	
				leaq format_decoded_chr_reset(%rip), %rdi
				jmp endcase_effect

			stopblink:	
				leaq format_decoded_chr_stopblink(%rip), %rdi
				jmp endcase_effect

			bold:	
				leaq format_decoded_chr_bold(%rip), %rdi
				jmp endcase_effect

			faint:	
				leaq format_decoded_chr_faint(%rip), %rdi
				jmp endcase_effect

			conceal:	
				leaq format_decoded_chr_conceal(%rip), %rdi
				jmp endcase_effect

			reveal:	
				leaq format_decoded_chr_reveal(%rip), %rdi
				jmp endcase_effect
			
			blink:	
				leaq format_decoded_chr_blink(%rip), %rdi
				jmp endcase_effect
			
			
			endcase_effect:
				mov $0, %rsi
				movb (%r8, %rbx, 8), %sil
				jmp endcase

		colored_output:
			leaq format_decoded_chr_colored(%rip), %rdi

			mov $0, %rcx
			movb (%r8, %rbx, 8), %cl							# print the character that we found

		endcase:
			call printf
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
