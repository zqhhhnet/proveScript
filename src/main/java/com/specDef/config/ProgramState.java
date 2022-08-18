package com.specDef.config;

import lombok.Data;
import com.pojo.Instruction;
import com.pojo.SpecContext;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Data
public class ProgramState {
    private Instruction instruction;

    /**
     * MOV、VMOV等单次可以验证成功的指令设定
     * @return
     */
    public List<String> simpleProgramSet(SpecContext specContext) {
        try {
            if (instruction == null || instruction.getOpcode() == null)
                throw new RuntimeException();
            List<String> instList = specContext.getInstList();
            if (instList == null || instList.isEmpty()) {
                instList = new ArrayList<>();
                char[] destinationRegister = instruction.getDestinationRegister().toCharArray();
                destinationRegister[0] = (char)(destinationRegister[0] + 32);
                String lowDestinationRegister = String.valueOf(destinationRegister);
                String inst = "\t\t\tmemloc(mi(32, 0)) |-> storedInstr( " + instruction.getOpcode() + " " + lowDestinationRegister
                        + ", ";
                if (instruction.getImm() == null) {
                    char[] sourceRegister = instruction.getSourceRegister().get(0).toCharArray();
                    sourceRegister[0] = (char) (sourceRegister[0] + 32);
                    String lowSourceRegister = String.valueOf(sourceRegister);
                    inst = inst + lowSourceRegister + ", .Operands)\n";
                } else {
                    inst = inst + "# " + instruction.getImm() + ", .Operands)\n";
                }
                instList.add(inst);
            } else {
                String regex = "^memloc\\(mi\\(32,[ ]*(\\d+)\\)";
                Pattern pattern = Pattern.compile(regex);
                Matcher matcher = pattern.matcher(instList.get(instList.size()-1));
                if (matcher.find()) {
                    int curLoc = Integer.parseInt(matcher.group(1)) +  1;
                    char[] destinationRegister = instruction.getDestinationRegister().toCharArray();
                    destinationRegister[0] = (char)(destinationRegister[0] + 32);
                    String lowDestinationRegister = String.valueOf(destinationRegister);
                    /*StringBuilder lowDestinationRegister = new StringBuilder();
                    for (int i = 0; i < destinationRegister.length; i++) {
                        if (i == 0) {
                            lowDestinationRegister.append((destinationRegister[0] + 32));
                        } else
                            lowDestinationRegister.append(destinationRegister[i]);
                    }*/
                    String inst = "\t\t\tmemloc(mi(32, " + curLoc + ")) |-> storedInstr( " + instruction.getOpcode() + " " +
                            lowDestinationRegister + ", ";
                    if (instruction.getImm() == null) {
                        char[] sourceRegister = instruction.getSourceRegister().get(0).toCharArray();
                        sourceRegister[0] = (char) (sourceRegister[0] + 32);
                        String lowSourceRegister = String.valueOf(sourceRegister);
                        inst = inst + lowSourceRegister + ", .operands)\n";
                    } else {
                        inst = inst + "# " + instruction.getImm() + ", .Operands)\n";
                    }
                    instList.add(inst);
                } else
                    throw new RuntimeException();
            }
            return instList;
        } catch (RuntimeException ex) {
            System.err.println("输入的验证程序出错，请重新输入");
            return null;
        }
    }
}
