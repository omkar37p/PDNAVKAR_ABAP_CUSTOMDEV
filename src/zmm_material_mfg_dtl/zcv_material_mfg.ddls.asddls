@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view for material MFG'
@UI.headerInfo:{
  typeName: 'Material',
  typeNamePlural: 'Material',
  title: {
    type: #STANDARD,
    value: 'Material'
  },
  description.value: 'Material'
}
define root view entity ZCV_MATERIAL_MFG
  provider contract transactional_query
  as projection on ZRV_MATERIAL_MFG
{

     @UI.facet: [{ id: 'Material',
        purpose: #STANDARD,
        type: #IDENTIFICATION_REFERENCE,
        label: 'Material',
        position: 10
      }, {
        id: 'MaterialDesc',position:20,
        label:'MaterialDesc'
      }, {
        id:'log',position:30,
        type: #FIELDGROUP_REFERENCE,
        targetQualifier: 'ChangeLog',
        label:'Change Log'
      }]

      @UI: { lineItem: [{ position: 10 }],
      identification: [{ position: 10 }],
      selectionField: [{ position: 10 }] }
  key Material,
      @UI: { lineItem: [{ position: 20 }],
      identification: [{ position: 20 }] }
      MaterialDesc,
      @UI: { lineItem: [{ position: 30 }],
      identification: [{ position: 30 }] }
      MfgerName,
      @UI.fieldGroup: [{ qualifier: 'ChangeLog', position: 10 }]
      CreatedBy,
      @UI.fieldGroup: [{ qualifier: 'ChangeLog', position: 20 }]
      CreatedAt,
      @UI.fieldGroup: [{ qualifier: 'ChangeLog', position: 30 }]
      LastChangedBy,
      @UI.fieldGroup: [{ qualifier: 'ChangeLog', position: 40 }]
      LastChangedAt,
      
      @UI.hidden: true
      ExcelRowNumber
}
