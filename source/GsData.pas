unit GsData;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ValEdit, ComCtrls, SynCommons, strUtils,  SQLite3, SQLite3Commons;

type

  TSQLGsSs = class;

  TSQLGsPattern = class(TSQLRecord)
  private
    FValuesEditor: TValueListEditor;
    FaSs: string;
    FlistSs: TRawUTF8List;
    Fkey: integer;
    procedure SetaSs(const Value: string);
    procedure SetlistSs(const Value: TRawUTF8List);
    procedure SetValuesEditor(const Value: TValueListEditor);
    procedure Setkey(const Value: integer);
  published
    property aSs: string read FaSs write SetaSs;
    property listSs: TRawUTF8List read FlistSs write SetlistSs;
  public
    property ValuesEditor: TValueListEditor read FValuesEditor write SetValuesEditor;
    constructor create();
    destructor destroy();
    procedure init();
    function lengthSs: integer;
    function getHandsParams: string;
    function getSsInNextNumBeatsFor(tRefSs: TSQLGsSs; numBeat: integer): TSQLGsSs;
    procedure clear;
    procedure addSs(tmpSs: TSQLGsSs);
    // figures testés
    procedure testCascade();
    procedure testCascadeInverse;
    procedure testHalfShower;
    function save(aDb: TSQLRestServerDB): boolean;
    function load(aDb: TSQLRestServerDB): boolean;
    function loadAll(aDb: TSQLRestServerDB): boolean;
    procedure assign(dest: TSQLGsPattern);
  end;

  TSQLGsSs = class(TSQLRecord)
  private
    FParentPattern: TSQLGsPattern;
    FSsBase: integer;
    FThrHand: string;
    FThrPos: string;
    FCatPos: string;
    FCatHand: string;
    Fhash: string;
    FcatModifier: string;
    FthrModfier: string;
    procedure SetcatPos(const Value: string);
    procedure SetparentPattern(const Value: TSQLGsPattern);
    procedure SetssBase(const Value: integer);
    procedure SetthrPos(const Value: string);
    procedure Sethash(const Value: string);
    procedure SetcatPosCoord(const Value: string);
    procedure SetthrPosCoord(const Value: string);
    function getCatPosCoord: double;
    function getThrPosCoord: double;
    procedure SetthrHand(const Value: string);
    procedure SetcatHand(const Value: string);
    procedure SetcatModifier(const Value: string);
    procedure SetthrModfier(const Value: string);
  published
    property ssBase: integer read FssBase write SetssBase;
    property thrHand: string read FthrHand write SetthrHand;
    property catHand: string read FcatHand write SetcatHand;
    property thrModfier: string read FthrModfier write SetthrModfier;
    property catModifier: string read FcatModifier write SetcatModifier;
    property thrPos: string read FthrPos write SetthrPos;
    property catPos: string read FcatPos write SetcatPos;
  public
    property parentPattern: TSQLGsPattern read FparentPattern write SetparentPattern;
    property hash: string read Fhash write Sethash;
    property thrPosCoord: double read getThrPosCoord;
    property catPosCoord: double read getCatPosCoord;
    function getNext: TSQLGsSs;
    procedure assign(dest: TSQLGsSs);
    constructor Create(aPattern: TSQLGsPattern);
    destructor Destroy();
  end;

  TDataPattern = record
    aPattern: TSQLGsPattern;
  end;

implementation

{ TGs }

procedure TSQLGsPattern.addSs(tmpSs: TSQLGsSs);
begin
  tmpSs.parentPattern := self;
  listSs.AddObject('', tmpSs);
end;

procedure TSQLGsPattern.assign(dest: TSQLGsPattern);
var
  i: integer;
begin
  dest.FaSs := FaSs;
  for i := 0 to listSs.Count-1 do
    dest.listSs.Add(listSs.Strings[i]);
end;

procedure TSQLGsPattern.clear;
var
  i: integer;
  aGsSs:TSQLGsSs;
begin
  aSs := '';
  for i := 0 to listSs.Count-1 do
  begin
    aGsSs := TSQLGsSs(listSs.Objects[i]);
    FreeAndNil(aGsSs);
  end;
  listSs.Clear;
end;

