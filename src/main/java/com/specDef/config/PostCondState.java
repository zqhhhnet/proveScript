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
                if ("VMAXV".equals(instruction.getOpcode())) {
                    desHigher = desHigher.compareTo(sourceRange[1]) >= 0 ? desHigher : sourceRange[1];
                    desLower = desLower.compareTo(sourceRange[1]) >= 0 ? desLower :
                            (desLower.compareTo(sourceRange[0]) >= 0 ? desLower : sourceRange[0]);
                } else {
                    desLower = desLower.compareTo(sourceRange[0]) <= 0 ? desLower : sourceRange[0];
                    desHigher = desHigher.compareTo(sourceRange[0]) <= 0 ? desHigher :
                            (desHigher.compareTo(sourceRange[1]) <= 0 ? desHigher : sourceRange[1]);
                }
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
                if ("VMAXV".equals(instruction.getOpcode())) {
                    desHigher = desHigher.compareTo(sourceRange[1]) >= 0 ? desHigher : sourceRange[1];
                    desLower = desLower.compareTo(sourceRange[1]) >= 0 ? desLower :
                            (desLower.compareTo(sourceRange[0]) >= 0 ? desLower : sourceRange[0]);
                } else {
                    desLower = desLower.compareTo(sourceRange[0]) <= 0 ? desLower : sourceRange[0];
                    desHigher = desHigher.compareTo(sourceRange[0]) <= 0 ? desHigher :
                            (desHigher.compareTo(sourceRange[1]) <= 0 ? desHigher : sourceRange[1]);
                }
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
    private String concaMInt(String reg, int size, int width) {
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
                BigInteger[] range = getRange(sourceRange0, sourceRange1, datatype);
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
                    BigInteger[] range = getRange(sourceRange0, sourceRange1, datatype);
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
    private BigInteger[] getRange(BigInteger[] sourceRange0, BigInteger[] sourceRange1, String datatype) {
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
}
