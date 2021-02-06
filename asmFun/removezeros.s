.text
.global removezeros 
#.type removezeros , @function

#int removezeros (unsigned char*, int);
removezeros:
push %rbp 
  movq %rsp, %rbp

  movq %rcx, %rdi
  movq %rdx, %rsi
  movq %rsi, %rax
  cmpq $1, %rax
      jle exit

  movq $-1, %rcx
  remove:                   # Liczenie zer
    incq %rcx
    cmpq %rsi, %rcx
      je next
    cmpb $0, (%rdi, %rcx, 1)
      je remove
    incq %rcx
next:
  xorq %rdx, %rdx
  decq %rcx
  slicedigits:              # Przesuwanie cyfr
    movb (%rdi, %rcx, 1), %al
    movb %al, (%rdi, %rdx, 1)
    incq %rcx
    incq %rdx
    cmpq %rsi, %rcx
      jne slicedigits
    
    movq %rdx, %rax

exit:
  cmpq $0, %rax
    jg exit2
  movb $0, (%rdi, %rax, 1)
  incq %rax
exit2:

  movq %rbp, %rsp
  pop %rbp
  ret
