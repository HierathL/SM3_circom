pragma circom 2.0.0;

/*
FF00(x,y,z)  ((x) ^ (y) ^ (z))
FF16(x,y,z)  (((x)&(y)) | ((x)&(z)) | ((y)&(z)))

ff00(a,b,c) = a^b^c (三变量异或)=>
ff00 = a+b+c−2ab−2ac−2bc+4abc

ff16(a,b,c) = (X∧Y)∨(X∧Z)∨(Y∧Z)
ff16 = ab+ac+bc -2abc
*/


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