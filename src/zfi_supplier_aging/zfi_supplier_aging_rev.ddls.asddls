@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ageing Report2 - Root Entity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZFI_SUPPLIER_AGING_REV as select from I_JournalEntry              as JEH
left outer join         I_JournalEntryItem          as JEI   on JEI.AccountingDocument  = JEH.AccountingDocument and JEI.FiscalYear = JEH.FiscalYear  and JEI.CompanyCode = JEH.CompanyCode  and JEI.Ledger = '0L'  and JEI.AccountingDocumentItem = '001'
left outer join         I_JournalEntryItem          as JEI1  on JEI1.AccountingDocument = JEH.AccountingDocument and JEI1.FiscalYear = JEH.FiscalYear and JEI1.CompanyCode = JEH.CompanyCode and JEI1.Ledger = '0L' and JEI1.AccountingDocumentItem = '002' and JEI1.AccountingDocumentType = 'KZ' 
left outer join         I_JournalEntryItem          as JEI2  on JEI2.AccountingDocument = JEH.AccountingDocument and JEI2.FiscalYear = JEH.FiscalYear and JEI2.CompanyCode = JEH.CompanyCode and JEI2.Ledger = '0L' and JEI2.AccountingDocumentItem = '002'  
left outer join         I_GLAccountLineItem         as GLi   on GLi.AccountingDocument  = JEI.AccountingDocument and GLi.FiscalYear = JEH.FiscalYear  and GLi.CompanyCode = JEH.CompanyCode  and GLi.Ledger = '0L'  and GLi.LedgerGLLineItem = '000002'
left outer join         I_Supplier                  as supp  on supp.Supplier           = JEI.Supplier
left outer join         I_Supplier                  as supp1 on supp1.Supplier          = JEI1.Supplier
left outer join         I_SupplierInvoiceAPI01      as Sinv  on Sinv.InvoicingParty     = JEI.Supplier   and Sinv.FiscalYear = JEH.FiscalYear and Sinv.CompanyCode = JEH.CompanyCode and Sinv.SupplierInvoiceIDByInvcgParty = JEH.DocumentReferenceID
                                                                and Sinv.SupplierInvoiceWthnFiscalYear = JEH.OriginalReferenceDocument
left outer join         I_CostCenterText            as Ctxt  on Ctxt.CostCenter         = JEI.CostCenter and Ctxt.Language = 'E'
left outer join         I_BillingDocument           as BDH   on BDH.AccountingDocument  = JEH.AccountingDocument and BDH.FiscalYear = JEH.FiscalYear and BDH.CompanyCode = JEH.CompanyCode
left outer join         I_OperationalAcctgDocItem   as OPDI  on OPDI.AccountingDocument = JEH.AccountingDocument and OPDI.CompanyCode = JEH.CompanyCode and OPDI.FiscalYear = JEH.FiscalYear and OPDI.AccountingDocumentItem = '002'
//left outer join         I_CostCenter                as Cost  on Cost.CostCenter         = jei2.CostCenter
//left outer join         I_AccountingDocumentJournal as ADJ   on ADJ.AccountingDocument = jeh.AccountingDocument and adj.FiscalYear = jeh.FiscalYear and adj.CompanyCode = JEH.CompanyCode and adj.Ledger = '0L' and adj.AccountingDocumentItem = '001' and adj.P_Language = 'EN'
left outer join         I_Plant                     as plnt  on plnt.Plant              = JEI.Plant                                               
left outer join         I_PurchaseOrderItemAPI01    as poi   on poi.PurchaseOrder       = OPDI.PurchasingDocument and poi.PurchaseOrderItem = OPDI.PurchasingDocumentItem 
left outer join        I_AcctAssignmentCategoryText as ACtxt on ACtxt.AccountAssignmentCategory = poi.AccountAssignmentCategory and ACtxt.Language = 'E'
left outer join         I_SupplierCompany           as Supco on Supco.Supplier          = supp.Supplier and Supco.CompanyCode = JEH.CompanyCode
left outer join         I_MaterialDocumentItem_2    as Mdoci on Mdoci.Supplier  = JEI1.Supplier
left outer join         I_GLAccountText             as GLAT  on GLAT.GLAccount  = JEI.GLAccount 
left outer join         I_GLAccountInChartOfAccounts as GLAICOA on GLAICOA.GLAccount = GLAT.GLAccount
left outer join         I_AccountingClerk           as AC    on AC.CompanyCode  = GLi.CompanyCode
left outer join         I_SalesDocumentItem         as SDI   on SDI.SDDocumentCategory = BDH.SDDocumentCategory
//left outer join         I_ExchangeRate              as ER    on ER.ExchangeRate  = JEH.ExchangeRate
left outer join         I_BillOfExchange            as BOE   on BOE.AccountingDocument  = JEI.AccountingDocument
 

