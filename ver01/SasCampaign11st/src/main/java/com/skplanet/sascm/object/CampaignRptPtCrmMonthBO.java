package com.skplanet.sascm.object;

import java.util.Date;

public class CampaignRptPtCrmMonthBO {
	private String std_mon;
	private int pt_cust_cnt;
	private int tot_cust_cnt;
	private int pt_cmpn_amt;
	private int tot_amt;
	private int pt_cmpn_cost;
	private int tot_dc_amt;
	private int pt_cost_ratio;
	private int tot_ratio;
	private int pt_net_amt;
	private int tot_net_amt;
	private Date create_dt;
	public String getStd_mon() {
		return std_mon;
	}
	public void setStd_mon(String std_mon) {
		this.std_mon = std_mon;
	}
	public int getPt_cust_cnt() {
		return pt_cust_cnt;
	}
	public void setPt_cust_cnt(int pt_cust_cnt) {
		this.pt_cust_cnt = pt_cust_cnt;
	}
	public int getTot_cust_cnt() {
		return tot_cust_cnt;
	}
	public void setTot_cust_cnt(int tot_cust_cnt) {
		this.tot_cust_cnt = tot_cust_cnt;
	}
	public int getPt_cmpn_amt() {
		return pt_cmpn_amt;
	}
	public void setPt_cmpn_amt(int pt_cmpn_amt) {
		this.pt_cmpn_amt = pt_cmpn_amt;
	}
	public int getTot_amt() {
		return tot_amt;
	}
	public void setTot_amt(int tot_amt) {
		this.tot_amt = tot_amt;
	}
	public int getPt_cmpn_cost() {
		return pt_cmpn_cost;
	}
	public void setPt_cmpn_cost(int pt_cmpn_cost) {
		this.pt_cmpn_cost = pt_cmpn_cost;
	}
	public int getTot_dc_amt() {
		return tot_dc_amt;
	}
	public void setTot_dc_amt(int tot_dc_amt) {
		this.tot_dc_amt = tot_dc_amt;
	}
	public int getPt_cost_ratio() {
		return pt_cost_ratio;
	}
	public void setPt_cost_ratio(int pt_cost_ratio) {
		this.pt_cost_ratio = pt_cost_ratio;
	}
	public int getTot_ratio() {
		return tot_ratio;
	}
	public void setTot_ratio(int tot_ratio) {
		this.tot_ratio = tot_ratio;
	}
	public int getPt_net_amt() {
		return pt_net_amt;
	}
	public void setPt_net_amt(int pt_net_amt) {
		this.pt_net_amt = pt_net_amt;
	}
	public int getTot_net_amt() {
		return tot_net_amt;
	}
	public void setTot_net_amt(int tot_net_amt) {
		this.tot_net_amt = tot_net_amt;
	}
	public Date getCreate_dt() {
		return create_dt;
	}
	public void setCreate_dt(Date create_dt) {
		this.create_dt = create_dt;
	}
}
