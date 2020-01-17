
# Load the module (unload it first in case we've made changes since loading it previously)
Remove-Module psIPAM -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\psIPAM.psm1
Remove-Variable -Name IPAM*

$ipamserver = 'dev-ipam.url'
$ipamappid = 'dev'
$ipamuser = 'dev'
$ipampassword = 'pwd'

Describe "psIPAM module" {
    It "Create new session and collect token from IPAM server" {
        New-IPAMSession -ipamserver $ipamserver -appid $ipamappid -username $ipamuser -password $ipampassword
        $IPAMToken | Should be $true
        $IPAMTokenExpires | Should be $true
        $IPAMAppid | Should be $ipamappid
        $IPAMServer | Should be $ipamserver
    }
}
Describe "Section controls" {
    It "Get all sections from IPAM" {
        $script:sectionresult = Get-IPAMSection
        $script:sectionresult.count | Should BeGreaterThan 0
    }
    It "Return one section by name" {
        $sectionbyname = Get-IPAMSection -SectionName $($script:sectionresult)[0].name
        $sectionbyname.count | Should be $null
        $sectionbyname.name | Should be $($script:sectionresult)[0].name
    }
    It "Return one section by ID" {
        $sectionbyid = Get-IPAMSection -SectionName $($script:sectionresult)[0].id
        $sectionbyid.count | Should be $null
        $sectionbyid.id | Should be $($script:sectionresult)[0].id
        $sectionbyid.name | Should be $($script:sectionresult)[0].name
    }
}
Describe "Subnet controls" {
    It "Get all subnets from IPAM" {
        $script:subnetsresult = Get-IPAMSubnet
        $script:subnetsresult.count | Should BeGreaterThan 1
    }
    <# It "Get all subnets by CIDR" {
        $CIDR = ($($script:subnetsresult)[0]).subnet + "/" + ($($script:subnetsresult)[0]).mask
        $subnetbycidr = Get-IPAMSubnet -SubnetID "$CIDR"
        $subnetbycidr.count | Should be 1
        $subnetbycidr.subnet | Should be $($script:subnetsresult)[0].subnet
    }#>
    It "Get one subnet by Subnet ID" {
        $subnetbysubnetid = Get-IPAMSubnet -SubnetID $($script:subnetsresult)[0].id
        $subnetbysubnetid.count | Should be $null
        $subnetbysubnetid.id | Should be $($script:subnetsresult)[0].id
    }
    <#
    It "Get subnet by Subnet Description" {
        $subnetbysubnetdescription = Get-IPAMSubnet -SubnetDescription $($script:subnetsresult)[0].description
        $subnetbysubnetdescription.count | Should Not Be $null
    }
    #>
    It "Get all subnets by Section ID" {
        $script:sectionresult = Get-IPAMSection
        $subnetbysectionid = Get-IPAMSubnet -SectionID $($script:sectionresult)[0].id
        $subnetbysectionid.count | Should BeGreaterThan 0
        $subnetbysectionid.sectionid | Should be $($script:sectionresult)[0].id
    }
    It "Get all subnets by Section Name" {
        $subnetbysectionname = Get-IPAMSubnet -SectionName $($script:sectionresult)[0].name
        $subnetbysectionname.count | Should BeGreaterThan 0
        $subnetbysectionname.sectionid | Should be $($script:sectionresult)[0].id
    }
}

Describe "Complete run" {
    It "Create new IPAM Session" {
        New-IPAMSession -ipamserver $ipamserver -appid $ipamappid -username $ipamuser -password $ipampassword
        $IPAMToken | Should be $true
        $IPAMTokenExpires | Should be $true
        $IPAMAppid | Should be $ipamappid
        $IPAMServer | Should be $ipamserver
    }
    It "Create a new test section (PesterTest)" {
        $createsection = New-IPAMSection -Name "PesterTest" -Description "This is created by a pester test of the psIPAM module (you should not see me)"
        $createsection.success | Should be "True"
    }
    It "Create a new test subnet in test section (127.0.0.0/24)" {
        $script:testsection = Get-IPAMSection -SectionName "PesterTest"
        $script:createsubnet = New-IPAMSubnet -SectionID $($script:testsection).id -NetworkAddress "127.0.0.0" -SubnetBitMask "24" -Description "PesterTestSubnet" 
        $createsubnet.success | Should be "True"
        $createsubnet.message | Should be "Subnet created"
        $createsubnet.data | Should be "127.0.0.0/24"
    }
    It "Check for a free address in the test subnet" {
        $getfreeaddress = New-IPAMFreeAddress -SubnetID $($script:createsubnet).id
        $getfreeaddress.success | Should be "True"
        $getfreeaddress.data | Should be "127.0.0.1"
    }
    It "Create a new (free) IP Address in the test subnet" {
        $script:newfreeipaddress = New-IPAMFreeAddress -SubnetID $($script:createsubnet).id -Hostname "psIPAMTest.delete.me" -Description "This is created by a pester test of the psIPAM module (you should not see me)" -Create
        $newfreeipaddress.success | Should be "True"
        $newfreeipaddress.message | Should be "Address created"
        $newfreeipaddress.data | Should be "127.0.0.1"
    }
    It "Get test IP Address by ID" {
        $getipaddress = Get-IPAMIPAddress -IPAddressID $($script:newfreeipaddress).id
        $getipaddress.id | Should be $($script:newfreeipaddress).id
        $getipaddress.ip | Should be "127.0.0.1"
        $getipaddress.hostname | Should be "psIPAMTest.delete.me"
    }
    It "Get test IP Address by hostname" {
        $getipaddressbyname = Get-IPAMIPAddress -Hostname "psIPAMTest.delete.me"
        $getipaddressbyname.count | Should be $null
        $getipaddressbyname.ip | Should be "127.0.0.1"
        $getipaddressbyname.hostname | Should be "psIPAMTest.delete.me"
    }
    It "Get test IP Address by IP" {
        $getipaddressbyip = Get-IPAMIPAddress -IPAddress "127.0.0.1"
        $getipaddressbyip.count | Should be $null
        $getipaddressbyip.ip | Should be "127.0.0.1"
        $getipaddressbyip.hostname | Should be "psIPAMTest.delete.me"
    }
    It "Remove test IP Address by Hostname" {
        $removeipaddress = Remove-IPAMIPAddress -Hostname "psIPAMTest.delete.me"
        $removeipaddress.success | Should be "True"
        $removeipaddress.message | Should be "Address deleted"
    }
    It "Check that subnet is empty" {

    }
    It "Remove test subnet" {

    }
    It "Remove test section with all subnets and IP's" {
        $removesection = Remove-IPAMSection -SectionName "PesterTest" -Confirm:$false
        $removesection.success | Should be "True"
    }
}