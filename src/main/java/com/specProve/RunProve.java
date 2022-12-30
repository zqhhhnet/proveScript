package com.specProve;

import com.parser.instParserImpl.InstParserImpl;
import com.pojo.SpecContext;
import com.specDef.SpecConfig;
import com.specDef.config.PostCondState;
import com.specDef.config.PreCondState;
import com.specDef.config.ProgramState;
import com.specDef.impl.SpecConfigImpl;
import com.parser.InstParser;
import com.pojo.Instruction;
import com.pojo.ProveObject;
import com.specDef.execute.SpecProve;
import com.specDef.execute.impl.SpecProveImpl;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class RunProve {
    /**
     * 程序验证入口，按次序循环处理指令
     * @param proveObject   context
     * @return
     */
    public boolean run(ProveObject proveObject) throws RuntimeException, IOException {
        List<String> instructions = proveObject.getInstructions();
        if (instructions == null || instructions.isEmpty()) {
            System.err.println("程序为空，请重新输入");
            return false;
        }
        // 存放结果
        String result = null;
        // 指令解析器
        InstParser instParser = new InstParserImpl();
        // 前置条件适配器
        PreCondState preCondState = new PreCondState(proveObject);
        // 后置条件适配器
        PostCondState postCondState = new PostCondState(proveObject);
        // 程序设定适配器
        ProgramState programState = new ProgramState();
        // spec配置器
        SpecConfig specConfig = new SpecConfigImpl(preCondState, postCondState, programState);
        // 调用OS执行kprove验证程序
        SpecProve specProve = new SpecProveImpl();
        // TODO:需要优化，对于普通赋值指令和简单指令（单次可以验证）可以连续组成一个子问题
        // 按次序处理指令
        for (String instruction : instructions) {
            proveObject.setCurInst(proveObject.getCurInst()+1);
            // 解析指令
            Instruction instructionStruct = instParser.instParse(instruction);
            // 将解析的指令信息输入前置条件适配器，用于配置前置条件
            preCondState.setInstruction(instructionStruct);
            // 将解析的指令信息输入后置条件适配器，用于配置后置条件
            postCondState.setInstruction(instructionStruct);
            // 将解析的指令信息输入程序设定适配器，用于设定验证程序
            programState.setInstruction(instructionStruct);
            if ("VMAXV".equals(instructionStruct.getOpcode()) || "VMINV".equals(instructionStruct.getOpcode())
                || "VMAXAV".equals(instructionStruct.getOpcode()) || "VMINAV".equals(instructionStruct.getOpcode())) {
                // 根据数据类型，获取需要分解为多少个子问题
                int count = 128 / Integer.parseInt(instructionStruct.getDatatype().substring(1));
                if ("VMAXV".equals(instructionStruct.getOpcode()) || "VMINV".equals(instructionStruct.getOpcode()))
                    programState.setSubOpcode("cmp");
                else
                    programState.setSubOpcode("cmpAbs");
                for (int i = 0; i < count; i++) {
                    long oneInstTimeStart = System.currentTimeMillis();

                    // 创建spec目录，用于存储指令解析的结果
                    SpecContext specContext = new SpecContext();
                    // 将VMAXV指令分解为多个子问题，循环依次解决每个子问题
                    preCondState.setBeat(i);
                    postCondState.setBeat(i);
                    programState.setBeat(i);
                    // 每个子问题都更新目标寄存器的值，设置前置、程序、后置条件
                    specContext = specConfig.specSet(specContext);
                    if (specContext == null)
                        return false;
                    File specFile = specConfig.setSpecFile(specContext, i);
                    if (specFile == null)
                        throw new RuntimeException("spec构建异常，请重新检查");
                    System.out.println("-----------  current instruction to prove: " + instruction + " 第" + i + "个子问题"
                            + " ----------- ");
                    System.out.println("----------- " + specFile.getName() + " begin prove ----------- ");
                    // TODO: 将验证参数通过输入层更改
                    result = specProve.executeSpecProve("kprove " + specFile.getName() + " --z3-impl-timeout 150000", null);

                    long oneInstTimeEnd = System.currentTimeMillis();
                    System.out.printf("该次验证用时：%d 毫秒%n", (oneInstTimeEnd - oneInstTimeStart));

                    if (result == null)
                        return false;
                    System.out.println("============= Result : " + result.split("\\n")[0]);
                    if (!result.matches("^#True\\n[\\d\\D]*")) {
                        return false;
                    }
                }
                // 处理完一个指令，初始化存储regstate中源操作数状态的列表
                postCondState.setSourcePostCond(new ArrayList<>());
                continue;
            } else if ("VMLAV".equals(instructionStruct.getOpcode())) {
                for (int i = 0; i < 4; i++) {
                    long oneInstTimeStart = System.currentTimeMillis();

                    // 创建spec目录，用于存储指令解析的结果
                    SpecContext specContext = new SpecContext();
                    // 将VMAXV指令分解为多个子问题，循环依次解决每个子问题
                    preCondState.setBeat(i);
                    postCondState.setBeat(i);
                    programState.setBeat(i);
                    // 每个子问题都更新目标寄存器的值，设置前置、程序、后置条件
                    specContext = specConfig.specSet(specContext);
                    if (specContext == null)
                        return false;
                    File specFile = specConfig.setSpecFile(specContext, i);
                    if (specFile == null)
                        throw new RuntimeException("spec构建异常，请重新检查");
                    System.out.println("-----------  current instruction to prove: " + instruction + " 第" + i + "个子问题"
                            + " ----------- ");
                    System.out.println("----------- " + specFile.getName() + " begin prove ----------- ");
                    // 用QFNRA-NLSAT策略解决Non-Linear Integer问题
                    result = specProve.executeSpecProve("kprove " + specFile.getName() +
                            " --z3-impl-timeout 150000 --z3-tactic qfnra-nlsat", null);

                    long oneInstTimeEnd = System.currentTimeMillis();
                    System.out.printf("该次验证用时：%d 毫秒%n", (oneInstTimeEnd - oneInstTimeStart));

                    if (result == null)
                        return false;
                    System.out.println("============= Result : " + result.split("\\n")[0]);
                    if (!result.matches("^#True\\n[\\d\\D]*")) {
                        return false;
                    }
                }
                // 处理完一个指令，初始化存储regstate中源操作数状态的列表
                postCondState.setSourcePostCond(new ArrayList<>());
                continue;
            }
            long oneInstTimeStart = System.currentTimeMillis();

            // 创建spec目录，用于存储指令解析的结果
            SpecContext specContext = new SpecContext();
            // spec解析入口，解析的结果存储于specContext
            specContext = specConfig.specSet(specContext);
            if (specContext == null)
                return false;
            // 设定spec文件
            File specFile = specConfig.setSpecFile(specContext, 0);
            if (specFile == null)
                throw new RuntimeException();
            //String[] split = specFile.getName().split(System.getProperty("file.separator"));
            System.out.println("-----------  current instruction to prove: " + instruction + " ----------- ");
            System.out.println("----------- " + specFile.getName() + " begin prove ----------- ");
            // 加入 --smt-prelude 支持int_abs等Z3 function
            /*result = specProve.executeSpecProve("kprove " + specFile.getName()
                    + " --z3-impl-timeout 15000 --smt-prelude " + System.getProperty("file.separator") + "home"
                    + System.getProperty("file.separator") + "hhh1" + System.getProperty("file.separator") + "kkkk"
                    + System.getProperty("file.separator") + "old-ver" + System.getProperty("file.separator")
                    + "kframework-5.0.0" + System.getProperty("file.separator") + "k-distribution" + System.getProperty("file.separator")
                    + "include" + System.getProperty("file.separator") + "z3" + System.getProperty("file.separator")
                    + "basic.smt2", null);*/
            result = proveObject.getSmtPrelude() == null ? specProve.executeSpecProve("kprove "
                    + specFile.getName() + " --z3-impl-timeout 15000", null) :
                    specProve.executeSpecProve("kprove " + specFile.getName() + " --z3-impl-timeout 15000 " +
                            "--smt-prelude " + proveObject.getSmtPrelude(), null);

            long oneInstTimeEnd = System.currentTimeMillis();
            System.out.printf("该次验证用时：%d 毫秒%n", (oneInstTimeEnd - oneInstTimeStart));

            if (result == null)
                return false;
            System.out.println("============= Result : " + result.split("\\n")[0]);

            if (!result.matches("^#True\\n[\\d\\D]*")) {
                return false;
            }
        }
        return true;
    }
}
