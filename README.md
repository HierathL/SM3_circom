# SM3_circom
 SM3 algorithm implemented in circom language 


## 描述 

本科毕业论文，零知识证明领域的一个国密化尝试。因为circomlib库（https://github.com/iden3/circomlib）提供了SHA256算法作为电路约束的circom实现电路。本项目实现了基于SM3算法的零知识证明电路的设计

## 电路编译 

电路基于cirocm语言和snarkjs环境实现

电路设计过程包括circom语言设计，circom编译，snarkjs生成证明和验证，环境配置和工具使用都十分友好，基本都提供了简明教程和示例。

circom环境配置和编译参考https://docs.circom.io/getting-started/installation/ snarkjs使用可以参考https://github.com/iden3/snarkjs

## 零知识证明 

本项目基于snarkjs，而snarkjs既可以实现Groth16也支持PLONK，两种零知识证明算法都可以在生成电路之后用。

关于零知识证明需要自己学习，主包研究了一个多月翻看无数博客和文献，祝好。
