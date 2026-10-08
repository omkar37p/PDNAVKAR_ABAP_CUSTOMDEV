@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RootEntityView_SUPPLIER_REPORET'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity Z_MM_SUPPLIER_REPORET 
as select from       I_Supplier            as SUP 
          inner join I_BuPaIdentification  as BID      on BID.BusinessPartner  = SUP.Supplier  
                                                       
{
     
      
    
     key BID.BusinessPartner             as  PARTNER,
     
  // key SUP.Supplier                 as  SOURCE_ID,
    key BID.BPIdentificationType        as  TYPE,
    key BID.BPIdentificationNumber      as  IDNUMBER,
   SUP.SupplierName                as  Name,
    BID.BPIdnNmbrIssuingInstitute   as  INSTITUTE,
    BID.BPIdentificationEntryDate   as  ENTRY_DATE,
    BID.ValidityStartDate           as  VALID_DATE_FROM,
    BID.ValidityEndDate             as  VALID_DATE_TO,
    BID.Country                     as  Country,
    BID.Region                      as  Region
}
