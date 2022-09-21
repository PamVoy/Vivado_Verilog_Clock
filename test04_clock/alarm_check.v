`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/18 15:24:02
// Design Name: 
// Module Name: alarm_check
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


module alarm_check(
 
    input clk_ac,                 // clock from FPGA (50MHz) through Frequency Divider : ( 50MHz ) / ( 2^24) = 2.98 Hz
    input reset,	 
    input [17:0] clock_inp,	   // 18 bits clock time data : hour, min, sec ; each one is 6 bits
    input [17:0] alarm_inp,	   // 18 bits alarm clock time data : hour, min, sec ; each one is 6 bits
    output reg ot_ac              // alarm signal -> trigger FPGA LED 
);	 
 
    always @ (posedge clk_ac )
        begin
            if (reset)               // reset alarm signal = 0
                begin    
                    ot_ac<=1'b0;
            end

            else if ( alarm_inp == clock_inp )   //  alarm clock time = clock time
                begin
                    ot_ac<=1'b1;                 // alarm signal = 1 ->  trigger FPGA LED 
                end
                
            else if ( alarm_inp+1 == clock_inp ) //  trigger FPGA LED  for 5 clock tiime
                begin
                    ot_ac<=1'b1;    
                end
                
             else if ( alarm_inp+2 == clock_inp ) // do the same thing as previous 
                begin
                    ot_ac<=1'b1;    
                end

            else if ( alarm_inp+3 == clock_inp ) // do the same thing as previous 
                begin
                    ot_ac<=1'b1;    
                end

            else if ( alarm_inp+4 == clock_inp ) // do the same thing as previous 
                begin
                    ot_ac<=1'b1;    
            end		
				  
            else                          // others condition, trun off alarm signal 
                begin
                    ot_ac<=1'b0;          //   alarm signal = 0
                end		   		  
        end	 
 
endmodule
