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
        String inst = "VMOV Q1, Q2";
        List<String> insts = new ArrayList<>();
        insts.add(inst);
        proveObject.setInstructions(insts);
        Map<String, BigInteger[]> preMap = new HashMap<>();
        preMap.put("A", new BigInteger[]{BigInteger.ONE, BigInteger.TEN});
        proveObject.setPreCond(preMap);
        Map<String, String> RegMap = new HashMap<>();
        //RegMap.put("R1", "A");
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
        File file = specConfig.setSpecFile(specContext);
        System.out.println(file);
    }
}
