pragma circom 2.0.0;

/*
GG00(x,y,z)  ((x) ^ (y) ^ (z))
GG16(x,y,z)  ((((y)^(z)) & (x)) ^ (z))
*/

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
