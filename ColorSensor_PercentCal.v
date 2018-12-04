`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 04:37:41 PM
// Design Name: 
// Module Name: PercentCalculator
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


module PercentCalculator(
     input CLK100MHZ,
     input reset,
     input [20:0] dividend,
     input [20:0] divisor,
     input per_on,
     output reg per_done = 0,
     output reg [9:0] percentage = 0
);
     reg [9:0] calc_per = 0;
     reg [4:0] state = 0;
     reg [18:0] sum = 0;
     parameter total       = 0,
               dividing    = 1,
               complete    = 2;

     always @ (posedge CLK100MHZ)
          if(reset || ~per_on) 
          begin
               state = 0;
               sum = 0;
               per_done = 0;
               calc_per = 0;
               percentage = 0;
          end
          else
          case(state)
               total:
                    if(per_on && divisor >= 0) 
                    begin
                         sum = dividend * 100 + divisor / 2;
                         state = dividing;
                    end
               dividing:
                    if(sum >= divisor) 
                    begin
                         sum = sum - divisor;
                         calc_per = calc_per + 1;
                         state = dividing;
                    end
                    else 
                    begin
                        state = complete;
                    end
               complete:
               begin
                    percentage = calc_per;
                    per_done = 1;
               end
          endcase

endmodule
