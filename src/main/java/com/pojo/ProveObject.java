package com.pojo;

import lombok.Data;

import java.math.BigInteger;
import java.util.List;
import java.util.Map;

@Data
public class ProveObject {
    // 前置条件
    private Map<String, BigInteger[]> preCond;
    // 改为依据数据类型进行设置
    // 后置条件
    private Map<String, BigInteger[]> postCond;
    // 程序指令
    private List<String> instructions;
    // 寄存器映射表
    private Map<String, String> registerMap;
    // 当前指令所处第几行，从0开始
    private int curInst = -1;
    // 存储浮点数标志位的变化，key是第几行指令触发的改变，value是改变的方式，0表示有SNaN，1表示有Denormalized，2表示都发生
    private Map<Integer, Integer> fpFlagMap;
    // 用于存储smt-prelude 的路径，用户手动设置对应k中basic.smt2的路径： 如，~/K_ROOT/k-distribution/include/z3/basic.smt2
    private String smtPrelude;
    // 被验证程序安全的中间或最终结果
    private List<String> safetyElement;
}
