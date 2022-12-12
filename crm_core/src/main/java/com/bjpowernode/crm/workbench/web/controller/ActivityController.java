package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.constants.CodeConstants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.MyUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityRemarkService;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.OutputStream;
import java.util.*;

@Controller
public class ActivityController {
    @Autowired
    private UserService userService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/index.do")
    public String index(HttpServletRequest request){
        List<User> users = userService.queryAllUsers();
        request.setAttribute("users",users);
        return "workbench/activity/index";
    }
    @RequestMapping("/workbench/activity/saveCreateActivity.do")
    @ResponseBody
    public Object saveCreateActivity(Activity activity, HttpSession session){
        activity.setId(UUIDUtils.getUUID());
        activity.setCreateTime(DateUtils.formatDateTime(new Date()));
        User user = (User) session.getAttribute(CodeConstants.SESSION_USER);
        activity.setCreateBy(user.getId());
        int i = 0;
        try {
            i=activityService.saveCreateActivity(activity);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return MyUtils.getReturnObject(i);
    }
    @RequestMapping("/workbench/activity/queryActivityByConditionForPage.do")
    @ResponseBody
    public Object queryActivityByConditionForPage(String owner,String name,String startDate,String endDate,int pageNo,int pageSize){
        Map<String,Object> map=new HashMap<>();
        map.put("owner",owner);
        map.put("name",name);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);
        List<Activity> activityList = activityService.queryActivityByConditionForPage(map);
        int totalRows=activityService.queryCountOfActivityByCondition(map);
        Map<String,Object> retMap=new HashMap<>();
        retMap.put("activityList",activityList);
        retMap.put("totalRows",totalRows);
        return retMap;
    }
    @RequestMapping("/workbench/activity/deleteActivitiesByIds.do")
    @ResponseBody
    public Object deleteActivitiesByIds(String[] id){
        int i = 0;
        try {
            i=activityService.deleteActivitiesByIds(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return MyUtils.getReturnObject(i);
    }
    @RequestMapping("/workbench/activity/saveEditActivityById.do")
    @ResponseBody
    public Object saveEditActivityById(Activity activity, HttpSession session){
        User user = (User) session.getAttribute(CodeConstants.SESSION_USER);
        activity.setEditBy(user.getId());
        activity.setEditTime(DateUtils.formatDateTime(new Date()));
        int i = 0;
        try {
            i=activityService.saveEditActivityById(activity);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return MyUtils.getReturnObject(i);
    }
    @RequestMapping("/workbench/activity/queryActivityById.do")
    @ResponseBody
    public Activity queryActivityById(String id){
        return activityService.queryActivityById(id);
    }
    @RequestMapping("/workbench/activity/exportAllActivity.do")
    public void exportAllActivity(HttpServletResponse response) throws IOException {
        List<Activity> activityList = activityService.queryAllActivity();
        HSSFWorkbook wb = MyUtils.getWorkbookForActivity(activityList);
        /*FileOutputStream fos=new FileOutputStream("D:/KeTangBiJi/CRM项目（SSM框架版）/ActivityTable.xls");
        wb.write(fos);
        fos.flush();
        fos.close();
        wb.close();

        response.setContentType("application/octet-stream;charset=UTF-8");
        OutputStream out = response.getOutputStream();
        response.setHeader("Content-Disposition","attachment;filename=ActivityTable.xls");
        FileInputStream fis = new FileInputStream("D:/KeTangBiJi/CRM项目（SSM框架版）/ActivityTable.xls");
        byte[] bytes = new byte[1024];
        int len = 0 ;
        while ((len = fis.read(bytes))!=-1){
            out.write(bytes,0,len);
        }
        out.flush();
        fis.close();*/
        response.setContentType("application/octet-stream;charset=UTF-8");
        OutputStream out = response.getOutputStream();
        response.setHeader("Content-Disposition","attachment;filename=ActivityTable.xls");
        wb.write(out);
        out.flush();
        wb.close();
    }
    @RequestMapping("/workbench/activity/exportXzActivity.do")
    public void exportXzActivity(HttpServletResponse response,String[] id) throws IOException {
        List<Activity> activityList = activityService.queryActivitiesByIds(id);
        HSSFWorkbook wb = MyUtils.getWorkbookForActivity(activityList);
        response.setContentType("application/octet-stream;charset=UTF-8");
        response.setHeader("content-Disposition","attachment;filename=ActivityForChoose.xls");
        OutputStream out = response.getOutputStream();
        wb.write(out);
        out.flush();
        wb.close();
    }
    @RequestMapping("/workbench/activity/importActivityByList.do")
    @ResponseBody
    public Object importActivityByList(MultipartFile activityFile,HttpSession session){
        ReturnObject obj=new ReturnObject();
        User user = (User)session.getAttribute(CodeConstants.SESSION_USER);
        try {
            HSSFWorkbook wb = new HSSFWorkbook(activityFile.getInputStream());
            HSSFSheet sheet = wb.getSheetAt(0);
            HSSFRow row=null;
            List<Activity> activityList=new ArrayList<>();
            Activity activity=null;
            for (int i=1;i<=sheet.getLastRowNum();i++) {
                activity = new Activity();
                activity.setId(UUIDUtils.getUUID());
                activity.setOwner(user.getId());
                activity.setCreateBy(user.getId());
                activity.setCreateTime(DateUtils.formatDateTime(new Date()));

                row = sheet.getRow(i);
                activity.setName(MyUtils.getCellValueForString(row.getCell(0)));
                activity.setStartDate(MyUtils.getCellValueForString(row.getCell(1)));
                activity.setEndDate(MyUtils.getCellValueForString(row.getCell(2)));
                activity.setCost(MyUtils.getCellValueForString(row.getCell(3)));
                activity.setDescription(MyUtils.getCellValueForString(row.getCell(4)));

                activityList.add(activity);
            }
            int count = activityService.saveCreateActivityByList(activityList);
            obj.setCode(CodeConstants.RETURN_OBJECT_CODE_SUCCESS);
            obj.setRetData(count);
        } catch (IOException e) {
            e.printStackTrace();
            obj.setCode(CodeConstants.RETURN_OBJECT_CODE_FAIL);
            obj.setMessage("系统忙，请稍后重试...");
        }
        return obj;
    }
    //活动备注页面方法
    @RequestMapping("/workbench/activity/activityDetail.do")
    public String activityDetail(String id,HttpServletRequest request){
        Activity activity = activityService.queryActivityForDetailById(id);
        List<ActivityRemark> activityRemarkList = activityRemarkService.queryActivityRemarkByActivityId(id);
        request.setAttribute("activity",activity);
        request.setAttribute("activityRemarkList",activityRemarkList);
        return "workbench/activity/detail";
    }
    @RequestMapping("/workbench/activity/saveCreateActivityRemark.do")
    @ResponseBody
    public Object saveCreateActivityRemark(ActivityRemark remark,HttpSession session){
        ReturnObject obj=null;
        remark.setId(UUIDUtils.getUUID());
        remark.setCreateTime(DateUtils.formatDateTime(new Date()));
        User user = (User) session.getAttribute(CodeConstants.SESSION_USER);
        remark.setCreateBy(user.getId());
        remark.setEditFlag(CodeConstants.REMARK_EDIT_FLAG_UNEDITED);
        int ret = 0;
        try {
            ret = activityRemarkService.saveCreateActivityRemark(remark);
            if (ret>0){
                obj = MyUtils.getReturnObject(ret);
                obj.setRetData(remark);
            }
        } catch (Exception e) {
            e.printStackTrace();
            obj = MyUtils.getReturnObject(ret);
        }
        return obj;
    }
    @RequestMapping("/workbench/activity/deleteActivityRemarkByRemarkId.do")
    @ResponseBody
    public Object deleteActivityRemarkByRemarkId(String remarkId){
        int ret = 0;
        try {
            ret=activityRemarkService.deleteActivityRemarkByRemarkId(remarkId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return MyUtils.getReturnObject(ret);
    }
    @RequestMapping("/workbench/activity/editRemarkNoteContentById.do")
    @ResponseBody
    public Object editRemarkNoteContentById(ActivityRemark remark,HttpSession session){
        User user = (User) session.getAttribute(CodeConstants.SESSION_USER);
        remark.setEditFlag(CodeConstants.REMARK_EDIT_FLAG_EDITED);
        remark.setEditTime(DateUtils.formatDateTime(new Date()));
        remark.setEditBy(user.getId());
        int i = 0;
        try {
            i=activityRemarkService.editRemarkNoteContentById(remark);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return MyUtils.getReturnObject(i);
    }
}
