section .data
	shebang:	db "#!"
	comment:	db "# Samuel Conry-Murray 9/3/2025"
	clear:		db 27, "[H",27,"[2J",27,"[3J"
	menu:
		db "1. Display the default gateway",10
		db "2. Test Local Connectivity",10
		db "3. Test Remote Connectivity",10
		db "4. Test DNS Resolution",10
		db "5. Exit the script",10
	menuLen		equ $-menu
	null:		db 0
	bash:	db "/usr/bin/bash",0
	arg1:	db "-c",0
	localArg:	db "ping -c 1 $("
	gateArg:	db "/usr/sbin/ip r | grep -m 1 -o -E -e ",34,"[0-9]{1,3}",92,".[0-9]{1,3}",92,".[0-9]{1,3}",92,".[0-9]{1,3}",34
			db " | grep -m 1 -o -E -e ",34,"[0-9]{1,3}",92,".[0-9]{1,3}",92,".[0-9]{1,3}",92,".[0-9]{1,3}",34
	crucial:	db 0
			db " &>/dev/null && echo ",34,"Local connection is good",34," || echo ",34,"Local connection is bad",34,0
	remoteArg:	db "ping -c 1 129.21.3.17 &>/dev/null && echo ",34,"Remote connection is good",34," || echo ",34,"Remote connection is bad",34,0
	dnsArg:		db "ping -c 1 google.com &>/dev/null && echo ",34,"DNS is working",34," || echo ",34,"DNS is not working",34,0

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
	mov	rax, bash
	mov	qword [argv], rax
	mov	rax, arg1
	mov	qword [argv+8], rax
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, clear
	mov	rdx, 11
	syscall

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
	mov	rax, gateArg
	mov	qword [argv+16], rax
	jmp	exec
local:
	mov	rax, localArg
	mov	qword [argv+16], rax
	mov	byte [crucial], 41
	jmp	exec

remote:
	mov	rax, remoteArg
	mov	qword [argv+16], rax
	jmp	exec

dns:
	mov	rax, dnsArg
	mov	qword [argv+16], rax
	jmp	exec

exec:
	mov	rax, 59
	mov	rdi, bash
	mov	rsi, argv
	mov	rdx, envp
	syscall

exit:
	mov	rax, 60
	mov	rdi, 0
	syscall


