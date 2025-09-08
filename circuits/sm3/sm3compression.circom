pragma circom 2.0.0;

include "sm3compression_function.circom";
include "extension.circom";
include "constants.circom";
include "tt1.circom";
include "tt2.circom";
include "ss1.circom";
include "ss2.circom";
include "../binsum.circom";
include "xor3.circom";



// template Sm3compression(){
//     signal input hin[256];//初始哈希值
//     signal input inp[512];//512bit消息快
//     signal output out[256];//输出哈希值
//     signal a[65][32];//8个迭代变量，每个变量65轮，每个值32bit
//     signal b[65][32];
//     signal c[65][32];
//     signal d[65][32];
//     signal e[65][32];
//     signal f[65][32];
//     signal g[65][32];
//     signal h[65][32];
//     signal w[68][32];
//     signal w1[64][32];

//     var outCalc[256] = sm3compression(hin, inp);

//     var i;
//     for (i=0; i<256; i++) out[i] <-- outCalc[i];

//     component extw[52];
//     for (i=0; i<52; i++) extw[i] = Wj();

//     component extw1[64];
//     for (i=0; i<64; i++) extw1[i] = Wj1();

//     component ct_k[64];
//     for (i=0; i<64; i++) ct_k[i] = K(i);

//     //有warning，下面没用到
//     //The value assigned to `ss2[i]` here does not influence witness or constraint generation.
//     // component ss1[64];
//     // for (i=0; i<64; i++) ss1[i] = SS1();

//     // component ss2[64];
//     // for (i=0; i<64; i++) ss2[i] = SS2();

//     //TT1和TT2需要分0，16
//     // component tt1[64];
//     // for (i=0; i<16; i++) tt1[i] = TT1_0();
//     // for (i=16; i<64; i++) tt1[i] = TT1_16();

//     // component tt2[64];
//     // for (i=0; i<16; i++) tt2[i] = TT2_0();
//     // for (i=16; i<64; i++) tt2[i] = TT2_16();

//     component p0[64];
//     for (i=0; i<64; i++) p0[i] = P(9,17);
    
//     component rotb[64];
//     for (i=0; i<64; i++) rotb[i] = RotL(32,9);

//     component rotf[64];
//     for (i=0; i<64; i++) rotf[i] = RotL(32,19);

//     component xor[8];
//     for (i=0; i<8; i++) xor[i] = Xor2(32);

//     var k;
//     var t;

//     //这里也出现了小端序的问题，原sha256用的是inp[t*32+31-k]
//     for (t=0; t<68; t++) {
//         if (t<16) {
//             for (k=0; k<32; k++) {
//                 w[t][k] <== inp[t*32+k];
//             }
//         } else {
//             for (k=0; k<32; k++) {
//                 extw[t-16].in3[k] <== w[t-3][k];
//                 extw[t-16].in6[k] <== w[t-6][k];
//                 extw[t-16].in9[k] <== w[t-9][k];
//                 extw[t-16].in13[k] <== w[t-13][k];
//                 extw[t-16].in16[k] <== w[t-16][k];
//             }
//             for (k=0; k<32; k++) {
//                 w[t][k] <== extw[t-16].out[k];
//             }
//         }
//     }

//     for (t=0; t<64; t++) {
//         for (k=0; k<32; k++) {
//             extw1[t].in[k] <== w[t][k];
//             extw1[t].in4[k] <== w[t+4][k];
//         }
//         for (k=0; k<32; k++) {
//             w1[t][k] <== extw1[t].out[k];
//         }
//     }

//     for (k=0; k<32; k++ ) {
//         a[0][k] <== hin[k];
//         b[0][k] <== hin[32*1 + k];
//         c[0][k] <== hin[32*2 + k];
//         d[0][k] <== hin[32*3 + k];
//         e[0][k] <== hin[32*4 + k];
//         f[0][k] <== hin[32*5 + k];
//         g[0][k] <== hin[32*6 + k];
//         h[0][k] <== hin[32*7 + k];
//     }
//     //TT1和TT2需要分0，16
//     component tt1_0[16],tt1_16[48];
//     component tt2_0[16],tt2_16[48];
//     for (i=0; i<16; i++) {
//         tt1_0[i] = TT1_0();
//         tt2_0[i] = TT2_0();
//         }
//     for (i=0; i<48; i++) {
//         tt1_16[i] = TT1_16();
//         tt2_16[i] = TT2_16();
//     }
//     var tt1[64][32];
//     var tt2[64][32];

