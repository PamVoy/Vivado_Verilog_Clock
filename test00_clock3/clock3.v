`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/09 17:24:56
// Design Name: 
// Module Name: clock3
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


module clock(
    input clock,        
    input enable, 
    input reset, 
    input load1,          // load sec
    input load2,          // load min
    input load3,          // load hour  
    input [5:0] data1,    // load sec data   
    input [5:0] data2,    // load min data
    input [5:0] data3,    // load hour data
    output reg [5:0] sec, // 0~59
    output reg [5:0] min, // 0~59
    output reg [4:0] hour // 0~23
);
	 
     always @ (posedge clock)
        begin
            if (reset)begin                // reset all data = 0
                sec<=6'b000000; 
                min<=6'b000000; 
                hour<=5'b00000;
			end
		    
		    else if (load1)                // load sec data    
                sec<=data1; 
			else if (load2)                // load min data   
			    min<=data2;
            else if (load3)                // load hour data   
			    hour<=data3; 					 
			else if (hour==5'd23 && min==6'd59 && sec==6'd59)begin         //  time 23:59:59  -> 00:00:00
				hour<=5'b00000; 
				sec<=6'b000000; 
				min<=6'b000000;
			end
			
			else if (min==6'd59 && sec==6'd59) begin              //  time 00:59:59  -> 01:00:00
			    sec<=6'b000000; 
			    min<=6'b000000;
				hour<=hour+1;
			end
			
			else if (sec==6'd59) begin                           //  time 00:00:59  -> 00:01:00
		        sec<=6'b000000;
			    min<=min+1;
			end
			
		    else if (enable)                                     //  time 00:00:00  -> 00:00:01
		        sec<=sec+1;
        end
endmodule

