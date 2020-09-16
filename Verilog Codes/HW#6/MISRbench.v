`timescale 1ns / 1ps
module MISRbench();
  reg clock;
  reg rst;
  reg en;
  reg [ 7 : 0 ] seed;
  reg [ 7 : 0 ] poly;
  reg [7:0] in;
  wire [7 :0] out;
  initial clock = 0;
  MISR CUT (clock,rst,en,poly,seed,in,out);
  initial repeat (8) begin
    #50 clock = ~clock;
    {seed,poly,in} = $random();
  end
  initial begin
    en = 1;
    rst = 1;
    #100;
    rst = 0;
  end
endmodule


