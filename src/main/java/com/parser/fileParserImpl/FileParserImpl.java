package com.parser.fileParserImpl;

import com.parser.FileParser;
import com.pojo.ProveObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.math.BigInteger;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class FileParserImpl implements FileParser {

    // 用于类似 -23 <= ABD < 1566，此处需要判断整个范围是否为true，即 -1 < A < -2 是非法的
    private final String pattern1 = "^[ ]*(-?\\d+|-?\\d+\\^?\\d+)[ ]*(<=|<|>|>=)[ ]*([A-Za-z]+\\d*[ ]*([\\+\\*\\/\\-]*[ ]*[A-Za-z]*\\d*[ ]*)*)(<=|<|>|>=)[ ]*(-?\\d+\\^?\\d+|-?\\d+)";

    // A321 = -213213
    private final String pattern2 = "^[ ]*([A-Za-z]+\\d*[ ]*([\\+\\*\\/\\-]*[ ]*[A-Za-z]*\\d*[ ]*)*)[ ]*(=|<=|>=|<|>)[ ]*(-?\\d+\\^?\\d+|-?\\d+)";

    // 无穷小
    private final BigInteger minValue = new BigInteger("-2").pow(128).subtract(BigInteger.ONE);
    // 无穷大
    private final BigInteger maxValue = new BigInteger("2").pow(128).add(BigInteger.ONE);

    /**
     * 获取文档中的初始信息
     * 设定 程序、前置条件、后置条件
     * 后置条件设定为寄存器，最终验证该寄存器是否满足条件
     * @param filename
     * @return
     */
    @Override
    public ProveObject fileParser(String filename) {
        // 获取当前路径
        String curPath = System.getProperty("user.dir");
        // 读取文件
        try (BufferedReader br =  Files.newBufferedReader(Paths.get(curPath + System.getProperty("file.separator") + filename))) {
            ProveObject proveObject = new ProveObject();
            String line;
            List<String> instList = new ArrayList<>();
            Map<String, BigInteger[]> preConditions = new HashMap<>();
            Map<String, BigInteger[]> postConditions = new HashMap<>();
            boolean valid = true;
            while ((line = br.readLine()) != null) {
                if (line.matches("^start.*")) {
                    while ((line = br.readLine()) != null) {
                        if (line.matches("^end.*")) {
                            break;
                        }
                        if (line.trim().equals(""))
                            continue;
                        instList.add(line.trim());
                    }
                    if (instList == null)
                        throw new InputMismatchException();
                    proveObject.setInstructions(instList);
                } else if (line.matches("^preCond.*")) {
                    boolean flag = true;
                    while ((line = br.readLine()) != null) {
                        if (line.length() == 0 || line.trim().length() == 0)
                            continue;
                        if (line.matches("^postCond.*")) {
                            flag = false;
                            continue;
                        }
                        if (flag) {
                            BigInteger[] range = new BigInteger[2];
                            String tag = getTag(line, range);
                            if (tag != null) {
                                preConditions.put(tag, range);
                            } else {
                                valid = false;
                                throw new InputMismatchException("前置条件获取失败");
                            }
                        } else {
                            BigInteger[] range = new BigInteger[2];
                            String tag = getTag(line, range);
                            if (tag != null) {
                                postConditions.put(tag, range);
                            } else {
                                valid = false;
                                throw new InputMismatchException("后置条件获取失败");
                            }
                        }
                    }
                }
            }
            if (valid == false) {
                throw new InputMismatchException();
            }
            proveObject.setPostCond(postConditions);
            proveObject.setPreCond(preConditions);
            proveObject.setRegisterMap(new HashMap<>());
            return proveObject;
        } catch (IOException ex) {
            ex.printStackTrace();
            return null;
        } catch (InputMismatchException ex) {
            System.err.println("输入范围非法 或 验证程序为空，请重新输入");
            return null;
        }
    }

    /**
     * 解析前后置条件，返回对应变量，并将变量对应的范围存储到BigInteger[2]数组range中，range[0]为左界，range[1]为右界
     * @param str   对应被解析的变量范围字符串
     * @param range 存储范围左右界的数组
     * @return   返回该范围对应的变量 tag
     */
    public String getTag(String str, BigInteger[] range) {
        Pattern pattern = Pattern.compile(pattern1);
        Matcher m = pattern.matcher(str);
        // pattern1
        if (m.find()) {
            String num1 = m.group(1);
            String symbol1 = m.group(2);
            String tag = m.group(3).trim();
            String symbol2 = m.group(5);
            String num2 = m.group(6);
            BigInteger big1 = null, big2 = null;
            if (("<".equals(symbol1) || "<=".equals(symbol1)) && (">".equals(symbol2) || ">=".equals(symbol2))) {
                System.err.println("输入条件非法，请重新输入 : " + m.group(0));
                return null;
            } else if ((">".equals(symbol1) || ">=".equals(symbol1)) && ("<".equals(symbol2) || "<=".equals(symbol2))) {
                System.err.println("输入条件非法，请重析输入 : " + m.group(0));
                return null;
            }
            if (num1.contains("^")) {
                String[] num1Group = num1.split("\\^");
                BigInteger base = new BigInteger(num1Group[0]);
                int index = Integer.parseInt(num1Group[1]);
                if (base.compareTo(BigInteger.ZERO) == -1 && index % 2 == 0) {
                    //big1 = base.pow(index);
                    big1 = base.pow(index).multiply(BigInteger.valueOf(-1));
                } else {
                    big1 = base.pow(index);
                }
            } else
                big1 = new BigInteger(num1);

            if (num2.contains("^")) {
                String[] num2Group = num2.split("\\^");
                BigInteger base = new BigInteger(num2Group[0]);
                int index = Integer.parseInt(num2Group[1]);
                if (base.compareTo(BigInteger.ZERO) == -1 && index % 2 == 0) {
                    //big2 = base.pow(index);
                    big2 = base.pow(index).multiply(BigInteger.valueOf(-1));
                } else {
                    big2 = base.pow(index);
                }
            } else
                big2 = new BigInteger(num2);

            // pattern1是小于或小于等于，因此当出现左界大于右界的情况就非法
            if ((("<".equals(symbol1) || "<=".equals(symbol1)) && big1.compareTo(big2) == 1) ||
                    ((">".equals(symbol1) || ">=".equals(symbol1)) && big1.compareTo(big2) == -1)) {
                System.err.println("输入条件非法（范围恒为false），请重新输入 : " + m.group(0));
                return null;
            }
            // 当存在没有等于的符号，存在相等的情况就非法
            if ("<".equals(symbol1) || "<".equals(symbol2) || ">".equals(symbol1) || ">".equals(symbol2)) {
                if (big1.compareTo(big2) == 0) {
                    System.err.println("输入条件非法（范围恒为false），请重析输入 : " + m.group(0));
                    return null;
                }
            }
            // 设定该值对应范围，用BigInteger数组存储
            if (big1.compareTo(big2) == 1) {
                if (">".equals(symbol2))
                    range[0] = big2.add(BigInteger.ONE);
                else
                    range[0] = big2;
                if (">".equals(symbol1))
                    range[1] = big1.subtract(BigInteger.ONE);
                else
                    range[1] = big1;
            } else {
                if ("<".equals(symbol1))
                    range[0] = big1.add(BigInteger.ONE);
                else
                    range[0] = big1;
                if ("<".equals(symbol2))
                    range[1] = big2.subtract(BigInteger.ONE);
                else
                    range[1] = big2;
            }
            return tag;
        }

        // pattern2，tag在最左侧，tag不在最左侧的判定非法，重新输入
        pattern = Pattern.compile(pattern2);
        m = pattern.matcher(str);
        if (m.find()) {
            String tag = m.group(1).trim();
            String symbol = m.group(3);
            String num = m.group(4);
            BigInteger big = null;
            if (num.contains("\\^")) {
                String[] bigGroup = num.split("\\^");
                BigInteger base = new BigInteger(bigGroup[0]);
                int index = Integer.parseInt(bigGroup[1]);
                if (base.compareTo(BigInteger.ZERO) == -1)
                    big = base.pow(index).multiply(BigInteger.valueOf(-1));
                else
                    big = base.pow(index);
            } else {
                big = new BigInteger(num);
            }
            if ("=".equals(symbol)) {
                range[0] = big;
                range[1] = big;
                return tag;
            } else if ("<".equals(symbol)) {
                // 下界默认无穷，这里设为 -2^128-1
                range[0] = minValue;
                range[1] = big.subtract(BigInteger.ONE);
            } else if ("<=".equals(symbol)) {
                // 下界默认无穷，这里设为 -2^128-1
                range[0] = minValue;
                range[1] = big;
            } else if (">".equals(symbol)) {
                range[0] = big.add(BigInteger.ONE);
                // 上界默认无穷，这里设为 2^128+1
                range[1] = maxValue;
            } else if (">=".equals(symbol)) {
                range[0] = big;
                // 上界默认无穷，这里设为 2^128+1
                range[1] = maxValue;
            }
            return tag;
        }
        System.err.println("输入范围格式非法，请重新输入！: " + str);
        return null;
    }

    /*public StringBuilder removeBlank(String line) {
        int len = line.length();
        StringBuilder cur = new StringBuilder();
        for (int i = 0; i < len; i++) {
            if (line.charAt(i) != ' ') {
                cur.append(line.charAt(i));
            }
        }
        return cur;
    }*/
}
