package com;

import com.parser.FileParser;
import com.parser.fileParserImpl.FileParserImpl;
import com.pojo.ProveObject;
import com.specProve.RunProve;

import java.io.IOException;
import java.util.InputMismatchException;


public class Prove {

    private static String filename;

    /**
     * 脚本
     *  1、命令行输入要包含要验证的程序以及相关前后置条件的文件名
     *  2、读取文件内容
     *      a、读取验证程序按顺序存储指令
     *      b、使用Map存储前置条件，主要用于 变量范围的映射关系
     *      c、使用Map存储后置条件，理由同上
     *  3、按顺序读取指令，根据指令类型分而治之
     *      a、如MOV、VMOV等简单语义的指令，单次调用kprove处理，提取结果作为下一指令的前置条件（多条该类型的指令可以单次调用kprove直接验证）
     *      b、如VMAX、VMAXA等可以调用kprove单次完成验证的指令，就不进行子问题拆分，直接验证，提取结果作为下一指令的前置条件
     *          但需要对值进行分解，因为后续指令可能会运用到该向量寄存器的值，而实际上向量寄存器的值存储于4个对应的32位寄存器中。
     *      c、如VMAXV等无法利用kprove单次完成验证的指令（由于工具OOM），进行组合验证（拆分子问题），每次验证其子问题，提取结果作为下一指令的
     *          前置条件
     *  4、从3中可分为很多顺序执行的验证问题，当其中任意一步验证结果为false时，则证明验证结果为错误，所有为True才为真。
     * @param args
     */
    public static void main(String[] args) throws IOException {
        //GetOpt getOpt = new GetOptImpl();
        // 获取文件名
        //String filename = getOpt.getOptFromCommandLine(args[0], args, "-:f");

        // 从命令行中获取需要验证的文档
        if (args.length > 0) {
            boolean proveFile = false;
            for (String s : args) {
                if ("--file".equals(s)) {
                    proveFile = true;
                } else if (proveFile) {
                    filename = s;
                    break;
                }
            }
        }
        if (filename == null)
            throw new IOException("请输入所要验证的文档");

        // 从文件中提取所需信息：程序指令、前置条件、后置条件
        FileParser fileParser = new FileParserImpl();
        ProveObject proveObject = fileParser.fileParser(filename);

        // 判断命令行中是否有入参
        if (args.length > 0) {
            boolean smtPrelude = false;
            for (String s : args) {
                if ("--smt-prelude".equals(s)) {
                    smtPrelude = true;
                } else if (smtPrelude) {
                    try {
                        proveObject.setSmtPrelude(s);
                        break;
                    } catch (RuntimeException ex) {
                        ex.printStackTrace();
                    }
                }
            }
        }

        /*
         * TODO: 按顺序处理指令，以及设定前置条件、后置条件
         * 从信息集中提取相关前置、后置条件，设定对应验证程序
         * 调用操作系统运行验证程序，从输出中获取结果，若 #True 则为正确，可以进行下一指令的运行
         */
        long startTime = System.currentTimeMillis();
        //进入指令处理循环，首先解析指令
        RunProve runProve = new RunProve();
        boolean result = runProve.run(proveObject);
        long endTime = System.currentTimeMillis();
        System.out.println(String.format("执行用时：%d 毫秒", (endTime - startTime)));
        if (result)
            System.out.println("#True");
        else
            System.out.println("#False");
    }
}
