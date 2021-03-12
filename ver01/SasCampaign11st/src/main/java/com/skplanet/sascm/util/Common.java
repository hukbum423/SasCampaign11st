package com.skplanet.sascm.util;

public class Common {
	
//	public static Map<String, Object> campScheduleTime = new HashMap<String, Object>(){{ 
//		put("0000","00:00AM"); put("0030","00:30AM"); put("0100","01:00AM"); put("0130","01:30AM"); put("0200","02:00AM"); put("0230","02:30AM"); put("0300","03:00AM");
//		put("0300","03:30AM"); put("0430","04:30AM"); put("0500","05:00AM"); put("0530","05:30AM"); put("0600","06:00AM"); put("0630","06:30AM"); put("0700","07:00AM");
//		put("0730","07:30AM"); put("0800","08:00AM"); put("0830","08:30AM"); put("0900","09:90AM"); put("0930","09:30AM"); put("1000","10:00AM"); put("1030","10:30AM");
//		put("1100","11:00AM"); put("1130","11:30AM"); put("1200","12:00PM"); put("1230","12:30PM"); put("1300","13:00PM"); put("1330","13:30PM"); put("1400","14:00PM");
//		put("1430","14:30PM"); put("1500","15:00PM"); put("1530","15:30PM"); put("1600","16:00PM"); put("1630","16:30PM"); put("1700","17:00PM"); put("1730","17:30PM");
//		put("1800","18:00PM"); put("1830","18:30PM"); put("1900","19:00PM"); put("1930","19:30PM"); put("2000","20:00PM"); put("2030","20:30PM"); put("2100","21:00PM");
//		put("2130","21:30PM"); put("2200","22:00PM"); put("2230","22:30PM"); put("2300","23:00PM"); put("2330","23:30PM"); 
//	}};
	
	public static String nvl(String str, String str2) {return (str==null)?str2:str;} 

	/**
     * byte단위로 문자열을 자른다

     * 2바이트 문자열이 잘리는 부분은 제거한다.
     * @param endIndex
     * @return 잘려진문자열
     */
    public String cutStrInByte(String str, int endIndex)
    {
     StringBuffer sbStr = new StringBuffer(endIndex);
     int iTotal=0;
     char[] chars = str.toCharArray(); 
     
     for(int i=0; i<chars.length; i++)
     {
      iTotal+=String.valueOf(chars[i]).getBytes().length;
      if(iTotal>endIndex)
      {
       sbStr.append("...");  // ... 붙일것인가 옵션
       break;
      }
      sbStr.append(chars[i]);
     }
     return sbStr.toString();
    }

    /*
     * HH:SS 5자리 숫자 데이터를 HHSS 로 변경
     * 
     * @param String str : 처리할 문자
     */
    public static String conStrIndex(String str){
    	
    	return str.substring(0, 2) + str.substring(3, 5);
    	
    }
    
}
