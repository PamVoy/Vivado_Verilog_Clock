`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/18 16:16:47
// Design Name: 
// Module Name: alarm_hour
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


module alarm_hour(                      // alarm_clock_hour module
 
    input clock,                        // clock from FPGA (50MHz) through Frequency Divider : ( 50MHz ) / ( 2^24) = 2.98 Hz
    input reset_hour,
    input enable_hour,
    input setting_hour,                  // press FPGA buttom to trigger loading hour data     
    //input [5:0] data_sec,
    output reg [5:0] count_hour          // output hour 6'd0 ~ 6'b23
    //output [5:0]count_sec1,
    //reg [5:0] count_sec1,
    //output carry_sec,
    //reg  carry_sec,
    //output carry_sec1,
    //reg  carry_sec1
); 

    always @ (posedge clock or posedge reset_hour )
        begin
            if (reset_hour) begin
                count_hour<=6'b000000;
                //carry_sec<=2'b0;
            end				
            else if (enable_hour && setting_hour && count_hour<6'd23 )     //  press buttom :  hour +1
                begin
                    count_hour<=count_hour+1;	
                end
                
            else if (enable_hour && setting_hour && count_hour==6'd23 )     // press buttom: min +1 = 23 -> 00
                begin
                    count_hour<=6'b000000;	
                end	
            end		
            
endmodule
