package com.skplanet.sascm.common.dao;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;

public class AbstractDAO {

	private static final Log log = LogFactory.getLog(AbstractDAO.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate = null;

	@Autowired
	public void setSqlSessionTemplate(SqlSessionTemplate sqlSessionTemplate) {
		this.sqlSessionTemplate = sqlSessionTemplate;
	}

	protected void printQueryId(String queryId) {
		if(log.isDebugEnabled()){
			log.debug("\t QueryId  \t:  " + queryId + ", sqlSessionTemplate = " + this.sqlSessionTemplate);
		}
	}

	public Object insert(String queryId, Object params){
		printQueryId(queryId);
		return this.sqlSessionTemplate.insert(queryId, params);
	}

	public Object update(String queryId, Object params){
		printQueryId(queryId);
		return this.sqlSessionTemplate.update(queryId, params);
	}

	public Object delete(String queryId, Object params){
		printQueryId(queryId);
		return this.sqlSessionTemplate.delete(queryId, params);
	}

	public Object selectOne(String queryId){
		printQueryId(queryId);
		return this.sqlSessionTemplate.selectOne(queryId);
	}

	public Object selectOne(String queryId, Object params){
		printQueryId(queryId);
		return this.sqlSessionTemplate.selectOne(queryId, params);
	}

	//@SuppressWarnings("rawtypes")
	public List<?> selectList(String queryId){
		printQueryId(queryId);
		return this.sqlSessionTemplate.selectList(queryId);
	}

	//@SuppressWarnings("rawtypes")
	public List<?> selectList(String queryId, Object params){
		printQueryId(queryId);
		return this.sqlSessionTemplate.selectList(queryId,params);
	}
}
