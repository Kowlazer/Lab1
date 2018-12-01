module phototransistor(
    input clk,
    input JB0
    );
    
    reg [9:0] freqCount;
    reg [20:0] timer;
    integer freqResult; // change to a 2 bit thing??? 4 possible values
    
    initial begin
        timer <= 0;
        freqCount = 0;
        freqResult = 0;
    end
    
    always @ (posedge clk) begin
        timer <= timer + 1;
        
        if (timer == 1_000_000) begin
            timer <= 0;
            freqCount <= 0;
            freqResult <= 0;
        end
        
        if (timer > 990_000) begin
            if (freqCount >= 50 && freqCount <= 149)
                freqResult = 100;
            else if (freqCount >= 150 && freqCount <= 249)
                freqResult = 200;
            else if (freqCount >= 250 && freqCount <= 349)
                freqResult = 300;
            else if (freqCount >= 350 && freqCount <= 449)
                freqResult = 400;
            end
        end
    
        always @ (posedge JB0) begin
        freqCount = freqCount + 1;
        end
        
endmodule
