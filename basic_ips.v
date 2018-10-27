
always@(posedge clk)
  begin
    if (!SIGNAL) begin
      LED = 1'b1;
    end
    else if (SINGAL) begin
      LED = 1'b0;
    end
end
