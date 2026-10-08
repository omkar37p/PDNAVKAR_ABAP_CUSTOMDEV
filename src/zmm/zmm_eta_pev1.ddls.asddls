@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection entity view eta report'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}


define view entity zmm_eta_PEV1 as select from zmm_eta__REV
{
    key PONUM,
    key lineitem,
    key PODT,
    key PLANT,
    key POTYPE,
    key POITMTXT,
    key SUPP,
    APPROXETAPLANT,
    BE,
    BLLRNO,
    CHAINV,
    CHA,
    CHKLST,
    DRAFTDOC,
    DUTYPAY,
    FASSIPAY,
    ZLABEL,
    LINERPAY,
    MISC,
    ORGDOC,
    PAY,
    ZREAMAK,
    SUPPPAY,
    TELEXBL,
    TRNSP,
    BLLRDT,
    PORTDT,
    PORTNAME,
    ZDOCCURRY,
    @Semantics.amount.currencyCode: 'ZDOCCURRY'
    NETAMT,
    ORDUNIT,
    @Semantics.quantity.unitOfMeasure: 'ORDUNIT'
    ORDQTY,
    SUPPNAME,
    QTYUNIT,
    @Semantics.quantity.unitOfMeasure: 'QTYUNIT'
    QTY,
    @Semantics.quantity.unitOfMeasure: 'QTYUNIT'
    PendingQty
    
    
}
