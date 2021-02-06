.text

.global andFullChars 
#.type andFullChars , @function

#int andFullChars (unsigned char*, int, unsigned char*, int);
# UWAGA FUNKCJA ZWRACA CZY WYNIKIEM JEST 0 (WTEDY RAX =0 ELSE RAX=1)
andFullChars:
  push %rbp 
  movq %rsp, %rbp
  pushq %rbx
  pushq %r12
  pushq %r13

  #movq %rdi, number1
  #movq %rsi, 
  #movq %rdx, number2
  #movq %rcx,
  # RCX, RDX, R8, R9, STOS
   movq %rcx, %rdi
   movq %r9, %rcx

  decq %rcx           # Zmniejszenie licznika mniejszej liczby (size - 1 = lastindex)
  cmpq $0, %rcx
    je after
  cmpq $0, %rdx
      je after
  
  andNumbers:
    decq %rdx
    movb (%rdi, %rdx, 1), %al
    andb (%r8, %rcx, 1), %al

    cmpb $0, %al
      jne end1
    cmpq $0, %rdx
      je end0
  loop andNumbers
    after:
    decq %rdx
    movb (%rdi, %rdx, 1), %al
    andb (%r8, %rcx, 1), %al
    cmpb $0, %al
      jne end1

end0:
    xorq %rax, %rax
    jmp exit

end1:
  movq $1, %rax

exit:
  popq %r13
  popq %r12
  popq %rbx
  movq %rbp, %rsp
  pop %rbp
  ret
