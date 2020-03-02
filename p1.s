.text

# // Finds the dot product between two different arrays of size n
# // Ignore integer overflow for the multiplication
# int paint_cost(unsigned int n, unsigned int* paint, unsigned int* cost) {
# 	int total = 0;
# 	for (int i = 0; i < n; i++) {
# 		total += paint[i] * cost[i];
# 	}
# 	return total;
# }

.globl paint_cost
paint_cost:

	li $t0, 0																						#total = 0
	li $t1, 0  																					#i = 0

loop:

	bge $t1, $a0, endloop 															#for loop condition

	lw $t2, 0($a1)																			#getting paint[0] in reg $t2
	lw $t3, 0($a2)																			#getting cost[0] in reg $t3

	mul $t4, $t2, $t3																		#multiplying paint and cost (mul $t4, $t2, $t3)
	add $t0, $t0, $t4																		#adding total (add $t5, $t4, $t4)

	add $t1, $t1, 1																			#incrementing the i value
	add $a1, $a1, 4																			#adding 4 to address of paint
	add $a2, $a2, 4																			#adding 4 to address of cost
	j loop

endloop:

	move $v0, $t0																				#moving the total into return value
	jr	$ra
