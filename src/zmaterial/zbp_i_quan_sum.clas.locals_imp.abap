CLASS lhc_zi_quan_sum DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_quan_sum RESULT result.

ENDCLASS.

CLASS lhc_zi_quan_sum IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_quan_sum DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_quan_sum IMPLEMENTATION.

  METHOD save_modified.
    DATA : lt_tab  TYPE TABLE OF zi_quan_sum,
           ls_tab  TYPE zi_quan_sum,
           ls_mat  TYPE i_materialdocumentitem_2,
           lv_line TYPE string.
    DATA : lt_product TYPE TABLE OF i_product,
           ls_product TYPE i_product.
    DATA: lt_lines      TYPE STANDARD TABLE OF string,
          lv_inputdate  TYPE zi_quan_sum-postingdate,
          lv_totalstock TYPE menge_d,
          lv_material   TYPE matnr VALUE '000000001350010025'.
    DATA: lt_insert TYPE STANDARD TABLE OF zquan_sum_result,
          lt_sum type standard table of zquan_sum_db.

*    lv_inputdate = cl_abap_context_info=>get_system_date( ).
    lv_inputdate = '20240620'.

*    LOOP AT lt_product INTO ls_product.
      SELECT  * FROM zi_quan_sum( inputdate = @lv_inputdate )
        WHERE material = @lv_material INTO TABLE @DATA(lt_data).

      DATA(lv_date) = VALUE #( lt_tab[ 1 ]-postingdate OPTIONAL ).
      SELECT SUM( quantityinbaseunit ) AS qty
        FROM i_materialdocumentitem_2  WHERE postingdate = @lv_date INTO @DATA(lv_qty).


      LOOP AT lt_data INTO DATA(wa_tab).
        ls_tab-matdocitem = wa_tab-matdocitem.
        ls_tab-matdoc = wa_tab-matdoc.
        ls_tab-batch = wa_tab-batch.
        ls_tab-material = wa_tab-material.
        ls_tab-materialunit = wa_tab-materialunit.
        ls_tab-movementtype = wa_tab-movementtype.
        ls_tab-stock = wa_tab-stock.
        ls_tab-openingstock = COND #( WHEN sy-tabix = 1 THEN  lv_qty ELSE VALUE #( lt_tab[ sy-tabix - 1 ]-totalstock OPTIONAL ) ).
        ls_tab-totalstock = ls_tab-stock + ls_tab-openingstock.

        APPEND ls_tab TO lt_tab.
        CLEAR ls_tab.
      ENDLOOP.

      DELETE FROM zquan_sum_db WHERE material = @ls_tab-material .

      INSERT VALUE zquan_sum_db(
        batch = ls_tab-batch
        matdoc = ls_tab-matdoc
        matdocitem = ls_tab-matdocitem
        material = ls_tab-material
        movementtype = ls_tab-movementtype
        plant = ls_tab-plant
        postingdate = ls_tab-postingdate
        quantity = ls_tab-Quantity
        materialunit = ls_tab-materialunit
        stock = ls_tab-stock
        openingstock = ls_tab-openingstock
        totalstock = ls_tab-totalstock
      ) INTO TABLE lt_sum.

      INSERT zquan_sum_db FROM TABLE @lt_sum.
*    ENDLOOP.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
