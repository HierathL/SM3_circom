pragma circom 2.1.6;

template H(x) {
    signal output out[32];
    var c[8] = [0x7380166f,
             0x4914b2b9,
             0x172442d7,
             0xda8a0600,
             0xa96f30bc,
             0x163138aa,
             0xe38dee4d,
             0xb0fb0e4e];
    //这里有问题，现在是按照sha的代码，小端序解析，需要修改为大端序。
    //这里就导致了rotate的右移位是左移位
    //compression_function 中对H重新计算十进制的函数中，也有问题。
    for (var i=0; i<32; i++) {
        out[i] <== (c[x] >> i) & 1;
    }
    
}

template Xor3(n) {
    signal input a[n];
    signal input b[n];
    signal input c[n];
    signal output out[n];
    signal mid[n];

    for (var k=0; k<n; k++) {
        mid[k] <== b[k]*c[k];
        out[k] <== a[k] * (1 -2*b[k]  -2*c[k] +4*mid[k]) + b[k] + c[k] -2*mid[k];
    }
}

template Xor2(n){
    signal input a[n];
    signal input b[n];
    signal output out[n];
    signal mid[n];

    for (var k=0; k<n; k++) {
        mid[k] <== 2*a[k]*b[k];
        out[k] <== a[k]+b[k]-mid[k];
    }
}

function nbits(a) {
    var n = 1;
    var r = 0;
    while (n-1<a) {
        r++;
        n *= 2;
    }
    return r;
}

//ops个n位操作数进行求和，输出长度根据nbits()计算
template BinSum(n, ops) {
    var nout = nbits((2**n -1)*ops);
    signal input in[ops][n];
    signal output out[nout];

    var lin = 0;
    var lout = 0;

    var k;
    var j;

    var e2;

    e2 = 1;
    for (k=0; k<n; k++) {
        for (j=0; j<ops; j++) {
            lin += in[j][k] * e2;
        }
        e2 = e2 + e2;
    }

    e2 = 1;
    for (k=0; k<nout; k++) {
        //lin是十进制的结果，转为二进制数组out[]
        out[k] <-- (lin >> k) & 1;

        // Ensure out is binary
        out[k] * (out[k] - 1) === 0;

        lout += out[k] * e2;

        e2 = e2+e2;
    }

    // Ensure the sum;

    lin === lout;
}


template K(x) {
    signal output out[32];
    var c[64] = [
        0x79cc4519, 0xf3988a32, 0xe7311465, 0xce6228cb,
        0x9cc45197, 0x3988a32f, 0x7311465e, 0xe6228cbc,
        0xcc451979, 0x988a32f3, 0x311465e7, 0x6228cbce,
        0xc451979c, 0x88a32f39, 0x11465e73, 0x228cbce6,
        0x9d8a7a87, 0x3b14f50f, 0x7629ea1e, 0xec53d43c,
        0xd8a7a879, 0xb14f50f3, 0x629ea1e7, 0xc53d43ce,
        0x8a7a879d, 0x14f50f3b, 0x29ea1e76, 0x53d43cec,
        0xa7a879d8, 0x4f50f3b1, 0x9ea1e762, 0x3d43cec5,
        0x7a879d8a, 0xf50f3b14, 0xea1e7629, 0xd43cec53,
        0xa879d8a7, 0x50f3b14f, 0xa1e7629e, 0x43cec53d,
        0x879d8a7a, 0x0f3b14f5, 0x1e7629ea, 0x3cec53d4,
        0x79d8a7a8, 0xf3b14f50, 0xe7629ea1, 0xcec53d43,
        0x9d8a7a87, 0x3b14f50f, 0x7629ea1e, 0xec53d43c,
        0xd8a7a879, 0xb14f50f3, 0x629ea1e7, 0xc53d43ce,
        0x8a7a879d, 0x14f50f3b, 0x29ea1e76, 0x53d43cec,
        0xa7a879d8, 0x4f50f3b1, 0x9ea1e762, 0x3d43cec5
        ];

    for (var i=0; i<32; i++) {
        out[i] <== (c[x] >> i) & 1;
    }
}

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