constructor TSQLGsPattern.create;
begin
  inherited;
  FListSs := TRawUTF8List.Create;
end;

destructor TSQLGsPattern.destroy;
begin
  clear;
  listSs.Free;
end;

function TSQLGsPattern.getHandsParams: string;
var
  i: integer;
  aSsThr, aSsCat: TSQLGsSs;
  strThr, strCat: string;
begin
  result := '';
  i := 0;
  while i < listSs.Count do
  begin
    aSsThr := TSQLGsSs(listSs.Objects[i]);
    aSsCat := self.getSsInNextNumBeatsFor(aSsThr, 1);
    strThr := FloatToStr(aSsThr.thrPosCoord);
    strCat := FloatToStr(aSsCat.CatPosCoord);
    result := result + Format('(%s)(%s).', [strThr, strCat]);
    inc(i);
  end;
end;

function TSQLGsPattern.getSsInNextNumBeatsFor(tRefSs: TSQLGsSs; numBeat: integer): TSQLGsSs;
var
  i, idx: integer;
  tmpSs: TSQLGsSs;
begin
  idx := listSs.IndexOfObject(tRefSs);
  if idx <> -1 then
  begin
    tmpSs := tRefSs;
    for i := 0 to numBeat-1 do
    begin
      tmpSs := tmpSs.getNext;
    end;
    result := tmpSs;
  end;
end;

procedure TSQLGsPattern.init;
var
  aSs: TSQLGsSs;
  i: integer;
begin
  Clear;
  for i := 1 to lengthSs do
  begin
    aSs := TSQLGsSs.Create(self);
    if i mod 2 = 0 then
      aSs.thrHand := 'r'
    else
      aSs.thrHand := 'l';
    aSs.ssBase := StrToInt(self.aSs[i]);
    aSs.thrPos :='r';
    aSs.catPos :='c';
    aSs.catHand := getSsInNextNumBeatsFor(aSs, aSs.ssBase).thrHand;
    aSs.hash := IntToStr(i);
    addSs(aSs);
  end;
end;

procedure TSQLGsPattern.testCascade;
var
  aGsSs: TSQLGsSs;
begin
  clear;
  aSs := '33';
  aGsSs := TSQLGsSs.Create(self);
  aGsSs.thrHand := 'l';
  aGsSs.ssBase := 3;
  aGsSs.thrPos := 'c';
  aGsSs.catPos := 'r';
  aGsSs.thrModfier := 'inside';
  addSs(aGsSs);
  aGsSs := TSQLGsSs.Create(self);
  aGsSs.thrHand := 'r';
  aGsSs.ssBase := 3;
  aGsSs.thrPos := 'c';
  aGsSs.catPos := 'l';
  aGsSs.thrModfier := 'inside';
  addSs(aGsSs);
end;

function TSQLGsPattern.lengthSs: integer;
begin
  result := length(aSs);
end;

function TSQLGsPattern.load(aDb: TSQLRestServerDB): boolean;
var
  aTmpSs, newSs: TSQLGsSs;
  i, idToGet: integer;
begin
  for i := 0 to listSs.Count-1 do
  begin
    idToGet := StrToInt(listSs.Strings[i]);
    aTmpSs := TSQLGsSs.Create(self);
    aDb.Retrieve(idToGet, aTmpSs);
    listSs.Objects[i] := aTmpSs;
  end;
end;

function TSQLGsPattern.loadAll(aDb: TSQLRestServerDB): boolean;
begin

end;

function TSQLGsPattern.save(aDb: TSQLRestServerDB): boolean;
var
  i, idSs: integer;
  tmpSs: TSQLGsSs;
begin
  for i := 0 to listSs.Count-1 do
  begin
    tmpSs := TSQLGsSs(listSs.Objects[i]);
    idSs := aDb.Add(tmpSs, true);
    listSs.strings[i] := IntToStr(idSs);
  end;
  aDb.Add(self, true);
end;

procedure TSQLGsPattern.SetaSs(const Value: string);
begin
  FaSs := Value;
end;

procedure TSQLGsPattern.Setkey(const Value: integer);
begin
  Fkey := Value;
end;

procedure TSQLGsPattern.SetlistSs(const Value: TRawUTF8List);
begin
  FlistSs := Value;
end;

