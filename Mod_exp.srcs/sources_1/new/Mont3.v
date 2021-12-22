`timescale 1ns / 1ps

module Mont3(A, B, M, S, start, done, clk, valid_out);
	input [1023:0] A,B,M;
	output wire [1023:0] S;
	input start,clk;
	output done,valid_out;
	reg [1023:0] A_temp, B_temp, M_temp;
	wire [1023:0]   S_temA,S_temB,S_O;
	wire [1024:0] S_temp;
	reg [10:0] counter;
	wire AA;
	wire EN;
always @(posedge clk)
begin
	if(start == 1)
	begin
		counter <= 0;
	end
	else if (counter < 1024)
	begin
		counter <= counter + 'd1;
	end
end
always @(negedge clk)
begin
	if (counter == 0 )
	begin
		A_temp    <= A;
		B_temp    <= B;
		M_temp    <= M;
	end
end
assign AA = ((0<=counter) && (counter<1024))?A_temp[counter]:1'b0;
MC_clk inst1(.Ai(AA), 
			.B(B_temp), 
			.M(M_temp), 
			.S(S_temA), 
			.SS(S_temB), 
			.EN(EN),.clk(~clk));
assign S_temA = (counter > 0)?S_temB:1024'b0;
assign EN = ((0<=counter) && (counter<1024))? 1'b1: 1'b0;
assign S = (counter <1024)?'bz:S_O;
//sub inst2(.A({{1'b0},S_temB}),.B({{1'b0},M_temp}),.S(S_temp),.carry());
assign S_temp = {{1'b0},S_temB} - {{1'b0},M_temp};
assign S_O = (S_temp[1024]==0)?S_temp[1023:0]:S_temB;
assign done = (counter == 1024)?1'b1:1'b0;
assign valid_out = (counter == 1024)?1'b1:1'b0;
endmodule
	
