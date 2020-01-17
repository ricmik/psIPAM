function New-IPAMSection {
    Param(
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][string]$Description
    )
    $Body = @{
        name = $Name
        description = $Description      
    } | ConvertTo-Json
    $result = New-IPAMRequest -APIController 'sections' -APIMethod 'Post' -Body $Body
    return $result
}
