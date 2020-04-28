package com.skplanet.sascm.test;

import org.apache.commons.codec.EncoderException;
import org.apache.commons.codec.net.URLCodec;
import org.apache.commons.lang3.StringUtils;

public class BannerDenyImageTestMain {

	private static final String OVERLAYERED_IMG_URL = "http://i.011st.com/ui_img/cm_display/2018/04/MPMCD/0402/txt_b_w.png";
	
	private static String getRolimgByImgTyp() {
		return "http://img.011st.com/11st-push/o.jpg;sz=800x464/#bannerImg#;sz=800x464;g=0;/#addImg#;g=9;off=-10+35";
	}
	
	private static String extractRolimg(URLCodec urlCodec, String bnnrImgUrl) throws EncoderException {
		String rolImg = getRolimgByImgTyp();
		String bannerImg = urlCodec.encode(bnnrImgUrl);
		String addImg = urlCodec.encode(OVERLAYERED_IMG_URL);
		rolImg = StringUtils.replace(rolImg, "#bannerImg#", bannerImg);
		rolImg = StringUtils.replace(rolImg, "#addImg", addImg);
		return rolImg;
	}

	public static void main(String[] args) throws EncoderException {
		String bnnrImgUrl = "http://i.011st.com/browsing/exhibition/2019/06/28/2019062815522853701__img.jpg";
		URLCodec urlCodec = new URLCodec();
		String result = extractRolimg(urlCodec, bnnrImgUrl);
		System.out.println("result = " + result);
	}
}
