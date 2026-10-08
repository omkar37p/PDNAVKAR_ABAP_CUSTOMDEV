@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define root view entity Z_MM_SUPPLIER_REPORET_PRV 
provider contract transactional_query
as projection on Z_MM_SUPPLIER_REPORET
{   
   // key SOURCE_ID,
     
    key PARTNER,
    key TYPE,
    key IDNUMBER,
    Name,
    INSTITUTE,
    ENTRY_DATE,
    VALID_DATE_FROM,
    VALID_DATE_TO,
    Country,
    Region
}
