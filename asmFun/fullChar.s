BASE = 10
BUFOR = 512

.data
number_len: .quad 0      #wartość
size: .quad 0
cbase: .byte 2, 5, 6

.bss
tab: .space BUFOR


.text

.global fullChar
#.type fullChar , @function

#int fullChar (unsigned char*);
fullChar:
  push %rbp
  movq %rsp, %rbp
  pushq %rbx
  pushq %r12
  pushq %r13
  movq %rcx, %r8

  movq %rcx, %rax
  movq $0, %rcx
  movq %rcx, size
toValue:
  movb (%rax), %bl
  cmpb $0, %bl
	je endToValue
  andb $0xF, %bl
  movb %bl, (%rax)
  incq %rax
  incq %rcx
  jmp toValue
endToValue:
  movq %rcx, number_len

  cmpq $0, %rcx
    je exit

count:
  movq $3, %rbx
  movq number_len, %rax
  cmpq $2, %rax
    je end2
  cmpq $1, %rax
    je end1
  cmpq $0, %rax
    je end0

  xorq %rdx, %rdx
  xorq %rdi, %rdi

countsub1:
  movq %rbx, %rsi
  movq $3, %rcx
  clc

  subtract1:
    decq %rsi
    decq %rcx
    movb cbase(, %rcx, 1), %al
    sbbb %al, (%r8 , %rsi, 1)
    jnc then
      cmpq %rdi, %rsi
        je restore
      addb $BASE, (%r8 , %rsi, 1)
      stc
      jmp subtract1
    then:
      cmpq %rdi, %rsi
        jg subtract1
      incb %dl
      jmp countsub1

restore:
  movq %rbx, %rsi
  movq $3, %rcx
  decq %rsi
  decq %rcx

  addlastcredit:
    movb cbase(, %rcx, 1), %al
    addb %al, (%r8 , %rsi, 1)
    push %rsi
    cmpb $BASE, (%r8 , %rsi, 1)
      jl then2
    subb $BASE, (%r8 , %rsi, 1)
    decq %rsi
    addb $1, (%r8 , %rsi, 1)
    then2:
    pop %rsi
    decq %rsi
    decq %rcx
    cmpq $0, %rsi
      jnl addlastcredit

slide:
  movb %dl, tab(, %rdi, 1)
  xorq %rdx, %rdx
  incq %rdi

  incq %rbx
  movq number_len, %rax
  cmpq %rbx, %rax
    jl out


countsub2:
  movq %rbx, %rsi
  movq $3, %rcx
  clc

  subtract2:    # Odejmij
    decq %rsi
    decq %rcx
    movb cbase(, %rcx, 1), %al
    sbbb %al, (%r8, %rsi, 1)
    jnc then3
      cmpq %rdi, %rsi
        je checkcredit
      addb $BASE, (%r8 , %rsi, 1)
      stc
      jmp subtract2
    then3:
      cmpq %rdi, %rsi
        jg subtract2
      incb %dl  # Zwiększ licznik
      jmp countsub2

  checkcredit:
    dec %rsi
    movb (%r8 , %rsi, 1), %al
    cmpb $0, %al
      jng restore   # Jeśli nie można uzyskać pożyczki należy cofnąć działanie

  iscredit:
    decb (%r8 , %rsi, 1)
    inc %rsi
    addb $BASE, (%r8 , %rsi, 1)
    incb %dl
    jmp countsub2

out:
  movq number_len, %rsi
  sub $3, %rsi
  movb $BASE, %bl
  xorq %rax, %rax
  addb (%r8, %rsi, 1), %al
  mulb %bl
  incq %rsi
  addb (%r8, %rsi, 1), %al
  mul %bl
  incq %rsi
  addb (%r8, %rsi, 1), %al
  push %rax
  incq size

  xorq %rsi, %rsi
  moveall:
    movb tab( , %rsi, 1), %al
    movb %al, (%r8, %rsi, 1)
    incq %rsi
    cmpq %rsi, %rdi
      jg moveall

  movq %rdi, number_len
  jmp count


end2:
  movq $0, %rsi
  movb $10, %bl
  xorq %rax, %rax
  addb (%r8, %rsi, 1), %al
  mulb %bl
  incq %rsi
  addb (%r8, %rsi, 1), %al
  push %rax
  incq size
  jmp end0

end1:
  movq $0, %rsi
  xorq %rax, %rax
  addb (%r8, %rsi, 1), %al
  push %rax
  incq size
  jmp end0

end0:
  xorq %rsi, %rsi
  rewrite:
    pop %rax
    movb %al, (%r8, %rsi, 1)
    incq %rsi
    cmpq %rsi, size
      jg rewrite

  movq $-1, %rcx
  removezeros:
    incq %rcx
    cmpb $0, (%r8, %rcx, 1)
      je removezeros

  xorq %rsi, %rsi
  slicedigits:
    movb (%r8, %rcx, 1), %al
    movb %al, (%r8, %rsi, 1)
    incq %rcx
    incq %rsi
    cmpq size, %rcx
      jne slicedigits

  movq %rsi, %rax

exit:
  popq %r13
  popq %r12
  popq %rbx
  movq %rbp, %rsp
  pop %rbp
  ret
