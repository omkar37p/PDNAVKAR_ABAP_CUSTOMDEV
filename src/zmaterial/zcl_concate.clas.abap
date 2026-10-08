CLASS zcl_concate DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CONCATE IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    TYPES: BEGIN OF ty_stock_summary,
             material    TYPE matnr,
             store_names TYPE i_materialstock_2-matlcnsmpnqtyinmatlbaseunit,
           END OF ty_stock_summary.

    DATA: lt_result TYPE STANDARD TABLE OF ty_stock_summary,
          lv_line   TYPE string.

    SELECT FROM i_materialstock_2
    FIELDS material,
          SUM( matlcnsmpnqtyinmatlbaseunit ) AS store_names
    GROUP BY material
    INTO TABLE @lt_result.

    LOOP AT lt_result INTO DATA(ls_output).
      lv_line = |Material: { ls_output-material }, Stores: { ls_output-store_names }|.
      out->write( lv_line ).
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
