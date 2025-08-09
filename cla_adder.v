module cla_adder(A, B, Cin, Sum, Cout);
    input [3:0] A, B;
    input Cin;
    output [3:0] Sum;
    output Cout;

    wire [3:0] G, P, C;

    and #11 g0(G[0], A[0], B[0]);
    and #11 g1(G[1], A[1], B[1]);
    and #11 g2(G[2], A[2], B[2]);
    and #11 g3(G[3], A[3], B[3]);

    xor #15 p0(P[0], A[0], B[0]);
    xor #15 p1(P[1], A[1], B[1]);
    xor #15 p2(P[2], A[2], B[2]);
    xor #15 p3(P[3], A[3], B[3]);

    assign C[0] = Cin;

    wire c1_part;
    and #11 a1(c1_part, P[0], Cin);
    or  #11 o1(C[1], G[0], c1_part);

    wire c2_p1, c2_p2;
    and #11 a2_1(c2_p1, P[1], G[0]);
    and #11 a2_2(c2_p2, P[1], P[0], Cin);
    or  #11 o2(C[2], G[1], c2_p1, c2_p2);

    wire c3_p1, c3_p2, c3_p3;
    and #11 a3_1(c3_p1, P[2], G[1]);
    and #11 a3_2(c3_p2, P[2], P[1], G[0]);
    and #11 a3_3(c3_p3, P[2], P[1], P[0], Cin);
    or  #11 o3(C[3], G[2], c3_p1, c3_p2, c3_p3);

    wire co1, co2, co3, co4;
    and #11 a4_1(co1, P[3], G[2]);
    and #11 a4_2(co2, P[3], P[2], G[1]);
    and #11 a4_3(co3, P[3], P[2], P[1], G[0]);
    and #11 a4_4(co4, P[3], P[2], P[1], P[0], Cin);
    or  #11 o4(Cout, G[3], co1, co2, co3, co4);

    xor #15 s0(Sum[0], P[0], C[0]);
    xor #15 s1(Sum[1], P[1], C[1]);
    xor #15 s2(Sum[2], P[2], C[2]);
    xor #15 s3(Sum[3], P[3], C[3]);
endmodule
