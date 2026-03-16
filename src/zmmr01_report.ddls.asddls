@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZMMR01_REPORT'
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
define view entity ZMMR01_REPORT
  as select from ZMMR01_03
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
      //      @UI.lineItem: [{ position: 50 , label: 'Plant' }]

      @UI.hidden: true
      ProfitCenter,
      @UI.hidden: true
      MaterialType,
      //      @UI.hidden: true
      PostingDate,
      @UI.hidden: true
      MaterialGroup,

      @UI.hidden: true
      @UI.lineItem: [{ position: 60 , label: 'Product Description' }]
      ProductDescription,
      @UI.lineItem: [{ position: 70 , label: 'BaseUnit' }]
      BaseUnit,

      @UI.lineItem: [{ position: 80 , label: 'Stock Quantity on Period Start' }]
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      STOCK_QTY_PERIOD_START,

      CompanyCodeCurrency,

      @UI.lineItem: [{ position: 90 , label: 'Value on Period Start' }]
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      stock_val,

      @UI.lineItem: [{ position: 91 , label: 'Total Goods Issue Quantity' }]
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      tot_good_issueqty,

      @UI.lineItem: [{ position: 92 , label: 'Total Goods Issue Value' }]
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      tot_good_issueval,

      @UI.lineItem: [{ position: 93 , label: 'Total Goods Receipt Quantity' }]
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      tot_good_recptqty,

      @UI.lineItem: [{ position: 94 , label: 'Total Goods Receipt Value' }]
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      tot_good_recptval,

      @UI.lineItem: [{ position: 95 , label: 'Stock Quantity on Period End' }]
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      stock_qty_pend,

      @UI.lineItem: [{ position: 96 , label: 'Stock Value on Period End' }]
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      stock_val_pend,

      @UI.lineItem: [{ position: 160 , label: 'Receipt From Purchase Quantity' }]
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      recpt_purchqty,

      @UI.lineItem: [{ position: 170 , label: 'Receipt From Purchase Value' }]
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      recpt_purch_val,

      @UI.lineItem: [{ position: 180 , label: 'Issue To Sales Quantity' }]
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      issue_salesqty,

      @UI.lineItem: [{ position: 190 , label: 'Issue To Sales Value' }]
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      issue_salesval,

      @UI.lineItem: [{ position: 200 , label: 'Receipt From Transfer Quantity' }]
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      recpt_transfqty,

      @UI.lineItem: [{ position: 210 , label: 'Receipt From Transfer Value' }]
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      recpt_transfval,

      @UI.lineItem: [{ position: 220 , label: 'Issue To Transfer Quantity' }]
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      issue_transfqty,

      @UI.lineItem: [{ position: 230 , label: 'Issue To Transfer Value' }]
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      issue_transfval,

      @UI.lineItem: [{ position: 240 , label: 'Quantity of Other Received Goods' }]
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      qty_oth_recvgoods,

      @UI.lineItem: [{ position: 250 , label: 'Value of Other Received Goods' }]
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      val_oth_recvgoods,

      @UI.lineItem: [{ position: 260 , label: 'Quantity of Other Issued Goods' }]
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      qty_oth_issuegoods,

      @UI.lineItem: [{ position: 270 , label: 'Value of Other Issued Goods' }]
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      val_oth_issuegoods,

      @UI.lineItem: [{ position: 280 , label: 'Quantity Adjustment Outwards' }]
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      qty_adj_outword,

      @UI.lineItem: [{ position: 290 , label: 'Value Adjustment Outwards' }]
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      val_adj_outword,

      @UI.lineItem: [{ position: 300 , label: 'Debit Revaluation' }]
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      Debit_Revaluation,

      @UI.lineItem: [{ position: 310 , label: 'Credit Revaluation' }]
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      Cebit_Revaluation
}
