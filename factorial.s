.data
	welcome_txt:  .asciz "\n\tWelcome to factorial in assembly!\n"  # blue text
	num_txt:	  .asciz "\tEnter number to factorialize: \n"	
	asd_txt: .asciz "\tChanged to: %lu"
	input_format: .asciz "%ld"

	num: .quad 0

.text

flush:
	enter $0, $0
	xor %rdi, %rdi
	call fflush
	leave
	ret

.globl main
main:
	# welcome text
	enter $0, $0

	mov $welcome_txt, %rdi
	call printf
	call flush

	mov $num_txt, %rdi
	call printf
	call flush

	mov $asd_txt, %rdi
	mov %rax, %rsi
	call printf
	call flush

	# finish
	mov $0, %rdi
	call exit

	leave
