CLASS zcl_incident_messages_ahj DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_dyn_msg .
    INTERFACES if_t100_message .
    INTERFACES if_abap_behv_message .

    CONSTANTS:
      gc_msgid TYPE symsgid VALUE 'ZMC_INCT_MESSAGE_AHJ',

      BEGIN OF status_invalid,
        msgid TYPE symsgid VALUE gc_msgid,
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'MV_STATUS',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF status_invalid,

      BEGIN OF creation_change_date,
        msgid TYPE symsgid VALUE gc_msgid,
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'MV_CREATION_DATE',
        attr2 TYPE scx_attrname VALUE 'MV_CHANGED_DATE',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF creation_change_date,

      BEGIN OF creation_date_sysdate,
        msgid TYPE symsgid VALUE gc_msgid,
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'MV_CREATION_DATE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF creation_date_sysdate,

      BEGIN OF change_date_sysdate,
        msgid TYPE symsgid VALUE gc_msgid,
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE 'MV_CHANGED_DATE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF change_date_sysdate,

      BEGIN OF enter_connection_id,
        msgid TYPE symsgid VALUE gc_msgid,
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_connection_id,

      BEGIN OF not_authorized,
        msgid TYPE symsgid VALUE gc_msgid,
        msgno TYPE symsgno VALUE '006',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF not_authorized,

      BEGIN OF enter_title,
        msgid TYPE symsgid VALUE gc_msgid,
        msgno TYPE symsgno VALUE '007',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_title,

      BEGIN OF enter_description,
        msgid TYPE symsgid VALUE gc_msgid,
        msgno TYPE symsgno VALUE '008',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_description,

      BEGIN OF enter_priority,
        msgid TYPE symsgid VALUE gc_msgid,
        msgno TYPE symsgno VALUE '009',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_priority,

      BEGIN OF assign_responsible,
        msgid TYPE symsgid VALUE gc_msgid,
        msgno TYPE symsgno VALUE '010',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF assign_responsible.




    METHODS constructor
      IMPORTING
        textid                LIKE if_t100_message=>t100key OPTIONAL
        attr1                 TYPE string OPTIONAL
        attr2                 TYPE string OPTIONAL
        attr3                 TYPE string OPTIONAL
        attr4                 TYPE string OPTIONAL
        creation_date         TYPE zde_creation_date_ahj OPTIONAL
        changed_date          TYPE zde_changed_date_ahj OPTIONAL
        status                TYPE zde_status_ahj OPTIONAL
        severity              TYPE if_abap_behv_message=>t_severity OPTIONAL
        connection_id         TYPE /dmo/connection-connection_id OPTIONAL
        uname                 TYPE syuname OPTIONAL.

    DATA:
      mv_attr1                 TYPE string,
      mv_attr2                 TYPE string,
      mv_attr3                 TYPE string,
      mv_attr4                 TYPE string,
      mv_creation_date         TYPE zde_creation_date_ahj,
      mv_changed_date          TYPE zde_changed_date_ahj,
      mv_status                TYPE zde_status_ahj,
      mv_connection_id         TYPE /dmo/connection-connection_id,
      mv_uname                 TYPE syuname.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_incident_messages_ahj IMPLEMENTATION.

 METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor(  previous = previous ) .

    me->mv_attr1                 = attr1.
    me->mv_attr2                 = attr2.
    me->mv_attr3                 = attr3.
    me->mv_attr4                 = attr4.
    me->mv_connection_id         = connection_id.
    me->mv_creation_date         = creation_date.
    me->mv_changed_date          = changed_date.
    me->mv_status                = status.
    me->mv_uname                 = uname.

    if_abap_behv_message~m_severity = severity.

    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
