@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZMMR01_03'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMMR01_03
  as select from    ZMMR01_01 as A
    left outer join ZMMR01_02 as B on B.Material = A.Material
{
  key A.Plant,
  key A.StorageLocation,
  key A.Material,
  key A.CompanyCode,
      A.ProfitCenter,
      A.MaterialType,
      A.PostingDate,
      A.MaterialGroup,
      A.ProductDescription,
      A.BaseUnit,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      A.STOCK_QTY_PERIOD_START,
      A.CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(A.STOCK_VAL_PERID_START + B.VAL_PERIOD1 + B.VAL_PERIOD2 )                                                                                                                                         as stock_val,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      sum(A.recpt_purchqty + A.recpt_transfqty +  A.qty_oth_recvgoods + A.qty_adj_inword )                                                                                                                  as tot_good_recptqty,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(A.recpt_purchval + A.recpt_transfval +  A.val_oth_recvgoods + A.val_adj_inword )                                                                                                                  as tot_good_recptval,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      sum(A.issue_salesqty +  A.issue_transfqty +  A.qty_oth_issuegoods +  A.qty_adj_outword )                                                                                                              as tot_good_issueqty,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(A.issue_salesval +  A.issue_transfval +  A.val_oth_issuegoods + A.val_adj_outword )                                                                                                               as tot_good_issueval,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      sum(A.STOCK_QTY_PERIOD_START + A.recpt_purchqty + A.recpt_transfqty +  A.qty_oth_recvgoods + A.qty_adj_inword  + A.issue_salesqty +  A.issue_transfqty +  A.qty_oth_issuegoods +  A.qty_adj_outword ) as stock_qty_pend,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(A.STOCK_VAL_PERID_START + A.recpt_purchval + A.recpt_transfval +  A.val_oth_recvgoods + A.val_adj_inword  + A.issue_salesval +  A.issue_transfval +  A.val_oth_issuegoods + A.val_adj_outword )   as stock_val_pend,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      A.recpt_purchqty,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum( A.recpt_purchval +  B.VAL_PERIOD2 )                                                                                                                                                              as recpt_purch_val,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      A.issue_salesqty,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      A.issue_salesval,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      A.recpt_transfqty,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      A.recpt_transfval,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      A.issue_transfqty,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      A.issue_transfval,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      A.qty_oth_recvgoods,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      A.val_oth_recvgoods,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      A.qty_oth_issuegoods,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      A.val_oth_issuegoods,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      A.qty_adj_inword,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      A.val_adj_inword,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      A.qty_adj_outword,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      A.val_adj_outword,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      B.Debit_Revaluation,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      B.VAL_PERIOD1,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      B.Cebit_Revaluation,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      B.VAL_PERIOD2
}

group by
  A.Plant,
  A.StorageLocation,
  A.Material,
  A.CompanyCode,
  A.ProfitCenter,
  A.MaterialType,
  A.PostingDate,
  A.MaterialGroup,
  A.ProductDescription,
  A.BaseUnit,
  A.STOCK_QTY_PERIOD_START,
  A.CompanyCodeCurrency,
  A.recpt_purchqty,
  A.recpt_purchval,
  A.issue_salesqty,
  A.issue_salesval,
  A.recpt_transfqty,
  A.recpt_transfval,
  A.issue_transfqty,
  A.issue_transfval,
  A.qty_oth_recvgoods,
  A.val_oth_recvgoods,
  A.qty_oth_issuegoods,
  A.val_oth_issuegoods,
  A.qty_adj_inword,
  A.val_adj_inword,
  A.qty_adj_outword,
  A.val_adj_outword,
  B.Debit_Revaluation,
  B.VAL_PERIOD1,
  B.Cebit_Revaluation,
  B.VAL_PERIOD2
