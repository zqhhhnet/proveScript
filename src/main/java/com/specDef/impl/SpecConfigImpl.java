package com.specDef.impl;

import com.pojo.Instruction;
import com.pojo.ProveObject;
import com.specDef.config.PostCondState;
import com.pojo.SpecContext;
import com.specDef.SpecConfig;
import com.specDef.config.PreCondState;
import com.specDef.config.ProgramState;
import java.lang.String;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.InputMismatchException;
import java.util.List;
import java.util.stream.Collectors;

public class SpecConfigImpl implements SpecConfig {

    private PreCondState preCondState;
    private PostCondState postCondState;
    private ProgramState programState;


    public SpecConfigImpl(PreCondState preCondState, PostCondState postCondState, ProgramState programState) {
        this.preCondState = preCondState;
        this.postCondState = postCondState;
        this.programState = programState;
    }

    /**
     * spec中，code text的设置
     * @param specContext
     * @return 返回验证程序
     */
    @Override
    public List<String> programSet(SpecContext specContext) {
        try {
            List<String> programSet = null;
            String opcode = programState.getInstruction().getOpcode();
            if (opcode == null)
                throw new RuntimeException();
            if ("MOV".equals(opcode) || "VMOV".equals(opcode)) {
                programSet = programState.simpleProgramSet(specContext);
                return programSet;
            } else if ("VMAXV".equals(opcode) || "VMINV".equals(opcode)
                    || "VMAX".equals(opcode) || "VMIN".equals(opcode)
                    || "VMAXA".equals(opcode) || "VMINA".equals(opcode)
                    || "VMLAV".equals(opcode) || "VMAXAV".equals(opcode) || "VMINAV".equals(opcode)) {
                programSet = programState.vvIntProgramSet(specContext);
            } else if ("VADD".equals(opcode) || "VSUB".equals(opcode) || "VMUL".equals(opcode)
                    || "VAND".equals(opcode) || "VORR".equals(opcode) || "VDUP".equals(opcode)
                    || "VNEG".equals(opcode) || "VSHR".equals(opcode) || "VSHL".equals(opcode)
                    || "VRSHL".equals(opcode) || "VMLA".equals(opcode) || "VQADD".equals(opcode)
                    || "VQRDMULH".equals(opcode)) {
                programSet = programState.vvIntProgramSet(specContext);
            }

            // TODO: 其他指令相应处理
            return programSet;
        } catch (RuntimeException ex) {
            System.err.println("输入程序设定异常，请重试或检查");
            return null;
        }
    }

    /**
     * 前置条件解析与设置
     * 按照不同指令进行设定
     * @return 返回前置条件
     */
    @Override
    public String preConditionSet() {
        try {
            String opcode = preCondState.getInstruction().getOpcode();
            String preCondition = null;
            if (opcode == null)
                throw new InputMismatchException();
            if ("MOV".equals(opcode)) {
                preCondition = preCondState.simplePreSet();
            } else if ("VMOV".equals(opcode)) {
                preCondition = preCondState.vecSimplePreSet();
            } else if ("VMAXV".equals(opcode) || "VMINV".equals(opcode)) {
                preCondition = preCondState.vvIntPreSet();
            } else if ("VMLAV".equals(opcode)) {
                preCondition = preCondState.vecPreSet();
            } else if ("VMAXAV".equals(opcode) || "VMINAV".equals(opcode)) {
                preCondition = preCondState.vvIntPreSet();
            } else if ("VMAX".equals(opcode) || "VMIN".equals(opcode)
                    || "VMAXA".equals(opcode) || "VMINA".equals(opcode) || "VRSHL".equals(opcode)
                    || "VQADD".equals(opcode)) {
                preCondition = preCondState.allVecPreSet();
            } else if ("VADD".equals(opcode) || "VSUB".equals(opcode) || "VMUL".equals(opcode)) {
                if (preCondState.getInstruction().getSourceRegister().get(1).charAt(0) == 'R') {
                    preCondition = preCondState.vecAndGeneralPreSet();
                } else {
                    preCondition = preCondState.allVecPreSet();
                }
            } else if ("VAND".equals(opcode) || "VORR".equals(opcode)) {
                preCondition = preCondState.allVecPreSetNoDataType();
            } else if ("VDUP".equals(opcode)) {
                preCondition = preCondState.vdupRQPreSet();
            } else if ("VNEG".equals(opcode) || "VSHR".equals(opcode) || "VSHL".equals(opcode)
                    || "VMLA".equals(opcode) || "VQRDMULH".equals(opcode)) {
                preCondition = preCondState.vecAndGeneralPreSet();
            }
            // TODO: 其他指令相应处理
            return preCondition;
        } catch (InputMismatchException ex) {
            System.err.println("指令信息出错，请检查输入");
            return null;
        }
    }

