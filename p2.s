.text

# int count_painted(int *wall, int width, int radius, int coord) {
# 	int row = (coord & 0xffff0000) >> 16;
# 	int col = coord & 0x0000ffff;
# 	int value = 0;
# 	for (int row_offset = -radius; row_offset <= radius; row_offset++) {
# 		int temp_row = row + row_offset;
# 		if (width <= temp_row || temp_row < 0) {
# 			continue;
# 		}
# 		for (int col_offset = -radius; col_offset <= radius; col_offset++) {
# 			int temp_col = col + col_offset;
# 			if (width <= temp_col || temp_col < 0) {
# 				continue;
# 			}
# 			value += wall[temp_row*width + temp_col];
# 		}
# 	}
# 	return value;
# }
#
# // a0: int *wall
# // a1: int width
# // a2: int radius
# // a3: int coord

.globl count_painted
count_painted:

	sub   $sp, $sp, 12
	sw		$s0, 0($sp)
	sw		$s1, 4($sp)
	sw		$s2, 8($sp)

	lui   $s1, 0xffff

	and		$t0, $a3, $s1												      				#coord & 0xffff0000
  srl 	$t2, $t0, 16                                      #(coord & 0xffff0000) >>16
	andi  $t4, $a3, 0x0000ffff															#col = coord & 0x0000ffff
	li 		$t1, 0																						#value = 0

	sub 	$s2, $zero, $a2															      #row_offset = -return

	forloop1:

		bgt		$s2, $a2, endloop1 														    #condition for first for loop
		add   $t3, $t2, $s2                                     #temp_row = row + row_offset

			ifcondition1:
    	ble		$a1, $t3, goBackToFirstLoop																			# if  <=  then (first condition satisfies)

			ifcondition2:
			blt		$t3, $zero, goBackToFirstLoop	                            			# if  <  then (second condition satisfy call forloop2)


		sub 	$t5, $zero, $a2																		#col_offset = -return

	forloop2:

		bgt		$t5, $a2, goBackToFirstLoop 														    #condition for first for loop
		add   $t6, $t4, $t5                                     #temp_col = row + row_offset

			ifcondition3:
			ble		$a1, $t6, goBackToSecondLoop

			ifcondition4:
			blt 	$t6, $zero, goBackToSecondLoop

		mul   $t7, $t3, $a1                                    	#temp_row * width
		add   $t8, $t7, $t6                                   	#(temp_row * width) + temp_col
		mul   $t8, $t8, 4
		add   $s0, $a0, $t8																			#s0 = wall[$t8]
		lw    $t9, 0($s0)																				#t9 points to $s0
		add   $t1, $t1, $t9																			#value = value + wall[]

		addi  $t5, $t5, 1																				#col_offset = col_offset + 1

		j forloop2

endloop1:

	move $v0, $t1							                              #moving the value into return
	lw   $s0, 0($sp)
	lw   $s1, 4($sp)
	lw   $s2, 8($sp)
	add  $sp, $sp, 12
	jr	 $ra

goBackToSecondLoop:

	addi $t5, $t5, 1
	j forloop2

goBackToFirstLoop:

	addi $s2, $s2, 1																				#row_offset = row_offset
	j forloop1                                              #continue statement



# int* get_heat_map(int *wall, int width, int radius) {
# 	int value = 0;
# 	for (int col = 0; col < width; col++) {
# 		for (int row = 0; row < width; row++) {
# 			int coord = (row << 16) | (col & 0x0000ffff);
# 			output_map[row*width + col] = count_painted(wall, width, radius, coord);
# 		}
# 	}
# 	return output_map;
# }
#
# // a0: int *wall
# // a1: int width
# // a2: int radius

.globl get_heat_map
get_heat_map:
	# Can access output_wall from p2.s

	sub		$sp, $sp, 48																	# set sp back
	sw    $ra, 0($sp)																		# store ra in memory

	la    $s5, output_wall

	li    $s0, 0																				# one temp variable value
	li    $s1, 0																				# int col = 0

	forloop_2_1:

		bge		$s1, $a1, endloop_2_1													# forloop_2_1 loop condition
		li    $s2, 0																	  			# int row = 0

		forloop_2_2:

			bge		$s2, $a1, endloop_2_2													# forloop_2_2 loop condition
			sll   $t0, $s2, 16                                  # performing 16 shift left of row
			andi  $t1, $s1, 0x0000ffff
			or    $t2, $t0, $t1																	# performing (row << 16) | (col & 0x0000ffff)

			mul   $t3, $s2, $a1																	#t3 = row * width
		  add   $t4, $t3, $s1																	#(row*width) + col
			mul   $t4, $t4, 4

			addi  $a3, $t2, 0																			#coordinate is 3rd param here
			sw		$s0, 4($sp)																		  # store in memory
			sw		$s1, 8($sp)																		  # store in memory
			sw    $s2, 12($sp)   																  # store in memory
			sw		$s3, 16($sp)																		# store in memory
			sw		$s4, 20($sp)																		# store in memory
			sw    $s5, 24($sp)   																  # store in memory

			sw		$t0, 28($sp)																		# store in memory
			sw		$t1, 32($sp)																		# store in memory
			sw    $t2, 36($sp)   																  # store in memory
			sw		$t3, 40($sp)																		# store in memory
			sw		$t4, 44($sp)																		# store in memory

			jal count_painted

			lw		$t4, 44($sp)																		# load arguments from memory
			lw		$t3, 40($sp)
			lw		$t2, 36($sp)
			lw		$t1, 32($sp)																		# load arguments from memory
			lw		$t0, 28($sp)
			lw		$s5, 24($sp)
			lw		$s4, 20($sp)																		# load arguments from memory
			lw		$s3, 16($sp)
			lw		$s2, 12($sp)
			lw		$s1, 8($sp)																		  # load arguments from memory
			lw		$s0, 4($sp)
			lw    $ra, 0($sp)
			move 	$s3, $v0																				#saving the output of count pained in $s3


		 add 		$s4, $s5, $t4																		#$s4 = output_map[(row * width) + col]
		 sw 		$s3, 0($s4)																				#storing $s3 into output_map[(row * width) + col]

		 addi 	$s2, $s2, 1																			#incrementing row
		 j forloop_2_2


endloop_2_2:

  addi $s1, $s1, 1                                    #increment col
	j forloop_2_1                                       #go back to inner loop

endloop_2_1:

	la $v0, output_wall
	add $sp, $sp, 48
	jr	$ra
