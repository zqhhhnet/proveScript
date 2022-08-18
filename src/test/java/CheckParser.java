import org.junit.Test;
import com.parser.FileParser;
import com.parser.fileParserImpl.FileParserImpl;
import com.pojo.ProveObject;

import java.math.BigInteger;
import java.util.List;
import java.util.Map;

public class CheckParser {
    /**
     * 测试 fileParser 是否成功
     * @param args
     */
    @Test
    public static void main(String[] args) {
        FileParser fileParser = new FileParserImpl();
        ProveObject proveObject = fileParser.fileParser("check.txt");
        if (proveObject == null)
            return;
        List<String> instructions = proveObject.getInstructions();
        Map<String, BigInteger[]> postCond = proveObject.getPostCond();
        Map<String, BigInteger[]> preCond = proveObject.getPreCond();
        for (String instruction : instructions) {
            System.out.println(instruction);
        }
        postCond.forEach((k, v) -> {
            System.out.println("postkey : " + k + " value : " + v[0].toString() + "right : " + v[1].toString());
        });
        preCond.forEach((k, v) -> {
            System.out.println("prekey : " + k + " value : " + v[0].toString() + "right : " + v[1].toString());
        });
    }
}
