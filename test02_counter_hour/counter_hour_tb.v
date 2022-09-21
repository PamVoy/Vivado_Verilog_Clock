`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/16 23:30:21
// Design Name: 
// Module Name: counter_hour_tb
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


module counter_hour_tb;

	// Inputs
	reg clock;
	reg reset_hour;
	reg enable_hour;
	reg load_hour;
	reg [5:0] data_hour;

	// Outputs
	wire [5:0] count_hour;
	wire carry_hour;

	// Instantiate the Unit Under Test (UUT)
	counter_hour uut (
	    .clock(clock), 
	    .reset_hour(reset_hour),
	    .enable_hour(enable_hour), 
	    .load_hour(load_hour), 
		.data_hour(data_hour), 
		.count_hour(count_hour), 
		.carry_hour(carry_hour)
	);

	initial begin
		// Initialize Inputs
		clock = 1;
		reset_hour = 1;
		enable_hour = 1;
		data_hour = 0;
		load_hour = 0;	
		#10;
        reset_hour = 0;  
        $monitor($time, "=>hour= %d,carry_hour= %d,enable_hour= %b,reset_hour= %b",count_hour,carry_hour,enable_hour,reset_hour);		
	end
	
	always begin
        clock = ~clock;
        #1;
    end	 
   
    initial begin	
        #150 enable_hour = 0;
        #20  enable_hour = 1;
    end
	
	initial
        #1000 $finish;	
	   
endmodule
