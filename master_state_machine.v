`timescale 1ns / 1ps

// ============================================================================
// Mealy State Machine
// Uses 2 processes:
//   1. Next State and Output Combinational Logic
//   2. State Register
// Output depends on current state and input (if we dont need this switch from Mealy to basic?)
// ============================================================================

module mealy(
     input clk,
     input [2:0] IRS, // [1:0]?
     input [2:0] Sense, // [1:0]? // Sense A & B from H-Bridge
     input IPS,
     input [3:0] CS, // [2:0]?
     
     output reg out, // ?
     output reg enable_search = 0 // will be used to turn on seperate module?
     );
     
     wire [8:0] inputs; // [7:0]? // input bus
     assign inputs = {IRS[2], IRS[1], Sense[2], Sense[1], !IPS, CS[3], CS[2], CS[1]}; 
////////// ^ Should I change so index starts at 0 not 1? 
     
     // Define states as parameters
     parameter S_Search = 0,    // Inputs: IRS, IPS, SenseA/B         Outputs: H-bridge, Servos
               S_Avoid = 1,     // Inputs: IRS, SenseA/B              Outputs: H-bridge
               S_Grab = 2,      // Inputs: None                       Outputs: E-mag, Servos
               S_Color = 3,     // Inputs: CS                         Outputs: None
               S_Corner = 4,    // Inputs: IRS, PT, SenseA/B          Outputs: H-bridge, Servos
               S_Drop = 5,      // Inputs: None                       Outputs: E-mag, Servos
               S_Stalled = 6;   // Inputs: SenseA/B                   Outputs: None

     // State registers
     reg state_previous = S_Search;
     reg state_now = S_Search;
     reg state_next;
     
     
     // Process 1: Determine next state and output (no outputs right now)
     always @ (state_now)
          case(state_now)
               S_Search:
                    state_previous <= S_Search; // used for S_Avoid & S_Stalled
                    casex(inputs)
                    8'b00_00_0_xxx: begin // no washer found, no object detected, still searching field
                         state_next <= S_Search;
                         enable_search = 1; // turns on seperate searching module
                    end
                         
////////// Figure out where to use x and where to use 0 to account for all possible cases                         
////////// Figure out how to do first two bits for IRS.. 1x & x1    or 01, 10, and 11 ???? 
                    8'b10_00_0_xxx: begin // Left IRS triggered
                         state_next <= S_Avoid;
                    end
                    8'b01_00_0_xxx: begin // Right IRS triggered
                         state_next <= S_Avoid;
                    end
                    8'b11_00_0_xxx: begin // Both IRS triggered - RARE!
                         state_next <= S_Avoid;
                    end
                         
                    8'bxx_1x_x_xxx: begin // Sense_A triggered
                         state_next <= S_Stall;
                    end
                    8'bxx_x1_x_xxx: begin // Sense_B triggered
                         state_next <= S_Stall;
                    end
                    8'bxx_xx_1_xxx: begin // IPS triggered
                         state_next <= S_Grab;
                    end
                    endcase
               
               
               
               
               
               S_Avoid:
                    casex(inputs) // needs a previous_state input to know where to return to
                    8'bxx_xx_x_xxx: begin // IRS still detects object
                         state_next <= S_Avoid;
                    end
                    8'bxx_xx_x_xxx: begin // Path is clear
                         state_next <= state_previous;
                    end
                    endcase
               
               
          endcase


     // Process 2: Move next state into current state
     always @ (posedge clk)
          state_now <= state_next;

endmodule
