package com.bjpowernode.crm.settings.web.interceptor;

import com.bjpowernode.crm.commons.constants.CodeConstants;
import com.bjpowernode.crm.settings.domain.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(CodeConstants.SESSION_USER);
        if (user==null){
            response.sendRedirect(request.getContextPath()+"/");
            return false;
        }
        return true;
    }
}
