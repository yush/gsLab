program gsLab;

uses
  Forms,
  SysUtils,
  main in 'source\main.pas' {Form1},
  GSWebServer in 'source\GSWebServer.pas',
  GsData in 'source\GsData.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
