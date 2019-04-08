package com.skplanet.sascm.util;

import java.lang.reflect.Type;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.reflect.TypeToken;

public class AlimiBlockConversionTestMain {

	public static void main(String[] args) throws Exception {
		if (Flag.flag) System.out.println(">>>>> " + ClassUtil.getClassInfo());

		if (!Flag.flag) test01();
		if (!Flag.flag) test02();
		if (!Flag.flag) test03();
		if (!Flag.flag) test04();
		if (Flag.flag) test05();
		if (!Flag.flag) test06();
	}

	private static void test01() throws Exception {
		if (Flag.flag) System.out.println(">>>>> " + ClassUtil.getClassInfo());

		String strJson = "{"
				+ " \"restMsg\": \"suc\", "
				+ " \"result\": {"
				+ "   \"rec\": ["
				+ "     { \"ADDR\": \"seoul addr-1\" },"
				+ "     { \"ADDR\": \"seoul addr-2\" },"
				+ "     { \"ADDR\": \"seoul addr-3\" }"
				+ "   ]"
				+ "  }"
				+ "}";
		if (Flag.flag) System.out.println(">>>>> " + strJson);

		JsonParser parser = new JsonParser();
		JsonElement rootObject = parser.parse(strJson);

		if (Flag.flag) System.out.println(">>>>> " + rootObject.getAsJsonObject().get("restMsg"));
		if (Flag.flag) System.out.println(">>>>> " + rootObject.getAsJsonObject().get("result"));
		if (Flag.flag) System.out.println(">>>>> " + rootObject.getAsJsonObject().get("result").getAsJsonObject().get("rec"));

		JsonElement obj = rootObject.getAsJsonObject().get("result").getAsJsonObject().get("rec");
		Type listType = new TypeToken<List<Map<String,String>>>(){}.getType();

		Gson gson = new Gson();
		List<Map<String,String>> listMap = gson.fromJson(obj, listType);
		for (Map<String,String> map : listMap) {
			String key = "ADDR";
			String val = map.get(key);
			if (Flag.flag) System.out.printf(">>>>> ('%s', '%s')%n", key, val);
		}
	}

	private static void test02() throws Exception {
		if (Flag.flag) System.out.println(">>>>> " + ClassUtil.getClassInfo());

		Gson gson = new Gson();
		JsonArray arr = new JsonArray();

		JsonObject obj;
		obj = new JsonObject();
		obj.addProperty("name", "park");
		obj.addProperty("age", 35);
		obj.addProperty("success", true);
		if (Flag.flag) System.out.println(">>>>> arr[0]: " + gson.toJson(obj));
		arr.add(obj);

		obj = new JsonObject();
		obj.addProperty("status", "SUCCESS");
		obj.addProperty("code", 999);
		obj.addProperty("message", "Hello system is done by success...");
		obj.addProperty("user", "Kiea");
		if (Flag.flag) System.out.println(">>>>> arr[1]: " + gson.toJson(obj));
		arr.add(obj);

		if (Flag.flag) System.out.println(">>>>> arr: " + gson.toJson(arr));

		obj = new JsonObject();
		obj.add("arr", arr);
		if (Flag.flag) System.out.println(">>>>> root: " + gson.toJson(obj));
	}

