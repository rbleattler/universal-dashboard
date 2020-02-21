function New-UDCard {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Id = ([Guid]::NewGuid()).ToString(),

        [Parameter()]
        [string]$ClassName,

        [Parameter()]
        [switch]$ShowToolBar,
     
        [Parameter (ParameterSetName = "Advanced")]
        [PSTypeName('UniversalDashboard.MaterialUI.CardToolbar')]$ToolBar,

        [Parameter(ParameterSetName = "Advanced")]
        [PSTypeName('UniversalDashboard.MaterialUI.CardHeader')]$Header,

        [Parameter(ParameterSetName = "Advanced")]
        [PSTypeName('UniversalDashboard.MaterialUI.CardBody')]$Body,

        [Parameter(ParameterSetName = "Advanced")]
        [PSTypeName('UniversalDashboard.MaterialUI.CardExpand')]$Expand,

        [Parameter(ParameterSetName = "Advanced")]
        [PSTypeName('UniversalDashboard.MaterialUI.CardFooter')]$Footer,

        [Parameter()]
        [Hashtable]$Style,

        [Parameter()]
        [ValidateSet("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24")]
        [int]$Elevation,

        [Parameter(ParameterSetName = "Simple")]
        [String]$Title,
        [Parameter(ParameterSetName = "Simple")]
        [ValidateSet('left', 'center', 'right')]
        [String]$TitleAlignment = 'left',
        [Parameter(ParameterSetName = "Simple")]
        [ScriptBlock]$Content,
        [Parameter(ParameterSetName = "Simple")]
        [string]$Image
    )

    End {

        if ($PSCMdlet.ParameterSetName -eq 'Advanced')
        {
            # Card toolbar checks
            if ($null -ne $ToolBar) {
                if ($ToolBar.psobject.typenames -notcontains "UniversalDashboard.MaterialUI.CardToolbar") {
                    throw "ToolBar must be a UniversalDashboard.MaterialUI.CardToolbar object, please use New-UDCardToolBar command."
                }
            }

            # Card header checks 
            if ($null -ne $Header) {
                if ($Header.psobject.typenames -notcontains "UniversalDashboard.MaterialUI.CardHeader") {
                    throw "Header must be a UniversalDashboard.MaterialUI.CardHeader object, please use New-UDCardHeader command."
                }
            }

            # Card Content checks 
            if ($null -ne $Content) {
                if ($Content.psobject.typenames -notcontains "UniversalDashboard.MaterialUI.CardBody") {
                    throw "Body must be a UniversalDashboard.MaterialUI.CardBody object, please use New-UDCardBody command."
                }
            }

            # Card Expand checks 
            if ($null -ne $Expand) {
                if ($Expand.psobject.typenames -notcontains "UniversalDashboard.MaterialUI.CardExpand") {
                    throw "Expand must be a UniversalDashboard.MaterialUI.CardExpand object, please use New-UDCardExpand command."
                }
            }

            # Card footer checks 
            if ($null -ne $Footer) {
                if ($Footer.psobject.typenames -notcontains "UniversalDashboard.MaterialUI.CardFooter") {
                    throw "Footer must be a UniversalDashboard.MaterialUI.CardFooter object, please use New-UDCardFooter command."
                }
            }
            
            $Parts = @{
                    toolbar         = $ToolBar
                    header          = $Header
                    body            = $Body
                    expand          = $Expand
                    footer          = $Footer
            }
            $Content = {$Parts}
        }
        else 
        {
            $Header = New-UDCardHeader -Title $Title

            if ($Image)
            {
                $Media = New-UDCardMedia -Height 120 -Image $Image
            }

            $BodyContent = $Content
            $Body = New-UDCardBody -Content {
                if ($null -ne $Content)
                {
                    $BodyContent.Invoke()
                }
            }

            $Parts = @{
                toolbar         = $ToolBar
                header          = $Header
                body            = $Body
                expand          = $Expand
                footer          = $Footer
            }
            $Content = {$Parts}
        }



        # Check to test if the card is dynamic ( Endpoint ) or static.
        if ($IsEndPoint) {
            $Endpoint = New-UDEndpoint -Endpoint $Content -Id $id
        }
        
        $Card = @{
            type            = "mu-card"
            isPlugin        = $true
            assetId         = $MUAssetId
            id              = $Id
            className       = $ClassName
            showToolBar     = $ShowToolBar.IsPresent
            media           = $Media
            toolbar         = $ToolBar
            header          = $Header
            body            = $Body
            expand          = $Expand
            footer          = $Footer
            style           = $Style
            elevation       = $Elevation

        }

        $Card.PSTypeNames.Insert(0, "UniversalDashboard.MaterialUI.Card") | Out-Null
        $Card
    }
}


