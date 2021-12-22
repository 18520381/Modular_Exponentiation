`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2021 10:06:38 AM
// Design Name: 
// Module Name: MC_clk
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module MC_clk(Ai, B, M, S,SS, EN, clk);
	input[1023:0] B, M;
	input [1023:0] S;
	input Ai,EN,clk;
	output reg [1023:0] SS;
	wire x,q;
	wire [1023:0] y,z;
	wire [1024:0] S_temp;
	integer i;
always @(posedge clk )
begin
if (EN)
 SS <= S_temp[1024:1];
else SS <= S;
end
		
assign		x = Ai & B[0];
assign		q = x ^ S[0];
assign		y = {1024{Ai}} & B;
assign		z = {1024{q}} & M;
//CSA inst1 (.x(y),.y(z),.z(S),.s(S_temp),.cout());
assign      S_temp = S + y + z;


endmodule