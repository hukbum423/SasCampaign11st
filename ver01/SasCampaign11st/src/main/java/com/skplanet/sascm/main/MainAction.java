package com.skplanet.sascm.main;

import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.skplanet.sascm.util.BaseAction;
import com.skplanet.sascm.util.DataMap;

@Controller
public class MainAction extends BaseAction {

    private static final Logger logger = LoggerFactory.getLogger(MainAction.class);

    @Resource(name = "messageSourceAccessor")
    protected MessageSourceAccessor messageSource;

    @Autowired
    private MainService fsService;

    // 화면 진입
    @RequestMapping("/main")
    public ModelAndView main(HttpServletRequest request, HttpServletResponse response) {
        logger.debug("main start");
        ModelAndView mv = new ModelAndView("/main/main");
        /*
        try {
            DataMap params = deliverParams(request);
            HashMap<String, Object> result = fsService.detailAuth(params);
            HashMap<String, Object> eventManagerYn = fsService.getEventManagerYN(params);
            result.put("event_auth", eventManagerYn.get("event_auth"));
            mv.addObject("result", result);
        } catch (Exception e) {
            //e.printStackTrace();
            //mv.addObject("result", ExceptionHandler.getMessage(e));
        	
        	e.printStackTrace();
            StackTraceElement[] trace = e.getStackTrace();
            StringBuffer sb = new StringBuffer();
            for (int i = 0; i < trace.length; i++) {
                sb.append(trace[i].toString() + "<br/>");
            }
            mv = new ModelAndView("/common/auth_error");
            mv.addObject("result", sb.toString());
            logger.debug("main exception finish");
            return mv;
        }
        logger.debug("main finish");
        */
        return mv;
    }
}
