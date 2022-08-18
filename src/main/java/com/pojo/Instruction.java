package com.pojo;

import lombok.Data;

import java.util.List;

@Data
public class Instruction {
    private String opcode;
    private String datatype;
    private List<String> sourceRegister;
    private String destinationRegister;
    private String imm;
}
