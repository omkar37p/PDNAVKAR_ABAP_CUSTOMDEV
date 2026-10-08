@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root view of excel upload program'
@ObjectModel.modelingPattern: #NONE
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED }
define root view entity ZRV_MATERIAL_MFG
  as select from zmaterial_mfg_t
{
      @EndUserText.label: 'Material'
  key material        as Material,
      @EndUserText.label: 'Material Description'
      material_desc   as MaterialDesc,
      @EndUserText.label: 'Manufactuer Name'
      mfger_name      as MfgerName,
      @Semantics.user.createdBy: true
      @EndUserText.label: 'Created By'
      created_by      as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      @EndUserText.label: 'Created At'
      created_at      as CreatedAt,
      @Semantics.user.lastChangedBy: true
      @EndUserText.label: 'Last Changed By'
      last_changed_by as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      @EndUserText.label: 'Last Changed At'
      last_changed_at as LastChangedAt,
      
      0               as ExcelRowNumber
}
