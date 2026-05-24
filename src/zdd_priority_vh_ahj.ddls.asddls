@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Priority -  Help Value'
@Search.searchable: true
define view entity ZDD_PRIORITY_VH_AHJ as select from zdt_priority_ahj
{
        @Search.defaultSearchElement: true 
        @ObjectModel.text.element:['PriorityDescription']
        @UI.lineItem: [{ position: 10, importance: #HIGH}]
    key priority_code as PriorityCode,
        @Search.defaultSearchElement: true 
        @Search.fuzzinessThreshold: 0.8
        @Semantics.text:true
        @UI.lineItem: [{ position: 20, importance: #HIGH}]
        priority_description as PriorityDescription
}
