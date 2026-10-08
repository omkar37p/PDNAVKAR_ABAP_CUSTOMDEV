@AbapCatalog.sqlViewName: 'Z_JOURNAL_ENTRY'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Journal entry without cancellation doc'
define view ZZFI_JOURNAL_ENTRY as select from I_JournalEntry as JEH
{
    key CompanyCode,
    key FiscalYear,
    key AccountingDocument,
        DocumentReferenceID,
        DocumentDate,
        AccountingDocumentType
}
  where JEH.ReverseDocument is initial and JEH.IsReversal is initial and JEH.IsReversed is initial 
        and (JEH.AccountingDocumentType = 'RE' 
        or JEH.AccountingDocumentType = 'SA' 
        or JEH.AccountingDocumentType = 'KG' 
        or JEH.AccountingDocumentType = 'KR');   // change by omkar 04.07.2024
