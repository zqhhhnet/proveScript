package com.specDef.config;

import com.bv2int.Binary2Signed;
import lombok.Data;
import com.pojo.Instruction;
import com.pojo.ProveObject;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.InputMismatchException;
import java.util.List;
import java.util.Map;

@Data
public class PostCondState {
    private Instruction instruction;
    private ProveObject proveObject;
    private int beat;
    private List<String> sourcePostCond;
    private static final String preTmp = "New";
    private static String oldVal;

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
            throw new RuntimeException("指令或目标寄存器为空");
        if (proveObject.getRegisterMap().get(instruction.getDestinationRegister()) == null)
            throw new RuntimeException("目标寄存器在寄存器表中为空，即无输入，请重新输入");
    }

    /**
     * 用于设置向量寄存器对应的4个32位浮点寄存器
     * @param postCondition
     * @param desReg
     * @param imm
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

    /**
     * VMAXV后置条件设定，主要是在regstate中设置
     * @return
     */
    public List<String> vvIntPostSet() {
        List<String> postCondition = new ArrayList<>();
        try {
            checkException();
            if (sourcePostCond == null || sourcePostCond.isEmpty()) {
                sourcePostCond = new ArrayList<>();
            }
            if (instruction.getSourceRegister() == null || instruction.getSourceRegister().isEmpty())
                throw new InputMismatchException("源操作数为空");
            String datatype = instruction.getDatatype();
            int size = Integer.parseInt(datatype.substring(1));
            Map<String, String> registerMap = proveObject.getRegisterMap();
            // 设定源寄存器的值，如向量寄存器、对应的浮点寄存器，需要通过size进行判断
            // 第一个beat时记录源寄存器的映射关系，后续无须重复
            String sourceReg = instruction.getSourceRegister().get(0);
            String indexStr = sourceReg.substring(1);
            int index = Integer.parseInt(indexStr) * 4;
            if (beat == 0) {
                // 当size为32时，即每个元素都是32位，直接对应浮点寄存器的值，因此可以直接映射
                if (size == 32) {
                    String qReg = concaMInt(sourceReg, 4, 32);
                    sourcePostCond.add(qReg);
                    for (int i = 0; i < 4; i++) {
                        String cur = "S" + (index+i);
                        String sReg = concaMInt(cur, 1, 32);
                        sourcePostCond.add(sReg);
                    }
                } else if (size == 16) {
                    // 当size为16时，即每个元素占浮点寄存器16位，一个浮点寄存器包含两个元素，需要通过concatenate连接
                    String qReg = concaMInt(sourceReg, 8, 16);
                    sourcePostCond.add(qReg);
                    for (int i = 0; i < 4; i++) {
                        String cur = "S" + (index+i);
                        String sReg = concaMInt(cur, 2, 16);
                        sourcePostCond.add(sReg);
                    }
                }else if (size == 8) {
                    // 当size为8时，即每个元素占浮点寄存器8位，一个浮点寄存器包含4个元素，需要通过3个concatenate连接
                    String qReg = concaMInt(sourceReg, 16, 8);
                    sourcePostCond.add(qReg);
                    for (int i = 0; i < 4; i++) {
                        String cur = "S" + (index+i);
                        String sReg = concaMInt(cur, 4, 8);
                        sourcePostCond.add(sReg);
                    }
                } else {
                    throw new InputMismatchException("数据类型无效，请重新输入");
                }
            }
            for (String s : sourcePostCond) {
                String ns = s;
                postCondition.add(ns);
            }
            // 设定目标寄存器的值，需要根据beat判断当前比较的对象是哪个元素
            StringBuilder desCond = new StringBuilder();
            String destinationRegister = instruction.getDestinationRegister();
            String val = registerMap.get(destinationRegister);
            if (beat == 0)
                oldVal = val;
            desCond.append("\t\t\t\"").append(destinationRegister).append("\" |-> ").append("(mi(32, ")
                    .append(val).append(") => ");
            StringBuilder sRegVal = new StringBuilder();
            Map<String, BigInteger[]> preCond = proveObject.getPreCond();
            BigInteger[] desRange = preCond.get(val);
            String lower = desRange[0].toString(2);
            BigInteger desLower = new BigInteger(Binary2Signed.AddBinToDec(Binary2Signed.signExtend(lower, 32).substring(32-size),
                    true));
            String higher = desRange[1].toString(2);
            BigInteger desHigher = new BigInteger(Binary2Signed.AddBinToDec(Binary2Signed.signExtend(higher, 32).substring(32-size),
                    true));
            if (size == 32) {
                String sourceVal = registerMap.get(sourceReg);
                sRegVal.append(sourceVal).append(beat);
                String sMInt = datatype.charAt(0) == 'S' ? "svalueMInt" : "uvalueMInt";
                desCond.append("ifMInt (").append(sMInt).append("(mi(32, ").append(val).append(") >=Int ").append(sMInt)
                        .append("(mi(32, ").append(sRegVal).append(")) then mi(32, ").append(val).append(") else mi(32, ")
                        .append(sRegVal).append("))\n");
                BigInteger[] sourceRange = preCond.get(sRegVal.toString());
                desHigher = desHigher.compareTo(sourceRange[1]) >= 0 ? desHigher : sourceRange[1];
                desLower = desLower.compareTo(sourceRange[1]) >= 0 ? desLower :
                        (desLower.compareTo(sourceRange[0]) >= 0 ? desLower : sourceRange[0]);
            } else if (size == 16 || size == 8) {
                String sourceVal = registerMap.get(sourceReg);
                sRegVal.append(sourceVal).append(size == 8 ? "00" : "0").append(beat);
                String sMInt = datatype.charAt(0) == 'S' ? "svalueMInt" : "uvalueMInt";
                desCond.append("mi(32, ").append("svalueMInt(").append("ifMInt ").append(sMInt).append('(').append("extractMInt(mi(32, ").append(val)
                        .append("), ").append(size == 8 ? "24, 32)) >Int " : "16, 32)) >Int ").append(sMInt).append("(mi(")
                        .append(size).append(", ").append(sRegVal).append(")) then extractMInt(mi(32, ").append(val)
                        .append("), ").append(size == 8 ? "24, 32) " : "16, 32) ").append("else mi(").append(size)
                        .append(", ").append(sRegVal).append("))))\n");
                BigInteger[] sourceRange = preCond.get(sRegVal.toString());
                desHigher = desHigher.compareTo(sourceRange[1]) >= 0 ? desHigher : sourceRange[1];
                desLower = desLower.compareTo(sourceRange[1]) >= 0 ? desLower :
                        (desLower.compareTo(sourceRange[0]) >= 0 ? desLower : sourceRange[0]);
            } else {
                throw new InputMismatchException("数据类型非法，请检查");
            }
            String newVal = preTmp + oldVal + beat;
            preCond.put(newVal, new BigInteger[] {desLower, desHigher});
            registerMap.put(destinationRegister, newVal);
            proveObject.setRegisterMap(registerMap);
            proveObject.setPreCond(preCond);
            postCondition.add(desCond.toString());
            // 需要在这里提前预算目标寄存器的新值，即新范围
        } catch (InputMismatchException ex) {
            ex.printStackTrace();
        }
        return postCondition;
    }

    /**
     * 将源寄存器在regstate的映射关系设置好
     * @param reg       当前寄存器，可以是向量寄存器或浮点寄存器
     * @param size      寄存器中有多少元素
     * @param width     每个元素的宽度
     * @return
     */
    public String concaMInt(String reg, int size, int width) {
        StringBuilder concaVal = new StringBuilder();
        // int index = Integer.parseInt(reg.substring(1));
        concaVal.append("\t\t\t\"").append(reg).append('\"').append(" |-> ");
        if (reg.charAt(0) == 'Q') {
            // index = index * 4;
            StringBuilder regPre = new StringBuilder(proveObject.getRegisterMap().get(reg));
            if (size == 8) {
                regPre.append('0');
            } else if (size == 16) {
                regPre.append("00");
            }
            for (int i = size-1; i >= 0; i--) {
                String cur = regPre.toString() + i;
                if (i != 0) {
                    concaVal.append("concatenateMInt(mi(").append(width).append(", ").append(cur).append("), ");
                } else {
                    concaVal.append("mi(").append(width).append(", ").append(cur).append(')');
                }
            }
            for (int i = 0; i < size-1; i++) {
                concaVal.append(')');
            }
            concaVal.append('\n');
        } else if (reg.charAt(0) == 'S') {
            if (width == 32) {
                concaVal.append("mi(32, ").append(proveObject.getRegisterMap().get(reg)).append('\n');
            } else {
                String[] vals = proveObject.getRegisterMap().get(reg).split(":");
                for (int i = 0; i < vals.length; i++) {
                    if (i != vals.length-1) {
                        concaVal.append("concatenateMInt(mi(").append(width).append(", ").append(vals[i]).append("), ");
                    } else {
                        concaVal.append("mi(").append(width).append(", ").append(vals[i]).append(")");
                    }
                }
                for (int i = 0; i < vals.length-1; i++) {
                    concaVal.append(')');
                }
                concaVal.append('\n');
            }
        }
        return concaVal.toString();
    }
}
