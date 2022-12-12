package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationService {

    int saveCreateRelations(List<ClueActivityRelation> list);

    int deleteRelation(ClueActivityRelation car);
}
