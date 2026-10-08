@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Commision Report - Root View Entity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZCOMMISION_RVE as select from I_BillingDocument as bdh
inner join I_BillingDocumentItem as bdi on bdi.BillingDocument = bdh.BillingDocument  
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
left outer join I_BillingDocumentBasic as bdb on bdb.BillingDocument = bdh.BillingDocument
left outer join I_DeliveryDocumentItem as doi on doi.DeliveryDocument = bdi.ReferenceSDDocument and doi.DeliveryDocumentItem = bdi.ReferenceSDDocumentItem and doi.Batch = bdi.Batch
left outer join I_BillingDocItemPartner as bdip on bdip.BillingDocument = bdi.BillingDocument and bdip.BillingDocumentItem = bdi.BillingDocumentItem and bdip.PartnerFunction = 'WE'
left outer join I_Customer as shp on shp.Customer = bdip.Customer
left outer join I_SalesDocument as sd on sd.SalesDocument = bdi.SalesDocument
left outer join ZSD_ALTERNATIVE_UOM_RE as uom on uom.product = bdi.Product
left outer join I_Supplier as sup on sup.Supplier = bdb.YY1_TransporterIDBP_BDH
left outer join I_BillingDocumentItemPrcgElmnt as bdipe on bdipe.BillingDocument = bdi.BillingDocument and bdipe.BillingDocumentItem = bdi.BillingDocumentItem and bdipe.ConditionType = 'ZCCC'

{
key bdh.BillingDocument as billdoc,
key bdi.BillingDocumentItem as billitem,
bdh.DocumentReferenceID   as invoiceno,
bdh.BillingDocumentDate  as invoicedt,
pdb.ConsumptionTaxCtrlCode as hsncode,
bdi.BillingDocumentItemText as desct,
bdi.BaseUnit                 as uom,
@Semantics.quantity.unitOfMeasure: 'uom'
doi.OriginalDeliveryQuantity     as billqty,
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
bdipe.ConditionAmount as comamt

    
} where bdh.BillingDocumentType = 'F2';
