@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZMMR01_01'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMMR01_01 with parameters 
    P_StartDate  : vdm_v_start_date ,
    P_EndDate    : vdm_v_end_date
    as select from    I_GoodsMovementCube       as A
    left outer join I_ProductDescription      as B on B.Product = A.Material
    left outer join I_Product                 as D on D.Product = A.Material


{
  key A.Plant,
  key A.StorageLocation,
  key A.Material,
  key A.CompanyCode,
      A.ProfitCenter,
      A.MaterialType,
      A.PostingDate,
      A.MaterialGroup,
//      A.GoodsMovementType,
//      A.IsConsumptionMovement,
      B.ProductDescription,
      D.BaseUnit,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      sum(A.MatlStkChangeQtyInBaseUnit) as STOCK_QTY_PERIOD_START,

      A.CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
     sum(A.GoodsMovementStkAmtInCCCrcy ) as STOCK_VAL_PERID_START,

      ////////      Purchase Inward
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      sum(case
        when A.GoodsMovementType = '101'
             or A.GoodsMovementType = '102'
             or A.GoodsMovementType = '561'
             or A.GoodsMovementType = '562'
        then A.MatlStkChangeQtyInBaseUnit  end ) as recpt_purchqty,


      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(
      case
      when A.GoodsMovementType = '101'
      or A.GoodsMovementType = '102'
      or A.GoodsMovementType = '561'
      or A.GoodsMovementType = '562'
      then   A.GoodsMovementStkAmtInCCCrcy end ) as recpt_purchval,

      //////      Sales Outward
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      sum(
      case
      when A.GoodsMovementType = '601'
      or A.GoodsMovementType = '602'
      then A.MatlStkChangeQtyInBaseUnit   end )  as issue_salesqty,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(
      case
      when A.GoodsMovementType = '601'
      or A.GoodsMovementType = '602'
      then A.GoodsMovementStkAmtInCCCrcy end )  as issue_salesval,

      //////      STO Inward
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      sum(
      case
      when A.IsConsumptionMovement <> 'X' and A.GoodsMovementType = '641' or A.GoodsMovementType = '642'
      then A.MatlStkChangeQtyInBaseUnit   end )  as recpt_transfqty,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(
      case
      when A.IsConsumptionMovement <> 'X' and A.GoodsMovementType = '641' or A.GoodsMovementType = '642'
      then A.GoodsMovementStkAmtInCCCrcy end  )        as recpt_transfval,

      //////       STO Outward
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      sum(
      case
      when A.IsConsumptionMovement = 'X' and A.GoodsMovementType = '641' or A.GoodsMovementType = '642'
      then A.MatlStkChangeQtyInBaseUnit end )          as issue_transfqty,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(
       case
       when A.IsConsumptionMovement = 'X' and A.GoodsMovementType = '641' or A.GoodsMovementType = '642'
       then A.GoodsMovementStkAmtInCCCrcy end  )       as issue_transfval,


      //////      other Inwards
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      sum( case
      when  A.GoodsMovementType = '651' or A.GoodsMovementType = '652' or A.GoodsMovementType = '653'
      or A.GoodsMovementType = '654' or A.GoodsMovementType = '655' or A.GoodsMovementType = '656' or A.GoodsMovementType = '657'
      or A.GoodsMovementType = '658'
      then A.MatlStkChangeQtyInBaseUnit end    )       as qty_oth_recvgoods,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'

      sum(case
      when  A.GoodsMovementType = '651' or A.GoodsMovementType = '652' or A.GoodsMovementType = '653'
      or A.GoodsMovementType = '654' or A.GoodsMovementType = '655' or A.GoodsMovementType = '656' or A.GoodsMovementType = '657'
      or A.GoodsMovementType = '658'
      then A.GoodsMovementStkAmtInCCCrcy end    )      as val_oth_recvgoods,

      //////      Other Outwards
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      sum( case
       when A.GoodsMovementType = '161' or A.GoodsMovementType = '162'
       or A.GoodsMovementType = '122' or A.GoodsMovementType = '123'
       then A.MatlStkChangeQtyInBaseUnit end  )        as qty_oth_issuegoods,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum( case
       when A.GoodsMovementType = '161' or A.GoodsMovementType = '162'
       or A.GoodsMovementType = '122' or A.GoodsMovementType = '123'
       then A.GoodsMovementStkAmtInCCCrcy end )        as val_oth_issuegoods,


      //////      Physical Adjustment Inwards
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      sum(case
      when A.GoodsMovementType = '701'
      then A.MatlStkChangeQtyInBaseUnit end     )      as qty_adj_inword,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(case
      when A.GoodsMovementType = '701'
      then A.GoodsMovementStkAmtInCCCrcy end      )    as val_adj_inword,

      ////      Physical Adjustment Outwards
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      sum( case
       when A.GoodsMovementType = '702'
       then A.MatlStkChangeQtyInBaseUnit end     )     as qty_adj_outword,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum( case
       when A.GoodsMovementType = '702'
       then A.GoodsMovementStkAmtInCCCrcy end    )     as val_adj_outword

}
where   A.PostingDate >= $parameters.P_StartDate
      and A.PostingDate <= $parameters.P_EndDate
group by
  A.Plant,
  A.StorageLocation,
  A.Material,
  A.CompanyCode,
  A.ProfitCenter,
  A.MaterialType,
  A.PostingDate,
  A.MaterialGroup,
//  A.GoodsMovementType,
//  A.IsConsumptionMovement,
  B.ProductDescription,
  D.BaseUnit,
  A.CompanyCodeCurrency

