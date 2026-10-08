@AbapCatalog.viewEnhancementCategory: [#NONE]
@EndUserText.label: 'Projection View Alternative UOM'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZSD_ALTERNATIVE_UOM_PV 
 provider contract transactional_query
as projection on ZSD_ALTERNATIVE_UOM_REV
{
    key product,
    alternativeunit,
    unitofmeasurename,
    baseunit,
    quantitynumerator,
    quantitydenominator 
}

