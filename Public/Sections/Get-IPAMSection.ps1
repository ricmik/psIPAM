function Get-IPAMSection {
    # Get sections using the /api/app_id/sections/ controller
    [CmdletBinding(DefaultParameterSetName = 'BySectionName')]
    Param(
        [Parameter(Mandatory = $false, ParameterSetName = 'BySectionID')][int]$SectionID,
        [Parameter(Mandatory = $false, ParameterSetName = 'BySectionID')][switch]$ShowAllSubnets,
        [Parameter(Mandatory = $false, ParameterSetName = 'BySectionName')][string]$SectionName
    )
    if ($SectionID) {
        # Get sections by their phpIPAM ID /api/app_id/sections/{id}/
        if ($ShowAllSubnets) { $parameters = @($SectionID, "subnets") }
        else { $parameters = @($SectionID) }
        $result = New-IPAMRequest -APIController 'sections' -APIMethod 'Get' -Parameters $parameters
    } elseif ($SectionName) {
        # Get sections by their names /api/app_id/sections/{section_name}/
        $result = New-IPAMRequest -APIController 'sections' -APIMethod 'Get' -Parameters $SectionName
    } else {
        # Get all sections /api/app_id/sections/
        $result = New-IPAMRequest -APIController 'sections' -APIMethod 'Get'
    }
    return $result.data
}
