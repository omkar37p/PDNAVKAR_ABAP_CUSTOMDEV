@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View For Billing Doument'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zsd_billg_doc_v as select from I_BillingDocumentBasic
{
   key BillingDocument,
    YY1_LRNo_SD_BDH ,
    YY1_DeliveryDate_BDH,
YY1_LRDate_SD_BDH ,
YY1_TransporterIDBP_BDH  ,
YY1_TransporterIDS_BDH ,
YY1_DeliveryDate_BDH as deliv,
@Semantics.amount.currencyCode: 'YY1_FreightPaidtoTrans_BDHC'
cast(YY1_FreightPaidtoTrans_BDH as abap.dec( 15,3) ) as YY1_FreightPaidtoTrans_BDH,
YY1_FreightPaidtoTrans_BDHC ,
@Semantics.amount.currencyCode: 'YY1_FreightRecfromCus_BDHC'
cast(YY1_FreightRecfromCus_BDH as abap.dec( 15,3) )  as YY1_FreightRecfromCus_BDH,
YY1_FreightRecfromCus_BDHC ,
 YY1_OriginalInvoice_SD_BDH
  
}
