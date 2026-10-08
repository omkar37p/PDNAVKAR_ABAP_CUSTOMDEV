@AbapCatalog.sqlViewName: 'ZVIEW_ORDERS1'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Orders CDS View'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_ORDERS1
  as select from zorders_db
{
  key orderid,
      plant,
      case status when 'OPEN' then 1 else 0 end      as OPEN_ORDERS,
      case status when 'RELEASED' then 1 else 0 end  as RELEASED,
      case status when 'COMPLETED' then 1 else 0 end as COMPLETED

}
