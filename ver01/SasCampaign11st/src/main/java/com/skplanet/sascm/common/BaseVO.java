package com.skplanet.sascm.common;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Calendar;

/**
 * The Class BaseVO.
 */
public class BaseVO implements Serializable {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;

  public static final int NUM_PER_PAGE = 10;
  public static final int PAGE_PER_LIST = 10;

	/** The new object. */
	private boolean newObject = false;

	/** The crtr id. */
	private String 	regId;

	/** The crt dt. */
	@SuppressWarnings("unused")
	private String 	regDt;

	/** The mdfr id. */
	private String 	modiId;

	/** The mdfy dt. */
	@SuppressWarnings("unused")
	private String 	modiDt;

	/** The page index. */
	private Integer pageIndex = 0;

	/** The page unit. */
	private Integer pageUnit = 0;

	/** The page size. */
	private Integer pageSize = 0;

	/** 페이징 시작 */
	private int   limitVal;
	/** 페이징 갯수 */
	private int     numPerPage;
	/** 쿼리 스트링 */
	private String    query;
	/** 페이징 갯수 */
	private int     pagePerList;
	/** 현재 페이지 */
	private int     page;
	/** 전체 갯수 */
	private int     totalData;

	@SuppressWarnings("unused")
	private String nowSysTime;

	public boolean isNewObject() {
		return newObject;
	}

	public void setNewObject(boolean newObject) {
		this.newObject = newObject;
	}

	public String getRegId() {
		return regId;
	}

	public void setRegId(String regId) {
		this.regId = regId;
	}

	public String getModiId() {
		return modiId;
	}

	public void setModiId(String modiId) {
		this.modiId = modiId;
	}

	public Integer getPageIndex() {
		return pageIndex;
	}

	public void setPageIndex(Integer pageIndex) {
		this.pageIndex = pageIndex;
	}

	public Integer getPageUnit() {
		return pageUnit;
	}

	public void setPageUnit(Integer pageUnit) {
		this.pageUnit = pageUnit;
	}

	public Integer getPageSize() {
		return pageSize;
	}

	public void setPageSize(Integer pageSize) {
		this.pageSize = pageSize;
	}

	public String getNowSysTime() {

		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy:MM:dd-hh:mm:ss");
		String datetime1 = null;
		datetime1 = sdf1.format(cal.getTime());

		return datetime1;
	}

	public int getLimitVal() {
		return limitVal;
	}

	public void setLimitVal(int limitVal) {
		this.limitVal = limitVal;
	}

	public int getNumPerPage() {
		return numPerPage;
	}

	public void setNumPerPage(int numPerPage) {
		this.numPerPage = numPerPage;
	}

	public String getQuery() {
		return query;
	}

	public void setQuery(String query) {
		this.query = query;
	}

	public int getPagePerList() {
		return pagePerList;
	}

	public void setPagePerList(int pagePerList) {
		this.pagePerList = pagePerList;
	}

	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		this.page = page;
	}

	public int getTotalData() {
		return totalData;
	}

	public void setTotalData(int totalData) {
		this.totalData = totalData;
	}
}
