package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.TransactionHistory;

import java.util.List;

public interface TranHistoryService {
    List<TransactionHistory> queryTranHistoryListByTranId(String tranId);
}
