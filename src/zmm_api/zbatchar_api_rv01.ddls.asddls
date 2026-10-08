@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Characteristics Data - Root Entity'
@Metadata.ignorePropagatedAnnotations: true
//@AbapCatalog.preserveKey: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZBATCHAR_API_RV01
  as select from   ZBATCHPROCESSORD_DATA as pr_item 
    left outer join I_Batch   as b  on b.Batch = pr_item.BATCH
                                    and b.Material = pr_item.PRODUCT
                                    and b.Plant <> ' '
    left outer join I_Product     as p    on p.Product = b.Material
    left outer join I_ProductDescription as pd on pd.Product = p.Product
                                         and pd.Language = 'E'
    left outer join ZBATCHAR_DATA as cmfg on  cmfg.Material        = b.Material
                                          and cmfg.Batch           = b.Batch
                                          and cmfg.CharcInternalID = '9999999422'
   left outer join ZBATCHAR_DATA as cexp on  cexp.Material        = b.Material
                                          and cexp.Batch           = b.Batch
                                         and cexp.CharcInternalID = '9999999400'
//   left outer join I_MaterialStock_2 as mat_stck on mat_stck.Batch = b.Batch 
//                                          and mat_stck.Material    = b.Material
//                                          and mat_stck.Plant       = b.Plant
   left outer join ZSD_ALTERNATIVE_UOM_RE as pd_uom on pd_uom.product     = b.Material 
//  left outer join I_MaterialDocumentItem_2 as matdoc on matdoc.Material = cmfg.Material
//                                          and matdoc.Batch         = cmfg.Batch
{
  key b.Batch as Batch_Code, 
  key b.Material as Product,
      pr_item.createdate as createdate,
      b.Plant as PLANT_,
      pd.ProductDescription as Description,
      p.BaseUnit as UOM,
      @Semantics.quantity.unitOfMeasure: 'UOM' 
      p.GrossWeight as gross_qty,
      @Semantics.quantity.unitOfMeasure: 'UOM' 
      p.NetWeight as net_weight,
      cmfg.CharcFromDate as mfgdate,
      cexp.CharcFromDate as expdate,
      @Semantics.quantity.unitOfMeasure: 'UOM' 
      pr_item.batch_size as batch_size,     
      pr_item.cr_date as CRDATE,
      pr_item.currentdate as CURRENTDATE,
//      $session.system_date as currentdate,
//     dats_add_days((cast($session.system_date as abap.dats )), -5, 'INITIAL') as cr_date,
//      matdoc.QuantityInBaseUnit as Size_
//      @Semantics.quantity.unitOfMeasure: 'UOM'
//      sum(mat_stck.MatlWrhsStkQtyInMatlBaseUnit) as stckqty,
      @Semantics.quantity.unitOfMeasure: 'UOM'
      pd_uom.quantitynumerator as base_qty,
      cast(get_numeric_value(pd_uom.quantitynumerator)*( p.GrossWeight)as abap.dec(15,2))as Gross_weight


} where pr_item.createdate >= pr_item.cr_date and pr_item.createdate <= pr_item.currentdate
//order by creationdate asc LIMIT 20
 //group by
//b.Batch,
//b.Material,
//b.Plant,
// pd.ProductDescription,
// p.BaseUnit,
// p.GrossWeight,
// p.NetWeight,
// cmfg.CharcFromDate,
// cexp.CharcFromDate,
// mat_stck.MatlWrhsStkQtyInMatlBaseUnit,
//pd_uom.quantitynumerator



