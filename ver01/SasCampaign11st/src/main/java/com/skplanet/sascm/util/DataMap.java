package com.skplanet.sascm.util;

import java.io.Serializable;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * HashMap 상속 받아 사용하기 쉽게 만든 Util
 * 
 * @author : Kim YoungBum (bumworld@gmail.com)
 * @version : 1.0
 * @comment :
 */
public class DataMap extends HashMap implements Serializable {

    private static final Logger logger = LoggerFactory.getLogger(DataMap.class);
    private static SimpleDateFormat fmtDate = null;

    private String name;
    /**
     * 정렬 value 타입
     */
    private int sortType;
    /**
     * 정렬 키 이름
     */
    private String sortKeyName;
    private String sortDateFormat = "yyyyMMddHHmmss";

    public void setSortSetting(int sortType, String sortKeyName) {
        setSortSetting(sortType, sortKeyName, "yyyyMMddHHmmss");
    }

    public void setSortSetting(int sortType, String sortKeyName, String sortDateFormat) {
        this.sortType = sortType;
        this.sortKeyName = sortKeyName;
        if (StringUtils.isNotBlank(sortDateFormat)) {
            this.sortDateFormat = sortDateFormat;
        }

        fmtDate = new SimpleDateFormat(this.sortDateFormat);
    }

    /**
     * 생성자
     * 
     * @param name
     *            DataMap 이름
     */
    public DataMap(String name) {
        super();
        this.name = name;
    }

    public DataMap(int sortType, String sortKeyName) {
        super();
        setSortSetting(sortType, sortKeyName, "yyyyMMddHHmmss");
    }

    public DataMap(int sortType, String sortKeyName, String sortDateFormat) {
        super();

        this.sortType = sortType;
        this.sortKeyName = sortKeyName;
        if (StringUtils.isNotBlank(sortDateFormat)) {
            this.sortDateFormat = sortDateFormat;
        }

        fmtDate = new SimpleDateFormat(this.sortDateFormat);
    }

    /**
     * 생성자
     * 
     */
    public DataMap() {
        super();
    }

    /**
     * DataMap 이름
     * 
     * @param name
     *            DataMap 이름
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * DataMap 이름
     * 
     * @return
     */
    public String getName() {
        return this.name;
    }

    /**
     * Object 값을 넘겨 준다.
     * 
     * @param key
     * @return
     */
    public Object getObject(String key) {
        return super.get(key);
    }

    /**
     * key가 없을경우 원하는 defaultValue return
     * 
     * @param key
     * @param flag
     * @return
     */
    public boolean getBoolean(String key, boolean defaultValue) {
        if (StringUtils.isBlank(key) || containsKey(key) == false || StringUtils.isBlank(getString(key))) {
            return defaultValue;
        }

        return getBoolean(key);
    }

    /**
     * 해당 Key 값 boolean으로 받기
     * 
     * @param key
     *            java.lang.String
     * @return boolean
     */
    public boolean getBoolean(String key) {
        String value = getString(key);
        boolean isTrue = false;
        try {
            isTrue = (new Boolean(value)).booleanValue();
        } catch (Exception e) {
            logger.error("getCookie", e);
        } finally {
        }
        return isTrue;
    }

    /**
     * 해당 Key 값 double로 받기 key가 없을경우 원하는 defaultValue return
     * 
     * @param key
     * @param defaultValue
     * @return
     */
    public double getDouble(String key, double defaultValue) {
        if (StringUtils.isBlank(key) || containsKey(key) == false) {
            return defaultValue;
        }

        return getDouble(key);
    }

    /**
     * 해당 Key 값 double으로 받기
     * 
     * @param key
     *            java.lang.String
     * @return java.lang.double
     */
    public double getDouble(String key) {
        double returnNum = 0;
        String value = getString(key);
        if (StringUtils.isBlank(value)) {
            return returnNum;
        }

        try {
            returnNum = Double.valueOf(value).doubleValue();
        } catch (Exception e) {
            logger.error("getCookie", e);
        }
        return returnNum;
    }

    /**
     * 해당 Key 값 float으로 받기 key가 없을경우 원하는 defaultValue return
     * 
     * @param key
     * @param defaultValue
     * @return
     */
    public float getFloat(String key, float defaultValue) {
        if (StringUtils.isBlank(key) || containsKey(key) == false) {
            return defaultValue;
        }

        return getFloat(key);
    }

    /**
     * 해당 Key 값 float으로 받기
     * 
     * @param key
     *            java.lang.String
     * @return java.lang.float
     */
    public float getFloat(String key) {
        return (float) getDouble(key);
    }

    /**
     * 해당 Key 값 int으로 받기 key가 없을경우 원하는 defaultValue return
     * 
     * @param key
     * @param defaultValue
     * @return
     */
    public int getInt(String key, int defaultValue) {
        if (StringUtils.isBlank(key) || containsKey(key) == false) {
            return defaultValue;
        }

        return getInt(key);
    }

    /**
     * 해당 Key 값 int로 받기
     * 
     * @param key
     * @return
     */
    public int getInt(String key) {
        double value = getDouble(key);
        return (int) value;
    }

    /**
     * key가 없을경우 원하는 defaultValue return
     * 
     * @param key
     * @param defaultValue
     * @return
     */
    public long getLong(String key, int defaultValue) {
        if (StringUtils.isBlank(key) || containsKey(key) == false) {
            return defaultValue;
        }

        return getLong(key);
    }

    /**
     * 해당 Key 값 long으로 받기
     * 
     * @param
     * @return
     */
    public long getLong(String key) {
        long lvalue = 0L;

        String value = getString(key);
        if (StringUtils.isBlank(value)) {
            return lvalue;
        }

        try {
            lvalue = Long.valueOf(value).longValue();
        } catch (Exception e) {
            logger.error("getCookie", e);
        }

        return lvalue;
    }

