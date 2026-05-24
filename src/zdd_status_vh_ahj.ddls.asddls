@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Status - Value Help'
@Search.searchable: true
define view entity ZDD_STATUS_VH_AHJ as select from zdt_status_ahj
{       
        @Search.defaultSearchElement: true   
        @ObjectModel.text.element:['StatusDescription']
        @UI.lineItem: [{ position: 10, importance: #HIGH}]
    key status_code as StatusCode,
        @Search.defaultSearchElement: true
        @Search.fuzzinessThreshold: 0.8
        @Semantics.text:true
        @UI.lineItem: [{ position: 20, importance: #HIGH}]
        status_description as StatusDescription
}
