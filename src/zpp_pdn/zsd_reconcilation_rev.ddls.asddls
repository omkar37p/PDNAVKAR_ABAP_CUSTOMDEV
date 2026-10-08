@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity - Reconcilation Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZSD_RECONCILATION_REV
 as select from I_MaterialDocumentHeader_2 as MDH
 left outer join I_MaterialDocumentItem_2 as ukb on ukb.MaterialDocument = MDH.MaterialDocument
inner join I_ManufacturingOrder as uki on uki.ManufacturingOrder = ukb.OrderID 
left outer join I_ProductDescription as ukm on ukm.Product = ukb.Material
{
    key MDH.MaterialDocument as GRNNo,
    key ukb.Material as MaterialNo,
    key uki.Batch as BatchNo,
    key ukb.Plant as plant1,
    uki.ManufacturingOrderText as FGPRODUCT,
    uki.Material as Materialnofororder,
    uki.ManufacturingOrder as ManufacturingOrderID,
    ukm.ProductDescription as ItemName,
    ukb.Batch as GRNBatchID,
    ukb.MaterialBaseUnit as umo,
    @Semantics.quantity.unitOfMeasure:'umo'
    ukb.QuantityInBaseUnit as issueQuantity,
    MDH.DocumentDate as GRNDate,
    @Semantics.quantity.unitOfMeasure:'umo'
    ukb.QuantityInEntryUnit as GRNqty
    
    
    
    
} where ukb.GoodsMovementType = '261'
