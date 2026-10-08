@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity View for Landed Cost report'
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZZMM_LANDED_COST_REV 
  as select from     I_JournalEntry               as JEH
    inner join       I_JournalEntryItem           as JEI      on  JEI.AccountingDocument =  JEH.AccountingDocument
                                                              and JEI.FiscalYear         =  JEH.FiscalYear
                                                              and JEI.Ledger             =  '2L'
                                                              and JEI.LedgerGLLineItem   =  '000001'
                                                              and JEI.TaxCode            <> ''
    left outer join  I_Supplier                   as Supplier on Supplier.Supplier = JEI.Supplier
    right outer join I_OperationalAcctgDocItem    as ACI      on  ACI.AccountingDocument =  JEI.AccountingDocument
                                                              and ACI.FiscalYear         =  JEI.FiscalYear
                                                              and ACI.ProfitCenter       <> ''
                                                              and ACI.AmountInTransactionCurrency > 0
    left outer join  I_MaterialDocumentItem_2     as MDI      on  MDI.MaterialDocumentYear = ACI.FiscalYear 
                                                              and MDI.MaterialDocument = substring(ACI.Reference3IDByBusinessPartner,5,10) 
                                                              and MDI.MaterialDocumentItem = substring(ACI.Reference3IDByBusinessPartner,15,4)                                                   
    left outer join  I_PurchaseOrderItemAPI01     as POI      on  POI.PurchaseOrder     = ACI.PurchasingDocument
                                                              and POI.PurchaseOrderItem = ACI.PurchasingDocumentItem
    left outer join  I_PurchaseOrderAPI01         as POH      on POH.PurchaseOrder = ACI.PurchasingDocument
    left outer join  I_PurchasingDocumentTypeText as POTT     on  POTT.PurchasingDocumentType     = POH.PurchaseOrderType
                                                              and POTT.PurchasingDocumentCategory = POI.PurchaseOrderCategory
                                                              and POTT.Language                   = 'E'
    left outer join  I_ProductText                as PRT      on  PRT.Product  = ACI.Product
                                                              and PRT.Language = 'E'
    left outer join  I_GLAccountText              as GLT      on  GLT.GLAccount = ACI.GLAccount
                                                              and GLT.Language  = 'E'
    left outer join  I_OperationalAcctgDocItem    as CGST     on  CGST.AccountingDocument           = ACI.AccountingDocument
                                                              and CGST.FiscalYear                   = ACI.FiscalYear
                                                              and CGST.TaxItemGroup                 = ACI.TaxItemGroup
                                                              and CGST.AccountingDocumentItemType   = 'T'
                                                              and CGST.TransactionTypeDetermination = 'JIC'
    left outer join  I_OperationalAcctgDocItem    as IGST     on  IGST.AccountingDocument           = ACI.AccountingDocument
                                                              and IGST.FiscalYear                   = ACI.FiscalYear
                                                              and IGST.TaxItemGroup                 = ACI.TaxItemGroup
                                                              and IGST.AccountingDocumentItemType   = 'T'
                                                              and IGST.TransactionTypeDetermination = 'JII' // or JIM   
    left outer join  I_PurOrdItmPricingElementAPI01 as ZDGV on ZDGV.PurchaseOrder = ACI.PurchasingDocument 
                                                            and ZDGV.PurchaseOrderItem = ACI.PurchasingDocumentItem
                                                            and ZDGV.ConditionType = 'ZDGV' // ZDGV = Discount value                                                         
    left outer join  I_PurOrdItmPricingElementAPI01 as ZJCD on ZJCD.PurchaseOrder = ACI.PurchasingDocument 
                                                            and ZJCD.PurchaseOrderItem = ACI.PurchasingDocumentItem
                                                            and ZJCD.ConditionType = 'ZJCD' // ZJCD = Customs Duty %
    left outer join  I_PurOrdItmPricingElementAPI01 as ZACE on ZACE.PurchaseOrder = ACI.PurchasingDocument 
                                                            and ZACE.PurchaseOrderItem = ACI.PurchasingDocumentItem
                                                            and ZACE.ConditionType = 'ZACE' // ZACE = Addnl Customs Duty
    left outer join  I_PurOrdItmPricingElementAPI01 as ZLIN on ZLIN.PurchaseOrder = ACI.PurchasingDocument 
                                                            and ZLIN.PurchaseOrderItem = ACI.PurchasingDocumentItem
                                                            and ZLIN.ConditionType = 'ZLIN' // ZLIN = Liner charges
    left outer join  I_PurOrdItmPricingElementAPI01 as ZLOV on ZLOV.PurchaseOrder = ACI.PurchasingDocument 
                                                            and ZLOV.PurchaseOrderItem = ACI.PurchasingDocumentItem
                                                            and ZLOV.ConditionType = 'ZLOV' // ZLOV = CFS charges (Val)
    left outer join  I_PurOrdItmPricingElementAPI01 as ZOCF on ZOCF.PurchaseOrder = ACI.PurchasingDocument 
                                                            and ZOCF.PurchaseOrderItem = ACI.PurchasingDocumentItem
                                                            and ZOCF.ConditionType = 'ZOCF' // ZOCF = Ocean Freight (Val)
    left outer join  I_PurOrdItmPricingElementAPI01 as ZSWC on ZSWC.PurchaseOrder = ACI.PurchasingDocument 
                                                            and ZSWC.PurchaseOrderItem = ACI.PurchasingDocumentItem
                                                            and ZSWC.ConditionType = 'ZSWC' // ZSWC = Social Welfare Cess
    left outer join  I_PurOrdItmPricingElementAPI01 as ZPFV on ZPFV.PurchaseOrder = ACI.PurchasingDocument 
                                                            and ZPFV.PurchaseOrderItem = ACI.PurchasingDocumentItem
                                                            and ZPFV.ConditionType = 'ZPFV' // ZPFV = CHA charges (Val)                                                  
{
  key ACI.AccountingDocument                            as GLNumber,
  key ACI.AccountingDocumentItem                        as GLItem,
  key ACI.FiscalYear                                    as GRYear,
  key POH.PurchaseOrder                                 as PurchaseOrder,
      POH.PurchaseOrderType                             as PurchaseType,
      substring(ACI.Reference3IDByBusinessPartner,5,10) as GRDocument, //5 is place, !0 is length
      ACI.PostingDate                                   as GRPostingDate,
      MDI.Batch,
      substring(ACI.OriginalReferenceDocument,1,10)     as SupplierInvoiceNo,
      ACI.PostingDate                                   as SupplierInvoiceDate,
      Supplier.SupplierName                             as VendorName,
      //      abap.string'' as acchead,
      //      SIH.SupplierInvoiceIDByInvcgParty as narration,
      PRT.ProductName                                   as MaterialDescription,
      ACI.IN_HSNOrSACCode                               as hsnno,
      POH.IncotermsTransferLocation                     as Country,
      POH.IncotermsClassification                       as pricebasic,
      @Semantics.quantity.unitOfMeasure:    'Baseunit'
      ACI.Quantity                                      as quantity,
      ACI.BaseUnit                                      as Baseunit,
      @Semantics.amount.currencyCode:       'PriceUnit'
      case
       when ACI.AmountInTransactionCurrency is not initial and ACI.Quantity is not initial
       then cast( get_numeric_value(ACI.AmountInTransactionCurrency) / get_numeric_value(ACI.Quantity) as abap.dec( 12, 2 ) )
       else null end                                    as Rate,
      @Semantics.amount.currencyCode:       'PriceUnit'
      ACI.AmountInTransactionCurrency                   as taxablevalue,
      ACI.TransactionCurrency                           as PriceUnit,
      // @Semantics.amount.currencyCode:       'PriceUnit'
      ZDGV.ConditionRateValue as discountvalue,
      ZJCD.ConditionRateValue as customduty,
      ZACE.ConditionRateValue as addl_customduty,
      ZSWC.ConditionRateValue as cess_charge,
      ZOCF.ConditionRateValue as freight,
      ZLIN.ConditionRateValue as liner_charges,
      ZLOV.ConditionRateValue as cfa_charges,
//      coolie,
//      other_duty_charges,
      @Semantics.amount.currencyCode: 'PriceUnit'
      IGST.AmountInTransactionCurrency                  as igstamount,
      @Semantics.amount.currencyCode: 'PriceUnit'
      CGST.AmountInTransactionCurrency                  as cgstamount,
      @Semantics.amount.currencyCode: 'PriceUnit'
      CGST.AmountInTransactionCurrency                  as sgstamount,  
      @Semantics.amount.currencyCode: 'PriceUnit'
      case
      when CGST.TransactionTypeDetermination = 'JIC' or CGST.TransactionTypeDetermination = 'JIS'
      then CGST.AmountInTransactionCurrency + CGST.AmountInTransactionCurrency + ACI.AmountInTransactionCurrency
      when IGST.TransactionTypeDetermination = 'JII'
      then IGST.AmountInTransactionCurrency + ACI.AmountInTransactionCurrency
      else ACI.AmountInTransactionCurrency end          as grossamount

}
where
      POH.PurchaseOrderType      <> 'ZSTO' //ZSTO for stock transfer
  and POH.PurchaseOrderType      <> 'ZSUB' //ZSUB for sub contracting PO ;
  and JEH.AccountingDocumentType =  'RE';

