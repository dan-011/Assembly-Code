#       CSE 3666 Lab 2

        .data

        .align 2
        # allocating space for 256 words
freq:   .space  1024

        # buffer to store the string
        # we assume 2048 is large enough
str:    .space  2048

        .globl  main

        .text
main:   

        # read a string into str
        la      a0, str
        li      a1, 2048
        li      a7, 8
        ecall
 
        # TODO
        # Add you code here
        # 1. initialize freq (set all elements to 0)
        # 2. count the frequency of each character in str
        # pseudocode
        #       i = 0
        #       while str[i] != 0:
        #               v = str[i]
        #               freq[v] += 1

	# use pseudoinstruction la to load an address into a register
        la t2, freq # initialize freq
        li s1, 0 # set register s1 to 0 --> start index (i)
        li s4, 256 # set register s4 to 1024 --> end index
        
        Test1:
        	slli t0, s1, 2 # multiply i by four and store it in t0
        	add t3, t0, t2 # add t0 to t2 (freq register) to get the address of freq[i]
        	sw x0, 0(t3) # save in freq[i] the value 0
        	addi s1, s1, 1 # add 1 to i
        	bne s1, s4, Test1 # if i does not equal 256 (end of freq), loop
        
        while:
        	lbu t3, 0(a0) # load the unsigned byte in str from i
        	beq t3, x0, end # if str[i] equals zero, go to end (while loop is over)
        	slli t3, t3, 2 # shift the unsigned byte by 2 to multiply it by 4 and align its value
        	add t4, t3, t2 # add the bit value from t3 to the register of freq(t2) to get the address of freq[v]
        	lw t6, 0(t4) # load the value of freq[v] using the address
        	addi t6, t6, 1 # add 1 to the value in freq[v]
        	sw t6, 0(t4) # save the incremented value into freq[v]
        	addi a0, a0, 1 # increment a0 by 1 to perform i = i + 1
        	beq x0, x0, while # if 0 == 0 (always true) go to loop
        
        end:
        	
        
        # print 
        # do not modify the code below  
        
        # use index i to control the loop
        li      t0, 0                   # index i
        li      t1, 256                 # until i is 256
        la      t2, freq                # address of freq

loop_print:
        # load freq[i]
        slli    t3, t0, 2
        add     t3, t3, t2      
        lw      t4, 0(t3)
        beq     t4, x0, skip_print
        
        # print t0, i
        mv      a0, t0
        li      a7, 36
        ecall
        
        # print space
        li      a0, ' '
        li      a7, 11
        ecall
 
        # print t4, freq[i]
        mv      a0, t4
        li      a7, 36
        ecall
                
        # print new line
        li      a0, '\n'
        li      a7, 11
        ecall
                
skip_print:
        addi    t0, t0, 1               # increment i
        bne     t0, t1, loop_print       
 
exit:   addi    a7, x0, 10
        ecall
