module fir_filter(
    input  clk,
    input  rst,
    input  signed [15:0] x_in,    // 16-bit input sample
    output signed [31:0] y_out    // 32-bit output
);

    // 16 coefficients in Q1.15 format
    wire signed [15:0] coeff [0:15];
    assign coeff[0]  = 16'b1111111111010101; // -43
    assign coeff[1]  = 16'b1111111101001111; // -177
    assign coeff[2]  = 16'b1111111001101010; // -406
    assign coeff[3]  = 16'b1111111010100001; // -351
    assign coeff[4]  = 16'b0000001010011100; // 668
    assign coeff[5]  = 16'b0000101110010010; // 2962
    assign coeff[6]  = 16'b0001011011010110; // 5846
    assign coeff[7]  = 16'b0001111011001100; // 7884
    assign coeff[8]  = 16'b0001111011001100; // 7884
    assign coeff[9]  = 16'b0001011011010110; // 5846
    assign coeff[10] = 16'b0000101110010010; // 2962
    assign coeff[11] = 16'b0000001010011100; // 668
    assign coeff[12] = 16'b1111111010100001; // -351
    assign coeff[13] = 16'b1111111001101010; // -406
    assign coeff[14] = 16'b1111111101001111; // -177
    assign coeff[15] = 16'b1111111111010101; // -43

    // 16 registers to store input history
    reg signed [15:0] shift_reg [0:15];

    integer i;

    // Shift register — shifts input every clock cycle
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 16; i = i + 1)
                shift_reg[i] <= 0;
        end else begin
            shift_reg[0] <= x_in;
            for (i = 1; i < 16; i = i + 1)
                shift_reg[i] <= shift_reg[i-1];
        end
    end

    // Multiply and accumulate
    wire signed [31:0] products [0:15];
    genvar j;
    generate
        for (j = 0; j < 16; j = j + 1) begin
            assign products[j] = shift_reg[j] * coeff[j];
        end
    endgenerate

    // Sum all products
    assign y_out = products[0]  + products[1]  + products[2]  + products[3]
                 + products[4]  + products[5]  + products[6]  + products[7]
                 + products[8]  + products[9]  + products[10] + products[11]
                 + products[12] + products[13] + products[14] + products[15];

endmodule

