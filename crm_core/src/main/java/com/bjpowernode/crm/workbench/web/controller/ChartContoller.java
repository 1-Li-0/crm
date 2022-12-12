package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.workbench.domain.ChartVO;
import com.bjpowernode.crm.workbench.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class ChartContoller {
    @Autowired
    private TranService tranService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ClueService clueService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private ContactsService contactsService;

    @RequestMapping("/workbench/chart/transaction/toTranChartIndex.do")
    public String toTranChartIndex(){
        return "workbench/chart/transaction/index";
    }
    @RequestMapping("/workbench/chart/transaction/queryCountOfTranByStage.do")
    @ResponseBody
    public Object queryCountOfTranByStage(){
        return tranService.queryCountOfTranByStage();
    }
    @RequestMapping("/workbench/chart/activity/toActivityChartIndex.do")
    public String toTActivityChartIndex(){
        return "workbench/chart/activity/index";
    }
    @RequestMapping("/workbench/chart/activity/queryActivityCountByOwner.do")
    @ResponseBody
    public Object queryActivityCountByOwner(){
        return activityService.queryActivityCountByOwner();
    }
    @RequestMapping("/workbench/chart/clue/toClueChartIndex.do")
    public String toClueChartIndex(){
        return "workbench/chart/clue/index";
    }
    @RequestMapping("/workbench/chart/clue/queryClueCountByOwner.do")
    @ResponseBody
    public Object queryClueCountByOwner(){
        return clueService.queryClueCountByOwner();
    }
    @RequestMapping("/workbench/chart/customerAndContacts/toCusAndConChartIndex.do")
    public String toCusAndConChartIndex(){
        return "workbench/chart/customerAndContacts/index";
    }
    @RequestMapping("/workbench/chart/customerAndContacts/queryCountOfCusAndConByOwner.do")
    @ResponseBody
    public Object queryCountOfCusAndConByOwner(){
        List<ChartVO> conList = contactsService.queryContactsCountByOwner();
        List<ChartVO> cusList = customerService.queryCustomerCountByOwner();
        for (ChartVO c:conList){
            cusList.add(c);
        }
        return cusList;
    }
}
