@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root entity for Alternative UOM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define root view entity ZSD_ALTERNATIVE_UOM_RE as select from zsd_alternav_uom
{
    key product,
    alternativeunit,
    unitofmeasurename,
    baseunit,
    quantitynumerator,
    quantitydenominator
    
}

