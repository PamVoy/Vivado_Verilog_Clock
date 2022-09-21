`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/18 16:08:55
// Design Name: 
// Module Name: alarm_min
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


module alarm_min(                 // alarm_clock_min module
 
    input clock,                  // clock from FPGA (50MHz) through Frequency Divider : ( 50MHz ) / ( 2^24) = 2.98 Hz
    input reset_min,
    input enable_min,    
	input setting_min,            // press FPGA buttom to trigger loading min data       
    //input [5:0] data_sec,
    output reg [5:0]count_min     // output min 6'd0 ~ 6'b59
    //output [5:0]count_sec1,
    //reg [5:0] count_sec1,
    //output carry_sec,
    //reg  carry_sec,
    //output carry_sec1,
    //reg  carry_sec1
);	 

    always @ (posedge clock or posedge reset_min )
        begin
            if (reset_min) begin
                count_min<=6'b000000;
                //carry_sec<=1'b0;
            end	
            			
        else if (enable_min && setting_min && count_min<6'd59 )    //  press buttom :  min +1
            begin
                count_min<=count_min+1;	
            end
            
        else if (enable_min && setting_min && count_min==6'd59 )   // press buttom: min +1 = 59 -> 00
            begin
                count_min<=6'b000000;	
            end	
        end		
endmodule
