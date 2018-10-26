//////////////////////////////////////////////////////////////////////////////////
// H-bridge PWM Mini Project:
// Uses 6 switches to control PWM speed & 2 switches to control H-bridge direction.
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module motors_mini_proj(
    input clk,
    input [7:0] sw,
    output LeftPWMOut,
    output RightPWMOut,
    output reg [3:0] TankDir = 4'b0000 // reg is used for any variable assigned in an always@ statement using <=
    );
    
    wire [5:0] speed; // wire is used at any block asigned using an assign statement using continuous assignment
    assign speed = sw[5:0];
    
    // module instantiation
    motors_pwm(
        .duty(speed),
        .clk(clk),
        .PWM_output(LeftPWMOut),
        .PWM_output(RightPWMOut) // made motors use same PWM; may change later; if not make Left/RightPWMOut the same (in .xdc)
    );

    always@(posedge clk)
        begin
            case(sw[7:6])
                1'b0: TankDir <= 4'b1001; // forward
                1'b1: TankDir <= 4'b0110; // reverse
                2'b10: TankDir <= 4'b1010; // left
                2'b01: TankDir <= 4'b0101; // right
                default: TankDir <= 4'b0000; // off
            endcase
        end
endmodule