template FF00(n) {
    signal input a[n];
    signal input b[n];
    signal input c[n];
    signal output out[n];

    signal p[n];  // b[k] + c[k]
    signal q[n];  // b[k] * c[k]
    signal r[n];  // 1 - 2 * a[k]
    signal s[n];  // q * r

    for (var k = 0; k < n; k++) {
        p[k] <== b[k] + c[k];
        q[k] <== b[k] * c[k];
        r[k] <== 1 - 2 * a[k];
        s[k] <== q[k] * r[k];

        out[k] <== a[k] + b[k] + c[k] - 2 * a[k] * p[k] - 2 * s[k];
    }
}

template FF16(n) {
    signal input a[n];
    signal input b[n];
    signal input c[n];
    signal output out[n];

    signal ab[n];
    signal ac[n];
    signal bc[n];

    for (var k = 0; k < n; k++) {
        ab[k] <== a[k] * b[k];
        ac[k] <== a[k] * c[k];
        bc[k] <== b[k] * c[k];

        out[k] <== ab[k] + ac[k] + bc[k] - 2*a[k] * bc[k];
        //out[k] * (1 - out[k]) === 0;
    }
}

template GG00(n) {
    signal input a[n];
    signal input b[n];
    signal input c[n];
    signal output out[n];

    signal p[n];  // b[k] + c[k]
    signal q[n];  // b[k] * c[k]
    signal r[n];  // 1 - 2 * a[k]
    signal s[n];  // q * r

    for (var k = 0; k < n; k++) {
        p[k] <== b[k] + c[k];
        q[k] <== b[k] * c[k];
        r[k] <== 1 - 2 * a[k];
        s[k] <== q[k] * r[k];

        out[k] <== a[k] + b[k] + c[k] - 2 * a[k] * p[k] - 2 * s[k];
    }
}

template GG16(n){
    signal input a[n];
    signal input b[n];
    signal input c[n];
    signal output out[n];

    for (var k=0; k<n; k++) {

        out[k] <== a[k] * (b[k]-c[k]) + c[k];
    }
}

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
        xor3.b[k] <== rota.out[k];
        xor3.c[k] <== rotb.out[k];
    }

    for (k=0; k<32; k++) {
        out[k] <== xor3.out[k];
    }
}

template RotL(n, r) {
    signal input in[n];
    signal output out[n];

    for (var i=0; i<n; i++) {
        out[i] <== in[ (i+r)%n ];
    }
}

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

function lrot(x, n) {
    return ((x << n) | (x >> (32-n))) & 0xFFFFFFFF;
}

function ff00(x,y,z) {
    return x ^ y ^ z;
}

function ff16(x,y,z) {
    return (x&y) ^ (x&z) ^ (y&z);
}

function gg00(x,y,z){
    return x ^ y ^ z;
}

function gg16(x, y, z) {
    return (x & y) ^ ((0xFFFFFFFF ^x) & z);
}

function p0(x) {
    return x ^ lrot(x,9) ^ lrot(x,17);
}

function p1(x) {
    return x ^ lrot(x,15) ^ lrot(x,23);
}

