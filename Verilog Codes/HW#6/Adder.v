module adder(a,b,s);
  input [7:0] a;
  input [7:0] b;
//  input cin;
//  output cout;
  output [8:0] s;
  assign s = a + b;
endmodule
