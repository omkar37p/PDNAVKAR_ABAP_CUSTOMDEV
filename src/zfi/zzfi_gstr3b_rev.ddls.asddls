@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity View for GSTR3B'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZZFI_GSTR3B_REV as select from  ZFI_GSTR3B_GRP as ACI                                                                               
      left outer join I_PurchaseOrderItemAPI01 as POI on POI.PurchaseOrder =  ACI.PurchasingDocument
                                               and POI.PurchaseOrderItem = ACI.PurchasingDocumentItem
      left outer join I_PurchaseOrderAPI01 as POH on POH.PurchaseOrder = ACI.PurchasingDocument 
      left outer join I_PurchasingDocumentTypeText as POTT on POTT.PurchasingDocumentType = POH.PurchaseOrderType
                                               and POTT.PurchasingDocumentCategory = POI.PurchaseOrderCategory 
                                               and POTT.Language = 'E'
      left outer join I_ProductText as PRT on PRT.Product = ACI.Product and PRT.Language = 'E'
      left outer join I_GLAccountText as GLT on GLT.GLAccount = ACI.GLAccount and  GLT.Language = 'E'
                                  
                                               
                                               
   { 
      key ACI.AccountingDocument as documentnumber,
      key ACI.FiscalYear as FiscalYear,
      key ACI.CompanyCode, 
      key ACI.TaxItemGroup,
          case
          when PRT.ProductName is not initial
          then PRT.ProductName
          else GLT.GLAccountName end as itemdescription,
          abap.string'29AAECP8133C1ZH' as buyergstin,
          ACI.TaxNumber3 as suppliergstin,
          ACI.SupplierName as suppliername,
          abap.string'New' as invoicestatus,
          abap.string'B2B' as supplytype,        
          ACI.DocumentReferenceID as invoiceno,
          ACI.DocumentDate as invoicedate,
          case ACI.TaxCode
          when '1A' then 'Exempt' 
          when '1H' then 'Exempt' 
          when '1I' then 'Zero tax'  
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
          end as invoicetype,
          abap.string'' as notenumber, 
          abap.string'' as notedate,
          ACI.IN_HSNOrSACCode  as hsn_sac,
          @Semantics.quantity.unitOfMeasure: 'uqc'
          POI.OrderQuantity as quantity,
          case 
          when POH.PurchaseOrderType = 'ZSER' or substring(ACI.IN_HSNOrSACCode, 1, 2) = '99'
          then cast( 'EA' as abap.unit( 2 ))
          else POI.BaseUnit 
          end as uqc,
         // POI.BaseUnit as uqc,
          @Semantics.amount.currencyCode: 'Curr' 
        case  
        when ACI.TransactionTypeDetermination = 'JIC' 
          then cast(ACI.CGST_T + ACI.CGST_T + ACI.AmountInTransactionCurrency as abap.dec(23,2)) // CHANGE CURR TO DEC
         when ACI.TransactionTypeDeterminationI = 'JII' 
         then cast(ACI.IGST_T + ACI.AmountInTransactionCurrency as abap.dec(23,2))
          when ACI.TransactionTypeDeterminationI1 = 'JIM'
          then cast(ACI.IGST1_T + ACI.AmountInTransactionCurrency as abap.dec(23,2)) 
          else cast(ACI.AmountInTransactionCurrency as abap.dec( 23, 2)) end as invoicevalue,
      //  @Semantics.amount.currencyCode: 'Curr'
     abap.string'' as notevalue,
          @Semantics.amount.currencyCode: 'Curr'
          ACI.AmountInTransactionCurrency as taxablevalue,
          ACI.TransactionCurrency as Curr,
          @Semantics.amount.currencyCode: 'Curr' 
          ACI.CGST_T  as cgstamount,
          @Semantics.amount.currencyCode: 'Curr' 
          ACI.CGST_T as sgstamount,
          @Semantics.amount.currencyCode: 'Curr' 
          case
         when ACI.TransactionTypeDeterminationI = 'JII'
         then ACI.IGST_T
         when ACI.TransactionTypeDeterminationI1 = 'JIM'
         then ACI.IGST1_T
         else null end as igstamount ,
       case 
      when ACI.TransactionTypeDetermination = 'JIC' 
       then
        case ACI.TaxCode
          when '1H' then '0.00' 
          when '1I' then '0.00'         
          when '1J' then '0.10'
          when '1K' then '5.00'
          when '1L' then '12.00'
          when '1M' then '18.00'
          when '1N' then '28.00'     
          when '1Q' then '18.00'
          when '1R' then '28.00'      
          when '1U' then '5.00'
          when '1X' then '12.00'
          when '1V' then '18.00'           
          when '3C' then '5.00'
          when '3D' then '5.00'
          else null end
       else
      case when ACI.TransactionTypeDeterminationI = 'JII' or ACI.TransactionTypeDeterminationI1 = 'JIM'
      then 
      case ACI.TaxCode 
      when '1A' then '0.00'
      when '1B' then '0.00'
      when '1C' then '0.10'
      when '1D' then '5.00' 
      when '1E' then '12.00'
      when '1F' then '18.00'
      when '1G' then '28.00'
      when '1O' then '18.00'
      when '1P' then '28.00'
      when '1S' then '5.00'
      when '1W' then '12.00'
      when '1T' then '18.00'
      when '5A' then '5.00'
      when '5B' then '12.00'
      when '5C' then '18.00'
      when '5D' then '28.00'
      when '5E' then '18.00'
      when '5F' then '28.00'
      when '3A' then '5.00'
      when '3B' then '18.00'
      else null end
      else '0.00'
        end
end as GSTRATE,
          @Semantics.amount.currencyCode: 'Curr' 
          abap.curr'0.00' as cessamount,
          case ACI.TaxCode
          when '1S' then 'N'
          when '1W' then 'N'
          when '1T' then 'N'
          when '1U' then 'N'
          when '1X' then 'N'
          when '1V' then 'N'
          else 'Y' 
          end as itceligibility,         
          case 
          when POH.PurchaseOrderType = 'ZCGP' then 'Capital Goods'
          when POH.PurchaseOrderType = 'ZSER' or substring(ACI.IN_HSNOrSACCode, 1, 2) = '99' then 'Input Services'
          else 'Input Goods' 
          end as eligibilitycategory,
          case ACI.TaxCode
          when '3A' then 'Y'
          when '3B' then 'Y'
          when '3C' then 'Y'
          when '3D' then 'Y'
          else 'N' 
          end as reversecharge,
          case 
          when POH.PurchaseOrderType = 'ZSER' or substring(ACI.IN_HSNOrSACCode, 1, 2) = '99' 
          
            then ' '                 // change by omkar  04.07.2024
          when POH.PurchaseOrderType = 'ZIMP' and POI.ProductType = '1' then 'Goods Import'
          when POH.PurchaseOrderType = 'ZIMP' and POI.ProductType = '2' then 'Service Import'
          //when eligibilitycategory = 'Input Services' then 'Domestic Service' 
          else null end as importtype,
          ACI.FiscalYearPeriod as gstr2returnperiod, 
          ACI.FiscalYearPeriod as b3auto_fillperiod,
          ACI.PostingDate as documentdate   ,
          
          // FOR COMPANY CURRENECY
           
          ACI.CompanyCodeCurrency as CCURR,
          @Semantics.amount.currencyCode: 'CCURR' 
          case  
          when ACI.TransactionTypeDetermination = 'JIC' 
          then cast(ACI.CGST_C + ACI.CGST_C + ACI.AmountInCompanyCodeCurrency as abap.dec(23,2)) // CHANGE CURR TO DEC
          when ACI.TransactionTypeDeterminationI = 'JII' 
          then cast(ACI.IGST_C + ACI.AmountInCompanyCodeCurrency as abap.dec(23,2))
          when ACI.TransactionTypeDeterminationI1 = 'JIM'
          then cast(ACI.IGST1_C + ACI.AmountInCompanyCodeCurrency as abap.dec(23,2)) 
          else cast(ACI.AmountInCompanyCodeCurrency as abap.dec( 23, 2)) end as invoicevalue_1,
            @Semantics.amount.currencyCode: 'CCURR' 
           ACI.AmountInCompanyCodeCurrency as taxablevalue_1,
            @Semantics.amount.currencyCode: 'CCURR' 
  
    ACI.CGST_C  as cgstamount_1,
    @Semantics.amount.currencyCode: 'CCURR'
    ACI.CGST_C  as sgstamount_1,
          @Semantics.amount.currencyCode: 'CCURR' 
          case
         when ACI.TransactionTypeDeterminationI = 'JII'
         then ACI.IGST_C 
         when ACI.TransactionTypeDeterminationI1 = 'JIM'
         then ACI.IGST1_C
         else null end as igstamount_1
          
          
          
                 
    } 
      
      
      
