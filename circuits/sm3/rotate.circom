/*
    循环左移
    in[1,2,3,4]
    out[2,3,4,]
*/
pragma circom 2.0.0;


template RotL(n, r) {
    signal input in[n];
    signal output out[n];

    for (var i=0; i<n; i++) {
        out[i] <== in[ (i+r)%n ];
    }
}

