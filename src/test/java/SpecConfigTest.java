import org.junit.Test;
import com.parser.InstParser;
import com.parser.instParserImpl.InstParserImpl;
import com.pojo.Instruction;
import com.pojo.ProveObject;
import com.pojo.SpecContext;
import com.specDef.SpecConfig;
import com.specDef.config.PostCondState;
import com.specDef.config.PreCondState;
import com.specDef.config.ProgramState;
import com.specDef.impl.SpecConfigImpl;

import java.io.File;
import java.math.BigInteger;
import java.util.*;

public class SpecConfigTest {
    @Test
    public static void main(String[] args) {
        ProveObject proveObject = new ProveObject();
        //String inst = "MOV R0, R1";
        String inst = "VMAXV.S8 R1, Q2";
        List<String> insts = new ArrayList<>();
        insts.add(inst);
        proveObject.setInstructions(insts);

        Map<String, BigInteger[]> preMap = new HashMap<>();
        preMap.put("A", new BigInteger[]{BigInteger.ONE, new BigInteger("1561561651")});
        preMap.put("A000", new BigInteger[]{BigInteger.ZERO, new BigInteger("127")});
        preMap.put("A001", new BigInteger[]{BigInteger.ZERO, new BigInteger("76")});
        preMap.put("A002", new BigInteger[]{BigInteger.ZERO, new BigInteger("78")});
        preMap.put("A003", new BigInteger[]{BigInteger.ZERO, new BigInteger("68")});
        preMap.put("A004", new BigInteger[]{BigInteger.ZERO, new BigInteger("8")});
        preMap.put("A005", new BigInteger[]{BigInteger.ZERO, new BigInteger("68")});
        preMap.put("A006", new BigInteger[]{BigInteger.ZERO, new BigInteger("62")});
        preMap.put("A007", new BigInteger[]{BigInteger.ZERO, new BigInteger("118")});
        preMap.put("A008", new BigInteger[]{BigInteger.ZERO, new BigInteger("98")});
        preMap.put("A009", new BigInteger[]{BigInteger.ZERO, new BigInteger("83")});
        preMap.put("A0010", new BigInteger[]{BigInteger.ZERO, new BigInteger("26")});
        preMap.put("A0011", new BigInteger[]{BigInteger.ZERO, new BigInteger("23")});
        preMap.put("A0012", new BigInteger[]{BigInteger.ZERO, new BigInteger("24")});
        preMap.put("A0013", new BigInteger[]{BigInteger.ZERO, new BigInteger("24")});
        preMap.put("A0014", new BigInteger[]{BigInteger.ZERO, new BigInteger("22")});
        preMap.put("A0015", new BigInteger[]{BigInteger.ZERO, new BigInteger("8")});
        preMap.put("B", new BigInteger[]{BigInteger.ZERO, new BigInteger("30")});
        proveObject.setPreCond(preMap);

        Map<String, String> RegMap = new HashMap<>();
        RegMap.put("Q2", "A");
        RegMap.put("R1", "B");
        proveObject.setRegisterMap(RegMap);
        PreCondState preCondState = new PreCondState(proveObject);
        PostCondState postCondState = new PostCondState(proveObject);
        ProgramState programState = new ProgramState();
        SpecConfig specConfig = new SpecConfigImpl(preCondState, postCondState, programState);
        InstParser instParser = new InstParserImpl();
        Instruction instruction = instParser.instParse(inst);
        preCondState.setInstruction(instruction);
        postCondState.setInstruction(instruction);
        programState.setInstruction(instruction);
        SpecContext specContext = new SpecContext();
        specConfig.specSet(specContext);
        List<String> instList = specContext.getInstList();
        System.out.println("inst:");
        for (String s : instList) {
            System.out.print(s);
        }
        System.out.println("Pre:");
        String preCondition = specContext.getPreCondition();
        System.out.println(preCondition);
        System.out.println("Post:");
        for (String s : specContext.getPostCondition()) {
            System.out.print(s);
        }
        File file = specConfig.setSpecFile(specContext, 0);
        System.out.println(file);
    }
}
