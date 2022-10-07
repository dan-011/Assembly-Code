#       CSE 3666 uint2decstr

        .globl  main

	.data
	
str:	.space 100

        .text
main:   

	la	a0, str
        li	a1, -1		# test with different numbers
	jal	ra, uint2decstr

        la      a0, str
        addi    a7, x0, 4
        ecall

exit:   addi    a7, x0, 10      
        ecall
#char * uint2decstr(char *s, unsigned int v)
#{
# unsigned int r;
# if (v < 10) {
# r = v;
# }
# else {
# s = uint2decstr(s, v / 10);
# r = v % 10;
# }
# s[0] = '0' + r;
# s[1] = 0;
# return s + 1;
#}
# char * uint2decstr(char *s, unsigned int v) 
uint2decstr:
	addi sp, sp, -4 # shift stack down
	sw ra, 0(sp)	# push ra onto stack
	addi t0, x0, 10 # t0 gets 10
	bgeu a1, t0, else # if v >= 10, goto else
	add t1, a1, x0	# if v < 10, r = v
	beq x0, x0, endif # goto endif
	else:
		addi sp, sp, -8	# shift stack down
		sw t0, 4(sp)	# push t0 (10) onto the stack
		sw a1, 0(sp)	# push a1 (v) onto the stack
		divu a1, a1, t0	# set argument 1 t0 v/10
		jal ra, uint2decstr # call uint2decstr(s, v/10)
		lw a1, 0(sp)	# pop v into a1
		lw t0, 4(sp)	# pop 10 into t0
		addi sp, sp, 8	# shift up sp
		remu t1, a1, t0	# r = v%10
	endif:
		addi t1, t1, 48 # place '0' + r in t1
		sb t1, 0(a0)	# s[0] = r + '0'
		sb x0, 1(a0)	# s[1] = 0
		addi a0, a0, 1	# place s+1 intot he return register
		lw ra, 0(sp)	# pop ra from the stack
		addi sp, sp, 4	# shift up sp
		jalr x0, 0(ra)	# return to the instruction after the function call
	#jr	ra
