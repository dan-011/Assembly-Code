#       CSE 3666 Lab 3

        .globl  main

        .text
	
main:   
        addi    a7, x0, 5
        ecall
        mv      s1, a0		# a in s1

        addi    a7, x0, 5
        ecall
        mv      s2, a0		# b in s2

        addi	a7, x0,5	# c in s3
        ecall
        mv	s3, a0
        	
    
        # compute median3(a, b, c) and print it
        jal ra, median3    	   # go to the function median and save the address of the following instruction (PC+4) in register ra
        print:
        	li  a7, 1          # load immediate 1 (print integer) into register a7
    		add a0, s4, x0     # load register s4 into into argument register a0 by adding it with 0 (this is what will be printed)
    		ecall
        
exit:   addi    a7, x0, 10 
        ecall
median3:
	bge s2, s1, b_ge_a # if b >= a, go to that branch
	bge s2, s3, b_ge_c # if b >= c, go to that branch
	bge s1, s2, a_ge_b # if a >= b, go to that branch
	bge s1, s3, a_ge_c # if a >= c, go to that branch
	bge s3, s1, c_ge_a # if c >= a, go to that branch
	bge s3, s2, c_ge_b # if c >= b, go to that branch
	
	b_ge_a:
		bge s1, s3, c_a_b 	# if b >= a and a >= c, then go to the branch for the ordering c,a,b
		bge s2, s3, b_ge_c 	# when the ordering isn't c,a,b then in the other case b may be greater than c, then it's a different ordering, so move to that branch
		bge s3, s2, c_ge_b 	# when the ordering isn't c,a,b then in the other case c may be greater than b, then it's a different ordering, so move to that branch
	b_ge_c:
		bge s3, s1, a_c_b 	# if b >= c and c >= a, then go to the branch for the ordering a,c,b
		bge s1, s2, a_ge_b	# when the ordering isn't a,c,b then in the other case a may be greater than b, then it's a different ordering, so move to that branch
		bge s2, s1, b_ge_a	# when the ordering isn't a,c,b then in the other case b may be greater than a, then it's a different ordering, so move to that branch
	a_ge_b:
		bge s2, s3, c_b_a 	# if a >= b and b >= c, then go to the branch for the ordering c,b,a
		bge s1, s3, a_ge_c	# when the ordering isn't c,b,a then in the other case a may be greater than c, then it's a different ordering, so move to that branch 
		bge s3, s1, c_ge_a	# when the ordering isn't c,b,a then in the other case c may be greater than a, then it's a different ordering, so move to that branch 
	a_ge_c:
		bge s3, s2, b_c_a	# if a >= c and c >= b, then go to the branch for the ordering b,c,a
		bge s1, s2, a_ge_b	# when the ordering isn't b,c,a then in the other case a may be greater than b, then it's a different ordering, so move to that branch 
		bge s2, s1, b_ge_a	# when the ordering isn't b,c,a then in the other case b may be greater than a, then it's a different ordering, so move to that branch 
		
	c_ge_b:
		bge s2, s1, a_b_c 	# if c >= b and b >= a, then go to the branch for the ordering a,b,c
		bge s3, s1, c_ge_a	# when the ordering isn't a,b,c then in the other case c may be greater than a, then it's a different ordering, so move to that branch 
		bge s1, s3, a_ge_c	# when the ordering isn't a,b,c then in the other case a may be greater than c, then it's a different ordering, so move to that branch 
	
	c_ge_a:
		bge s1, s2, b_a_c 	# if c >= a and a >= b, then go to the branch for the ordering b,a,c
		bge s2, s1, b_ge_a	# when the ordering isn't b,a,c then in the other case b may be greater than a, then it's a different ordering, so move to that branch 
		bge s1, s2, a_ge_b	# when the ordering isn't b,a,c then in the other case a may be greater than b, then it's a different ordering, so move to that branch 
	
	a_b_c:
		add s4, x0, s2		# When the ordering is a,b,c, b is the median, so load its value into register s4
		jalr x0, 0(ra)		# Return to the instruction whose address is in register ra (the address of the instruction after the function call)
	a_c_b:
		add s4, x0, s3		# When the ordering is a,c,b, c is the median, so load its value into register s4
		jalr x0, 0(ra)		# Return to the instruction whose address is in register ra (the address of the instruction after the function call)
	b_a_c:
		add s4, x0, s1		# When the ordering is b,a,c, a is the median, so load its value into register s4
		jalr x0, 0(ra)		# Return to the instruction whose address is in register ra (the address of the instruction after the function call)
	b_c_a:
		add s4, x0, s3		# When the ordering is b,c,a, c is the median, so load its value into register s4
		jalr x0, 0(ra)		# Return to the instruction whose address is in register ra (the address of the instruction after the function call)
	c_a_b:
		add s4, x0, s1		# When the ordering is c,a,b, a is the median, so load its value into register s4
		jalr x0, 0(ra)		# Return to the instruction whose address is in register ra (the address of the instruction after the function call)
	c_b_a:
		add s4, x0, s2		# When the ordering is c,b,a, b is the median, so load its value into register s4
		jalr x0, 0(ra)		# Return to the instruction whose address is in register ra (the address of the instruction after the function call)
