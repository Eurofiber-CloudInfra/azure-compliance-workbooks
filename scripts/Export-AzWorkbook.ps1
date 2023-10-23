<#
	.SYNOPSIS
       Exports an Azure Workbook into ARM format

	.DESCRIPTION
        Running Export-AzResourceGroup for an Azure Workbook resource only returns 
        resource details without dashboard content.
        This script retrieves the dashboard content and merges it with the ARM export into
        a deployable ARM file. 

    .PARAMETER source_workbook_resource_id
        The resource id of the Azure workbook resource that needs to be exported

	.EXAMPLE
	   .\Export-AzWorkbook.ps1 -source_workbook_resource_id "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/microsoft.insights/workbooks/00000000-0000-0000-0000-000000000000"
	   
	.LINK

	.Notes
		NAME:      Export-AzWorkbook.ps1
		AUTHOR(s): D. Rietvink
		LASTEDIT:  16-9-2023
		KEYWORDS:  azure workbook development
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$source_workbook_resource_id
)

$source_workbook_resource_id_array=$source_workbook_resource_id.Split('/')

# Get ARM template for Workbook
Set-AzContext -Subscription $source_workbook_resource_id_array[2] -Force
$workbook_template_file = Export-AzResourceGroup `
   -ResourceGroupName $source_workbook_resource_id_array[4] `
   -Resource $source_workbook_resource_id `
   -SkipAllParameterization `
   -Force 
$workbook_template = Get-Content -Raw $workbook_template_file.Path | ConvertFrom-Json
Remove-Item $workbook_template_file.Path -Force
$workbook_display_name = $workbook_template.resources[0].properties.displayName

# Get Notebook json for Workbook
$workbook_object_serialized_data=((Invoke-AzRestMethod -Method GET -Path ($source_workbook_resource_id + "?api-version=2021-08-01&canFetchContent=true")).Content | ConvertFrom-JSON ).properties.serializedData

# Update ARM template with stringyfied Notebook json
$workbook_template.resources[0].properties.serializedData = $workbook_object_serialized_data 

# Get Notebook version from main parameter section if exist
$template_version = "1.0.0.0"
$workbook_object_serialized_data_json = $workbook_object_serialized_data | ConvertFrom-Json -Depth 99 
$parameters_index = [array]::indexof($workbook_object_serialized_data_json.items.name,'parameters-main')
if ($parameters_index -ge 0) {
    $parameters = $workbook_object_serialized_data_json.items[$parameters_index].content.parameters
    $template_version_index = [array]::indexof($parameters.name, '_template_version')
    if ($template_version_index -ge 0) {
        $template_version = $parameters[$template_version_index].value
    }
}

# Set ARM contentVersion 
$workbook_template.contentVersion = $template_version

# Save ARM template
$out_file= ('..\ARM\' + $workbook_display_name + '.json').Replace(' ', '-')
$workbook_template | ConvertTo-Json -depth 99 | Out-File $out_file -Force

