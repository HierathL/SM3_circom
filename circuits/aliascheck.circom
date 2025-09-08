pragma circom 2.0.0;

include "compconstant.circom";
//别名检查电路，验证输入 in[254] 是否符合某个常量约束。



template AliasCheck() {

    signal input in[254];

    component  compConstant = CompConstant(-1);

    for (var i=0; i<254; i++) in[i] ==> compConstant.in[i];

    compConstant.out === 0;
}