	private static void test03() throws Exception {
		if (Flag.flag) System.out.println(">>>>> " + ClassUtil.getClassInfo());

		/*
		String str = "[{'NO':1,'NAME':'APPLE','KOR':'사과','PRICE':'1000'},{'NO':2,'NAME':'BANANA','KOR':'바나나','PRICE':'500'},{'NO':3,'NAME':'MELON','KOR':'메론','PRICE':'2000'}]";
		JsonParser jsonParser = new JsonParser();
		JsonArray jsonArray = (JsonArray) jsonParser.parse(str);
		for (int i = 0; i < jsonArray.size(); i++) {
			JsonObject object = (JsonObject) jsonArray.get(i);
			String NO = object.get("NO").getAsString();
			String NAME = object.get("NAME").getAsString();
			String KOR = object.get("KOR").getAsString();
			String PRICE = object.get("PRICE").getAsString();

			System.out.println(NO);
			System.out.println(NAME);
			System.out.println(KOR);
			System.out.println(PRICE);
			System.out.println();
		}

		str = "{'fruit':[{'NO':1,'NAME':'APPLE','KOR':'사과','PRICE':'1000'},
				{'NO':2,'NAME':'BANANA','KOR':'바나나','PRICE':'500'},
				{'NO':3,'NAME':'MELON','KOR':'메론','PRICE':'2000'}],
			'animal':[{'NO':1,'NAME':'cat','KOR':'고양이','age':'3'},
				{'NO':2,'NAME':'dog','KOR':'개','age':'5'},
				{'NO':3,'NAME':'rabbit','KOR':'토끼','age':'2'}]}";
		JsonParser Parser = new JsonParser();
		JsonObject jsonObj = (JsonObject) Parser.parse(str);
		JsonArray memberArray = (JsonArray) jsonObj.get("fruit");
		System.out.println("=========fruit=========");
		for (int i = 0; i < memberArray.size(); i++) {
			JsonObject object = (JsonObject) memberArray.get(i);
			System.out.println("번호 : " + object.get("NO"));
			System.out.println("영어 : " + object.get("NAME"));
			System.out.println("한글 : " + object.get("KOR"));
			System.out.println("가격 : " + object.get("PRICE"));
			System.out.println("------------------------");
		}
		memberArray = (JsonArray) jsonObj.get("animal");
		System.out.println("=========animal=========");
		for (int i = 0; i < memberArray.size(); i++) {
			JsonObject object = (JsonObject) memberArray.get(i);
			System.out.println("번호 : " + object.get("NO"));
			System.out.println("영어 : " + object.get("NAME"));
			System.out.println("한글 : " + object.get("KOR"));
			System.out.println("나이 : " + object.get("age"));
			System.out.println("------------------------");
		}
		*/
	}

