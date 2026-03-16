@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Closing Stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_closing_stock 
  with parameters 
      p_startdate : abap.dats,
      p_enddate   : abap.dats
  as select from I_GoodsMovementCube
{
  key Material,
  key Plant,
  key StorageLocation,
  key CompanyCode,
      ProfitCenter,
      MaterialType,
      MaterialGroup,
      MaterialBaseUnit,
      CompanyCodeCurrency,

      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      sum( MatlStkChangeQtyInBaseUnit )    as closingQty,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum( GoodsMovementStkAmtInCCCrcy )   as closingVal
}
where PostingDate between $parameters.p_startdate and $parameters.p_enddate
group by
  Material,
  Plant,
  StorageLocation,
  CompanyCode,
  ProfitCenter,
  MaterialType,
  MaterialGroup,
  MaterialBaseUnit,
  CompanyCodeCurrency;
