package com.skplanet.sascm.util;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;

import sun.misc.BASE64Decoder;

/**
 * 템플릿 쿠폰 번호 체크 후 쿠폰 번호 복사 하여 저장
 * @author JinJungAh
 * @createdate 2013.11.11
 */
@SuppressWarnings("restriction")
public class CheckCopyCouponNo {

  @SuppressWarnings("finally")
  public static String checkCouponNo(String sPFlowchartId, String sPRunId, String dbconnUrl, String dbconnUser, String dbconnPass, String dbconnBoUrl, String dbconnBoUser, String dbconnBoPass, int offerId) {

    try {
      Class.forName("oracle.jdbc.driver.OracleDriver");
    } catch (ClassNotFoundException e) {
      System.out.println("Driver Load Error : " + e.getMessage());
      return "Driver Load Error"; 
    }
    
    //System.out.println("argument count: " + args.length);

    //String sPFlowchartId = args[0];
    //String sPRunId = args[1];

    int nFlowchartId = 0;
    int nRunId = 0;
        
//    CampaignLogWrite logwrite = new CampaignLogWrite("CheckCopyCouponNo","JAVA");
        
    try {
      nFlowchartId = Integer.parseInt(sPFlowchartId);
      nRunId = Integer.parseInt(sPRunId);
    } catch (Exception e) {
      System.out.println("Parameter error : " + e.getMessage());
//      logwrite.write("ERROR","[캠페인 대상자 추출|쿠폰복사] sPFlowchartId="+sPFlowchartId+", sPRunId="+sPRunId+", Parameter Error","","Java CheckCopyCouponNo Parameter error","02");
      //System.exit(1);
      return "Parameter Error"; 
    }
    System.out.println("FlowchartId: " + nFlowchartId);
    System.out.println("RunId: " + nRunId);

    //Configuration conf = null;

    String sCMSDBURL = "";
    String sCMSDBID = "";
    String sCMSDBPWD = "";
    Connection conCMS = null;
    PreparedStatement pstmtCMS = null;
    PreparedStatement pstmtCMS2 = null;
    PreparedStatement pstmtCMS2_del = null;
    ResultSet rsCMS = null;

    String sOMDBURL = "";
    String sOMDBID = "";
    String sOMDBPWD = "";
    Connection conOM = null;
    PreparedStatement pstmtOM = null;
    CallableStatement cstmtOM = null;
    ResultSet rsOM = null;

    String sSQL = "";

    String OFFER_SYS_CD = "";
    String OFFER_TYPE_CD = "";
    String TMPL_CUPN_NO = "";
    String TMPL_CUPN_NO_USE_YN = "";
    int TREATMENTSIZE = 0;
    String TREATMENTCODE = "";
    int CELLID = 0;
    int OFFERID = 0;
    String CAMP_BGN_DT = "";
    String CAMP_END_DT = "";
    String CUPN_NM = "";
    String CUPN_APPV_YN = "";
    String CUPN_BGN_DT = "";
    String CUPN_END_DT = "";
    int CUPN_QTY = 0;
    String CUPN_STATUS = "";
    String CUPN_OK_YN = "";
    String CUPN_NO = "";
    Long nTMPL_CUPN_NO = null;
    Long nCUPN_NO = null;

    try {

        
      //conf = new Configuration();
      @SuppressWarnings("unused")
      BASE64Decoder base64Decoder = new BASE64Decoder();
      @SuppressWarnings("unused")
      SeedCBC seed = new SeedCBC();
      
      sCMSDBURL = dbconnUrl;
      sCMSDBID = dbconnUser;
      sCMSDBPWD = dbconnPass;
      conCMS = DriverManager.getConnection(sCMSDBURL, sCMSDBID, sCMSDBPWD);

      //sOMDBURL = "jdbc:oracle:thin:@(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=172.18.185.37)(PORT=1525))(ADDRESS=(PROTOCOL=TCP)(HOST=172.18.185.69)(PORT=1525))(FAILOVER=on)(LOAD_BALANCE=off))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=TMALL)))  ";
      sOMDBURL = dbconnBoUrl;
      sOMDBID = dbconnBoUser;
      sOMDBPWD = dbconnBoPass;
      conOM = DriverManager.getConnection(sOMDBURL, sOMDBID, sOMDBPWD);

      // 체크 및 복사할 쿠폰번호 조회
        sSQL  = " select a.offer_sys_cd";
        sSQL += "       ,a.offer_type_cd";
        sSQL += "       ,a.tmpl_cupn_no";
        sSQL += "       ,a.tmpl_cupn_no_use_yn";
        sSQL += "       ,(select count(*) from ci_contact_history t1 where t1.cell_package_sk = b.cell_package_sk) treatmentsize";
        sSQL += "       ,to_char(b.cell_package_sk) treatmentcode";
        sSQL += "       ,a.cellid";
        sSQL += "       ,a.offerid      ";
        sSQL += "       ,case";
        sSQL += "            when c.camp_term_cd = '01' then to_char(c.camp_bgn_dt,'YYYYMMDD')";
        sSQL += "            else to_char(decode(c.manual_trans_yn,'T',sysdate,sysdate+1),'YYYYMMDD')";
        sSQL += "        end camp_bgn_dt      ";
        sSQL += "       ,case";
        sSQL += "            when c.camp_term_cd = '01' then to_char(c.camp_end_dt,'YYYYMMDD')";
        sSQL += "            else to_char(decode(c.manual_trans_yn,'T',sysdate,sysdate+1)+c.camp_term_day,'YYYYMMDD')";
        sSQL += "        end camp_end_dt";
        sSQL += " from   cm_campaign_offer a";
        sSQL += "       ,ci_cell_package   b";
        sSQL += "       ,cm_campaign_dtl   c";
        sSQL += " where  a.cellid             = b.marketing_cell_sk";
        sSQL += " and    a.flowchartid        = b.campaign_sk";
        sSQL += " and    a.campaigncode       = c.campaigncode";
        sSQL += " and    a.flowchartid        = ?";
        sSQL += " and    b.marketing_cell_sk    = ?";
        sSQL += " and    b.cell_package_sk    = (select max(cell_package_sk) from ci_cell_package where campaign_sk =b.campaign_sk and marketing_cell_sk = b.marketing_cell_sk ) ";
        sSQL += " and    a.offerid    = ?";
        sSQL += " and    a.offer_sys_cd       = 'OM' ";
        sSQL += " and    a.offer_type_cd      = 'CU' ";
            
      System.out.println(sSQL);
            
      pstmtCMS = conCMS.prepareStatement(sSQL);
      pstmtCMS.setInt(1, nFlowchartId);
      pstmtCMS.setInt(2, nRunId);
      pstmtCMS.setInt(3, offerId);
      pstmtCMS.execute();
    
      rsCMS = pstmtCMS.getResultSet();

      while(rsCMS.next()) {
        System.out.println("########### While START !!!");
        CUPN_OK_YN = "Y";
        CUPN_STATUS = "";
        CUPN_NO = "";

        OFFER_SYS_CD = rsCMS.getString("OFFER_SYS_CD");
        OFFER_TYPE_CD = rsCMS.getString("OFFER_TYPE_CD");
        TMPL_CUPN_NO = rsCMS.getString("TMPL_CUPN_NO");
        TMPL_CUPN_NO_USE_YN = rsCMS.getString("TMPL_CUPN_NO_USE_YN");
        TREATMENTSIZE = rsCMS.getInt("TREATMENTSIZE");
        TREATMENTCODE = rsCMS.getString("TREATMENTCODE");
        CELLID = rsCMS.getInt("CELLID");
        OFFERID = rsCMS.getInt("OFFERID");
        CAMP_BGN_DT = rsCMS.getString("CAMP_BGN_DT");
        CAMP_END_DT = rsCMS.getString("CAMP_END_DT");
                
        System.out.println("OFFER_SYS_CD="+OFFER_SYS_CD);
        System.out.println("OFFER_TYPE_CD="+OFFER_TYPE_CD);
        System.out.println("TMPL_CUPN_NO="+TMPL_CUPN_NO);
        System.out.println("TMPL_CUPN_NO_USE_YN="+TMPL_CUPN_NO_USE_YN);
        System.out.println("TREATMENTSIZE="+TREATMENTSIZE);
        System.out.println("CAMP_BGN_DT="+CAMP_BGN_DT);
        System.out.println("CAMP_END_DT="+CAMP_END_DT);
                
        sSQL  = " SELECT CUPN_NM CUPN_NM, ";
        sSQL += "        DECODE(CUPN_ISS_STAT_CD,'03','Y','N') CUPN_APPV_YN, ";
        sSQL += "        TO_CHAR(ISS_CN_BGN_DT,'YYYYMMDD') CUPN_BGN_DT, ";
        sSQL += "        TO_CHAR(ISS_CN_END_DT,'YYYYMMDD') CUPN_END_DT, ";
        sSQL += "        ISU_QTY CUPN_QTY ";
        sSQL += " FROM   TABLE(TMALL.FN_MT_CUPN_INFO(?)) ";

                
        System.out.println(sSQL);
                
        pstmtOM = conOM.prepareStatement(sSQL);
        pstmtOM.setString(1, TMPL_CUPN_NO);
        pstmtOM.execute();

        rsOM = pstmtOM.getResultSet();

        if(rsOM.next()) {
            
          CUPN_NM = rsOM.getString("CUPN_NM");
          CUPN_APPV_YN = rsOM.getString("CUPN_APPV_YN");
          CUPN_BGN_DT = rsOM.getString("CUPN_BGN_DT");
          CUPN_END_DT = rsOM.getString("CUPN_END_DT");
          CUPN_QTY = rsOM.getInt("CUPN_QTY");
                    
          System.out.println("CUPN_NM="+CUPN_NM);
          System.out.println("CUPN_APPV_YN="+CUPN_APPV_YN);
          System.out.println("CUPN_BGN_DT="+CUPN_BGN_DT);
          System.out.println("CUPN_END_DT="+CUPN_END_DT);
          System.out.println("CUPN_QTY="+CUPN_QTY);
                    
          // 쿠폰이 조회되지 않음
          if( CUPN_NM.equals("") ) {
            CUPN_STATUS = "Not Exists";
            CUPN_OK_YN = "N";
          } else {
            // 쿠폰이 승인되지 않음
            if( !CUPN_APPV_YN.equals("Y") ) {
              CUPN_STATUS = "Not Approved";
              CUPN_OK_YN = "N";
            } else {
              // 캠페인기간이 쿠폰기간을 벗어남
              if( Integer.parseInt(CAMP_BGN_DT) < Integer.parseInt(CUPN_BGN_DT) 
                    || Integer.parseInt(CAMP_END_DT) > Integer.parseInt(CUPN_END_DT) ) {
                  CUPN_STATUS = "Invalid Date";
                  CUPN_OK_YN = "N";
                }
              // 추출된 대상수가 남은 쿠폰 수량보다 큼
              if( CUPN_QTY < TREATMENTSIZE ) {
                CUPN_STATUS = "Quantity Exceed";
                CUPN_OK_YN = "N";
              }
            }
          }
        }
        
        System.out.println("CUPN_STATUS: " + CUPN_STATUS);
        System.out.println("CUPN_OK_YN: " + CUPN_OK_YN);

        if( pstmtOM != null ) pstmtOM.close();
        pstmtOM = null;
        if( rsOM != null ) rsOM.close();
        rsOM = null;

        // 쿠폰이 정상임
        if( CUPN_OK_YN.equals("Y") ) {
            
            // 템플릿 쿠폰 번호 사용 여부 N 이면 쿠폰복사
            if( TMPL_CUPN_NO_USE_YN.equals("N") ) {
              
              // OM 쿠폰 복사 SP 호출
              if( OFFER_SYS_CD.equals("OM") ) {
                  
                nTMPL_CUPN_NO = new Long(TMPL_CUPN_NO);
    
                cstmtOM = conOM.prepareCall("{ call TMALL.SP_MT_CUPN_COPY(?,TO_DATE(?,'YYYYMMDD'),TO_DATE(?,'YYYYMMDDHH24MISS'),?,?)}");
                cstmtOM.setLong(1, nTMPL_CUPN_NO); // 복사할 쿠폰번호
                cstmtOM.setString(2, CAMP_BGN_DT); // 유효 시작일
                cstmtOM.setString(3, CAMP_END_DT+"235959"); // 유효 종료일
                cstmtOM.registerOutParameter(4, Types.NUMERIC); // 성공시 신규 쿠폰번호, 실패시 0 이하값
                cstmtOM.setString(5,TMPL_CUPN_NO_USE_YN); // 쿠폰 복사 예외 여부
    
                cstmtOM.execute();
                nCUPN_NO = cstmtOM.getLong(4);
    
                if( nCUPN_NO.longValue() <= 0 ) {
                  CUPN_STATUS = "Fail Coupon Copy";
                  CUPN_OK_YN = "N";
                } else {
                  CUPN_NO = nCUPN_NO.toString();
                }
                
              // OM 쿠폰 복사 SP 호출
              } else if( OFFER_SYS_CD.equals("MM") ) {
                  
                cstmtOM = conOM.prepareCall("{ call MERCHANT.SP_TBL_MT_CPN_COPY(?,TO_DATE(?,'YYYYMMDD'),TO_DATE(?,'YYYYMMDDHH24MISS'),?,?)}");
                cstmtOM.setString(1, TMPL_CUPN_NO); // 복사할 쿠폰번호
                cstmtOM.setString(2, CAMP_BGN_DT); // 유효 시작일
                cstmtOM.setString(3, CAMP_END_DT+"235959"); // 유효 종료일
                cstmtOM.registerOutParameter(4, Types.VARCHAR); // 성공시 신규 쿠폰번호, 실패시 0 이하값
                cstmtOM.setString(5,TMPL_CUPN_NO_USE_YN); // 쿠폰 복사 예외 여부
    
                cstmtOM.execute();
                CUPN_NO = cstmtOM.getString(4);
                if( CUPN_NO.equals("0") || CUPN_NO.indexOf("-") >= 0 ) {
                  CUPN_STATUS = "Fail Coupon Copy";
                  CUPN_OK_YN = "N";
                }
              }
              
            // 템플릿 쿠폰 번호 사용 여부 Y 이면 TMPL_CUPN_NO 그대로 사용
            } else {
                CUPN_NO = TMPL_CUPN_NO;
            }
        } // 쿠폰이 정상임 END
                
        System.out.println("============== COPY COUPONNO ==============");
        System.out.println("CUPN_STATUS: " + CUPN_STATUS);
        System.out.println("CUPN_OK_YN: " + CUPN_OK_YN);
        System.out.println("CUPN_NO: " + CUPN_NO);
                                
        if( cstmtOM != null ) cstmtOM.close();
        cstmtOM = null;

        sSQL  = "DELETE CM_CUPN_STAT WHERE TREATMENTCODE = ? AND OFFERID = ?";

        System.out.println(sSQL + " ::: " + "TREATMENTCODE : " + TREATMENTCODE + "::: OFFERID : " + OFFERID);
        
        pstmtCMS2_del = conCMS.prepareStatement(sSQL);
        pstmtCMS2_del.setString(1, TREATMENTCODE);
        pstmtCMS2_del.setInt(2, OFFERID);
        
        pstmtCMS2_del.executeUpdate();

        if( pstmtCMS2 != null ) pstmtCMS2.close();
        pstmtCMS2 = null;
        
        sSQL  = "INSERT INTO CM_CUPN_STAT(TREATMENTCODE, CELLID, OFFERID, RUNID, CUPN_NO, CUPN_STATUS, CUPN_OK_YN)";
        sSQL += "VALUES(?, ?, ?, ?, ?, ?, ?)";

        System.out.println(sSQL + 
                "::: TREATMENTCODE : " + TREATMENTCODE + 
                "::: CELLID : " + CELLID + 
                "::: OFFERID : " + OFFERID + 
                "::: nRunId : " + TREATMENTCODE + 
                "::: CUPN_NO : " + CUPN_NO + 
                "::: CUPN_STATUS : " + CUPN_STATUS + 
                "::: CUPN_OK_YN : " + CUPN_OK_YN);
        
        pstmtCMS2 = conCMS.prepareStatement(sSQL);
        pstmtCMS2.setString(1, TREATMENTCODE);
        pstmtCMS2.setInt(2, CELLID);
        pstmtCMS2.setInt(3, OFFERID);
        pstmtCMS2.setInt(4, Integer.parseInt(TREATMENTCODE));
        pstmtCMS2.setString(5, CUPN_NO);
        pstmtCMS2.setString(6, CUPN_STATUS);
        pstmtCMS2.setString(7, CUPN_OK_YN);

        pstmtCMS2.executeUpdate();

        if( pstmtCMS2 != null ) pstmtCMS2.close();
        pstmtCMS2 = null;

      }
            
    } catch(Exception e) {
      System.out.println("System Error : " + e);
      //logwrite.write("ERROR","[캠페인 대상자 추출|쿠폰복사] sPFlowchartId="+sPFlowchartId+", sPRunId="+sPRunId+", ERROR MESSAGE:"+e.getMessage(),"","Java CheckCopyCouponNo Program Error","02");
      return "System Error";
    } finally {
      if( conCMS != null ) try{ conCMS.close(); } catch(Exception e){}
      conCMS = null;
      if( pstmtCMS != null ) try{ pstmtCMS.close(); } catch(Exception e){}
      pstmtCMS = null;
      if( pstmtCMS2 != null ) try{ pstmtCMS2.close(); } catch(Exception e){}
      pstmtCMS2 = null;
      if( pstmtCMS2_del != null ) try{ pstmtCMS2_del.close(); } catch(Exception e){}
      pstmtCMS2_del = null;
      if( rsCMS != null ) try{ rsCMS.close(); } catch(Exception e){}
      rsCMS = null;
      if( conOM != null ) try{ conOM.close(); } catch(Exception e){}
      conOM = null;
      if( pstmtOM != null ) try{ pstmtOM.close(); } catch(Exception e){}
      pstmtOM = null;
      if( cstmtOM != null ) try{ cstmtOM.close(); } catch(Exception e){}
      cstmtOM = null;
      if( rsOM != null ) try{ rsOM.close(); } catch(Exception e){}
      rsOM = null;
      
      return "OK";
    }
  }
}
