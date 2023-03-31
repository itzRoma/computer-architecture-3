.syntax unified
.cpu cortex-m4
.thumb

#define VAR_A #5
#define VAR_B #2
#define VAR_C #3

// Global memory locations.
.global vtable_kernel
.global __kernel_reset__

.type vtable_kernel, %object
.type __kernel_reset__, %function

.section .interrupt_vector
vtable_kernel:
    .word __stack_start
    .word __kernel_reset__+1
    .size vtable_kernel, .-vtable_kernel

.section .rodata
    data: .asciz "kernel started!\n"
    final: .asciz "Value in register #7: "
.section .text
__kernel_reset__:
    ldr r0, =data
    bl dbgput_line

    // calculate
    mov r0, VAR_A
    mov r1, VAR_B
    mov r2, VAR_C

    sub r3, r0, r1 // (a-b)

    // next set of instructions will evaluate 2^c expression
    mov r4, #1 // use r4 to store the result of multiplication, initial value is 1
    mov r5, r2 // use r5 as a counter, initial value is r2 (VAR_C)
    loop:
        mul r4, r4, r1 // multiply by 2
        subs r5, r5, #1 // decrement r6
        bne loop // branch to loop if r5 is not zero

    adds r6, r3, r3, lsl #1 // (a-b)*3
    adds r7, r6, r4 // (a-b)*3 + 2^c

    ldr r0, =final
    bl dbgput
    mov r0, r7
    bl dbgput_num

    end:
    b end
