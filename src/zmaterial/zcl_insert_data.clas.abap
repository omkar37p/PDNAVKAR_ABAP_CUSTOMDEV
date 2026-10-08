CLASS zcl_insert_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_INSERT_DATA IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA : lt_orders TYPE TABLE OF zorders_db.

    lt_orders = VALUE #( ( plant = 'Plant1'
                         orderid = 'Order1'
                         status = 'OPEN' )
                         ( plant = 'Plant1'
                         orderid = 'Order2'
                         status = 'RELEASED' )
                         ( plant = 'Plant1'
                         orderid = 'Order3'
                         status = 'COMPLETED' )
                         ( plant = 'Plant1'
                         orderid = 'Order4    '
                         status = 'OPEN' )
                         ( plant = 'Plant1'
                         orderid = 'Order5'
                         status = 'RELEASED' )
                         ( plant = 'Plant1'
                         orderid = 'Order6'
                         status = 'COMPLETED' )
                         ( plant = 'Plant2'
                         orderid = 'Order7'
                         status = 'RELEASED' )
                         ( plant = 'Plant2'
                         orderid = 'Order8'
                         status = 'COMPLETED' ) ).

    DELETE FROM zorders_db.

    INSERT zorders_db FROM TABLE @lt_orders.

    SELECT * FROM zorders_db INTO TABLE @lt_orders.

    out->write( lt_orders ).


  ENDMETHOD.
ENDCLASS.
