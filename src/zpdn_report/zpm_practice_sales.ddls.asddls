@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZPM_Practice_Sales as select from I_SalesDocumentItem as SDI
   inner join I_SalesDocument as SDH on SDH.SalesDocument = SDI.SalesDocument
    
{
 key SDH.SalesDocument as Sales,
key SDI.SalesDocumentItem as item,
 SDH.SDDocumentCategory as catg,
 SDH.SalesDocumentType as type,
 SDH.SalesDocumentProcessingType as sdp

 
}
