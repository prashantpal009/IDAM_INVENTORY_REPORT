@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zcds_mmr01_001'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_mmr01_001
  with parameters
    P_StartDate : zdats,
    P_EndDate   : zdats_end
  as select from    ZCDS_MMR01_REPORT(
                         P_StartDate: $parameters.P_StartDate,
                         P_EndDate  : $parameters.P_EndDate ) as A

    left outer join I_OperationalAcctgDocItem                 as c on  c.Product                      = A.Material
                                                                   and c.CompanyCode                  = A.CompanyCode
                                                                   and c.ProfitCenter                 = A.ProfitCenter
                                                                   and c.AccountingDocumentType       = 'RE'
                                                                   and c.TransactionTypeDetermination = 'BSX'
                                                                   and c.ReferenceDocumentType        = 'RMRP'

    left outer join I_OperationalAcctgDocItem                 as D on  c.Product                      = A.Material
                                                                   and c.CompanyCode                  = A.CompanyCode
                                                                   and c.ProfitCenter                 = A.ProfitCenter
                                                                   and c.AccountingDocumentType       = 'PR'
                                                                   and c.TransactionTypeDetermination = 'BSX'
                                                                   and c.ReferenceDocumentType        = 'PRCHG'

{

  key A.Plant,
  key A.StorageLocation,
  key A.Material,
  key A.ProfitCenter,
  key A.CompanyCode,
      A.CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum( case
       when c.DebitCreditCode = 'S' then
       c.AmountInCompanyCodeCurrency end     ) as Debit_Revaluation,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(c.AmountInCompanyCodeCurrency     )  as VAL_PERIOD1,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum( case
       when  c.DebitCreditCode = 'H' then
       c.AmountInCompanyCodeCurrency end   )   as Cebit_Revaluation,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum( D.AmountInCompanyCodeCurrency)      as VAL_PERIOD2

}

group by
  A.Plant,
  A.StorageLocation,
  A.Material,
  A.CompanyCode,
  A.ProfitCenter,
  A.CompanyCodeCurrency
