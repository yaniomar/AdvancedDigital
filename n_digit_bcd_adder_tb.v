`timescale 1ns/1ps

module n_digit_bcd_adder_tb;

    parameter N = 3;
    integer MAX_VAL = 10**N - 1;

    reg clk, rst;
    reg [4*N-1:0] A_in, B_in;
    reg Cin_in;
    wire [4*N-1:0] Sum_out;
    wire Cout_out;

    integer a, b;
    integer expected_sum, expected_bcd, actual_bcd;
    integer total_tests = 0;
    integer errors = 0;
    integer time_unit = 15;
				   
    n_digit_bcd_adder #(.N(N)) dut (
        .clk(clk),
        .rst(rst),
        .A_in(A_in),
        .B_in(B_in),
        .Cin_in(Cin_in),
        .Sum_out(Sum_out),
        .Cout_out(Cout_out)
    );
	   	 
    always #(time_unit / 2) clk = ~clk;
									
    function [4*N-1:0] int_to_bcd;
        input integer val;
        integer i;
        begin
            for (i = 0; i < N; i = i + 1)
                int_to_bcd[i*4 +: 4] = (val / (10**i)) % 10;
        end
    endfunction
									 
    function integer bcd_to_int;
        input [4*N-1:0] bcd;
        integer i;
        begin
            bcd_to_int = 0;
            for (i = 0; i < N; i = i + 1)
                bcd_to_int = bcd_to_int + (bcd[i*4 +: 4] * (10**i));
        end
    endfunction

    initial begin
        $display("Starting testbench for n_digit_bcd_adder (N = %0d)", N);

        clk = 0;
        rst = 1;
        Cin_in = 0;
        A_in = 0;
        B_in = 0;

        #time_unit rst = 0;

        for (a = 0; a <= MAX_VAL; a = a + 1) begin
            for (b = 0; b <= MAX_VAL; b = b + 1) begin
                A_in = int_to_bcd(a);
                B_in = int_to_bcd(b);
                Cin_in = 0;

                #time_unit;
                #time_unit;

                expected_sum = a + b;
                expected_bcd = expected_sum % (10**N);
                actual_bcd = bcd_to_int(Sum_out);
                total_tests = total_tests + 1;

                if ((expected_bcd != actual_bcd) ||
                    (expected_sum > MAX_VAL && Cout_out != 1) ||
                    (expected_sum <= MAX_VAL && Cout_out != 0)) begin
                    errors = errors + 1;
                    $display("%0d + %0d FAILED at time %t ns | Expected: %0d, Cout: %b | Got: %0d, Cout: %b",
                             a, b, $time, expected_bcd, (expected_sum > MAX_VAL), actual_bcd, Cout_out);
                end else begin
                    $display("%0d + %0d PASSED at time %t ns | Expected: %0d, Cout: %b | Got: %0d, Cout: %b",
                             a, b, $time, expected_bcd, (expected_sum > MAX_VAL), actual_bcd, Cout_out);
                end
            end
        end

        $display("==============================================");
        $display("Simulation completed at time: %t ns", $time);
        $display("Total tests run       : %0d", total_tests);
        $display("Total errors detected : %0d", errors);
        if (errors == 0)
            $display("All tests passed successfully!");
        else
            $display("Some tests failed. Review errors above.");
        $finish;
    end
endmodule
