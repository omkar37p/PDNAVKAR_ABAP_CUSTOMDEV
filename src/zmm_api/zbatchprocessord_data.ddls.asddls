@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View Entity for Process order'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZBATCHPROCESSORD_DATA as select from I_ManufacturingOrder as pr_ORD
{
key pr_ORD.ManufacturingOrder as processord,
    pr_ORD.Batch as BATCH,
    pr_ORD.Product as PRODUCT,
    pr_ORD.CreationDate as createdate,
    pr_ORD.ProductionUnit as UOM,
    @Semantics.quantity.unitOfMeasure: 'UOM' 
    pr_ORD.MfgOrderPlannedTotalQty as batch_size,     
    $session.system_date as currentdate,
    dats_add_days((cast($session.system_date as abap.dats )), -5, 'INITIAL') as cr_date
}