	/**
	 * FAIL
	 * 
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private static void test04() throws Exception {
		if (Flag.flag) System.out.println(">>>>> " + ClassUtil.getClassInfo());
		
		if (Flag.flag) System.out.println(">>>>> " + new Record().getTalkBlckCont());

		JsonObject obj = new JsonObject();
		Record record = new Record();
		
		obj.addProperty("alimiShow", record.getTalkMsgDispYn());
		obj.addProperty("alimiText", record.getTalkMsgSummary());
		obj.addProperty("alimiType", record.getTalkMsgTmpltNo());
		
		JsonParser parser = new JsonParser();
		JsonElement rootObject = parser.parse(record.getTalkBlckCont());
		Type listType = new TypeToken<List<Map<String,Object>>>(){}.getType();
		Gson gson = new Gson();
		List<Map<String,Object>> listMap = gson.fromJson(rootObject, listType);
		Map<String,String> subMap = null;
		for (Map<String,Object> map : listMap) {
			String id = (String) map.get("id");
			switch (id) {
			case "Block_Top_Cap":
				if (Flag.flag) System.out.println(">>>>> " + id);
				subMap = (Map<String,String>) map.get("payload");
				obj.addProperty("title1", subMap.get("text1"));
				obj.addProperty("advText", subMap.get("sub_text1"));
				break;
			case "Block_Bold_Text":
				if (Flag.flag) System.out.println(">>>>> " + id);
				subMap = (Map<String,String>) map.get("payload");
				obj.addProperty("title2", subMap.get("text1"));
				obj.addProperty("title3", subMap.get("sub_text1"));
				break;
			case "Block_Btn_View":
				if (Flag.flag) System.out.println(">>>>> " + id);
				subMap = (Map<String,String>) map.get("payload");
				obj.addProperty("ftrText", subMap.get("text1"));
				//obj.addProperty("ftrMblUrl", subMap.get("sub_text1"));
				break;
			case "Block_Img_500":
				if (Flag.flag) System.out.println(">>>>> " + id);
				break;
			}
		}
		
		obj.addProperty("ftrText", record.getTalkMsgDispYn());
		obj.addProperty("ftrMblUrl", record.getTalkMsgDispYn());
		obj.addProperty("ftrWebUrl", record.getTalkMsgDispYn());
		
		if (Flag.flag) System.out.println(">>>>> obj: " + obj);
	}
	
	/**
	 * SUCCESS
	 * 
	 * @throws Exception
	 */
	private static void test05() throws Exception {
		if (Flag.flag) System.out.println(">>>>> " + ClassUtil.getClassInfo());
		if (Flag.flag) System.out.println(">>>>> " + new Record().getTalkBlckCont());

		Record record = new Record();             // source
		JsonObject obj = new JsonObject();        // target
		
		obj.addProperty("alimiShow", record.getTalkMsgDispYn());
		obj.addProperty("alimiText", record.getTalkMsgSummary());
		obj.addProperty("alimiType", record.getTalkMsgTmpltNo());
		
		JsonParser parser = new JsonParser();
		JsonArray arrRoot = parser.parse(record.getTalkBlckCont()).getAsJsonArray();
		for (JsonElement element : arrRoot) {
			if (Flag.flag) System.out.println(">>>>> " + element);
			String id = element.getAsJsonObject().get("id").getAsString();
			JsonElement payload = element.getAsJsonObject().get("payload");
			switch (id) {
			case "Block_Top_Cap":
				if (Flag.flag) {
					obj.addProperty("title1", payload.getAsJsonObject().get("text1").getAsString());
					obj.addProperty("addText", payload.getAsJsonObject().get("sub_text1").getAsString());
				}
				break;
			case "Block_Bold_Text":
				if (Flag.flag) {
					obj.addProperty("title2", payload.getAsJsonObject().get("text1").getAsString());
					obj.addProperty("title3", payload.getAsJsonObject().get("sub_text1").getAsString());
				}
				break;
			case "Block_Btn_View":
				if (Flag.flag) {
					obj.addProperty("ftrText", payload.getAsJsonObject().get("text1").getAsString());
					obj.addProperty("ftrMblUrl", payload.getAsJsonObject().get("linkUrl1").getAsJsonObject().get("mobile").getAsString());
					obj.addProperty("ftrWebUrl", payload.getAsJsonObject().get("linkUrl1").getAsJsonObject().get("web").getAsString());
				}
				break;
			case "Block_Img_500":
				if (Flag.flag) {
					JsonArray subArr = new JsonArray();
					for (JsonElement subElement : payload.getAsJsonArray()) {
						JsonObject subObj = new JsonObject();
						subObj.addProperty("imgUrl", subElement.getAsJsonObject().get("imgUrl1").getAsString());
						subArr.add(subObj);
					}
					obj.add("arrImg500", subArr);
				}
				break;
			case "Block_Img_240":
				if (Flag.flag) {
					JsonArray subArr = new JsonArray();
					JsonObject subObj = new JsonObject();
					subObj.addProperty("imgUrl", payload.getAsJsonObject().get("imgUrl1").getAsString());
					subArr.add(subObj);
					obj.add("arrImg240", subArr);
				}
				break;
			case "Block_Product_Price":
				if (Flag.flag) {
					JsonArray subArr = new JsonArray();
					for (JsonElement subElement : payload.getAsJsonArray()) {
						JsonObject subObj = new JsonObject();
						subObj.addProperty("prdUrl", subElement.getAsJsonObject().get("imgUrl1").getAsString());
						subObj.addProperty("prdName", subElement.getAsJsonObject().get("text1").getAsString());
						subObj.addProperty("prdPrice", subElement.getAsJsonObject().get("price1").getAsString());
						subObj.addProperty("prdUnit", subElement.getAsJsonObject().get("priceUnit1").getAsString());
						subObj.addProperty("prdMblUrl", subElement.getAsJsonObject().get("linkUrl1").getAsJsonObject().get("mobile").getAsString());
						subObj.addProperty("prdWebUrl", subElement.getAsJsonObject().get("linkUrl1").getAsJsonObject().get("web").getAsString());
						subArr.add(subObj);
					}
					obj.add("arrPrd", subArr);
				}
				break;
			case "Block_Coupon_Text":
				if (Flag.flag) {
					JsonArray subArr = new JsonArray();
					for (JsonElement subElement : payload.getAsJsonArray()) {
						JsonObject subObj = new JsonObject();
						subObj.addProperty("cpnNumber", subElement.getAsJsonObject().get("couponNo").getAsString());
						subObj.addProperty("cpnText1", subElement.getAsJsonObject().get("couponText").getAsString());
						subObj.addProperty("cpnText2", subElement.getAsJsonObject().get("title1").getAsString());
						subObj.addProperty("cpnText3", subElement.getAsJsonObject().get("sub_text1").getAsString());
						subObj.addProperty("cpnText4", subElement.getAsJsonObject().get("sub_text2").getAsString());
						subObj.addProperty("cpnVisible", subElement.getAsJsonObject().get("isDisplayBtn").getAsBoolean() ? "show" : "hide");
						subArr.add(subObj);
					}
					obj.add("arrCpn", subArr);
				}
				break;
			case "Block_Sub_Test":
				if (Flag.flag) {
					JsonArray subArr = new JsonArray();
					JsonObject subObj = new JsonObject();
					subObj.addProperty("annText", payload.getAsJsonObject().get("test1").getAsString());
					subObj.addProperty("annFixed", payload.getAsJsonObject().get("align").getAsString());
					subArr.add(subObj);
					obj.add("arrAnn", subArr);
				}
				break;
			}
		}
		if (Flag.flag) System.out.println(">>>>> obj: " + new GsonBuilder().setPrettyPrinting().create().toJson(obj));
	}
	
