@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Opening Stock Before Start Date'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_OPEN_STOCK
  with parameters p_startdate : abap.dats
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
      sum( MatlStkChangeQtyInBaseUnit )    as OpeningQty,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum( GoodsMovementStkAmtInCCCrcy )   as OpeningVal

}
where PostingDate < $parameters.p_startdate
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
