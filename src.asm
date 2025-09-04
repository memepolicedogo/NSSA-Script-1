section .data
	menu:
		db "1. Display the default gateway",10
		db "2. Test Local Connectivity",10
		db "3. Test Remote Connectivity",10
		db "4. Test DNS Resolution",10
		db "5. Exit the script",10
	menuLen		equ $-menu
	gateFile:	db "/usr/bin/bash",0
	null:		db 0
	gateArg1:	db "-c",0
	gateArg2:	db "ip r | grep -m 1 -o -E -e ",34,"[0-9]{1,3}",92,".[0-9]{1,3}",92,".[0-9]{1,3}",92,".[0-9]{1,3}",34
			db " | grep -m 1 -o -E -e ",34,"[0-9]{1,3}",92,".[0-9]{1,3}",92,".[0-9]{1,3}",92,".[0-9]{1,3}",34,0
	tst		equ $-gateArg2

	; "ip r | grep -m 1 -o -E -e \"[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\" | grep -m 1 -o -E -e \"[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\""
	
section .bss
	input		resb 2
	envp		resq 1
	argv		resq 3
section .text
global _start
_start:
	mov	rax, null
	mov	qword [envp], rax
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, menu
	mov	rdx, menuLen
	syscall

	mov	rax, 0
	mov	rdi, 1
	mov	rsi, input
	mov	rdx, 2
	syscall

	sub	byte [input], 48

	cmp	byte [input], 1
	je	gateway
	cmp	byte [input], 2
	je	local
	cmp	byte [input], 3
	je	remote
	cmp	byte [input], 4
	je	dns
	jmp	exit

gateway:
	mov	rax, gateFile
	mov	qword [argv], rax
	mov	rax, gateArg1
	mov	qword [argv+8], rax
	mov	rax, gateArg2
	mov	qword [argv+16], rax
	mov	rax, 59
	mov	rdi, gateFile
	mov	rsi, argv
	mov	rdx, envp
	syscall
	jmp	exit

local:

	jmp	exit

remote:
	
	jmp	exit

dns:

	jmp	exit


exit:
	mov	rax, 60
	mov	rdi, 0
	syscall


