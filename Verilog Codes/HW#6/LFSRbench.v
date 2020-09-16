`timescale 1ns / 1ps
module LFSRbench();
  reg clock;
  reg rst;
  reg en;
  reg [ 7 : 0 ] seed;
  reg [ 7 : 0 ] poly;
  wire [7 :0] out;
	integer File;
  initial clock = 0;
  LFSR CUT (clock,rst,en,poly,seed,out);
  initial File = $fopen ("LFSRinputs.flt", "w");
  initial repeat (8) begin
    #50 clock = ~clock;
    {seed,poly} = $random();
    $fwrite (File, "%b \n", out);
  end
  initial begin
    en = 1;
    rst = 1;
    #52;
    rst = 0;
  end
  initial begin
    #900;
    	$fclose(File);		
		 $stop;
	end
endmodule
