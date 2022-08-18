package com.bv2int;

import sun.plugin2.util.SystemUtil;

/**
 * 算子 二进制转有符号整型
 */
public class Binary2Signed {

    /**
     * 2进制原码 转 十进制
     * @param binaryStr 2进制原码
     * @param includeSymbol 是否区分符号位
     * @return
     */
    public static String ORGBinToDec(String binaryStr, boolean includeSymbol) {
        String result = "";
        //有符号且符号为1，负数时特殊处理
        if (includeSymbol && binaryStr.charAt(0) == '1') {
            result = "-"+Integer.parseInt(binaryStr.substring(1), 2);
        } else {
            int i = Integer.parseInt(binaryStr, 2);
            result = String.valueOf(i);
        }
        return result;
    }

    /**
     * 2进制补码 转 十进制
     * 一般用这个 正数在计算机中原码补码相同 负数在计算机中以补码存储  可以理解为都是按照补码存储的
     * 11100110   真值-26
     * 注意：当转为无符号整数时，不能用这个函数，因为底层还是用Integer.parseInt，所以只有32位无法表示32位最高位为1的无符号整数
     * Java中整数32位默认是带符号数。
     * @param binaryStr 2进制补码
     * @param includeSymbol 是否区分符号位
     * @return
     */
    public static String AddBinToDec(String binaryStr, boolean includeSymbol) {
        String result = "";
        //有符号且符号为1，负数时特殊处理
        if (includeSymbol && binaryStr.charAt(0) == '1') {
            result = negativeBinToDec(binaryStr);
        } else {
            int i = Integer.parseInt(binaryStr, 2);
            result = String.valueOf(i);
        }
        return result;
    }

    /**
     * 2进制负数转10进制
     *
     * @param binaryStr
     * @return
     */
    public static String negativeBinToDec(String binaryStr) {
        //获取反码
        String oppositeCode =  getOppositeCode(binaryStr);
        //取反
        String negateBinary  = getNegate(oppositeCode);
        //转十进制带符号
        String result = "-"+Integer.parseInt(negateBinary, 2);
        return result;
    }

    /**
     * 补码 -> 反码
     *
     * @param binaryStr
     * @return
     */
    public static String getOppositeCode(String binaryStr) {
        /**
         * 补码减1，得反码；
         * 1.末尾为1，反码：末尾变0，其他位不变
         * 2.末尾为0，
         */
        int down = 0;
        int len = binaryStr.length();
        StringBuffer oppositeCode = new StringBuffer();
        if (binaryStr.charAt(len - 1) == '1') {
            oppositeCode = oppositeCode.append(binaryStr.substring(0, len - 1) + "0");
            return oppositeCode.toString();
        }
        for (int i = len - 1; i >= 0; i--) {
            if (i == len - 1) {
                oppositeCode.append(1);
                down = 1;
                continue;
            }
            int c =  binaryStr.charAt(i);
            c =Character.getNumericValue(c);
            int m = c - down;
            if (m == 0) {
                oppositeCode.append(0);
                down = 0;
                continue;
            }
            if (m == -1) {
                oppositeCode.append(1);
                down = 1;
                continue;
            }
            if (m == 1) {
                oppositeCode.append(1);
                down = 0;
                continue;
            }
        }
        return oppositeCode.reverse().toString();
    }

    /**
     * 取反
     * @return
     */
    public static String getNegate(String binaryStr){
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < binaryStr.length() ; i++){
            if (binaryStr.charAt(i) == '0'){
                sb.append('1');
            }else {
                sb.append('0');
            }
        }
        return sb.toString();
    }
}

