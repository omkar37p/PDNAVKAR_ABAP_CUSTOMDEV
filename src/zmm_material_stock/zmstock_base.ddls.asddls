@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Stock base view'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMStock_base
  with parameters
    //  from_date : abap.dats,
    to_date : abap.dats
  as select from I_MaterialDocumentItem_2 as matdocitem
  association [0..1] to I_MaterialDocumentHeader_2 as _Header               on  matdocitem.MaterialDocument     = _Header.MaterialDocument
                                                                            and matdocitem.MaterialDocumentYear = _Header.MaterialDocumentYear
  /*+ [hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ] } */
  association [0..1] to I_Product                  as _material             on  _material.Product = matdocitem.Material
  association [0..1] to I_DeliveryDocumentItem     as _DeliveryDocumentItem on  _DeliveryDocumentItem.DeliveryDocument     = matdocitem.DeliveryDocument
                                                                            and _DeliveryDocumentItem.DeliveryDocumentItem = matdocitem.DeliveryDocumentItem
{
  key    matdocitem.MaterialDocumentYear                                                                                           as Matdocyear,
  key    matdocitem.MaterialDocument                                                                                               as Matdoc,
  key    matdocitem.MaterialDocumentItem                                                                                           as Matdocitem,
         matdocitem.DeliveryDocument                                                                                               as Deliverydocument,
         matdocitem.DeliveryDocumentItem                                                                                           as Deliverydocumentitem,
         matdocitem.DocumentDate                                                                                                   as Documentdate,
         matdocitem.PostingDate                                                                                                    as Postingdate,
         _Header.CreationDate                                                                                                      as Creationdate,
         _Header.CreationTime                                                                                                      as Creationtime,
         _material._DivisionText.DivisionName                                                                                      as Division,
         _material._ProductGroupText_2.ProductGroupName                                                                            as Productgroup,
         case when matdocitem.GoodsMovementType = '101' and _material.ProductGroup <> 'Z001' and matdocitem.OrderID is not null
         then 'PRODUCTION'
         when matdocitem.GoodsMovementType = '101' and _material.ProductGroup = 'Z001'
         then 'PURCHASE'
         when matdocitem.GoodsMovementType = '641'
         then 'STO'
         when matdocitem.GoodsMovementType = '601' and _DeliveryDocumentItem.DistributionChannel is not null
         then _DeliveryDocumentItem._DistributionChannel._Text.DistributionChannelName
         else cast('STO' as abap.char(20)) end                                                                                     as DistributionChannel,
         matdocitem.Material                                                                                                       as Material,
         _material._Text.ProductName                                                                                               as Materialname,
         matdocitem.CompanyCode                                                                                                    as Companycode,
         matdocitem.Plant                                                                                                          as Plant,
         matdocitem.StorageLocation                                                                                                as Storagelocation,
         matdocitem.Batch                                                                                                          as Batch,
         matdocitem.GoodsMovementType                                                                                              as Movementtype,
         matdocitem.MaterialBaseUnit                                                                                               as Material_UOM,
         @Semantics.quantity.unitOfMeasure: 'Material_UOM'
         case when matdocitem.GoodsMovementType = '101' and _material.ProductGroup <> 'Z001' and matdocitem.OrderID is not null
         then matdocitem.QuantityInBaseUnit
         else cast('0.000' as abap.quan(13,3)) end                                                                                 as ProductionQty,
         @Semantics.quantity.unitOfMeasure: 'Material_UOM'
         case when matdocitem.GoodsMovementType = '101' and _material.ProductGroup = 'Z001'
         then matdocitem.QuantityInBaseUnit
         else cast('0.000' as abap.quan(13,3)) end                                                                                 as PurchaseQty,
         @Semantics.quantity.unitOfMeasure: 'Material_UOM'
         cast('0.000' as abap.quan(13,3))                                                                                          as TradingQty,
         @Semantics.quantity.unitOfMeasure: 'Material_UOM'
         case when matdocitem.GoodsMovementType = '641' and matdocitem.IssuingOrReceivingPlant = matdocitem.Plant
         then matdocitem.QuantityInBaseUnit else cast('0.000' as abap.quan(13,3)) end                                              as Loc_Trf_InQty,
         @Semantics.quantity.unitOfMeasure: 'Material_UOM'
         cast('0.000' as abap.quan(13,3))                                                                                          as WriteBackQty,
         @Semantics.quantity.unitOfMeasure: 'Material_UOM'
         case when matdocitem.GoodsMovementType = '101' and matdocitem.OrderID is not null
         then matdocitem.QuantityInBaseUnit
         else cast('0.000' as abap.quan(13,3)) end                                                                                 as Total_InwardQty,
         @Semantics.quantity.unitOfMeasure: 'Material_UOM'
         case when matdocitem.GoodsMovementType = '601' and _DeliveryDocumentItem.DistributionChannel = '01'
         then matdocitem.QuantityInBaseUnit else cast('0.000' as abap.quan(13,3)) end                                              as DomesticSalesQty,
         @Semantics.quantity.unitOfMeasure: 'Material_UOM'
         case when matdocitem.GoodsMovementType = '601' and _DeliveryDocumentItem.DistributionChannel = '03'
         then matdocitem.QuantityInBaseUnit else cast('0.000' as abap.quan(13,3)) end                                              as DeemedExportQty,
         @Semantics.quantity.unitOfMeasure: 'Material_UOM'
         case when matdocitem.GoodsMovementType = '601' and _DeliveryDocumentItem.DistributionChannel = '04'
         then matdocitem.QuantityInBaseUnit else cast('0.000' as abap.quan(13,3)) end                                              as SEZSalesQty,
         @Semantics.quantity.unitOfMeasure: 'Material_UOM'
         case when matdocitem.GoodsMovementType = '601' and _DeliveryDocumentItem.DistributionChannel = '02'
         then matdocitem.QuantityInBaseUnit else cast('0.000' as abap.quan(13,3)) end                                              as ExportQty,
         @Semantics.quantity.unitOfMeasure: 'Material_UOM'
         case matdocitem.GoodsMovementType when '601' then matdocitem.QuantityInBaseUnit else cast('0.000' as abap.quan(13,3)) end as NetSalesQty,
         @Semantics.quantity.unitOfMeasure: 'Material_UOM'
         cast('0.000' as abap.quan(13,3))                                                                                          as JobWorkQty,
         @Semantics.quantity.unitOfMeasure: 'Material_UOM'
         case matdocitem.GoodsMovementType when '261' then matdocitem.QuantityInBaseUnit else cast('0.000' as abap.quan(13,3)) end as ProductionIssueQty,
         @Semantics.quantity.unitOfMeasure: 'Material_UOM'
         case when matdocitem.GoodsMovementType = '641' and matdocitem.IssuingOrReceivingPlant <> matdocitem.Plant
         then matdocitem.QuantityInBaseUnit else cast('0.000' as abap.quan(13,3)) end                                              as Loc_Trf_OutQty,
         @Semantics.quantity.unitOfMeasure: 'Material_UOM'
         cast('0.000' as abap.quan(13,3))                                                                                          as ReProcessQty,
         @Semantics.quantity.unitOfMeasure: 'Material_UOM'
         cast('0.000' as abap.quan(13,3))                                                                                          as WriteOffQty,
         @Semantics.quantity.unitOfMeasure: 'Material_UOM'
         case matdocitem.GoodsMovementType when '641' then matdocitem.QuantityInBaseUnit else cast('0.000' as abap.quan(13,3)) end as Total_OutQty,
         @Semantics.quantity.unitOfMeasure: 'Material_UOM'
         (
           case matdocitem.GoodsMovementType when '101' then matdocitem.QuantityInBaseUnit else cast('0.000' as abap.quan(13,3)) end -
           case matdocitem.GoodsMovementType when '261' then matdocitem.QuantityInBaseUnit else cast('0.000' as abap.quan(13,3)) end +
         //  case matdocitem.GoodsMovementType when '301' then matdocitem.QuantityInBaseUnit else cast('0.000' as abap.quan(13,3)) end + //301 not required because this is plant to plant transfer posting
         //  case matdocitem.GoodsMovementType when '321' then matdocitem.QuantityInBaseUnit else cast('0.000' as abap.quan(13,3)) end + //321 not required because this quality inspection movement
           case matdocitem.GoodsMovementType when '561' then matdocitem.QuantityInBaseUnit else cast('0.000' as abap.quan(13,3)) end -
           case matdocitem.GoodsMovementType when '601' then matdocitem.QuantityInBaseUnit else cast('0.000' as abap.quan(13,3)) end +
           case matdocitem.GoodsMovementType when '602' then matdocitem.QuantityInBaseUnit else cast('0.000' as abap.quan(13,3)) end -
           case matdocitem.GoodsMovementType when '641' then matdocitem.QuantityInBaseUnit else cast('0.000' as abap.quan(13,3)) end +
           case matdocitem.GoodsMovementType when '653' then matdocitem.QuantityInBaseUnit else cast('0.000' as abap.quan(13,3)) end
         )                                                                                                                         as Stock,

         // Association
         _Header,
         _material,
         _DeliveryDocumentItem

}
where
  // matdocitem.PostingDate between $parameters.from_date and $parameters.to_date
  matdocitem.PostingDate <= $parameters.to_date and
  matdocitem.GoodsMovementType <> '321' and // 321 is quality inspection movement, not required in stock report
  matdocitem.GoodsMovementType <> '301' and // 301 is plant to plant transfer posting, not required in stock report
  matdocitem.StorageLocation is not initial and
  matdocitem.Batch is not initial

// and matdocitem.Material    = '000000001350010025' // TODO: remove this line, it is only for testing