//     for (t=0; t<64; t++) {
        
//         if(t<16){
//             //log("tt1_0",t);
//             for (k=0; k<32; k++) {
//                 tt1_0[t].a[k] <== a[t][k];
//                 tt1_0[t].b[k] <== b[t][k];
//                 tt1_0[t].c[k] <== c[t][k];
//                 tt1_0[t].d[k] <== d[t][k];
//                 tt1_0[t].e[k] <== e[t][k];
//                 tt1_0[t].t[k] <== ct_k[t].out[k];
//                 tt1_0[t].w1[k] <== w1[t][k];
                

//                 tt2_0[t].a[k] <== a[t][k];
//                 tt2_0[t].e[k] <== e[t][k];
//                 tt2_0[t].f[k] <== f[t][k];
//                 tt2_0[t].g[k] <== g[t][k];
//                 tt2_0[t].h[k] <== h[t][k];
//                 tt2_0[t].t[k] <== ct_k[t].out[k];
//                 tt2_0[t].w[k] <== w[t][k];
                
//             }
//             for(k=0; k<32; k++){
//                 tt1[t][k] = tt1_0[t].out[k];
//                 tt2[t][k] = tt2_0[t].out[k];
//                 //log(tt1[t][k]);
//             }
//         }else{
//             //log("tt1_16",t);
//             for (k=0; k<32; k++) {
//                 tt1_16[t-16].a[k] <== a[t][k];
//                 tt1_16[t-16].b[k] <== b[t][k];
//                 tt1_16[t-16].c[k] <== c[t][k];
//                 tt1_16[t-16].d[k] <== d[t][k];
//                 tt1_16[t-16].e[k] <== e[t][k];
//                 tt1_16[t-16].t[k] <== ct_k[t].out[k];
//                 tt1_16[t-16].w1[k] <== w1[t][k];
                

//                 tt2_16[t-16].a[k] <== a[t][k];
//                 tt2_16[t-16].e[k] <== e[t][k];
//                 tt2_16[t-16].f[k] <== f[t][k];
//                 tt2_16[t-16].g[k] <== g[t][k];
//                 tt2_16[t-16].h[k] <== h[t][k];
//                 tt2_16[t-16].t[k] <== ct_k[t].out[k];
//                 tt2_16[t-16].w[k] <== w[t][k];   
//             }
//             for(k=0; k<32; k++){
//                 tt1[t][k] = tt1_16[t-16].out[k];
//                 tt2[t][k] = tt2_16[t-16].out[k];
//                 //log(tt1[t][k]);
//             }
//         }

//         for (k=0; k<32; k++) {
//             p0[t].in[k] <== tt2[t].out[k];
//             rotb[t].in[k] <== b[t][k];
//             rotf[t].in[k] <== f[t][k];
//         }

//         for (k=0; k<32; k++) {
//             d[t+1][k] <== c[t][k];
//             c[t+1][k] <== rotb[t].out[k];
//             b[t+1][k] <== a[t][k];
//             a[t+1][k] <== tt1[t].out[k];
//             h[t+1][k] <== g[t][k];
//             g[t+1][k] <== rotf[t].out[k];
//             f[t+1][k] <== e[t][k];
//             e[t+1][k] <== p0[t].out[k];  
//         }
//     }

//     for (k=0; k<32; k++) {
//         xor[0].a[k] <==  hin[32*0+k];
//         xor[0].b[k] <==  a[64][k];
//         xor[1].a[k] <==  hin[32*1+k];
//         xor[1].b[k] <==  b[64][k];
//         xor[2].a[k] <==  hin[32*2+k];
//         xor[2].b[k] <==  c[64][k];
//         xor[3].a[k] <==  hin[32*3+k];
//         xor[3].b[k] <==  d[64][k];
//         xor[4].a[k] <==  hin[32*4+k];
//         xor[4].b[k] <==  e[64][k];
//         xor[5].a[k] <==  hin[32*5+k];
//         xor[5].b[k] <==  f[64][k];
//         xor[6].a[k] <==  hin[32*6+k];
//         xor[6].b[k] <==  g[64][k];
//         xor[7].a[k] <==  hin[32*7+k];
//         xor[7].b[k] <==  h[64][k];
//     }

