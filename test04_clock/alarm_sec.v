`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/18 15:55:43
// Design Name: 
// Module Name: alarm_sec
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

module alarm_sec(             // alarm_clock_sec module
 
    input clock,              // clock from FPGA (50MHz) through Frequency Divider : ( 50MHz ) / ( 2^24) = 2.98 Hz
    input reset_sec,
    input enable_sec,
    input setting_sec,        // press FPGA buttom to trigger loading sec data  
    //input [5:0] data_sec,
    output reg [5:0]count_sec // output sec 6'd0 ~ 6'b59
    //output [5:0]count_sec1.
    //reg [5:0] count_sec1.
    //output carry_sec.
    //reg  carry_sec.
    //output carry_sec1.
    //reg  carry_sec1
);	 

    always @ (posedge clock or posedge reset_sec )
        begin
            if (reset_sec) begin                    
                count_sec<=6'b000000;
                //carry_sec<=1'b0;
            end		
            		
            else if (enable_sec && setting_sec && count_sec<6'd59 )          //  press buttom : sec +1
                begin
                    count_sec<=count_sec+1;	
                end
                
            else if (enable_sec && setting_sec && count_sec==6'd59 )         // press buttom: sec +1 = 59 -> 00     
                begin
                    count_sec<=6'b000000;	
                end	
        end		
endmodule