@EndUserText.label: 'Product Order CDS'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZPRO_CDSVIEW 
provider contract transactional_query
as projection on I_ProductTP_2
{
    key Product,
    GrossWeight,
    WeightUnit,
    NetWeight
       /* Associations 
    _ProductChangeMaster,
    _ProductDescription,
    _ProductEWMWarehouse,
    _ProductGroup_2,
    _ProductPlant,
    _ProductProcurement,
    _ProductQualityManagement,
    _ProductSales,
    _ProductSalesDelivery,
    _ProductStorage,
    _ProductType,
    _ProductUnitOfMeasure,
    _ProductValuation */
}
