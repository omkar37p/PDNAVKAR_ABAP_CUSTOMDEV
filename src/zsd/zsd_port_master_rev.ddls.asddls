@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity View for Port Master'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZSD_PORT_MASTER_REV
  as select from ZSD_PORT_MASTER_RE
{
  key portname,
  key countryname,
      portno,
      portofloading,
      portofclearance
}
