  MODULE('VENTEKWEB003.CLW')
WebHandler             PROCEDURE(String p_String)
IndexPage              PROCEDURE(NetWebServerWorker p_web)
LoginForm              FUNCTION(NetWebServerWorker p_web,long p_action=0),long,proc
  END
