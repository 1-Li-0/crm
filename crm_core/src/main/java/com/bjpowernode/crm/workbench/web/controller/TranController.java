package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.constants.CodeConstants;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.MyUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.DicValueService;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.domain.TransactionHistory;
import com.bjpowernode.crm.workbench.domain.TransactionRemark;
import com.bjpowernode.crm.workbench.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class TranController {
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private UserService userService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private TranService tranService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private TranHistoryService tranHistoryService;
    @Autowired
    private TranRemarkService tranRemarkService;

    @RequestMapping("/workbench/transaction/index.do")
    public String index(HttpServletRequest request){
        List<DicValue> stageList = dicValueService.queryDicValuesByTypeCode("stage");
        List<DicValue> tranTypeList = dicValueService.queryDicValuesByTypeCode("transactionType");
        List<DicValue> sourceList = dicValueService.queryDicValuesByTypeCode("source");
        request.setAttribute("stageList",stageList);
        request.setAttribute("tranTypeList",tranTypeList);
        request.setAttribute("sourceList",sourceList);
        return "workbench/transaction/index";
    }
    @RequestMapping("/workbench/transaction/queryTranListByConditionForPages.do")
    @ResponseBody
    public Object queryTranListByConditionForPages(String owner,String name,String customerName,String stage,String type,String source,String contactsName,Integer pageNo,Integer pageSize){
        Map<String,Object> map=new HashMap<>();
        map.put("owner",owner);
        map.put("name",name);
        map.put("customerName",customerName);
        map.put("stage",stage);
        map.put("type",type);
        map.put("source",source);
        map.put("contactsName",contactsName);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);
        List<Tran> tranList = tranService.queryTranListByConditionForPages(map);
        int totalRows = tranService.queryTranCountByCondition(map);
        Map<String,Object> retMap=new HashMap<>();
        retMap.put("tranList",tranList);
        retMap.put("totalRows",totalRows);
        return retMap;
    }
    @RequestMapping("/workbench/transaction/save.do")
    public String save(HttpServletRequest request){
        List<User> userList = userService.queryAllUsers();
        List<DicValue> stageList = dicValueService.queryDicValuesByTypeCode("stage");
        List<DicValue> tranTypeList = dicValueService.queryDicValuesByTypeCode("transactionType");
        List<DicValue> sourceList = dicValueService.queryDicValuesByTypeCode("source");
        request.setAttribute("userList",userList);
        request.setAttribute("stageList",stageList);
        request.setAttribute("tranTypeList",tranTypeList);
        request.setAttribute("sourceList",sourceList);
        return "workbench/transaction/save";
    }
    @RequestMapping("/workbench/transaction/queryActivityByName.do")
    @ResponseBody
    public Object queryActivityByName(String name){
        return activityService.queryActivityForTranByName(name);
    }
    @RequestMapping("/workbench/transaction/queryContactsByName.do")
    @ResponseBody
    public Object queryContactsByName(String name){
        return contactsService.queryContactsForTranByName(name);
    }
    @RequestMapping("/workbench/transaction/getPossibilityByStage.do")
    @ResponseBody
    public Object getPossibilityByStage(String stage){
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility = bundle.getString(stage);
        return possibility;
    }
    @RequestMapping("/workbench/transaction/queryCustomerNameForCreateByName.do")
    @ResponseBody
    public Object queryCustomerNameForCreateByName(String name){
        List<String> nameList = customerService.queryCustomerNameForCreateByName(name);
        return nameList;
    }
    @RequestMapping("/workbench/transaction/saveCreateTran.do")
    @ResponseBody
    public Object saveCreateTran(Tran tran,String cusName,HttpSession session){
        User user = (User) session.getAttribute(CodeConstants.SESSION_USER);
        Map<String,Object> map=new HashMap<>();
        map.put("tran",tran);
        map.put("user",user);
        map.put("cusName",cusName);
        int i=0;
        try {
            i = tranService.saveCreateTran(map);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return MyUtils.getReturnObject(i);
    }

    @RequestMapping("/workbench/transaction/edit.do")
    public String edit(String id,HttpServletRequest request){
        List<User> userList = userService.queryAllUsers();
        List<DicValue> stageList = dicValueService.queryDicValuesByTypeCode("stage");
        List<DicValue> tranTypeList = dicValueService.queryDicValuesByTypeCode("transactionType");
        List<DicValue> sourceList = dicValueService.queryDicValuesByTypeCode("source");
        request.setAttribute("userList",userList);
        request.setAttribute("stageList",stageList);
        request.setAttribute("tranTypeList",tranTypeList);
        request.setAttribute("sourceList",sourceList);
        request.setAttribute("tranId",id);
        return "workbench/transaction/edit";
    }
    @RequestMapping("/workbench/transaction/queryTranById.do")
    @ResponseBody
    public Object queryTranById(String id){
        Map<String, Object> map = tranService.queryTranForEditById(id);
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        Tran tran = (Tran) map.get("tran");
        DicValue dicValue = dicValueService.queryDicValueById(tran.getStage());
        String possibility = bundle.getString(dicValue.getValue());
        map.put("possibility",possibility);
        return map;
    }
    @RequestMapping("/workbench/transaction/editTran.do")
    @ResponseBody
    public Object editTran(Tran tran, HttpSession session){
        User user = (User) session.getAttribute(CodeConstants.SESSION_USER);
        tran.setEditBy(user.getId());
        tran.setEditTime(DateUtils.formatDateTime(new Date()));
        int i=0;
        try {
            i = tranService.editByIdSelective(tran);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return MyUtils.getReturnObject(i);
    }
    @RequestMapping("/workbench/transaction/toDetail.do")
    public String toDetail(String tranId,HttpServletRequest request){
        Tran tran = tranService.queryTranForDetailById(tranId);
        request.setAttribute("tran",tran);

        List<TransactionHistory> tranHistories = tranHistoryService.queryTranHistoryListByTranId(tranId);
        request.setAttribute("tranHistories",tranHistories);

        List<TransactionRemark> tranRemarks = tranRemarkService.queryTranRemarkByTranId(tranId);
        request.setAttribute("tranRemarks",tranRemarks);

        List<DicValue> stageList = dicValueService.queryDicValuesByTypeCode("stage");
        request.setAttribute("stageList",stageList);

        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility = bundle.getString(tran.getStage());
        request.setAttribute("possibility",possibility);
        return "workbench/transaction/detail";
    }

}
