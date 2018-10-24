`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Texas Tech University
// Engineer: Braydon Westmoreland (R11384249)
// 
// Create Date: 09/13/2018 06:02:01 PM
// Module Name: PWM_Motor
// Project Name: Lab 1 H-bridge Mini Project
//////////////////////////////////////////////////////////////////////////////////

module PWM_Motor(
    input [5:0] PWMRate,
    input clock,
    output reg PWMOut = 0
    );
    
    reg[5:0] count = 0;
    
    always@(posedge clock) // trigger statement - inside () is the "sensitivity list"
        begin
            PWMOut <= (count < PWMRate);
            count = count + 1; // swapped lines with above - delete comment if no errors
        end
endmodule

