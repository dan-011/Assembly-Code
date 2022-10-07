# CSE 3666 Lab 4
        .globl  main            # declare main to be global

        .data                   #data segment

	# reserve space for 64 words
        .align 2
res:    .space   256

        .text                   # Code segment
main: 
        la      s1, signals

        # call function
        la	a0, res
        addi    a1, s1, 256	# change 0 to 256 for the second test
        li	a2, 64
        jal     ra, median_filter
 
        # exit
        li      a7, 10  
        ecall   

# function median_filter
# void median_filter(int C[], int D[], int n) 
median_filter : 
        #TODO
        # for (i = 0; i < n - 2; i = i + 1) 
        #     C[i] = median3(D[i], D[i+1], D[i+2]);
	
	# a1 is signals register
	# a0 is C register
	# a2 is n
	addi sp, sp, -4
	sw ra, 0(sp)
	li s4, 0	# i
	addi s5, a2, -2 # n - 2
	
	loop:
		bge s4, s5, end # if i >= n - 2, stop looping

		slli t0, s4, 2 	# i*4
		add t1, t0, a1 	# D[i] address
		add t2, t0, a0 	# C[i] address
		addi sp, sp, -16# shift down sp
		sw a0, 12(sp)	# push a0 into stack
		sw a1, 8(sp)	# push a1 into stack
		sw a2, 4(sp)	# push a2 into stack
		sw a3, 0(sp)	# push a3 into stack
		
		lw a0, 0(t1)	# load D[i] into a0
		lw a1, 4(t1)	# load D[i+1] into a1
		lw a2, 8(t1)	# load D[i+2] into a2
		jal ra, median3	# call median3
		sw a0, 0(t2)	# save the result, a0, into C[i]
		
		lw a3, 0(sp)	# pop the stack into a3
		lw a2, 4(sp)	# pop the stack into a2
		lw a1, 8(sp)	# pop the stack into a1
		lw a0, 12(sp)	# pop the stack into a0
		addi sp, sp, 16	# shift sp up
		addi s4, s4, 1	# increment i by 1
		beq x0, x0, loop# loop
	end:
	lw ra, 0(sp)		# pop the stack into ra
	addi sp, sp, 4		# shift up the stack pointer
        jr      ra		# go to the instruction after the function call (ra)

### median3
# int median3(int a, int b, int c);
# return the median of the 3 arguments
median3:
	#TODO
	# copy your lab3 code here
	bge a1, a0, b_ge_a # if b >= a, go to that branch
	bge a1, a2, b_ge_c # if b >= c, go to that branch
	bge a0, a1, a_ge_b # if a >= b, go to that branch
	bge a0, a2, a_ge_c # if a >= c, go to that branch
	bge a2, a0, c_ge_a # if c >= a, go to that branch
	bge a2, a1, c_ge_b # if c >= b, go to that branch
	
	b_ge_a:
		bge a0, a2, c_a_b 	# if b >= a and a >= c, then go to the branch for the ordering c,a,b
		bge a1, a2, b_ge_c 	# when the ordering isn't c,a,b then in the other case b may be greater than c, then it's a different ordering, so move to that branch
		bge a2, a1, c_ge_b 	# when the ordering isn't c,a,b then in the other case c may be greater than b, then it's a different ordering, so move to that branch
	b_ge_c:
		bge a2, a0, a_c_b 	# if b >= c and c >= a, then go to the branch for the ordering a,c,b
		bge a0, a1, a_ge_b	# when the ordering isn't a,c,b then in the other case a may be greater than b, then it's a different ordering, so move to that branch
		bge a1, a0, b_ge_a	# when the ordering isn't a,c,b then in the other case b may be greater than a, then it's a different ordering, so move to that branch
	a_ge_b:
		bge a1, a2, c_b_a 	# if a >= b and b >= c, then go to the branch for the ordering c,b,a
		bge a0, a2, a_ge_c	# when the ordering isn't c,b,a then in the other case a may be greater than c, then it's a different ordering, so move to that branch 
		bge a2, a0, c_ge_a	# when the ordering isn't c,b,a then in the other case c may be greater than a, then it's a different ordering, so move to that branch 
	a_ge_c:
		bge a2, a1, b_c_a	# if a >= c and c >= b, then go to the branch for the ordering b,c,a
		bge a0, a1, a_ge_b	# when the ordering isn't b,c,a then in the other case a may be greater than b, then it's a different ordering, so move to that branch 
		bge a1, a0, b_ge_a	# when the ordering isn't b,c,a then in the other case b may be greater than a, then it's a different ordering, so move to that branch 
		
	c_ge_b:
		bge a1, a0, a_b_c 	# if c >= b and b >= a, then go to the branch for the ordering a,b,c
		bge a2, a0, c_ge_a	# when the ordering isn't a,b,c then in the other case c may be greater than a, then it's a different ordering, so move to that branch 
		bge a0, a2, a_ge_c	# when the ordering isn't a,b,c then in the other case a may be greater than c, then it's a different ordering, so move to that branch 
	
	c_ge_a:
		bge a0, a1, b_a_c 	# if c >= a and a >= b, then go to the branch for the ordering b,a,c
		bge a1, a0, b_ge_a	# when the ordering isn't b,a,c then in the other case b may be greater than a, then it's a different ordering, so move to that branch 
		bge a0, a1, a_ge_b	# when the ordering isn't b,a,c then in the other case a may be greater than b, then it's a different ordering, so move to that branch 
	
	a_b_c:
		add a0, x0, a1		# When the ordering is a,b,c, b is the median, so load its value into register s4
		jalr x0, 0(ra)		# Return to the instruction whose address is in register ra (the address of the instruction after the function call)
	a_c_b:
		add a0, x0, a2		# When the ordering is a,c,b, c is the median, so load its value into register s4
		jalr x0, 0(ra)		# Return to the instruction whose address is in register ra (the address of the instruction after the function call)
	b_a_c:
		add a0, x0, a0		# When the ordering is b,a,c, a is the median, so load its value into register s4
		jalr x0, 0(ra)		# Return to the instruction whose address is in register ra (the address of the instruction after the function call)
	b_c_a:
		add a0, x0, a2		# When the ordering is b,c,a, c is the median, so load its value into register s4
		jalr x0, 0(ra)		# Return to the instruction whose address is in register ra (the address of the instruction after the function call)
	c_a_b:
		add a0, x0, a0		# When the ordering is c,a,b, a is the median, so load its value into register s4
		jalr x0, 0(ra)		# Return to the instruction whose address is in register ra (the address of the instruction after the function call)
	c_b_a:
		add a0, x0, a1		# When the ordering is c,b,a, b is the median, so load its value into register s4
		jalr x0, 0(ra)		# Return to the instruction whose address is in register ra (the address of the instruction after the function call)

        jr      ra

