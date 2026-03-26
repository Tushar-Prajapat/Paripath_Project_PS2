module testbench;
    reg a, b;
    wire y;

    and_gate uut(.a(a), .b(b), .y(y));

    initial begin
        $dumpfile("test.vcd");   // saves waveform
        $dumpvars(0, testbench);

        a=0; b=0; #10;  // wait 10 time units
        a=0; b=1; #10;
        a=1; b=0; #10;
        a=1; b=1; #10;

        $display("Simulation done!");
        $finish;
    end
endmodule