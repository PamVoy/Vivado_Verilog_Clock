`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/16 23:03:12
// Design Name: 
// Module Name: counter_min_tb
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


module counter_min_tb;

    // Inputs
	reg clock;
	reg reset_min;
    reg enable_min;
	reg enable_min1;
	reg load_min;
	reg [5:0] data_min;

	// Outputs
	wire [5:0] count_min;
	wire carry_min;
	

	// Instantiate the Unit Under Test (UUT)
	counter_min uut (
        .clock(clock),
        .reset_min(reset_min),
        .enable_min(enable_min), 
		.enable_min1(enable_min1), 
		.load_min(load_min), 
		.data_min(data_min),
		.count_min(count_min), 
		.carry_min(carry_min)	
	);

	initial begin
		// Initialize Inputs
		clock = 1;
		reset_min = 1;
        enable_min = 1;
		enable_min1= 0;
		data_min = 0;
		load_min = 0;
		#10;
        reset_min = 0;
        $monitor($time, "=>min= %d,carry_min= %d,enable_min= %b,reset_min= %b",count_min,carry_min,enable_min,reset_min);  		
    end
	
	always begin
        clock = ~clock;
        #1;
    end	 
   
    initial begin	
        #150 enable_min = 0;
        #20  enable_min = 1;
        #97  enable_min1 = 1;
        #3   enable_min1 = 0;
	end
	
	initial
        #1000 $finish;	

endmodule

