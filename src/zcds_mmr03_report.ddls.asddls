@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zcds_mmr03_report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@UI.headerInfo: {
    typeName: 'Inventory Register Report',
    typeNamePlural: 'Inventory Register Report'
}
define view entity zcds_mmr03_report
  with parameters
    P_StartDate : zdats,
    P_EndDate   : zdats_end
  as select from   zcds_mmr01_002
                 (
                 P_StartDate: $parameters.P_StartDate,
                 P_EndDate  : $parameters.P_EndDate )
{
      @UI.lineItem: [{ position: 10 , label: 'Plant' }]
      @UI.selectionField: [ { position: 10 } ]
      @EndUserText.label: 'Plant'
  key Plant,
      @UI.lineItem: [{ position: 20 , label: 'Storage Location' }]
      @UI.selectionField: [ { position: 20 } ]
      @EndUserText.label: 'Storage Location'
  key StorageLocation,
      @UI.lineItem: [{ position: 30 , label: 'Material' }]
      @UI.selectionField: [ { position: 30 } ]
      @EndUserText.label: 'Material'
  key Material,
      @UI.lineItem: [{ position: 40 , label: 'CompanyCode' }]
  key CompanyCode,
   @UI.lineItem: [{ position: 41 , label: 'ProfitCenter' }]
   key ProfitCenter,
//      @UI.lineItem: [{ position: 41 , label: 'PostingDate' }]
      //  key PostingDate,
     @UI.lineItem: [{ position: 42 , label: 'Material Description' }]
      ProductDescription,

      @UI.hidden: true
      CompanyCodeCurrency,

      @UI.lineItem: [{ position: 44 , label: 'Base Unit of Measure' }]
      MaterialBaseUnit,

      //*******************************Opening Stock*******************************//


      @UI.lineItem: [{ position: 45 , label: 'Stock Quantity on Period Start' }]
      OpeningQty,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @UI.lineItem: [{ position: 46 , label: 'Value on Period Start' }]
      OpeningVal,


      //*******************************Total Inward*******************************//
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI.lineItem: [{ position: 47 , label: 'Total Goods Receipt Quantity' }]
       tot_goods_rec_qty,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @UI.lineItem: [{ position: 48 , label: 'Total Goods Receipt Value' }]
       tot_goods_rec_val,

      //*******************************Total outward*******************************//

      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI.lineItem: [{ position: 49 , label: 'Total Goods Issue Quantity' }]
      tot_goods_issue_qty,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @UI.lineItem: [{ position: 50 , label: 'Total Goods Issue Value' }]
     tot_goods_issue_val,

      //*******************************Closing Stock*******************************//

      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI.lineItem: [{ position: 50.1 , label: 'Stock Quantity on Period End' }]
      finalclosingQty,
      //
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @UI.lineItem: [{ position: 50 , label: 'Stock Value on Period End' }]
      FinalclosingVal,
      //*******************************Purchase Inward*******************************//
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI.lineItem: [{ position: 51 , label: 'Receipt From Purchase Quantity' }]
      recpt_purchqty                                                              as recpt_purchqty,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @UI.lineItem: [{ position: 52 , label: 'Receipt From Purchase Value' }]
      recpt_purchval                                                              as recpt_purchval,

      //*******************************Sales Outward*******************************//
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI.lineItem: [{ position: 53 , label: 'Issue To Sales Quantity' }]
      issue_salesqty                                                              as issue_salesqty,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @UI.lineItem: [{ position: 54 , label: 'Issue To Sales Value' }]
      issue_salesval                                                             as issue_salesval,

      //*******************************STO Inward*******************************//
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI.lineItem: [{ position: 55 , label: 'Receipt From Transfer Quantity' }]
       recpt_transfqty                                                           as recpt_transfqty,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @UI.lineItem: [{ position: 56, label: 'Receipt From Transfer Value' }]
      recpt_transfval                                                            as recpt_transfval,

      //*******************************STO Outward*******************************//
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI.lineItem: [{ position: 57 , label: 'Issue To Transfer Quantity' }]
      issue_transfqty                                                             as issue_transfqty,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @UI.lineItem: [{ position: 50 , label: 'Issue To Transfer Value' }]
      issue_transfval                                                            as issue_transfval,
      //*******************************Other Inwards*******************************//
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI.lineItem: [{ position: 51 , label: 'Quantity of Other Received Goods' }]
     qty_oth_recvgoods                                                           as qty_oth_recvgoods,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @UI.lineItem: [{ position: 52 , label: 'Value of Other Received Goods' }]
      val_oth_recvgoods                                                           as val_oth_recvgoods,
      //*******************************Other Outwards*******************************//
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI.lineItem: [{ position: 53 , label: 'Quantity of Other Issued Goods' }]
      qty_oth_issuegoods                                                         as qty_oth_issuegoods,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @UI.lineItem: [{ position: 54 , label: 'Value of Other Issued Goods' }]
      val_oth_issuegoods                                                         as val_oth_issuegoods,
      //*******************************Physical Adjustment Inwards*******************************//
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI.lineItem: [{ position: 55 , label: 'Quantity Adjustment Inwards' }]
      qty_adj_inword                                                             as qty_adj_inword,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @UI.lineItem: [{ position: 56 , label: 'Value Adjustment Inwards' }]
      val_adj_inword                                                              as val_adj_inword,

      //*******************************Physical Adjustment outwards*******************************//
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI.lineItem: [{ position: 57 , label: 'Quantity Adjustment Outwards' }]
      qty_adj_outword                                                            as qty_adj_outword,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @UI.lineItem: [{ position: 58 , label: 'Value Adjustment Outwards' }]
      val_adj_outword                                                            as val_adj_outword,
      //*******************************Change in COGS*******************************//
      @UI.lineItem: [{ position: 59 , label: 'Debit Revaluation' }]
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      Debit_Revaluation                                                           as Debit_Revaluation,
      @UI.lineItem: [{ position: 60 , label: 'Credit Revaluation' }]
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      Cebit_Revaluation                                                          as Cebit_Revaluation


}

where StorageLocation <> ' ';
