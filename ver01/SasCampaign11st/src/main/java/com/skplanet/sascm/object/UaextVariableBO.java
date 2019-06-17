package com.skplanet.sascm.object;

public class UaextVariableBO {
	private String num;
	private String vari_name;
	private String key_column;
	private String ref_table;
	private String ref_column;
	private String if_null;
	private String use_yn;
	private String create_id;
	private String create_nm;
	private String create_dt;
	private String update_id;
	private String update_nm;
	private String update_dt;
	private String pre_value;
	private String max_byte;

	public String getMax_byte() {
		return max_byte;
	}

	public void setMax_byte(String max_byte) {
		this.max_byte = max_byte;
	}

	public String getNum() {
		return num;
	}

	public void setNum(String num) {
		this.num = num;
	}

	public String getVari_name() {
		return vari_name;
	}

	public void setVari_name(String vari_name) {
		this.vari_name = vari_name;
	}

	public String getKey_column() {
		return key_column;
	}

	public void setKey_column(String key_column) {
		this.key_column = key_column;
	}

	public String getRef_table() {
		return ref_table;
	}

	public void setRef_table(String ref_table) {
		this.ref_table = ref_table;
	}

	public String getRef_column() {
		return ref_column;
	}

	public void setRef_column(String ref_column) {
		this.ref_column = ref_column;
	}

	public String getIf_null() {
		return if_null;
	}

	public void setIf_null(String if_null) {
		this.if_null = if_null;
	}

	public String getUse_yn() {
		return use_yn;
	}

	public void setUse_yn(String use_yn) {
		this.use_yn = use_yn;
	}

	public String getCreate_nm() {
		return create_nm;
	}

	public void setCreate_nm(String create_nm) {
		this.create_nm = create_nm;
	}

	public String getCreate_dt() {
		return create_dt;
	}

	public void setCreate_dt(String create_dt) {
		this.create_dt = create_dt;
	}

	public String getUpdate_nm() {
		return update_nm;
	}

	public void setUpdate_nm(String update_nm) {
		this.update_nm = update_nm;
	}

	public String getUpdate_dt() {
		return update_dt;
	}

	public void setUpdate_dt(String update_dt) {
		this.update_dt = update_dt;
	}

	public String getCreate_id() {
		return create_id;
	}

	public void setCreate_id(String create_id) {
		this.create_id = create_id;
	}

	public String getUpdate_id() {
		return update_id;
	}

	public void setUpdate_id(String update_id) {
		this.update_id = update_id;
	}

	public String getPre_value() {
		return pre_value;
	}

	public void setPre_value(String pre_value) {
		this.pre_value = pre_value;
	}

}
