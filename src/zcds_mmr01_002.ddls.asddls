@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zcds_mmr01_002'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_mmr01_002
  with parameters
    P_StartDate : zdats,
    P_EndDate   : zdats_end
  as select from    ZCDS_INVENTROY_REP1 (
                              P_StartDate: $parameters.P_StartDate,
                              P_EndDate  : $parameters.P_EndDate ) as A
    left outer join zcds_mmr01_001 (
                             P_StartDate: $parameters.P_StartDate,
                             P_EndDate  : $parameters.P_EndDate )  as B on B.Material = A.Material
                                                                        and  B.Plant = A.Plant
                                                                        and B.StorageLocation = A.StorageLocation
                                                                        and B.ProfitCenter = A.ProfitCenter
                                                                        and B.CompanyCode = A.CompanyCode

{
  key A.Material,
  key A.Plant,
  key A.StorageLocation,
  key A.CompanyCode,
  key A.ProfitCenter,
      A.ProductDescription,
      A.CompanyCodeCurrency,
      A.MaterialBaseUnit,
      
      
      // Opening & Closing
      cast( A.OpeningQty        as abap.dec(23,2) ) as OpeningQty,
      cast( A.ClosingQty   as abap.dec(23,2) ) as finalclosingQty,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( A.OpeningAmt        as abap.curr(23,2) ) as OpeningVal,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( A.ClosingAmt   as abap.curr(23,2) ) as FinalclosingVal,

      // Purchase Inward
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      cast( A.recpt_purchqty    as abap.dec(23,2) ) as recpt_purchqty,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( A.recpt_purchval    as abap.curr(23,2) ) as recpt_purchval,

      // Sales Outward
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      cast( A.issue_salesqty    as abap.dec(23,2) ) as issue_salesqty,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( A.issue_salesval    as abap.curr(23,2) ) as issue_salesval,

      // STO Inward
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      cast( A.recpt_transfqty   as abap.dec(23,2) ) as recpt_transfqty,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( A.recpt_transfval   as abap.curr(23,2) ) as recpt_transfval,

      // STO Outward
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      cast( A.issue_transfqty   as abap.dec(23,2) ) as issue_transfqty,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( A.issue_transfval   as abap.curr(23,2) ) as issue_transfval,

      // Other Receipts
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      cast( A.qty_oth_recvgoods as abap.dec(23,2) ) as qty_oth_recvgoods,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( A.val_oth_recvgoods as abap.curr(23,2) ) as val_oth_recvgoods,

      // Other Issues
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      cast( A.qty_oth_issuegoods as abap.dec(23,2) ) as qty_oth_issuegoods,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( A.val_oth_issuegoods as abap.curr(23,2) ) as val_oth_issuegoods,

      // Adjustments In/Out
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      cast( A.qty_adj_inword     as abap.dec(23,2) ) as qty_adj_inword,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( A.val_adj_inword     as abap.curr(23,2) ) as val_adj_inword,

      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      cast( A.qty_adj_outword    as abap.dec(23,2) ) as qty_adj_outword,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( A.val_adj_outword    as abap.curr(23,2) ) as val_adj_outword,

      // Revaluation
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( B.Debit_Revaluation  as abap.curr(23,2) ) as Debit_Revaluation,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( B.VAL_PERIOD1        as abap.curr(23,2) ) as VAL_PERIOD1,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( B.Cebit_Revaluation  as abap.curr(23,2) ) as Cebit_Revaluation,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( B.VAL_PERIOD2        as abap.curr(23,2) ) as VAL_PER,
      
      
//      //*******************************Total inward*******************************//
     @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI.lineItem: [{ position: 47 , label: 'Total Goods Receipt Quantity' }]
      cast(
            coalesce( cast( A.recpt_purchqty     as abap.dec(23,2) ), 0 ) +
            coalesce( cast( A.recpt_transfqty    as abap.dec(23,2) ), 0 ) +
            coalesce( cast( A.qty_oth_recvgoods  as abap.dec(23,2) ), 0 ) +
            coalesce( cast( A.qty_adj_inword     as abap.dec(23,2) ), 0 )
          as abap.dec(23,2)
      ) as tot_goods_rec_qty,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @UI.lineItem: [{ position: 48 , label: 'Total Goods Receipt Value' }]
      cast(
            coalesce( cast( A.recpt_purchval     as abap.dec(23,2) ), 0 ) +
            coalesce( cast( A.recpt_transfval    as abap.dec(23,2) ), 0 ) +
            coalesce( cast( A.val_oth_recvgoods  as abap.dec(23,2) ), 0 ) +
            coalesce( cast( A.val_adj_inword     as abap.dec(23,2) ), 0 )
          as abap.curr(23,2)
      ) as tot_goods_rec_val,

      //*******************************Total outward*******************************//

      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI.lineItem: [{ position: 49 , label: 'Total Goods Issue Quantity' }]
      cast(
            coalesce( cast( A.issue_salesqty     as abap.dec(23,2) ), 0 ) +
            coalesce( cast( A.issue_transfqty    as abap.dec(23,2) ), 0 ) +
            coalesce( cast( A.qty_oth_issuegoods as abap.dec(23,2) ), 0 ) +
            coalesce( cast( A.qty_adj_outword    as abap.dec(23,2) ), 0 )
          as abap.dec(23,2)
      ) as tot_goods_issue_qty,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @UI.lineItem: [{ position: 50 , label: 'Total Goods Issue Value' }]
      cast(
            coalesce( cast( A.issue_salesval     as abap.dec(23,2) ), 0 ) +
            coalesce( cast( A.recpt_transfval    as abap.dec(23,2) ), 0 ) +    // If issue_transfval exists, replace here
            coalesce( cast( A.val_oth_issuegoods as abap.dec(23,2) ), 0 ) +
            coalesce( cast( A.val_adj_outword    as abap.dec(23,2) ), 0 )
          as abap.curr(23,2)
      ) as tot_goods_issue_val
      
      


}
