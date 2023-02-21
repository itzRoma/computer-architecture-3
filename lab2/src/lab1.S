.global lab1
.syntax unified

#define VAR_A #5
#define VAR_B #2
#define VAR_C #3

// main function
lab1:
    push { lr }

    // pass arguments to calc function
    mov r0, VAR_A
    mov r1, VAR_B
    mov r2, VAR_C
    
    bl calc // call 'calc' function, after finishing return here

    pop { pc }

// function to calculate expression (a-b)*3 + 2^c
calc:
    push { r4, r5, r6, lr }
    
    sub r4, r0, r1 // (a-b)

    // next set of instructions will evaluate 2^c expression
    mov r5, #1 // use r5 to store the result of multiplication, initial value is 1
    mov r6, r2 // use r6 as a counter, initial value is r2 (VAR_C)
    loop:
        mul r5, r5, r1 // multiply by 2
        subs r6, r6, #1 // decrement r6
        bne loop // branch to loop if r6 is not zero

    adds r0, r4, r4, lsl #1 // (a-b)*3
    adds r0, r0, r5 // (a-b)*3 + 2^c

    pop { r4, r5, r6, pc }

