@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'History - Comsuption'
//@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_ZDT_INCT_H_AHJ as projection on zdd_inct_h_ahj
{
    key HisUuid,
    key IncUuid,
    HisId,
    PreviousStatus,
    NewStatus,
    Text,
    LocalCreatedBy,
    LocalCreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    /* Associations */
    _Incident : redirected to parent ZC_ZDT_INCT_AHJ
}
