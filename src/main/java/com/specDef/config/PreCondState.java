package com.specDef.config;

import lombok.Data;
import com.pojo.Instruction;
import com.pojo.ProveObject;

import java.io.StringReader;
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
        String preCondition = "";
        try {
            // 若出现instruction context为空 或者 目标操作数为空 的情况
            if (instruction == null || instruction.getDestinationRegister() == null) {
                throw new InputMismatchException("context为空或目标操作数为空");
            }
            // 前置条件设定
            // String preCondition = null;
            // 提取prove 目录中的寄存器映射表
            Map<String, String> registerMap = proveObject.getRegisterMap();
            Map<String, BigInteger[]> preCond = proveObject.getPreCond();
            // 目标寄存器
            String destinationRegister = instruction.getDestinationRegister();
            // 当源操作数为立即数时，直接将立即数存储到寄存器映射表中
            if (instruction.getImm() != null) {
                registerMap.put(destinationRegister, instruction.getImm());
                // 将立即数存到preCond中，以免后续获取范围时出现空指针，即左右界都是立即数
                if (!preCond.containsKey(instruction.getImm())) {
                    preCond.put(instruction.getImm(), new BigInteger[]{new BigInteger(instruction.getImm()),
                            new BigInteger(instruction.getImm())});
                }
                // 当MOV的源操作数是立即数时，前置条件为空（验证程序中默认的范围，即当为32位寄存器值时，当立即数超出32位能表达的范围验证器不会判True）
                // 只需验证其后置条件是否满足
                preCondition = isValMov(instruction.getImm());
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
                preCondition = isValMov(value);
            }
            proveObject.setRegisterMap(registerMap);
            proveObject.setPreCond(preCond);
        } catch (InputMismatchException ex) {
            //System.err.println("输入内容为空，请重新输入！");
            ex.printStackTrace();
            return null;
        }
        return preCondition;
    }

    /**
     * MOV指令 构建precondition
     * 当imm存在时，需要判断imm是否为变量，不是变量则无需设置范围，是变量则从变量映射表中提取变量范围值进行设定
     * @param imm
     * @return
     */
    private String isValMov(String imm) {
        StringBuilder preCondition = new StringBuilder();
        if (imm.charAt(0) >= 'A' && imm.charAt(0) <= 'Z') {
            if (!proveObject.getPreCond().containsKey(imm)) {
                throw new InputMismatchException("变量为空，请检测输入的条件");
            } else {
                BigInteger[] bigIntegers = proveObject.getPreCond().get(imm);
                preCondition.append("\t\t\trequires ");
                if (bigIntegers[0].compareTo(minValue) == 0) {  // 左边界为空
                    preCondition.append(imm).append(" <=Int ").append(bigIntegers[1]).append("\n");
                } else if (bigIntegers[1].compareTo(maxValue) == 0) { // 右边界为空
                    preCondition.append(imm).append(" >=Int ").append(bigIntegers[0]).append("\n");
                } else {
                    if (bigIntegers[0].compareTo(bigIntegers[1]) == 0) {    // 左右界相等，即变量是等于某值
                        preCondition.append(imm).append(" ==Int ").append(bigIntegers[0]).append("\n");
                    } else {
                        preCondition.append(bigIntegers[0]).append(" <=Int ").append(imm).append(" andBool ").append(imm)
                                .append(" <=Int ").append(bigIntegers[1]).append("\n");
                    }
                }
                return preCondition.toString();
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
            Map<String, BigInteger[]> preCond = proveObject.getPreCond();
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
                if (sourceRegister.get(0).charAt(0) != 'Q' && sourceRegister.get(0).charAt(0) != 'R') {
                    throw new InputMismatchException("源操作数不为向量寄存器，请重新输入");
                }
                String source = sourceRegister.get(0);
                // 当存在数据类型的时候，表明现在是VMOV.$I模式，需要处理一下目标寄存器，因为目标寄存器为Qn[I]，后面的[I]截取掉
                if (instruction.getDatatype() != null) {
                    int index = Integer.parseInt(destinationRegister.substring(3, destinationRegister.indexOf("]")));
                    int dataSize = Integer.parseInt(instruction.getDatatype().substring(1));
                    destinationRegister = destinationRegister.substring(0, 2);
                    if (registerMap.containsKey(destinationRegister)) {
                        String valDes = registerMap.get(destinationRegister);
                        valDes = dataSize == 8 ? valDes + "00" + index : ((dataSize == 16) ? valDes + "0" + index :
                                valDes + index);
                        preCond.put(valDes, preCond.get(registerMap.get(source)));
                    } else {
                        String valDes = destinationRegister + "_V";
                        registerMap.put(destinationRegister, valDes);
                        if (!preCond.containsKey(valDes)) {
                            preCond.put(valDes, new BigInteger[]{BigInteger.ZERO, BigInteger.ZERO});
                        }
                        valDes = dataSize == 8 ? valDes + "00" + index : (dataSize == 16 ? valDes + "0" + index :
                                valDes + index);
                        preCond.put(valDes, preCond.get(registerMap.get(source)));
                    }
                    String value = registerMap.get(destinationRegister);
                    proveObject.setRegisterMap(registerMap);
                    proveObject.setPreCond(preCond);
                    BigInteger[] sourceValue = preCond.get(registerMap.get(source));
                    StringBuilder sourcePre = new StringBuilder();
                    sourcePre.append("\t\t\t\tandBool ").append(sourceValue[0]).append(" <=Int ").append(registerMap.get(source))
                            .append(" andBool ").append(registerMap.get(source)).append(" <=Int ").append(sourceValue[1])
                            .append("\n");
                    return isValVmov(value) + sourcePre.toString();
                } else {
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
                    proveObject.setRegisterMap(registerMap);
                    proveObject.setPreCond(preCond);
                    return isValVmov(value);
                }
            }
        } catch (RuntimeException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    private String isValVmov(String imm) {
        StringBuilder preCondition = new StringBuilder();
        if (Character.isLetter(imm.charAt(0))) {
            if (!proveObject.getPreCond().containsKey(imm)) {
                throw new RuntimeException("无效变量，请检测输入变量");
            } else {
                preCondition.append("\t\t\trequires ");
                BigInteger[] bigIntegers = proveObject.getPreCond().get(imm);
                if (bigIntegers[0].compareTo(minValue) == 0) {  // 左边界为空
                    preCondition.append(imm).append(" <=Int ").append(bigIntegers[1]).append("\n");
                } else if (bigIntegers[1].compareTo(maxValue) == 0) { // 右边界为空
                    preCondition.append(imm).append(" >=Int ").append(bigIntegers[0]).append("\n");
                } else {
                    if (bigIntegers[0].compareTo(bigIntegers[1]) == 0) {    // 左右界相等，即变量是等于某值
                        preCondition.append(imm).append(" ==Int ").append(bigIntegers[0]).append("\n");
                    } else {
                        preCondition.append(bigIntegers[0]).append(" <=Int ").append(imm).append(" andBool ").append(imm)
                                .append(" <=Int ").append(bigIntegers[1]).append("\n");
                    }
                }
            }
            return preCondition.toString();
        } else // 立即数不设requires
            return "";
    }

    /**
     * VMAXV、VMINV等操作数是通用寄存器与向量寄存器的指令的前置条件设置，使用组合验证方法，分解多个子问题进行解决
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
                preSourceCond = "\t\t\trequires " + setSRegister(sourceRegister, size);
            }
            // 将目标寄存器的值的范围设置到前置条件
            preCondition = setDesCond(preSourceCond, destinationRegister, size);
        } catch (InputMismatchException ex) {
            ex.printStackTrace();
        }
        return preCondition;
    }

    /**
     * 用于设置操作数都为向量寄存器的指令的前置条件
     * @return
     */
    public String allVecPreSet() {
        String preCondition = "";
        try {
            if (instruction == null || instruction.getDestinationRegister() == null) {
                throw new RuntimeException("context is null");
            }
            if (instruction.getSourceRegister() == null || instruction.getSourceRegister().isEmpty()) {
                throw new RuntimeException("Source register is null");
            }
            String desRegister = instruction.getDestinationRegister();
            int size = Integer.parseInt(instruction.getDatatype().substring(1));
            if ("VMAX".equals(instruction.getOpcode()) || "VMIN".equals(instruction.getOpcode())
                || "VSUB".equals(instruction.getOpcode()) || "VRSHL".equals(instruction.getOpcode())
                    || "VQADD".equals(instruction.getOpcode()) || "VADD".equals(instruction.getOpcode())) {
                if (instruction.getSourceRegister().size() < 2)
                    throw new RuntimeException("Number of Source Registers is less than 2");
                preCondition = "\t\t\trequires " + setSRegister(instruction.getSourceRegister().get(0), size)
                        + "\t\t\tandBool " + setSRegister(instruction.getSourceRegister().get(1), size) + "\n";
            } else if ("VMAXA".equals(instruction.getOpcode()) || "VMINA".equals(instruction.getOpcode())) {
                preCondition = "\t\t\trequires " + setSRegister(instruction.getSourceRegister().get(0), size)
                        + "\t\t\tandBool " + setSRegister(instruction.getDestinationRegister(), size) + "\n";
            }
        } catch (RuntimeException ex) {
            ex.printStackTrace();
        }
        return preCondition;
    }

    /**
     * 无数据类型
     * @return
     */
    public String allVecPreSetNoDataType() {
        String preCondition = "";
        try {
            if (instruction == null || instruction.getDestinationRegister() == null) {
                throw new RuntimeException("context is null");
            }
            if (instruction.getSourceRegister() == null || instruction.getSourceRegister().isEmpty()) {
                throw new RuntimeException("Source register is null");
            }
            String desRegister = instruction.getDestinationRegister();
            if ("VAND".equals(instruction.getOpcode()) || "VORR".equals(instruction.getOpcode())) {
                if (instruction.getSourceRegister().size() < 2)
                    throw new RuntimeException("Number of Source Registers is less than 2");
                preCondition = "\t\t\trequires " + setSRegister(instruction.getSourceRegister().get(0), 32)
                        + "\t\t\tandBool " + setSRegister(instruction.getSourceRegister().get(1), 32) + "\n";
            }
        } catch (RuntimeException ex) {
            ex.printStackTrace();
        }
        return preCondition;
    }

    /**
     * 源操作数是向量寄存器和通用寄存器
     * @return
     */
    public String vecAndGeneralPreSet() {
        String preCondition = "";
        try {
            if (instruction == null || instruction.getDestinationRegister() == null) {
                throw new RuntimeException("context is null");
            }
            if (instruction.getSourceRegister() == null || instruction.getSourceRegister().isEmpty()) {
                throw new RuntimeException("Source register is null");
            }
            int size = Integer.parseInt(instruction.getDatatype().substring(1));
            if ("VADD".equals(instruction.getOpcode()) || "VSUB".equals(instruction.getOpcode())
                    || "VMUL".equals(instruction.getOpcode()) || "VQRDMULH".equals(instruction.getOpcode())) {
                if (instruction.getSourceRegister().size() < 2)
                    throw new RuntimeException("Number of Source Registers is less than 2");
                String desRegister = instruction.getSourceRegister().get(1);
                preCondition = "\t\t\trequires " + setSRegister(instruction.getSourceRegister().get(0), size);
                preCondition = setDesCond(preCondition, desRegister, size);
            } else if ("VNEG".equals(instruction.getOpcode())) {
                preCondition = "\t\t\trequires " + setSRegister(instruction.getSourceRegister().get(0), size);
            } else if ("VSHR".equals(instruction.getOpcode()) || "VSHL".equals(instruction.getOpcode())) {
                preCondition = "\t\t\trequires " + setSRegister(instruction.getSourceRegister().get(0), size);
                if (instruction.getImm() != null && Character.isLetter(instruction.getImm().charAt(0))) {
                    Map<String, BigInteger[]> preCond = proveObject.getPreCond();
                    preCondition = preCondition + "\t\t\tandBool " + instruction.getImm() + " >=Int " +
                            preCond.get(instruction.getImm())[0] + " andBool " + instruction.getImm() +
                            " <=Int " + preCond.get(instruction.getImm())[1] + "\n";
                }
            } else if ("VMLA".equals(instruction.getOpcode())) {
                if (instruction.getSourceRegister().size() < 2)
                    throw new RuntimeException("Number of Source Registers is less than 2");
                String desRegister = instruction.getSourceRegister().get(1);
                preCondition = "\t\t\trequires " + setSRegister(instruction.getSourceRegister().get(0), size);
                if (!instruction.getDestinationRegister().equals(instruction.getSourceRegister().get(0))) {
                    preCondition = preCondition + "\t\t\tandBool " + setSRegister(instruction.getDestinationRegister(), size);
                }
                preCondition = setDesCond(preCondition, desRegister, size);
            }
        } catch (RuntimeException ex) {
            ex.printStackTrace();
        }
        return preCondition;
    }

    /**
     * for VMLAV, set the initial state of each element of the precondition
     * @return
     */
    public String vecPreSet() {
        String preCondition = null;
        try {
            if (instruction == null || instruction.getDestinationRegister() == null) {
                throw new RuntimeException("context is null");
            }
            if (instruction.getSourceRegister() == null || instruction.getSourceRegister().isEmpty()) {
                throw new RuntimeException("Source register is null");
            }
            String destinationRegister = instruction.getDestinationRegister();
            int size = Integer.parseInt(instruction.getDatatype().substring(1));
            if (beat == 0) {
                StringBuilder curSource = new StringBuilder();
                curSource.append(setSRegister(instruction.getSourceRegister().get(0), size)).append("\t\t\tandBool ");
                curSource.append(setSRegister(instruction.getSourceRegister().get(1), size));
                preSourceCond = "\t\t\trequires " + curSource;
            }
            preCondition = setDesCond(preSourceCond, destinationRegister, size);
        } catch (RuntimeException ex) {
            ex.printStackTrace();
        }
        return preCondition;
    }

    /**
     * 通用寄存器的前置条件
     * @param preSourceCond 源操作数的前置条件
     * @param destinationRegister   目标通用寄存器
     * @param size  数据类型长度
     * @return  前置条件
     */
    private String setDesCond(String preSourceCond, String destinationRegister, int size) {
        String desPreCond = null;
        Map<String, BigInteger[]> preCond = proveObject.getPreCond();
        Map<String, String> registerMap = proveObject.getRegisterMap();
        if (!registerMap.containsKey(destinationRegister)) {
            if ("VMLAV".equals(instruction.getOpcode())) {
                registerMap.put(destinationRegister, "0");
                preCond.put("0", new BigInteger[]{BigInteger.ZERO, BigInteger.ZERO});
            } else
                throw new InputMismatchException("目标寄存器无对应值，请重新设置");
        }
        String val = registerMap.get(destinationRegister);
        if (val != null && preCond.get(val) == null) {
            preCond.put(val, new BigInteger[]{new BigInteger(val), new BigInteger(val)});
        }
        BigInteger[] bigIntegers = preCond.get(val);
        desPreCond = preSourceCond + "\t\t\tandBool " + val + " >=Int " + bigIntegers[0] +
                " andBool " + val + " <=Int " + bigIntegers[1] + "\n";
        proveObject.setRegisterMap(registerMap);
        proveObject.setPreCond(preCond);
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
        StringBuilder sourcePre = new StringBuilder();
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
                    sourcePre.append(cur).append(" >=Int ").append(bigIntegers[0]).append(" andBool ").append(cur)
                            .append(" <=Int ").append(bigIntegers[1]).append("\n");
                } else {
                    sourcePre.append("\t\t\tandBool ").append(cur).append(" >=Int ").append(bigIntegers[0])
                            .append(" andBool ").append(cur).append(" <=Int ").append(bigIntegers[1]).append("\n");
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
                    sourcePre.append(cur1).append(" >=Int ").append(bigIntegers1[0]).append(" andBool ").append(cur1)
                            .append(" <=Int ").append(bigIntegers1[1]).append("\n\t\t\tandBool ")
                            .append(cur2).append(" >=Int ").append(bigIntegers2[0]).append(" andBool ").append(cur2).append(" <=Int ")
                            .append(bigIntegers2[1]).append("\n");
                } else {
                    sourcePre.append("\t\t\tandBool ").append(cur1).append(" >=Int ")
                            .append(bigIntegers1[0]).append(" andBool ").append(cur1).append(" <=Int ").append(bigIntegers1[1])
                            .append("\n\t\t\tandBool ").append(cur2).append(" >=Int ").append(bigIntegers2[0]).append(" andBool ")
                            .append(cur2).append(" <=Int ").append(bigIntegers2[1]).append("\n");
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
                    sourcePre.append(cur1).append(" >=Int ").append(big1[0]).append(" andBool ").append(cur1)
                            .append(" <=Int ").append(big1[1]).append("\n\t\t\tandBool ").append(cur2).append(" >=Int ")
                            .append(big2[0]).append(" andBool ").append(cur2).append(" <=Int ").append(big2[1])
                            .append("\n\t\t\tandBool ").append(cur3).append(" >=Int ").append(big3[0])
                            .append(" andBool ").append(cur3).append(" <=Int ").append(big3[1])
                            .append("\n\t\t\tandBool ").append(cur4).append(" >=Int ").append(big4[0])
                            .append(" andBool ").append(cur4).append(" <=Int ").append(big4[1]).append("\n");
                } else {
                    sourcePre.append("\t\t\tandBool ").append(cur1).append(" >=Int ").append(big1[0]).append(" andBool ")
                            .append(cur1).append(" <=Int ").append(big1[1]).append("\n\t\t\tandBool ").append(cur2)
                            .append(" >=Int ").append(big2[0]).append(" andBool ").append(cur2).append(" <=Int ")
                            .append(big2[1]).append("\n\t\t\tandBool ").append(cur3).append(" >=Int ").append(big3[0])
                            .append(" andBool ").append(cur3).append(" <=Int ").append(big3[1])
                            .append("\n\t\t\tandBool ").append(cur4).append(" >=Int ").append(big4[0])
                            .append(" andBool ").append(cur4).append(" <=Int ").append(big4[1]).append("\n");
                }
            }
        } else
            throw new InputMismatchException("无效数据类型");
        proveObject.setRegisterMap(registerMap);
        return sourcePre.toString();
    }

    public String vdupRQPreSet() {
        String preCondition = "";
        try {
            if (instruction == null || instruction.getDestinationRegister() == null) {
                throw new RuntimeException("context is null");
            }
            if (instruction.getSourceRegister() == null || instruction.getSourceRegister().isEmpty()) {
                throw new RuntimeException("Source register is null");
            }
            String sourceRegister = instruction.getSourceRegister().get(0);
            // 无ISUF
            int size = Integer.parseInt(instruction.getDatatype());
            if ("VDUP".equals(instruction.getOpcode())) {
                Map<String, BigInteger[]> preCond = proveObject.getPreCond();
                Map<String, String> registerMap = proveObject.getRegisterMap();
                if (!registerMap.containsKey(sourceRegister))
                    throw new InputMismatchException("目标寄存器无对应值，请重新设置");
                String val = registerMap.get(sourceRegister);
                if (val != null && preCond.get(val) == null) {
                    preCond.put(val, new BigInteger[]{new BigInteger(val), new BigInteger(val)});
                }
                BigInteger[] bigIntegers = preCond.get(val);
                preCondition = "\t\t\trequires " + val + " >=Int " + bigIntegers[0] +
                        " andBool " + val + " <=Int " + bigIntegers[1] + "\n";
                proveObject.setPreCond(preCond);
            }
        } catch (RuntimeException ex) {
            ex.printStackTrace();
        }
        return preCondition;
    }
}
