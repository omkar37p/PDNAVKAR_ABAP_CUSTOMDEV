@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root entity view eta report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zmm_eta__REV as
 select from I_PurchaseOrderItemAPI01 as POI  
inner join I_PurchaseOrderAPI01  as POH  on POH.PurchaseOrder = POI.PurchaseOrder 
                                             
inner join I_Supplier as supp on supp.Supplier = POH.Supplier
left outer join I_PurchaseOrderHistoryAPI01 as pohis on pohis.PurchaseOrder = POI.PurchaseOrder
                                                        and pohis.PurchaseOrderItem = POI.PurchaseOrderItem
{
    key POI.PurchaseOrder as PONUM,
    key POI.PurchaseOrderItem as lineitem, 
    key POH.PurchaseOrderDate as PODT,
    key POI.Plant as PLANT,
    key POH.PurchaseOrderType as POTYPE,
    key POI.PurchaseOrderItemText as POITMTXT,
    key POH.Supplier as SUPP,
    POH.YY1_APPROXETAPLANT_PDH  as APPROXETAPLANT,
    POH.YY1_BE_MM_PDH as BE,
    POH.YY1_BL_LR_NO_PDH as BLLRNO,
    POH.YY1_CHA_INV_PDH as CHAINV,
    POH.YY1_CHA_PDH as CHA,
    POH.YY1_CHECK_LIST_PDH as CHKLST,
    POH.YY1_DRAFT_DOCUMENT_PDH as DRAFTDOC,
    POH.YY1_DUTY_PAYMENT_PDH as DUTYPAY,
    POH.YY1_FSSAI_PAYMENT_PDH as FASSIPAY,
    POH.YY1_LABEL_PDH as ZLABEL,
    POH.YY1_LINER_PAYMENT_PDH as LINERPAY,
    POH.YY1_MISC_PDH as MISC,
    POH.YY1_ORIGINALDOC_PDH as ORGDOC,
    POH.YY1_PAYMENT_PDH as PAY,
    POH.YY1_REMARKS_PDH as ZREAMAK,
    POH.YY1_SUPPPAYMENT_PDH as SUPPPAY,
    POH.YY1_TELEXBL_PDH as TELEXBL,
    POH.YY1_TRNSP_CD_PDH as TRNSP,
    POH.YY1_BL_LR_DATE_PDH as BLLRDT,
    POH.YY1_ETA_PORT_PDH as PORTDT,
    POH.YY1_PORT_NAME_PDH as PORTNAME,
    POI.DocumentCurrency as ZDOCCURRY,
    @Semantics.amount.currencyCode: 'ZDOCCURRY'
    POI.NetPriceAmount as NETAMT,
    POI.OrderPriceUnit as ORDUNIT,
    @Semantics.quantity.unitOfMeasure: 'ORDUNIT'
    POI.OrderQuantity as ORDQTY,
    supp.SupplierFullName as SUPPNAME,
    pohis.PurchaseOrderQuantityUnit as QTYUNIT,
    @Semantics.quantity.unitOfMeasure: 'QTYUNIT'    
    pohis.Quantity as QTY,
    @Semantics.quantity.unitOfMeasure: 'QTYUNIT'
    min(POI.OrderQuantity - pohis.Quantity) as PendingQty
    
}

//where POH.PurchaseOrder = '2000000157'
group by
    POI.PurchaseOrder,
    POI.PurchaseOrderItem,
    POH.PurchaseOrderDate,
    POI.Plant,
    POH.PurchaseOrderType,
    POI.PurchaseOrderItemText,
    POH.Supplier,
    POH.YY1_APPROXETAPLANT_PDH,
    POH.YY1_BE_MM_PDH,
    POH.YY1_BL_LR_NO_PDH,
    POH.YY1_CHA_INV_PDH,
    POH.YY1_CHA_PDH,
    POH.YY1_CHECK_LIST_PDH,
    POH.YY1_DRAFT_DOCUMENT_PDH,
    POH.YY1_DUTY_PAYMENT_PDH,
    POH.YY1_FSSAI_PAYMENT_PDH,
    POH.YY1_LABEL_PDH,
    POH.YY1_LINER_PAYMENT_PDH,
    POH.YY1_MISC_PDH,
    POH.YY1_ORIGINALDOC_PDH,
    POH.YY1_PAYMENT_PDH,
    POH.YY1_REMARKS_PDH,
    POH.YY1_SUPPPAYMENT_PDH,
    POH.YY1_TELEXBL_PDH,
    POH.YY1_TRNSP_CD_PDH,
    POH.YY1_BL_LR_DATE_PDH,
    POH.YY1_ETA_PORT_PDH,
    POH.YY1_PORT_NAME_PDH,
    POI.DocumentCurrency,
    POI.NetPriceAmount,
    POI.OrderPriceUnit,
    POI.OrderQuantity,
    supp.SupplierFullName,
    pohis.PurchaseOrderQuantityUnit,
    pohis.Quantity
   

