CLASS zcl_fill_priority_ahj DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_fill_priority_ahj IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DELETE FROM zdt_priority_ahj.


* Fill Priority Data
    INSERT zdt_priority_ahj FROM TABLE @( VALUE #( ( priority_code = 'H'
                                                     priority_description = 'High' )
                                                   ( priority_code = 'M'
                                                     priority_description = 'Medium' )
                                                   ( priority_code = 'L'
                                                     priority_description = 'Low' ) ) ).
    IF sy-subrc EQ 0.
      out->write( |{ sy-dbcnt } Priorities added| ).
    ENDIF.


  ENDMETHOD.

ENDCLASS.
