function Update-IPAMToken {
    # Used for extending the token expiration time
    if (!$($Global:IPAMToken)) {
        Write-Error -Message "You need to create a session with New-IPAMSession first."
        break
    }

    try {
        $Headers = @{
            "Token"        = $Global:IPAMToken
            "Content-Type" = "application/json"
        }
        $uri = "https://$Global:IPAMServer/api/$($Global:IPAMAppid)/user/" 
        $response = Invoke-WebRequest -Uri $uri -Headers $Headers -Method Patch -UseBasicParsing
        $responsecontent = $response.Content | ConvertFrom-Json
        $Global:IPAMTokenExpires = $responsecontent.data.expires
        Write-Debug -Message "Invoke-Webrequest towards: $uri"
        
    } catch {
        Write-Error -Message $_.Exception.Message    
        throw
    }
    Write-Debug -Message "New token expiration time: $Global:IPAMTokenExpires"
}