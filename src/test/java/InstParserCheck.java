import org.junit.Test;
import com.parser.InstParser;
import com.parser.instParserImpl.InstParserImpl;
import com.pojo.Instruction;

public class InstParserCheck {
    @Test
    public static void main(String[] args) {
        String inst = "VMOV Q0, # B";

        InstParser instParser = new InstParserImpl();
        Instruction instruction = instParser.instParse(inst);
        if (instruction == null)
            return;
        System.out.println(instruction.getOpcode());
        if (instruction.getDatatype() != null)
            System.out.println(instruction.getDatatype());
        System.out.println(instruction.getDestinationRegister());
        if (instruction.getSourceRegister() != null) {
            for (String s : instruction.getSourceRegister()) {
                System.out.println(s);
            }
        }
        if (instruction.getImm() != null)
            System.out.println(instruction.getImm());
    }
}
