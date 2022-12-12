package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.mapper.DicValueMapper;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.mapper.*;
import com.bjpowernode.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImpl implements ClueService {
    @Autowired
    private ClueMapper clueMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private ContactsMapper contactsMapper;
    @Autowired
    private ClueRemarkMapper clueRemarkMapper;
    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;
    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;
    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;
    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;
    @Autowired
    private TranMapper tranMapper;
    @Autowired
    private TransactionHistoryMapper tranHistoryMapper;
    @Autowired
    private TransactionRemarkMapper tranRemarkMapper;
    @Autowired
    private DicValueMapper dicValueMapper;

    @Override
    public List<Clue> queryClueByConditionsForPages(Map<String,Object> map) {
        return clueMapper.selectClueByConditionsForPages(map);
    }

    @Override
    public int queryCountOfClueByConditions(Map<String, Object> map) {
        return clueMapper.selectCountOfClueByConditions(map);
    }

    @Override
    public int saveCreateClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }

    @Override
    public int deleteCluesByIds(String[] ids) {
        return clueMapper.deleteCluesByIds(ids);
    }

    @Override
    public int editClue(Clue clue) {
        return clueMapper.updateClue(clue);
    }

    @Override
    public Clue queryClueById(String id) {
        return clueMapper.selectClueById(id);
    }
    @Override
    public Clue queryClueDetailById(String id) {
        return clueMapper.selectClueDetailById(id);
    }

    @Override
    public void saveConvertClue(Map<String, Object> map) {
        String clueId = (String) map.get("clueId");
        User user = (User) map.get("user");
        Clue clue = clueMapper.selectClueForConvertById(clueId);
        //保存客户信息
        Customer customer=new Customer();
        String customerId=UUIDUtils.getUUID();
        customer.setId(customerId);
        customer.setOwner(user.getId());
        customer.setName(clue.getCompany());
        customer.setPhone(clue.getPhone());
        customer.setWebsite(clue.getWebsite());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateUtils.formatDateTime(new Date()));
        customer.setContactSummary(clue.getContactSummary());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setDescription(clue.getDescription());
        customer.setAddress(clue.getAddress());
        customerMapper.insert(customer);
        //保存联系人信息
        Contacts contacts=new Contacts();
        String contactsId=UUIDUtils.getUUID();
        contacts.setId(contactsId);
        contacts.setOwner(user.getId());
        contacts.setSource(clue.getSource());
        contacts.setCustomerId(customerId);
        contacts.setFullname(clue.getFullname());
        contacts.setAppellation(clue.getAppellation());
        contacts.setEmail(clue.getEmail());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateUtils.formatDateTime(new Date()));
        contacts.setDescription(clue.getDescription());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setAddress(clue.getAddress());
        contactsMapper.insert(contacts);
        //查询该线索所有的备注，分别保存到客户和联系人备注中
        List<ClueRemark> remarkList = clueRemarkMapper.selectClueRemarkForConvertByClueId(clueId);
        if (remarkList!=null && remarkList.size()>0){
            CustomerRemark customerRemark=null;
            ContactsRemark contactsRemark=null;
            for (ClueRemark remark : remarkList) {
                customerRemark = new CustomerRemark();
                customerRemark.setId(UUIDUtils.getUUID());
                customerRemark.setNoteContent(remark.getNoteContent());
                customerRemark.setCreateBy(remark.getCreateBy());
                customerRemark.setCreateTime(remark.getCreateTime());
                customerRemark.setEditBy(remark.getEditBy());
                customerRemark.setEditTime(remark.getEditTime());
                customerRemark.setEditFlag(remark.getEditFlag());
                customerRemark.setCustomerId(customerId);
                customerRemarkMapper.insert(customerRemark);
                contactsRemark = new ContactsRemark();
                contactsRemark.setId(UUIDUtils.getUUID());
                contactsRemark.setNoteContent(remark.getNoteContent());
                contactsRemark.setCreateBy(remark.getCreateBy());
                contactsRemark.setCreateTime(remark.getCreateTime());
                contactsRemark.setEditBy(remark.getEditBy());
                contactsRemark.setEditTime(remark.getEditTime());
                contactsRemark.setEditFlag(remark.getEditFlag());
                contactsRemark.setContactsId(contactsId);
                contactsRemarkMapper.insert(contactsRemark);
            }
        }
        //查询线索和市场活动的关联关系，保存在联系人和市场活动的关系表中
        List<String> activityIds = clueActivityRelationMapper.selectActivityIdByClueId(clueId);
        if (activityIds!=null && activityIds.size()>0){
            ContactsActivityRelation contactsActivityRelation = null;
            for (String activityId : activityIds) {
                contactsActivityRelation = new ContactsActivityRelation();
                contactsActivityRelation.setId(UUIDUtils.getUUID());
                contactsActivityRelation.setContactsId(contactsId);
                contactsActivityRelation.setActivityId(activityId);
                contactsActivityRelationMapper.insert(contactsActivityRelation);
            }
        }
        //如果需要创建交易，交易表添加记录
        Object tran = map.get("tran");
        if (tran != null){
            Tran t = (Tran) tran;
            t.setCustomerId(customerId);
            t.setContactsId(contactsId);
            tranMapper.insert(t);
            //添加交易历史
            TransactionHistory tranHistory=new TransactionHistory();
            tranHistory.setId(UUIDUtils.getUUID());
            tranHistory.setStage(t.getStage());
            tranHistory.setMoney(t.getMoney());
            tranHistory.setExpectedDate(t.getExpectedDate());
            tranHistory.setCreateTime(t.getCreateTime());
            tranHistory.setCreateBy(t.getCreateBy());
            tranHistory.setTranId(t.getId());
            tranHistoryMapper.insert(tranHistory);
            //增加备注
            if (remarkList!=null && remarkList.size()>0){
                TransactionRemark tranRemark = null;
                for (ClueRemark remark : remarkList) {
                    tranRemark = new TransactionRemark();
                    tranRemark.setId(UUIDUtils.getUUID());
                    tranRemark.setTranId(t.getId());
                    tranRemark.setNoteContent(remark.getNoteContent());
                    tranRemark.setCreateBy(remark.getCreateBy());
                    tranRemark.setCreateTime(remark.getCreateTime());
                    tranRemark.setEditBy(remark.getEditBy());
                    tranRemark.setEditTime(remark.getEditTime());
                    tranRemark.setEditFlag(remark.getEditFlag());
                    tranRemarkMapper.insert(tranRemark);
                }
            }
        }
        //删除线索
        clueRemarkMapper.deleteClueRemarkByClueId(clueId);
        clueActivityRelationMapper.deleteClueActivityRemarkByClueId(clueId);
        clueMapper.deleteClueByClueId(clueId);
    }

    @Override
    public List<ChartVO> queryClueCountByOwner() {
        return clueMapper.selectClueCountByOwner();
    }
}
