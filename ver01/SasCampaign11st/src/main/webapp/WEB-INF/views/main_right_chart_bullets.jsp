<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
[
  {"title":"고객수","subtitle":"명","ranges":[0,0,0],"measures":[${ptCrmMonth.pt_cust_cnt },${ptCrmMonth.tot_cust_cnt }],"markers":[0]},
  {"title":"거래액","subtitle":"억","ranges":[0,0,0],"measures":[${ptCrmMonth.pt_cmpn_amt },${ptCrmMonth.tot_amt }],"markers":[0]},
  {"title":"비용","subtitle":"억","ranges":[0,0,0],"measures":[${ptCrmMonth.pt_cmpn_cost },${ptCrmMonth.tot_dc_amt }],"markers":[0]},
  {"title":"비용률","subtitle":"","ranges":[0,0,0],"measures":[${ptCrmMonth.pt_cost_ratio },${ptCrmMonth.tot_ratio }],"markers":[0]},
  {"title":"순매출","subtitle":"억","ranges":[0,0,0],"measures":[${ptCrmMonth.pt_net_amt },${ptCrmMonth.tot_net_amt }],"markers":[0]}
]