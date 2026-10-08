@EndUserText.label: 'Projection View For Purchase Register'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define root view entity ZMM_PURCHASE_REGISTER_PV
  provider contract transactional_query
  as projection on ZMM_PURCHASE_REGISTER_REV

{
  key GLNumber,
  key GLItem,
  key GRYear,
  key PurchaseOrder,
      PurchaseType,
      GRDocument,
      GRDocumentItem,
      GRPostingDate,
      FIInvoiceNo,
      FIInvoiceDate,
      SupplierInvoiceNo,
      SupplierInvoiceDate,
      VendorNo,
      VendorName,
      MaterialDescription,
      hsnno,
      Country,
      State,
      pricebasic,
      @Semantics.quantity.unitOfMeasure:    'Baseunit'
      quantity,
      Baseunit,
      @Semantics.amount.currencyCode:       'PriceUnit'
      Rate,
      @Semantics.amount.currencyCode:       'PriceUnit'
      conversionrate,
      discountvalue,
      @Semantics.amount.currencyCode:       'PriceUnit'
      AssessibleValue,
      @Semantics.amount.currencyCode:       'PriceUnit'
      Custom_Duty,
      @Semantics.amount.currencyCode:       'PriceUnit'
      taxablevalue,
      @Semantics.amount.currencyCode: 'PriceUnit_CC'
      taxablevalue_CC,
      PriceUnit, 
      PriceUnit_CC,
      @Semantics.amount.currencyCode:       'PriceUnit'
      igstamount,
      @Semantics.amount.currencyCode:       'PriceUnit'
      cgstamount,
      @Semantics.amount.currencyCode:       'PriceUnit'
      sgstamount,
      @Semantics.amount.currencyCode:       'PriceUnit'
      grossamount,
      @Semantics.amount.currencyCode: 'PriceUnit_CC'
      grossamount_CC,
      Taxrate,
      TaxCode,
      GLName,
      @Semantics.amount.currencyCode:       'PriceUnit'
      TDSAmount,
      Vendor_GST,
      supplytype,
      invoicetype,
      itceligibility,
      eligibilitycategory,
      LR_BL,
      LR_BL_Date,
      EWayBill,
      EWayBillDate
}
