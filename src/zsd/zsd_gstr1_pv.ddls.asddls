@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view- GSTR1SD'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZSD_GSTR1_PV
  provider contract transactional_query
  as projection on ZSD_GSTR1_REV
{
    key billdoc, 
  key billitm,
      igststep,
      igstcnt,
      Supply,
      ExportType,
//      kunnr,
//      kngrp,
      lang,
      Gstrate,
//      product,
//      plant,
//      @ObjectModel.text.element: [ 'kunnr' ]
      custname,
      taxno2,
      billdate,
//      tcurr,
      stcurr,
      @Semantics.amount.currencyCode: 'stcurr'
      totnetamt,
      @Semantics.amount.currencyCode: 'stcurr'
      tottaxamt,
      excgrate,
//      @Semantics.amount.currencyCode: 'stcurr'
//      condamt,
      prdgrp,
      refdoc,
//      cusgrpnam,
// @Semantics.amount.currencyCode: 'stcurr'
//      igstrate,
   @Semantics.amount.currencyCode: 'igstcurr'
      igstamt,
      IGSTCURR,
//      @Semantics.amount.currencyCode: 'igstcurr'
//      Gstrate,
//      cgstrate,
    @Semantics.amount.currencyCode: 'igstcurr'
      cgstamt,
//      sgstRate,
      @Semantics.amount.currencyCode: 'igstcurr'
      sgstamt,

      itmtxt,
      uom,
      @Semantics.quantity.unitOfMeasure: 'uom'
      billqty,
      hsncode,
      //igstcntyp,  //CHANGE 
      //cgstcntyp,  // CHANGE
      //sgstcntyp,  // CHANGE 
//     @ObjectModel.text.element: [ '' ]
      State,
      Accdoc,
//      Divisionb,
      SupplierGSTIN,
//      Statecode,
//      Suppler,
//      ProfitCenter,
      BillingType,
      Fidocdate,
      InStus,
      @Semantics.amount.currencyCode: 'stcurr'
      Cessamt,
      Notenumber,
      NoteDate,
      @Semantics.amount.currencyCode: 'stcurr'
      NoteValue,
      RevenueAccount,
      ShippingBillNumber,
      ShippingBillDate,
      PortNumber,
      ClearancePort,
      GSTR1RETURNPERIOD,
      BAUTOFILLPERIOD,
      Location,
      isamended,
      ReverseCharge,
      OriginalInvoiceNumber,
      OriginalInvoiceDate,
      OriginalMonth,
      Supplytype1,
//      FIDocumentDate,
//      invoicedate,
//      MatDes,
//     OriginalDocumentNumber,
//    AccountingVoucherDate 
    Plant,
    PlantName




}
