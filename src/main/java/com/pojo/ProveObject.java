package com.pojo;

import lombok.Data;

import java.math.BigInteger;
import java.util.List;
import java.util.Map;

@Data
public class ProveObject {
    // 前置条件
    private Map<String, BigInteger[]> preCond;
    // 后置条件
    private Map<String, BigInteger[]> postCond;
    // 程序指令
    private List<String> instructions;
    // 寄存器映射表
    private Map<String, String> registerMap;
}
