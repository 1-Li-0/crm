package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ChartVO;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    int saveCreateActivity(Activity activity);
    List<Activity> queryActivityByConditionForPage(Map<String,Object> map);
    int queryCountOfActivityByCondition(Map<String,Object> map);
    int deleteActivitiesByIds(String[] ids);
    int saveEditActivityById(Activity activity);
    Activity queryActivityById(String id);
    List<Activity> queryAllActivity();
    List<Activity> queryActivitiesByIds(String[] id);
    int saveCreateActivityByList(List<Activity> activityList);
    Activity queryActivityForDetailById(String id);
    List<Activity> queryActivityForDetailByName(Map<String,Object> map);
    List<Activity> queryActivitiesByClueId(String clueId);
    List<Activity> queryActivityForConvertByName(Map<String,Object> map);
    List<Activity> queryActivityForTranByName(String name);
    List<ChartVO> queryActivityCountByOwner();
}
