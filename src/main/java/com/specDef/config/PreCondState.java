package com.specDef.config;

import lombok.Data;
import com.pojo.Instruction;
import com.pojo.ProveObject;

import java.math.BigInteger;
import java.util.InputMismatchException;
import java.util.List;
import java.util.Map;

@Data
public class PreCondState {
    private Instruction instruction;
    private ProveObject proveObject;
    // 无穷小
    private BigInteger minValue = new BigInteger("-2").pow(128).subtract(BigInteger.ONE);
    // 无穷大
    private BigInteger maxValue = new BigInteger("2").pow(128).add(BigInteger.ONE);

    public PreCondState(ProveObject proveObject) {
        this.proveObject = proveObject;
    }

    /**
     * MOV指令的前置条件处理与设置
     * @return
     */
    public String simplePreSet() {
        try {
            // 若出现instruction context为空 或者 目标操作数为空 的情况
            if (instruction == null || instruction.getDestinationRegister() == null) {
                throw new InputMismatchException("context为空或目标操作数为空");
            }
            // 前置条件设定
            // String preCondition = null;
            // 提取prove 目录中的寄存器映射表
            Map<String, String> registerMap = proveObject.getRegisterMap();
            // 目标寄存器
            String destinationRegister = instruction.getDestinationRegister();
            // 当源操作数为立即数时，直接将立即数存储到寄存器映射表中
            if (instruction.getImm() != null) {
                registerMap.put(destinationRegister, instruction.getImm());
                // 当MOV的源操作数是立即数时，前置条件为空（验证程序中默认的范围，即当为32位寄存器值时，当立即数超出32位能表达的范围验证器不会判True）
                // 只需验证其后置条件是否满足
                return isValMov(instruction.getImm());
            } else {
                // 源操作数为寄存器
                List<String> sourceRegister = instruction.getSourceRegister();
                if (sourceRegister == null || sourceRegister.isEmpty()) {
                    throw new InputMismatchException("源操作数空");
                }
                String source = sourceRegister.get(0);
                // 当源操作数在寄存器表中没有记录，则默认设定初始值0
                if (!registerMap.containsKey(source)) {
                    registerMap.put(source, "0");
                    // 若目标寄存器原来有值，也覆盖掉，契合语义，MOV/load语句会覆盖当前值
                    registerMap.put(destinationRegister, "0");
                } else {
                    registerMap.put(destinationRegister, registerMap.get(source));
                }
                // 当MOV的源操作数是寄存器时，需要再判断一次，若当前存储的是立即数（即源操作数的值也是立即数的情况），那还是设空，不是立即数就
                // 设定范围
                String value = registerMap.get(destinationRegister);
                return isValMov(value);
            }
        } catch (InputMismatchException ex) {
            //System.err.println("输入内容为空，请重新输入！");
            ex.printStackTrace();
            return null;
        }
    }

    /**
     * MOV指令 构建precondition
     * 当imm存在时，需要判断imm是否为变量，不是变量则无需设置范围，是变量则从变量映射表中提取变量范围值进行设定
     * @param imm
     * @return
     */
    public String isValMov(String imm) {
        String preCondition = null;
        if (imm.charAt(0) >= 'A' && imm.charAt(0) <= 'Z') {
            if (!proveObject.getPreCond().containsKey(imm)) {
                throw new InputMismatchException("变量为空，请检测输入的条件");
            } else {
                BigInteger[] bigIntegers = proveObject.getPreCond().get(imm);
                if (bigIntegers[0].compareTo(minValue) == 0) {  // 左边界为空
                    preCondition = imm + " <=Int " + bigIntegers[1] + "\n";
                } else if (bigIntegers[1].compareTo(maxValue) == 0) { // 右边界为空
                    preCondition = imm + " >=Int " + bigIntegers[0] + "\n";
                } else {
                    if (bigIntegers[0].compareTo(bigIntegers[1]) == 0) {    // 左右界相等，即变量是等于某值
                        preCondition = imm + " ==Int " + bigIntegers[0] + "\n";
                    } else {
                        preCondition = bigIntegers[0] + " <=Int " + imm + " andBool " + imm + " <=Int " + bigIntegers[1] + "\n";
                    }
                }
                return preCondition;
            }
        } else {
            return "";
        }
    }

    /**
     * VMOV指令解析前置条件，获取相关信息
     * 简单处理
     * @return
     */
    public String vecSimplePreSet() {
        try {
            // String preCondition = null;
            // 提取prove 目录中的寄存器映射表
            Map<String, String> registerMap = proveObject.getRegisterMap();
            // 目标寄存器
            String destinationRegister = instruction.getDestinationRegister();
            if (destinationRegister.charAt(0) != 'Q')
                throw new RuntimeException("VMOV中目标操作数必须为向量寄存器，请重新输入");
            // 当源操作数为立即数时，直接将立即数存储到寄存器映射表中
            if (instruction.getImm() != null) {
                registerMap.put(destinationRegister, instruction.getImm());
                // 当为VMOV
                return isValVmov(instruction.getImm());
            } else {
                // 源操作数为寄存器
                List<String> sourceRegister = instruction.getSourceRegister();
                if (sourceRegister == null || sourceRegister.isEmpty()) {
                    throw new InputMismatchException("源操作数空");
                }
                if (sourceRegister.get(0).charAt(0) != 'Q') {
                    throw new InputMismatchException("源操作数不为向量寄存器，请重新输入");
                }
                String source = sourceRegister.get(0);
                // 当源操作数在寄存器表中没有记录，则默认设定初始值0
                if (!registerMap.containsKey(source)) {
                    registerMap.put(source, "0");
                    // 若目标寄存器原来有值，也覆盖掉，契合语义，MOV/load语句会覆盖当前值
                    registerMap.put(destinationRegister, "0");
                } else {
                    registerMap.put(destinationRegister, registerMap.get(source));
                }
                // 当MOV的源操作数是寄存器时，需要再判断一次，若当前存储的是立即数（即源操作数的值也是立即数的情况），那还是设空，不是立即数就
                // 设定范围
                String value = registerMap.get(destinationRegister);
                return isValVmov(value);
            }
        } catch (RuntimeException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    public String isValVmov(String imm) {
        String preCondition = "";
        if (Character.isLetter(imm.charAt(0))) {
            if (!proveObject.getPreCond().containsKey(imm)) {
                throw new RuntimeException("无效变量，请检测输入变量");
            } else {
                BigInteger[] bigIntegers = proveObject.getPreCond().get(imm);
                if (bigIntegers[0].compareTo(minValue) == 0) {  // 左边界为空
                    preCondition = imm + " <=Int " + bigIntegers[1] + "\n";
                } else if (bigIntegers[1].compareTo(maxValue) == 0) { // 右边界为空
                    preCondition = imm + " >=Int " + bigIntegers[0] + "\n";
                } else {
                    if (bigIntegers[0].compareTo(bigIntegers[1]) == 0) {    // 左右界相等，即变量是等于某值
                        preCondition = imm + " ==Int " + bigIntegers[0] + "\n";
                    } else {
                        preCondition = bigIntegers[0] + " <=Int " + imm + " andBool " + imm + " <=Int " + bigIntegers[1] + "\n";
                    }
                }
            }
            return preCondition;
        } else // 立即数不设requires
            return "";
    }
}
