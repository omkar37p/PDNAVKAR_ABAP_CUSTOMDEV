@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity View for Material Valuation'
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMATERIAL_VALUATION_REV
 as select from I_ProductValuationBasic as PVB
 left outer to one join       I_Plant                     as plt       on plt.ValuationArea = PVB.ValuationArea
 left outer to one join       I_MaterialStock_2           as Mstock    on Mstock.Material   = PVB.Product
{
      @ObjectModel.text.element: [ 'ProductName']
  key PVB.Product,
  key PVB.ValuationArea,
  key PVB.ValuationType,
      @ObjectModel.text.element: [ 'PlantName']
      plt.Plant,
      plt.PlantName,
      PVB._Product._Text.ProductName,
      @ObjectModel.text.element: [ 'ValuationClassDescription']
      PVB.ValuationClass,
      PVB._ValuationClass._ValuationClassText.ValuationClassDescription,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      sum(Mstock.MatlWrhsStkQtyInMatlBaseUnit) as TotStockQty,
      Mstock.MaterialBaseUnit as BaseUnit,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit2'
      PVB.PriceUnitQty,
      Mstock.MaterialBaseUnit as BaseUnit2,
      @Semantics.amount.currencyCode: 'Currency'
      PVB.MovingAveragePrice as price,
      PVB.Currency as Currency,
      @Semantics.amount.currencyCode: 'Currency2'
      cast(  sum(Mstock.MatlWrhsStkQtyInMatlBaseUnit)  * get_numeric_value( PVB.MovingAveragePrice)  as abap.dec(13, 2)) as TotalValue,
      PVB.Currency as Currency2
}

 where
      PVB.ValuationClass = '3000' or PVB.ValuationClass = '3050'     
      //3000  Raw Materials           PIPE
      //3050  Packaging and empties   LEIH
group by
    PVB.Product,
    PVB.ValuationArea,
    PVB.ValuationType,
    plt.Plant,
    plt.PlantName,
    PVB._Product._Text.ProductName,
    PVB.ValuationClass,
    PVB._ValuationClass._ValuationClassText.ValuationClassDescription,
    Mstock.MaterialBaseUnit,
    PVB.Currency,
    PVB.StandardPrice,
    PVB.PriceUnitQty,
    PVB.MovingAveragePrice
    

 

