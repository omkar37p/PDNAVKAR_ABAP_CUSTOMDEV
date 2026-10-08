@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ageing Report2 - Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZFI_SUPPLIER_AGING_PV
  provider contract transactional_query
  as projection on ZFI_SUPPLIER_AGING_REV
{
  key AccountingDocument,
    key CompanyCode,
    key FiscalYear,
    Plant,
    TransactionSite,
    PartyCode,
    PartyDescription,
    PartyCategory,
    PartyState,
    GSTINNo,
    PaymentHoldasPerMaster,
    PaymentHoldRemarks,
    PartyCreditDays,
    PaymentTerms,
    AccountingDocumentType,
    costCenter,
    CostCenterDescription,
    VoucherDate,
    SupInvorCustomerPOsNo,
    SupInvDateorCusPODt,
    InvoiceDuedate,
    curr,
   // ExchangeRate,
    @Semantics.amount.currencyCode: 'curr'
    OriAmtForeignCur,
    @Semantics.amount.currencyCode: 'curr'
    OriAmtDomCur,
    @Semantics.amount.currencyCode: 'curr'
    LCDomCur,
//    @Semantics.amount.currencyCode: 'curr'
    DueDays,
    @Semantics.amount.currencyCode: 'curr'
    LCAmt30,
    @Semantics.amount.currencyCode: 'curr'
    Fcamt30,
    @Semantics.amount.currencyCode: 'curr'
    LCamt60,
    @Semantics.amount.currencyCode: 'curr'
    FCamt60,
    @Semantics.amount.currencyCode: 'curr'
    LCamt90,
    @Semantics.amount.currencyCode: 'curr'
    FCamt90,
    @Semantics.amount.currencyCode: 'curr'
    LCamt120,
    @Semantics.amount.currencyCode: 'curr'
    FCamt120,
    @Semantics.amount.currencyCode: 'curr'
    LCamt150,
    @Semantics.amount.currencyCode: 'curr'
    FCamt150,
    @Semantics.amount.currencyCode: 'curr'
    LCamt180,
    @Semantics.amount.currencyCode: 'curr'
    FCamt180,
    @Semantics.amount.currencyCode: 'curr'
    DueamtFC,
    @Semantics.amount.currencyCode: 'curr'
    DueamtlC,
    
    HeaderNarration,
    VoucherCreatedBy,
    ProfitCenter,
    SpecialGLCode,
    paymentHold,
    purchaseOrder,
    AccCatoDec,
    @Semantics.amount.currencyCode: 'curr'
    DueInCCOdeCurr,
    MSMEvidenti,
    SRefDocID,
    AssignmentNumber,
    ChartsOfAccounts,
    FinAccountType,
    ClearingDates,
    TransactionCurrency,
    GRNo,
    ReconACName,
    ClearingJournalEntryNumber,
    @Semantics.amount.currencyCode: 'curr'
    Withholdingtaxexempt,
    GLACCODE,
    GLACNAME,
    ACCOUNTINGDOCJE,
    NetDueInterval,
    @Semantics.amount.currencyCode: 'curr'
    WHTBA,
    RefDocType,
    AccountGroup,
    AccountingClerk,
    ReconACCode,
    SalesReturnedItem,
    ItemCode,
    SectionCode,
    PlaceOfSupply,
    AsgnmntNumber,
    ExchangeRateType

}
