package com.pojo;

import lombok.Data;

import java.util.List;

@Data
public class SpecContext {
    // requests 后 完整的条件
    private String preCondition;
    // regstate中涉及的寄存器的值，这里简单记录一下每个寄存器对应的语句，后续直接插入spec
    private List<String> postCondition;
    // 验证的程序包含的指令
    private List<String> instList;
}
