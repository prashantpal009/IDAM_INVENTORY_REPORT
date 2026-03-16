@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZCDS_INVENTROY_REP1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_INVENTROY_REP1
  with parameters
    P_StartDate : zdats,
    P_EndDate   : zdats_end
  as select from    I_GoodsMovementCube  as A
    left outer join I_ProductDescription as B on B.Product = A.Material
    left outer join I_Product            as D on D.Product = A.Material
{
  key A.Material,
  key A.Plant,
  key A.StorageLocation,
  key A.CompanyCode,
  key A.ProfitCenter,
      A.MaterialBaseUnit,
      //      A.IsConsumptionMovement,
      A.CompanyCodeCurrency,
      B.ProductDescription,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum(
      case
//       when A.PostingDate between $parameters.P_StartDate and $parameters.P_EndDate
      when A.PostingDate <= $parameters.P_StartDate
        then A.MatlStkChangeQtyInBaseUnit
        else cast( 0 as abap.quan(31,14) ) end )    as OpeningQty,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'

      sum(
      case
      when A.PostingDate <= $parameters.P_StartDate
      then A.GoodsMovementStkAmtInCCCrcy
      else cast( 0 as abap.curr(23,2) ) end )       as OpeningAmt,


      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum(
      case
//      when A.PostingDate between $parameters.P_StartDate and $parameters.P_EndDate
       when A.PostingDate <= $parameters.P_EndDate
        then A.MatlStkChangeQtyInBaseUnit
        else cast( 0 as abap.quan(31,14) ) end )    as ClosingQty ,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(
       case
//       when A.PostingDate between $parameters.P_StartDate and $parameters.P_EndDate
         when A.PostingDate <= $parameters.P_EndDate
           then A.GoodsMovementStkAmtInCCCrcy
           else cast( 0 as abap.curr(23,2) ) end )  as ClosingAmt,



      //       ////////      Purchase Inward
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum(case
        when  A.PostingDate between $parameters.P_StartDate and $parameters.P_EndDate and
           A.GoodsMovementType = '561'
        then A.MatlStkChangeQtyInBaseUnit  end )    as stock_qty,


      ////////      Purchase Inward
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'

      sum(case
        when A.PostingDate between $parameters.P_StartDate and $parameters.P_EndDate and 
           ( A.GoodsMovementType = '101'
             or A.GoodsMovementType = '102'
             or A.GoodsMovementType = '561'
             or A.GoodsMovementType = '562'  )
            
        then A.MatlStkChangeQtyInBaseUnit  end )    as recpt_purchqty,


      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(
      case
      when A.PostingDate between $parameters.P_StartDate and $parameters.P_EndDate and 
      ( A.GoodsMovementType = '101'
      or A.GoodsMovementType = '102'
      or A.GoodsMovementType = '561'
      or A.GoodsMovementType = '562' ) 
      then  A.GoodsMovementStkAmtInCCCrcy end )    as recpt_purchval,

      //////      Sales Outward
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum(
      case
      when A.PostingDate between $parameters.P_StartDate and $parameters.P_EndDate
       and ( A.GoodsMovementType = '601'
        or A.GoodsMovementType = '602' )
      then A.MatlStkChangeQtyInBaseUnit   end )     as issue_salesqty,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(
      case
      when A.PostingDate between $parameters.P_StartDate and $parameters.P_EndDate
       and ( A.GoodsMovementType = '601'
        or A.GoodsMovementType = '602' )
      then A.GoodsMovementStkAmtInCCCrcy end )      as issue_salesval,

      //////      STO Inward
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum(
      case
      when A.PostingDate between $parameters.P_StartDate and $parameters.P_EndDate and 
     ( A.IsConsumptionMovement <> 'X' and A.GoodsMovementType = '641' or A.GoodsMovementType = '642' ) 
      then A.MatlStkChangeQtyInBaseUnit   end )     as recpt_transfqty,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(
      case
      when A.PostingDate between $parameters.P_StartDate and $parameters.P_EndDate and 
       ( A.IsConsumptionMovement <> 'X' and A.GoodsMovementType = '641' or A.GoodsMovementType = '642' )
       then A.GoodsMovementStkAmtInCCCrcy end  )     as recpt_transfval,

      //////       STO Outward
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum(
      case
      when  A.PostingDate between $parameters.P_StartDate and $parameters.P_EndDate and (
      A.IsConsumptionMovement = 'X' and A.GoodsMovementType = '641' or A.GoodsMovementType = '642' )
      then A.MatlStkChangeQtyInBaseUnit end )       as issue_transfqty,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(
       case 
       when  A.PostingDate between $parameters.P_StartDate and $parameters.P_EndDate and
       ( A.IsConsumptionMovement = 'X' and A.GoodsMovementType = '641' or A.GoodsMovementType = '642' )
       then A.GoodsMovementStkAmtInCCCrcy end  )    as issue_transfval,


      //////      other Inwards
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum( case
      when A.PostingDate between $parameters.P_StartDate and $parameters.P_EndDate and 
       ( A.GoodsMovementType = '651' or A.GoodsMovementType = '652' or A.GoodsMovementType = '653'
      or A.GoodsMovementType = '654' or A.GoodsMovementType = '655' or A.GoodsMovementType = '656' or A.GoodsMovementType = '657'
      or A.GoodsMovementType = '658' )
      then A.MatlStkChangeQtyInBaseUnit end    )    as qty_oth_recvgoods,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'

      sum(case
      when  A.PostingDate between $parameters.P_StartDate and $parameters.P_EndDate and
      ( A.GoodsMovementType = '651' or A.GoodsMovementType = '652' or A.GoodsMovementType = '653'
      or A.GoodsMovementType = '654' or A.GoodsMovementType = '655' or A.GoodsMovementType = '656' or A.GoodsMovementType = '657'
      or A.GoodsMovementType = '658' )
      then A.GoodsMovementStkAmtInCCCrcy end    )   as val_oth_recvgoods,

      //////      Other Outwards
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum( case
       when A.PostingDate between $parameters.P_StartDate and $parameters.P_EndDate and
       ( A.GoodsMovementType = '161' or A.GoodsMovementType = '162'
       or A.GoodsMovementType = '122' or A.GoodsMovementType = '123' )
       then A.MatlStkChangeQtyInBaseUnit end  )     as qty_oth_issuegoods,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum( case
       when A.PostingDate between $parameters.P_StartDate and $parameters.P_EndDate and
       ( A.GoodsMovementType = '161' or A.GoodsMovementType = '162'
       or A.GoodsMovementType = '122' or A.GoodsMovementType = '123' )
       then A.GoodsMovementStkAmtInCCCrcy end )     as val_oth_issuegoods,


      //////      Physical Adjustment Inwards
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum(case
      when  A.PostingDate between $parameters.P_StartDate and $parameters.P_EndDate and
      A.GoodsMovementType = '701'
      then A.MatlStkChangeQtyInBaseUnit end     )   as qty_adj_inword,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(case
      when A.PostingDate between $parameters.P_StartDate and $parameters.P_EndDate and
      A.GoodsMovementType = '701'
      then A.GoodsMovementStkAmtInCCCrcy end      ) as val_adj_inword,

      ////      Physical Adjustment Outwards
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum( case
       when A.PostingDate between $parameters.P_StartDate and $parameters.P_EndDate and
        A.GoodsMovementType = '702'
       then A.MatlStkChangeQtyInBaseUnit end     )  as qty_adj_outword,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum( case
       when A.PostingDate between $parameters.P_StartDate and $parameters.P_EndDate and 
       A.GoodsMovementType = '702'
       then A.GoodsMovementStkAmtInCCCrcy end    )  as val_adj_outword


}
where A.StorageLocation <> ' '
group by
  A.Material,
  A.Plant,
  A.StorageLocation,
  A.CompanyCode,
  A.ProfitCenter,
  A.MaterialBaseUnit,
  A.CompanyCodeCurrency,
  B.ProductDescription
