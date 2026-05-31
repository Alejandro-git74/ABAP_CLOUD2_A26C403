CLASS lhc_Incident DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PUBLIC SECTION.


    CONSTANTS: BEGIN OF i_status,
                 op TYPE zde_status_ahj VALUE 'OP',
                 ip TYPE zde_status_ahj VALUE 'IP',
                 pe TYPE zde_status_ahj VALUE 'PE',
                 co TYPE zde_status_ahj VALUE 'CO',
                 cl TYPE zde_status_ahj VALUE 'CL',
                 cn TYPE zde_status_ahj VALUE 'CN',
               END OF i_status.

  PRIVATE SECTION.

    METHODS validaIncident FOR VALIDATE ON SAVE
      IMPORTING keys FOR Incident~validaIncident.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Incident RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Incident RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Incident RESULT result.

    METHODS changeStatus FOR MODIFY
      IMPORTING keys FOR ACTION Incident~changeStatus RESULT result.

    METHODS setHistory FOR MODIFY
      IMPORTING keys FOR ACTION Incident~setHistory.

    METHODS setDefaultValues FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Incident~setDefaultValues.

    METHODS setDefaultHistory FOR DETERMINE ON SAVE
      IMPORTING keys FOR Incident~setDefaultHistory.



    METHODS get_history_index EXPORTING ev_incuuid      TYPE sysuuid_x16
                              RETURNING VALUE(rv_index) TYPE zde_his_id_ahj.

ENDCLASS.

CLASS lhc_Incident IMPLEMENTATION.


  METHOD validaIncident.

    READ ENTITIES OF zr_zdt_inct_ahj IN LOCAL MODE
         ENTITY Incident
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(Incidents).

    LOOP AT Incidents INTO DATA(Incident).

      IF Incident-title IS INITIAL.
        APPEND VALUE #( %tky = Incident-%tky ) TO failed-Incident.
*      Customize error messages
        APPEND VALUE #( %tky = Incident-%tky
                       %msg = NEW zcl_incident_messages_ahj( textid = zcl_incident_messages_ahj=>enter_title
                                                             severity = if_abap_behv_message=>severity-error   )
                                                             %element-title = if_abap_behv=>mk-on )
                                                     TO reported-Incident.
      ENDIF.

      IF Incident-Description IS INITIAL.
        APPEND VALUE #( %tky = Incident-%tky ) TO failed-Incident.
*      Customize error messages
        APPEND VALUE #( %tky = Incident-%tky
                       %msg = NEW zcl_incident_messages_ahj( textid = zcl_incident_messages_ahj=>enter_description
                                                             severity = if_abap_behv_message=>severity-error   )
                                                             %element-title = if_abap_behv=>mk-on )
                                                     TO reported-Incident.
      ENDIF.

      IF Incident-priority IS INITIAL.
        APPEND VALUE #( %tky = Incident-%tky ) TO failed-Incident.
*      Customize error messages
        APPEND VALUE #( %tky = Incident-%tky
                       %msg = NEW zcl_incident_messages_ahj( textid = zcl_incident_messages_ahj=>enter_priority
                                                             severity = if_abap_behv_message=>severity-error   )
                                                             %element-title = if_abap_behv=>mk-on )
                                                     TO reported-Incident.
      ENDIF.


    ENDLOOP.

  ENDMETHOD.


  METHOD get_instance_features.

    DATA lv_history_index TYPE zde_his_id_ahj.
    READ ENTITIES OF zr_zdt_inct_ahj IN LOCAL MODE
       ENTITY Incident
         FIELDS ( Status )
         WITH CORRESPONDING #( keys )
       RESULT DATA(incidents)
       FAILED failed.

