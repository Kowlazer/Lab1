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
     input [3:0] color, // wire [4:0] - color needs to be 3 bits
     input IR,
     input IPS,
     output reg out, // IDK what this is yet...
     output reg enable_searching = 0
     );
     
     wire [4:0] inputs; // input bus
     assign inputs = {IR, IPS, color[3], color[2], color[1]};
     // Define states as parameters
     parameter S_Search = 0,    // Search field for washer.     Need to use: IRS, H-bridge (& pwm module), IPS, servo(s).
               S_Avoid = 1,
               S_Grab = 2,      // Pick the washer up.          Need to use: E-mag, servo(s).
               S_Color = 3,     // Determine washer color.      Need to use: color sensor, maybe backlight. (Scan multiple times - if no color is found washer is dropped and needs to go back to S_Search)
               S_Corner = 4,    // Find correct corner LED.     Need to use: IRS, H-bridge (& pwm module), phototransistor (need to figure out mounting and if it needs a servo).
               S_Drop = 5;      // Drop the washer off.         Need to use: Servo(s), E-mag?
               // May need states to reposition washer before picking up and dropping off the washer.


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
                    case(inputs)
                    0: begin
                         state_next <= S_Avoid;
                         out = 0;
                    end
                    1: begin
                         state_next <= S_Search;
                         out = 0;
                    end
                    1: begin
                         state_next <= S_Corner;
                         out = 0;
                    end  
                    endcase
                    
               S_Grab:
                    case(inputs)
                    0: begin
                         state_next <= S_Grab;
                         out = 0;
                    end
                    1: begin
                         state_next <= S_Color;
                         out = 0;
                    end
                    endcase
               
               S_Color:
                    case(inputs)
                    0: begin
                         state_next <= S_Color;
                         out = 0;
                    end
                    1: begin
                         state_next <= S_Corner;
                         out = 0;
                    end
                    endcase   
                    
               S_Corner:
                    case(inputs)
                    0: begin
                         state_next <= S_Corner;
                         out = 0;
                    end
                    1: begin
                         state_next <= S_Drop;
                         out = 0;
                    end
                    endcase
                         
               S_Drop:
                    case(inputs)
                    0: begin
                         state_next <= S_Drop;
                         out = 0;
                    end
                    1: begin
                         state_next <= S_Search;
                         out = 0; 
                    end
                    endcase
          endcase


     // Process 2: Move next state into current state
     always @ (posedge clk)
          state_now <= state_next;

endmodule



























//////////////////////////////////////////////////////////////////////////////////
// OLD VERSION USING MOORE
//////////////////////////////////////////////////////////////////////////////////

// Moore machine; output only depends on current state
module moore(
     input clk,
     input in,
     output reg out
     );

     // Define states as parameters
     parameter S0 = 000, // Searching
               S1 = 001, // Pick up
               S2 = 010, // Find color
               S3 = 011, // Find corner
               S4 = 100; // Drop off

     // Create a register for the current state, initialize it to S0
     reg state_now = S0;
     // Create a register for the next state
     reg state_next;

     // Determine next state
     always @ (state_now)
          case(state_now)
               S0:
                    case(in)
                    0: state_next <= S0;
                    1: state_next <= S1;
                    endcase
               S1:
                    case(in)
                    0: state_next <= S1;
                    1: state_next <= S2;
                    endcase
               S2:
                    case(in)
                    0: state_next <= S2;
                    1: state_next <= S3;
                    endcase
               S3:
                    case(in)
                    0: state_next <= S3;
                    1: state_next <= S4;
                    endcase 
               S4:
                    case(in)
                    0: state_next <= S4;
                    1: state_next <= S0;
                    endcase                   
          endcase

     // Move next state into current state
     always @ (posedge clk)
          state_now <= state_next;

     // Output according to current state
     always @ (state_now)
          case(state_now)
          S0: out = 000;
          S1: out = 001;
          S2: out = 010;
          S3: out = 011;
          S4: out = 100;
          endcase
endmodule