//left outer join         I_GLAccountInChartOfAccounts as GLATICOA on GLATICOA.   
{
key JEH.AccountingDocument,          //as VoucherNumber ,
key JEH.CompanyCode ,//                as CompanyCode,
key JEH.FiscalYear,
JEI.Plant                         as Plant,
plnt.PlantName                     as TransactionSite,

case 
when JEH.AccountingDocumentType <> 'KZ'
then JEI.Supplier  
else JEI1.Supplier
end                                 as PartyCode,

case 
when JEH.AccountingDocumentType <> 'KZ'
then supp.SupplierFullName
else supp1.SupplierFullName
end                                 as PartyDescription,

case
when JEH.AccountingDocumentType <> 'KZ'
then supp.SupplierAccountGroup      
else supp1.SupplierAccountGroup 
end                                 as PartyCategory,

case
when JEH.AccountingDocumentType <> 'KZ'
then supp.Region  
else supp1.Region  
end                                 as PartyState,

case 
when JEH.AccountingDocumentType <> 'KZ'
then supp.TaxNumber3
else supp1.TaxNumber3      
end                                 as GSTINNo,

case 
when JEH.AccountingDocumentType <> 'KZ'
then supp.PaymentIsBlockedForSupplier  
else supp1.PaymentIsBlockedForSupplier
end                                 as PaymentHoldasPerMaster, 

case 
when JEH.AccountingDocumentType <> 'KZ' 
then supp.PaymentReason   
else supp1.PaymentReason
end                                 as PaymentHoldRemarks,

Sinv.NetPaymentDays                 as PartyCreditDays,
Sinv.PaymentTerms ,
JEH.AccountingDocumentType ,
GLi.CostCenter                      as costCenter,
Ctxt.CostCenterName                 as CostCenterDescription,
JEH.AccountingDocumentCreationDate  as VoucherDate,
Sinv.SupplierInvoice                as SupInvorCustomerPOsNo,
JEI.DocumentDate                    as SupInvDateorCusPODt,
JEI.NetDueDate                      as InvoiceDuedate,
JEI.TransactionCurrency             as curr,
Sinv.ExchangeRate                   as ExchangeRate,
@Semantics.amount.currencyCode: 'Curr'
case 
when JEI.TransactionCurrency = 'USD' or JEI.TransactionCurrency = 'CNY'
                                     or JEI.TransactionCurrency = 'EUR'
                                     or JEI.TransactionCurrency = 'HKD'
                                     or JEI.TransactionCurrency = 'JPY' 
then JEI.AmountInTransactionCurrency 
else null 
end                                 as OriAmtForeignCur, 

@Semantics.amount.currencyCode: 'Curr'
case
when JEI.TransactionCurrency = 'INR'
then JEI.AmountInTransactionCurrency 
else null //JEI.AmountInCompanyCodeCurrency
end                                 as OriAmtDomCur,

@Semantics.amount.currencyCode: 'Curr'
case
when JEI.TransactionCurrency = 'INR'
then JEI.AmountInTransactionCurrency 
else JEI.AmountInCompanyCodeCurrency
end                                 as LCDomCur,
 
@Semantics.durationInDays: true
case 
when JEH.AccountingDocumentType <> 'KZ'
then cast( dats_days_between( JEI.DocumentDate, JEI.NetDueDate ) as abap.int4 ) 
else cast( dats_days_between( JEI1.DocumentDate, JEI1.NetDueDate ) as abap.int4 ) 
end                                 as DueDays,
//
@Semantics.amount.currencyCode: 'Curr'
case
when  cast( dats_days_between( JEI.DocumentDate, JEI.NetDueDate ) as abap.int4 )  <= 30 and JEI.TransactionCurrency = 'INR'
then JEI.AmountInTransactionCurrency
else null end                       as LCAmt30,

@Semantics.amount.currencyCode: 'Curr'
case
when  cast( dats_days_between( JEI.DocumentDate, JEI.NetDueDate ) as abap.int4 )  <= 30 and JEI.TransactionCurrency <> 'INR'
then JEI.AmountInTransactionCurrency
else null end                       as Fcamt30,

@Semantics.amount.currencyCode: 'Curr'
case
when cast( dats_days_between( JEI.DocumentDate, JEI.NetDueDate ) as abap.int4 )  >= 31 
     and cast( dats_days_between( JEI.DocumentDate, JEI.NetDueDate ) as abap.int4 )  <= 60 and JEI.TransactionCurrency = 'INR'
then JEI.AmountInTransactionCurrency
else null end                       as LCamt60,

@Semantics.amount.currencyCode: 'Curr'
case
when cast( dats_days_between( JEI.DocumentDate, JEI.NetDueDate ) as abap.int4 )  >= 31 
    and cast( dats_days_between( JEI.DocumentDate, JEI.NetDueDate ) as abap.int4 )  <= 60   and JEI.TransactionCurrency <> 'INR'
then JEI.AmountInTransactionCurrency
else null end                       as FCamt60,

@Semantics.amount.currencyCode: 'Curr'
case
when cast( dats_days_between( JEI.DocumentDate, JEI.NetDueDate ) as abap.int4 )  >= 61 
    and cast( dats_days_between( JEI.DocumentDate, JEI.NetDueDate ) as abap.int4 )  <= 90 and JEI.TransactionCurrency = 'INR'
then JEI.AmountInTransactionCurrency
else null end                       as LCamt90,

@Semantics.amount.currencyCode: 'Curr'
case
when  cast( dats_days_between( JEI.DocumentDate, JEI.NetDueDate ) as abap.int4 )  >= 61 
    and cast( dats_days_between( JEI.DocumentDate, JEI.NetDueDate ) as abap.int4 )  <= 90   and JEI.TransactionCurrency <> 'INR'
then JEI.AmountInTransactionCurrency
else null end                       as FCamt90,


@Semantics.amount.currencyCode: 'Curr'
case
when cast( dats_days_between( JEI.DocumentDate, JEI.NetDueDate ) as abap.int4 )  >= 91 
    and cast( dats_days_between( JEI.DocumentDate, JEI.NetDueDate ) as abap.int4 )  <= 120 and JEI.TransactionCurrency = 'INR'
then JEI.AmountInTransactionCurrency
else null end                       as LCamt120,

@Semantics.amount.currencyCode: 'Curr'
case
when cast( dats_days_between( JEI.DocumentDate, JEI.NetDueDate ) as abap.int4 )  >= 91 
    and cast( dats_days_between( JEI.DocumentDate, JEI.NetDueDate ) as abap.int4 )  <= 120  and JEI.TransactionCurrency <> 'INR'
then JEI.AmountInTransactionCurrency
else null end                       as FCamt120,

@Semantics.amount.currencyCode: 'Curr'
case
when cast( dats_days_between( JEI.DocumentDate, JEI.NetDueDate ) as abap.int4 )  >= 121 
    and cast( dats_days_between( JEI.DocumentDate, JEI.NetDueDate ) as abap.int4 )  <= 150 and JEI.TransactionCurrency = 'INR'
then JEI.AmountInTransactionCurrency
else null end                       as LCamt150,

@Semantics.amount.currencyCode: 'Curr'
case
when cast( dats_days_between( JEI.DocumentDate, JEI.NetDueDate ) as abap.int4 )  >= 121 
    and cast( dats_days_between( JEI.DocumentDate, JEI.NetDueDate ) as abap.int4 )  <= 150  and JEI.TransactionCurrency <> 'INR'
then JEI.AmountInTransactionCurrency
else null end                       as FCamt150,

@Semantics.amount.currencyCode: 'Curr'
case
when cast( dats_days_between( JEI.DocumentDate, JEI.NetDueDate ) as abap.int4 )  >= 151 
    and cast( dats_days_between( JEI.DocumentDate, JEI.NetDueDate ) as abap.int4 )  <= 180 and JEI.TransactionCurrency = 'INR'
then JEI.AmountInTransactionCurrency
else null end                       as LCamt180,


@Semantics.amount.currencyCode: 'Curr'
case
when cast( dats_days_between( JEI.DocumentDate, JEI.NetDueDate ) as abap.int4 )  >= 151 
    and cast( dats_days_between( JEI.DocumentDate, JEI.NetDueDate ) as abap.int4 )  <= 180  and JEI.TransactionCurrency <> 'INR'
then JEI.AmountInTransactionCurrency
else null end                       as FCamt180,



//
//
//
//
//
//
@Semantics.amount.currencyCode: 'Curr'
case 
when JEI.TransactionCurrency <> 'INR'  
then JEI.AmountInTransactionCurrency 
else null end                       as DueamtFC, 

@Semantics.amount.currencyCode: 'Curr'
case
when JEI.TransactionCurrency = 'INR'
then JEI.AmountInTransactionCurrency 
else null
end                                 as DueamtlC,

BDH.DocumentReferenceID             as HeaderNarration,
JEH.AccountingDocCreatedByUser      as VoucherCreatedBy ,
JEI.ProfitCenter,
OPDI.SpecialGLCode,
OPDI.PaymentBlockingReason          as paymentHold,
OPDI.PurchasingDocument             as  purchaseOrder,
ACtxt.AcctAssignmentCategoryName    as AccCatoDec,
@Semantics.amount.currencyCode: 'Curr'
JEI.AmountInCompanyCodeCurrency     as DueInCCOdeCurr,
Supco.MinorityGroup                 as MSMEvidenti ,
JEH.DocumentReferenceID             as SRefDocID,
Sinv.AssignmentReference            as AssignmentNumber,
JEI.ChartOfAccounts                 as ChartsOfAccounts,
//OPDI.ClearingJournalEntry           as ClearingJournalEntryNumber
JEI.FinancialAccountType            as FinAccountType,
JEI.ClearingDate                    as ClearingDates,
OPDI.TransactionCurrency            as TransactionCurrency,
Mdoci.MaterialDocument              as GRNo,
Supco.ReconciliationAccount         as ReconACName,
OPDI.ClearingJournalEntry           as ClearingJournalEntryNumber,
@Semantics.amount.currencyCode: 'Curr'
OPDI.WithholdingTaxExemptionAmt     as Withholdingtaxexempt,
JEI.GLAccount                       as GLACCODE,
GLAT.GLAccountName                  as GLACNAME,
JEI.AccountingDocument              as ACCOUNTINGDOCJE,
OPDI.NetDueDate                     as NetDueInterval,
@Semantics.amount.currencyCode: 'Curr'
OPDI.WithholdingTaxBaseAmount       as WHTBA,
JEH.ReferenceDocumentType           as RefDocType,
GLAICOA.GLAccountGroup              as AccountGroup,
AC.AccountingClerk                  as AccountingClerk,
GLAICOA.BankReconciliationAccount   as ReconACCode,
SDI.IsReturnsItem                   as SalesReturnedItem,
Mdoci.Material                      as ItemCode,
BOE.BusinessSectionCode             as SectionCode,
OPDI.IN_GSTPlaceOfSupply            as PlaceOfSupply,
//@Semantics.amount.currencyCode: 'Curr'
//Sinv.ExchangeRate                    as ExchangeRates
GLi.AccountAssignmentNumber         as AsgnmntNumber,
JEH.ExchangeRateType                as ExchangeRateType

}
where ( JEH.AccountingDocumentType = 'RE' or
JEH.AccountingDocumentType = 'KR' or
JEH.AccountingDocumentType = 'KA' or
JEH.AccountingDocumentType = 'KG' or
JEH.AccountingDocumentType = 'UE' or
JEH.AccountingDocumentType = 'KZ' )
//and JEI.ClearingJournalEntry = '' ;
and JEI.ClearingJournalEntry <> '' ; 
