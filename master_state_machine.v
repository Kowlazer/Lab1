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
     input [2:0] color,
     input IRS,
     input IPS,
     output reg out, // IDK what this is yet...
     output reg enable_searching = 0
     );
     
     wire [4:0] inputs; // bus to combine all 3 input sources
     assign inputs = {IRS, IPS, color[2], color[1], color[0]};
     
     // Define states as parameters
     parameter S_Search = 0,    // Search field for washer.     Need to use: IRS, H-bridge (& pwm module), IPS, servo(s).
               S_Avoid = 1,     // Avoid obstacle.              Need to use:
               S_Grab = 2,      // Pick the washer up.          Need to use: E-mag, servo(s).
               S_Color = 3,     // Determine washer color.      Need to use: color sensor, maybe backlight. (Scan multiple times - if no color is found washer is dropped and needs to go back to S_Search)
               S_Corner = 4,    // Find correct corner LED.     Need to use: IRS, H-bridge (& pwm module), phototransistor (need to figure out mounting and if it needs a servo).
               S_Drop = 5,      // Drop the washer off.         Need to use: Servo(s), E-mag?
               S_Stalled = 6;   // Motors have stalled.         Need to use:


     // Create a register for the current state, initialize it to S_Search
     reg state_now = S_Search;
     // Create a register for the next state
     reg state_next;
     

     // Process 1: Determine next state and output
     always @ (state_now)
          case(state_now)
               S_Search:
                    casex(inputs) // dont care about color sensor bits
                    5'b00xxx: begin // no washer found, no object detected, still searching field
                         state_next <= S_Search;
                         enable_searching = 1; // turns on seperate searching module
                         // have this state output enable bit that tells movement module 
                         // multiplexer needed??
                    end
                    5'b10xxx: begin // IRS object detected
                         state_next <= S_Avoid;
                         enable_searching = 0; // ??
                         
                    end
                    5'b01xxx: begin // IPS washer detected
                         state_next <= S_Grab;
                         enable_searching = 0;
                    end
                    endcase
               
               S_Avoid:
                    casex(inputs) // needs a previous_state input to know where to return to
                    5'b10xxx: begin
                         state_next <= S_Avoid;
                    end
                    5'b00xxx: begin // needs prev_state
                         state_next <= S_Search;
                    end
                    5'b00xxx: begin // needs prev_state
                         state_next <= S_Corner;
                    end  
                    endcase
                    
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
