CLASS zcl_quan_sum_query DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_QUAN_SUM_QUERY IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA : lt_tab  TYPE TABLE OF zi_quan_sum,
           ls_tab  TYPE zi_quan_sum,
           lv_inputdate  TYPE zi_quan_sum-postingdate.
    DATA : lv_line TYPE string,
           lt_lines      TYPE STANDARD TABLE OF string.
    data : ls_mat  TYPE i_materialdocumentitem_2,
           lt_mat  TYPE STANDARD TABLE OF i_materialdocumentitem_2,
           lv_material   TYPE i_materialdocumentitem_2-material.
    DATA: lt_insert TYPE STANDARD TABLE OF zquan_sum_result.
    DATA : lt_sum TYPE STANDARD TABLE OF zquan_sum_db,
           ls_sum TYPE zquan_sum_db.
    DATA : lt_product TYPE STANDARD TABLE OF i_product,
           ls_product TYPE i_product.

*    lv_inputdate = cl_abap_context_info=>get_system_date( ).

*    SELECT  * FROM zi_quan_sum( inputdate = @lv_inputdate )
*      WHERE material = @lv_material INTO TABLE @DATA(lt_data).

    SELECT  * FROM zi_quan_sum INTO TABLE @DATA(lt_data).

    DATA(lv_date) = VALUE #( lt_tab[ 1 ]-postingdate OPTIONAL ).

*    SELECT SUM( quantityinbaseunit ) AS qty
*      FROM i_materialdocumentitem_2  WHERE postingdate = @lv_date INTO @DATA(lv_qty).

   SELECT SUM( quantityinbaseunit ) AS qty
      FROM i_materialdocumentitem_2  WHERE postingdate = @lv_date INTO @DATA(lv_qty).

    LOOP AT lt_data INTO DATA(wa_tab).
      ls_sum-matdocitem = wa_tab-matdocitem.
      ls_sum-matdoc = wa_tab-matdoc.
      ls_sum-postingdate = wa_tab-Postingdate.
      ls_sum-batch = wa_tab-batch.
      ls_sum-material = wa_tab-material.
      ls_sum-materialunit = wa_tab-materialunit.
      ls_sum-movementtype = wa_tab-movementtype.
      ls_sum-stock = wa_tab-stock.
      ls_sum-openingstock = COND #( WHEN sy-tabix = 1 THEN  lv_qty ELSE VALUE #( lt_sum[ sy-tabix - 1 ]-totalstock OPTIONAL ) ).
      ls_sum-totalstock = ls_sum-stock + ls_sum-openingstock.

      APPEND ls_sum TO lt_sum.
      CLEAR ls_sum.
    ENDLOOP.

    DELETE FROM zquan_sum_db.

*    INSERT VALUE zquan_sum_result(
*      material      = lv_material
*      inputdate     = lv_inputdate
*      custom_amount = lv_totalstock
*    ) INTO TABLE lt_insert.

    INSERT zquan_sum_db FROM TABLE @lt_sum.

    out->write( lt_sum ).

  ENDMETHOD.
ENDCLASS.
