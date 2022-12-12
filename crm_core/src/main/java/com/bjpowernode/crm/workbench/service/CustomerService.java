package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.ChartVO;

import java.util.List;

public interface CustomerService {
    List<String> queryCustomerNameForCreateByName(String name);
    List<ChartVO> queryCustomerCountByOwner();
}
