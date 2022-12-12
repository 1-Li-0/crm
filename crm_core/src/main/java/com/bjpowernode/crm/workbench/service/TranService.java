package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.ChartVO;
import com.bjpowernode.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranService {
    int saveCreateTran(Map<String,Object> map);
    int editByIdSelective(Tran tran);
    List<Tran> queryTranListByConditionForPages(Map<String,Object> map);
    int queryTranCountByCondition(Map<String,Object> map);
    Tran queryTranForDetailById(String id);
    Map<String,Object> queryTranForEditById(String id);
    List<ChartVO> queryCountOfTranByStage();
}
