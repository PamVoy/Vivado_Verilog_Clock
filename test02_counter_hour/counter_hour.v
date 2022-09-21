`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/16 23:17:21
// Design Name: 
// Module Name: counter_hour
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

module counter_hour( 
    input clock,                     // clock from FPGA (50MHz) through Frequency Divider : ( 50MHz ) / ( 2^24) = 2.98 Hz
    input reset_hour,
    input enable_hour,
    input load_hour,                 // load data mode
	input setting_hour,              // press FPGA buttom to trigger loading hour data
    input [5:0] data_hour,           // hour data  6'd0 ~ 6'b23
    output reg [5:0] count_hour,     // output hour 6'd0 ~ 6'b23
	output reg carry_hour            // control signal for module counter_day:  enable day+1
);
	 
    always @ (posedge clock or posedge reset_hour)
        begin
            if (reset_hour) begin
                count_hour<=6'b000000;
				carry_hour<=1'b0;
			end
			
            else if (load_hour && setting_hour && count_hour<6'd23) begin    
			     count_hour<=count_hour+1;                                        //  press buttom : load +1 = sec +1
            end
			     
            else if (load_hour && setting_hour && count_hour==6'd23) begin
			     count_hour<=6'b000000;	                                           // press buttom: load hour +1 = 23 -> 00
            end		
            	     					
			else if (count_hour==6'd23 && enable_hour && load_hour==0) begin
		         count_hour<=6'b000000;                                            // hour 23 -> 00
				 carry_hour<=1'b1;                                                 // enable counter_day +1             
			end
					
			else if (count_hour>6'd23 && load_hour==0) begin                      // hour : 00~23
		          count_hour<=6'b000000;
				  carry_hour<=1'b0;                                               // disable carry_hour
			end	
			  
			else if (count_hour<6'd23 && enable_hour && load_hour==0) begin
		          count_hour<=count_hour+1;                                        // counter_hour + 1                
				  carry_hour<=1'b0;                                                // disable carry_hour
			end			     				 
        end				
endmodule
