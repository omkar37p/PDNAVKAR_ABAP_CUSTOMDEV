@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity - GSTR1 Dispatch Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZSD_GSTR1_DT_RE as select from I_BillingDocumentBasic as bdh
inner join I_BillingDocumentItem as bdi on bdi.BillingDocument = bdh.BillingDocument  
left outer join I_ProductPlantBasic as pdb on pdb.Product = bdi.Product and pdb.Plant = bdi.Plant
left outer join I_IN_ElectronicDocTransptRegn as eway on eway.ElectronicDocSourceKey = bdh.BillingDocument
left outer join I_BillingDocumentPartner as bdp on bdp.BillingDocument = bdh.BillingDocument and bdp.PartnerFunction = 'AG'
left outer join I_BillingDocumentPartner as btpp on btpp.BillingDocument = bdh.BillingDocument and btpp.PartnerFunction = 'RE'
left outer join I_BillingDocumentPartner as payy on payy.BillingDocument = bdh.BillingDocument and payy.PartnerFunction = 'RG'
left outer join I_Customer as stp on stp.Customer = bdp.Customer  // SOLD TO PARTY
left outer join I_Customer as btp on btp.Customer = btpp.Customer  // bill TO PARTY
left outer join I_Customer as pay on pay.Customer = payy.Customer  // payer
left outer join zsd_billg_doc_v as bdb on bdb.BillingDocument = bdh.BillingDocument
left outer join zsd_delivery_v as doi on doi.DeliveryDocument = bdi.ReferenceSDDocument and doi.DeliveryDocumentItem = bdi.ReferenceSDDocumentItem //and doi.Batch = bdi.Batch
left outer join I_BillingDocItemPartner as bdip on bdip.BillingDocument = bdi.BillingDocument and bdip.BillingDocumentItem = bdi.BillingDocumentItem and bdip.PartnerFunction = 'WE'
left outer join I_Customer as shp on shp.Customer = bdip.Customer
left outer join I_SalesDocument as sd on sd.SalesDocument = bdi.SalesDocument
left outer join ZSD_ALTERNATIVE_UOM_RE as uom on uom.product = bdi.Product
left outer join I_Supplier as sup on sup.Supplier = bdb.YY1_TransporterIDBP_BDH
left outer join I_IncotermsClassificationText as inco on inco.IncotermsClassification = bdh.IncotermsClassification and inco.Language = 'E'

{
key bdh.BillingDocument as billdoc,
key bdi.BillingDocumentItem as billitem,
bdh.DocumentReferenceID   as invoiceno,
bdh.BillingDocumentDate  as invoicedt,
pdb.ConsumptionTaxCtrlCode as hsncode,
bdi.BillingDocumentItemText as desct,
bdi.BaseUnit                 as uom,
@Semantics.quantity.unitOfMeasure: 'uom'
doi.ActualDeliveryQuantity     as billqty,
doi.Batch ,
stp.Customer as stpno,
stp.CustomerName as stpname,
btp.Customer as btpno,
btp.CustomerName as btpname,
pay.Customer as pyno,
pay.CustomerName as pyname,
shp.Customer as shpno,
shp.CustomerName as shpname,
shp.PostalCode as pin,
case when bdh.YY1_EWAYBill_No_SD_BDH is not initial
then
bdh.YY1_EWAYBill_No_SD_BDH
else
eway.IN_ElectronicDocEWbillNmbr  end  as ewayno,
eway.IN_EDocEWbillCreateDate as ewaydate,
bdb.YY1_LRNo_SD_BDH as lrno,
bdb.YY1_LRDate_SD_BDH as lrdt,
sd.PurchaseOrderByCustomer as pono,
bdb.YY1_TransporterIDBP_BDH  as transporterid,
bdb.YY1_TransporterIDS_BDH as sutprid,
sup.SupplierName as sfn,
bdb.YY1_DeliveryDate_BDH as deliv,
uom.unitofmeasurename as uomname,
@Semantics.amount.currencyCode: 'fcurr'
bdb.YY1_FreightPaidtoTrans_BDH as frightptt,
@Semantics.quantity.unitOfMeasure: 'uom'
doi.OriginalDeliveryQuantity as dgi,
//@Semantics.amount.currencyCode: 'fcurr'
//cast(cast(bdb.YY1_FreightPaidtoTrans_BDH as abap.dec(15,2 ) ) * doi.OriginalDeliveryQuantity as abap.dec( 15,2) )as frightptrtot,
//@Semantics.amount.currencyCode: 'fcurr'

//@Semantics.amount.currencyCode: 'fcurr'

//case 
//  when bdb.YY1_FreightPaidtoTrans_BDH is initial or doi.OriginalDeliveryQuantity is initial or bdb.YY1_FreightPaidtoTrans_BDH = 0 
//      or doi.ActualDeliveryQuantity = 0 
//    then cast( 0 as abap.dec(15,2) )
//  else 
//    cast(
//      cast(bdb.YY1_FreightPaidtoTrans_BDH as abap.dec(15,4)) * 
//      cast(doi.ActualDeliveryQuantity as abap.dec(15,4))
//      as abap.dec(15,2)
//    )
//end as frightptrtot,
//cast(coalesce(bdb.YY1_FreightPaidtoTrans_BDH,0) * coalesce(doi.OriginalDeliveryQuantity,0)as abap.dec(15, 3 ) ) as frightptrtot,
bdb.YY1_FreightPaidtoTrans_BDHC as fcurr,
@Semantics.amount.currencyCode: 'frcurr'
bdb.YY1_FreightRecfromCus_BDH as frightrfc,
//@Semantics.amount.currencyCode: 'frcurr'
//cast(
//    cast(bdb.YY1_FreightRecfromCus_BDH as abap.dec(15,2)) *
//    cast(coalesce(doi.OriginalDeliveryQuantity, 0) as abap.dec(15,3))
//    as abap.dec(15,2)
//) as frightrfctot,
//@Semantics.amount.currencyCode: 'fcurr'
//case 
//  when bdb.YY1_FreightRecfromCus_BDH is initial or doi.OriginalDeliveryQuantity is initial or bdb.YY1_FreightRecfromCus_BDH = 0 or 
//  doi.ActualDeliveryQuantity = 0
//    then cast( 0 as abap.dec(15,2) )
//  else
//    cast(
//      cast(bdb.YY1_FreightRecfromCus_BDH as abap.dec(15,4)) * 
//      cast(doi.ActualDeliveryQuantity as abap.dec(15,4))
//      as abap.dec(15,2)
//    )
//end as frightrfctot,
//cast(coalesce(bdb.YY1_FreightRecfromCus_BDH,0) * coalesce(doi.OriginalDeliveryQuantity,0)as abap.dec(15, 3 ) ) as frightrfctot, 
bdb.YY1_FreightRecfromCus_BDHC as frcurr,
inco.IncotermsClassificationName as inconame,
//@Semantics.amount.currencyCode: 'frcurr'
cast( coalesce(bdb.YY1_FreightRecfromCus_BDH, 0)  * coalesce(doi.OriginalDeliveryQuantity, 0)  as abap.dec(18, 3))  as frightrfctot,
//@Semantics.amount.currencyCode: 'fcurr'
cast(
    coalesce(bdb.YY1_FreightPaidtoTrans_BDH, 0) *
   coalesce(doi.ActualDeliveryQuantity, 0) as abap.dec(18, 3)
) as frightptrtot




    
} where bdh.BillingDocumentType = 'F2' and bdi.Batch is not initial ;
