CLASS zzsd_handlingunit_cl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES IF_SLIN_BADI_DBTAB_ACCESS.

    TYPES: BEGIN OF ty_output,
             lv_GrossWT  TYPE i_billingdocumentitem-BILLINGQUANTITY,
             lv_TareWT   TYPE i_billingdocumentitem-BILLINGQUANTITY,
            END OF ty_output.

    CLASS-METHODS:
      get_data
        IMPORTING lm_RefDoc TYPE i_billingdocumentitem-referencesddocument
        RETURNING VALUE(ex_data) TYPE ty_output.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA: ls_output TYPE ty_output.
ENDCLASS.



CLASS ZZSD_HANDLINGUNIT_CL IMPLEMENTATION.


  METHOD get_data.

    """"""""""""""""""" Main Code Start """"""""""""""""""""

" select from I_HandlingUnitItem
" fields handlingunitexternalid
"      where handlingunitreferencedocument = @lm_RefDoc
"      into table @data(lt_HandlingUnitItem).

"if lt_HandlingUnitItem is not initial.

"select from I_HandlingUnitHeader
"fields handlingunitexternalid, grossweight, handlingunittareweight
"for all entries in @lt_HandlingUnitItem
"  where handlingunitexternalid = @lt_HandlingUnitItem-handlingunitexternalid
"  into table @data(lt_HandlingUnitHeader).

"endif.

 select from I_HandlingUnitItem as HUI
    inner join I_HandlingUnitHeader as HUH on HUH~handlingunitexternalid = HUI~handlingunitexternalid
        fields HUI~handlingunitexternalid, HUH~grossweight, HUH~handlingunittareweight
      where HUI~handlingunitreferencedocument = @lm_RefDoc
      into table @data(lt_HandlingUnit).


    SORT lt_HandlingUnit ASCENDING BY handlingunitexternalid.
    DELETE ADJACENT DUPLICATES FROM lt_HandlingUnit COMPARING handlingunitexternalid.

clear: ls_output,ex_data.

   LOOP AT lt_HandlingUnit INTO data(ls_HandlingUnit).

      ls_output-lv_GrossWT  += ls_HandlingUnit-grossweight.
      ls_output-lv_TareWT  += ls_HandlingUnit-handlingunittareweight.

    ENDLOOP.

    MOVE-CORRESPONDING ls_output to ex_data.

    """"""""""""""""""" Main Code End """"""""""""""""""""

  ENDMETHOD.


  METHOD if_slin_badi_dbtab_access~add_dbtab_access.
     ir->add_accepted_dbtab( 'I_HandlingUnitItem' ).
     ir->add_accepted_dbtab( 'I_HandlingUnitHeader' ).
  ENDMETHOD.
ENDCLASS.