procedure TSQLGsPattern.SetValuesEditor(const Value: TValueListEditor);
begin
  FValuesEditor := Value;
end;

procedure TSQLGsPattern.testCascadeInverse;
var
  aGsSs: TSQLGsSs;
begin
  clear;
  aSs := '33';
  aGsSs := TSQLGsSs.Create(self);
  aGsSs.thrHand := 'l';
  aGsSs.ssBase := 3;
  aGsSs.thrPos := 'l';
  aGsSs.catPos := 'c';
  addSs(aGsSs);

  aGsSs := TSQLGsSs.Create(self);
  aGsSs.thrHand := 'r';
  aGsSs.ssBase := 3;
  aGsSs.thrPos := 'r';
  aGsSs.catPos := 'c';
  self.addSs(aGsSs);
end;

procedure TSQLGsPattern.testHalfShower;
var
  aGsSs: TSQLGsSs;
begin
  clear;
  aSs := '53';
  aGsSs := TSQLGsSs.Create(self);
  aGsSs.ssBase := 5;
  aGsSs.thrHand := 'l';
  aGsSs.thrPos := 'l';
  aGsSs.catPos := 'r';
  aGsSs.thrModfier := 'outside';
  self.addSs(aGsSs);

  aGsSs := TSQLGsSs.Create(self);
  aGsSs.ssBase := 3;
  aGsSs.thrHand := 'r';
  aGsSs.thrPos := 'r';
  aGsSs.catPos := 'l';
  aGsSs.thrModfier := 'inside';
  self.addSs(aGsSs);
end;
{ TSs }

procedure TSQLGsSs.assign(dest: TSQLGsSs);
begin
  dest.FParentPattern := FParentPattern;
  dest.FSsBase := FSsBase;
  dest.FThrHand := FThrHand;
  dest.FThrPos := FThrPos;
  dest.FCatPos := FCatPos;
  dest.FCatHand := FCatHand;
  dest.Fhash := Fhash;
  dest.FcatModifier := FcatModifier;
  dest.FthrModfier := FthrModfier;
end;

constructor TSQLGsSs.Create(aPattern: TSQLGsPattern);
begin
  parentPattern := aPattern;
end;

destructor TSQLGsSs.Destroy;
begin

end;

function TSQLGsSs.getCatPosCoord: double;
begin
  result := StrToFloat(parentPattern.ValuesEditor.Values[catPos]);
end;

function TSQLGsSs.getNext: TSQLGsSs;
var
  idx: integer;
begin
  result := nil;
  idx := parentPattern.listSs.IndexOfObject(self);
  if idx <> -1 then
  begin
    inc(idx);
    if idx > parentPattern.listSs.Count-1 then
      idx := 0;
    result := TSQLGsSs(parentPattern.listSs.Objects[idx]);
  end;
end;

function TSQLGsSs.getThrPosCoord: double;
begin
  result := StrToFloat(parentPattern.ValuesEditor.Values[thrPos]);
  if thrModfier = 'inside' then
    result := result - 10
  else if thrModfier = 'outside' then
    result := result + 10;
end;

procedure TSQLGsSs.SetcatHand(const Value: string);
begin
  FcatHand := Value;
end;

procedure TSQLGsSs.SetcatModifier(const Value: string);
begin
  FcatModifier := Value;
end;

procedure TSQLGsSs.SetcatPos(const Value: string);
begin
  FcatPos := Value;
end;

procedure TSQLGsSs.SetcatPosCoord(const Value: string);
begin

end;

procedure TSQLGsSs.Sethash(const Value: string);
begin
  Fhash := Value;
end;

procedure TSQLGsSs.SetparentPattern(const Value: TSQLGsPattern);
begin
  FparentPattern := Value;
end;


procedure TSQLGsSs.SetssBase(const Value: integer);
begin
  FssBase := Value;
end;

procedure TSQLGsSs.SetthrHand(const Value: string);
begin
  FthrHand := Value;
end;

procedure TSQLGsSs.SetthrModfier(const Value: string);
begin
  FthrModfier := Value;
end;

procedure TSQLGsSs.SetthrPos(const Value: string);
begin
  FthrPos := Value;
end;

procedure TSQLGsSs.SetthrPosCoord(const Value: string);
begin

end;

end.
