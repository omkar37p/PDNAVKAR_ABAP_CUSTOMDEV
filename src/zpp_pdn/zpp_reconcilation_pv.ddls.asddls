@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View Reconcilation'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZPP_RECONCILATION_PV provider contract transactional_query as projection on ZSD_RECONCILATION_REV
{
key GRNNo,
key MaterialNo,
key BatchNo,
key plant1,
FGPRODUCT,
Materialnofororder,
ManufacturingOrderID,
ItemName,
GRNBatchID,
umo,
 @Semantics.quantity.unitOfMeasure:'umo'
issueQuantity,
GRNDate,
@Semantics.quantity.unitOfMeasure:'umo'
GRNqty
}
