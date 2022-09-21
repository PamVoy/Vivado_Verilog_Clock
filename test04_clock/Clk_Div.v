`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/18 10:58:14
// Design Name: 
// Module Name: Clk_Div
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


module Clk_Div(

   input clk,                                // FPGA clock : 50MHz
   input RESETn,
   output [15:0] clk_div_out
);   
                   
   reg [63:0] count;                            // 64 bit counter  :  0,1,2,3,.....,(2^62),(2^63) ; clock of counter : 50 MHz
   wire [15:0] clk_div_out;
        
   assign clk_div_out=count[31:16];             //  clk_div_out [0] = (50MHz) / (2^17) = 381.47 Hz
   
   //There are 16bits for the clk_div_out,
   //it will be easier for the designer to try out different clocks
   
   //The input clock is a 50Mhz signal (from Nexys2 clocks)
   //Therefore, count[0] represents a 25Mhz clk
   // count[1]: 12.5MHz
   // count[2]: 6.25MHz
   // count[3]: 3.125MHz
   // ...
   // count[16]:381.47Hz
   // count[17]:190.74Hz
   // count[18]:95.37Hz
   // count[19]:47.68Hz
   // count[20]:23.84Hz
  
   //This is a 64-bit counter 
    always@(posedge clk or posedge RESETn)
        begin
            if(RESETn)
                count<=64'b0;
        else
                count<=count+64'b1;
        end 
endmodule 
