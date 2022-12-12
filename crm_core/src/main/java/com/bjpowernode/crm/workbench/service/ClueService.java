package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.ChartVO;
import com.bjpowernode.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueService {
    List<Clue> queryClueByConditionsForPages(Map<String,Object> map);
    int queryCountOfClueByConditions(Map<String,Object> map);
    int saveCreateClue(Clue clue);
    int deleteCluesByIds(String[] ids);
    int editClue(Clue clue);
    Clue queryClueById(String id);
    Clue queryClueDetailById(String id);

    void saveConvertClue(Map<String,Object> map);

    List<ChartVO> queryClueCountByOwner();
}
