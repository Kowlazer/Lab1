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
     input in, // I think this comes from the other modules as an input back into the state machine??
     output reg out // IDK what this is yet...
     );

     // Define states as parameters
     parameter S_Search = 0,    // Search field for washer.     Need to use: IRS, H-bridge (& pwm module), IPS, servo(s).
               S_Grab = 1,      // Pick the washer up.          Need to use: E-mag, servo(s).
               S_Color = 2,     // Determine washer color.      Need to use: color sensor, maybe backlight. (Scan multiple times - if no color is found washer is dropped and needs to go back to S_Search)
               S_Corner = 3,    // Find correct corner LED.     Need to use: IRS, H-bridge (& pwm module), phototransistor (need to figure out mounting and if it needs a servo).
               S_Drop = 4;      // Drop the washer off.         Need to use: Servo(s), E-mag?
               // May need states to reposition washer before picking up and dropping off the washer.


     // Create a register for the current state, initialize it to S_Search
     reg state_now = S_Search;
     // Create a register for the next state
     reg state_next;


     // Process 1: Determine next state and output
     always @ (state_now)
          case(state_now)
               S_Search:
                    case(in)
                    0: begin // no washer found, still searching field
                         state_next <= S_Search;
                         out = 0; // ????? becomes 'in' ??? IDK
                    end
                    1: begin
                         state_next <= S_Grab;
                         out = 1;
                    end
                    endcase
                    
               S_Grab:
                    case(in)
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
                    case(in)
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
                    case(in)
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
                    case(in)
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
