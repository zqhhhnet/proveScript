package com.specDef.impl;

import com.specDef.config.PostCondState;
import com.pojo.SpecContext;
import com.specDef.SpecConfig;
import com.specDef.config.PreCondState;
import com.specDef.config.ProgramState;

import java.io.File;
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

    @Override
    public List<String> programSet(SpecContext specContext) {
        try {
            String opcode = programState.getInstruction().getOpcode();
            if (opcode == null)
                throw new RuntimeException();
            if ("MOV".equals(opcode) || "VMOV".equals(opcode)) {
                List<String> programSet = programState.simpleProgramSet(specContext);
                return programSet;
            }

            // TODO: 其他指令相应处理
            return null;
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
            if (opcode == null)
                throw new InputMismatchException();
            if ("MOV".equals(opcode)) {
                String preCondtion = preCondState.simplePreSet();
                return preCondtion;
            } else if ("VMOV".equals(opcode)) {   // TODO: 其他指令相应处理
                String preCondition = preCondState.vecSimplePreSet();
                return preCondition;
            }/* else if (opcode.equals("VMAX") || opcode.equals("VMAXA")) {

            }*/
            return null;
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
            if (opcode == null)
                throw new InputMismatchException();
            if ("MOV".equals(opcode)) {
                List<String> postCondition = postCondState.simplePostSet();
                return postCondition;
            } else if ("VMOV".equals(opcode)) {
                List<String> postCondition = postCondState.vecSimplePostSet();
                return postCondition;
            }
            // TODO: 其他指令相应处理
            // 都不匹配
            return null;
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
    private String defaultReg = "\t\t\t\"R15\" |-> (memloc(mi(32, 0)) => memloc(mi(32, 1)))\n\t\t\t\"RESULT\" |-> mi(32, 0)\n\t\t\t\"RESULT64\" |-> mi(64, 0)\n\t\t</regstate>\n";
    private String endModule = "endmodule\n";

    /**
     * 设定specFile
     * @param specContext
     * @return  返回file
     */
    @Override
    public File setSpecFile(SpecContext specContext) {
        FileOutputStream fos = null;
        try {
            String opcode = preCondState.getInstruction().getOpcode();
            if (opcode == null)
                throw new IOException();
            if ("MOV".equals(opcode) || "VMOV".equals(opcode)) {
                String moduleName = "MOV".equals(opcode) ? "module SPEC-MOV-MODE\n" : "module SPEC-VMOV-MODE\n";
                List<String> instList = specContext.getInstList();
                // 将code中，目标操作数和源操作数的寄存器的大写字母变为小写字母
                String codeMap = "\t\t\tcode (\n" + instList.stream().collect(Collectors.joining()) + "\t\t\t)\n";
                List<String> postCondition = specContext.getPostCondition();
                String regStateSet = postCondition.stream().collect(Collectors.joining());
                String preCondition = specContext.getPreCondition();
                preCondition = "\t\t\trequires " + preCondition;
                String total = fileRef + moduleName + moduleImportRuleTillInstList + codeMap + endInstListAndRegStateBegin +
                        regStateSet + defaultReg + preCondition + endModule;
                String curPath = System.getProperty("user.dir");
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
}
