@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity View for Purchase Register'
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_PURCHASE_REGISTER_REV
  as select from     I_JournalEntry               as JEH
    inner join       I_JournalEntryItem           as JEI         on  JEI.AccountingDocument =  JEH.AccountingDocument
                                                                 and JEI.FiscalYear         =  JEH.FiscalYear
                                                                 and JEI.Ledger             =  '2L'
                                                                 and JEI.LedgerGLLineItem   =  '000001'
                                                                 and JEI.TaxCode            <> ''
    left outer join  I_Supplier                   as Supplier    on Supplier.Supplier = JEI.Supplier
    left outer join  I_CountryText                as Countrytext on  Countrytext.Country  = Supplier.Country
                                                                 and Countrytext.Language = 'E'
    left outer join  I_RegionText                 as Regiontext  on  Regiontext.Country  = Supplier.Country
                                                                 and Regiontext.Region   = Supplier.Region
                                                                 and Regiontext.Language = 'E'
    right outer join I_OperationalAcctgDocItem    as ACI         on  ACI.AccountingDocument =  JEI.AccountingDocument
                                                                 and ACI.FiscalYear         =  JEI.FiscalYear
                                                                 and ACI.ProfitCenter       <> ''
    left outer join  I_PurchaseOrderItemAPI01     as POI         on  POI.PurchaseOrder     = ACI.PurchasingDocument
                                                                 and POI.PurchaseOrderItem = ACI.PurchasingDocumentItem
    left outer join  I_PurchaseOrderAPI01         as POH         on POH.PurchaseOrder = ACI.PurchasingDocument
    left outer join  I_PurchasingDocumentTypeText as POTT        on  POTT.PurchasingDocumentType     = POH.PurchaseOrderType
                                                                 and POTT.PurchasingDocumentCategory = POI.PurchaseOrderCategory
                                                                 and POTT.Language                   = 'E'
    left outer join  I_ProductText                as PRT         on  PRT.Product  = ACI.Product
                                                                 and PRT.Language = 'E'
    left outer join  I_GLAccountText              as GLT         on  GLT.GLAccount = ACI.GLAccount
                                                                 and GLT.Language  = 'E'

    left outer join  I_OperationalAcctgDocItem    as CGST        on  CGST.AccountingDocument           = ACI.AccountingDocument
                                                                 and CGST.FiscalYear                   = ACI.FiscalYear
                                                                 and CGST.TaxItemGroup                 = ACI.TaxItemGroup
                                                                 and CGST.AccountingDocumentItemType   = 'T'
                                                                 and CGST.TransactionTypeDetermination = 'JIC'
    left outer join  I_OperationalAcctgDocItem    as IGST        on  IGST.AccountingDocument           = ACI.AccountingDocument
                                                                 and IGST.FiscalYear                   = ACI.FiscalYear
                                                                 and IGST.TaxItemGroup                 = ACI.TaxItemGroup
                                                                 and IGST.AccountingDocumentItemType   = 'T'
                                                                 and IGST.TransactionTypeDetermination = 'JII' // or JIM
    left outer join  I_OperationalAcctgDocItem    as TDS         on  TDS.AccountingDocument           = ACI.AccountingDocument
                                                                 and TDS.FiscalYear                   = ACI.FiscalYear
                                                                 and TDS.TransactionTypeDetermination = 'WIT'

    left outer join  I_MaterialDocumentItem_2     as MDI         on  MDI.MaterialDocument     = substring(ACI.Reference3IDByBusinessPartner, 5, 10)
                                                                 and MDI.MaterialDocumentItem = cast('0001' as abap.numc(4))
    left outer join  zex_rate                     as MAXEXDATE   on  MAXEXDATE.ExchangeRateType = 'IMP'
                                                                 and MAXEXDATE.documentDate     = ACI.DocumentDate
                                                                 and MAXEXDATE.SourceCurrency   = 'USD'
    left outer join  I_ExchangeRateRawData        as Ratedate    on  Ratedate.ValidityStartDate = MAXEXDATE.SourceDate
                                                                 and Ratedate.ExchangeRateType  = 'IMP'
                                                                 and Ratedate.SourceCurrency    = 'USD'

