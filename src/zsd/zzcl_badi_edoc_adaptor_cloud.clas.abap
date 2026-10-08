CLASS zzcl_badi_edoc_adaptor_cloud DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_edoc_adaptor_cloud .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZZCL_BADI_EDOC_ADAPTOR_CLOUD IMPLEMENTATION.


  METHOD if_edoc_adaptor_cloud~change_edocument_type.
  ENDMETHOD.


  METHOD if_edoc_adaptor_cloud~change_form.
  ENDMETHOD.


  METHOD if_edoc_adaptor_cloud~change_invoice_type.
  ENDMETHOD.


  METHOD if_edoc_adaptor_cloud~get_variable_key.
  ENDMETHOD.


  METHOD if_edoc_adaptor_cloud~is_relevant.
  ENDMETHOD.


  METHOD if_edoc_adaptor_cloud~restrict_cancel.
  ENDMETHOD.


  METHOD if_edoc_adaptor_cloud~set_output_data.

   FIELD-SYMBOLS: <ls_header_data_action> TYPE any,
                  <ls_doc_data> TYPE any .

   ASSIGN cs_output_data-('REQUEST-HEADER_DATA-ACTION') TO <ls_header_data_action>.

   IF <ls_header_data_action> IS ASSIGNED and IV_EDOC_TYPE = 'IN_EWB' .

       READ table is_source_data-sd_partner_data INTO DATA(billto_party) with key parvw = 'RE'.
       IF SY-SUBRC = 0.
            SELECT SINGLE TaxNumber3 FROM I_Customer WITH PRIVILEGED ACCESS AS Customer
                where Customer = @billto_party-kunnr
                INTO @DATA(ls_billto_TaxNumber3).
       ENDIF.

       READ table is_source_data-sd_partner_data INTO DATA(shipto_party) with key parvw = 'WE'.
       IF SY-SUBRC = 0.
              SELECT SINGLE * FROM I_Customer WITH PRIVILEGED ACCESS AS Customer
                INNER JOIN I_Address_2 WITH PRIVILEGED ACCESS AS Address
                ON Address~AddressID = Customer~AddressID
                where Customer~Customer = @shipto_party-kunnr
                INTO @DATA(ls_shipto_address).
       ENDIF.

       IF ls_billto_TaxNumber3 = ls_shipto_address-customer-TaxNumber3.
          ASSIGN cs_output_data-('REQUEST-DOC_DATA') TO <ls_doc_data>.
    	  IF <ls_doc_data> IS ASSIGNED.
             <lS_DOC_DATA>-('TRANSACTION_TYPE') = '1'.
             <lS_DOC_DATA>-('SHIP_TO_GSTIN') = ' '.
             <lS_DOC_DATA>-('SHIP_TO_TRADE_NAME') = ' '.
             <lS_DOC_DATA>-('TO_ADDR1') = ls_shipto_address-address-Street.
             <lS_DOC_DATA>-('TO_ADDR2') = |{ ls_shipto_address-address-StreetPrefixName1 }{ ls_shipto_address-address-StreetPrefixName2 }{ ls_shipto_address-address-CityName }|.
             <lS_DOC_DATA>-('TO_PLACE') = ls_shipto_address-address-CityName.
             <lS_DOC_DATA>-('TO_PINCODE') = ls_shipto_address-address-PostalCode.
    	  endif.
       ENDIF.

    ENDIF.
  ENDMETHOD.
ENDCLASS.
