//////////////////////////////////////////////////////////////////////////////////
// H-bridge PWM Mini Project:
// Uses 6 switches to control PWM speed & 2 switches to control H-bridge direction.
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module motors_mini_proj(
    input clock,
    input [7:0] sw,
    output LeftPWMOut,
    output RightPWMOut,
    output reg [3:0] TankDir = 4'b0000 // reg is used for any variable assigned in an always@ statement using <=
    );
    
    wire [5:0] speed; // wire is used at any block asigned using an assign statement using continuous assignment
    assign speed = sw[5:0];
    
    // IDK if the following three lines are needed > added when debugging > try removing
    wire pwm_L, pwm_R;
    assign LeftPWMOut = pwm_L;
    assign RightPWMOut = pwm_R;
    
    // module instantiation
    motors_pwm L(
        .clk(clock),
        .duty(speed),
        .PWM_output(pwm_L)
    );
    motors_pwm R(
            .clk(clock),
            .duty(speed),
            .PWM_output(pwm_R)
        );


    always@(posedge clock)
        begin
            case(sw[7:6])
                2'b00: TankDir <= 4'b0110; // forward
                2'b11: TankDir <= 4'b1001; // reverse
                2'b10: TankDir <= 4'b1010; // left
                2'b01: TankDir <= 4'b0101; // right
                default: TankDir <= 4'b0000; // off
            endcase
        end
endmodule