	/**
	 * JsonPrimitive
	 * 
	 * @throws Exception
	 */
	private static void test06() throws Exception {
		if (Flag.flag) System.out.println(">>>>> " + ClassUtil.getClassInfo());
		
		String companyJson= "{\"name\":\"1004lucifer\\u0027s Company\\u0022. \",\"employees\":[{\"name\":\"1004lucifer\",\"age\":\"30\",\"sex\":\"M\"},{\"name\":\"vvoei\",\"age\":\"29\",\"sex\":\"M\"},{\"name\":\"John\",\"sex\":\"M\"},{\"name\":\"Jane\",\"age\":\"20\"},{}]}";
		
		JsonObject object = new JsonParser().parse(companyJson).getAsJsonObject();
		
		if (Flag.flag) System.out.println("========== Encrypt Value =========");
		companyJson = cipherValue(object, true);
		if (Flag.flag) System.out.println(companyJson);
		
		if (Flag.flag) System.out.println("========== Decrypt Value =========");
		companyJson = cipherValue(object, false);
		if (Flag.flag) System.out.println(companyJson);
	}
	
	private static String cipherValue(JsonObject jsonObject, boolean isEncrypt) {
		Iterator<Map.Entry<String, JsonElement>> iterator = jsonObject.entrySet().iterator();
		Map.Entry<String, JsonElement> entry;
		while (iterator.hasNext()) {
			entry = iterator.next();
			String key = entry.getKey();
			JsonElement value = entry.getValue();
			if (Flag.flag) System.out.println("# " + key + ", val=" + value);
			if (value.isJsonPrimitive()) {
				try {
					if (isEncrypt) {
						//entry.setValue(new JsonPrimitive(EncryptSDK.encData(entry.getValue().getAsString())));
						if (Flag.flag) System.out.println(">>>>> encrypt");
					} else {
						//entry.setValue(new JsonPrimitive(EncryptSDK.decrypt(entry.getValue().getAsString())));
						if (Flag.flag) System.out.println(">>>>> decrypt");
					}
				} catch (Exception e) {}
			} else if (value.isJsonObject()) {
				cipherValue(value.getAsJsonObject(), isEncrypt);
			} else if (value.isJsonArray()) {
				JsonArray jsonArray = value.getAsJsonArray();
				JsonElement jsonElement;
				for (int i=0; i < jsonArray.size(); i++) {
					jsonElement = jsonArray.get(i);
					cipherValue(jsonElement.getAsJsonObject(), isEncrypt);
				}
			} else if (value.isJsonNull()) {
				if (Flag.flag) System.out.println(">>>>> JsonNull");
			}
		}
		return null;
	}
	
