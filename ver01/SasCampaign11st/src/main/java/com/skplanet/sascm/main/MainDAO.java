package com.skplanet.sascm.main;

import java.util.HashMap;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import com.skplanet.sascm.util.DataMap;

@Repository
public class MainDAO extends SqlSessionDaoSupport {

    // 현재 접속자의 권한 조회
    public HashMap<String, Object> detailAuth(DataMap param) {
        return getSqlSession().selectOne("checkAuthCenter", param);
    }

    // 온라인 이벤트 사용 가능여부 조회 
    public HashMap<String, Object> getEventManagerYN(DataMap empno) {
        return getSqlSession().selectOne("checkEventManager", empno);
    }
}
