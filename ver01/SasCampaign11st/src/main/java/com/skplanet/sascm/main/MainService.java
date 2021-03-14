package com.skplanet.sascm.main;

import java.util.HashMap;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.skplanet.sascm.util.DataMap;
import com.skplanet.sascm.util.ServiceMapper;

@Service
public class MainService {

    private static final Logger logger = LoggerFactory.getLogger(MainService.class);

    //@Autowired
    //private MainDAO fsDao;

    @Resource(name = "messageSourceAccessor")
    private MessageSourceAccessor msa;

    /*
    // 접속자 권한 조회
    public HashMap<String, Object> detailAuth(DataMap param) throws Exception {
        logger.debug("detailAuth start");
        try {
            HashMap<String, Object> result = ServiceMapper.convertMap(fsDao.detailAuth(param));
            logger.debug("detailAuth finish");
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
    }

    // 온라인 이벤트 사용 가능여부 조회 
    public HashMap<String, Object> getEventManagerYN(DataMap param) {
        logger.debug("selectChannel start");
        HashMap<String, Object> result = ServiceMapper.convertMap(fsDao.getEventManagerYN(param));
        logger.debug("selectChannel finish");
        return result;
    }
    */
}