    /**
     * 后置条件解析与设定
     * 需要根据指令分别处理
     * TODO: 加入ensures
     * @return 返回后置条件
     */
    @Override
    public List<String> postConditionSet() {
        try {
            String opcode = postCondState.getInstruction().getOpcode();
            List<String> postCondition = null;
            if (opcode == null)
                throw new InputMismatchException();
            if ("MOV".equals(opcode)) {
                postCondition = postCondState.simplePostSet();
            } else if ("VMOV".equals(opcode)) {
                postCondition = postCondState.vecSimplePostSet();
            } else if ("VMAXV".equals(opcode) || "VMINV".equals(opcode)) {
                postCondition = postCondState.vvIntPostSet();
            } else if ("VMLAV".equals(opcode)) {
                postCondition = postCondState.innerProductPostSet();
            } else if ("VMAXAV".equals(opcode) || "VMINAV".equals(opcode)) {
                postCondition = postCondState.vvIntAbsPostSet();
            } else if ("VMAXA".equals(opcode) || "VMINA".equals(opcode)
                    || "VMAX".equals(opcode) || "VMIN".equals(opcode)) {
                postCondition = postCondState.allVecPostSet();
            } else if ("VADD".equals(opcode)) {
                if (preCondState.getInstruction().getSourceRegister().get(1).charAt(0) == 'R') {
                    postCondition = postCondState.vaddQRPostSet();
                } else {
                    postCondition = postCondState.vaddQQPostSet();
                }
                // TODO:postCondition = postCondState.vaddQQPostSet();
            } else if ("VSUB".equals(opcode)) {
                if (preCondState.getInstruction().getSourceRegister().get(1).charAt(0) == 'R') {
                    postCondition = postCondState.vsubQRPostSet();
                } else {
                    postCondition = postCondState.vsubQQPostSet();
                }
            } else if ("VMUL".equals(opcode)) {
                if (preCondState.getInstruction().getSourceRegister().get(1).charAt(0) == 'R') {
                    postCondition = postCondState.vmulQRPostSet();
                } else {
                    //postCondition = postCondState.vmulQQPostSet();
                }
            } else if ("VSHR".equals(opcode)) {
                postCondition = postCondState.vshrQImmPostSet();
            } else if ("VSHL".equals(opcode)) {
                postCondition = postCondState.vshlQImmPostSet();
            } else if ("VORR".equals(opcode)) {
                if (preCondState.getInstruction().getDatatype() == null) {
                    postCondition = postCondState.vorrQQPostSet();
                }
                // 立即数
            } else if ("VAND".equals(opcode)) {
                postCondition = postCondState.vandQQPostSet();
            } else if ("VDUP".equals(opcode)) {
                postCondition = postCondState.vdupQRPostSet();
            } else if ("VNEG".equals(opcode)) {
                postCondition = postCondState.vnegQQPostSet();
            } else if ("VMLA".equals(opcode)) {
                postCondition = postCondState.vmlaQRPostSet();
            } else if ("VRSHL".equals(opcode)) {
                postCondition = postCondState.vrshlQQPostSet();
            } else if ("VQADD".equals(opcode)) {    //fpscr
                postCondition = postCondState.vqaddQQPostSet();
            } else if ("VQRDMULH".equals(opcode)) { //fpscr
                postCondition = postCondState.vqrdmulhQRPostSet();
            }
            // TODO: 其他指令相应处理
            // 都不匹配
            return postCondition;
        } catch (InputMismatchException ex) {
            System.err.println("后置条件出错，请检查");
            return null;
        }
    }

