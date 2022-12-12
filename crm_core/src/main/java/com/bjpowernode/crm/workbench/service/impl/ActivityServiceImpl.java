package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ChartVO;
import com.bjpowernode.crm.workbench.mapper.ActivityMapper;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {
    @Autowired
    private ActivityMapper activityMapper;
    @Override
    public int saveCreateActivity(Activity activity) {
        return activityMapper.insertActivity(activity);
    }

    @Override
    public List<Activity> queryActivityByConditionForPage(Map<String,Object> map) {
        return activityMapper.selectActivityByConditionForPage(map);
    }

    @Override
    public int queryCountOfActivityByCondition(Map<String,Object> map) {
        return activityMapper.selectCountOfActivityByCondition(map);
    }

    @Override
    public int deleteActivitiesByIds(String[] ids) {
        return activityMapper.deleteActivitiesByIds(ids);
    }

    @Override
    public int saveEditActivityById(Activity activity) {
        return activityMapper.updateActivityById(activity);
    }

    @Override
    public Activity queryActivityById(String id) {
        return activityMapper.selectActivityById(id);
    }

    @Override
    public List<Activity> queryAllActivity() {
        return activityMapper.selectAllActivity();
    }

    @Override
    public List<Activity> queryActivitiesByIds(String[] id) {
        return activityMapper.selectActivitiesByIds(id);
    }

    @Override
    public int saveCreateActivityByList(List<Activity> activityList) {
        return activityMapper.insertActivityByList(activityList);
    }

    @Override
    public Activity queryActivityForDetailById(String id) {
        return activityMapper.selectActivityForDetailById(id);
    }

    @Override
    public List<Activity> queryActivityForDetailByName(Map<String,Object> map) {
        return activityMapper.selectActivityForDetailByName(map);
    }

    @Override
    public List<Activity> queryActivitiesByClueId(String clueId) {
        return activityMapper.selectActivitiesByClueId(clueId);
    }

    @Override
    public List<Activity> queryActivityForConvertByName(Map<String, Object> map) {
        return activityMapper.selectActivityForConvertByName(map);
    }

    @Override
    public List<Activity> queryActivityForTranByName(String name) {
        return activityMapper.selectActivityForTranByName(name);
    }

    @Override
    public List<ChartVO> queryActivityCountByOwner() {
        return activityMapper.selectActivityCountByOwner();
    }
}
