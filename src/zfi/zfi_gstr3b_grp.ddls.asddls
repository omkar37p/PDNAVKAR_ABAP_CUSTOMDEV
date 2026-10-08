@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gstr3b Report - Grouping'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_GSTR3B_GRP as select from ZZFI_JOURNAL_ENTRY as jeh
inner join I_JournalEntryItem as JEI on JEI.AccountingDocument = jeh.AccountingDocument and JEI.FiscalYear = jeh.FiscalYear
                                                              and JEI.Ledger='2L' and JEI.LedgerGLLineItem ='000001' and JEI.TaxCode<>''
      left outer join I_Supplier as SUP on SUP.Supplier = JEI.Supplier
      left outer join I_OperationalAcctgDocItem as ACI on ACI.AccountingDocument = JEI.AccountingDocument //CHANGE
                                               and ACI.FiscalYear = JEI.FiscalYear and (ACI.ProfitCenter <> '' or ACI.TransactionTypeDetermination = '')                                                                              
                                               and ACI.GLAccount <> '0000302400' 
                                               and ACI.TaxCode <> ' '
      left outer join I_OperationalAcctgDocItem as CGST on CGST.AccountingDocument = ACI.AccountingDocument
                                               and CGST.FiscalYear = ACI.FiscalYear and CGST.TaxItemGroup = ACI.TaxItemGroup
                                               and CGST.AccountingDocumentItemType = 'T'
                                               and CGST.TransactionTypeDetermination = 'JIC'                                              
      left outer join I_OperationalAcctgDocItem as IGST on IGST.AccountingDocument = ACI.AccountingDocument
                                               and IGST.FiscalYear = ACI.FiscalYear and IGST.TaxItemGroup = ACI.TaxItemGroup 
                                               and IGST.AccountingDocumentItemType = 'T'
                                               and IGST.TransactionTypeDetermination = 'JII' 
       left outer join I_OperationalAcctgDocItem as IGST1 on IGST1.AccountingDocument = ACI.AccountingDocument
                                               and IGST1.FiscalYear = ACI.FiscalYear and IGST1.TaxItemGroup = ACI.TaxItemGroup 
                                               and IGST1.AccountingDocumentItemType = 'T'
                                               and IGST1.TransactionTypeDetermination = 'JIM'
{
 key ACI.CompanyCode,
 key ACI.AccountingDocument,
 key ACI.FiscalYear,
 key ACI.TaxItemGroup,
 jeh.DocumentReferenceID ,
 jeh.DocumentDate,
 JEI.FiscalYearPeriod,
 ACI.PurchasingDocument,
ACI.PurchasingDocumentItem,
ACI.Product,
@EndUserText.label: 'OMKAR'
min(ACI.GLAccount) as GLAccount,
ACI.TaxCode,
ACI.IN_HSNOrSACCode,
@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
sum(ACI.AmountInCompanyCodeCurrency ) as AmountInCompanyCodeCurrency,
ACI.CompanyCodeCurrency,
@Semantics.amount.currencyCode: 'TransactionCurrency'
sum(ACI.AmountInTransactionCurrency) as AmountInTransactionCurrency,
ACI.TransactionCurrency,
ACI.PostingDate,
@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
CGST.AmountInCompanyCodeCurrency as CGST_C,
@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
IGST.AmountInCompanyCodeCurrency as IGST_C,
@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
IGST1.AmountInCompanyCodeCurrency as IGST1_C,
@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
CGST.AmountInTransactionCurrency as CGST_T,
CGST.TransactionTypeDetermination as TransactionTypeDetermination,
@Semantics.amount.currencyCode: 'TransactionCurrency'
IGST.AmountInTransactionCurrency as IGST_T,
@Semantics.amount.currencyCode: 'TransactionCurrency'
IGST1.AmountInTransactionCurrency as IGST1_T,
IGST.TransactionTypeDetermination as TransactionTypeDeterminationI,
IGST1.TransactionTypeDetermination as TransactionTypeDeterminationI1,
SUP.TaxNumber3,
SUP.SupplierName
}
group by
 ACI.CompanyCode,
  ACI.AccountingDocument,
  ACI.FiscalYear,
  ACI.TaxItemGroup,
 jeh.DocumentReferenceID,
  jeh.DocumentDate,
   JEI.FiscalYearPeriod,
   ACI.PurchasingDocument,
   ACI.PurchasingDocumentItem,
ACI.Product,
ACI.TaxCode,
ACI.IN_HSNOrSACCode,
ACI.CompanyCodeCurrency,
ACI.TransactionCurrency,
ACI.PostingDate,
CGST.AmountInCompanyCodeCurrency,
IGST.AmountInCompanyCodeCurrency,
IGST1.AmountInCompanyCodeCurrency ,
CGST.AmountInTransactionCurrency ,
CGST.TransactionTypeDetermination,
IGST.AmountInTransactionCurrency,
IGST1.AmountInTransactionCurrency,
IGST.TransactionTypeDetermination,
IGST1.TransactionTypeDetermination,
SUP.TaxNumber3,
SUP.SupplierName
