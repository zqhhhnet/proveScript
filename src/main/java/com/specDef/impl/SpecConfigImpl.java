package com.specDef.impl;

import com.specDef.config.PostCondState;
import com.pojo.SpecContext;
import com.specDef.SpecConfig;
import com.specDef.config.PreCondState;
import com.specDef.config.ProgramState;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
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
     * @return
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
            } else if ("VMAXV".equals(opcode) || "VMINV".equals(opcode)) {
                programSet = programState.vvIntProgramSet(specContext);
            } else if ("VMLAV".equals(opcode)) {
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
     * @return
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
            } else if ("VMAXNMV".equals(opcode) || "VMINNMV".equals(opcode)) {
                
            } else if ("VMLAV".equals(opcode)) {
                preCondition = preCondState.vecPreSet();
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
     * @return
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
            }
            // TODO: 其他指令相应处理
            // 都不匹配
            return postCondition;
        } catch (InputMismatchException ex) {
            System.err.println("后置条件出错，请检查");
            return null;
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
            specContext.setInstList(programSet);
            specContext.setPostCondition(postConditionSet);
            specContext.setPreCondition(preConditionSet);
            return specContext;
        } catch (RuntimeException ex) {
            ex.printStackTrace();
            return null;
        }
    }

    private String fileRef = "require \"armv8-semantics.k\"\n";
    private String moduleImportRuleTillInstList = "\timports ARMV8-SEMANTICS\n\n\trule <k>\n\t\t\tscan => End\n\t\t</k>\n\t\t<begin>\n\t\t\t.K\n\t\t</begin>\n\t\t<currentstate>\n\t\t\t\"text\"\n\t\t</currentstate>\n\t\t<nextloc>    \n\t\t\t_:MInt\n\t\t</nextloc>\n\t\t<functarget>\n\t\t\tstart |-> mi(32, 0)\n\t\t</functarget>\n\t\t<instructiontext>\n";
    private String endInstListAndRegStateBegin = "\t\t</instructiontext>\n\t\t<regstate>\n";
    private String tempReg = "\t\t\t\"RESULT\" |-> mi(32, 0)\n\t\t\t\"RESULT64\" |-> mi(64, 0)\n";
    private String defaultReg = "\t\t\t\"R15\" |-> (memloc(mi(32, 0)) => memloc(mi(32, 1)))\n\t\t</regstate>\n";
    private String endModule = "endmodule\n";

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
            String codeMap = "\t\t\tcode (\n" + specContext.getInstList().stream().collect(Collectors.joining()) + "\t\t\t)\n";
            String regStateSet = specContext.getPostCondition().stream().collect(Collectors.joining());
            String preCondition = specContext.getPreCondition();
            if ("MOV".equals(opcode) || "VMOV".equals(opcode)) {
                String moduleName = "MOV".equals(opcode) ? "module SPEC-MOV-MODE\n" : "module SPEC-VMOV-MODE\n";
                String total = fileRef + moduleName + moduleImportRuleTillInstList + codeMap + endInstListAndRegStateBegin +
                        regStateSet + tempReg + defaultReg + preCondition + endModule;
                File file = new File(curPath + System.getProperty("file.separator") + ("MOV".equals(opcode) ?
                        "spec-mov-mode.k" : "spec-vmov-mode.k"));
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
                        regStateSet + defaultReg + preCondition + endModule;
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
                        regStateSet + defaultReg + preCondition + endModule;
                File file = new File(curPath + System.getProperty("file.separator") + "spec-vmlav-mode-" + count + ".k");
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
}
