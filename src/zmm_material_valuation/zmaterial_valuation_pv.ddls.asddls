@EndUserText.label: 'Projection View for Material Valuation'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define root view entity ZMATERIAL_VALUATION_PV
  provider contract transactional_query
  as projection on ZMATERIAL_VALUATION_REV

{     
  key Product,
  key ValuationArea,
  key ValuationType,
      @ObjectModel.text.element: [ 'PlantName']
      Plant,
      PlantName,
      ProductName,
      @ObjectModel.text.element: [ 'ValuationClassDescription']
      ValuationClass,
      ValuationClassDescription,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      TotStockQty,
      BaseUnit,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit2'
      PriceUnitQty,
      BaseUnit2,   
      @Semantics.amount.currencyCode: 'Currency'
      price,
      Currency,
      @Semantics.amount.currencyCode: 'Currency2'
      TotalValue,
      Currency2
}
