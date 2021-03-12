package com.skplanet.sascm.vo;

import java.sql.Date;

import com.skplanet.sascm.common.BaseVO;

/**
 * <pre>
 * com.skplanet.sascm.vo
 * MemberVO.java
 * </pre>
 *
 * @Author 		: dev
 * @Date		: 2015. 9. 22.
 * @Version	: 
 */
public class MemberVO extends BaseVO {
	
	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;
	
	private int    id;
	private String group_name;
	private String user_name;
	private Date create_date;
	private String useyn;
	private String menu_name;
	private String groupid;
	private String userid;
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getGroup_name() {
        return group_name;
    }
    public void setGroup_name(String group_name) {
        this.group_name = group_name;
    }
    public String getUser_name() {
        return user_name;
    }
    public void setUser_name(String user_name) {
        this.user_name = user_name;
    }
    public Date getCreate_date() {
        return create_date;
    }
    public void setCreate_date(Date create_date) {
        this.create_date = create_date;
    }
    public String getUseyn() {
        return useyn;
    }
    public void setUseyn(String useyn) {
        this.useyn = useyn;
    }
    public String getMenu_name() {
        return menu_name;
    }
    public void setMenu_name(String menu_name) {
        this.menu_name = menu_name;
    }
    public String getGroupid() {
        return groupid;
    }
    public void setGroupid(String groupid) {
        this.groupid = groupid;
    }
    public String getUserid() {
        return userid;
    }
    public void setUserid(String userid) {
        this.userid = userid;
    }

	
}