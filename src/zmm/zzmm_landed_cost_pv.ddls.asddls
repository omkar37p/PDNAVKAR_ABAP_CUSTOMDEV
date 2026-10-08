@EndUserText.label: 'Projection View For Landed Cost'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define root view entity ZZMM_LANDED_COST_PV
  provider contract transactional_query
  as projection on ZZMM_LANDED_COST_REV

{     
  key GLNumber,
  key GLItem,
  key GRYear,
  key PurchaseOrder,
      PurchaseType,
      GRDocument,   
      GRPostingDate,
      Batch,
      SupplierInvoiceNo,
      SupplierInvoiceDate, 
      VendorName,
//    acchead,
//    narration,
      MaterialDescription,
      hsnno,
      Country,
      pricebasic,
      @Semantics.quantity.unitOfMeasure:    'Baseunit'
      quantity,
      Baseunit,
      @Semantics.amount.currencyCode:       'PriceUnit'
      Rate,
      @Semantics.amount.currencyCode:       'PriceUnit'
      taxablevalue,
      PriceUnit,
//      @Semantics.amount.currencyCode:       'PriceUnit'
      discountvalue,
      customduty,
      addl_customduty,
      cess_charge,
      freight,
      liner_charges,
      cfa_charges,
//      coolie,
//      other_duty_charges,
      @Semantics.amount.currencyCode:       'PriceUnit'
      igstamount,
      @Semantics.amount.currencyCode:       'PriceUnit'
      cgstamount,
      @Semantics.amount.currencyCode:       'PriceUnit'
      sgstamount,
      @Semantics.amount.currencyCode:       'PriceUnit'
      grossamount

}
