function Set-IPAMSubnet {
    [CmdletBinding(DefaultParameterSetName = "None", SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    Param(
        [Parameter(Mandatory = $false, ParameterSetName = 'ByCIDR')][string]$CIDR,
        [Parameter(Mandatory = $false, ParameterSetName = 'BySubnetID')][int]$SubnetID,
        [Parameter(Mandatory = $true)][string]$Description
    )
    if ($CIDR) {
        $ipamsubnet = Get-IPAMSubnet -CIDR $CIDR
        $SubnetID = $($ipamsubnet.id)
    }
    if ($SubnetID) {
        $Body = @{
            id          = $SubnetID
            description = $Description
        } | ConvertTo-Json
        if ($PSCmdlet.ShouldProcess("Updates subnet with SubnetID $SubnetID with new data. $Body")) {
            $result = (New-IPAMRequest -APIController 'subnets' -APIMethod 'Patch' -Body $Body).data
        }
    }
    return $result
}