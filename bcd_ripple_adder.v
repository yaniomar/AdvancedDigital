module bcd_ripple_adder(a, b, cin, s, carry);
    input [3:0] a, b;
    input cin;
    output [3:0] s;
    output carry;

    wire [3:0] Q;
    wire cout, ignoredCout;
    wire [3:0] correction = 4'b0110;

    ripple_adder ra1(a, b, cin, Q, cout);
    assign carry = cout | (Q[3] & (Q[2] | Q[1]));  // Approximate over-9 detection

    wire [3:0] over9handle = carry ? correction : 4'b0000;

    ripple_adder ra2(Q, over9handle, 1'b0, s, ignoredCout);
endmodule
