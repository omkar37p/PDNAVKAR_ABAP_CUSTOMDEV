CLASS zcl_mstock_tf DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS get_stock
        FOR TABLE FUNCTION zmstock_tf.

ENDCLASS.



CLASS ZCL_MSTOCK_TF IMPLEMENTATION.


  METHOD get_stock
  BY DATABASE FUNCTION
  FOR HDB
  LANGUAGE SQLSCRIPT
  OPTIONS READ-ONLY
  USING zmstock_base.

    RETURN
      select
        mandt,
        cast(record_id AS integer)                    AS record_id,
        cast(Matdocyear AS nvarchar(4))               as Matdocyear,
        cast(matdoc AS nvarchar(10))                  AS matdoc,
        cast(matdocitem AS nvarchar(4))               AS matdocitem,
        documentdate,
        postingdate,
        cast(material AS nvarchar(18))                AS material,
        cast(plant AS nvarchar(4))                    AS plant,
        cast(stock AS decimal(13,3))                  AS stock,
        coalesce(
          LAG(cast(total_stock AS decimal(13,3))) OVER (PARTITION BY material ORDER BY record_id),
          cast('0.000' AS decimal(13,3))
        )                                             AS open_stock,
        cast(total_stock AS decimal(13,3))                  AS total_stock,
        material_uom
      FROM (
        SELECT
          mandt,
          ROW_NUMBER() OVER (PARTITION BY material
          order by material, creationdate, creationtime, matdoc, matdocitem) AS record_id,
          Matdocyear,
          matdoc,
          matdocitem,
          documentdate,
          postingdate,
          material,
          plant,
          stock,
          SUM(stock) OVER (PARTITION BY material
          order by material, creationdate, creationtime, matdoc, matdocitem ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT row) AS total_stock,
          material_uom
*        FROM zmstock_base(:from_date, :to_date)
        FROM zmstock_base(:to_date)
        WHERE mandt = session_context('CLIENT')
*          AND material = '000000001350010025'
      ) AS sub;

  ENDMETHOD.
ENDCLASS.
