BUFOR = 512

.data
tab: .space BUFOR
cbase: .byte 10


.text

.global fullCharToString
#.type fullCharToString , @function

#int fullCharToString (unsigned char*, int);
fullCharToString:
  push %rbp
  movq %rsp, %rbp
  pushq %rbx
  movq %rcx, %rdi
  movq %rdx, %rsi

  cmpq $0, %rcx
    je exit

  #%rcx/r9 - dlugosc liczby, %rdx/r8 - liczba
  movq %rcx, %r8
  movq %rdx, %r9

  xorq %rax, %rax
  xorq %rdi, %rdi
  xorq %rsi, %rsi
  xorq %r10, %r10

  movb cbase, %bl
divfullChar:
  movb (%r8, %rsi, 1), %al
  div %bl
  movb %al, (%r8, %rsi, 1)
  inc %rsi
  cmpq %rsi, %r9
    jg divfullChar

  movb %ah, tab(, %rdi, 1)
  inc %rdi

  cmpb $0, (%r8, %r10, 1)
    jne dalej
  
  incq %r10

dalej:
  cmpq %r10, %r9
    je end

  xorq %rax, %rax
  movq %r10, %rsi

  jmp divfullChar

end:
  xor %rsi, %rsi
  mov %rdi, %rax

toChar:
  dec %rdi
  movb tab(, %rdi, 1), %dl
  orb $0x30, %dl
  movb %dl, (%r8, %rsi, 1)
  inc %rsi
  cmpq $0, %rdi
    jg toChar
  

  movb $0, (%r8, %rsi, 1)
  inc %rax

exit:
  popq %rbx
  movq %rbp, %rsp
  pop %rbp
  ret
