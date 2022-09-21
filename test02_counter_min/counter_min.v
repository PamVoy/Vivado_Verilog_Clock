`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/16 23:00:52
// Design Name: 
// Module Name: counter_min
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


module counter_min(
    input clock,                   // clock from FPGA (50MHz) through Frequency Divider : ( 50MHz ) / ( 2^24) = 2.98 Hz
    input reset_min, 
    input enable_min,              // input source: carry_sec , for min+1
    input enable_min1,             // input source: carry_sec1 , for hour +1
    input load_min,                // load data mode
    input setting_min,             // press FPGA buttom to trigger loading min data
    input [5:0] data_min,          // min data  6'd0 ~ 6'b59
    output reg [5:0]count_min,     // output min 6'd0 ~ 6'b59
	output reg carry_min           // control signal for module counter_hour: enable hour +1  
);

    always @ (posedge clock or posedge reset_min)
        begin
            if (reset_min)begin
                count_min<=6'b000000;
				carry_min<=1'b0;                                                // disable counter_hour +1
			end
			
		    else if (load_min && setting_min && count_min<6'd59) begin          // press buttom : load +1 = min +1
			    count_min<=count_min+1;	
			end
			    
            else if (load_min && setting_min && count_min==6'd59) begin         // press buttom: load min +1 = 59 -> 00
			    count_min<=6'b000000;
			end 

			else if (count_min==6'd59 && enable_min1 && load_min==0 ) begin	    // condition : min=59(count_min==6'd59) , sec=59( && enable_min1) ; 00:59:59 -> 01:00:00
			    carry_min<=1'b1;                                                // enable counter_hour +1
			end				
				
            else if (count_min==6'd59 && enable_min && load_min==0) begin	
				count_min<=6'b000000;                                            // 00:59:59 -> 01:00:00
				carry_min<=1'b0;                                                 // disable counter_min +1
			end				
			
			else if (count_min==0 && enable_min==0 && load_min==0) begin
			    carry_min<=1'b0;                                                  // disable counter_min +1
			end		
			
			else if (count_min<6'd59 && enable_min && load_min==0) begin
		        count_min<=count_min+1;	                                          // counter_min +1
                carry_min<=1'b0;					                              // disable counter_min +1
			end			     				 
        end		
endmodule
