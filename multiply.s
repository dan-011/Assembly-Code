        .globl  main

        .text
main:   
        addi    a7, x0, 5
        ecall
        mv      s1, a0		# a in s1

        addi    a7, x0, 5
        ecall
        mv      s2, a0		# b in s2
	
	add a0, x0, s1
	add a1, x0, s2
	jal ra, multiply
	add s1, x0, a0
        li  a7, 1        
    	add a0, s1, x0 
    	ecall
        
exit:   addi    a7, x0, 10 
        ecall

multiply:
	# a0 <-
	# a1 ->
	addi t0, x0, 1
	add s0, x0, x0
	loop:
		and t1, t0, a1
		beq t1, x0, skip
		add s0, a0, s0
		skip:
		slli a0, a0, 1
		srli a1, a1, 1
		bne a1, x0, loop
	add a0, x0, s0
	jalr x0, 0(ra)
#divide:
	