    public String getString(String key) {
        return getString(key, null);
    }

    /**
     * 해당 Key 값 String으로 받기
     * 
     * @param key
     *            java.lang.String
     * @return java.lang.String
     */
    public String getString(String key, String defaultValue) {
        String returnValue = "";

        if (StringUtils.isBlank(key) || containsKey(key) == false) {
            return defaultValue;
        }

        try {

            Object obj = get(key);
            if (obj instanceof java.lang.String) {
                returnValue = (String) obj;
            } else if (obj instanceof java.math.BigDecimal) {
                returnValue = ((BigDecimal) obj).toString();
            } else if (obj instanceof java.lang.Integer) {
                returnValue = ((Integer) obj).toString();
            } else if (obj == null) {
                returnValue = "";
            } else {
                returnValue = obj.toString();
            }

            if (StringUtils.isBlank(returnValue)) {
                return defaultValue;
            }
        } catch (Exception e) {
            logger.error("getCookie", e);
            returnValue = "";
        }

        return returnValue;
    }

    /**
     * key value의 isBlank
     * 
     * @param key
     * @return
     */
    public boolean isBlank(String key) {
        return StringUtils.isBlank(getString(key));
    }

    /**
     * key value의 isNotBlank
     * 
     * @param key
     * @return
     */
    public boolean isNotBlank(String key) {
        return StringUtils.isNotBlank(getString(key));
    }

    /**
     * Key1이 없으면 Key2로 리턴
     * 
     * @param key
     *            java.lang.String
     * @return java.lang.String
     */
    public String getStringKeys(String key1, String key2) {

        String keyValue = getString(key1);
        if (StringUtils.isBlank(keyValue)) {
            keyValue = getString(key2);
        }

        return keyValue;
    }

    /**
     * key list를 arrayList에 담아 return.
     * 
     * @return
     */
    @SuppressWarnings("unchecked")
    public ArrayList<String> getKeyList() {
        ArrayList<String> list = new ArrayList<String>();

        Set<String> keys = keySet();

        Iterator<String> it = keys.iterator();

        while (it.hasNext()) {
            list.add(it.next());
        }

        return list;
    }

    /**
     * 전화번호 포멧 형식
     * 
     * @param name
     * @return
     */
    public String getTel(String name) {
        String telNumber = getString(name);
        telNumber = StringUtils.replace(telNumber, "-", "");
        if (StringUtils.isBlank(telNumber)) {
            return "";
        }

        if (telNumber.length() >= 7 && telNumber.length() <= 11) {
            Pattern tellPattern = Pattern.compile("^(01\\d{1}|02|0505|0502|0506|0\\d{1,2})-?(\\d{3,4})-?(\\d{4})");
            Matcher matcher = tellPattern.matcher(telNumber);
            if (matcher.matches()) {
                return matcher.group(1) + "-" + matcher.group(2) + "-" + matcher.group(3);
            }
        }

        return telNumber;
    }

    /**
     * DataMap에 put 한다.
     * 
     * @param key
     * @param value
     */
    public void put(String key, Object value) {
        if (value != null) {
            super.put(key, value);
        }
    }

    /**
     * DataMap에 int형으로 put하면<br>
     * 내부적으로 String 변환하여 put한다.
     * 
     * @param key
     * @param value
     */
    public void put(String key, int value) {
        super.put(key, Integer.valueOf(value));
    }

    /**
     * 전체 키와 value를 리턴한다.
     * 
     * @return
     */
    public String getKeyValue() {
        StringBuffer buf = new StringBuffer();
        ArrayList keyList = this.getKeyList();
        for (int i = 0; i < keyList.size(); i++) {
            String key = (String) keyList.get(i);
            Object obj = this.get(key);
            if (obj != null) {
                if (obj instanceof java.lang.String) {
                    buf.append("key : " + key + "     value : " + obj + "\n");
                } else if (obj.getClass().isArray()) {
                    Object[] objArray = (Object[]) obj;
                    for (int j = 0; j < objArray.length; j++) {
                        if (objArray[j] == null) {
                            buf.append("\t" + key + " : " + j + " is null \n");
                        } else {
                            buf.append("\t" + key + " : " + j + " : " + objArray[j] + "\n");
                        }
                    }
                } else {
                    buf.append("key : " + key + "     value : " + obj.toString() + "\n");
                }
            } else {
                buf.append("key : " + key + "     value is null\n");
            }
        }
        return buf.toString();
    }

    /**
     * simple json에서 JsonArray에 넘기기 위한 데이타 가공
     */
    public String toString() {
        JSONObject json = JSONObject.fromObject(this);
        return json.toString();
    }

    /**
     * key 값의 문자열이 해당 문자열과 같은지 체크
     * 
     * @param key
     * @param value
     * @return
     */
    public boolean equals(String key, String value) {
        boolean flag = false;

        String eqStr = getString(key);

        if (eqStr == value) {
            flag = true;
        } else if (eqStr != null && eqStr.equals(value)) {
            flag = true;
        } else {
            flag = false;
        }

        return flag;
    }

    /**
     * key의 int형 값이 비교값과 같은지 체크
     * 
     * @param key
     * @param value
     * @return
     */
    public boolean equals(String key, int value) {
        boolean flag = false;
        try {
            if (Integer.parseInt(getString(key)) == value) {
                flag = true;
            } else {
                flag = false;
            }
        } catch (Exception e) {
            logger.error("", e);
            flag = false;
        }
        return flag;
    }
}