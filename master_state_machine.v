`timescale 1ns / 1ps

// currently using 7 states & 8 inputs
module top(
     input clk,
     input [1:0] IRS,
     input [1:0] Sense,
     input IPS,
     input [2:0] CS,
     // add??: input PT, 
     output reg enable_search = 0 // will be used to turn on seperate module
     );
     
     wire [7:0] inputs;
     assign inputs = {IRS[1], IRS[0], Sense[1], Sense[0], !IPS, CS[2], CS[1], CS[0]}; 
     
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
     reg state_next = S_Search;
     
     
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
                    8'b10_00_0_xxx: begin // Left IRS
                         state_next <= S_Avoid;
                    end
                    8'b01_00_0_xxx: begin // Right IRS
                         state_next <= S_Avoid;
                    end
                    8'b11_00_0_xxx: begin // Both IRS (RARE)
                         state_next <= S_Avoid;
                    end
                    8'bxx_1x_x_xxx: begin // Sense A
                         state_next <= S_Stall;
                    end
                    8'bxx_x1_x_xxx: begin // Sense B
                         state_next <= S_Stall;
                    end
                    8'bxx_xx_1_xxx: begin // IPS
                         state_next <= S_Grab;
                    end
                    endcase

               S_Avoid:
                    // not 100% how this state will work yet; might be a "go ... done" system instead
                    casex(inputs)
                    8'b10_xx_x_xxx: begin // Left IRS still
                         state_next <= S_Avoid;
                    end
                    8'b01_xx_x_xxx: begin // Right IRS still
                         state_next <= S_Avoid;
                    end
                    8'b11_xx_x_xxx: begin // Both IRS still (RARE)
                         state_next <= S_Avoid;
                    end
                    8'b00_xx_x_xxx: begin // Path is clear
                         state_next <= state_previous;
                    end
                    endcase   
          endcase

     
     // Process 2: Move next state into current state
     always @ (posedge clk)
          state_now <= state_next;

endmodule
