@EndUserText.label: 'Custom Entity for Quantity Summary'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_QUAN_SUM_QUERY'
define custom entity ZI_OPENING_STOCK
{
  key Matdoc        : mblnr;
  key Matdocitem    : mblpo;
      Postingdate   : abap.dats;
      Material      : matnr;
      Plant         : werks_d;
      Batch         : charg_d;
      Movementtype  : kzbew;
      @Semantics.quantity.unitOfMeasure: 'Materialunit'
      Quantity      : menge_d;
      MaterialUnit  : meins;
      @Semantics.quantity.unitOfMeasure: 'Materialunit'
      Quantity_101  : menge_d;
      @Semantics.quantity.unitOfMeasure: 'Materialunit'
      Quantity_561  : menge_d;
      @Semantics.quantity.unitOfMeasure: 'Materialunit'
      Quantity_601  : menge_d;
      @Semantics.quantity.unitOfMeasure: 'Materialunit'
      Quantity_641  : menge_d;
      @Semantics.quantity.unitOfMeasure: 'Materialunit'
      Quantity_653  : menge_d;
      @Semantics.quantity.unitOfMeasure: 'Materialunit'
      Stock         : menge_d;
      @Semantics.quantity.unitOfMeasure: 'Materialunit'
      OpeningStock  : menge_d;
      @Semantics.quantity.unitOfMeasure: 'Materialunit'
      TotalStock    : menge_d;

}