** Disable changeStatus for Incidents Creation
    DATA(lv_create_action) = lines( incidents ).
    IF lv_create_action EQ 1.
      lv_history_index = get_history_index( IMPORTING ev_incuuid = incidents[ 1 ]-IncUUID ).
    ELSE.
      lv_history_index = 1.
    ENDIF.

    result = VALUE #( FOR incident IN incidents
                          ( %tky                   = incident-%tky
                            %action-ChangeStatus   = COND #( WHEN incident-Status = i_status-co OR
                                                                  incident-Status = i_status-cl OR
                                                                  incident-Status = i_status-cn OR
                                                                  lv_history_index = 0
                                                             THEN if_abap_behv=>fc-o-disabled
                                                             ELSE if_abap_behv=>fc-o-enabled )

                            %assoc-_History       = COND #( WHEN incident-Status = i_status-co OR
                                                                 incident-Status = i_status-cl OR
                                                                 incident-Status = i_status-cn OR
                                                                 lv_history_index = 0
                                                            THEN if_abap_behv=>fc-o-disabled
                                                            ELSE if_abap_behv=>fc-o-enabled )
                          ) ).
  ENDMETHOD.


  METHOD get_instance_authorizations.

    DATA: update_request TYPE abap_bool,
          update_granted TYPE abap_bool.

    DATA(lv_technical_name) = cl_abap_context_info=>get_user_technical_name( ).


    READ ENTITIES OF zr_zdt_inct_ahj IN LOCAL MODE
       ENTITY Incident
         FIELDS ( Status )
         WITH CORRESPONDING #( keys )
       RESULT DATA(Incidents)
       FAILED failed.

    update_request = COND #( WHEN requested_authorizations-%update EQ if_abap_behv=>mk-on
                               OR requested_authorizations-%action-Edit EQ if_abap_behv=>mk-on
                            THEN abap_true
                            ELSE abap_false ).

    LOOP AT Incidents INTO DATA(Incident)
        WHERE Status IS NOT INITIAL.


*  lv_technical_name = 'DIFERENT_USER'.
*  lv_technical_name = 'CB9980000477'.
*** Authorization Status IP
        IF Incident-Status EQ 'IP'.
          IF lv_technical_name EQ 'CB9980000477'.
            update_granted = abap_true.
          ELSE.
            update_granted = abap_false.
*      Customize error messages
            APPEND VALUE #( %msg = NEW zcl_incident_messages_ahj( textid = zcl_incident_messages_ahj=>assign_responsible
                                                                 severity = if_abap_behv_message=>severity-error   )
                                                                 %element-title = if_abap_behv=>mk-on )
                                                         TO reported-Incident.


            APPEND VALUE #( LET upd_auth = COND #( WHEN update_granted = abap_true
                                                   THEN if_abap_behv=>auth-allowed
                                                   ELSE if_abap_behv=>auth-unauthorized )
                                           IN
                                           %tky = Incident-%tky
                                           %update = upd_auth
                                           %action-edit = upd_auth ) TO result.

          ENDIF.

      endif.

**** Authorization All Status
*        IF Incident-Status ne 'OP'.
*
*          lv_technical_name = 'DIFERENT_USER'.
*
*
*          IF lv_technical_name EQ 'CB9980000477'.
*            update_granted = abap_true.
*          ELSE.
*            update_granted = abap_false.
**      Customize error messages
*        append value #( %msg = new zcl_incident_messages_ahj( textid = zcl_incident_messages_ahj=>not_authorized
*                                                             severity = if_abap_behv_message=>severity-error   )
*                                                             %element-title = if_abap_behv=>mk-on )
*                                                     to reported-Incident.
*
*
*            APPEND VALUE #( LET upd_auth = COND #( WHEN update_granted = abap_true
*                                                   THEN if_abap_behv=>auth-allowed
*                                                   ELSE if_abap_behv=>auth-unauthorized )
*                                           IN
*                                           %tky = Incident-%tky
*                                           %update = upd_auth
*                                           %action-edit = upd_auth ) TO result.
*
*          ENDIF.
*
*        ENDIF.

    ENDLOOP.


  ENDMETHOD.


  METHOD get_global_authorizations.

     data(lv_technical_name) = cl_abap_context_info=>get_user_technical_name( ).
*   lv_technical_name = 'DIFERENT_USER'.
* lv_technical_name = 'CB9980000477'.
     if requested_authorizations-%update eq if_abap_behv=>mk-on.
      if lv_technical_name eq 'CB9980000477'.
        result-%create = if_abap_behv=>auth-allowed.
       else.
        result-%create = if_abap_behv=>auth-unauthorized.
*      Customize error messages
        append value #( %msg = new zcl_incident_messages_ahj( textid = zcl_incident_messages_ahj=>not_authorized
                                                             severity = if_abap_behv_message=>severity-error   )
                                                             %element-title = if_abap_behv=>mk-on )
                                                     to reported-Incident.
      endif.
     endif.

  ENDMETHOD.


  METHOD changeStatus.
