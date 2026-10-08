@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View For Port Master'
//@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZSD_PORT_MASTER_PV
  provider contract transactional_query
  as projection on ZSD_PORT_MASTER_REV
{
  key portname,
  key countryname,
      portno,
      portofloading,
      portofclearance
}
