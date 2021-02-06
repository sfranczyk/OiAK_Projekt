.text

.global absFullChars 
#.type absFullChars , @function

#int absFullChars (unsigned char*, int, unsigned char*, int, unsigned char*);
absFullChars:
push %rbp 
  movq %rsp, %rbp
  pushq %rbx
  pushq %r12
  pushq %r13

  #movq %rdi, number1
  #movq %rsi, 
  #movq %rdx, number2
  #movq %rcx,
  movq %rcx, %rdi
  movq %rdx, %rsi
  movq %r8, %rdx
  movq %r9, %rcx
  movq 48(%rbp), %r8

  cmpq %rcx, %rsi
    jl smaller1
    jg smaller2

  xorq %r10, %r10
  spr:
    movb (%rdi, %r10, 1), %al
    cmpb %al, (%rdx, %r10, 1)
      jl smaller2
      jg smaller1
    incq %r10
    cmpq %rcx, %r10
      jne spr
    movq $1, %rax
    movb $0, (%r8)
    jmp exit
  
  smaller2:
  movq %rdi, %r9        # Liczba większa trafia do %R9
  movq %rdx, %rbx       # Liczba mniejsza trafia do %RBX
  jmp before


  smaller1:
  movq %rcx, %rbx       # Zamiana miejscami długości większej i mniejszej 
  movq %rsi, %rcx
  movq %rbx, %rsi
  movq %rdi, %rbx
  movq %rdx, %r9
  
  before:
  addq %rsi, %r8      # Przesunięcie wskaźnika tablicy wyniku
  movq %rsi, %r11
  decq %rcx           # Zmniejszenie licznika mniejszej liczby (size - 1 = lastindex)
  clc

  cmpq $0, %rcx
    je after

  subNumbers:
    decq %r8
    decq %rsi
    movb (%r9, %rsi, 1), %al
    movb %al, (%r8)
    movb (%rbx, %rcx, 1), %al
    sbbb %al, (%r8)
  loop subNumbers
  after:
    decq %r8
    decq %rsi
    movb (%r9, %rsi, 1), %al
    movb %al, (%r8)
    movb (%rbx, %rcx, 1), %al
    sbbb %al, (%r8)

  jnc then1
  jc then2
  
  then1:
  cmpq $0, %rsi
    je end
  movq %rsi, %rcx
  decq %rcx
  cmpq $0, %rcx
    je after2
  jmp subRestNumbers
  then2:
  cmpq $0, %rsi
    je end
  movq %rsi, %rcx
  decq %rcx
  cmpq $0, %rcx
    je after2
  jmp subRestNumbers
  stc

  subRestNumbers:
    decq %r8
    movb (%r9, %rcx, 1), %al
    movb %al, (%r8)
    sbbb $0, (%r8)
  loop subRestNumbers
  after2:
    decq %r8
    movb (%r9, %rcx, 1), %al
    movb %al, (%r8)
    sbbb $0, (%r8)

end:
  #mov %r11, %rsi
  #mov %r8, %rdi
  mov %r11, %rdx
  mov %r8, %rcx
  call removezeros
  addq $16, %rsp

exit:
  popq %r13
  popq %r12
  popq %rbx
  movq %rbp, %rsp
  pop %rbp
  ret
