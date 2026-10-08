@EndUserText.label: 'Material Stock base table function'
@ClientHandling: { type: #CLIENT_DEPENDENT, algorithm: #SESSION_VARIABLE }
@AccessControl.authorizationCheck: #NOT_REQUIRED
define table function ZMSTOCK_TF
  with parameters
  //  from_date : abap.dats,
    to_date   : abap.dats
returns
{
  key mandt               : abap.clnt;
  key record_id           : abap.int4;
  key Matdocyear          : abap.numc(4);
  key matdoc              : abap.char(10);
  key matdocitem          : abap.numc(4);
      //      Deliverydocument : abap.char(10);
      //      Deliverydocumentitem : abap.numc(6);
      documentdate        : abap.dats;
      postingdate         : abap.dats;
   //   Division            : abap.char(25);
//      Productgroup        : abap.char(25);
//      DistributionChannel : abap.char(30);
      material            : abap.char(18);
//      Materialname        : abap.char(40);
//      Companycode         : abap.char(4);
      plant               : abap.char(4);
//      Storagelocation     : abap.char(4);
//      Batch               : abap.char(12);
//      Movementtype        : abap.char(3);
      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
      stock               : abap.quan(13,3);
      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
      open_stock          : abap.quan(13,3);
//      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
//      ProductionQty       : abap.quan(13,3);
//      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
//      TradingQty          : abap.quan(13,3);
//      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
//      Loc_Trf_InQty       : abap.quan(13,3);
//      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
//      WriteBackQty        : abap.quan(13,3);
//      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
//      Total_InwardQty     : abap.quan(13,3);
//      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
//      DomesticSalesQty    : abap.quan(13,3);
//      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
//      DeemedExportQty     : abap.quan(13,3);
//      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
//      SEZSalesQty         : abap.quan(13,3);
//      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
//      ExportQty           : abap.quan(13,3);
//      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
//      NetSalesQty         : abap.quan(13,3);
//      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
//      Loc_Trf_OutQty      : abap.quan(13,3);
//      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
//      Total_OutQty        : abap.quan(13,3);
      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
      total_stock         : abap.quan(13,3);
      Material_UOM        : abap.unit(3); // Unit of Measure
}
implemented by method
  ZCL_MSTOCK_TF=>get_stock;