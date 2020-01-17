function Remove-IPAMIPAddress {
    Param(
        [ipaddress]$IpAddress,
        [string]$HostName,
        [int]$IpAddressID,
        [switch]$Confirm
    )
    if ($IpAddress) {
        $ipamobject = Get-IPAMIPAddress -IPAddress $($IpAddress.IPAddressToString)
        $result = New-IPAMRequest -APIController 'addresses' -APIMethod 'Delete' -Parameters @($($ipamobject.id))
    } elseif ($HostName) {
        $ipamobject = Get-IPAMIPAddress -Hostname $HostName
        $result = New-IPAMRequest -APIController 'addresses' -APIMethod 'Delete' -Parameters @($($ipamobject.id))
    } elseif ($IpAddressID) {
        $result = New-IPAMRequest -APIController 'addresses' -APIMethod 'Delete' -Parameters $IpAddressID
    }
    return $result
}