* Declaration of necessary variables
    DATA: lt_updated_root_entity TYPE TABLE FOR UPDATE zr_zdt_inct_ahj,
          lt_association_entity  TYPE TABLE FOR CREATE zr_zdt_inct_ahj\_History,
          lv_status              TYPE zde_status_ahj,
          lv_text                TYPE zde_text_ahj,
          lv_exception           TYPE string,
          lv_error               TYPE c,
          ls_incident_history    TYPE zdt_inct_h_ahj,
          lv_max_his_id          TYPE zde_his_id_ahj,
          lv_wrong_status        TYPE zde_status_ahj.

** Iterate through the keys records to get parameters for validations
    READ ENTITIES OF zr_zdt_inct_ahj IN LOCAL MODE
         ENTITY Incident
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(incidents)
         FAILED failed.

** Get parameters
    LOOP AT incidents ASSIGNING FIELD-SYMBOL(<incident>).
** Get Status
      lv_status = keys[ KEY id %tky = <incident>-%tky ]-%param-status.

**  It is not possible to change the pending (PE) to Completed (CO) or Closed (CL) status
      IF <incident>-Status EQ i_status-pe AND lv_status EQ i_status-cl OR
         <incident>-Status EQ i_status-pe AND lv_status EQ i_status-co.
** Set authorizations
        APPEND VALUE #( %tky = <incident>-%tky ) TO failed-incident.

        lv_wrong_status = lv_status.
* Customize error messages
        APPEND VALUE #( %tky = <incident>-%tky
                        %msg = NEW zcl_incident_messages_ahj( textid = zcl_incident_messages_ahj=>status_invalid
                                                            status   = lv_wrong_status
                                                            severity = if_abap_behv_message=>severity-error )
                        %state_area = 'VALIDATE_COMPONENT'
                         ) TO reported-incident.
        lv_error = abap_true.
        EXIT.
      ENDIF.

      APPEND VALUE #( %tky = <incident>-%tky
                      ChangedDate = cl_abap_context_info=>get_system_date( )
                      Status = lv_status ) TO lt_updated_root_entity.

** Get Text
      lv_text = keys[ KEY id %tky = <incident>-%tky ]-%param-text.

      lv_max_his_id = get_history_index(
                  IMPORTING
                    ev_incuuid = <incident>-IncUUID ).

      IF lv_max_his_id IS INITIAL.
        ls_incident_history-his_id = 1.
      ELSE.
        ls_incident_history-his_id = lv_max_his_id + 1.
      ENDIF.

      ls_incident_history-new_status = lv_status.
      ls_incident_history-text = lv_text.

      TRY.
          ls_incident_history-inc_uuid = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error INTO DATA(lo_error).
          lv_exception = lo_error->get_text(  ).
      ENDTRY.

      IF ls_incident_history-his_id IS NOT INITIAL.
*
        APPEND VALUE #( %tky = <incident>-%tky
                        %target = VALUE #( (  HisUUID = ls_incident_history-inc_uuid
                                              IncUUID = <incident>-IncUUID
                                              HisID = ls_incident_history-his_id
                                              PreviousStatus = <incident>-Status
                                              NewStatus = ls_incident_history-new_status
                                              Text = ls_incident_history-text ) )
                                               ) TO lt_association_entity.
      ENDIF.
    ENDLOOP.
    UNASSIGN <incident>.

** The process is interrupted because a change of status from pending (PE) to Completed (CO) or Closed (CL) is not permitted.
    CHECK lv_error IS INITIAL.

** Modify status in Root Entity
    MODIFY ENTITIES OF zr_zdt_inct_ahj IN LOCAL MODE
    ENTITY Incident
    UPDATE  FIELDS ( ChangedDate
                     Status )
    WITH lt_updated_root_entity.

    FREE incidents. " Free entries in incidents

    MODIFY ENTITIES OF zr_zdt_inct_ahj IN LOCAL MODE
     ENTITY Incident
     CREATE BY \_History FIELDS ( HisUUID
                                  IncUUID
                                  HisID
                                  PreviousStatus
                                  NewStatus
                                  Text )
        AUTO FILL CID
        WITH lt_association_entity
     MAPPED mapped
     FAILED failed
     REPORTED reported.

** Read root entity entries updated
    READ ENTITIES OF zr_zdt_inct_ahj IN LOCAL MODE
    ENTITY Incident
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT incidents
    FAILED failed.

