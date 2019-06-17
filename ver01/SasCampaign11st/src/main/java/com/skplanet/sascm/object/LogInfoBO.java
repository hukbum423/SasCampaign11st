package com.skplanet.sascm.object;

public class LogInfoBO {
	private String num;
	private String logid;
	private String objectname;
	private String objecttype;
	private String status;
	private String content;
	private String campaigncode;
	private String sms_yn;
	private String sms_msg;
	private String sms_send_yn;
	private String create_dt;
	private String sms_target;

	public String getNum() {
		return num;
	}

	public void setNum(String num) {
		this.num = num;
	}

	public String getLogid() {
		return logid;
	}

	public void setLogid(String logid) {
		this.logid = logid;
	}

	public String getObjectname() {
		return objectname;
	}

	public void setObjectname(String objectname) {
		this.objectname = objectname;
	}

	public String getObjecttype() {
		return objecttype;
	}

	public void setObjecttype(String objecttype) {
		this.objecttype = objecttype;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getCampaigncode() {
		return campaigncode;
	}

	public void setCampaigncode(String campaigncode) {
		this.campaigncode = campaigncode;
	}

	public String getSms_yn() {
		return sms_yn;
	}

	public void setSms_yn(String sms_yn) {
		this.sms_yn = sms_yn;
	}

	public String getSms_msg() {
		return sms_msg;
	}

	public void setSms_msg(String sms_msg) {
		this.sms_msg = sms_msg;
	}

	public String getSms_send_yn() {
		return sms_send_yn;
	}

	public void setSms_send_yn(String sms_send_yn) {
		this.sms_send_yn = sms_send_yn;
	}

	public String getCreate_dt() {
		return create_dt;
	}

	public void setCreate_dt(String create_dt) {
		this.create_dt = create_dt;
	}

	public String getSms_target() {
		return sms_target;
	}

	public void setSms_target(String sms_target) {
		this.sms_target = sms_target;
	}

}
