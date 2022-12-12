package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.mapper.ActivityRemarkMapper;
import com.bjpowernode.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {
    @Autowired
    private ActivityRemarkMapper activityRemarkMapper;
    @Override
    public List<ActivityRemark> queryActivityRemarkByActivityId(String activityId) {
        return activityRemarkMapper.selectActivityRemarkByActivityId(activityId);
    }

    @Override
    public int saveCreateActivityRemark(ActivityRemark remark) {
        return activityRemarkMapper.insertActivityRemark(remark);
    }

    @Override
    public int deleteActivityRemarkByRemarkId(String remarkId) {
        return activityRemarkMapper.deleteActivityRemarkByRemarkId(remarkId);
    }

    @Override
    public ActivityRemark queryActivityRemarkByRemarkId(String remarkId) {
        return activityRemarkMapper.selectActivityRemarkByRemarkId(remarkId);
    }

    @Override
    public int editRemarkNoteContentById(ActivityRemark remark) {
        return activityRemarkMapper.updateRemarkById(remark);
    }
}
