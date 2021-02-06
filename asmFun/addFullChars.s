.text

.global addFullChars 
#.type addFullChars , @function

#int addFullChars (unsigned char*, int, unsigned char*, int, unsigned char*);
# UWAGA FUNKCJA NIE ZWRACA DŁUGOŚCI WYNIKU, TYLKO CZY ZWIĘKSZYŁA SIĘ ONA W STOSUNKU DO DŁUŻSZEJ LICZBY
addFullChars:
  push %rbp 
  movq %rsp, %rbp
  pushq %rbx

  #movq %rdi, number1
  #movq %rsi, 
  #movq %rdx, number2
  #movq %rcx,
  # RCX, RDX, R8, R9, STOS
  movq %rcx, %rdi
  movq %rdx, %rsi
  movq %r8, %rdx
  movq %r9, %rcx
  movq 48(%rbp), %r8 #->

  cmpq %rcx, %rsi
    jl smaller1
  
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
  movq %rsi, %r10
  decq %rcx           # Zmniejszenie licznika mniejszej liczby (size - 1 = lastindex)
  clc

  cmpq $0, %rcx
    je after
  
  addNumbers:
    decq %r8
    decq %rsi
    movb (%r9, %rsi, 1), %al
    adcb (%rbx, %rcx, 1), %al
    movb %al, (%r8)
  loop addNumbers
    after:
    decq %r8
    decq %rsi
    movb (%r9, %rsi, 1), %al
    adcb (%rbx, %rcx, 1), %al
    movb %al, (%r8)

  jnc then1
  jc then2
  
  then1:
  cmpq $0, %rsi
    je end
  movq %rsi, %rcx
  decq %rcx
  cmpq $0, %rcx
    je after2
  jmp addRestNumbers
  then2:
  cmpq $0, %rsi
    je endOV
  movq %rsi, %rcx
  decq %rcx
  cmpq $0, %rcx
    je after2stc
  stc
  addRestNumbers:
    decq %r8
    movb $0, %al
    adcb (%r9, %rcx, 1), %al
    movb %al, (%r8)
  loop addRestNumbers
  jmp after2
  after2stc:
  stc
  after2:
    decq %r8
    movb $0, %al
    adcb (%r9, %rcx, 1), %al
    movb %al, (%r8)
  jnc end
  jmp endOV

end:
    movq %r10, %rax
    jmp exit

endOV:
  movq %r10, %rcx
  movq %r10, %rax

hop:
  decq %r10
  movb (%r8, %r10, 1), %bl
  movb %bl, (%r8, %rcx, 1)
  loop hop
  movb $1, (%r8, %rcx, 1)
  incq %rax

exit:
  popq %rbx
  movq %rbp, %rsp
  pop %rbp
  ret
