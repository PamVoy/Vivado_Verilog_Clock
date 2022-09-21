`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/18 12:09:59
// Design Name: 
// Module Name: FSM_01
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


module FSM_01(            // Finite state machine module
  
    input m_clk,          // clock from FPGA (50MHz) through Frequency Divider : ( 50MHz ) / ( 2^24) = 2.98 Hz
    input m_reset,
    input trigger,        // FPGA buttom pressed
    output reg m_load,    // control signal for loading time data ( sec, min, hour)
    output reg  m_alarm   // control signal for loading alarm clock's time data ( sec, min, hour)
 );   
 
    reg[1:0] present_state;         //  Finite state machine : present_state
    reg[1:0] next_state;            //  Finite state machine :  next_state
    parameter A=2'd0;               //  state A : clock mode activated
    parameter B=2'd1;               //  state B : load time data  mode activated
    parameter C=2'd2;               //  state C : alarm clock mode activated

	 
    always @ ( present_state or trigger or m_reset ) 
        case ( present_state )
            A: if (m_reset)              //  state A : clock mode activated & reset occured
                begin
                    next_state = A;      //  reset to default state A : clock mode activated & reset occured
                    m_load=1'b0;         // turn off control signal for loading time data ( sec, min, hour)
                    m_alarm=1'b0;        // turn off control signal for loading alarm clock's time data ( sec, min, hour)
                end	
				 
                else if (trigger)        // FPGA buttom pressed
                    begin
                        next_state = B;  //  state B : load time data  mode activated
                        m_load=1'b1;     // turn on control signal for loading time data ( sec, min, hour)
                        m_alarm=1'b0;    // turn off control signal for loading alarm clock's time data ( sec, min, hour)
                    end
					 
			     else 
				    begin
                        next_state = A;  //  remain in state A : clock mode activated
                        m_load=1'b0;     // turn off control signal for loading time data ( sec, min, hour)
                        m_alarm=1'b0;    // turn off control signal for loading alarm clock's time data ( sec, min, hour)
                   end 
					 
				
            B:  if (m_reset)             //  state B : load time data  mode activated  & reset occured
                begin
                    next_state = A;      //  reset to default state A : clock mode activated
                    m_load=1'b0;         // turn off control signal for loading time data ( sec, min, hour)
                    m_alarm=1'b0;        // turn off control signal for loading alarm clock's time data ( sec, min, hour)
                end	
				 
                else if (trigger)        // FPGA buttom pressed
                    begin
                        next_state = C;  //  state C : alarm clock mode activated
                        m_load=1'b0;     // turn off control signal for loading time data ( sec, min, hour)
                        m_alarm=1'b1;    // turn on control signal for loading alarm clock's time data ( sec, min, hour)
					end
					 
			     else 
				    begin
                        next_state = B;  //  remain in state B : load time data  mode activated
                        m_load=1'b1;     // turn on control signal for loading time data ( sec, min, hour)
                        m_alarm=1'b0;    // turn off control signal for loading alarm clock's time data ( sec, min, hour)
					end 

            C: if (m_reset)              // state C : alarm clock mode activated  & reset occured
                begin
                    next_state = A;      //  reset to default state A : clock mode activated
                    m_load=1'b0;         // turn off control signal for loading time data ( sec, min, hour)
                    m_alarm=1'b0;        // turn off control signal for loading alarm clock's time data ( sec, min, hour)
                end	
				 
                else if (trigger)         // FPGA buttom pressed
                    begin
                        next_state = A;   //  retrun to state A : clock mode activated
                        m_load=1'b0;      // turn off control signal for loading time data ( sec, min, hour)
                        m_alarm=1'b0;     // turn off control signal for loading alarm clock's time data ( sec, min, hour)
					end
					 
			     else 
				    begin
                        next_state = C;   //  state C : alarm clock mode activated
                        m_load=1'b0;      // turn off control signal for loading time data ( sec, min, hour)
                        m_alarm=1'b1;     // turn on control signal for loading alarm clock's time data ( sec, min, hour)
                   end 
					
            default : next_state = A;
	     endcase
	 	 
    always @ ( posedge m_clk )            
        present_state <= next_state;      // Finite state machine , state changing
	 
endmodule
