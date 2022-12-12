package com.bjpowernode.crm.commons.utils;

import com.bjpowernode.crm.commons.constants.CodeConstants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.workbench.domain.Activity;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.CellType;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

public class MyUtils {
    public static void destroyCookies(HttpServletResponse response){
        Cookie c1=new Cookie("loginAct","0");
        Cookie c2=new Cookie("loginPwd","0");
        Cookie c3=new Cookie("isRemPwd","false");
        c1.setMaxAge(0);
        c2.setMaxAge(0);
        c3.setMaxAge(0);
        response.addCookie(c1);
        response.addCookie(c2);
        response.addCookie(c3);
    }
    public static ReturnObject getReturnObject(int i){
        ReturnObject obj = new ReturnObject();
        if (i>0){
            obj.setCode(CodeConstants.RETURN_OBJECT_CODE_SUCCESS);
        }else {
            obj.setCode(CodeConstants.RETURN_OBJECT_CODE_FAIL);
            obj.setMessage("系统忙，请稍后再试...");
        }
        return obj;
    }
    public static HSSFWorkbook getWorkbookForActivity(List<Activity> activityList){
        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet("activityTable");
        HSSFRow row = sheet.createRow(0);
        row.createCell(0).setCellValue("id");
        row.createCell(1).setCellValue("owner");
        row.createCell(2).setCellValue("name");
        row.createCell(3).setCellValue("startDate");
        row.createCell(4).setCellValue("endDate");
        row.createCell(5).setCellValue("cost");
        row.createCell(6).setCellValue("description");
        row.createCell(7).setCellValue("createTime");
        row.createCell(8).setCellValue("createBy");
        row.createCell(9).setCellValue("editTime");
        row.createCell(10).setCellValue("editBy");
        int i = 0;
        if (activityList.size()>0) {
            for (Activity activity:activityList){
                i++;
                row = sheet.createRow(i);
                activity.setId(String.valueOf(i));
                row.createCell(0).setCellValue(activity.getId());
                row.createCell(1).setCellValue(activity.getOwner());
                row.createCell(2).setCellValue(activity.getName());
                row.createCell(3).setCellValue(activity.getStartDate());
                row.createCell(4).setCellValue(activity.getEndDate());
                row.createCell(5).setCellValue(activity.getCost());
                row.createCell(6).setCellValue(activity.getDescription());
                row.createCell(7).setCellValue(activity.getCreateTime());
                row.createCell(8).setCellValue(activity.getCreateBy());
                row.createCell(9).setCellValue(activity.getEditTime());
                row.createCell(10).setCellValue(activity.getEditBy());
            }
        }
        return wb;
    }
    public static String getCellValueForString(HSSFCell cell){
        String str ="";
        if (cell.getCellType()== CellType.STRING){
            str = cell.getStringCellValue();
        }else if (cell.getCellType()==CellType.BOOLEAN){
            str = cell.getBooleanCellValue()+"";
        }else if (cell.getCellType()==CellType.NUMERIC){
            str = cell.getNumericCellValue()+"";
        }else if (cell.getCellType()==CellType.FORMULA){
            str = cell.getCellFormula();
        }else {
            str ="";
        }
        return str;
    }
}
