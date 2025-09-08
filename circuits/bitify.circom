/*
    数值与二进制表示之间的转换
    _strict是严格版本增加了 AliasCheck，确保数据不会被错误引用。

*/
pragma circom 2.0.0;

include "comparators.circom";
include "aliascheck.circom";

//将一个整数转换为n位的bits数组
template Num2Bits(n) {
    signal input in;
    signal output out[n];
    var lc1=0;

    var e2=1;
    for (var i = 0; i<n; i++) {
        out[i] <-- (in >> i) & 1;
        out[i] * (out[i] -1 ) === 0;//确保 out[i] 只能是 0 或 1（布尔约束）
        lc1 += out[i] * e2;
        e2 = e2+e2;
    }

    lc1 === in;//确保转换后的二进制值正确表示 in,lc1的作用就是验证
}

template Num2Bits_strict() {
    signal input in;
    signal output out[254];//强制输入为 254 位

    component aliasCheck = AliasCheck();//防止意外的变量引用
    component n2b = Num2Bits(254);
    in ==> n2b.in;

    for (var i=0; i<254; i++) {
        n2b.out[i] ==> out[i];
        n2b.out[i] ==> aliasCheck.in[i];
    }
}

template Bits2Num(n) {
    signal input in[n];
    signal output out;
    var lc1=0;

    var e2 = 1;
    for (var i = 0; i<n; i++) {
        lc1 += in[i] * e2;
        e2 = e2 + e2;
    }

    lc1 ==> out;
}

template Bits2Num_strict() {
    signal input in[254];
    signal output out;

    component aliasCheck = AliasCheck();
    component b2n = Bits2Num(254);

    for (var i=0; i<254; i++) {
        in[i] ==> b2n.in[i];
        in[i] ==> aliasCheck.in[i];
    }

    b2n.out ==> out;
}

//带负数
template Num2BitsNeg(n) {
    signal input in;
    signal output out[n];
    var lc1=0;

    component isZero;

    isZero = IsZero();

    //计算补码
    var neg = n == 0 ? 0 : 2**n - in;

    for (var i = 0; i<n; i++) {
        out[i] <-- (neg >> i) & 1;
        out[i] * (out[i] -1 ) === 0;
        lc1 += out[i] * 2**i;
    }

    in ==> isZero.in;


    lc1 + isZero.out * 2**n === 2**n - in;
}
