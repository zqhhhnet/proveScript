package com.specDef.execute;

import java.io.File;
import java.io.IOException;

public interface SpecProve {
    public String executeSpecProve(String cmd, File dir) throws IOException;
}
