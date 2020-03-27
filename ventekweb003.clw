

   MEMBER('ventekweb.clw')                                 ! This is a MEMBER module


   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE
   INCLUDE('NetWeb.inc'),ONCE
   INCLUDE('netwebm.inc'),ONCE

                     MAP
                       INCLUDE('VENTEKWEB003.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - Window
!!! </summary>
WebServer PROCEDURE (<NetWebServer pServer>)

WebLog               GROUP,PRE(web)                        ! 
EnableLogging        LONG(1)                               ! 
LastGet              STRING(4096)                          ! 
LastPost             STRING(4096)                          ! 
StartDate            LONG                                  ! 
StartTime            LONG                                  ! 
PagesServed          LONG                                  ! 
                     END                                   ! 
LogQueue             QUEUE,PRE(LogQ)                       ! 
Port                 STRING(30)                            ! 
Socket               LONG                                  ! 
Thread               LONG                                  ! 
Date                 LONG                                  ! 
Time                 LONG                                  ! 
Desc                 STRING(4096)                          ! 
                     END                                   ! 
BannedQueue          QUEUE,PRE(BannedQueue)                ! 
IPAddress            STRING(45)                            ! 
                     END                                   ! 
WebPerformance       GROUP,PRE(wp)                         ! 
StartDateA           LONG                                  ! 
StartTimeA           LONG                                  ! 
NumberOfRequests     LONG                                  ! 
NumberOfSpiderRequests LONG                                ! 
NumberOf404Requests  LONG                                  ! 
NumberOf500Requests  LONG                                  ! 
TotalRequestTime     REAL                                  ! 
NumberOfRequestsLTHalf LONG                                ! 
NumberOfRequestsLTOne LONG                                 ! 
NumberOfRequestsLTTwo LONG                                 ! 
NumberOfRequestsLTFive LONG                                ! 
NumberOfRequestsGTFive LONG                                ! 
RequestTimeLTHalf    REAL                                  ! 
RequestTimeLTOne     REAL                                  ! 
RequestTimeLTTwo     REAL                                  ! 
RequestTimeLTFive    REAL                                  ! 
RequestTimeGTFive    REAL                                  ! 
AverageRequestTimeLTHalf REAL                              ! 
AverageRequestTimeLTOne REAL                               ! 
AverageRequestTimeLTTwo REAL                               ! 
AverageRequestTimeLTFive REAL                              ! 
AverageRequestTimeGTFive REAL                              ! 
MaximumThreads       LONG                                  ! 
MaximumSessions      LONG                                  ! 
MaximumSessionData   LONG                                  ! 
MaximumThreadPool    LONG                                  ! 
MaximumConnections   LONG                                  ! 
MaximumWebSocketConnections LONG                           ! 
NumberOfSessions     LONG                                  ! 
NumberOfSessionData  LONG                                  ! 
NumberOfThreads      LONG                                  ! 
NumberOfThreadPool   LONG                                  ! 
NumberOfConnections  LONG                                  ! 
NumberofWebSocketConnections LONG                          ! 
                     END                                   ! 
ServerSettings       GROUP,PRE()                           ! 
set:SecurePort       LONG                                  ! 
set:InsecurePort     LONG                                  ! 
set:AccountName      STRING(256)                           ! 
set:Domains          STRING(2048)                          ! 
set:CertificatesFolder STRING(256)                         ! 
set:LastCertificateCheckDate LONG                          ! 
set:Staging          LONG                                  ! 
set:WebFolder        STRING(256)                           ! 
set:AcmeFolder       STRING(256)                           ! 
set:BindToIpAddress  STRING(100)                           ! 
set:SessionTimeout   LONG                                  ! 
set:xFrameOptions    STRING(256)                           ! 
set:AccessControlAllowOrigin STRING(256)                   ! 
set:StrictTransportSecurity STRING(50)                     ! 
set:ContentSecurityPolicy STRING(256)                      ! 
set:ContentSecurityPolicyReportOnly STRING(256)            ! 
set:ReferrerPolicy   STRING(50)                            ! 
                     END                                   ! 
s_web              &NetWebServer
Net:ShortInit      Long
loc:RequestData    Group(NetWebServerRequestDataType).
loc:OverString     String(size(loc:RequestData)),over(loc:RequestData)
loc:ShuttingDown   Long
loc:Index          Long
ServerStateName        StringTheory
ServerStateXML         Class(xFileXML)
SaveCurrentFieldToXML    PROCEDURE (Long p_x,Long p_DimCounter,String p_name),VIRTUAL
AssignField              PROCEDURE (Long DataStartPos,Long DataEndPos),Long, virtual
                       End
Window               WINDOW('NetTalk Web Server'),AT(,,460,315),FONT('Segoe UI',10,,FONT:regular,CHARSET:ANSI), |
  DOUBLE,AUTO,GRAY,IMM,SYSTEM
                       SHEET,AT(5,5,452,290),USE(?SHEET1)
                         TAB('Log'),USE(?TabLog)
                           GROUP('Logging Group'),AT(12,24,440,264),USE(?LogGroup)
                             LIST,AT(17,29,430,70),USE(?LogQueue),VSCROLL,COLOR(,COLOR:Black,00F0F0F0h),GRID(00F0F0F0h), |
  FORMAT('51L(2)|M~IP Address~@s30@28L(2)|M~Socket~@n7@28L(2)|M~Thread~@n3@51L(2)|M~Dat' & |
  'e~@D17B@36L(2)|M~Time~@T4B@1020L(2)|M~Description~@s255@'),FROM(LogQueue)
                             TEXT,AT(17,104,210,159),USE(web:LastGet),VSCROLL
                             TEXT,AT(236,104,210,159),USE(web:LastPost),VSCROLL
                             OPTION('Log:'),AT(17,266,147,22),USE(web:EnableLogging),BOXED
                               RADIO('No'),AT(23,275),USE(?Option1:Radio1),TRN,VALUE('0')
                               RADIO('Screen'),AT(51,275),USE(?Option1:Radio2),TRN,VALUE('1')
                               RADIO('Screen && Disk'),AT(97,275,61),USE(?Option1:Radio3),TRN,VALUE('2')
                             END
                             BUTTON('Clear'),AT(183,272,50,14),USE(?Clear)
                             BUTTON('Ban'),AT(237,272,50,14),USE(?Ban)
                           END
                         END
                         TAB('Performance'),USE(?TabPerformance)
                           STRING('Started At:'),AT(10,23),USE(?StartDate),TRN
                           STRING(@d17),AT(88,23),USE(wp:StartDateA),TRN
                           STRING(@t1),AT(153,23),USE(wp:StartTimeA),TRN
                           LIST,AT(228,23,184,74),USE(?BannedList),HVSCROLL,FORMAT('180L(2)|M~Banned IP Addresses~@s45@'), |
  FROM(BannedQueue)
                           BUTTON('UnBan'),AT(228,101,50,14),USE(?UnBanButton)
                           GROUP('Number of Requests'),AT(10,37,173,82),USE(?Perfrequests),BOXED
                             STRING('Total:'),AT(19,49),USE(?NumberOfRequests),TRN
                             STRING(@n14),AT(82,49),USE(wp:NumberOfRequests),RIGHT,TRN
                             STRING('Spiders:'),AT(19,62),USE(?NumberOfSpiderRequests),TRN
                             STRING(@n14),AT(82,62),USE(wp:NumberOfSpiderRequests),RIGHT,TRN
                             STRING('Not Found (404):'),AT(19,75),USE(?NumberOf404Requests),TRN
                             STRING(@n14),AT(82,75),USE(wp:NumberOf404Requests),RIGHT,TRN
                             STRING('Too Busy (500):'),AT(19,88),USE(?NumberOf500Requests),TRN
                             STRING(@n14),AT(82,88),USE(wp:NumberOf500Requests),RIGHT,TRN
                             STRING('Total Time:'),AT(19,101),USE(?TotalRequestTime),TRN
                             STRING(@n10.2),AT(99,101),USE(wp:TotalRequestTime),RIGHT,TRN
                           END
                           GROUP('Performance Breakdown'),AT(10,122,412,60),USE(?PerfBreakdown),BOXED
                             STRING('<< 0.5'),AT(132,130),USE(?LT05),FONT(,,,FONT:bold),RIGHT,TRN
                             STRING('<< 1'),AT(203,130),USE(?LT1),FONT(,,,FONT:bold),RIGHT,TRN
                             STRING('<< 2'),AT(267,130),USE(?LT2),FONT(,,,FONT:bold),RIGHT,TRN
                             STRING('<< 5'),AT(331,130),USE(?LT5),FONT(,,,FONT:bold),RIGHT,TRN
                             STRING('> 5'),AT(395,130),USE(?GT5),FONT(,,,FONT:bold),RIGHT,TRN
                             STRING('Number of requests:'),AT(19,143),USE(?Numberbreakdown),TRN
                             STRING(@n11),AT(95,143),USE(wp:NumberOfRequestsLTHalf),RIGHT,TRN
                             STRING(@n11),AT(159,143),USE(wp:NumberOfRequestsLTOne),RIGHT,TRN
                             STRING(@n11),AT(223,143),USE(wp:NumberOfRequestsLTTwo),RIGHT,TRN
                             STRING(@n11),AT(287,143),USE(wp:NumberOfRequestsLTFive),RIGHT,TRN
                             STRING(@n11),AT(351,143),USE(wp:NumberOfRequestsGTFive),RIGHT,TRN
                             STRING('Total Response Time (s):'),AT(19,156),USE(?totaltimeBreakdown),TRN
                             STRING(@n11),AT(95,156),USE(wp:RequestTimeLTHalf),RIGHT,TRN
                             STRING(@n11),AT(159,156),USE(wp:RequestTimeLTOne),RIGHT,TRN
                             STRING(@n11),AT(223,156),USE(wp:RequestTimeLTTwo),RIGHT,TRN
                             STRING(@n11),AT(287,156),USE(wp:RequestTimeLTFive),RIGHT,TRN
                             STRING(@n11),AT(351,156),USE(wp:RequestTimeGTFive),RIGHT,TRN
                             STRING('Average Response Time (s):'),AT(19,169),USE(?timeBreakdown),TRN
                             STRING(@n4.2),AT(129,169),USE(wp:AverageRequestTimeLTHalf),RIGHT,TRN
                             STRING(@n4.2),AT(193,169),USE(wp:AverageRequestTimeLTOne),RIGHT,TRN
                             STRING(@n4.2),AT(257,169),USE(wp:AverageRequestTimeLTTwo),RIGHT,TRN
                             STRING(@n4.2),AT(321,169),USE(wp:AverageRequestTimeLTFive),RIGHT,TRN
                             STRING(@n10),AT(355,169),USE(wp:AverageRequestTimeGTFive),RIGHT,TRN
                           END
                           GROUP('Resources'),AT(10,189,232,105),USE(?PerfResources),BOXED
                             STRING('Current'),AT(124,197),USE(?Current),FONT(,,,FONT:bold),TRN
                             STRING('Maximum'),AT(178,197),USE(?Maximum),FONT(,,,FONT:bold),TRN
                             STRING('Threads:'),AT(19,210),USE(?Threads),TRN
                             STRING(@n11),AT(95,210),USE(wp:NumberOfThreads),RIGHT,TRN
                             STRING(@n11),AT(158,210),USE(wp:MaximumThreads),RIGHT,TRN
                             STRING('Sessions'),AT(19,223),USE(?Sessions),TRN
                             STRING(@n11),AT(95,223),USE(wp:NumberOfSessions),RIGHT,TRN
                             STRING(@n11),AT(158,223),USE(wp:MaximumSessions),RIGHT,TRN
                             STRING('Session Data:'),AT(19,236),USE(?SessionData),TRN
                             STRING(@n11),AT(95,236),USE(wp:NumberOfSessionData),RIGHT,TRN
                             STRING(@n11),AT(158,236),USE(wp:MaximumSessionData),RIGHT,TRN
                             STRING('Thread Pool:'),AT(19,249),USE(?threadPool),TRN
                             STRING(@n11),AT(95,249),USE(wp:NumberOfThreadPool),RIGHT,TRN
                             STRING(@n11),AT(158,249),USE(wp:MaximumThreadPool),RIGHT,TRN
                             STRING('Connections:'),AT(19,262),USE(?connections),TRN
                             STRING(@n11),AT(95,262),USE(wp:NumberOfConnections),RIGHT,TRN
                             STRING(@n11),AT(158,262),USE(wp:MaximumConnections),RIGHT,TRN
                             STRING('WebSocket Connections :'),AT(19,275),USE(?websocketsconnections),TRN
                             STRING(@n11),AT(95,275),USE(wp:NumberofWebSocketConnections),RIGHT,TRN
                             STRING(@n11),AT(158,275),USE(wp:MaximumWebSocketConnections),RIGHT,TRN
                           END
                           BUTTON('Refresh Cache'),AT(247,255,75,16),USE(?RefreshCacheButton)
                           BUTTON('Clear'),AT(247,275,45,16),USE(?ClearStatsButton)
                         END
                         TAB('Settings'),USE(?SettingsTab)
                           SHEET,AT(11,22,438,266),USE(?SettingsSheet)
                             TAB('Security'),USE(?SecurityTab)
                               PROMPT('Secure Port:'),AT(21,39),USE(?set:SecurePort:Prompt),TRN
                               ENTRY(@n6),AT(121,39,60,10),USE(set:SecurePort),OVR
                               CHECK('Testing'),AT(203,39),USE(set:Staging),TRN
                               PROMPT('Insecure Port:'),AT(21,55),USE(?set:InsecurePort:Prompt),TRN
                               ENTRY(@n6),AT(121,55,60,10),USE(set:InsecurePort),OVR
                               BUTTON('Certificates'),AT(291,39),USE(?GetCertificatesButton)
                               BUTTON('Restart Server'),AT(352,39),USE(?RestartButton)
                               PROMPT('Certificates Folder:'),AT(21,71),USE(?set:CertificatesFolder:Prompt),TRN
                               ENTRY(@s255),AT(121,71,317,12),USE(set:CertificatesFolder)
                               PROMPT('Acme Web Folder:'),AT(21,87),USE(?set:AcmeFolder:Prompt),TRN
                               ENTRY(@s255),AT(121,87,317,12),USE(set:AcmeFolder)
                               PROMPT('CA Account:'),AT(21,103),USE(?set:AccountName:Prompt),TRN
                               ENTRY(@s255),AT(121,103,317,12),USE(set:AccountName)
                               PROMPT('Bind To IP Address:'),AT(21,119),USE(?set:BindToIpAddress:Prompt),TRN
                               ENTRY(@s100),AT(121,119,317,12),USE(set:BindToIpAddress)
                               PROMPT('Domains:'),AT(21,135),USE(?set:Domains:Prompt),TRN
                               TEXT,AT(121,135,317,35),USE(set:Domains),HVSCROLL
                               TEXT,AT(121,180,317,70),USE(?LogText),HVSCROLL
                             END
                             TAB('Site'),USE(?SiteTab)
                               PROMPT('Web folder:'),AT(21,39),USE(?set:WebFolder:Prompt),TRN
                               ENTRY(@s255),AT(116,39,300,10),USE(set:WebFolder)
                               PROMPT('Session Timeout:'),AT(21,58),USE(?set:SessionTimeout:Prompt),TRN
                               ENTRY(@t1),AT(116,56,40,12),USE(set:SessionTimeout)
                               GROUP('Server Headers'),AT(19,82,405,112),USE(?ServerHeaders),BOXED
                                 PROMPT('X-Frame-Options:'),AT(29,98),USE(?set:xFrameOptions:Prompt),TRN
                                 ENTRY(@s255),AT(159,98,250,12),USE(set:xFrameOptions)
                                 PROMPT('Access-Control-Allow-Origin:'),AT(29,114),USE(?set:AccessControlAllowOrigin:Prompt), |
  TRN
                                 ENTRY(@s255),AT(159,114,250,12),USE(set:AccessControlAllowOrigin)
                                 PROMPT('Strict-Transport-Security:'),AT(29,130),USE(?set:StrictTransportSecurity:Prompt),TRN
                                 ENTRY(@s255),AT(159,130,250,12),USE(set:StrictTransportSecurity)
                                 PROMPT('Content-Security-Policy:'),AT(29,146),USE(?set:ContentSecurityPolicy:Prompt),TRN
                                 ENTRY(@s255),AT(159,146,250,12),USE(set:ContentSecurityPolicy)
                                 PROMPT('Content-Security-Policy-Report-Only:'),AT(29,162),USE(?set:ContentSecurityPolicyReportOnly:Prompt), |
  TRN
                                 ENTRY(@s255),AT(159,162,250,12),USE(set:ContentSecurityPolicyReportOnly)
                                 PROMPT('Referrer-Policy:'),AT(29,178),USE(?set:ReferrerPolicy:Prompt),TRN
                                 ENTRY(@s255),AT(159,178,250,12),USE(set:ReferrerPolicy)
                               END
                             END
                           END
                         END
                       END
                       BUTTON('Graceful Close'),AT(338,298,64,14),USE(?GracefulCloseButton)
                       BUTTON('Close'),AT(405,298,50,14),USE(?Close)
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
TakeEvent              PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
!Local Data Classes
ThisWebServer        CLASS(NetWebServer)                   ! Generated by NetTalk Extension (Class Definition)
AddLog                 PROCEDURE(FILE p_File,*String p_Field,*String p_Name,String p_DataString,<String p_ip>),DERIVED
AddLog                 PROCEDURE(String p_Data,<string p_ip>),DERIVED
StartNewThread         PROCEDURE(NetWebServerRequestDataType p_RequestData),DERIVED
TakeEvent              PROCEDURE(),DERIVED

                     END


  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------
CheckOmittedWeb  routine
  If not omitted(1)
    If Not pServer &= Null
      Net:ShortInit = 1
    End
  End

UpdateStats  Routine
PopulateBannedQueue  Routine
  Data
str  StringTheory
cx   Long
  Code
  free(BannedQueue)
  str.SetValue(s_web.GetBanned())
  str.split(',')
  loop cx = 1 to str.records()
    BannedQueue.IPAddress = str.getline(cx)
    Add(BannedQueue)
  end
  display()
! ----------------------------------------------------------------------------------------
SaveSettings  Routine
  data
SettingsName        StringTheory
SettingsXML         xFileXML
  code
  SettingsName.SetValue(SettingsName.FileNameOnly(command(0),false) &'.ServerSettings.Xml')
    SettingsXML.Start()
    SettingsXML.TagCase = xf:CaseLower
    SettingsXML.Save(ServerSettings,SettingsName.GetValue(),'','ServerSettings')
! ----------------------------------------------------------------------------------------
LoadSettings  Routine
  data
SettingsName        StringTheory
SettingsXML         xFileXML
  code
  SettingsName.SetValue(SettingsName.FileNameOnly(command(0),false) &'.ServerSettings.Xml')
  If exists(SettingsName.GetValue()) = false
    rename('ServerSettings.xml',SettingsName.GetValue())
  End
  SettingsXML.Start()
  SettingsXML.TagCase = xf:CaseLower
  SettingsXML.Load(ServerSettings,SettingsName.GetValue(),'','ServerSettings')
  if set:SecurePort = 0 and set:InsecurePort = 0 then set:InsecurePort = 88.

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

!s_web    &NetWebServer
  CODE
  GlobalErrors.SetProcedureName('WebServer')
  Do LoadSettings
  If set:CertificatesFolder = '' then set:CertificatesFolder = ThisWebServer._SitesQueue.defaults.CertificatesPath.
  If set:AcmeFolder = '' then set:AcmeFolder = ThisWebServer._SitesQueue.defaults.AcmeFolderPath.
  If set:WebFolder = '' then set:WebFolder = ThisWebServer._SitesQueue.defaults.WebfolderPath.
  If set:SessionTimeout = 0 then set:SessionTimeout = 90001.
  If set:xFrameOptions = '' then set:xFrameOptions = 'sameorigin'.
  If set:ReferrerPolicy = '' then set:ReferrerPolicy = 'strict-origin-when-cross-origin'.
  ThisWebServer.MoveFolder(clip(set:WebFolder) & '\certificates','certificates')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?LogQueue
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.AddItem(Toolbar)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Close,RequestCancelled)                 ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Close,RequestCompleted)                 ! Add the close control to the window manger
  END
  SELF.Open(Window)                                        ! Open window
  !Setting the LineHeight for every control of type LIST/DROP or COMBO in the window using the global setting.
  ?LogQueue{PROP:LineHeight} = 10
  ?BannedList{PROP:LineHeight} = 10
                                               ! Generated by NetTalk Extension (Start)
  do CheckOmittedWeb
  ThisWebServer.InactiveTimeout = 0
  If Net:ShortInit
    s_web &= pServer
  Else
    s_web &= ThisWebServer
    s_web.SuppressErrorMsg = 1
    s_web.init()
    Get(s_web._SitesQueue,1)
    s_web._SitesQueue.defaults.CertificatesPath = set:CertificatesFolder
    s_web._SitesQueue.defaults.WebFolderPath = set:WebFolder
    s_web._SitesQueue.defaults.AcmeFolderPath = set:AcmeFolder
    s_web.acme.staging = set:staging
    s_web.SetPorts(set:InsecurePort, set:SecurePort)
    s_web.SetDomains('localhost')
  
    s_web.Open()
  End
  !---------------------------------
  s_web.MaxThreads = 100
  s_web.ServerMemory.CacheSmallerThan = 1000000
  s_web.ServerMemory.MaxCache = 50000000
  s_web._SitesQueue.Defaults.WebHandlerProcName = 'WebHandler'
  s_web._SitesQueue.Defaults.DefaultPage = 'IndexPage'
  s_web._SitesQueue.Defaults.SessionExpiryAfterHS = set:SessionTimeout
  s_web._SitesQueue.Defaults.xFrameOptions = set:xFrameOptions
  s_web._SitesQueue.Defaults.AccessControlAllowOrigin = set:AccessControlAllowOrigin
  s_web._SitesQueue.Defaults.StrictTransportSecurity = set:StrictTransportSecurity
  s_web._SitesQueue.Defaults.ContentSecurityPolicy = set:ContentSecurityPolicy
  s_web._SitesQueue.Defaults.ContentSecurityPolicyReportOnly = set:ContentSecurityPolicyReportOnly
  s_web._SitesQueue.Defaults.ReferrerPolicy = set:ReferrerPolicy
  s_web._SitesQueue.Defaults.SuggestBasic = 1
  s_web._SitesQueue.Defaults.SuggestDigest = 0
  s_web._SitesQueue.Defaults.ExternalHttps = 0
  s_web._SitesQueue.Defaults.FormLayoutMethod = Net:Table
  s_web._SitesQueue.Defaults.BrowseLayoutMethod = Net:Table
  s_web._SitesQueue.Defaults.ChildrenLayoutMethod = Net:Table
  s_web._SitesQueue.Defaults.SessionLength = 30
  s_web._SitesQueue.Defaults.ChangeSessionOnLogInOut = 1
  s_web._SitesQueue.Defaults.DeleteSessionOnLogout = 0
  s_web._SitesQueue.Defaults.NoIPSpoofing = 0
  s_web.MaxPostSize = 0 * 1024 * 1024
  s_web._SitesQueue.Defaults.MaxPostSize = 0 * 1024 * 1024
  s_web._SitesQueue.Defaults.LoginPage = 'LoginForm'
  s_web._SitesQueue.Defaults.LoginPageIsControl = 1
  s_web._SitesQueue.Defaults.WebFolderPath = set:WebFolder
  If instring('\',s_web._SitesQueue.Defaults.WebFolderPath,1,1) = 0
    s_web._SitesQueue.Defaults.WebFolderPath = clip(s_web._SitesQueue.defaults.appPath) & s_web._SitesQueue.Defaults.WebFolderPath
  End
  s_web._SitesQueue.Defaults.UploadsPath = clip(s_web._SitesQueue.Defaults.WebFolderPath) & '\uploads'
  s_web._SitesQueue.Defaults.HtmlCharset = lower('utf-8')
  s_web._SitesQueue.Defaults.LocatePromptText = clip('Locate')
  s_web._SitesQueue.Defaults.LocatePromptTextPosition = clip('Locate (Position)')
  s_web._SitesQueue.Defaults.LocatePromptTextBegins = clip('Locate (Begins With)')
  s_web._SitesQueue.Defaults.LocatePromptTextContains = clip('Locate (Contains)')
  s_web._SitesQueue.Defaults.scriptsdir = 'scripts'
  s_web._SitesQueue.Defaults.ThemesDir  = 'themes'
  s_web._SitesQueue.Defaults.stylesdir  = 'styles'
  s_web.MakeFolders()
  !s_web._SitesQueue.defaults.AllowAjax = 1
  s_web._SitesQueue.defaults._CheckForParseHeader = 1         ! Check for Parse Header String
  s_web._SitesQueue.defaults._CheckForParseHeaderSize = 1000  ! Check for the Parse Header in the first x bytes
  s_web._SitesQueue.defaults._CheckParseHeader = '<!-- NetWebServer -->'
  s_web._SitesQueue.defaults.securedir = 'secure'
  s_web._SitesQueue.defaults.loggedindir = 'loggedin'
  s_web._SitesQueue.defaults.InsertPromptText = s_web.Translate('Insert')
  s_web._SitesQueue.defaults.CopyPromptText = s_web.Translate('Copy')
  s_web._SitesQueue.defaults.ChangePromptText = s_web.Translate('Change')
  s_web._SitesQueue.defaults.ViewPromptText   = s_web.Translate('View')
  s_web._SitesQueue.defaults.DeletePromptText = s_web.Translate('Delete')
  s_web._SitesQueue.defaults.RequiredText = s_web.Translate('Required')
  s_web._SitesQueue.defaults.NumericText = s_web.Translate('A Number')
  s_web._SitesQueue.defaults.MoreThanText = s_web.Translate('More than or equal to')
  s_web._SitesQueue.defaults.LessThanText = s_web.Translate('Less than or equal to')
  s_web._SitesQueue.defaults.NotZeroText = s_web.Translate('Must not be Zero or Blank')
  s_web._SitesQueue.defaults.OneOfText = s_web.Translate('Must be one of')
  s_web._SitesQueue.defaults.InListText = s_web.Translate('Must be one of')
  s_web._SitesQueue.defaults.InFileText = s_web.Translate('Must be in table')
  s_web._SitesQueue.defaults.DuplicateText = s_web.Translate('Creates Duplicate Record on')
  s_web._SitesQueue.defaults.RestrictText = s_web.Translate('Unable to Delete, Child records exist in table')
  s_web._SitesQueue.Defaults.StoreDataAs = net:StoreAsUTF8
  s_web._SitesQueue.Defaults.DatePicture = '@D6'
  s_web._SitesQueue.Defaults.PageHeaderTag = '<!-- Net:PageHeaderTag -->'
  s_web._SitesQueue.Defaults.PageFooterTag = '<!-- Net:PageFooterTag -->'
  s_web._SitesQueue.Defaults.ContentBody = 'contentbody' ! want a fixed name for ntWidth function.
  s_web._SitesQueue.Defaults.ContentBodyDivClass = 'nt-contentpanel'
  s_web._SitesQueue.Defaults.WebFormStyle = Net:Web:Tab
  s_web._SitesQueue.Defaults.DefaultDoubleClick = 3
  s_web._SitesQueue.Defaults.DefaultExport = 0
  s_web._SitesQueue.Defaults.DefaultDeletePrompt = 1
  s_web._SitesQueue.Defaults.DefaultCancelPrompt = 1
  s_web._SitesQueue.Defaults.Style.FormDiv = ' nt-width-100'
  s_web._SitesQueue.Defaults.Style.FormHeading = 'nt-header nt-form-header'
  s_web._SitesQueue.Defaults.Style.FormSubHeading = 'nt-header nt-form-header-sub'
  s_web._SitesQueue.Defaults.Style.FormTable = 'nt-form-table'
  s_web._SitesQueue.Defaults.Style.FormTableRow = 'nt-form-table-row'
  s_web._SitesQueue.Defaults.Style.FormTableCell = 'nt-form-table-cell'
  s_web._SitesQueue.Defaults.Style.FormGrid = 'nt-form-grid'
  s_web._SitesQueue.Defaults.Style.FormGridRow = 'nt-form-grid-row'
  s_web._SitesQueue.Defaults.Style.FormGridCell = 'nt-form-grid-cell'
  s_web._SitesQueue.Defaults.Style.FormPrompt = 'nt-form-div nt-prompt nt-formcell'
  s_web._SitesQueue.Defaults.Style.FormEntryDiv = 'nt-form-div nt-value nt-formcell'
  s_web._SitesQueue.Defaults.Style.FormButtonDiv = 'nt-form-div nt-formcell nt-left'
  s_web._SitesQueue.Defaults.Style.FormEntry = 'nt-entry ui-corner-all'
  s_web._SitesQueue.Defaults.Style.FormSelect = ' nt-select'
  s_web._SitesQueue.Defaults.Style.FormEntryRequired = 'nt-entry-required'
  s_web._SitesQueue.Defaults.Style.FormEntryReadonly = 'nt-entry-readonly'
  s_web._SitesQueue.Defaults.Style.FormEntryError = 'nt-entry-error'
  s_web._SitesQueue.Defaults.Style.FormComment = 'nt-form-div nt-comment nt-formcell'
  s_web._SitesQueue.Defaults.Style.FormCommentError = 'nt-comment-error ui-state-error ui-corner-all'
  s_web._SitesQueue.Defaults.Style.FormTabOuter = 'nt-tab-outer'
  s_web._SitesQueue.Defaults.Style.FormTabTitle = 'nt-tab-title'
  s_web._SitesQueue.Defaults.Style.FormSaveButtonSet = ''
  s_web._SitesQueue.Defaults.Style.ChildGrid = 'nt-child-grid'
  s_web._SitesQueue.Defaults.Style.ChildGridRow = 'nt-child-grid-row'
  s_web._SitesQueue.Defaults.Style.ChildGridCell = 'nt-child-grid-cell'
  s_web._SitesQueue.Defaults.Style.CalDiv = ''
  s_web._SitesQueue.Defaults.Style.MonthSet = 'nt-month-set'
  s_web._SitesQueue.Defaults.Style.Month = 'nt-month-big ui-widget-content ui-corner-all'
  s_web._SitesQueue.Defaults.Style.MonthSmall = 'nt-month-small ui-widget-content ui-corner-all'
  s_web._SitesQueue.Defaults.Style.MonthHeader = 'ui-widget-header ui-corner-top nt-month-header'
  s_web._SitesQueue.Defaults.Style.MonthHeading = 'nt-heading'
  s_web._SitesQueue.Defaults.Style.MonthHeaderCell = 'nt-month-header-cell nt-wide'
  s_web._SitesQueue.Defaults.Style.MonthEmptyDayCell = 'nt-monthday-empty-cell'
  s_web._SitesQueue.Defaults.Style.MonthDayCell = 'nt-monthday-cell ui-corner-all'
  s_web._SitesQueue.Defaults.Style.MonthContentCell = 'nt-content'
  s_web._SitesQueue.Defaults.Style.MonthLabelCell = 'nt-label'
  s_web._SitesQueue.Defaults.Style.MonthEmptyLabelCell = 'nt-label-empty'
  s_web._SitesQueue.Defaults.Style.MonthContentCellSmall = 'nt-hidden'
  s_web._SitesQueue.Defaults.Style.MonthLabelCellSmall = 'nt-label-small'
  s_web._SitesQueue.Defaults.Style.MonthEmptyLabelCellSmall = 'nt-label-empty-small'
  s_web._SitesQueue.Defaults.Style.FormTabInner = 'nt-tab-inner'
  s_web._SitesQueue.Defaults.Style.BrowseDiv = 'nt-browse'
  s_web._SitesQueue.Defaults.Style.BrowseGrid = 'nt-browse-grid'
  s_web._SitesQueue.Defaults.Style.BrowseGridRow = 'nt-browse-grid-row'
  s_web._SitesQueue.Defaults.Style.BrowseGridDeletedRow = 'nt-browse-grid-row-deleted'
  s_web._SitesQueue.Defaults.Style.BrowseGridCell = 'nt-browse-grid-cell'
  s_web._SitesQueue.Defaults.Style.BrowseTable = 'nt-browse-table ui-widget-content ui-corner-all'
  s_web._SitesQueue.Defaults.Style.BrowseTableDiv = 'ui-widget'
  s_web._SitesQueue.Defaults.Style.BrowseHeader = 'ui-widget-header nt-browse-table-header'
  s_web._SitesQueue.Defaults.Style.BrowseBody = 'nt-browse-table-body'
  s_web._SitesQueue.Defaults.Style.BrowseTableRow = 'nt-browse-table-row'  ! was .BrowseRow
  s_web._SitesQueue.Defaults.Style.BrowseTableDeletedRow = 'nt-browse-table-row-deleted'
  s_web._SitesQueue.Defaults.Style.BrowseFoot = 'nt-browse-table-foot'
  s_web._SitesQueue.Defaults.Style.BrowseFooter = ' nt-browse-table-footer'
  s_web._SitesQueue.Defaults.Style.BrowseFooterEmpty = ' nt-browse-table-footer-empty'
  s_web._SitesQueue.Defaults.Style.BrowseHeading = 'nt-header nt-browse-header'
  s_web._SitesQueue.Defaults.Style.BrowseSubHeading = 'nt-header nt-browse-header-sub'
  s_web._SitesQueue.Defaults.Style.BrowseLocator = 'nt-locator'
  s_web._SitesQueue.Defaults.Style.BrowseLocateButtonSet = ''
  s_web._SitesQueue.Defaults.Style.BrowseNavButtonSet = ''
  s_web._SitesQueue.Defaults.Style.BrowseUpdateButtonSet = ''
  s_web._SitesQueue.Defaults.Style.BrowseSelectButtonSet = ''
  s_web._SitesQueue.Defaults.Style.BrowseHyperLinks = ''
  s_web._SitesQueue.Defaults.Style.BrowseEmpty = ''
  s_web._SitesQueue.Defaults.Style.BrowseEntry = 'nt-browse-entry'
  s_web._SitesQueue.Defaults.Style.BrowseText = 'nt-browse-entry'
  s_web._SitesQueue.Defaults.Style.BrowseDate = 'nt-browse-entry'
  s_web._SitesQueue.Defaults.Style.BrowseDrop = 'nt-browse-entry'
  s_web._SitesQueue.Defaults.Style.BrowseDropOption = 'nt-browse-entry'
  s_web._SitesQueue.Defaults.Style.BrowseCheck = 'nt-browse-entry'
  s_web._SitesQueue.Defaults.Style.BrowseOtherButtonWithText = ''
  s_web._SitesQueue.Defaults.Style.BrowseOtherButtonWithoutText = ''
  s_web._SitesQueue.Defaults.Style.FormOtherButtonWithText = ''
  s_web._SitesQueue.Defaults.Style.FormOtherButtonWithoutText = ''
  s_web._SitesQueue.Defaults.HtmlClass = 'nt-html'
  s_web._SitesQueue.Defaults.BodyClass = 'nt-body'
  s_web._SitesQueue.Defaults.BodyDivClass = 'nt-body-div'
  s_web._SitesQueue.Defaults.BusyClass = 'nt-busy'
  s_web._SitesQueue.Defaults.BusyImage = '/images/_busy.gif'
  s_web._SitesQueue.Defaults.MessageClass = 'nt-width-50 nt-alert ui-state-error ui-corner-all'
  s_web._SitesQueue.Defaults.MapProvider = Net:MapQuestOpen:OSM
  s_web._SitesQueue.Defaults.MapDefaultMarker = ''
  s_web._SitesQueue.Defaults.DefaultHTMLEditor = net:HTMLRedactor
  s_web._SitesQueue.Defaults.UploadButton.Name = 'upload_btn'
  s_web._SitesQueue.Defaults.UploadButton.TextValue = clip('Upload') !s_web.Translate('Upload',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.UploadButton.Class = ''
  s_web._SitesQueue.Defaults.UploadButton.ToolTip = clip('Click here to Upload the file') !s_web.Translate('Click here to Upload the file')
  s_web._SitesQueue.Defaults.UploadButton.JsIcon = ''
  s_web._SitesQueue.Defaults.LookupButton.Name = 'lookup_btn'
  s_web._SitesQueue.Defaults.LookupButton.TextValue = clip('') !s_web.Translate('',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.LookupButton.Class = 'nt-lookup-button nt-small-button'
  s_web._SitesQueue.Defaults.LookupButton.ToolTip = clip('Click here to Search for a value') !s_web.Translate('Click here to Search for a value')
  s_web._SitesQueue.Defaults.LookupButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.LookupButton.JsIcon = 'help'
  s_web._SitesQueue.Defaults.LookupButton.PopupHeader = 'Lookup'
  s_web._SitesQueue.Defaults.SaveButton.Name = 'save_btn'
  s_web._SitesQueue.Defaults.SaveButton.TextValue = clip('Save') !s_web.Translate('Save',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.SaveButton.Class = 'nt-save-button'
  s_web._SitesQueue.Defaults.SaveButton.ToolTip = clip('Click on this to Save the form') !s_web.Translate('Click on this to Save the form')
  s_web._SitesQueue.Defaults.SaveButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.SaveButton.JsIcon = 'check'
  s_web._SitesQueue.Defaults.CancelButton.Name = 'cancel_btn'
  s_web._SitesQueue.Defaults.CancelButton.TextValue = clip('Cancel') !s_web.Translate('Cancel',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.CancelButton.Class = 'nt-cancel-button'
  s_web._SitesQueue.Defaults.CancelButton.ToolTip = clip('Click on this to Cancel the form') !s_web.Translate('Click on this to Cancel the form')
  s_web._SitesQueue.Defaults.CancelButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.CancelButton.JsIcon = 'cancel'
  s_web._SitesQueue.Defaults.DeletefButton.Name = 'deletef_btn'
  s_web._SitesQueue.Defaults.DeletefButton.TextValue = clip('Delete') !s_web.Translate('Delete',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.DeletefButton.Class = 'nt-deletef-button'
  s_web._SitesQueue.Defaults.DeletefButton.ToolTip = clip('Click here to Delete this record') !s_web.Translate('Click here to Delete this record')
  s_web._SitesQueue.Defaults.DeletefButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.DeletefButton.JsIcon = 'trash'
  s_web._SitesQueue.Defaults.CloseButton.Name = 'close_btn'
  s_web._SitesQueue.Defaults.CloseButton.TextValue = clip('Close') !s_web.Translate('Close',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.CloseButton.Class = 'nt-close-button'
  s_web._SitesQueue.Defaults.CloseButton.ToolTip = clip('Click here to Close this form') !s_web.Translate('Click here to Close this form')
  s_web._SitesQueue.Defaults.CloseButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.CloseButton.JsIcon = 'check'
  s_web._SitesQueue.Defaults.InsertButton.Name = 'insert_btn'
  s_web._SitesQueue.Defaults.InsertButton.TextValue = clip('Insert') !s_web.Translate('Insert',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.InsertButton.Class = 'nt-insert-button'
  s_web._SitesQueue.Defaults.InsertButton.ToolTip = clip('Click here to Insert a new record') !s_web.Translate('Click here to Insert a new record')
  s_web._SitesQueue.Defaults.InsertButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.InsertButton.JsIcon = 'plus'
  s_web._SitesQueue.Defaults.InsertButton.PopupHeader = 'Insert'
  s_web._SitesQueue.Defaults.ChangeButton.Name = 'change_btn'
  s_web._SitesQueue.Defaults.ChangeButton.TextValue = clip('Change') !s_web.Translate('Change',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.ChangeButton.Class = 'nt-change-button'
  s_web._SitesQueue.Defaults.ChangeButton.ToolTip = clip('Click here to Change the highlighted record') !s_web.Translate('Click here to Change the highlighted record')
  s_web._SitesQueue.Defaults.ChangeButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.ChangeButton.JsIcon = 'pencil'
  s_web._SitesQueue.Defaults.ChangeButton.PopupHeader = 'Change'
  s_web._SitesQueue.Defaults.ViewButton.Name = 'view_btn'
  s_web._SitesQueue.Defaults.ViewButton.TextValue = clip('View') !s_web.Translate('View',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.ViewButton.Class = 'nt-view-button'
  s_web._SitesQueue.Defaults.ViewButton.ToolTip = clip('Click here to view details of the highlighted record') !s_web.Translate('Click here to view details of the highlighted record')
  s_web._SitesQueue.Defaults.ViewButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.ViewButton.JsIcon = 'minus'
  s_web._SitesQueue.Defaults.ViewButton.PopupHeader = 'View'
  s_web._SitesQueue.Defaults.DeletebButton.Name = 'deleteb_btn'
  s_web._SitesQueue.Defaults.DeletebButton.TextValue = clip('Delete') !s_web.Translate('Delete',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.DeletebButton.Class = 'nt-deleteb-button'
  s_web._SitesQueue.Defaults.DeletebButton.ToolTip = clip('Click here to Delete the highlighted record') !s_web.Translate('Click here to Delete the highlighted record')
  s_web._SitesQueue.Defaults.DeletebButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.DeletebButton.JsIcon = 'trash'
  s_web._SitesQueue.Defaults.DeletebButton.PopupHeader = 'Delete'
  s_web._SitesQueue.Defaults.SelectButton.Name = 'select_btn'
  s_web._SitesQueue.Defaults.SelectButton.TextValue = clip('Select') !s_web.Translate('Select',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.SelectButton.Class = 'nt-select-button'
  s_web._SitesQueue.Defaults.SelectButton.ToolTip = clip('Click here to Select the highlighted record') !s_web.Translate('Click here to Select the highlighted record')
  s_web._SitesQueue.Defaults.SelectButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.SelectButton.JsIcon = 'check'
  s_web._SitesQueue.Defaults.BrowseCancelButton.Name = 'browsecancel_btn'
  s_web._SitesQueue.Defaults.BrowseCancelButton.TextValue = clip('Cancel') !s_web.Translate('Cancel',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.BrowseCancelButton.Class = 'nt-cancel-button'
  s_web._SitesQueue.Defaults.BrowseCancelButton.ToolTip = clip('Click here to return without selecting anything') !s_web.Translate('Click here to return without selecting anything')
  s_web._SitesQueue.Defaults.BrowseCancelButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.BrowseCancelButton.JsIcon = 'cancel'
  s_web._SitesQueue.Defaults.BrowseCloseButton.Name = 'browseclose_btn'
  s_web._SitesQueue.Defaults.BrowseCloseButton.TextValue = clip('Close') !s_web.Translate('Close',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.BrowseCloseButton.Class = 'nt-close-button'
  s_web._SitesQueue.Defaults.BrowseCloseButton.ToolTip = clip('Click here to Close this browse') !s_web.Translate('Click here to Close this browse')
  s_web._SitesQueue.Defaults.BrowseCloseButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.BrowseCloseButton.JsIcon = 'check'
  s_web._SitesQueue.Defaults.SmallInsertButton.Name = 'insert_btn'
  s_web._SitesQueue.Defaults.SmallInsertButton.TextValue = clip('') !s_web.Translate('',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.SmallInsertButton.Class = 'nt-insert-button nt-small-button'
  s_web._SitesQueue.Defaults.SmallInsertButton.ToolTip = clip('Click here to Insert a new record') !s_web.Translate('Click here to Insert a new record')
  s_web._SitesQueue.Defaults.SmallInsertButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.SmallInsertButton.JsIcon = 'plus'
  s_web._SitesQueue.Defaults.SmallInsertButton.PopupHeader = 'Insert'
  s_web._SitesQueue.Defaults.SmallChangeButton.Name = 'change_btn'
  s_web._SitesQueue.Defaults.SmallChangeButton.TextValue = clip('') !s_web.Translate('',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.SmallChangeButton.Class = 'nt-change-button nt-small-button'
  s_web._SitesQueue.Defaults.SmallChangeButton.ToolTip = clip('Click here to Change this record') !s_web.Translate('Click here to Change this record')
  s_web._SitesQueue.Defaults.SmallChangeButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.SmallChangeButton.JsIcon = 'pencil'
  s_web._SitesQueue.Defaults.SmallChangeButton.PopupHeader = 'Change'
  s_web._SitesQueue.Defaults.SmallViewButton.Name = 'view_btn'
  s_web._SitesQueue.Defaults.SmallViewButton.TextValue = clip('') !s_web.Translate('',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.SmallViewButton.Class = 'nt-view-button nt-small-button'
  s_web._SitesQueue.Defaults.SmallViewButton.ToolTip = clip('Click here to View details of this record') !s_web.Translate('Click here to View details of this record')
  s_web._SitesQueue.Defaults.SmallViewButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.SmallViewButton.JsIcon = 'zoomin'
  s_web._SitesQueue.Defaults.SmallViewButton.PopupHeader = 'View'
  s_web._SitesQueue.Defaults.SmallDeleteButton.Name = 'deleteb_btn'
  s_web._SitesQueue.Defaults.SmallDeleteButton.TextValue = clip('') !s_web.Translate('',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.SmallDeleteButton.Class = 'nt-deleteb-button nt-small-button'
  s_web._SitesQueue.Defaults.SmallDeleteButton.ToolTip = clip('Click here to Delete this record') !s_web.Translate('Click here to Delete this record')
  s_web._SitesQueue.Defaults.SmallDeleteButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.SmallDeleteButton.JsIcon = 'trash'
  s_web._SitesQueue.Defaults.SmallDeleteButton.PopupHeader = 'Delete'
  s_web._SitesQueue.Defaults.SmallSelectButton.Name = 'select_btn'
  s_web._SitesQueue.Defaults.SmallSelectButton.TextValue = clip('') !s_web.Translate('',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.SmallSelectButton.Class = 'nt-select-button nt-small-button'
  s_web._SitesQueue.Defaults.SmallSelectButton.ToolTip = clip('Click here to Select this record') !s_web.Translate('Click here to Select this record')
  s_web._SitesQueue.Defaults.SmallSelectButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.SmallSelectButton.JsIcon = 'check'
  s_web._SitesQueue.Defaults.LocateButton.Name = 'locate_btn'
  s_web._SitesQueue.Defaults.LocateButton.TextValue = clip('Search') !s_web.Translate('Search',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.LocateButton.Class = 'nt-locate-button'
  s_web._SitesQueue.Defaults.LocateButton.ToolTip = clip('Click here to start the Search') !s_web.Translate('Click here to start the Search')
  s_web._SitesQueue.Defaults.LocateButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.LocateButton.JsIcon = 'lightbulb'
  s_web._SitesQueue.Defaults.FirstButton.Name = 'first_btn'
  s_web._SitesQueue.Defaults.FirstButton.TextValue = clip('First') !s_web.Translate('First',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.FirstButton.Class = 'nt-first-button'
  s_web._SitesQueue.Defaults.FirstButton.ToolTip = clip('Click here to go to the First page in the list') !s_web.Translate('Click here to go to the First page in the list')
  s_web._SitesQueue.Defaults.FirstButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.FirstButton.JsIcon = 'arrowthickstop-1-w'
  s_web._SitesQueue.Defaults.PreviousButton.Name = 'previous_btn'
  s_web._SitesQueue.Defaults.PreviousButton.TextValue = clip('Previous') !s_web.Translate('Previous',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.PreviousButton.Class = 'nt-previous-button'
  s_web._SitesQueue.Defaults.PreviousButton.ToolTip = clip('Click here to go to the Previous page in the list') !s_web.Translate('Click here to go to the Previous page in the list')
  s_web._SitesQueue.Defaults.PreviousButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.PreviousButton.JsIcon = 'arrowthick-1-w'
  s_web._SitesQueue.Defaults.NextButton.Name = 'next_btn'
  s_web._SitesQueue.Defaults.NextButton.TextValue = clip('Next') !s_web.Translate('Next',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.NextButton.Class = 'nt-next-button'
  s_web._SitesQueue.Defaults.NextButton.ToolTip = clip('Click here to go to the Next page in the list') !s_web.Translate('Click here to go to the Next page in the list')
  s_web._SitesQueue.Defaults.NextButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.NextButton.JsIcon = 'arrowthick-1-e'
  s_web._SitesQueue.Defaults.LastButton.Name = 'last_btn'
  s_web._SitesQueue.Defaults.LastButton.TextValue = clip('Last') !s_web.Translate('Last',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.LastButton.Class = 'nt-last-button'
  s_web._SitesQueue.Defaults.LastButton.ToolTip = clip('Click here to go to the Last page in the list') !s_web.Translate('Click here to go to the Last page in the list')
  s_web._SitesQueue.Defaults.LastButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.LastButton.JsIcon = 'arrowthickstop-1-e'
  s_web._SitesQueue.Defaults.PrintButton.Name = 'print_btn'
  s_web._SitesQueue.Defaults.PrintButton.TextValue = clip('Print') !s_web.Translate('Print',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.PrintButton.Class = 'nt-print-button'
  s_web._SitesQueue.Defaults.PrintButton.ToolTip = clip('Click here to Print this page') !s_web.Translate('Click here to Print this page')
  s_web._SitesQueue.Defaults.PrintButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.PrintButton.JsIcon = 'print'
  s_web._SitesQueue.Defaults.StartButton.Name = 'start_btn'
  s_web._SitesQueue.Defaults.StartButton.TextValue = clip('Start') !s_web.Translate('Start',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.StartButton.Class = 'nt-start-button'
  s_web._SitesQueue.Defaults.StartButton.ToolTip = clip('Click here to Start the report') !s_web.Translate('Click here to Start the report')
  s_web._SitesQueue.Defaults.StartButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.StartButton.JsIcon = 'check'
  s_web._SitesQueue.Defaults.DateLookupButton.Name = 'lookup_btn'
  s_web._SitesQueue.Defaults.DateLookupButton.TextValue = clip('') !s_web.Translate('',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.DateLookupButton.Class = 'nt-small-button nt-lookup-button'
  s_web._SitesQueue.Defaults.DateLookupButton.ToolTip = clip('Click here to select a date') !s_web.Translate('Click here to select a date')
  s_web._SitesQueue.Defaults.DateLookupButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.DateLookupButton.JsIcon = 'help'
  s_web._SitesQueue.Defaults.WizPreviousButton.Name = 'wizprevious_btn'
  s_web._SitesQueue.Defaults.WizPreviousButton.TextValue = clip('Previous') !s_web.Translate('Previous',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.WizPreviousButton.Class = 'nt-wizprevious-button'
  s_web._SitesQueue.Defaults.WizPreviousButton.ToolTip = clip('Click here to go back to the Previous step') !s_web.Translate('Click here to go back to the Previous step')
  s_web._SitesQueue.Defaults.WizPreviousButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.WizPreviousButton.JsIcon = 'arrowthick-1-w'
  s_web._SitesQueue.Defaults.WizNextButton.Name = 'wiznext_btn'
  s_web._SitesQueue.Defaults.WizNextButton.TextValue = clip('Next') !s_web.Translate('Next',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.WizNextButton.Class = 'nt-wiznext-button'
  s_web._SitesQueue.Defaults.WizNextButton.ToolTip = clip('Click here to go to the Next step') !s_web.Translate('Click here to go to the Next step')
  s_web._SitesQueue.Defaults.WizNextButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.WizNextButton.JsIcon = 'arrowthick-1-e'
  s_web._SitesQueue.Defaults.SmallOtherButton.Name = 'other_btn'
  s_web._SitesQueue.Defaults.SmallOtherButton.TextValue = clip('') !s_web.Translate('',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.SmallOtherButton.Class = 'nt-small-button'
  s_web._SitesQueue.Defaults.SmallOtherButton.ToolTip = clip('') !s_web.Translate('')
  s_web._SitesQueue.Defaults.SmallOtherButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.SmallOtherButton.JsIcon = ''
  s_web._SitesQueue.Defaults.SmallPrintButton.Name = 'print_btn'
  s_web._SitesQueue.Defaults.SmallPrintButton.TextValue = clip('') !s_web.Translate('',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.SmallPrintButton.Class = 'nt-print-button nt-small-button'
  s_web._SitesQueue.Defaults.SmallPrintButton.ToolTip = clip('Click here to print this record') !s_web.Translate('Click here to print this record')
  s_web._SitesQueue.Defaults.SmallPrintButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.SmallPrintButton.JsIcon = 'print'
  s_web._SitesQueue.Defaults.CopyButton.Name = 'copy_btn'
  s_web._SitesQueue.Defaults.CopyButton.TextValue = clip('Copy') !s_web.Translate('Copy',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.CopyButton.Class = 'nt-copy-button'
  s_web._SitesQueue.Defaults.CopyButton.ToolTip = clip('Click here to copy the highlighted record') !s_web.Translate('Click here to copy the highlighted record')
  s_web._SitesQueue.Defaults.CopyButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.CopyButton.JsIcon = 'copy'
  s_web._SitesQueue.Defaults.CopyButton.PopupHeader = 'Copy'
  s_web._SitesQueue.Defaults.SmallCopyButton.Name = 'copy_btn'
  s_web._SitesQueue.Defaults.SmallCopyButton.TextValue = clip('') !s_web.Translate('',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.SmallCopyButton.Class = 'nt-copy-button nt-small-button'
  s_web._SitesQueue.Defaults.SmallCopyButton.ToolTip = clip('Click here to copy this record') !s_web.Translate('Click here to copy this record')
  s_web._SitesQueue.Defaults.SmallCopyButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.SmallCopyButton.JsIcon = 'copy'
  s_web._SitesQueue.Defaults.SmallCopyButton.PopupHeader = 'Copy'
  s_web._SitesQueue.Defaults.ClearButton.Name = 'clear_btn'
  s_web._SitesQueue.Defaults.ClearButton.TextValue = clip('Clear') !s_web.Translate('Clear',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.ClearButton.Class = 'nt-clear-button'
  s_web._SitesQueue.Defaults.ClearButton.ToolTip = clip('Click here to clear the locator') !s_web.Translate('Click here to clear the locator')
  s_web._SitesQueue.Defaults.ClearButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.ClearButton.JsIcon = 'arrowrefresh-1-w'
  s_web._SitesQueue.Defaults.LogoutButton.Name = 'logout_btn'
  s_web._SitesQueue.Defaults.LogoutButton.TextValue = clip('Logout') !s_web.Translate('Logout',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.LogoutButton.Class = 'nt-logout-button'
  s_web._SitesQueue.Defaults.LogoutButton.ToolTip = clip('Click here to logout') !s_web.Translate('Click here to logout')
  s_web._SitesQueue.Defaults.LogoutButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.LogoutButton.JsIcon = 'locked'
  s_web._SitesQueue.Defaults.AddFileButton.Name = 'addfile_btn'
  s_web._SitesQueue.Defaults.AddFileButton.TextValue = clip('Add File') !s_web.Translate('Add File',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.AddFileButton.Class = 'nt-insert-button'
  s_web._SitesQueue.Defaults.AddFileButton.ToolTip = clip('Click here to add files') !s_web.Translate('Click here to add files')
  s_web._SitesQueue.Defaults.AddFileButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.AddFileButton.JsIcon = 'plus'
  s_web._SitesQueue.Defaults.ClearFileButton.Name = 'clearfile_btn'
  s_web._SitesQueue.Defaults.ClearFileButton.TextValue = clip('Clear') !s_web.Translate('Clear',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.ClearFileButton.Class = 'nt-deletef-button'
  s_web._SitesQueue.Defaults.ClearFileButton.ToolTip = clip('Click here to clear the file list') !s_web.Translate('Click here to clear the file list')
  s_web._SitesQueue.Defaults.ClearFileButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.ClearFileButton.JsIcon = 'trash'
  s_web._SitesQueue.Defaults.StartFileButton.Name = 'startfile_btn'
  s_web._SitesQueue.Defaults.StartFileButton.TextValue = clip('Start') !s_web.Translate('Start',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.StartFileButton.Class = 'nt-save-button'
  s_web._SitesQueue.Defaults.StartFileButton.ToolTip = clip('Click here to start the upload') !s_web.Translate('Click here to start the upload')
  s_web._SitesQueue.Defaults.StartFileButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.StartFileButton.JsIcon = 'play'
  s_web._SitesQueue.Defaults.CancelFileButton.Name = 'cancelfile_btn'
  s_web._SitesQueue.Defaults.CancelFileButton.TextValue = clip('Cancel') !s_web.Translate('Cancel',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.CancelFileButton.Class = 'nt-cancel-button'
  s_web._SitesQueue.Defaults.CancelFileButton.ToolTip = clip('Click here to cancel the upload') !s_web.Translate('Click here to cancel the upload')
  s_web._SitesQueue.Defaults.CancelFileButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.CancelFileButton.JsIcon = 'cancel'
  s_web._SitesQueue.Defaults.RemoveFileButton.Name = 'removefile_btn'
  s_web._SitesQueue.Defaults.RemoveFileButton.TextValue = clip('Remove') !s_web.Translate('Remove',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.RemoveFileButton.Class = 'nt-deletef-button'
  s_web._SitesQueue.Defaults.RemoveFileButton.ToolTip = clip('Click here to remove this file from the list') !s_web.Translate('Click here to remove this file from the list')
  s_web._SitesQueue.Defaults.RemoveFileButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.RemoveFileButton.JsIcon = 'trash'
  s_web._SitesQueue.Defaults.ExportButton.Name = 'export_btn'
  s_web._SitesQueue.Defaults.ExportButton.TextValue = clip('Export') !s_web.Translate('Export',Net:HtmlOk) ! button text will be cleaned later on.
  s_web._SitesQueue.Defaults.ExportButton.Class = 'nt-export-button'
  s_web._SitesQueue.Defaults.ExportButton.ToolTip = clip('Click here to export the data in this browse') !s_web.Translate('Click here to export the data in this browse')
  s_web._SitesQueue.Defaults.ExportButton.UseJavaScript = 1
  s_web._SitesQueue.Defaults.ExportButton.JsIcon = 'arrowreturnthick-1-e'
  s_web._SitesQueue.Defaults.PreCompressed = 1
  s_web._SitesQueue.Defaults.CompressStatic = true
  s_web._SitesQueue.Defaults.CompressDynamic = true
  s_web._SitesQueue.Defaults.AutoCheckCache = 1
  s_web._SitesQueue.Defaults.FrontLoaded       = false
  s_web._SitesQueue.Defaults.NoJavaScriptCheck = false
  s_web._SitesQueue.Defaults.NoScreenSizeCheck = false
  s_web._SitesQueue.Defaults.MultiTab = false
  s_web._SitesQueue.Defaults.ReuseConnections  = 0 ! true
  s_web._SitesQueue.Defaults.PinchToZoom  = false
  s_web._SitesQueue.Defaults.themeColor  = 'white'
  IF(1)
    s_web._SitesQueue.Defaults.HtmlCommonScripts = |
      s_web.AddScript('all.js') &|
      s_web.AddScript('/redactor/redactor.min.js') &|
      ''
  Else
    s_web._SitesQueue.Defaults.HtmlCommonScripts = |
      s_web.AddScript('modernizr.custom.js') &|
      s_web.AddScript('jquery-1.12.4.min.js') &|
      s_web.AddScript('jquery-ui-1.12.1.custom.min.js') &|
      s_web.AddScript('jquery.corners.js') &|
      s_web.AddScript('jquery.form.js') &|
      s_web.AddScript('jquery.nt-form.js') &|
      s_web.AddScript('jquery.nt-menu.js') &|
      s_web.AddScript('jquery.nt-wiz.js') &|
      s_web.AddScript('jquery.metadata.js') &|
      s_web.AddScript('jquery.nt-color.js') &|
      s_web.AddScript('jquery.nt-dialog.js') &|
      s_web.AddScript('jquery.media.js') &|
      s_web.AddScript('netweb.js') &|
      s_web.AddScript('jquery.nt-browse.js') &|
      s_web.AddScript('jcanvas.js') &|
      s_web.AddScript('jquery.nt-cal.js') &|
      s_web.AddScript('jquery.ad-gallery.js') &|
      s_web.AddScript('jquery.iframe-transport.js') &|
      s_web.AddScript('jquery.fileupload.js') &|
      s_web.AddScript('jquery.nt-upload.js') &|
      s_web.AddScript('/redactor/redactor.min.js') &|
    ''
  End
  s_web._SitesQueue.Defaults.HtmlMSIE6Scripts = |
    s_web.AddScript('msie6.js') &|
  ''
  s_web._SitesQueue.Defaults.DefaultTheme = 'Sunny'
  
  IF(1)
    s_web._SitesQueue.Defaults.HtmlCommonStyles = |
      s_web.AddManifest() &|
      s_web.AddStyle(clip('Sunny') & '/theme.css',true) &|
      s_web.AddStyle('/redactor/redactor.min.css') &|
      ''
  Else
    s_web._SitesQueue.Defaults.HtmlCommonStyles = |
      s_web.AddManifest() &|
      s_web.AddStyle('jquery-ui.structure.css') &|
      s_web.AddStyle(clip('Sunny') & '/jquery-ui.theme.css',true) & |
      s_web.AddStyle('jquery-nt-color.css') &|
      s_web.AddStyle('jquery-nt-menu.css') &|
      s_web.AddStyle('jquery-nt-cal.css') &|
      s_web.AddStyle('jquery.ad-gallery.css') &|
      s_web.AddStyle('jquery.fileupload-ui.css') &|
      s_web.AddStyle('netweb.css') &|
      s_web.AddStyle('/redactor/redactor.min.css') &|
      s_web.AddStyle('nettalk-grid.css') &|
      s_web.AddStyle(clip('Sunny') & '/nettalk-ui.css',true) & |
      s_web.AddStyle('Custom.Css') &|
      s_web.AddStyle(clip('Sunny') & '/' & clip('CustomT.Css'),true) & |
    ''
  End
  
  s_web._SitesQueue.Defaults.HtmlMSIE6Styles = |
    s_web.AddStyle('msie6.css') &|
    ''
  
  s_web._SitesQueue.Defaults.HtmlMSIE7Styles = |
    s_web.AddStyle('msie7.css') &|
    ''
  
  s_web._SitesQueue.Defaults.HtmlMSIE8Styles = |
    s_web.AddStyle('msie.css') &|
    ''
  
  s_web._SitesQueue.Defaults.HtmlMSIE9Styles = |
    s_web.AddStyle('msie.css') &|
    ''
  
  s_web._SitesQueue.Defaults.HtmlMSIE10Styles = |
    s_web.AddStyle('msie.css') &|
    ''
  s_web._SitesQueue.Defaults.HtmlMSIE11Styles = |
    s_web.AddStyle('msie.css') &|
    ''
  
  s_web._SitesQueue.Defaults.HtmlEdgeStyles = |
    s_web.AddStyle('edge.css') &|
    ''
  
  s_web._SitesQueue.Defaults.HtmlFireFoxStyles = |
    s_web.AddStyle('firefox.css') &|
    ''
  
  s_web._SitesQueue.Defaults.HtmlSafariStyles = |
    s_web.AddStyle('safari.css') &|
    ''
  
  s_web._SitesQueue.Defaults.HtmlChromeStyles = |
    s_web.AddStyle('chrome.css') &|
    ''
  
  s_web._SitesQueue.Defaults.HtmlOperaStyles = |
    s_web.AddStyle('opera.css') &|
    ''
  
  s_web._SitesQueue.Defaults.HtmlMozillaStyles = |
    s_web.AddStyle('firefox.css') &|
    ''
  
  Put(s_web._SitesQueue)
  If Net:ShortInit
    ReturnValue = Level:Notify
    Return ReturnValue
  End
  ServerStateName.SetValue(ServerStateName.FileNameOnly(command(0),false) &'.State.Xml')
  ServerStateXML.Load(ThisWebServer._SessionQueue,ServerStateName.GetValue(),'SessionQueue','row')
  ServerStateXML.Load(ThisWebServer._SessionDataQueue,ServerStateName.GetValue(),'SessionDataQueue','row')
  ServerStateXML.Load(ThisWebServer._BrowseIDQueue,ServerStateName.GetValue(),'BrowseIDQueue','row')
  ServerStateXML.Load(ThisWebServer._SettingsQueue,ServerStateName.GetValue(),'SettingsQueue','row')
  ServerStateXML.Load(ThisWebServer._BrowseSettingsQueue,ServerStateName.GetValue(),'BrowseSettingsQueue','row')
  ServerStateXML.Load(ThisWebServer._ChannelQueue,ServerStateName.GetValue(),'ChannelQueue','row')
  ServerStateXML.Load(ThisWebServer._ChannelNameQueue,ServerStateName.GetValue(),'ChannelNameQueue','row')
  
  !--------------------------------------------------------------
  if ThisWebServer.error <> 0
    ! Put code in here to handle if the object does not initialise properly
  end
  Do DefineListboxStyle
  ThisWebServer.acme.LogControl = ?LogText
  ThisWebServer.acme.Staging = set:Staging
  !ProcedureTemplate = Window
  INIMgr.Fetch('WebServer',Window)                         ! Restore window settings from non-volatile store
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
    ServerStateXML.RootBoundary = 'NetTalkWebServerState'
    ServerStateXML.DontSaveBlanks = true
    ServerStateXML.DontCloseTags = true
    ServerStateXML.Append = false
    ServerStateXML.Save(ThisWebServer._SessionQueue,ServerStateName.GetValue(),'SessionQueue','row')
    ServerStateXML.Append = true
    ServerStateXML.Save(ThisWebServer._SessionDataQueue,ServerStateName.GetValue(),'SessionDataQueue','row')
    ServerStateXML.Save(ThisWebServer._BrowseIDQueue,ServerStateName.GetValue(),'BrowseIDQueue','row')
    ServerStateXML.Save(ThisWebServer._SettingsQueue,ServerStateName.GetValue(),'SettingsQueue','row')
    ServerStateXML.Save(ThisWebServer._ChannelQueue,ServerStateName.GetValue(),'ChannelQueue','row')
    ServerStateXML.Save(ThisWebServer._ChannelNameQueue,ServerStateName.GetValue(),'ChannelNameQueue','row')
    ServerStateXML.DontCloseTags = false
    ServerStateXML.Save(ThisWebServer._BrowseSettingsQueue,ServerStateName.GetValue(),'BrowseSettingsQueue','row')
  ThisWebServer.Kill()                              ! Generated by NetTalk Extension
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.Opened
    INIMgr.Update('WebServer',Window)                      ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.TakeEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receives all events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
    ThisWebServer.TakeEvent()                 ! Generated by NetTalk Extension
  ReturnValue = PARENT.TakeEvent()
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWebServer.AddLog PROCEDURE(FILE p_File,*String p_Field,*String p_Name,String p_DataString,<String p_ip>)

  !-----------------------------------------------------------------------------
  ! This method is called from AddLog PROCEDURE(String p_Data,<string p_ip>) to save to a disk file
  !-----------------------------------------------------------------------------

  CODE
  PARENT.AddLog(p_File,p_Field,p_Name,p_DataString,p_ip)


ThisWebServer.AddLog PROCEDURE(String p_Data,<string p_ip>)

  !-----------------------------------------------------------------------------
  ! This method is called before the request has been processed.
  ! Code to add to the on-screen log is added here. If logging to disk the call is made from here.
  ! For POSTs this method is called twice, once with the header and once with the whole request.
  !-----------------------------------------------------------------------------

  CODE
    self._wait()
    !! Log To Screen
    If web:EnableLogging > 0
      clear(LogQueue)
      if not omitted(p_ip)
        LogQueue.Port = p_ip
      else
        LogQueue.Port = Self.Port
      end
      LogQueue.Date = today()
      LogQueue.Time = clock()
      LogQueue.Socket = self.packet.SockID
      LogQueue.Thread = 0
      LogQueue.Desc = p_Data
      Add(LogQueue,1)
      Loop While Records(LogQueue) > 500
        Get(LogQueue,501)
        Delete(LogQueue)
      End
    End
    self._release()
  PARENT.AddLog(p_Data,p_ip)


ThisWebServer.StartNewThread PROCEDURE(NetWebServerRequestDataType p_RequestData)

!loc:RequestData    Group(NetWebServerRequestDataType).
!loc:OverString     String(size(loc:RequestData)),over(loc:RequestData)
StartNewPool   Long
PoolWaiting    Long
Index          Long

  CODE
    loc:RequestData :=: p_RequestData
    If (self.performance.NumberOfThreads >= self.MaxThreads and self.MaxThreads > 0) or loc:shuttingDown
      if loc:RequestData.RequestMethodType <> NetWebServer_DELETESESSION and PoolWaiting = 0
        self.SendError(500,'Server Busy','Server Busy, try again shortly')
        self._PerfEndThread(0,0,500)  ! Errors are counted, but otherwise not included in stats
        do UpdateStats
        dispose(p_RequestData.DataString)
      end
      return
    End
    web:PagesServed = self._PagesServed + 1
    if p_RequestData.DataStringLen >= 4
      case (upper(p_RequestData.DataString[1 : 4]))
      of 'POST'
        web:LastPost = p_RequestData.DataString[1 : p_RequestData.DataStringLen]
        display (?web:LastPost)
      of 'GET '
        web:LastGet = p_RequestData.DataString[1 : p_RequestData.DataStringLen]
        display (?web:LastGet)
      else
        web:LastGet = p_RequestData.DataString[1 : p_RequestData.DataStringLen]
        display (?web:LastGet)
      end
    end
    self._PerfStartThread()
    self.NewThread = START (WebHandler, 35000, loc:OverString)
    RESUME(self.NewThread)
    do UpdateStats
      !! log thread number to screen
      Get(LogQueue,1)
      LogQueue.Thread = self.NewThread
      Put(LogQueue)
    RETURN ! Don't call parent
  PARENT.StartNewThread(p_RequestData)


ThisWebServer.TakeEvent PROCEDURE


  CODE
    Case Event()
    of Event:Accepted
      Case Field()
      of ?ClearStatsButton
        Clear(s_web.performance)
        s_web.Performance.StartDate = Today()
        s_web.Performance.StartTime = Clock()
      of ?RefreshCacheButton
        s_web.ServerMemory.FreeCached()
      of ?UnBanButton
        Get(BannedQueue,choice(?BannedList))
        s_web.UnBan(BannedQueue.IPAddress)
        do PopulateBannedQueue
      End
    End
    WebPerformance = s_web.Performance ! performance monitoring control template
    case Event()
    of Event:Accepted
      case Field()
      of ?Clear
        Free(LogQueue)
        web:LastGet = ''
        web:LastPost = ''
        display()
      of ?Ban
        Get(LogQueue,choice(?LogQueue))
        s_web.Ban(LogQ:Port)
        do PopulateBannedQueue
      End
    End
    case Event()
    of Event:Accepted
      case Field()
      of ?set:InsecurePort          orof ?set:SecurePort    orof ?set:AccountName
      orof ?set:CertificatesFolder  orof ?set:Domains       orof ?set:BindToIPAddress
      orof ?set:WebFolder           orof ?set:AcmeFolder    orof ?set:Staging
      orof ?set:SessionTimeout      orof ?set:xFrameOptions orof ?set:AccessControlAllowOrigin
      orof ?set:StrictTransportSecurity                     orof ?set:ContentSecurityPolicy
      orof ?set:ContentSecurityPolicyReportOnly             orof ?set:ReferrerPolicy
        do SaveSettings
      End
      case Field()
      of ?set:InsecurePort
      orof ?set:SecurePort
        s_web.SetPorts(set:InsecurePort,set:SecurePort) ! will restart if necessary
      of ?set:AccountName
      of ?set:WebFolder
        get(s_web._SitesQueue,1)
        s_web._SitesQueue.defaults.WebFolderPath = set:WebFolder
        put(s_web._SitesQueue)
      of ?set:CertificatesFolder
        get(s_web._SitesQueue,1)
        s_web._SitesQueue.defaults.CertificatesPath = set:CertificatesFolder
        put(s_web._SitesQueue)
        self.acme.SetFolders()
        s_web.Restart()
      of ?set:AcmeFolder
        get(s_web._SitesQueue,1)
        s_web._SitesQueue.defaults.AcmeFolderPath = set:AcmeFolder
        put(s_web._SitesQueue)
        self.acme.SetFolders()
      of ?set:SessionTimeout
        get(s_web._SitesQueue,1)
        s_web._SitesQueue.defaults.SessionExpiryAfterHS = set:SessionTimeout
        put(s_web._SitesQueue)
      of ?set:Staging
        self.acme.staging = set:staging
        if self.acme.staging = false
          self.acme.DeleteCertificates(set:Domains)
        end
      of ?set:Domains
        self.SetDomains(set:Domains)
      Of ?RestartButton
        s_web.Restart()
      Of ?GetCertificatesButton
        If self.acme.SetAccountName(set:AccountName) = net:ok
          If self.acme.SetDomains(set:Domains) = net:ok
            self.acme.CheckCertificates() ! may call restart server
          End
        End
      Of ?set:BindToIpAddress
        s_web._ServerIP = set:BindToIpAddress
        s_web.Restart()
      Of ?set:xFrameOptions
        get(s_web._SitesQueue,1)
        s_web._SitesQueue.defaults.xFrameOptions = set:xFrameOptions
        put(s_web._SitesQueue)
      Of ?set:AccessControlAllowOrigin
        get(s_web._SitesQueue,1)
        s_web._SitesQueue.defaults.AccessControlAllowOrigin = set:AccessControlAllowOrigin
        put(s_web._SitesQueue)
      Of ?set:StrictTransportSecurity
        get(s_web._SitesQueue,1)
        s_web._SitesQueue.defaults.StrictTransportSecurity = set:StrictTransportSecurity
        put(s_web._SitesQueue)
      Of ?set:ContentSecurityPolicy
        get(s_web._SitesQueue,1)
        s_web._SitesQueue.defaults.ContentSecurityPolicy = set:ContentSecurityPolicy
        put(s_web._SitesQueue)
      Of ?set:ContentSecurityPolicyReportOnly
        get(s_web._SitesQueue,1)
        s_web._SitesQueue.defaults.ContentSecurityPolicyReportOnly = set:ContentSecurityPolicyReportOnly
        put(s_web._SitesQueue)
      Of ?set:ReferrerPolicy
        get(s_web._SitesQueue,1)
        s_web._SitesQueue.defaults.ReferrerPolicy = set:ReferrerPolicy
        put(s_web._SitesQueue)
      End
    End
    If set:LastCertificateCheckDate < today()
      Post(Event:Accepted,?GetCertificatesButton)
      set:LastCertificateCheckDate = today()
      do SaveSettings
    End
    If Event() = Event:Accepted and Field() = ?GracefulCloseButton
      loc:shuttingDown = true
      Window{prop:timer} = 100
      Disable(?GracefulCloseButton)
    End
    If loc:shuttingDown
      ?GracefulCloseButton{prop:text} = 'Waiting:' & wp:NumberOfThreads
      If wp:NumberOfThreads = 0
        Post(event:Accepted,?Close)
        Window{prop:timer} = 0
      End
    End
  PARENT.TakeEvent
    If Field() = ?LogQueue and Event() = Event:NewSelection
      Get(LogQueue,Choice(?LogQueue))
      If ErrorCode() = 0
        Case Upper(Sub(LogQueue.Desc,1,3))
        Of 'POS'
          web:LastPost = LogQueue.Desc
        Of 'GET'
          web:LastGet = LogQueue.Desc
        Else
          web:LastGet = LogQueue.Desc
        End
        Display()
      End
    End

ServerStateXML.SaveCurrentFieldToXML  PROCEDURE (Long p_x,Long p_DimCounter,String p_name)
eString  String(1)
  code
  if lower(p_name) = 'extvalue'
    if ThisWebServer._SessionDataQueue.ExtValue &= Null
      self.currentfield &= eString
    else
      self.currentfield &= ThisWebServer._SessionDataQueue.ExtValue
    end
  end
  Parent.SaveCurrentFieldToXML(p_x,p_DimCounter,p_name)

ServerStateXML.AssignField            PROCEDURE (Long DataStartPos,Long DataEndPos)
  CODE
  if lower(self.CurrentTag) = 'extvalue'
    ThisWebServer._SessionDataQueue.ExtValue &= new string(DataEndPos - DataStartPos + 1)
    self.CurrentField &= ThisWebServer._SessionDataQueue.ExtValue
  end
  Return Parent.AssignField(DataStartPos,DataEndPos)
Browsevendas         PROCEDURE  (NetWebServerWorker p_web)
packet  StringTheory
TableQueue               Queue,pre(TableQueue)
kind                       Long
row                        String(100000)
id                         String(252),dim(Net:MaxKeyFields)
idx                        String(Net:HashSize)
sub                        Long
                         End
ven:TipoVenda:IsInvalid  Long
ven:VendaSap:IsInvalid  Long
ven:Quantidade:IsInvalid  Long
loc:total                decimal(31,15),dim(200)
loc:RowNumber            Long
loc:section              Long
loc:found                Long
loc:DefaultSelection     String(Net:HashSize)
loc:ActualSelection      String(Net:HashSize)
loc:RowsHigh             Long(1)
loc:RowsIn               Long
loc:vordernumber         Long
loc:vorder               String(252)
loc:NavButtonPosition    Long
loc:UpdateButtonPosition Long
loc:FileLoading          Long
loc:Sorting              Long
loc:LayoutMethod         Long
loc:LocatorPosition      Long
loc:LocatorBlank         Long
loc:LocatorType          Long
loc:LocatorCase          Long
loc:LocatorSearchButton  Long
loc:LocatorClearButton   Long
loc:LocatorImmediate     Long
loc:LocatorSuggestions   Long
loc:LocatorAutoCompleteOptions StringTheory ! options for jQuery calls
loc:LocatorValue         String(252)
Loc:FormName             String(252)
Loc:Class                String(252)
Loc:Skip                 Long
loc:ViewOnly             Long
loc:invalid              String(100)
loc:ViewPosWorkaround    String(252)
loc:lookupdone           Long
loc:FormPopup            Long
loc:options              StringTheory ! options for jQuery calls
tempjson                 StringTheory
loc:RandomBrowseId       string(net:RandomIdSize)
loc:FrontLoading         long
loc:Heading              string(1024)
loc:InsertButtonDone     long
loc:ChildRowCounter      long
ThisView            View(vendas)
                      Project(ven:Reg)
                      Project(ven:TipoVenda)
                      Project(ven:VendaSap)
                      Project(ven:Quantidade)
                    END ! of ThisView
!-- drop

loc:formaction        String(252)
loc:formactiontarget  String(252)
loc:SelectAction      String(252)
loc:CancelAction      String(252)
loc:CloseAction       String(252)
loc:extra             String(252)
loc:LiveClick         String(252)
loc:Selecting         Long
loc:rowcount          Long ! counts the total rows printed to screen
loc:pagerows          Long ! the number of rows per page
loc:ReadData          Long(1) ! if set to false, then it won't actually read data from the table. Used for front-loading.
loc:columns           Long
loc:checked           String(10)
loc:direction         Long(2) ! + = forwards, - = backwards
loc:FillBack          Long(1)
loc:field             string(Net:HashSize)
loc:first             Long
loc:FirstValue        String(1024)
loc:LastValue         String(1024)
Loc:LocateField       String(252)
Loc:LocateOnFields    String(252)
Loc:SortHeader        String(252) ! contains the heading text for the sorting column. passed to CreateLocator
Loc:SortDirection     Long(1)
loc:disabled          Long
loc:RowStyle          String(252)
loc:RecordExtra       StringTheory
loc:RecordClicked     StringTheory
loc:MultiRowStyle     String(252)
loc:SelectColumnClass String(252)
loc:x                 Long
loc:y                 Long
loc:InView            Long
loc:RowStarted        Long
loc:nextdisabled      Long
loc:previousdisabled  Long
loc:divname           String(252)
loc:tablename         String(252)
loc:FilterWas         String(4096)
loc:selected          String(252)
loc:parent            String(252)
loc:parentRow         String(252)
loc:IsChange          Long
loc:Silent            Long ! children of this browse should go into Silent mode
loc:ParentSilent      Long ! this browse should go into silent mode (reads value of _silent_ on start).
loc:eip               Long
loc:alert             String(252)
loc:SkipHeader        Long
loc:ViewState         String(1024)
Loc:NoBuffer          Long(1)         ! buffer is causing a problem with sql engines, and resetting the position in the view, so default to off.
Loc:popup             Long
loc:SecwinProcedure   String(255)
loc:ContentBody       Long
loc:inCallPopups      Long
Loc:Stage             Long
loc:TableRefresh      Long
loc:rowclick          string(1024)
loc:CellsCounter      long
loc:CellStarted       long
FilesOpened       Long
FilesErrorOnOpen  StringTheory
  CODE
  GlobalErrors.SetProcedureName('Browsevendas')
  ! loc:parent is the container (form etc) on which this procedure is embedded.
  loc:parent = p_web.PlainText(lower(p_web.GetValue('_parentProc_')))
  loc:RandomBrowseId = p_web.GetValue('_rid_')
  p_web.DeleteValue('_rid_')
  If p_web.site.ContentBody <> '' and lower(p_web.GetValue('_cb_')) = lower('Browsevendas') then loc:ContentBody=1.
  if loc:RandomBrowseId = '' then loc:RandomBrowseId = p_web.Crc32(clip(loc:parent) & ' Browsevendas').
  ! loc:ParentRow contains the parent row id for browses that are embedded in other browses
  loc:ParentRow = lower(p_web.GetValue('_parentRow_'))
  ! loc:divname contains the div for this browse.
  If loc:parent <> '' and loc:ParentRow <> ''
    loc:divname = lower(clip(loc:parent) & '_Browsevendas_' & lower(loc:parentRow))
    p_web.GetBrowseValue(p_web.GetValue('_parentRow_')) ! need to reget, so it's not lowered
  elsif loc:parent <> ''
    loc:divname = lower(clip(loc:parent) & '_Browsevendas')
  else
    loc:divname = lower('Browsevendas')
  end
  ! loc:tablename contains the table id for this browse.
  loc:tablename = clip(loc:divname) & '_tbl'

  case p_web.site.formpopups
  of -1 ; loc:FormPopup = Net:Page
  of 0 ; loc:FormPopup = Net:Popup
  of 1 ; loc:FormPopup = Net:Popup
  End
  loc:ParentSilent = p_web.GetValue('_silent_')
  loc:popup = p_web.GetValue('_popup_')
  if p_web.site.frontloaded and p_web.Ajax and loc:popup = 1
    loc:FrontLoading = true
  end
  do TakeEvent
  GlobalErrors.SetProcedureName()
  Return ! End of Browse

TakeEvent  Routine
  case p_web.Event
  of 'export'
    do ExportTo
  of 'timer'
    do ExportTimer

  of 'clearbrowse'
    loc:stage = Net:Web:ClearBrowse
    do ClearBrowse

  of 'expcon' ! row expanded or contracted
    do ExpCon

  of 'rowclicked'
    loc:stage = Net:Web:RowClicked
    do CallClicked
    loc:found = 1 !! if not set then can result in this browse being declared "silent" when refreshing children in AjaxChildren.
    p_web.PushEvent('parentnewselection')
    do AlertChildren ! propogate event down
    p_web.PopEvent()
    p_web.PushEvent('childnewselection')
    do AlertParent   ! propogate event up
    p_web.PopEvent()

  of 'parentnewselection'
    loc:stage = net:web:GenerateTable + net:web:UpdateNav + net:web:UpdateUpdates + net:web:UpdateHeadings + net:web:GenerateUpdates
    do GenerateBrowse
    p_web.PushEvent('parentnewselection')
    do AlertChildren ! propogate event down
    p_web.PopEvent()

  of 'childupdated'
    p_web.SetValue('_eipclm_','')
    do AlertParent

  of 'eipaccepted'
    if p_web.IfExistsValue('_eipclm_')
      loc:stage = Net:Web:EIPColumn
      loc:found = 1 !! if not set then can result in this browse being declared "silent" when refreshing children in AjaxChildren.
      do CallEIP
      p_web.PushEvent('parentupdated')
      do AlertChildren ! propogate event down
      p_web.PopEvent()
      p_web.PushEvent('childupdated')
      do AlertParent   ! propogate event up
      p_web.PopEvent()
    End

  of 'sortchanged'
    loc:stage = net:web:GenerateTable + net:web:GenerateLocator
    do GenerateBrowse
    p_web.PushEvent('parentnewselection')
    do AlertChildren ! propogate event down
    p_web.PopEvent()
    p_web.PushEvent('childnewselection')
    do AlertParent   ! propogate event up
    p_web.PopEvent()
    p_web.ntBrowse(loc:divname,'locatorFocus')

  of 'locatorchanged'
    loc:stage = net:web:GenerateTable + net:web:UpdateNav
    do GenerateBrowse
    p_web.PushEvent('parentnewselection')
    do AlertChildren ! propogate event down
    p_web.PopEvent()
    p_web.PushEvent('childnewselection')
    do AlertParent   ! propogate event up
    p_web.PopEvent()
    If loc:LocatorType = Net:Position or loc:LocatorType = Net:Date or loc:LocatorType = Net:NoLocator
      p_web.ntBrowse(loc:divname,'serverClearLocator')
    End
    p_web.ntBrowse(loc:divname,'locatorFocus')

  of 'nav'
    loc:stage = net:web:GenerateTable + net:web:UpdateNav
    do GenerateBrowse
    p_web.PushEvent('parentnewselection')
    do AlertChildren ! propogate event down
    p_web.PopEvent()
    p_web.PushEvent('childnewselection')
    do AlertParent   ! propogate event up
    p_web.PopEvent()

  of 'childnewselection'
    do ChildNewSelection
    do AlertParent

  of 'gainfocus'
    if p_web.GetValue('_refresh_') = 'saved'
      loc:found = 1 !! if not set then can result in this browse being declared "silent" when refreshing children in AjaxChildren.
      do CallEip
      p_web.PushEvent('parentupdated')
      do AlertChildren ! propogate event down
      p_web.PopEvent()
      p_web.PushEvent('childupdated')
      do AlertParent   ! propogate event up
      p_web.PopEvent()
    else
      p_web.ntBrowse(loc:divname,'enable')
      do GotFocusBack
    end

  of 'parentupdated'
    loc:stage = net:web:GenerateTable + net:web:UpdateNav + net:web:UpdateUpdates + net:web:UpdateHeadings + net:web:UpdateLocator + net:web:GenerateUpdates
    do GenerateBrowse
    do AlertChildren ! propogate event down

  of 'deleteb'
    do CallEip
    p_web.PushEvent('parentupdated')
    do AlertChildren ! propogate event down
    p_web.PopEvent()
    p_web.PushEvent('childupdated')
    do AlertParent   ! propogate event up
    p_web.PopEvent()

  of 'generate'
  orof ''
    p_web.PushEvent('generate')
    loc:stage = net:web:GenerateWholeBrowse
    do CallBrowse
    do Popups
    p_web.PopEvent()

  of 'callpopups'
    loc:stage = net:web:GenerateWholeBrowse
    do CallPopups

  of 'getsecwinsettings'
    loc:stage = Net:Web:GetSecwinSettings
      p_web.SetValue('Secwin_' & 'Browsevendas' & 'AccessGroupsArray','1')
      p_web.SetValue('Secwin_AccessWindowName','Browsevendas')


  else
  end

ExportTo  Routine
  data
  code
  case lower(p_web.GetValue('_exportto_'))
  of 'excel'
    do ExportToExcel
  end

ExportTimer  ROUTINE
  data
loc:percentage  long
  code
  loc:percentage = p_web.GSV('Export_Browsevendas_PercentageComplete')
  if loc:percentage < 1 then loc:percentage = 1.
  p_web.ntBrowse(loc:divname,'exportProgress',loc:percentage)

ExportToExcel Routine
  data
ExcelExport     xCell
rowNumber       Long
columnNumber    Long
ColumnWidth     Long,dim(1024)
DateColumn      Long,dim(1024)
TimeColumn      Long,dim(1024)
ExpectedRecords Long
CountRecords    Long
Percentage      Long
  code
  ExcelExport.SetWorkSheet('vendas')
  ExcelExport.WithWorkSheet('vendas')
  do OpenFilesB
  If p_web.sqlsync then p_web.SqlWait(p_web.SqlName).
  Open(ThisView)
  ThisView{prop:order} = p_web.GetSessionValue('Browsevendas_CurrentOrder_' & loc:RandomBrowseId)
  ThisView{prop:filter} = p_web.GetSessionValue('Browsevendas_CurrentFilter_' & loc:RandomBrowseId)
  ExpectedRecords = records(vendas)

  Set(ThisView)
  ! styles

  ExcelExport.SetStyle('s151','MainHeader')
  ExcelExport.SetStyleFont('s151','Calibri','Swiss',15,'#1F497D',1)
  ExcelExport.SetStyleInterior('s151','#C5D9F1','Solid')

  ExcelExport.SetStyle('s152','SubHeader')
  ExcelExport.SetStyleFont('s152','Calibri','Swiss',13,'#1F497D',1)
  ExcelExport.SetStyleInterior('s152','#E4EDF8','Solid')
  ExcelExport.SetStyleBorder('s152','Bottom','Continuous',3,'#A7BFDE')

  ExcelExport.SetStyle('s153','ColumnHeader')
  ExcelExport.SetStyleBorder('s153','Bottom','Continuous',3,'#A7BFDE')
  ExcelExport.SetStyleFont('s153','Calibri','Swiss',13,'#1F497D',1)

  ExcelExport.SetStyle('s154','Footer')
  ExcelExport.SetStyleFont('s154','Calibri','Swiss',11,'#008000')
  ExcelExport.SetStyleInterior('s154','#C6EFCE','Solid')


  ! headers
  rowNumber = 1
  ExcelExport.SetRow(rowNumber,'s151',,22)
  ExcelExport.SetCell(rowNumber,1,p_web.translate('Vendas'),'d151')


  rowNumber = 3
  ExcelExport.SetRow(rowNumber,'s153',,22)
  ColumnNumber = 0
  ColumnNumber += 1
  ExcelExport.SetCell(rowNumber,ColumnNumber,'Tipo Venda','s153')
  if Len(Clip('Tipo Venda')) > ColumnWidth[ColumnNumber] then ColumnWidth[ColumnNumber] = Len(Clip('Tipo Venda')).
  If upper(sub('@s11',2,1)) = 'D'
    DateColumn[ColumnNumber] = ExcelExport.AddDatePicture('@s11')
  ElsIf upper(sub('@s11',2,1)) = 'T'
    TimeColumn[ColumnNumber] = ExcelExport.AddTimePicture('@s11')
  End
  ColumnNumber += 1
  ExcelExport.SetCell(rowNumber,ColumnNumber,'Venda Sap','s153')
  if Len(Clip('Venda Sap')) > ColumnWidth[ColumnNumber] then ColumnWidth[ColumnNumber] = Len(Clip('Venda Sap')).
  If upper(sub('@s11',2,1)) = 'D'
    DateColumn[ColumnNumber] = ExcelExport.AddDatePicture('@s11')
  ElsIf upper(sub('@s11',2,1)) = 'T'
    TimeColumn[ColumnNumber] = ExcelExport.AddTimePicture('@s11')
  End
  ColumnNumber += 1
  ExcelExport.SetCell(rowNumber,ColumnNumber,'Quantidade','s153')
  if Len(Clip('Quantidade')) > ColumnWidth[ColumnNumber] then ColumnWidth[ColumnNumber] = Len(Clip('Quantidade')).
  If upper(sub('@n-14',2,1)) = 'D'
    DateColumn[ColumnNumber] = ExcelExport.AddDatePicture('@n-14')
  ElsIf upper(sub('@n-14',2,1)) = 'T'
    TimeColumn[ColumnNumber] = ExcelExport.AddTimePicture('@n-14')
  End
  loc:columns = ColumnNumber

  !rows
  rowNumber = 4
  LOOP
    next(ThisView)
    If ERRORCODE() then break.
    CountRecords += 1
    p_web.noop()
    ColumnNumber = 0
    Percentage = (CountRecords / ExpectedRecords) * 100
    If Percentage > 99 then Percentage = 99.
    p_web.SetSessionValue('Export_Browsevendas_PercentageComplete',percentage)
    ExcelExport.SetRow(rowNumber)
    ColumnNumber += 1
    If DateColumn[ColumnNumber]
      ExcelExport.SetCell(rowNumber,ColumnNumber,p_web.FormatValue(ven:TipoVenda,'@D010-B'),'d' &  DateColumn[ColumnNumber],,'DateTime')
      If 12 > ColumnWidth[ColumnNumber] then ColumnWidth[ColumnNumber] = 12.
    ElsIf TimeColumn[ColumnNumber]
      ExcelExport.SetCell(rowNumber,ColumnNumber,'1899-12-31T' & p_web.FormatValue(ven:TipoVenda,'@T04B'),'t' &  TimeColumn[ColumnNumber],,'DateTime')
      If 12 > ColumnWidth[ColumnNumber] then ColumnWidth[ColumnNumber] = 12.
    Else
      ExcelExport.SetCell(rowNumber,ColumnNumber,ven:TipoVenda)
      If Len(Clip(ven:TipoVenda)) > ColumnWidth[ColumnNumber] then ColumnWidth[ColumnNumber] = Len(Clip(ven:TipoVenda)).
    End
    ColumnNumber += 1
    If DateColumn[ColumnNumber]
      ExcelExport.SetCell(rowNumber,ColumnNumber,p_web.FormatValue(ven:VendaSap,'@D010-B'),'d' &  DateColumn[ColumnNumber],,'DateTime')
      If 12 > ColumnWidth[ColumnNumber] then ColumnWidth[ColumnNumber] = 12.
    ElsIf TimeColumn[ColumnNumber]
      ExcelExport.SetCell(rowNumber,ColumnNumber,'1899-12-31T' & p_web.FormatValue(ven:VendaSap,'@T04B'),'t' &  TimeColumn[ColumnNumber],,'DateTime')
      If 12 > ColumnWidth[ColumnNumber] then ColumnWidth[ColumnNumber] = 12.
    Else
      ExcelExport.SetCell(rowNumber,ColumnNumber,ven:VendaSap)
      If Len(Clip(ven:VendaSap)) > ColumnWidth[ColumnNumber] then ColumnWidth[ColumnNumber] = Len(Clip(ven:VendaSap)).
    End
    ColumnNumber += 1
    If DateColumn[ColumnNumber]
      ExcelExport.SetCell(rowNumber,ColumnNumber,p_web.FormatValue(ven:Quantidade,'@D010-B'),'d' &  DateColumn[ColumnNumber],,'DateTime')
      If 12 > ColumnWidth[ColumnNumber] then ColumnWidth[ColumnNumber] = 12.
    ElsIf TimeColumn[ColumnNumber]
      ExcelExport.SetCell(rowNumber,ColumnNumber,'1899-12-31T' & p_web.FormatValue(ven:Quantidade,'@T04B'),'t' &  TimeColumn[ColumnNumber],,'DateTime')
      If 12 > ColumnWidth[ColumnNumber] then ColumnWidth[ColumnNumber] = 12.
    Else
      ExcelExport.SetCell(rowNumber,ColumnNumber,ven:Quantidade)
      If Len(Clip(ven:Quantidade)) > ColumnWidth[ColumnNumber] then ColumnWidth[ColumnNumber] = Len(Clip(ven:Quantidade)).
    End
    rowNumber += 1
  End
  ! set style for header cells, across full browse width
  Loop columnNumber = 1 to loc:columns
    ExcelExport.SetCell(1,columnNumber,,'s151')
  End
  ! footer
  ExcelExport.SetRow(rowNumber,'s154',,22)
  ColumnNumber = 0
  ColumnNumber += 1
  ColumnNumber += 1
  ColumnNumber += 1
  Close(ThisView)
  If p_web.sqlsync then p_web.SqlRelease(p_web.SqlName).
  do CloseFilesB
  ! columns
  Loop columnNumber = 1 to loc:columns
    ExcelExport.SetColumn(columnNumber,,,ColumnWidth[columnNumber]*10)
    if columnNumber = maximum(ColumnWidth,1) then break.
  End
  ExcelExport.Save()
  p_web.SetSessionValue('Export_Browsevendas_PercentageComplete',100)
  p_web.HeaderDetails.ContentDisposition = 'attachment; filename="vendas.xml"'
  p_web.ReplyContentType = 'application/vnd.ms-excel'
  p_web.ReplyContentFixed = true
  p_web.SetHeader200()
  p_web.SendString (ExcelExport.xmlData, 1, ExcelExport.xmlDataLen, NET:SendHeader)

ExpCon  Routine
  p_web.SetBrowseValueStatus(p_web.getvalue('_bidv_'),choose(p_web.GetValue('_status_')='true',1,-1))

ChildNewSelection  Routine
  data
  code

! Propogates events up to "parent" controls
AlertParent  Routine
  data
parent_       string(100)
  code
  If loc:parent
    parent_ = p_web.GetValue('_ParentProc_')
    p_web.SetValue('_ParentProc_','')
    p_web.PageName = clip(loc:parent) & '_' & lower('Browsevendas') & '_value'
    p_web._SendFile(p_web.PageName)
    p_web.SetValue('_ParentProc_',parent_)
  End

! propogates events down to "child" controls.
AlertChildren  Routine
  if loc:selecting = 0
    do AjaxChildren
  End





CallPopups  Routine
  data
loc:options             StringTheory ! options for jQuery calls
loc:CallPopups   Long
loc:name         String(252)
  code
    loc:inCallPopups = 1
    loc:CallPopups = p_web.GetValue('_CallPopups')
    if loc:CallPopups = 1 ! browse not embedded on form so include popup divs and scripts for this browse
      if p_web.GetPreCall('popup_Browsevendas') = 0
        p_web.AddPreCall('popup_Browsevendas')
        p_web.DivHeader('popup_Browsevendas','nt-hidden',,,,1,,,'popup_Browsevendas')
        p_web.DivHeader('Browsevendas',p_web.combine(p_web.site.style.browsediv,,'Browsevendas',,1))
        if p_web.site.FrontLoaded
          loc:popup = 1
          loc:ReadData = false
          do GenerateBrowse
        End
        p_web.DivFooter()
        p_web.DivFooter(,'popup_Browsevendas End')
        do Heading
        loc:options.Free(True)
        p_web.SetOption(loc:options,'close','function(event, ui) {{ ntd.pop(); }')
        p_web.SetOption(loc:options,'autoOpen','false')
        p_web.SetOption(loc:options,'title',loc:heading)
        p_web.SetOption(loc:options,'width','95%')
        p_web.SetOption(loc:options,'modal', 'true')
        p_web.SetOption(loc:options,'position','[''center'','& clip(15)&']')
        If p_web.site.DefaultBrowseOpenAnimation
          p_web.SetOption(loc:options,'show','{{' & clip(p_web.site.DefaultBrowseOpenAnimation) & '}')
        End
        If p_web.site.DefaultBrowseCloseAnimation
          p_web.SetOption(loc:options,'hide','{{' & clip(p_web.site.DefaultBrowseCloseAnimation) & '}')
        End
        p_web.jQuery('#' & lower('popup_Browsevendas_div'),'dialog',loc:options,'.removeClass("nt-hidden")') !& |
        if p_web.site.FrontLoaded then do ClosingScripts.
        p_web.SetValue('_CallPopups',1)
        do Popups
        p_web.SetValue('_CallPopups',loc:CallPopups)
      End

    Elsif loc:CallPopups = 2 ! generate browse and dependants. not front loaded. popup browse has just opened.
      do GenerateBrowse
      p_web.SetValue('_CallPopups',1)
      do Popups
      p_web.SetValue('_CallPopups',loc:CallPopups)

    Elsif loc:CallPopups = 3 ! generate just browse dependants. outside </form> of parent.
        p_web.SetValue('_CallPopups',1)
        do Popups
        p_web.SetValue('_CallPopups',loc:CallPopups)

    Elsif loc:CallPopups = 4  ! generate the browse table only and enable the browse (frontloaded. browse refreshing)
      do GenerateBrowse
      p_web.ntBrowse(loc:divname,'enable')
    Elsif loc:CallPopups = 5 ! generate the browse but no dependants. frontloaded. ajax=0.  no data needed here.
      loc:popup = 1
      loc:ReadData = false
      do CallBrowse
    End
    loc:popup = 1
    do SendPacket

ClearBrowse  Routine
  p_web.ClearBrowse('Browsevendas_' & loc:randomBrowseId)

CallBrowse  Routine
  loc:stage = net:web:GenerateWholeBrowse
  If p_web.Ajax = 0
    p_web.Message('alert',,,Net:Send,true)   ! these 2 should have been done by here, but this handles cases
    p_web.Busy(Net:Send)                ! where they are not done.
  End
  If loc:FrontLoading = 0
    if Loc:ContentBody
      p_web.DivHeader(p_web.site.ContentBody,p_web.site.contentbodydivclass)
    End
    p_web.DivHeader(loc:divname,p_web.combine(p_web.site.style.browsediv,),,,,1)
  End
  do GenerateBrowse
  If loc:FrontLoading = 0
    p_web.DivFooter(,loc:divname)
    do Children
    If p_web.site.ContentBody <> '' and lower(p_web.GetValue('_cb_')) = lower('Browsevendas')
      p_web.Divfooter()
    End
    do ClosingScripts
    do SendPacket
  End

LookupAbility  Routine
  If p_web.IfExistsValue('Lookup_Btn')
    loc:vorder = upper(p_web.GetValue('_sort_'))
    p_web.PrimeForLookup(vendas,ven:PRIMARY,loc:vorder)
    If False
    ElsIf (loc:vorder = 'VEN:TIPOVENDA') then p_web.SetValue('Browsevendas_sort','1')
    ElsIf (loc:vorder = 'VEN:VENDASAP') then p_web.SetValue('Browsevendas_sort','2')
    ElsIf (loc:vorder = 'VEN:QUANTIDADE') then p_web.SetValue('Browsevendas_sort','3')
    End
  End
  If p_web.IfExistsValue('LookupField') and p_web.GetValue('Browsevendas:parentIs') <> 'Browse'
    loc:selecting = true
    p_web.StoreValue('Browsevendas:LookupField','LookupField')
  elsif p_web.Ajax > 0 and p_web.IfExistsSessionValue('Browsevendas:LookupField') > 0
    loc:selecting = true
  else
    p_web.DeleteSessionValue('Browsevendas:LookupField')
    loc:selecting = false
  End

Popups  Routine
  data
loc:options             StringTheory ! options for jQuery calls
  code
  If (loc:popup = 0 or p_web.site.FrontLoaded = 1)
    p_web.PushEvent('callpopups')
    If p_web.GetPreCall('Updatevendas') = 0 then Updatevendas(p_web,Net:Web:Popup).  !Form Procedure
    p_web.SetValue('_CallPopups',0)
    p_web.PopEvent()
  End

SetFormAction  Routine
  loc:formaction = 'Updatevendas'
  loc:formactiontarget = '_self'

GotFocusBack  Routine

Heading  Routine
  If band(loc:stage,net:web:GenerateHeadings + net:web:UpdateHeadings)
    If p_web.GetValue('_title_') <> ''
      loc:heading = p_web.Translate(p_web.GetValue('_title_'),(Net:HtmlOk*0)+(Net:UnsafeHtmlOk*0))
    Else
      loc:heading = p_web.Translate('Vendas',(Net:HtmlOk*0)+(Net:UnsafeHtmlOk*0))
    End
    do SendPacket
    if loc:inCallPopups then exit.
    if loc:heading
      if loc:popup
        ! do nothing
      else
        packet.append(p_web.DivHeader(clip(loc:divname) & '_header',p_web.Combine(p_web.site.style.browseHeading,),Net:NoSend))
        if loc:ParentSilent = 0
          packet.append(clip(loc:heading))
        end
        packet.append(p_web.DivFooter(Net:NoSend))
        do SendPacket
      end
    end
  End ! If band(loc:stage,net:web:GenerateHeadings + net:web:UpdateHeadings)

BrowseFooter  Routine

FindAnchor  Routine
  data
  code


SetSortHeader  Routine
  Case Left(Upper(Loc:LocateField))
  Of upper('ven:TipoVenda')
    loc:SortHeader = p_web.Translate('Tipo Venda',(Net:HtmlOk*0)+(Net:UnsafeHtmlOk*0))
    p_web.SetSessionValue('Browsevendas_LocatorPic_' & clip(loc:RandomBrowseId),'@s11')
    loc:LocatorType = Net:Search     ! default locator type for this browse
  Of upper('ven:VendaSap')
    loc:SortHeader = p_web.Translate('Venda Sap',(Net:HtmlOk*0)+(Net:UnsafeHtmlOk*0))
    p_web.SetSessionValue('Browsevendas_LocatorPic_' & clip(loc:RandomBrowseId),'@s11')
    loc:LocatorType = Net:Search     ! default locator type for this browse
  Of upper('ven:Quantidade')
    loc:SortHeader = p_web.Translate('Quantidade',(Net:HtmlOk*0)+(Net:UnsafeHtmlOk*0))
    p_web.SetSessionValue('Browsevendas_LocatorPic_' & clip(loc:RandomBrowseId),'@n-14')
    loc:LocatorType = Net:Position ! default locator is Search but this is a numeric column
  End

SetVorder  Routine
  If loc:vordernumber = 0
    loc:vordernumber = 1
  End
  p_web.SetSessionValue('Browsevendas_sort_' & loc:RandomBrowseId ,loc:vordernumber)
  Loc:SortDirection = choose(loc:vordernumber < 0,-1,1)
  case abs(loc:vordernumber)
  of 1
    loc:vorder = Choose(Loc:SortDirection=1,'UPPER(ven:TipoVenda)','-UPPER(ven:TipoVenda)')
    Loc:LocateOnFields = 'ven:TipoVenda'
    Loc:LocateField = 'ven:TipoVenda'
    Loc:LocatorCase = 0
  of 2
    loc:vorder = Choose(Loc:SortDirection=1,'UPPER(ven:VendaSap)','-UPPER(ven:VendaSap)')
    Loc:LocateOnFields = 'ven:VendaSap'
    Loc:LocateField = 'ven:VendaSap'
    Loc:LocatorCase = 0
  of 3
    loc:vorder = Choose(Loc:SortDirection=1,'ven:Quantidade','-ven:Quantidade')
    Loc:LocateOnFields = 'ven:Quantidade'
    Loc:LocateField = 'ven:Quantidade'
    Loc:LocatorCase = 0
  end
  if loc:vorder = ''
    loc:vorder = '+ven:Reg'
  end


SetLocatorOptions  Routine
  loc:LocatorPosition  = Net:Above
  loc:LocatorBlank = 0
  loc:LocatorSearchButton = true
  loc:LocatorClearButton = false
  loc:LocatorImmediate = 1

GenerateLocatorAbove  Routine
  If band(loc:stage,net:web:GenerateLocator) and loc:FileLoading = Net:PageLoad
    p_web.DivHeader(clip(loc:divname) & '_locator_b','')
    loc:options.Free(True)
    Loc:LocatorValue = p_web.GetLocatorValue(Loc:LocatorType,loc:divname,Net:Above,Loc:LocateOnFields)
    packet.append(p_web.CreateLocator('Browsevendas',loc:divname,loc:LocatorType,loc:locatorValue,loc:options,loc:SortHeader,loc:divname,loc:RandomBrowseId,,,'Search',20,0,Net:Above,loc:LocatorSearchButton,loc:LocatorClearButton,loc:LocatorSuggestions,loc:LocatorAutoCompleteoptions,loc:stage,loc:LocatorImmediate))
    do SendPacket
    p_web.DivFooter()
  End

GenerateLocatorBelow  Routine
  if band(loc:stage,net:web:GenerateLocator) and loc:FileLoading=Net:PageLoad
    p_web.DivHeader(clip(loc:divname) & '_locator_a','')
    loc:options.Free(True)
    Loc:LocatorValue = p_web.GetLocatorValue(Loc:LocatorType,loc:divname,Net:Below,Loc:LocateOnFields)
    packet.append(p_web.CreateLocator('Browsevendas',loc:divname,loc:LocatorType,loc:locatorValue,loc:options,loc:SortHeader,loc:divname,loc:RandomBrowseId,,,'Search',20,0,Net:Below,loc:LocatorSearchButton,loc:LocatorClearButton,loc:LocatorSuggestions,loc:LocatorAutoCompleteoptions,loc:stage,loc:LocatorImmediate))
    do SendPacket
    p_web.DivFooter()
  End

DisplayLocator  Routine
  if band(loc:stage,net:web:GenerateLocator + net:web:UpdateLocator)
    !! hide if browse not there
    If loc:ParentSilent or loc:LocatorPosition = Net:None or loc:LocatorType = Net:NoLocator
      p_web.ntBrowse(loc:divname,'hideLocator')
    !! hide if no sort column specified
    ElsIf loc:sortheader = ''
      p_web.ntBrowse(loc:divname,'hideLocator')
    !! hide if no records found and not set as "Table blank until locator entered" and locator blank
    ElsIf Loc:Found = 0 and loc:LocatorBlank = 0 and Loc:LocatorValue = ''
      p_web.ntBrowse(loc:divname,'hideLocator')
    !! hide if all records are displayed, and locator is positional
    ElsIf loc:LocatorType = Net:Position and loc:previousdisabled and loc:nextdisabled
      p_web.ntBrowse(loc:divname,'hideLocator')
    !! else unhide
    Else
      p_web.ntBrowse(loc:divname,'unhideLocator',loc:LocatorPosition)
    End
  End

BrowseBeforeTable  Routine

SetBrowseOptions  Routine
  loc:NavButtonPosition   = Net:Below
  loc:UpdateButtonPosition   = Net:Below
  if p_web.IfExistsValue('_viewonly_')
    loc:viewonly = p_web.GetValue('_viewonly_')
    p_web.SetSessionValue(clip(loc:divname)&'_viewonly_' & loc:RandomBrowseId,loc:viewonly)
  else
    loc:viewonly = choose(p_web.GetSessionValue(clip(loc:divname)&'_viewonly_' & loc:RandomBrowseId)=1,1,loc:viewonly)
  end
  p_web.SetValue('_viewonly_',loc:viewonly)
  loc:FileLoading      = Net:PageLoad   ! Page
  loc:Sorting          = Net:ServerSort
  loc:LayoutMethod =  p_web.site.BrowseLayoutMethod


GenerateBrowse  Routine
  data
loc:options             StringTheory ! options for jQuery calls
  code
  do SetBrowseOptions
  do SetLocatorOptions
  do ClearBrowse
  do OpenFilesB
  do LookupAbility ! browse lookup initialization
  If loc:FileLoading = Net:PageLoad then loc:pagerows = 10.
  loc:ActualSelection = ''
  ! Set Sort Order Options
  loc:vordernumber    = p_web.RestoreValue('Browsevendas_sort_' & loc:RandomBrowseId,net:DontEvaluate)
  do SetVorder
  do SetSortHeader
  If loc:selecting = true
    p_web.GetSettings(p_web.GetSessionValue('Push1'))
    loc:selectaction = p_web.FormSettings.ParentPage !p_web.GetSessionValue('Browsevendas:LookupFrom')
    p_web.GetSettings(p_web.GetSessionValue('Push1'))
    loc:CancelAction = p_web.FormSettings.ParentPage !p_web.GetSessionValue('Browsevendas:LookupFrom')
  End !Else
  loc:CloseAction = p_web.site.DefaultPage
  do SendPacket
  do SetFormAction
  loc:rowcount = 0
  do Heading
  ! in this section packets are added to the Queue using AddPacket, not sent using SendPacket

  if band(loc:stage,net:web:Navigate)
    p_web.ntBrowse(loc:divname,'restoreFocus')
  end

  do GenerateLocatorAbove
  do GenerateNavButtonsAbove
  do GenerateUpdateButtonsAbove
  do BrowseBeforeTable

  TableQueue.Kind = Net:RowTable
  loc:found = 0
  do BrowseTable
  do GenerateLocatorBelow
  do GenerateNavButtonsBelow
  do GenerateUpdateButtonsBelow
  do DisplayLocator
  do DisplayNavButtons
  do DisplayUpdatebuttons
  do SendPacket
  if band(loc:stage,net:web:GenerateWholeBrowse) <> net:web:GenerateWholeBrowse
    p_web.ntBrowse(loc:divname,'refresh','"' & clip(loc:actualselection) & '"')
  end
  if loc:ParentSilent
    p_web.ntBrowse(loc:divname,'hide')
  else
    p_web.ntBrowse(loc:divname,'show')
  end

BrowseTable  routine
  If p_web.RequestJson = false
    packet.append(p_web.DivHeader(clip(loc:divname) & '_table',p_web.Combine(p_web.site.style.BrowseTableDiv,),Net:NoSend,,,1)) ! Table Div
  else
    packet.append(p_web.DivHeader(clip(loc:divname) ,p_web.Combine(p_web.site.style.BrowseTableDiv,),Net:NoSend,,,,p_web.RequestJson)) ! Table Div
  end
  do SendPacket
  if loc:ParentSilent = false
    If p_web.RequestJson = false
      packet.append(p_web.BrowseTableStart(clip(loc:tablename), p_web.Combine(p_web.site.style.BrowseTable,''), '' , Net:Default  ))
    Else
      packet.append('"table":{{ "class":"'&p_web.Combine(p_web.site.style.BrowseTable,'')&'","id":"'&clip(loc:tablename)&'",' & p_web.HtmlToJsonAttributes(''))
    End
    do AddPacket
    TableQueue.Kind = Net:RowHeader
    If p_web.RequestJson = 0
      packet.append(p_web.BrowseTableRowStart('',' nt-browse-row-header browsevendas-row-header','browse-header-row','',Net:Default))
    Else
      packet.append('"rows":[ {{"row":{{')
    End
    loc:SelectColumnClass = ' class="selectcolumn"'
    If p_web.RequestJson
      packet.append('"cells":[')
    End
        If loc:CellStarted = false
          packet.append(p_web.CreateSortHeader(loc:vordernumber,'1','Browsevendas',p_web.Translate('Tipo Venda',(Net:HtmlOk*0)+(Net:UnsafeHtmlOk*0)),'Click here to sort by Tipo Venda',,,p_web.Combine(,),1,,,0,loc:Sorting,'String','nt-left',Net:Default,' Title="'&p_web._jsok('Click here to sort by Tipo Venda')&'"'))
        End
        loc:CellStarted = false
            do AddPacket
            loc:columns += 1
        If p_web.RequestJSON then packet.append(',').
        If loc:CellStarted = false
          packet.append(p_web.CreateSortHeader(loc:vordernumber,'2','Browsevendas',p_web.Translate('Venda Sap',(Net:HtmlOk*0)+(Net:UnsafeHtmlOk*0)),'Click here to sort by Venda Sap',,,p_web.Combine(,),1,,,0,loc:Sorting,'String','nt-left',Net:Default,' Title="'&p_web._jsok('Click here to sort by Venda Sap')&'"'))
        End
        loc:CellStarted = false
            do AddPacket
            loc:columns += 1
        If p_web.RequestJSON then packet.append(',').
        If loc:CellStarted = false
          packet.append(p_web.CreateSortHeader(loc:vordernumber,'3','Browsevendas',p_web.Translate('Quantidade',(Net:HtmlOk*0)+(Net:UnsafeHtmlOk*0)),'Click here to sort by Quantidade',,,p_web.Combine(,),1,,,0,loc:Sorting,'String','nt-left',Net:Default,' Title="'&p_web._jsok('Click here to sort by Quantidade')&'"'))
        End
        loc:CellStarted = false
            do AddPacket
            loc:columns += 1
        If loc:Selecting = 0
        If p_web.RequestJSON then packet.append(',').
        If loc:CellStarted = false
          packet.append(p_web.CreateSortHeader(loc:vordernumber,'4','Browsevendas',p_web.Translate(,(Net:HtmlOk*0)+(Net:UnsafeHtmlOk*0)),,,,p_web.Combine(,),1,,,1,loc:Sorting,'Button','nt-left',Net:Default,''))
        End
        loc:CellStarted = false
            do AddPacket
            loc:columns += 1
        End ! Selecting
        If loc:Selecting = 0
        If p_web.RequestJSON then packet.append(',').
        If loc:CellStarted = false
          packet.append(p_web.CreateSortHeader(loc:vordernumber,'5','Browsevendas',p_web.Translate(,(Net:HtmlOk*0)+(Net:UnsafeHtmlOk*0)),,,,p_web.Combine(,),1,,,1,loc:Sorting,'Button','nt-left',Net:Default,''))
        End
        loc:CellStarted = false
            do AddPacket
            loc:columns += 1
        End ! Selecting
        If loc:Selecting = 0
        If p_web.RequestJSON then packet.append(',').
        If loc:CellStarted = false
          packet.append(p_web.CreateSortHeader(loc:vordernumber,'6','Browsevendas',p_web.Translate(,(Net:HtmlOk*0)+(Net:UnsafeHtmlOk*0)),,,,p_web.Combine(,),1,,,1,loc:Sorting,'Button','nt-left',Net:Default,''))
        End
        loc:CellStarted = false
            do AddPacket
            loc:columns += 1
        End ! Selecting
        If loc:Selecting = 1
        If p_web.RequestJSON then packet.append(',').
        If loc:CellStarted = false
          packet.append(p_web.CreateSortHeader(loc:vordernumber,'7','Browsevendas',p_web.Translate(,(Net:HtmlOk*0)+(Net:UnsafeHtmlOk*0)),,,,p_web.Combine(,),1,,,1,loc:Sorting,'Button','nt-left',Net:Default,''))
        End
        loc:CellStarted = false
            do AddPacket
            loc:columns += 1
        End ! Selecting
    If p_web.RequestJson = 0
      packet.append(p_web.BrowseTableRowEnd('',Net:Default))
    Else
      packet.append(']}}]'&p_web.CRLF)  ! end of browse header
    End
    loc:rowstarted = 0
    do AddPacket
    if loc:ReadData
      do GenerateTableRows
    end
    if p_web.site.frontloaded
      loc:found = 1
      loc:previousdisabled = 0
      loc:nextdisabled = 0
    end
    p_web._thisrow = ''
    p_web._thisvalue = ''
    if loc:found = 0
      If p_web.RequestJson = 0
        packet.append(p_web.BrowseTableRowStart('','','browse-row','',Net:Default))
        packet.append(p_web.BrowseTableCellStart('',p_web.combine(p_web.site.style.BrowseEmpty,),1,1,'browse-cell','',Net:Default))
        packet.append(p_web.Translate('no Vendas'))
        packet.append(p_web.BrowseTableCellEnd('',Net:Default))
        packet.append(p_web.BrowseTableRowEnd('',Net:Default))
      Else
        packet.append('"rows":[ {{"row":{{"cells":[{{"cell":{{"class":"'&p_web.combine(p_web.site.style.BrowseEmpty,)&'",content:"'&p_web.Translate('no Vendas')&'"}}]}}]')
      End
      do AddPacket
      p_web.ntBrowse(loc:divname,'hideFormButtons','"0"')
      loc:firstvalue = ''
      loc:lastvalue = ''
    else
      p_web.ntBrowse(loc:divname,'unhideTable')
      p_web.ntBrowse(loc:divname,'unhideFormButtons')
    end
    loc:direction = 1
    do Totals

    p_web.SetSessionValue('Browsevendas_prop:Order_' & loc:RandomBrowseId,ThisView{prop:order})
    p_web.SetSessionValue('Browsevendas_prop:Filter_' & loc:RandomBrowseId,ThisView{prop:filter})
    Close(ThisView)
    If p_web.sqlsync then p_web.SqlRelease(p_web.SqlName).
    do SendQueue ! sends the thead, tfoot and tbody parts of the table.
    do SendPacket
    if p_web.RequestJson = 0
      packet.append(p_web.BrowseTableEnd(clip(loc:tablename),Net:Default))
    else
      packet.append('}' & p_web.CRLF)
    end
    do SendPacket
    do SendPacket
  End
  packet.append(p_web.DivFooter(Net:NoSend,'Browsevendas_table_div',p_web.RequestJson)) ! Table Div
  do SendPacket
  If loc:FrontLoading = 0
    do SendPacket
  End

  if(loc:FileLoading=Net:PageLoad)
    p_web.SetSessionValue('Browsevendas_FirstValue_' & loc:RandomBrowseId,loc:firstvalue)
    p_web.SetSessionValue('Browsevendas_LastValue_' & loc:RandomBrowseId,loc:lastvalue)
  End
  do CloseFilesB

GenerateTableRows  Routine
  data
loc:viewoptions  Long
  code
  TableQueue.Kind = Net:RowData
  If p_web.sqlsync then p_web.SqlWait(p_web.SqlName).
  Open(ThisView)
  If Loc:NoBuffer = 0
    Buffer(ThisView,10,0,0,0) ! causes sorting error in ODBC, when sorting by Decimal fields.
  End
  If Instring('ven:reg',lower(loc:vorder),1,1) = 0 !and vendas{prop:SQLDriver} = 1
    loc:vorder = Choose(loc:vorder='','ven:Reg',clip(loc:vorder) & ',' & 'ven:Reg')
  End
  Loc:Selected = Choose(p_web.IfExistsValue('ven:Reg'),p_web.GetValue('ven:Reg'),p_web.GetSessionValue('ven:Reg'))
  ThisView{prop:order} = p_web.CleanFilter(ThisView,clip(loc:vorder))
  
  ThisView{prop:Filter} = loc:FilterWas
  Loc:LocatorValue = p_web.GetLocatorValue(Loc:LocatorType,loc:divname,Net:Both,Loc:LocateOnFields)
  loc:FilterWas = ThisView{prop:filter}
  if loc:filterwas <> p_web.GetSessionValue('Browsevendas_Filter_' & loc:RandomBrowseId)
    p_web.SetSessionValue('Browsevendas_FirstValue_' & loc:RandomBrowseId,'')
    p_web.SetSessionValue('Browsevendas_Filter_' & loc:RandomBrowseId,loc:filterwas)
  end
  do FindAnchor
  p_web.SetSessionValue('LocatorField:' & clip(loc:divname),lower(left(Loc:LocateField)))
  p_web.SetView(ThisView,vendas,ven:PRIMARY,loc:PageRows,'Browsevendas',left(Loc:LocateOnFields),left(Loc:LocateField),loc:FileLoading,loc:LocatorType,clip(loc:LocatorValue),Loc:SortDirection,loc:ViewOptions,Loc:FillBack,Loc:Direction,loc:NextDisabled,loc:PreviousDisabled,Loc:LocatorCase,loc:RandomBrowseId)
  p_web.SetSessionValue('Browsevendas_CurrentOrder_' & loc:RandomBrowseId,ThisView{prop:order})
  p_web.SetSessionValue('Browsevendas_CurrentFilter_' & loc:RandomBrowseId,ThisView{prop:filter})
  If loc:LocatorBlank = 0 or Loc:LocatorValue <> '' or Loc:LocatorType = Net:Date or loc:LocatorType = Net:Position or loc:LocatorType = Net:NoLocator
    loc:InView = 1
    Loop
      If loc:direction > 0 Then Next(ThisView) else Previous(ThisView).
      if errorcode() = 0                                         ! in some cases the first record in the
        if loc:ViewPosWorkaround = Position(ThisView)   ! view is fetched twice after the SET(view,file)
          Cycle                                                  ! 4.31 PR 18
        End
        loc:ViewPosWorkaround = Position(ThisView)
      End
      If ErrorCode()
        loc:ViewPosWorkaround = ''
        if loc:rowstarted
          If p_web.RequestJson = 0
            packet.append(p_web.BrowseTableRowEnd('',Net:Default))
          Else
            packet.append('},'&p_web.CRLF)
          End
          do AddPacket
          loc:rowstarted = 0
        End
        If loc:direction = -1
          loc:previousdisabled = 1
          Break
        End
        If loc:direction = 1
          loc:nextdisabled = 1
          Break
        End
        If loc:fillback = 0
          loc:nextdisabled = 1
          Break
        end
        if loc:direction = 2
          If loc:LocatorType = Net:Position or loc:LocatorType = Net:Date
            ThisView{prop:Filter} = p_web.AssignFilter(loc:FilterWas)
          End
          If loc:first = 0
            Set(thisView)
          Else
            p_web._bounceView(ThisView)
            p_web.ResetPosition(ThisView,loc:firstvalue)
            Previous(ThisView)
          End
          loc:direction = -1
          loc:nextdisabled = 1
          Cycle
        End
        if loc:direction = -2
          p_web._bounceView(ThisView)
            p_web.ResetPosition(ThisView,loc:lastvalue)
          Next(ThisView)
          loc:direction = 1
          loc:previousdisabled = 1
          Cycle
        End
      End
      If(loc:FileLoading=Net:PageLoad)
        If loc:rowcount >= loc:pagerows !and loc:page > 1
          if loc:rowstarted
            If p_web.RequestJson = 0
              packet.append(p_web.BrowseTableRowEnd('',Net:Default))
            Else
              packet.append('}'&p_web.CRLF)
            End
            do AddPacket
            loc:rowstarted = 0
          End
          Break
        End
      End
      loc:viewstate = p_web.escape(p_web.Base64Encode(clip(ven:Reg)))
      do BrowseRow
    end ! loop
    loc:InView = 0
  else
    If p_web.RequestJson = 0
      packet.append(p_web.BrowseTableRowStart('',' nt-browse-locator-row browsevendas-locator-row','browse-locator-row','',Net:Default))
      packet.append(p_web.BrowseTableCellStart('',' nt-browse-locator-cell browsevendas-locator-cell',1,1,'browse-locator-cell','',Net:Default))
      packet.append(p_web.Translate('Enter a search term in the locator'))
      packet.append(p_web.BrowseTableCellEnd('',Net:Default))
      packet.append(p_web.BrowseTableRowEnd('',Net:Default))
    Else
      packet.append(p_web.BrowseTableRowStart('',' nt-browse-locator-row browsevendas-locator-row','browse-locator-row','',Net:Default))
      packet.append(p_web.BrowseTableCellStart('',' nt-browse-locator-cell browsevendas-locator-cell',1,1,'browse-locator-cell','',Net:Default))
      packet.append(p_web.Translate('Enter a search term in the locator'))
      packet.append(p_web.BrowseTableCellEnd('',Net:Default))
      packet.append(p_web.BrowseTableRowEnd('',Net:Default))
    End
    do AddPacket
  end

GenerateUpdateButtonsAbove  Routine
  If (loc:UpdateButtonPosition=Net:Above or loc:UpdateButtonPosition=Net:Both) and band(loc:stage,net:web:GenerateUpdates)
    packet.append(p_web.DivHeader(clip(loc:divname)&'_update_a',p_web.combine(p_web.site.style.BrowseUpdateButtonSet,),net:noSend))
    If (loc:selecting = 0 or loc:popup)
        If loc:viewonly = 0
              packet.append(p_web.CreateStdBrowseButton(Net:Web:InsertButton,'Browsevendas',,,loc:FormPopup,'Updatevendas'))
              do SendPacket
        End
    End
        If p_web.site.DefaultExport
          packet.append(p_web.CreateStdBrowseButton(Net:Web:ExportButton,'Browsevendas') & p_web.CRLF)
        End
    
    packet.append(p_web.DivFooter(Net:NoSend,clip(loc:divname)&'_update_a',false,true))
    If p_web.site.UseUpdateButtonSet
      loc:options.Free(True)
      p_web.jQuery('#'&clip(loc:divname)&'_update_a','controlgroup',loc:options)
    End ! If p_web.site.UseUpdateButtonSet
    do SendPacket
      packet.append('<div id="Browsevendas_select_a" class="'&p_web.combine(p_web.site.style.BrowseSelectButtonSet,)&'">')
    If loc:selecting = 1 !and loc:parent = ''
      packet.append(p_web.CreateStdBrowseButton(Net:Web:BrowseCancelButton,'Browsevendas',,,loc:popup))
      do SendPacket
    End
    packet.append('</div>' & p_web.CRLF)
    If p_web.site.UseSelectButtonSet
      loc:options.Free(True)
      p_web.jQuery('#' & 'Browsevendas_select_a','controlgroup',loc:options)
    End ! If p_web.site.UseSelectButtonSet
    do SendPacket
    do SendPacket
  End

GenerateUpdateButtonsBelow  routine
  If (loc:UpdateButtonPosition=Net:Below or loc:UpdateButtonPosition=Net:Both) and band(loc:stage,net:web:GenerateUpdates)
    packet.append(p_web.DivHeader(clip(loc:divname)&'_update_b',p_web.combine(p_web.site.style.BrowseUpdateButtonSet,),net:noSend))
    If (loc:selecting = 0 or loc:popup)
        If loc:viewonly = 0
              packet.append(p_web.CreateStdBrowseButton(Net:Web:InsertButton,'Browsevendas',,,loc:FormPopup,'Updatevendas'))
              do SendPacket
        End
    End
        If p_web.site.DefaultExport
          packet.append(p_web.CreateStdBrowseButton(Net:Web:ExportButton,'Browsevendas') & p_web.CRLF)
        End
    
    packet.append(p_web.DivFooter(Net:NoSend,clip(loc:divname)&'_update_b',false,true))
    If p_web.site.UseUpdateButtonSet
      loc:options.Free(True)
      p_web.jQuery('#'&clip(loc:divname)&'_update_b','controlgroup',loc:options)
    End ! If p_web.site.UseUpdateButtonSet
    do SendPacket
      packet.append('<div id="Browsevendas_select_b" class="'&p_web.combine(p_web.site.style.BrowseSelectButtonSet,)&'">')
    If loc:selecting = 1 !and loc:parent = ''
      packet.append(p_web.CreateStdBrowseButton(Net:Web:BrowseCancelButton,'Browsevendas',,,loc:popup))
      do SendPacket
    End
    packet.append('</div>' & p_web.CRLF)
    If p_web.site.UseSelectButtonSet
      loc:options.Free(True)
      p_web.jQuery('#' & 'Browsevendas_select_b','controlgroup',loc:options)
    End ! If p_web.site.UseSelectButtonSet
    do SendPacket
    do SendPacket
  End ! If (loc:UpdateButtonPosition...

DisplayUpdateButtons  Routine
  If loc:parentSilent
    p_web.ntBrowse(loc:divname,'hideFormButtons','true')
  ElsIf loc:found = 0
    p_web.ntBrowse(loc:divname,'hideFormButtons','"0"')
  Else
    p_web.ntBrowse(loc:divname,'unhideFormButtons')
  End

GenerateNavButtonsAbove  routine
  If loc:FileLoading=Net:PageLoad and band(loc:stage,net:web:GenerateNav) and (loc:NavButtonPosition=Net:Above or loc:NavButtonPosition=Net:Both)
      packet.append('<div id="' & clip(loc:divname) & '_nav_a" class="'&p_web.combine(p_web.site.style.BrowseNavButtonSet,)&'">')
      packet.append(p_web.CreateStdButton('button',Net:Web:FirstButton,,,,,,loc:previousdisabled,,'Browsevendas')) !p1
      packet.append(p_web.CreateStdButton('button',Net:Web:PreviousButton,,,,,,loc:previousdisabled,,'Browsevendas')) !p2
      packet.append(p_web.CreateStdButton('button',Net:Web:NextButton,,,,,,loc:nextdisabled,,'Browsevendas')) !p3
      packet.append(p_web.CreateStdButton('button',Net:Web:LastButton,,,,,,loc:nextdisabled,,'Browsevendas')) !p4
      packet.append('</div>' & p_web.CRLF)
      If p_web.site.UseNavigationButtonSet
        loc:options.Free(True)
        p_web.jQuery('#' & clip(loc:divname) & '_nav_a','controlgroup',loc:options)
      End
      do SendPacket
    do SendPacket
  End

GenerateNavButtonsBelow  routine
  If loc:FileLoading=Net:PageLoad and band(loc:stage,net:web:GenerateNav) and (loc:NavButtonPosition=Net:Below or loc:NavButtonPosition=Net:Both)
      packet.append('<div id="' & clip(loc:divname) & '_nav_b" class="'&p_web.combine(p_web.site.style.BrowseNavButtonSet,)&'">')
      packet.append(p_web.CreateStdButton('button',Net:Web:FirstButton,,,,,,loc:previousdisabled,,'Browsevendas')) !p1
      packet.append(p_web.CreateStdButton('button',Net:Web:PreviousButton,,,,,,loc:previousdisabled,,'Browsevendas')) !p2
      packet.append(p_web.CreateStdButton('button',Net:Web:NextButton,,,,,,loc:nextdisabled,,'Browsevendas')) !p3
      packet.append(p_web.CreateStdButton('button',Net:Web:LastButton,,,,,,loc:nextdisabled,,'Browsevendas')) !p4
      packet.append('</div>' & p_web.CRLF)
      If p_web.site.UseNavigationButtonSet
        loc:options.Free(True)
        p_web.jQuery('#' & clip(loc:divname) & '_nav_b','controlgroup',loc:options)
      End
      do SendPacket
    do SendPacket
  End

DisplayNavButtons  Routine
  If loc:FileLoading=Net:PageLoad
    If band(loc:stage,net:web:GenerateNav + net:web:UpdateNav)
      if (loc:previousdisabled and loc:nextdisabled) or loc:parentsilent or loc:found = 0
        p_web.ntBrowse(loc:divname,'hideNav')
      elsif loc:ParentSilent = 0
        p_web.ntBrowse(loc:divname,'unhideNav',loc:previousdisabled&','&loc:nextdisabled)
      end
    End
  End

BrowseRow  routine
  If loc:eip = 0
    If(loc:InView)
      loc:field = p_web.AddBrowseValue('Browsevendas_' & loc:RandomBrowseId,'vendas',ven:PRIMARY,ThisView)
    Else
      loc:field = p_web.AddBrowseValue('Browsevendas_' & loc:RandomBrowseId,'vendas',ven:PRIMARY)
    End
  End
  p_web._thisrow = p_web.nocolon('ven:Reg')
  p_web._thisvalue = p_web._jsok(loc:field)
  loc:RecordExtra.SetValue('')
  if loc:eip = 0
    if Loc:LocatorValue <> '' and loc:ActualSelection = '' and false ! this path disable because of  http://www.nettalkcentral.com/index.php?option=com_smf&Itemid=36&topic=5043.0
      loc:checked = 'checked'
      do SetSelection
    elsif loc:ActualSelection = '' and ven:Reg = p_web.GetSessionValue('ven:Reg')
       loc:checked = 'checked'
       do SetSelection
    elsif loc:selecting = 1
      loc:checked = Choose(p_web.getsessionvalue(p_web.GetSessionValue('Browsevendas:LookupField')) = ven:Reg and loc:ActualSelection = '','checked','')
      if loc:checked <> '' then do SetSelection.
    else
      loc:checked = Choose((ven:Reg = loc:selected) and loc:ActualSelection = '','checked','')
      if loc:checked <> '' then do SetSelection.
    end
    loc:rowstyle = p_web.combine()
    loc:RecordExtra.SetValue('data-nt-id="'& clip(loc:field) &'"')
    loc:RecordClicked.SetValue('')
    If(loc:RecordClicked.Length())
      loc:RecordExtra.append(' onclick="'& loc:RecordClicked.GetValue()&'"')
    End
    do StartRowHTML
    do StartRow
    loc:RowsIn = 0
    if(loc:FileLoading=Net:PageLoad)
      if loc:first = 0 or loc:direction < 0
        loc:firstvalue = p_web.ViewPos
        if loc:first = 0 then loc:first = records(TableQueue) + 1.
        loc:DefaultSelection = loc:field
      end
      if loc:direction > 0 or loc:lastvalue = ''
              loc:lastvalue = p_web.ViewPos
      end
    Else
      If loc:first = 0
        loc:first = records(TableQueue) + 1
        loc:DefaultSelection = loc:field
      End
    End
    If loc:checked then do SetSelection.
    If loc:DefaultSelection = '' or loc:direction < 0
      loc:DefaultSelection = loc:field
    End
  end ! loc:eip = 0
  if p_web.RequestJSON
    packet.append('"cells": [')
  end
  loc:CellsCounter = 0
  do Cells1
  if p_web.RequestJSON
    packet.append(']}')
  end
  loc:found = 1

Cells1  Routine
          If Loc:Eip = 0
              If p_web.RequestJson = 0
                If loc:CellStarted = false
                  packet.append(p_web.BrowseTableCellStart(clip(loc:field)&'-1',p_web.combine(' nt-flexwidth-1'),,,'browse-cell','',Net:Default)) !w3
                  loc:CellStarted = true
                End
              Else
                loc:CellsCounter += 1
                if loc:CellsCounter > 1 then packet.append(',').
                packet.append('{{"cell":{{' & p_web.HtmlToJsonAttributes(p_web.combine(' nt-flexwidth-1') & ''))   !b1
              End
          end ! loc:eip = 0
          If p_web.RequestJson = 0
            do value::ven:TipoVenda
          Else
            packet.append('"content":"')
            tempjson.SetValue(packet.GetValue())
            packet.SetValue('')
            do value::ven:TipoVenda
            packet.JsonEncode(st:xml)
            packet.SetValue(tempjson.GetValue() & packet.GetValue())
            packet.append('"')
          end
          If loc:eip = 0
            If p_web.RequestJson = 0
              packet.append(p_web.BrowseTableCellEnd('',Net:Default))
              loc:CellStarted = false
            Else
              packet.append('}}' & p_web.CRLF)
            End
          End
          If Loc:Eip = 0
              If p_web.RequestJson = 0
                If loc:CellStarted = false
                  packet.append(p_web.BrowseTableCellStart(clip(loc:field)&'-2',p_web.combine(' nt-flexwidth-1'),,,'browse-cell','',Net:Default)) !w3
                  loc:CellStarted = true
                End
              Else
                loc:CellsCounter += 1
                if loc:CellsCounter > 1 then packet.append(',').
                packet.append('{{"cell":{{' & p_web.HtmlToJsonAttributes(p_web.combine(' nt-flexwidth-1') & ''))   !b1
              End
          end ! loc:eip = 0
          If p_web.RequestJson = 0
            do value::ven:VendaSap
          Else
            packet.append('"content":"')
            tempjson.SetValue(packet.GetValue())
            packet.SetValue('')
            do value::ven:VendaSap
            packet.JsonEncode(st:xml)
            packet.SetValue(tempjson.GetValue() & packet.GetValue())
            packet.append('"')
          end
          If loc:eip = 0
            If p_web.RequestJson = 0
              packet.append(p_web.BrowseTableCellEnd('',Net:Default))
              loc:CellStarted = false
            Else
              packet.append('}}' & p_web.CRLF)
            End
          End
          If Loc:Eip = 0
              If p_web.RequestJson = 0
                If loc:CellStarted = false
                  packet.append(p_web.BrowseTableCellStart(clip(loc:field)&'-3',p_web.combine(' nt-flexwidth-1'),,,'browse-cell','',Net:Default)) !w3
                  loc:CellStarted = true
                End
              Else
                loc:CellsCounter += 1
                if loc:CellsCounter > 1 then packet.append(',').
                packet.append('{{"cell":{{' & p_web.HtmlToJsonAttributes(p_web.combine(' nt-flexwidth-1') & ''))   !b1
              End
          end ! loc:eip = 0
          If p_web.RequestJson = 0
            do value::ven:Quantidade
          Else
            packet.append('"content":"')
            tempjson.SetValue(packet.GetValue())
            packet.SetValue('')
            do value::ven:Quantidade
            packet.JsonEncode(st:xml)
            packet.SetValue(tempjson.GetValue() & packet.GetValue())
            packet.append('"')
          end
          If loc:eip = 0
            If p_web.RequestJson = 0
              packet.append(p_web.BrowseTableCellEnd('',Net:Default))
              loc:CellStarted = false
            Else
              packet.append('}}' & p_web.CRLF)
            End
          End
        If Loc:Selecting = 0
          If Loc:Eip = 0
              If p_web.RequestJson = 0
                If loc:CellStarted = false
                  packet.append(p_web.BrowseTableCellStart(clip(loc:field)&'-4',p_web.combine(' nt-flexwidth-1'),,,'browse-cell','',Net:Default)) !w3
                  loc:CellStarted = true
                End
              Else
                loc:CellsCounter += 1
                if loc:CellsCounter > 1 then packet.append(',').
                packet.append('{{"cell":{{' & p_web.HtmlToJsonAttributes(p_web.combine(' nt-flexwidth-1') & ''))   !b1
              End
          end ! loc:eip = 0
          If p_web.RequestJson = 0
            do value::Copy
          Else
            packet.append('"content":"')
            tempjson.SetValue(packet.GetValue())
            packet.SetValue('')
            do value::Copy
            packet.JsonEncode(st:xml)
            packet.SetValue(tempjson.GetValue() & packet.GetValue())
            packet.append('"')
          end
          If loc:eip = 0
            If p_web.RequestJson = 0
              packet.append(p_web.BrowseTableCellEnd('',Net:Default))
              loc:CellStarted = false
            Else
              packet.append('}}' & p_web.CRLF)
            End
          End
        End     !Selecting
        If Loc:Selecting = 0
          If Loc:Eip = 0
              If p_web.RequestJson = 0
                If loc:CellStarted = false
                  packet.append(p_web.BrowseTableCellStart(clip(loc:field)&'-5',p_web.combine(' nt-flexwidth-1'),,,'browse-cell','',Net:Default)) !w3
                  loc:CellStarted = true
                End
              Else
                loc:CellsCounter += 1
                if loc:CellsCounter > 1 then packet.append(',').
                packet.append('{{"cell":{{' & p_web.HtmlToJsonAttributes(p_web.combine(' nt-flexwidth-1') & ''))   !b1
              End
          end ! loc:eip = 0
          If p_web.RequestJson = 0
            do value::Change
          Else
            packet.append('"content":"')
            tempjson.SetValue(packet.GetValue())
            packet.SetValue('')
            do value::Change
            packet.JsonEncode(st:xml)
            packet.SetValue(tempjson.GetValue() & packet.GetValue())
            packet.append('"')
          end
          If loc:eip = 0
            If p_web.RequestJson = 0
              packet.append(p_web.BrowseTableCellEnd('',Net:Default))
              loc:CellStarted = false
            Else
              packet.append('}}' & p_web.CRLF)
            End
          End
        End     !Selecting
        If Loc:Selecting = 0
          If Loc:Eip = 0
              If p_web.RequestJson = 0
                If loc:CellStarted = false
                  packet.append(p_web.BrowseTableCellStart(clip(loc:field)&'-6',p_web.combine(' nt-flexwidth-1'),,,'browse-cell','',Net:Default)) !w3
                  loc:CellStarted = true
                End
              Else
                loc:CellsCounter += 1
                if loc:CellsCounter > 1 then packet.append(',').
                packet.append('{{"cell":{{' & p_web.HtmlToJsonAttributes(p_web.combine(' nt-flexwidth-1') & ''))   !b1
              End
          end ! loc:eip = 0
          If p_web.RequestJson = 0
            do value::Delete
          Else
            packet.append('"content":"')
            tempjson.SetValue(packet.GetValue())
            packet.SetValue('')
            do value::Delete
            packet.JsonEncode(st:xml)
            packet.SetValue(tempjson.GetValue() & packet.GetValue())
            packet.append('"')
          end
          If loc:eip = 0
            If p_web.RequestJson = 0
              packet.append(p_web.BrowseTableCellEnd('',Net:Default))
              loc:CellStarted = false
            Else
              packet.append('}}' & p_web.CRLF)
            End
          End
        End     !Selecting
        If Loc:Selecting = 1
          If Loc:Eip = 0
              If p_web.RequestJson = 0
                If loc:CellStarted = false
                  packet.append(p_web.BrowseTableCellStart(clip(loc:field)&'-7',p_web.combine(' nt-flexwidth-1'),,,'browse-cell','',Net:Default)) !w3
                  loc:CellStarted = true
                End
              Else
                loc:CellsCounter += 1
                if loc:CellsCounter > 1 then packet.append(',').
                packet.append('{{"cell":{{' & p_web.HtmlToJsonAttributes(p_web.combine(' nt-flexwidth-1') & ''))   !b1
              End
          end ! loc:eip = 0
          If p_web.RequestJson = 0
            do value::Select
          Else
            packet.append('"content":"')
            tempjson.SetValue(packet.GetValue())
            packet.SetValue('')
            do value::Select
            packet.JsonEncode(st:xml)
            packet.SetValue(tempjson.GetValue() & packet.GetValue())
            packet.append('"')
          end
          If loc:eip = 0
            If p_web.RequestJson = 0
              packet.append(p_web.BrowseTableCellEnd('',Net:Default))
              loc:CellStarted = false
            Else
              packet.append('}}' & p_web.CRLF)
            End
          End
        End     !Selecting

StartRowHTML  Routine
  data
DataDo  String(100)
  code
  If loc:rowstarted
    if p_web.RequestJson = 0
      packet.append(p_web.BrowseTableRowEnd('',Net:Default))
    else
      packet.append('},'&p_web.CRLF)
    end
    do AddPacket
  End
  If band(p_web.site.DefaultDoubleClick,Net:Select + Net:SingleClick ) = Net:Select + Net:SingleClick and loc:selecting
    DataDo = 'data-do="ss"'
  ElsIf band(p_web.site.DefaultDoubleClick,Net:Select) and loc:selecting
    DataDo = 'data-do="ds"'
  ElsIf  band(p_web.site.DefaultDoubleClick,Net:Update) !! goto form
    If True
      If band(p_web.site.DefaultDoubleClick,Net:SingleClick)
        DataDo = 'data-do="sc"'
      Else
        DataDo = 'data-do="dc"'
      End
    End
  Else  !! no DoubleClick (or SingleClick) support
  End
  If p_web.RequestJson = 0
    packet.append(p_web.BrowseTableRowStart('',' ' & clip(loc:rowstyle) & ' nt-browse-row-data browsevendas-row-data','browse-row',loc:RecordExtra.GetValue() & ' ' & dataDo,Net:Default,))
  Else
    packet.append('{{ "row": {{' & p_web.HtmlToJsonAttributes(dataDo) & p_web.HtmlToJsonAttributes(loc:rowstyle) &p_web.CRLF)
  End
  loc:rowstarted = 1

StartRow  Routine
  loc:rowcount += 1
  TableQueue.Idx = loc:field !p_web.AddBrowseValue('Browsevendas','vendas',ven:PRIMARY,ThisView)
  TableQueue.Id[1] = ven:Reg

ClosingScripts  Routine
  data
Rtn_SecwinProcedureName         string(252)
loc:BuildOptions                stringTheory
FirstInCell                     long
  code
    do SetFormAction
    loc:SecwinProcedure = ''
    loc:options.Free(True)
    p_web.SetOption(loc:options,'procedure',lower('Browsevendas'))
    p_web.SetOption(loc:options,'id',loc:divname)
    p_web.SetOption(loc:options,'tableId', clip(loc:tablename))
    p_web.SetOption(loc:options,'title',loc:Heading)
    p_web.SetOption(loc:options,'randomid',loc:RandomBrowseId)
    p_web.SetOption(loc:options,'parent',loc:parent)
    p_web.SetOption(loc:options,'parentrid',p_web.GetValue('_parentrid_'))
    p_web.SetOption(loc:options,'value',loc:actualselection)
    p_web.SetOption(loc:options,'form',loc:formaction)
    p_web.SetOption(loc:options,'formInsert','')
    p_web.SetOption(loc:options,'formCopy','')
    p_web.SetOption(loc:options,'formChange','')
    p_web.SetOption(loc:options,'formView','')
    p_web.SetOption(loc:options,'formDelete','')
    p_web.SetOption(loc:options,'formpopup',loc:FormPopup)
    p_web.SetOption(loc:options,'selectAction',loc:selectAction)
    p_web.SetOption(loc:options,'cancelAction',loc:cancelAction)
    p_web.SetOption(loc:options,'closeAction',loc:CloseAction)
    p_web.SetOption(loc:options,'viewOnly',loc:ViewOnly)
    p_web.SetOption(loc:options,'animateSpeed', 500 )
    p_web.SetOption(loc:options,'lookupField',p_web.GetSessionValue('Browsevendas:LookupField'))
    p_web.SetOption(loc:options,'confirmDeleteMessage',p_web.translate('Are you sure you want to delete this record?'))
    p_web.SetOption(loc:options,'confirmText',p_web.translate('Confirm'))
    p_web.SetOption(loc:options,'deleteText',p_web.translate('Delete'))
    p_web.SetOption(loc:options,'cancelText',p_web.translate('No'))
    p_web.SetOption(loc:options,'confirmDelete',p_web.site.DefaultDeletePrompt)
    p_web.SetOption(loc:options,'rowsHigh',loc:RowsHigh)
    if p_web.Site.Style.BrowseOverColor
      p_web.SetOption(loc:options,'bgOver',p_web.Site.Style.BrowseOverColor)
    end
    if p_web.Site.Style.BrowseHighlightColor
      p_web.SetOption(loc:options,'bgSelect',p_web.Site.Style.BrowseHighlightColor)
    end
    if p_web.Site.Style.BrowseOneColor
      p_web.SetOption(loc:options,'bgOne',p_web.Site.Style.BrowseOneColor)
    end
    if p_web.Site.Style.BrowseTwoColor
      p_web.SetOption(loc:options,'bgTwo',p_web.Site.Style.BrowseTwoColor)
    end
    p_web.SetOption(loc:options,'rubberband',0)
    p_web.SetOption(loc:options,'hideRubberbandOnMouseUp',1)
    p_web.SetOption(loc:options,'popup',loc:popup)
    p_web.ntBrowse(loc:divname,loc:options)
    If p_web.GetValue('SelectField') = '' and loc:LocatorPosition <> Net:None and p_web.Focus = true
      p_web.ntBrowse(loc:divname,'locatorFocus')
    End
    do SendPacket

CloseFilesB  Routine
  p_web.CloseFile(vendas)
  popbind()

OpenFilesB  Routine
  pushbind()
  p_web.OpenFile(vendas)
  Bind(ven:Record)
  Clear(ven:Record)

Children  Routine
  if loc:selecting = 0
    If p_web.Ajax = 0 or p_web.GetValue('_cb_')
      do StartChildren
    Else
      do AjaxChildren
    End
  end

AjaxChildren  Routine
  data
refresh  string(100)
  code

StartChildren  Routine
  data
parent_  string(252)
  code
  parent_ = p_web.SetParent(loc:parent,'Browsevendas')
! ----------------------------------------------------------------------------------------
CallClicked  Routine
  p_web.SetSessionValue('ven:Reg',p_web.GetValue('ven:Reg'))

! ----------------------------------------------------------------------------------------
CallRow  Routine
  data
loc:result  long
loc:hash  string(Net:HashSize)
  code
  do OpenFilesB
  ven:Reg = p_web.GetSessionValue('ven:Reg')
  loc:result = p_web.GetFile(vendas,ven:PRIMARY)
  if loc:result = 0
    loc:hash = p_web.GetBrowseHash('Browsevendas_' & loc:RandomBrowseId,'vendas',vendas,ven:PRIMARY ,ven:Reg)
    if loc:hash
      p_web.GetBrowseValue(loc:hash) ! primes p_web.viewpos for use in GetView
    end
  end
  loc:result = p_web.GetView(ThisView,'Browsevendas',loc:RandomBrowseId)
  loc:InView = 1
  loc:eip = 1
  loc:viewstate = p_web.escape(p_web.Base64Encode(clip(ven:Reg)))
  do BrowseRow
  loc:InView = 0
  do SendPacket
  do ClosefilesB

! ----------------------------------------------------------------------------------------
SendMessage  Routine
  p_web.Message('Alert',loc:alert,p_web.site.MessageClass,Net:Send,true)

! ----------------------------------------------------------------------------------------
CallEip  Routine
  Data
loc:RefreshAction  long
  Code
  loc:eip = 1
  p_web.OpenFile(vendas)
  Case upper(p_web.GetValue('_eipclm_'))
  Else
    loc:RefreshAction = p_web.GetValue('_action_')
    case loc:RefreshAction
    of Net:ChangeRecord
      loc:eip = 0
      do CallRow
      p_web.ntBrowse(loc:divname,'enable')
    of Net:InsertRecord
    orof Net:DeleteRecord
    orof Net:CopyRecord
    orof Net:LookupRecord
    orof Net:RefreshWholeTable
    orof Net:NotKnown
      loc:eip = 0
      loc:stage = net:web:GenerateTable + net:web:UpdateNav + net:web:GenerateUpdates
      do GenerateBrowse
      p_web.ntBrowse(loc:divname,'enable')
    of Net:ViewRecord
      p_web.ntBrowse(loc:divname,'enable')
    end
  End
  do GotFocusBack
  p_web.CloseFile(vendas)
!
! ----------------------------------------------------------------------------------------
value::ven:TipoVenda  Routine
  data
loc:extra          String(252)
loc:disabled       String(20)
loc:FormOk         Long(1)
loc:options        StringTheory ! options for jQuery calls
loc:fieldClass     String(252)
loc:javascript     String(JavascriptStringLen)
loc:ok             Long
loc:abbreviate     Long
loc:FilterA         StringTheory
  code
    if false
    else ! default settings for browse column
      loc:extra = ''
      if loc:LayoutMethod <> net:Table
        packet.append('<div class="' & p_web.Combine('nt-browse-grid-cell-prompt',' nt-flex nt-browse-data',,) & '">'&p_web.Translate('Tipo Venda',(Net:HtmlOk*0)+(Net:UnsafeHtmlOk*0))&'</div>')
      end
      packet.append(p_web.DivHeader('Browsevendas_ven:TipoVenda_'&ven:Reg,' nt-flex nt-browse-data',net:crc,,loc:extra))
      packet.append( p_web.CreateHyperLink(p_web._jsok(Left(p_web.FormatValue(ven:TipoVenda,'@s11')),(Net:HtmlOk*0)+(Net:UnsafeHtmlOk*0)),,,,loc:javascript,,,(Net:HtmlOk*0)+(Net:UnsafeHtmlOk*0),,,'Browsevendas'))
    End
    packet.append(p_web.DivFooter(Net:NoSend))
    if loc:eip = 1
      do SendPacket
    end
! ----------------------------------------------------------------------------------------
value::ven:VendaSap  Routine
  data
loc:extra          String(252)
loc:disabled       String(20)
loc:FormOk         Long(1)
loc:options        StringTheory ! options for jQuery calls
loc:fieldClass     String(252)
loc:javascript     String(JavascriptStringLen)
loc:ok             Long
loc:abbreviate     Long
loc:FilterA         StringTheory
  code
    if false
    else ! default settings for browse column
      loc:extra = ''
      if loc:LayoutMethod <> net:Table
        packet.append('<div class="' & p_web.Combine('nt-browse-grid-cell-prompt',' nt-flex nt-browse-data',,) & '">'&p_web.Translate('Venda Sap',(Net:HtmlOk*0)+(Net:UnsafeHtmlOk*0))&'</div>')
      end
      packet.append(p_web.DivHeader('Browsevendas_ven:VendaSap_'&ven:Reg,' nt-flex nt-browse-data',net:crc,,loc:extra))
      packet.append( p_web.CreateHyperLink(p_web._jsok(Left(p_web.FormatValue(ven:VendaSap,'@s11')),(Net:HtmlOk*0)+(Net:UnsafeHtmlOk*0)),,,,loc:javascript,,,(Net:HtmlOk*0)+(Net:UnsafeHtmlOk*0),,,'Browsevendas'))
    End
    packet.append(p_web.DivFooter(Net:NoSend))
    if loc:eip = 1
      do SendPacket
    end
! ----------------------------------------------------------------------------------------
value::ven:Quantidade  Routine
  data
loc:extra          String(252)
loc:disabled       String(20)
loc:FormOk         Long(1)
loc:options        StringTheory ! options for jQuery calls
loc:fieldClass     String(252)
loc:javascript     String(JavascriptStringLen)
loc:ok             Long
loc:abbreviate     Long
loc:FilterA         StringTheory
  code
    if false
    else ! default settings for browse column
      loc:extra = ''
      if loc:LayoutMethod <> net:Table
        packet.append('<div class="' & p_web.Combine('nt-browse-grid-cell-prompt',' nt-flex nt-browse-data',,) & '">'&p_web.Translate('Quantidade',(Net:HtmlOk*0)+(Net:UnsafeHtmlOk*0))&'</div>')
      end
      packet.append(p_web.DivHeader('Browsevendas_ven:Quantidade_'&ven:Reg,' nt-flex nt-browse-data',net:crc,,loc:extra))
      packet.append( p_web.CreateHyperLink(p_web._jsok(Left(p_web.FormatValue(ven:Quantidade,'@n-14')),(Net:HtmlOk*0)+(Net:UnsafeHtmlOk*0)),,,,loc:javascript,,,(Net:HtmlOk*0)+(Net:UnsafeHtmlOk*0),,,'Browsevendas'))
    End
    packet.append(p_web.DivFooter(Net:NoSend))
    if loc:eip = 1
      do SendPacket
    end
! ----------------------------------------------------------------------------------------
value::Copy  Routine
  data
loc:extra          String(252)
loc:disabled       String(20)
loc:FormOk         Long(1)
loc:options        StringTheory ! options for jQuery calls
loc:fieldClass     String(252)
loc:javascript     String(JavascriptStringLen)
loc:ok             Long
loc:abbreviate     Long
loc:FilterA         StringTheory
  code
    if false
    else ! default settings for browse column
      loc:extra = ''
      packet.append(p_web.DivHeader('Browsevendas_Copy_'&ven:Reg,' nt-flex nt-browse-data',net:crc,,loc:extra))
          If loc:viewonly = 0
             packet.append(p_web.CreateStdBrowseButton(Net:Web:SmallCopyButton,'Browsevendas',loc:field,false,loc:FormPopup,'Updatevendas')  & p_web.CRLF)
          End
    End
    packet.append(p_web.DivFooter(Net:NoSend))
    if loc:eip = 1
      do SendPacket
    end
! ----------------------------------------------------------------------------------------
value::Change  Routine
  data
loc:extra          String(252)
loc:disabled       String(20)
loc:FormOk         Long(1)
loc:options        StringTheory ! options for jQuery calls
loc:fieldClass     String(252)
loc:javascript     String(JavascriptStringLen)
loc:ok             Long
loc:abbreviate     Long
loc:FilterA         StringTheory
  code
    if false
    else ! default settings for browse column
      loc:extra = ''
      packet.append(p_web.DivHeader('Browsevendas_Change_'&ven:Reg,' nt-flex nt-browse-data',net:crc,,loc:extra))
          If loc:viewonly = 0
             packet.append(p_web.CreateStdBrowseButton(Net:Web:SmallChangeButton,'Browsevendas',loc:field,false,loc:FormPopup,'Updatevendas')  & p_web.CRLF)
          End
    End
    packet.append(p_web.DivFooter(Net:NoSend))
    if loc:eip = 1
      do SendPacket
    end
! ----------------------------------------------------------------------------------------
value::Delete  Routine
  data
loc:extra          String(252)
loc:disabled       String(20)
loc:FormOk         Long(1)
loc:options        StringTheory ! options for jQuery calls
loc:fieldClass     String(252)
loc:javascript     String(JavascriptStringLen)
loc:ok             Long
loc:abbreviate     Long
loc:FilterA         StringTheory
  code
    if false
    else ! default settings for browse column
      loc:extra = ''
      packet.append(p_web.DivHeader('Browsevendas_Delete_'&ven:Reg,' nt-flex nt-browse-data',net:crc,,loc:extra))
          If loc:viewonly = 0
            packet.append(p_web.CreateStdBrowseButton(Net:Web:SmallDeleteButton,'Browsevendas',loc:field,false,loc:FormPopup,'Updatevendas')  & p_web.CRLF)
          End
    End
    packet.append(p_web.DivFooter(Net:NoSend))
    if loc:eip = 1
      do SendPacket
    end
! ----------------------------------------------------------------------------------------
value::Select  Routine
  data
loc:extra          String(252)
loc:disabled       String(20)
loc:FormOk         Long(1)
loc:options        StringTheory ! options for jQuery calls
loc:fieldClass     String(252)
loc:javascript     String(JavascriptStringLen)
loc:ok             Long
loc:abbreviate     Long
loc:FilterA         StringTheory
  code
    if false
    else ! default settings for browse column
      loc:extra = ''
      packet.append(p_web.DivHeader('Browsevendas_Select_'&ven:Reg,' nt-flex nt-browse-data',net:crc,,loc:extra))
        packet.append(p_web.CreateStdBrowseButton(Net:Web:SmallSelectButton,'Browsevendas',loc:field,,loc:popup))
    End
    packet.append(p_web.DivFooter(Net:NoSend))
    if loc:eip = 1
      do SendPacket
    end
OpenFiles  ROUTINE
  FilesErrorOnOpen.SetValue('')
  FilesOpened = True
!--------------------------------------
CloseFiles ROUTINE
  IF FilesOpened THEN
     FilesOpened = False
  END
!--------------------------------------
SendPacket  routine
  p_web.ParseHTML(packet, 1, 0, NET:NoHeader)
  packet.SetValue('')
CheckForDuplicate  Routine
  If loc:invalid <> '' then exit. ! no need to check, record is already invalid
  If Duplicate(ven:PRIMARY)
    loc:Invalid = 'ven:Reg'
    if not loc:alert then loc:Alert = clip(p_web.site.DuplicateText) & ' PRIMARY --> ven:Reg = ' & clip(ven:Reg).
  End
SetSelection  Routine
  loc:ActualSelection = loc:field
  p_web.SetSessionValue('ven:Reg',ven:Reg)

Totals  Routine
  If Loc:Found = 0 then exit.

AddPacket  Routine
  If packet.Length() = 0 then exit.
  TableQueue.Row = packet.GetValue()
  TableQueue.Sub = loc:RowsIn
  if loc:direction > 0
    add(TableQueue)
  else
    add(TableQueue,loc:first + loc:RowsIn)
  end
  packet.SetValue('')
  If TableQueue.Kind = Net:RowData
    Loc:RowNumber += 1
  End

SendQueue  Routine
  data
ix  long
iy  long
  code
  if loc:ParentSilent = 0
    If loc:ActualSelection = ''
      p_web.GetBrowseValue(loc:DefaultSelection,Net:Web:Record+Net:Web:SessionQueue) ! so children are primed with correct sessionValue, and whole record is loaded in call to SetSelection
      loc:Field = loc:DefaultSelection                                               ! want this set for the call to SetSelection
      do SetSelection
    End
    loc:section = Net:RowTable
    do SendSection
    if loc:found
      if p_web.RequestJson = 0
        if loc:LayoutMethod = net:Table
          packet.append('<thead class="'&p_web.combine(p_web.site.style.BrowseHeader,'')&'">' & p_web.CRLF)
        end
      else
        packet.append('"head":{{ "class":"'&p_web.combine(p_web.site.style.BrowseHeader,'')&'",' & p_web.CRLF)
      end
      loc:section = Net:RowHeader
      do SendSection
      if packet.length() = 0                   ! if it comes back blank, it's been sent, so send the closing tag.
        If p_web.RequestJson = 0
          if loc:LayoutMethod = net:Table
            packet.append('</thead>' & p_web.CRLF)
          End
        Else
          packet.append('},' & p_web.CRLF)
        End
        do SendPacket
      end
    end
    packet.setvalue('')
    if loc:LayoutMethod = net:Table
      do SendFooterSection
    end
    If p_web.RequestJson = 0
      if loc:LayoutMethod = net:Table
        packet.append('<tbody class="' & p_web.combine(p_web.site.style.BrowseBody,) & '" data-elem="browse-body">' & p_web.CRLF)
      else
        packet.append('<div class="' & p_web.combine(p_web.site.style.BrowseBody,' nt-browse-grid-body', ) & '" data-elem="browse-body">' & p_web.CRLF)
      end
    else
      packet.append('"body":{{"class":"'&p_web.combine(p_web.site.style.BrowseBody,)&'","rows": [ ' )
    end
    do SendPacket
    loc:section = Net:PreRowData
    do SendSection
    loc:section = Net:RowData
    do SendSection
    if p_web.RequestJson = 0
      If loc:LayoutMethod = net:Table
        packet.append('</tbody>'& p_web.CRLF)
      else
        packet.append('</div>'& p_web.CRLF)
      End
    else
      packet.append(']}'& p_web.CRLF)
    end
    do SendPacket
    if loc:LayoutMethod <> net:Table
      do SendFooterSection
    end
  end

SendFooterSection  Routine
  If p_web.RequestJson = 0
    if loc:LayoutMethod = net:Table
      packet.append('<tfoot class="'&p_web.combine(p_web.site.style.BrowseFoot,)&'">' & p_web.CRLF)
    end
  Else
    packet.append('"foot":{{ "class":"'&p_web.combine(p_web.site.style.BrowseFoot,)&'",' & p_web.CRLF)
  End
  loc:section = Net:RowFooter
  do SendSection
  if packet.Length() = 0                   ! if it comes back blank, it's been sent, so send the closing tag.
    If p_web.RequestJson = 0
      if loc:LayoutMethod = net:Table
        packet.append('</tfoot>' & p_web.CRLF)
      end
    Else
      packet.append('},' & p_web.CRLF)
    End
    do SendPacket
  end
  packet.setvalue('')

SendSection  Routine
  DATA
loc:counter  Long
loc:r  Long
  CODE
  Loop loc:counter = 1 to records(TableQueue)
    get(TableQueue,loc:counter)
    if TableQueue.Kind = loc:section
      if loc:r = 0 then do SendPacket. ! <head> and <foot> come in "suspended"
      packet.append(clip(TableQueue.Row))
      do SendPacket
      loc:r += 1
    End
  End
  if(loc:FileLoading=Net:PageLoad)
  End
Updatevendas         PROCEDURE  (NetWebServerWorker p_web,long p_stage=0)
! the 'pre' routines are called when the form _opens_
! the 'post' routines are called when the 'save' or 'cancel' or 'delete' button is pressed
! remember this will happen on 2 separate threads. So use the SessionQueue here
! if you want to carry information from the pre, to the post, stage.

! there are many stages in the form
!   NET:WEB:StagePre which is called when the form _opens_
!   NET:WEB:StageValidate which is called when the form _closes_, before the record is written
!   NET:WEB:StagePost which is called _after_ the record is written
Ans                  LONG                                  !
FilesOpened       Long
FilesErrorOnOpen  StringTheory
vendas::State  USHORT
ven:TipoVenda:IsInvalid  Long
ven:VendaSap:IsInvalid  Long
ven:Quantidade:IsInvalid  Long
loc:TabStyle               Long
loc:WebStyle               Long,over(loc:TabStyle)
loc:TabTo                  Long
loc:viewonly               Long
loc:silent                 Long
loc:formname               string(252)
loc:procedure              string(252)
loc:formaction             string(252)
loc:formactioncancel       string(252)
loc:formactioncanceltarget string(252)
loc:formactiontarget       string(252)
loc:extra                  string(252)
loc:capture                long
loc:AcceptTypes            String(252)
loc:autocomplete           String(20)
loc:enctype                string(252)
loc:javascript             string(JavascriptStringLen)
loc:tabs                   string(252)
loc:readonly               String(32)
loc:lookuponly             String(32)
loc:invalid                String(100)
loc:alert                  String(1024)
loc:comment                String(252)
loc:prompt                 String(1024)
loc:invalidtab             Long
loc:tabnumber              Long
loc:retrying               Long
loc:lookupdone             Long
loc:tabheight              Long
loc:action                 string(40)
loc:act                    Long
loc:width                  String(40)
loc:rowstyle               String(252)
loc:buttonset              String(64)
loc:even                   Long
loc:columncounter          Long
loc:maxcolumns             Long
loc:rowstarted             Long
loc:cellstarted            Long
loc:FirstInCell            Long
loc:options                StringTheory ! options for jQuery calls
loc:popup                  long
loc:inNetWebPopup          long
loc:poppedup               long
loc:ok                     long
loc:parent                 string(252)   ! should always be a lower-case string
loc:heading                string(1024)
loc:fieldclass             string(StyleStringSize)
loc:frontloading           long
loc:noFocus                long
loc:FormOnSave             long
packet                       StringTheory
  CODE
  loc:procedure = lower('Updatevendas')
  GlobalErrors.SetProcedureName('Updatevendas')
  if p_stage = 0 and p_web.GetValue('_CallPopups') <> 0
    p_stage = Net:Web:Popup ! required for forms in DLL's, where PreCall doesn't know it's a form.
  elsif p_stage = 0 and p_Web.Ajax = 1
    case lower(p_web.Event)
    of 'gainfocus'
      p_stage = Net:Web:FocusBack
    of 'parentupdated'
      loc:noFocus = true ! the form regenerates, but nothing gets focus.
    end
  end
  loc:formname = lower('Updatevendas_frm')
  loc:parent = p_web.PlainText(lower(p_web.GetValue('_parentProc_')))
  loc:popup = p_web.GetValue('_popup_')
  loc:FormOnSave = Net:CloseForm
  loc:silent = p_web.GetValue('_silent_')

  loc:TabStyle = p_web.site.WebFormStyle
  do SetAction
  ans = band(p_stage,255)
  case p_stage
  of net:web:Generate
    if loc:silent = false
      if p_web.Event = 'parentnewselection' or  p_web.GetValue('Updatevendas:parentIs') = 'Browse' ! allow for form used as a child of a browse, default to change mode.
        p_web.FormReady('Updatevendas','Change','ven:Reg',p_web.GetSessionValue('ven:Reg'))
      Else
        p_web.FormReady('Updatevendas','')
      End
    End
    if p_web.site.frontloaded and p_web.Ajax and loc:popup = 1
      loc:FrontLoading = net:GeneratingData
    else
      If p_web.site.ContentBody <> '' and lower(p_web.GetValue('_cb_')) = lower('Updatevendas')
        p_web.DivHeader(p_web.site.ContentBody,p_web.site.contentbodydivclass)
      End
      p_web.DivHeader('Updatevendas',p_web.combine(p_web.site.style.formdiv,))
      p_web.DivHeader('Updatevendas_alert',p_web.combine(p_web.site.MessageClass,' nt-hidden'))
      p_web.DivFooter()
    End
    do SetPics
    if loc:FrontLoading = net:GeneratingData
      do GenerateData
    else
      do GenerateForm
      p_web.DivFooter()
      If p_web.site.ContentBody <> '' and lower(p_web.GetValue('_cb_')) = lower('Updatevendas')
        p_web.DivFooter()
      End
    End
  of Net:Web:SetPics
  orof Net:Web:SetPics + NET:WEB:StageValidate
    do SetPics

  of Net:Web:MakeReady

  of Net:Web:Init
  orof Net:Web:Init + Net:InsertRecord
  orof Net:Web:Init + Net:ChangeRecord
  orof Net:Web:Init + Net:CopyRecord
  orof Net:Web:Init + Net:ViewRecord
  orof Net:Web:Init + Net:DeleteRecord
    do InitForm

  of Net:Web:FocusBack
    do GotFocusBack

  of net:web:popup
    loc:inNetWebPopup = 1
    loc:poppedup = p_web.GetValue('_Updatevendas:_poppedup_')
    if p_web.site.FrontLoaded then loc:popup = 1.
    if loc:poppedup = 0 and p_Web.Ajax = 0
      If p_web.GetPreCall('Updatevendas') = 0 and (p_web.GetValue('_CallPopups') = 0 or p_web.GetValue('_CallPopups') = 1)
        p_web.AddPreCall('Updatevendas')
        p_web.DivHeader('popup_Updatevendas','nt-hidden',,,,1,,,'popup_Updatevendas')
        p_web.DivHeader('Updatevendas',p_web.combine(p_web.site.style.formdiv,),,,,1)
        If p_web.site.FrontLoaded
          loc:frontloading = net:GeneratingPage
          do GenerateForm
        End
        p_web.DivFooter()
        p_web.DivFooter(,lower('popup_Updatevendas End'))
        do Heading
        loc:options.Free(True)
        p_web.SetOption(loc:options,'close','function(event, ui) {{ ntd.pop(); }')
        p_web.SetOption(loc:options,'autoOpen','false')
        p_web.SetOption(loc:options,'width','95%')
        p_web.SetOption(loc:options,'modal','true')
        p_web.SetOption(loc:options,'title',loc:Heading)
        p_web.SetOption(loc:options,'position','[''center'','& clip(15)&']')
        p_web.SetOption(loc:options,'addsec','')
        If p_web.site.DefaultFormOpenAnimation
          p_web.SetOption(loc:options,'show','{{' & clip(p_web.site.DefaultFormOpenAnimation) & '}')
        End
        If p_web.site.DefaultFormCloseAnimation
          p_web.SetOption(loc:options,'hide','{{' & clip(p_web.site.DefaultFormCloseAnimation) & '}')
        End
        p_web.SetOption(loc:options,'closeText',p_web.translate(p_web.site.CloseButton.TextValue))
        p_web.jQuery('#' & lower('popup_Updatevendas_div'),'dialog',loc:options,'.removeClass("nt-hidden")')
      End
      do popups ! includes all the other popups dependant on this procedure
      loc:poppedup = 1
      p_web.SetValue('_Updatevendas:_poppedup_',1)
    end

  of Net:Web:AfterLookup + Net:Web:Cancel
    loc:LookupDone = 0
    do AfterLookup
    if p_web.Ajax = 1 and loc:popup
      p_web.script('$(''#popup_'&lower('Updatevendas')&'_div'').dialog(''close'');')
    end

  of Net:Web:AfterLookup
    loc:LookupDone = 1
    do AfterLookup

  of Net:Web:Cancel
    do CancelForm
    if p_web.Ajax = 1 and loc:popup
      p_web.script('$(''#popup_'&lower('Updatevendas')&'_div'').dialog(''close'');')
    end

  of Net:InsertRecord + NET:WEB:StagePre
    if p_web._InsertAfterSave = 0
      p_web.setsessionvalue('SaveReferUpdatevendas',p_web.getPageName(p_web.RequestReferer))
    end
    do StoreMem
    do PreInsert
  of Net:InsertRecord + NET:WEB:StageValidate
    do RestoreMem
    do ValidateInsert
  of Net:InsertRecord + NET:WEB:StagePost
    do RestoreMem
    do PostInsert
  of Net:InsertRecord + NET:WEB:Populate
    do OpenFiles
    do InitForm
    do PreInsert
    do CloseFiles
  of Net:CopyRecord + NET:WEB:StagePre
    p_web.setsessionvalue('SaveReferUpdatevendas',p_web.getPageName(p_web.RequestReferer))
    do StoreMem
    do PreCopy
  of Net:CopyRecord + NET:WEB:StageValidate
    do RestoreMem
    do ValidateCopy
  of Net:CopyRecord + NET:WEB:StagePost
    do RestoreMem
    do PostCopy
  of Net:CopyRecord + NET:WEB:Populate
    If p_web.IfExistsValue('ven:Reg') = 0 then p_web.SetValue('ven:Reg',p_web.GetSessionValue('ven:Reg')).
    do PreCopy
    p_web.setsessionvalue('showtab_Updatevendas',0)
  of Net:ChangeRecord + NET:WEB:StagePre
    p_web.setsessionvalue('SaveReferUpdatevendas',p_web.getPageName(p_web.RequestReferer))
    do StoreMem
    do PreUpdate
    p_web.setsessionvalue('showtab_Updatevendas',0)
  of Net:ChangeRecord + NET:WEB:StageValidate
    do RestoreMem
    If false
    ElsIf loc:act = Net:InsertRecord
      do ValidateInsert
    ElsIf loc:act = Net:CopyRecord
      do ValidateCopy
    Else
      do ValidateUpdate
    End
  of Net:ChangeRecord + NET:WEB:StagePost
    do RestoreMem
    If false
    ElsIf loc:act = Net:InsertRecord
      do PostInsert
    ElsIf loc:act = Net:CopyRecord
      do ValidateCopy
    Else
      do PostUpdate
    End
  of Net:ChangeRecord + NET:WEB:Populate
    If p_web.IfExistsValue('ven:Reg') = 0 then p_web.SetValue('ven:Reg',p_web.GetSessionValue('ven:Reg')).
    do OpenFiles
    do InitForm
    do PreUpdate
    do CloseFiles
    p_web.setsessionvalue('showtab_Updatevendas',0)
  of Net:DeleteRecord + NET:WEB:StagePre
    p_web.setsessionvalue('SaveReferUpdatevendas',p_web.getPageName(p_web.RequestReferer))
    do StoreMem
    do PreDelete
  of Net:DeleteRecord + NET:WEB:StageValidate
    do RestoreMem
    do ValidateDelete
  of Net:DeleteRecord + NET:WEB:StagePost
    do RestoreMem
    do PostDelete
  of Net:ViewRecord + NET:WEB:Populate
    If p_web.IfExistsValue('ven:Reg') = 0 then p_web.SetValue('ven:Reg',p_web.GetSessionValue('ven:Reg')).
    do OpenFiles
    do InitForm
    do PreUpdate
    p_web.setsessionvalue('showtab_Updatevendas',0)
    do CloseFiles

  of Net:ViewRecord + NET:WEB:StagePre
    p_web.setsessionvalue('SaveReferUpdatevendas',p_web.getPageName(p_web.RequestReferer))
    do StoreMem
    do PreUpdate
    p_web.setsessionvalue('showtab_Updatevendas',0)
  of Net:Web:NextTab
    do NextTab
  of Net:Web:Div
    If p_web.site.FrontLoaded
      loc:frontloading = net:GeneratingData
    End
    do CallDiv
  Else
    ans = 0
  End ! Case
  If Loc:Invalid
    Ans = Net:Web:InvalidRecord
      p_web.requestfilename = p_web.formsettings.parentpage
      if p_web.GetValue('_parentPage') = ''
        p_web.SetValue('_parentPage',p_web.requestfilename)
      End
    p_web.SetValue('retryfield',Loc:Invalid)
    p_web.setsessionvalue('showtab_Updatevendas',Loc:InvalidTab)
  ElsIf band(p_stage,NET:WEB:StageValidate) > 0 and band(p_stage,Net:DeleteRecord) <> Net:DeleteRecord and band(p_stage,Net:WriteMask) > 0 and p_web.Ajax = 1 and loc:popup
    If p_web.IfExistsValue('_stayopen_')
    ! only a partial save, so don't complete the form.
    ElsIf loc:FormOnSave = Net:InsertAgain
      If band(loc:act,Net:InsertRecord) <> Net:InsertRecord
        p_web.script('$(''#popup_'&lower('Updatevendas')&'_div'').dialog(''close'');')
      End
    Else
      p_web.script('$(''#popup_'&lower('Updatevendas')&'_div'').dialog(''close'');')
    End
  End
  if loc:alert <> ''
    p_web.SetAlert(loc:alert, net:Alert + Net:Message,'Updatevendas',1)
  end
  GlobalErrors.SetProcedureName()
  return Ans

OpenFiles  ROUTINE
  FilesErrorOnOpen.SetValue('')
  If p_web.OpenFile(vendas) <> 0
    FilesErrorOnOpen.Append('vendas',st:clip,',')
  End
  FilesOpened = True
!--------------------------------------
CloseFiles ROUTINE
  IF FilesOpened THEN
  p_Web.CloseFile(vendas)
     FilesOpened = False
  END

AlertParent  routine
  DATA
parent_       string(100)
parentrid_    string(100)
  CODE
  p_web.pushEvent('childupdated')
  parent_ = p_web.GetValue('_ParentProc_')
  If loc:Parent
    p_web.SetValue('_ParentProc_','')
    p_web.PageName = clip(loc:parent) & '_' & lower('Updatevendas') & '_value'
    p_web._SendFile(p_web.PageName)
  Elsif p_web.formsettings.parentpage
    parentrid_ = p_web.GetValue('_parentrid_')
    p_web.SetValue('_ParentProc_','')
    p_web.SetValue('_parentrid_')
    p_web.PageName = clip(p_web.formsettings.parentpage) & '_' & lower('Updatevendas') & '_value'
    p_web._SendFile(p_web.PageName)
    p_web.SetValue('_parentrid_',parentrid_)
  End
  p_web.SetValue('_ParentProc_',parent_)
  p_web.popEvent()

GotFocusBack  routine
  DATA
loc:Equate  string(252)
loc:Done    long
  CODE

InitForm       Routine
  DATA
LF  &FILE
  CODE
  p_web.SetValue('Updatevendas_form:inited_',1)
  p_web.formsettings.file = 'vendas'
  p_web.formsettings.key = 'ven:PRIMARY'
  do RestoreMem

SetFormSettings  routine
  data
  code
  If p_web.Formstate = ''
    p_web.formsettings.file = 'vendas'
    p_web.formsettings.key = 'ven:PRIMARY'
      clear(p_web.formsettings.FieldName)
    p_web.formsettings.recordid[1] = ven:Reg
    p_web.formsettings.FieldName[1] = 'ven:Reg'
    do SetAction
    if p_web.GetSessionValue('Updatevendas:Primed') = 1 or Ans = 2
      p_web.formsettings.action = Net:ChangeRecord
    Else
      p_web.formsettings.action = Loc:Act
    End
    p_web.formsettings.OriginalAction = Loc:Act
    If p_web.GetValue('_parentPage') <> ''
      p_web.formsettings.parentpage = p_web.GetValue('_parentPage')
    else
      p_web.formsettings.parentpage = 'Updatevendas'
    end
    p_web.formsettings.proc = 'Updatevendas'
    clear(p_web.formsettings.target)
    p_web.FormState = p_web.AddSettings()
  end

CancelForm  Routine
  IF p_web.GetSessionValue('Updatevendas:Primed') = 1
    p_web.DeleteFile(vendas)
    p_web.SetSessionValue('Updatevendas:Primed',0)
  End
  p_web.SetSessionValue('Updatevendas:Active',0)

SendMessage Routine
  p_web.Message('Alert',loc:alert,p_web.site.MessageClass,Net:Send,1)

SetPics        Routine
  p_web.SetValue('UpdateFile','vendas')
  p_web.SetValue('UpdateKey','ven:PRIMARY')
  If p_web.IfExistsValue('ven:TipoVenda')
    p_web.SetPicture('ven:TipoVenda','@s11')
  End
  p_web.SetSessionPicture('ven:TipoVenda','@s11')
  If p_web.IfExistsValue('ven:VendaSap')
    p_web.SetPicture('ven:VendaSap','@s11')
  End
  p_web.SetSessionPicture('ven:VendaSap','@s11')
  If p_web.IfExistsValue('ven:Quantidade')
    p_web.SetPicture('ven:Quantidade','@n-14')
  End
  p_web.SetSessionPicture('ven:Quantidade','@n-14')

AfterLookup Routine
  loc:TabNumber = -1
    loc:TabNumber += 1
  p_web.DeleteValue('LookupField')

StoreMem  Routine

! RestoreMem primes all the non-file fields with their session value. Useful in Validate and PostAction routines
RestoreMem  Routine
  !FormSource=File

SetAction  routine
  data
  code
  If Band(p_Stage,Net:ViewRecord) = Net:ViewRecord
    Loc:ViewOnly = true
    loc:action = p_web.site.ViewPromptText
    loc:act = Net:ViewRecord
    p_web.SetValue('_viewonly_',1) ! cascade ViewOnly mode to child procedures
    p_web.SetSessionValue('Updatevendas_CurrentAction',Net:ViewRecord)
  Else
    Case p_web.GetSessionValue('Updatevendas_CurrentAction')
    of Net:InsertRecord
      loc:action = p_web.site.InsertPromptText
      loc:act = Net:InsertRecord
    of Net:CopyRecord
      loc:action = p_web.site.CopyPromptText
      loc:act = Net:CopyRecord
    of Net:ChangeRecord
      loc:action = p_web.site.ChangePromptText
      loc:act = Net:ChangeRecord
    of Net:DeleteRecord
      loc:action = p_web.site.DeletePromptText
      loc:act = Net:DeleteRecord
    of Net:ViewRecord
      Loc:ViewOnly = true
      loc:action = p_web.site.ViewPromptText
      loc:act = Net:ViewRecord
    Else
      loc:action = ''
      loc:act = 0
    End
  End

SetFormAction  routine
  data
  code
  loc:FormAction = p_web.GetValue('onsave')
  If loc:formaction = 'stay'
    loc:FormAction = p_web.Requestfilename
  Else
    loc:formaction = p_web.getsessionvalue('SaveReferUpdatevendas')
  End
  if p_web.GetValue('_ChainToPage_') <> ''
    loc:formaction = p_web.GetValue('_ChainToPage_')
    p_web.SetSessionValue('Updatevendas_ChainTo',loc:FormAction)
    loc:formactiontarget = '_self'
  ElsIf p_web.IfExistsSessionValue('Updatevendas_ChainTo')
    loc:formaction = p_web.GetSessionValue('Updatevendas_ChainTo')
    loc:formactiontarget = '_self'
  End
  If loc:FormActionTarget = ''
    loc:FormActionTarget = '_self'
  End
  If loc:formaction = ''
    loc:formaction = lower(p_web.getPageName(p_web.RequestReferer))
  End
  loc:FormActionCancel = loc:FormAction
  If loc:FormActionCancelTarget = ''
    loc:FormActionCancelTarget = '_self'
  End

! front-loaded forms only need the fields updated - not the structure generated.
! this routine is called when loc:frontloaded = net:GeneratingData
GenerateData  routine
  data
loc:send     StringTheory
loc:checked  String(50)
  code
  do Refresh::ven:TipoVenda
  do Refresh::ven:VendaSap
  do Refresh::ven:Quantidade
  p_web.Script('$(''#'&clip(loc:formname)&''').find(''#FormState'').val('''&clip(p_web.FormState)&''');' & p_web.CRLF)
  p_web.ntForm(loc:formname,'show')

GenerateForm  Routine
  data
loc:disabled  Long
  code
  p_web.ClearBrowse('Updatevendas')
  do LoadRelatedRecords
  do SetFormAction
  do ntForm
  If p_web.IfExistsValue('retryField')
    loc:retrying = 1
  End
  loc:viewonly = Choose(p_web.IfExistsValue('View_btn'),1,loc:viewonly)
  p_web.SetValue('_viewonly_',loc:viewonly)
  packet.append('<form action="'&clip(loc:formaction)&'" '&clip(loc:enctype)&' method="post" name="'&clip(loc:formname)&'" id="'&clip(loc:formname)&'" target="'&clip(loc:FormActionTarget)&'" onsubmit="osf(this);">' & p_web.CRLF)
  if loc:viewonly and p_web.IfExistsValue('LookupField')
    packet.append(p_web.CreateInput('hidden','LookupField',p_web.GetValue('LookupField'))  & p_web.CRLF)
  end
  packet.append(p_web.CreateInput('hidden','FormState',p_web.FormState)  & p_web.CRLF)
  do SendPacket
  do Heading
    Case loc:TabStyle
    of Net:Web:Carousel
    packet.append(p_web.DivHeader('Tab_Updatevendas',p_web.combine(p_web.site.style.FormTabOuter,,' nt-tab-carousel'),Net:NoSend))
    Else
    packet.append(p_web.DivHeader('Tab_Updatevendas',p_web.combine(p_web.site.style.FormTabOuter,),Net:NoSend))
    End
    Case loc:TabStyle
    of Net:Web:Tab
      packet.append('<ul class="'&p_web.combine(p_web.site.style.FormTabTitle,)&'">'& p_web.CRLF)
      packet.append('<li><a href="#' & lower('tab_Updatevendas0_div') & '">' & p_web.Translate('General',true)&'</a></li>'& p_web.CRLF)
      packet.append('</ul>'& p_web.CRLF)
    end
    do SendPacket
  if p_web.event = 'callpopups'
    p_web.PushEvent('callpopups')
  else
    p_web.PushEvent('generate')
  end
  do GenerateTab0
  packet.append(p_web.DivFooter(Net:NoSend))
  do SendPacket
  p_web.PopEvent()
      if loc:ViewOnly = 0
        packet.append('<div id="Updatevendas_saveset" class="'&p_web.combine(p_web.site.style.FormSaveButtonSet,)&'">')
        If loc:TabStyle = Net:Web:Wizard
          loc:javascript = ''
          packet.append(p_web.CreateStdButton('button',NET:WEB:WizPreviousButton,loc:formname,,,loc:javascript,,,,'Updatevendas')) !f1
          packet.append(p_web.CreateStdButton('button',NET:WEB:WizNextButton,loc:formname,,,loc:javascript,,,,'Updatevendas')) !f2
        End
        loc:javascript = ''
        packet.append(p_web.CreateStdButton('button',Net:Web:SaveButton,loc:formname,,,loc:javascript,,loc:disabled,,'Updatevendas',1)) !f3
        loc:javascript = ''
        if loc:popup
          packet.append(p_web.CreateStdButton('button',Net:Web:CancelButton,loc:formname,,,loc:javascript,,,,'Updatevendas')) !f5
        else
          packet.append(p_web.CreateStdButton('button',Net:Web:CancelButton,loc:formname,,,loc:javascript,,,,'Updatevendas')) !f6
        end
        packet.append('</div>'  & p_web.CRLF) ! end id="Updatevendas_saveset"
        If p_web.site.UseSaveButtonSet
          loc:options.Free(True)
          p_web.jQuery('#' & 'Updatevendas_saveset','controlgroup',loc:options)
        End
      Else
        packet.append('<div id="Updatevendas_saveset" class="'&p_web.combine(p_web.site.style.FormSaveButtonSet,)&'">')
        If loc:TabStyle = Net:Web:Wizard
          loc:javascript = ''
          packet.append(p_web.CreateStdButton('button',NET:WEB:WizPreviousButton,loc:formname,,,loc:javascript,,,,'Updatevendas')) !f8
          packet.append(p_web.CreateStdButton('button',NET:WEB:WizNextButton,loc:formname,,,loc:javascript,,,,'Updatevendas')) !f9
        End
        loc:javascript = ''
        if loc:popup
          loc:javascript = clip(loc:javascript) & 'ntd.close();'
          packet.append(p_web.CreateStdButton('button',Net:Web:CloseButton,loc:formname,,,loc:javascript,,loc:disabled,,'Updatevendas')) !f10
        else
          packet.append(p_web.CreateStdButton('submit',Net:Web:CloseButton,loc:formname,loc:formactioncancel,loc:formactioncanceltarget,,,loc:disabled,,'Updatevendas')) !f11
        end
        packet.append('</div>' & p_web.CRLF)
        If p_web.site.UseSaveButtonSet
          loc:options.Free(True)
          p_web.jQuery('#' & 'Updatevendas_saveset','controlgroup',loc:options)
        End
      End
  if loc:retrying
    p_web.SetValue('SelectField',clip(loc:formname) & '.' & p_web.GetValue('retryfield'))
  Elsif p_web.IfExistsValue('Select_btn')
  Else
    If False
    Else ! If False
        If loc:noFocus = false
          p_web.SetValue('SelectField',clip(loc:formname) & '.ven:TipoVenda')
        End
    End ! If False
  End
    loc:options.Free(True)
    Case loc:TabStyle
    of Net:Web:Accordion
      p_web.SetOption(loc:options,'heightStyle','content')
      p_web.SetOption(loc:options,'active', choose(p_web.GetSessionValue('showtab_Updatevendas')>0,p_web.GetSessionValue('showtab_Updatevendas'),'0'))
      p_web.SetOption(loc:options,'activate', 'function(event, ui) {{ TabChanged(''Updatevendas_tabchanged'',$(this).accordion("option","active")); }')
      p_web.jQuery('#' & lower('Tab_Updatevendas') & '_div','accordion',loc:options)
    of Net:Web:Tab
      p_web.SetOption(loc:options,'activate','function(event,ui){{TabChanged(''Updatevendas_tabchanged'',$(this).tabs("option","active"));}')
      p_web.SetOption(loc:options,'active',choose(p_web.GetSessionValue('showtab_Updatevendas')>0,p_web.GetSessionValue('showtab_Updatevendas'),'0'))
      p_web.jQuery('#' & lower('Tab_Updatevendas') & '_div','tabs',loc:options)
    of Net:Web:Wizard
       p_web.SetOption(loc:options,'procedure','Updatevendas')
       p_web.SetOption(loc:options,'popup',loc:popup)
       p_web.SetOption(loc:options,'active',choose(p_web.GetSessionValue('showtab_Updatevendas')>0,p_web.GetSessionValue('showtab_Updatevendas'),0))
       p_web.SetOption(loc:options,'ntform', '#' & clip(loc:formname))
       p_web.ntWiz('Updatevendas',loc:options)
    of Net:Web:Carousel
       p_web.SetOption(loc:options,'dots','^true')
       p_web.SetOption(loc:options,'autoplay','^false')
       p_web.jQuery('#' & lower('tab_Updatevendas_div'),'slick',loc:options)
    end
    do SendPacket
  packet.append('</form>'&p_web.CRLF)
  do SendPacket
  loc:options.Free(True)
  do SendPacket
  If not (p_web.site.FrontLoaded and loc:frontloading = net:GeneratingPage) ! don't want to do popups here if generating in front-loaded mode from net:web:popup stage
    do Popups
  end
  if p_web.Ajax then do AutoLookups.

  do SendPacket

Popups  Routine
  If p_web.Ajax = 0
    p_web.PushEvent('callpopups')
    do AutoLookups
    p_web.AddPreCall('Updatevendas')
    p_web.SetValue('_popup_',0)
    p_web.PopEvent()
  End

ntForm Routine
  data
loc:BuildOptions                stringTheory
  code
  p_web.SetOption(loc:options,'id',clip(loc:formname))
  p_web.SetOption(loc:options,'procedure', lower('Updatevendas'))
  p_web.SetOption(loc:options,'parent', lower(clip(loc:parent)))
  p_web.SetOption(loc:options,'title',loc:Heading)
  p_web.SetOption(loc:options,'tabType', loc:TabStyle)
  p_web.SetOption(loc:options,'action', loc:formaction)
  p_web.SetOption(loc:options,'actionCancel', loc:formactioncancel)
  p_web.SetOption(loc:options,'actionCancelTarget',loc:formactioncanceltarget)
  p_web.SetOption(loc:options,'actionTarget', loc:formactiontarget)
  p_web.SetOption(loc:options,'confirmText',p_web.translate('Confirm'))
  p_web.SetOption(loc:options,'confirmDeleteMessage',p_web.translate('Are you sure you want to delete this record?'))
  p_web.SetOption(loc:options,'yesDeleteText',p_web.translate('Delete'))
  p_web.SetOption(loc:options,'noDeleteText',p_web.translate('No'))
  p_web.SetOption(loc:options,'confirmDelete',p_web.site.DefaultDeletePrompt)
  p_web.SetOption(loc:options,'confirmCancelMessage',p_web.translate('Are you sure you want to cancel the changes?'))
  p_web.SetOption(loc:options,'yesCancelText',p_web.translate('Cancel'))
  p_web.SetOption(loc:options,'noCancelText',p_web.translate('No'))
  p_web.SetOption(loc:options,'confirmCancel',p_web.site.DefaultCancelPrompt)
  p_web.SetOption(loc:options,'popup', loc:popup)
  p_web.SetOption(loc:options,'focus', p_web.focus)
  p_web.ntForm(loc:formname,loc:options)
  If loc:silent
    p_web.ntForm(loc:formname,'hide')
    ans = 0
  End

AutoLookups  Routine
GenerateTab0  Routine
      Case loc:TabStyle
      of Net:Web:Accordion
        packet.append('<h3 class="'&p_web.combine(p_web.site.style.FormTabTitle,)&'">'&p_web.Translate('General')&'</h3>' & p_web.CRLF & p_web.DivHeader('tab_Updatevendas0',p_web.combine(p_web.site.style.FormTabInner,,),Net:NoSend,,,1))
      of Net:Web:Tab
        packet.append(p_web.DivHeader('tab_Updatevendas0',p_web.combine(p_web.site.style.FormTabInner,,),Net:NoSend,,,1))
      of Net:Web:Wizard
        packet.append(p_web.DivHeader('tab_Updatevendas0',p_web.combine(clip(p_web.site.style.FormTabInner) & ' nt-wizard',,),Net:NoSend,,,1))
      of Net:Web:Carousel
        packet.append(p_web.DivHeader('tab_Updatevendas0',p_web.combine(clip(p_web.site.style.FormTabInner) & ' nt-carousel',,),Net:NoSend,,,1))
      of Net:Web:Rounded
        packet.append(p_web.DivHeader('tab_Updatevendas0',p_web.combine(clip(p_web.site.style.FormTabInner) & ' nt-rounded',,),Net:NoSend,,,1) & '<div class="ui-state-default nt-rounded-header ui-corner-all">' & p_web.Translate('General')&'</div>'& p_web.CRLF)
      of Net:Web:Plain
        packet.append(p_web.DivHeader('tab_Updatevendas0',p_web.combine(clip(p_web.site.style.FormTabInner) & ' nt-plain',,),Net:NoSend,,,1) & '<fieldset class="ui-tabs ui-widget ui-widget-content ui-corner-all plain"><legend>' & p_web.Translate('General')&'</legend>' & p_web.CRLF)
      of Net:Web:None
        packet.append(p_web.DivHeader('tab_Updatevendas0',p_web.combine(p_web.site.style.FormTabInner,,),Net:NoSend,,,1))
      end
      do SendPacket
      packet.append(p_web.FormTableStart('Updatevendas_container',,,Net:Default))
      do SendPacket
        if loc:rowstarted = 0
          packet.append(p_web.FormTableRowStart( p_web.NoColon(lower('ven:TipoVenda_row')) ,p_web.Combine(,),Net:Default))
          if loc:columncounter > loc:maxcolumns then loc:maxcolumns = loc:columncounter.
          loc:columncounter = 0
          loc:rowstarted = 1
        end
        do SendPacket
        loc:width = ''
        If loc:cellstarted = 0
          packet.append(p_web.FormTableCellStart( ,' nt-prompt-align-middle' , , , clip(loc:width) , Net:Default, net:CellTypePrompt))
          loc:columncounter += 1
          do SendPacket
          loc:cellstarted = 1
          loc:FirstInCell = 1
        Else
          loc:FirstInCell = 0
        End
        do Prompt::ven:TipoVenda
        If loc:FirstInCell = 1
          packet.append(p_web.FormTableCellEnd( ,Net:Default))
          loc:cellstarted = 0
          do SendPacket
        End
        if loc:cellstarted = 0
          loc:width = ''
          packet.append(p_web.FormTableCellStart( , , , , clip(loc:width) , Net:Default, net:CellTypeValue))
          loc:columncounter += 1
          do SendPacket
          loc:cellstarted = 1
        end
        do Value::ven:TipoVenda
        packet.append(p_web.FormTableCellEnd( ,Net:Default))
        loc:cellstarted = 0
          loc:width = ''
          packet.append(p_web.FormTableCellStart( , , , , clip(loc:width) , Net:Default, net:CellTypeComment))
          loc:columncounter += 1
          do SendPacket
          do Comment::ven:TipoVenda
          packet.append(p_web.FormTableCellEnd( ,Net:Default))
          loc:cellstarted = 0
          do SendPacket
        if loc:cellstarted
          packet.append(p_web.FormTableCellEnd( ,Net:Default))
          packet.append(p_web.FormTableRowEnd( ,Net:Default))
          loc:cellstarted = 0
        Else
          packet.append(p_web.FormTableRowEnd( ,Net:Default))
        End
        loc:rowstarted = 0
        loc:cellstarted = 0
      do SendPacket
        if loc:rowstarted = 0
          packet.append(p_web.FormTableRowStart( p_web.NoColon(lower('ven:VendaSap_row')) ,p_web.Combine(,),Net:Default))
          if loc:columncounter > loc:maxcolumns then loc:maxcolumns = loc:columncounter.
          loc:columncounter = 0
          loc:rowstarted = 1
        end
        do SendPacket
        loc:width = ''
        If loc:cellstarted = 0
          packet.append(p_web.FormTableCellStart( ,' nt-prompt-align-middle' , , , clip(loc:width) , Net:Default, net:CellTypePrompt))
          loc:columncounter += 1
          do SendPacket
          loc:cellstarted = 1
          loc:FirstInCell = 1
        Else
          loc:FirstInCell = 0
        End
        do Prompt::ven:VendaSap
        If loc:FirstInCell = 1
          packet.append(p_web.FormTableCellEnd( ,Net:Default))
          loc:cellstarted = 0
          do SendPacket
        End
        if loc:cellstarted = 0
          loc:width = ''
          packet.append(p_web.FormTableCellStart( , , , , clip(loc:width) , Net:Default, net:CellTypeValue))
          loc:columncounter += 1
          do SendPacket
          loc:cellstarted = 1
        end
        do Value::ven:VendaSap
        packet.append(p_web.FormTableCellEnd( ,Net:Default))
        loc:cellstarted = 0
          loc:width = ''
          packet.append(p_web.FormTableCellStart( , , , , clip(loc:width) , Net:Default, net:CellTypeComment))
          loc:columncounter += 1
          do SendPacket
          do Comment::ven:VendaSap
          packet.append(p_web.FormTableCellEnd( ,Net:Default))
          loc:cellstarted = 0
          do SendPacket
        if loc:cellstarted
          packet.append(p_web.FormTableCellEnd( ,Net:Default))
          packet.append(p_web.FormTableRowEnd( ,Net:Default))
          loc:cellstarted = 0
        Else
          packet.append(p_web.FormTableRowEnd( ,Net:Default))
        End
        loc:rowstarted = 0
        loc:cellstarted = 0
      do SendPacket
        if loc:rowstarted = 0
          packet.append(p_web.FormTableRowStart( p_web.NoColon(lower('ven:Quantidade_row')) ,p_web.Combine(,),Net:Default))
          if loc:columncounter > loc:maxcolumns then loc:maxcolumns = loc:columncounter.
          loc:columncounter = 0
          loc:rowstarted = 1
        end
        do SendPacket
        loc:width = ''
        If loc:cellstarted = 0
          packet.append(p_web.FormTableCellStart( ,' nt-prompt-align-middle' , , , clip(loc:width) , Net:Default, net:CellTypePrompt))
          loc:columncounter += 1
          do SendPacket
          loc:cellstarted = 1
          loc:FirstInCell = 1
        Else
          loc:FirstInCell = 0
        End
        do Prompt::ven:Quantidade
        If loc:FirstInCell = 1
          packet.append(p_web.FormTableCellEnd( ,Net:Default))
          loc:cellstarted = 0
          do SendPacket
        End
        if loc:cellstarted = 0
          loc:width = ''
          packet.append(p_web.FormTableCellStart( , , , , clip(loc:width) , Net:Default, net:CellTypeValue))
          loc:columncounter += 1
          do SendPacket
          loc:cellstarted = 1
        end
        do Value::ven:Quantidade
        packet.append(p_web.FormTableCellEnd( ,Net:Default))
        loc:cellstarted = 0
          loc:width = ''
          packet.append(p_web.FormTableCellStart( , , , , clip(loc:width) , Net:Default, net:CellTypeComment))
          loc:columncounter += 1
          do SendPacket
          do Comment::ven:Quantidade
          packet.append(p_web.FormTableCellEnd( ,Net:Default))
          loc:cellstarted = 0
          do SendPacket
        if loc:cellstarted
          packet.append(p_web.FormTableCellEnd( ,Net:Default))
          packet.append(p_web.FormTableRowEnd( ,Net:Default))
          loc:cellstarted = 0
        Else
          packet.append(p_web.FormTableRowEnd( ,Net:Default))
        End
        loc:rowstarted = 0
        loc:cellstarted = 0
      do SendPacket
      if loc:rowstarted and loc:cellstarted
        packet.append(p_web.FormTableCellEnd( ,Net:Default))
        packet.append(p_web.FormTableRowEnd( ,Net:Default))
        packet.append(p_web.FormTableEnd('Updatevendas_container',Net:Default))
        loc:cellstarted = 0
        loc:rowstarted = 0
      elsif loc:rowstarted
        packet.append(p_web.FormTableRowEnd( ,Net:Default))
        packet.append(p_web.FormTableEnd('Updatevendas_container',Net:Default))
        loc:rowstarted = 0
      else
        packet.append(p_web.FormTableEnd('Updatevendas_container',Net:Default))
      end
      do SendPacket
      Case loc:TabStyle
      of Net:Web:Plain
        packet.append('</fieldset>' & p_web.DivFooter(Net:NoSend,'tab_Updatevendas0'))
      else
        packet.append(p_web.DivFooter(Net:NoSend,'tab_Updatevendas0'))
      end
      do SendPacket
Heading  Routine
  data
loc:disabled  long
  code
  If p_web.GetValue('_title_') <> ''
    loc:Heading = p_web.Translate(p_web.GetValue('_title_'),(Net:HtmlOk*0)+(Net:UnsafeHtmlOk*0))
  Else
    loc:Heading = p_web.Translate('Update Vendas',(Net:HtmlOk*0)+(Net:UnsafeHtmlOk*0))
  End
  If loc:inNetWebPopup = 1 then exit.
  If loc:Heading
    if loc:popup
      p_web.SetPopupDialogHeading('Updatevendas',clip(loc:heading),(Net:HtmlOk*0)+(Net:UnsafeHtmlOk*0))
    else
      packet.append(lower('<div id="form-access-Updatevendas"></div>'))
        p_web.DivHeader('Updatevendas_header',p_web.combine(p_web.site.style.formheading,))
        packet.append(clip(loc:Heading))
        do SendPacket
        p_web.DivFooter()
    end
  End

Refresh::ven:TipoVenda  Routine
  do Prompt::ven:TipoVenda
  do Value::ven:TipoVenda
  do Comment::ven:TipoVenda

Prompt::ven:TipoVenda  Routine
  loc:fieldclass = Choose(not(1=0),p_web.combine(p_web.site.style.formprompt,,),'nt-hidden')
  If p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
  Else
    packet.append(p_web.DivHeader('Updatevendas_' & p_web.nocolon('ven:TipoVenda') & '_prompt',loc:fieldClass,Net:NoSend))
  End
  loc:prompt = Choose(1=0,'',p_web.Translate('Tipo Venda:'))
  If p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
    p_web.Script('$(''[for="'&p_web.nocolon('ven:TipoVenda')&'"]'').html("'&clip(loc:prompt)&'");')
  Else ! not front loaded
    packet.append('<label for="'&p_web.nocolon('ven:TipoVenda')&'">' & clip(loc:prompt) & '</label>')
    packet.append(p_web.DivFooter(Net:NoSend,,,0))
    do SendPacket
  End  ! front loaded

  omit('*** end of scripts ***')
  ! *** end of scripts ***

Validate::ven:TipoVenda Routine
  If p_web.Ajax = 1 and p_web.ifExistsValue('NewValue')
    ven:TipoVenda = p_web.GetValue('NewValue')
  ElsIf p_web.IfExistsValue('Value') !FormFieldPicture =   !FieldPicture = @s11
    ven:TipoVenda = p_web.DeformatValue(p_web.GetValue('Value'),'@s11')
  End
  do ValidateValue::ven:TipoVenda  ! copies value to session value if valid.

  p_web.PushEvent('parentupdated')
  do Refresh::ven:TipoVenda   ! Field is auto-validated
  do SendMessage
  p_web.ntForm(loc:formname,'ready') ! 8.67 (in case the form was not the originator of the Ajax call)
  p_web.PopEvent()

ValidateValue::ven:TipoVenda  Routine
      If loc:invalid = '' then p_web.SetSessionValue('ven:TipoVenda',ven:TipoVenda).

Value::ven:TipoVenda  Routine
  data
loc:fieldclass     string(StyleStringSize)
loc:extra          string(StyleStringSize)
loc:disabled       long
loc:saveCallPopups long
loc:counter        long
loc:Filter       StringTheory
  code
  loc:fieldclass = p_web.Combine(p_web.site.style.formentrydiv,,)
  loc:fieldclass = choose(not(1=0),loc:fieldclass,'nt-hidden ' & loc:fieldclass)
  If p_web.site.FrontLoaded = 0 or loc:frontloading = net:GeneratingPage
    p_web.DivHeader('Updatevendas_' & p_web.nocolon('ven:TipoVenda') & '_value',loc:fieldclass)
  End
  loc:fieldclass = ''
  loc:fieldclass = p_web.combine(p_web.site.style.formentry,,)
  If loc:viewonly
    loc:fieldclass = clip(loc:fieldclass) & ' ' & p_web.combine(p_web.site.style.formEntryReadOnly,)
  End
  If loc:retrying
    ven:TipoVenda = p_web.RestoreValue('ven:TipoVenda')
    do ValidateValue::ven:TipoVenda
    If ven:TipoVenda:IsInvalid then loc:fieldclass = clip(loc:fieldclass) & ' ' & p_web.combine(p_web.site.style.formEntryError,).
  End
  loc:extra = ''
  If Not (1=0)  ! SecFieldHideStateRtn
    p_web.site.HTMLEditor = p_web.site.DefaultHTMLEditor
    ! --- STRING --- ven:TipoVenda
    loc:AutoComplete = 'autocomplete="off"'
    loc:readonly = Choose(loc:viewonly,'readonly','')
      loc:extra = clip(loc:extra) & p_web.SetEntryWidth(,Net:Form)
    loc:javascript = ''  ! MakeFormJavaScript
    if p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
      p_web.Script('$(''#'&p_web.nocolon('ven:TipoVenda')&''').val('''&p_web._jsok(p_web.GetSessionValueFormat('ven:TipoVenda'))&''');')
    Else
      packet.append(p_web.CreateInput('text','ven:TipoVenda',p_web.GetSessionValueFormat('ven:TipoVenda'),loc:fieldclass,loc:readonly,clip(loc:extra) & ' ' & clip(loc:autocomplete),,loc:javascript,p_web.PicLength('@s11'),,'ven:TipoVenda',,'imm',,,,'Updatevendas')  & p_web.CRLF) !b
    End
    do SendPacket
  End
  if p_web.site.FrontLoaded = 0 or loc:frontloading = net:GeneratingPage
    p_web.DivFooter(,,,0)
  end

Comment::ven:TipoVenda  Routine
  data
loc:fieldclass string(StyleStringSize)
  code
  loc:fieldclass = p_web.Combine(p_web.site.style.formcomment,,)
  if ven:TipoVenda:IsInvalid
    loc:fieldclass = clip(loc:fieldclass) & ' ' & p_web.site.style.FormCommentError
  end
    loc:comment = ''
  loc:fieldclass = Choose(not(1=0),loc:fieldclass,'nt-hidden ' & loc:fieldclass)
  If p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
  else
    packet.append(p_web.DivHeader('Updatevendas_' & p_web.nocolon('ven:TipoVenda') & '_comment',loc:fieldclass,Net:NoSend))
  End
  If 1=0
    loc:comment = ''
  End
  If p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
    p_web.script('$("#Updatevendas_' & p_web.nocolon('ven:TipoVenda') & '_comment_div").html("'&clip(loc:comment)&'");')
  Else
    packet.append(clip(loc:comment) & p_web.DivFooter(net:nosend,,,0))
  End
  do SendPacket

Refresh::ven:VendaSap  Routine
  do Prompt::ven:VendaSap
  do Value::ven:VendaSap
  do Comment::ven:VendaSap

Prompt::ven:VendaSap  Routine
  loc:fieldclass = Choose(not(1=0),p_web.combine(p_web.site.style.formprompt,,),'nt-hidden')
  If p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
  Else
    packet.append(p_web.DivHeader('Updatevendas_' & p_web.nocolon('ven:VendaSap') & '_prompt',loc:fieldClass,Net:NoSend))
  End
  loc:prompt = Choose(1=0,'',p_web.Translate('Venda Sap:'))
  If p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
    p_web.Script('$(''[for="'&p_web.nocolon('ven:VendaSap')&'"]'').html("'&clip(loc:prompt)&'");')
  Else ! not front loaded
    packet.append('<label for="'&p_web.nocolon('ven:VendaSap')&'">' & clip(loc:prompt) & '</label>')
    packet.append(p_web.DivFooter(Net:NoSend,,,0))
    do SendPacket
  End  ! front loaded

  omit('*** end of scripts ***')
  ! *** end of scripts ***

Validate::ven:VendaSap Routine
  If p_web.Ajax = 1 and p_web.ifExistsValue('NewValue')
    ven:VendaSap = p_web.GetValue('NewValue')
  ElsIf p_web.IfExistsValue('Value') !FormFieldPicture =   !FieldPicture = @s11
    ven:VendaSap = p_web.DeformatValue(p_web.GetValue('Value'),'@s11')
  End
  do ValidateValue::ven:VendaSap  ! copies value to session value if valid.

  p_web.PushEvent('parentupdated')
  do Refresh::ven:VendaSap   ! Field is auto-validated
  do SendMessage
  p_web.ntForm(loc:formname,'ready') ! 8.67 (in case the form was not the originator of the Ajax call)
  p_web.PopEvent()

ValidateValue::ven:VendaSap  Routine
      If loc:invalid = '' then p_web.SetSessionValue('ven:VendaSap',ven:VendaSap).

Value::ven:VendaSap  Routine
  data
loc:fieldclass     string(StyleStringSize)
loc:extra          string(StyleStringSize)
loc:disabled       long
loc:saveCallPopups long
loc:counter        long
loc:Filter       StringTheory
  code
  loc:fieldclass = p_web.Combine(p_web.site.style.formentrydiv,,)
  loc:fieldclass = choose(not(1=0),loc:fieldclass,'nt-hidden ' & loc:fieldclass)
  If p_web.site.FrontLoaded = 0 or loc:frontloading = net:GeneratingPage
    p_web.DivHeader('Updatevendas_' & p_web.nocolon('ven:VendaSap') & '_value',loc:fieldclass)
  End
  loc:fieldclass = ''
  loc:fieldclass = p_web.combine(p_web.site.style.formentry,,)
  If loc:viewonly
    loc:fieldclass = clip(loc:fieldclass) & ' ' & p_web.combine(p_web.site.style.formEntryReadOnly,)
  End
  If loc:retrying
    ven:VendaSap = p_web.RestoreValue('ven:VendaSap')
    do ValidateValue::ven:VendaSap
    If ven:VendaSap:IsInvalid then loc:fieldclass = clip(loc:fieldclass) & ' ' & p_web.combine(p_web.site.style.formEntryError,).
  End
  loc:extra = ''
  If Not (1=0)  ! SecFieldHideStateRtn
    p_web.site.HTMLEditor = p_web.site.DefaultHTMLEditor
    ! --- STRING --- ven:VendaSap
    loc:AutoComplete = 'autocomplete="off"'
    loc:readonly = Choose(loc:viewonly,'readonly','')
      loc:extra = clip(loc:extra) & p_web.SetEntryWidth(,Net:Form)
    loc:javascript = ''  ! MakeFormJavaScript
    if p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
      p_web.Script('$(''#'&p_web.nocolon('ven:VendaSap')&''').val('''&p_web._jsok(p_web.GetSessionValueFormat('ven:VendaSap'))&''');')
    Else
      packet.append(p_web.CreateInput('text','ven:VendaSap',p_web.GetSessionValueFormat('ven:VendaSap'),loc:fieldclass,loc:readonly,clip(loc:extra) & ' ' & clip(loc:autocomplete),,loc:javascript,p_web.PicLength('@s11'),,'ven:VendaSap',,'imm',,,,'Updatevendas')  & p_web.CRLF) !b
    End
    do SendPacket
  End
  if p_web.site.FrontLoaded = 0 or loc:frontloading = net:GeneratingPage
    p_web.DivFooter(,,,0)
  end

Comment::ven:VendaSap  Routine
  data
loc:fieldclass string(StyleStringSize)
  code
  loc:fieldclass = p_web.Combine(p_web.site.style.formcomment,,)
  if ven:VendaSap:IsInvalid
    loc:fieldclass = clip(loc:fieldclass) & ' ' & p_web.site.style.FormCommentError
  end
    loc:comment = ''
  loc:fieldclass = Choose(not(1=0),loc:fieldclass,'nt-hidden ' & loc:fieldclass)
  If p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
  else
    packet.append(p_web.DivHeader('Updatevendas_' & p_web.nocolon('ven:VendaSap') & '_comment',loc:fieldclass,Net:NoSend))
  End
  If 1=0
    loc:comment = ''
  End
  If p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
    p_web.script('$("#Updatevendas_' & p_web.nocolon('ven:VendaSap') & '_comment_div").html("'&clip(loc:comment)&'");')
  Else
    packet.append(clip(loc:comment) & p_web.DivFooter(net:nosend,,,0))
  End
  do SendPacket

Refresh::ven:Quantidade  Routine
  do Prompt::ven:Quantidade
  do Value::ven:Quantidade
  do Comment::ven:Quantidade

Prompt::ven:Quantidade  Routine
  loc:fieldclass = Choose(not(1=0),p_web.combine(p_web.site.style.formprompt,,),'nt-hidden')
  If p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
  Else
    packet.append(p_web.DivHeader('Updatevendas_' & p_web.nocolon('ven:Quantidade') & '_prompt',loc:fieldClass,Net:NoSend))
  End
  loc:prompt = Choose(1=0,'',p_web.Translate('Quantidade:'))
  If p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
    p_web.Script('$(''[for="'&p_web.nocolon('ven:Quantidade')&'"]'').html("'&clip(loc:prompt)&'");')
  Else ! not front loaded
    packet.append('<label for="'&p_web.nocolon('ven:Quantidade')&'">' & clip(loc:prompt) & '</label>')
    packet.append(p_web.DivFooter(Net:NoSend,,,0))
    do SendPacket
  End  ! front loaded

  omit('*** end of scripts ***')
  ! *** end of scripts ***

Validate::ven:Quantidade Routine
  If p_web.Ajax = 1 and p_web.ifExistsValue('NewValue')
    ven:Quantidade = p_web.GetValue('NewValue')
  ElsIf p_web.IfExistsValue('Value') !FormFieldPicture =   !FieldPicture = @n-14
    ven:Quantidade = p_web.DeformatValue(p_web.GetValue('Value'),'@n-14')
  End
  do ValidateValue::ven:Quantidade  ! copies value to session value if valid.

  p_web.PushEvent('parentupdated')
  do Refresh::ven:Quantidade   ! Field is auto-validated
  do SendMessage
  p_web.ntForm(loc:formname,'ready') ! 8.67 (in case the form was not the originator of the Ajax call)
  p_web.PopEvent()

ValidateValue::ven:Quantidade  Routine
  If Numeric(ven:Quantidade) = 0
    loc:Invalid = 'ven:Quantidade'
    ven:Quantidade:IsInvalid = true
    if not loc:alert then loc:alert = p_web.translate('Quantidade:') & ' ' & p_web.site.NumericText.
  End
      If loc:invalid = '' then p_web.SetSessionValue('ven:Quantidade',ven:Quantidade).

Value::ven:Quantidade  Routine
  data
loc:fieldclass     string(StyleStringSize)
loc:extra          string(StyleStringSize)
loc:disabled       long
loc:saveCallPopups long
loc:counter        long
  code
  loc:fieldclass = p_web.Combine(p_web.site.style.formentrydiv,,)
  loc:fieldclass = choose(not(1=0),loc:fieldclass,'nt-hidden ' & loc:fieldclass)
  If p_web.site.FrontLoaded = 0 or loc:frontloading = net:GeneratingPage
    p_web.DivHeader('Updatevendas_' & p_web.nocolon('ven:Quantidade') & '_value',loc:fieldclass)
  End
  loc:fieldclass = ''
  loc:fieldclass = p_web.combine(p_web.site.style.formentry,,)
  If loc:viewonly
    loc:fieldclass = clip(loc:fieldclass) & ' ' & p_web.combine(p_web.site.style.formEntryReadOnly,)
  End
  If loc:retrying
    ven:Quantidade = p_web.RestoreValue('ven:Quantidade')
    do ValidateValue::ven:Quantidade
    If ven:Quantidade:IsInvalid then loc:fieldclass = clip(loc:fieldclass) & ' ' & p_web.combine(p_web.site.style.formEntryError,).
  End
  loc:extra = ''
  If Not (1=0)  ! SecFieldHideStateRtn
    p_web.site.HTMLEditor = p_web.site.DefaultHTMLEditor
    ! --- NUMBER --- ven:Quantidade
    loc:AutoComplete = 'autocomplete="off"'
    loc:readonly = Choose(loc:viewonly,'readonly','')
      loc:extra = clip(loc:extra) & p_web.SetEntryWidth(,Net:Form)
    loc:javascript = ''  ! MakeFormJavaScript
    If p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
      p_web.Script('$(''#'&p_web.nocolon('ven:Quantidade')&''').val('''&p_web._jsok(p_web.GetSessionValue('ven:Quantidade'))&''');')
    Else
      packet.append(p_web.CreateInput('number','ven:Quantidade',p_web.GetSessionValue('ven:Quantidade'),loc:fieldclass,loc:readonly,clip(loc:extra) & ' ' & clip(loc:autocomplete),,loc:javascript,p_web.PicLength('@n-14'),,'ven:Quantidade',,'imm',,,,'Updatevendas')  & p_web.CRLF)
    End
    do SendPacket
  End
  if p_web.site.FrontLoaded = 0 or loc:frontloading = net:GeneratingPage
    p_web.DivFooter(,,,0)
  end

Comment::ven:Quantidade  Routine
  data
loc:fieldclass string(StyleStringSize)
  code
  loc:fieldclass = p_web.Combine(p_web.site.style.formcomment,,)
  if ven:Quantidade:IsInvalid
    loc:fieldclass = clip(loc:fieldclass) & ' ' & p_web.site.style.FormCommentError
  end
  loc:comment = p_web._jsok(p_web.site.NumericText)
  loc:fieldclass = Choose(not(1=0),loc:fieldclass,'nt-hidden ' & loc:fieldclass)
  If p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
  else
    packet.append(p_web.DivHeader('Updatevendas_' & p_web.nocolon('ven:Quantidade') & '_comment',loc:fieldclass,Net:NoSend))
  End
  If 1=0
    loc:comment = ''
  End
  If p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
    p_web.script('$("#Updatevendas_' & p_web.nocolon('ven:Quantidade') & '_comment_div").html("'&clip(loc:comment)&'");')
  Else
    packet.append(clip(loc:comment) & p_web.DivFooter(net:nosend,,,0))
  End
  do SendPacket

NextTab  routine
  data
  code
  p_web.Ajax = 1
  p_web.PageName = p_web._unEscape(p_web.PageName)

  case lower(p_web.PageName)
  of lower('Updatevendas_nexttab_' & 0)
    ven:TipoVenda = p_web.GetSessionValue('ven:TipoVenda')
    do ValidateValue::ven:TipoVenda
    If loc:Invalid
      loc:retrying = 1
      do Value::ven:TipoVenda
      do Comment::ven:TipoVenda ! allows comment style to be updated.
    End
    ven:VendaSap = p_web.GetSessionValue('ven:VendaSap')
    do ValidateValue::ven:VendaSap
    If loc:Invalid
      loc:retrying = 1
      do Value::ven:VendaSap
      do Comment::ven:VendaSap ! allows comment style to be updated.
    End
    ven:Quantidade = p_web.GetSessionValue('ven:Quantidade')
    do ValidateValue::ven:Quantidade
    If loc:Invalid
      loc:retrying = 1
      do Value::ven:Quantidade
      do Comment::ven:Quantidade ! allows comment style to be updated.
    End
    If loc:Invalid then exit.
  End
  p_web.ntWiz('Updatevendas','next')

ChangeTab  routine
  p_web.ChangeTab(loc:TabStyle,'Updatevendas',loc:TabTo)

TabChanged  routine
  data
TabNumber   Long   !! remember that tabs are numbered from 0
TabHeading  String(252),dim(1)
  code
  tabnumber = p_web.GetValue('_tab_')
  tabheading[1]  = p_web.Translate('General')
  p_web.SetSessionValue('showtab_Updatevendas',tabnumber) !! remember that tabs are numbered from 0

CallDiv    routine
  data
  code
  p_web.Ajax = 1
  p_web.PageName = p_web._unEscape(p_web.PageName)
  case lower(p_web.PageName)
  of lower('Updatevendas') & '_tabchanged'
     do TabChanged
  of lower('Updatevendas_tab_' & 0)
    do GenerateTab0
  of lower('Updatevendas_ven:TipoVenda_value')
      case p_web.Event ! String
      of 'selected' !event:selected !257
      of 'accepted' !event:accepted !1
      orof 'childupdated'
        do Validate::ven:TipoVenda
        do AlertParent
      of 'timer'
        do refresh::ven:TipoVenda
        do AlertParent
      else
        do Value::ven:TipoVenda
      end
  of lower('Updatevendas_ven:VendaSap_value')
      case p_web.Event ! String
      of 'selected' !event:selected !257
      of 'accepted' !event:accepted !1
      orof 'childupdated'
        do Validate::ven:VendaSap
        do AlertParent
      of 'timer'
        do refresh::ven:VendaSap
        do AlertParent
      else
        do Value::ven:VendaSap
      end
  of lower('Updatevendas_ven:Quantidade_value')
      case p_web.Event ! Number
      of 'selected' !event:selected !257
      of 'accepted' !event:accepted !1
      orof 'childupdated'
        do Validate::ven:Quantidade
        do AlertParent
      of 'timer'
        do refresh::ven:Quantidade
        do AlertParent
      else
        do Value::ven:Quantidade
      end
  End

SendPacket  routine
  p_web.ParseHTML(packet, 1, 0, NET:NoHeader)
  packet.setvalue('')
! NET:WEB:StagePRE

PreInsert  Routine
  data
  code
  p_web.SetValue('Updatevendas_form:ready_',1)
  p_web.SetSessionValue('Updatevendas:Active',1)
  p_web.SetSessionValue('Updatevendas_CurrentAction',Net:InsertRecord)
  p_web.setsessionvalue('showtab_Updatevendas',0)
  clear(ven:record) ! Primes moved before auto-increment (PrimeRecord) call.
  do SetFormSettings

PreCopy  Routine
  data
  code
  p_web.SetValue('Updatevendas_form:ready_',1)
  p_web.SetSessionValue('Updatevendas:Active',1)
  p_web.SetSessionValue('Updatevendas_CurrentAction',Net:CopyRecord)
  p_web.setsessionvalue('showtab_Updatevendas',0)
  p_web._PreCopyRecord(vendas,ven:PRIMARY)
  ! here we need to copy the non-unique fields across
  do SetFormSettings

PreUpdate  Routine
  data
loc:offset      Long
  code
  p_web.SetValue('Updatevendas_form:ready_',1)
  p_web.SetSessionValue('Updatevendas:Active',1)
  p_web.SetSessionValue('Updatevendas_CurrentAction',Net:ChangeRecord)
  p_web.SetSessionValue('Updatevendas:Primed',0)
  do SetFormSettings

PreDelete       Routine
  data
  code
  p_web.SetValue('Updatevendas_form:ready_',1)
  p_web.SetSessionValue('Updatevendas_CurrentAction',Net:DeleteRecord)
  p_web.SetSessionValue('Updatevendas:Primed',0)
  p_web.setsessionvalue('showtab_Updatevendas',0)
  do SetFormSettings

LoadRelatedRecords  Routine
  loc:ok = 0
  loc:ok = 0

! copies fields from the Value queue to the File Field.
CompleteForm  Routine
  data
loc:pic   string(40)
  code
  do SetPics
          If p_web.IfExistsValue('ven:TipoVenda')
            ven:TipoVenda = p_web.GetValue('ven:TipoVenda')
          End
          If p_web.IfExistsValue('ven:VendaSap')
            ven:VendaSap = p_web.GetValue('ven:VendaSap')
          End
          If p_web.IfExistsValue('ven:Quantidade')
            ven:Quantidade = p_web.GetValue('ven:Quantidade')
          End


! NET:WEB:StageVALIDATE
ValidateInsert  Routine
  do CompleteForm
  do ValidateRecord
  do CheckForDuplicate

ValidateCopy  Routine
  do CompleteForm
  do ValidateRecord
  do CheckForDuplicate

ValidateUpdate  Routine
  do CompleteForm
  do ValidateRecord
  do CheckForDuplicate
CheckForDuplicate  Routine
  Data
GotFileZero    long
  Code
  If loc:invalid <> '' then exit. ! no need to check, record is already invalid
  If ans = 0 then exit. ! no need to check, as no action happening
  If p_web.GetSessionValue('Updatevendas:Primed') = 0 and Ans = Net:InsertRecord
    Get(vendas,0)
    GotFileZero = true
  End
  ! Check for duplicates
  If Duplicate(ven:PRIMARY) ! In SQL drivers this clears the Blob field, if Get(file,0) was done. TPS does not.
    loc:Invalid = 'ven:Reg'
    if not loc:alert then loc:Alert = clip(p_web.site.DuplicateText) & ' PRIMARY --> ven:Reg = ' & clip(ven:Reg).
  End
  If GotFileZero
  End

ValidateDelete  Routine
  p_web.DeleteSessionValue('Updatevendas_ChainTo')
  ! Check for restricted child records

ValidateRecord  Routine
  p_web.DeleteSessionValue('Updatevendas_ChainTo')

  ! Then add additional constraints set on the template
  loc:InvalidTab = -1
  ! tab = 1
        loc:InvalidTab += 1
        do ValidateValue::ven:TipoVenda
        If loc:Invalid then exit.
        do ValidateValue::ven:VendaSap
        If loc:Invalid then exit.
        do ValidateValue::ven:Quantidade
        If loc:Invalid then exit.
  ! The following fields are not on the form, but need to be checked anyway.
! NET:WEB:StagePOST
PostInsert      Routine
  If loc:FormOnSave = Net:InsertAgain
    p_web.InsertAgain('Updatevendas')
    Clear(ven:Record)
  Else
    p_web.SetSessionValue('Updatevendas:Active',0)
  End
PostCopy        Routine
  p_web.SetSessionValue('Updatevendas:Primed',0)
  p_web.SetSessionValue('Updatevendas:Active',0)

PostUpdate      Routine
  Data
  Code
  p_web.SetSessionValue('Updatevendas:Primed',0)
  p_web.SetSessionValue('Updatevendas:Active',0)

PostDelete      Routine
WebHandler           PROCEDURE (String p_ReqString)

loc:file                              &FILE
!Local Data Classes
p_web                CLASS(NetWebServerWorker)             ! Generated by NetTalk Extension (Class Definition)
AddFile                PROCEDURE(FILE p_file),LONG,PROC,DERIVED
Authenticate           PROCEDURE(String pUser,String pPassword),Long,PROC,DERIVED
CallForm               PROCEDURE(FILE p_file,LONG p_Stage),LONG,PROC,DERIVED
CloseFile              PROCEDURE(FILE p_file),LONG,PROC,DERIVED
DeleteFile             PROCEDURE(FILE p_file),LONG,PROC,DERIVED
GetFile                PROCEDURE(FILE p_file,KEY p_Key),LONG,PROC,DERIVED
GetPassword            PROCEDURE(String pUser),String,DERIVED
OpenFile               PROCEDURE(FILE p_file),LONG,PROC,DERIVED
PrimeFile              PROCEDURE(FILE p_file,Long p_Clear,Long p_forceWrite=False),LONG,PROC,DERIVED
ProcessLink            PROCEDURE(<string p_action>),DERIVED
ProcessTag             PROCEDURE(string p_TagString),DERIVED
SetErrors              PROCEDURE(),DERIVED
UpdateFile             PROCEDURE(FILE p_file),LONG,PROC,DERIVED
_NetWebFileNamed       PROCEDURE(STRING p_Label),*FILE,DERIVED
_SendFile              PROCEDURE(string p_FileName,Long p_header=NET:SendHeader),DERIVED

                     END


  CODE
  GlobalErrors.SetProcedureName('WebHandler')
  p_web.ProcessRequest(p_ReqString)
  GlobalErrors.SetProcedureName()

p_web.AddFile PROCEDURE(FILE p_file)

ReturnValue          LONG,AUTO

RM      &RelationManager
Loc:Err Long(-1)

  CODE
    RM &= NetWebRelationManager(p_File)
    If NOT RM &= Null
      self.SetSqlTimeout(p_File,net:On)
      Loc:Err = RM.Me.Insert()
      self.SetErrors()
      self.SetSqlTimeout(p_File,net:Off)
      Self.FileToSessionQueue(p_File,Net:AlsoValueQueue)
    End
    Return Loc:Err
  ReturnValue = PARENT.AddFile(p_file)
  RETURN ReturnValue


p_web.Authenticate PROCEDURE(String pUser,String pPassword)

ReturnValue          Long,AUTO


  CODE
  ! -------------------------------------------------------------------------------------------------
  ! Add code here after the parent call to check if the User and Password is correct. If it is set the
  ! ReturnValue to true. Entering code in here will allow Basic Authentication to be done automatically.
  ! -------------------------------------------------------------------------------------------------
  ReturnValue = PARENT.Authenticate(pUser,pPassword)
  ReturnValue = False
  ! This is just an example of embed code here. Use a stronger test in your app.
  IF pUser = 'demo' AND pPassword = 'demo'
    ReturnValue = true
    self.SetSessionLevel(0)
  END
  ! Here's an example of reading the user name and password from a table. Alter to match your system.
  ! Access:Users.Open()
  ! Access:Users.UseFile()
  ! Use:UserName = pUser
  ! If Access:Users.Fetch(use:UserNameKey) = LevelBenign
  !   If pPassword = use:password
  !     ReturnValue = true
  !     self.SetSessionLevel(0)
  !   End
  ! End
  ! Access:Users.Close()
  ! Return ReturnValue
  RETURN ReturnValue


p_web.CallForm PROCEDURE(FILE p_file,LONG p_Stage)

ReturnValue          LONG,AUTO


  CODE
    If Band(p_Stage, NET:WEB:StagePost + NET:WEB:StageValidate + NET:WEB:Cancel)
      case lower(self.formsettings.proc)
      Of 'updatevendas'
         ReturnValue = Updatevendas(Self,p_stage)
         RETURN ReturnValue
      Of 'loginform'
         ReturnValue = LoginForm(Self,p_stage)
         RETURN ReturnValue
      End
    Else
      case lower(SELF.PageName)
        Of 'updatevendas'
          ReturnValue = Updatevendas(Self,p_stage)
          RETURN ReturnValue
        Of 'loginform'
          ReturnValue = LoginForm(Self,p_stage)
          RETURN ReturnValue
      End
    End
    If p_File &= vendas
       ReturnValue = Updatevendas(Self,p_stage)
       RETURN ReturnValue
    End
    Case Lower(Self.FormSettings.ParentPage)
      Of 'loginform'
        ReturnValue = LoginForm(Self,p_Stage)
        Return ReturnValue
    End
  ReturnValue = PARENT.CallForm(p_file,p_Stage)
  RETURN ReturnValue


p_web.CloseFile PROCEDURE(FILE p_file)

ReturnValue          LONG,AUTO

RM      &RelationManager
Loc:Err Long(-1)

  CODE
    RM &= NetWebRelationManager(p_File)
    If NOT RM &= Null
      Loc:Err = RM.Close()  ! doing an rm.close can cause problems.
    end
    Return Loc:Err
  ReturnValue = PARENT.CloseFile(p_file)
  RETURN ReturnValue


p_web.DeleteFile PROCEDURE(FILE p_file)

ReturnValue          LONG,AUTO

RM      &RelationManager
Loc:Err Long(-1)

  CODE
    RM &= NetWebRelationManager(p_File)
    If NOT RM &= Null
      self.SetSqlTimeout(p_File,net:On)
      Loc:Err = RM.Delete(False)
      Self.SetErrors()
      self.SetSqlTimeout(p_File,net:Off)
    End
    Return Loc:Err
  ReturnValue = PARENT.DeleteFile(p_file)
  RETURN ReturnValue


p_web.GetFile PROCEDURE(FILE p_file,KEY p_Key)

ReturnValue          LONG,AUTO

RM      &RelationManager
Loc:Err Long(-1)

  CODE
    RM &= NetWebRelationManager(p_File)
    If NOT RM &= Null
      self.SetSqlTimeout(p_File,net:On)
      Loc:Err = RM.Me.Fetch(p_Key)
      Self.SetErrors()
      RM.Save()                    ! saves related file info so relational update will work.
      self.SetSqlTimeout(p_File,net:Off)
    End
    Return Loc:Err
  ReturnValue = PARENT.GetFile(p_file,p_Key)
  RETURN ReturnValue


p_web.GetPassword PROCEDURE(String pUser)

ReturnValue          ANY


  CODE
  ! --------------------------------------------------------------------------------------------------
  ! Add code here to check a password if Digest Authentication is being supported. It is not necessary
  ! to add code here for other kinds of authentication.
  ! --------------------------------------------------------------------------------------------------
  ReturnValue = PARENT.GetPassword(pUser)
  !CASE pUser
  !OF 'demo'
  !  ReturnValue = 'demo'
  !END
  RETURN ReturnValue


p_web.OpenFile PROCEDURE(FILE p_file)

ReturnValue          LONG,AUTO

RM      &RelationManager
Loc:Err Long(-1)

  CODE
    RM &= NetWebRelationManager(p_File)
    If NOT RM &= Null
      Loc:Err = RM.Open()
      self.SetErrors()
    End
    Return Loc:Err
  ReturnValue = PARENT.OpenFile(p_file)
  RETURN ReturnValue


p_web.PrimeFile PROCEDURE(FILE p_file,Long p_Clear,Long p_forceWrite=False)

ReturnValue          LONG,AUTO

RM      &RelationManager
Loc:Err Long(-1)

  CODE
    RM &= NetWebRelationManager(p_File)
    If NOT RM &= Null
      !If p_forceWrite then RM.Me.HasAutoInc = true. ! this forces an Insert, even if no keys are set as auto-inc, like in the case of a server side Identity field.
      self.SetSqlTimeout(p_File,net:On)
      Loc:Err = RM.Me.PrimeRecord(p_Clear)
      self.SetSqlTimeout(p_File,net:Off)
      Self.FileToSessionQueue(p_File,Net:AlsoValueQueue)
    End
    Return Loc:Err
  ReturnValue = PARENT.PrimeFile(p_file,p_Clear,p_forceWrite)
  RETURN ReturnValue


p_web.ProcessLink PROCEDURE(<string p_action>)


  CODE
  ! -----------------------------------------------------------------------------
  ! The incoming request has been completely parsed and is about to be processed.
  ! No tables have been opened, but they may be soon so this is a good place
  ! to set owner and filename variables .
  ! -----------------------------------------------------------------------------
  PARENT.ProcessLink(p_action)


p_web.ProcessTag PROCEDURE(string p_TagString)

loc:tag      String(1024)

  CODE
  PARENT.ProcessTag(p_TagString)
    loc:tag = lower(p_TagString)
  loc:tag = Choose(Instring('?',loc:tag) > 0,sub(loc:tag,1,Instring('?',loc:tag)-1),loc:tag)
  Case loc:tag
    of 'pagefootertag'
      pagefootertag(Self)
    of 'browsevendas'
      browsevendas(Self)
    of 'updatevendas'
      updatevendas(Self)
    of 'pageheadertag'
      pageheadertag(Self)
    of 'loginform'
      loginform(Self)
  End


p_web.SetErrors PROCEDURE


  CODE
    self.lastError = GlobalErrors.GetError(ErrClarion)
    self.lastErrorCode = GlobalErrors.GetErrorCode(ErrClarion)
    self.lastFileError = GlobalErrors.GetError(ErrFile)
    self.lastFileErrorCode = GlobalErrors.GetErrorCode(ErrFile)
  PARENT.SetErrors


p_web.UpdateFile PROCEDURE(FILE p_file)

ReturnValue          LONG,AUTO

RM      &RelationManager
Loc:Err Long(-1)

  CODE
    RM &= NetWebRelationManager(p_File)
    If NOT RM &= Null
      self.SetSqlTimeout(p_File,net:On)
      Loc:Err = RM.Update()
      self.SetErrors()
      self.SetSqlTimeout(p_File,net:Off)
      Self.FileToSessionQueue(p_File,Net:AlsoValueQueue)
    End
    Return Loc:Err
  ReturnValue = PARENT.UpdateFile(p_file)
  RETURN ReturnValue


p_web._NetWebFileNamed PROCEDURE(STRING p_Label)

ReturnValue          &FILE


  CODE
    ReturnValue &= NetWebFileNamed(p_Label)
    Return ReturnValue
  ReturnValue &= PARENT._NetWebFileNamed(p_Label)
  RETURN ReturnValue


p_web._SendFile PROCEDURE(string p_FileName,Long p_header=NET:SendHeader)

loc:parent  string(252)   ! should always be a lower-case string
loc:done        Long
loc:filename    string(252)

  CODE
    loc:parent = self.PlainText(Lower(self.GetValue('_parentProc_')))
    loc:filename = SELF.GetPageName(Lower(p_FileName))
  
    do CaseStart:ventekweb
    If loc:Done then Return.
  PARENT._SendFile(p_FileName,p_header)
! ----------------------------------------------------------------
SendFile:ventekweb:R1  Routine
  Case lower(loc:filename)
  of 'indexpage'
  orof 'index.htm'
    IndexPage(p_web)
    loc:Done = 1 ; Exit
  of 'pagefootertag'
  orof 'pagefootertag' & '_' & loc:parent
      p_web.Ajax = 1
      PageFooterTag(p_web)
      p_web.Sendfooter(12)
      loc:Done = 1
  of 'browsevendas'
  orof 'browsevendas' & '_' & loc:parent
    p_web.MakePage('Browsevendas',Net:Web:Browse,0,'Vendas',,,) !sf1
    loc:Done = 1
  of 'pageheadertag'
  orof 'pageheadertag' & '_' & loc:parent
      p_web.Ajax = 1
      PageHeaderTag(p_web)
      p_web.Sendfooter(12)
      loc:Done = 1
  End ! Case Loc:filename
! ----------------------------------------------------------------------
ServicesAndMethods:ventekweb  routine
!------------------------------------------------------------------------
Case:Updatevendas  Routine
  Case lower(loc:filename)
  of 'updatevendas'
    p_web.MakePage('Updatevendas',Net:Web:Form,0,'Update Vendas',,,)
    loc:Done = 1 ; Exit
  of p_web.nocolon('updatevendas_tabchanged')
    Updatevendas(p_web,Net:Web:Div)
    loc:Done = 1 ; Exit
  of p_web.nocolon('updatevendas_nexttab_0')
    Updatevendas(p_web,Net:Web:NextTab)
    p_web.Sendfooter(5)
    loc:Done = 1 ; Exit
  of p_web.nocolon('updatevendas_tab_0')
  orof p_web.nocolon('updatevendas_ven:tipovenda_value')
  orof p_web.nocolon('updatevendas_ven:tipovenda_value')
  orof p_web.nocolon('updatevendas_ven:vendasap_value')
  orof p_web.nocolon('updatevendas_ven:vendasap_value')
  orof p_web.nocolon('updatevendas_ven:quantidade_value')
  orof p_web.nocolon('updatevendas_ven:quantidade_value')
    Updatevendas(p_web,Net:Web:Div)
    p_web.Sendfooter(11)
    loc:Done = 1 ; exit
  End ! Case

!------------------------------------------------------------------------
Case:LoginForm  Routine
  Case lower(loc:filename)
  of 'loginform'
    p_web.MakePage('LoginForm',Net:Web:Form,0,,,,)
    loc:Done = 1 ; Exit
  of p_web.nocolon('loginform_tabchanged')
    LoginForm(p_web,Net:Web:Div)
    loc:Done = 1 ; Exit
  of p_web.nocolon('loginform_nexttab_0')
    LoginForm(p_web,Net:Web:NextTab)
    p_web.Sendfooter(5)
    loc:Done = 1 ; Exit
  of p_web.nocolon('loginform_tab_0')
  orof p_web.nocolon('loginform_loc:login_value')
  orof p_web.nocolon('loginform_loc:login_value')
  orof p_web.nocolon('loginform_loc:password_value')
  orof p_web.nocolon('loginform_loc:password_value')
  orof p_web.nocolon('loginform_loc:remember_value')
  orof p_web.nocolon('loginform_loc:remember_value')
  orof p_web.nocolon('loginform_loc:hash_value')
  orof p_web.nocolon('loginform_loc:hash_value')
    LoginForm(p_web,Net:Web:Div)
    p_web.Sendfooter(11)
    loc:Done = 1 ; exit
  End ! Case

!------------------------------------------------------------------------
CaseStart:ventekweb  routine
  do ServicesAndMethods:ventekweb
  if loc:done then exit.
  do SendFile:ventekweb:R1
  if loc:done then exit.
  do Case:Updatevendas
  if loc:done then exit.
  do Case:LoginForm
  if loc:done then exit.

PageHeaderTag        PROCEDURE  (NetWebServerWorker p_web)
! Use this procedure to "embed" html in other pages.
! on the web page use <!-- Net:PageHeaderTag -->
!
! In this procedure set the packet stringTheory object, and call the SendPacket routine.
!
! EXAMPLE:
! packet.append('<strong>Hello World!</strong>'& p_web.CRLF)
! do SendPacket
loc:divname           string(252)
loc:parent            string(252)  ! should always be a lower-case string
loc:ContentBodyClass  string(StyleStringSize)
loc:LeftPanelClass    string(StyleStringSize)
loc:RightPanelClass   string(StyleStringSize)
loc:leftpanel         Long
loc:rightpanel        Long
packet                  StringTheory
timer                   long
loc:options             StringTheory ! options for jQuery calls
Loc:MenuStyle3   Long
Loc:MenuPos3     Long
  CODE
  If p_web.Event='callpopups' then return.
  GlobalErrors.SetProcedureName('PageHeaderTag')
  loc:parent = p_web.PlainText(lower(p_web.GetValue('_parentProc_')))
  If loc:parent <> ''
    loc:divname = lower(clip(loc:parent) & '_PageHeaderTag')
  Else
    loc:divname = lower('PageHeaderTag')
  End
    if p_web.Event = 'getsecwinsettings'   !NetTalk Web Menu
        p_web.SetValue('Secwin_AccessWindowName','PageHeaderTag')
  
      GlobalErrors.SetProcedureName()
      Return
    end
      !%SecwinCtrlsDisplay = 0 ; %SecwinAccessGroupsNotCreated = 0

  p_web.DivHeader(loc:divname,'nt-site-header-6 ui-widget-header ui-corner-top',,,' data-role="header"',1,,,'PageHeaderTag')
!----------- put your Header Panel html code here -----------------------------------
    !
      do SendPacket
    If (p_web.PageName = p_web.site.LoginPage)
      Do HeadingPlain
      do SendPacket
    End
    If (p_web.GetSessionLoggedIn() = 0 and p_web.PageName <> p_web.site.LoginPage)
      Do HeadingWhenLoggedOut
      do SendPacket
    End
    If (p_web.GetSessionLoggedIn() and p_web.PageName <> p_web.site.LoginPage)
      Do HeadingWhenLoggedIn
      do SendPacket
    End
    p_web.ClearBrowse('PageHeaderTag')
    p_web.StoreValue('_menu_')
    loc:menuStyle3 = p_web.RestoreValue('_menu_')
    p_web.StoreValue('_menu_' & 'pos')
    loc:menuPos3 = p_web.RestoreValue('_menu_' & 'pos')
    If loc:MenuStyle3 = 0 then loc:MenuStyle3 = Net:Web:Ddm.
    If loc:menuPos3 = 0 then loc:menuPos3 = net:left.
    If loc:menuStyle3 <> Net:Web:Accordion and loc:menuStyle3 <> Net:Web:TaskPanel
      do WebMenus:3
      packet.append(p_web.comment('End Menu Popups'))
      do MenuPopups:3
      do SendPacket
    End
!----------- end of custom code ----------------------------------------
  do SendPacket
  p_web.DivFooter(,loc:divName)
    ! AfterDiv
  packet.append('<!-- Net:Busy -->')
  packet.append('<!-- Net:Message -->')
  do SendPacket
    Case Loc:MenuStyle3
    Of Net:Web:TaskPanel
    OrOf Net:Web:Accordion
      Case Loc:MenuPos3
      of net:Left
        loc:leftpanel = 1
      of net:Right
        loc:rightpanel = 1
      End
    End
  If loc:leftpanel and loc:rightpanel
    loc:ContentBodyClass = ' nt-contentpanel-lr'
    loc:LeftPanelClass = 'nt-leftpanel nt-leftpanel-lr'
    loc:RightPanelClass = 'nt-rightpanel nt-rightpanel-lr'
  ElsIf loc:leftpanel
    loc:ContentBodyClass = ' nt-contentpanel-l'
    loc:LeftPanelClass = 'nt-leftpanel nt-leftpanel-l'
  ElsIf loc:Rightpanel
    loc:ContentBodyClass = ' nt-contentpanel-r'
    loc:RightPanelClass = 'nt-rightpanel nt-rightpanel-r'
  Else
    loc:ContentBodyClass = ' nt-contentpanel-h'
  End
  If Loc:LeftPanel
    p_web.DivHeader(clip(loc:divname) & '_left',p_web.Combine(loc:LeftPanelClass,''),,,,1,,,'Left Panel')
      If Loc:MenuPos3 = net:Left and (loc:menuStyle3 = Net:Web:Accordion or loc:menuStyle3 = Net:Web:TaskPanel)
        do WebMenus:3
        packet.append(p_web.comment('End Menu Popups'))
        do MenuPopups:3
        do SendPacket
      End
    p_web.DivFooter(,clip(loc:divname) & '_left')
  End
  If Loc:RightPanel
    p_web.DivHeader(clip(loc:divname) & '_right',p_web.Combine(loc:RightPanelClass,''),,,,1,,,'Right Panel')
      If Loc:MenuPos3 = net:right and (loc:menuStyle3 = Net:Web:Accordion or loc:menuStyle3 = Net:Web:TaskPanel)
        do WebMenus:3
        packet.append(p_web.comment('End Menu Popups'))
        do MenuPopups:3
        do SendPacket
      End
    p_web.DivFooter(,clip(loc:divname) & '_right')
  End
  If (p_web.site.ContentBody) and p_web.Ajax = 0
    p_web.DivHeader(p_web.site.ContentBody,p_web.Combine(p_web.site.contentbodydivclass,loc:ContentBodyClass),,,,,,,'Content Body')
  end
  GlobalErrors.SetProcedureName()
  Return

!--------------------------------------
SendPacket  routine
  p_web.ParseHTML(packet,1,0,NET:NoHeader)
  packet.SetValue('')

MenuPopups:3  Routine

WebMenus:Accordion:3  Routine
  data
loc:menunumber  long
  code
  do StartMenu:3
  packet.append(p_web.DivHeader(clip('menu'),p_web.Combine('nt-noprint',p_web.site.style.FormTabOuter,''),Net:NoSend))
  !! No Menu Condition
        packet.append('<h3 class="'&p_web.combine(p_web.site.style.FormTabTitle,' nt-accordion-icon-right')&'"' & p_web.CreateTip() & '>'& |
                         '<div id="'&clip('menu')&'_1_name'&'" class="">' & |
                         p_web.Translate('Home',Net:HtmlOk * 0 + Net:UnsafeHtmlOk * 0)& |
                         '</div>' &|
                         '</h3>' & p_web.CRLF & |
                 p_web.DivHeader(clip('menu')&'_1',p_web.combine(p_web.site.style.FormTabInner,' nt-padding-1 nt-menu-items-background'),Net:NoSend))
        do Menu:1:3
        packet.append(p_web.DivFooter(Net:NoSend))
        p_web.SetSessionValueDefault('PageHeaderTag_MenuOpen',loc:menunumber)
        loc:menunumber += 1
  !! No Menu Condition
        packet.append('<h3 class="'&p_web.combine(p_web.site.style.FormTabTitle,' nt-accordion-icon-right')&'"' & p_web.CreateTip() & '>'& |
                         '<div id="'&clip('menu')&'_2_name'&'" class="">' & |
                         p_web.Translate('Browse',Net:HtmlOk * 0 + Net:UnsafeHtmlOk * 0)& |
                         '</div>' &|
                         '</h3>' & p_web.CRLF & |
                 p_web.DivHeader(clip('menu')&'_2',p_web.combine(p_web.site.style.FormTabInner,' nt-padding-1 nt-menu-items-background'),Net:NoSend))
        do Menu:2:3
        packet.append(p_web.DivFooter(Net:NoSend))
        p_web.SetSessionValueDefault('PageHeaderTag_MenuOpen',loc:menunumber)
        loc:menunumber += 1
  If p_web.GetSessionLoggedIn() = 0 and p_web.PageName <> p_web.site.LoginPage
        packet.append('<h3 class="'&p_web.combine(p_web.site.style.FormTabTitle,' nt-accordion-icon-right')&'"' & p_web.CreateTip() & '>'& |
                         '<div id="'&clip('menu')&'_3_name'&'" class="">' & |
                         p_web.Translate('Login',Net:HtmlOk * 0 + Net:UnsafeHtmlOk * 0)& |
                         '</div>' &|
                         '</h3>' & p_web.CRLF & |
                 p_web.DivHeader(clip('menu')&'_3',p_web.combine(p_web.site.style.FormTabInner,' nt-padding-1 nt-menu-items-background'),Net:NoSend))
        do Menu:3:3
        packet.append(p_web.DivFooter(Net:NoSend))
        p_web.SetSessionValueDefault('PageHeaderTag_MenuOpen',loc:menunumber)
        loc:menunumber += 1
  End
  If p_web.GetSessionLoggedIn() = 1 and p_web.PageName <> p_web.site.LoginPage
        packet.append('<h3 class="'&p_web.combine(p_web.site.style.FormTabTitle,' nt-accordion-icon-right')&'"' & p_web.CreateTip() & '>'& |
                         '<div id="'&clip('menu')&'_4_name'&'" class="">' & |
                         p_web.Translate('Logout',Net:HtmlOk * 0 + Net:UnsafeHtmlOk * 0)& |
                         '</div>' &|
                         '</h3>' & p_web.CRLF & |
                 p_web.DivHeader(clip('menu')&'_4',p_web.combine(p_web.site.style.FormTabInner,' nt-padding-1 nt-menu-items-background'),Net:NoSend))
        do Menu:4:3
        packet.append(p_web.DivFooter(Net:NoSend))
        p_web.SetSessionValueDefault('PageHeaderTag_MenuOpen',loc:menunumber)
        loc:menunumber += 1
  End
  packet.append(p_web.DivFooter(Net:NoSend))
  do EndMenu:3
  ! javascript to make menu work
  loc:options.Free(True)
  p_web.SetOption(loc:options,'heightStyle','content')
  p_web.SetOption(loc:options,'icons','{{ ''header'': ''ui-icon-circle-arrow-s'', ''activeHeader'': ''ui-icon-blank'' }')
  p_web.SetOption(loc:options,'active',p_web.GetSessionValue('PageHeaderTag_MenuOpen') )
  p_web.SetOption(loc:options,'activate','function(event, ui) {{ SetSessionValue(''PageHeaderTag_MenuOpen'',$(this).accordion("option","active")); }')
  p_web.jQuery('#' & lower('menu') & '_div','accordion',loc:options)
WebMenus:TaskPanel:3  Routine
  data
loc:options             StringTheory ! options for jQuery calls
  code
  do StartMenu:3
  ! menu div
  packet.append(p_web.DivHeader('menu',p_web.Combine('nt-noprint',''),Net:NoSend,,,,,,'Taskpanel Menu') & p_web.CRLF)
  ! Task Panel header - 'Home'
        packet.append('<a href="'&p_web._jsok(p_web._MakeUrl(clip('IndexPage')))&'"' & p_web.CreateTip() & ' id="'&p_web._jsok('menu')&'_1" class="'& p_web.combine('nt-menu-item-alone',clip(''))&'">' & |
                        '<div id="'&clip('menu')&'_1_name'&'" class="nt-menu-text">' & |
                        p_web.Translate('Home',Net:HtmlOk * 0 + Net:UnsafeHtmlOk * 0)&|
                        '</div></a>')
  ! Task Panel header - 'Browse'
        packet.append('<div' & p_web.CreateTip() & ' id="'&p_web._jsok('menu')&'_2" class="'& p_web.combine(clip(''))&'">' & |
                                '<h3 class="' & p_web.combine(' nt-accordion-icon-right') & '">'&|
                                '<div id="'&clip('menu')&'_2_name'&'" class="">' & |
                                p_web.Translate('Browse',Net:HtmlOk * 0 + Net:UnsafeHtmlOk * 0)&|
                                '</div>' & |
                                '</h3><div class="'&p_web.combine('nt-menu-items-background',' nt-padding-1 nt-menu-items-background')&'">' & p_web.CRLF )
        do Menu:2:3
        packet.append('</div></div>')
        p_web.SetSessionValueDefault('open_PageHeaderTag_2','0')  ! if not set earlier - 0 = first menu.
        loc:options.Free(True)
        p_web.SetOption(loc:options,'collapsible','true')
        p_web.SetOption(loc:options,'heightStyle','content')
        p_web.SetOption(loc:options,'icons','{{ ''header'': ''ui-icon-circle-arrow-s'', ''activeHeader'': ''ui-icon-circle-arrow-n'' }')
        p_web.SetOption(loc:options,'active',p_web.GetSessionValue('open_PageHeaderTag_2'))
        p_web.SetOption(loc:options,'activate','function(event, ui) {{ SetSessionValue(''open_PageHeaderTag_2'',$(this).accordion( "option", "active" ));}')
        p_web.jQuery('#' & p_web._jsok('menu')&'_2','accordion',loc:options)
  ! Task Panel header - 'Login'
  If p_web.GetSessionLoggedIn() = 0 and p_web.PageName <> p_web.site.LoginPage
        packet.append('<a href="'&p_web._jsok(p_web._MakeUrl('/LoginForm?' & clip('')))&'"' & p_web.CreateTip() & ' id="'&p_web._jsok('menu')&'_3" class="'& p_web.combine('nt-menu-item-alone',clip(''))&'">' & |
                        '<div id="'&clip('menu')&'_3_name'&'" class="nt-menu-text">' & |
                        p_web.Translate('Login',Net:HtmlOk * 0 + Net:UnsafeHtmlOk * 0)&|
                        '</div></a>')
  End
  ! Task Panel header - 'Logout'
  If p_web.GetSessionLoggedIn() = 1 and p_web.PageName <> p_web.site.LoginPage
        packet.append('<a href="'&p_web._jsok(p_web._MakeUrl('/LoginForm?' & clip('')))&'"' & p_web.CreateTip() & ' id="'&p_web._jsok('menu')&'_4" class="'& p_web.combine('nt-menu-item-alone',clip(''))&'">' & |
                        '<div id="'&clip('menu')&'_4_name'&'" class="nt-menu-text">' & |
                        p_web.Translate('Logout',Net:HtmlOk * 0 + Net:UnsafeHtmlOk * 0)&|
                        '</div></a>')
  End
  packet.append(p_web.divFooter(net:nosend,'Task Panel Menu End'))
  do EndMenu:3
WebMenus:DoubleDrop:3  Routine
  do StartMenu:3
  packet.append(p_web.DivHeader('menu',' nt-menu-div ui-corner-br',Net:NoSend,,,1,,,'Double Drop Menu','nav'))
  packet.append('<div id="'& clip('menu') & '_burger" class="nt-small-menu"></div>' & p_web.CRLF)
  packet.append('<ul id="'&clip('menu')&'" class="'&clip(' nt-menu')&'">' & p_web.CRLF)
        packet.append('<li class="nt-menu-nodrop"><a' & p_web.CreateTip() & ' class="'&p_web.Combine('nt-menu-button nt-menu-button-drop', )&'" href="'&p_web._jsok(p_web._MakeUrl(clip('IndexPage')))&'">' & |
          '<div class="nt-menu-text">' & p_web.Translate('Home',Net:HtmlOk * 0 + Net:UnsafeHtmlOk * 0)&'</div></a>' & p_web.CRLF)
        do SendPacket
        do Menu:1:3
        packet.append('</li>' & p_web.CRLF)
        packet.append('<li class="nt-menu-drop"><a' & p_web.CreateTip() & ' class="'&p_web.Combine('nt-menu-button nt-menu-button-drop',)&'" href="#">' & |
          '<div class="nt-menu-text">' & p_web.Translate('Browse',Net:HtmlOk * 0 + Net:UnsafeHtmlOk * 0)&'</div></a>' & p_web.CRLF)
        do SendPacket
        do Menu:2:3
        packet.append('</li>' & p_web.CRLF)
  If p_web.GetSessionLoggedIn() = 0 and p_web.PageName <> p_web.site.LoginPage
        packet.append('<li class="nt-menu-nodrop"><a' & p_web.CreateTip() & ' class="'&p_web.Combine('nt-menu-button nt-menu-button-drop', )&'" href="'&p_web._jsok(p_web._MakeUrl('/LoginForm?' & clip('')))&'">' & |
          '<div class="nt-menu-text">' & p_web.Translate('Login',Net:HtmlOk * 0 + Net:UnsafeHtmlOk * 0)&'</div></a>' & p_web.CRLF)
        do SendPacket
        do Menu:3:3
        packet.append('</li>' & p_web.CRLF)
  End
  If p_web.GetSessionLoggedIn() = 1 and p_web.PageName <> p_web.site.LoginPage
        packet.append('<li class="nt-menu-nodrop"><a' & p_web.CreateTip() & ' class="'&p_web.Combine('nt-menu-button nt-menu-button-drop', )&'" href="'&p_web._jsok(p_web._MakeUrl('/LoginForm?' & clip('')))&'">' & |
          '<div class="nt-menu-text">' & p_web.Translate('Logout',Net:HtmlOk * 0 + Net:UnsafeHtmlOk * 0)&'</div></a>' & p_web.CRLF)
        do SendPacket
        do Menu:4:3
        packet.append('</li>' & p_web.CRLF)
  End
  packet.append('</ul>' & p_web.CRLF & p_web.DivFooter(net:NoSend,'Double Drop Menu End',,,'nav'))
  do EndMenu:3
  ! javascript to make menu work.
  loc:options.Free(True)
  p_web.SetOption(loc:options,'ul',clip('menu'))    ! id of first UL for the menu
  p_web.SetOption(loc:options,'burger',clip('menu') & '_burger')  ! id of hamburger
  p_web.SetOption(loc:options,'icons','{{ submenu: "ui-icon-' & clip('circle-triangle-s') & '"}')
  p_web.SetOption(loc:options,' position','{{ my: "left top", at: "left+0 bottom+1"}')  ! bottom + 10?
  p_web.SetOption(loc:options,'touch',p_web.IsMenuTouch(),true) ! doesn't override existing setting.
  p_web.jQuery('#' & clip('menu'),'ntmenu',loc:options)
  do SendPacket

!--- Menu ---  'Home'
Menu:1:3  Routine
  case loc:menuStyle3
  of net:web:ddm
  packet.append('<ul id="ul-1-3" class="nt-menu-items">' & p_web.CRLF)
  of Net:Web:Accordion
  packet.append('<div class="nt-menu-accordion-items">' & p_web.CRLF)
  end ! case loc:menuStyle3 [1]
      Case loc:menuStyle3
      of Net:Web:Accordion
        packet.append('<div class="nt-menu-item">' & p_web.CRLF)
        packet.append(p_web.CreateMenuItem(loc:MenuStyle3,'Home','IndexPage',,'','',net:OpenAsLink,,,,,,,,,Net:HtmlOk * 0 + Net:UnsafeHtmlOk * 0, ,) & p_web.CRLF)
        packet.append('</div>' & p_web.CRLF)
        do SendPacket
      End ! Case loc:menuStyle3 [3]
  case loc:menuStyle3
  of net:web:ddm
  If packet.Instring('<li')
  packet.append('</ul>' & p_web.CRLF)
  Else
  packet.setValue('')
  End
  of Net:Web:Accordion
  packet.append('</div>' & p_web.CRLF)
  End ! case loc:menuStyle3 [2]
  do SendPacket

!--- Menu ---  'Browse'
Menu:2:3  Routine
  case loc:menuStyle3
  of net:web:ddm
  packet.append('<ul id="ul-2-3" class="nt-menu-items">' & p_web.CRLF)
  of Net:Web:Accordion
  packet.append('<div class="nt-menu-accordion-items">' & p_web.CRLF)
  end ! case loc:menuStyle3 [1]
  
    !--- Menu Item ---  'Browse'  --- 'Vendas' -- Level = 1 -- pParent = 0 -- found=0
          case loc:menuStyle3
          of net:web:ddm
            packet.append('<li class="nt-menu-item">' & p_web.CRLF)
          of net:web:taskpanel
          orof Net:Web:Accordion
            packet.append('<div class="nt-menu-item">' & p_web.CRLF)
          end ! case loc:menuStyle3 [4]
            packet.append(p_web.CreateMenuItem(loc:MenuStyle3,'Vendas','Browsevendas',,,'',net:OpenAsLink,Net:Browse,,,,'16','16','',0,Net:HtmlOk * 0 + Net:UnsafeHtmlOk * 0, ,) & p_web.CRLF)
          case loc:menuStyle3
          of net:web:ddm
            packet.append('</li>' & p_web.CRLF)
          of net:web:taskpanel
          orof Net:Web:Accordion
            packet.append('</div>' & p_web.CRLF)
          end ! loc:menuStyle3 [7]
  case loc:menuStyle3
  of net:web:ddm
  If packet.Instring('<li')
  packet.append('</ul>' & p_web.CRLF)
  Else
  packet.setValue('')
  End
  of Net:Web:Accordion
  packet.append('</div>' & p_web.CRLF)
  End ! case loc:menuStyle3 [2]
  do SendPacket

!--- Menu ---  'Login'
Menu:3:3  Routine
  case loc:menuStyle3
  of net:web:ddm
  packet.append('<ul id="ul-3-3" class="nt-menu-items">' & p_web.CRLF)
  of Net:Web:Accordion
  packet.append('<div class="nt-menu-accordion-items">' & p_web.CRLF)
  end ! case loc:menuStyle3 [1]
      Case loc:menuStyle3
      of Net:Web:Accordion
        packet.append('<div class="nt-menu-item">' & p_web.CRLF)
        packet.append(p_web.CreateMenuItem(loc:MenuStyle3,'Login','LoginForm',,'','',net:OpenAsLink,Net:Form,,,,,,,,Net:HtmlOk * 0 + Net:UnsafeHtmlOk * 0, ,) & p_web.CRLF)
        packet.append('</div>' & p_web.CRLF)
        do SendPacket
      End ! Case loc:menuStyle3 [3]
  case loc:menuStyle3
  of net:web:ddm
  If packet.Instring('<li')
  packet.append('</ul>' & p_web.CRLF)
  Else
  packet.setValue('')
  End
  of Net:Web:Accordion
  packet.append('</div>' & p_web.CRLF)
  End ! case loc:menuStyle3 [2]
  do SendPacket

!--- Menu ---  'Logout'
Menu:4:3  Routine
  case loc:menuStyle3
  of net:web:ddm
  packet.append('<ul id="ul-4-3" class="nt-menu-items">' & p_web.CRLF)
  of Net:Web:Accordion
  packet.append('<div class="nt-menu-accordion-items">' & p_web.CRLF)
  end ! case loc:menuStyle3 [1]
      Case loc:menuStyle3
      of Net:Web:Accordion
        packet.append('<div class="nt-menu-item">' & p_web.CRLF)
        packet.append(p_web.CreateMenuItem(loc:MenuStyle3,'Logout','LoginForm',,'','',net:OpenAsLink,Net:Form,,,,,,,,Net:HtmlOk * 0 + Net:UnsafeHtmlOk * 0, ,) & p_web.CRLF)
        packet.append('</div>' & p_web.CRLF)
        do SendPacket
      End ! Case loc:menuStyle3 [3]
  case loc:menuStyle3
  of net:web:ddm
  If packet.Instring('<li')
  packet.append('</ul>' & p_web.CRLF)
  Else
  packet.setValue('')
  End
  of Net:Web:Accordion
  packet.append('</div>' & p_web.CRLF)
  End ! case loc:menuStyle3 [2]
  do SendPacket

WebMenus:3   routine
  case loc:MenuStyle3
  of Net:Web:Accordion
    do WebMenus:Accordion:3
  of Net:Web:Ddm
    do WebMenus:DoubleDrop:3
  of Net:Web:TaskPanel
    do WebMenus:TaskPanel:3
  end

StartMenu:3  Routine

EndMenu:3   routine
  packet.append(p_web.comment('Menu Popups'))
  do SendPacket

HeadingPlain  Routine
  packet.append(p_web.AsciiToUTF(|
    '<<div class="nt-left nt-site-header-logo"><<img src="/images/logo.png" /><</div><<h1>ventekweb<</h1><13,10>'&|
    '',net:OnlyIfUTF,net:StoreAsAscii))
HeadingWhenLoggedOut  Routine
  packet.append(p_web.AsciiToUTF(|
    '<<div class="nt-left nt-site-header-logo"><<img src="/images/logo.png" /><</div><<h1>ventekweb<</h1><13,10>'&|
    '',net:OnlyIfUTF,net:StoreAsAscii))
HeadingWhenLoggedIn  Routine
  packet.append(p_web.AsciiToUTF(|
    '<<div class="nt-left nt-site-header-logo"><<img src="/images/logo.png" /><</div><<h1>ventekweb<</h1><13,10>'&|
    '',net:OnlyIfUTF,net:StoreAsAscii))
PageFooterTag        PROCEDURE  (NetWebServerWorker p_web)
! Use this procedure to "embed" html in other pages.
! on the web page use <!-- Net:PageFooterTag -->
!
! In this procedure set the packet stringTheory object, and call the SendPacket routine.
!
! EXAMPLE:
! packet.append('<strong>Hello World!</strong>'& p_web.CRLF)
! do SendPacket
loc:divname           string(252)
loc:parent            string(252)  ! should always be a lower-case string
packet                  StringTheory
timer                   long
loc:options             StringTheory ! options for jQuery calls
  CODE
  If p_web.Event='callpopups' then return.
  GlobalErrors.SetProcedureName('PageFooterTag')
  loc:parent = p_web.PlainText(lower(p_web.GetValue('_parentProc_')))
  If loc:parent <> ''
    loc:divname = lower(clip(loc:parent) & '_PageFooterTag')
  Else
    loc:divname = lower('PageFooterTag')
  End
      !%SecwinCtrlsDisplay = 0 ; %SecwinAccessGroupsNotCreated = 0

  If (p_web.site.ContentBody) and p_web.Ajax = 0
    p_web.DivFooter(,'contentbody_div')
  end
  p_web.DivHeader(loc:divname,'nt-left nt-width-100 nt-site-footer',,,' data-role="footer"',1,,,'PageFooterTag')
!----------- put your Header Panel html code here -----------------------------------
    !
      do SendPacket
    If (p_web.GetSessionLoggedIn() )
      Do LoggedIn
      do SendPacket
    End
    If (p_web.GetSessionLoggedIn() = 0)
      Do NotLoggedIn
      do SendPacket
    End
    if (p_web.GetSessionLoggedIn() and p_web.PageName <> p_web.site.LoginPage)
      ! parameter 1 is the session time
      ! parameter 2 is the name of the login page.
      ! parameter 3 is the id of the <div> in the html.
      p_web.Script('startCountDown('& int(p_web.site.SessionExpiryAfterHS/100) &',"'& clip(p_web.site.LoginPage) &'","countdown");')
    end
  
!----------- end of custom code ----------------------------------------
  do SendPacket
  p_web.DivFooter(,loc:divName)
  GlobalErrors.SetProcedureName()
  Return

!--------------------------------------
SendPacket  routine
  p_web.ParseHTML(packet,1,0,NET:NoHeader)
  packet.SetValue('')
LoggedIn  Routine
  packet.append(p_web.AsciiToUTF(|
    '<<div>Copyright <<!-- IvoNet 2019 --><</div><<div class="nt-right nt-countdown">Session Expires In:<<div id="countdown"><</div><</div><13,10>'&|
    '',net:OnlyIfUTF,net:StoreAsAscii))
NotLoggedIn  Routine
  packet.append(p_web.AsciiToUTF(|
    '<<div>Copyright <<!-- IvoNet 2019 --><</div><13,10>'&|
    '',net:OnlyIfUTF,net:StoreAsAscii))
IndexPage            PROCEDURE  (NetWebServerWorker p_web)
loc:x          Long
packet         StringTheory
loc:options    StringTheory ! options for jQuery calls

  CODE
  GlobalErrors.SetProcedureName('IndexPage')
  p_web.SetValue('_parentPage','IndexPage')
  p_web.publicpage = 1
  if p_web.sessionId = '' then p_web.NewSession().
  do Header
  packet.append(p_web.BodyOnLoad(p_web.Combine(p_web.site.bodyclass,'nt-body'),,p_web.Combine(p_web.site.bodydivclass,'nt-body-div')))
  packet.append(p_web.site.PageHeaderTag)
    do SendPacket
    Do body
    do SendPacket
  do Footer
  do SendPacket
  GlobalErrors.SetProcedureName()
  Return

SendPacket  Routine
  p_web.ParseHTML(packet,1,0,Net:NoHeader)
  packet.SetValue('')
Header  Routine
  packet.Append(p_web.w3Header(p_web.Combine(p_web.site.HtmlClass,),))
  p_web.SetCustomHTMLHeaders()
  packet.append('<head>' & p_web.CRLF &|
      '<title>'&p_web.Translate(p_web.site.PageTitle)&'</title>' & p_web.CRLF &|
      '<meta http-equiv="Content-Type" content="text/html; charset='&clip(p_web.site.HtmlCharset)&'" />' & p_web.CRLF &|
      clip(p_web.MetaHeaders) & p_web.CRLF)

  packet.append('<meta name="viewport" content="initial-scale=1">' & p_web.CRLF) ! experiment
  packet.append(p_web.IncludeStyles())
  packet.append(p_web.IncludeScripts())
  packet.append('</head>' & p_web.CRLF)
  p_web.ParseHTML(packet,1,0,Net:SendHeader+Net:DontCache)
  packet.setvalue('')

Footer  Routine
  packet.append('<!-- Net:SelectField -->')
  packet.append(p_web.site.PageFooterTag)
  do SendPacket
  p_web.FlushResponses() ! mobile wants this inside the body div.
  packet.append('</div>' & p_web.Comment('body_div') & p_web.CRLF)
  packet.append('</body>' & p_web.CRLF & '</html>' & p_web.CRLF)
  do SendPacket
body  Routine
  packet.append(p_web.AsciiToUTF(|
    '<<br /><13,10>'&|
    'Welcome<<br /><<br /><13,10>'&|
    '',net:OnlyIfUTF,net:StoreAsAscii))
LoginForm            PROCEDURE  (NetWebServerWorker p_web,long p_stage=0)
! the 'pre' routines are called when the form _opens_
! the 'post' routines are called when the 'save' or 'cancel' or 'delete' button is pressed
! remember this will happen on 2 separate threads. So use the SessionQueue here
! if you want to carry information from the pre, to the post, stage.

! there are many stages in the form
!   NET:WEB:StagePre which is called when the form _opens_
!   NET:WEB:StageValidate which is called when the form _closes_, before the record is written
!   NET:WEB:StagePost which is called _after_ the record is written
Ans                  LONG                                  !
Loc:Login            STRING(255)                           !
Loc:Password         STRING(255)                           !
Loc:Remember         LONG                                  !
loc:Hash             LONG                                  !
FilesOpened       Long
FilesErrorOnOpen  StringTheory
Loc:Login:IsInvalid  Long
Loc:Password:IsInvalid  Long
Loc:Remember:IsInvalid  Long
loc:Hash:IsInvalid  Long
loc:TabStyle               Long
loc:WebStyle               Long,over(loc:TabStyle)
loc:TabTo                  Long
loc:viewonly               Long
loc:silent                 Long
loc:formname               string(252)
loc:procedure              string(252)
loc:formaction             string(252)
loc:formactioncancel       string(252)
loc:formactioncanceltarget string(252)
loc:formactiontarget       string(252)
loc:extra                  string(252)
loc:capture                long
loc:AcceptTypes            String(252)
loc:autocomplete           String(20)
loc:enctype                string(252)
loc:javascript             string(JavascriptStringLen)
loc:tabs                   string(252)
loc:readonly               String(32)
loc:lookuponly             String(32)
loc:invalid                String(100)
loc:alert                  String(1024)
loc:comment                String(252)
loc:prompt                 String(1024)
loc:invalidtab             Long
loc:tabnumber              Long
loc:retrying               Long
loc:lookupdone             Long
loc:tabheight              Long
loc:action                 string(40)
loc:act                    Long
loc:width                  String(40)
loc:rowstyle               String(252)
loc:buttonset              String(64)
loc:even                   Long
loc:columncounter          Long
loc:maxcolumns             Long
loc:rowstarted             Long
loc:cellstarted            Long
loc:FirstInCell            Long
loc:options                StringTheory ! options for jQuery calls
loc:popup                  long
loc:inNetWebPopup          long
loc:poppedup               long
loc:ok                     long
loc:parent                 string(252)   ! should always be a lower-case string
loc:heading                string(1024)
loc:fieldclass             string(StyleStringSize)
loc:frontloading           long
loc:noFocus                long
loc:FormOnSave             long
packet                       StringTheory
  CODE
  loc:procedure = lower('LoginForm')
  GlobalErrors.SetProcedureName('LoginForm')
  if p_stage = 0 and p_web.GetValue('_CallPopups') <> 0
    p_stage = Net:Web:Popup ! required for forms in DLL's, where PreCall doesn't know it's a form.
  elsif p_stage = 0 and p_Web.Ajax = 1
    case lower(p_web.Event)
    of 'gainfocus'
      p_stage = Net:Web:FocusBack
    of 'parentupdated'
      loc:noFocus = true ! the form regenerates, but nothing gets focus.
    end
  end
  loc:formname = lower('LoginForm_frm')
  loc:parent = p_web.PlainText(lower(p_web.GetValue('_parentProc_')))
  loc:popup = p_web.GetValue('_popup_')
  loc:FormOnSave = Net:CloseForm
  loc:silent = p_web.GetValue('_silent_')

  loc:TabStyle = Net:Web:Rounded
  do SetAction
  ans = band(p_stage,255)
  case p_stage
  of net:web:Generate
    if loc:silent = false
      if p_web.Event = 'parentnewselection' or  p_web.GetValue('LoginForm:parentIs') = 'Browse' ! allow for form used as a child of a browse, default to change mode.
        p_web.FormReady('LoginForm','Change')
      Else
        p_web.FormReady('LoginForm','')
      End
    End
    if p_web.site.frontloaded and p_web.Ajax and loc:popup = 1
      loc:FrontLoading = net:GeneratingData
    else
      If p_web.site.ContentBody <> '' and lower(p_web.GetValue('_cb_')) = lower('LoginForm')
        p_web.DivHeader(p_web.site.ContentBody,p_web.site.contentbodydivclass)
      End
      p_web.DivHeader('LoginForm',p_web.combine(p_web.site.style.formdiv,' nt-fix-center nt-width-400px'))
      p_web.DivHeader('LoginForm_alert',p_web.combine(p_web.site.MessageClass,' nt-hidden'))
      p_web.DivFooter()
    End
    do PreUpdate
    do SetPics
    if loc:FrontLoading = net:GeneratingData
      do GenerateData
    else
      do GenerateForm
      p_web.DivFooter()
      If p_web.site.ContentBody <> '' and lower(p_web.GetValue('_cb_')) = lower('LoginForm')
        p_web.DivFooter()
      End
    End
  of Net:Web:SetPics
  orof Net:Web:SetPics + NET:WEB:StageValidate
    do SetPics

  of Net:Web:MakeReady

  of Net:Web:Init
  orof Net:Web:Init + Net:InsertRecord
  orof Net:Web:Init + Net:ChangeRecord
  orof Net:Web:Init + Net:CopyRecord
  orof Net:Web:Init + Net:ViewRecord
  orof Net:Web:Init + Net:DeleteRecord
    do InitForm

  of Net:Web:FocusBack
    do GotFocusBack

  of net:web:popup
    loc:inNetWebPopup = 1
    loc:poppedup = p_web.GetValue('_LoginForm:_poppedup_')
    if p_web.site.FrontLoaded then loc:popup = 1.
    if loc:poppedup = 0 and p_Web.Ajax = 0
      If p_web.GetPreCall('LoginForm') = 0 and (p_web.GetValue('_CallPopups') = 0 or p_web.GetValue('_CallPopups') = 1)
        p_web.AddPreCall('LoginForm')
        p_web.DivHeader('popup_LoginForm','nt-hidden',,,,1,,,'popup_LoginForm')
        p_web.DivHeader('LoginForm',p_web.combine(p_web.site.style.formdiv,' nt-fix-center nt-width-400px'),,,,1)
        If p_web.site.FrontLoaded
          loc:frontloading = net:GeneratingPage
          do GenerateForm
        End
        p_web.DivFooter()
        p_web.DivFooter(,lower('popup_LoginForm End'))
        do Heading
        loc:options.Free(True)
        p_web.SetOption(loc:options,'close','function(event, ui) {{ ntd.pop(); }')
        p_web.SetOption(loc:options,'autoOpen','false')
        p_web.SetOption(loc:options,'width',600)
        p_web.SetOption(loc:options,'modal','true')
        p_web.SetOption(loc:options,'title',loc:Heading)
        p_web.SetOption(loc:options,'position','[''center'','& clip(15)&']')
        p_web.SetOption(loc:options,'addsec','')
        If p_web.site.DefaultFormOpenAnimation
          p_web.SetOption(loc:options,'show','{{' & clip(p_web.site.DefaultFormOpenAnimation) & '}')
        End
        If p_web.site.DefaultFormCloseAnimation
          p_web.SetOption(loc:options,'hide','{{' & clip(p_web.site.DefaultFormCloseAnimation) & '}')
        End
        p_web.SetOption(loc:options,'closeText',p_web.translate(p_web.site.CloseButton.TextValue))
        p_web.jQuery('#' & lower('popup_LoginForm_div'),'dialog',loc:options,'.removeClass("nt-hidden")')
      End
      do popups ! includes all the other popups dependant on this procedure
      loc:poppedup = 1
      p_web.SetValue('_LoginForm:_poppedup_',1)
    end

  of Net:Web:AfterLookup + Net:Web:Cancel
    loc:LookupDone = 0
    do AfterLookup
    if p_web.Ajax = 1 and loc:popup
      p_web.script('$(''#popup_'&lower('LoginForm')&'_div'').dialog(''close'');')
    end

  of Net:Web:AfterLookup
    loc:LookupDone = 1
    do AfterLookup

  of Net:Web:Cancel
    do CancelForm
    if p_web.Ajax = 1 and loc:popup
      p_web.script('$(''#popup_'&lower('LoginForm')&'_div'').dialog(''close'');')
    end

  of Net:InsertRecord + NET:WEB:StagePre
    if p_web._InsertAfterSave = 0
      p_web.setsessionvalue('SaveReferLoginForm',p_web.getPageName(p_web.RequestReferer))
    end
    do StoreMem
    do PreInsert
  of Net:InsertRecord + NET:WEB:StageValidate
    do RestoreMem
    do ValidateInsert
  of Net:InsertRecord + NET:WEB:Populate
    do OpenFiles
    do InitForm
    do PreInsert
    do CloseFiles
  of Net:CopyRecord + NET:WEB:StagePre
    p_web.setsessionvalue('SaveReferLoginForm',p_web.getPageName(p_web.RequestReferer))
    do StoreMem
    do PreCopy
  of Net:CopyRecord + NET:WEB:StageValidate
    do RestoreMem
    do ValidateCopy
  of Net:CopyRecord + NET:WEB:Populate
    do PreCopy
    p_web.setsessionvalue('showtab_LoginForm',0)
  of Net:ChangeRecord + NET:WEB:StagePre
    p_web.setsessionvalue('SaveReferLoginForm',p_web.getPageName(p_web.RequestReferer))
    do StoreMem
    do PreUpdate
    p_web.setsessionvalue('showtab_LoginForm',0)
  of Net:ChangeRecord + NET:WEB:StageValidate
    do RestoreMem
    If false
    ElsIf loc:act = Net:InsertRecord
      do ValidateInsert
    ElsIf loc:act = Net:CopyRecord
      do ValidateCopy
    Else
      do ValidateUpdate
    End
  of Net:ChangeRecord + NET:WEB:StagePost
    do RestoreMem
    do PostUpdate
  of Net:ChangeRecord + NET:WEB:Populate
    do OpenFiles
    do InitForm
    do PreUpdate
    do CloseFiles
    p_web.setsessionvalue('showtab_LoginForm',0)
  of Net:DeleteRecord + NET:WEB:StagePre
    p_web.setsessionvalue('SaveReferLoginForm',p_web.getPageName(p_web.RequestReferer))
    do StoreMem
    do PreDelete
  of Net:DeleteRecord + NET:WEB:StageValidate
    do RestoreMem
    do ValidateDelete
  of Net:ViewRecord + NET:WEB:Populate
    do OpenFiles
    do InitForm
    do PreUpdate
    p_web.setsessionvalue('showtab_LoginForm',0)
    do CloseFiles

  of Net:ViewRecord + NET:WEB:StagePre
    p_web.setsessionvalue('SaveReferLoginForm',p_web.getPageName(p_web.RequestReferer))
    do StoreMem
    do PreUpdate
    p_web.setsessionvalue('showtab_LoginForm',0)
  of Net:Web:NextTab
    do NextTab
  of Net:Web:Div
    If p_web.site.FrontLoaded
      loc:frontloading = net:GeneratingData
    End
    do CallDiv
  Else
    ans = 0
  End ! Case
  If Loc:Invalid
    Ans = Net:Web:InvalidRecord
      p_web.requestfilename = p_web.formsettings.parentpage
      if p_web.GetValue('_parentPage') = ''
        p_web.SetValue('_parentPage',p_web.requestfilename)
      End
    p_web.SetValue('retryfield',Loc:Invalid)
    p_web.setsessionvalue('showtab_LoginForm',Loc:InvalidTab)
  ElsIf band(p_stage,NET:WEB:StageValidate) > 0 and band(p_stage,Net:DeleteRecord) <> Net:DeleteRecord and band(p_stage,Net:WriteMask) > 0 and p_web.Ajax = 1 and loc:popup
    If p_web.IfExistsValue('_stayopen_')
    ! only a partial save, so don't complete the form.
    ElsIf loc:FormOnSave = Net:InsertAgain
      If band(loc:act,Net:InsertRecord) <> Net:InsertRecord
        p_web.script('$(''#popup_'&lower('LoginForm')&'_div'').dialog(''close'');')
      End
    Else
      p_web.script('$(''#popup_'&lower('LoginForm')&'_div'').dialog(''close'');')
    End
  End
  if loc:alert <> ''
    p_web.SetAlert(loc:alert, net:Alert + Net:Message,'LoginForm',1)
  end
  GlobalErrors.SetProcedureName()
  return Ans

OpenFiles  ROUTINE
  FilesErrorOnOpen.SetValue('')
  FilesOpened = True
!--------------------------------------
CloseFiles ROUTINE
  IF FilesOpened THEN
     FilesOpened = False
  END

AlertParent  routine
  DATA
parent_       string(100)
parentrid_    string(100)
  CODE
  p_web.pushEvent('childupdated')
  parent_ = p_web.GetValue('_ParentProc_')
  If loc:Parent
    p_web.SetValue('_ParentProc_','')
    p_web.PageName = clip(loc:parent) & '_' & lower('LoginForm') & '_value'
    p_web._SendFile(p_web.PageName)
  Elsif p_web.formsettings.parentpage
    parentrid_ = p_web.GetValue('_parentrid_')
    p_web.SetValue('_ParentProc_','')
    p_web.SetValue('_parentrid_')
    p_web.PageName = clip(p_web.formsettings.parentpage) & '_' & lower('LoginForm') & '_value'
    p_web._SendFile(p_web.PageName)
    p_web.SetValue('_parentrid_',parentrid_)
  End
  p_web.SetValue('_ParentProc_',parent_)
  p_web.popEvent()

GotFocusBack  routine
  DATA
loc:Equate  string(252)
loc:Done    long
  CODE

InitForm       Routine
  DATA
LF  &FILE
  CODE
  p_web.SetValue('LoginForm_form:inited_',1)
  p_web.formsettings.file = ''
  p_web.formsettings.key = ''
  do RestoreMem

SetFormSettings  routine
  data
  code
  If p_web.Formstate = ''
    p_web.formsettings.file = ''
    p_web.formsettings.key = ''
    p_web.formsettings.action = Net:ChangeRecord
    clear(p_web.formsettings.recordid)
    clear(p_web.formsettings.FieldName)
    If p_web.GetValue('_parentPage') <> ''
      p_web.formsettings.parentpage = p_web.GetValue('_parentPage')
    else
      p_web.formsettings.parentpage = 'LoginForm'
    end
    p_web.formsettings.proc = 'LoginForm'
    clear(p_web.formsettings.target)
    p_web.FormState = p_web.AddSettings()
  end

CancelForm  Routine
  p_web.SetSessionValue('LoginForm:Active',0)

SendMessage Routine
  p_web.Message('Alert',loc:alert,p_web.site.MessageClass,Net:Send,1)

SetPics        Routine

AfterLookup Routine
  loc:TabNumber = -1
    loc:TabNumber += 1
  p_web.DeleteValue('LookupField')

StoreMem  Routine
  if p_web.IfExistsValue('Loc:Login') = 0
    p_web.SetSessionValue('Loc:Login',Loc:Login)
  Else
    Loc:Login = p_web.GetSessionValue('Loc:Login')
  End
  if p_web.IfExistsValue('Loc:Password') = 0
    p_web.SetSessionValue('Loc:Password',Loc:Password)
  Else
    Loc:Password = p_web.GetSessionValue('Loc:Password')
  End
  if p_web.IfExistsValue('Loc:Remember') = 0
    p_web.SetSessionValue('Loc:Remember',Loc:Remember)
  Else
    Loc:Remember = p_web.GetSessionValue('Loc:Remember')
  End
  if p_web.IfExistsValue('loc:Hash') = 0
    p_web.SetSessionValue('loc:Hash',loc:Hash)
  Else
    loc:Hash = p_web.GetSessionValue('loc:Hash')
  End

! RestoreMem primes all the non-file fields with their session value. Useful in Validate and PostAction routines
RestoreMem  Routine
  !FormSource=Memory
  if p_web.IfExistsValue('Loc:Login')
    Loc:Login = p_web.GetValue('Loc:Login')
    p_web.SetSessionValue('Loc:Login',Loc:Login)
  Elsif p_web.IfExistsSessionValue('Loc:Login')
    Loc:Login = p_web.GetSessionValue('Loc:Login')
  End
  if p_web.IfExistsValue('Loc:Password')
    Loc:Password = p_web.GetValue('Loc:Password')
    p_web.SetSessionValue('Loc:Password',Loc:Password)
  Elsif p_web.IfExistsSessionValue('Loc:Password')
    Loc:Password = p_web.GetSessionValue('Loc:Password')
  End
  if p_web.IfExistsValue('Loc:Remember')
    Loc:Remember = p_web.GetValue('Loc:Remember')
    p_web.SetSessionValue('Loc:Remember',Loc:Remember)
  Elsif p_web.IfExistsSessionValue('Loc:Remember')
    Loc:Remember = p_web.GetSessionValue('Loc:Remember')
  End
  if p_web.IfExistsValue('loc:Hash')
    loc:Hash = p_web.GetValue('loc:Hash')
    p_web.SetSessionValue('loc:Hash',loc:Hash)
  Elsif p_web.IfExistsSessionValue('loc:Hash')
    loc:Hash = p_web.GetSessionValue('loc:Hash')
  End

SetAction  routine
  data
  code
  If Band(p_Stage,Net:ViewRecord) = Net:ViewRecord
    Loc:ViewOnly = true
    loc:action = p_web.site.ViewPromptText
    loc:act = Net:ViewRecord
    p_web.SetValue('_viewonly_',1) ! cascade ViewOnly mode to child procedures
    p_web.SetSessionValue('LoginForm_CurrentAction',Net:ViewRecord)
  Else
    Case p_web.GetSessionValue('LoginForm_CurrentAction')
    of Net:InsertRecord
      loc:action = p_web.site.InsertPromptText
      loc:act = Net:InsertRecord
    of Net:CopyRecord
      loc:action = p_web.site.CopyPromptText
      loc:act = Net:CopyRecord
    of Net:ChangeRecord
      loc:action = p_web.site.ChangePromptText
      loc:act = Net:ChangeRecord
    of Net:DeleteRecord
      loc:action = p_web.site.DeletePromptText
      loc:act = Net:DeleteRecord
    of Net:ViewRecord
      Loc:ViewOnly = true
      loc:action = p_web.site.ViewPromptText
      loc:act = Net:ViewRecord
    Else
      loc:action = ''
      loc:act = 0
    End
  End

SetFormAction  routine
  data
  code
  loc:FormAction = p_web.GetValue('onsave')
  If loc:formaction = 'stay'
    loc:FormAction = p_web.Requestfilename
  Else
    loc:formaction = 'IndexPage'
  End
  if p_web.GetValue('_ChainToPage_') <> ''
    loc:formaction = p_web.GetValue('_ChainToPage_')
    p_web.SetSessionValue('LoginForm_ChainTo',loc:FormAction)
    loc:formactiontarget = '_self'
  ElsIf p_web.IfExistsSessionValue('LoginForm_ChainTo')
    loc:formaction = p_web.GetSessionValue('LoginForm_ChainTo')
    loc:formactiontarget = '_self'
  End
  If loc:FormActionTarget = ''
    loc:FormActionTarget = '_self'
  End
  If loc:formaction = ''
    loc:formaction = lower(p_web.getPageName(p_web.RequestReferer))
  End
  loc:FormActionCancel = loc:FormAction
  If loc:FormActionCancelTarget = ''
    loc:FormActionCancelTarget = '_self'
  End

! front-loaded forms only need the fields updated - not the structure generated.
! this routine is called when loc:frontloaded = net:GeneratingData
GenerateData  routine
  data
loc:send     StringTheory
loc:checked  String(50)
  code
  do Refresh::Loc:Login
  do Refresh::Loc:Password
  do Refresh::Loc:Remember
  do Refresh::loc:Hash
  p_web.Script('$(''#'&clip(loc:formname)&''').find(''#FormState'').val('''&clip(p_web.FormState)&''');' & p_web.CRLF)
  p_web.ntForm(loc:formname,'show')

GenerateForm  Routine
  data
loc:disabled  Long
  code
  p_web.ClearBrowse('LoginForm')
  do LoadRelatedRecords
  ! change the 'save' button so it says 'login'
  p_web.site.SaveButton.TextValue = 'Login'
  p_web.site.SaveButton.Tooltip = 'Click here to Login'
  
  ! coming to the login screen automatically logs the user out.
  ! Note that logging out does not delete the session.
  p_web.SetSessionLoggedIn(0)
  do SetFormAction
  do ntForm
 Loc:Login = p_web.RestoreValue('Loc:Login')
 Loc:Password = p_web.RestoreValue('Loc:Password')
 Loc:Remember = p_web.RestoreValue('Loc:Remember')
 loc:Hash = p_web.RestoreValue('loc:Hash')
  If p_web.IfExistsValue('retryField')
    loc:retrying = 1
  End
  loc:viewonly = Choose(p_web.IfExistsValue('View_btn'),1,loc:viewonly)
  p_web.SetValue('_viewonly_',loc:viewonly)
  packet.append('<form action="'&clip(loc:formaction)&'" '&clip(loc:enctype)&' method="post" name="'&clip(loc:formname)&'" id="'&clip(loc:formname)&'" target="'&clip(loc:FormActionTarget)&'" onsubmit="osf(this);">' & p_web.CRLF)
  if loc:viewonly and p_web.IfExistsValue('LookupField')
    packet.append(p_web.CreateInput('hidden','LookupField',p_web.GetValue('LookupField'))  & p_web.CRLF)
  end
  packet.append(p_web.CreateInput('hidden','FormState',p_web.FormState)  & p_web.CRLF)
  do SendPacket
  do Heading
    Case loc:TabStyle
    of Net:Web:Carousel
    packet.append(p_web.DivHeader('Tab_LoginForm',p_web.combine(p_web.site.style.FormTabOuter,,' nt-tab-carousel'),Net:NoSend))
    Else
    packet.append(p_web.DivHeader('Tab_LoginForm',p_web.combine(p_web.site.style.FormTabOuter,),Net:NoSend))
    End
    Case loc:TabStyle
    of Net:Web:Tab
      packet.append('<ul class="'&p_web.combine(p_web.site.style.FormTabTitle,)&'">'& p_web.CRLF)
      packet.append('<li><a href="#' & lower('tab_LoginForm0_div') & '">' & p_web.Translate('Login',true)&'</a></li>'& p_web.CRLF)
      packet.append('</ul>'& p_web.CRLF)
    end
    do SendPacket
  if p_web.event = 'callpopups'
    p_web.PushEvent('callpopups')
  else
    p_web.PushEvent('generate')
  end
  do GenerateTab0
  packet.append(p_web.DivFooter(Net:NoSend))
  do SendPacket
  p_web.PopEvent()
      if loc:ViewOnly = 0
        packet.append('<div id="LoginForm_saveset" class="'&p_web.combine(p_web.site.style.FormSaveButtonSet,)&'">')
        If loc:TabStyle = Net:Web:Wizard
          loc:javascript = ''
          packet.append(p_web.CreateStdButton('button',NET:WEB:WizPreviousButton,loc:formname,,,loc:javascript,,,,'LoginForm')) !f1
          packet.append(p_web.CreateStdButton('button',NET:WEB:WizNextButton,loc:formname,,,loc:javascript,,,,'LoginForm')) !f2
        End
        loc:javascript = ''
        packet.append(p_web.CreateStdButton('button',Net:Web:SaveButton,loc:formname,,,loc:javascript,,loc:disabled,,'LoginForm',1)) !f3
        packet.append('</div>'  & p_web.CRLF) ! end id="LoginForm_saveset"
        If p_web.site.UseSaveButtonSet
          loc:options.Free(True)
          p_web.jQuery('#' & 'LoginForm_saveset','controlgroup',loc:options)
        End
      Else
        packet.append('<div id="LoginForm_saveset" class="'&p_web.combine(p_web.site.style.FormSaveButtonSet,)&'">')
        If loc:TabStyle = Net:Web:Wizard
          loc:javascript = ''
          packet.append(p_web.CreateStdButton('button',NET:WEB:WizPreviousButton,loc:formname,,,loc:javascript,,,,'LoginForm')) !f8
          packet.append(p_web.CreateStdButton('button',NET:WEB:WizNextButton,loc:formname,,,loc:javascript,,,,'LoginForm')) !f9
        End
        loc:javascript = ''
        if loc:popup
          loc:javascript = clip(loc:javascript) & 'ntd.close();'
          packet.append(p_web.CreateStdButton('button',Net:Web:CloseButton,loc:formname,,,loc:javascript,,loc:disabled,,'LoginForm')) !f10
        else
          packet.append(p_web.CreateStdButton('submit',Net:Web:CloseButton,loc:formname,loc:formactioncancel,loc:formactioncanceltarget,,,loc:disabled,,'LoginForm')) !f11
        end
        packet.append('</div>' & p_web.CRLF)
        If p_web.site.UseSaveButtonSet
          loc:options.Free(True)
          p_web.jQuery('#' & 'LoginForm_saveset','controlgroup',loc:options)
        End
      End
  if loc:retrying
    p_web.SetValue('SelectField',clip(loc:formname) & '.' & p_web.GetValue('retryfield'))
  Elsif p_web.IfExistsValue('Select_btn')
  Else
    If False
    Else ! If False
        If loc:noFocus = false
          p_web.SetValue('SelectField',clip(loc:formname) & '.Loc:Login')
        End
    End ! If False
  End
    loc:options.Free(True)
    Case loc:TabStyle
    of Net:Web:Accordion
      p_web.SetOption(loc:options,'heightStyle','content')
      p_web.SetOption(loc:options,'active', choose(p_web.GetSessionValue('showtab_LoginForm')>0,p_web.GetSessionValue('showtab_LoginForm'),'0'))
      p_web.SetOption(loc:options,'activate', 'function(event, ui) {{ TabChanged(''LoginForm_tabchanged'',$(this).accordion("option","active")); }')
      p_web.jQuery('#' & lower('Tab_LoginForm') & '_div','accordion',loc:options)
    of Net:Web:Tab
      p_web.SetOption(loc:options,'activate','function(event,ui){{TabChanged(''LoginForm_tabchanged'',$(this).tabs("option","active"));}')
      p_web.SetOption(loc:options,'active',choose(p_web.GetSessionValue('showtab_LoginForm')>0,p_web.GetSessionValue('showtab_LoginForm'),'0'))
      p_web.jQuery('#' & lower('Tab_LoginForm') & '_div','tabs',loc:options)
    of Net:Web:Wizard
       p_web.SetOption(loc:options,'procedure','LoginForm')
       p_web.SetOption(loc:options,'popup',loc:popup)
       p_web.SetOption(loc:options,'active',choose(p_web.GetSessionValue('showtab_LoginForm')>0,p_web.GetSessionValue('showtab_LoginForm'),0))
       p_web.SetOption(loc:options,'ntform', '#' & clip(loc:formname))
       p_web.ntWiz('LoginForm',loc:options)
    of Net:Web:Carousel
       p_web.SetOption(loc:options,'dots','^true')
       p_web.SetOption(loc:options,'autoplay','^false')
       p_web.jQuery('#' & lower('tab_LoginForm_div'),'slick',loc:options)
    end
    do SendPacket
  packet.append('</form>'&p_web.CRLF)
  do SendPacket
  loc:options.Free(True)
  do SendPacket
  If not (p_web.site.FrontLoaded and loc:frontloading = net:GeneratingPage) ! don't want to do popups here if generating in front-loaded mode from net:web:popup stage
    do Popups
  end
  if p_web.Ajax then do AutoLookups.

  do SendPacket

Popups  Routine
  If p_web.Ajax = 0
    p_web.PushEvent('callpopups')
    do AutoLookups
    p_web.AddPreCall('LoginForm')
    p_web.SetValue('_popup_',0)
    p_web.PopEvent()
  End

ntForm Routine
  data
loc:BuildOptions                stringTheory
  code
  p_web.SetOption(loc:options,'id',clip(loc:formname))
  p_web.SetOption(loc:options,'procedure', lower('LoginForm'))
  p_web.SetOption(loc:options,'parent', lower(clip(loc:parent)))
  p_web.SetOption(loc:options,'title',loc:Heading)
  p_web.SetOption(loc:options,'tabType', loc:TabStyle)
  p_web.SetOption(loc:options,'action', loc:formaction)
  p_web.SetOption(loc:options,'actionCancel', loc:formactioncancel)
  p_web.SetOption(loc:options,'actionCancelTarget',loc:formactioncanceltarget)
  p_web.SetOption(loc:options,'actionTarget', loc:formactiontarget)
  p_web.SetOption(loc:options,'confirmText',p_web.translate('Confirm'))
  p_web.SetOption(loc:options,'confirmDeleteMessage',p_web.translate('Are you sure you want to delete this record?'))
  p_web.SetOption(loc:options,'yesDeleteText',p_web.translate('Delete'))
  p_web.SetOption(loc:options,'noDeleteText',p_web.translate('No'))
  p_web.SetOption(loc:options,'confirmDelete',p_web.site.DefaultDeletePrompt)
  p_web.SetOption(loc:options,'confirmCancelMessage',p_web.translate('Are you sure you want to cancel the changes?'))
  p_web.SetOption(loc:options,'yesCancelText',p_web.translate('Cancel'))
  p_web.SetOption(loc:options,'noCancelText',p_web.translate('No'))
  p_web.SetOption(loc:options,'confirmCancel',p_web.site.DefaultCancelPrompt)
  p_web.SetOption(loc:options,'popup', loc:popup)
  p_web.SetOption(loc:options,'focus', p_web.focus)
  p_web.ntForm(loc:formname,loc:options)
  If loc:silent
    p_web.ntForm(loc:formname,'hide')
    ans = 0
  End

AutoLookups  Routine
GenerateTab0  Routine
      Case loc:TabStyle
      of Net:Web:Accordion
        packet.append('<h3 class="'&p_web.combine(p_web.site.style.FormTabTitle,)&'">'&p_web.Translate('Login')&'</h3>' & p_web.CRLF & p_web.DivHeader('tab_LoginForm0',p_web.combine(p_web.site.style.FormTabInner,,),Net:NoSend,,,1))
      of Net:Web:Tab
        packet.append(p_web.DivHeader('tab_LoginForm0',p_web.combine(p_web.site.style.FormTabInner,,),Net:NoSend,,,1))
      of Net:Web:Wizard
        packet.append(p_web.DivHeader('tab_LoginForm0',p_web.combine(clip(p_web.site.style.FormTabInner) & ' nt-wizard',,),Net:NoSend,,,1))
      of Net:Web:Carousel
        packet.append(p_web.DivHeader('tab_LoginForm0',p_web.combine(clip(p_web.site.style.FormTabInner) & ' nt-carousel',,),Net:NoSend,,,1))
      of Net:Web:Rounded
        packet.append(p_web.DivHeader('tab_LoginForm0',p_web.combine(clip(p_web.site.style.FormTabInner) & ' nt-rounded',,),Net:NoSend,,,1) & '<div class="ui-state-default nt-rounded-header ui-corner-all">' & p_web.Translate('Login')&'</div>'& p_web.CRLF)
      of Net:Web:Plain
        packet.append(p_web.DivHeader('tab_LoginForm0',p_web.combine(clip(p_web.site.style.FormTabInner) & ' nt-plain',,),Net:NoSend,,,1) & '<fieldset class="ui-tabs ui-widget ui-widget-content ui-corner-all plain"><legend>' & p_web.Translate('Login')&'</legend>' & p_web.CRLF)
      of Net:Web:None
        packet.append(p_web.DivHeader('tab_LoginForm0',p_web.combine(p_web.site.style.FormTabInner,,),Net:NoSend,,,1))
      end
      do SendPacket
      packet.append(p_web.FormTableStart('LoginForm_container',,'300',Net:Default))
      do SendPacket
        if loc:rowstarted = 0
          packet.append(p_web.FormTableRowStart( p_web.NoColon(lower('Loc:Login_row')) ,p_web.Combine(,),Net:Default))
          if loc:columncounter > loc:maxcolumns then loc:maxcolumns = loc:columncounter.
          loc:columncounter = 0
          loc:rowstarted = 1
        end
        do SendPacket
        loc:width = ''
        If loc:cellstarted = 0
          packet.append(p_web.FormTableCellStart( ,' nt-prompt-align-middle' , , , clip(loc:width) , Net:Default, net:CellTypePrompt))
          loc:columncounter += 1
          do SendPacket
          loc:cellstarted = 1
          loc:FirstInCell = 1
        Else
          loc:FirstInCell = 0
        End
        do Prompt::Loc:Login
        If loc:FirstInCell = 1
          packet.append(p_web.FormTableCellEnd( ,Net:Default))
          loc:cellstarted = 0
          do SendPacket
        End
        if loc:cellstarted = 0
          loc:width = ''
          packet.append(p_web.FormTableCellStart( , , , , clip(loc:width) , Net:Default, net:CellTypeValue))
          loc:columncounter += 1
          do SendPacket
          loc:cellstarted = 1
        end
        do Value::Loc:Login
        packet.append(p_web.FormTableCellEnd( ,Net:Default))
        loc:cellstarted = 0
          loc:width = ''
          packet.append(p_web.FormTableCellStart( , , , , clip(loc:width) , Net:Default, net:CellTypeComment))
          loc:columncounter += 1
          do SendPacket
          do Comment::Loc:Login
          packet.append(p_web.FormTableCellEnd( ,Net:Default))
          loc:cellstarted = 0
          do SendPacket
        if loc:cellstarted
          packet.append(p_web.FormTableCellEnd( ,Net:Default))
          packet.append(p_web.FormTableRowEnd( ,Net:Default))
          loc:cellstarted = 0
        Else
          packet.append(p_web.FormTableRowEnd( ,Net:Default))
        End
        loc:rowstarted = 0
        loc:cellstarted = 0
      do SendPacket
        if loc:rowstarted = 0
          packet.append(p_web.FormTableRowStart( p_web.NoColon(lower('Loc:Password_row')) ,p_web.Combine(,),Net:Default))
          if loc:columncounter > loc:maxcolumns then loc:maxcolumns = loc:columncounter.
          loc:columncounter = 0
          loc:rowstarted = 1
        end
        do SendPacket
        loc:width = ''
        If loc:cellstarted = 0
          packet.append(p_web.FormTableCellStart( ,' nt-prompt-align-middle' , , , clip(loc:width) , Net:Default, net:CellTypePrompt))
          loc:columncounter += 1
          do SendPacket
          loc:cellstarted = 1
          loc:FirstInCell = 1
        Else
          loc:FirstInCell = 0
        End
        do Prompt::Loc:Password
        If loc:FirstInCell = 1
          packet.append(p_web.FormTableCellEnd( ,Net:Default))
          loc:cellstarted = 0
          do SendPacket
        End
        if loc:cellstarted = 0
          loc:width = ''
          packet.append(p_web.FormTableCellStart( , , , , clip(loc:width) , Net:Default, net:CellTypeValue))
          loc:columncounter += 1
          do SendPacket
          loc:cellstarted = 1
        end
        do Value::Loc:Password
        packet.append(p_web.FormTableCellEnd( ,Net:Default))
        loc:cellstarted = 0
          loc:width = ''
          packet.append(p_web.FormTableCellStart( , , , , clip(loc:width) , Net:Default, net:CellTypeComment))
          loc:columncounter += 1
          do SendPacket
          do Comment::Loc:Password
          packet.append(p_web.FormTableCellEnd( ,Net:Default))
          loc:cellstarted = 0
          do SendPacket
        if loc:cellstarted
          packet.append(p_web.FormTableCellEnd( ,Net:Default))
          packet.append(p_web.FormTableRowEnd( ,Net:Default))
          loc:cellstarted = 0
        Else
          packet.append(p_web.FormTableRowEnd( ,Net:Default))
        End
        loc:rowstarted = 0
        loc:cellstarted = 0
      do SendPacket
        if loc:rowstarted = 0
          packet.append(p_web.FormTableRowStart( p_web.NoColon(lower('Loc:Remember_row')) ,p_web.Combine(,),Net:Default))
          if loc:columncounter > loc:maxcolumns then loc:maxcolumns = loc:columncounter.
          loc:columncounter = 0
          loc:rowstarted = 1
        end
        do SendPacket
        loc:width = ''
        If loc:cellstarted = 0
          packet.append(p_web.FormTableCellStart( ,' nt-prompt-align-middle' , , , clip(loc:width) , Net:Default, net:CellTypePrompt))
          loc:columncounter += 1
          do SendPacket
          loc:cellstarted = 1
          loc:FirstInCell = 1
        Else
          loc:FirstInCell = 0
        End
        do Prompt::Loc:Remember
        If loc:FirstInCell = 1
          packet.append(p_web.FormTableCellEnd( ,Net:Default))
          loc:cellstarted = 0
          do SendPacket
        End
        if loc:cellstarted = 0
          loc:width = ''
          packet.append(p_web.FormTableCellStart( , , , , clip(loc:width) , Net:Default, net:CellTypeValue))
          loc:columncounter += 1
          do SendPacket
          loc:cellstarted = 1
        end
        do Value::Loc:Remember
        packet.append(p_web.FormTableCellEnd( ,Net:Default))
        loc:cellstarted = 0
          loc:width = ''
          packet.append(p_web.FormTableCellStart( , , , , clip(loc:width) , Net:Default, net:CellTypeComment))
          loc:columncounter += 1
          do SendPacket
          do Comment::Loc:Remember
          packet.append(p_web.FormTableCellEnd( ,Net:Default))
          loc:cellstarted = 0
          do SendPacket
        if loc:cellstarted
          packet.append(p_web.FormTableCellEnd( ,Net:Default))
          packet.append(p_web.FormTableRowEnd( ,Net:Default))
          loc:cellstarted = 0
        Else
          packet.append(p_web.FormTableRowEnd( ,Net:Default))
        End
        loc:rowstarted = 0
        loc:cellstarted = 0
      do SendPacket
        if loc:rowstarted = 0
          packet.append(p_web.FormTableRowStart( p_web.NoColon(lower('loc:Hash_row')) ,p_web.Combine(,),Net:Default))
          if loc:columncounter > loc:maxcolumns then loc:maxcolumns = loc:columncounter.
          loc:columncounter = 0
          loc:rowstarted = 1
        end
        do SendPacket
        loc:width = ''
        If loc:cellstarted = 0
          packet.append(p_web.FormTableCellStart( ,' nt-prompt-align-middle' , , , clip(loc:width) , Net:Default, net:CellTypePrompt))
          loc:columncounter += 1
          do SendPacket
          loc:cellstarted = 1
          loc:FirstInCell = 1
        Else
          loc:FirstInCell = 0
        End
        do Prompt::loc:Hash
        If loc:FirstInCell = 1
          packet.append(p_web.FormTableCellEnd( ,Net:Default))
          loc:cellstarted = 0
          do SendPacket
        End
        if loc:cellstarted = 0
          loc:width = ''
          packet.append(p_web.FormTableCellStart( , , , , clip(loc:width) , Net:Default, net:CellTypeValue))
          loc:columncounter += 1
          do SendPacket
          loc:cellstarted = 1
        end
        do Value::loc:Hash
        packet.append(p_web.FormTableCellEnd( ,Net:Default))
        loc:cellstarted = 0
          loc:width = ''
          packet.append(p_web.FormTableCellStart( , , , , clip(loc:width) , Net:Default, net:CellTypeComment))
          loc:columncounter += 1
          do SendPacket
          do Comment::loc:Hash
          packet.append(p_web.FormTableCellEnd( ,Net:Default))
          loc:cellstarted = 0
          do SendPacket
        if loc:cellstarted
          packet.append(p_web.FormTableCellEnd( ,Net:Default))
          packet.append(p_web.FormTableRowEnd( ,Net:Default))
          loc:cellstarted = 0
        Else
          packet.append(p_web.FormTableRowEnd( ,Net:Default))
        End
        loc:rowstarted = 0
        loc:cellstarted = 0
      do SendPacket
      if loc:rowstarted and loc:cellstarted
        packet.append(p_web.FormTableCellEnd( ,Net:Default))
        packet.append(p_web.FormTableRowEnd( ,Net:Default))
        packet.append(p_web.FormTableEnd('LoginForm_container',Net:Default))
        loc:cellstarted = 0
        loc:rowstarted = 0
      elsif loc:rowstarted
        packet.append(p_web.FormTableRowEnd( ,Net:Default))
        packet.append(p_web.FormTableEnd('LoginForm_container',Net:Default))
        loc:rowstarted = 0
      else
        packet.append(p_web.FormTableEnd('LoginForm_container',Net:Default))
      end
      do SendPacket
      Case loc:TabStyle
      of Net:Web:Plain
        packet.append('</fieldset>' & p_web.DivFooter(Net:NoSend,'tab_LoginForm0'))
      else
        packet.append(p_web.DivFooter(Net:NoSend,'tab_LoginForm0'))
      end
      do SendPacket
Heading  Routine
  data
loc:disabled  long
  code
  If p_web.GetValue('_title_') <> ''
    loc:Heading = p_web.Translate(p_web.GetValue('_title_'),(Net:HtmlOk*0)+(Net:UnsafeHtmlOk*0))
  End
  If loc:inNetWebPopup = 1 then exit.
  If loc:Heading
    if loc:popup
      p_web.SetPopupDialogHeading('LoginForm',clip(loc:heading),(Net:HtmlOk*0)+(Net:UnsafeHtmlOk*0))
    else
      packet.append(lower('<div id="form-access-LoginForm"></div>'))
        p_web.DivHeader('LoginForm_header',p_web.combine(p_web.site.style.formheading,))
        packet.append(clip(loc:Heading))
        do SendPacket
        p_web.DivFooter()
    end
  End

Refresh::Loc:Login  Routine
  do Prompt::Loc:Login
  do Value::Loc:Login
  do Comment::Loc:Login

Prompt::Loc:Login  Routine
  loc:fieldclass = Choose(not(1=0),p_web.combine(p_web.site.style.formprompt,,),'nt-hidden')
  If p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
  Else
    packet.append(p_web.DivHeader('LoginForm_' & p_web.nocolon('Loc:Login') & '_prompt',loc:fieldClass,Net:NoSend))
  End
  loc:prompt = Choose(1=0,'',p_web.Translate('Login:'))
  If p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
    p_web.Script('$(''[for="'&p_web.nocolon('Loc:Login')&'"]'').html("'&clip(loc:prompt)&'");')
  Else ! not front loaded
    packet.append('<label for="'&p_web.nocolon('Loc:Login')&'">' & clip(loc:prompt) & '</label>')
    packet.append(p_web.DivFooter(Net:NoSend,,,0))
    do SendPacket
  End  ! front loaded

  omit('*** end of scripts ***')
  ! *** end of scripts ***

Validate::Loc:Login Routine
  If p_web.Ajax = 1 and p_web.ifExistsValue('NewValue')
    Loc:Login = p_web.GetValue('NewValue')
  ElsIf p_web.IfExistsValue('Value') !FormFieldPicture =   !FieldPicture = 
    Loc:Login = p_web.GetValue('Value')
  End
  do ValidateValue::Loc:Login  ! copies value to session value if valid.

  p_web.PushEvent('parentupdated')
  do Refresh::Loc:Login   ! Field is auto-validated
  do SendMessage
  p_web.ntForm(loc:formname,'ready') ! 8.67 (in case the form was not the originator of the Ajax call)
  p_web.PopEvent()

ValidateValue::Loc:Login  Routine
      If loc:invalid = '' then p_web.SetSessionValue('Loc:Login',Loc:Login).

Value::Loc:Login  Routine
  data
loc:fieldclass     string(StyleStringSize)
loc:extra          string(StyleStringSize)
loc:disabled       long
loc:saveCallPopups long
loc:counter        long
loc:Filter       StringTheory
  code
  loc:fieldclass = p_web.Combine(p_web.site.style.formentrydiv,,)
  loc:fieldclass = choose(not(1=0),loc:fieldclass,'nt-hidden ' & loc:fieldclass)
  If p_web.site.FrontLoaded = 0 or loc:frontloading = net:GeneratingPage
    p_web.DivHeader('LoginForm_' & p_web.nocolon('Loc:Login') & '_value',loc:fieldclass)
  End
  loc:fieldclass = ''
  loc:fieldclass = p_web.combine(p_web.site.style.formentry,,)
  If loc:viewonly
    loc:fieldclass = clip(loc:fieldclass) & ' ' & p_web.combine(p_web.site.style.formEntryReadOnly,)
  End
  If loc:retrying
    Loc:Login = p_web.RestoreValue('Loc:Login')
    do ValidateValue::Loc:Login
    If Loc:Login:IsInvalid then loc:fieldclass = clip(loc:fieldclass) & ' ' & p_web.combine(p_web.site.style.formEntryError,).
  End
  loc:extra = ''
  If Not (1=0)  ! SecFieldHideStateRtn
    p_web.site.HTMLEditor = p_web.site.DefaultHTMLEditor
    ! --- STRING --- Loc:Login
    loc:AutoComplete = 'autocomplete="off"'
    loc:readonly = Choose(loc:viewonly,'readonly','')
      loc:extra = clip(loc:extra) & p_web.SetEntryWidth(20,Net:Form)
    loc:javascript = ''  ! MakeFormJavaScript
    if p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
      p_web.Script('$(''#'&p_web.nocolon('Loc:Login')&''').val('''&p_web._jsok(p_web.GetSessionValueFormat('Loc:Login'))&''');')
    Else
      packet.append(p_web.CreateInput('text','Loc:Login',p_web.GetSessionValueFormat('Loc:Login'),loc:fieldclass,loc:readonly,clip(loc:extra) & ' ' & clip(loc:autocomplete),,loc:javascript,,,'Loc:Login',,'imm',,,,'LoginForm')  & p_web.CRLF) !b
    End
    do SendPacket
  End
  if p_web.site.FrontLoaded = 0 or loc:frontloading = net:GeneratingPage
    p_web.DivFooter(,,,0)
  end

Comment::Loc:Login  Routine
  data
loc:fieldclass string(StyleStringSize)
  code
  loc:fieldclass = p_web.Combine(p_web.site.style.formcomment,,)
  if Loc:Login:IsInvalid
    loc:fieldclass = clip(loc:fieldclass) & ' ' & p_web.site.style.FormCommentError
  end
    loc:comment = ''
  loc:fieldclass = Choose(not(1=0),loc:fieldclass,'nt-hidden ' & loc:fieldclass)
  If p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
  else
    packet.append(p_web.DivHeader('LoginForm_' & p_web.nocolon('Loc:Login') & '_comment',loc:fieldclass,Net:NoSend))
  End
  If 1=0
    loc:comment = ''
  End
  If p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
    p_web.script('$("#LoginForm_' & p_web.nocolon('Loc:Login') & '_comment_div").html("'&clip(loc:comment)&'");')
  Else
    packet.append(clip(loc:comment) & p_web.DivFooter(net:nosend,,,0))
  End
  do SendPacket

Refresh::Loc:Password  Routine
  do Prompt::Loc:Password
  do Value::Loc:Password
  do Comment::Loc:Password

Prompt::Loc:Password  Routine
  loc:fieldclass = Choose(not(1=0),p_web.combine(p_web.site.style.formprompt,,),'nt-hidden')
  If p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
  Else
    packet.append(p_web.DivHeader('LoginForm_' & p_web.nocolon('Loc:Password') & '_prompt',loc:fieldClass,Net:NoSend))
  End
  loc:prompt = Choose(1=0,'',p_web.Translate('Password:'))
  If p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
    p_web.Script('$(''[for="'&p_web.nocolon('Loc:Password')&'"]'').html("'&clip(loc:prompt)&'");')
  Else ! not front loaded
    packet.append('<label for="'&p_web.nocolon('Loc:Password')&'">' & clip(loc:prompt) & '</label>')
    packet.append(p_web.DivFooter(Net:NoSend,,,0))
    do SendPacket
  End  ! front loaded

  omit('*** end of scripts ***')
  ! *** end of scripts ***

Validate::Loc:Password Routine
  If p_web.Ajax = 1 and p_web.ifExistsValue('NewValue')
    Loc:Password = p_web.GetValue('NewValue')
  ElsIf p_web.IfExistsValue('Value') !FormFieldPicture =   !FieldPicture = 
    Loc:Password = p_web.GetValue('Value')
  End
  do ValidateValue::Loc:Password  ! copies value to session value if valid.

  p_web.PushEvent('parentupdated')
  p_web.ntForm(loc:formname,'ready') ! 8.67 (in case the form was not the originator of the Ajax call)
  p_web.PopEvent()

ValidateValue::Loc:Password  Routine
      If loc:invalid = '' then p_web.SetSessionValue('Loc:Password',Loc:Password).

Value::Loc:Password  Routine
  data
loc:fieldclass     string(StyleStringSize)
loc:extra          string(StyleStringSize)
loc:disabled       long
loc:saveCallPopups long
loc:counter        long
loc:Filter       StringTheory
  code
  loc:fieldclass = p_web.Combine(p_web.site.style.formentrydiv,,)
  loc:fieldclass = choose(not(1=0),loc:fieldclass,'nt-hidden ' & loc:fieldclass)
  If p_web.site.FrontLoaded = 0 or loc:frontloading = net:GeneratingPage
    p_web.DivHeader('LoginForm_' & p_web.nocolon('Loc:Password') & '_value',loc:fieldclass)
  End
  loc:fieldclass = ''
  loc:fieldclass = p_web.combine(p_web.site.style.formentry,,)
  If loc:viewonly
    loc:fieldclass = clip(loc:fieldclass) & ' ' & p_web.combine(p_web.site.style.formEntryReadOnly,)
  End
  If loc:retrying
    Loc:Password = p_web.RestoreValue('Loc:Password')
    do ValidateValue::Loc:Password
    If Loc:Password:IsInvalid then loc:fieldclass = clip(loc:fieldclass) & ' ' & p_web.combine(p_web.site.style.formEntryError,).
  End
  loc:extra = ''
  If Not (1=0)  ! SecFieldHideStateRtn
    p_web.site.HTMLEditor = p_web.site.DefaultHTMLEditor
    ! --- STRING --- Loc:Password
    loc:AutoComplete = 'autocomplete="off"'
    loc:readonly = Choose(loc:viewonly,'readonly','')
      loc:extra = clip(loc:extra) & p_web.SetEntryWidth(20,Net:Form)
    loc:javascript = ''  ! MakeFormJavaScript
    if p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
      p_web.Script('$(''#'&p_web.nocolon('Loc:Password')&''').val('''&p_web._jsok(p_web.GetSessionValueFormat('Loc:Password'))&''');')
    Else
      packet.append(p_web.CreateInput('password','Loc:Password',p_web.GetSessionValueFormat('Loc:Password'),loc:fieldclass,loc:readonly,clip(loc:extra) & ' ' & clip(loc:autocomplete),,loc:javascript,,,'Loc:Password',,'',,,,'LoginForm')  & p_web.CRLF)
    End
    do SendPacket
  End
  if p_web.site.FrontLoaded = 0 or loc:frontloading = net:GeneratingPage
    p_web.DivFooter(,,,0)
  end

Comment::Loc:Password  Routine
  data
loc:fieldclass string(StyleStringSize)
  code
  loc:fieldclass = p_web.Combine(p_web.site.style.formcomment,,)
  if Loc:Password:IsInvalid
    loc:fieldclass = clip(loc:fieldclass) & ' ' & p_web.site.style.FormCommentError
  end
    loc:comment = ''
  loc:fieldclass = Choose(not(1=0),loc:fieldclass,'nt-hidden ' & loc:fieldclass)
  If p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
  else
    packet.append(p_web.DivHeader('LoginForm_' & p_web.nocolon('Loc:Password') & '_comment',loc:fieldclass,Net:NoSend))
  End
  If 1=0
    loc:comment = ''
  End
  If p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
    p_web.script('$("#LoginForm_' & p_web.nocolon('Loc:Password') & '_comment_div").html("'&clip(loc:comment)&'");')
  Else
    packet.append(clip(loc:comment) & p_web.DivFooter(net:nosend,,,0))
  End
  do SendPacket

Refresh::Loc:Remember  Routine
  do Prompt::Loc:Remember
  do Value::Loc:Remember
  do Comment::Loc:Remember

Prompt::Loc:Remember  Routine
  loc:fieldclass = Choose(not(1=0),p_web.combine(p_web.site.style.formprompt,,),'nt-hidden')
  If p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
  Else
    packet.append(p_web.DivHeader('LoginForm_' & p_web.nocolon('Loc:Remember') & '_prompt',loc:fieldClass,Net:NoSend))
  End
  loc:prompt = Choose(1=0,'',p_web.Translate('Remember me'))
  If p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
    p_web.Script('$(''[for="_'&p_web.nocolon('Loc:Remember')&'"]'').html("'&clip(loc:prompt)&'");')
  Else ! not front loaded
    packet.append('<label for="_'&p_web.nocolon('Loc:Remember')&'">' & clip(loc:prompt) & '</label>')
    packet.append(p_web.DivFooter(Net:NoSend,,,0))
    do SendPacket
  End  ! front loaded

  omit('*** end of scripts ***')
  ! *** end of scripts ***

Validate::Loc:Remember Routine
  If p_web.Ajax = 1 and p_web.ifExistsValue('NewValue')
    Loc:Remember = p_web.GetValue('NewValue')
  ElsIf p_web.IfExistsValue('Value')
    if p_web.GetValue('Value') = ''
      p_web.SetValue('Value',0)
    end
    Loc:Remember = p_web.GetValue('Value')
  End
  do ValidateValue::Loc:Remember  ! copies value to session value if valid.

  p_web.PushEvent('parentupdated')
  do Refresh::Loc:Remember   ! Field is auto-validated
  do SendMessage
  p_web.ntForm(loc:formname,'ready') ! 8.67 (in case the form was not the originator of the Ajax call)
  p_web.PopEvent()

ValidateValue::Loc:Remember  Routine
      If loc:invalid = '' then p_web.SetSessionValue('Loc:Remember',Loc:Remember).

Value::Loc:Remember  Routine
  data
loc:fieldclass     string(StyleStringSize)
loc:extra          string(StyleStringSize)
loc:disabled       long
loc:saveCallPopups long
loc:counter        long
  code
  loc:fieldclass = p_web.Combine(p_web.site.style.formentrydiv,,)
  loc:fieldclass = choose(not(1=0),loc:fieldclass,'nt-hidden ' & loc:fieldclass)
  If p_web.site.FrontLoaded = 0 or loc:frontloading = net:GeneratingPage
    p_web.DivHeader('LoginForm_' & p_web.nocolon('Loc:Remember') & '_value',loc:fieldclass)
  End
  loc:fieldclass = ''
  loc:fieldclass = p_web.combine(p_web.site.style.formentry,,)
  If loc:retrying
    Loc:Remember = p_web.RestoreValue('Loc:Remember')
    do ValidateValue::Loc:Remember
    If Loc:Remember:IsInvalid then loc:fieldclass = clip(loc:fieldclass) & ' ' & p_web.combine(p_web.site.style.formEntryError,).
  End
  loc:extra = ''
  If Not (1=0)  ! SecFieldHideStateRtn
    p_web.site.HTMLEditor = p_web.site.DefaultHTMLEditor
    ! --- CHECKBOX --- Loc:Remember
    If p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
      If p_web.GetSessionValue('Loc:Remember') = true
        p_web.Script('$(''#'&p_web.nocolon('Loc:Remember')&''').checkboxbutton("refresh",1);')
      Else
        p_web.Script('$(''#'&p_web.nocolon('Loc:Remember')&''').checkboxbutton("refresh",0);')
      End
    Else
      loc:javascript = ''  ! MakeFormJavaScript
      loc:readonly = Choose(loc:viewonly,'disabled','')
      If p_web.GetSessionValue('Loc:Remember') = true
        loc:readonly = 'checked ' & loc:readonly
      End
      packet.append(p_web.CreateInput('checkbox','Loc:Remember',clip(true),,loc:readonly,,,loc:javascript,,,'Loc:Remember',,'imm',,,,'LoginForm')  & p_web.CRLF)
        packet.append('<label for="'&p_web.nocolon('Loc:Remember')&'"></label>')
        loc:options.Free(True)
        p_web.SetOption(loc:options,'trueText',p_web.Translate('Yes'))
        p_web.SetOption(loc:options,'falseText',p_web.Translate('No'))
        p_web.SetOption(loc:options,'trueIcon','ui-icon-'&'check')
        p_web.SetOption(loc:options,'falseIcon','ui-icon-'&'close')
        p_web.SetOption(loc:options,'label','null')
        p_web.jQuery('#Loc:Remember','checkboxbutton',loc:options)
    End
    do SendPacket
  End
  if p_web.site.FrontLoaded = 0 or loc:frontloading = net:GeneratingPage
    p_web.DivFooter(,,,0)
  end

Comment::Loc:Remember  Routine
  data
loc:fieldclass string(StyleStringSize)
  code
  loc:fieldclass = p_web.Combine(p_web.site.style.formcomment,,)
  if Loc:Remember:IsInvalid
    loc:fieldclass = clip(loc:fieldclass) & ' ' & p_web.site.style.FormCommentError
  end
  loc:comment = ''
  loc:fieldclass = Choose(not(1=0),loc:fieldclass,'nt-hidden ' & loc:fieldclass)
  If p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
  else
    packet.append(p_web.DivHeader('LoginForm_' & p_web.nocolon('Loc:Remember') & '_comment',loc:fieldclass,Net:NoSend))
  End
  If 1=0
    loc:comment = ''
  End
  If p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
    p_web.script('$("#LoginForm_' & p_web.nocolon('Loc:Remember') & '_comment_div").html("'&clip(loc:comment)&'");')
  Else
    packet.append(clip(loc:comment) & p_web.DivFooter(net:nosend,,,0))
  End
  do SendPacket

Refresh::loc:Hash  Routine
  do Prompt::loc:Hash
  do Value::loc:Hash
  do Comment::loc:Hash

Prompt::loc:Hash  Routine

  omit('*** end of scripts ***')
  ! *** end of scripts ***

Validate::loc:Hash Routine
  If p_web.Ajax = 1 and p_web.ifExistsValue('NewValue')
    loc:Hash = p_web.GetValue('NewValue')
  ElsIf p_web.IfExistsValue('Value') !FormFieldPicture =   !FieldPicture = 
    loc:Hash = p_web.GetValue('Value')
  End
  do ValidateValue::loc:Hash  ! copies value to session value if valid.

  p_web.PushEvent('parentupdated')
  p_web.ntForm(loc:formname,'ready') ! 8.67 (in case the form was not the originator of the Ajax call)
  p_web.PopEvent()

ValidateValue::loc:Hash  Routine
      If loc:invalid = '' then p_web.SetSessionValue('loc:Hash',loc:Hash).

Value::loc:Hash  Routine
  data
loc:fieldclass     string(StyleStringSize)
loc:extra          string(StyleStringSize)
loc:disabled       long
loc:saveCallPopups long
loc:counter        long
  code
  loc:fieldclass = p_web.Combine(p_web.site.style.formentrydiv,,)
  loc:fieldclass = choose(not(1=0),loc:fieldclass,'nt-hidden ' & loc:fieldclass)
  If p_web.site.FrontLoaded = 0 or loc:frontloading = net:GeneratingPage
    p_web.DivHeader('LoginForm_' & p_web.nocolon('loc:Hash') & '_value',loc:fieldclass)
  End
  loc:fieldclass = ''
  loc:fieldclass = p_web.combine(p_web.site.style.formentry,,)
  If loc:retrying
    loc:Hash = p_web.RestoreValue('loc:Hash')
    do ValidateValue::loc:Hash
    If loc:Hash:IsInvalid then loc:fieldclass = clip(loc:fieldclass) & ' ' & p_web.combine(p_web.site.style.formEntryError,).
  End
  loc:extra = ''
  If Not (1=0)  ! SecFieldHideStateRtn
    p_web.site.HTMLEditor = p_web.site.DefaultHTMLEditor
    ! --- HIDDEN --- loc:Hash -- loc:Hash
    if p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
      p_web.Script('$(''#'&p_web.nocolon('loc:Hash')&''').val('''&p_web._jsok(p_web.GetSessionValue('loc:Hash'))&''');')
    else
      packet.append(p_web.CreateInput('hidden','loc:Hash',p_web.GetSessionValue('loc:Hash'))  & p_web.CRLF)
    end
    do SendPacket
  End
  if p_web.site.FrontLoaded = 0 or loc:frontloading = net:GeneratingPage
    p_web.DivFooter(,,,0)
  end

Comment::loc:Hash  Routine
  data
loc:fieldclass string(StyleStringSize)
  code
  loc:fieldclass = p_web.Combine(p_web.site.style.formcomment,,)
  if loc:Hash:IsInvalid
    loc:fieldclass = clip(loc:fieldclass) & ' ' & p_web.site.style.FormCommentError
  end
  loc:comment = ''
  loc:fieldclass = Choose(not(1=0),loc:fieldclass,'nt-hidden ' & loc:fieldclass)
  If p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
  else
    packet.append(p_web.DivHeader('LoginForm_' & p_web.nocolon('loc:Hash') & '_comment',loc:fieldclass,Net:NoSend))
  End
  If 1=0
    loc:comment = ''
  End
  If p_web.site.FrontLoaded and loc:frontloading = net:GeneratingData
    p_web.script('$("#LoginForm_' & p_web.nocolon('loc:Hash') & '_comment_div").html("'&clip(loc:comment)&'");')
  Else
    packet.append(clip(loc:comment) & p_web.DivFooter(net:nosend,,,0))
  End
  do SendPacket

NextTab  routine
  data
  code
  p_web.Ajax = 1
  p_web.PageName = p_web._unEscape(p_web.PageName)

  case lower(p_web.PageName)
  of lower('LoginForm_nexttab_' & 0)
    Loc:Login = p_web.GetSessionValue('Loc:Login')
    do ValidateValue::Loc:Login
    If loc:Invalid
      loc:retrying = 1
      do Value::Loc:Login
      do Comment::Loc:Login ! allows comment style to be updated.
    End
    Loc:Password = p_web.GetSessionValue('Loc:Password')
    do ValidateValue::Loc:Password
    If loc:Invalid
      loc:retrying = 1
      do Value::Loc:Password
      do Comment::Loc:Password ! allows comment style to be updated.
    End
    Loc:Remember = p_web.GetSessionValue('Loc:Remember')
    do ValidateValue::Loc:Remember
    If loc:Invalid
      loc:retrying = 1
      do Value::Loc:Remember
      do Comment::Loc:Remember ! allows comment style to be updated.
    End
    loc:Hash = p_web.GetSessionValue('loc:Hash')
    do ValidateValue::loc:Hash
    If loc:Invalid
      loc:retrying = 1
      do Value::loc:Hash
      do Comment::loc:Hash ! allows comment style to be updated.
    End
    If loc:Invalid then exit.
  End
  p_web.ntWiz('LoginForm','next')

ChangeTab  routine
  p_web.ChangeTab(loc:TabStyle,'LoginForm',loc:TabTo)

TabChanged  routine
  data
TabNumber   Long   !! remember that tabs are numbered from 0
TabHeading  String(252),dim(1)
  code
  tabnumber = p_web.GetValue('_tab_')
  tabheading[1]  = p_web.Translate('Login')
  p_web.SetSessionValue('showtab_LoginForm',tabnumber) !! remember that tabs are numbered from 0

CallDiv    routine
  data
  code
  p_web.Ajax = 1
  p_web.PageName = p_web._unEscape(p_web.PageName)
  case lower(p_web.PageName)
  of lower('LoginForm') & '_tabchanged'
     do TabChanged
  of lower('LoginForm_tab_' & 0)
    do GenerateTab0
  of lower('LoginForm_Loc:Login_value')
      case p_web.Event ! String
      of 'selected' !event:selected !257
      of 'accepted' !event:accepted !1
      orof 'childupdated'
        do Validate::Loc:Login
        do AlertParent
      of 'timer'
        do refresh::Loc:Login
        do AlertParent
      else
        do Value::Loc:Login
      end
  of lower('LoginForm_Loc:Password_value')
      case p_web.Event ! String
      of 'selected' !event:selected !257
      of 'accepted' !event:accepted !1
      orof 'childupdated'
        do Validate::Loc:Password
        do AlertParent
      of 'timer'
        do refresh::Loc:Password
        do AlertParent
      else
        do Value::Loc:Password
      end
  of lower('LoginForm_Loc:Remember_value')
      case p_web.Event ! CheckBox
      of 'selected' !event:selected !257
      of 'accepted' !event:accepted !1
      orof 'childupdated'
        do Validate::Loc:Remember
        do AlertParent
      of 'timer'
        do refresh::Loc:Remember
        do AlertParent
      else
        do Value::Loc:Remember
      end
  of lower('LoginForm_loc:Hash_value')
      case p_web.Event ! Hidden
      of 'selected' !event:selected !257
      of 'accepted' !event:accepted !1
      orof 'childupdated'
        do Validate::loc:Hash
        do AlertParent
      of 'timer'
        do refresh::loc:Hash
        do AlertParent
      else
        do Value::loc:Hash
      end
  End

SendPacket  routine
  p_web.ParseHTML(packet, 1, 0, NET:NoHeader)
  packet.setvalue('')
! NET:WEB:StagePRE

PreInsert  Routine
  data
  code
  p_web.SetValue('LoginForm_form:ready_',1)
  p_web.SetSessionValue('LoginForm:Active',1)
  p_web.SetSessionValue('LoginForm_CurrentAction',Net:InsertRecord)
  p_web.setsessionvalue('showtab_LoginForm',0)
  loc:Hash = random(1,2000000000)
  p_web.SetSessionValue('loc:Hash',loc:Hash)
  do SetFormSettings

PreCopy  Routine
  data
  code
  p_web.SetValue('LoginForm_form:ready_',1)
  p_web.SetSessionValue('LoginForm:Active',1)
  p_web.SetSessionValue('LoginForm_CurrentAction',Net:CopyRecord)
  p_web.setsessionvalue('showtab_LoginForm',0)
  ! here we need to copy the non-unique fields across
  loc:Hash = random(1,2000000000)
  p_web.SetSessionValue('loc:Hash',loc:Hash)
  do SetFormSettings

PreUpdate  Routine
  data
loc:offset      Long
  code
  p_web.SetValue('LoginForm_form:ready_',1)
  p_web.SetSessionValue('LoginForm:Active',1)
  p_web.SetSessionValue('LoginForm_CurrentAction',Net:ChangeRecord)
  p_web.SetSessionValue('LoginForm:Primed',0)
  loc:Hash = random(1,2000000000)
  p_web.SetSessionValue('loc:Hash',loc:Hash)
  do SetFormSettings

PreDelete       Routine
  data
  code
  p_web.SetValue('LoginForm_form:ready_',1)
  p_web.SetSessionValue('LoginForm_CurrentAction',Net:DeleteRecord)
  p_web.SetSessionValue('LoginForm:Primed',0)
  p_web.setsessionvalue('showtab_LoginForm',0)
  do SetFormSettings

LoadRelatedRecords  Routine
  loc:ok = 0
  loc:ok = 0

! copies fields from the Value queue to the File Field.
CompleteForm  Routine
  data
loc:pic   string(40)
  code
  do SetPics
          If p_web.IfExistsValue('Loc:Login')
            Loc:Login = p_web.GetValue('Loc:Login')
          End
          If p_web.IfExistsValue('Loc:Password')
            Loc:Password = p_web.GetValue('Loc:Password')
          End
          If p_web.IfExistsValue('Loc:Remember') = 0
            p_web.SetValue('Loc:Remember',false)
            Loc:Remember = false
          Else
            Loc:Remember = p_web.GetValue('Loc:Remember')
          End
          If p_web.IfExistsValue('loc:Hash')
            loc:Hash = p_web.GetValue('loc:Hash')
          End


! NET:WEB:StageVALIDATE
ValidateInsert  Routine
  do CompleteForm
  do ValidateRecord

ValidateCopy  Routine
  do CompleteForm
  do ValidateRecord

ValidateUpdate  Routine
  do CompleteForm
  do ValidateRecord
  ! The HASH test prevents the same form-post from being used "twice".
  ! This improves security on public computers.

  if p_web.GetValue('loc:hash') = p_web.GetSessionValue('loc:hash')

    ! login checking goes here
    if p_web.Authenticate(Loc:Login,Loc:Password) = true ! WebHandler, Authenticate method needs to be fleshed out.
      p_web.ValidateLogin()                   ! this sets the session to "logged in"
      p_web.SetSessionValue('loc:hash',0)         ! clear the hash, so this login can't get "replayed".

      ! set any session variables based on the logged in user.

      ! this next bit shows how the login & password can be stored in the browser
      ! so that it is "remembered" for next time
      if loc:remember = 1
        p_web.SetCookie('loc__login',loc:login,today()+30)       ! note the expiry date. It's good form
        p_web.SetCookie('loc__password',loc:password,today()+30) ! to make sure your cookies expire sometime.
      else
        ! don't remember, so clear cookies in browser.
        p_web.DeleteCookie('loc__login')
        p_web.DeleteCookie('loc__password')
      End
    Else
      loc:invalid = 'Loc:Login'
      p_web.SetValue('retry',p_web.site.LoginPage)
      loc:Alert = 'Login Failed. Try Again.'
      p_web.DeleteCookie('loc__login')
      p_web.DeleteCookie('loc__password')
    End
  Else
    p_web.DeleteCookie('loc__login')
    p_web.DeleteCookie('loc__password')
  End
  ! delete the session values, so if the user comes back to the form, the items are not set.
  p_web.deletesessionvalue('loc:login')
  p_web.deletesessionvalue('loc:password')
  p_web.deletesessionvalue('loc:remember')
  p_web.deletevalue('loc:login')
  p_web.deletevalue('loc:password')
  p_web.deletevalue('loc:remember')


ValidateDelete  Routine
  p_web.DeleteSessionValue('LoginForm_ChainTo')
  ! Check for restricted child records

ValidateRecord  Routine
  p_web.DeleteSessionValue('LoginForm_ChainTo')

  ! Then add additional constraints set on the template
  loc:InvalidTab = -1
  ! tab = 1
        loc:InvalidTab += 1
        do ValidateValue::Loc:Login
        If loc:Invalid then exit.
        do ValidateValue::Loc:Password
        If loc:Invalid then exit.
        do ValidateValue::Loc:Remember
        If loc:Invalid then exit.
        do ValidateValue::loc:Hash
        If loc:Invalid then exit.
  ! The following fields are not on the form, but need to be checked anyway.
! NET:WEB:StagePOST
  p_web.SetSessionValue('LoginForm:Active',0)

PostUpdate      Routine
  Data
  Code
  p_web.SetSessionValue('LoginForm:Primed',0)
  p_web.StoreValue('Loc:Login')
  p_web.StoreValue('Loc:Password')
  p_web.StoreValue('Loc:Remember')
  p_web.StoreValue('loc:Hash')
  p_web.SetSessionValue('LoginForm:Active',0)
