`timescale 1ns / 1ps

module Mod_exp(
	input CLK,
	input RST,
	input [63:0] M,
	input [63:0] E,
	input [63:0] N,
    input [63:0] r2,
	output valid_out,
	output wire [63:0] C
);

	reg [15:0]     counter;
	reg [10:0]     counter_loop;
	
	reg [1023:0]   M_data;
	reg [1023:0]   E_data;
	reg [1023:0]   N_data;
	reg [1023:0]   r2_data;
	
	reg [1023:0]   S_data;
	reg [1023:0]   C_data;
	
	always @(posedge CLK)
	begin
		if (RST)
		begin
			counter	         <= 0;
			counter_loop     <= 0;
	    end
//		else if (counter == 274)
		else if (counter == 1041)
		begin
		    counter          <= 16;
		    counter_loop     <= counter_loop + 'b1;
		end
		else
			counter          <= counter + 'b1;
	end
	
	always @(negedge CLK)
	begin
		if (counter < 16)
		begin
			M_data[(64*counter) +: 64] <= M;
			E_data[(64*counter) +: 64] <= E;
			N_data[(64*counter) +: 64] <= N;
			r2_data[(64*counter) +: 64] <= r2;
		end

	end

    wire [1023:0]   A_1;
    wire [1023:0]   B_1;
    wire [1023:0]   A_2;
    wire [1023:0]   B_2;
    
    wire [1023:0]   Sqr_out;
    wire            Sqr_valid_out;
    wire            Sqr_done;
    wire [1023:0]   Mul_out;
    wire            Mul_done;
    wire            Mul_valid_out;
	
	wire           start;
	wire           Sel0;
	wire           Sel1;
	  
//    assign start   = ((counter > 'd16) && (counter != 273) && (counter != 274))? 'b0 : 'b1; 
    assign start   = ((counter > 'd16) && (counter != 1041)/* && (counter != 1042)*/)? 'b0 : 'b1; 
	assign Sel0    = (counter_loop > 'b0)? 'b1 : 'b0;
	assign Sel1    = (counter_loop == 'd1025)? 'b1 : 'b0;
	
	Mux2	mux1	(Sel0, r2_data, S_data, A_1);
	Mux2	mux2	(Sel0, M_data, S_data, B_1);
	Mux4	mux3	({Sel1,Sel0}, r2_data, S_data, 'd0, 'd1, A_2);
	Mux2	mux4	(Sel0, 'd1, C_data, B_2);	
	
//	Mont2 inst_sqr(
	Mont3 inst_sqr(
        .A(A_1),
        .B(B_1),
        .M(N_data),
        .S(Sqr_out),
        .start(start),
        .done(Sqr_done),
        .clk(CLK),
        .valid_out(Sqr_valid_out));
  
//	Mont2 inst_mul(
	Mont3 inst_mul(
        .A(A_2),
        .B(B_2),
        .M(N_data),
        .S(Mul_out),
        .start(start),
        .done(Mul_done),
        .clk(CLK),
        .valid_out(Mul_valid_out));


    wire done;  
    assign done         = Sqr_done & Mul_done;
    assign valid_out    = ((counter_loop == 'd1026) && (counter >= 16) && (counter < 32))? 'b1 : 'b0; 
    assign C = valid_out?C_data[(64*(counter - 16)) +: 64]:'bz;
    always @(posedge CLK)
	begin
		if ((counter > 16) && done)
		begin
		    if (!((counter_loop > 0) && (counter_loop < 1025) && (!E_data[counter_loop - 1])))
		    begin
                C_data  =   Mul_out;
            end
            S_data  =   Sqr_out;
		end
	end   
	
endmodule