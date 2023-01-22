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
        //String inst = "MOV R0, # B";
        //String inst = "VMUL.I8 Q1, Q1, R0";
        //String inst = "VORR Q2, Q1, Q3";
        String inst = "VMLAV.S8 R0, Q0, Q1";
        List<String> insts = new ArrayList<>();
        insts.add(inst);
        proveObject.setInstructions(insts);

        Map<String, BigInteger[]> preMap = new HashMap<>();
        //preMap.put("B", new BigInteger[]{BigInteger.ZERO, new BigInteger("30")});
        preMap.put("A", new BigInteger[]{BigInteger.ONE, new BigInteger("1561561651")});
        /*preMap.put("A0", new BigInteger[]{BigInteger.ZERO, new BigInteger("232321")});
        preMap.put("A1", new BigInteger[]{BigInteger.ZERO, new BigInteger("78424")});
        preMap.put("A2", new BigInteger[]{BigInteger.ZERO, new BigInteger("683222")});
        preMap.put("A3", new BigInteger[]{BigInteger.ZERO, new BigInteger("8232322")});*/
        /*preMap.put("C", new BigInteger[]{BigInteger.ONE, new BigInteger("1455554345")});
        preMap.put("C0", new BigInteger[]{BigInteger.ZERO, new BigInteger("2322321")});
        preMap.put("C1", new BigInteger[]{BigInteger.ZERO, new BigInteger("7843")});
        preMap.put("C2", new BigInteger[]{BigInteger.ZERO, new BigInteger("68222")});
        preMap.put("C3", new BigInteger[]{BigInteger.ZERO, new BigInteger("3821322")});*/
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
        //preMap.put("B", new BigInteger[]{BigInteger.ZERO, new BigInteger("2")});
        preMap.put("C", new BigInteger[]{BigInteger.ONE, new BigInteger("1455554345")});
        preMap.put("C000", new BigInteger[]{BigInteger.ZERO, new BigInteger("25")});
        preMap.put("C001", new BigInteger[]{BigInteger.ZERO, new BigInteger("45")});
        preMap.put("C002", new BigInteger[]{BigInteger.ZERO, new BigInteger("56")});
        preMap.put("C003", new BigInteger[]{BigInteger.ZERO, new BigInteger("52")});
        preMap.put("C004", new BigInteger[]{BigInteger.ZERO, new BigInteger("35")});
        preMap.put("C005", new BigInteger[]{BigInteger.ZERO, new BigInteger("12")});
        preMap.put("C006", new BigInteger[]{BigInteger.ZERO, new BigInteger("23")});
        preMap.put("C007", new BigInteger[]{BigInteger.ZERO, new BigInteger("58")});
        preMap.put("C008", new BigInteger[]{BigInteger.ZERO, new BigInteger("65")});
        preMap.put("C009", new BigInteger[]{BigInteger.ZERO, new BigInteger("78")});
        preMap.put("C0010", new BigInteger[]{BigInteger.ZERO, new BigInteger("98")});
        preMap.put("C0011", new BigInteger[]{BigInteger.ZERO, new BigInteger("87")});
        preMap.put("C0012", new BigInteger[]{BigInteger.ZERO, new BigInteger("112")});
        preMap.put("C0013", new BigInteger[]{BigInteger.ZERO, new BigInteger("110")});
        preMap.put("C0014", new BigInteger[]{BigInteger.ZERO, new BigInteger("13")});
        preMap.put("C0015", new BigInteger[]{BigInteger.ZERO, new BigInteger("12")});
        proveObject.setPreCond(preMap);

        Map<String, String> RegMap = new HashMap<>();
        RegMap.put("Q0", "A");
        //RegMap.put("R0", "B");
        RegMap.put("Q1", "C");
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
