@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Exchange Rate'
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zex_rate
  as select from     I_JournalEntry            as JEH
    inner join       I_JournalEntryItem        as JEI    on  JEI.AccountingDocument =  JEH.AccountingDocument
                                                         and JEI.FiscalYear         =  JEH.FiscalYear
                                                         and JEI.Ledger             =  '2L'
                                                         and JEI.LedgerGLLineItem   =  '000001'
                                                         and JEI.TaxCode            <> ''
    right outer join I_OperationalAcctgDocItem as ACI    on  ACI.AccountingDocument =  JEI.AccountingDocument
                                                         and ACI.FiscalYear         =  JEI.FiscalYear
                                                         and ACI.ProfitCenter       <> ''
    left outer join  I_PurchaseOrderAPI01      as POH    on POH.PurchaseOrder = ACI.PurchasingDocument
    left outer join  I_ExchangeRateRawData     as ExRate on ExRate.ExchangeRateType = 'IMP'

{
  key ACI.DocumentDate              as documentDate,
      ExRate.ExchangeRateType,
      ExRate.SourceCurrency,
    //  ExRate.ExchangeRate           as ExchangeRate,
     // ExRate.ValidityStartDate   as SourceDate
      max(ExRate.ValidityStartDate) as SourceDate

}
where
      ExRate.ValidityStartDate        <  ACI.DocumentDate
  and ACI.ProfitCenter                <> ''
  and POH.PurchaseOrderType           <> 'ZSTO'
  and POH.PurchaseOrderType           <> 'ZSUB'
  and JEH.AccountingDocumentType      =  'RE'
  and ACI.AmountInTransactionCurrency <> 0.00
group by
  ACI.DocumentDate,
  ExRate.ExchangeRateType,
  ExRate.SourceCurrency
