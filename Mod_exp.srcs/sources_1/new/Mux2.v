`timescale 1ns / 1ps

module Mux2(
    input S,
    input [1023:0] I0,
    input [1023:0] I1,
    
    output [1023:0] Y
);
  
  assign Y = S? I1 : I0;  
  
endmodule
