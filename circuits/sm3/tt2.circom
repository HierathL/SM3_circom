pragma circom 2.0.0;

include "../binsum.circom";
include "gg.circom";
include "ss1.circom";

template TT2_0() {
    signal input a[32];
    signal input e[32];
    signal input f[32];
    signal input g[32];
    signal input h[32];
    signal input t[32];
    signal input w[32];
    signal output out[32];
    component gg = GG00(32);
    component ss1 = SS1();

    var i;
    
    for(i = 0;i<32;i++){
        gg.a[i] <== e[i];
        gg.b[i] <== f[i];
        gg.c[i] <== g[i];

        ss1.a[i] <== a[i];
        ss1.e[i] <== e[i];
        ss1.t[i] <== t[i];
    } 

    component sum = BinSum(32, 4);
    for (i=0; i<32; i++) {
        sum.in[0][i] <== gg.out[i];
        sum.in[1][i] <== h[i];
        sum.in[2][i] <== ss1.out[i];
        sum.in[3][i] <== w[i];
    }

    for (i=0; i<32; i++) {
        out[i] <== sum.out[i];
    }
}

template TT2_16() {
    signal input a[32];
    signal input e[32];
    signal input f[32];
    signal input g[32];
    signal input h[32];
    signal input t[32];
    signal input w[32];
    signal output out[32];
    component gg = GG16(32);
    component ss1 = SS1();

    var i;
    
    for(i = 0;i<32;i++){
        gg.a[i] <== e[i];
        gg.b[i] <== f[i];
        gg.c[i] <== g[i];

        ss1.a[i] <== a[i];
        ss1.e[i] <== e[i];
        ss1.t[i] <== t[i];
    } 

    component sum = BinSum(32, 4);
    for (i=0; i<32; i++) {
        sum.in[0][i] <== gg.out[i];
        sum.in[1][i] <== h[i];
        sum.in[2][i] <== ss1.out[i];
        sum.in[3][i] <== w[i];
    }

    for (i=0; i<32; i++) {
        out[i] <== sum.out[i];
    }
}