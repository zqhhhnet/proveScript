/*
package command.impl;

import GetOpt;
import gnu.getopt.Getopt;
import gnu.getopt.LongOpt;

public class GetOptImpl implements GetOpt {

    */
/**
     * 获取命令行中输入的文件名
     * @param arg0
     * @param args
     * @param opt
     * @return
     *//*

    @Override
    public String getOptFromCommandLine(String arg0, String[] args, String opt) {
        //LongOpt[] longOpts = new LongOpt[1];    // 使用Longopt设置长选项参数
        //longOpts[0] = new LongOpt("file", LongOpt.REQUIRED_ARGUMENT, null, 'f');
        Getopt getopt = new Getopt(arg0, args, opt);
        int res;
        String str = "";
        while ((res = getopt.getopt()) != -1) {
            switch (res) {
                case 'f':
                    str = getopt.getOptarg();
                    System.out.println("验证的文件为：" + ((str != null) ? str : "null"));
                    break;
                case '?':
                    System.out.println("选项不合法，请重新输入");
                    break;
                default:;
            }
        }
        return str;
    }
}
*/