{
  key ACI.AccountingDocument                             as GLNumber,
  key ACI.AccountingDocumentItem                         as GLItem,
  key ACI.FiscalYear                                     as GRYear,
  key POH.PurchaseOrder                                  as PurchaseOrder,
      POH.PurchaseOrderType                              as PurchaseType,
      substring(ACI.Reference3IDByBusinessPartner,5,10)  as GRDocument, //5 is place, !0 is length
      substring(ACI.Reference3IDByBusinessPartner, 15,4) as GRDocumentItem,
      ACI.PostingDate                                    as GRPostingDate,
      substring(ACI.OriginalReferenceDocument,1,10)      as FIInvoiceNo,
      ACI.PostingDate                                    as FIInvoiceDate,
      JEH.DocumentReferenceID                            as SupplierInvoiceNo,
      ACI.DocumentDate                                   as SupplierInvoiceDate,
      Supplier.Supplier                                  as VendorNo,
      Supplier.SupplierName                              as VendorName,
      //      abap.string'' as acchead,
      //      SIH.SupplierInvoiceIDByInvcgParty as narration,
      //PRT.ProductName                                    as MaterialDescription,
      case
      when ACI.Product is initial
      then POI.PurchaseOrderItemText
      else PRT.ProductName end                           as MaterialDescription,
      ACI.IN_HSNOrSACCode                                as hsnno,
      Countrytext.CountryName                            as Country,
      Regiontext.RegionName                              as State,
      POH.IncotermsClassification                        as pricebasic,
      @Semantics.quantity.unitOfMeasure:    'Baseunit'
      ACI.Quantity                                       as quantity,
      ACI.BaseUnit                                       as Baseunit,
      @Semantics.amount.currencyCode:       'PriceUnit'
      case
       when ACI.AmountInTransactionCurrency is not initial and ACI.Quantity is not initial
       then cast( get_numeric_value(ACI.AmountInTransactionCurrency) / get_numeric_value(ACI.Quantity) as abap.dec( 12, 2 ) )
       else null end                                     as Rate,
      @Semantics.amount.currencyCode:       'PriceUnit'
      JEH.AbsoluteExchangeRate                           as conversionrate,
      abap.string''                                      as discountvalue,
      Ratedate.ExchangeRate                              as ExchangeRate,
      @Semantics.amount.currencyCode:       'PriceUnit'
      case
      when Supplier.SupplierName = 'INDIAN CUSTOMS'
      then cast(POH.PurgReleaseTimeTotalAmount as abap.dec(12,2)) * cast(Ratedate.ExchangeRate as abap.dec(12,2))
      else null end                                      as AssessibleValue,
      @Semantics.amount.currencyCode: 'PriceUnit'
      case
      when Supplier.Supplier = '0130000372' and POH.PurchaseOrderType = 'ZIMP'
      then ACI.AmountInTransactionCurrency
      else null end                                      as Custom_Duty,
      @Semantics.amount.currencyCode: 'PriceUnit'
      case
      when Supplier.Supplier != '0130000372' or POH.PurchaseOrderType != 'ZIMP'
      then ACI.AmountInTransactionCurrency
      else null end                                      as taxablevalue,
      @Semantics.amount.currencyCode: 'PriceUnit_CC'
      case
      when Supplier.Supplier != '0130000372' or POH.PurchaseOrderType != 'ZIMP'
      then cast( JEH.AbsoluteExchangeRate as abap.dec( 12, 2 ) ) * cast( ACI.AmountInTransactionCurrency as abap.dec( 12, 2 ) )
      else null end                                      as taxablevalue_CC,
      JEI.TransactionCurrency                            as PriceUnit,
      JEI.CompanyCodeCurrency                            as PriceUnit_CC,
      @Semantics.amount.currencyCode: 'PriceUnit'
      CGST.AmountInTransactionCurrency                   as cgstamount,
      @Semantics.amount.currencyCode: 'PriceUnit'
      CGST.AmountInTransactionCurrency                   as sgstamount,
      @Semantics.amount.currencyCode: 'PriceUnit'
      IGST.AmountInTransactionCurrency                   as igstamount,
      @Semantics.amount.currencyCode: 'PriceUnit'
      case
      when CGST.TransactionTypeDetermination = 'JIC' or CGST.TransactionTypeDetermination = 'JIS'
      then CGST.AmountInTransactionCurrency + CGST.AmountInTransactionCurrency + ACI.AmountInTransactionCurrency
      when IGST.TransactionTypeDetermination = 'JII'
      then IGST.AmountInTransactionCurrency + ACI.AmountInTransactionCurrency
      else ACI.AmountInTransactionCurrency end           as grossamount,
      case
      when CGST.TransactionTypeDetermination = 'JIC' or CGST.TransactionTypeDetermination = 'JIS'
      then
      cast(CGST.AmountInTransactionCurrency + CGST.AmountInTransactionCurrency + ACI.AmountInTransactionCurrency
                      as abap.dec(17, 2))  * cast(JEH.AbsoluteExchangeRate as abap.dec(17, 2))
      when IGST.TransactionTypeDetermination = 'JII'
      then cast(IGST.AmountInTransactionCurrency + ACI.AmountInTransactionCurrency as abap.dec(17, 2))
           * cast(JEH.AbsoluteExchangeRate as abap.dec(17, 2))
      else cast(ACI.AmountInTransactionCurrency as abap.dec(17, 2)) * cast(JEH.AbsoluteExchangeRate as abap.dec(17, 2))
      end                                                as grossamount_CC,

      case
      when CGST.TransactionTypeDetermination = 'JIC' or CGST.TransactionTypeDetermination = 'JIS'
      then ( ( get_numeric_value(CGST.AmountInTransactionCurrency) * 2 ) / get_numeric_value(ACI.AmountInTransactionCurrency) ) * 100
      when IGST.TransactionTypeDetermination = 'JII'
      then ( get_numeric_value(IGST.AmountInTransactionCurrency) / get_numeric_value(ACI.AmountInTransactionCurrency) ) * 100
      else null end                                      as Taxrate,

      ACI.TaxCode                                        as TaxCode,
      GLT.GLAccountName                                  as GLName,
      @Semantics.amount.currencyCode: 'PriceUnit'
      TDS.AmountInTransactionCurrency                    as TDSAmount,
      Supplier.TaxNumber3                                as Vendor_GST,
      abap.string'B2B'                                   as supplytype,
      case ACI.TaxCode
          when '1A' then 'Exempt'
          when '1B' then 'Exempt'
          when '1H' then 'Exempt'
          when '1I' then 'Exempt'
          when '1O' then 'Capital Goods'
          when '1P' then 'Capital Goods'
          when '1Q' then 'Capital Goods'
          when '1R' then 'Capital Goods'
          when '1S' then 'Tax invoice Not Eligible'
          when '1W' then 'Tax invoice Not Eligible'
          when '1T' then 'Tax invoice Not Eligible'
          when '1U' then 'Tax invoice Not Eligible'
          when '1X' then 'Tax invoice Not Eligible'
          when '1V' then 'Tax invoice Not Eligible'
          when '5A' then 'Import'
          when '5B' then 'Import'
          when '5C' then 'Import'
          when '5D' then 'Import'
          when '5E' then 'import capital goods'
          when '5F' then 'import capital goods'
          when '3A' then 'RCM'
          when '3B' then 'RCM'
          when '3C' then 'RCM'
          when '3D' then 'RCM'
          else 'Tax invoice'
          end                                            as invoicetype,
      case ACI.TaxCode
        when '1S' then 'N'
        when '1W' then 'N'
        when '1T' then 'N'
        when '1U' then 'N'
        when '1X' then 'N'
        when '1V' then 'N'
        else 'Y'
        end                                              as itceligibility,
      case
        when POH.PurchaseOrderType = 'ZCGP' then 'Capital Goods'
        when POH.PurchaseOrderType = 'ZSER' or substring(ACI.IN_HSNOrSACCode, 1, 2) = '99' then 'Input Services'
        else 'Input Goods'
        end                                              as eligibilitycategory,
      MDI.YY1_BOENO_MMI                                  as LR_BL,
      MDI.YY1_BOEDATE_MMI                                as LR_BL_Date,
      MDI.YY1_EWayBillNumber1_MMI                        as EWayBill,
      MDI.YY1_EWayBillDate_MMI                           as EWayBillDate

}
where
      POH.PurchaseOrderType           <> 'ZSTO' //ZSTO for stock transfer
  and POH.PurchaseOrderType           <> 'ZSUB' //ZSUB for sub contracting PO ;
  and JEH.AccountingDocumentType      =  'RE'
  and ACI.AmountInTransactionCurrency <> 0.00 // Remove the line when amount is zero added by ranjan on 25-02-2025
  and Supplier.Supplier               <> '0130000373' // Remove the line when this PRD 0130000373 supplier is coming, because HAMALI COOLIE charges, this is not related to purchse
  and ACI.ProfitCenter                <> '';
