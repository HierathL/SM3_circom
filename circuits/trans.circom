pragma circom 2.0.0;

// 将Buffer转为比特数组（大端序，从最高位到最低位）
//先push的在低地址，是高位数字
function buffer2bitArray(b) {
    const res = [];
    for (let i = 0; i < b.length; i++) { // 遍历每个字节
        for (let j = 0; j < 8; j++) { // 提取每个比特，从高位到低位
            res.push((b[i] >> (7 - j)) & 1);
        }
    }
    return res;
}

// 将比特数组转回Buffer
function bitArray2buffer(a) {
    const len = Math.floor((a.length - 1) / 8) + 1; // 计算Buffer长度
    const b = Buffer.alloc(len); // 创建Buffer

    for (let i = 0; i < a.length; i++) { // 遍历比特数组
        const p = Math.floor(i / 8); // 计算字节位置
        b[p] = b[p] | (Number(a[i]) << (7 - (i % 8))); // 组装字节
    }
    return b;
}
/*
在测试中有
        const cir = await wasm_tester(path.join(__dirname, "circuits", "sha256_test512.circom"));
        
        //创建buffer（64B）b:[1,2,....64]即[0x01,..,0x40]
        const b = Buffer.alloc(64);
        for (let i = 0; i < 64; i++) {
            b[i] = i + 1;
        }

        //密码库计算hash
        const hash = crypto.createHash("sha256").update(b).digest("hex");
        
        //Circom 电路往往处理的是比特级操作，所以需要把 buffer 转换成比特数组。
        const arrIn = buffer2bitArray(b);
        //witness（见证值） 是 Circom 电路计算出的中间值和输出值
        const witness = await cir.calculateWitness({ "in": arrIn }, true);

        //SHA-256 输出 256 比特哈希值，Circom 计算结果在 witness 的索引 1 到 256 之间
        const arrOut = witness.slice(1, 257); // 提取电路输出的比特
        const hash2 = bitArray2buffer(arrOut).toString("hex");

        assert.equal(hash, hash2); // 验证电路计算的哈希是否正确
*/