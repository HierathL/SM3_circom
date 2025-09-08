/* Xor3 function for sha256

out = a ^ b ^ c  =>

out = a+b+c - 2*a*b - 2*a*c - 2*b*c + 4*a*b*c   =>

out = a*( 1 - 2*b - 2*c + 4*b*c ) + b + c - 2*b*c =>

mid = b*c   中间信号数组 mid，用于存储 b 和 c 的逐位乘积,可以优化计算电路
out = a*( 1 - 2*b -2*c + 4*mid ) + b + c - 2 * mid

*/
pragma circom 2.0.0;

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

