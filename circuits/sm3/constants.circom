
pragma circom 2.0.0;

/*
输出初始哈希值 H 的二进制表示，out[32] 存储 c[x] 的二进制形式，逐位提取
（按小端序存储）

x=0，c[0] = 0x6a09e667（十六进制转二进制为 01101010000010011110011001100111
则有，
out[0]  = 1
out[1]  = 1
out[2]  = 1
out[3]  = 0
...
out[31] = 0
*/

//已改为SM3_IV
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
    //已经修改为大端序。

    for (var i=0; i<32; i++) {
        out[31-i] <== (c[x] >> i) & 1;
    }
    
}

/*
Ti=
*/
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
        out[31-i] <== (c[x] >> i) & 1;
    }
}
