module fir_tb;
    reg clk, rst;
    reg signed [15:0] x_in;
    wire signed [31:0] y_out;
    fir_filter uut(
        .clk(clk),
        .rst(rst),
        .x_in(x_in),
        .y_out(y_out)
    );
    always #5 clk = ~clk;
    integer i;
    initial begin
        $dumpfile("fir_test.vcd");
        $dumpvars(0, fir_tb);
        clk = 0;
        rst = 1;
        x_in = 0;
        #20 rst = 0;
        for (i = 0; i < 30; i = i + 1) begin
            x_in = 16'd1000;
            #10;
        end
        $display("Simulation complete!");
        $finish;
    end
endmodule
