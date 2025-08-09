module n_digit_bcd_adder(clk, rst, A_in, B_in, Cin_in, Sum_out, Cout_out);
    parameter N = 2;

    input [4*N-1:0] A_in, B_in;
    input Cin_in, clk, rst;
    output reg [4*N-1:0] Sum_out;
    output reg Cout_out;

    reg [4*N-1:0] A_reg, B_reg;
    reg Cin_reg;

    wire [4*N-1:0] Sum_wire;
    wire Cout_wire;

    wire [N:0] carry;
    assign carry[0] = Cin_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A_reg <= 0;
            B_reg <= 0;
            Cin_reg <= 0;
        end else begin
            A_reg <= A_in;
            B_reg <= B_in;
            Cin_reg <= Cin_in;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Sum_out <= 0;
            Cout_out <= 0;
        end else begin
            Sum_out <= Sum_wire;
            Cout_out <= Cout_wire;
        end
    end

    wire [4*N-1:0] s_wires;
    assign Sum_wire = s_wires;
    assign Cout_wire = carry[N];

    genvar j;
    generate
        for (j = 0; j < N; j = j + 1) begin : bcd_digit_adders
            wire [3:0] a_bits = A_reg[4*j+3 : 4*j];
            wire [3:0] b_bits = B_reg[4*j+3 : 4*j];
            wire [3:0] s_bits;
            wire c_in = carry[j];
            wire c_out;

            bcd_cla_adder bcd_adder(a_bits, b_bits, c_in, s_bits, c_out);

            assign s_wires[4*j+3 : 4*j] = s_bits;
            assign carry[j+1] = c_out;
        end
    endgenerate
endmodule
