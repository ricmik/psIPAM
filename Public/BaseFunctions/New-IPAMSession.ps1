function New-IPAMSession {
    # This function is used for creating a token and making everything ready for all other functions
    Param(
        [string]$ipamserver = 'ipam.url',
        [string]$appid = 'dhcpupdate',
        [Parameter(Mandatory = $true)][string]$username,
        [Parameter(Mandatory = $true)][string]$password
    )
    
    <#FOR DEV PURPOSES ONLY
    $ipamserver = 'ipam.url'
    $appid = 'appid'
    $username = 'devpowershell'
    $password = ''
    #END FOR DEV PURPOSES ONLY
    #>
    
    $credpair = "$($username):$($password)"
    $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($credpair))

    $Headers = @{
        "Authorization" = "Basic $encodedCreds"
    }

    $uri = "https://$ipamserver/api/$appid/user/" 
    $response = Invoke-WebRequest -Uri $uri -Headers $Headers -Method Post -UseBasicParsing
    $responsecontent = $response.Content | ConvertFrom-Json
    $Global:IPAMToken = $responsecontent.data.token
    $Global:IPAMTokenExpires = $responsecontent.data.expires
    $Global:IPAMServer = $ipamserver
    $Global:IPAMAppid = $appid
} 
