package com.jb;

import javax.servlet.*;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

final public class CorsFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) {

    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        // TODO Auto-generated method stub
        HttpServletResponse res = (HttpServletResponse) servletResponse;
        res.setHeader("Access-Control-Allow-Origin", "*");//http://localhost:8080
        res.setHeader("Access-Control-Allow-Methods", "POST, GET");
        res.setHeader("Access-Control-Max-Age", "0");
        res.setHeader("Access-Control-Allow-Headers", "Origin, No-Cache, X-Requested-With, If-Modified-Since, Pragma, Last-Modified, Cache-Control, Expires, Content-Type, X-E4M-With, userId, token, Content-Language, XDomainRequestAllowed");
        res.setHeader("Access-Control-Allow-Credentials", "true");

        res.setHeader("Content-Type", "application/json;charset=UTF-8");
        res.setHeader("Content-Language", "zh");
        res.setHeader("XDomainRequestAllowed","1");

        filterChain.doFilter(servletRequest, servletResponse);
    }

    @Override
    public void destroy() {

    }
}
