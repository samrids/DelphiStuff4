Source code

.
.
.
uses

  IdBaseComponent,
  IdComponent,
  IdExplicitTLSClientServerBase,
  IdIOHandler,
  IdIOHandlerSocket,
  IdIOHandlerStack,
  IdMessage,
  IdSMTP,
  IdSSL,
  IdSSLOpenSSL;

procedure SendMail(const Subject: string; const Recipients: string;
  const Msg: TStrings);
var
  IdMessage1: TIdMessage;
  IdSMTP1: TIdSMTP;
  IdSSL1: TIdSSLIOHandlerSocketOpenSSL;
begin
  IdSMTP1 := TIdSMTP.Create(nil);
  IdMessage1 := TIdMessage.Create(nil);
  IdSSL1 := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  try
    IdSSL1.SSLOptions.Method := sslvTLSv1_2;
    IdSSL1.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
    IdSSL1.SSLOptions.Mode := sslmClient;
    IdSSL1.SSLOptions.VerifyDepth := 0;

    IdSSL1.SSLOptions.VerifyMode := [];

    IdMessage1.From.Address := 'USERNAME@gmail.com';
    IdMessage1.Recipients.EMailAddresses := Recipients;
    IdMessage1.Subject := Subject;
    IdMessage1.body.text := Msg.text;

    IdMessage1.CharSet := 'UTF-8';
    IdMessage1.ContentType := 'text/plain; charset=UTF-8';

    IdSMTP1.IOHandler := IdSSL1;
    IdSMTP1.Host := 'smtp.gmail.com';
    IdSMTP1.Port := 587;
    IdSMTP1.username := 'USERNAME@gmail.com';
    IdSMTP1.password := 'your Gmail password';
    IdSMTP1.UseTLS := utUseExplicitTLS;

    IdSMTP1.Connect;
    IdSMTP1.Send(IdMessage1);
    IdSMTP1.Disconnect;
  finally
    IdSMTP1.Free;
    IdMessage1.Free;
    IdSSL1.Free;
  end;
end;
