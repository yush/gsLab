unit Testmain;
{

  Cas de test DUnit Delphi
  ----------------------
  Cette unité contient une classe cas de test de squelette générée par l'expert Cas de test.
  Modifiez le code généré pour configurer et appeler correctement les méthodes de l'unité
  en cours de test.

}

interface

uses
  TestFramework, VirtualTrees, IdHTTPServer, OleCtrls, SysUtils, ComCtrls, Windows,
  StdCtrls, ValEdit, Messages, Variants, Controls, Classes, IdComponent, Dialogs, SHDocVw,
  Grids, Forms, IdBaseComponent, IdCustomHTTPServer, ExtCtrls, Graphics,
  IdCustomTCPServer, GsData, GSWebServer, main;

type
  // Méthodes de test pour la classe TPattern

  TestTGsPattern = class(TTestCase)
  strict private
    aFrm: TForm1;
    FPattern: TSQLGsPattern;
  private
    procedure initCascade(var FPattern: TSQLGsPattern);
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure testCascade;
    procedure testCascadeInverse;
    procedure testHalfShower;
    procedure testWindMill;
    procedure TestgetSsInNextNumBeatsFor;
  end;

implementation

procedure TestTGsPattern.SetUp;
begin
  aFrm := TForm1.Create(nil);
  FPattern := TSQLGsPattern.Create;
  FPattern.ValuesEditor := aFrm.vlePos ;
end;

procedure TestTGsPattern.TearDown;
begin
  FPattern.Free;
  FPattern := nil;
  aFrm.Free;
end;

procedure TestTGsPattern.testCascade;
begin
  initCascade(FPattern);
  checkEquals( '(0,0)(32,0).(0,0)(32,0).', FPattern.getHandsParams);
end;

procedure TestTGsPattern.testCascadeInverse;
var
  aSs: TSQLGsSs;
begin
  FPattern.clear;
  FPattern.testCascadeInverse;
  checkEquals( '(32,0)(0,0).(32,0)(0,0).', FPattern.getHandsParams);
end;

procedure TestTGsPattern.testHalfShower;
var
  aSs: TSQLGsSs;
begin
  FPattern.testHalfShower;
  checkEquals( '(32)(0).(0)(32).', FPattern.getHandsParams);
end;

procedure TestTGsPattern.testWindMill;
begin
  FPattern.clear;
  FPattern.testWindMill;
  checkEquals( '(-32,0)(0,0).(32,0)(0,0).', FPattern.getHandsParams);
end;

procedure TestTGsPattern.initCascade(var FPattern: TSQLGsPattern);
var
  aSs: TSQLGsSs;
begin
  FPattern.clear;
  FPattern.testCascade;
end;

procedure TestTGsPattern.TestgetSsInNextNumBeatsFor;
var
  ReturnValue: TSQLGsSs;
  numBeat: Integer;
  tRefSs: TSQLGsSs;
begin
  // TODO : Configurer les paramètres d'appel des méthodes
  initCascade(FPattern);
  tRefSs := TSQLGsSs(FPattern.listSs.Objects[0]);
  ReturnValue := FPattern.getSsInNextNumBeatsFor(tRefSs, 1);
  CheckEquals('1', ReturnValue.hash);
  ReturnValue := FPattern.getSsInNextNumBeatsFor(tRefSs, 2);
  CheckEquals('0', ReturnValue.hash);
  // TODO : Valider les résultats des méthodes
end;

initialization
  // Enregistrer tous les cas de test avec l'exécuteur de test
  RegisterTest(TestTGsPattern.Suite);
end.

