@AbapCatalog.sqlViewName: 'ZI_ORDERS_2'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Orders CDS View'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_ORDERS2
  as select from ZI_ORDERS1
{
  key min(orderid) as OrderID,
      plant,
      count( * )         as TotalOrders,
      sum( OPEN_ORDERS ) as OPEN_ORDERS,
      sum( RELEASED )    as RELEASED,
      sum( COMPLETED )   as COMPLETED

}
group by
  plant
