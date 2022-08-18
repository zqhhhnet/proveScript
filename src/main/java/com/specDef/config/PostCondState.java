package com.specDef.config;

import lombok.Data;
import com.pojo.Instruction;
import com.pojo.ProveObject;

import java.util.ArrayList;
import java.util.List;

@Data
public class PostCondState {
    private Instruction instruction;
    private ProveObject proveObject;

    public PostCondState(ProveObject proveObject) {
        this.proveObject = proveObject;
    }

    /**
     * MOV 后置条件设置
     *  1、当为立即数模式，只需设定目标寄存器
     *  2、当为寄存器间模式，还需设定源寄存器
     * @return  列表首项是目标寄存器
     */
    public List<String> simplePostSet() {
        try {
            checkException();
            // 设置目标寄存器的值
            String destinationRegister = instruction.getDestinationRegister();
            List<String> postCondition = new ArrayList<>();
            // 立即数模式
            if (instruction.getImm() != null) {
                String imm = proveObject.getRegisterMap().get(destinationRegister);
                String destinationReg = "\t\t\t\"" + destinationRegister + "\"" + " |-> " + "mi(32, " + imm + ")\n";
                postCondition.add(destinationReg);
            } else {    // 寄存器-寄存器
                String valDest = proveObject.getRegisterMap().get(destinationRegister);
                String destinationReg = "\t\t\t\"" + destinationRegister + "\" |-> mi(32, " + valDest + ")\n";
                postCondition.add(destinationReg);
                if (instruction.getSourceRegister() == null)
                    throw new RuntimeException();
                String valSource = proveObject.getRegisterMap().get(instruction.getSourceRegister().get(0));
                String sourceReg = "\t\t\t\"" + instruction.getSourceRegister().get(0) + "\" |-> mi(32, " + valSource
                        + ")\n";
                postCondition.add(sourceReg);
            }
            return postCondition;
        } catch (RuntimeException ex) {
            System.err.println("后置条件解析出问题了，请检测");
            return null;
        }
    }

    /**
     * VMOV后置条件设置
     * @return
     */
    public List<String> vecSimplePostSet() {
        try {
            checkException();
            String destinationRegister = instruction.getDestinationRegister();
            List<String> postCondition = new ArrayList<>();
            if (instruction.getImm() != null) {
                String imm = proveObject.getRegisterMap().get(destinationRegister);
                String destinationReg = "\t\t\t\"" + destinationRegister + "\" |-> mi(128, " + imm + ")\n";
                postCondition.add((destinationReg));
                setSReg(postCondition, destinationRegister, imm);
            } else {
                List<String> sourceRegister = instruction.getSourceRegister();
                if (sourceRegister == null || sourceRegister.isEmpty())
                    throw new RuntimeException("源操作数为空，请检测");
                if (destinationRegister.equals(sourceRegister.get(0)))
                    throw new RuntimeException("VMOV中，目标操作数和源操作数不能为同一寄存器");
                String val = proveObject.getRegisterMap().get(sourceRegister.get(0));
                String sourceReg = "\t\t\t\"" + sourceRegister.get(0) + "\" |-> mi(128, " + val + ")\n";
                String destinationReg = "\t\t\t\"" + destinationRegister + "\" |-> mi(128, " + val + ")\n";
                postCondition.add(sourceReg);
                postCondition.add(destinationReg);
                setSReg(postCondition, sourceRegister.get(0), val);
                setSReg(postCondition, destinationRegister, val);
            }
            return postCondition;
        } catch (RuntimeException ex) {
            ex.printStackTrace();
            return null;
        }
    }

    public void checkException() {
        if (instruction == null || instruction.getDestinationRegister() == null)
            throw new RuntimeException();
        if (proveObject.getRegisterMap().get(instruction.getDestinationRegister()) == null)
            throw new RuntimeException();
    }

    /**
     * 用于设置向量寄存器对应的4个32位浮点寄存器
     * @param postCondition
     * @param desReg
     */
    public static void setSReg(List<String> postCondition, String desReg, String imm) {
        if (desReg == null)
            throw new RuntimeException("寄存器为空，请重试");
        int cur = Integer.parseInt(desReg.substring(1));
        for (int i = cur*4, k = 0; i < cur*4+4; i++, k++) {
            StringBuilder sReg = new StringBuilder();
            sReg.append('S').append(i);
            String post = "\t\t\t\"" + sReg + "\" |-> extractMInt(mi(128, " + imm + "), " + ((3-k) * 32) + "," + ((4-k) * 32)
                     + ")\n";
            postCondition.add(post);
        }
    }
}
