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
            // 解析指令
            Instruction instructionStruct = instParser.instParse(instruction);
            // 将解析的指令信息输入前置条件适配器，用于配置前置条件
            preCondState.setInstruction(instructionStruct);
            // 将解析的指令信息输入后置条件适配器，用于配置后置条件
            postCondState.setInstruction(instructionStruct);
            // 将解析的指令信息输入程序设定适配器，用于设定验证程序
            programState.setInstruction(instructionStruct);
            // 创建spec目录，用于存储指令解析的结果
            SpecContext specContext = new SpecContext();
            // spec解析入口，解析的结果存储于specContext
            specContext = specConfig.specSet(specContext);
            if (specConfig == null)
                return false;
            // 设定spec文件
            File specFile = specConfig.setSpecFile(specContext);
            if (specFile == null)
                throw new RuntimeException();
            //String[] split = specFile.getName().split(System.getProperty("file.separator"));
            System.out.println("-----------  current instruction to prove: " + instruction + " ----------- ");
            System.out.println("----------- " + specFile.getName() + "begin prove ----------- ");
            result = specProve.executeSpecProve("kprove " + specFile.getName(), null);
            if (result == null)
                return false;
            System.out.println("============= Result : " + result);
            if (!result.matches("^#True\\n")) {
                return false;
            }
        }
        return true;
    }
}
