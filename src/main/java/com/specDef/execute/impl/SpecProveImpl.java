package com.specDef.execute.impl;

import com.specDef.execute.SpecProve;

import java.io.*;

public class SpecProveImpl implements SpecProve {
    @Override
    public String executeSpecProve(String cmd, File dir) throws IOException {
        // 存储kprove验证返回的结果
        StringBuilder result = new StringBuilder();
        Process process = null;
        BufferedReader bufIn = null;
        BufferedReader bufError = null;
        try {
            // 调用操作系统执行命令，返回一个子进程对象
            process = Runtime.getRuntime().exec(cmd, null, dir);
            // 方法阻塞，等待命令执行完成
            process.waitFor();
            // 获取命令执行结果，有两个结果：正常的输出 和 错误的输出 （获取子进程的输出）
            bufIn = new BufferedReader(new InputStreamReader(process.getInputStream(), "UTF-8"));
            bufError = new BufferedReader(new InputStreamReader(process.getErrorStream(), "UTF-8"));
            // 读取输出
            String line = null;
            while ((line = bufIn.readLine()) != null) {
                result.append(line).append("\n");
            }
            while ((line = bufError.readLine()) != null) {
                result.append(line).append("\n");
            }
        } catch (RuntimeException ex) {
            ex.printStackTrace();
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        } finally {
            closeStream(bufIn);
            closeStream(bufError);
            // 销毁子进程
            if (process != null) {
                process.destroy();
            }
        }
        return result.toString();
    }

    private static void closeStream(Closeable stream) {
        if (stream != null) {
            try {
                stream.close();
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }
}
