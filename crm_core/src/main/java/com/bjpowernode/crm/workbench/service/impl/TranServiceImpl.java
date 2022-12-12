package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.mapper.*;
import com.bjpowernode.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class TranServiceImpl implements TranService {
    @Autowired
    private TranMapper tranMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private TransactionHistoryMapper transactionHistoryMapper;
    @Autowired
    private ActivityMapper activityMapper;
    @Autowired
    private ContactsMapper contactsMapper;

    @Override
    public int saveCreateTran(Map<String,Object> map) {
        String name = String.valueOf(map.get("cusName"));
        Customer customer = customerMapper.selectCustomerByName(name);
        User user = (User) map.get("user");
        if (customer==null){
            customer=new Customer();
            customer.setId(UUIDUtils.getUUID());
            customer.setName(name);
            customer.setOwner(user.getId());
            customer.setCreateTime(DateUtils.formatDateTime(new Date()));
            customer.setCreateBy(user.getId());
            customerMapper.insert(customer);
        }
        String id=customer.getId();
        Tran tran= (Tran) map.get("tran");
        tran.setCustomerId(id);
        tran.setId(UUIDUtils.getUUID());
        tran.setOwner(user.getId());
        tran.setCreateBy(user.getId());
        tran.setCreateTime(DateUtils.formatDateTime(new Date()));
        int ret1 = tranMapper.insert(tran);

        TransactionHistory th = new TransactionHistory();
        th.setId(UUIDUtils.getUUID());
        th.setCreateBy(user.getId());
        th.setCreateTime(DateUtils.formatDateTime(new Date()));
        th.setTranId(tran.getId());
        th.setMoney(tran.getMoney());
        th.setStage(tran.getStage());
        th.setExpectedDate(tran.getExpectedDate());
        transactionHistoryMapper.insert(th);
        return ret1;
    }

    @Override
    public int editByIdSelective(Tran tran) {
        return tranMapper.updateByIdSelective(tran);
    }

    @Override
    public List<Tran> queryTranListByConditionForPages(Map<String, Object> map) {
        return tranMapper.selectTranListByConditionForPages(map);
    }

    @Override
    public int queryTranCountByCondition(Map<String, Object> map) {
        return tranMapper.selectTranCountByCondition(map);
    }

    @Override
    public Tran queryTranForDetailById(String id) {
        return tranMapper.selectTranForDetailById(id);
    }

    @Override
    public Map<String,Object> queryTranForEditById(String id) {
        Map<String,Object> map = new HashMap<>();
        Tran tran = tranMapper.selectTranForEditById(id);
        map.put("tran",tran);
        Activity activity = activityMapper.selectActivityById(tran.getActivityId());
        map.put("activityName",activity.getName());
        Contacts contacts = contactsMapper.selectByPrimaryKey(tran.getContactsId());
        map.put("contactsName",contacts.getFullname());
        return map;
    }

    @Override
    public List<ChartVO> queryCountOfTranByStage() {
        return tranMapper.selectCountOfTranByStage();
    }

}
