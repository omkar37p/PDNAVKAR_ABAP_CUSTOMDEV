@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity - Sales Order List'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZSD_SALESOR_REV
  as select from    I_SalesOrder                                                             as so
    inner join      I_SalesOrderItem                                                         as soi  on soi.SalesOrder = so.SalesOrder
    left outer join I_SalesOrderPartner                                                      as stp  on  stp.SalesOrder      = so.SalesOrder
                                                                                                     and stp.PartnerFunction = 'AG'
    left outer join I_SalesOrderPartner                                                      as btp  on  btp.SalesOrder      = so.SalesOrder
                                                                                                     and btp.PartnerFunction = 'RE'
    left outer join I_SalesOrderPartner                                                      as pay  on  pay.SalesOrder      = so.SalesOrder
                                                                                                     and pay.PartnerFunction = 'RG'
    left outer join I_SalesOrderPartner                                                      as sop  on  sop.SalesOrder      = so.SalesOrder
                                                                                                     and sop.PartnerFunction = 'WE'
    left outer join I_SalesOrderScheduleLine                                                 as sos  on  sos.SalesOrder     = soi.SalesOrder
                                                                                                     and sos.SalesOrderItem = soi.SalesOrderItem
    left outer join I_SalesOrderItemCube( P_ExchangeRateType:'M' , P_DisplayCurrency:'INR' ) as SOIC on  SOIC.SalesOrder     = soi.SalesOrder
                                                                                                     and SOIC.SalesOrderItem = soi.SalesOrderItem
    left outer join I_IncotermsClassificationText                                            as inco on inco.IncotermsClassification = soi.IncotermsClassification
  //left outer join I_SalesDocumentItem as sdi on sdi.SalesDocument = soi.SalesOrder and sdi.SalesDocumentItem = soi.SalesOrderItem

{
  key so.SalesOrder,
  key soi.SalesOrderItem                as lineitem,
  key sos.ScheduleLine                  as sche,
      soi.Product,
      soi.SalesOrderItemText            as Descr,
      sos.OrderQuantityUnit             as qun,
      @Semantics.quantity.unitOfMeasure: 'qun'
      soi.OrderQuantity                 as od,
      @Semantics.quantity.unitOfMeasure: 'qun'
      sos.OpenConfdDelivQtyInOrdQtyUnit as conf,
      soi.TransactionCurrency           as curr,
      @Semantics.amount.currencyCode: 'curr'
      soi.NetAmount,
      @Semantics.quantity.unitOfMeasure: 'qun'
      sos.DeliveredQtyInOrderQtyUnit    as ordquantity,
      sos.DeliveryDate                  as reqdate,  
      stp.Customer                      as stpno,    // Sold-To Party (Customer)
      stp.FullName                      as stpname,
      btp.Customer                      as btpno,    // Bill-To Party (Customer)
      btp.FullName                      as btpname,
      pay.Customer                      as payno,    // Payer (Customer)
      pay.FullName                      as payname,
      sop.Customer                      as sopno,    // Ship-To Party (Customer)
      sop.FullName                      as sopname,
      soi.IncotermsClassification       as incoterm,  // Incoterms
      inco.IncotermsClassificationName  as inconame,
      soi.PurchaseOrderByCustomer       as custref,
      soi.CustomerPurchaseOrderDate     as custdt,
      case SOIC.OverallDeliveryStatus
          when 'A' then 'Open'
          when 'B' then 'Partial Delivered'
          when 'C' then 'Completed'
          else null
      end                               as overallstus, // Overall Delivery Status
      so.SalesGroup

}