function New-UDCardToolbar {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Id = ([Guid]::NewGuid()).ToString(),

        [Parameter()]
        [string]$ClassName,

        [Parameter()]
        [scriptblock]$Content,

        [Parameter ()]
        [PSTypeName("UniversalDashboard.MaterialUI.Icon")]$Icon,
        
        [Parameter()]
        [object]$Title,


        [Parameter()]
        [Switch]$ShowButtons,

        [Parameter()]
        [Hashtable]$Style

    )
    End {

        # if ($null -ne $Title) {
        #     if (-not($Title.psobject.typenames -notcontains "UniversalDashboard.MaterialUI.Typography") -or ($Title -isnot [string])) {
        #         throw "Title must be a string or UniversalDashboard.MaterialUI.Typography object, please use New-UDMuTypography command."
        #     }
        # }

        if ($null -ne $Content) {
            $Object = $Content.Invoke() 
        }
        else {
            throw "New-UDMuCardExpand Content parameter can't be empty"
        }

        $CardToolbar = @{
            type        = "mu-card-toolbar"
            isPlugin    = $true
            assetId     = $MUAssetId
            id          = $Id
            className   = $ClassName
            content     = $Object
            title       = $Title
            style       = $Style
            icon        = $Icon
            showButtons = $ShowButtons.IsPresent
            # PSTypeName  = "UniversalDashboard.MaterialUI.CardToolbar"
        }
        $CardToolbar.PSTypeNames.Insert(0, "UniversalDashboard.MaterialUI.CardToolbar") | Out-Null
        $CardToolbar
    }
}
function New-UDCardHeader {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Id = ([Guid]::NewGuid()).ToString(),
        [Parameter()]
        [string]$Title

    )
    End {
        $Header = @{
            type            = "mu-card-header"
            isPlugin        = $true
            assetId         = $MUAssetId
            id              = $Id
            title           = $Title
        }
        $Header.PSTypeNames.Insert(0, "UniversalDashboard.MaterialUI.CardHeader") | Out-Null
        $Header
    }
}


function New-UDCardBody {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Id = ([Guid]::NewGuid()).ToString(),

        [Parameter()]
        [string]$ClassName,

        [Parameter()]
        [scriptblock]$Content,

        [Parameter()]
        [Hashtable]$Style,

        [Parameter(ParameterSetName = 'endpoint')]
        [switch]$IsEndPoint,

        [Parameter(ParameterSetName = 'endpoint')]
        [switch]$AutoRefresh,

        [Parameter(ParameterSetName = 'endpoint')]
        [int]$RefreshInterval = 5
    )
    End {

        if ($null -ne $Content) {
            if ($IsEndPoint) {
                $Endpoint = New-UDEndpoint -Endpoint $Content -Id $id
                $Object = $Content.Invoke()
            }
            else {
                $Object = $Content.Invoke()
            }
        }
        else {
            throw "New-UDCardBody Content parameter can't be empty"
        }

        $cContent = @{
            type            = "mu-card-body"
            isPlugin        = $true
            assetId         = $MUAssetId
            id              = $Id
            className       = $ClassName
            content         = $Object
            style           = $Style
            isEndpoint      = $isEndPoint.IsPresent
            refreshInterval = $RefreshInterval
            autoRefresh     = $AutoRefresh.IsPresent
            # PSTypeName      = "UniversalDashboard.MaterialUI.CardContent"

        }
        $cContent.PSTypeNames.Insert(0, "UniversalDashboard.MaterialUI.CardBody") | Out-Null
        $cContent
    }
}


