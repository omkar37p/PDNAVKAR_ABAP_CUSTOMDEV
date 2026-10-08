@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Delivery Document View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zsd_delivery_v as select from I_DeliveryDocumentItem
{
  key DeliveryDocument,
  key DeliveryDocumentItem,
  ReferenceSDDocument,
  ReferenceSDDocumentItem,
  Batch,
  BaseUnit,
  @Semantics.quantity.unitOfMeasure: 'BaseUnit'
  ActualDeliveryQuantity ,
  @Semantics.quantity.unitOfMeasure: 'BaseUnit'
  OriginalDeliveryQuantity  
  
  
  
}

