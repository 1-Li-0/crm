package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.constants.CodeConstants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.MyUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.ClueActivityRelationService;
import com.bjpowernode.crm.workbench.service.ClueRemarkService;
import com.bjpowernode.crm.workbench.service.ClueService;
import com.bjpowernode.crm.settings.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class ClueController {
    @Autowired
    private ClueService clueService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private UserService userService;
    @Autowired
    private ClueRemarkService clueRemarkService;
    @Autowired
    private ClueActivityRelationService relationService;
    @Autowired
    private ActivityService activityService;

    @RequestMapping("/workbench/clue/index.do")
    public String index(HttpServletRequest request){
        List<User> users = userService.queryAllUsers();
        request.setAttribute("users",users);
        List<DicValue> appellations=dicValueService.queryDicValuesByTypeCode("appellation");
        request.setAttribute("appellations",appellations);
        List<DicValue> sources=dicValueService.queryDicValuesByTypeCode("source");
        request.setAttribute("sources",sources);
        List<DicValue> clueStates=dicValueService.queryDicValuesByTypeCode("clueState");
        request.setAttribute("clueStates",clueStates);
        return "workbench/clue/index";
    }
    @RequestMapping("/workbench/clue/queryClueByConditionsForPages.do")
    @ResponseBody
    public Object queryClueByConditionsForPages(String fullname,String company,String phone,String source,String owner,String mphone,String state,int pageNo,int pageSize){
        Map<String,Object> map=new HashMap<>();
        map.put("fullname",fullname);
        map.put("company",company);
        map.put("phone",phone);
        map.put("source",source);
        map.put("owner",owner);
        map.put("mphone",mphone);
        map.put("state",state);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);
        List<Clue> clueList = clueService.queryClueByConditionsForPages(map);
        int totalRows = clueService.queryCountOfClueByConditions(map);
        Map<String,Object> retMap=new HashMap<>();
        retMap.put("clueList",clueList);
        retMap.put("totalRows",totalRows);
        return retMap;
    }
    @RequestMapping("/workbench/clue/saveCreateClue.do")
    @ResponseBody
    public Object saveCreateClue(Clue clue, HttpSession session){
        clue.setId(UUIDUtils.getUUID());
        User user = (User) session.getAttribute(CodeConstants.SESSION_USER);
        clue.setCreateBy(user.getId());
        clue.setCreateTime(DateUtils.formatDateTime(new Date()));
        int i=0;
        try {
            i = clueService.saveCreateClue(clue);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return MyUtils.getReturnObject(i);
    }
    @RequestMapping("/workbench/clue/deleteCluesByIds.do")
    @ResponseBody
    public Object deleteCluesByIds(String[] id){
        int i =0;
        try {
            i=clueService.deleteCluesByIds(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return MyUtils.getReturnObject(i);
    }
    @RequestMapping("/workbench/clue/editClue.do")
    @ResponseBody
    public Object editClue(Clue clue,HttpSession session){
        User user = (User) session.getAttribute(CodeConstants.SESSION_USER);
        clue.setEditBy(user.getId());
        clue.setEditTime(DateUtils.formatDateTime(new Date()));
        int i =0;
        try {
            i=clueService.editClue(clue);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return MyUtils.getReturnObject(i);
    }
    @RequestMapping("/workbench/clue/queryClueById.do")
    @ResponseBody
    public Clue queryClueById(String id){
        return clueService.queryClueById(id);
    }
    @RequestMapping("/workbench/clue/queryClueDetailById.do")
    public String queryClueDetailById(String id,HttpServletRequest request){
        Clue clue = clueService.queryClueDetailById(id);
        List<ClueRemark> clueRemarkList = clueRemarkService.queryClueRemarkByClueId(id);
        List<Activity> activityList=activityService.queryActivitiesByClueId(id);

        request.setAttribute("clue",clue);
        request.setAttribute("clueRemarkList",clueRemarkList);
        request.setAttribute("activityList",activityList);
        return "workbench/clue/detail";
    }
    @RequestMapping("/workbench/clue/insertClueRemark.do")
    @ResponseBody
    public Object insertClueRemark(ClueRemark clueRemark,HttpSession session){
        ReturnObject obj=null;
        clueRemark.setId(UUIDUtils.getUUID());
        User user = (User) session.getAttribute(CodeConstants.SESSION_USER);
        clueRemark.setCreateBy(user.getId());
        clueRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
        clueRemark.setEditFlag(CodeConstants.REMARK_EDIT_FLAG_UNEDITED);
        int i=0;
        try {
            i = clueRemarkService.saveCreateClueRemark(clueRemark);
            if (i>0){
                obj = MyUtils.getReturnObject(i);
                obj.setRetData(clueRemark);
            }
        } catch (Exception e) {
            e.printStackTrace();
            obj = MyUtils.getReturnObject(i);
        }
        return obj;
    }
    @RequestMapping("/workbench/clue/deleteClueRemarkById.do")
    @ResponseBody
    public Object deleteClueRemarkById(String id){
        int i=0;
        try {
            i = clueRemarkService.deleteClueRemarkById(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return MyUtils.getReturnObject(i);
    }
    @RequestMapping("/workbench/clue/editClueRemark.do")
    @ResponseBody
    public Object editClueRemark(ClueRemark clueRemark,HttpSession session){
        clueRemark.setEditFlag(CodeConstants.REMARK_EDIT_FLAG_EDITED);
        User user = (User) session.getAttribute(CodeConstants.SESSION_USER);
        clueRemark.setEditBy(user.getId());
        clueRemark.setEditTime(DateUtils.formatDateTime(new Date()));
        int i=0;
        try {
            i = clueRemarkService.editClueRemark(clueRemark);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return MyUtils.getReturnObject(i);
    }
    @RequestMapping("/workbench/clue/saveBund.do")
    @ResponseBody
    public Object saveBund(String[] activityId,String clueId){
        List<ClueActivityRelation> list=new ArrayList<>();
        ClueActivityRelation relation = null;
        for (String s : activityId) {
            relation = new ClueActivityRelation();
            relation.setId(UUIDUtils.getUUID());
            relation.setClueId(clueId);
            relation.setActivityId(s);
            list.add(relation);
        }
        ReturnObject obj=null;
        int i=0;
        try {
            i = relationService.saveCreateRelations(list);
            if (i>0) {
                List<Activity> activityList = activityService.queryActivitiesByIds(activityId);
                obj=MyUtils.getReturnObject(i);
                obj.setRetData(activityList);
            }else obj=MyUtils.getReturnObject(i);
        } catch (Exception e) {
            e.printStackTrace();
            obj=MyUtils.getReturnObject(i);
        }
        return obj;
    }
    @RequestMapping("/workbench/clue/queryActivityForDetailByName.do")
    @ResponseBody
    public Object queryActivityForDetailByName(String name,String clueId){
        Map<String,Object> map=new HashMap<>();
        map.put("name",name);
        map.put("clueId",clueId);
        return activityService.queryActivityForDetailByName(map);
    }
    @RequestMapping("/workbench/clue/deleteRelation.do")
    @ResponseBody
    public Object deleteRelation(ClueActivityRelation car){
        int i = 0 ;
        try {
            i=relationService.deleteRelation(car);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return MyUtils.getReturnObject(i);
    }
    @RequestMapping("/workbench/clue/toConvert.do")
    public String toConvert(String id,HttpServletRequest request){
        Clue clue=clueService.queryClueDetailById(id);
        List<DicValue> stageList=dicValueService.queryDicValuesByTypeCode("stage");
        request.setAttribute("clue",clue);
        request.setAttribute("stageList",stageList);
        return "workbench/clue/convert";
    }
    @RequestMapping("/workbench/clue/queryActivityForConvertByName.do")
    @ResponseBody
    public Object queryActivityForConvertByName(String name,String id){
        Map<String,Object> map=new HashMap<>();
        map.put("name",name);
        map.put("clueId",id);
        return activityService.queryActivityForConvertByName(map);
    }
    @RequestMapping("/workbench/clue/saveConvertClue.do")
    @ResponseBody
    public Object saveConvertClue(String clueId,boolean flag,String money,String name,String expectedDate,String stage,String activityId,String source,HttpSession session){
        Map<String,Object> map=new HashMap<>();
        map.put("clueId",clueId);
        User user= (User) session.getAttribute(CodeConstants.SESSION_USER);
        map.put("user",user);
        Tran tran=null;
        if (flag==true){
            tran=new Tran();
            tran.setId(UUIDUtils.getUUID());
            tran.setOwner(user.getId());
            tran.setMoney(money);
            tran.setName(name);
            tran.setExpectedDate(expectedDate);
            tran.setStage(stage);
            tran.setSource(source);
            tran.setActivityId(activityId);
            tran.setCreateBy(user.getId());
            tran.setCreateTime(DateUtils.formatDateTime(new Date()));
        }
        map.put("tran",tran);
        int i = 0;
        try {
            clueService.saveConvertClue(map);
            i=1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return MyUtils.getReturnObject(i);
    }
}
