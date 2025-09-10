.equ LPAREN, 40
.equ RPAREN, 41
.equ LBRACKET, 91
.equ RBRACKET, 93
.equ LBRACE, 123
.equ RBRACE, 125

.data
	input_str: .asciz "([])"
	format_char: .asciz "\n%c\n"
	format_int: .asciz "\n%ld\n"

.text

.global main
main:
	enter $0, $0

	leaq input_str(%rip), %rdi
	call printf

	# get length of input sequence
	leaq input_str(%rip), %rdi
	call strlen

	mov %rax, %r13		# length of string in r13
	call parenthesis

	leave
	ret

parenthesis:
	enter $0, $0

parenthesis_loop:
	testq %r13, %r13
	jz loop_end

	#
	mov input_str(%rip), %rdi
	mov %r13, %rsi
	call nth_string

	# print it
	movq format_char(%rip), %rdi
	movzbq %al, %rsi
	call printf

	# n-th string is now stored in rax, so push it to the stack
	pushq %rax
	dec %r13

skip_char:
	incq %r12
	decq %r13
	jmp parenthesis_loop

loop_end:
	leave
	ret

nth_string:
	add %rsi, %rdi
	movb (%rdi), %al
	ret