//压缩函数
function sm3compression(hin, inp) {
    var H[8];
    var a;
    var b;
    var c;
    var d;
    var e;
    var f;
    var g;
    var h;
    var out[256];

    //Tj<<j常数
    var smk[64] = [
        0x79cc4519, 0xf3988a32, 0xe7311465, 0xce6228cb,
        0x9cc45197, 0x3988a32f, 0x7311465e, 0xe6228cbc,
        0xcc451979, 0x988a32f3, 0x311465e7, 0x6228cbce,
        0xc451979c, 0x88a32f39, 0x11465e73, 0x228cbce6,
        0x9d8a7a87, 0x3b14f50f, 0x7629ea1e, 0xec53d43c,
        0xd8a7a879, 0xb14f50f3, 0x629ea1e7, 0xc53d43ce,
        0x8a7a879d, 0x14f50f3b, 0x29ea1e76, 0x53d43cec,
        0xa7a879d8, 0x4f50f3b1, 0x9ea1e762, 0x3d43cec5,
        0x7a879d8a, 0xf50f3b14, 0xea1e7629, 0xd43cec53,
        0xa879d8a7, 0x50f3b14f, 0xa1e7629e, 0x43cec53d,
        0x879d8a7a, 0x0f3b14f5, 0x1e7629ea, 0x3cec53d4,
        0x79d8a7a8, 0xf3b14f50, 0xe7629ea1, 0xcec53d43,
        0x9d8a7a87, 0x3b14f50f, 0x7629ea1e, 0xec53d43c,
        0xd8a7a879, 0xb14f50f3, 0x629ea1e7, 0xc53d43ce,
        0x8a7a879d, 0x14f50f3b, 0x29ea1e76, 0x53d43cec,
        0xa7a879d8, 0x4f50f3b1, 0x9ea1e762, 0x3d43cec5
        ];

    //解析初始IV,大端序    
    for (var i=0; i<8; i++) {
        H[i] = 0;
        for (var j=0; j<32; j++) {
            H[i] += hin[i*32+31-j] << j;
        }
    }

    a=H[0];
    b=H[1];
    c=H[2];
    d=H[3];
    e=H[4];
    f=H[5];
    g=H[6];
    h=H[7];
    var w1[64];
    var w[68];
    var SS1;
    var SS2;
    var TT1;
    var TT2;

    //解析 inp 512 位数据块
    //inp[512] 存储的是 512 位的 SHA-256 数据块，每 32 位解析成 w[i]
    for (var i = 0;i<68;i++){
        if (i<16) {
            w[i]=0;
            for (var j=0; j<32; j++) {
                w[i] +=  inp[i*32+31-j]<<j;
            }
            
        } else {
            w[i] = p1(w[i-16] ^ w[i-9] ^ lrot(w[i-3],15)) ^ lrot(w[i-13],7) ^ w[i-6];
        }
        //测试
        //log("w",i,w[i]);    
    }

    for (var i=0; i<64; i++) {
        w1[i]=w[i] ^ w[i+4];

        SS1 = lrot((lrot(a,12) + e + smk[i]) & 0xFFFFFFFF,7);
        SS2 = (SS1 ^ lrot(a,12)) & 0xFFFFFFFF;

        if(i<16){
            TT1 = (ff00(a,b,c) + d + SS2 + w1[i]) & 0xFFFFFFFF;
            TT2 = (gg00(e,f,g) + h + SS1 + w[i]) & 0xFFFFFFFF;
        }else{
            TT1 = (ff16(a,b,c) + d + SS2 + w1[i]) & 0xFFFFFFFF;
            TT2 = (gg16(e,f,g) + h + SS1 + w[i]) & 0xFFFFFFFF;
        }

        h=g;
        g=lrot(f,19);
        f=e;
        e=p0(TT2);
        d=c;
        c=lrot(b,9);
        b=a;
        a=TT1;
    }
    H[0] = H[0] ^ a;
    H[1] = H[1] ^ b;
    H[2] = H[2] ^ c;
    H[3] = H[3] ^ d;
    H[4] = H[4] ^ e;
    H[5] = H[5] ^ f;
    H[6] = H[6] ^ g;
    H[7] = H[7] ^ h;

    //H[8] 转换回 out[256]，作为 新的 SHA-256 哈希状态输出
    for (var i=0; i<8; i++) {
        for (var j=0; j<32; j++) {
            out[i*32+31-j] = (H[i] >> j) & 1;
        }
    }
    return out;
}


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

    //这里也出现了小端序的问题，原sha256用的是inp[t*32+k]
    for (t=0; t<68; t++) {
        if (t<16) {
            for (k=0; k<32; k++) {
                //这里也出现了小端序的问题，原sha256用的是inp[t*32+k]
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
            for (k=0; k<32; k++) {
                w[t][k] <== extw[t-16].out[k];
            }
        }
    }

    for (t=0; t<64; t++) {
        for (k=0; k<32; k++) {
            extw1[t].in[k] <== w[t][k];
            extw1[t].in4[k] <== w[t+4][k];
        }
        for (k=0; k<32; k++) {
            w1[t][k] <== extw1[t].out[k];
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
            for (k=0; k<32; k++) {
                //我觉得ss不用生成约束
                // ss1[t].a[k] <== h[t][k];
                // ss1[t].e[k] <== e[t][k];
                // ss1[t].t[k] <== ct_k[t].out[k];

                // ss2[t].a[k] <== a[t][k];
                // ss2[t].e[k] <== e[t][k];
                // ss2[t].t[k] <== ct_k[t].out[k];

                tt1_0[t].a[k] <== a[t][k];
                tt1_0[t].b[k] <== b[t][k];
                tt1_0[t].c[k] <== c[t][k];
                tt1_0[t].d[k] <== d[t][k];
                tt1_0[t].e[k] <== e[t][k];
                tt1_0[t].t[k] <== ct_k[t].out[k];
                tt1_0[t].w1[k] <== w1[t][k];
                

                tt2_0[t].a[k] <== a[t][k];
                tt2_0[t].e[k] <== e[t][k];
                tt2_0[t].f[k] <== f[t][k];
                tt2_0[t].g[k] <== g[t][k];
                tt2_0[t].h[k] <== h[t][k];
                tt2_0[t].t[k] <== ct_k[t].out[k];
                tt2_0[t].w[k] <== w[t][k];
                
            }
            for(k=0; k<32; k++){
                tt1[t][k] = tt1_0[t].out[k];
                tt2[t][k] = tt2_0[t].out[k];
            }
        }else{
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
        out[32+k]  === xor[1].out[k];//error
        out[64+k]  === xor[2].out[k];
        out[96+k]  === xor[3].out[k];
        out[128+k] === xor[4].out[k];
        out[160+k] === xor[5].out[k];
        out[192+k] === xor[6].out[k];
        out[224+k] === xor[7].out[k];
    }
}



template SM3(nBits) {
    signal input in[nBits];
    signal output out[256];

    var i;
    var k;
    var nBlocks;
    var bitsLastBlock;


    nBlocks = ((nBits + 64)\512)+1;

    signal paddedIn[nBlocks*512];

    for (k=0; k<nBits; k++) {
        paddedIn[k] <== in[k];
    }
    paddedIn[nBits] <== 1;

    for (k=nBits+1; k<nBlocks*512-64; k++) {
        paddedIn[k] <== 0;
    }

    for (k = 0; k< 64; k++) {
        paddedIn[nBlocks*512 - k -1] <== (nBits >> k)&1;
    }
    // for(k = 0;k<nBlocks*512;k++){
    // log(paddedIn[k]);}

//创建基于H模板的组件，H定义于constants.circom
    component ha0 = H(0);
    component hb0 = H(1);
    component hc0 = H(2);
    component hd0 = H(3);
    component he0 = H(4);
    component hf0 = H(5);
    component hg0 = H(6);
    component hh0 = H(7);

//创建sm3compression组件数组，基于Sha256compression()模板，定义于sha256compression.circom
    component sm3compression[nBlocks];

    for (i=0; i<nBlocks; i++) {

        sm3compression[i] = Sm3compression() ;

        //ABCDEFGH <- V(i)
        //按bit输出的out[k],所以k是32
        if (i==0) {
            for (k=0; k<32; k++ ) {
                sm3compression[i].hin[0*32+k] <== ha0.out[k];
                sm3compression[i].hin[1*32+k] <== hb0.out[k];
                sm3compression[i].hin[2*32+k] <== hc0.out[k];
                sm3compression[i].hin[3*32+k] <== hd0.out[k];
                sm3compression[i].hin[4*32+k] <== he0.out[k];
                sm3compression[i].hin[5*32+k] <== hf0.out[k];
                sm3compression[i].hin[6*32+k] <== hg0.out[k];
                sm3compression[i].hin[7*32+k] <== hh0.out[k];
            }
        } 
        else {
            for (k=0; k<32; k++ ) {
                sm3compression[i].hin[32*0+k] <== sm3compression[i-1].out[32*0+k];
                sm3compression[i].hin[32*1+k] <== sm3compression[i-1].out[32*1+k];
                sm3compression[i].hin[32*2+k] <== sm3compression[i-1].out[32*2+k];
                sm3compression[i].hin[32*3+k] <== sm3compression[i-1].out[32*3+k];
                sm3compression[i].hin[32*4+k] <== sm3compression[i-1].out[32*4+k];
                sm3compression[i].hin[32*5+k] <== sm3compression[i-1].out[32*5+k];
                sm3compression[i].hin[32*6+k] <== sm3compression[i-1].out[32*6+k];
                sm3compression[i].hin[32*7+k] <== sm3compression[i-1].out[32*7+k];
            }
        }

        for (k=0; k<512; k++) {
            sm3compression[i].inp[k] <== paddedIn[i*512+k];//error
        }
    }

    for (k=0; k<256; k++) {
        out[k] <== sm3compression[nBlocks-1].out[k];
        log(out[k]);
    }

}


component main = SM3(24);

/* INPUT = {
    "in": ["0","1","1","0","0","0","0","1","0","1","1","0","0","0","1","0",
 "0","1","1","0","0","0","1","1"]
} */

