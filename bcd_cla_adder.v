module bcd_cla_adder(a, b, cin, s, carry);
    input [3:0] a, b;
    input cin;
    output [3:0] s;
    output carry;

    wire [3:0] Q;
    wire cout, ignoredCout;

    cla_adder cla1(a, b, cin, Q, cout);

    wire condition1, condition2;
    and #11 a1(condition1, Q[3], Q[2]);
    and #11 a2(condition2, Q[3], Q[1]);
    or  #11 over9(Q_gt_9, condition1, condition2);

    or  #11 c_out(carry, cout, Q_gt_9);

    wire [3:0] correction = carry ? 4'b0110 : 4'b0000;
    cla_adder cla2(Q, correction, 1'b0, s, ignoredCout);
endmodule
