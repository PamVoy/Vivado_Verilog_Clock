`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/16 22:39:06
// Design Name: 
// Module Name: counter_sec
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

module counter_sec(
    input clock,                    // clock from FPGA (50MHz) through Frequency Divider : ( 50MHz ) / ( 2^24) = 2.98 Hz
    input enable_sec,
    input reset_sec,
    input load_sec,                 // load data mode
	input setting_sec,              // press FPGA buttom to trigger loading sec data     
    input [5:0] data_sec,           // sec data  6'd0 ~ 6'b59
    output reg [5:0]count_sec,      //  output sec 6'd0 ~ 6'b59
	output reg carry_sec,           // control signal for module counter_min:  enable min+1
	output reg carry_sec1           // control signal for module counter_min:  00:59:59 -> 01:00:00
);
    
	 
     always @ (posedge clock or posedge reset_sec )
        begin
            if (reset_sec)begin
                count_sec<=6'b000000;
				carry_sec<=1'b0;
			end				
		     
		    else if (load_sec && setting_sec && count_sec<6'd59 ) begin            //  press buttom : load +1 = sec +1
			     count_sec<=count_sec+1;	
			end
			  
			else if (load_sec && setting_sec && count_sec==6'd59 ) begin           // press buttom: load  sec +1 = 59 -> 00
			     count_sec<=6'b000000;	
			end	
           
            else if (count_sec==6'd59 && load_sec==0 ) begin                       // sec 59 -> 00 , carry =1 for min+1
		         count_sec<=6'b000000;
				 carry_sec<=1'b0;                                                  // disable counter_min +1                   
			end	
			
		    else if (count_sec==6'd58 && load_sec==0) begin	
                 count_sec<=count_sec+1;	                                        // 58 -> 59
				 carry_sec1<=1'b0;                                                  // disable carry_min for 00:59:59 -> 01:00:00
				 carry_sec<=1'b1;                                                   // enable counter_min +1
			end			
			
			else if (count_sec==6'd57 && load_sec==0) begin	
			      count_sec<=count_sec+1;                                            // 57 -> 58
                  carry_sec1<=1'b1;                                                  // enable carry_min for 00:59:59 -> 01:00:00                  
			end			
			
			else if (count_sec<6'd58 && enable_sec && load_sec==0) begin             // counter_sec + 1
		          count_sec<=count_sec+1;
				  carry_sec<=1'b0;                                                   // disable counter_min +1   
			end	
			
		end		
endmodule