function New-UDCardExpand {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Id = ([Guid]::NewGuid()).ToString(),

        [Parameter()]
        [string]$ClassName,

        [Parameter()]
        [scriptblock]$Content,

        [Parameter()]
        [Hashtable]$Style,

        [Parameter(ParameterSetName = 'endpoint')]
        [switch]$IsEndPoint,

        [Parameter(ParameterSetName = 'endpoint')]
        [switch]$AutoRefresh,

        [Parameter(ParameterSetName = 'endpoint')]
        [int]$RefreshInterval = 5
    )
    End {
        if ($null -ne $Content) {
            if ($IsEndPoint) {
                $Endpoint = New-UDEndpoint -Endpoint $Content -Id $id
                $Object = $Content.Invoke()
            }
            else {
                $Object = $Content.Invoke()
            }
        }
        else {
            throw "New-UDMuCardExpand Content parameter can't be empty"
        }

        $Expand = @{
            type            = "mu-card-expand"
            isPlugin        = $true
            assetId         = $MUAssetId
            id              = $Id
            className       = $ClassName
            content         = $Object
            style           = $Style
            isEndpoint      = $isEndPoint.IsPresent
            refreshInterval = $RefreshInterval
            autoRefresh     = $AutoRefresh.IsPresent
            # PSTypeName      = "UniversalDashboard.MaterialUI.CardExpand"
        }
        $Expand.PSTypeNames.Insert(0, "UniversalDashboard.MaterialUI.CardExpand") | Out-Null
        $Expand
    }
}


function New-UDCardFooter {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Id = ([Guid]::NewGuid()).ToString(),

        [Parameter()]
        [string]$ClassName,

        [Parameter()]
        [scriptblock]$Content,

        [Parameter()]
        [Hashtable]$Style,

        [Parameter(ParameterSetName = 'endpoint')]
        [switch]$IsEndPoint,

        [Parameter(ParameterSetName = 'endpoint')]
        [switch]$AutoRefresh,

        [Parameter(ParameterSetName = 'endpoint')]
        [int]$RefreshInterval = 5
    )
    End {
        if ($null -ne $Content) {
            if ($IsEndPoint) {
                $Endpoint = New-UDEndpoint -Endpoint $Content -Id $id
                $Object = $Content.Invoke()
            }
            else {
                $Object = $Content.Invoke()
            }
        }
        else {
            throw "New-UDMuCardFooter Content parameter can't be empty"
        }

        $Footer = @{
            type            = "mu-card-footer"
            isPlugin        = $true
            assetId         = $MUAssetId
            id              = $Id
            className       = $ClassName
            content         = $Object
            style           = $Style
            isEndpoint      = $isEndPoint.IsPresent
            refreshInterval = $RefreshInterval
            autoRefresh     = $AutoRefresh.IsPresent
            # PSTypeName      = "UniversalDashboard.MaterialUI.CardFooter"
        }
        $Footer.PSTypeNames.Insert(0, "UniversalDashboard.MaterialUI.CardFooter") | Out-Null
        $Footer
    }
}
function New-UDCardMedia {
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param(
        [Parameter()]
        [string]$Id = ([Guid]::NewGuid()).ToString(),

        [Parameter()]
        [ValidateSet("img", "video", "audio")]       
        [string]$Component = "img",

        [Parameter()]
        [string]$Alt,

        [Parameter()]
        [string]$Height,

        [Parameter (ParameterSetName = 'image')]
        [string]$Image,

        [Parameter()]
        [string]$Title,

        [Parameter(ParameterSetName = 'media')]
        [string]$Source

    )
    End {
        $CardMedia = @{
            type      = "mu-card-media"
            isPlugin  = $true
            assetId   = $MUAssetId
            id        = $Id
            component = $Component
            alt       = $Alt
            height    = $Height
            image     = $Image
            title     = $Title
            source    = $Source
            # PSTypeName = "UniversalDashboard.MaterialUI.CardMedia"
        }
        $CardMedia.PSTypeNames.Insert(0, "UniversalDashboard.MaterialUI.CardMedia") | Out-Null
        $CardMedia
    }
}