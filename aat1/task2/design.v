module digital_clock (
    input  logic clk,
    input  logic rst,
    output logic [5:0] sec,   // 0–59
    output logic [3:0] min    // 0–9
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        sec <= 0;
        min <= 0;
    end
    else begin
        if (sec == 59) begin
            sec <= 0;
            if (min == 9)
                min <= 0;
            else
                min <= min + 1;
        end
        else begin
            sec <= sec + 1;
        end
    end
end

endmodule
