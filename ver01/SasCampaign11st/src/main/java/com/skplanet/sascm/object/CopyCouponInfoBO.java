package com.skplanet.sascm.object;

import java.util.Date;
import java.util.List;

public class CopyCouponInfoBO {
	private String p_cupn_no;
	private String p_cupn_nm;
	private String p_cupn_dsc_mthd_cd;
	private long p_dsc_amt_rt;
	private long p_max_dsc_amt;
	private long p_min_ord_amt;
	private Date p_iss_cn_bgn_dt;
	private Date p_iss_cn_end_dt;
	private Date p_eftv_bgn_dt;
	private Date p_eftv_end_dt;
	private String p_wire_wirelss_clf_cd;
	private String p_create_id;
	private String p_aprv_id;
	private String r_cupn_no;
	private List<Integer> p_ctgr_no_list;
	private String p_update_id;

	public String getP_cupn_nm() {
		return p_cupn_nm;
	}

	public void setP_cupn_nm(String p_cupn_nm) {
		this.p_cupn_nm = p_cupn_nm;
	}

	public String getP_cupn_dsc_mthd_cd() {
		return p_cupn_dsc_mthd_cd;
	}

	public void setP_cupn_dsc_mthd_cd(String p_cupn_dsc_mthd_cd) {
		this.p_cupn_dsc_mthd_cd = p_cupn_dsc_mthd_cd;
	}

	public long getP_dsc_amt_rt() {
		return p_dsc_amt_rt;
	}

	public void setP_dsc_amt_rt(long p_dsc_amt_rt) {
		this.p_dsc_amt_rt = p_dsc_amt_rt;
	}

	public long getP_max_dsc_amt() {
		return p_max_dsc_amt;
	}

	public void setP_max_dsc_amt(long p_max_dsc_amt) {
		this.p_max_dsc_amt = p_max_dsc_amt;
	}

	public long getP_min_ord_amt() {
		return p_min_ord_amt;
	}

	public void setP_min_ord_amt(long p_min_ord_amt) {
		this.p_min_ord_amt = p_min_ord_amt;
	}

	public Date getP_iss_cn_bgn_dt() {
		return p_iss_cn_bgn_dt;
	}

	public void setP_iss_cn_bgn_dt(Date p_iss_cn_bgn_dt) {
		this.p_iss_cn_bgn_dt = p_iss_cn_bgn_dt;
	}

	public Date getP_iss_cn_end_dt() {
		return p_iss_cn_end_dt;
	}

	public void setP_iss_cn_end_dt(Date p_iss_cn_end_dt) {
		this.p_iss_cn_end_dt = p_iss_cn_end_dt;
	}

	public Date getP_eftv_bgn_dt() {
		return p_eftv_bgn_dt;
	}

	public void setP_eftv_bgn_dt(Date p_eftv_bgn_dt) {
		this.p_eftv_bgn_dt = p_eftv_bgn_dt;
	}

	public Date getP_eftv_end_dt() {
		return p_eftv_end_dt;
	}

	public void setP_eftv_end_dt(Date p_eftv_end_dt) {
		this.p_eftv_end_dt = p_eftv_end_dt;
	}

	public String getP_cupn_no() {
		return p_cupn_no;
	}

	public String getP_wire_wirelss_clf_cd() {
		return p_wire_wirelss_clf_cd;
	}

	public void setP_wire_wirelss_clf_cd(String p_wire_wirelss_clf_cd) {
		this.p_wire_wirelss_clf_cd = p_wire_wirelss_clf_cd;
	}

	public String getP_create_id() {
		return p_create_id;
	}

	public void setP_create_id(String p_create_id) {
		this.p_create_id = p_create_id;
	}

	public String getP_aprv_id() {
		return p_aprv_id;
	}

	public void setP_aprv_id(String p_aprv_id) {
		this.p_aprv_id = p_aprv_id;
	}

	public List<Integer> getP_ctgr_no_list() {
		return p_ctgr_no_list;
	}

	public void setP_ctgr_no_list(List<Integer> p_ctgr_no_list) {
		this.p_ctgr_no_list = p_ctgr_no_list;
	}

	public String getP_update_id() {
		return p_update_id;
	}

	public void setP_update_id(String p_update_id) {
		this.p_update_id = p_update_id;
	}

	public String getR_cupn_no() {
		return r_cupn_no;
	}

	public void setR_cupn_no(String r_cupn_no) {
		this.r_cupn_no = r_cupn_no;
	}

	public void setP_cupn_no(String p_cupn_no) {
		this.p_cupn_no = p_cupn_no;
	}
}
