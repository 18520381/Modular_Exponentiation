`timescale 1ns / 1ps

module Mont1(A,B,M,S,SS,EN,clk);
	input [3:0] A;
	input [1023:0] B,M,S;
	output reg [1023:0] SS;
	input clk, EN;
	wire [1023:0] S_temp0,S_temp1,S_temp2,S_temp3,S_temp4;
assign S_temp0 = S;
always @(posedge clk )
begin
if (EN)
 SS <= S_temp4;
else SS <= S;
end
MC1 inst0(A[0],B,M,S_temp0,S_temp1);
MC1 inst1(A[1],B,M,S_temp1,S_temp2);
MC1 inst2(A[2],B,M,S_temp2,S_temp3);
MC1 inst3(A[3],B,M,S_temp3,S_temp4);
endmodule