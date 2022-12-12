package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.commons.constants.CodeConstants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.MyUtils;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {
    @Autowired
    UserService userService;
    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin(){
        return "settings/qx/user/login";
    }

    @RequestMapping("/settings/qx/user/login.do")
    @ResponseBody
    public Object Login(String loginAct, String loginPwd, String isRemPwd, HttpServletRequest request, HttpServletResponse response, HttpSession session){
        Map<String,Object> map = new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        User user = userService.queryUserByLoginActAndPwd(map);
        ReturnObject obj = new ReturnObject();
        if (user==null){
            //用户名或者密码不正确
            obj.setCode(CodeConstants.RETURN_OBJECT_CODE_FAIL);
            obj.setMessage("用户名或者密码不正确");
        }else if (DateUtils.formatDateTime(new Date()).compareTo(user.getExpireTime())>0){
            //用户已过期
            obj.setCode(CodeConstants.RETURN_OBJECT_CODE_FAIL);
            obj.setMessage("用户已过期");
        }else if ("0".equals(user.getLockState())){
            //用户状态被锁定
            obj.setCode(CodeConstants.RETURN_OBJECT_CODE_FAIL);
            obj.setMessage("用户状态被锁定");
        }else if (!user.getAllowIps().contains(request.getRemoteAddr())){
            //ip受限
            obj.setCode(CodeConstants.RETURN_OBJECT_CODE_FAIL);
            obj.setMessage("ip受限");
        }else {
            //登陆成功
            obj.setCode(CodeConstants.RETURN_OBJECT_CODE_SUCCESS);
            session.setAttribute(CodeConstants.SESSION_USER,user);
            if (isRemPwd.equals("true")){
                Cookie c1=new Cookie("loginAct",loginAct);
                Cookie c2=new Cookie("loginPwd",loginPwd);
                Cookie c3=new Cookie("isRemPwd",isRemPwd);
                c1.setMaxAge(7*24*60*60);
                c2.setMaxAge(7*24*60*60);
                c3.setMaxAge(7*24*60*60);
                response.addCookie(c1);
                response.addCookie(c2);
                response.addCookie(c3);
            }else if (isRemPwd.equals("false")){
                MyUtils.destroyCookies(response);
            }
        }
        return obj;
    }
    @RequestMapping("/settings/qx/user/logout.do")
    public String logout(HttpSession session,HttpServletResponse response){
        MyUtils.destroyCookies(response);
        session.invalidate();
        return "redirect:/";
    }
}
