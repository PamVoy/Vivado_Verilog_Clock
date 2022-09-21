`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/17 01:08:27
// Design Name: 
// Module Name: top_one
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


module top_one(
    input clock,                    // clock from FPGA (25MHz) through Frequency Divider : ( 25MHz ) / ( 2^24) = 2.98 Hz
    input reset_n,
    input enable,      
    input load,                     // load time data mode :  FPGA DIP  switch trigger
	input setting1,                 // load sec data : FPGA bottom trigger                 
	input setting2,                 // load min data : FPGA bottom trigger      
	input setting3,                 // load hour data : FPGA bottom trigger 
    input [5:0] data_sec,           // time data : secound 6'd 0 ~ 6d' 59
	input [5:0] data_min,           // time data : minute  6'd 0 ~ 6d' 59
	input [5:0] data_hour,          // time data : hour 6'd 0 ~ 6d' 23
    output [5:0] count_sec,         // time data : secound 6'd 0 ~ 6d' 59
	 //reg [5:0] count_sec;
	output[5:0] count_min,          // time data : minute  6'd 0 ~ 6d' 59
	 //reg[5:0] count_min;
	output[5:0] count_hour,         // time data : hour 6'd 0 ~ 6d' 23
	 //reg[5:0] count_hour;
	output carry_hour               // hour_carry_out  for   day+1
	//reg  carry_sec, carry_min, carry_hour
); 
   
	 wire s_to_m;            //  for connection : sec_carry_out    to   enable_min_input     (module sec    to   module min)
	 wire s1_to_m;           //  for connection : sec_carry1_out    to   enable_min1_input     (module sec    to   module min)
	 wire m_to_h;            //  for connection : min_carry_out    to   enable_hour_input     (module min    to   module hour)
	 
	 
    counter_sec	go1( 
        .clock(clock),
        .reset_sec(reset_n),
        .enable_sec(enable),
        .load_sec(load),
        .setting_sec(setting1), 
        .data_sec(data_sec), 
        .count_sec(count_sec),   
        .carry_sec(s_to_m), 
        .carry_sec1(s1_to_m)
    );
	  
    counter_min go2( 
        .clock(clock),
        .reset_min(reset_n),
        .enable_min(s_to_m),
        .enable_min1(s1_to_m), 
        .load_min(load), 
        .setting_min(setting2),        
        .data_min(data_min), 
        .count_min(count_min),    
        .carry_min(m_to_h) 	   
    );  
    
    counter_hour go3( 
        .clock(clock), 
        .reset_hour(reset_n),
        .enable_hour(m_to_h),
        .load_hour(load), 
        .setting_hour(setting3), 
        .data_hour(data_hour),
        .count_hour(count_hour),    
        .carry_hour(carry_hour)
    );  
endmodule