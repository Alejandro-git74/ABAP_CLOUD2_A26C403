@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Priority -  Help Value'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
define view entity ZDD_PRIORITY_VH_AHJ as select from zdt_priority_ahj
{
    @ObjectModel.text.element:['PriorityDescription']
    key priority_code as PriorityCode,
      @Search.defaultSearchElement: true 
      @Search.fuzzinessThreshold: 0.8
      @Semantics.text:true
    priority_description as PriorityDescription
}
