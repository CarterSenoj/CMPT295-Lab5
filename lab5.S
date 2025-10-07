    .section .note.GNU-stack,""
    .global fibonacci
    .global is_odd1
    .global is_odd2 
    .global mul1
    .global mul2
    .global polynomial1 
    .global polynomial2 
    .text

fibonacci:
# pushing reg for holding fib(n-1) results
push %r12
# keep looping while n > i
cmp $1, %rdi
jg fib_loop
mov %rdi, %rax
pop %r12
ret

fib_loop:
# push to hold current n 
push %rdi
sub $1, %rdi
call fibonacci
# hold total of fib(n-1)
mov %rax, %r12

# rdi is on the stack at its starting value
# so just reuse same looping as before with 
# n - 2
pop %rdi
sub $2, %rdi
call fibonacci

# %rax holders result of fib(n-2) so add result of fib(n-1)
add %r12, %rax
pop %r12
ret

polynomial1:
mov %rdi, %rax
imul %rdi, %rax
imul %rdi, %rax
imul %rsi, %rax

# %rax is holding a*x*x*x

mov %rdi, %r9
imul %rdi, %r9
imul %rdx, %r9
add %r9, %rax

# %rax now holds a*x*x*x + b*x*x

mov %rdi, %r9
imul %rcx, %r9
add %r9, %rax

#rax now holds a*x*x*x + b*x*x + c*x

add %r8, %rax

#rax now holds a*x*x*x + b*x*x + c*x + d

ret

polynomial2:
imul %rdi, %rsi
add %rdx, %rsi
imul %rdi, %rsi
add %rcx, %rsi
imul %rdi, %rsi
add %r8, %rsi
mov %rsi, %rax
ret

is_odd1:
# set divisor
mov $2, %r8
# move %rdi to dividend 
mov %rdi, %rax
# needed to use idiv. cant fill upper end with zeros like lab 4
# sign-extends %rax into %rdx
cqto
idiv %r8
# check remainder
cmp $1, %rdx
je odd

mov $0, %rax
ret

is_odd2:
mov $1, %r8
and %rdi, %r8
cmp $1, %r8
je odd

mov $0, %rax
ret

odd:
mov $1, %rax
ret

mul1:
mov $65537, %rax
mul %rdi
ret

mul2:
mov %rdi, %rax
# shift left by 16 bits
# which happens to multiply by 2^16
# shl $x, %rax shifts rax by that man bits left
# accomplishing %rax * 2^x
shl $16, %rax
# add one more x to get 65537 * n
add %rdi, %rax
ret