package com.parser.instParserImpl;

import com.parser.InstParser;
import com.pojo.Instruction;

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class InstParserImpl implements InstParser {
    //                                  1           2         3     4                   5                         6                         7                             8                        9
    private String instPattern = "^[ ]*([A-Z]+)[ ]*([\\.][ ]*([SUF](8|16|32|64)+))*[ ]*([RQSD][0-9]{1,2})[ ]*,[ ]*([RQSD][0-9]{1,2}|[#][ ]*([A-Za-z]+\\d*|\\d+))[ ]*,?[ ]*([RQSD][0-9]{1,2}|[#][ ]*([A-Za-z]+\\d*|\\d+))?[ ]*";

    private final Set<String> instTable = new HashSet<>(Arrays.asList("MOV", "VMOV", "VMAX", "VMAXA", "VMAXV", "VMAXAV", "VMAXNM", "VMAXNMV", "VMAXNMA", "VMAXNMAV",
            "VMIN", "VMINV", "VMINA", "VMINAV", "VMINNM", "VMINNMA", "VMINNMV", "VMINNMAV", "VMLAV"));
    private final Set<String> dataTypeTable = new HashSet<>(Arrays.asList("S8", "S16", "S32", "U8", "U16", "U32", "F16", "F32", "F64"));
    private final Set<String> RegisterTable = new HashSet<>(Arrays.asList("R0", "R1", "R2", "R3", "R4", "R5", "R6", "R7", "R8",
            "R9", "R10", "R11", "R12", "R13", "S0", "S1", "S2", "S3", "S4", "S5", "S6", "S7", "S8", "S9", "S10", "S11",
            "S12", "S13", "S14", "S15", "S16", "S17", "S18", "S19", "S20", "S21", "S22", "S23", "S24", "S25", "S26",
            "S26", "S27", "S28", "S29", "S30", "S31", "D0", "D1", "D2", "D3", "D4", "D5", "D6", "D7", "D8", "D9", "D10", "D11",
            "D12", "D13", "D14", "D15", "Q0", "Q1", "Q2", "Q3", "Q4", "Q5", "Q6", "Q7"));

    // TODO: VMOV的格式 VMOV.$I Qn[i], Rm  需要加入
    @Override
    public Instruction instParse(String inst) {
        Pattern pattern = Pattern.compile(instPattern);
        Matcher matcher = pattern.matcher(inst);
        try {
            if (matcher.find()) {
                Instruction instruction = new Instruction();
                // 判断opcode是否有效
                if (!instTable.contains(matcher.group(1)))
                    throw new InputMismatchException();
                instruction.setOpcode(matcher.group(1));
                // 判断数据类型是否位空，并是否有效
                if (matcher.group(3) != null && !dataTypeTable.contains(matcher.group(3)))
                    throw new InputMismatchException();
                else if (matcher.group(3) != null)
                    instruction.setDatatype(matcher.group(3));

                // 判断目标操作数是否有效
                if (!RegisterTable.contains(matcher.group(5)))
                    throw new InputMismatchException();
                instruction.setDestinationRegister(matcher.group(5));
                // 判断第一个源操作数是否为立即数，若不是，判断其寄存器是否有效
                if (!matcher.group(6).contains("#") ) {
                    if (!RegisterTable.contains(matcher.group(6)))
                        throw new InputMismatchException();
                    else {
                        List<String> sourceReg = instruction.getSourceRegister();
                        if (sourceReg == null || sourceReg.isEmpty()) {
                            sourceReg = new ArrayList<>();
                            sourceReg.add(matcher.group(6));
                        }
                        else
                            sourceReg.add(matcher.group(6));
                        instruction.setSourceRegister(sourceReg);
                    }
                } else {
                    if (matcher.group(8) != null)
                        throw new InputMismatchException();
                    instruction.setImm(matcher.group(7));
                    return instruction;
                }
                // 判断第二个源操作数
                if (matcher.group(8) != null && !matcher.group(8).contains("#")) {
                    if (!RegisterTable.contains(matcher.group(8))) {
                        throw new InputMismatchException();
                    } else {
                        List<String> sourceReg = instruction.getSourceRegister();
                        if (sourceReg == null || sourceReg.isEmpty()) {
                            sourceReg = new ArrayList<>();
                            sourceReg.add(matcher.group(8));
                        } else
                            sourceReg.add(matcher.group(8));
                        instruction.setSourceRegister(sourceReg);
                    }
                } else if (matcher.group(8) != null) {
                    instruction.setImm(matcher.group(9));
                }
                return instruction;
            } else
                throw new InputMismatchException();
        } catch (InputMismatchException ex) {
            System.err.println("指令非法，请检测指令是否错误 ： " + inst);
            return null;
        }
    }
}