//     for (k=0; k<32; k++) {
//         out[k]     === xor[0].out[k];
//         out[32+k]  === xor[1].out[k];
//         out[64+k]  === xor[2].out[k];
//         out[96+k]  === xor[3].out[k];
//         out[128+k] === xor[4].out[k];
//         out[160+k] === xor[5].out[k];
//         out[192+k] === xor[6].out[k];
//         out[224+k] === xor[7].out[k];
//     }
// }

template Sm3compression(){
    signal input hin[256];//初始哈希值
    signal input inp[512];//512bit消息快
    signal output out[256];//输出哈希值
    signal a[65][32];//8个迭代变量，每个变量65轮，每个值32bit
    signal b[65][32];
    signal c[65][32];
    signal d[65][32];
    signal e[65][32];
    signal f[65][32];
    signal g[65][32];
    signal h[65][32];
    signal w[68][32];
    signal w1[64][32];

    var outCalc[256] = sm3compression(hin, inp);

    var i;
    for (i=0; i<256; i++) out[i] <-- outCalc[i];

    component extw[52];
    for (i=0; i<52; i++) extw[i] = Wj();

    component extw1[64];
    for (i=0; i<64; i++) extw1[i] = Wj1();

    component ct_k[64];
    for (i=0; i<64; i++) ct_k[i] = K(i);

    component p0[64];
    for (i=0; i<64; i++) p0[i] = P(9,17);
    
    component rotb[64];
    for (i=0; i<64; i++) rotb[i] = RotL(32,9);

    component rotf[64];
    for (i=0; i<64; i++) rotf[i] = RotL(32,19);

    component xor[8];
    for (i=0; i<8; i++) xor[i] = Xor2(32);

    var k;
    var t;

    //这里也出现了小端序的问题，原sha256用的是inp[t*32+31-k]
    for (t=0; t<68; t++) {
        //log("t:",t);
        if (t<16) {
            for (k=0; k<32; k++) {
                w[t][k] <== inp[t*32+k];
            }
        } else {
            for (k=0; k<32; k++) {
                extw[t-16].in3[k] <== w[t-3][k];
                extw[t-16].in6[k] <== w[t-6][k];
                extw[t-16].in9[k] <== w[t-9][k];
                extw[t-16].in13[k] <== w[t-13][k];
                extw[t-16].in16[k] <== w[t-16][k];
            }
            //log("w",t);
            for (k=0; k<32; k++) {
                w[t][k] <== extw[t-16].out[k];
                //log(w[t][k]);
            }
        }
    }

    for (t=0; t<64; t++) {
        //log("t",t);
        for (k=0; k<32; k++) {
            extw1[t].in[k] <== w[t][k];
            extw1[t].in4[k] <== w[t+4][k];
            //log(w[t][k]);
        }
        for (k=0; k<32; k++) {
            w1[t][k] <== extw1[t].out[k];
            //log(extw1[t].out[k]);
        }
    }

    for (k=0; k<32; k++ ) {
        a[0][k] <== hin[k];
        b[0][k] <== hin[32*1 + k];
        c[0][k] <== hin[32*2 + k];
        d[0][k] <== hin[32*3 + k];
        e[0][k] <== hin[32*4 + k];
        f[0][k] <== hin[32*5 + k];
        g[0][k] <== hin[32*6 + k];
        h[0][k] <== hin[32*7 + k];
    }

    //TT1和TT2需要分0，16
    component tt1_0[16],tt1_16[48];
    component tt2_0[16],tt2_16[48];
    for (i=0; i<16; i++) {
        tt1_0[i] = TT1_0();
        tt2_0[i] = TT2_0();
        }
    for (i=0; i<48; i++) {
        tt1_16[i] = TT1_16();
        tt2_16[i] = TT2_16();
    }
    var tt1[64][32];
    var tt2[64][32];

    for (t=0; t<64; t++) {
        
        if(t<16){
            //log("tt1_0",t);
            for (k=0; k<32; k++) {
                tt1_0[t].a[k] <== a[t][k];
                tt1_0[t].b[k] <== b[t][k];
                tt1_0[t].c[k] <== c[t][k];
                tt1_0[t].d[k] <== d[t][k];
                tt1_0[t].e[k] <== e[t][k];
                tt1_0[t].t[k] <== ct_k[t].out[k];
                tt1_0[t].w1[k] <== w1[t][k];
                //log(tt1_0[t].w1[k]);

                tt2_0[t].a[k] <== a[t][k];
                tt2_0[t].e[k] <== e[t][k];
                tt2_0[t].f[k] <== f[t][k];
                tt2_0[t].g[k] <== g[t][k];
                tt2_0[t].h[k] <== h[t][k];
                tt2_0[t].t[k] <== ct_k[t].out[k];
                tt2_0[t].w[k] <== w[t][k];
                
            }
            //log("here");
            for(k=0; k<32; k++){
                tt1[t][k] = tt1_0[t].out[k];
                tt2[t][k] = tt2_0[t].out[k];
                //log(tt1[t][k]);
            }
        }else{
            //log("tt1_16",t);
            for (k=0; k<32; k++) {
                tt1_16[t-16].a[k] <== a[t][k];
                tt1_16[t-16].b[k] <== b[t][k];
                tt1_16[t-16].c[k] <== c[t][k];
                tt1_16[t-16].d[k] <== d[t][k];
                tt1_16[t-16].e[k] <== e[t][k];
                tt1_16[t-16].t[k] <== ct_k[t].out[k];
                tt1_16[t-16].w1[k] <== w1[t][k];
                

                tt2_16[t-16].a[k] <== a[t][k];
                tt2_16[t-16].e[k] <== e[t][k];
                tt2_16[t-16].f[k] <== f[t][k];
                tt2_16[t-16].g[k] <== g[t][k];
                tt2_16[t-16].h[k] <== h[t][k];
                tt2_16[t-16].t[k] <== ct_k[t].out[k];
                tt2_16[t-16].w[k] <== w[t][k];   
            }
            for(k=0; k<32; k++){
                tt1[t][k] = tt1_16[t-16].out[k];
                tt2[t][k] = tt2_16[t-16].out[k];
                //log(tt1[t][k]);
            }
        }

        for (k=0; k<32; k++) {
            p0[t].in[k] <== tt2[t][k];
            rotb[t].in[k] <== b[t][k];
            rotf[t].in[k] <== f[t][k];
        }

        for (k=0; k<32; k++) {
            d[t+1][k] <== c[t][k];
            c[t+1][k] <== rotb[t].out[k];
            b[t+1][k] <== a[t][k];
            a[t+1][k] <== tt1[t][k];
            h[t+1][k] <== g[t][k];
            g[t+1][k] <== rotf[t].out[k];
            f[t+1][k] <== e[t][k];
            e[t+1][k] <== p0[t].out[k];  
        }
    }

    for (k=0; k<32; k++) {
        xor[0].a[k] <==  hin[32*0+k];
        xor[0].b[k] <==  a[64][k];
        xor[1].a[k] <==  hin[32*1+k];
        xor[1].b[k] <==  b[64][k];
        xor[2].a[k] <==  hin[32*2+k];
        xor[2].b[k] <==  c[64][k];
        xor[3].a[k] <==  hin[32*3+k];
        xor[3].b[k] <==  d[64][k];
        xor[4].a[k] <==  hin[32*4+k];
        xor[4].b[k] <==  e[64][k];
        xor[5].a[k] <==  hin[32*5+k];
        xor[5].b[k] <==  f[64][k];
        xor[6].a[k] <==  hin[32*6+k];
        xor[6].b[k] <==  g[64][k];
        xor[7].a[k] <==  hin[32*7+k];
        xor[7].b[k] <==  h[64][k];
    }

    for (k=0; k<32; k++) {
        out[k]     === xor[0].out[k];
        out[32+k]  === xor[1].out[k];
        out[64+k]  === xor[2].out[k];
        out[96+k]  === xor[3].out[k];
        out[128+k] === xor[4].out[k];
        out[160+k] === xor[5].out[k];
        out[192+k] === xor[6].out[k];
        out[224+k] === xor[7].out[k];
    }
}