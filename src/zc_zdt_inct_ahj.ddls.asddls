@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Incident - Consumption'
//@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_ZDT_INCT_AHJ 
provider contract transactional_query
as projection on zr_zdt_inct_ahj
{
    key IncUuid,
    IncidentId,
    Title,
    Description,
    Status,
    Priority,
    CreationDate,
    ChangedDate,
    LocalCreatedBy,
    LocalCreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    /* Associations */
    _History : redirected to composition child ZC_ZDT_INCT_H_AHJ 
}
