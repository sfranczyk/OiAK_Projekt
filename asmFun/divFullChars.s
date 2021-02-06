.text

.global divFullChars 
#.type divFullChars , @function

#int divFullChars (unsigned char*, int, unsigned char*, int, unsigned char*);
divFullChars:

  push %rbp
  movq %rsp, %rbp
  pushq %rbx
  pushq %r12
  pushq %r13

  #movq %rdi, number1
  #movq %rsi, - number1 size
  #movq %rdx, number2
  #movq %rcx, - number2 size
  #%r8
  movq %rcx, %rdi
  movq %rdx, %rsi
  movq %r8, %rdx
  movq %r9, %rcx
  movq 48(%rbp), %r8

  xorq %r12, %r12

  # number2/number1 = numberout + reszta
  # number2 -- number1
  cmpq %rsi, %rcx
    jl out

  xorq %r11, %r11
  movq %rsi, %r10
  movq %rsi, %rbx
  movq %rcx, %r13

countsub1:
  movq %rbx, %rsi
  movq %r10, %rcx
  decq %rcx
  cmpq $0, %rcx
    je after1
  clc
  subtract1:
    decq %rsi
    movb (%rdi , %rcx, 1), %al
    sbbb %al, (%rdx , %rsi, 1)
  loop subtract1
  after1:
  decq %rsi
  movb (%rdi , %rcx, 1), %al
  sbbb %al, (%rdx , %rsi, 1)

  jc restore
  incb %r11b
  jmp countsub1

restore:
  movq %rbx, %rsi
  movq %r10, %rcx
  decq %rcx
  cmpq $0, %rcx
    je afterRes
  clc

  addlastcredit:
    decq %rsi
    movb (%rdi , %rcx, 1), %al
    adcb %al, (%rdx , %rsi, 1)
    loop addlastcredit
    afterRes:
    decq %rsi
    movb (%rdi , %rcx, 1), %al
    adcb %al, (%rdx , %rsi, 1)

slide:
  movb %r11b, (%r8, %r12, 1)

  xorq %r11, %r11
  incq %r12
  incq %rbx
  cmpq %rbx, %r13
    jl out

countsub2:
  movq %rbx, %rsi
  movq %r10, %rcx
  decq %rcx
  cmpq $0, %rcx
    je after2
  clc

  subtract2:
    decq %rsi
    movb (%rdi , %rcx, 1), %al
    sbbb %al, (%rdx , %rsi, 1)
  loop subtract2
  after2:
  decq %rsi
  movb (%rdi , %rcx, 1), %al
  sbbb %al, (%rdx , %rsi, 1)
  jc checkcredit
  incb %r11b
  jmp countsub2

  checkcredit:
    decq %rsi
    movb (%rdx , %rsi, 1), %al
    cmpb $0, %al
      je restore

  iscredit:
    decb (%rdx , %rsi, 1)
    incb %r11b
    jmp countsub2
    
out:
  movq %r12, %rax   # Długość reszty z dzielenia

exit:
  popq %r13
  popq %r12
  popq %rbx
  movq %rbp, %rsp
  pop %rbp
  ret
