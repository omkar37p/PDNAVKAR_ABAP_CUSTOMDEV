@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Commision Report - Root View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZSD_COMM_REN as select from I_BillingDocument as bdh
inner join I_BillingDocumentItem as bdi on bdi.BillingDocument = bdh.BillingDocument  
left outer join I_BillingDocumentItemPrcgElmnt as bnet on bnet.BillingDocument = bdi.BillingDocument and bnet.BillingDocumentItem = bdi.BillingDocumentItem and bnet.ConditionType = 'ZPRI'
left outer join I_BillingDocumentItemPrcgElmnt as bdipe on bdipe.BillingDocument = bdi.BillingDocument and bdipe.BillingDocumentItem = bdi.BillingDocumentItem and bdipe.ConditionType = 'ZCCC'
left outer join I_ProductPlantBasic as pdb on pdb.Product = bdi.Product and pdb.Plant = bdi.Plant
left outer join I_IN_ElectronicDocTransptRegn as eway on eway.ElectronicDocSourceKey = bdh.BillingDocument
left outer join I_BillingDocumentPartner as bdp on bdp.BillingDocument = bdh.BillingDocument and bdp.PartnerFunction = 'AG'
left outer join I_BillingDocumentPartner as btpp on btpp.BillingDocument = bdh.BillingDocument and btpp.PartnerFunction = 'RE'
left outer join I_BillingDocumentPartner as payy on payy.BillingDocument = bdh.BillingDocument and payy.PartnerFunction = 'RG'
left outer join I_BillingDocumentPartner as comm on comm.BillingDocument = bdh.BillingDocument and comm.PartnerFunction = 'Z2'
left outer join I_Customer as stp on stp.Customer = bdp.Customer  // SOLD TO PARTY
left outer join I_Customer as btp on btp.Customer = btpp.Customer  // bill TO PARTY
left outer join I_Customer as pay on pay.Customer = payy.Customer  // payer
left outer join I_Customer as com on com.Customer = comm.Customer // commision
left outer join zsd_billg_doc_v as bdb on bdb.BillingDocument = bdh.BillingDocument
left outer join zsd_delivery_v as doi on doi.DeliveryDocument = bdi.ReferenceSDDocument and doi.DeliveryDocumentItem = bdi.ReferenceSDDocumentItem //And doi.Batch = bdi.Batch
left outer join I_BillingDocItemPartner as bdip on bdip.BillingDocument = bdi.BillingDocument and bdip.BillingDocumentItem = bdi.BillingDocumentItem and bdip.PartnerFunction = 'WE'
left outer join I_Customer as shp on shp.Customer = bdip.Customer
left outer join I_SalesDocument as sd on sd.SalesDocument = bdi.SalesDocument
left outer join ZSD_ALTERNATIVE_UOM_RE as uom on uom.product = bdi.Product
left outer join I_Supplier as sup on sup.Supplier = bdb.YY1_TransporterIDBP_BDH

{
key bdh.BillingDocument as billdoc,
key bdi.BillingDocumentItem as billitem,
bdh.DocumentReferenceID   as invoiceno,
bdh.BillingDocumentDate  as invoicedt,
pdb.ConsumptionTaxCtrlCode as hsncode,
bdi.BillingDocumentItemText as desct,
bdi.BaseUnit                 as uom,
@Semantics.quantity.unitOfMeasure: 'uom'
case 
when  bdh.BillingDocumentType = 'G2' or bdh.BillingDocumentType = 'L2' or bdh.BillingDocumentType = 'S1'
then bdi.BillingQuantity 
else
doi.ActualDeliveryQuantity end  as billqty,
bdi.Batch ,
stp.Customer as stpno,
stp.CustomerName as stpname,
btp.Customer as btpno,
btp.CustomerName as btpname,
pay.Customer as pyno,
pay.CustomerName as pyname,
shp.Customer as shpno,
shp.CustomerName as shpname,
shp.PostalCode as pin,
eway.IN_ElectronicDocEWbillNmbr as ewayno,
bdb.YY1_LRNo_SD_BDH as lrno,
bdb.YY1_LRDate_SD_BDH as lrdt,
sd.PurchaseOrderByCustomer as pono,
bdb.YY1_TransporterIDBP_BDH as transporterid,
bdb.YY1_TransporterIDS_BDH as sutprid,
sup.SupplierName as sfn,
bdb.YY1_DeliveryDate_BDH as deliv,
uom.unitofmeasurename as uomname,
com.Customer as comno,
com.CustomerName as comname,
bdipe.ConditionCurrency as curr,
@Semantics.amount.currencyCode: 'curr'
bdipe.ConditionAmount as comamt,
@Semantics.amount.currencyCode: 'fcurr'
bdb.YY1_FreightPaidtoTrans_BDH as frightptt,
@Semantics.amount.currencyCode: 'fcurr'
//cast(cast(bdb.YY1_FreightPaidtoTrans_BDH as abap.dec(15,2 ) ) * doi.OriginalDeliveryQuantity as abap.dec( 15,2) )as frightptrtot,
cast(
    coalesce(bdb.YY1_FreightPaidtoTrans_BDH, 0) *
   coalesce(doi.ActualDeliveryQuantity, 0) as abap.dec(18, 3)
) as frightptrtot,
bdb.YY1_FreightPaidtoTrans_BDHC as fcurr,
@Semantics.amount.currencyCode: 'frcurr'
bdb.YY1_FreightRecfromCus_BDH as frightrfc,
@Semantics.amount.currencyCode: 'frcurr'
//cast(cast(bdb.YY1_FreightRecfromCus_BDH as abap.dec(15,2 ) ) * doi.OriginalDeliveryQuantity as abap.dec( 15,2) ) as frightrfctot,
cast( coalesce(bdb.YY1_FreightRecfromCus_BDH, 0)  * coalesce(doi.OriginalDeliveryQuantity, 0)  as abap.dec(18, 3))  as frightrfctot,
bdb.YY1_FreightRecfromCus_BDHC as frcurr,
bnet.ConditionCurrency as currr,
@Semantics.amount.currencyCode: 'currr'
case when bdh.BillingDocumentType = 'G2'
then 
 cast(bdi.BillingQuantity * bnet.ConditionRateAmount as abap.curr( 15, 2) )
else 
cast(doi.ActualDeliveryQuantity * bnet.ConditionRateAmount as abap.curr( 15, 2))
 end
 as basenet,
case bdh.InvoiceClearingStatus
when 'A' then 'Not Clear'
when 'C' then 'Cleared'
else null end as overallstus,
@Semantics.amount.currencyCode: 'currr'
bnet.ConditionRateAmount as baseamt,
case
      when bdh.BillingDocumentType = 'G2' or bdh.BillingDocumentType = 'L2' or bdh.BillingDocumentType = 'S1'
      then 
      case when bdb.YY1_OriginalInvoice_SD_BDH is not initial 
      then bdb.YY1_OriginalInvoice_SD_BDH 
      else bdh.AssignmentReference end
      else null  end       as OriginalInvoiceNumber





//case
//    when bnet.ConditionRateAmount > 500 then 1  -- Medium criticality (yellow)
//    when  bnet.ConditionRateAmount  > 100 then 2   -- Low criticality (green)
//    else 3                        -- High criticality (red)
//  end as NetAmountCriticality

    
} where (bdh.BillingDocumentType = 'F2' or bdh.BillingDocumentType = 'G2'or  bdh.BillingDocumentType = 'L2'or bdh.BillingDocumentType = 'S1') ;//and bdi.BillingQuantity is not initial; //and doi.OriginalDeliveryQuantity is not initial;
