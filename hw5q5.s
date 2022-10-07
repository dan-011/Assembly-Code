#       CSE 3666 dot-product

        .globl  main

        .text
main:   

	# Change the immeidate in ADDI to different values to test the code.
	# The following are expected results when the immediate is 64, 128, and 256  
	# 64:  16.51825
	# 128: 15.144777
	# 256: 16.001322
	
	la	a0, fvalues
	addi	a1, a0, 256	# change the immediate to test the results.
	li      a2, 64
	jal	dot_product
	
	li	a7, 2		# print float
        ecall

exit:   addi    a7, x0, 10      
        ecall

# float dot_product(float x[], float y[], int n)
#{
#float sum = 0.0;
#for (int i = 0; i < n; i += 1)
# sum += x[i] * y[i];
#return sum;
#}
#
dot_product:
	# TODO
	flw f10, 0(gp)		# sum (f10) = 0.0
	add t0, x0, x0		# i (t0) = 0
	beq x0, x0, test	# goto test
	loop:
		slli t1, t0, 2	# align i, i*4
		add t2, a0, t1	# offset a0 to get the address for x[i]
		flw f1, 0(t2)	# load x[i] into f1
		add t2, a1, t1	# offset a1 to get the adress for y[i]
		flw f2, 0(t2)	# load y[i] into f2
		fmul.s f1, f1, f2 # perform x[i]*y[i] and store it in f1
		fadd.s f10, f10, f1 # add x[i]*y[i] to sum and store the value in sum
		addi t0, t0, 1	# i = i + 1
	test:
		blt t0, a2, loop # if i < n, loop
	jr	ra

############### No need to change data
	.data
	.align 2
	

# 128 floats
fvalues:     .float   
0.062,	0.819,	0.266,	0.342,	0.659,	0.728,	0.067,	0.352,
0.367,	0.244,	0.368,	0.783,	0.281,	0.080,	0.160,	0.907,
0.519,	0.639,	0.614,	0.734,	0.463,	0.993,	0.709,	0.724,
0.501,	0.735,	0.846,	0.331,	0.103,	0.600,	0.244,	0.059,
0.655,	0.139,	0.586,	0.423,	0.090,	0.849,	0.527,	0.744,
0.097,	0.938,	0.388,	0.586,	0.160,	0.496,	0.127,	0.757,
0.041,	0.353,	0.638,	0.797,	0.776,	0.455,	0.437,	0.920,
0.225,	0.464,	0.180,	0.439,	0.284,	0.882,	0.831,	0.794,
0.398,	0.400,	0.664,	0.885,	0.863,	0.556,	0.294,	0.816,
0.206,	0.150,	0.555,	0.448,	0.781,	0.065,	0.703,	0.092,
0.455,	0.415,	0.469,	0.172,	0.327,	0.235,	0.432,	0.616,
0.735,	0.675,	0.256,	0.900,	0.745,	0.475,	0.602,	0.470,
0.146,	0.729,	0.373,	0.773,	0.302,	0.324,	0.823,	0.362,
0.662,	0.219,	0.307,	0.849,	0.870,	0.980,	0.951,	0.157,
0.714,	0.267,	0.706,	0.572,	0.820,	0.715,	0.019,	0.778,
0.036,	0.706,	0.317,	0.056,	0.984,	0.957,	0.840,	0.479
