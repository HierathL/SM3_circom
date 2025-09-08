pragma circom 2.0.0;

include "xor3.circom";
include "rotate.circom";
include "ss1.circom";

template SS2(){
    signal input a[32];
    signal input e[32];
    signal input t[32];
    signal output out[32];
    var k;

    component ss1 = SS1();
    component rota = RotL(32,12);
    for(k=0; k<32; k++){
        ss1.a[k] <== a[k];
        ss1.e[k] <== e[k];
        ss1.t[k] <== t[k];
        rota.in[k] <== a[k];
    }
    
    component xor = Xor2(32);
    for(k=0; k<32; k++){
        xor.a[k] <== rota.out[k];
        xor.b[k] <== ss1.out[k];
    }

    for (k=0; k<32; k++) {
        out[k] <== xor.out[k];
    }
}