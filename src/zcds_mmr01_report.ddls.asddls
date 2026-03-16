@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZCDS_MMR01_REPORT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_MMR01_REPORT
  with parameters
    P_StartDate : zdats,
    P_EndDate   : zdats_end
  as select from    I_GoodsMovementCube                                     as A
    left outer join I_ProductDescription                                    as B on B.Product = A.Material
    left outer join I_Product                                               as D on D.Product = A.Material
    left outer join ZCDS_OPEN_STOCK( p_startdate: $parameters.P_StartDate ) as e on  e.Material        = A.Material
                                                                                 and e.Plant           = A.Plant
                                                                                 and e.StorageLocation = A.StorageLocation
    left outer join zcds_closing_stock( p_startdate: $parameters.P_StartDate,
                                     p_enddate  : $parameters.P_EndDate )   as f on  f.Material        = A.Material
                                                                                 and f.Plant           = A.Plant
                                                                                 and f.StorageLocation = A.StorageLocation

{

  key A.Material,
  key A.Plant,
  key A.StorageLocation,
  key A.CompanyCode,
      B.ProductDescription,
      A.ProfitCenter,
      A.MaterialType,
      A.MaterialGroup,
      A.MaterialBaseUnit,
      //      A.IsConsumptionMovement,
      A.CompanyCodeCurrency,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
     cast( e.OpeningQty as abap.dec(23,2) ) as OpeningQty,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
     cast( e.OpeningVal as abap.dec(23,2) ) as Openingval,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      cast(
            coalesce( cast( e.OpeningQty as abap.dec(23,2) ), 0 )
            + coalesce( cast( f.closingQty as abap.dec(23,2) ), 0 )
           as abap.dec(23,2)
      )                                             as finalclosingQty,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
            coalesce( cast( f.closingVal as abap.dec(23,2) ), 0 )
            + coalesce( cast( e.OpeningVal as abap.dec(23,2) ), 0 )
           as abap.curr(23,2)
      )                                             as finalclosingVal,



      ////////      Purchase Inward
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum(case
        when A.GoodsMovementType = '561'
        then A.MatlStkChangeQtyInBaseUnit  end )    as stock_qty,


      ////////      Purchase Inward
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum(case
        when A.GoodsMovementType = '101'
             or A.GoodsMovementType = '102'
             or A.GoodsMovementType = '561'
             or A.GoodsMovementType = '562'
        then A.MatlStkChangeQtyInBaseUnit  end )    as recpt_purchqty,


      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(
      case
      when A.GoodsMovementType = '101'
      or A.GoodsMovementType = '102'
      or A.GoodsMovementType = '561'
      or A.GoodsMovementType = '562'
      then   A.GoodsMovementStkAmtInCCCrcy end )    as recpt_purchval,

      //////      Sales Outward
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum(
      case
      when A.GoodsMovementType = '601'
      or A.GoodsMovementType = '602'
      then A.MatlStkChangeQtyInBaseUnit   end )     as issue_salesqty,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(
      case
      when A.GoodsMovementType = '601'
      or A.GoodsMovementType = '602'
      then A.GoodsMovementStkAmtInCCCrcy end )      as issue_salesval,

      //////      STO Inward
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum(
      case
      when A.IsConsumptionMovement <> 'X' and A.GoodsMovementType = '641' or A.GoodsMovementType = '642'
      then A.MatlStkChangeQtyInBaseUnit   end )     as recpt_transfqty,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(
      case
      when A.IsConsumptionMovement <> 'X' and A.GoodsMovementType = '641' or A.GoodsMovementType = '642'
      then A.GoodsMovementStkAmtInCCCrcy end  )     as recpt_transfval,

      //////       STO Outward
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum(
      case
      when A.IsConsumptionMovement = 'X' and A.GoodsMovementType = '641' or A.GoodsMovementType = '642'
      then A.MatlStkChangeQtyInBaseUnit end )       as issue_transfqty,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(
       case
       when A.IsConsumptionMovement = 'X' and A.GoodsMovementType = '641' or A.GoodsMovementType = '642'
       then A.GoodsMovementStkAmtInCCCrcy end  )    as issue_transfval,


      //////      other Inwards
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum( case
      when  A.GoodsMovementType = '651' or A.GoodsMovementType = '652' or A.GoodsMovementType = '653'
      or A.GoodsMovementType = '654' or A.GoodsMovementType = '655' or A.GoodsMovementType = '656' or A.GoodsMovementType = '657'
      or A.GoodsMovementType = '658'
      then A.MatlStkChangeQtyInBaseUnit end    )    as qty_oth_recvgoods,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'

      sum(case
      when  A.GoodsMovementType = '651' or A.GoodsMovementType = '652' or A.GoodsMovementType = '653'
      or A.GoodsMovementType = '654' or A.GoodsMovementType = '655' or A.GoodsMovementType = '656' or A.GoodsMovementType = '657'
      or A.GoodsMovementType = '658'
      then A.GoodsMovementStkAmtInCCCrcy end    )   as val_oth_recvgoods,

      //////      Other Outwards
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum( case
       when A.GoodsMovementType = '161' or A.GoodsMovementType = '162'
       or A.GoodsMovementType = '122' or A.GoodsMovementType = '123'
       then A.MatlStkChangeQtyInBaseUnit end  )     as qty_oth_issuegoods,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum( case
       when A.GoodsMovementType = '161' or A.GoodsMovementType = '162'
       or A.GoodsMovementType = '122' or A.GoodsMovementType = '123'
       then A.GoodsMovementStkAmtInCCCrcy end )     as val_oth_issuegoods,


      //////      Physical Adjustment Inwards
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum(case
      when A.GoodsMovementType = '701'
      then A.MatlStkChangeQtyInBaseUnit end     )   as qty_adj_inword,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(case
      when A.GoodsMovementType = '701'
      then A.GoodsMovementStkAmtInCCCrcy end      ) as val_adj_inword,

      ////      Physical Adjustment Outwards
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum( case
       when A.GoodsMovementType = '702'
       then A.MatlStkChangeQtyInBaseUnit end     )  as qty_adj_outword,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum( case
       when A.GoodsMovementType = '702'
       then A.GoodsMovementStkAmtInCCCrcy end    )  as val_adj_outword

}
where
  A.PostingDate between $parameters.P_StartDate and $parameters.P_EndDate
//where
//      A.PostingDate >= $parameters.P_StartDate
//  and A.PostingDate <= $parameters.P_EndDate

group by
  A.Plant,
  A.StorageLocation,
  A.Material,
  B.ProductDescription,
  A.CompanyCode,
  A.ProfitCenter,
  A.MaterialType,
  //  A.IsConsumptionMovement,
  e.OpeningQty,
  e.OpeningVal,
  f.closingVal,
  f.closingQty,
  //  a.GoodsMovementType,
  A.MaterialGroup,
  A.MaterialBaseUnit,
  A.CompanyCodeCurrency
