pragma circom 2.0.0;

include "../binsum.circom";
include "ff.circom";
include "ss1.circom";
include "ss2.circom";

template TT1_0() {
    signal input a[32];
    signal input b[32];
    signal input c[32];
    signal input d[32];
    signal input e[32];
    signal input t[32];
    signal input w1[32];
    signal output out[32];
    component ff = FF00(32);

    var i;

    for(i = 0;i<32;i++){
        ff.a[i] <== a[i];
        ff.b[i] <== b[i];
        ff.c[i] <== c[i];
    }

    component ss2 = SS2();
    for(i = 0; i<32;i++){
        ss2.a[i] <== a[i];
        ss2.e[i] <== e[i];
        ss2.t[i] <== t[i];
    } 

    component sum = BinSum(32, 4);
    for (i=0; i<32; i++) {
        sum.in[0][i] <== ff.out[i];
        sum.in[1][i] <== d[i];
        sum.in[2][i] <== ss2.out[i];
        sum.in[3][i] <== w1[i];
    }

    for (i=0; i<32; i++) {
        out[i] <== sum.out[i];
    }
}

template TT1_16() {
    signal input a[32];
    signal input b[32];
    signal input c[32];
    signal input d[32];
    signal input e[32];
    signal input t[32];
    signal input w1[32];
    signal output out[32];
    component ff = FF16(32);

    var i;

    for(i = 0;i<32;i++){
        ff.a[i] <== a[i];
        ff.b[i] <== b[i];
        ff.c[i] <== c[i];
    }

    component ss2 = SS2();
    for(i = 0; i<32;i++){
        ss2.a[i] <== a[i];
        ss2.e[i] <== e[i];
        ss2.t[i] <== t[i];
    } 

    component sum = BinSum(32, 4);
    for (i=0; i<32; i++) {
        sum.in[0][i] <== ff.out[i];
        sum.in[1][i] <== d[i];
        sum.in[2][i] <== ss2.out[i];
        sum.in[3][i] <== w1[i];
    }

    for (i=0; i<32; i++) {
        out[i] <== sum.out[i];
    }
}

// template TT1(j) {
//     signal input a[32];
//     signal input b[32];
//     signal input c[32];
//     signal input d[32];
//     signal input e[32];
//     signal input t[32];
//     signal input w1[32];
//     signal output out[32];
//     component ff;

//     var i;
//     if(j == 0){
//         ff = FF00(32);
//         for(i = 0;i<32;i++){
//             ff.a[i] <== a[i];
//             ff.b[i] <== b[i];
//             ff.c[i] <== c[i];
//         }
//     }else{
//         ff = FF16(32);
//         for(i = 0;i<32;i++){
//             ff.a[i] <== a[i];
//             ff.b[i] <== b[i];
//             ff.c[i] <== c[i];
//         }
//     }

//     component ss2 = SS2();
//     for(i = 0; i<32;i++){
//         ss2.a[i] <== a[i];
//         ss2.e[i] <== e[i];
//         ss2.t[i] <== t[i];
//     } 

//     component sum = BinSum(32, 4);
//     for (i=0; i<32; i++) {
//         sum.in[0][i] <== ff.out[i];
//         sum.in[1][i] <== d[i];
//         sum.in[2][i] <== ss2.out[i];
//         sum.in[3][i] <== w1[i];
//     }

//     for (i=0; i<32; i++) {
//         out[i] <== sum.out[i];
//     }
// }
