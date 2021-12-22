`timescale 1ns / 1ps

module Mux4(
    input [1:0]     S,
    input [1023:0]  I0,
    input [1023:0]  I1,
    input [1023:0]  I2,
    input [1023:0]  I3,
    
    output [1023:0] Y
);
  
  assign Y = (S == 'b11)? I3 : (S == 'b10)? I2 : (S == 'b01)? I1 : I0;  
  
endmodule