    @Override
    public String safetyPropertySet() {
        // 获取需要安全验证的元素以及所要验证的后置条件范围
        // 安全属性的范围根据指令数据类型进行限制
        // 有数据类型则按照数据类型的范围，无数据类型，则按照beat的范围
        ProveObject proveObject = postCondState.getProveObject();
        Instruction instruction = postCondState.getInstruction();
        List<String> safetyElement = proveObject.getSafetyElement();
        StringBuilder safetyQuery = new StringBuilder();
        if (safetyElement == null || safetyElement.isEmpty()) {
            return "";
        } else {
            return safetySet();
        }
    }

    /**
     * 总接口，把所有的解析结果存到specContext
     * @param specContext
     */
    @Override
    public SpecContext specSet(SpecContext specContext) {
        try {
            String preConditionSet = preConditionSet();
            if (preConditionSet == null)
                throw new RuntimeException("前置条件为空");
            List<String> postConditionSet = postConditionSet();
            if (postConditionSet == null || postConditionSet.isEmpty())
                throw new RuntimeException("后置条件为空");
            List<String> programSet = programSet(specContext);
            if (programSet == null || programSet.isEmpty())
                throw new RuntimeException("程序设置为空");
            String safetySet = safetyPropertySet();
            specContext.setInstList(programSet);
            specContext.setPostCondition(postConditionSet);
            specContext.setPreCondition(preConditionSet);
            specContext.setSafetyToEnsures(safetySet);
            return specContext;
        } catch (RuntimeException ex) {
            ex.printStackTrace();
            return null;
        }
    }

    private final String fileRef = "require \"armv8-semantics.k\"\n";
    private final String moduleImportRuleTillInstList = "\timports ARMV8-SEMANTICS\n\n\trule <k>\n\t\t\tscan => End\n\t\t</k>\n\t\t<begin>\n\t\t\t.K\n\t\t</begin>\n\t\t<currentstate>\n\t\t\t\"text\"\n\t\t</currentstate>\n\t\t<nextloc>    \n\t\t\t_:MInt\n\t\t</nextloc>\n\t\t<functarget>\n\t\t\tstart |-> mi(32, 0)\n\t\t</functarget>\n\t\t<instructiontext>\n";
    private final String endInstListAndRegStateBegin = "\t\t</instructiontext>\n\t\t<regstate>\n";
    private final String tempReg = "\t\t\t\"RESULT\" |-> mi(32, 0)\n\t\t\t\"RESULT64\" |-> mi(64, 0)\n";
    private final String defaultReg = "\t\t\t\"R15\" |-> (memloc(mi(32, 0)) => memloc(mi(32, 1)))\n\t\t</regstate>\n";
    private final String endModule = "endmodule\n";

