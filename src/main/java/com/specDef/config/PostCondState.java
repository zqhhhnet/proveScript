package com.specDef.config;

import com.bv2int.Binary2Signed;
import lombok.Data;
import com.pojo.Instruction;
import com.pojo.ProveObject;

import java.math.BigInteger;
import java.util.*;
import java.util.stream.Stream;

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
            if (instruction == null || instruction.getDestinationRegister() == null)
                throw new RuntimeException("指令或目标寄存器为空");
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
                if (instruction.getDatatype() == null) {
                    String sourceReg = "\t\t\t\"" + sourceRegister.get(0) + "\" |-> mi(128, " + val + ")\n";
                    String destinationReg = "\t\t\t\"" + destinationRegister + "\" |-> mi(128, " + val + ")\n";
                    postCondition.add(sourceReg);
                    postCondition.add(destinationReg);
                    setSReg(postCondition, sourceRegister.get(0), val);
                    setSReg(postCondition, destinationRegister, val);
                } else {    // VMOV.$I Qn[D], Rn
                    String sourceReg = "\t\t\t\"" + sourceRegister.get(0) + "\" |-> mi(32, " + val + ")\n";
                    int dataSize = Integer.parseInt(instruction.getDatatype().substring(1));
                    int index = Integer.parseInt(destinationRegister.substring(3, destinationRegister.indexOf("]")));
                    destinationRegister = destinationRegister.substring(0, 2);
                    String valDes = proveObject.getRegisterMap().get(destinationRegister);
                    int cur = Integer.parseInt(destinationRegister.substring(1));
                    int speIndex = index / (32 / dataSize);
                    String destinationReg;
                    if ((dataSize == 32 && index > 0 && index < 3) || (dataSize == 16 && index > 0 && index < 7)
                        || (dataSize == 8 && index > 0 && index < 15)) {
                        destinationReg = "\t\t\t\"" + destinationRegister + "\" |-> (mi(128, " + valDes + ") => " +
                                "concatenateMInt(extractMInt(mi(128, " + valDes + "), 0, " + (128 - (index+1) * dataSize) +
                                "), concatenateMInt(extractMInt(mi(32, " + val + "), " + (32 - dataSize) + ", 32), extractMInt(mi(128, " +
                                valDes + "), " + (128 - index * dataSize) + ", 128))))\n";
                    } else if (index == 0) {
                        destinationReg = "\t\t\t\"" + destinationRegister + "\" |-> (mi(128, " + valDes + ") => " +
                                "concatenateMInt(extractMInt(mi(128, " + valDes + "), 0, " + (128 - dataSize) + "), extractMInt(mi(32, "
                                + val + "), " + (32 - dataSize) + ", 32)))\n";
                    } else {
                        destinationReg = "\t\t\t\"" + destinationRegister + "\" |-> (mi(128, " + valDes + ") => " +
                                "concatenateMInt(extractMInt(mi(32, " + val + "), " + (32 - dataSize) + ", 32), extractMInt(mi(128, " +
                                valDes + "), " + dataSize + ", 128)))\n";
                    }
                    postCondition.add(sourceReg);
                    postCondition.add(destinationReg);
                    for (int i = 0; i <= 3; i++) {
                        StringBuilder sReg = new StringBuilder();
                        sReg.append('S').append(cur * 4 + i);
                        String post;
                        if (i != speIndex) {
                            post = "\t\t\t\"" + sReg + "\" |-> extractMInt(mi(128, " + valDes + "), " + ((3-i) * 32) +
                                    ", " + ((4-i) * 32) + ")\n";
                        } else {
                            if (dataSize == 32) {
                                post = "\t\t\t\"" + sReg + "\" |-> (extractMInt(mi(128, " + valDes + "), " + ((3-i)*32) +
                                        ", " + ((4-i)*32) + ") => mi(32, " + val + "))\n";
                            } else if (dataSize == 16) {
                                if (index % 2 == 0) {
                                    post = "\t\t\t\"" + sReg + "\" |-> (extractMInt(mi(128, " + valDes + "), " + ((3-i)*32) +
                                            ", " + ((4-i)*32) + ") => concatenateMInt(extractMInt(mi(128, " + valDes + "), " +
                                            ((3-i)*32) + ", " + (128 - (index + 1) * 16) + "), extractMInt(mi(32, " +
                                            val + "), 16, 32)))\n";
                                } else {
                                    post = "\t\t\t\"" + sReg + "\" |-> (extractMInt(mi(128, " + valDes + "), " + ((3-i)*32) +
                                            ", " + ((4-i)*32) + ") => concatenateMInt(extractMInt(mi(32, " + val + "), 16, 32), " +
                                            "extractMInt(mi(128, " + valDes + "), " + (128 - index * 16) + ", "
                                            + ((4-i)*32) + ")))\n";
                                }
                            } else {
                                if (index % 4 == 0) {
                                    post = "\t\t\t\"" + sReg + "\" |-> (extractMInt(mi(128, " + valDes + "), " + ((3-i) * 32) +
                                            ", " + ((4-i) * 32) + ") => concatenateMInt(extractMInt(mi(128, " + valDes + "), " +
                                            ((3-i) * 32) + ", " + (128 - (index + 1) * 8) + "), extractMInt(mi(32, " +
                                            val + "), 24, 32)))\n";
                                } else if (index % 4 == 3) {
                                    post = "\t\t\t\"" + sReg + "\" |-> (extractMInt(mi(128, " + valDes + ")," + ((3-i)*32) +
                                            ", " + ((4-i)*32) + ") => concatenateMInt(extractMInt(mi(32, " + val + "), 24, 32), " +
                                            "extractMInt(mi(128, " + valDes + "), " + (128 - index * 8) + ", "
                                            + ((4-i)*32) + ")))\n";
                                } else {
                                    post = "\t\t\t\"" + sReg + "\" |-> (extractMInt(mi(128, " + valDes + "), " + ((3-i) * 32) +
                                            ", " + ((4-i) * 32) + ") => concatenateMInt(extractMInt(mi(128, " + valDes + "), " +
                                            ((3-i) * 32) + ", " + (128 - (index + 1) * dataSize) + "), concatenateMInt(extractMInt(mi(32, "
                                            + val + "), " + (32 - dataSize) + ", 32), extractMInt(mi(128, " + valDes + "), "
                                            + (128 - index*dataSize) + ", " + ((4-i) * 32) + "))))\n";
                                }
                            }
                        }
                        postCondition.add(post);
                    }
                }
            }
            return postCondition;
        } catch (RuntimeException ex) {
            ex.printStackTrace();
            return null;
        }
    }

    private void checkException() {
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
    private static void setSReg(List<String> postCondition, String desReg, String imm) {
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
     * 关于操作数是R和Q的绝对值比较
     * @return
     */
    public List<String> vvIntAbsPostSet() {
        List<String> postCondition = new ArrayList<>();
        try {
            checkException();
            if (instruction.getSourceRegister() == null || instruction.getSourceRegister().isEmpty())
                throw new InputMismatchException("源操作数为空");
            if (sourcePostCond == null || sourcePostCond.isEmpty()) {
                sourcePostCond = new ArrayList<>();
            }
            String datatype = instruction.getDatatype();
            int size = Integer.parseInt(datatype.substring(1));
            Map<String, String> registerMap = proveObject.getRegisterMap();
            String sourceReg = instruction.getSourceRegister().get(0);
            String indexStr = sourceReg.substring(1);
            int index = Integer.parseInt(indexStr) * 4;
            if (beat == 0) {
                setSourcePostCond(size, index, sourceReg);
            }
            postCondition.addAll(sourcePostCond);
            StringBuilder desCond = new StringBuilder();
            String destinationRegister = instruction.getDestinationRegister();
            String val = registerMap.get(destinationRegister);
            //TODO: 需要处理一下引入的新变量的命名，当调用到该寄存器的值次数过多，且更改时，会引入很多数字后缀，如 A1213213123..等
            if (beat == 0) {
                oldVal = val;
            }
            desCond.append("\t\t\t\"").append(destinationRegister).append("\" |-> ").append("(mi(32, ")
                    .append(val).append(") => ");
            StringBuilder sRegVal = new StringBuilder();
            Map<String, BigInteger[]> preCond = proveObject.getPreCond();
            BigInteger[] desRange = preCond.get(val);
            String lower = desRange[0].toString(2);
            String higher = desRange[1].toString(2);
            // 获取目标通用寄存器的值
            BigInteger desLower, desHigher;
            desLower = new BigInteger(Binary2Signed.AddBinToDec(Binary2Signed.signExtend(lower, 32).substring(32-size),
                    true));
            desHigher = new BigInteger(Binary2Signed.AddBinToDec(Binary2Signed.signExtend(higher, 32).substring(32-size),
                    true));
            // 根据size进行设定对应的postcondition
            String cmpMode = "VMAXAV".equals(instruction.getOpcode()) ? "<=Int" : ">=Int";
            BigInteger[] newDesRange;
            if (size == 32) {
                String sourceVal = registerMap.get(sourceReg);
                sRegVal.append(sourceVal).append(beat);
                desCond.append("ifMInt (").append("absInt(").append(sourceVal).append(") ").append(cmpMode).append(" uvalueMInt(")
                        .append("mi(32, ").append(val).append("))) then mi(32, ").append(val).append(") else mi(32, ")
                        .append("absInt(").append(sRegVal).append(")))\n");
                BigInteger[] sourceRange = preCond.get(sRegVal.toString());
                // 还是需要再处理一下，由于前面的指令可能存在改变寄存器值的指令，因此值的范围有可能会与初始设定不一样，因此可能会出现无符号下溢或带符号上溢的情况
                normalize(sourceRange, datatype, size);
                // 分情况讨论，VMAXAV中，当目标寄存器上界小于0，则直接取目标寄存器的值为范围，否则进入下一步
                // 判断目标寄存器值下界是否小于0，若小于0，则取小于0为下界，上界取（目标操作数上界、源下界绝对值、源上界绝对值中最大的值）
                // 若大于0，则比较源寄存器的下界是否小于0，小于0则取目标下界作为下界，上界取（目标操作数上界、源下界绝对值、源上界绝对值中最大的值）；大于0则取下界的较大值，上界取（目标上界和源上界的较大值）。
                newDesRange = getAbsDesRange(sourceRange, desLower, desHigher);
            } else if (size == 16 || size == 8) {
                String sourceVal = registerMap.get(sourceReg);
                sRegVal.append(sourceVal).append(size == 8 ? "00" : "0").append(beat);
                desCond.append("mi(32, ").append("svalueMInt(").append("ifMInt ").append("absInt(").append(sRegVal).append(") ")
                        .append(cmpMode).append(" uvalueMInt(").append("extractMInt(mi(32, ").append(val)
                        .append("), ").append(size == 8 ? "24, 32))" : "16, 32))").append(" then extractMInt(mi(32, ").append(val)
                        .append("), ").append(size == 8 ? "24, 32) " : "16, 32) ").append("else mi(").append(size)
                        .append(", absInt(").append(sRegVal).append(")))))\n");
                BigInteger[] sourceRange = preCond.get(sRegVal.toString());
                // 同上
                normalize(sourceRange, datatype, size);
                newDesRange = getAbsDesRange(sourceRange, desLower, desHigher);
            } else {
                throw new InputMismatchException("数据类型非法，请检查");
            }
            StringBuilder newVal = new StringBuilder();
            newVal.append(preTmp).append(oldVal).append(beat);
            preCond.put(newVal.toString(), newDesRange);
            registerMap.put(destinationRegister, newVal.toString());
            proveObject.setRegisterMap(registerMap);
            proveObject.setPreCond(preCond);
            postCondition.add(desCond.toString());
        } catch (InputMismatchException ex) {
            ex.printStackTrace();
        }
        return postCondition;
    }

    /**
     * 获取绝对值比较后，目标操作数对应的范围
     * @param sourceRange
     * @param desLower
     * @param desHigher
     * @return
     */
    private BigInteger[] getAbsDesRange(BigInteger[] sourceRange, BigInteger desLower, BigInteger desHigher) {
        if ("VMAXAV".equals(instruction.getOpcode())) {
            if (desHigher.compareTo(BigInteger.ZERO) < 0) {

            } else if (desLower.compareTo(BigInteger.ZERO) < 0) {
                desHigher = sourceRange[0].abs().compareTo(sourceRange[1].abs()) < 0 ?
                        (sourceRange[1].abs().compareTo(desHigher) < 0 ? desHigher : sourceRange[1].abs()) :
                        (sourceRange[0].abs().compareTo(desHigher) < 0 ? desHigher : sourceRange[0].abs());
            } else if (desLower.compareTo(BigInteger.ZERO) >= 0) {
                if (sourceRange[0].compareTo(BigInteger.ZERO) <= 0) {
                    desHigher = sourceRange[0].abs().compareTo(sourceRange[1].abs()) < 0 ?
                            (sourceRange[1].abs().compareTo(desHigher) < 0 ? desHigher : sourceRange[1].abs()) :
                            (sourceRange[0].abs().compareTo(desHigher) < 0 ? desHigher : sourceRange[0].abs());
                } else {
                    desLower = desLower.compareTo(sourceRange[0]) <= 0 ? sourceRange[0] : desLower;
                    desHigher = desHigher.compareTo(sourceRange[1]) <= 0 ? sourceRange[1] : desHigher;
                }
            }
        } else {
            if (sourceRange[0].compareTo(BigInteger.ZERO) < 0) {
                sourceRange[1] = sourceRange[0].abs().compareTo(sourceRange[1].abs()) < 0 ? sourceRange[1].abs() :
                        sourceRange[0].abs();
                sourceRange[0] = BigInteger.ZERO;
            }
            // VMINAV中，当目标寄存器上界小于0，直接取source
            // 当下界小于0，直接取 0 - source的上界
            // 当下界大于等于0，正常取，下界取小的，上界取小的
            if (desHigher.compareTo(BigInteger.ZERO) < 0) {
                desLower = sourceRange[0];
                desHigher = sourceRange[1];
            } else if (desLower.compareTo(BigInteger.ZERO) < 0) {
                desLower = BigInteger.ZERO;
                desHigher = sourceRange[1];
            } else if (desLower.compareTo(BigInteger.ZERO) >= 0) {
                desLower = desLower.compareTo(sourceRange[0]) <= 0 ? desLower : sourceRange[0];
                desHigher = desHigher.compareTo(sourceRange[1]) <= 0 ? desHigher : sourceRange[1];
            }
        }
        return new BigInteger[]{desLower, desHigher};
    }

    /**
     * VMAXV、VMINV后置条件设定，主要是在regstate中设置
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
                setSourcePostCond(size, index, sourceReg);
            }
            postCondition.addAll(sourcePostCond);
            // 设定目标寄存器的值，需要根据beat判断当前比较的对象是哪个元素
            StringBuilder desCond = new StringBuilder();
            String destinationRegister = instruction.getDestinationRegister();
            String val = registerMap.get(destinationRegister);
            if (beat == 0)
                oldVal = val;   // 暂存通用寄存器最初的值，用于构建其元素值
            desCond.append("\t\t\t\"").append(destinationRegister).append("\" |-> ").append("(mi(32, ")
                    .append(val).append(") => ");
            StringBuilder sRegVal = new StringBuilder();
            Map<String, BigInteger[]> preCond = proveObject.getPreCond();
            BigInteger[] desRange = preCond.get(val);
            String lower = desRange[0].toString(2);
            String higher = desRange[1].toString(2);
            BigInteger desLower, desHigher;
            if (datatype.charAt(0) == 'S') {
                // 当为带符号时，查看上界是否大于带符号数能表示的整数范围，若大于，则将其转换为带符号对应的范围
                // 如 -10 ~ 128， 128超出带符号位（8位）能表示的范围，因此将128转为对应带符号数，即 -128
                // 所以当超出上界时，还是对上例，范围可以取-128 ~ 127，因为下界还是-128，上界127（原来是 0 ~ 127 和 -128 ~ -128）
                // 由于后续的向量内积运算取上下界范围，因此当下界最小为-128，取（-128 ~ 127）不影响最终的结果上下界范围（只会影响中间部分）
                // 而验证只需要保证结果不超越二进制串能表示的范围，关于最终结果是通过原来的操作逻辑保证，因此不影响最终的验证。
                desLower = new BigInteger(Binary2Signed.AddBinToDec(Binary2Signed.signExtend(lower, 32).substring(32-size),
                        true));
                desHigher = new BigInteger(Binary2Signed.AddBinToDec(Binary2Signed.signExtend(higher, 32).substring(32-size),
                        true));
                // 所以当在带符号的数据类型中出现范围上界超越该数据类型的二进制串能表示的带符号数范围时（带符号数是上界）
                // 直接取当前二进制串能表示的范围
                if (desHigher.compareTo(BigInteger.valueOf((1L << (size - 1)) - 1)) > 0) {
                    desLower = BigInteger.valueOf(-(1L<<(size-1)));
                    desHigher = BigInteger.valueOf((1L<<(size-1))-1L);
                }
            } else {
                // 当为无符号时，查看下界是否大于上界，若是，则需要引入新范围即下界到无符号最大值作为新一个区间，0到上界为另一个区间
                // 如 -10 ~ 10，为无符号数时，-10对应2进制串的无符号数为246，因此对应无符号数区间为 0~10 和 246 ~ 255
                // 此处应该可以将范围取为0~255，由于取最大值，因此总会存在255为上界的情况，这对后续的向量内积运算的范围（取上下界最值）没有影响
                desLower = new BigInteger(Binary2Signed.ORGBinToDec(Binary2Signed.signExtend(lower, 32).substring(32-size),
                        false));
                desHigher = new BigInteger(Binary2Signed.ORGBinToDec(Binary2Signed.signExtend(higher, 32).substring(32-size),
                        false));
                // 同理，当在无符号数的数据类型中出现范围下界小于0的时候
                // 直接取当前二进制串能表示的范围
                if (desLower.compareTo(BigInteger.ZERO) < 0) {
                    desLower = BigInteger.ZERO;
                    desHigher = BigInteger.valueOf((1L<<size)-1);
                }
            }
            String sMInt = datatype.charAt(0) == 'S' ? "svalueMInt" : "uvalueMInt";
            String cmpMode = "VMAXV".equals(instruction.getOpcode()) ? " >Int " : " <Int ";
            BigInteger[] elementRange;
            if (size == 32) {
                String sourceVal = registerMap.get(sourceReg);
                sRegVal.append(sourceVal).append(beat);
                desCond.append("ifMInt (").append(sMInt).append("(mi(32, ").append(val).append(')').append(cmpMode).append(sMInt)
                        .append("(mi(32, ").append(sRegVal).append(")) then mi(32, ").append(val).append(") else mi(32, ")
                        .append(sRegVal).append("))\n");
                BigInteger[] sourceRange = preCond.get(sRegVal.toString());
                // 还是需要再处理一下，由于前面的指令可能存在改变寄存器值的指令，因此值的范围有可能会与初始设定不一样，因此可能会出现无符号下溢或带符号上溢的情况
                normalize(sourceRange, datatype, size);
                // 分情况讨论，VMAXV去较大的界，VMINV取较小的界
                elementRange = getElementRange(new BigInteger[]{desLower, desHigher}, sourceRange);
            } else if (size == 16 || size == 8) {
                String sourceVal = registerMap.get(sourceReg);
                sRegVal.append(sourceVal).append(size == 8 ? "00" : "0").append(beat);
                desCond.append("mi(32, ").append("svalueMInt(").append("ifMInt ").append(sMInt).append('(').append("extractMInt(mi(32, ").append(val)
                        .append("), ").append(size == 8 ? "24, 32))" : "16, 32))").append(cmpMode).append(sMInt).append("(mi(")
                        .append(size).append(", ").append(sRegVal).append(")) then extractMInt(mi(32, ").append(val)
                        .append("), ").append(size == 8 ? "24, 32) " : "16, 32) ").append("else mi(").append(size)
                        .append(", ").append(sRegVal).append("))))\n");
                BigInteger[] sourceRange = preCond.get(sRegVal.toString());
                // 同上
                normalize(sourceRange, datatype, size);
                elementRange = getElementRange(new BigInteger[]{desLower, desHigher}, sourceRange);
            } else {
                throw new InputMismatchException("数据类型非法，请检查");
            }
            StringBuilder newVal = new StringBuilder();
            newVal.append(preTmp).append(oldVal).append(beat);
            preCond.put(newVal.toString(), elementRange);
            registerMap.put(destinationRegister, newVal.toString());
            proveObject.setRegisterMap(registerMap);
            proveObject.setPreCond(preCond);
            postCondition.add(desCond.toString());
            // 需要在这里提前预算目标寄存器的新值，即新范围
        } catch (InputMismatchException ex) {
            ex.printStackTrace();
        }
        return postCondition;
    }

    private BigInteger[] getElementRange(BigInteger[] des, BigInteger[] sourceRange) {
        BigInteger[] res = new BigInteger[2];
        if ("VMAXV".equals(instruction.getOpcode())) {
            res[1] = des[1].compareTo(sourceRange[1]) >= 0 ? des[1] : sourceRange[1];
            res[0] = des[0].compareTo(sourceRange[1]) >= 0 ? des[0] :
                    (des[0].compareTo(sourceRange[0]) >= 0 ? des[0] : sourceRange[0]);
        } else {
            res[0] = des[0].compareTo(sourceRange[0]) <= 0 ? des[0] : sourceRange[0];
            res[1] = des[1].compareTo(sourceRange[0]) <= 0 ? des[1] :
                    (des[1].compareTo(sourceRange[1]) <= 0 ? des[1] : sourceRange[1]);
        }
        return res;
    }

    /**
     * 源操作数存在通用寄存器
     * @return  后置条件
     */
    public List<String> vaddQRPostSet() {
        List<String> postCondition = new ArrayList<>();
        try {
            if (instruction == null || instruction.getDestinationRegister() == null)
                throw new RuntimeException("指令或目标寄存器为空");
            if (sourcePostCond == null || sourcePostCond.isEmpty())
                sourcePostCond = new ArrayList<>();
            if (instruction.getSourceRegister() == null || instruction.getSourceRegister().isEmpty())
                throw new InputMismatchException("源操作数为空");
            String datatype = instruction.getDatatype();
            int size = Integer.parseInt(datatype.substring(1));
            Map<String, String> registerMap = proveObject.getRegisterMap();
            Map<String, BigInteger[]> preCond = proveObject.getPreCond();
            String desRegister = instruction.getDestinationRegister();
            StringBuilder desCond = preSet();
            sourcePostCond.clear();

            String sourceRegister1 = instruction.getSourceRegister().get(0);
            String sourceRegister2 = instruction.getSourceRegister().get(1);
            String val = registerMap.get(sourceRegister2);
            desCond.append("\t\t\t\"").append(sourceRegister2).append("\" |-> ").append("mi(32, ")
                    .append(val).append(")\n");
            if (desRegister.equals(sourceRegister1)) {
                List<StringBuilder> sListTo = new ArrayList<>();
                int indexDes = Integer.parseInt(desRegister.substring(1)) * 4;
                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (indexDes+i);
                    StringBuilder sRegFrom = conca(sReg1, 32 / size, size, new StringBuilder());

                    StringBuilder sRegToLeft = new StringBuilder();
                    StringBuilder sRegToRight = new StringBuilder();
                    String[] vals1 = registerMap.get(sReg1.toString()).split(":");
                    if (size == 32) {
                        getVADDQRsRegToLeft(32, sRegToLeft, registerMap, sReg1, sourceRegister2, vals1);
                        String sub = "extractMInt(addMInt(mi(32, " + registerMap.get(sReg1) + "), mi(32, "
                                + registerMap.get(sourceRegister2) + ")), ";
                        sRegToRight.append("\t\t\t\t\tconcatenateMInt(").append(sub).append("0, 24), ")
                                .append("addMInt(extractMInt(mi(32, ").append(registerMap.get(sReg1))
                                .append("), 24, 32), extractMInt(mi(32, ").append(registerMap.get(sourceRegister2))
                                .append("), 24, 32)))\n");
                    } else {
                        getVADDQRsRegToLeft(size, sRegToLeft, registerMap, sReg1, sourceRegister2, vals1);
                        sRegToRight = sRegToLeft;
                    }
                    sListTo.add(sRegToRight);
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToRight).append("\t\t\t\telse undefMInt32)\n");

                    // 重设目标寄存器的值范围
                    BigInteger[] bigIntegers2 = preCond.get(registerMap.get(sourceRegister2));

                    for (String s : vals1) {
                        BigInteger[] bigIntegers1 = preCond.get(s);
                        //normalize(bigIntegers1, datatype, size);
                        //normalize(bigIntegers2, datatype, size);

                        preCond.put(s, new BigInteger[]{bigIntegers1[0].add(bigIntegers2[0]),
                                bigIntegers1[1].add(bigIntegers2[1])});
                    }
                }
                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = conca(desRegister, 128 / size, size, new StringBuilder());
                qRegFrom.append(" => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            } else {
                int index1 = Integer.parseInt(sourceRegister1.substring(1)) * 4;
                setSourcePostCond(size, index1, sourceRegister1);
                postCondition.addAll(sourcePostCond);
                // 设置S
                List<StringBuilder> sListTo = new ArrayList<>();
                int indexDes = Integer.parseInt(desRegister.substring(1)) * 4;
                // 若目标寄存器中无初始值，则在registerMap和preCondMap中设定一个初始值，相当于初始化
                // 命名规则为 vec + 当前向量寄存器的标识符 + '_' + set
                setVecDefaultPreCondAndRegisterMap(registerMap, preCond, desRegister, size, indexDes);

                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (index1+i);
                    StringBuilder sRegFrom = new StringBuilder().append("mi(32, _:Int)\n");

                    StringBuilder sRegToLeft = new StringBuilder();
                    StringBuilder sRegToRight = new StringBuilder();
                    String[] vals1 = registerMap.get(sReg1.toString()).split(":");
                    if (size == 32) {
                        getVADDQRsRegToLeft(32, sRegToLeft, registerMap, sReg1, sourceRegister2, vals1);
                        String sub = "extractMInt(addMInt(mi(32, " + registerMap.get(sReg1) + "), mi(32, "
                                + registerMap.get(sourceRegister2) + ")), ";
                        sRegToRight.append("\t\t\t\t\tconcatenateMInt(").append(sub).append("0, 24), ")
                                .append("addMInt(extractMInt(mi(32, ").append(registerMap.get(sReg1))
                                .append("), 24, 32), extractMInt(mi(32, ").append(registerMap.get(sourceRegister2))
                                .append("), 24, 32)))\n");
                    } else {
                        getVADDQRsRegToLeft(size, sRegToLeft, registerMap, sReg1, sourceRegister2, vals1);
                        sRegToRight = sRegToLeft;
                    }
                    sListTo.add(sRegToRight);
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToRight).append("\t\t\t\telse undefMInt32)\n");

                    // 重设目标寄存器的值范围
                    BigInteger[] bigIntegers2 = preCond.get(registerMap.get(sourceRegister2));
                    String[] valsDes = registerMap.get("S" + (indexDes+i)).split(":");

                    for (int j = 0; j < vals1.length; j++) {
                        BigInteger[] bigIntegers1 = preCond.get(vals1[j]);
                        //normalize(bigIntegers1, datatype, size);
                        //normalize(bigIntegers2, datatype, size);

                        preCond.put(valsDes[j], new BigInteger[]{bigIntegers1[0].add(bigIntegers2[0]),
                                bigIntegers1[1].add(bigIntegers2[1])});
                    }
                }

                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = new StringBuilder().append(" mi(128, _:Int) => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            }
            proveObject.setPreCond(preCond);
            proveObject.setRegisterMap(registerMap);
            postCondition.add(desCond.toString());
        } catch (RuntimeException e) {
            e.printStackTrace();
        }
        return postCondition;
    }

    /**
     * 源存在通用寄存器
     * @return
     */
    public List<String> vsubQRPostSet() {
        List<String> postCondition = new ArrayList<>();
        try {
            if (instruction == null || instruction.getDestinationRegister() == null)
                throw new RuntimeException("指令或目标寄存器为空");
            if (sourcePostCond == null || sourcePostCond.isEmpty())
                sourcePostCond = new ArrayList<>();
            if (instruction.getSourceRegister() == null || instruction.getSourceRegister().isEmpty())
                throw new InputMismatchException("源操作数为空");
            String datatype = instruction.getDatatype();
            int size = Integer.parseInt(datatype.substring(1));
            Map<String, String> registerMap = proveObject.getRegisterMap();
            Map<String, BigInteger[]> preCond = proveObject.getPreCond();
            String desRegister = instruction.getDestinationRegister();
            StringBuilder desCond = preSet();
            sourcePostCond.clear();

            String sourceRegister1 = instruction.getSourceRegister().get(0);
            String sourceRegister2 = instruction.getSourceRegister().get(1);
            String val = registerMap.get(sourceRegister2);
            desCond.append("\t\t\t\"").append(sourceRegister2).append("\" |-> ").append("mi(32, ")
                    .append(val).append(")\n");
            if (desRegister.equals(sourceRegister1)) {
                List<StringBuilder> sListTo = new ArrayList<>();
                int indexDes = Integer.parseInt(desRegister.substring(1)) * 4;
                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (indexDes+i);
                    StringBuilder sRegFrom = conca(sReg1, 32 / size, size, new StringBuilder());

                    StringBuilder sRegToLeft = new StringBuilder();
                    String[] vals1 = registerMap.get(sReg1.toString()).split(":");
                    getVSUBQRsRegToLeft(size, sRegToLeft, registerMap, sReg1, sourceRegister2, vals1);
                    sListTo.add(sRegToLeft);
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToLeft).append("\t\t\t\telse undefMInt32)\n");

                    // 重设目标寄存器的值范围
                    BigInteger[] bigIntegers2 = preCond.get(registerMap.get(sourceRegister2));

                    for (String s : vals1) {
                        BigInteger[] bigIntegers1 = preCond.get(s);
                        //normalize(bigIntegers1, datatype, size);
                        //normalize(bigIntegers2, datatype, size);

                        preCond.put(s, new BigInteger[]{bigIntegers1[0].subtract(bigIntegers2[1]),
                                bigIntegers1[1].subtract(bigIntegers2[0])});
                    }
                }
                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = conca(desRegister, 128 / size, size, new StringBuilder());
                qRegFrom.append(" => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            } else {
                int index1 = Integer.parseInt(sourceRegister1.substring(1)) * 4;
                setSourcePostCond(size, index1, sourceRegister1);
                postCondition.addAll(sourcePostCond);
                // 设置S
                List<StringBuilder> sListTo = new ArrayList<>();
                int indexDes = Integer.parseInt(desRegister.substring(1)) * 4;
                // 若目标寄存器中无初始值，则在registerMap和preCondMap中设定一个初始值，相当于初始化
                // 命名规则为 vec + 当前向量寄存器的标识符 + '_' + set
                setVecDefaultPreCondAndRegisterMap(registerMap, preCond, desRegister, size, indexDes);

                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (index1+i);
                    StringBuilder sRegFrom = new StringBuilder().append("mi(32, _:Int)\n");

                    StringBuilder sRegToLeft = new StringBuilder();
                    String[] vals1 = registerMap.get(sReg1.toString()).split(":");
                    getVSUBQRsRegToLeft(size, sRegToLeft, registerMap, sReg1, sourceRegister2, vals1);
                    sListTo.add(sRegToLeft);
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToLeft).append("\t\t\t\telse undefMInt32)\n");

                    // 重设目标寄存器的值范围
                    BigInteger[] bigIntegers2 = preCond.get(registerMap.get(sourceRegister2));
                    String[] valsDes = registerMap.get("S" + (indexDes+i)).split(":");

                    for (int j = 0; j < vals1.length; j++) {
                        BigInteger[] bigIntegers1 = preCond.get(vals1[j]);
                        //normalize(bigIntegers1, datatype, size);
                        //normalize(bigIntegers2, datatype, size);

                        preCond.put(valsDes[j], new BigInteger[]{bigIntegers1[0].subtract(bigIntegers2[1]),
                                bigIntegers1[1].subtract(bigIntegers2[0])});
                    }
                }

                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = new StringBuilder().append(" mi(128, _:Int) => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            }
            proveObject.setPreCond(preCond);
            proveObject.setRegisterMap(registerMap);
            postCondition.add(desCond.toString());
        } catch (RuntimeException e) {
            e.printStackTrace();
        }
        return postCondition;
    }

    /**
     * 源皆为向量寄存器
     * @return
     */
    public List<String> vsubQQPostSet() {
        List<String> postCondition = new ArrayList<>();
        try {
            if (instruction == null || instruction.getDestinationRegister() == null)
                throw new RuntimeException("指令或目标寄存器为空");
            if (sourcePostCond == null || sourcePostCond.isEmpty())
                sourcePostCond = new ArrayList<>();
            if (instruction.getSourceRegister() == null || instruction.getSourceRegister().isEmpty())
                throw new InputMismatchException("源操作数为空");
            String datatype = instruction.getDatatype();
            int size = Integer.parseInt(datatype.substring(1));
            Map<String, String> registerMap = proveObject.getRegisterMap();
            Map<String, BigInteger[]> preCond = proveObject.getPreCond();
            String desRegister = instruction.getDestinationRegister();
            StringBuilder desCond = preSet();
            sourcePostCond.clear();

            String sourceRegister1 = instruction.getSourceRegister().get(0);
            String sourceRegister2 = instruction.getSourceRegister().get(1);
            int indexDes = Integer.parseInt(desRegister.substring(1)) * 4;
            // 第一个源操作数同时为目标操作数
            if (desRegister.equals(sourceRegister1)) {
                int index = Integer.parseInt(sourceRegister2.substring(1)) * 4;
                // 源操作数初始
                setSourcePostCond(size, index, sourceRegister2);
                postCondition.addAll(sourcePostCond);
                sourcePostCond.clear();
                List<StringBuilder> sListTo = new ArrayList<>();
                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (indexDes+i);
                    String sReg2 = "S" + (index+i);
                    StringBuilder sRegFrom = conca(sReg1, 32 / size, size, new StringBuilder());

                    StringBuilder sRegToLeft = new StringBuilder();
                    String[] vals1 = registerMap.get(sReg1.toString()).split(":");
                    String[] vals2 = registerMap.get(sReg2.toString()).split(":");
                    getVSUBQQsRegToLeft(size, sRegToLeft, registerMap, sReg1, sReg2, vals1, vals2);
                    sListTo.add(sRegToLeft);
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToLeft).append("\t\t\t\telse undefMInt32)\n");


                    for (int j = 0; j < vals1.length; j++) {
                        BigInteger[] bigIntegers1 = preCond.get(vals1[j]);
                        BigInteger[] bigIntegers2 = preCond.get(vals2[j]);
                        //normalize(bigIntegers1, datatype, size);
                        //normalize(bigIntegers2, datatype, size);

                        preCond.put(vals1[j], new BigInteger[]{bigIntegers1[0].subtract(bigIntegers2[1]),
                                bigIntegers1[1].subtract(bigIntegers2[0])});
                    }
                }
                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = conca(desRegister, 128 / size, size, new StringBuilder());
                qRegFrom.append(" => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            } else if (desRegister.equals(sourceRegister2)) {   // 第二个源操作数同时为目标操作数
                int index = Integer.parseInt(sourceRegister1.substring(1)) * 4;
                // 源操作数初始
                setSourcePostCond(size, index, sourceRegister1);
                postCondition.addAll(sourcePostCond);
                sourcePostCond.clear();
                List<StringBuilder> sListTo = new ArrayList<>();
                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (index+i);
                    String sReg2 = "S" + (indexDes+i);
                    StringBuilder sRegFrom = conca(sReg2, 32 / size, size, new StringBuilder());

                    StringBuilder sRegToLeft = new StringBuilder();
                    String[] vals1 = registerMap.get(sReg1.toString()).split(":");
                    String[] vals2 = registerMap.get(sReg2.toString()).split(":");
                    getVSUBQQsRegToLeft(size, sRegToLeft, registerMap, sReg1, sReg2, vals1, vals2);
                    sListTo.add(sRegToLeft);
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToLeft).append("\t\t\t\telse undefMInt32)\n");


                    for (int j = 0; j < vals1.length; j++) {
                        BigInteger[] bigIntegers1 = preCond.get(vals1[j]);
                        BigInteger[] bigIntegers2 = preCond.get(vals2[j]);
                        //normalize(bigIntegers1, datatype, size);
                        //normalize(bigIntegers2, datatype, size);

                        preCond.put(vals2[j], new BigInteger[]{bigIntegers1[0].subtract(bigIntegers2[1]),
                                bigIntegers1[1].subtract(bigIntegers2[0])});
                    }
                }
                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = conca(desRegister, 128 / size, size, new StringBuilder());
                qRegFrom.append(" => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            } else {
                int index1 = Integer.parseInt(sourceRegister1.substring(1)) * 4;
                int index2 = Integer.parseInt(sourceRegister2.substring(1)) * 4;
                setSourcePostCond(size, index1, sourceRegister1);
                postCondition.addAll(sourcePostCond);
                sourcePostCond.clear();
                setSourcePostCond(size, index2, sourceRegister2);
                postCondition.addAll(sourcePostCond);
                sourcePostCond.clear();
                // 设置S
                List<StringBuilder> sListTo = new ArrayList<>();
                // 若目标寄存器中无初始值，则在registerMap和preCondMap中设定一个初始值，相当于初始化
                // 命名规则为 vec + 当前向量寄存器的标识符 + '_' + set
                setVecDefaultPreCondAndRegisterMap(registerMap, preCond, desRegister, size, indexDes);

                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (index1+i);
                    String sReg2 = "S" + (index2+i);
                    StringBuilder sRegFrom = new StringBuilder().append("mi(32, _:Int)\n");

                    StringBuilder sRegToLeft = new StringBuilder();
                    String[] vals1 = registerMap.get(sReg1.toString()).split(":");
                    String[] vals2 = registerMap.get(sReg2.toString()).split(":");
                    getVSUBQQsRegToLeft(size, sRegToLeft, registerMap, sReg1, sReg2, vals1, vals2);
                    sListTo.add(sRegToLeft);
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToLeft).append("\t\t\t\telse undefMInt32)\n");

                    // 重设目标寄存器的值范围
                    String[] valsDes = registerMap.get("S" + (indexDes+i)).split(":");

                    for (int j = 0; j < vals1.length; j++) {
                        BigInteger[] bigIntegers1 = preCond.get(vals1[j]);
                        BigInteger[] bigIntegers2 = preCond.get(vals2[j]);
                        //normalize(bigIntegers1, datatype, size);
                        //normalize(bigIntegers2, datatype, size);

                        preCond.put(valsDes[j], new BigInteger[]{bigIntegers1[0].subtract(bigIntegers2[1]),
                                bigIntegers1[1].subtract(bigIntegers2[0])});
                    }
                }

                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = new StringBuilder().append(" mi(128, _:Int) => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            }
            proveObject.setPreCond(preCond);
            proveObject.setRegisterMap(registerMap);
            postCondition.add(desCond.toString());
        } catch (RuntimeException e) {
            e.printStackTrace();
        }
        return postCondition;
    }

    /**
     * 用于处理操作数都是向量寄存器的指令，once
     * @return
     */
    public List<String> allVecPostSet() {
        // 初始寄存器
        // 源向量寄存器
        // 判断目标向量寄存器是否和某一源寄存器为同一个寄存器（VMAX、VMIN），若相等则设置左式 => 右式；不相等则 _ => 右式
        // 设置临时寄存器
        List<String> postCondition = new ArrayList<>();
        try {
            if (instruction == null || instruction.getDestinationRegister() == null)
                throw new RuntimeException("指令或目标寄存器为空");
            if (sourcePostCond == null || sourcePostCond.isEmpty()) {
                sourcePostCond = new ArrayList<>();
            }
            if (instruction.getSourceRegister() == null || instruction.getSourceRegister().isEmpty())
                throw new InputMismatchException("源操作数为空");
            String datatype = instruction.getDatatype();
            int size = Integer.parseInt(datatype.substring(1));
            Map<String, String> registerMap = proveObject.getRegisterMap();
            String desRegister = instruction.getDestinationRegister();
            StringBuilder desCond = preSet();
            Map<String, BigInteger[]> preCond = proveObject.getPreCond();
            sourcePostCond.clear();

            // VMAX、VMIN需要判断目标寄存器是否为某一个源寄存器，若是，则需要 原 => 后
            if ("VMAX".equals(instruction.getOpcode()) || "VMIN".equals(instruction.getOpcode())) {
                int equalFlag = 0;
                String sourceRegister1 = instruction.getSourceRegister().get(0);
                String sourceRegister2 = instruction.getSourceRegister().get(1);
                if (desRegister.equals(sourceRegister1)) {
                    equalFlag = 1;
                } else if (desRegister.equals(sourceRegister2)) {
                    equalFlag = 2;
                }
                // 目标寄存器为某一源寄存器
                if (equalFlag > 0) {
                    String sourceRegister = equalFlag == 1 ? sourceRegister2 : sourceRegister1;
                    int index = Integer.parseInt(sourceRegister.substring(1)) * 4;
                    setSourcePostCond(size, index, sourceRegister);
                    // 设置目标寄存器
                    // 设置S
                    postCondition.addAll(sourcePostCond);
                    List<StringBuilder> sListTo = new ArrayList<>();
                    int indexDes = Integer.parseInt(desRegister.substring(1)) * 4;
                    for (int i = 0; i < 4; i++) {
                        StringBuilder sRegFrom = conca("S" + (indexDes+i), 32 / size, size, new StringBuilder());
                        StringBuilder sReg1 = new StringBuilder();
                        StringBuilder sReg2 = new StringBuilder();
                        if (equalFlag == 2) {
                            sReg1.append('S').append((index+i));
                            sReg2.append('S').append((indexDes+i));
                        } else {
                            sReg1.append('S').append((indexDes+i));
                            sReg2.append('S').append((index+i));
                        }
                        StringBuilder sRegTo = getDesByCompElement(sReg1.toString(), sReg2.toString(), size,
                                "VMAX".equals(instruction.getOpcode()) ? "<=Int" : ">=Int", datatype);
                        sListTo.add(sRegTo);
                        desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                                .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegTo)
                                .append("\t\t\t\t) then ").append(sRegTo).append("\t\t\t\telse undefMInt32)\n");

                        // 重设目标寄存器的值范围
                        String[] vals1 = registerMap.get(sReg1.toString()).split(":");
                        String[] vals2 = registerMap.get(sReg2.toString()).split(":");
                        for (int j = 0; j < vals1.length; j++) {
                            BigInteger[] bigIntegers1 = preCond.get(vals1[j]);
                            BigInteger[] bigIntegers2 = preCond.get(vals2[j]);
                            normalize(bigIntegers1, datatype, size);
                            normalize(bigIntegers2, datatype, size);
                            BigInteger[] elementRange = getElementRange(bigIntegers1, bigIntegers2);
                            preCond.put(equalFlag == 2 ? vals2[j] : vals1[j], elementRange);
                        }
                    }
                    // 设置临时变量
                    desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                    // 设置Q
                    StringBuilder qRegFrom = conca(desRegister, 128 / size, size, new StringBuilder());
                    qRegFrom.append(" => ");
                    for (int i = 3; i >= 0; i--) {
                        if (i > 0)
                            qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                        else
                            qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                    }
                    desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);

                } else {
                    int index1 = Integer.parseInt(sourceRegister1.substring(1)) * 4;
                    setSourcePostCond(size, index1, sourceRegister1);
                    postCondition.addAll(sourcePostCond);
                    sourcePostCond.clear();
                    int index2 = Integer.parseInt(sourceRegister2.substring(1)) * 4;
                    setSourcePostCond(size, index2, sourceRegister2);
                    postCondition.addAll(sourcePostCond);
                    // 设置S
                    List<StringBuilder> sListTo = new ArrayList<>();
                    int indexDes = Integer.parseInt(desRegister.substring(1)) * 4;
                    // 若目标寄存器中无初始值，则在registerMap和preCondMap中设定一个初始值，相当于初始化
                    // 命名规则为 vec + 当前向量寄存器的标识符 + '_' + set
                    if (!registerMap.containsKey(desRegister)) {
                        String val = "V" + desRegister + "_set";
                        registerMap.put(desRegister, val);
                        preCond.put(val, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                        val = size == 32 ? val : (size == 16 ? val + "0" : val + "00");
                        for (int i = 0; i < 4; i++) {
                            if (size == 8) {
                                String tmp1 = val + (i * 4);
                                String tmp2 = val + (i * 4 + 1);
                                String tmp3 = val + (i * 4 + 2);
                                String tmp4 = val + (i * 4 + 3);
                                registerMap.put("S" + (indexDes + i), tmp4 + ":" + tmp3 + ":" + tmp2 + ":" + tmp1);
                                preCond.put(tmp1, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                                preCond.put(tmp2, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                                preCond.put(tmp3, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                                preCond.put(tmp4, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                            } else if (size == 16) {
                                String tmp1 = val + (i * 2);
                                String tmp2 = val + (i * 2 + 1);
                                registerMap.put("S" + (indexDes + i), tmp2 + ":" + tmp1);
                                preCond.put(tmp1, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                                preCond.put(tmp2, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                            } else if (size == 32) {
                                String tmp = val + i;
                                registerMap.put("S" + (indexDes + i), tmp);
                                preCond.put(tmp, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                            }
                        }
                    } else {
                        int len = registerMap.get("S" + indexDes).split(":").length;
                        if (len != 32 / size) {
                            String val = registerMap.get(desRegister);
                            for (int i = 0; i < 4; i++) {
                                if (size == 8) {
                                    String tmp1 = val + (i * 4);
                                    String tmp2 = val + (i * 4 + 1);
                                    String tmp3 = val + (i * 4 + 2);
                                    String tmp4 = val + (i * 4 + 3);
                                    registerMap.put("S" + (indexDes + i), tmp4 + ":" + tmp3 + ":" + tmp2 + ":" + tmp1);
                                    preCond.put(tmp1, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                                    preCond.put(tmp2, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                                    preCond.put(tmp3, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                                    preCond.put(tmp4, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                                } else if (size == 16) {
                                    String tmp1 = val + (i * 2);
                                    String tmp2 = val + (i * 2 + 1);
                                    registerMap.put("S" + (indexDes + i), tmp2 + ":" + tmp1);
                                    preCond.put(tmp1, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                                    preCond.put(tmp2, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                                } else if (size == 32) {
                                    String tmp = val + i;
                                    registerMap.put("S" + (indexDes + i), tmp);
                                    preCond.put(tmp, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                                }
                            }
                        }
                    }

                    for (int i = 0; i < 4; i++) {
                        StringBuilder sRegFrom = new StringBuilder().append("mi(32, _:Int)\n");
                        StringBuilder sReg1 = new StringBuilder();
                        StringBuilder sReg2 = new StringBuilder();
                        sReg1.append('S').append((index1+i));
                        sReg2.append('S').append((index2+i));
                        StringBuilder sRegTo = getDesByCompElement(sReg1.toString(), sReg2.toString(), size,
                                "VMAX".equals(instruction.getOpcode()) ? "<=Int" : ">=Int", datatype);
                        sListTo.add(sRegTo);
                        desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                                .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegTo)
                                .append("\t\t\t\t) then ").append(sRegTo).append("\t\t\t\telse undefMInt32)\n");

                        // 重设目标寄存器的值范围
                        String[] vals1 = registerMap.get(sReg1.toString()).split(":");
                        String[] vals2 = registerMap.get(sReg2.toString()).split(":");
                        String[] valDes = registerMap.get("S" + (indexDes+i)).split(":");

                        for (int j = 0; j < vals1.length; j++) {
                            BigInteger[] bigIntegers1 = preCond.get(vals1[j]);
                            BigInteger[] bigIntegers2 = preCond.get(vals2[j]);
                            normalize(bigIntegers1, datatype, size);
                            normalize(bigIntegers2, datatype, size);
                            BigInteger[] elementRange = getElementRange(bigIntegers1, bigIntegers2);
                            preCond.put(valDes[j], elementRange);
                        }
                    }
                    // 设置临时变量
                    desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                    // 设置Q
                    StringBuilder qRegFrom = new StringBuilder().append(" mi(128, _:Int) => ");
                    for (int i = 3; i >= 0; i--) {
                        if (i > 0)
                            qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                        else
                            qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                    }
                    desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
                }
            } else if ("VMAXA".equals(instruction.getOpcode()) || "VMINA".equals(instruction.getOpcode())) {
                String sourceRegister = instruction.getSourceRegister().get(0);
                int index = Integer.parseInt(sourceRegister.substring(1)) * 4;
                setSourcePostCond(size, index, sourceRegister);
                // 设置目标寄存器
                // 设置S
                postCondition.addAll(sourcePostCond);
                List<StringBuilder> sListTo = new ArrayList<>();
                int indexDes = Integer.parseInt(desRegister.substring(1)) * 4;
                for (int i = 0; i < 4; i++) {
                    StringBuilder sRegFrom = conca("S" + (indexDes+i), 32 / size, size, new StringBuilder());
                    StringBuilder sReg1 = new StringBuilder();
                    StringBuilder sReg2 = new StringBuilder();
                    sReg1.append('S').append((index+i));
                    sReg2.append('S').append((indexDes+i));
                    StringBuilder sRegTo = getToDesAbsConca(sReg2.toString(), sReg1.toString(), size,
                            "VMAXA".equals(instruction.getOpcode()) ? "<=Int" : ">=Int");
                    sListTo.add(sRegTo);
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegTo)
                            .append("\t\t\t\t) then ").append(sRegTo).append("\t\t\t\telse undefMInt32)\n");

                    // 重设目标寄存器的值范围
                    String[] vals1 = registerMap.get(sReg1.toString()).split(":");
                    String[] vals2 = registerMap.get(sReg2.toString()).split(":");
                    for (int j = 0; j < vals1.length; j++) {
                        BigInteger[] bigIntegers1 = preCond.get(vals1[j]);
                        BigInteger[] bigIntegers2 = preCond.get(vals2[j]);
                        normalize(bigIntegers1, datatype, size);
                        normalize(bigIntegers2, datatype, size);
                        BigInteger[] elementRange = getAbsDesRange(bigIntegers1, bigIntegers2[0], bigIntegers2[1]);
                        preCond.put(vals2[j], elementRange);
                    }
                }
                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = conca(desRegister, 128 / size, size, new StringBuilder());
                qRegFrom.append(" => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            }
            proveObject.setPreCond(preCond);
            proveObject.setRegisterMap(registerMap);
            postCondition.add(desCond.toString());
        } catch (InputMismatchException ex) {
            ex.printStackTrace();
        }
        return postCondition;
    }

    private StringBuilder preSet() {
        StringBuilder pre = new StringBuilder();
        pre.append("\t\t\t\"CONTROL\" |-> (mi(32, _:Int) => mi(32, 1))\n\t\t\t\"CONTROL_NS\" |-> (mi(32, _:Int) => mi(32, 1))\n ")
                .append("\t\t\t\"CONTROL_S\" |-> (mi(32, _:Int) => mi(32, 1))\n")
                .append("\t\t\t\"CPACR\" |-> (mi(32, _:Int) => mi(32, 3145728))\n")
                .append("\t\t\t\"CPACR_NS\" |-> (mi(32, _:Int) => mi(32, 3145728))\n")
                .append("\t\t\t\"CPACR_S\" |-> (mi(32, _:Int) => mi(32, 3145728))\n")
                .append("\t\t\t\"CPPWR\" |-> (mi(32, _:Int) => mi(32, 0))\n")
                .append("\t\t\t\"CPPWR_NS\" |-> (mi(32, _:Int) => mi(32, 0))\n")
                .append("\t\t\t\"CPPWR_S\" |-> (mi(32, _:Int) => mi(32, 0))\n")
                .append("\t\t\t\"EPSR\" |-> (mi(32, _:Int) => mi(32, 2048))\n")
                .append("\t\t\t\"FPCCR\" |-> (mi(32, _:Int) => mi(32, 0))\n")
                .append("\t\t\t\"FPCCR_NS\" |-> (mi(32, _:Int) => mi(32, 0))\n")
                .append("\t\t\t\"FPCCR_S\" |-> (mi(32, _:Int) => mi(32, 0))\n")
                .append("\t\t\t\"MVFR1\" |-> (mi(32, _:Int) => mi(32, 256))\n")
                .append("\t\t\t\"NSACR\" |-> (mi(32, _:Int) => mi(32, 1024))\n")
                .append("\t\t\t\"VPR\" |-> (mi(32, _:Int) => mi(32, 2048))\n")
                .append("\t\t\t\"RESULT64\" |-> mi(64, 0)\n");
        return pre;
    }

    /**
     * 获取绝对值时，两个元素对比的后置条件
     * @param sReg1 源操作数元素1
     * @param sReg2 源操作数元素2
     * @param width 位宽
     * @param cmpMode   比较最大还是最小
     * @return  后置条件
     */
    private StringBuilder getToDesAbsConca(String sReg1, String sReg2, int width, String cmpMode) {
        StringBuilder res = new StringBuilder();
        String[] vals1 = proveObject.getRegisterMap().get(sReg1).split(":");
        String[] vals2 = proveObject.getRegisterMap().get(sReg2).split(":");
        for (int i = 0; i < vals1.length; i++) {
            if (i < vals1.length - 1) {
                res.append("concatenateMInt(ifMInt (").append("absInt(").append(vals2[i]).append(") ").append(cmpMode)
                        .append(" uvalueMInt(mi(").append(width).append(", ").append(vals1[i])
                        .append("))) then (mi(").append(width).append(", ").append(vals1[i]).append(")) else mi(")
                        .append(width).append(", absInt(").append(vals2[i]).append(")) ,");
            } else {
                res.append(" ifMInt (").append("absInt(").append(vals2[i]).append(") ").append(cmpMode)
                        .append(" uvalueMInt(mi(").append(width).append(", ").append(vals1[i])
                        .append("))) then (mi(").append(width).append(", ").append(vals1[i]).append(")) else mi(")
                        .append(width).append(", absInt(").append(vals2[i]).append("))");
            }
        }
        for (int i = 1; i < vals1.length; i++) {
            res.append(')');
        }
        res.append('\n');
        return res;
    }

    /**
     * 获取浮点寄存器 S 中，每对元素的比较情况，对应后置条件
     * @param sReg1 对应第一个源操作数的浮点寄存器
     * @param sReg2 对应第二个源操作数的浮点寄存器
     * @param width 每个元素的位宽
     * @param cmpMode   比较模式，取最大还是取最小
     * @return  返回 S 对应的后置条件
     */
    private StringBuilder getDesByCompElement(String sReg1, String sReg2, int width, String cmpMode, String datatype) {
        StringBuilder res = new StringBuilder();
        String[] vals1 = proveObject.getRegisterMap().get(sReg1).split(":");
        String[] vals2 = proveObject.getRegisterMap().get(sReg2).split(":");
        String signMode = datatype.charAt(0) == 'S' ? "svalueMInt" : "uvalueMInt";
        for (int i = 0; i < vals1.length; i++) {
            if (i < vals1.length - 1) {
                res.append("concatenateMInt(ifMInt (")
                        .append(signMode).append("(mi(").append(width).append(", ").append(vals2[i]).append(")) ")
                        .append(cmpMode).append(" ")
                        .append(signMode).append("(mi(").append(width).append(", ").append(vals1[i]).append(")) ")
                        .append(") then (mi(").append(width).append(", ").append(vals1[i]).append(")) else mi(")
                        .append(width).append(", ").append(vals2[i]).append(") ,");
            } else {
                res.append(" ifMInt (")
                        .append(signMode).append("(mi(").append(width).append(", ").append(vals2[i]).append(")) ")
                        .append(cmpMode).append(" ")
                        .append(signMode).append("(mi(").append(width).append(", ").append(vals1[i]).append(")) ")
                        .append(") then mi(")
                        .append(width).append(", ").append(vals1[i]).append(") else mi(").append(width).append(", ")
                        .append(vals2[i]).append(")");
            }
        }
        for (int i = 1; i < vals1.length; i++) {
            res.append(')');
        }
        res.append('\n');
        return res;
    }


    /**
     * 将源寄存器在regstate的映射关系设置好
     * @param reg       当前寄存器，可以是向量寄存器或浮点寄存器
     * @param size      寄存器中有多少元素
     * @param width     每个元素的宽度
     * @return
     */
    private String concaMInt(String reg, int size, int width) {
        StringBuilder concaVal = new StringBuilder();
        // int index = Integer.parseInt(reg.substring(1));
        concaVal.append("\t\t\t\"").append(reg).append('\"').append(" |-> ");
        concaVal = conca(reg, size, width, concaVal);
        concaVal.append('\n');
        return concaVal.toString();
    }

    /**
     * conca实现用cancatenateMInt拼接
     * @param reg
     * @param size
     * @param width
     * @param concaVal
     * @return
     */
    private StringBuilder conca(String reg, int size, int width, StringBuilder concaVal) {
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
        } else if (reg.charAt(0) == 'S') {
            if (width == 32) {
                concaVal.append("mi(32, ").append(proveObject.getRegisterMap().get(reg)).append(")");
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
            }
        }
        return concaVal;
    }

    /**
     * 设置源向量操作数的后置条件
     * @param size
     * @param index
     * @param sourceReg
     */
    private void setSourcePostCond(int size, int index, String sourceReg) {
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

    /**
     * VMLAV 处理regstate内容，构建源寄存器和目标寄存器的信息
     * 由于指令内部涉及内积操作，因此需要对乘法和加法的结果进行相应的范围处理获取结果的值范围。
     * @return
     */
    public List<String> innerProductPostSet() {
        List<String> postCondition = new ArrayList<>();
        try {
            checkException();
            if (instruction.getSourceRegister() == null || instruction.getSourceRegister().size() != 2)
                throw new RuntimeException();
            if (sourcePostCond == null || sourcePostCond.isEmpty()) {
                sourcePostCond = new ArrayList<>();
            }
            String datatype = instruction.getDatatype();
            int size = Integer.parseInt(datatype.substring(1));
            Map<String, String> registerMap = proveObject.getRegisterMap();
            // 设定源寄存器的值，如向量寄存器、对应的浮点寄存器，需要通过size进行判断
            // 第一个beat时记录源寄存器的映射关系，后续无须重复
            if (beat == 0) {
                for (String sourceReg : instruction.getSourceRegister()) {
                    String indexStr = sourceReg.substring(1);
                    int index = Integer.parseInt(indexStr) * 4;
                    setSourcePostCond(size, index, sourceReg);
                }
            }
            postCondition.addAll(sourcePostCond);
            // 设定目标寄存器的值，需要根据beat判断当前比较的对象是哪个元素
            StringBuilder desCond = new StringBuilder();
            String destinationRegister = instruction.getDestinationRegister();
            String val = registerMap.get(destinationRegister);
            if (beat == 0)
                oldVal = val;   // 暂存通用寄存器最初的值，用于构建其元素值
            desCond.append("\t\t\t\"").append(destinationRegister).append("\" |-> ").append("(mi(32, ")
                    .append(val).append(") => ");
            StringBuilder sRegVal0 = new StringBuilder(), sRegVal1 = new StringBuilder();
            Map<String, BigInteger[]> preCond = proveObject.getPreCond();
            BigInteger[] desRange = preCond.get(val);
            //String lower = desRange[0].toString(2);
            //String higher = desRange[1].toString(2);
            BigInteger desLower = desRange[0], desHigher = desRange[1];
            if (datatype.charAt(0) == 'S') {
                /*
                desLower = new BigInteger(Binary2Signed.AddBinToDec(Binary2Signed.signExtend(lower, 32).substring(32-size),
                        true));
                desHigher = new BigInteger(Binary2Signed.AddBinToDec(Binary2Signed.signExtend(higher, 32).substring(32-size),
                        true));
                 */
                // 所以当在带符号的数据类型中出现范围上界超越32位的二进制串能表示的带符号数范围时（带符号数是上界）
                // 直接取当前二进制串能表示的范围
                if (desHigher.compareTo(BigInteger.valueOf((1L << 31) - 1)) > 0) {
                    desLower = BigInteger.valueOf(-(1L<<31));
                    desHigher = BigInteger.valueOf((1L<<31)-1L);
                }
            } else {
                /*desLower = new BigInteger(Binary2Signed.ORGBinToDec(Binary2Signed.signExtend(lower, 32).substring(32-size),
                        false));
                desHigher = new BigInteger(Binary2Signed.ORGBinToDec(Binary2Signed.signExtend(higher, 32).substring(32-size),
                        false));*/
                // 同理，当在无符号数的数据类型中出现范围下界小于0的时候
                // 直接取当前二进制串能表示的范围
                if (desLower.compareTo(BigInteger.ZERO) < 0) {
                    desLower = BigInteger.ZERO;
                    desHigher = BigInteger.valueOf((1L<<32)-1);
                }
            }
            // 内积处理范围
            if (size == 32) {
                String sourceVal0 = registerMap.get(instruction.getSourceRegister().get(0));
                String sourceVal1 = registerMap.get(instruction.getSourceRegister().get(1));
                sRegVal0.append(sourceVal0).append(beat);
                sRegVal1.append(sourceVal1).append(beat);
                StringBuilder formula = new StringBuilder();
                formula.append(val).append(" +Int ").append(sRegVal0).append(" *Int ").append(sRegVal1);
                // TODO：这里后续需要加入postcondition作为条件判断语句
                desCond.append("ifMInt ((").append(formula).append(" >=Int ")
                        .append(datatype.charAt(0) == 'S' ? "-2 ^Int 31" : "0").append(") andBool (")
                        .append(formula).append(" <=Int ").append(datatype.charAt(0) == 'S' ? "2 ^Int 31 -Int 1" : "2 ^Int 32 -Int 1")
                        .append(")) then (").append("extractMInt(mi(64, ").append(formula).append("), 32, 64)) else (undefMInt32))\n");
                BigInteger[] sourceRange0 = preCond.get(sRegVal0.toString());
                BigInteger[] sourceRange1 = preCond.get(sRegVal1.toString());
                // 还是需要再处理一下，由于前面的指令可能存在改变寄存器值的指令，因此值的范围有可能会与初始设定不一样，因此可能会出现无符号下溢或带符号上溢的情况
                normalize(sourceRange0, datatype, size);
                normalize(sourceRange1, datatype, size);
                // 分情况讨论，当为带符号数时
                BigInteger[] range = getMULRange(sourceRange0, sourceRange1, datatype);
                desLower = desLower.add(range[0]);
                desHigher = desHigher.add(range[1]);
            } else if (size == 16 || size == 8) {
                int index = beat * 32 / size;
                String sourceVal0 = registerMap.get(instruction.getSourceRegister().get(0));
                String sourceVal1 = registerMap.get(instruction.getSourceRegister().get(1));
                sRegVal0.append(sourceVal0).append(size == 16 ? '0' : "00");
                sRegVal1.append(sourceVal1).append(size == 16 ? '0' : "00");
                StringBuilder formula = new StringBuilder();
                BigInteger freshB = BigInteger.ZERO, freshH = BigInteger.ZERO;
                for (int i = 0; i < 32 / size; i++) {
                    formula.append(sRegVal0).append(index + i).append(" *Int ").append(sRegVal1).append(index + i)
                           .append(" +Int ");
                    BigInteger[] sourceRange0 = preCond.get(sRegVal0.toString() + (index+i));
                    BigInteger[] sourceRange1 = preCond.get(sRegVal1.toString() + (index+i));
                    // 同上
                    normalize(sourceRange0, datatype, size);
                    normalize(sourceRange1, datatype, size);
                    BigInteger[] range = getMULRange(sourceRange0, sourceRange1, datatype);
                    freshB = freshB.add(range[0]);
                    freshH = freshH.add(range[1]);
                }
                formula.append(val);
                desCond.append("ifMInt ((").append(formula).append(" >=Int ")
                        .append(datatype.charAt(0) == 'S' ? "-2 ^Int 31" : "0").append(") andBool (")
                        .append(formula).append(" <=Int ").append(datatype.charAt(0) == 'S' ? "2 ^Int 31 -Int 1" : "2 ^Int 32 -Int 1")
                        .append(")) then (").append("extractMInt(mi(64, ").append(formula).append("), 32, 64)) else (undefMInt32))\n");
                desLower = desLower.add(freshB);
                desHigher = desHigher.add(freshH);
            } else {
                throw new InputMismatchException("数据类型非法，请检查");
            }
            StringBuilder newVal = new StringBuilder();
            newVal.append(preTmp).append(oldVal).append(beat);
            preCond.put(newVal.toString(), new BigInteger[] {desLower, desHigher});
            registerMap.put(destinationRegister, newVal.toString());
            proveObject.setRegisterMap(registerMap);
            proveObject.setPreCond(preCond);
            postCondition.add(desCond.toString());
        } catch (RuntimeException ex) {
            ex.printStackTrace();
        }
        return postCondition;
    }

    /**
     * 将无符号运算时，值范围出现小于0的情况 以及 带符号运算时，值范围出现大于带符号能表示的范围的情况进行处理
     * @param range
     * @param datatype
     * @param size
     */
    private void normalize(BigInteger[] range, String datatype, int size) {
        if (datatype.charAt(0) == 'S') {
            if (range[1].compareTo(BigInteger.valueOf((1L << (size - 1)) - 1)) > 0) {
                range[0] = BigInteger.valueOf(-(1L<<(size-1)));
                range[1] = BigInteger.valueOf((1L<<(size-1))-1);
            }
        } else {
            if (range[0].compareTo(BigInteger.ZERO) < 0) {
                range[0] = BigInteger.ZERO;
                range[1] = BigInteger.valueOf((1L<<size)-1);
            }
        }
    }

    /**
     * 获取内积操作时，元素乘法运算的结果的范围
     * @param sourceRange0
     * @param sourceRange1
     * @param datatype
     * @return
     */
    private BigInteger[] getMULRange(BigInteger[] sourceRange0, BigInteger[] sourceRange1, String datatype) {
        BigInteger freshH, freshB;
        if (datatype.charAt(0) == 'S') {
            // 上界都为负数
            if (sourceRange0[1].compareTo(BigInteger.ZERO) < 0 && sourceRange1[1].compareTo(BigInteger.ZERO) < 0) {
                freshB = sourceRange0[1].multiply(sourceRange1[1]);
                freshH = sourceRange0[0].multiply(sourceRange1[0]);
            } else if (sourceRange0[0].compareTo(BigInteger.ZERO) < 0 && sourceRange1[0].compareTo(BigInteger.ZERO) < 0) {
                // 下界都为负数，上界不都为负数
                freshH = sourceRange0[0].multiply(sourceRange1[0]).compareTo(sourceRange0[1].multiply(sourceRange1[1])) > 0 ?
                        sourceRange0[0].multiply(sourceRange1[0]) : sourceRange0[1].multiply(sourceRange1[1]);
                freshB = sourceRange0[0].multiply(sourceRange1[1]).compareTo(sourceRange1[0].multiply(sourceRange0[1])) < 0 ?
                        sourceRange0[0].multiply(sourceRange1[1]) : sourceRange1[0].multiply(sourceRange0[1]);
            } else if (sourceRange0[0].compareTo(BigInteger.ZERO) < 0) {
                //只有一个下界为负
                freshH = sourceRange0[1].multiply(sourceRange1[1]);
                freshB = sourceRange0[0].multiply(sourceRange1[1]);
            } else if (sourceRange1[0].compareTo(BigInteger.ZERO) < 0) {
                // 只有一个下界为负
                freshH = sourceRange0[1].multiply(sourceRange1[1]);
                freshB = sourceRange1[0].multiply(sourceRange0[1]);
            } else {
                // 下界都不为负数
                freshB = sourceRange0[0].multiply(sourceRange1[0]);
                freshH = sourceRange0[1].multiply(sourceRange1[1]);
            }
        } else {
            // 无符号数处理
            freshB = sourceRange0[0].multiply(sourceRange1[0]);
            freshH = sourceRange0[1].multiply(sourceRange1[1]);
        }
        return new BigInteger[]{freshB, freshH};
    }

    /**
     * undo
     * for FP, get the max/min element of a vector register.
     * Vector and General Register.
     * @return
     */
    public List<String> fpVecGenRegPostSet() {
        List<String> postCondition = new ArrayList<>();
        try {
            checkException();
            // prepare for the source register
            if (instruction.getSourceRegister() == null || instruction.getSourceRegister().isEmpty())
                throw new RuntimeException();
            if (sourcePostCond == null || sourcePostCond.isEmpty()) {
                sourcePostCond = new ArrayList<>();
            }
            String datatype = instruction.getDatatype();
            String sourceReg = instruction.getSourceRegister().get(0);
            int size = Integer.parseInt(datatype.substring(1));
            Map<String, String> registerMap = proveObject.getRegisterMap();
            // 设定源寄存器的值，如向量寄存器、对应的浮点寄存器，需要通过size进行判断
            // 第一个beat时记录源寄存器的映射关系，后续无须重复
            if (beat == 0) {
                String indexStr = sourceReg.substring(1);
                int index = Integer.parseInt(indexStr) * 4;
                setSourcePostCond(size, index, sourceReg);
            }
            postCondition.addAll(sourcePostCond);
            StringBuilder desCond = new StringBuilder();
            String destinationRegister = instruction.getDestinationRegister();
            String val = registerMap.get(destinationRegister);
            if (beat == 0)
                oldVal = val;
            desCond.append("\t\t\t\"").append(destinationRegister).append("\" |-> ").append("(mi(32, ")
                    .append(val).append(") => ");
            Map<String, BigInteger[]> preCond = proveObject.getPreCond();
            BigInteger[] desRange = preCond.get(val);
            StringBuilder sRegVal = new StringBuilder();
            String sourceVal = registerMap.get(sourceReg);
            BigInteger[] sourceRange;
            boolean sourceDFlag = false, desDFlag = false, sourceSNaNFlag = false, desSNaNFlag = false;
            int sourceState = 0, desState = 0;
            if (size == 32) {
                sRegVal.append(sourceVal).append(beat);
                sourceRange = preCond.get(sRegVal);
                // 处理浮点值范围带来的影响
                sourceState = getSingleDoubleFPStateFlag(sourceRange, 32);
                desState = getSingleDoubleFPStateFlag(desRange, 32);

            } else if (size == 16) {
                sRegVal.append(sourceVal).append("0").append(beat);
                sourceRange = preCond.get(sRegVal);

            }
            // handle the output of current instruction
            // 解析二进制串，判断值范围是否包含特殊值，若包含则记录标志位的改变
            // 针对不同情况分类处理范围（由于可能出现分支情况，预先得到的结果可能是不确定的）
            // 先判断值的范围是否包含多种情况，若包含多种情况，则先处理值（若多种情况不能确定值）

        } catch (RuntimeException ex) {
            ex.printStackTrace();
        }
        return postCondition;
    }

    /**
     * undo
     * 32位
     * -0 D Normal Inf SNaN QNaN 0 D Normal Inf SNaN QNaN
     *              用标志记录状态
     *                 -1  -0
     *                 0 表示值为 + 0
     *                 1 表示都在正常状态   （正）
     *                 2 表示都在正常状态   （负）
     *                 3 表示都在0（0 和 Denormalized）
     *                 4 表示都在-0 （负数）
     *                 5 表示都在SNaN （正）
     *                 6 表示都在SNaN （负）
     *                 7 表示都在QNaN （正）
     *                 8 表示都在QNaN （负）
     *                 9 表示包含除NaN外的情况 （正）
     *                 10 表示包含除NaN外的情况 （负）
     *                 11 表示包含除0外的情况   （正）
     *                 12 表示包含除0外的情况   （负）
     *                 13 表示正数所有的情况    （正）
     *                 14 表示负数所有的情况    （负）
     *
     *                 15 表示包含正负的范围，并下界只包含QNaN，上界不包含NaN
     *                 16 表示包含正负的范围，下界只包含NaN，上界不包含NaN
     *                 17 表示包含正负的范围，下界包含所有情况，上界不包含NaN
     *                 18 表示包含。。，下界只包含QNaN，上界包含所有
     *                 19 表示包含。。，下界包含所有，上界包含所有
     * @param range
     * @return
     */
    private int getSingleDoubleFPStateFlag(BigInteger[] range, int size) {
        if (size == 32) {
            if (range[0].compareTo(BigInteger.ZERO) == 0 && range[1].compareTo(BigInteger.ZERO) == 0)
                return 0;
            else if (range[0].compareTo(BigInteger.valueOf(-2147483648)) == 0 && range[1].compareTo(BigInteger.valueOf(-2147483648)) == 0) {
                return -1;
            } if (range[0].compareTo(BigInteger.valueOf(8388608)) >= 0 && range[1].compareTo(BigInteger.valueOf(2139095040)) <= 0) {
                return 1;
            } else if (range[0].compareTo(BigInteger.valueOf(-2139095040)) >= 0 && range[0].compareTo(BigInteger.valueOf(-8388608)) <= 0) {
                return 2;
            } else if (range[0].compareTo(BigInteger.ZERO) >= 0 && range[0].compareTo(BigInteger.valueOf(8388607)) <= 0) {
                return 3;
            } else if (range[0].compareTo(BigInteger.valueOf(-2147483648)) >= 0 && range[1].compareTo(BigInteger.valueOf(-2139095041)) <= 0) {
                return 4;
            } else if (range[0].compareTo(BigInteger.valueOf(2139095041)) >= 0 && range[1].compareTo(BigInteger.valueOf(2143289343)) <= 0) {
                return 5;
            } else if (range[0].compareTo(BigInteger.valueOf(-8388607)) >= 0 && range[1].compareTo(BigInteger.valueOf(-4194305)) <= 0) {
                return 6;
            } else if (range[0].compareTo(BigInteger.valueOf(2143289344)) >= 0 && range[1].compareTo(BigInteger.valueOf(2147483647)) <= 0) {
                return 7;
            } else if (range[0].compareTo(BigInteger.valueOf(-4194304)) >= 0 && range[1].compareTo(BigInteger.valueOf(-1)) <= 0) {
                return 8;
            } else if (range[0].compareTo(BigInteger.ZERO) >= 0 && range[1].compareTo(BigInteger.valueOf(2139095040)) <= 0) {
                return 9;
            } else if (range[0].compareTo(BigInteger.valueOf(-2147483648)) >= 0 && range[1].compareTo(BigInteger.valueOf(-8388608)) <= 0) {
                return 10;
            } else if (range[0].compareTo(BigInteger.valueOf(8388608)) >= 0 && range[1].compareTo(BigInteger.valueOf(2147483647)) <= 0) {
                return 11;
            } else if (range[0].compareTo(BigInteger.valueOf(-2139095040)) >= 0 && range[1].compareTo(BigInteger.valueOf(-1)) <= 0) {
                return 12;
            } else if (range[0].compareTo(BigInteger.ZERO) >= 0 && range[1].compareTo(BigInteger.valueOf(2147483647)) <= 0) {
                return 13;
            } else if (range[0].compareTo(BigInteger.valueOf(-2147483648)) >= 0 && range[1].compareTo(BigInteger.valueOf(-1)) <= 0) {
                return 14;
            } else if (range[0].compareTo(BigInteger.valueOf(-4194304)) >= 0 && range[1].compareTo(BigInteger.valueOf(2139095040)) <= 0) {
                return 15;
            } else if (range[0].compareTo(BigInteger.valueOf(-8388607)) >= 0 && range[1].compareTo(BigInteger.valueOf(2139095040)) <= 0) {
                return 16;
            } else if (range[0].compareTo(BigInteger.valueOf(-2147483648)) >= 0 && range[1].compareTo(BigInteger.valueOf(2139095040)) <= 0) {
                return 17;
            } else if (range[0].compareTo(BigInteger.valueOf(-4194304)) >= 0 && range[1].compareTo(BigInteger.valueOf(2147483647)) <= 0) {
                return 18;
            } else if (range[0].compareTo(BigInteger.valueOf(-2147483648)) >= 0 && range[1].compareTo(BigInteger.valueOf(2147483647)) <= 0) {
                return 19;
            } else
                return -2;
        }
        return -2;
    }

    /**
     * 16位
     * -0 D Normal Inf SNaN QNaN 0 D Normal Inf SNaN QNaN
     *              用标志记录状态
     *                 1 表示都在正常状态   （正）
     *                 2 表示都在正常状态   （负）
     *                 3 表示都在SNaN （正）
     *                 4 表示都在SNaN （负）
     *                 5 表示都在QNaN （正）
     *                 6 表示都在QNaN （负）
     *                 7 表示正数所有的情况    （正）
     *                 8 表示负数所有的情况    （负）
     *
     *                 9 表示包含正负的范围，并下界只包含QNaN，上界不包含NaN
     *                 10 表示包含正负的范围，下界只包含NaN，上界不包含NaN
     *                 11 表示包含正负的范围，下界包含所有情况，上界不包含NaN
     *                 12 表示包含。。，下界只包含QNaN，上界包含所有
     *                 13 表示包含。。，下界包含所有，上界包含所有
     * @param range
     * @return
     */
    private int getHalfFPStateFlag(BigInteger[] range) {
        if (range[0].compareTo(BigInteger.ZERO) >= 0 && range[1].compareTo(BigInteger.valueOf(31744)) <= 0) {
            return 1;
        } else if (range[0].compareTo(BigInteger.valueOf(-32768)) >= 0 && range[1].compareTo(BigInteger.valueOf(-1024)) <= 0) {
            return 2;
        } else if (range[0].compareTo(BigInteger.valueOf(31745)) >= 0 && range[1].compareTo(BigInteger.valueOf(32255)) <= 0) {
            return 3;
        } else if (range[0].compareTo(BigInteger.valueOf(-1023)) >= 0 && range[1].compareTo(BigInteger.valueOf(-511)) <= 0) {
            return 4;
        } else if (range[0].compareTo(BigInteger.valueOf(32256)) >= 0 && range[1].compareTo(BigInteger.valueOf(32767)) <= 0) {
            return 5;
        } else if (range[0].compareTo(BigInteger.valueOf(-512)) >= 0 && range[1].compareTo(BigInteger.valueOf(-1)) <= 0) {
            return 6;
        } else if (range[0].compareTo(BigInteger.ZERO) >= 0 && range[1].compareTo(BigInteger.valueOf(32767)) <= 0) {
            return 7;
        } else if (range[0].compareTo(BigInteger.valueOf(-32768)) >= 0 && range[1].compareTo(BigInteger.valueOf(-1)) <= 0) {
            return 8;
        } else if (range[0].compareTo(BigInteger.valueOf(-512)) >= 0 && range[1].compareTo(BigInteger.valueOf(31744)) <= 0) {
            return 9;
        } else if (range[0].compareTo(BigInteger.valueOf(-1023)) >= 0 && range[1].compareTo(BigInteger.valueOf(31744)) <= 0) {
            return 10;
        } else if (range[0].compareTo(BigInteger.valueOf(-32768)) >= 0 && range[1].compareTo(BigInteger.valueOf(31744)) <= 0) {
            return 11;
        } else if (range[0].compareTo(BigInteger.valueOf(-512)) >= 0 && range[1].compareTo(BigInteger.valueOf(32767)) <= 0) {
            return 12;
        } else if (range[0].compareTo(BigInteger.valueOf(-32768)) >= 0 && range[1].compareTo(BigInteger.valueOf(32767)) <= 0) {
            return 13;
        } else
            return -1;
    }

    /**
     * undo
     * 单双精度浮点数的结果范围
     * @param sourceState
     * @param desState
     * @param sourceRange
     * @param desRange
     * @return
     */
    private BigInteger[] getSingleDoubleMaxDesRange(int sourceState, int desState, BigInteger[] sourceRange, BigInteger[] desRange) {
        BigInteger upper = BigInteger.ZERO, lower = BigInteger.ZERO;
        if ((sourceState == 0 && (desState == 0 || desState == -1 || desState == 2 || desState == 3 || desState == 4
                || desState == 5 || desState == 6 || desState == 7 || desState == 8))
                ||
                (desState == 0 && (sourceState == -1 || sourceState == 2 || sourceState == 3 || sourceState == 4
                || sourceState == 5 || sourceState == 6 || sourceState == 7 || sourceState == 8))
                || (sourceState == 2 && desState == 3) || (desState == 2 && sourceState == 3) ) {
            upper = BigInteger.ZERO;
            lower = BigInteger.ZERO;
        } else if ((sourceState == -1 && (desState == -1 || desState == 4 || desState == 5 || desState == 6
                || desState == 7 || desState == 8)) ||
                (desState == -1 && (sourceState == 4 || sourceState == 5 || sourceState == 6 || sourceState == 7 || sourceState == 8))) {
            upper = BigInteger.valueOf(-2147483648);
            lower = upper;
        } else if ((sourceState == 1 && (desState == 1 || desState == 9)) || (desState == 1 && sourceState == 9)) {
            upper = sourceRange[1].compareTo(desRange[1]) <= 0 ? desRange[1] : sourceRange[1];
            lower = sourceRange[0].compareTo(desRange[0]) <= 0 ? desRange[0] : sourceRange[0];
        } else if (sourceState == 1 && (desState == -1 || desState == 2 || desState == 0 || desState == 3 || desState == 4
                || desState == 5 || desState == 6 || desState == 7 || desState == 8 || desState == 10)) {
            upper = sourceRange[1];
            lower = sourceRange[0];
        } else if (desState == 1 && (sourceState == -1 || sourceState == 2 || sourceState == 0 || sourceState == 3 || sourceState == 4
                || sourceState == 5 || sourceState == 6 || sourceState == 7 || sourceState == 10)) {
            upper = desRange[1];
            lower = desRange[0];
        } else if ((sourceState == 2 && (desState == 2 || desState == 10)) || (desState == 2 && sourceState == 10)) {
            upper = sourceRange[1].compareTo(desRange[1]) <= 0 ? desRange[1] : sourceRange[1];
            lower = sourceRange[0].compareTo(desRange[0]) <= 0 ? desRange[0] : sourceRange[0];
        } else if (sourceState == 2 && (desState == 4 || desState == 5 || desState == 6 || desState == 7
                || desState == 8)) {
            upper = sourceRange[1];
            lower = sourceRange[0];
        } else if (desState == 2 && (sourceState == 4 || sourceState == 5 || sourceState == 6
                ||sourceState == 7 || sourceState == 8)) {
            upper = desRange[1];
            lower = desRange[0];
        } else if ((sourceState == 3 && (desState == 3 || desState == 4 || desState == 5 || desState == 6 || desState == 7
                || desState == 8 )) || (desState == 3 && (sourceState == 4 || sourceState == 5 || sourceState == 6
                || sourceState == 7 || sourceState == 8))) {
            upper = BigInteger.ZERO;
            lower = BigInteger.ZERO;
        } else if ((sourceState == 4 && (desState == 4 || desState == 5 || desState == 6 || desState == 7 || desState == 8))
                || (desState == 4 && (sourceState == 5 || sourceState == 6 || sourceState == 7 || sourceState == 8))) {
            upper = BigInteger.valueOf(-2147483648);
            lower = upper;
        } else if ((sourceState == 5 && (desState == 5 || desState == 6 || desState == 7 || desState == 8))
                || (desState == 5 && (sourceState == 6 || sourceState == 7 || sourceState == 8))
                || (sourceState == 6 && (desState == 6 || desState == 7 || desState == 8))
                || (desState == 6 && (sourceState == 7 || sourceState == 8)) || (sourceState == 7 && (desState == 7 || desState == 8))
                || (desState == 7 && sourceState == 8) || (desState == 8 && sourceState == 8)) {
            upper = BigInteger.valueOf(2143289344);
            lower = BigInteger.valueOf(2143289344);
        } else if (sourceState == 9 && (desState == 0 || desState == -1 || desState == 2 || desState == 3 || desState == 4
                || desState == 5 || desState == 6 || desState == 7 || desState == 8 || desState == 10)) {
            upper = sourceRange[1];
            lower = sourceRange[0];
        } else if (desState == 9 && (sourceState == 0 || sourceState == -1 || sourceState == 2 || sourceState == 3
                || sourceState == 4 || sourceState == 5 || sourceState == 6 || sourceState == 7 || sourceState == 8 || sourceState == 10)) {
            upper = desRange[1];
            lower = desRange[0];
        } else if (desState == 9 && sourceState == 9) {
            upper = desRange[1].compareTo(sourceRange[1]) <= 0 ? sourceRange[1] : desRange[1];
            lower = desRange[0].compareTo(sourceRange[0]) <= 0 ? sourceRange[0] : desRange[0];
        } else if ((sourceState == 9 && (desState == 11 || desState == 13)) || (desState == 9 && (sourceState == 11 || sourceState == 13))) {
            upper = BigInteger.valueOf(2139095040);
            lower = sourceRange[0].compareTo(desRange[0]) <= 0 ? desRange[0] : sourceRange[0];
        } else if (sourceState == 10 && (desState == -1 || desState == 4 || desState == 5 || desState == 6
                || desState == 7 || desState == 8)) {
            upper = sourceRange[1];
            lower = sourceRange[0];
        } else if (desState == 10 && (sourceState == -1 || sourceState == 4 || sourceState == 5
                || sourceState == 6 || sourceState == 7 || sourceState == 8)) {
            upper = desRange[1];
            lower = desRange[0];
        } else if ((sourceState == 10 && (desState == 12 || desState == 14))
                || (desState == 10 && (sourceState == 12 || sourceState == 14))) {
            upper = BigInteger.valueOf(-8388608);
            lower = sourceRange[0].compareTo(desRange[0]) <= 0 ? desRange[0] : sourceRange[0];
        } else if (sourceState == 10 && desState == 10) {
            upper = sourceRange[1].compareTo(desRange[1]) <= 0 ? desRange[1] : sourceRange[1];
            lower = sourceRange[0].compareTo(desRange[0]) <= 0 ? desRange[0] : sourceRange[0];
        }
        return new BigInteger[]{lower, upper};
    }

    private void getVADDQRsRegToLeft(int size, StringBuilder sRegToLeft, Map<String, String> registerMap,
                                        String sReg1, String sourceRegister2, String[] vals1) {

        if (size == 32) {
            sRegToLeft.append("\t\t\t\t\taddMInt(mi(32, ").append(registerMap.get(sReg1))
                    .append("), mi(32, ").append(registerMap.get(sourceRegister2)).append("))\n");
        } else if (size == 16) {
            String sub = "extractMInt(mi(32, " + registerMap.get(sourceRegister2) + "), 16, 32)";
            sRegToLeft.append("\t\t\t\t\tconcatenateMInt(").append("addMInt(mi(16, ")
                    .append(vals1[0]).append("), ")
                    .append(sub).append("), addMInt(mi(16, ").append(vals1[1])
                    .append("), ").append(sub).append("))\n");
        } else if (size == 8) {
            String sub = "extractMInt(mi(32, " + registerMap.get(sourceRegister2) + "), 24, 32)";
            sRegToLeft.append("\t\t\t\t\tconcatenateMInt(").append("addMInt(mi(8, ")
                    .append(vals1[0]).append("), ")
                    .append(sub).append("), ").append("concatenateMInt(")
                    .append("addMInt(mi(8, ").append(vals1[1])
                    .append("), ").append(sub).append("), ")
                    .append("concatenateMInt(")
                    .append("addMInt(mi(8, ").append(vals1[2])
                    .append("), ").append(sub).append("), ")
                    .append("addMInt(mi(8, ").append(vals1[3])
                    .append("), ").append(sub).append("))))\n");
        }

    }

    private void getVSUBQRsRegToLeft(int size, StringBuilder sRegToLeft, Map<String, String> registerMap,
                                   String sReg1, String sourceRegister2, String[] vals1) {
        if (size == 32) {
            sRegToLeft.append("\t\t\t\t\tsubMInt(mi(32, ").append(registerMap.get(sReg1))
                    .append("), mi(32, ").append(registerMap.get(sourceRegister2)).append("))\n");
        } else if (size == 16) {
            String sub = "extractMInt(mi(32, " + registerMap.get(sourceRegister2) + "), 16, 32)";
            sRegToLeft.append("\t\t\t\t\tconcatenateMInt(").append("subMInt(mi(16, ")
                    .append(vals1[0]).append("), ")
                    .append(sub).append("), subMInt(mi(16, ").append(vals1[1])
                    .append("), ").append(sub).append("))\n");
        } else if (size == 8) {
            String sub = "extractMInt(mi(32, " + registerMap.get(sourceRegister2) + "), 24, 32)";
            sRegToLeft.append("\t\t\t\t\tconcatenateMInt(").append("subMInt(mi(8, ")
                    .append(vals1[0]).append("), ")
                    .append(sub).append("), ").append("concatenateMInt(")
                    .append("subMInt(mi(8, ").append(vals1[1])
                    .append("), ").append(sub).append("), ")
                    .append("concatenateMInt(")
                    .append("subMInt(mi(8, ").append(vals1[2])
                    .append("), ").append(sub).append("), ")
                    .append("subMInt(mi(8, ").append(vals1[3])
                    .append("), ").append(sub).append("))))\n");
        }
    }

    private void getVMULQRsRegToLeft(int size, StringBuilder sRegToLeft, Map<String, String> registerMap,
                                     String sReg1, String sourceRegister2, String[] vals1) {
        if (size == 32) {
            sRegToLeft.append("\t\t\t\t\textractMInt(mi(64, svalueMInt(mi(32, ").append(registerMap.get(sReg1))
                    .append(")) *Int svalueMInt(mi(32, ").append(registerMap.get(sourceRegister2))
                    .append("))), 32, 64)");
        } else if (size == 16) {
            String sub = "extractMInt(mi(32, " + registerMap.get(sourceRegister2) + "), 16, 32)";
            sRegToLeft.append("\t\t\t\t\tconcatenateMInt(")
                    .append("extractMInt(mi(32, svalueMInt(mi(16, ").append(vals1[0])
                    .append(")) *Int svalueMInt(").append(sub).append(")), 16, 32), ")
                    .append("extractMInt(mi(32, svalueMInt(mi(16, ").append(vals1[1])
                    .append(")) *Int svalueMInt(").append(sub).append(")), 16, 32))")
                    .append("\n");
        } else if (size == 8) {
            String sub = "extractMInt(mi(32, " + registerMap.get(sourceRegister2) + "), 24, 32)";
            sRegToLeft.append("\t\t\t\t\tconcatenateMInt(")
                    .append("extractMInt(mi(16, svalueMInt(mi(8, ").append(vals1[0])
                    .append(")) *Int svalueMInt(").append(sub).append(")), 8, 16), ")
                    .append("concatenateMInt(")
                    .append("extractMInt(mi(16, svalueMInt(mi(8, ").append(vals1[1])
                    .append(")) *Int svalueMInt(").append(sub).append(")), 8, 16), ")
                    .append("concatenateMInt(")
                    .append("extractMInt(mi(16, svalueMInt(mi(8, ").append(vals1[2])
                    .append(")) *Int svalueMInt(").append(sub).append(")), 8, 16), ")
                    .append("extractMInt(mi(16, svalueMInt(mi(8, ").append(vals1[3])
                    .append(")) *Int svalueMInt(").append(sub).append(")), 8, 16)")
                    .append(")))\n");
        }
    }

    /**
     * 源向量  相减
     * @param size
     * @param sRegToLeft
     * @param registerMap
     * @param sReg1 被减
     * @param sReg2 减
     * @param vals1
     * @param vals2
     */
    private void getVSUBQQsRegToLeft(int size, StringBuilder sRegToLeft, Map<String, String> registerMap,
                                     String sReg1, String sReg2, String[] vals1, String[] vals2) {
        if (size == 32) {
            sRegToLeft.append("\t\t\t\t\tsubMInt(mi(32, ").append(registerMap.get(sReg1))
                    .append("), mi(32, ").append(registerMap.get(sReg2)).append("))\n");
        } else if (size == 16) {
            sRegToLeft.append("\t\t\t\t\tconcatenateMInt(")
                    .append("subMInt(mi(16, ").append(vals1[0]).append("), ")
                    .append("mi(16, ").append(vals2[0]).append(")), ")
                    .append("subMInt(mi(16, ").append(vals1[1]).append("), ")
                    .append("mi(16, ").append(vals2[1]).append(")))\n");
        } else if (size == 8) {
            sRegToLeft.append("\t\t\t\t\tconcatenateMInt(")
                    .append("subMInt(mi(8, ").append(vals1[0]).append("), ")
                    .append("mi(8, ").append(vals2[0]).append(")), ")
                    .append("concatenateMInt(")
                    .append("subMInt(mi(8, ").append(vals1[1]).append("), ")
                    .append("mi(8, ").append(vals2[1]).append(")), ")
                    .append("concatenateMInt(")
                    .append("subMInt(mi(8, ").append(vals1[2]).append("), ")
                    .append("mi(8, ").append(vals2[2]).append(")), ")
                    .append("subMInt(mi(8, ").append(vals1[3]).append("), ")
                    .append("mi(8, ").append(vals2[3]).append("))")
                    .append(")))\n");
        }
    }

    /**
     * VMUL Q R
     * @return
     */
    public List<String> vmulQRPostSet() {
        List<String> postCondition = new ArrayList<>();
        try {
            if (instruction == null || instruction.getDestinationRegister() == null)
                throw new RuntimeException("指令或目标寄存器为空");
            if (sourcePostCond == null || sourcePostCond.isEmpty())
                sourcePostCond = new ArrayList<>();
            if (instruction.getSourceRegister() == null || instruction.getSourceRegister().isEmpty())
                throw new InputMismatchException("源操作数为空");
            String datatype = instruction.getDatatype();
            int size = Integer.parseInt(datatype.substring(1));
            Map<String, String> registerMap = proveObject.getRegisterMap();
            Map<String, BigInteger[]> preCond = proveObject.getPreCond();
            String desRegister = instruction.getDestinationRegister();
            StringBuilder desCond = preSet();
            sourcePostCond.clear();

            String sourceRegister1 = instruction.getSourceRegister().get(0);
            String sourceRegister2 = instruction.getSourceRegister().get(1);
            String val = registerMap.get(sourceRegister2);
            desCond.append("\t\t\t\"").append(sourceRegister2).append("\" |-> ").append("mi(32, ")
                    .append(val).append(")\n");
            if (desRegister.equals(sourceRegister1)) {
                List<StringBuilder> sListTo = new ArrayList<>();
                int indexDes = Integer.parseInt(desRegister.substring(1)) * 4;
                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (indexDes+i);
                    StringBuilder sRegFrom = conca(sReg1, 32 / size, size, new StringBuilder());

                    StringBuilder sRegToLeft = new StringBuilder();
                    String[] vals1 = registerMap.get(sReg1.toString()).split(":");
                    getVMULQRsRegToLeft(size, sRegToLeft, registerMap, sReg1, sourceRegister2, vals1);
                    sListTo.add(sRegToLeft);
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToLeft).append("\t\t\t\telse undefMInt32)\n");

                    // 重设目标寄存器的值范围
                    BigInteger[] bigIntegers2 = preCond.get(registerMap.get(sourceRegister2));

                    for (String s : vals1) {
                        BigInteger[] bigIntegers1 = preCond.get(s);
                        //normalize(bigIntegers1, datatype, size);
                        //normalize(bigIntegers2, datatype, size);

                        preCond.put(s, new BigInteger[]{
                                bigIntegers1[0].multiply(bigIntegers2[0]).compareTo(bigIntegers1[1].multiply(bigIntegers2[0])) > 0
                                        ? (bigIntegers1[1].multiply(bigIntegers2[0]).compareTo(bigIntegers1[0].multiply(bigIntegers2[1])) > 0
                                            ? bigIntegers1[0].multiply(bigIntegers2[1]) : bigIntegers1[1].multiply(bigIntegers2[0]))
                                        : (bigIntegers1[0].multiply(bigIntegers2[0]).compareTo(bigIntegers1[0].multiply(bigIntegers2[1])) > 0
                                        ? bigIntegers1[0].multiply(bigIntegers2[1]) : bigIntegers1[0].multiply(bigIntegers2[0])),
                                bigIntegers1[1].multiply(bigIntegers2[1]).compareTo(bigIntegers1[0].multiply(bigIntegers2[0])) > 0
                                        ? bigIntegers1[1].multiply(bigIntegers2[1]) : bigIntegers1[0].multiply(bigIntegers2[0])});
                    }
                }
                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = conca(desRegister, 128 / size, size, new StringBuilder());
                qRegFrom.append(" => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            } else {
                int index1 = Integer.parseInt(sourceRegister1.substring(1)) * 4;
                setSourcePostCond(size, index1, sourceRegister1);
                postCondition.addAll(sourcePostCond);
                // 设置S
                List<StringBuilder> sListTo = new ArrayList<>();
                int indexDes = Integer.parseInt(desRegister.substring(1)) * 4;
                // 若目标寄存器中无初始值，则在registerMap和preCondMap中设定一个初始值，相当于初始化
                // 命名规则为 vec + 当前向量寄存器的标识符 + '_' + set
                setVecDefaultPreCondAndRegisterMap(registerMap, preCond, desRegister, size, indexDes);

                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (index1+i);
                    StringBuilder sRegFrom = new StringBuilder().append("mi(32, _:Int)\n");

                    StringBuilder sRegToLeft = new StringBuilder();
                    String[] vals1 = registerMap.get(sReg1.toString()).split(":");
                    getVMULQRsRegToLeft(size, sRegToLeft, registerMap, sReg1, sourceRegister2, vals1);
                    sListTo.add(sRegToLeft);
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToLeft).append("\t\t\t\telse undefMInt32)\n");

                    // 重设目标寄存器的值范围
                    BigInteger[] bigIntegers2 = preCond.get(registerMap.get(sourceRegister2));
                    String[] valsDes = registerMap.get("S" + (indexDes+i)).split(":");

                    for (int j = 0; j < vals1.length; j++) {
                        BigInteger[] bigIntegers1 = preCond.get(vals1[j]);
                        //normalize(bigIntegers1, datatype, size);
                        //normalize(bigIntegers2, datatype, size);

                        preCond.put(valsDes[j], new BigInteger[]{
                                bigIntegers1[0].multiply(bigIntegers2[0]).compareTo(bigIntegers1[1].multiply(bigIntegers2[0])) > 0
                                        ? (bigIntegers1[1].multiply(bigIntegers2[0]).compareTo(bigIntegers1[0].multiply(bigIntegers2[1])) > 0
                                        ? bigIntegers1[0].multiply(bigIntegers2[1]) : bigIntegers1[1].multiply(bigIntegers2[0]))
                                        : (bigIntegers1[0].multiply(bigIntegers2[0]).compareTo(bigIntegers1[0].multiply(bigIntegers2[1])) > 0
                                        ? bigIntegers1[0].multiply(bigIntegers2[1]) : bigIntegers1[0].multiply(bigIntegers2[0])),
                                bigIntegers1[1].multiply(bigIntegers2[1]).compareTo(bigIntegers1[0].multiply(bigIntegers2[0])) > 0
                                        ? bigIntegers1[1].multiply(bigIntegers2[1]) : bigIntegers1[0].multiply(bigIntegers2[0])});
                    }
                }

                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = new StringBuilder().append(" mi(128, _:Int) => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            }
            proveObject.setPreCond(preCond);
            proveObject.setRegisterMap(registerMap);
            postCondition.add(desCond.toString());
        } catch (RuntimeException e) {
            e.printStackTrace();
        }
        return postCondition;
    }

    /**
     * VAND Q Q
     * @return
     */
    public List<String> vandQQPostSet() {
        List<String> postCondition = new ArrayList<>();
        try {
            if (instruction == null || instruction.getDestinationRegister() == null)
                throw new RuntimeException("指令或目标寄存器为空");
            if (sourcePostCond == null || sourcePostCond.isEmpty())
                sourcePostCond = new ArrayList<>();
            if (instruction.getSourceRegister() == null || instruction.getSourceRegister().isEmpty())
                throw new InputMismatchException("源操作数为空");
            int size = 32;
            Map<String, String> registerMap = proveObject.getRegisterMap();
            Map<String, BigInteger[]> preCond = proveObject.getPreCond();
            String desRegister = instruction.getDestinationRegister();
            StringBuilder desCond = preSet();
            sourcePostCond.clear();

            String sourceRegister1 = instruction.getSourceRegister().get(0);
            String sourceRegister2 = instruction.getSourceRegister().get(1);
            int indexDes = Integer.parseInt(desRegister.substring(1)) * 4;
            // 第一个源操作数同时为目标操作数
            if (desRegister.equals(sourceRegister1)) {
                int index = Integer.parseInt(sourceRegister2.substring(1)) * 4;
                // 源操作数初始
                setSourcePostCond(size, index, sourceRegister2);
                postCondition.addAll(sourcePostCond);
                sourcePostCond.clear();
                List<StringBuilder> sListTo = new ArrayList<>();
                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (indexDes+i);
                    String sReg2 = "S" + (index+i);
                    StringBuilder sRegFrom = conca(sReg1, 1, 32, new StringBuilder());

                    StringBuilder sRegToLeft = new StringBuilder();
                    StringBuilder sRegToRight = new StringBuilder();
                    //String[] vals1 = registerMap.get(sReg1.toString()).split(":");
                    //String[] vals2 = registerMap.get(sReg2.toString()).split(":");
                    sRegToLeft.append("\t\t\t\t\tandMInt(mi(32, ").append(registerMap.get(sReg1))
                            .append("), mi(32, ").append(registerMap.get(sReg2)).append("))\n");
                    sListTo.add(sRegToLeft);
                    sRegToRight.append("\t\t\t\t\tconcatenateMInt(")
                            .append("andMInt(extractMInt(mi(32, ").append(registerMap.get(sReg1)).append("), 0, 8),")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sReg2)).append("), 0, 8)), ")
                            .append("concatenateMInt(")
                            .append("andMInt(extractMInt(mi(32, ").append(registerMap.get(sReg1)).append("), 8, 16),")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sReg2)).append("), 8, 16)), ")
                            .append("concatenateMInt(")
                            .append("andMInt(extractMInt(mi(32, ").append(registerMap.get(sReg1)).append("), 16, 24),")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sReg2)).append("), 16, 24)), ")
                            .append("andMInt(extractMInt(mi(32, ").append(registerMap.get(sReg1)).append("), 24, 32),")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sReg2)).append("), 24, 32))")
                            .append(")))\n");
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToRight).append("\t\t\t\telse undefMInt32)\n");

                    BigInteger[] bigIntegers1 = preCond.get(registerMap.get(sReg1));
                    BigInteger[] bigIntegers2 = preCond.get(registerMap.get(sReg2));
                    preCond.put(registerMap.get(sReg1), new BigInteger[]{
                            bigIntegers1[0].compareTo(bigIntegers2[0]) > 0 ? bigIntegers2[0] : bigIntegers1[0],
                            bigIntegers1[1].compareTo(bigIntegers2[1]) > 0 ? bigIntegers2[1] : bigIntegers1[1]
                    });
                }
                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = conca(desRegister, 128 / size, size, new StringBuilder());
                qRegFrom.append(" => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            } else if (desRegister.equals(sourceRegister2)) {   // 第二个源操作数同时为目标操作数
                int index = Integer.parseInt(sourceRegister1.substring(1)) * 4;
                // 源操作数初始
                setSourcePostCond(size, index, sourceRegister1);
                postCondition.addAll(sourcePostCond);
                sourcePostCond.clear();
                List<StringBuilder> sListTo = new ArrayList<>();
                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (index+i);
                    String sReg2 = "S" + (indexDes+i);
                    StringBuilder sRegFrom = conca(sReg2, 1, 32, new StringBuilder());

                    StringBuilder sRegToLeft = new StringBuilder();
                    StringBuilder sRegToRight = new StringBuilder();
                    sRegToLeft.append("\t\t\t\t\tandMInt(mi(32, ").append(registerMap.get(sReg1))
                            .append("), mi(32, ").append(registerMap.get(sReg2)).append("))\n");
                    sListTo.add(sRegToLeft);
                    sRegToRight.append("\t\t\t\t\tconcatenateMInt(")
                            .append("andMInt(extractMInt(mi(32, ").append(registerMap.get(sReg1)).append("), 0, 8),")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sReg2)).append("), 0, 8)), ")
                            .append("concatenateMInt(")
                            .append("andMInt(extractMInt(mi(32, ").append(registerMap.get(sReg1)).append("), 8, 16),")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sReg2)).append("), 8, 16)), ")
                            .append("concatenateMInt(")
                            .append("andMInt(extractMInt(mi(32, ").append(registerMap.get(sReg1)).append("), 16, 24),")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sReg2)).append("), 16, 24)), ")
                            .append("andMInt(extractMInt(mi(32, ").append(registerMap.get(sReg1)).append("), 24, 32),")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sReg2)).append("), 24, 32))")
                            .append(")))\n");
                    sListTo.add(sRegToLeft);
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToRight).append("\t\t\t\telse undefMInt32)\n");

                    BigInteger[] bigIntegers1 = preCond.get(registerMap.get(sReg1));
                    BigInteger[] bigIntegers2 = preCond.get(registerMap.get(sReg2));
                    preCond.put(registerMap.get(sReg2), new BigInteger[]{
                            bigIntegers1[0].compareTo(bigIntegers2[0]) > 0 ? bigIntegers2[0] : bigIntegers1[0],
                            bigIntegers1[1].compareTo(bigIntegers2[1]) > 0 ? bigIntegers2[1] : bigIntegers1[1]
                    });
                }
                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = conca(desRegister, 128 / size, size, new StringBuilder());
                qRegFrom.append(" => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            } else {
                int index1 = Integer.parseInt(sourceRegister1.substring(1)) * 4;
                int index2 = Integer.parseInt(sourceRegister2.substring(1)) * 4;
                setSourcePostCond(size, index1, sourceRegister1);
                postCondition.addAll(sourcePostCond);
                sourcePostCond.clear();
                setSourcePostCond(size, index2, sourceRegister2);
                postCondition.addAll(sourcePostCond);
                sourcePostCond.clear();
                // 设置S
                List<StringBuilder> sListTo = new ArrayList<>();
                // 若目标寄存器中无初始值，则在registerMap和preCondMap中设定一个初始值，相当于初始化
                // 命名规则为 vec + 当前向量寄存器的标识符 + '_' + set
                if (!registerMap.containsKey(desRegister)) {
                    String valNew = "V" + desRegister + "_set";
                    registerMap.put(desRegister, valNew);
                    for (int i = 0; i < 4; i++) {
                        String tmp = valNew + i;
                        registerMap.put("S" + (indexDes+i), tmp);
                        preCond.put(tmp, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                    }
                } else {
                    String valNew = registerMap.get(desRegister);
                    for (int i = 0; i < 4; i++) {
                        String tmp = valNew + i;
                        registerMap.put("S" + (indexDes+i), tmp);
                        preCond.put(tmp, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                    }
                }

                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (index1+i);
                    String sReg2 = "S" + (index2+i);
                    StringBuilder sRegFrom = new StringBuilder().append("mi(32, _:Int)\n");

                    StringBuilder sRegToLeft = new StringBuilder();
                    StringBuilder sRegToRight = new StringBuilder();
                    sRegToLeft.append("\t\t\t\t\tandMInt(mi(32, ").append(registerMap.get(sReg1))
                            .append("), mi(32, ").append(registerMap.get(sReg2)).append("))\n");
                    sListTo.add(sRegToLeft);
                    sRegToRight.append("\t\t\t\t\tconcatenateMInt(")
                            .append("andMInt(extractMInt(mi(32, ").append(registerMap.get(sReg1)).append("), 0, 8),")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sReg2)).append("), 0, 8)), ")
                            .append("concatenateMInt(")
                            .append("andMInt(extractMInt(mi(32, ").append(registerMap.get(sReg1)).append("), 8, 16),")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sReg2)).append("), 8, 16)), ")
                            .append("concatenateMInt(")
                            .append("andMInt(extractMInt(mi(32, ").append(registerMap.get(sReg1)).append("), 16, 24),")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sReg2)).append("), 16, 24)), ")
                            .append("andMInt(extractMInt(mi(32, ").append(registerMap.get(sReg1)).append("), 24, 32),")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sReg2)).append("), 24, 32))")
                            .append(")))\n");
                    sListTo.add(sRegToLeft);
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToRight).append("\t\t\t\telse undefMInt32)\n");

                    BigInteger[] bigIntegers1 = preCond.get(registerMap.get(sReg1));
                    BigInteger[] bigIntegers2 = preCond.get(registerMap.get(sReg2));
                    preCond.put(registerMap.get("S" + (indexDes+i)), new BigInteger[]{
                            bigIntegers1[0].compareTo(bigIntegers2[0]) > 0 ? bigIntegers2[0] : bigIntegers1[0],
                            bigIntegers1[1].compareTo(bigIntegers2[1]) > 0 ? bigIntegers2[1] : bigIntegers1[1]
                    });
                }

                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = new StringBuilder().append(" mi(128, _:Int) => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            }
            proveObject.setPreCond(preCond);
            proveObject.setRegisterMap(registerMap);
            postCondition.add(desCond.toString());
        } catch (RuntimeException e) {
            e.printStackTrace();
        }
        return postCondition;
    }

    /**
     * VORR Q Q
     * @return
     */
    public List<String> vorrQQPostSet() {
        List<String> postCondition = new ArrayList<>();
        try {
            if (instruction == null || instruction.getDestinationRegister() == null)
                throw new RuntimeException("指令或目标寄存器为空");
            if (sourcePostCond == null || sourcePostCond.isEmpty())
                sourcePostCond = new ArrayList<>();
            if (instruction.getSourceRegister() == null || instruction.getSourceRegister().isEmpty())
                throw new InputMismatchException("源操作数为空");
            int size = 32;
            Map<String, String> registerMap = proveObject.getRegisterMap();
            Map<String, BigInteger[]> preCond = proveObject.getPreCond();
            String desRegister = instruction.getDestinationRegister();
            StringBuilder desCond = preSet();
            sourcePostCond.clear();

            String sourceRegister1 = instruction.getSourceRegister().get(0);
            String sourceRegister2 = instruction.getSourceRegister().get(1);
            int indexDes = Integer.parseInt(desRegister.substring(1)) * 4;
            // 第一个源操作数同时为目标操作数
            if (desRegister.equals(sourceRegister1)) {
                int index = Integer.parseInt(sourceRegister2.substring(1)) * 4;
                // 源操作数初始
                setSourcePostCond(size, index, sourceRegister2);
                postCondition.addAll(sourcePostCond);
                sourcePostCond.clear();
                List<StringBuilder> sListTo = new ArrayList<>();
                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (indexDes+i);
                    String sReg2 = "S" + (index+i);
                    StringBuilder sRegFrom = conca(sReg1, 1, 32, new StringBuilder());

                    StringBuilder sRegToLeft = new StringBuilder();
                    StringBuilder sRegToRight = new StringBuilder();
                    //String[] vals1 = registerMap.get(sReg1.toString()).split(":");
                    //String[] vals2 = registerMap.get(sReg2.toString()).split(":");
                    sRegToLeft.append("\t\t\t\t\torMInt(mi(32, ").append(registerMap.get(sReg1))
                            .append("), mi(32, ").append(registerMap.get(sReg2)).append("))\n");
                    sListTo.add(sRegToLeft);
                    sRegToRight.append("\t\t\t\t\tconcatenateMInt(")
                            .append("orMInt(extractMInt(mi(32, ").append(registerMap.get(sReg1)).append("), 0, 8),")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sReg2)).append("), 0, 8)), ")
                            .append("concatenateMInt(")
                            .append("orMInt(extractMInt(mi(32, ").append(registerMap.get(sReg1)).append("), 8, 16),")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sReg2)).append("), 8, 16)), ")
                            .append("concatenateMInt(")
                            .append("orMInt(extractMInt(mi(32, ").append(registerMap.get(sReg1)).append("), 16, 24),")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sReg2)).append("), 16, 24)), ")
                            .append("orMInt(extractMInt(mi(32, ").append(registerMap.get(sReg1)).append("), 24, 32),")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sReg2)).append("), 24, 32))")
                            .append(")))\n");
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToRight).append("\t\t\t\telse undefMInt32)\n");

                    BigInteger[] bigIntegers1 = preCond.get(registerMap.get(sReg1));
                    BigInteger[] bigIntegers2 = preCond.get(registerMap.get(sReg2));
                    preCond.put(registerMap.get(sReg1), new BigInteger[]{
                            bigIntegers1[0].or(bigIntegers2[0]),
                            getRightRangeOr(bigIntegers1, bigIntegers2)
                    });
                }
                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = conca(desRegister, 128 / size, size, new StringBuilder());
                qRegFrom.append(" => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            } else if (desRegister.equals(sourceRegister2)) {   // 第二个源操作数同时为目标操作数
                int index = Integer.parseInt(sourceRegister1.substring(1)) * 4;
                // 源操作数初始
                setSourcePostCond(size, index, sourceRegister1);
                postCondition.addAll(sourcePostCond);
                sourcePostCond.clear();
                List<StringBuilder> sListTo = new ArrayList<>();
                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (index+i);
                    String sReg2 = "S" + (indexDes+i);
                    StringBuilder sRegFrom = conca(sReg2, 1, 32, new StringBuilder());

                    StringBuilder sRegToLeft = new StringBuilder();
                    StringBuilder sRegToRight = new StringBuilder();
                    sRegToLeft.append("\t\t\t\t\torMInt(mi(32, ").append(registerMap.get(sReg1))
                            .append("), mi(32, ").append(registerMap.get(sReg2)).append("))\n");
                    sListTo.add(sRegToLeft);
                    sRegToRight.append("\t\t\t\t\tconcatenateMInt(")
                            .append("orMInt(extractMInt(mi(32, ").append(registerMap.get(sReg1)).append("), 0, 8),")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sReg2)).append("), 0, 8)), ")
                            .append("concatenateMInt(")
                            .append("orMInt(extractMInt(mi(32, ").append(registerMap.get(sReg1)).append("), 8, 16),")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sReg2)).append("), 8, 16)), ")
                            .append("concatenateMInt(")
                            .append("orMInt(extractMInt(mi(32, ").append(registerMap.get(sReg1)).append("), 16, 24),")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sReg2)).append("), 16, 24)), ")
                            .append("orMInt(extractMInt(mi(32, ").append(registerMap.get(sReg1)).append("), 24, 32),")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sReg2)).append("), 24, 32))")
                            .append(")))\n");
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToRight).append("\t\t\t\telse undefMInt32)\n");

                    BigInteger[] bigIntegers1 = preCond.get(registerMap.get(sReg1));
                    BigInteger[] bigIntegers2 = preCond.get(registerMap.get(sReg2));
                    preCond.put(registerMap.get(sReg2), new BigInteger[]{
                            bigIntegers1[0].or(bigIntegers2[0]),
                            getRightRangeOr(bigIntegers1, bigIntegers2)
                    });
                }
                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = conca(desRegister, 128 / size, size, new StringBuilder());
                qRegFrom.append(" => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            } else {
                int index1 = Integer.parseInt(sourceRegister1.substring(1)) * 4;
                int index2 = Integer.parseInt(sourceRegister2.substring(1)) * 4;
                setSourcePostCond(size, index1, sourceRegister1);
                postCondition.addAll(sourcePostCond);
                sourcePostCond.clear();
                setSourcePostCond(size, index2, sourceRegister2);
                postCondition.addAll(sourcePostCond);
                sourcePostCond.clear();
                // 设置S
                List<StringBuilder> sListTo = new ArrayList<>();
                // 若目标寄存器中无初始值，则在registerMap和preCondMap中设定一个初始值，相当于初始化
                // 命名规则为 vec + 当前向量寄存器的标识符 + '_' + set
                if (!registerMap.containsKey(desRegister)) {
                    String valNew = "V" + desRegister + "_set";
                    registerMap.put(desRegister, valNew);
                    for (int i = 0; i < 4; i++) {
                        String tmp = valNew + i;
                        registerMap.put("S" + (indexDes+i), tmp);
                        preCond.put(tmp, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                    }
                } else {
                    String valNew = registerMap.get(desRegister);
                    for (int i = 0; i < 4; i++) {
                        String tmp = valNew + i;
                        registerMap.put("S" + (indexDes+i), tmp);
                        preCond.put(tmp, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                    }
                }

                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (index1+i);
                    String sReg2 = "S" + (index2+i);
                    StringBuilder sRegFrom = new StringBuilder().append("mi(32, _:Int)\n");

                    StringBuilder sRegToLeft = new StringBuilder();
                    StringBuilder sRegToRight = new StringBuilder();
                    sRegToLeft.append("\t\t\t\t\torMInt(mi(32, ").append(registerMap.get(sReg1))
                            .append("), mi(32, ").append(registerMap.get(sReg2)).append("))\n");
                    sListTo.add(sRegToLeft);
                    sRegToRight.append("\t\t\t\t\tconcatenateMInt(")
                            .append("orMInt(extractMInt(mi(32, ").append(registerMap.get(sReg1)).append("), 0, 8),")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sReg2)).append("), 0, 8)), ")
                            .append("concatenateMInt(")
                            .append("orMInt(extractMInt(mi(32, ").append(registerMap.get(sReg1)).append("), 8, 16),")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sReg2)).append("), 8, 16)), ")
                            .append("concatenateMInt(")
                            .append("orMInt(extractMInt(mi(32, ").append(registerMap.get(sReg1)).append("), 16, 24),")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sReg2)).append("), 16, 24)), ")
                            .append("orMInt(extractMInt(mi(32, ").append(registerMap.get(sReg1)).append("), 24, 32),")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sReg2)).append("), 24, 32))")
                            .append(")))\n");
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToRight).append("\t\t\t\telse undefMInt32)\n");

                    BigInteger[] bigIntegers1 = preCond.get(registerMap.get(sReg1));
                    BigInteger[] bigIntegers2 = preCond.get(registerMap.get(sReg2));
                    preCond.put(registerMap.get("S" + (indexDes+i)), new BigInteger[]{
                            bigIntegers1[0].or(bigIntegers2[0]),
                            getRightRangeOr(bigIntegers1, bigIntegers2)
                    });
                }

                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = new StringBuilder().append(" mi(128, _:Int) => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            }
            proveObject.setPreCond(preCond);
            proveObject.setRegisterMap(registerMap);
            postCondition.add(desCond.toString());
        } catch (RuntimeException e) {
            e.printStackTrace();
        }
        return postCondition;
    }

    /**
     * 获取 Or 右边界
     * @param bigIntegers1
     * @param bigIntegers2
     * @return
     */
    private BigInteger getRightRangeOr(BigInteger[] bigIntegers1, BigInteger[] bigIntegers2) {
        String bigHigher1 = bigIntegers1[1].toString(2);
        String bigHigher2 = bigIntegers2[1].toString(2);
        if (bigIntegers1[1].compareTo(bigIntegers2[1]) > 0) {
            int leftOne2 = bigHigher2.length() - bigHigher2.indexOf("1");
            int loc = 0, cnt = 0;
            for (int j = 0; j < bigHigher1.length(); j++) {
                if (bigHigher1.charAt(j) == '1') {
                    cnt++;
                    if (cnt == 2) {
                        loc = bigHigher1.length() - j;
                        break;
                    }
                }
            }
            if (loc == 0 || leftOne2 > loc) {
                bigIntegers1[1] = bigIntegers1[1].or(bigIntegers2[1]);
            } else {
                bigIntegers1[1] = bigIntegers1[1].or(BigInteger.valueOf(2).pow(leftOne2-1)
                        .subtract(BigInteger.ONE));
            }
            return bigIntegers1[1];
        } else {
            int leftOne1 = bigHigher1.length() - bigHigher1.indexOf("1");
            int loc = 0, cnt = 0;
            for (int j = 0; j < bigHigher2.length(); j++) {
                if (bigHigher2.charAt(j) == '1') {
                    cnt++;
                    if (cnt == 2) {
                        loc = bigHigher2.length() - j;
                        break;
                    }
                }
            }
            if (loc == 0 || leftOne1 > loc) {
                bigIntegers2[1] = bigIntegers2[1].or(bigIntegers1[1]);
            } else {
                bigIntegers2[1] = bigIntegers2[1].or(BigInteger.valueOf(2).pow(leftOne1-1)
                        .subtract(BigInteger.ONE));
            }
            return bigIntegers2[1];
        }
    }

    /**
     * VUDP Q R
     * @return
     */

    public List<String> vdupQRPostSet() {
        List<String> postCondition = new ArrayList<>();
        try {
            if (instruction == null || instruction.getDestinationRegister() == null)
                throw new RuntimeException("指令或目标寄存器为空");
            if (sourcePostCond == null || sourcePostCond.isEmpty())
                sourcePostCond = new ArrayList<>();
            if (instruction.getSourceRegister() == null || instruction.getSourceRegister().isEmpty())
                throw new InputMismatchException("源操作数为空");
            String datatype = instruction.getDatatype();
            int size = Integer.parseInt(datatype);
            Map<String, String> registerMap = proveObject.getRegisterMap();
            Map<String, BigInteger[]> preCond = proveObject.getPreCond();
            String desRegister = instruction.getDestinationRegister();
            StringBuilder desCond = preSet();
            sourcePostCond.clear();

            String sourceRegister1 = instruction.getSourceRegister().get(0);
            String val = registerMap.get(sourceRegister1);
            desCond.append("\t\t\t\"").append(sourceRegister1).append("\" |-> ").append("mi(32, ")
                    .append(val).append(")\n");

            // 设置S
            List<StringBuilder> sListTo = new ArrayList<>();
            int indexDes = Integer.parseInt(desRegister.substring(1)) * 4;
            // 若目标寄存器中无初始值，则在registerMap和preCondMap中设定一个初始值，相当于初始化
            // 命名规则为 vec + 当前向量寄存器的标识符 + '_' + set
            if (!registerMap.containsKey(desRegister)) {
                String valNew = "V" + desRegister + "_set";
                registerMap.put(desRegister, valNew);
                valNew = size == 32 ? valNew : (size == 16 ? valNew + "0" : valNew + "00");
                for (int i = 0; i < 4; i++) {
                    if (size == 8) {
                        String tmp1 = valNew + (i * 4);
                        String tmp2 = valNew + (i * 4 + 1);
                        String tmp3 = valNew + (i * 4 + 2);
                        String tmp4 = valNew + (i * 4 + 3);
                        registerMap.put("S" + (indexDes + i), tmp4 + ":" + tmp3 + ":" + tmp2 + ":" + tmp1);
                        preCond.put(tmp1, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                        preCond.put(tmp2, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                        preCond.put(tmp3, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                        preCond.put(tmp4, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                    } else if (size == 16) {
                        String tmp1 = valNew + (i * 2);
                        String tmp2 = valNew + (i * 2 + 1);
                        registerMap.put("S" + (indexDes + i), tmp2 + ":" + tmp1);
                        preCond.put(tmp1, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                        preCond.put(tmp2, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                    } else if (size == 32) {
                        String tmp = valNew + i;
                        registerMap.put("S" + (indexDes + i), tmp);
                        preCond.put(tmp, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                    }
                }
            } else {
                int len = registerMap.get("S" + indexDes).split(":").length;
                if (len != 32 / size) {
                    String valNew = registerMap.get(desRegister);
                    for (int i = 0; i < 4; i++) {
                        if (size == 8) {
                            String tmp1 = valNew + (i * 4);
                            String tmp2 = valNew + (i * 4 + 1);
                            String tmp3 = valNew + (i * 4 + 2);
                            String tmp4 = valNew + (i * 4 + 3);
                            registerMap.put("S" + (indexDes + i), tmp4 + ":" + tmp3 + ":" + tmp2 + ":" + tmp1);
                            preCond.put(tmp1, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                            preCond.put(tmp2, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                            preCond.put(tmp3, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                            preCond.put(tmp4, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                        } else if (size == 16) {
                            String tmp1 = valNew + (i * 2);
                            String tmp2 = valNew + (i * 2 + 1);
                            registerMap.put("S" + (indexDes + i), tmp2 + ":" + tmp1);
                            preCond.put(tmp1, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                            preCond.put(tmp2, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                        } else if (size == 32) {
                            String tmp = valNew + i;
                            registerMap.put("S" + (indexDes + i), tmp);
                            preCond.put(tmp, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                        }
                    }
                }
            }

            for (int i = 0; i < 4; i++) {
                StringBuilder sRegFrom = new StringBuilder().append("mi(32, _:Int)\n");

                StringBuilder sRegToLeft = new StringBuilder();
                if (size == 32) {
                    sRegToLeft.append("\t\t\t\t\tmi(32, ").append(registerMap.get(sourceRegister1)).append(")\n");
                } else if (size == 16) {
                    sRegToLeft.append("\t\t\t\t\tconcatenateMInt(")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sourceRegister1))
                            .append("), 16, 32), ")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sourceRegister1))
                            .append("), 16, 32))\n");
                } else if (size == 8) {
                    sRegToLeft.append("concatenateMInt(")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sourceRegister1))
                            .append("), 24, 32), ")
                            .append("concatenateMInt(")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sourceRegister1))
                            .append("), 24, 32), ")
                            .append("concatenateMInt(")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sourceRegister1))
                            .append("), 24, 32), ")
                            .append("extractMInt(mi(32, ").append(registerMap.get(sourceRegister1))
                            .append("), 24, 32)")
                            .append(")))\n");
                }
                sListTo.add(sRegToLeft);
                desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                        .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                        .append("\t\t\t\t) then ").append(sRegToLeft).append("\t\t\t\telse undefMInt32)\n");

                // 重设目标寄存器的值范围
                String[] valsDes = registerMap.get("S" + (indexDes+i)).split(":");
                BigInteger[] bigIntegers1 = preCond.get(registerMap.get(sourceRegister1));

                for (int j = 0; j < valsDes.length; j++) {
                    preCond.put(valsDes[j], new BigInteger[]{
                            bigIntegers1[0],
                            bigIntegers1[1]
                            });
                }
            }

            // 设置临时变量
            desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
            // 设置Q
            StringBuilder qRegFrom = new StringBuilder().append(" mi(128, _:Int) => ");
            for (int i = 3; i >= 0; i--) {
                if (i > 0)
                    qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                else
                    qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
            }
            desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);

            proveObject.setPreCond(preCond);
            proveObject.setRegisterMap(registerMap);
            postCondition.add(desCond.toString());
        } catch (RuntimeException e) {
            e.printStackTrace();
        }
        return postCondition;
    }

    /**
     * VNEG Q Q
     * @return
     */
    public List<String> vnegQQPostSet() {
        List<String> postCondition = new ArrayList<>();
        try {
            if (instruction == null || instruction.getDestinationRegister() == null)
                throw new RuntimeException("指令或目标寄存器为空");
            if (sourcePostCond == null || sourcePostCond.isEmpty())
                sourcePostCond = new ArrayList<>();
            if (instruction.getSourceRegister() == null || instruction.getSourceRegister().isEmpty())
                throw new InputMismatchException("源操作数为空");
            String datatype = instruction.getDatatype();
            int size = Integer.parseInt(datatype.substring(1));
            Map<String, String> registerMap = proveObject.getRegisterMap();
            Map<String, BigInteger[]> preCond = proveObject.getPreCond();
            String desRegister = instruction.getDestinationRegister();
            StringBuilder desCond = preSet();
            sourcePostCond.clear();

            String sourceRegister1 = instruction.getSourceRegister().get(0);
            BigInteger dataLowerestBound = BigInteger.valueOf(2).pow(size - 1).multiply(BigInteger.valueOf(-1));
            BigInteger dataHighestBound = BigInteger.valueOf(2).pow(size - 1).subtract(BigInteger.ONE);
            if (desRegister.equals(sourceRegister1)) {
                List<StringBuilder> sListTo = new ArrayList<>();
                int indexDes = Integer.parseInt(desRegister.substring(1)) * 4;
                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (indexDes+i);
                    StringBuilder sRegFrom = conca(sReg1, 32 / size, size, new StringBuilder());

                    StringBuilder sRegToLeft = new StringBuilder();
                    String[] vals1 = registerMap.get(sReg1).split(":");
                    if (size == 32) {
                        sRegToLeft.append("\t\t\t\t\t")
                                .append("mi(32, -1 *Int svalueMInt(mi(32, " + registerMap.get(sReg1) + "))")
                                .append(")\n");
                    } else if (size == 16) {
                        sRegToLeft.append("\t\t\t\t\tconcatenateMInt(")
                                .append("mi(16, -1 *Int " + vals1[0])
                                .append("), ")
                                .append(preCond.get(vals1[1])[0].compareTo(BigInteger.ONE) <= 0 ?
                                        "mi(16, -1 *Int " + vals1[1] : "extractMInt(mi(32, -1 *Int " + vals1[1] + "), 16, 32")
                                .append("))\n");
                    } else if (size == 8) {
                        sRegToLeft.append("\t\t\t\t\tconcatenateMInt(")
                                .append("mi(8, -1 *Int " + vals1[0])
                                .append("), ")
                                .append("concatenateMInt(")
                                .append("mi(8, -1 *Int " + vals1[1])
                                .append("), ")
                                .append("concatenateMInt(")
                                .append("mi(8, -1 *Int " + vals1[2])
                                .append("), ")
                                .append(preCond.get(vals1[3])[0].compareTo(BigInteger.ONE) <= 0 ?
                                        "mi(8, -1 *Int " + vals1[3] : "extractMInt(mi(32, -1 *Int " + vals1[3] + "), 24, 32")
                                .append(")")
                                .append(")))\n");
                    }
                    sListTo.add(sRegToLeft);
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToLeft).append("\t\t\t\telse undefMInt32)\n");

                    // 重设目标寄存器的值范围

                    for (String s : vals1) {
                        BigInteger[] bigIntegers1 = preCond.get(s);

                        preCond.put(s, new BigInteger[]{
                                bigIntegers1[1].multiply(BigInteger.valueOf(-1)),
                                bigIntegers1[0].compareTo(dataLowerestBound) == 0 ?
                                        dataHighestBound :
                                        bigIntegers1[0].multiply(BigInteger.valueOf(-1))
                        });
                    }
                }
                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = conca(desRegister, 128 / size, size, new StringBuilder());
                qRegFrom.append(" => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            } else {
                int index1 = Integer.parseInt(sourceRegister1.substring(1)) * 4;
                setSourcePostCond(size, index1, sourceRegister1);
                postCondition.addAll(sourcePostCond);
                sourcePostCond.clear();
                // 设置S
                List<StringBuilder> sListTo = new ArrayList<>();
                int indexDes = Integer.parseInt(desRegister.substring(1)) * 4;
                // 若目标寄存器中无初始值，则在registerMap和preCondMap中设定一个初始值，相当于初始化
                // 命名规则为 vec + 当前向量寄存器的标识符 + '_' + set
                setVecDefaultPreCondAndRegisterMap(registerMap, preCond, desRegister, size, indexDes);

                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (index1+i);
                    StringBuilder sRegFrom = new StringBuilder().append("mi(32, _:Int)\n");

                    StringBuilder sRegToLeft = new StringBuilder();
                    String[] vals1 = registerMap.get(sReg1).split(":");
                    if (size == 32) {
                        sRegToLeft.append("\t\t\t\t\t")
                                .append("mi(32, -1 *Int svalueMInt(mi(32, " + registerMap.get(sReg1) + "))")
                                .append(")\n");
                    } else if (size == 16) {
                        sRegToLeft.append("\t\t\t\t\tconcatenateMInt(")
                                .append("mi(16, -1 *Int " + vals1[0])
                                .append("), ")
                                .append(preCond.get(vals1[1])[0].compareTo(BigInteger.ONE) <= 0 ?
                                        "mi(16, -1 *Int " + vals1[1] : "extractMInt(mi(32, -1 *Int " + vals1[1] + "), 16, 32")
                                .append("))\n");
                    } else if (size == 8) {
                        sRegToLeft.append("\t\t\t\t\tconcatenateMInt(")
                                .append("mi(8, -1 *Int " + vals1[0])
                                .append("), ")
                                .append("concatenateMInt(")
                                .append("mi(8, -1 *Int " + vals1[1])
                                .append("), ")
                                .append("concatenateMInt(")
                                .append("mi(8, -1 *Int " + vals1[2])
                                .append("), ")
                                .append(preCond.get(vals1[3])[0].compareTo(BigInteger.ONE) <= 0 ?
                                        "mi(8, -1 *Int " + vals1[3] : "extractMInt(mi(32, -1 *Int " + vals1[3] + "), 24, 32")
                                .append(")")
                                .append(")))\n");
                    }
                    sListTo.add(sRegToLeft);
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToLeft).append("\t\t\t\telse undefMInt32)\n");

                    // 重设目标寄存器的值范围
                    String[] valsDes = registerMap.get("S" + (indexDes+i)).split(":");

                    for (int j = 0; j < vals1.length; j++) {
                        BigInteger[] bigIntegers1 = preCond.get(vals1[j]);
                        //normalize(bigIntegers1, datatype, size);
                        //normalize(bigIntegers2, datatype, size);

                        preCond.put(valsDes[j], new BigInteger[]{
                                bigIntegers1[1].multiply(BigInteger.valueOf(-1)),
                                bigIntegers1[0].compareTo(dataLowerestBound) == 0 ?
                                        dataHighestBound :
                                        bigIntegers1[0].multiply(BigInteger.valueOf(-1))
                        });
                    }
                }

                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = new StringBuilder().append(" mi(128, _:Int) => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            }
            proveObject.setPreCond(preCond);
            proveObject.setRegisterMap(registerMap);
            postCondition.add(desCond.toString());
        } catch (RuntimeException e) {
            e.printStackTrace();
        }
        return postCondition;
    }

    /**
     * VSHR Q Imm
     * @return
     */
    public List<String> vshrQImmPostSet() {
        List<String> postCondition = new ArrayList<>();
        try {
            if (instruction == null || instruction.getDestinationRegister() == null)
                throw new RuntimeException("指令或目标寄存器为空");
            if (sourcePostCond == null || sourcePostCond.isEmpty())
                sourcePostCond = new ArrayList<>();
            if (instruction.getSourceRegister() == null || instruction.getSourceRegister().isEmpty())
                throw new InputMismatchException("源操作数为空");
            String datatype = instruction.getDatatype();
            int size = Integer.parseInt(datatype.substring(1));
            Map<String, String> registerMap = proveObject.getRegisterMap();
            Map<String, BigInteger[]> preCond = proveObject.getPreCond();
            String desRegister = instruction.getDestinationRegister();
            StringBuilder desCond = preSet();
            sourcePostCond.clear();

            String sourceRegister1 = instruction.getSourceRegister().get(0);
            String imm = instruction.getImm();
            String signMode = instruction.getDatatype().charAt(0) == 'S' ? "svalueMInt" : "uvalueMInt";
            if (desRegister.equals(sourceRegister1)) {
                List<StringBuilder> sListTo = new ArrayList<>();
                int indexDes = Integer.parseInt(desRegister.substring(1)) * 4;
                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (indexDes+i);
                    StringBuilder sRegFrom = conca(sReg1, 32 / size, size, new StringBuilder());

                    StringBuilder sRegToLeft = new StringBuilder();
                    String[] vals1 = registerMap.get(sReg1).split(":");
                    if (size == 32) {
                        sRegToLeft.append("\t\t\t\t\t")
                                .append("mi(32, " + signMode + "(mi(32, " + registerMap.get(sReg1) + "))")
                                .append(" >>Int ").append(imm)
                                .append(")\n");
                    } else if (size == 16) {
                        sRegToLeft.append("\t\t\t\t\tconcatenateMInt(")
                                .append("mi(16, " + signMode + "(mi(16, " + vals1[0] + "))")
                                .append(" >>Int ").append(imm).append("), ")
                                .append("mi(16, " + signMode + "(mi(16, " + vals1[1] + "))")
                                .append(" >>Int ").append(imm)
                                .append("))\n");
                    } else if (size == 8) {
                        sRegToLeft.append("\t\t\t\t\tconcatenateMInt(")
                                .append("mi(8, " + signMode + "(mi(8, " + vals1[0] + "))")
                                .append(" >>Int ").append(imm).append("), ")
                                .append("concatenateMInt(")
                                .append("mi(8, " + signMode + "(mi(8, " + vals1[1] + "))")
                                .append(" >>Int ").append(imm).append("), ")
                                .append("concatenateMInt(")
                                .append("mi(8, " + signMode + "(mi(8, " + vals1[2] + "))")
                                .append(" >>Int ").append(imm).append("), ")
                                .append("mi(8, " + signMode + "(mi(8, " + vals1[3] + "))")
                                .append(" >>Int ").append(imm).append(")")
                                .append(")))\n");
                    }
                    sListTo.add(sRegToLeft);
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToLeft).append("\t\t\t\telse undefMInt32)\n");

                    // 重设目标寄存器的值范围
                    BigInteger[] immRange = preCond.get(imm);
                    for (String s : vals1) {
                        BigInteger[] bigIntegers1 = preCond.get(s);

                        preCond.put(s, new BigInteger[]{
                                bigIntegers1[0].compareTo(BigInteger.ONE) >= 0 ?
                                        bigIntegers1[0].divide(BigInteger.valueOf(2).pow(Integer.parseInt(immRange[0].toString()))) :
                                        bigIntegers1[0].divide(BigInteger.valueOf(2).pow(Integer.parseInt(immRange[1].toString()))),
                                bigIntegers1[1].compareTo(BigInteger.ONE) >= 0 ?
                                        bigIntegers1[1].divide(BigInteger.valueOf(2).pow(Integer.parseInt(immRange[0].toString()))) :
                                        bigIntegers1[1].divide(BigInteger.valueOf(2).pow(Integer.parseInt(immRange[1].toString())))
                        });
                    }
                }
                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = conca(desRegister, 128 / size, size, new StringBuilder());
                qRegFrom.append(" => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            } else {
                int index1 = Integer.parseInt(sourceRegister1.substring(1)) * 4;
                setSourcePostCond(size, index1, sourceRegister1);
                postCondition.addAll(sourcePostCond);
                sourcePostCond.clear();
                // 设置S
                List<StringBuilder> sListTo = new ArrayList<>();
                int indexDes = Integer.parseInt(desRegister.substring(1)) * 4;
                // 若目标寄存器中无初始值，则在registerMap和preCondMap中设定一个初始值，相当于初始化
                // 命名规则为 vec + 当前向量寄存器的标识符 + '_' + set
                setVecDefaultPreCondAndRegisterMap(registerMap, preCond, desRegister, size, indexDes);

                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (index1+i);
                    StringBuilder sRegFrom = new StringBuilder().append("mi(32, _:Int)\n");

                    StringBuilder sRegToLeft = new StringBuilder();
                    String[] vals1 = registerMap.get(sReg1).split(":");
                    if (size == 32) {
                        sRegToLeft.append("\t\t\t\t\t")
                                .append("mi(32, " + signMode + "(mi(32, " + registerMap.get(sReg1) + "))")
                                .append(" >>Int ").append(imm)
                                .append(")\n");
                    } else if (size == 16) {
                        sRegToLeft.append("\t\t\t\t\tconcatenateMInt(")
                                .append("mi(16, " + signMode + "(mi(16, " + vals1[0] + "))")
                                .append(" >>Int ").append(imm).append("), ")
                                .append("mi(16, " + signMode + "(mi(16, " + vals1[1] + "))")
                                .append(" >>Int ").append(imm)
                                .append("))\n");
                    } else if (size == 8) {
                        sRegToLeft.append("\t\t\t\t\tconcatenateMInt(")
                                .append("mi(8, " + signMode + "(mi(8, " + vals1[0] + "))")
                                .append(" >>Int ").append(imm).append("), ")
                                .append("concatenateMInt(")
                                .append("mi(8, " + signMode + "(mi(8, " + vals1[1] + "))")
                                .append(" >>Int ").append(imm).append("), ")
                                .append("concatenateMInt(")
                                .append("mi(8, " + signMode + "(mi(8, " + vals1[2] + "))")
                                .append(" >>Int ").append(imm).append("), ")
                                .append("mi(8, " + signMode + "(mi(8, " + vals1[3] + "))")
                                .append(" >>Int ").append(imm).append(")")
                                .append(")))\n");
                    }
                    sListTo.add(sRegToLeft);
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToLeft).append("\t\t\t\telse undefMInt32)\n");

                    // 重设目标寄存器的值范围
                    String[] valsDes = registerMap.get("S" + (indexDes+i)).split(":");

                    BigInteger[] immRange = preCond.get(imm);
                    for (int j = 0; j < vals1.length; j++) {
                        BigInteger[] bigIntegers1 = preCond.get(valsDes[j]);

                        preCond.put(valsDes[j], new BigInteger[]{
                                bigIntegers1[0].compareTo(BigInteger.ONE) >= 0 ?
                                        bigIntegers1[0].divide(BigInteger.valueOf(2).pow(Integer.parseInt(immRange[0].toString()))) :
                                        bigIntegers1[0].divide(BigInteger.valueOf(2).pow(Integer.parseInt(immRange[1].toString()))),
                                bigIntegers1[1].compareTo(BigInteger.ONE) >= 0 ?
                                        bigIntegers1[1].divide(BigInteger.valueOf(2).pow(Integer.parseInt(immRange[0].toString()))) :
                                        bigIntegers1[1].divide(BigInteger.valueOf(2).pow(Integer.parseInt(immRange[1].toString())))
                        });
                    }
                }

                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = new StringBuilder().append(" mi(128, _:Int) => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            }
            proveObject.setPreCond(preCond);
            proveObject.setRegisterMap(registerMap);
            postCondition.add(desCond.toString());
        } catch (RuntimeException e) {
            e.printStackTrace();
        }
        return postCondition;
    }

    /**
     * VSHL Q Imm
     * @return
     */
    public List<String> vshlQImmPostSet() {
        List<String> postCondition = new ArrayList<>();
        try {
            if (instruction == null || instruction.getDestinationRegister() == null)
                throw new RuntimeException("指令或目标寄存器为空");
            if (sourcePostCond == null || sourcePostCond.isEmpty())
                sourcePostCond = new ArrayList<>();
            if (instruction.getSourceRegister() == null || instruction.getSourceRegister().isEmpty())
                throw new InputMismatchException("源操作数为空");
            String datatype = instruction.getDatatype();
            int size = Integer.parseInt(datatype.substring(1));
            Map<String, String> registerMap = proveObject.getRegisterMap();
            Map<String, BigInteger[]> preCond = proveObject.getPreCond();
            String desRegister = instruction.getDestinationRegister();
            StringBuilder desCond = preSet();
            sourcePostCond.clear();

            String sourceRegister1 = instruction.getSourceRegister().get(0);
            String imm = instruction.getImm();
            String signMode = instruction.getDatatype().charAt(0) == 'S' ? "svalueMInt" : "uvalueMInt";
            if (desRegister.equals(sourceRegister1)) {
                List<StringBuilder> sListTo = new ArrayList<>();
                int indexDes = Integer.parseInt(desRegister.substring(1)) * 4;
                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (indexDes+i);
                    StringBuilder sRegFrom = conca(sReg1, 32 / size, size, new StringBuilder());

                    StringBuilder sRegToLeft = new StringBuilder();
                    String[] vals1 = registerMap.get(sReg1).split(":");
                    if (size == 32) {
                        sRegToLeft.append("\t\t\t\t\t")
                                .append("mi(32, (" + signMode + "(mi(32, " + registerMap.get(sReg1) + "))")
                                .append(" <<Int ").append(imm).append(") &Int 4294967295")
                                .append(")\n");
                    } else if (size == 16) {
                        sRegToLeft.append("\t\t\t\t\tconcatenateMInt(")
                                .append("mi(16, (" + signMode + "(mi(16, " + vals1[0] + "))")
                                .append(" <<Int ").append(imm).append(") &Int 65535), ")
                                .append("mi(16, (" + signMode + "(mi(16, " + vals1[1] + "))")
                                .append(" <<Int ").append(imm).append(") &Int 65535)")
                                .append(")\n");
                    } else if (size == 8) {
                        sRegToLeft.append("\t\t\t\t\tconcatenateMInt(")
                                .append("mi(8, (" + signMode + "(mi(8, " + vals1[0] + "))")
                                .append(" <<Int ").append(imm).append(") &Int 255), ")
                                .append("concatenateMInt(")
                                .append("mi(8, (" + signMode + "(mi(8, " + vals1[1] + "))")
                                .append(" <<Int ").append(imm).append(") &Int 255), ")
                                .append("concatenateMInt(")
                                .append("mi(8, (" + signMode + "(mi(8, " + vals1[2] + "))")
                                .append(" <<Int ").append(imm).append(") &Int 255), ")
                                .append("mi(8, (" + signMode + "(mi(8, " + vals1[3] + "))")
                                .append(" <<Int ").append(imm).append(") &Int 255)")
                                .append(")))\n");
                    }
                    sListTo.add(sRegToLeft);
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToLeft).append("\t\t\t\telse undefMInt32)\n");

                    // 重设目标寄存器的值范围
                    BigInteger[] immRange = preCond.get(imm);
                    int immLeft = Integer.parseInt(immRange[0].toString());
                    int immRight = Integer.parseInt(immRange[1].toString());
                    for (String s : vals1) {
                        BigInteger[] bigIntegers1 = preCond.get(s);
                        normalize(bigIntegers1, datatype, size);
                        BigInteger[] desRange = getVSHLRange(datatype, bigIntegers1, size, immLeft, immRight);

                        preCond.put(s, desRange);
                    }
                }
                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = conca(desRegister, 128 / size, size, new StringBuilder());
                qRegFrom.append(" => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            } else {
                int index1 = Integer.parseInt(sourceRegister1.substring(1)) * 4;
                setSourcePostCond(size, index1, sourceRegister1);
                postCondition.addAll(sourcePostCond);
                sourcePostCond.clear();
                // 设置S
                List<StringBuilder> sListTo = new ArrayList<>();
                int indexDes = Integer.parseInt(desRegister.substring(1)) * 4;
                // 若目标寄存器中无初始值，则在registerMap和preCondMap中设定一个初始值，相当于初始化
                // 命名规则为 vec + 当前向量寄存器的标识符 + '_' + set
                setVecDefaultPreCondAndRegisterMap(registerMap, preCond, desRegister, size, indexDes);

                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (index1+i);
                    StringBuilder sRegFrom = new StringBuilder().append("mi(32, _:Int)\n");

                    StringBuilder sRegToLeft = new StringBuilder();
                    String[] vals1 = registerMap.get(sReg1).split(":");
                    if (size == 32) {
                        sRegToLeft.append("\t\t\t\t\t")
                                .append("mi(32, (" + signMode + "(mi(32, " + registerMap.get(sReg1) + "))")
                                .append(" <<Int ").append(imm).append(") &Int 4294967295")
                                .append(")\n");
                    } else if (size == 16) {
                        sRegToLeft.append("\t\t\t\t\tconcatenateMInt(")
                                .append("mi(16, (" + signMode + "(mi(16, " + vals1[0] + "))")
                                .append(" <<Int ").append(imm).append(") &Int 65535), ")
                                .append("mi(16, (" + signMode + "(mi(16, " + vals1[1] + "))")
                                .append(" <<Int ").append(imm).append(") &Int 65535)")
                                .append(")\n");
                    } else if (size == 8) {
                        sRegToLeft.append("\t\t\t\t\tconcatenateMInt(")
                                .append("mi(8, (" + signMode + "(mi(8, " + vals1[0] + "))")
                                .append(" <<Int ").append(imm).append(") &Int 255), ")
                                .append("concatenateMInt(")
                                .append("mi(8, (" + signMode + "(mi(8, " + vals1[1] + "))")
                                .append(" <<Int ").append(imm).append(") &Int 255), ")
                                .append("concatenateMInt(")
                                .append("mi(8, (" + signMode + "(mi(8, " + vals1[2] + "))")
                                .append(" <<Int ").append(imm).append(") &Int 255), ")
                                .append("mi(8, (" + signMode + "(mi(8, " + vals1[3] + "))")
                                .append(" <<Int ").append(imm).append(") &Int 255)")
                                .append(")))\n");
                    }
                    sListTo.add(sRegToLeft);
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToLeft).append("\t\t\t\telse undefMInt32)\n");

                    // 重设目标寄存器的值范围
                    String[] valsDes = registerMap.get("S" + (indexDes+i)).split(":");
                    // 重设目标寄存器的值范围
                    BigInteger[] immRange = preCond.get(imm);
                    int immLeft = Integer.parseInt(immRange[0].toString());
                    int immRight = Integer.parseInt(immRange[1].toString());
                    for (int j = 0; j < vals1.length; j++) {
                        BigInteger[] bigIntegers1 = preCond.get(vals1[j]);
                        normalize(bigIntegers1, datatype, size);
                        BigInteger[] desRange = getVSHLRange(datatype, bigIntegers1, size, immLeft, immRight);

                        preCond.put(valsDes[j], desRange);
                    }
                }

                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = new StringBuilder().append(" mi(128, _:Int) => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            }
            proveObject.setPreCond(preCond);
            proveObject.setRegisterMap(registerMap);
            postCondition.add(desCond.toString());
        } catch (RuntimeException e) {
            e.printStackTrace();
        }
        return postCondition;
    }


    private BigInteger[] getVSHLRange(String datatype, BigInteger[] bigIntegers1, int size, int immLeft, int immRight) {
        BigInteger[] desRange = new BigInteger[2];
        if (datatype.charAt(0) == 'S') {
            BigInteger pow = BigInteger.valueOf(2).pow(size - immRight - 1);
            BigInteger bigInteger = BigInteger.valueOf(2).pow(size - immLeft - 1);
            BigInteger subtract = BigInteger.valueOf(2).pow(size - 1).subtract(BigInteger.ONE);
            if (bigIntegers1[0].compareTo(BigInteger.ONE) < 0) {
                BigInteger multiply = BigInteger.valueOf(2).pow(size - 1).multiply(BigInteger.valueOf(-1));
                if (bigIntegers1[0].compareTo(
                        pow.multiply(BigInteger.valueOf(-1))) > 0) {
                    desRange[0] = bigIntegers1[0].multiply(BigInteger.valueOf(2).pow(immRight));
                } else {
                    desRange[0] = multiply;
                }
                if (bigIntegers1[1].compareTo(BigInteger.ONE) < 0) {
                    if (bigIntegers1[1].compareTo(
                            bigInteger.multiply(BigInteger.valueOf(-1))) > 0) {
                        desRange[1] = bigIntegers1[1].multiply(BigInteger.valueOf(2).pow(immLeft));
                    } else {
                        desRange[1] = multiply;
                    }
                } else {
                    if (bigIntegers1[1].compareTo(
                            pow) < 0) {
                        desRange[1] = bigIntegers1[1].multiply(BigInteger.valueOf(2).pow(immRight));
                    } else {
                        desRange[1] = subtract;
                    }
                }
            } else {
                if (bigIntegers1[0].compareTo(
                        bigInteger) < 0) {
                    desRange[0] = bigIntegers1[0].multiply(BigInteger.valueOf(2).pow(immLeft));
                    if (bigIntegers1[1].compareTo(pow) < 0) {
                        desRange[1] = bigIntegers1[1].multiply(BigInteger.valueOf(2).pow(immRight));
                    } else {
                        desRange[1] = subtract;
                    }
                } else {
                    desRange[0] = BigInteger.ZERO;
                    desRange[1] = BigInteger.ZERO;
                }
            }
        } else {
            // 无符号
            if (bigIntegers1[0].compareTo(
                    BigInteger.valueOf(2).pow(size - immLeft)) < 0) {
                desRange[0] = bigIntegers1[0].multiply(BigInteger.valueOf(2).pow(immLeft));
                if (bigIntegers1[1].compareTo(
                        BigInteger.valueOf(2).pow(size - immRight)) < 0) {
                    desRange[1] = bigIntegers1[1].multiply(BigInteger.valueOf(2).pow(immRight)).subtract(BigInteger.ONE);
                } else {
                    desRange[1] = BigInteger.valueOf(2).pow(immRight).subtract(BigInteger.ONE);
                }
            } else {
                desRange[0] = BigInteger.ZERO;
                desRange[1] = BigInteger.ZERO;
            }
        }
        return desRange;
    }

    /**
     * VRSHL Q Q
     * @return
     */
    public List<String> vrshlQQPostSet() {
        List<String> postCondition = new ArrayList<>();
        try {
            if (instruction == null || instruction.getDestinationRegister() == null)
                throw new RuntimeException("指令或目标寄存器为空");
            if (sourcePostCond == null || sourcePostCond.isEmpty())
                sourcePostCond = new ArrayList<>();
            if (instruction.getSourceRegister() == null || instruction.getSourceRegister().isEmpty())
                throw new InputMismatchException("源操作数为空");
            String datatype = instruction.getDatatype();
            int size = Integer.parseInt(datatype.substring(1));
            Map<String, String> registerMap = proveObject.getRegisterMap();
            Map<String, BigInteger[]> preCond = proveObject.getPreCond();
            String desRegister = instruction.getDestinationRegister();
            StringBuilder desCond = preSet();
            sourcePostCond.clear();

            String sourceRegister1 = instruction.getSourceRegister().get(0);
            String sourceRegister2 = instruction.getSourceRegister().get(1);
            int indexDes = Integer.parseInt(desRegister.substring(1)) * 4;
            String signMode = instruction.getDatatype().charAt(0) == 'S' ? "svalueMInt" : "uvalueMInt";
            // 第一个源操作数同时为目标操作数
            if (desRegister.equals(sourceRegister1)) {
                int index = Integer.parseInt(sourceRegister2.substring(1)) * 4;
                // 源操作数初始
                setSourcePostCond(size, index, sourceRegister2);
                postCondition.addAll(sourcePostCond);
                sourcePostCond.clear();
                List<StringBuilder> sListTo = new ArrayList<>();
                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (indexDes+i);
                    String sReg2 = "S" + (index+i);
                    StringBuilder sRegFrom = conca(sReg1, 32 / size, size, new StringBuilder());

                    StringBuilder sRegToLeft = new StringBuilder();
                    String[] vals1 = registerMap.get(sReg1).split(":");
                    String[] vals2 = registerMap.get(sReg2).split(":");
                    getVRSHLSub(size, sRegToLeft, signMode, vals1, vals2);
                    sListTo.add(sRegToLeft);
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToLeft).append("\t\t\t\telse undefMInt32)\n");

                    for (int j = 0; j < vals1.length; j++) {
                        BigInteger[] bigIntegers1 = preCond.get(vals1[j]);
                        BigInteger[] bigIntegers2 = preCond.get(vals2[j]);
                        normalize(bigIntegers1, datatype, size);
                        normalize(bigIntegers2, datatype, size);
                        BigInteger[] desRange = getVRSHLRange(bigIntegers1, bigIntegers2);
                        preCond.put(vals1[j], desRange);
                    }
                }
                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = conca(desRegister, 128 / size, size, new StringBuilder());
                qRegFrom.append(" => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            } else if (desRegister.equals(sourceRegister2)) {   // 第二个源操作数同时为目标操作数
                int index = Integer.parseInt(sourceRegister1.substring(1)) * 4;
                // 源操作数初始
                setSourcePostCond(size, index, sourceRegister1);
                postCondition.addAll(sourcePostCond);
                sourcePostCond.clear();
                List<StringBuilder> sListTo = new ArrayList<>();
                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (index+i);
                    String sReg2 = "S" + (indexDes+i);
                    StringBuilder sRegFrom = conca(sReg2, 32 / size, size, new StringBuilder());

                    StringBuilder sRegToLeft = new StringBuilder();
                    String[] vals1 = registerMap.get(sReg1.toString()).split(":");
                    String[] vals2 = registerMap.get(sReg2.toString()).split(":");
                    getVRSHLSub(size, sRegToLeft, signMode, vals1, vals2);
                    sListTo.add(sRegToLeft);
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToLeft).append("\t\t\t\telse undefMInt32)\n");

                    for (int j = 0; j < vals1.length; j++) {
                        BigInteger[] bigIntegers1 = preCond.get(vals1[j]);
                        BigInteger[] bigIntegers2 = preCond.get(vals2[j]);
                        normalize(bigIntegers1, datatype, size);
                        normalize(bigIntegers2, datatype, size);
                        BigInteger[] desRange = getVRSHLRange(bigIntegers1, bigIntegers2);
                        preCond.put(vals2[j], desRange);
                    }
                }
                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = conca(desRegister, 128 / size, size, new StringBuilder());
                qRegFrom.append(" => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            } else {
                int index1 = Integer.parseInt(sourceRegister1.substring(1)) * 4;
                int index2 = Integer.parseInt(sourceRegister2.substring(1)) * 4;
                setSourcePostCond(size, index1, sourceRegister1);
                postCondition.addAll(sourcePostCond);
                sourcePostCond.clear();
                setSourcePostCond(size, index2, sourceRegister2);
                postCondition.addAll(sourcePostCond);
                sourcePostCond.clear();
                // 设置S
                List<StringBuilder> sListTo = new ArrayList<>();
                // 若目标寄存器中无初始值，则在registerMap和preCondMap中设定一个初始值，相当于初始化
                // 命名规则为 vec + 当前向量寄存器的标识符 + '_' + set
                setVecDefaultPreCondAndRegisterMap(registerMap, preCond, desRegister, size, indexDes);

                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (index1+i);
                    String sReg2 = "S" + (index2+i);
                    StringBuilder sRegFrom = new StringBuilder().append("mi(32, _:Int)\n");

                    StringBuilder sRegToLeft = new StringBuilder();
                    String[] vals1 = registerMap.get(sReg1).split(":");
                    String[] vals2 = registerMap.get(sReg2).split(":");
                    getVRSHLSub(size, sRegToLeft, signMode, vals1, vals2);
                    sListTo.add(sRegToLeft);
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToLeft).append("\t\t\t\telse undefMInt32)\n");

                    // 重设目标寄存器的值范围
                    String[] valsDes = registerMap.get("S" + (indexDes+i)).split(":");

                    for (int j = 0; j < vals1.length; j++) {
                        BigInteger[] bigIntegers1 = preCond.get(vals1[j]);
                        BigInteger[] bigIntegers2 = preCond.get(vals2[j]);
                        normalize(bigIntegers1, datatype, size);
                        normalize(bigIntegers2, datatype, size);
                        BigInteger[] desRange = getVRSHLRange(bigIntegers1, bigIntegers2);
                        preCond.put(valsDes[j], desRange);
                    }
                }

                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = new StringBuilder().append(" mi(128, _:Int) => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            }
            proveObject.setPreCond(preCond);
            proveObject.setRegisterMap(registerMap);
            postCondition.add(desCond.toString());
        } catch (RuntimeException e) {
            e.printStackTrace();
        }
        return postCondition;
    }

    private void getVRSHLSub(int size, StringBuilder sRegToLeft, String signMode, String[] vals1, String[] vals2) {
        if (size == 32) {
            String sub = "svalueMInt(extractMInt(mi(32, " + vals2[0] + "), 24, 32))";
            sRegToLeft.append("\t\t\t\t\t")
                    .append("ifMInt (").append(sub).append(" >=Int 0) then ")
                    .append("mi(32, (" + signMode + "(mi(32, " + vals1[0] + ")) <<Int ")
                    .append(sub).append(") &Int 4294967295) ")
                    .append(" else ")
                    .append("mi(32, ((" + signMode + "(mi(32, " + vals1[0] + ")) +Int ")
                    .append("(1 <<Int (-1 *Int ").append(sub).append(" -Int 1))) >>Int ")
                    .append("(-1 *Int ").append(sub).append(")) &Int 4294967295)")
                    .append("\n");
        } else if (size == 16) {
            String sub = "svalueMInt(extractMInt(mi(16, ";
            sRegToLeft.append("\t\t\t\t\t")
                    .append("concatenateMInt(")
                    .append("ifMInt (").append(sub).append(vals2[0]).append("), 8, 16)) >=Int 0) then ")
                    .append("mi(16, (" + signMode + "(mi(16, " + vals1[0] + ")) <<Int ")
                    .append(sub).append(vals2[0]).append("), 8, 16))) &Int 65535) ")
                    .append(" else ")
                    .append("mi(16, ((" + signMode + "(mi(16, " + vals1[0] + ")) +Int ")
                    .append("(1 <<Int (-1 *Int ").append(sub).append(vals2[0]).append("), 8, 16)) -Int 1))) >>Int ")
                    .append("(-1 *Int ").append(sub).append(vals2[0]).append("), 8, 16)))) &Int 65535), ")
                    .append("ifMInt (").append(sub).append(vals2[1]).append("), 8, 16)) >=Int 0) then ")
                    .append("mi(16, (" + signMode + "(mi(16, " + vals1[1] + ")) <<Int ")
                    .append(sub).append(vals2[1]).append("), 8, 16))) &Int 65535) ")
                    .append(" else ")
                    .append("mi(16, ((" + signMode + "(mi(16, " + vals1[1] + ")) +Int ")
                    .append("(1 <<Int (-1 *Int ").append(sub).append(vals2[1]).append("), 8, 16)) -Int 1))) >>Int ")
                    .append("(-1 *Int ").append(sub).append(vals2[1]).append("), 8, 16)))) &Int 65535)")
                    .append(")\n");
        } else if (size == 8) {
            String sub = "svalueMInt(mi(8, ";
            sRegToLeft.append("\t\t\t\t\t")
                    .append("concatenateMInt(")
                    .append("ifMInt (").append(sub).append(vals2[0]).append(")) >=Int 0) then ")
                    .append("mi(8, (" + signMode + "(mi(8, " + vals1[0] + ")) <<Int ")
                    .append(sub).append(vals2[0]).append("))) &Int 255) ")
                    .append(" else ")
                    .append("mi(8, ((" + signMode + "(mi(8, " + vals1[0] + ")) +Int ")
                    .append("(1 <<Int (-1 *Int ").append(sub).append(vals2[0]).append(")) -Int 1))) >>Int ")
                    .append("(-1 *Int ").append(sub).append(vals2[0]).append(")))) &Int 255), ")
                    .append("concatenateMInt(")
                    .append("ifMInt (").append(sub).append(vals2[1]).append(")) >=Int 0) then ")
                    .append("mi(8, (" + signMode + "(mi(8, " + vals1[1] + ")) <<Int ")
                    .append(sub).append(vals2[1]).append("))) &Int 255) ")
                    .append(" else ")
                    .append("mi(8, ((" + signMode + "(mi(8, " + vals1[1] + ")) +Int ")
                    .append("(1 <<Int (-1 *Int ").append(sub).append(vals2[1]).append(")) -Int 1))) >>Int ")
                    .append("(-1 *Int ").append(sub).append(vals2[1]).append(")))) &Int 255), ")
                    .append("concatenateMInt(")
                    .append("ifMInt (").append(sub).append(vals2[2]).append(")) >=Int 0) then ")
                    .append("mi(8, (" + signMode + "(mi(8, " + vals1[2] + ")) <<Int ")
                    .append(sub).append(vals2[2]).append("))) &Int 255) ")
                    .append(" else ")
                    .append("mi(8, ((" + signMode + "(mi(8, " + vals1[2] + ")) +Int ")
                    .append("(1 <<Int (-1 *Int ").append(sub).append(vals2[2]).append(")) -Int 1))) >>Int ")
                    .append("(-1 *Int ").append(sub).append(vals2[2]).append(")))) &Int 255), ")
                    .append("ifMInt (").append(sub).append(vals2[3]).append(")) >=Int 0) then ")
                    .append("mi(8, (" + signMode + "(mi(8, " + vals1[3] + ")) <<Int ")
                    .append(sub).append(vals2[3]).append("))) &Int 255) ")
                    .append(" else ")
                    .append("mi(8, ((" + signMode + "(mi(8, " + vals1[3] + ")) +Int ")
                    .append("(1 <<Int (-1 *Int ").append(sub).append(vals2[3]).append(")) -Int 1))) >>Int ")
                    .append("(-1 *Int ").append(sub).append(vals2[3]).append(")))) &Int 255)")
                    .append(")))\n");
        }
    }

    /**
     * VMLA Q R
     * @return
     */
    public List<String> vmlaQRPostSet() {
        List<String> postCondition = new ArrayList<>();
        try {
            if (instruction == null || instruction.getDestinationRegister() == null)
                throw new RuntimeException("指令或目标寄存器为空");
            if (sourcePostCond == null || sourcePostCond.isEmpty())
                sourcePostCond = new ArrayList<>();
            if (instruction.getSourceRegister() == null || instruction.getSourceRegister().isEmpty())
                throw new InputMismatchException("源操作数为空");
            String datatype = instruction.getDatatype();
            int size = Integer.parseInt(datatype.substring(1));
            Map<String, String> registerMap = proveObject.getRegisterMap();
            Map<String, BigInteger[]> preCond = proveObject.getPreCond();
            String desRegister = instruction.getDestinationRegister();
            StringBuilder desCond = preSet();
            sourcePostCond.clear();

            String signMode = datatype.charAt(0) == 'S' ? "svalueMInt" : "uvalueMInt";
            String sourceRegister1 = instruction.getSourceRegister().get(0);
            String sourceRegister2 = instruction.getSourceRegister().get(1);
            String val = registerMap.get(sourceRegister2);
            desCond.append("\t\t\t\"").append(sourceRegister2).append("\" |-> ").append("mi(32, ")
                    .append(val).append(")\n");
            if (desRegister.equals(sourceRegister1)) {
                List<StringBuilder> sListTo = new ArrayList<>();
                int indexDes = Integer.parseInt(desRegister.substring(1)) * 4;
                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (indexDes+i);
                    StringBuilder sRegFrom = conca(sReg1, 32 / size, size, new StringBuilder());

                    StringBuilder sRegToLeft = new StringBuilder();
                    String[] vals1 = registerMap.get(sReg1).split(":");
                    getVMLASub(size, signMode, val, vals1, vals1, sRegToLeft);
                    sListTo.add(sRegToLeft);
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToLeft).append("\t\t\t\telse undefMInt32)\n");

                    // 重设目标寄存器的值范围
                    BigInteger[] bigIntegers2 = preCond.get(registerMap.get(sourceRegister2));
                    normalize(bigIntegers2, datatype, size);

                    for (String s : vals1) {
                        BigInteger[] bigIntegers1 = preCond.get(s);
                        normalize(bigIntegers1, datatype, size);
                        BigInteger[] mulRange = getMULRange(bigIntegers1, bigIntegers2, datatype);
                        preCond.put(s, new BigInteger[]{
                                bigIntegers1[0].add(mulRange[0]),
                                bigIntegers1[1].add(mulRange[1])
                        });
                    }
                }
                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = conca(desRegister, 128 / size, size, new StringBuilder());
                qRegFrom.append(" => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            } else {
                int index1 = Integer.parseInt(sourceRegister1.substring(1)) * 4;
                setSourcePostCond(size, index1, sourceRegister1);
                postCondition.addAll(sourcePostCond);
                // 设置S
                List<StringBuilder> sListTo = new ArrayList<>();
                int indexDes = Integer.parseInt(desRegister.substring(1)) * 4;
                // 若目标寄存器中无初始值，则在registerMap和preCondMap中设定一个初始值，相当于初始化
                // 命名规则为 vec + 当前向量寄存器的标识符 + '_' + set
                setVecDefaultPreCondAndRegisterMap(registerMap, preCond, desRegister, size, indexDes);

                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (index1+i);
                    String sReg2 = "S" + (indexDes + i);

                    StringBuilder sRegToLeft = new StringBuilder();
                    String[] vals1 = registerMap.get(sReg1).split(":");
                    String[] vals2 = registerMap.get(sReg2).split(":");
                    //String sRegFrom = "mi(32, " + vals2[i] + ")\n";
                    StringBuilder sRegFrom = conca(sReg2, 32 / size, size, new StringBuilder());
                    getVMLASub(size, signMode, val, vals1, vals2, sRegToLeft);
                    sListTo.add(sRegToLeft);
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToLeft).append("\t\t\t\telse undefMInt32)\n");

                    // 重设目标寄存器的值范围
                    BigInteger[] bigIntegers2 = preCond.get(registerMap.get(sourceRegister2));
                    normalize(bigIntegers2, datatype, size);
                    String[] valsDes = registerMap.get("S" + (indexDes+i)).split(":");

                    for (int j = 0; j < vals1.length; j++) {
                        BigInteger[] bigIntegers1 = preCond.get(vals1[j]);
                        BigInteger[] bigIntegersDes = preCond.get(valsDes[j]);
                        normalize(bigIntegers1, datatype, size);
                        normalize(bigIntegersDes, datatype, size);
                        BigInteger[] mulRange = getMULRange(bigIntegers1, bigIntegers2, datatype);
                        preCond.put(valsDes[j], new BigInteger[]{
                                mulRange[0].add(bigIntegersDes[0]),
                                mulRange[1].add(bigIntegersDes[1])
                        });
                    }
                }

                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = new StringBuilder().append(" mi(128, _:Int) => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            }
            proveObject.setPreCond(preCond);
            proveObject.setRegisterMap(registerMap);
            postCondition.add(desCond.toString());
        } catch (RuntimeException e) {
            e.printStackTrace();
        }
        return postCondition;
    }

    private void setVecDefaultPreCondAndRegisterMap(Map<String, String> registerMap, Map<String, BigInteger[]> preCond,
                                                    String desRegister, int size, int indexDes) {
        if (!registerMap.containsKey(desRegister)) {
            String valNew = "V" + desRegister + "_set";
            registerMap.put(desRegister, valNew);
            preCond.put(valNew, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
            valNew = size == 32 ? valNew : (size == 16 ? valNew + "0" : valNew + "00");
            for (int i = 0; i < 4; i++) {
                if (size == 8) {
                    String tmp1 = valNew + (i * 4);
                    String tmp2 = valNew + (i * 4 + 1);
                    String tmp3 = valNew + (i * 4 + 2);
                    String tmp4 = valNew + (i * 4 + 3);
                    registerMap.put("S" + (indexDes + i), tmp4 + ":" + tmp3 + ":" + tmp2 + ":" + tmp1);
                    preCond.put(tmp1, new BigInteger[]{BigInteger.ZERO, BigInteger.ZERO});
                    preCond.put(tmp2, new BigInteger[]{BigInteger.ZERO, BigInteger.ZERO});
                    preCond.put(tmp3, new BigInteger[]{BigInteger.ZERO, BigInteger.ZERO});
                    preCond.put(tmp4, new BigInteger[]{BigInteger.ZERO, BigInteger.ZERO});
                } else if (size == 16) {
                    String tmp1 = valNew + (i * 2);
                    String tmp2 = valNew + (i * 2 + 1);
                    registerMap.put("S" + (indexDes + i), tmp2 + ":" + tmp1);
                    preCond.put(tmp1, new BigInteger[]{BigInteger.ZERO, BigInteger.ZERO});
                    preCond.put(tmp2, new BigInteger[]{BigInteger.ZERO, BigInteger.ZERO});
                } else if (size == 32) {
                    String tmp = valNew + i;
                    registerMap.put("S" + (indexDes + i), tmp);
                    preCond.put(tmp, new BigInteger[]{BigInteger.ZERO, BigInteger.ZERO});
                }
            }
        } else {
            int len = registerMap.get("S" + indexDes).split(":").length;
            if (len != 32 / size) {
                String valNew = registerMap.get(desRegister);
                for (int i = 0; i < 4; i++) {
                    if (size == 8) {
                        String tmp1 = valNew + (i * 4);
                        String tmp2 = valNew + (i * 4 + 1);
                        String tmp3 = valNew + (i * 4 + 2);
                        String tmp4 = valNew + (i * 4 + 3);
                        registerMap.put("S" + (indexDes + i), tmp4 + ":" + tmp3 + ":" + tmp2 + ":" + tmp1);
                        preCond.put(tmp1, new BigInteger[]{BigInteger.ZERO, BigInteger.ZERO});
                        preCond.put(tmp2, new BigInteger[]{BigInteger.ZERO, BigInteger.ZERO});
                        preCond.put(tmp3, new BigInteger[]{BigInteger.ZERO, BigInteger.ZERO});
                        preCond.put(tmp4, new BigInteger[]{BigInteger.ZERO, BigInteger.ZERO});
                    } else if (size == 16) {
                        String tmp1 = valNew + (i * 2);
                        String tmp2 = valNew + (i * 2 + 1);
                        registerMap.put("S" + (indexDes + i), tmp2 + ":" + tmp1);
                        preCond.put(tmp1, new BigInteger[]{BigInteger.ZERO, BigInteger.ZERO});
                        preCond.put(tmp2, new BigInteger[]{BigInteger.ZERO, BigInteger.ZERO});
                    } else if (size == 32) {
                        String tmp = valNew + i;
                        registerMap.put("S" + (indexDes + i), tmp);
                        preCond.put(tmp, new BigInteger[]{BigInteger.ZERO, BigInteger.ZERO});
                    }
                }
            }
        }
    }

    private void getVMLASub(int size, String signMode, String val, String[] vals1, String[] vals2, StringBuilder sRegToLeft) {
        if (size == 32) {
            sRegToLeft.append("\t\t\t\t\t")
                    .append("extractMInt(mi(64, ").append(signMode).append("(mi(32, ").append(vals1[0])
                    .append(")) *Int ").append(signMode).append("(mi(32, ").append(val).append("))")
                    .append(" +Int ").append(signMode).append("(mi(32, ").append(vals2[0])
                    .append("))), 32, 64)\n");
        } else if (size == 16) {
            sRegToLeft.append("\t\t\t\t\t")
                    .append("concatenateMInt(")
                    .append("extractMInt(mi(32, ").append(signMode).append("(mi(16, ").append(vals1[0])
                    .append(")) *Int ").append(signMode).append("(extractMInt(mi(32, ").append(val)
                    .append("), 16, 32))")
                    .append(" +Int ").append(signMode).append("(mi(16, ").append(vals2[0])
                    .append("))), 16, 32), ")
                    .append("extractMInt(mi(32, ").append(signMode).append("(mi(16, ").append(vals1[1])
                    .append(")) *Int ").append(signMode).append("(extractMInt(mi(32, ").append(val)
                    .append("), 16, 32))")
                    .append(" +Int ").append(signMode).append("(mi(16, ").append(vals2[1])
                    .append("))), 16, 32)")
                    .append(")\n");
        } else if (size == 8) {
            sRegToLeft.append("\t\t\t\t\t")
                    .append("concatenateMInt(")
                    .append("extractMInt(mi(16, ").append(signMode).append("(mi(8, ").append(vals1[0])
                    .append(")) *Int ").append(signMode).append("(extractMInt(mi(32, ").append(val)
                    .append("), 24, 32))")
                    .append(" +Int ").append(signMode).append("(mi(8, ").append(vals2[0])
                    .append("))), 8, 16), ")
                    .append("concatenateMInt(")
                    .append("extractMInt(mi(16, ").append(signMode).append("(mi(8, ").append(vals1[1])
                    .append(")) *Int ").append(signMode).append("(extractMInt(mi(32, ").append(val)
                    .append("), 24, 32))")
                    .append(" +Int ").append(signMode).append("(mi(8, ").append(vals2[1])
                    .append("))), 8, 16), ")
                    .append("concatenateMInt(")
                    .append("extractMInt(mi(16, ").append(signMode).append("(mi(8, ").append(vals1[2])
                    .append(")) *Int ").append(signMode).append("(extractMInt(mi(32, ").append(val)
                    .append("), 24, 32))")
                    .append(" +Int ").append(signMode).append("(mi(8, ").append(vals2[2])
                    .append("))), 8, 16), ")
                    .append("extractMInt(mi(16, ").append(signMode).append("(mi(8, ").append(vals1[3])
                    .append(")) *Int ").append(signMode).append("(extractMInt(mi(32, ").append(val)
                    .append("), 24, 32))")
                    .append(" +Int ").append(signMode).append("(mi(8, ").append(vals2[3])
                    .append("))), 8, 16)")
                    .append(")))\n");
        }
    }

    /**
     * VQADD Q Q
     * @return
     */
    public List<String> vqaddQQPostSet() {
        List<String> postCondition = new ArrayList<>();
        try {
            if (instruction == null || instruction.getDestinationRegister() == null)
                throw new RuntimeException("指令或目标寄存器为空");
            if (sourcePostCond == null || sourcePostCond.isEmpty())
                sourcePostCond = new ArrayList<>();
            if (instruction.getSourceRegister() == null || instruction.getSourceRegister().isEmpty())
                throw new InputMismatchException("源操作数为空");
            String datatype = instruction.getDatatype();
            int size = Integer.parseInt(datatype.substring(1));
            Map<String, String> registerMap = proveObject.getRegisterMap();
            Map<String, BigInteger[]> preCond = proveObject.getPreCond();
            String desRegister = instruction.getDestinationRegister();
            StringBuilder desCond = preSet();
            sourcePostCond.clear();

            String signMode = datatype.charAt(0) == 'S' ? "svalueMInt" : "uvalueMInt";
            String sourceRegister1 = instruction.getSourceRegister().get(0);
            String sourceRegister2 = instruction.getSourceRegister().get(1);
            int indexDes = Integer.parseInt(desRegister.substring(1)) * 4;
            // 第一个源操作数同时为目标操作数
            if (desRegister.equals(sourceRegister1)) {
                int index = Integer.parseInt(sourceRegister2.substring(1)) * 4;
                // 源操作数初始
                setSourcePostCond(size, index, sourceRegister2);
                postCondition.addAll(sourcePostCond);
                sourcePostCond.clear();
                List<StringBuilder> sListTo = new ArrayList<>();
                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (indexDes+i);
                    String sReg2 = "S" + (index+i);
                    StringBuilder sRegFrom = conca(sReg1, 32 / size, size, new StringBuilder());

                    StringBuilder sRegToLeft = new StringBuilder();
                    String[] vals1 = registerMap.get(sReg1).split(":");
                    String[] vals2 = registerMap.get(sReg2).split(":");
                    // 修改sRegToLeft
                    getVQADDsRegToLeft(size, signMode, datatype, vals1, vals2, sRegToLeft);
                    sListTo.add(sRegToLeft);
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToLeft).append("\t\t\t\telse undefMInt32)\n");

                    if (i == 3) {
                        getVQADDFPSCR(size, signMode, datatype, desCond, vals1, vals2);
                    }
                    BigInteger[] cmpRange = new BigInteger[2];
                    if (datatype.charAt(0) == 'S') {
                        cmpRange[0] = BigInteger.valueOf(-1 * (1L << (size-1)));
                        cmpRange[1] = BigInteger.valueOf(1L << (size-1));
                    } else {
                        cmpRange[0] = BigInteger.ZERO;
                        cmpRange[1] = BigInteger.valueOf(1L << size);
                    }
                    for (int j = 0; j < vals1.length; j++) {
                        BigInteger[] bigIntegers1 = preCond.get(vals1[j]);
                        BigInteger[] bigIntegers2 = preCond.get(vals2[j]);
                        normalize(bigIntegers1, datatype, size);
                        normalize(bigIntegers2, datatype, size);
                        BigInteger[] desRange = getVQADDDesRange(bigIntegers1, bigIntegers2, cmpRange);
                        preCond.put(vals1[j], desRange);
                    }
                }
                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = conca(desRegister, 128 / size, size, new StringBuilder());
                qRegFrom.append(" => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            } else if (desRegister.equals(sourceRegister2)) {   // 第二个源操作数同时为目标操作数
                int index = Integer.parseInt(sourceRegister1.substring(1)) * 4;
                // 源操作数初始
                setSourcePostCond(size, index, sourceRegister1);
                postCondition.addAll(sourcePostCond);
                sourcePostCond.clear();
                List<StringBuilder> sListTo = new ArrayList<>();
                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (index+i);
                    String sReg2 = "S" + (indexDes+i);
                    StringBuilder sRegFrom = conca(sReg2, 32 / size, size, new StringBuilder());

                    StringBuilder sRegToLeft = new StringBuilder();
                    String[] vals1 = registerMap.get(sReg1).split(":");
                    String[] vals2 = registerMap.get(sReg2).split(":");
                    getVQADDsRegToLeft(size, signMode, datatype, vals1, vals2, sRegToLeft);
                    sListTo.add(sRegToLeft);
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToLeft).append("\t\t\t\telse undefMInt32)\n");

                    if (i == 3) {
                        getVQADDFPSCR(size, signMode, datatype, desCond, vals1, vals2);
                    }

                    BigInteger[] cmpRange = new BigInteger[2];
                    if (datatype.charAt(0) == 'S') {
                        cmpRange[0] = BigInteger.valueOf(-1 * (1L << (size-1)));
                        cmpRange[1] = BigInteger.valueOf(1L << (size-1));
                    } else {
                        cmpRange[0] = BigInteger.ZERO;
                        cmpRange[1] = BigInteger.valueOf(1L << size);
                    }
                    for (int j = 0; j < vals1.length; j++) {
                        BigInteger[] bigIntegers1 = preCond.get(vals1[j]);
                        BigInteger[] bigIntegers2 = preCond.get(vals2[j]);
                        normalize(bigIntegers1, datatype, size);
                        normalize(bigIntegers2, datatype, size);
                        BigInteger[] desRange = getVQADDDesRange(bigIntegers1, bigIntegers2, cmpRange);
                        preCond.put(vals2[j], desRange);
                    }
                }
                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = conca(desRegister, 128 / size, size, new StringBuilder());
                qRegFrom.append(" => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            } else {
                int index1 = Integer.parseInt(sourceRegister1.substring(1)) * 4;
                int index2 = Integer.parseInt(sourceRegister2.substring(1)) * 4;
                setSourcePostCond(size, index1, sourceRegister1);
                postCondition.addAll(sourcePostCond);
                sourcePostCond.clear();
                setSourcePostCond(size, index2, sourceRegister2);
                postCondition.addAll(sourcePostCond);
                sourcePostCond.clear();
                // 设置S
                List<StringBuilder> sListTo = new ArrayList<>();
                // 若目标寄存器中无初始值，则在registerMap和preCondMap中设定一个初始值，相当于初始化
                // 命名规则为 vec + 当前向量寄存器的标识符 + '_' + set
                setVecDefaultPreCondAndRegisterMap(registerMap, preCond, desRegister, size, indexDes);

                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (index1+i);
                    String sReg2 = "S" + (index2+i);
                    StringBuilder sRegFrom = new StringBuilder().append("mi(32, _:Int)\n");

                    StringBuilder sRegToLeft = new StringBuilder();
                    String[] vals1 = registerMap.get(sReg1).split(":");
                    String[] vals2 = registerMap.get(sReg2).split(":");
                    getVQADDsRegToLeft(size, signMode, datatype, vals1, vals2, sRegToLeft);
                    sListTo.add(sRegToLeft);
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToLeft).append("\t\t\t\telse undefMInt32)\n");

                    if (i == 3) {
                        getVQADDFPSCR(size, signMode, datatype, desCond, vals1, vals2);
                    }
                    // 重设目标寄存器的值范围
                    String[] valsDes = registerMap.get("S" + (indexDes+i)).split(":");

                    BigInteger[] cmpRange = new BigInteger[2];
                    if (datatype.charAt(0) == 'S') {
                        cmpRange[0] = BigInteger.valueOf(-1 * (1L << (size-1)));
                        cmpRange[1] = BigInteger.valueOf(1L << (size-1));
                    } else {
                        cmpRange[0] = BigInteger.ZERO;
                        cmpRange[1] = BigInteger.valueOf(1L << size);
                    }
                    for (int j = 0; j < vals1.length; j++) {
                        BigInteger[] bigIntegers1 = preCond.get(vals1[j]);
                        BigInteger[] bigIntegers2 = preCond.get(vals2[j]);
                        normalize(bigIntegers1, datatype, size);
                        normalize(bigIntegers2, datatype, size);
                        BigInteger[] desRange = getVQADDDesRange(bigIntegers1, bigIntegers2, cmpRange);
                        preCond.put(valsDes[j], desRange);
                    }
                }

                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = new StringBuilder().append(" mi(128, _:Int) => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            }
            proveObject.setPreCond(preCond);
            proveObject.setRegisterMap(registerMap);
            postCondition.add(desCond.toString());
        } catch (RuntimeException e) {
            e.printStackTrace();
        }
        return postCondition;
    }

    private void getVQADDsRegToLeft(int size, String signMode, String datatype, String[] vals1, String[] vals2,
                                    StringBuilder sRegToLeft) {
        if (size == 32) {
            String sub = signMode + "(mi(32, ";
            String[] thres = datatype.charAt(0) == 'S' ? new String[]{"-2147483648", "2147483647"}
                    : new String[]{"0", "4294967295"};
            sRegToLeft.append("\t\t\t\t\t")
                    .append("ifMInt (").append(sub).append(vals1[0])
                    .append(")) +Int ")
                    .append(sub).append(vals2[0]).append(")) >Int ").append(thres[1])
                    .append(") then mi(32, ").append(thres[1]).append(") else ifMInt (")
                    .append(sub).append(vals1[0]).append(")) +Int ").append(sub).append(vals2[0])
                    .append(")) <Int ").append(thres[0]).append(") then mi(32, ").append(thres[0])
                    .append(") else ")
                    .append("mi(32, ").append(sub).append(vals1[0]).append(")) +Int ")
                    .append(sub).append(vals2[0]).append(")))\n");
        } else if (size == 16) {
            String sub = signMode + "(mi(16, ";
            String[] thres = datatype.charAt(0) == 'S' ? new String[]{"-32768", "32767"}
                    : new String[]{"0", "65535"};
            sRegToLeft.append("\t\t\t\t\t")
                    .append("concatenateMInt(")
                    .append("ifMInt (").append(sub).append(vals1[0])
                    .append(")) +Int ")
                    .append(sub).append(vals2[0]).append(")) >Int ").append(thres[1])
                    .append(") then mi(16, ").append(thres[1]).append(") else ifMInt (")
                    .append(sub).append(vals1[0]).append(")) +Int ").append(sub).append(vals2[0])
                    .append(")) <Int ").append(thres[0]).append(") then mi(16, ").append(thres[0])
                    .append(") else ")
                    .append("mi(16, ").append(sub).append(vals1[0]).append(")) +Int ")
                    .append(sub).append(vals2[0]).append("))), ")
                    .append("ifMInt (").append(sub).append(vals1[1])
                    .append(")) +Int ")
                    .append(sub).append(vals2[1]).append(")) >Int ").append(thres[1])
                    .append(") then mi(16, ").append(thres[1]).append(") else ifMInt (")
                    .append(sub).append(vals1[1]).append(")) +Int ").append(sub).append(vals2[1])
                    .append(")) <Int ").append(thres[0]).append(") then mi(16, ").append(thres[0])
                    .append(") else ")
                    .append("mi(16, ").append(sub).append(vals1[1]).append(")) +Int ")
                    .append(sub).append(vals2[1]).append(")))")
                    .append(")\n");
        } else if (size == 8) {
            String sub = signMode + "(mi(8, ";
            String[] thres = datatype.charAt(0) == 'S' ? new String[]{"-128", "127"}
                    : new String[]{"0", "255"};
            sRegToLeft.append("\t\t\t\t\t")
                    .append("concatenateMInt(")
                    .append("ifMInt (").append(sub).append(vals1[0])
                    .append(")) +Int ")
                    .append(sub).append(vals2[0]).append(")) >Int ").append(thres[1])
                    .append(") then mi(8, ").append(thres[1]).append(") else ifMInt (")
                    .append(sub).append(vals1[0]).append(")) +Int ").append(sub).append(vals2[0])
                    .append(")) <Int ").append(thres[0]).append(") then mi(8, ").append(thres[0])
                    .append(") else ")
                    .append("mi(8, ").append(sub).append(vals1[0]).append(")) +Int ")
                    .append(sub).append(vals2[0]).append("))), ")
                    .append("concatenateMInt(")
                    .append("ifMInt (").append(sub).append(vals1[1])
                    .append(")) +Int ")
                    .append(sub).append(vals2[1]).append(")) >Int ").append(thres[1])
                    .append(") then mi(8, ").append(thres[1]).append(") else ifMInt (")
                    .append(sub).append(vals1[1]).append(")) +Int ").append(sub).append(vals2[1])
                    .append(")) <Int ").append(thres[0]).append(") then mi(8, ").append(thres[0])
                    .append(") else ")
                    .append("mi(8, ").append(sub).append(vals1[1]).append(")) +Int ")
                    .append(sub).append(vals2[1]).append("))), ")
                    .append("concatenateMInt(")
                    .append("ifMInt (").append(sub).append(vals1[2])
                    .append(")) +Int ")
                    .append(sub).append(vals2[2]).append(")) >Int ").append(thres[1])
                    .append(") then mi(8, ").append(thres[1]).append(") else ifMInt (")
                    .append(sub).append(vals1[2]).append(")) +Int ").append(sub).append(vals2[2])
                    .append(")) <Int ").append(thres[0]).append(") then mi(8, ").append(thres[0])
                    .append(") else ")
                    .append("mi(8, ").append(sub).append(vals1[2]).append(")) +Int ")
                    .append(sub).append(vals2[2]).append("))), ")
                    .append("ifMInt (").append(sub).append(vals1[3])
                    .append(")) +Int ")
                    .append(sub).append(vals2[3]).append(")) >Int ").append(thres[1])
                    .append(") then mi(8, ").append(thres[1]).append(") else ifMInt (")
                    .append(sub).append(vals1[3]).append(")) +Int ").append(sub).append(vals2[3])
                    .append(")) <Int ").append(thres[0]).append(") then mi(8, ").append(thres[0])
                    .append(") else ")
                    .append("mi(8, ").append(sub).append(vals1[3]).append(")) +Int ")
                    .append(sub).append(vals2[3]).append(")))")
                    .append(")))\n");
        }
    }

    private void getVQADDFPSCR(int size, String signMode, String datatype, StringBuilder desCond,
                               String[] vals1, String[] vals2) {
        if (size == 32) {
            String sub = signMode + "(mi(32, ";
            String[] thres = datatype.charAt(0) == 'S' ? new String[]{"-2147483648", "2147483647"}
                    : new String[]{"0", "4294967295"};
            desCond.append("\t\t\t\"FPSCR\" |-> (mi(32, 50331648) => ").append("ifMInt ((").append(sub)
                    .append(vals1[0]).append("))").append(" +Int ").append(sub).append(vals2[0])
                    .append(")) >Int ").append(thres[1]).append(") orBool (").append(sub)
                    .append(vals1[0]).append("))").append(" +Int ").append(sub).append(vals2[0])
                    .append(")) <Int").append(thres[0]).append("))").append(" then \n")
                    .append("\t\t\t\tplugInMask(mi(32, 50331648), mi(1, 1), 27)\n")
                    .append("\t\t\t else \n")
                    .append("\t\t\t\tmi(32, 50331648))\n");
        } else if (size == 16) {
            String sub = signMode + "(mi(16, ";
            String[] thres = datatype.charAt(0) == 'S' ? new String[]{"-32768", "32767"}
                    : new String[]{"0", "65535"};
            desCond.append("\t\t\t\"FPSCR\" |-> (mi(32, 50331648) => ").append(" ifMInt ")
                    .append("((").append(sub)
                    .append(vals1[1]).append("))").append(" +Int ").append(sub).append(vals2[1])
                    .append(")) >Int ").append(thres[1]).append(") orBool (").append(sub)
                    .append(vals1[1]).append("))").append(" +Int ").append(sub).append(vals2[1])
                    .append(")) <Int ").append(thres[0]).append(") orBool (").append(sub)
                    .append(vals1[0]).append("))").append(" +Int ").append(sub).append(vals2[0])
                    .append(")) >Int ").append(thres[1]).append(") orBool (").append(sub)
                    .append(vals1[0]).append("))").append(" +Int ").append(sub).append(vals2[0])
                    .append(")) <Int ").append(thres[0]).append("))")
                    .append(" then \n")
                    .append("\t\t\t\tplugInMask(mi(32, 50331648), mi(1, 1), 27)\n")
                    .append("\t\t\t else \n")
                    .append("\t\t\t\tmi(32, 50331648))\n");
        } else if (size == 8) {
            String sub = signMode + "(mi(8, ";
            String[] thres = datatype.charAt(0) == 'S' ? new String[]{"-128", "127"}
                    : new String[]{"0", "255"};
            desCond.append("\t\t\t\"FPSCR\" |-> (mi(32, 50331648) => ").append(" ifMInt ")
                    .append("((").append(sub)
                    .append(vals1[3]).append("))").append(" +Int ").append(sub).append(vals2[3])
                    .append(")) >Int ").append(thres[1]).append(") orBool (").append(sub)
                    .append(vals1[3]).append("))").append(" +Int ").append(sub).append(vals2[3])
                    .append(")) <Int ").append(thres[0]).append(") orBool (").append(sub)
                    .append(vals1[2]).append("))").append(" +Int ").append(sub).append(vals2[2])
                    .append(")) >Int ").append(thres[1]).append(") orBool (").append(sub)
                    .append(vals1[2]).append("))").append(" +Int ").append(sub).append(vals2[2])
                    .append(")) <Int ").append(thres[0]).append(") orBool (").append(sub)
                    .append(vals1[1]).append("))").append(" +Int ").append(sub).append(vals2[1])
                    .append(")) >Int ").append(thres[1]).append(") orBool (").append(sub)
                    .append(vals1[1]).append("))").append(" +Int ").append(sub).append(vals2[1])
                    .append(")) <Int ").append(thres[0]).append(") orBool (").append(sub)
                    .append(vals1[0]).append("))").append(" +Int ").append(sub).append(vals2[0])
                    .append(")) >Int ").append(thres[1]).append(") orBool (").append(sub)
                    .append(vals1[0]).append("))").append(" +Int ").append(sub).append(vals2[0])
                    .append(")) <Int ").append(thres[0]).append("))")
                    .append(" then \n")
                    .append("\t\t\t\tplugInMask(mi(32, 50331648), mi(1, 1), 27)\n")
                    .append("\t\t\t else \n")
                    .append("\t\t\t\tmi(32, 50331648))\n");
        }
    }

    private BigInteger[] getVQADDDesRange(BigInteger[] bigIntegers1, BigInteger[] bigIntegers2, BigInteger[] cmpRange) {
        BigInteger[] desRange = new BigInteger[2];
        if (bigIntegers1[0].add(bigIntegers2[0]).compareTo(cmpRange[0]) < 0) {
            desRange[0] = cmpRange[0];
            if (bigIntegers1[1].add(bigIntegers2[1]).compareTo(cmpRange[0]) < 0) {
                desRange[1] = cmpRange[0];
            } else if (bigIntegers1[1].add(bigIntegers2[1]).compareTo(cmpRange[1]) >= 0) {
                desRange[1] = cmpRange[1];
            } else {
                desRange[1] = bigIntegers1[1].add(bigIntegers2[1]);
            }
        } else if (bigIntegers1[0].add(bigIntegers2[0]).compareTo(cmpRange[1]) >= 0) {
            desRange[0] = cmpRange[1];
            desRange[1] = cmpRange[1];
        } else {
            desRange[0] = bigIntegers1[0].add(bigIntegers2[0]);
            if (bigIntegers1[1].add(bigIntegers2[1]).compareTo(cmpRange[1]) >= 0) {
                desRange[1] = cmpRange[1];
            } else {
                desRange[1] = bigIntegers1[1].add(bigIntegers2[1]);
            }
        }
        return desRange;
    }

    /**
     * VQRDMULH Q R
     * @return
     */
    public List<String> vqrdmulhQRPostSet() {
        List<String> postCondition = new ArrayList<>();
        try {
            if (instruction == null || instruction.getDestinationRegister() == null)
                throw new RuntimeException("指令或目标寄存器为空");
            if (sourcePostCond == null || sourcePostCond.isEmpty())
                sourcePostCond = new ArrayList<>();
            if (instruction.getSourceRegister() == null || instruction.getSourceRegister().isEmpty())
                throw new InputMismatchException("源操作数为空");
            String datatype = instruction.getDatatype();
            int size = Integer.parseInt(datatype.substring(1));
            Map<String, String> registerMap = proveObject.getRegisterMap();
            Map<String, BigInteger[]> preCond = proveObject.getPreCond();
            String desRegister = instruction.getDestinationRegister();
            StringBuilder desCond = preSet();
            sourcePostCond.clear();

            String sourceRegister1 = instruction.getSourceRegister().get(0);
            String sourceRegister2 = instruction.getSourceRegister().get(1);
            String val = registerMap.get(sourceRegister2);
            desCond.append("\t\t\t\"").append(sourceRegister2).append("\" |-> ").append("mi(32, ")
                    .append(val).append(")\n");
            String sub = "svalueMInt(mi(" + size + ", ";
            if (desRegister.equals(sourceRegister1)) {
                List<StringBuilder> sListTo = new ArrayList<>();
                int indexDes = Integer.parseInt(desRegister.substring(1)) * 4;
                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (indexDes+i);
                    StringBuilder sRegFrom = conca(sReg1, 32 / size, size, new StringBuilder());

                    StringBuilder sRegToLeft = new StringBuilder();
                    String[] vals1 = registerMap.get(sReg1).split(":");
                    getVQRDMULHsRegToLeft(size, sub, val, vals1, sRegToLeft);
                    sListTo.add(sRegToLeft);
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToLeft).append("\t\t\t\telse undefMInt32)\n");

                    if (i == 3) {
                        getVQRDMULHFPSCR(size, sub, val, vals1, desCond);
                    }
                    // 重设目标寄存器的值范围
                    BigInteger[] bigIntegers2 = preCond.get(registerMap.get(sourceRegister2));

                    for (String s : vals1) {
                        BigInteger[] bigIntegers1 = preCond.get(s);
                        normalize(bigIntegers1, datatype, size);
                        normalize(bigIntegers2, datatype, size);

                        bigIntegers1[0] = bigIntegers1[0].multiply(BigInteger.valueOf(2));
                        bigIntegers1[1] = bigIntegers2[0].multiply(BigInteger.valueOf(2));
                        BigInteger[] mulRange = getMULRange(bigIntegers1, bigIntegers2, datatype);
                        mulRange[0] = mulRange[0].add(BigInteger.valueOf(1L << (size-1))).divide(BigInteger.valueOf(1L << size));
                        mulRange[1] = mulRange[1].add(BigInteger.valueOf(1L << (size-1))).divide(BigInteger.valueOf(1L << size));
                        preCond.put(s, mulRange);
                    }
                }
                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = conca(desRegister, 128 / size, size, new StringBuilder());
                qRegFrom.append(" => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            } else {
                int index1 = Integer.parseInt(sourceRegister1.substring(1)) * 4;
                setSourcePostCond(size, index1, sourceRegister1);
                postCondition.addAll(sourcePostCond);
                // 设置S
                List<StringBuilder> sListTo = new ArrayList<>();
                int indexDes = Integer.parseInt(desRegister.substring(1)) * 4;
                // 若目标寄存器中无初始值，则在registerMap和preCondMap中设定一个初始值，相当于初始化
                // 命名规则为 vec + 当前向量寄存器的标识符 + '_' + set
                setVecDefaultPreCondAndRegisterMap(registerMap, preCond, desRegister, size, indexDes);

                for (int i = 0; i < 4; i++) {
                    String sReg1 = "S" + (index1+i);
                    StringBuilder sRegFrom = new StringBuilder().append("mi(32, _:Int)\n");

                    StringBuilder sRegToLeft = new StringBuilder();
                    String[] vals1 = registerMap.get(sReg1).split(":");
                    getVQRDMULHsRegToLeft(size, sub, val, vals1, sRegToLeft);
                    sListTo.add(sRegToLeft);
                    desCond.append("\n\t\t\t\"S").append(indexDes+i).append("\" |-> (").append(sRegFrom)
                            .append("\n\t\t\t\t => \n").append("\t\t\t\tifMInt notBool IsUndef (").append(sRegToLeft)
                            .append("\t\t\t\t) then ").append(sRegToLeft).append("\t\t\t\telse undefMInt32)\n");

                    // 重设目标寄存器的值范围
                    BigInteger[] bigIntegers2 = preCond.get(registerMap.get(sourceRegister2));
                    String[] valsDes = registerMap.get("S" + (indexDes+i)).split(":");

                    if (i == 3) {
                        getVQRDMULHFPSCR(size, sub, val, vals1, desCond);
                    }

                    for (int j = 0; j < vals1.length; j++) {
                        BigInteger[] bigIntegers1 = preCond.get(vals1[j]);
                        normalize(bigIntegers1, datatype, size);
                        normalize(bigIntegers2, datatype, size);

                        bigIntegers1[0] = bigIntegers1[0].multiply(BigInteger.valueOf(2));
                        bigIntegers1[1] = bigIntegers2[0].multiply(BigInteger.valueOf(2));
                        BigInteger[] mulRange = getMULRange(bigIntegers1, bigIntegers2, datatype);
                        mulRange[0] = mulRange[0].add(BigInteger.valueOf(1L << (size-1))).divide(BigInteger.valueOf(1L << size));
                        mulRange[1] = mulRange[1].add(BigInteger.valueOf(1L << (size-1))).divide(BigInteger.valueOf(1L << size));
                        preCond.put(valsDes[j], mulRange);
                    }
                }

                // 设置临时变量
                desCond.append("\t\t\t\"RESULT\" |-> (mi(32, 0) => ").append(sListTo.get(3)).append("\t\t\t\t)\n");
                // 设置Q
                StringBuilder qRegFrom = new StringBuilder().append(" mi(128, _:Int) => ");
                for (int i = 3; i >= 0; i--) {
                    if (i > 0)
                        qRegFrom.append("concatenateMInt(").append(sListTo.get(i)).append("\t\t\t\t,\n\t\t\t\t");
                    else
                        qRegFrom.append(sListTo.get(0)).append("\t\t\t\t))))\n");
                }
                desCond.append("\t\t\t\"").append(desRegister).append("\" |-> (").append(qRegFrom);
            }
            proveObject.setPreCond(preCond);
            proveObject.setRegisterMap(registerMap);
            postCondition.add(desCond.toString());
        } catch (RuntimeException e) {
            e.printStackTrace();
        }
        return postCondition;
    }

    private void getVQRDMULHsRegToLeft(int size, String sub, String val, String[] vals1, StringBuilder sRegToLeft) {
        if (size == 32) {
            sRegToLeft.append("\t\t\t\t\t")
                    .append("ifMInt (((2 *Int ").append(sub).append(vals1[0]).append(")) *Int ")
                    .append(sub).append(val).append(")) +Int 2147483648) >>Int 32) >Int 2147483647)")
                    .append(" then ")
                    .append("mi(32, 2147483647)")
                    .append(" else ")
                    .append("ifMInt (((2 *Int ").append(sub).append(vals1[0]).append(")) *Int ")
                    .append(sub).append(val).append(")) +Int 2147483648) >>Int 32) <Int -2147483648)")
                    .append(" then ")
                    .append("mi(32, -2147483648)")
                    .append(" else ")
                    .append("mi(32, ((2 *Int ").append(sub).append(vals1[0]).append(")) *Int ")
                    .append(sub).append(val).append(")) +Int 2147483648) >>Int 32))")
                    .append("\n");
        } else if (size == 16) {
            String sub2 = "svalueMInt(extractMInt(mi(32, " + val + "), 16, 32))";
            sRegToLeft.append("\t\t\t\t\t")
                    .append("concatenateMInt(")
                    .append("ifMInt (((2 *Int ").append(sub).append(vals1[0]).append(")) *Int ")
                    .append(sub2).append(" +Int 32768) >>Int 16) >Int 32767)")
                    .append(" then ")
                    .append("mi(16, 32767)")
                    .append(" else ")
                    .append("ifMInt (((2 *Int ").append(sub).append(vals1[0]).append(")) *Int ")
                    .append(sub2).append(" +Int 32768) >>Int 16) <Int -32768)")
                    .append(" then ")
                    .append("mi(16, -32768)")
                    .append(" else ")
                    .append("mi(16, ((2 *Int ").append(sub).append(vals1[0]).append(")) *Int ")
                    .append(sub2).append(" +Int 32768) >>Int 16)), ")
                    .append("ifMInt (((2 *Int ").append(sub).append(vals1[1]).append(")) *Int ")
                    .append(sub2).append(" +Int 32768) >>Int 16) >Int 32767)")
                    .append(" then ")
                    .append("mi(16, 32767)")
                    .append(" else ")
                    .append("ifMInt (((2 *Int ").append(sub).append(vals1[1]).append(")) *Int ")
                    .append(sub2).append(" +Int 32768) >>Int 16) <Int -32768)")
                    .append(" then ")
                    .append("mi(16, -32768)")
                    .append(" else ")
                    .append("mi(16, ((2 *Int ").append(sub).append(vals1[1]).append(")) *Int ")
                    .append(sub2).append(" +Int 32768) >>Int 16))")
                    .append(")\n");
        } else if (size == 8) {
            String sub2 = "svalueMInt(extractMInt(mi(32, " + val + "), 24, 32))";
            sRegToLeft.append("\t\t\t\t\t")
                    .append("concatenateMInt(")
                    .append("ifMInt (((2 *Int ").append(sub).append(vals1[0]).append(")) *Int ")
                    .append(sub2).append(" +Int 128) >>Int 8) >Int 127)")
                    .append(" then ")
                    .append("mi(8, 127)")
                    .append(" else ")
                    .append("ifMInt (((2 *Int ").append(sub).append(vals1[0]).append(")) *Int ")
                    .append(sub2).append(" +Int 128) >>Int 8) <Int -128)")
                    .append(" then ")
                    .append("mi(8, -128)")
                    .append(" else ")
                    .append("mi(8, ((2 *Int ").append(sub).append(vals1[0]).append(")) *Int ")
                    .append(sub2).append(" +Int 128) >>Int 8)), ")
                    .append("concatenateMInt(")
                    .append("ifMInt (((2 *Int ").append(sub).append(vals1[1]).append(")) *Int ")
                    .append(sub2).append(" +Int 128) >>Int 8) >Int 127)")
                    .append(" then ")
                    .append("mi(8, 127)")
                    .append(" else ")
                    .append("ifMInt (((2 *Int ").append(sub).append(vals1[1]).append(")) *Int ")
                    .append(sub2).append(" +Int 128) >>Int 8) <Int -128)")
                    .append(" then ")
                    .append("mi(8, -128)")
                    .append(" else ")
                    .append("mi(8, ((2 *Int ").append(sub).append(vals1[1]).append(")) *Int ")
                    .append(sub2).append(" +Int 128) >>Int 8)), ")
                    .append("concatenateMInt(")
                    .append("ifMInt (((2 *Int ").append(sub).append(vals1[2]).append(")) *Int ")
                    .append(sub2).append(" +Int 128) >>Int 8) >Int 127)")
                    .append(" then ")
                    .append("mi(8, 127)")
                    .append(" else ")
                    .append("ifMInt (((2 *Int ").append(sub).append(vals1[2]).append(")) *Int ")
                    .append(sub2).append(" +Int 128) >>Int 8) <Int -128)")
                    .append(" then ")
                    .append("mi(8, -128)")
                    .append(" else ")
                    .append("mi(8, ((2 *Int ").append(sub).append(vals1[2]).append(")) *Int ")
                    .append(sub2).append(" +Int 128) >>Int 8)), ")
                    .append("ifMInt (((2 *Int ").append(sub).append(vals1[3]).append(")) *Int ")
                    .append(sub2).append(" +Int 128) >>Int 8) >Int 127)")
                    .append(" then ")
                    .append("mi(8, 127)")
                    .append(" else ")
                    .append("ifMInt (((2 *Int ").append(sub).append(vals1[3]).append(")) *Int ")
                    .append(sub2).append(" +Int 128) >>Int 8) <Int -128)")
                    .append(" then ")
                    .append("mi(8, -128)")
                    .append(" else ")
                    .append("mi(8, ((2 *Int ").append(sub).append(vals1[3]).append(")) *Int ")
                    .append(sub2).append(" +Int 128) >>Int 8))")
                    .append(")))\n");
        }
    }

    private void getVQRDMULHFPSCR(int size, String sub, String val, String[] vals1, StringBuilder desCond) {
        if (size == 32) {
            desCond.append("\n\t\t\t\"FPSCR\" |-> (mi(32, 50331648) => ")
                    .append("ifMInt (").append("(((2 *Int ").append(sub).append(vals1[0])
                    .append(")) *Int ").append(sub).append(val).append(")) +Int 2147483648) >>Int 32)")
                    .append(" >Int 2147483647) ")
                    .append(" orBool ")
                    .append("(((2 *Int ").append(sub).append(vals1[0])
                    .append(")) *Int ").append(sub).append(val).append(")) +Int 2147483648) >>Int 32)")
                    .append(" <Int -2147483648) ")
                    .append(")")
                    .append(" then ")
                    .append("plugInMask(mi(32, 50331648), mi(1, 1), 27)")
                    .append(" else ").append("mi(32, 50331648))\n");
        } else if (size == 16) {
            String sub2 = "svalueMInt(extractMInt(mi(32, " + val + "), 16, 32))";
            desCond.append("\n\t\t\t\"FPSCR\" |-> (mi(32, 50331648) => ")
                    .append("ifMInt (").append("(((2 *Int ").append(sub).append(vals1[1])
                    .append(")) *Int ").append(sub2).append(" +Int 32768) >>Int 16)")
                    .append(" >Int 32767) ")
                    .append(" orBool ")
                    .append("(((2 *Int ").append(sub).append(vals1[1])
                    .append(")) *Int ").append(sub2).append(" +Int 32768) >>Int 16)")
                    .append(" <Int -32768) ")
                    .append(" orBool ")
                    .append("(((2 *Int ").append(sub).append(vals1[0])
                    .append(")) *Int ").append(sub2).append(" +Int 32768) >>Int 16)")
                    .append(" >Int 32767) ")
                    .append(" orBool ")
                    .append("(((2 *Int ").append(sub).append(vals1[0])
                    .append(")) *Int ").append(sub2).append(" +Int 32768) >>Int 16)")
                    .append(" <Int -32768) ")
                    .append(")")
                    .append(" then ")
                    .append("plugInMask(mi(32, 50331648), mi(1, 1), 27)")
                    .append(" else ").append("mi(32, 50331648))\n");
        } else if (size == 8) {
            String sub2 = "svalueMInt(extractMInt(mi(32, " + val + "), 24, 32))";
            desCond.append("\n\t\t\t\"FPSCR\" |-> (mi(32, 50331648) => ")
                    .append("ifMInt (").append("(((2 *Int ").append(sub).append(vals1[3])
                    .append(")) *Int ").append(sub2).append(" +Int 128) >>Int 8)")
                    .append(" >Int 127) ")
                    .append(" orBool ")
                    .append("(((2 *Int ").append(sub).append(vals1[3])
                    .append(")) *Int ").append(sub2).append(" +Int 128) >>Int 8)")
                    .append(" <Int -128) ")
                    .append(" orBool ")
                    .append("(((2 *Int ").append(sub).append(vals1[2])
                    .append(")) *Int ").append(sub2).append(" +Int 128) >>Int 8)")
                    .append(" >Int 127) ")
                    .append(" orBool ")
                    .append("(((2 *Int ").append(sub).append(vals1[2])
                    .append(")) *Int ").append(sub2).append(" +Int 128) >>Int 8)")
                    .append(" <Int -128) ")
                    .append(" orBool ")
                    .append("(((2 *Int ").append(sub).append(vals1[1])
                    .append(")) *Int ").append(sub2).append(" +Int 128) >>Int 8)")
                    .append(" >Int 127) ")
                    .append(" orBool ")
                    .append("(((2 *Int ").append(sub).append(vals1[1])
                    .append(")) *Int ").append(sub2).append(" +Int 128) >>Int 8)")
                    .append(" <Int -128) ")
                    .append(" orBool ")
                    .append("(((2 *Int ").append(sub).append(vals1[0])
                    .append(")) *Int ").append(sub2).append(" +Int 128) >>Int 8)")
                    .append(" >Int 127) ")
                    .append(" orBool ")
                    .append("(((2 *Int ").append(sub).append(vals1[0])
                    .append(")) *Int ").append(sub2).append(" +Int 128) >>Int 8)")
                    .append(" <Int -128) ")
                    .append(")")
                    .append(" then ")
                    .append("plugInMask(mi(32, 50331648), mi(1, 1), 27)")
                    .append(" else ").append("mi(32, 50331648))\n");
        }
    }

    private BigInteger[] getVRSHLRange(BigInteger[] bigIntegers1, BigInteger[] bigIntegers2) {
        if (bigIntegers1[0].compareTo(BigInteger.ZERO) < 0) {
            if (bigIntegers2[1].compareTo(BigInteger.ZERO) < 0) {
                bigIntegers1[0] = bigIntegers1[0]
                        .add(BigInteger.valueOf(2).pow(Integer.parseInt(
                                bigIntegers2[1].abs().subtract(BigInteger.ONE).toString())))
                        .divide(BigInteger.valueOf(2).pow(Integer.parseInt(bigIntegers2[1].abs().toString())));
            } else {
                bigIntegers1[0] = bigIntegers1[0].multiply(BigInteger.valueOf(2)
                        .pow(Integer.parseInt(bigIntegers2[1].abs().toString())));
            }
        } else {
            if (bigIntegers2[0].compareTo(BigInteger.ZERO) < 0) {
                bigIntegers1[0] = bigIntegers1[0]
                        .add(BigInteger.valueOf(2).pow(Integer.parseInt(
                                bigIntegers2[0].abs().subtract(BigInteger.ONE).toString())))
                        .divide(BigInteger.valueOf(2).pow(Integer.parseInt(bigIntegers2[0].abs().toString())));
            } else {
                bigIntegers1[0] = bigIntegers1[0].multiply(BigInteger.valueOf(2)
                        .pow(Integer.parseInt(bigIntegers2[0].abs().toString())));
            }
        }
        if (bigIntegers1[1].compareTo(BigInteger.ZERO) < 0) {
            if (bigIntegers2[0].compareTo(BigInteger.ZERO) < 0) {
                bigIntegers1[1] = bigIntegers1[1]
                        .add(BigInteger.valueOf(2).pow(Integer.parseInt(
                                bigIntegers2[0].abs().subtract(BigInteger.ONE).toString())))
                        .divide(BigInteger.valueOf(2).pow(Integer.parseInt(bigIntegers2[0].abs().toString())));
            } else {
                bigIntegers1[1] = bigIntegers1[1].multiply(BigInteger.valueOf(2)
                        .pow(Integer.parseInt(bigIntegers2[0].abs().toString())));
            }
        } else {
            if (bigIntegers2[1].compareTo(BigInteger.ZERO) < 0) {
                bigIntegers1[1] = bigIntegers1[1]
                        .add(BigInteger.valueOf(2).pow(Integer.parseInt(
                                bigIntegers2[1].abs().subtract(BigInteger.ONE).toString())))
                        .divide(BigInteger.valueOf(2).pow(Integer.parseInt(bigIntegers2[1].abs().toString())));
            } else {
                bigIntegers1[1] = bigIntegers1[1].multiply(BigInteger.valueOf(2)
                        .pow(Integer.parseInt(bigIntegers2[1].abs().toString())));
            }
        }
        return new BigInteger[]{bigIntegers1[0], bigIntegers1[1]};
    }
}
