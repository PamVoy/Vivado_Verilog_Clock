`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/16 22:48:02
// Design Name: 
// Module Name: counter_sec_tb
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


module counter_sec_tb;

	// Inputs
	reg clock;
	reg reset_sec;
	reg enable_sec;
	reg load_sec;
    reg [5:0] data_sec;

	// Outputs
	wire [5:0] count_sec;
	wire carry_sec;
	wire carry_sec1;

	// Instantiate the Unit Under Test (UUT)
	counter_sec uut (	 	 
		.clock(clock), 
		.reset_sec(reset_sec),
		.enable_sec(enable_sec),
		.load_sec(load_sec),
		.data_sec(data_sec),
		.count_sec(count_sec), 
		.carry_sec(carry_sec),
		.carry_sec1(carry_sec1)
	);

	initial begin
		// Initialize Inputs
		clock = 1;
        enable_sec = 1;
		reset_sec = 1;
	    data_sec = 0;
		load_sec = 0;
		#10;
        reset_sec = 0; 
        $monitor($time, "=>sec= %d,carry_sec= %d,carry_sec1= %d,enable_sec= %b,reset_sec= %b",count_sec,carry_sec,carry_sec1,enable_sec,reset_sec);  		
	end
	
	always begin
	    clock = ~clock;
	    #1;
    end	 
   
    initial begin	
	    #150 enable_sec = 0;
	    #20  enable_sec = 1;
	end
	
	initial
	    #1000 $finish;	
	
endmodule