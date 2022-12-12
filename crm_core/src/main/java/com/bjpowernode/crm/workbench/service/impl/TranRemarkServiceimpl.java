package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.domain.TransactionRemark;
import com.bjpowernode.crm.workbench.mapper.TransactionRemarkMapper;
import com.bjpowernode.crm.workbench.service.TranRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class TranRemarkServiceimpl implements TranRemarkService {
    @Autowired
    private TransactionRemarkMapper tranRemarkMapper;

    @Override
    public List<TransactionRemark> queryTranRemarkByTranId(String tranId) {
        return tranRemarkMapper.selectTranRemarkByTranId(tranId);
    }
}
