@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Batch Char Data - Root Projection'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZBATCHAR_API_RPV01
  provider contract transactional_query
  as projection on ZBATCHAR_API_RV01
{ 
 key Batch_Code,
 key Product,
 PLANT_,
 Description,
 UOM,
  @Semantics.quantity.unitOfMeasure: 'UOM' 
 gross_qty,
  @Semantics.quantity.unitOfMeasure: 'UOM' 
 net_weight,
 mfgdate,
 expdate,
 @Semantics.quantity.unitOfMeasure: 'UOM' 
 batch_size,
 @Semantics.quantity.unitOfMeasure: 'UOM' 
 base_qty,
 Gross_weight
 
}
