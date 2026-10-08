@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Final Material Stock view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@AbapCatalog.viewEnhancementCategory: [#NONE]
@ObjectModel.usageType:{ serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }
define view entity ZMStock_final
with parameters
//@EndUserText: { label: 'From Date' } 
    from_date : erdat,      // abap.dats is not suppoted service binding
//@EndUserText: { label: 'To Date' } 
    to_date   : erdat       // abap.dats is not suppoted service binding
//  as select from ZMSTOCK_TF( from_date: $parameters.from_date, to_date: $parameters.to_date ) as _ZMSTOCK_TF
  as select from ZMSTOCK_TF( to_date: $parameters.to_date ) as _ZMSTOCK_TF
  left outer join ZMStock_base(
 //   from_date: $parameters.from_date,
    to_date: $parameters.to_date
  ) as _Base
  on _ZMSTOCK_TF.matdoc = _Base.Matdoc and
     _ZMSTOCK_TF.matdocitem = _Base.Matdocitem and
     _ZMSTOCK_TF.Matdocyear = _Base.Matdocyear

{
  key _ZMSTOCK_TF.record_id,
  key _ZMSTOCK_TF.Matdocyear,
  key _ZMSTOCK_TF.matdoc,
  key _ZMSTOCK_TF.matdocitem,
      _ZMSTOCK_TF.documentdate,
      _ZMSTOCK_TF.postingdate,
      _Base.Division,
      _Base.Productgroup,
      _Base.DistributionChannel,
      _ZMSTOCK_TF.material,
      _Base.Materialname,
      _Base.Companycode,
      _ZMSTOCK_TF.plant,
      _Base.Storagelocation,
      _Base.Batch,
      _Base.Movementtype,
      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
      _ZMSTOCK_TF.stock,
      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
      _ZMSTOCK_TF.open_stock,
      ' ' as os_StockRate,
      ' ' as Os_Stockvalue,
      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
      _Base.ProductionQty,
      ' ' as ProductionRate,
      ' ' as ProductionValue, 
      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
      _Base.PurchaseQty,
      ' ' as PurchaseRate,
      ' ' as PurchaseValue,    
      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
      _Base.TradingQty,     
      ' ' as TradingRate,
      ' ' as TradingValue,
      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
      _Base.Loc_Trf_InQty,
      ' ' as Loc_Trf_InRate,
      ' ' as Loc_Trf_InValue,
      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
      _Base.WriteBackQty,
      ' ' as WriteBackRate,
      ' ' as WriteBackValue,
      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
      _Base.Total_InwardQty,
      '' as Total_InwardRate,
      '' as Total_InwardValue,
      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
      _Base.DomesticSalesQty,
      '' as DomesticSalesRate,
      '' as DomesticSalesValue,
      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
      _Base.DeemedExportQty,
      '' as DeemedExportRate,
      '' as DeemedExportValue,
      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
      _Base.SEZSalesQty,
      '' as SEZSalesRate,
      '' as SEZSalesValue,
      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
      _Base.ExportQty,
      '' as ExportRate,
      '' as ExportValue,
      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
      _Base.NetSalesQty,
      '' as NetSalesRate,
      '' as NetSalesValue,
      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
      _Base.JobWorkQty,
      '' as JobWorkRate,
      '' as JobWorkValue,
      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
      _Base.ProductionIssueQty,
      '' as ProductionIssueRate,
      '' as ProductionIssueValue,
      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
      _Base.Loc_Trf_OutQty,
      ' ' as Loc_Trf_OutRate,
      ' ' as Loc_Trf_OutValue,
      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
      _Base.ReProcessQty,
      ' ' as ReProcessRate,
      ' ' as ReProcessValue,
      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
      _Base.WriteOffQty,
      '' as WriteOffRate,
      '' as WriteOffValue,
      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
      _Base.Total_OutQty,
      ' ' as Total_OutRate,
      ' ' as Total_OutValue,
      @Semantics.quantity.unitOfMeasure: 'Material_UOM'
      _ZMSTOCK_TF.total_stock,
      '' as Total_StockRate,
      '' as Total_StockValue,
      _ZMSTOCK_TF.Material_UOM
}

where _ZMSTOCK_TF.postingdate between $parameters.from_date and $parameters.to_date
