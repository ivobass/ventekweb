  Section('ProcessTag')
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
  Section('CallFormA')
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
  Section('CallFormB')
    If p_File &= vendas
       ReturnValue = Updatevendas(Self,p_stage)
       RETURN ReturnValue
    End
  Section('CallFormC')
    Case Lower(Self.FormSettings.ParentPage)
      Of 'loginform'
        ReturnValue = LoginForm(Self,p_Stage)
        Return ReturnValue
    End
  Section('ProcessYear')
