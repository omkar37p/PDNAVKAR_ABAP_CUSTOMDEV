@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View -  GSTR1 Dispatch Report'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZSD_GSTR1_DT_PV provider contract transactional_query
  as projection on ZSD_GSTR1_DT_RE
{
    key billdoc,
    key billitem,
    invoiceno,
    invoicedt,
    hsncode,
    desct,
    uom,
    @Semantics.quantity.unitOfMeasure: 'uom'
    billqty,
    Batch,
    stpno,
    stpname,
    btpno,
    btpname,
    pyno,
    shpno,
    shpname,
    pin,
    pyname,
    ewayno,
    ewaydate,
    lrno,
    lrdt,
    pono,
    transporterid,
    sutprid,
    sfn,
    deliv,
    uomname,
    @Semantics.amount.currencyCode: 'fcurr'
    frightptt,
    @Semantics.quantity.unitOfMeasure: 'uom'
     dgi,
    frightptrtot,
    fcurr,
    @Semantics.amount.currencyCode: 'frcurr'
    frightrfc,
   frightrfctot,
    frcurr,
    inconame
    
}
