.data
	welcome_txt:  .asciz "\n\tWelcome to powers in assembly!\n"
	second_txt: .asciz "\n\tSecond welcome!\n\n"

.text

.global main
main:
	# prologue
	enter $0, $0	

	# welcome text
	movq $welcome_txt, %rdi			# pass address of welcome text	
	call printf						# call printf

	call second

	leave							# implicit epilogue

	xor %rdi, %rdi					# set exit param to 0
	call exit						# exit


second:
	enter $0, $0

	leaq second_txt(%rip), %rdi
	call printf
	
	leave
	ret

