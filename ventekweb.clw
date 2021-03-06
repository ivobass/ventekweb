   PROGRAM


NetTalk:TemplateVersion equate('11.05')
ActivateNetTalk   EQUATE(1)
  include('NetCrit.inc'),once
  include('NetMap.inc'),once
  include('NetAll.inc'),once
  include('NetTalk.inc'),once
  include('NetSimp.inc'),once
  include('NetFtp.inc'),once
  include('NetHttp.inc'),once
  include('NetWww.inc'),once
  include('NetSync.inc'),once
  include('NetWeb.inc'),once
  include('NetWebSocketClient.inc'),once
  include('NetWebSocketServer.inc'),once
  include('NetWebM.inc'),once
  include('NetWSDL.inc'),once
  include('NetEmail.inc'),once
  include('NetFile.inc'),once
  include('NetWebSms.inc'),once
  Include('NetOauth.inc'),once
  Include('NetLDAP.inc'),once
  Include('NetMaps.inc'),once
  Include('NetDrive.inc'),once
  Include('NetSms.inc'),once
StringTheory:TemplateVersion equate('3.05')
xFiles:TemplateVersion equate('3.09')
jFiles:TemplateVersion equate('1.72')

   INCLUDE('ABERROR.INC'),ONCE
   INCLUDE('ABFILE.INC'),ONCE
   INCLUDE('ABUTIL.INC'),ONCE
   INCLUDE('ERRORS.CLW'),ONCE
   INCLUDE('KEYCODES.CLW'),ONCE
   INCLUDE('ABFUZZY.INC'),ONCE
  include('cwsynchc.inc'),once  ! added by NetTalk
  include('StringTheory.Inc'),ONCE
   include('xfiles.inc'),ONCE
   include('jFiles.inc'),ONCE

   MAP
     MODULE('VENTEKWEB_BC.CLW')
DctInit     PROCEDURE                                      ! Initializes the dictionary definition module
DctKill     PROCEDURE                                      ! Kills the dictionary definition module
     END
!--- Application Global and Exported Procedure Definitions --------------------------------------------
     MODULE('VENTEKWEB003.CLW')
WebServer              PROCEDURE(<NetWebServer pServer>),name('WebServer')   !
Browsevendas           PROCEDURE(NetWebServerWorker p_web)   !
Updatevendas           FUNCTION(NetWebServerWorker p_web,long p_action=0),long,proc   !
PageHeaderTag          PROCEDURE(NetWebServerWorker p_web)   !***** Includes Menu *****
PageFooterTag          PROCEDURE(NetWebServerWorker p_web)   !
     END
       Module('vente_nw.clw')
          NetWebRelationManager (FILE p_file),*RelationManager
          NetWebFileNamed (string p_file),*File
          NetWebDLL_ventekweb_SendFile (NetWebServerWorker p_web, string p_Filename, String p_Parent),Long,Proc
       End
   END

  include('StringTheory.Inc'),ONCE
SilentRunning        BYTE(0)                               ! Set true when application is running in 'silent mode'

!region File Declaration
vendas               FILE,DRIVER('ODBC'),OWNER('vendastekkies,ivo'),NAME('vendas'),PRE(ven),BINDABLE,THREAD !                     
PRIMARY                  KEY(ven:Reg),PRIMARY              !                     
Record                   RECORD,PRE()
Reg                         LONG                           !                     
TipoVenda                   CSTRING(12)                    !                     
VendaSap                    CSTRING(12)                    !                     
Quantidade                  LONG                           !                     
                         END
                     END                       

!endregion

Access:vendas        &FileManager,THREAD                   ! FileManager for vendas
Relate:vendas        &RelationManager,THREAD               ! RelationManager for vendas

FuzzyMatcher         FuzzyClass                            ! Global fuzzy matcher
GlobalErrorStatus    ErrorStatusClass,THREAD
GlobalErrors         ErrorClass                            ! Global error manager
INIMgr               INIClass                              ! Global non-volatile storage manager
GlobalRequest        BYTE(0),THREAD                        ! Set when a browse calls a form, to let it know action to perform
GlobalResponse       BYTE(0),THREAD                        ! Set to the response from the form
VCRRequest           LONG(0),THREAD                        ! Set to the request from the VCR buttons

Dictionary           CLASS,THREAD
Construct              PROCEDURE
Destruct               PROCEDURE
                     END


  CODE
  GlobalErrors.Init(GlobalErrorStatus)
  FuzzyMatcher.Init                                        ! Initilaize the browse 'fuzzy matcher'
  FuzzyMatcher.SetOption(MatchOption:NoCase, 1)            ! Configure case matching
  FuzzyMatcher.SetOption(MatchOption:WordOnly, 0)          ! Configure 'word only' matching
  INIMgr.Init('.\ventekweb.INI', NVD_INI)                  ! Configure INIManager to use INI file
  DctInit()
                             ! Begin Generated by NetTalk Extension Template
    if ~command ('/netnolog') and (command ('/nettalklog') or command ('/nettalklogerrors') or command ('/neterrors') or command ('/netall'))
      NetDebugTrace ('[Nettalk Template] NetTalk Template version 11.05')
      NetDebugTrace ('[Nettalk Template] NetTalk Template using Clarion ' & 11000)
      NetDebugTrace ('[Nettalk Template] NetTalk Object version ' & NETTALK:VERSION )
      NetDebugTrace ('[Nettalk Template] ABC Template Chain')
    end
                             ! End Generated by Extension Template
  WebServer
  INIMgr.Update
                             ! Begin Generated by NetTalk Extension Template
    NetCloseCallBackWindow() ! Tell NetTalk DLL to shutdown it's WinSock Call Back Window
  
    if ~command ('/netnolog') and (command ('/nettalklog') or command ('/nettalklogerrors') or command ('/neterrors') or command ('/netall'))
      NetDebugTrace ('[Nettalk Template] NetTalk Template version 11.05')
      NetDebugTrace ('[Nettalk Template] NetTalk Template using Clarion ' & 11000)
      NetDebugTrace ('[Nettalk Template] Closing Down NetTalk (Object) version ' & NETTALK:VERSION)
    end
                             ! End Generated by Extension Template
  INIMgr.Kill                                              ! Destroy INI manager
  FuzzyMatcher.Kill                                        ! Destroy fuzzy matcher


Dictionary.Construct PROCEDURE

  CODE
  IF THREAD()<>1
     DctInit()
  END


Dictionary.Destruct PROCEDURE

  CODE
  DctKill()

