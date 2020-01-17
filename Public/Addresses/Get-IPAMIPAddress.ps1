function Get-IPAMIPAddress {
    Param(
        [ipaddress]$IPAddress,
        $Hostname,
        $IPAddressID
    )
    # /api/my_app/addresses/search/{ip}/
    # searches for addresses in database, returns multiple if found
    if($IPAddress) {
        $result = (New-IPAMRequest -APIController 'addresses' -APIMethod 'Get' -Parameters @("search", $($IPAddress.IPAddressToString))).data
    }
    #/api/my_app/addresses/search_hostname/{hostname}/
    #searches for addresses in database by hostname, returns multiple if found
    elseif($Hostname) {
        $result = (New-IPAMRequest -APIController 'addresses' -APIMethod 'Get' -Parameters @("search_hostname", $Hostname)).data
    }
    elseif($IPAddressID) {
        $result = (New-IPAMRequest -APIController 'addresses' -APIMethod 'Get' -Parameters $IPAddressID).data
    }
    return $result
}
