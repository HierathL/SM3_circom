pragma circom 2.0.0;

include "constants.circom";
include "sm3compression.circom";

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
    //大端序的padding
    for (k = 0; k< 64; k++) {
        paddedIn[nBlocks*512 - k -1] <== (nBits >> k)&1;
    }

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
        //inp即消息块也是大端序
        for (k=0; k<512; k++) {
            sm3compression[i].inp[k] <== paddedIn[i*512+k];
        }
    }

    for (k=0; k<256; k++) {
        out[k] <== sm3compression[nBlocks-1].out[k];
    }

}

component main = SM3(24);