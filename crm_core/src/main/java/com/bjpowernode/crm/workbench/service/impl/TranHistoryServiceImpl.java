package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.domain.TransactionHistory;
import com.bjpowernode.crm.workbench.mapper.TransactionHistoryMapper;
import com.bjpowernode.crm.workbench.service.TranHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class TranHistoryServiceImpl implements TranHistoryService {
    @Autowired
    private TransactionHistoryMapper tranHistoryMapper;

    @Override
    public List<TransactionHistory> queryTranHistoryListByTranId(String tranId) {
        return tranHistoryMapper.selectTranHistoryListByTranId(tranId);
    }
}
