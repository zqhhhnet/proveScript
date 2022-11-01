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
            checkException();
            if (sourcePostCond == null || sourcePostCond.isEmpty()) {
                sourcePostCond = new ArrayList<>();
            }
            if (instruction.getSourceRegister() == null || instruction.getSourceRegister().isEmpty())
                throw new InputMismatchException("源操作数为空");
            String datatype = instruction.getDatatype();
            int size = Integer.parseInt(datatype.substring(1));
            Map<String, String> registerMap = proveObject.getRegisterMap();
            String desRegister = instruction.getDestinationRegister();
            StringBuilder desCond = new StringBuilder();
            desCond.append("\t\t\t\"CONTROL\" |-> (mi(32, _:Int) => mi(32, 1))\n\t\t\t\"CONTROL_NS\" |-> (mi(32, _:Int) => mi(32, 1))\n ")
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
            Map<String, BigInteger[]> preCond = proveObject.getPreCond();
            sourcePostCond.clear();

            // VMAX、VMIN需要判断目标寄存器是否为某一个源寄存器，若是，则需要利用 原 => 后
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
                        StringBuilder sRegTo = getToDesConca(sReg1.toString(), sReg2.toString(), size,
                                "VMAX".equals(instruction.getOpcode()) ? "<=Int" : ">=Int");
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
                                registerMap.put("S" + i, tmp);
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
                                    registerMap.put("S" + i, tmp);
                                    preCond.put(tmp, new BigInteger[]{BigInteger.ZERO, BigInteger.ONE});
                                }
                            }
                        }
                    }

                    for (int i = 0; i < 4; i++) {
                        StringBuilder sRegFrom = new StringBuilder().append("\"mi(32, _:Int)\n");
                        StringBuilder sReg1 = new StringBuilder();
                        StringBuilder sReg2 = new StringBuilder();
                        sReg1.append('S').append((index1+i));
                        sReg2.append('S').append((index2+i));
                        StringBuilder sRegTo = getToDesConca(sReg1.toString(), sReg2.toString(), size,
                                "VMAX".equals(instruction.getOpcode()) ? "<=Int" : ">=Int");
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
     * 获取浮点寄存器中，每对元素的比较情况，对应后置条件
     * @param sReg1 对应第一个源操作数的浮点寄存器
     * @param sReg2 对应第二个源操作数的浮点寄存器
     * @param width 每个元素的位宽
     * @param cmpMode   比较模式，取最大还是取最小
     * @return  返回 S 对应的后置条件
     */
    private StringBuilder getToDesConca(String sReg1, String sReg2, int width, String cmpMode) {
        StringBuilder res = new StringBuilder();
        String[] vals1 = proveObject.getRegisterMap().get(sReg1).split(":");
        String[] vals2 = proveObject.getRegisterMap().get(sReg2).split(":");
        for (int i = 0; i < vals1.length; i++) {
            if (i < vals1.length - 1) {
                res.append("concatenateMInt(ifMInt (").append(vals2[i]).append(" ").append(cmpMode).append(" ").append(vals1[i])
                        .append(") then (mi(").append(width).append(", ").append(vals1[i]).append(")) else mi(")
                        .append(width).append(", ").append(vals2[i]).append(") ,");
            } else {
                res.append(" ifMInt (").append(vals2[i]).append(" ").append(cmpMode).append(" ").append(vals1[i]).append(") then mi(")
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
                concaVal.append("mi(32, ").append(proveObject.getRegisterMap().get(reg));
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
}
