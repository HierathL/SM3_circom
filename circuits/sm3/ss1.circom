pragma circom 2.0.0;

include "rotate.circom";
include "../binsum.circom";

template SS1(){
    signal input a[32];
    signal input e[32];
    signal input t[32];
    signal output out[32];
    var k;

    component rota = RotL(32,12);
    for(k=0; k<32; k++){
        rota.in[k] <== a[k];
    }

    component sum = BinSum(32,3);
    for(k=0; k<32; k++){
        sum.in[0][k] <== rota.out[k];
        sum.in[1][k] <== e[k];
        sum.in[2][k] <== t[k];
    }

    component rots = RotL(32,7);
    for(k=0; k<32; k++){
        rots.in[k] <== sum.out[k];
    }

    for (k=0; k<32; k++) {
        out[k] <== rots.out[k];
    }
}