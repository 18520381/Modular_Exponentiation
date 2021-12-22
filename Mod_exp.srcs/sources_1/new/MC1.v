`timescale 1ns / 1ps

module MC1(Ai, B, M, S,SS);
	input[1023:0] B, M;
	input [1023:0] S;
	input Ai;
	output wire [1023:0] SS;
	wire x,q;
	wire [1023:0] y,z;
	wire [1024:0] S_temp;
	integer i;

		
assign		x = Ai & B[0];
assign		q = x ^ S[0];
assign		y = {1024{Ai}} & B;
assign		z = {1024{q}} & M;
assign 		S_temp = S + y + z;
assign SS = S_temp[1024:1];

endmodule

	
	