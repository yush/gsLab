program gsLab;

uses
(*
  Windows,
  Messages,
  Variants,
  Classes,
  Graphics,
  Controls,
    *)
  Forms,
  SysUtils,
  main in 'source\main.pas' {Form1},
  GSWebServer in 'source\GSWebServer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
