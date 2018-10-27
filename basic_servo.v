`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2018 06:39:37 PM
// Design Name: 
// Module Name: Test_servo
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


module Ififcase(

input clk,
input button,
input servo,
input metal_detector_1,
output reg servo_sweep,
output reg servo_follow
);

reg [21:0] count;

reg [29:0] big_count; 

reg [29:0] big_count_2;

reg kill_switch;

reg [20:0] kill_signal;

reg [20:0] kill_signal_2;

reg [20:0] kill_switch_2;

reg metal;

reg [5:0] degree;


initial begin 
    count = 21'b0;
    big_count = 29'b0;
    big_count_2 = 20'b0;
    kill_signal = 20'd65000;
    kill_switch_2 =1'b0;
    kill_switch = 1'b0;
    kill_signal_2 =1'b0;
    metal =1'b0;
    degree = 5'b0;
    
end

always @(posedge clk)                           //this module creates a counter that will create 20ms reset frequency
    begin 
        if(count==21'd2_000_000)                   
            begin 
                count <=21'b0;
            end
        else
            begin
                count <= count +1'b1;
            end 
   
    end
    
always@(posedge clk)                                //here we set a value metal to be high when we detect a washer
    begin 
        metal = ~metal_detector_1;
    end

always @(posedge clk)
begin   
if(!metal)
    begin
 
//always @(posedge clk)                               //every .85 seconds we reset a toggle a value controling where we sweep to
    begin
        if(big_count == 29'd85_000_000)
            begin
                big_count <= 27'b0;
                kill_switch <= kill_switch +1'b1;
            end

        else 
        begin
            big_count <= big_count+1'b1;
        end
end

//always @(kill_switch)                           //when kill switch is toggled every .85 seconds we reset how long the signal is one
    begin
        if(kill_switch)
            begin
                kill_signal <= 20'd260_000;
            end      
        else
            begin 
                kill_signal <= 20'd65_000;
            end
    end
    

//always @(posedge clk) begin                 //actually outputs the value of 1 when l
    if(count < kill_signal)
        begin 
            servo_sweep =1'b1;
        end
    else
         begin 
            servo_sweep =1'b0;
         end

end
