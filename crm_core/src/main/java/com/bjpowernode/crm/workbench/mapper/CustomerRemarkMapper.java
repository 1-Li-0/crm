package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.CustomerRemark;

public interface CustomerRemarkMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbg.generated Thu Jun 09 10:48:38 CST 2022
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbg.generated Thu Jun 09 10:48:38 CST 2022
     */
    int insert(CustomerRemark row);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbg.generated Thu Jun 09 10:48:38 CST 2022
     */
    int insertSelective(CustomerRemark row);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbg.generated Thu Jun 09 10:48:38 CST 2022
     */
    CustomerRemark selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbg.generated Thu Jun 09 10:48:38 CST 2022
     */
    int updateByPrimaryKeySelective(CustomerRemark row);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbg.generated Thu Jun 09 10:48:38 CST 2022
     */
    int updateByPrimaryKey(CustomerRemark row);
}