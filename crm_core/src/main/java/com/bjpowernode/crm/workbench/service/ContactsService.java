package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.ChartVO;
import com.bjpowernode.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsService {
    List<Contacts> queryContactsForTranByName(String name);
    List<ChartVO> queryContactsCountByOwner();
}
