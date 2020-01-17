function New-IPAMRequest {
    # This function is used by all functions for sending the actual REST calls to the IPAM-server
    Param(
        # Valid API controllers as explained in the phpIPAM API Documentation
        [ValidateSet("sections", "subnets", "folders", "addresses", "vlans", "l2domains", "vrfs", "tools", "prefix")][string]$APIController,
        # Valid HTTP methods as explained in the phpIPAM API Documentation
        [ValidateSet("Get", "Post", "Options", "Put", "Patch", "Delete")][string]$APIMethod,
        [string[]]$Parameters,
        [string]$Body
    )

    # Without a token we cannot continue with the request.
    if (!$($Global:IPAMToken)) {
        Write-Error -Message "You need to create a session with New-IPAMSession first."
        break
    }

    # Make sure to update the token if it is about to expire. Or stop execution if the token has expired.
    if ((Get-Date) -gt [datetime]::ParseExact($($Global:IPAMTokenExpires), "yyyy-MM-dd HH:mm:ss", $null)) {
        Write-Error -Message "The token has expired and cannot be extended anymore. Please create a new session with New-IPAMSession."
        break
    } elseif ((Get-Date).AddHours(-1) -gt [datetime]::ParseExact($($Global:IPAMTokenExpires), "yyyy-MM-dd HH:mm:ss", $null)) {
        Write-Debug -Message "The token is about to expire. Trying to extend the token."
        try {
            Update-IPAMToken
        } catch {
            Write-Error -Message "Could not update token expiration date. Please create a new session with New-IPAMSession."
            break
        }
    }


    $Headers = @{
        "Token"        = $Global:IPAMToken
        "Content-Type" = "application/json"
    }
    if ($Parameters) {
        foreach ($Parameter in $Parameters) {
            $uriparameters += "$Parameter/"
        }
        $uri = "https://$($Global:IPAMServer)/api/$($Global:IPAMAppid)/$APIController/$uriparameters"
    } else {
        $uri = "https://$($Global:IPAMServer)/api/$($Global:IPAMAppid)/$APIController/"
    }
    try {
        Write-Debug -Message "IPAM Token: $Global:IPAMToken"
        Write-Debug -Message "IPAM Token Expiration: $Global:IPAMTokenExpires"
        Write-Debug -Message "Invoke-Webrequest ($APIMethod) towards: $uri"
        if($Body -and ($APIMethod -eq "Post" -or $APIMethod -eq "Patch")) {
            Write-Debug -Message "Body of $APIMethod message: $Body"
            $response = Invoke-WebRequest -Uri $uri -Headers $Headers -Method $APIMethod -Body $Body
        }
        else {
            $response = Invoke-WebRequest -Uri $uri -Headers $Headers -Method $APIMethod
        }
        
        return $response.Content | ConvertFrom-Json
        
    } catch {
        Write-Error -Message $_.Exception.Message
        throw
    }
   
    
}