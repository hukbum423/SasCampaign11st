package com.skplanet.sascm.util;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.zip.GZIPOutputStream;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;
import org.springframework.web.servlet.view.AbstractView;

public class BaseAction {

    private static final Logger logger = LoggerFactory.getLogger(BaseAction.class);

    public void sendFlag(String flag, HttpServletRequest request, HttpServletResponse response) {
        DataMap jsonMap = new DataMap();
        jsonMap.put("flag", flag);

        sendMap(jsonMap, request, response);
    }

    public void sendCSV(ArrayList<String[]> list, HttpServletRequest request, HttpServletResponse response) {
        StringBuffer result = new StringBuffer();
        int len = list.size();
        if (len > 0) {
            String[] row = list.get(0);
            int colCnt = row.length;
            result.append(row[0]);
            for (int j = 1; j < colCnt; j++) {
                result.append("," + row[j]);
            }
            result.append("\n");
            for (int i = 1; i < len; i++) {
                row = list.get(i);
                result.append(row[0]);
                for (int j = 1; j < colCnt; j++) {
                    result.append("," + row[j]);
                }
                result.append("\n");
            }
        }
        sendResponse(result.toString(), request, response);
    }
    public void sendMap(DataMap jsonMap, HttpServletRequest request, HttpServletResponse response) {
        sendResponse(JSONObject.fromObject(jsonMap).toString(), request, response);
    }

    public void sendHashMap(HashMap<String, Object> jsonMap, HttpServletRequest request, HttpServletResponse response) {
        sendResponse(JSONObject.fromObject(jsonMap).toString(), request, response);
    }

    public static void sendResponse(String str, HttpServletRequest request, HttpServletResponse response) {
        sendResponse(str, request, response, "utf-8");
    }

    public static void sendResponse(String str, HttpServletRequest request, HttpServletResponse response, String charset) {
        sendResponse(str, request, response, "utf-8", true, "application/json");
    }

    public static void sendResponseXml(String str, HttpServletRequest request, HttpServletResponse response) {
        sendResponseXml(str, request, response, "utf-8");
    }

    public static void sendResponseXml(String str, HttpServletRequest request, HttpServletResponse response, String charset) {
        sendResponse(str, request, response, "utf-8", true, "text/xml");
    }

    public static void sendResponse(String str, HttpServletRequest request, HttpServletResponse response, String charset, boolean zipFlag, String contentType) {

        response.setContentType(contentType + "; charset=" + charset);
        response.setHeader("pragma", "no-cache");
        response.setHeader("cache-control", "no-cache");
        response.setHeader("expires", "0");
        try {
            String userAgent = request.getHeader("user-agent");
            if (userAgent != null && userAgent.toLowerCase().indexOf("flash") > -1) {
                PrintWriter out = response.getWriter();
                out.println(str);
                out.flush();
                out.close();
            } else if (zipFlag) {
                String acceptEncoding = request.getHeader("accept-encoding");
                if (acceptEncoding != null && acceptEncoding.toLowerCase().indexOf("gzip") > -1) {
                    response.setHeader("Content-Encoding", "gzip");

                    GZIPOutputStream out = new GZIPOutputStream(response.getOutputStream());
                    out.write(str.getBytes(charset));
                    out.flush();
                    out.close();
                } else {
                    PrintWriter out = response.getWriter();
                    out.println(str);
                    out.flush();
                    out.close();
                }
            } else {
                PrintWriter out = response.getWriter();
                out.println(str);
                out.flush();
                out.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 
     * 
     * @param request
     * @return
     */
    public String getDomain(HttpServletRequest request) {
        String domain = "https://" + request.getServerName();
        if (request.getServerPort() == 80) {
            domain = domain + request.getContextPath();
        } else {
            domain = domain + ":" + request.getServerPort() + request.getContextPath();
        }
        logger.debug(domain.toString() +"appendCustomeSearch https:// "+request.getServerPort());
        return domain;
    }

    public static ModelAndView getMessageView(final String msg, final String script) {
        View view = new AbstractView() {
            @Override
            protected void renderMergedOutputModel(Map model, HttpServletRequest request, HttpServletResponse response) throws Exception {
                response.setContentType("text/html; charset=UTF-8");
                response.setCharacterEncoding("UTF-8");
                ServletOutputStream outs = response.getOutputStream();
                outs.println("<html><script type='text/javascript'>");
                outs.println("alert(\"" + new String(msg.getBytes(), "ISO_8859_1") + "\");");
                outs.println(new String(script.getBytes(), "ISO_8859_1"));
                outs.println("</script></html>");
                outs.flush();
            }
        };
        return new ModelAndView(view);
    }

    protected DataMap deliverParams(HttpServletRequest request) {
        DataMap result = new DataMap();
        Enumeration<String> params = request.getParameterNames();
        while (params.hasMoreElements()) {
            String key = params.nextElement();
            result.put(key, request.getParameter(key).toString());
            //logger.debug("key:[" + key + "],value:[" + request.getParameter(key).toString() + "]");
        }
        return result;
    }
}