    /**
     * 根据不同指令设定specFile
     * @param specContext
     * @param count     作为组合验证处理时，处理子问题的序号，用于生成多个子文件spec
     * @return  返回file
     */
    @Override
    public File setSpecFile(SpecContext specContext, int count) {
        FileOutputStream fos = null;
        try {
            String opcode = preCondState.getInstruction().getOpcode();
            if (opcode == null)
                throw new IOException();
            String curPath = System.getProperty("user.dir");
            String codeMap = "\t\t\tcode (\n" + String.join("", specContext.getInstList()) + "\t\t\t)\n";
            String regStateSet = String.join("", specContext.getPostCondition());
            String preCondition = specContext.getPreCondition();
            String safetyToEnsures = specContext.getSafetyToEnsures();
            if ("MOV".equals(opcode) || "VMOV".equals(opcode)) {
                String moduleName = "MOV".equals(opcode) ? "module SPEC-MOV-MODE\n" : (
                        preCondState.getInstruction().getDatatype() == null ? "module SPEC-VMOV-MODE\n" :
                        "module SPEC-VMOV-LANE-MODE\n");
                String total = fileRef + moduleName + moduleImportRuleTillInstList + codeMap + endInstListAndRegStateBegin +
                        regStateSet + tempReg + defaultReg + preCondition + endModule;
                File file;
                file = new File(curPath + System.getProperty("file.separator") + ("MOV".equals(opcode) ?
                        "spec-mov-mode.k" : preCondState.getInstruction().getDatatype() == null ?
                        "spec-vmov-mode.k" : "spec-vmov-lane-mode.k"));
                System.out.println(file.getName());
                fos = new FileOutputStream(file);
                byte[] bytes = total.getBytes(StandardCharsets.UTF_8);
                fos.write(bytes);
                //System.out.println(file.getName() + " before");
                fos.flush();
                //System.out.println(file.getName() + " after");
                return file;
            } else if ("VMAXV".equals(opcode) || "VMINV".equals(opcode)) {
                StringBuilder moduleName = new StringBuilder();
                moduleName.append("module SPEC-").append(opcode).append("-MODE").append('-').append(count).append('\n');
                String total = fileRef + moduleName + moduleImportRuleTillInstList + codeMap + endInstListAndRegStateBegin +
                        regStateSet + defaultReg + preCondition + "\n" + safetyToEnsures + endModule;
                String curOpcode = "VMAXV".equals(opcode) ? "spec-vmaxv-mode-" : "spec-vminv-mode-";
                File file = new File(curPath + System.getProperty("file.separator") + curOpcode + count + ".k");
                System.out.println(file.getName());
                fos = new FileOutputStream(file);
                makeFile(fos, total);
                return file;
            } else if ("VMLAV".equals(opcode)) {
                StringBuilder moduleName = new StringBuilder();
                moduleName.append("module SPEC-").append(opcode).append("-MODE").append('-').append(count).append('\n');
                String total = fileRef + moduleName + moduleImportRuleTillInstList + codeMap + endInstListAndRegStateBegin +
                        regStateSet + defaultReg + preCondition + "\n" + safetyToEnsures + endModule;
                File file = new File(curPath + System.getProperty("file.separator") + "spec-vmlav-mode-" + count + ".k");
                System.out.println(file.getName());
                fos = new FileOutputStream(file);
                makeFile(fos, total);
                return file;
            } else if ("VMAXAV".equals(opcode) || "VMINAV".equals(opcode)) {
                StringBuilder moduleName = new StringBuilder();
                moduleName.append("module SPEC-").append(opcode).append("-MODE").append('-').append(count).append('\n');
                String total = fileRef + moduleName + moduleImportRuleTillInstList + codeMap + endInstListAndRegStateBegin +
                        regStateSet + defaultReg + preCondition + "\n" + safetyToEnsures + endModule;
                String curOpcode = "VMAXAV".equals(opcode) ? "spec-vmaxav-mode-" : "spec-vminav-mode-";
                File file = new File(curPath + System.getProperty("file.separator") + curOpcode + count
                        + ".k");
                System.out.println(file.getName());
                fos = new FileOutputStream(file);
                makeFile(fos, total);
                return file;
            } else if ("VMAXA".equals(opcode) || "VMINA".equals(opcode)
                    || "VMAX".equals(opcode) || "VMIN".equals(opcode)) {
                StringBuilder moduleName = new StringBuilder();
                moduleName.append("module SPEC-").append(opcode).append("-ONCE\n");
                String total = fileRef + moduleName + moduleImportRuleTillInstList + codeMap + endInstListAndRegStateBegin +
                        regStateSet + defaultReg + preCondition + "\n" + safetyToEnsures + endModule;
                String curOpcode = "VMAXA".equals(opcode) ? "spec-vmaxa-once.k" :
                        ("VMINA".equals(opcode) ? "spec-vmina-once.k" :
                                ("VMAX").equals(opcode) ? "spec-vmax-once.k" : "spec-vmin-once.k");
                File file = new File(curPath + System.getProperty("file.separator") + curOpcode);
                System.out.println(file.getName());
                fos = new FileOutputStream(file);
                makeFile(fos, total);
                return file;
            } else if ("VADD".equals(opcode) || "VSUB".equals(opcode) || "VMUL".equals(opcode)
                    || "VAND".equals(opcode) || "VORR".equals(opcode) || "VDUP".equals(opcode)
                    || "VNEG".equals(opcode) || "VSHR".equals(opcode) || "VSHL".equals(opcode)
                    || "VRSHL".equals(opcode) || "VMLA".equals(opcode) || "VQADD".equals(opcode)
                    || "VQRDMULH".equals(opcode)) {
                StringBuilder moduleName = new StringBuilder();
                moduleName.append("module SPEC-").append(opcode).append("-ONCE\n");
                String total = "";
                if ("VQADD".equals(opcode) || "VQRDMULH".equals(opcode)) {
                    total = fileRef + moduleName + moduleImportRuleTillInstList + codeMap + endInstListAndRegStateBegin +
                        regStateSet + defaultReg + preCondition + endModule;
                } else {
                    total = fileRef + moduleName + moduleImportRuleTillInstList + codeMap + endInstListAndRegStateBegin +
                            regStateSet + defaultReg + preCondition + "\n" + safetyToEnsures + endModule;
                }
                String curOpcode = "spec-" + opcode.toLowerCase() + "-once.k";
                File file = new File(curPath + System.getProperty("file.separator") + curOpcode);
                System.out.println(file.getName());
                fos = new FileOutputStream(file);
                makeFile(fos, total);
                return file;
            }
            // TODO：其他指令的相应配置
        } catch (IOException ex) {
            ex.printStackTrace();
            System.err.println("spec设置出错，请重试");
            return null;
        } finally {
            try {
                if (fos != null)
                    fos.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    private void makeFile(FileOutputStream fos, String total) throws IOException {
        byte[] bytes = total.getBytes(StandardCharsets.UTF_8);
        fos.write(bytes);
        fos.flush();
    }

    private String safetySet() {
        Instruction instruction = postCondState.getInstruction();
        List<String> safetyElement = postCondState.getProveObject().getSafetyElement();
        StringBuilder safetyQuery = new StringBuilder();
        safetyQuery.append("\t\t\t\tensures ");
        if (instruction.getDatatype() == null) {
            int i = 0;
            for (String s : safetyElement) {
                if (i == 0) {
                    safetyQuery.append(s).append(" >=Int 0 andBool ").append(s).append(" <Int (2 ^Int 32) ");
                    i = 1;
                } else {
                    safetyQuery.append(" andBool ").append(s).append(" >=Int 0 andBool ").append(s)
                            .append(" <Int (2 ^Int 32) ");
                }
            }
            safetyQuery.append("\n");
        } else {
            int i = 0;
            String datatype = instruction.getDatatype();
            int size = Integer.parseInt(datatype.substring(1));
            if (datatype.charAt(0) == 'S') {
                String sBound = size == 8 ? "128" : (size == 16 ? "32768" : "2147483648");
                for (String s : safetyElement) {
                    if (i == 0) {
                        safetyQuery.append(s).append(" >=Int -").append(sBound).append(" andBool ")
                                .append(s).append(" <Int ").append(sBound);
                        i = 1;
                    } else {
                        safetyQuery.append(" andBool ").append(s).append(" >=Int -").append(sBound).append(" andBool ")
                                .append(s).append(" <Int ").append(sBound);
                    }
                }
            } else if (datatype.charAt(0) == 'U') {
                String uBound = size == 8 ? "256" : (size == 16 ? "65536" : "4294967296");
                for (String s : safetyElement) {
                    if (i == 0) {
                        safetyQuery.append(s).append(" >=Int 0 andBool ").append(s).append(" <Int ").append(uBound);
                        i = 1;
                    } else {
                        safetyQuery.append(" andBool ").append(s).append(" >=Int 0 andBool ")
                                .append(s).append(" <Int ").append(uBound);
                    }
                }
            } else if (datatype.charAt(0) == 'I') {
                String sBound = size == 8 ? "128" : (size == 16 ? "32768" : "2147483648");
                String uBound = size == 8 ? "256" : (size == 16 ? "65536" : "4294967296");
                safetyQuery.append("(");
                for (String s : safetyElement) {
                    if (i == 0) {
                        safetyQuery.append(s).append(" >=Int -").append(sBound).append(" andBool ")
                                .append(s).append(" <Int ").append(sBound);
                        i = 1;
                    } else {
                        safetyQuery.append(" andBool ").append(s).append(" >=Int -").append(sBound).append(" andBool ")
                                .append(s).append(" <Int ").append(sBound);
                    }
                }
                i = 0;
                safetyQuery.append(") orBool (");
                for (String s : safetyElement) {
                    if (i == 0) {
                        safetyQuery.append(s).append(" >=Int 0 andBool ").append(s).append(" <Int ").append(uBound);
                        i = 1;
                    } else {
                        safetyQuery.append(" andBool ").append(s).append(" >=Int 0 andBool ")
                                .append(s).append(" <Int ").append(uBound);
                    }
                }
                safetyQuery.append(")");
            }
            safetyQuery.append("\n");
        }
        return safetyQuery.toString();
    }
}
