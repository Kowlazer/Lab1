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
     input IRS,
     input IPS,
     input [3:0] CS,
     input [2:0] Sense,
     output reg out, // ?
     output reg enable_searching = 0
     );
     
     wire [7:0] inputs; // input bus
     assign inputs = {IRS, IPS, CS[3], CS[2], CS[1], Sense[2], Sense[1]}; // *** should I change so index starts at 0 not 1? 
     
     // Define states as parameters
     parameter S_Search = 0,    // Inputs: IRS, IPS, SenseA/B         Outputs: H-bridge, Servos
               S_Avoid = 1,     // Inputs:                            Outputs:
               S_Grab = 2,      // Inputs: Emag,                      Outputs: Servos
               S_Color = 3,     // Inputs: CS                         Outputs:
               S_Corner = 4,    // Inputs: IRS, PT, SenseA/B          Outputs: H-bridge, Servos
               S_Drop = 5,      // Inputs: Emag,                      Outputs: Servos
               S_Stalled = 6;   // Inputs: SenseA/B                   Outputs: H-bridge

     // State registers
     reg state_now = S_Search;
     reg state_next;
     reg state_previous;
     
     // *****
     // *****
     // ***** CURRENT TASK IS TO INCORPORATE SENSE A&B AS INPUTS INTO THE SEARCHING STATE *****
     // *****
     // *****

     // Process 1: Determine next state and output (no outputs right now)
     always @ (state_now)
          case(state_now)
               S_Search:
                    casex(inputs) // dont care about color sensor bits
                    7'b00xxx??: begin // no washer found, no object detected, still searching field
                         state_next <= S_Search;
                         enable_searching = 1; // turns on seperate searching module
                         // have this state output enable bit that tells movement module 
                         // multiplexer needed??
                    end
                    7'b10xxx??: begin // IRS detected object
                         state_next <= S_Avoid;
                         state_previous <= S_Search; // so Avoid state knows where to return to
                         enable_searching = 0; // ??
                         
                    end
                    7'b01xxx??: begin // IPS detected washer
                         state_next <= S_Grab;
                         enable_searching = 0;
                    end
                    7'b11xxx??: begin // What do we want to do when both IRS & IPS are activated?
                         state_next <= S_Grab;
                         enable_searching = 0;
                    end
                    endcase
               
               S_Avoid:
                    casex(inputs) // needs a previous_state input to know where to return to
                    7'b1xxxx??: begin // IRS still detects object
                         state_next <= S_Avoid;
                    end
                    7'b0xxxx??: begin // Path is clear
                         state_next <= state_previous;
                    end
                    endcase
               
               
               
               
               
               // IGNORE THE REST OF THE STATES FOR NOW
               
               
               
               
                    
               S_Grab:
                    casex(inputs)
                    5'b01xxx: begin // IPS still detects washer
                         state_next <= S_Grab;
                    end
                    5'b00xxx: begin
                         state_next <= S_Color;
                    end
                    endcase
               
               S_Color:
                    casex(inputs)
                    5'b00xxx: begin
                         state_next <= S_Color;
                    end
                    5'b00xxx: begin
                         state_next <= S_Corner;
                    end
                    endcase   
                    
               S_Corner:
                    casex(inputs)
                    5'b00xxx: begin
                         state_next <= S_Corner;
                    end
                    5'b00xxx: begin
                         state_next <= S_Drop;
                    end
                    endcase
                         
               S_Drop:
                    casex(inputs)
                    5'b00xxx: begin
                         state_next <= S_Drop;
                    end
                    5'b00xxx: begin
                         state_next <= S_Search;
                    end
                    endcase
               
               S_Stalled:
                    casex(inputs) // needs a previous_state input to know where to return to
                    5'b00xxx: begin
                         state_next <= S_Stalled;
                    end
                    5'b00xxx: begin
                         state_next <= S_Search;
                    end
                    5'b00xxx: begin
                         state_next <= S_Corner;
                    endcase
          endcase


     // Process 2: Move next state into current state
     always @ (posedge clk)
          state_now <= state_next;

endmodule
