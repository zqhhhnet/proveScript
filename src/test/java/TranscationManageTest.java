import org.junit.Test;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

public class TranscationManageTest {
    @Test
    public static void main(String[] args) throws IOException {
        BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(System.in));
        String str = bufferedReader.readLine();
        int n = Integer.parseInt(str.split(" ")[0]);
        int[][] arr = new int[n][3];
        for (int i = 0; i < n; i++) {
            str = bufferedReader.readLine();
            String[] nums = str.split(" ");
            arr[i][0] = Integer.parseInt(nums[0]);
            arr[i][1] = Integer.parseInt(nums[1]);
            arr[i][2] = Integer.parseInt(nums[2]);
        }
        solution(arr);
        //System.out.println("left : " + solution[0] + " right : " + solution[1]);
    }

    public static void solution(int[][] f) {
        int n = f.length;
        Arrays.sort(f, new Comparator<int[]>() {
            @Override
            public int compare(int[] a, int[] b) {
                return a[1] - b[1];
            }
        });
        int[] dp = new int[n];
        // 记录当前事务队列的最大值的第一个事务
        int[] pre = new int[n];
        dp[0] = f[0][2];
        pre[0] = 0;
        for (int i = 1; i < n; i++) {
            int left = 0, right = i-1;
            while (left < right) {
                int mid = left + right + 1 >>> 1;
                if (f[mid][1] > f[i][0]) {
                    right = mid-1;
                } else if (f[mid][1] < f[i][0]) {
                    left = mid;
                } else if (f[mid][1] == f[i][0]) {
                    left = mid;
                }
            }
            if (f[left][1] > f[i][0]) {
                if (dp[i-1] > f[i][2]) {
                    dp[i] = dp[i-1];
                    pre[i] = i-1;
                } else {
                    dp[i] = f[i][2];
                    pre[i] = i;
                }
            } else {
                if (dp[i-1] > dp[left] + f[i][2]) {
                    dp[i] = dp[i-1];
                    pre[i] = i-1;
                } else {
                    dp[i] = dp[left] + f[i][2];
                    pre[i] = left;
                }
            }
            //dp[i] = f[left][1] > f[i][0] ? Math.max(dp[i-1], f[i][2]) : Math.max(dp[i-1], dp[left] + f[i][2]);
        }
        int i = n-1;
        while (i > 0 && dp[i] == dp[i-1]) {
            i--;
        }
        List<Integer> res = new ArrayList<>();
        res.add(i+1);
        while (pre[i] != i) {
            res.add(pre[i]+1);
            i = pre[i];
        }
        for (Integer re : res) {
            System.out.println(re);
        }
        //return dp[n-1];
    }
}
