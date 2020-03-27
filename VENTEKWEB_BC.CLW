  MEMBER('ventekweb.clw')

  PRAGMA('define(init_priority=>3)')

  MAP
    MODULE('ventekweb_BC0.CLW')
ventekweb_BC0:DctInit             PROCEDURE()
ventekweb_BC0:DctKill             PROCEDURE()
ventekweb_BC0:FilesInit           PROCEDURE()
    END
  END

DctInit PROCEDURE()
  CODE
  ventekweb_BC0:DctInit
  ventekweb_BC0:FilesInit


DctKill PROCEDURE()
  CODE
  ventekweb_BC0:DctKill