	@SuppressWarnings("unused")
	private static <T> List<T> toList(String json, Class<T> clazz) {
		if (json == null) {
			return null;
		}
		Gson gson = new Gson();
		return gson.fromJson(json, new TypeToken<T>(){}.getType());
	}
}

class Record {
	private String cellId = "1526";
	private String campaignCode = "CAMP718";
	private String campaignId = "718";
	private String channelCd = "MOBILE";
	private String appKdCd = "01";
	private String talkMsgDispYn = "Y";
	private String talkMsgSummary = "aaa";
	private String talkMsgTmpltNo = "001";
	private String talkBlckCont = ""
			+ "[                                     \n"
			+ "  {                                   \n"
			+ "    \"id\": \"Block_Top_Cap\",        \n"
			+ "    \"payload\": {                    \n"
			+ "      \"text1\": \"bbb\",             \n"
			+ "      \"sub_text1\": \"광고\"         \n"
			+ "    }                                 \n"
			+ "  },                                  \n"
			+ "  {                                   \n"
			+ "    \"id\": \"Block_Bold_Text\",      \n"
			+ "    \"payload\": {                    \n"
			+ "      \"text1\": \"ccc\",             \n"
			+ "      \"sub_text1\": \"ddd\"          \n"
			+ "    }                                 \n"
			+ "  },                                  \n"
			
			
			+ "  {                                   \n"
			+ "    \"id\": \"Block_Img_500\",        \n"
			+ "    \"payload\": [                    \n"
			+ "      {                               \n"
			+ "        \"imgUrl1\": \"http://eee1\"  \n"
			+ "      },                              \n"
			+ "      {                               \n"
			+ "        \"imgUrl1\": \"http://eee2\"  \n"
			+ "      }                               \n"
			+ "    ]                                 \n"
			+ "  },                                  \n"
			
			
			+ "  {                                                                                \n"
			+ "    \"id\": \"Block_Img_240\",                                                     \n"
			+ "    \"payload\": {                                                                 \n"
			+ "      \"imgUrl1\": \"http://i.011st.com/ui_img/11talk/img_500_240_sample1.png\"    \n"
			+ "    }                                                                              \n"
			+ "  },                                                                               \n"
			
			
			+ "  {                                                                                               \n"
			+ "    \"id\": \"Block_Product_Price\",                                                              \n"
			+ "    \"payload\": [                                                                                \n"
			+ "      {                                                                                           \n"
			+ "        \"imgUrl1\": \"http://i.011st.com/ui_img/11talk/Product_Price_img_small1.jpg\",           \n"
			+ "        \"text1\": \"임시상품-1\",                                                                \n"
			+ "        \"price1\": \"10,000\",                                                                   \n"
			+ "        \"priceUnit1\": \"원\",                                                                   \n"
			+ "        \"linkUrl1\": {                                                                           \n"
			+ "          \"mobile\": \"http://i.011st.com/ui_img/11talk/img_500_250_sample2.png\",               \n"
			+ "          \"web\": \"\"                                                                           \n"
			+ "        }                                                                                         \n"
			+ "      },                                                                                          \n"
			+ "      {                                                                                           \n"
			+ "        \"imgUrl1\": \"http://i.011st.com/ui_img/11talk/Product_Price_img_small2.jpg\",           \n"
			+ "        \"text1\": \"임시상품-2\",                                                                \n"
			+ "        \"price1\": \"20,000\",                                                                   \n"
			+ "        \"priceUnit1\": \"원\",                                                                   \n"
			+ "        \"linkUrl1\": {                                                                           \n"
			+ "          \"mobile\": \"http://i.011st.com/ui_img/11talk/img_500_250_sample2.png\",               \n"
			+ "          \"web\": \"\"                                                                           \n"
			+ "        }                                                                                         \n"
			+ "      },                                                                                          \n"
			+ "      {                                                                                           \n"
			+ "        \"imgUrl1\": \"http://i.011st.com/ui_img/11talk/Product_Price_img_small3.jpg\",           \n"
			+ "        \"text1\": \"임시상품-3\",                                                                \n"
			+ "        \"price1\": \"30,000\",                                                                   \n"
			+ "        \"priceUnit1\": \"원\",                                                                   \n"
			+ "        \"linkUrl1\": {                                                                           \n"
			+ "          \"mobile\": \"http://i.011st.com/ui_img/11talk/img_500_250_sample2.png\",               \n"
			+ "          \"web\": \"\"                                                                           \n"
			+ "        }                                                                                         \n"
			+ "      }                                                                                           \n"
			+ "    ]                                                                                             \n"
			+ "  },                                                                                              \n"
			
			
			+ "  {                                                                                \n" 
			+ "    \"id\": \"Block_Coupon_Text\",                                                 \n" 
			+ "    \"payload\": [                                                                 \n" 
			+ "      {                                                                            \n" 
			+ "        \"couponNo\": \"1234567891\",                                              \n" 
			+ "        \"couponText\": \"30%, 2,500(1)\",                                         \n" 
			+ "        \"title1\": \"5월 VVIP구매등급 쿠폰\",                                     \n" 
			+ "        \"sub_text1\": \"3,000원이상 구매 최대 2,500원 이벤트\u0026기획전 쿠폰\",  \n" 
			+ "        \"sub_text2\": \"2019.04.01 ~ 2019.04.30\",                                \n" 
			+ "        \"isDisplayBtn\": true                                                     \n" 
			+ "      },                                                                           \n" 
			+ "      {                                                                            \n" 
			+ "        \"couponNo\": \"1234567892\",                                              \n" 
			+ "        \"couponText\": \"30%, 2,500(2)\",                                         \n" 
			+ "        \"title1\": \"5월 VVIP구매등급 쿠폰\",                                     \n" 
			+ "        \"sub_text1\": \"3,000원이상 구매 최대 2,500원 이벤트\u0026기획전 쿠폰\",  \n" 
			+ "        \"sub_text2\": \"2019.04.01 ~ 2019.04.30\",                                \n" 
			+ "        \"isDisplayBtn\": false                                                    \n" 
			+ "      },                                                                           \n" 
			+ "      {                                                                            \n" 
			+ "        \"couponNo\": \"1234567893\",                                              \n" 
			+ "        \"couponText\": \"30%, 2,500(3)\",                                         \n" 
			+ "        \"title1\": \"5월 VVIP구매등급 쿠폰\",                                     \n" 
			+ "        \"sub_text1\": \"3,000원이상 구매 최대 2,500원 이벤트\u0026기획전 쿠폰\",  \n" 
			+ "        \"sub_text2\": \"2019.04.01 ~ 2019.04.30\",                                \n" 
			+ "        \"isDisplayBtn\": true                                                     \n" 
			+ "      },                                                                           \n" 
			+ "      {                                                                            \n" 
			+ "        \"couponNo\": \"1234567894\",                                              \n" 
			+ "        \"couponText\": \"30%, 2,500(4)\",                                         \n" 
			+ "        \"title1\": \"5월 VVIP구매등급 쿠폰\",                                     \n" 
			+ "        \"sub_text1\": \"3,000원이상 구매 최대 2,500원 이벤트\u0026기획전 쿠폰\",  \n" 
			+ "        \"sub_text2\": \"2019.04.01 ~ 2019.04.30\",                                \n" 
			+ "        \"isDisplayBtn\": false                                                    \n" 
			+ "      },                                                                           \n" 
			+ "      {                                                                            \n" 
			+ "        \"couponNo\": \"1234567895\",                                              \n" 
			+ "        \"couponText\": \"30%, 2,500(5)\",                                         \n" 
			+ "        \"title1\": \"5월 VVIP구매등급 쿠폰\",                                     \n" 
			+ "        \"sub_text1\": \"3,000원이상 구매 최대 2,500원 이벤트\u0026기획전 쿠폰\",  \n" 
			+ "        \"sub_text2\": \"2019.04.01 ~ 2019.04.30\",                                \n" 
			+ "        \"isDisplayBtn\": true                                                     \n" 
			+ "      },                                                                           \n" 
			+ "      {                                                                            \n" 
			+ "        \"couponNo\": \"1234567896\",                                              \n" 
			+ "        \"couponText\": \"30%, 2,500(6)\",                                         \n" 
			+ "        \"title1\": \"5월 VVIP구매등급 쿠폰\",                                     \n" 
			+ "        \"sub_text1\": \"3,000원이상 구매 최대 2,500원 이벤트\u0026기획전 쿠폰\",  \n" 
			+ "        \"sub_text2\": \"2019.04.01 ~ 2019.04.30\",                                \n" 
			+ "        \"isDisplayBtn\": false                                                    \n" 
			+ "      }                                                                            \n" 
			+ "    ]                                                                              \n" 
			+ "  },                                                                               \n" 
			
			
			+ "  {                                                                      \n"
			+ "    \"id\": \"Block_Sub_Text\",                                          \n"
			+ "    \"payload\": {                                                       \n"
			+ "      \"text1\": \"직영몰 상품의 주문량이 많아 배송이 늦어질 수 있습니다.\",  \n"
			+ "      \"align\": \"center\"                                              \n"
			+ "    }                                                                    \n"
			+ "  },                                                                     \n"
			
			
			+ "  {                                   \n"
			+ "    \"id\": \"Block_Btn_View\",       \n"
			+ "    \"payload\": {                    \n"
			+ "      \"text1\": \"fff\",             \n"
			+ "      \"linkUrl1\": {                 \n"
			+ "        \"mobile\": \"http://ggg\",   \n"
			+ "        \"web\": \"\"                 \n"
			+ "      }                               \n"
			+ "    }                                 \n"
			+ "  }                                   \n"
			+ "]                                     \n";
	private String mobileSendPreferCd = "SEND01";
	private String mobilePersonMsgYn = "Y";
	private String createDt = "19/03/28";
	private String createId = "2";
	private String updateDt = "19/03/28";
	private String updateId = "2";
	public String getCellId() {
		return cellId;
	}
	public String getCampaignCode() {
		return campaignCode;
	}
	public String getCampaignId() {
		return campaignId;
	}
	public String getChannelCd() {
		return channelCd;
	}
	public String getAppKdCd() {
		return appKdCd;
	}
	public String getTalkMsgDispYn() {
		return talkMsgDispYn;
	}
	public String getTalkMsgSummary() {
		return talkMsgSummary;
	}
	public String getTalkMsgTmpltNo() {
		return talkMsgTmpltNo;
	}
	public String getTalkBlckCont() {
		return talkBlckCont;
	}
	public String getMobileSendPreferCd() {
		return mobileSendPreferCd;
	}
	public String getMobilePersonMsgYn() {
		return mobilePersonMsgYn;
	}
	public String getCreateDt() {
		return createDt;
	}
	public String getCreateId() {
		return createId;
	}
	public String getUpdateDt() {
		return updateDt;
	}
	public String getUpdateId() {
		return updateId;
	}
}