############## Do not change the initialized data
#data segment, constant
        .data                   #data segment
        .align 2
signals:        .word 
   341,    649,    733,    373,   -479,   -671,    985,    316,
   160,   1035,    324,   -186,   1556,   1592,   1135,   1798,
  1575,   1479,    239,   1106,    141,   1447,   1894,    322,
   460,    994,   1361,   1367,   1878,    491,   1263,   1420,
  1635,    200,     52,    327,   1578,   1365,    524,   1191,
   522,    -90,    666,   -436,   1492,   1288,   -586,   1168,
    11,   -660,   1051,   -714,   -509,    105,  -1053,    677,
   672,    258,    455,     89,   -900,   -733,   -835,    103,
 -1629,   -448,    -31,   -281,  -1104,  -1762,     65,   -910,
 -1563,  -1960,   -540,  -1210,  -1773,  -1918,  -1039,    -79,
  -293,  -1590,  -1523,  -1214,  -1033,  -1647,  -1746,    -96,
 -1356,   -465,  -1768,  -1722,  -1497,  -1211,   -722,    -80,
   202,    143,    570,   -722,    -11,    280,    283,    672,
  -636,    462,    956,   -727,    -43,    159,    476,    768,
  -490,   -109,   1405,    341,    899,    845,    526,   1412,
  1155,    422,    935,   1590,   1590,      4,    538,   1833,
   167,   1127,   1052,   1616,    985,    152,   1117,   1429,
   640,    172,   1129,    782,    520,    930,    867,    348,
  1182,    -14,    966,    781,    957,    995,    -47,   1147,
   703,    603,   -486,   -567,    975,   -246,   -468,    170,
   322,    538,    515,   -633,    209,   -773,    168,   -645,
  -243,    318,   -814,  -1264,  -1780,     46,   -482,  -1108,
 -1009,  -1643,   -303,   -126,    -67,    -45,  -1592,   -491,
 -2003,  -1385,   -426,  -1429,   -940,     10,  -1273,  -1054,
 -1562,  -1313,  -1108,   -856,   -495,   -254,   -555,   -905,
  -637,  -1487,   -735,   -806,  -1010,   -650,     72,    410,
   878,    911,    548,   -406,    486,   -392,   -636,   -563,
   633,    355,    454,   1552,     69,    679,   1491,   1274,
  1663,   1106,   1851,   1593,   1708,   1612,     31,    483,
  1227,   1700,   1466,    352,    129,    672,     99,    910,
  1542,    553,    -50,    456,    991,    153,   1130,    734,
  1073,   -276,    -18,    900,   1436,    748,   -139,    324
signals_end:
