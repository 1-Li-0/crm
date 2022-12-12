package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.domain.ChartVO;
import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.mapper.ContactsMapper;
import com.bjpowernode.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class ContactsServiceImpl implements ContactsService {
    @Autowired
    private ContactsMapper contactsMapper;

    @Override
    public List<Contacts> queryContactsForTranByName(String name) {
        return contactsMapper.selectContactsForTranByName(name);
    }

    @Override
    public List<ChartVO> queryContactsCountByOwner() {
        return contactsMapper.selectContactsCountByOwner();
    }
}
