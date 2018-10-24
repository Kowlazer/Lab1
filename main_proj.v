`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2018 02:48:01 PM
// Design Name: 
// Module Name: main_proj
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


//module main_proj(
//    input clock,
//    input IR,
//    input [7:0] sw, // switches - NOT USING SW6 or SW7 anymore - was for manual direction control
//    output LeftPWMOut,
//    output RightPWMOut,
//    output reg [3:0] TankDir = 4'b0000 // reg is used for any variable assigned in an always@ statement using <=
//    );
    
//    wire [5:0] speed; // wire is used at any block asigned using an assign statement using continuous assignment
//    assign speed = sw[5:0];
    
//     // module instantiation
//       PWM_Motor L(
//           .PWMRate(speed),
//           .clock(clock),
//           .PWMOut(LeftPWMOut)
//       );
//       PWM_Motor R(
//           .PWMRate(speed),
//           .clock(clock),
//           .PWMOut(RightPWMOut)
//           );
       
//       always@(posedge clock)
//           begin
//               case(IR) // need another sensor and change to 2-bit thing
//                   1'b0: TankDir <= 4'b1001; // forward
//                   1'b1: TankDir <= 4'b0110; // reverse
//                   //2'b10: TankDir <= 4'b1010; // left
//                   //2'b01: TankDir <= 4'b0101; // right
//                   default: TankDir <= 4'b0000; // off
//               endcase
//           end
//endmodule
