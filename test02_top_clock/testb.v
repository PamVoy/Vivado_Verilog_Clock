`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/17 01:11:51
// Design Name: 
// Module Name: testb
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

module testb;

	// Inputs
	reg clock;
	reg reset_n;
	reg enable;
	reg load;
	reg [5:0] data_sec;
	reg [5:0] data_min;
	reg [5:0] data_hour;
	
	// Outputs
	wire [5:0] count_sec;
	wire [5:0] count_min;
	wire [5:0] count_hour;
	wire carry_hour;

	// Instantiate the Unit Under Test (UUT)
	top_one uut (
        .clock(clock),
        .reset_n(reset_n),
		.enable(enable), 
		.load(load), 		 
		.data_sec(data_sec), 
		.count_sec(count_sec), 
		.data_min(data_min), 
		.count_min(count_min), 
		.data_hour(data_hour), 
		.count_hour(count_hour), 
		.carry_hour(carry_hour)
		
	);

	initial begin
		// Initialize Inputs
		clock = 0;
		reset_n = 1;
		enable = 1;
		load = 0;		
		data_sec = 0;
		data_min = 0;
		data_hour = 0;	
        #10;
        reset_n = 0; 
        //$monitor($time, "=>hour= %d, min= %d, sec= %d, enable= %b, reset= %b",count_hour,count_min,count_sec,enable,reset_n);  
        $monitor($time, "=> Time (hour : min : sec) = (%d : %d : %d) , enable= %b, reset= %b",count_hour,count_min,count_sec,enable,reset_n);  	
	end  
        
		// Add stimulus here
    always begin
        clock = ~clock;
        #0.001;
    end	 
   
   //initial begin	
	 //#150 enable_sec = 0;
	 //#20  enable_sec = 1;
	 //end
	
    initial
    #1000 $finish;	
	
endmodule      
