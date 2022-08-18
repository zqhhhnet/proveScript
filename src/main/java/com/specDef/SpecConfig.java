package com.specDef;

import com.pojo.SpecContext;

import java.io.File;
import java.util.List;

public interface SpecConfig {
    /**
     * spec中设定验证程序指令
     */
    public List<String> programSet(SpecContext specContext);

    /**
     * spec中设定验证程序的前置条件
     */
    public String preConditionSet();

    /**
     * spec中设定验证程序的后置条件
     */
    public List<String> postConditionSet();

    public SpecContext specSet(SpecContext specContext);

    public File setSpecFile(SpecContext specContext);
}
