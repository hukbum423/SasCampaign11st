package com.skplanet.sascm.object;

public class CalendarBO {

	private String cmpgn_id;
	private String campaignname;
	private String campaigncode; //tr코드
	private String campaign_period;
	private String camp_from_dt;
	private String camp_to_dt;
	private String camp_from_tm;
	private String camp_to_tm;
	private String send_day;
	private String processed_dttm;
	private String rsrv_dt;
	private String start;
	private String end;
	private String url;
	private String title;
	private String color;

	public String getCampaignname() {
		return campaignname;
	}
	public void setCampaignname(String campaignname) {
		this.campaignname = campaignname;
	}
	public String getCampaigncode() {
		return campaigncode;
	}
	public void setCampaigncode(String campaigncode) {
		this.campaigncode = campaigncode;
	}
	public String getCampaign_period() {
		return campaign_period;
	}
	public void setCampaign_period(String campaign_period) {
		this.campaign_period = campaign_period;
	}
	public String getCamp_from_dt() {
		return camp_from_dt;
	}
	public void setCamp_from_dt(String camp_from_dt) {
		this.camp_from_dt = camp_from_dt;
	}
	public String getCamp_to_dt() {
		return camp_to_dt;
	}
	public void setCamp_to_dt(String camp_to_dt) {
		this.camp_to_dt = camp_to_dt;
	}
	public String getCamp_from_tm() {
		return camp_from_tm;
	}
	public void setCamp_from_tm(String camp_from_tm) {
		this.camp_from_tm = camp_from_tm;
	}
	public String getCamp_to_tm() {
		return camp_to_tm;
	}
	public void setCamp_to_tm(String camp_to_tm) {
		this.camp_to_tm = camp_to_tm;
	}
	public String getSend_day() {
		return send_day;
	}
	public void setSend_day(String send_day) {
		this.send_day = send_day;
	}
	public String getProcessed_dttm() {
		return processed_dttm;
	}
	public void setProcessed_dttm(String processed_dttm) {
		this.processed_dttm = processed_dttm;
	}
	public String getCmpgn_id() {
		return cmpgn_id;
	}
	public void setCmpgn_id(String cmpgn_id) {
		this.cmpgn_id = cmpgn_id;
	}
	public String getRsrv_dt() {
		return rsrv_dt;
	}
	public void setRsrv_dt(String rsrv_dt) {
		this.rsrv_dt = rsrv_dt;
	}
	public String getStart() {
		return start;
	}
	public void setStart(String start) {
		this.start = start;
	}
	public String getEnd() {
		return end;
	}
	public void setEnd(String end) {
		this.end = end;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getColor() {
		return color;
	}
	public void setColor(String color) {
		this.color = color;
	}
}
