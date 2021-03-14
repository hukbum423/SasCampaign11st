package com.skplanet.sascm.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ServiceMapper {

    private static final Logger logger = LoggerFactory.getLogger(ServiceMapper.class);

    public static List<HashMap<String, Object>> convert(List<HashMap<String, Object>> source) {
        List<HashMap<String, Object>> result = new ArrayList<HashMap<String, Object>>();
        int len = source.size();
        for (int i = 0; i < len; i++) {
            HashMap<String, Object> srcRow = source.get(i);
            HashMap<String, Object> trtRow = new HashMap<String, Object>();
            Set<String> keys = srcRow.keySet();
            Iterator<String> ite = keys.iterator();
            while (ite.hasNext()) {
                String key = ite.next();
                trtRow.put(key.toLowerCase(), srcRow.get(key));
                //logger.debug("[key:" + key + "," + "value:" + srcRow.get(key) + "]");
            }
            result.add(trtRow);
        }
        return result;
    }

    public static HashMap<String, Object> convertMap(HashMap<String, Object> source) {
        HashMap<String, Object> result = new HashMap<String, Object>();
        Set<String> keys = source.keySet();
        Iterator<String> ite = keys.iterator();
        while (ite.hasNext()) {
            String key = ite.next();
            result.put(key.toLowerCase(), source.get(key));
            logger.debug("[key:" + key + "," + "value:" + source.get(key) + "]");
        }
        return result;
    }
}
