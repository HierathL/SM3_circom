pragma circom 2.0.0;

include "xor3.circom";
include "rotate.circom";

template P(ra, rb) {
    signal input in[32];
    signal output out[32];
    var k;

    component rota = RotL(32, ra);
    component rotb = RotL(32, rb);
    for (k=0; k<32; k++) {
        rota.in[k] <== in[k];
        rotb.in[k] <== in[k];
    }

    component xor3 = Xor3(32);

    for (k=0; k<32; k++) {
        xor3.a[k] <== in[k];
        xor3.b[k] <== rotb.out[k];
        xor3.c[k] <== rota.out[k];
    }

    for (k=0; k<32; k++) {
        out[k] <== xor3.out[k];
    }
}
