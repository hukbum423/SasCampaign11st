package com.skplanet.sascm.util;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.google.common.collect.Lists;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.reflect.TypeToken;

import skt.tmall.talk.dto.PushTalkParameter;
import skt.tmall.talk.dto.type.AppKdCdType;
import skt.tmall.talk.dto.type.Block;
import skt.tmall.talk.dto.type.BlockBoldText;
import skt.tmall.talk.dto.type.BlockBtnView;
import skt.tmall.talk.dto.type.BlockCouponText;
import skt.tmall.talk.dto.type.BlockImg240;
import skt.tmall.talk.dto.type.BlockImg500;
import skt.tmall.talk.dto.type.BlockLinkUrl;
import skt.tmall.talk.dto.type.BlockProductPrice;
import skt.tmall.talk.dto.type.BlockSubText;
import skt.tmall.talk.dto.type.BlockSubTextAlignType;
import skt.tmall.talk.dto.type.BlockTopCap;
import skt.tmall.talk.service.PushTalkSendService;

public class TypeToJsonTestMain {

	private static boolean flag = true;
	
	// memberNo: 김영천(18468196) 강석(12774111) 김창범(20750578,42751905,10000276)
	//private static Long memberNo = 18468196L;  // 김영천(18468196)
	private static Long memberNo = 12774111L;  // 강석 (12774111)
	//private static Long memberNo = 20750578L;  // 김창범(20750578) 개발 김창범(42751905,10000276)
	private static int SEQ = 9;
	
	public static void main(String[] args) throws Exception {
		if (flag) test01();
		if (flag) try { Thread.sleep(1000); } catch (InterruptedException e) {}
		if (flag) test02();
		if (flag) try { Thread.sleep(1000); } catch (InterruptedException e) {}
		if (flag) test03();
		if (flag) try { Thread.sleep(1000); } catch (InterruptedException e) {}
		if (flag) test04();
		if (flag) try { Thread.sleep(1000); } catch (InterruptedException e) {}
		if (flag) test05();
		if (flag) try { Thread.sleep(1000); } catch (InterruptedException e) {}
		if (flag) test06();
	}
	
