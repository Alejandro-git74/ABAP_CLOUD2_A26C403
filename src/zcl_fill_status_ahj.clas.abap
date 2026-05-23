CLASS zcl_fill_status_ahj DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_fill_status_ahj IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DELETE FROM zdt_status_ahj.

* Fill Status Data
    INSERT zdt_status_ahj FROM TABLE @( VALUE #( ( status_code = 'OP'
                                                   status_description = 'Open' )
                                                 ( status_code = 'IP'
                                                   status_description = 'In Progress' )
                                                 ( status_code = 'PE'
                                                   status_description = 'Pending' )
                                                 ( status_code = 'CO'
                                                   status_description = 'Completed' )
                                                 ( status_code = 'CL'
                                                   status_description = 'Closed' )
                                                 ( status_code = 'CN'
                                                   status_description = 'Canceled' ) ) ).
    IF sy-subrc EQ 0.
      out->write( |{ sy-dbcnt } Status added| ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
