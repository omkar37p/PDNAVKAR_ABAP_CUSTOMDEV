CLASS zztest_class DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZZTEST_CLASS IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

   " DATA itab TYPE TABLE OF zmm_t_ranjan.

  "  TYPES: BEGIN OF ty_output,
  "           lv_bill_doc  TYPE i_billingdocumentitem-billingdocument,
  "           lv_bill_item TYPE i_billingdocumentitem-billingdocumentitem,
  "         END OF ty_output.
  "  DATA: lt_output TYPE TABLE OF ty_output,
  "        ls_output TYPE ty_output.

 "  select from I_SupplierInvoiceAPI01 as SI
 "   left outer join I_SuplrInvcItemPurOrdRefAPI01 as SPR on SPR.SupplierInvoice = SI.SupplierInvoice and SPR.FiscalYear = SI.FiscalYear
  " // inner join I_ProductText as PRT on PRT.Product = SPR.PurchaseOrderItemMaterial and PRT.Language = 'E'
  "  //INNER JOIN I_PurchaseOrderAPI01 AS POH ON SII-PurchaseOrder = POH.PurchaseOrder
  "  //       " INNER JOIN I_PURCHASEORDERITEMAPI01 AS POI ON SII~PurchaseOrder EQ POI~PurchaseOrder
  "  //       " LEFT OUTER JOIN I_Supplier AS SUP ON POH~Supplier EQ SUP~Supplier
   "      key SI.SupplierInvoice,
   "       SI.DocumentDate,
    "      SI.InvoicingParty,
    "      SI.SupplierInvoiceIDByInvcgParty,
    "      SPR.PurchaseOrderItemMaterial

    SELECT * FROM I_SupplierInvoiceAPI01 as SI
      left outer join I_SuplrInvcItemPurOrdRefAPI01 as SPR on SPR~SupplierInvoice = SI~SupplierInvoice and SPR~FiscalYear = SI~FiscalYear
    WHERE SI~SupplierInvoice = '5105600101'
    INTO TABLE @data(GT_SInvoice).

*   output the result as a console message
    out->write( |{ sy-dbcnt } employee entries inserted successfully!| ).

  ENDMETHOD.
ENDCLASS.
