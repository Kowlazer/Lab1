// Pulse Width Modulation (PWM) Signal Generator
// ===========================================================================
// Simple module generates a PWM signal using a counter and a comparator. 6-bit
// counter counts positive edges of the clock until it passes the maximum, then
// alternates. The duty cycle in percentage is the duty given / max of the
// counter * 100. So for a duty cycle of 50%, the user would input 32 because
// 32/63*100 is roughly 50%.
// ===========================================================================

`timescale 1ns / 1ps

module pwm_motors(
	input clk,
    input [5:0] duty,
	output reg PWM_output = 0
);
     // 6-bit counter can count up to 64
    reg [5:0] count = 0;
	always@(posedge clk)
	begin
		count <= count + 1;
		// If count is less than duty, then output is 1.
		// Otherwise, it's 0.
		PWM_output <= (count < duty);
	end
endmodule
