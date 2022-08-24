import com.bv2int.Binary2Signed;
import org.junit.Test;

import java.math.BigInteger;

public class BigIntegerToBitCheck {
    @Test
    public static void main(String[] args) {
        BigInteger num = new BigInteger("4294967295");
        byte[] bytes = num.toByteArray();
        for (byte aByte : bytes) {
            System.out.println(aByte + ":");
            String s = String.valueOf(aByte);
            System.out.println(s);
        }
        String s = num.toString(2);
        System.out.println("二进制：" + s);

        String s1 = signExtend(s, 64);
        System.out.println(s1);
        BigInteger signExtendNum = new BigInteger(s1, 2);
        BigInteger noExNum = new BigInteger(s.substring(1, s.length()), 2);
        System.out.println("扩展位：" + signExtendNum);
        System.out.println("无扩展" + noExNum);
        String s2 = Binary2Signed.AddBinToDec(s1.substring(32), true);
        System.out.println("s1 低32位 ：" + s2);
    }

    public static String signExtend(String s, int len) {
        StringBuilder res = new StringBuilder();
        int lenS = s.length();
        if (s.charAt(0) == '-') {
            int rest = len - lenS + 1;
            for (int i = 0; i < rest; i++) {
                res.append('1');
            }
            res.append(s.substring(1, lenS));
        } else {
            int rest = len - lenS;
            for (int i = 0; i < rest; i++) {
                res.append('0');
            }
            res.append(s);
        }
        return res.toString();
    }
}
