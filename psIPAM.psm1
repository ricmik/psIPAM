# Apache requires TLS version 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#Get public and private function definition files.
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\ -Recurse -Include *.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\ -Recurse -Include *.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
Foreach($import in @($Public + $Private))
{
    Try
    {
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

# Export Public functions

Export-ModuleMember -Function $Public.Basename
