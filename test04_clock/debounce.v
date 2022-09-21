`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/18 18:34:44
// Design Name: 
// Module Name: debounce
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


module debounce(
   
    input wire inp,      // configration on FPGA buttom
    input wire cclk,     // clock from FPGA 50 MHz
    input wire clr,      // reset function , configration on FPGA switch
	input alarm_d,       // alarm clock mode index ; 0 = clock mode , 1 =  alarm clock mode
    output wire  outp    // output signal after debouncing
 );
	 
    reg delay1;
    reg delay2;
    reg delay3;
	 
    always @(posedge cclk or posedge clr )
        begin
            if (clr == 1)                // clr = reset
                begin  
					delay1 <= 1'b0;      // reset to 0
					delay2 <= 1'b0;
					delay3 <= 1'b0;
				end
				
        else if ( alarm_d == 0 )     // alarm clock mode index ; 0 = clock mode
				begin
					delay1 <= inp;       //  inp = press FPGA buttom
					delay2 <= delay1;   
					delay3 <= delay2;
				end
        end
		
    assign outp = delay1 & delay2 & delay3;  //  input & 2 delay signal  
	
endmodule
