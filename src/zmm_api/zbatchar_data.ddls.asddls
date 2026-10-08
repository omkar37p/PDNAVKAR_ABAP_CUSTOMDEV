@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Batch Characteristics Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZBATCHAR_DATA
  as select from I_ClfnObjectCharcValForKeyDate(P_KeyDate: $session.system_date) as ObjectCharcValue
   inner join  I_BatchDistinct                                                 as Batch on ObjectCharcValue.ClfnObjectInternalID = Batch.ClfnObjectInternalID

{
  key Batch.Material,
  key Batch.Plant                               as BatchIdentifyingPlant,
  key Batch.Batch,
  key ObjectCharcValue.CharcInternalID,
  key ObjectCharcValue.CharcValuePositionNumber as ClfnCharcValuePositionNumber,
      ObjectCharcValue.CharcValue,
      ObjectCharcValue.CharcFromDecimalValue,
      ObjectCharcValue.CharcToDecimalValue,
      ObjectCharcValue.CharcFromDate,
      ObjectCharcValue.CharcToDate
}
where
       ObjectCharcValue.ClfnObjectType  = 'O'
  and( 
       ObjectCharcValue.ClfnObjectTable = 'MCH1'
    or ObjectCharcValue.ClfnObjectTable = 'MCHA' 
  )
