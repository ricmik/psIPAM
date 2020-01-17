function Get-IPAMSubnet {
    [CmdletBinding(DefaultParameterSetName = "None")] 
    Param(
        [Parameter(Mandatory = $false, ParameterSetName = 'ByCIDR')][string]$CIDR,
        [Parameter(Mandatory = $false, ParameterSetName = 'BySubnetID')][int]$SubnetID,
        [Parameter(Mandatory = $false, ParameterSetName = 'BySubnetDescription')][string]$SubnetDescription,
        [Parameter(Mandatory = $false, ParameterSetName = 'BySectionID')][int]$SectionID,
        [Parameter(Mandatory = $false, ParameterSetName = 'BySectionName')][string]$SectionName
    )
    if ($CIDR) {
        # Find subnet by CIDR /api/my_app/subnets/cidr/{subnet}/ 
        $CIDREscaped = $CIDR.Replace("/", "\/")
        $result = (New-IPAMRequest -APIController 'subnets' -APIMethod 'Get' -Parameters @("cidr", $CIDREscaped)).data
    } elseif ($SubnetID) {
        $result = (New-IPAMRequest -APIController 'subnets' -APIMethod 'Get' -Parameters $SubnetID).data
    } elseif ($SubnetDescription) {
        $allsubnets = Get-IPAMSubnet
        foreach ($subnet in $allsubnets) {
            if($subnet.description -eq $SubnetDescription) {
                $result += $subnet
            }
        }
    } elseif ($SectionID) {
        $result = Get-IPAMSection -SectionID $SectionID -ShowAllSubnets
     
    } elseif ($SectionName) {
        $SectionIDFromName = (Get-IPAMSection -SectionName $SectionName).id
        $result = Get-IPAMSection -SectionID $SectionIDFromName -ShowAllSubnets

    } else {
        # Get all subnets in all sections by default if no parameters were defined
        $Sections = Get-IPAMSection
        foreach ($Section in $Sections) {
            $result += Get-IPAMSection -SectionID $($Section.id) -ShowAllSubnets
        }
    }
    
    return $result
}
