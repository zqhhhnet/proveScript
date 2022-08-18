package com.command;


public interface GetOpt {
    /**
     * 从命令行输入中获取输入文档名称
     * @return
     */
    public String getOptFromCommandLine(String arg0, String[] args, String opt);
}
