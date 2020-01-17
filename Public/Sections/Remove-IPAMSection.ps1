function Remove-IPAMSection {
    [CmdletBinding(DefaultParameterSetName = 'BySectionName', SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    Param(
        [Parameter(Mandatory = $false, ParameterSetName = 'BySectionID')][int]$SectionID,
        [Parameter(Mandatory = $false, ParameterSetName = 'BySectionName')][string]$SectionName
    )
    if ($SectionName) {
        $SectionID = (Get-IPAMSection -SectionName $SectionName).id
    }
    if ($PSCmdlet.ShouldProcess($SectionID, "Remove section. This will remove all subnets and IP-addresses in the section.")) {
        $result = New-IPAMRequest -APIController 'sections' -APIMethod 'Delete' -Parameters $SectionID
        return $result
    }
}
