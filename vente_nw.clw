  MEMBER('ventekweb.clw')
    MAP
! WebServer : ActiveTemplate = CloseButton(ABC)
! WebServer : ActiveTemplate = IncludeNetTalkObject(NetTalk)
! WebServer : ActiveTemplate = NetWebServerLogging(NetTalk)
! WebServer : ActiveTemplate = NetWebServerPerformance(NetTalk)
! WebServer : ActiveTemplate = NetWebServerSettings(NetTalk)
! WebServer : ActiveTemplate = NetWebServerGracefulClose(NetTalk)
      INCLUDE('ventekweb003.Inc'),ONCE ! In WebHandler so make all procedures in scope
    END
  ! ----------------------------------------------------------------------------------------
! ----------------------------------------------------------------------------------------
! These procedures support the NetTalk Web Server templates. They are sufficiently generic
! that there is no need to put them in the application true, however are dependant on the
! dictionary and/or application such that they need to be generated, and cannot be inserted
! as methods in the class.
! ----------------------------------------------------------------------------------------
NetWebRelationManager PROCEDURE  (FILE p_file)
RM       &RelationManager
  CODE
  RM &= NULL
  If p_FILE &= NULL then Return RM.
  If p_File &= Relate:vendas.Me.File then RM &= Relate:vendas.
  Return RM
! ----------------------------------------------------------------------------------------
NetWebFileNamed PROCEDURE  (string p_file)
F        &File
  CODE
  F &= NULL
  Case Lower(p_file)
  Of 'vendas'
    F &= vendas
  End
  Return F
! ----------------------------------------------------------------------------------------
! ----------------------------------------------------------------------------------------
! ----------------------------------------------------------------------------------------
NetWebDLL_ventekweb_SendFile PROCEDURE  (NetWebServerWorker p_web, string p_Filename, String p_Parent)
loc:parent      string(252)   ! should always be a lower-case string
loc:done        Long
loc:filename    string(252)
  CODE
  loc:parent = p_parent
  loc:filename = p_filename
  do CaseStart:ventekweb
  Return Loc:Done

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

