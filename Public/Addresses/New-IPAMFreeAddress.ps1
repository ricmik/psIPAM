function New-IPAMFreeAddress {
    Param(
    [int]$SubnetID,
    [string]$Hostname,
    [string]$Description,
    [switch]$Create
    )
    if($create) {
        $parameters = @("first_free", $subnetid)
        $Body = @{
            hostname = $Hostname
            description = $Description
        } | ConvertTo-Json
        $result = New-IPAMRequest -APIController 'addresses' -APIMethod 'Post' -Parameters $parameters -Body $Body
    }
    else {
        $parameters = @("first_free", $subnetid)
        $result = New-IPAMRequest -APIController 'addresses' -APIMethod 'Get' -Parameters $parameters
    }
    return $result
    
}