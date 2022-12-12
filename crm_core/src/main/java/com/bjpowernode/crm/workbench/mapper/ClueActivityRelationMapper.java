package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationMapper {

    int insertRelations(List<ClueActivityRelation> list);

    int deleteRelation(ClueActivityRelation car);

    List<String> selectActivityIdByClueId(String clueId);

    int deleteClueActivityRemarkByClueId(String clueId);
}
