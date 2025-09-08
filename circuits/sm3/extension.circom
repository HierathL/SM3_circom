pragma circom 2.0.0;

include "../binsum.circom";
include "p.circom";
include "xor3.circom";
include "rotate.circom";

template Wj() {
    signal input in3[32];
    signal input in6[32];
    signal input in9[32];
    signal input in13[32];
    signal input in16[32];
    signal output out[32];
    var k;
    
    component rot3 = RotL(32,15);
    component rot13 = RotL(32,7);

    for (k=0; k<32; k++) {
        rot3.in[k] <== in3[k];
        rot13.in[k] <== in13[k];
    }

    component xor1 = Xor3(32);
    for (k=0; k<32; k++) {
        xor1.a[k] <== in16[k];
        xor1.b[k] <== in9[k];
        xor1.c[k] <== rot3.out[k];
    }

    component p1 = P(15,23);
    for (k=0; k<32; k++) {
        p1.in[k] <== xor1.out[k];
    }

    component xor2 = Xor3(32);
    for (k=0; k<32; k++) {
        xor2.a[k] <== p1.out[k];
        xor2.b[k] <== rot13.out[k];
        xor2.c[k] <== in6[k];
    }

    for (k=0; k<32; k++) {
        out[k] <== xor2.out[k];
    }
}

template Wj1(){
    signal input in[32];
    signal input in4[32];
    signal output out[32];
    var k;

    component xor = Xor2(32);
    for (k=0; k<32; k++) {
        xor.a[k] <== in[k];
        xor.b[k] <== in4[k];
    }

    for (k=0; k<32; k++) {
        out[k] <== xor.out[k];
    }


}
