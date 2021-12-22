`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2021 09:36:48 AM
// Design Name: 
// Module Name: tb_exp
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



module tb_exp();
    reg CLK;
    reg RST;

    reg [63:0] M;
    reg [63:0] E;
    reg [63:0] N;
    reg [63:0] r2;
    reg [1023:0] M_in;
    reg [1023:0] E_in;
    reg [1023:0] N_in;
    reg [1023:0] r2_in;
    reg [1023:0] d;
    reg [1023:0] C_out, C_out_true, M_maple;
    
    reg [21:0] counter;
    reg [3:0]  counter_out;
    
    wire valid_out;
    wire [63:0] C;
    integer i, Test_file, M_stt, E_stt, D_stt, N_stt, r2_stt, result_stt;
    
    initial begin
    CLK = 0;
    RST = 1;
    C_out = 1024'd0;
    M_maple = 1024'd0;
    Test_file = $fopen("F:/Gen_key/A.txt", "r");
    M_stt = $fscanf(Test_file, "%d\n", M_in);
    E_stt = $fscanf(Test_file, "%d\n", E_in);
    D_stt = $fscanf(Test_file, "%d\n", d);
    N_stt = $fscanf(Test_file, "%d\n", N_in);
    r2_stt = $fscanf(Test_file, "%d\n", r2_in);
    result_stt = $fscanf(Test_file, "%d\n", C_out_true);
    $fclose(Test_file);
    $display("\n\n------------------Load Datas------------------");
    $display("Message:\t%0d", M_in);
    $display("e:\t\t\t%0d", E_in);
    $display("d:\t\t\t%0d", d);
    $display("N:\t\t\t%0d", N_in);
    $display("r^2:\t\t%0d", r2_in);
    $display("EncryptMsg:\t%0d\n", C_out_true);
    counter = 0;
    counter_out = 0;
    #10 
    M = M_in[63:0]; E = E_in[63:0]; N = N_in[63:0]; r2 = r2_in[63:0];
    for ( i = 1; i < 16 ; i = i + 1 )
    begin
    #20
    if (i==1) RST = 0;
    M = M_in[(64*i) +: 64]; E = E_in[(64*i) +: 64]; N = N_in[(64*i) +: 64]; r2 = r2_in[(64*i) +: 64];
    end

    #21_055_010
    C_out = 1024'd0;
    RST = 1;
    #10 
    M = M_maple[63:0]; E = d[63:0]; N = N_in[63:0]; r2 = r2_in[63:0];
    for ( i = 1; i < 16 ; i = i + 1 )
    begin
    #20
    if (i==1) RST = 0;
    M = M_maple[(64*i) +: 64]; E = d[(64*i) +: 64]; N = N_in[(64*i) +: 64]; r2 = r2_in[(64*i) +: 64];
    end
    #21_055_000 $finish;
    end
    always @(negedge CLK) begin

        if (valid_out && (counter_out < 16))
            begin
            C_out = C_out + (C << (64*counter_out));
            counter_out <= counter_out + 1;
            end
        else counter_out = 0;
    end
    always @(negedge valid_out)
    begin
    if ( counter > 500000 && counter < 1500000) begin
    $display("\n------------------Encrypted Phase------------------\n");
    $display("Simulate Result: \t%0d", C_out);
    M_maple = C_out;
    $display("True Result: \t\t%0d\n", C_out_true);
    if ( C_out == C_out_true ) $display("Encrypted TRUE\n"); else $display("Encrypted FALSE\n");
    end
    if ( counter > 1500000 ) begin
    $display("\n------------------Decrypted Phase------------------\n");
    $display("Simulate Result: \t%0d", C_out);
    $display("True Result: \t\t%0d\n", M_in);
    if ( C_out == M_in ) $display("Decrypted TRUE\n"); else $display("Decrypted FALSE\n");
    end
    end
    always @(CLK)
        #10 CLK <= ~CLK;
    
    Mod_exp DUT (CLK, RST, M, E, N, r2, valid_out, C);
    always #20 counter = counter+1;

endmodule

