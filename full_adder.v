module full_adder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;

    wire xor1_out, and1_out, and2_out;

    xor #15 xor1(xor1_out, a, b);
    xor #15 xor2(sum, xor1_out, cin);

    and #11 and1(and1_out, a, b);
    and #11 and2(and2_out, xor1_out, cin);
    or  #11 or1(cout, and1_out, and2_out);
endmodule
