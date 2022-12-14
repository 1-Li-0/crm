package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkMapper {

    int deleteActivityRemarkByRemarkId(String remarkId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbg.generated Thu Jun 02 16:09:28 CST 2022
     */
    int insert(ActivityRemark row);

    ActivityRemark selectActivityRemarkByRemarkId(String remarkId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbg.generated Thu Jun 02 16:09:28 CST 2022
     */
    int updateByPrimaryKey(ActivityRemark row);

    List<ActivityRemark> selectActivityRemarkByActivityId(String activityId);

    int insertActivityRemark(ActivityRemark remark);

    int updateRemarkById(ActivityRemark remark);
}
