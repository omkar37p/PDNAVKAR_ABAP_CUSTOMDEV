@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Commision Report - Projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZSD_COMM_PV provider contract transactional_query
  as projection on ZSD_COMM_REN
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
    pyname,
    shpno,
    shpname,
    pin,
    ewayno,
    lrno,
    lrdt,
    pono,
    transporterid,
    sutprid,
    sfn,
    deliv,
    uomname,
     comno,
    comname,
    curr,
    @Semantics.amount.currencyCode: 'curr'
    comamt,
    @Semantics.amount.currencyCode: 'fcurr'
    frightptt,
    frightptrtot,
    fcurr,
    @Semantics.amount.currencyCode: 'frcurr'
    frightrfc,
    frightrfctot,
    frcurr,
currr,
@Semantics.amount.currencyCode: 'currr'
    basenet,
    overallstus,
    @Semantics.amount.currencyCode: 'currr'
    baseamt,
    OriginalInvoiceNumber
//    NetAmountCriticality
}
