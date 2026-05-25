@EndUserText.label: 'Change Status - Abstract Entity'
define abstract entity zae_change_status_param_ahj
{
  @EndUserText.label: 'Change Status'
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'zdd_status_vh_ahj',
    entity.element: 'StatusCode',
    useForValidation: true
  } ]

     status : zde_status_ahj;   
     
  @EndUserText.label: 'Add Observation Text'
    text : zde_text_ahj;   
    
}
