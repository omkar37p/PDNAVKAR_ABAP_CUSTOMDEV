@EndUserText.label: 'BATCH DETAILS CDS VIEW'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZBATCH_DET_CDS
provider contract transactional_query as projection on I_BatchTP_2
{
    key Material,
    key BatchIdentifyingPlant,
    key Batch,
    ShelfLifeExpirationDate,
    ManufactureDate
    /* Associations
    _BatchCharacteristicTP,
    _BatchClassTP,
    _BatchPlantTP,
    _BatchTextTP,
    _Product   */
}
