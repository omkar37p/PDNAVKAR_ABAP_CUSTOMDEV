@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root entity View for Alternative UOM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZSD_ALTERNATIVE_UOM_REV as select from ZSD_ALTERNATIVE_UOM_RE
{
    key product,
    alternativeunit,
    unitofmeasurename,
    baseunit,
    quantitynumerator,
    quantitydenominator
    
}

