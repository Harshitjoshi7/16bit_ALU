module alu_16bit_cg (
    input clk, reset,
    input [15:0] A, B,
    input S2, S1, S0, cin,
    output reg [15:0] alu_out
);
    // Clock Gating Logic
    wire clk_lu = clk & (~S2); 
    wire clk_au = clk & S2;    

    reg [15:0] lu_out, au_out;

    // Logic Unit
    always @(posedge clk_lu or posedge reset) begin
        if (reset) lu_out <= 16'b0;
        else begin
            case ({S1, S0})
                2'b00: lu_out <= A & B;
                2'b01: lu_out <= A ^ B;
                2'b10: lu_out <= A | B;
                2'b11: lu_out <= ~B;
            endcase
        end
    end

    // Arithmetic Unit
    always @(posedge clk_au or posedge reset) begin
        if (reset) au_out <= 16'b0;
        else begin
            case ({S1, S0})
                2'b00: au_out <= A + B + cin; 
                2'b01: au_out <= A - B;
                default: au_out <= A + 1;
            endcase
        end
    end

    // Output Multiplexer
    always @(*) begin
        if (S2 == 0) alu_out = lu_out;
        else         alu_out = au_out;
    end
endmodule
