  MEMBER('ventekweb.clw')

  INCLUDE('ABFILE.INC'),ONCE

  MAP
ventekweb_BC0:DctInit    PROCEDURE()
ventekweb_BC0:DctKill    PROCEDURE()
ventekweb_BC0:FilesInit  PROCEDURE()
  END

Hide:Access:vendas   CLASS(FileManager),TYPE               ! FileManager for vendas
Init                   PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED
                     END


Hide:Relate:vendas   CLASS(RelationManager),TYPE           ! RelationManager for vendas
Init                   PROCEDURE
Kill                   PROCEDURE(),DERIVED
                     END


_Hide:Access:vendas  &Hide:Access:vendas,AUTO,THREAD
_Hide:Relate:vendas  &Hide:Relate:vendas,AUTO,THREAD


ventekweb_BC0:DctInit PROCEDURE()
  CODE
  _Hide:Access:vendas &= NEW(Hide:Access:vendas)
  _Hide:Relate:vendas &= NEW(Hide:Relate:vendas)
  Relate:vendas &= _Hide:Relate:vendas


ventekweb_BC0:FilesInit PROCEDURE()
  CODE
  _Hide:Relate:vendas.Init


ventekweb_BC0:DctKill PROCEDURE()
  CODE
  _Hide:Relate:vendas.Kill
  DISPOSE(_Hide:Relate:vendas)


Hide:Relate:vendas.Init PROCEDURE()
  CODE
  _Hide:Access:vendas.Init
  SELF.Init(Access:vendas,1)


Hide:Access:vendas.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= ven:Record
  SELF.FileNameValue = 'vendas'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= vendas
  PARENT.Init
  Access:vendas &= SELF


Hide:Access:vendas.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:vendas &= NULL                                    ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:vendas.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(vendas,GlobalErrors)
    SELF.Create = 0
    SELF.LockRecover = 10
    SELF.AddKey(ven:PRIMARY,'ven:PRIMARY',0)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Relate:vendas.Kill PROCEDURE

  CODE
  _Hide:Access:vendas.Kill                                 ! Kill the file manager
  PARENT.Kill
  Relate:vendas &= NULL                                    ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:vendas)                             ! destroy the file manager

