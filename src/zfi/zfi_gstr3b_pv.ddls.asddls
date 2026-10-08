@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR3B Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZFI_GSTR3B_PV 
provider contract transactional_query
  as projection on ZZFI_GSTR3B_REV
{
      key documentnumber,
      key FiscalYear,
      key CompanyCode,
      key TaxItemGroup,
          itemdescription,
          buyergstin,
          suppliergstin,
          suppliername,
          invoicestatus,
          supplytype,
          invoiceno,
          invoicedate,
          invoicetype,
          notenumber,
          notedate,
          hsn_sac,
          @Semantics.quantity.unitOfMeasure: 'uqc'
          quantity,
          uqc,
          @Semantics.amount.currencyCode: 'Curr' 
          invoicevalue,
        //  @Semantics.amount.currencyCode: 'Curr' 
          notevalue,
          @Semantics.amount.currencyCode: 'Curr' 
          taxablevalue,
          Curr,
          GSTRATE,
          @Semantics.amount.currencyCode: 'Curr' 
          cgstamount,
          @Semantics.amount.currencyCode: 'Curr' 
          sgstamount,
          @Semantics.amount.currencyCode: 'Curr' 
          igstamount,
          @Semantics.amount.currencyCode: 'Curr' 
          cessamount,         
          itceligibility,
          eligibilitycategory,
          reversecharge,
          importtype,
          gstr2returnperiod,
          b3auto_fillperiod,
          documentdate,
          CCURR,
           @Semantics.amount.currencyCode: 'CCURR' 
          taxablevalue_1,
           @Semantics.amount.currencyCode: 'CCURR' 
          cgstamount_1,
           @Semantics.amount.currencyCode: 'CCURR' 
          sgstamount_1,
           @Semantics.amount.currencyCode: 'CCURR' 
          igstamount_1
          
                     
}

