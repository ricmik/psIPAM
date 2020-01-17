function New-IPAMSubnet {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    Param(
        [Parameter(Mandatory = $true)][int]$SectionID,
        [int]$ParentSubnetID = 0,
        [ipaddress]$NetworkAddress,
        [int]$SubnetBitMask,
        [string]$Description
    )
    $Body = @{
        subnet = $NetworkAddress.IPAddressToString
        mask = $SubnetBitMask
        description = $Description
        sectionId = $SectionID
        masterSubnetId = $ParentSubnetID
        
    } | ConvertTo-Json
    if ($PSCmdlet.ShouldProcess("Creates subnet $($NetworkAddress)/$($SubnetBitMask) with parent subnet ID $ParentSubnetID in section $($SectionID)")) {
        New-IPAMRequest -APIController 'subnets' -APIMethod 'Post' -Body $Body
    }
}