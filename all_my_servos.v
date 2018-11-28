`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Hunter Fucking Book
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
output reg servo_follow,
output reg electro_magnet,
output reg color_servo
);

reg [25:0] increase_angle_counter;

reg [20:0] increase_angle;

reg [25:0] metal_count;

reg [21:0] count;

reg [3:0] state_count;

reg [29:0] big_count; 

reg [29:0] big_count_2;

reg kill_switch;

reg [20:0] kill_signal;

reg [20:0] kill_signal_2;

reg [20:0] kill_signal_3;

reg [20:0] kill_switch_2;

reg metal;

reg metal_1;

reg metal_2;

reg [5:0] degree;

reg [35:0] two_sweep_count;

reg [29:0] drop_count;

initial begin 
    increase_angle_counter=25'b0;
    increase_angle=20'b0;
    metal_count=25'b0;
    electro_magnet=1'b0;
    count = 21'b0;
    state_count = 1'b0;
    big_count = 29'b0;
    big_count_2 = 29'b0;
    kill_signal = 20'd65000;
    kill_switch_2 =1'b0;
    kill_switch = 1'b0;
    kill_signal_2 =1'b0;
    metal =1'b0;
    degree = 5'b0;
    two_sweep_count=35'b0;
    drop_count =29'b0;
    
end

always @(posedge clk) 
    begin 
        if(metal_count ==25'd1_000)
            begin 
                metal_count<=25'b0;
            end
        else 
            begin 
                metal_count<=metal_count+1'b1;
            end
            
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



if(!state_count)
begin

  electro_magnet=1'b0;
                       
  if(metal) 
    begin
     state_count = state_count +1'b1;
    end            
        //kill the electromagnet
//always @(posedge clk)                               //every .85 seconds we reset a toggle a value controling where we sweep to
    
        if(big_count == 29'd42_500_000)
            begin
                big_count <= 29'b0;
                kill_switch <= kill_switch +1'b1;
            end

        else 
            begin
                big_count <= big_count+1'b1;
            end
        

//always @(kill_switch)                           //when kill switch is toggled every .85 seconds we reset how long the signal is one
    
        if(kill_switch)
            begin
                kill_signal <= 20'd211_250;
            end      
        else
            begin 
                kill_signal <= 20'd113_750;
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

else if(state_count==1'b1)                                     //so metal is detected
begin
    
    electro_magnet=1'b1;
    
    //set a counter that will send us to the next state after two full sweeps 
    
        if(two_sweep_count==35'd400_000_000)
            begin
                two_sweep_count<=35'd0;
                state_count=state_count+1;
                
            end
        else 
            begin
                two_sweep_count = two_sweep_count+1'b1;
            end
    
    
    

    //send original servo back to 180 degrees send the electromagnet
    
        kill_signal <=20'd100_000;
    
    
    if (count<kill_signal)
        begin
            servo_sweep =1'b1;                  //all this sends our metal detector servo back to zero degrees
        end
    else 
        begin
            servo_sweep=1'b0;
        end
        
    
    //turn electromagnet on
    //create new turnback timer
    
    //create counter 
    
        
       
         if(big_count_2 == 29'd150_000_000)
             begin
                 big_count_2 <= 29'b0;
                 kill_switch_2 <= kill_switch_2 +1'b1;
                 
             end
 
         else 
         begin
             big_count_2 <= big_count_2+1'b1;
         end
       
       
       
         
           if(kill_switch_2)
               begin
                   kill_signal_2 <= 20'd260_000;
               end      
           else
               begin 
                   kill_signal_2 <= 20'd113_750;
               end
        
        
           if(count < kill_signal_2)
             begin 
                 servo_follow =1'b1;
             end
         else
              begin 
                 servo_follow =1'b0;
              end
     
end
     
else if(state_count==2'b10)                                    //we have picked up the metal 
    begin   

        //lets give it .8 seconds to get straight up before we drop it off 
        
        electro_magnet=1'b0;
        
        if(two_sweep_count==29'd100_000_000)
            begin
                two_sweep_count<=29'd0;
                state_count=state_count+1;
            end
        else 
            begin
                two_sweep_count=two_sweep_count+1'b1;
            end
           
           
         kill_signal_2=20'd162_500;
            
            if(count < kill_signal_2)
              begin 
                  servo_follow =1'b1;
              end
            else
               begin 
                  servo_follow =1'b0;
               end
       end
       
       
       
       
       
else if(state_count==2'b11) 
    begin 
        electro_magnet=1'b0;
        
            kill_signal_3=20'd130_000;
                if (count< kill_signal_3)
                    begin 
                        color_servo=1'b1;
                    end
                else    
                    begin 
                        color_servo=1'b0;
                    end
        
       
        
    end
    

    
    
    
end
 

endmodule

//--------------------------------------------------
