package com.specDef;

import com.pojo.SpecContext;

import java.io.File;
import java.util.List;

public interface SpecConfig {
    /**
     * spec中设定验证程序指令
     */
    List<String> programSet(SpecContext specContext);

    /**
     * spec中设定验证程序的前置条件
     */
    String preConditionSet();

    /**
     * spec中设定验证程序的后置条件
     */
    List<String> postConditionSet();

    SpecContext specSet(SpecContext specContext);

    File setSpecFile(SpecContext specContext, int count);

    String safetyPropertySet();
}
