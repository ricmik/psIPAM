function Remove-IPAMSubnet {
    [CmdletBinding(DefaultParameterSetName = 'None', SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param(
        [Parameter(Mandatory = $false, ParameterSetName = 'ByCIDR')][string]$CIDR,
        [Parameter(Mandatory = $false, ParameterSetName = 'BySubnetID')][int]$SubnetID,
        [Parameter(Mandatory = $false, ParameterSetName = 'BySubnetDescription')][string]$SubnetDescription
    )
    if ($CIDR) {
        $SubnetID = (Get-IPAMSubnet -CIDR $CIDR).id
    }
    if ($SubnetDescription) {
        $SubnetID = (Get-IPAMSubnet -SubnetDescription $SubnetDescription).id
    }
    if ($PSCmdlet.ShouldProcess($SectionID, "Remove subnet. This will remove all IP-addresses in the subnet.")) {
        $result = New-IPAMRequest -APIController 'subnets' -APIMethod 'Delete' -Parameters $SubnetID
        return $result
    }
}
