.text

.global mulFullChars 
#.type mulFullChars, @function

#int mulFullChars (unsigned char*, int, unsigned char*, int, unsigned char*);
mulFullChars:
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

  movq %rsi, %r9
  addq %rcx, %r9
  xorq %r10, %r10
  xorq %r11, %r11 # Przechowuje liczbę przeniesień
  zerosOut:
    movb $0, (%r8, %r10, 1)
  incq %r10
  cmpq %r10, %r9
    jg zerosOut

  cmpq $1, %rcx
    jne noOneDigit
  cmpq %rcx, %rsi
    jne noOneDigit

  xorq %r9, %r9
  movb (%rdx, %r9, 1), %bl
  movb (%rdi, %r9, 1), %al
  mul %bl
  cmpb $0, %ah
   je notBigger
  movb %ah, %bl
  movb %bl, (%r8, %r9, 1)
  incq %r9
  movb %al, (%r8, %r9, 1)
  movq $2, %rax
  jmp exit

notBigger:
    movb %al, (%r8, %r9, 1)
    movq $1, %rax
      jmp exit

noOneDigit:
  push %r9
  movq %rcx, %r10
  subq %rsi, %r9
  firstLoop:            # multiplication of to big numbers
    movq %rsi, %rcx
    addq %rsi, %r9
    decq %r9
    decq %r10
    decq %rcx
    xorq %rax, %rax
    movb (%rdx, %r10, 1), %bl   # Przeniesienie cyfry mnożonej
    cmpq $0, %rcx
    je next
  secondLoop:                   # Mnożenie przez daną cyfrę
    movb (%rdi, %rcx, 1), %al
    mul %bl
    add %al, (%r8, %r9, 1)      # Dodawanie do wyniku
    decq %r9
    movb %ah, %al
    adcb %al, (%r8, %r9, 1)     # Dodawanie przeniesienia
    jnc a
    ac:         # Przeniesienia
    incq %r11
    decq %r9
    adcb $0, (%r8, %r9, 1)      # Dodawanie przeniesienia
    jc ac
    add %r11, %r9
    xorq %r11, %r11
    a:          # Brak przeniesień
  loop secondLoop
next:                           # Ostatnie mnożenie
    movb (%rdi, %rcx, 1), %al
    mul %bl
    add %al, (%r8, %r9, 1)
    decq %r9
    movb %ah, %al
    adcb %al, (%r8, %r9, 1)
    jnc b
    bc:
        incq %r11
        decq %r9
        adcb $0, (%r8, %r9, 1)
        jc bc
        add %r11, %r9
        xorq %r11, %r11
    b:
    cmpq $0, %r9
      jg firstLoop

  popq %rax

exit:
  popq %r13
  popq %r12
  popq %rbx
  movq %rbp, %rsp
  pop %rbp
  ret
