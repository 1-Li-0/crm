package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkService {
    List<ActivityRemark> queryActivityRemarkByActivityId(String activityId);
    int saveCreateActivityRemark(ActivityRemark remark);
    int deleteActivityRemarkByRemarkId(String remarkId);
    ActivityRemark queryActivityRemarkByRemarkId(String remarkId);
    int editRemarkNoteContentById(ActivityRemark remark);
}