	@SuppressWarnings("unchecked")
	private static void test01() {
		Gson gson = new Gson();
		String jsonParams = null;
		Map<String, Object> mapParams = null;
		List<Block> composites = null;
		int seq = 100 + SEQ;
		
		if (flag) {
			// Type 1
			jsonParams = "{\"alimiShow\":\"Y\",\"alimiText\":\"a\",\"alimiType\":\"001\","
					+ "\"title1\":\"패션워크\",\"advText\":\"광고\",\"title2\":\"반값 타임딜 하루 1번 오픈\",\"title3\":\"놓치지마세요!\","
					+ "\"ftrText\":\"상세보기(44)\",\"ftrMblUrl\":\"http://m.11st.co.kr/MW/MyPage/V1/benefitCouponDownList.tmall\",\"ftrWebUrl\":\"http://11st.co.kr\","
					+ "\"arrImg\":["
					+ "{\"imgUrl\":\"http://i.011st.com/ui_img/11talk/img_500_500_sample1.png\"},"
					+ "{\"imgUrl\":\"http://i.011st.com/ui_img/11talk/img_500_500_sample2.png\"},"
					+ "{\"imgUrl\":\"http://i.011st.com/ui_img/11talk/img_500_500_sample1.png\"},"
					+ "{\"imgUrl\":\"http://i.011st.com/ui_img/11talk/img_500_500_sample2.png\"},"
					+ "{\"imgUrl\":\"http://i.011st.com/ui_img/11talk/img_500_500_sample1.png\"}"
					+ "]}";
		}
		
		if (flag) {
			mapParams = gson.fromJson(jsonParams, new TypeToken<Map<String, Object>>(){}.getType());
			if (flag) {
				System.out.println("----- mapParams -----");
				System.out.println("alimiText: " + mapParams.get("alimiText"));
				System.out.println("title1: " + mapParams.get("title1"));
				System.out.println("arrImg: " + mapParams.get("arrImg"));
				for (Map<String, Object> map : (List<Map<String, Object>>) mapParams.get("arrImg")) {
					System.out.println(">>>>> " + map);
				}
			}
		}
		
		if (flag) {
			List<BlockImg500.Value> listImg = new ArrayList<>();
			for (Map<String, Object> map : (List<Map<String, Object>>) mapParams.get("arrImg")) {
				listImg.add(new BlockImg500.Value((String) map.get("imgUrl")));
			}
			composites = Lists.newArrayList(
					new BlockTopCap(new BlockTopCap.Value((String) mapParams.get("title1"), (String) mapParams.get("advText")))
					, new BlockBoldText(new BlockBoldText.Value((String) mapParams.get("title2") + seq, (String) mapParams.get("title3") + seq))
					, new BlockImg500(listImg)
					, new BlockBtnView(new BlockBtnView.Value((String) mapParams.get("ftrText"), new BlockLinkUrl((String) mapParams.get("ftrMblUrl"), (String) mapParams.get("ftrWebUrl"))))
			);
			if (flag) {
				System.out.println("----- composites -----");
				System.out.println(">>>>> " + composites);
				System.out.println(">>>>> " + new GsonBuilder().setPrettyPrinting().create().toJson(composites));
			}
		}
		
		if (!flag) {
			// environment
			System.setProperty("server.type", "real");
			
			// 알림톡 템플릿에 등록한 메시지 타입코드 or "002"
			String talkMsgTempNo = "001";
			
			// 발송대상 앱코드
			AppKdCdType appKdCd = AppKdCdType.ELEVENSTAPP;
			
			// 푸시메시지
			JsonObject obj = new JsonObject();
			obj.addProperty("IOS_MSG", "아이폰 메시지~개인화테스트입니다~"+seq+"번째(포맷유지)");
			obj.addProperty("AND_TOP_MSG", "안드로이드 메시지~~개인화테스트입니다~"+seq+"번째(포맷변경)");
			obj.addProperty("AND_BTM_MSG", "안드로이드 메시지~~개인화테스트입니다~"+seq+"번째(포맷변경)");
			if (flag) {
				System.out.println(">>>>> " + obj.toString());
			}
			
			// Url
			String detailUrl = "http://m.11st.co.kr/MW/TData/dataFree.tmall";
			String bannerUrl = "http://m.11st.co.kr";
			String etcSasData = "{ \"campaigncode\":\"CAMP00000\", \"treatmentcode\":\"TR00000\" }";
			Map<String,String> mapEtcSasData = gson.fromJson(etcSasData, new TypeToken<Map<String, Object>>(){}.getType());
			String summary = "주문 알림톡입니다.("+seq+")";  // 알림톡방 리스트에 노출 할 메시지
			
			/////////////////////////////////////////
			// 알림톡 인자 세팅
			PushTalkParameter pushTalkParam = new PushTalkParameter(talkMsgTempNo, memberNo);
			pushTalkParam.setAppKdCd(appKdCd);             // 발송대상 앱코드
			//pushTalkParam.setMsgGrpNo(1235L);              // 메시지 식별 그룹번호. 없을경우 생략가능
			pushTalkParam.setPushIosMessage(obj.toString());     // JSON (?)
			pushTalkParam.setPushTopMessage(obj.toString());     // JSON (?)
			pushTalkParam.setPushBottomMessage(obj.toString());  // JSON (?)
			//pushTalkParam.setPushIosMessage(obj.get("IOS_MSG").getAsString());         // IOS message
			//pushTalkParam.setPushTopMessage(obj.get("AND_TOP_MSG").getAsString());     // Android Top message
			//pushTalkParam.setPushBottomMessage(obj.get("AND_BTM_MSG").getAsString());  // Android Bottom message
			pushTalkParam.setTalkDispYn("Y");              // 고정 처리 (Y) 알림-혜택톡방 동시 사용함
			pushTalkParam.setDetailUrl(detailUrl);         // 일반푸시 사용시- 클릭URL
			pushTalkParam.setBannerUrl(bannerUrl);         // 푸시배너이미지. 없을경우 생략가능
			pushTalkParam.setEtcData(mapEtcSasData);       // 기타 데이타 SAS에서 사용
			pushTalkParam.setTalkSummaryMessage(summary);  // 알림톡방 리스트에 노출 할 메시지
			pushTalkParam.setTalkMessage(composites);      // data from DB Table CM_CAMPAIGN_CHANNEL_JS
			pushTalkParam.setSendAllwBgnDt(new Date());    // 예약발송시 설정.
			// SMS 셋팅 http://wiki.11stcorp.com/pages/viewpage.action?pageId=214088691
			//pushTalkParam.setSmsMsg("SMS 스펙에 해당하는 데이터 작성");
			// 테스트 데이터 셋팅, 운영모드 일 경우 Remarking
			if (flag) {
				System.out.println(">>>>> " + pushTalkParam);
			}
			
			try {
				//알림톡 전송
				int ret = -1;
				if (flag) ret = PushTalkSendService.INSTANCE.remoteSyncPush(Lists.newArrayList(pushTalkParam));
				System.out.println("ret = " + ret);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	@SuppressWarnings("unchecked")
	private static void test02() {
		Gson gson = new Gson();
		String jsonParams = null;
		Map<String, Object> mapParams = null;
		Map<String, Object> mapImg = null;
		List<Block> composites = null;
		int seq = 200 + SEQ;
		
		if (flag) {
			// Type 2
			jsonParams = "{\"alimiShow\":\"N\",\"alimiText\":\"a\",\"alimiType\":\"002\","
					+ "\"title1\":\"패션워크\",\"advText\":\"광고\",\"title2\":\"반값 타임딜 하루 4번 오픈\",\"title3\":\"놓치지마세요!\","
					+ "\"ftrText\":\"상세보기(1)\",\"ftrMblUrl\":\"http://m.11st.co.kr/MW/MyPage/V1/benefitCouponDownList.tmall\",\"ftrWebUrl\":\"http://11st.co.kr\","
					+ "\"arrImg\":["
					+ "{\"imgUrl\":\"http://i.011st.com/ui_img/11talk/img_500_240_sample1.png\"}"
					+ "],"
					+ "\"arrPrd\":["
					+ "{\"prdUrl\":\"http://i.011st.com/ui_img/11talk/Product_Price_img_small1.jpg\",\"prdName\":\"임시상품-1\",\"prdPrice\":\"10,000\",\"prdUnit\":\"원\",\"prdMblUrl\":\"http://i.011st.com/ui_img/11talk/img_500_250_sample2.png\",\"prdWebUrl\":\"\"},"
					+ "{\"prdUrl\":\"http://i.011st.com/ui_img/11talk/Product_Price_img_small2.jpg\",\"prdName\":\"임시상품-2\",\"prdPrice\":\"20,000\",\"prdUnit\":\"원\",\"prdMblUrl\":\"http://i.011st.com/ui_img/11talk/img_500_250_sample2.png\",\"prdWebUrl\":\"\"},"
					+ "{\"prdUrl\":\"http://i.011st.com/ui_img/11talk/Product_Price_img_small3.jpg\",\"prdName\":\"임시상품-3\",\"prdPrice\":\"30,000\",\"prdUnit\":\"원\",\"prdMblUrl\":\"http://i.011st.com/ui_img/11talk/img_500_250_sample2.png\",\"prdWebUrl\":\"\"}"
					+ "]}";
		}
		
		if (flag) {
			mapParams = gson.fromJson(jsonParams, new TypeToken<Map<String, Object>>(){}.getType());
			if (flag) {
				System.out.println("----- mapParams -----");
				System.out.println("alimiText: " + mapParams.get("alimiText"));
				System.out.println("title1: " + mapParams.get("title1"));
				System.out.println("arrImg: " + mapParams.get("arrImg"));
				for (Map<String, Object> map : (List<Map<String, Object>>) mapParams.get("arrImg")) {
					System.out.println(">>>>> " + map);
				}
				for (Map<String, Object> map : (List<Map<String, Object>>) mapParams.get("arrPrd")) {
					System.out.println(">>>>> " + map);
				}
			}
			mapImg = ((List<Map<String, Object>>) mapParams.get("arrImg")).get(0);
		}
		
		if (flag) {
			List<BlockProductPrice.Value> listProduct = new ArrayList<>();
			for (Map<String, Object> map : (List<Map<String, Object>>) mapParams.get("arrPrd")) {
				listProduct.add(new BlockProductPrice.Value(
						(String) map.get("prdUrl"), 
						(String) map.get("prdName"), 
						(String) map.get("prdPrice"), 
						(String) map.get("prdUnit"), 
						new BlockLinkUrl((String) map.get("prdMblUrl"), 
								(String) map.get("prdWebUrl"))
						));
			}
			
			composites = Lists.newArrayList(
					new BlockTopCap(new BlockTopCap.Value((String) mapParams.get("title1"), (String) mapParams.get("advText")))
					, new BlockBoldText(new BlockBoldText.Value((String) mapParams.get("title2") + seq, (String) mapParams.get("title3") + seq))
					, new BlockImg240(new BlockImg240.Value((String)mapImg.get("imgUrl")))
					, new BlockProductPrice(listProduct)
					, new BlockBtnView(new BlockBtnView.Value((String) mapParams.get("ftrText"), new BlockLinkUrl((String) mapParams.get("ftrMblUrl"), (String) mapParams.get("ftrWebUrl"))))
			);
			if (flag) {
				System.out.println("----- composites -----");
				System.out.println(">>>>> " + composites);
				System.out.println(">>>>> " + new GsonBuilder().setPrettyPrinting().create().toJson(composites));
			}
		}
		
		if (!flag) {
			// environment
			System.setProperty("server.type", "real");
			
			// 알림톡 템플릿에 등록한 메시지 타입코드 or "002"
			String talkMsgTempNo = "001";
			
			// 발송대상 앱코드
			AppKdCdType appKdCd = AppKdCdType.ELEVENSTAPP;
			
			// 푸시메시지
			JsonObject obj = new JsonObject();
			obj.addProperty("IOS_MSG", "아이폰 메시지~개인화테스트입니다~"+seq+"번째(포맷유지)");
			obj.addProperty("AND_TOP_MSG", "안드로이드 메시지~~개인화테스트입니다~"+seq+"번째(포맷변경)");
			obj.addProperty("AND_BTM_MSG", "안드로이드 메시지~~개인화테스트입니다~"+seq+"번째(포맷변경)");
			if (flag) {
				System.out.println(">>>>> " + obj.toString());
			}
			
			// Url
			String detailUrl = "http://m.11st.co.kr/MW/TData/dataFree.tmall";
			String bannerUrl = "http://m.11st.co.kr";
			String etcSasData = "{ \"campaigncode\":\"CAMP00000\", \"treatmentcode\":\"TR00000\" }";
			Map<String,String> mapEtcSasData = gson.fromJson(etcSasData, new TypeToken<Map<String, Object>>(){}.getType());
			String summary = "주문 알림톡입니다.("+seq+")";  // 알림톡방 리스트에 노출 할 메시지
			
			/////////////////////////////////////////
			// 알림톡 인자 세팅
			PushTalkParameter pushTalkParam = new PushTalkParameter(talkMsgTempNo, memberNo);
			pushTalkParam.setAppKdCd(appKdCd);             // 발송대상 앱코드
			//pushTalkParam.setMsgGrpNo(1235L);              // 메시지 식별 그룹번호. 없을경우 생략가능
			pushTalkParam.setPushIosMessage(obj.toString());     // JSON (?)
			pushTalkParam.setPushTopMessage(obj.toString());     // JSON (?)
			pushTalkParam.setPushBottomMessage(obj.toString());  // JSON (?)
			//pushTalkParam.setPushIosMessage(obj.get("IOS_MSG").getAsString());         // IOS message
			//pushTalkParam.setPushTopMessage(obj.get("AND_TOP_MSG").getAsString());     // Android Top message
			//pushTalkParam.setPushBottomMessage(obj.get("AND_BTM_MSG").getAsString());  // Android Bottom message
			pushTalkParam.setTalkDispYn("Y");              // 고정 처리 (Y) 알림-혜택톡방 동시 사용함
			pushTalkParam.setDetailUrl(detailUrl);         // 일반푸시 사용시- 클릭URL
			pushTalkParam.setBannerUrl(bannerUrl);         // 푸시배너이미지. 없을경우 생략가능
			pushTalkParam.setEtcData(mapEtcSasData);       // 기타 데이타 SAS에서 사용
			pushTalkParam.setTalkSummaryMessage(summary);  // 알림톡방 리스트에 노출 할 메시지
			pushTalkParam.setTalkMessage(composites);      // data from DB Table CM_CAMPAIGN_CHANNEL_JS
			pushTalkParam.setSendAllwBgnDt(new Date());    // 예약발송시 설정.
			// SMS 셋팅 http://wiki.11stcorp.com/pages/viewpage.action?pageId=214088691
			//pushTalkParam.setSmsMsg("SMS 스펙에 해당하는 데이터 작성");
			// 테스트 데이터 셋팅, 운영모드 일 경우 Remarking
			if (flag) {
				System.out.println(">>>>> " + pushTalkParam);
			}
			
			try {
				//알림톡 전송
				int ret = -1;
				if (flag) ret = PushTalkSendService.INSTANCE.remoteSyncPush(Lists.newArrayList(pushTalkParam));
				System.out.println("ret = " + ret);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	@SuppressWarnings("unchecked")
	private static void test03() {
		Gson gson = new Gson();
		String jsonParams = null;
		Map<String, Object> mapParams = null;
		Map<String, Object> mapImg = null;
		List<Block> composites = null;
		int seq = 300 + SEQ;
		
		if (flag) {
			// Type 3
			jsonParams = "{\"alimiShow\":\"N\",\"alimiText\":\"a\",\"alimiType\":\"003\","
					+ "\"title1\":\"패션워크\",\"advText\":\"광고\",\"title2\":\"반값 타임딜 하루 4번 오픈\",\"title3\":\"놓치지마세요!\","
					+ "\"ftrText\":\"상세보기(1)\",\"ftrMblUrl\":\"http://m.11st.co.kr/MW/MyPage/V1/benefitCouponDownList.tmall\",\"ftrWebUrl\":\"http://11st.co.kr\","
					+ "\"arrImg\":["
					+ "{\"imgUrl\":\"http://i.011st.com/ui_img/11talk/img_500_240_sample1.png\"}"
					+ "],"
					+ "\"arrCpn\":["
					+ "{\"cpnText1\":\"30%, 2,500(1)\",\"cpnText2\":\"5월 VVIP구매등급 쿠폰\",\"cpnText3\":\"3,000원이상 구매 최대 2,500원 이벤트&기획전 쿠폰\",\"cpnText4\":\"2019.04.01 ~ 2019.04.30\",\"cpnNumber\":\"1234567891\",\"cpnVisible\":\"show\"},"
					+ "{\"cpnText1\":\"30%, 2,500(2)\",\"cpnText2\":\"5월 VVIP구매등급 쿠폰\",\"cpnText3\":\"3,000원이상 구매 최대 2,500원 이벤트&기획전 쿠폰\",\"cpnText4\":\"2019.04.01 ~ 2019.04.30\",\"cpnNumber\":\"1234567892\",\"cpnVisible\":\"hide\"},"
					+ "{\"cpnText1\":\"30%, 2,500(3)\",\"cpnText2\":\"5월 VVIP구매등급 쿠폰\",\"cpnText3\":\"3,000원이상 구매 최대 2,500원 이벤트&기획전 쿠폰\",\"cpnText4\":\"2019.04.01 ~ 2019.04.30\",\"cpnNumber\":\"1234567893\",\"cpnVisible\":\"show\"},"
					+ "{\"cpnText1\":\"30%, 2,500(4)\",\"cpnText2\":\"5월 VVIP구매등급 쿠폰\",\"cpnText3\":\"3,000원이상 구매 최대 2,500원 이벤트&기획전 쿠폰\",\"cpnText4\":\"2019.04.01 ~ 2019.04.30\",\"cpnNumber\":\"1234567894\",\"cpnVisible\":\"hide\"},"
					+ "{\"cpnText1\":\"30%, 2,500(5)\",\"cpnText2\":\"5월 VVIP구매등급 쿠폰\",\"cpnText3\":\"3,000원이상 구매 최대 2,500원 이벤트&기획전 쿠폰\",\"cpnText4\":\"2019.04.01 ~ 2019.04.30\",\"cpnNumber\":\"1234567895\",\"cpnVisible\":\"show\"},"
					+ "{\"cpnText1\":\"30%, 2,500(6)\",\"cpnText2\":\"5월 VVIP구매등급 쿠폰\",\"cpnText3\":\"3,000원이상 구매 최대 2,500원 이벤트&기획전 쿠폰\",\"cpnText4\":\"2019.04.01 ~ 2019.04.30\",\"cpnNumber\":\"1234567896\",\"cpnVisible\":\"hide\"}"
					+ "]}";
		}
		
		if (flag) {
			mapParams = gson.fromJson(jsonParams, new TypeToken<Map<String, Object>>(){}.getType());
			if (flag) {
				System.out.println("----- mapParams -----");
				System.out.println("alimiText: " + mapParams.get("alimiText"));
				System.out.println("title1: " + mapParams.get("title1"));
				System.out.println("arrImg: " + mapParams.get("arrImg"));
				for (Map<String, Object> map : (List<Map<String, Object>>) mapParams.get("arrImg")) {
					System.out.println(">>>>> " + map);
				}
				for (Map<String, Object> map : (List<Map<String, Object>>) mapParams.get("arrCpn")) {
					System.out.println(">>>>> " + map);
				}
			}
			mapImg = ((List<Map<String, Object>>) mapParams.get("arrImg")).get(0);
		}
		
		if (flag) {
			List<BlockCouponText.Value> listCoupon = new ArrayList<>();
			for (Map<String, Object> map : (List<Map<String, Object>>) mapParams.get("arrCpn")) {
				System.out.println(">>>>> " + map);
				listCoupon.add(new BlockCouponText.Value(
						/* couponNo, couponText, title1, sub_text1, sub_text2, true */
						(String) map.get("cpnNumber"),
						(String) map.get("cpnText1"),
						(String) map.get("cpnText2"),
						(String) map.get("cpnText3"),
						(String) map.get("cpnText4"),
						"show".equals((String) map.get("cpnVisible")) ? true : false
						));
			}
			
			composites = Lists.newArrayList(
					new BlockTopCap(new BlockTopCap.Value((String) mapParams.get("title1"), (String) mapParams.get("advText")))
					, new BlockBoldText(new BlockBoldText.Value((String) mapParams.get("title2") + seq, (String) mapParams.get("title3") + seq))
					, new BlockImg240(new BlockImg240.Value((String) mapImg.get("imgUrl")))
					, new BlockCouponText(listCoupon)
					, new BlockBtnView(new BlockBtnView.Value((String) mapParams.get("ftrText"), new BlockLinkUrl((String) mapParams.get("ftrMblUrl"), (String) mapParams.get("ftrWebUrl"))))
			);
			if (flag) {
				System.out.println("----- composites -----");
				System.out.println(">>>>> " + composites);
				System.out.println(">>>>> " + new GsonBuilder().setPrettyPrinting().create().toJson(composites));
			}
		}
		
		if (!flag) {
			// environment
			System.setProperty("server.type", "real");
			
			// 알림톡 템플릿에 등록한 메시지 타입코드 or "002"
			String talkMsgTempNo = "001";
			
			// 발송대상 앱코드
			AppKdCdType appKdCd = AppKdCdType.ELEVENSTAPP;
			
			// 푸시메시지
			JsonObject obj = new JsonObject();
			obj.addProperty("IOS_MSG", "아이폰 메시지~개인화테스트입니다~"+seq+"번째(포맷유지)");
			obj.addProperty("AND_TOP_MSG", "안드로이드 메시지~~개인화테스트입니다~"+seq+"번째(포맷변경)");
			obj.addProperty("AND_BTM_MSG", "안드로이드 메시지~~개인화테스트입니다~"+seq+"번째(포맷변경)");
			if (flag) {
				System.out.println(">>>>> " + obj.toString());
			}
			
			// Url
			String detailUrl = "http://m.11st.co.kr/MW/TData/dataFree.tmall";
			String bannerUrl = "http://m.11st.co.kr";
			String etcSasData = "{ \"campaigncode\":\"CAMP00000\", \"treatmentcode\":\"TR00000\" }";
			Map<String,String> mapEtcSasData = gson.fromJson(etcSasData, new TypeToken<Map<String, Object>>(){}.getType());
			String summary = "주문 알림톡입니다.("+seq+")";  // 알림톡방 리스트에 노출 할 메시지
			
			/////////////////////////////////////////
			// 알림톡 인자 세팅
			PushTalkParameter pushTalkParam = new PushTalkParameter(talkMsgTempNo, memberNo);
			pushTalkParam.setAppKdCd(appKdCd);             // 발송대상 앱코드
			//pushTalkParam.setMsgGrpNo(1235L);              // 메시지 식별 그룹번호. 없을경우 생략가능
			pushTalkParam.setPushIosMessage(obj.toString());     // JSON (?)
			pushTalkParam.setPushTopMessage(obj.toString());     // JSON (?)
			pushTalkParam.setPushBottomMessage(obj.toString());  // JSON (?)
			//pushTalkParam.setPushIosMessage(obj.get("IOS_MSG").getAsString());         // IOS message
			//pushTalkParam.setPushTopMessage(obj.get("AND_TOP_MSG").getAsString());     // Android Top message
			//pushTalkParam.setPushBottomMessage(obj.get("AND_BTM_MSG").getAsString());  // Android Bottom message
			pushTalkParam.setTalkDispYn("Y");              // 고정 처리 (Y) 알림-혜택톡방 동시 사용함
			pushTalkParam.setDetailUrl(detailUrl);         // 일반푸시 사용시- 클릭URL
			pushTalkParam.setBannerUrl(bannerUrl);         // 푸시배너이미지. 없을경우 생략가능
			pushTalkParam.setEtcData(mapEtcSasData);       // 기타 데이타 SAS에서 사용
			pushTalkParam.setTalkSummaryMessage(summary);  // 알림톡방 리스트에 노출 할 메시지
			pushTalkParam.setTalkMessage(composites);      // data from DB Table CM_CAMPAIGN_CHANNEL_JS
			pushTalkParam.setSendAllwBgnDt(new Date());    // 예약발송시 설정.
			// SMS 셋팅 http://wiki.11stcorp.com/pages/viewpage.action?pageId=214088691
			//pushTalkParam.setSmsMsg("SMS 스펙에 해당하는 데이터 작성");
			// 테스트 데이터 셋팅, 운영모드 일 경우 Remarking
			if (flag) {
				System.out.println(">>>>> " + pushTalkParam);
			}
			
			try {
				//알림톡 전송
				int ret = -1;
				if (flag) ret = PushTalkSendService.INSTANCE.remoteSyncPush(Lists.newArrayList(pushTalkParam));
				System.out.println("ret = " + ret);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	@SuppressWarnings("unchecked")
	private static void test04() {
		Gson gson = new Gson();
		String jsonParams = null;
		Map<String, Object> mapParams = null;
		Map<String, Object> mapAnn = null;
		List<Block> composites = null;
		int seq = 400 + SEQ;
		
		if (flag) {
			// Type 4
			jsonParams = "{\"alimiShow\":\"N\",\"alimiText\":\"a\",\"alimiType\":\"004\","
					+ "\"title1\":\"패션워크\",\"advText\":\"광고\",\"title2\":\"반값 타임딜 하루 4번 오픈\",\"title3\":\"놓치지마세요!\","
					+ "\"ftrText\":\"상세보기(1)\",\"ftrMblUrl\":\"http://m.11st.co.kr/MW/MyPage/V1/benefitCouponDownList.tmall\",\"ftrWebUrl\":\"http://11st.co.kr\","
					+ "\"arrAnn\":["
					+ "{\"annText\":\"직영몰 상품의 주문량이 많아 배송이 늦어질 수 있습니다.\",\"annFixed\":\"center\"}"
					+ "]}";
		}
		
		if (flag) {
			mapParams = gson.fromJson(jsonParams, new TypeToken<Map<String, Object>>(){}.getType());
			if (flag) {
				System.out.println("----- mapParams -----");
				System.out.println("alimiText: " + mapParams.get("alimiText"));
				System.out.println("title1: " + mapParams.get("title1"));
				for (Map<String, Object> map : (List<Map<String, Object>>) mapParams.get("arrAnn")) {
					System.out.println(">>>>> " + map);
				}
			}
			mapAnn = ((List<Map<String, Object>>) mapParams.get("arrAnn")).get(0);
		}
		
		if (flag) {
			composites = Lists.newArrayList(
					new BlockTopCap(new BlockTopCap.Value((String) mapParams.get("title1"), (String) mapParams.get("advText")))
					, new BlockBoldText(new BlockBoldText.Value((String) mapParams.get("title2") + seq, (String) mapParams.get("title3") + seq))
					, new BlockSubText(new BlockSubText.Value((String)mapAnn.get("annText"), BlockSubTextAlignType.CENTER))
					, new BlockBtnView(new BlockBtnView.Value((String) mapParams.get("ftrText"), new BlockLinkUrl((String) mapParams.get("ftrMblUrl"), (String) mapParams.get("ftrWebUrl"))))
			);
			if (flag) {
				System.out.println("----- composites -----");
				System.out.println(">>>>> " + composites);
				System.out.println(">>>>> " + new GsonBuilder().setPrettyPrinting().create().toJson(composites));
			}
		}
		
		if (!flag) {
			// environment
			System.setProperty("server.type", "real");
			
			// 알림톡 템플릿에 등록한 메시지 타입코드 or "002"
			String talkMsgTempNo = "001";
			
			// 발송대상 앱코드
			AppKdCdType appKdCd = AppKdCdType.ELEVENSTAPP;
			
			// 푸시메시지
			JsonObject obj = new JsonObject();
			obj.addProperty("IOS_MSG", "아이폰 메시지~개인화테스트입니다~"+seq+"번째(포맷유지)");
			obj.addProperty("AND_TOP_MSG", "안드로이드 메시지~~개인화테스트입니다~"+seq+"번째(포맷변경)");
			obj.addProperty("AND_BTM_MSG", "안드로이드 메시지~~개인화테스트입니다~"+seq+"번째(포맷변경)");
			if (flag) {
				System.out.println(">>>>> " + obj.toString());
			}
			
			// Url
			String detailUrl = "http://m.11st.co.kr/MW/TData/dataFree.tmall";
			String bannerUrl = "http://m.11st.co.kr";
			String etcSasData = "{ \"campaigncode\":\"CAMP00000\", \"treatmentcode\":\"TR00000\" }";
			Map<String,String> mapEtcSasData = gson.fromJson(etcSasData, new TypeToken<Map<String, Object>>(){}.getType());
			String summary = "주문 알림톡입니다.("+seq+")";  // 알림톡방 리스트에 노출 할 메시지
			
			/////////////////////////////////////////
			// 알림톡 인자 세팅
			PushTalkParameter pushTalkParam = new PushTalkParameter(talkMsgTempNo, memberNo);
			pushTalkParam.setAppKdCd(appKdCd);             // 발송대상 앱코드
			//pushTalkParam.setMsgGrpNo(1235L);              // 메시지 식별 그룹번호. 없을경우 생략가능
			pushTalkParam.setPushIosMessage(obj.toString());     // JSON (?)
			pushTalkParam.setPushTopMessage(obj.toString());     // JSON (?)
			pushTalkParam.setPushBottomMessage(obj.toString());  // JSON (?)
			//pushTalkParam.setPushIosMessage(obj.get("IOS_MSG").getAsString());         // IOS message
			//pushTalkParam.setPushTopMessage(obj.get("AND_TOP_MSG").getAsString());     // Android Top message
			//pushTalkParam.setPushBottomMessage(obj.get("AND_BTM_MSG").getAsString());  // Android Bottom message
			pushTalkParam.setTalkDispYn("Y");              // 고정 처리 (Y) 알림-혜택톡방 동시 사용함
			pushTalkParam.setDetailUrl(detailUrl);         // 일반푸시 사용시- 클릭URL
			pushTalkParam.setBannerUrl(bannerUrl);         // 푸시배너이미지. 없을경우 생략가능
			pushTalkParam.setEtcData(mapEtcSasData);       // 기타 데이타 SAS에서 사용
			pushTalkParam.setTalkSummaryMessage(summary);  // 알림톡방 리스트에 노출 할 메시지
			pushTalkParam.setTalkMessage(composites);      // data from DB Table CM_CAMPAIGN_CHANNEL_JS
			pushTalkParam.setSendAllwBgnDt(new Date());    // 예약발송시 설정.
			// SMS 셋팅 http://wiki.11stcorp.com/pages/viewpage.action?pageId=214088691
			//pushTalkParam.setSmsMsg("SMS 스펙에 해당하는 데이터 작성");
			// 테스트 데이터 셋팅, 운영모드 일 경우 Remarking
			if (flag) {
				System.out.println(">>>>> " + pushTalkParam);
			}
			
			try {
				//알림톡 전송
				int ret = -1;
				if (flag) ret = PushTalkSendService.INSTANCE.remoteSyncPush(Lists.newArrayList(pushTalkParam));
				System.out.println("ret = " + ret);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}	
	@SuppressWarnings("unchecked")
	private static void test05() {
		Gson gson = new Gson();
		String jsonParams = null;
		Map<String, Object> mapParams = null;
		List<Block> composites = null;
		int seq = 500 + SEQ;
		
		if (flag) {
			// Type 2
			jsonParams = "{\"alimiShow\":\"N\",\"alimiText\":\"a\",\"alimiType\":\"002\","
					+ "\"title1\":\"패션워크\",\"advText\":\"광고\",\"title2\":\"반값 타임딜 하루 4번 오픈\",\"title3\":\"놓치지마세요!\","
					+ "\"ftrText\":\"상세보기(1)\",\"ftrMblUrl\":\"http://m.11st.co.kr/MW/MyPage/V1/benefitCouponDownList.tmall\",\"ftrWebUrl\":\"http://11st.co.kr\","
					+ "\"arrPrd\":["
					+ "{\"prdUrl\":\"http://i.011st.com/ui_img/11talk/Product_Price_img_big1.jpg\",\"prdName\":\"임시상품-1\",\"prdPrice\":\"10,000\",\"prdUnit\":\"원\",\"prdMblUrl\":\"http://i.011st.com/ui_img/11talk/img_500_250_sample2.png\",\"prdWebUrl\":\"\"},"
					+ "{\"prdUrl\":\"http://i.011st.com/ui_img/11talk/Product_Price_img_big2.jpg\",\"prdName\":\"임시상품-2\",\"prdPrice\":\"20,000\",\"prdUnit\":\"원\",\"prdMblUrl\":\"http://i.011st.com/ui_img/11talk/img_500_250_sample2.png\",\"prdWebUrl\":\"\"},"
					+ "{\"prdUrl\":\"http://i.011st.com/ui_img/11talk/Product_Price_img_big3.jpg\",\"prdName\":\"임시상품-3\",\"prdPrice\":\"30,000\",\"prdUnit\":\"원\",\"prdMblUrl\":\"http://i.011st.com/ui_img/11talk/img_500_250_sample2.png\",\"prdWebUrl\":\"\"},"
					+ "{\"prdUrl\":\"http://i.011st.com/ui_img/11talk/Product_Price_img_big1.jpg\",\"prdName\":\"임시상품-4\",\"prdPrice\":\"40,000\",\"prdUnit\":\"원\",\"prdMblUrl\":\"http://i.011st.com/ui_img/11talk/img_500_250_sample2.png\",\"prdWebUrl\":\"\"},"
					+ "{\"prdUrl\":\"http://i.011st.com/ui_img/11talk/Product_Price_img_big2.jpg\",\"prdName\":\"임시상품-5\",\"prdPrice\":\"50,000\",\"prdUnit\":\"원\",\"prdMblUrl\":\"http://i.011st.com/ui_img/11talk/img_500_250_sample2.png\",\"prdWebUrl\":\"\"},"
					+ "{\"prdUrl\":\"http://i.011st.com/ui_img/11talk/Product_Price_img_big3.jpg\",\"prdName\":\"임시상품-6\",\"prdPrice\":\"60,000\",\"prdUnit\":\"원\",\"prdMblUrl\":\"http://i.011st.com/ui_img/11talk/img_500_250_sample2.png\",\"prdWebUrl\":\"\"}"
					+ "]}";
		}
		
		if (flag) {
			mapParams = gson.fromJson(jsonParams, new TypeToken<Map<String, Object>>(){}.getType());
			if (flag) {
				System.out.println("----- mapParams -----");
				System.out.println("alimiText: " + mapParams.get("alimiText"));
				System.out.println("title1: " + mapParams.get("title1"));
				System.out.println("arrImg: " + mapParams.get("arrImg"));
				for (Map<String, Object> map : (List<Map<String, Object>>) mapParams.get("arrPrd")) {
					System.out.println(">>>>> " + map);
				}
			}
		}
		
		if (flag) {
			List<BlockProductPrice.Value> listProduct = new ArrayList<>();
			for (Map<String, Object> map : (List<Map<String, Object>>) mapParams.get("arrPrd")) {
				listProduct.add(new BlockProductPrice.Value(
						(String) map.get("prdUrl"), 
						(String) map.get("prdName"), 
						(String) map.get("prdPrice"), 
						(String) map.get("prdUnit"), 
						new BlockLinkUrl((String) map.get("prdMblUrl"), 
								(String) map.get("prdWebUrl"))
						));
			}
			
			composites = Lists.newArrayList(
					new BlockTopCap(new BlockTopCap.Value((String) mapParams.get("title1"), (String) mapParams.get("advText")))
					, new BlockBoldText(new BlockBoldText.Value((String) mapParams.get("title2") + seq, (String) mapParams.get("title3") + seq))
					, new BlockProductPrice(listProduct)
					, new BlockBtnView(new BlockBtnView.Value((String) mapParams.get("ftrText"), new BlockLinkUrl((String) mapParams.get("ftrMblUrl"), (String) mapParams.get("ftrWebUrl"))))
			);
			if (flag) {
				System.out.println("----- composites -----");
				System.out.println(">>>>> " + composites);
				System.out.println(">>>>> " + new GsonBuilder().setPrettyPrinting().create().toJson(composites));
			}
		}
		
		if (!flag) {
			// environment
			System.setProperty("server.type", "real");
			
			// 알림톡 템플릿에 등록한 메시지 타입코드 or "002"
			String talkMsgTempNo = "001";
			
			// 발송대상 앱코드
			AppKdCdType appKdCd = AppKdCdType.ELEVENSTAPP;
			
			// 푸시메시지
			JsonObject obj = new JsonObject();
			obj.addProperty("IOS_MSG", "아이폰 메시지~개인화테스트입니다~"+seq+"번째(포맷유지)");
			obj.addProperty("AND_TOP_MSG", "안드로이드 메시지~~개인화테스트입니다~"+seq+"번째(포맷변경)");
			obj.addProperty("AND_BTM_MSG", "안드로이드 메시지~~개인화테스트입니다~"+seq+"번째(포맷변경)");
			if (flag) {
				System.out.println(">>>>> " + obj.toString());
			}
			
			// Url
			String detailUrl = "http://m.11st.co.kr/MW/TData/dataFree.tmall";
			String bannerUrl = "http://m.11st.co.kr";
			String etcSasData = "{ \"campaigncode\":\"CAMP00000\", \"treatmentcode\":\"TR00000\" }";
			Map<String,String> mapEtcSasData = gson.fromJson(etcSasData, new TypeToken<Map<String, Object>>(){}.getType());
			String summary = "주문 알림톡입니다.("+seq+")";  // 알림톡방 리스트에 노출 할 메시지
			
			/////////////////////////////////////////
			// 알림톡 인자 세팅
			PushTalkParameter pushTalkParam = new PushTalkParameter(talkMsgTempNo, memberNo);
			pushTalkParam.setAppKdCd(appKdCd);             // 발송대상 앱코드
			//pushTalkParam.setMsgGrpNo(1235L);              // 메시지 식별 그룹번호. 없을경우 생략가능
			pushTalkParam.setPushIosMessage(obj.toString());     // JSON (?)
			pushTalkParam.setPushTopMessage(obj.toString());     // JSON (?)
			pushTalkParam.setPushBottomMessage(obj.toString());  // JSON (?)
			//pushTalkParam.setPushIosMessage(obj.get("IOS_MSG").getAsString());         // IOS message
			//pushTalkParam.setPushTopMessage(obj.get("AND_TOP_MSG").getAsString());     // Android Top message
			//pushTalkParam.setPushBottomMessage(obj.get("AND_BTM_MSG").getAsString());  // Android Bottom message
			pushTalkParam.setTalkDispYn("Y");              // 고정 처리 (Y) 알림-혜택톡방 동시 사용함
			pushTalkParam.setDetailUrl(detailUrl);         // 일반푸시 사용시- 클릭URL
			pushTalkParam.setBannerUrl(bannerUrl);         // 푸시배너이미지. 없을경우 생략가능
			pushTalkParam.setEtcData(mapEtcSasData);       // 기타 데이타 SAS에서 사용
			pushTalkParam.setTalkSummaryMessage(summary);  // 알림톡방 리스트에 노출 할 메시지
			pushTalkParam.setTalkMessage(composites);      // data from DB Table CM_CAMPAIGN_CHANNEL_JS
			pushTalkParam.setSendAllwBgnDt(new Date());    // 예약발송시 설정.
			// SMS 셋팅 http://wiki.11stcorp.com/pages/viewpage.action?pageId=214088691
			//pushTalkParam.setSmsMsg("SMS 스펙에 해당하는 데이터 작성");
			// 테스트 데이터 셋팅, 운영모드 일 경우 Remarking
			if (flag) {
				System.out.println(">>>>> " + pushTalkParam);
			}
			
			try {
				//알림톡 전송
				int ret = -1;
				if (flag) ret = PushTalkSendService.INSTANCE.remoteSyncPush(Lists.newArrayList(pushTalkParam));
				System.out.println("ret = " + ret);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	@SuppressWarnings("unchecked")
	private static void test06() {
		Gson gson = new Gson();
		String jsonParams = null;
		Map<String, Object> mapParams = null;
		List<Block> composites = null;
		int seq = 600 + SEQ;
		
		if (flag) {
			// Type 3
			jsonParams = "{\"alimiShow\":\"N\",\"alimiText\":\"a\",\"alimiType\":\"003\","
					+ "\"title1\":\"패션워크\",\"advText\":\"광고\",\"title2\":\"반값 타임딜 하루 4번 오픈\",\"title3\":\"놓치지마세요!\","
					+ "\"ftrText\":\"상세보기(1)\",\"ftrMblUrl\":\"http://m.11st.co.kr/MW/MyPage/V1/benefitCouponDownList.tmall\",\"ftrWebUrl\":\"http://11st.co.kr\","
					+ "\"arrCpn\":["
					+ "{\"cpnText1\":\"30%, 2,500(1)\",\"cpnText2\":\"5월 VVIP구매등급 쿠폰\",\"cpnText3\":\"3,000원이상 구매 최대 2,500원 이벤트&기획전 쿠폰\",\"cpnText4\":\"2019.04.01 ~ 2019.04.30\",\"cpnNumber\":\"1234567891\",\"cpnVisible\":\"show\"},"
					+ "{\"cpnText1\":\"30%, 2,500(2)\",\"cpnText2\":\"5월 VVIP구매등급 쿠폰\",\"cpnText3\":\"3,000원이상 구매 최대 2,500원 이벤트&기획전 쿠폰\",\"cpnText4\":\"2019.04.01 ~ 2019.04.30\",\"cpnNumber\":\"1234567892\",\"cpnVisible\":\"hide\"},"
					+ "{\"cpnText1\":\"30%, 2,500(3)\",\"cpnText2\":\"5월 VVIP구매등급 쿠폰\",\"cpnText3\":\"3,000원이상 구매 최대 2,500원 이벤트&기획전 쿠폰\",\"cpnText4\":\"2019.04.01 ~ 2019.04.30\",\"cpnNumber\":\"1234567893\",\"cpnVisible\":\"show\"},"
					+ "{\"cpnText1\":\"30%, 2,500(4)\",\"cpnText2\":\"5월 VVIP구매등급 쿠폰\",\"cpnText3\":\"3,000원이상 구매 최대 2,500원 이벤트&기획전 쿠폰\",\"cpnText4\":\"2019.04.01 ~ 2019.04.30\",\"cpnNumber\":\"1234567894\",\"cpnVisible\":\"hide\"},"
					+ "{\"cpnText1\":\"30%, 2,500(5)\",\"cpnText2\":\"5월 VVIP구매등급 쿠폰\",\"cpnText3\":\"3,000원이상 구매 최대 2,500원 이벤트&기획전 쿠폰\",\"cpnText4\":\"2019.04.01 ~ 2019.04.30\",\"cpnNumber\":\"1234567895\",\"cpnVisible\":\"show\"},"
					+ "{\"cpnText1\":\"30%, 2,500(6)\",\"cpnText2\":\"5월 VVIP구매등급 쿠폰\",\"cpnText3\":\"3,000원이상 구매 최대 2,500원 이벤트&기획전 쿠폰\",\"cpnText4\":\"2019.04.01 ~ 2019.04.30\",\"cpnNumber\":\"1234567896\",\"cpnVisible\":\"hide\"}"
					+ "]}";
		}
		
		if (flag) {
			mapParams = gson.fromJson(jsonParams, new TypeToken<Map<String, Object>>(){}.getType());
			if (flag) {
				System.out.println("----- mapParams -----");
				System.out.println("alimiText: " + mapParams.get("alimiText"));
				System.out.println("title1: " + mapParams.get("title1"));
				System.out.println("arrImg: " + mapParams.get("arrImg"));
				for (Map<String, Object> map : (List<Map<String, Object>>) mapParams.get("arrCpn")) {
					System.out.println(">>>>> " + map);
				}
			}
		}
		
		if (flag) {
			List<BlockCouponText.Value> listCoupon = new ArrayList<>();
			for (Map<String, Object> map : (List<Map<String, Object>>) mapParams.get("arrCpn")) {
				System.out.println(">>>>> " + map);
				listCoupon.add(new BlockCouponText.Value(
						/* couponNo, couponText, title1, sub_text1, sub_text2, true */
						(String) map.get("cpnNumber"),
						(String) map.get("cpnText1"),
						(String) map.get("cpnText2"),
						(String) map.get("cpnText3"),
						(String) map.get("cpnText4"),
						"show".equals((String) map.get("cpnVisible")) ? true : false
						));
			}
			
			composites = Lists.newArrayList(
					new BlockTopCap(new BlockTopCap.Value((String) mapParams.get("title1"), (String) mapParams.get("advText")))
					, new BlockBoldText(new BlockBoldText.Value((String) mapParams.get("title2") + seq, (String) mapParams.get("title3") + seq))
					, new BlockCouponText(listCoupon)
					, new BlockBtnView(new BlockBtnView.Value((String) mapParams.get("ftrText"), new BlockLinkUrl((String) mapParams.get("ftrMblUrl"), (String) mapParams.get("ftrWebUrl"))))
			);
			if (flag) {
				System.out.println("----- composites -----");
				System.out.println(">>>>> " + composites);
				System.out.println(">>>>> " + new GsonBuilder().setPrettyPrinting().create().toJson(composites));
			}
		}
		
		if (!flag) {
			// environment
			System.setProperty("server.type", "real");
			
			// 알림톡 템플릿에 등록한 메시지 타입코드 or "002"
			String talkMsgTempNo = "001";
			
			// 발송대상 앱코드
			AppKdCdType appKdCd = AppKdCdType.ELEVENSTAPP;
			
			// 푸시메시지
			JsonObject obj = new JsonObject();
			obj.addProperty("IOS_MSG", "아이폰 메시지~개인화테스트입니다~"+seq+"번째(포맷유지)");
			obj.addProperty("AND_TOP_MSG", "안드로이드 메시지~~개인화테스트입니다~"+seq+"번째(포맷변경)");
			obj.addProperty("AND_BTM_MSG", "안드로이드 메시지~~개인화테스트입니다~"+seq+"번째(포맷변경)");
			if (flag) {
				System.out.println(">>>>> " + obj.toString());
			}
			
			// Url
			String detailUrl = "http://m.11st.co.kr/MW/TData/dataFree.tmall";
			String bannerUrl = "http://m.11st.co.kr";
			String etcSasData = "{ \"campaigncode\":\"CAMP00000\", \"treatmentcode\":\"TR00000\" }";
			Map<String,String> mapEtcSasData = gson.fromJson(etcSasData, new TypeToken<Map<String, Object>>(){}.getType());
			String summary = "주문 알림톡입니다.("+seq+")";  // 알림톡방 리스트에 노출 할 메시지
			
			/////////////////////////////////////////
			// 알림톡 인자 세팅
			PushTalkParameter pushTalkParam = new PushTalkParameter(talkMsgTempNo, memberNo);
			pushTalkParam.setAppKdCd(appKdCd);             // 발송대상 앱코드
			//pushTalkParam.setMsgGrpNo(1235L);              // 메시지 식별 그룹번호. 없을경우 생략가능
			pushTalkParam.setPushIosMessage(obj.toString());     // JSON (?)
			pushTalkParam.setPushTopMessage(obj.toString());     // JSON (?)
			pushTalkParam.setPushBottomMessage(obj.toString());  // JSON (?)
			//pushTalkParam.setPushIosMessage(obj.get("IOS_MSG").getAsString());         // IOS message
			//pushTalkParam.setPushTopMessage(obj.get("AND_TOP_MSG").getAsString());     // Android Top message
			//pushTalkParam.setPushBottomMessage(obj.get("AND_BTM_MSG").getAsString());  // Android Bottom message
			pushTalkParam.setTalkDispYn("Y");              // 고정 처리 (Y) 알림-혜택톡방 동시 사용함
			pushTalkParam.setDetailUrl(detailUrl);         // 일반푸시 사용시- 클릭URL
			pushTalkParam.setBannerUrl(bannerUrl);         // 푸시배너이미지. 없을경우 생략가능
			pushTalkParam.setEtcData(mapEtcSasData);       // 기타 데이타 SAS에서 사용
			pushTalkParam.setTalkSummaryMessage(summary);  // 알림톡방 리스트에 노출 할 메시지
			pushTalkParam.setTalkMessage(composites);      // data from DB Table CM_CAMPAIGN_CHANNEL_JS
			pushTalkParam.setSendAllwBgnDt(new Date());    // 예약발송시 설정.
			// SMS 셋팅 http://wiki.11stcorp.com/pages/viewpage.action?pageId=214088691
			//pushTalkParam.setSmsMsg("SMS 스펙에 해당하는 데이터 작성");
			// 테스트 데이터 셋팅, 운영모드 일 경우 Remarking
			if (flag) {
				System.out.println(">>>>> " + pushTalkParam);
			}
			
			try {
				//알림톡 전송
				int ret = -1;
				if (flag) ret = PushTalkSendService.INSTANCE.remoteSyncPush(Lists.newArrayList(pushTalkParam));
				System.out.println("ret = " + ret);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
}
