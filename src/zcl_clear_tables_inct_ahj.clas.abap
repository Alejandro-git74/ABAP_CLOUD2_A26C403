CLASS zcl_clear_tables_inct_ahj DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_clear_tables_inct_ahj IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DELETE FROM zdt_inct_h_ahj.
    DELETE FROM zdt_inct_ahj.
    IF sy-subrc EQ 0.
      out->write( |{ sy-dbcnt } Clear Tables| ).
    ENDIF.


  ENDMETHOD.

ENDCLASS.
