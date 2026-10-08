@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Quantity Summation'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_QUAN_SUM
//  with parameters
//    inputdate : abap.dats
  as select from I_MaterialDocumentItem_2 as matdocitem
  //    left outer join ZI_OPENING_STOCK( inputdate: $parameters.inputdate ) as openstock on  openstock.Material = matdocitem.Material
  //                                                                                      and openstock.Plant    = matdocitem.Plant
  //    left outer join ZI_OPENING_STOCK         as openstock on  openstock.Material = matdocitem.Material
  //                                                          and openstock.Plant    = matdocitem.Plant
{
  key    matdocitem.MaterialDocument                                                                                               as Matdoc,
  key    matdocitem.MaterialDocumentItem                                                                                           as Matdocitem,
         matdocitem.PostingDate                                                                                                    as Postingdate,
         matdocitem.Material                                                                                                       as Material,
         matdocitem.Plant                                                                                                          as Plant,
         matdocitem.Batch                                                                                                          as Batch,
         matdocitem.GoodsMovementType                                                                                              as Movementtype,
         @Semantics.quantity.unitOfMeasure: 'Materialunit'
         matdocitem.QuantityInBaseUnit                                                                                             as Quantity,
         matdocitem.MaterialBaseUnit                                                                                               as MaterialUnit,
         @Semantics.quantity.unitOfMeasure: 'Materialunit'
         case matdocitem.GoodsMovementType when '101' then matdocitem.QuantityInBaseUnit else cast('0.000' as abap.quan(13,3)) end as Quantity_101,
         @Semantics.quantity.unitOfMeasure: 'Materialunit'
         case matdocitem.GoodsMovementType when '561' then matdocitem.QuantityInBaseUnit else cast('0.000' as abap.quan(13,3)) end as Quantity_561,
         @Semantics.quantity.unitOfMeasure: 'Materialunit'
         case matdocitem.GoodsMovementType when '601' then matdocitem.QuantityInBaseUnit else cast('0.000' as abap.quan(13,3)) end as Quantity_601,
         @Semantics.quantity.unitOfMeasure: 'Materialunit'
         case matdocitem.GoodsMovementType when '641' then matdocitem.QuantityInBaseUnit else cast('0.000' as abap.quan(13,3)) end as Quantity_641,
         @Semantics.quantity.unitOfMeasure: 'Materialunit'
         case matdocitem.GoodsMovementType when '653' then matdocitem.QuantityInBaseUnit else cast('0.000' as abap.quan(13,3)) end as Quantity_653,
         @Semantics.quantity.unitOfMeasure: 'Materialunit'
         (
           case matdocitem.GoodsMovementType when '101' then matdocitem.QuantityInBaseUnit else cast('0.000' as abap.quan(13,3)) end +
           case matdocitem.GoodsMovementType when '561' then matdocitem.QuantityInBaseUnit else cast('0.000' as abap.quan(13,3)) end -
           case matdocitem.GoodsMovementType when '601' then matdocitem.QuantityInBaseUnit else cast('0.000' as abap.quan(13,3)) end -
           case matdocitem.GoodsMovementType when '641' then matdocitem.QuantityInBaseUnit else cast('0.000' as abap.quan(13,3)) end +
           case matdocitem.GoodsMovementType when '653' then matdocitem.QuantityInBaseUnit else cast('0.000' as abap.quan(13,3)) end
         )                                                                                                                         as Stock,
         @Semantics.quantity.unitOfMeasure: 'Materialunit'
         cast( 0 as abap.quan( 13, 3 ))                                                                                            as OpeningStock,
         @Semantics.quantity.unitOfMeasure: 'Materialunit'
         cast( 0 as abap.quan( 13, 3 ))                                                                                            as TotalStock

}
//where
//  matdocitem.PostingDate < $parameters.inputdate