** Update User Interface
    result = VALUE #( FOR incident IN incidents ( %tky = incident-%tky
                                                  %param = incident ) ).
  ENDMETHOD.

  METHOD setHistory.
** Declaration of necessary variables
    DATA: lt_updated_root_entity TYPE TABLE FOR UPDATE zr_zdt_inct_ahj,
          lt_association_entity  TYPE TABLE FOR CREATE zr_zdt_inct_ahj\_History,
          lv_exception           TYPE string,
          ls_incident_history    TYPE zdt_inct_h_ahj,
          lv_max_his_id          TYPE zde_his_id_ahj.

** Iterate through the keys records to get parameters for validations
    READ ENTITIES OF zr_zdt_inct_ahj IN LOCAL MODE
         ENTITY Incident
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(incidents).

** Get parameters
    LOOP AT incidents ASSIGNING FIELD-SYMBOL(<incident>).
      lv_max_his_id = get_history_index( IMPORTING ev_incuuid = <incident>-IncUUID ).

      IF lv_max_his_id IS INITIAL.
        ls_incident_history-his_id = 1.
      ELSE.
        ls_incident_history-his_id = lv_max_his_id + 1.
      ENDIF.

      TRY.
          ls_incident_history-inc_uuid = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error INTO DATA(lo_error).
          lv_exception = lo_error->get_text(  ).
      ENDTRY.

      IF ls_incident_history-his_id IS NOT INITIAL.
        APPEND VALUE #( %tky = <incident>-%tky
                        %target = VALUE #( (  HisUUID = ls_incident_history-inc_uuid
                                              IncUUID = <incident>-IncUUID
                                              HisID = ls_incident_history-his_id
                                              NewStatus = <incident>-Status
                                              Text = 'First Incident' ) )
                                               ) TO lt_association_entity.
      ENDIF.
    ENDLOOP.
    UNASSIGN <incident>.

    FREE incidents. " Free entries in incidents

    MODIFY ENTITIES OF zr_zdt_inct_ahj IN LOCAL MODE
     ENTITY Incident
     CREATE BY \_History FIELDS ( HisUUID
                                  IncUUID
                                  HisID
                                  PreviousStatus
                                  NewStatus
                                  Text )
        AUTO FILL CID
        WITH lt_association_entity.
  ENDMETHOD.


  METHOD setDefaultValues.
** Read root entity entries
    READ ENTITIES OF zr_zdt_inct_ahj IN LOCAL MODE
     ENTITY Incident
     FIELDS ( CreationDate
              Status ) WITH CORRESPONDING #( keys )
     RESULT DATA(incidents).

** This important for logic
    DELETE incidents WHERE CreationDate IS NOT INITIAL.

    CHECK incidents IS NOT INITIAL.

** Get Last index from Incidents
    SELECT FROM zdt_inct_ahj
      FIELDS MAX( incident_id ) AS max_inct_id
      WHERE incident_id IS NOT NULL
      INTO @DATA(lv_max_inct_id).

    IF lv_max_inct_id IS INITIAL.
      lv_max_inct_id = 1.
    ELSE.
      lv_max_inct_id += 1.
    ENDIF.

** Modify status in Root Entity
    MODIFY ENTITIES OF zr_zdt_inct_ahj IN LOCAL MODE
      ENTITY Incident
      UPDATE
      FIELDS ( IncidentID
               CreationDate
               Status )
      WITH VALUE #(  FOR incident IN incidents ( %tky = incident-%tky
                                                 IncidentID = lv_max_inct_id
                                                 CreationDate = cl_abap_context_info=>get_system_date( )
                                                 Status       = i_status-op )  ).
  ENDMETHOD.

  METHOD setDefaultHistory.
** Execute internal action to update Flight Date
    MODIFY ENTITIES OF zr_zdt_inct_ahj IN LOCAL MODE
    ENTITY Incident
    EXECUTE setHistory
       FROM CORRESPONDING #( keys ).
  ENDMETHOD.


  METHOD get_history_index.
** Fill history data
    SELECT FROM zdt_inct_h_ahj
      FIELDS MAX( his_id ) AS max_his_id
      WHERE inc_uuid EQ @ev_incuuid AND
            his_uuid IS NOT NULL
      INTO @rv_index.
  ENDMETHOD.




ENDCLASS.
