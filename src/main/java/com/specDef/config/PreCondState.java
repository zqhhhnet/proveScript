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
    private int beat;
    // 若指令为需要组合验证，存储当前指令的源操作数的precondition，避免重复运算
    private String preSourceCond;
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

    /**
     * VMAXV指令的前置条件设置，使用组合验证方法，分解多个子问题进行解决
     * @return
     */
    public String vvIntPreSet() {
        String preCondition = null;
        try {
            if (instruction == null || instruction.getDestinationRegister() == null) {
                throw new InputMismatchException("context为空或目标操作数为空");
            }
            // 设置requires条件，由于指令会更新目标寄存器的值，因此需要先取出旧值作为前置条件以及比较条件，然后再获取新值
            if (instruction.getSourceRegister() == null || instruction.getSourceRegister().isEmpty()) {
                throw new InputMismatchException("源寄存器为空");
            }
            String destinationRegister = instruction.getDestinationRegister();
            String sourceRegister = instruction.getSourceRegister().get(0);
            int size = Integer.parseInt(instruction.getDatatype().substring(1));
            // 只需进入VMAXV第一个子问题的时候设置向量寄存器对应的浮点寄存器的值，其他子问题不需要再重复设置
            if (beat == 0) {
                // 存放S寄存器到寄存器映射表
                preSourceCond = setSRegister(sourceRegister, size);
            }
            // 将目标寄存器的值的范围设置到前置条件
            preCondition = setDesCond(preSourceCond, destinationRegister, size);
        } catch (InputMismatchException ex) {
            ex.printStackTrace();
        }
        return preCondition;
    }

    private String setDesCond(String preSourceCond, String destinationRegister, int size) {
        String desPreCond = null;
        Map<String, BigInteger[]> preCond = proveObject.getPreCond();
        Map<String, String> registerMap = proveObject.getRegisterMap();
        if (!registerMap.containsKey(destinationRegister))
            throw new InputMismatchException("目标寄存器无对应值，请重新设置");
        String val = registerMap.get(destinationRegister);
        BigInteger[] bigIntegers = preCond.get(val);
        desPreCond = preSourceCond + "\t\t\tandBool " + val + " >=Int " + bigIntegers[0] +
                " andBool " + val + " <=Int " + bigIntegers[1] + "\n";
        return desPreCond;
    }

    /**
     * 根据源向量寄存器，获取对应向量，根据数据类型，设置浮点寄存器对应值
     * 以及第一次进入指令时，设置源寄存器的前置条件，因为源寄存器的值是不变的，一次设置好，无需重复设置
     * @param sourceRegister
     * @param size
     * @return 源寄存器的前置条件
     */
    public String setSRegister(String sourceRegister, int size) {
        String sourcePre = "";
        Map<String, String> registerMap = proveObject.getRegisterMap();
        Map<String, BigInteger[]> preCond = proveObject.getPreCond();
        String val = registerMap.get(sourceRegister);
        if (!preCond.containsKey(val))
            throw new InputMismatchException("变量为空，重新输入");
        int sIndex = Integer.parseInt(sourceRegister.substring(1)) * 4;
        if (size == 32) {
            for (int i = 0; i < 4; i++) {
                String cur = val + i;
                if (!preCond.containsKey(cur)) {
                    throw new InputMismatchException("元素长度32时，向量寄存器的元素没有范围，请赋上范围");
                }
                String sReg = "S" + (sIndex + i);
                registerMap.put(sReg, cur);
                BigInteger[] bigIntegers = preCond.get(cur);
                if (i == 0) {
                    sourcePre = sourcePre + "\t\t\trequires " + cur + " >=Int " + bigIntegers[0] + " andBool " +
                            cur + " <=Int " + bigIntegers[1] + "\n";
                } else {
                    sourcePre = sourcePre + "\t\t\tandBool " + cur + " >=Int " + bigIntegers[0] + " andBool "
                            + cur + " >=Int " + bigIntegers[1] + "\n";
                }
            }
        } else if (size == 16) {
            for (int i = 0; i < 4; i++) {
                String cur1 = val + "0" + (i*2);
                String cur2 = val + "0" + (i*2+1);
                if (!preCond.containsKey(cur1) || !preCond.containsKey(cur2)) {
                    throw new InputMismatchException("元素长度16时，向量寄存器的元素没有范围，请赋上范围");
                }
                String sReg = "S" + (sIndex + i);
                // 这里简单的用 A：B 代表A后面B组成二进制串，即concatenate，解析的时候需要注意：
                registerMap.put(sReg, cur2 + ":" + cur1);
                BigInteger[] bigIntegers1 = preCond.get(cur1);
                BigInteger[] bigIntegers2 = preCond.get(cur2);
                if (i == 0) {
                    sourcePre = sourcePre + "\t\t\trequires " + cur1 + " >=Int " + bigIntegers1[0] + " andBool " +
                            cur1 + " <=Int " + bigIntegers1[1] + "\n\t\t\tandBool " + cur2 + " >=Int "
                            + bigIntegers2[0] + " andBool " + cur2 + " <=Int " + bigIntegers2[1] + "\n";
                } else {
                    sourcePre = sourcePre + "\t\t\tandBool " + cur1 + " >=Int " + bigIntegers1[0] + " andBool " +
                            cur1 + " <=Int " + bigIntegers1[1] + "\n\t\t\tandBool " + cur2 + " >=Int "
                            + bigIntegers2[0] + " andBool " + cur2 + " <=Int " + bigIntegers2[1] + "\n";
                }
            }
        } else if (size == 8) {
            for (int i = 0; i < 4; i++) {
                String cur1 = val + "00" + (i*4);
                String cur2 = val + "00" + (i*4+1);
                String cur3 = val + "00" + (i*4+2);
                String cur4 = val + "00" + (i*4+3);
                if (!preCond.containsKey(cur1) || !preCond.containsKey(cur2) ||
                        !preCond.containsKey(cur3) || !preCond.containsKey(cur4))
                    throw new InputMismatchException("元素长度8时，向量寄存器的元素没有范围，请赋上范围");
                String sReg = "S" + (sIndex + i);
                registerMap.put(sReg, cur4 + ":" + cur3 + ":" + cur2 + ":" + cur1);
                BigInteger[] big1 = preCond.get(cur1);
                BigInteger[] big2 = preCond.get(cur2);
                BigInteger[] big3 = preCond.get(cur3);
                BigInteger[] big4 = preCond.get(cur4);
                if (i == 0) {
                    sourcePre = sourcePre + "\t\t\trequires " + cur1 + " >=Int " + big1[0] + " andBool " +
                            cur1 + " <=Int " + big1[1] + "\n\t\t\tandBool " + cur2 + " >=Int "
                            + big2[0] + " andBool " + cur2 + " <=Int " + big2[1] + "\n\t\t\tandBool "
                            + cur3 + " >=Int " + big3[0] + " andBool " + cur3 + " <=Int " + big3[1]
                            + "\n\t\t\tandBool " + cur4 + " >=Int " + big4[0] + " andBool " + cur4
                            + " <=Int " + big4[1] + "\n";
                } else {
                    sourcePre = sourcePre + "\t\t\tandBool " + cur1 + " >=Int " + big1[0] + " andBool " +
                            cur1 + " <=Int " + big1[1] + "\n\t\t\tandBool " + cur2 + " >=Int "
                            + big2[0] + " andBool " + cur2 + " <=Int " + big2[1] + "\n\t\t\tandBool "
                            + cur3 + " >=Int " + big3[0] + " andBool " + cur3 + " <=Int " + big3[1]
                            + "\n\t\t\tandBool " + cur4 + " >=Int " + big4[0] + " andBool " + cur4
                            + " <=Int " + big4[1] + "\n";
                }
            }
        } else
            throw new InputMismatchException("无效数据类型");
        proveObject.setRegisterMap(registerMap);
        return sourcePre;
    }
}
