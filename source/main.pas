unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, ValEdit, OleCtrls, SHDocVw,
  ComCtrls, IdBaseComponent, IdComponent, IdCustomTCPServer, IdCustomHTTPServer,
  IdHTTPServer, VirtualTrees, SynCommons, idHttp, generics.Collections, strUtils, GsWebServer;

const
  colWidth = 60;
  edtHeight = 50;
  NUM_INFO = 7; //ssTime, thrHand, catHand, thrPos, catPos, thrModifier, catModifier

type
  Tss = class;

  TVstPatternEditLink = class(TInterfacedObject, IVTEditLink)
    private
      FEdit: TWinControl;        // One of the property editor classes.
      FTree: TVirtualStringTree; // A back reference to the tree calling.
      FNode: PVirtualNode;       // The node being edited.
      FColumn: Integer;          // The column of the node being edited.
    protected
      procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    public
      destructor Destroy; override;
      function BeginEdit: Boolean; stdcall;
      function CancelEdit: Boolean; stdcall;
      function EndEdit: Boolean; stdcall;
      function GetBounds: TRect; stdcall;
      function PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean; stdcall;
      procedure ProcessMessage(var Message: TMessage); stdcall;
      procedure SetBounds(R: TRect); stdcall;
  end;

  TGsPattern = class
  private
    FValuesEditor: TValueListEditor;
    FaSs: string;
    FlistSs: TStringList;
    procedure SetaSs(const Value: string);
    procedure SetlistSs(const Value: TStringList);
    procedure SetValuesEditor(const Value: TValueListEditor);
  published
  public
    property ValuesEditor: TValueListEditor read FValuesEditor write SetValuesEditor;
    property aSs: string read FaSs write SetaSs;
    property listSs: TStringList read FlistSs write SetlistSs;
    constructor create();
    destructor destroy();
    procedure init();
    function lengthSs: integer;
    function getHandsParams: string;
    function getSsInNextNumBeatsFor(tRefSs: TSs; numBeat: integer): TSs;
    procedure clear;
    procedure addSs(tmpSs: TSs);
    // figures testés
    procedure testCascade();
    procedure testCascadeInverse;
    procedure testHalfShower;
  end;

  TSs = class
  private
    FParentPattern: TGsPattern;
    FSsBase: integer;
    FThrHand: string;
    FThrPos: string;
    FCatPos: string;
    FCatHand: string;
    Fhash: string;
    FcatModifier: string;
    FthrModfier: string;
    procedure SetcatPos(const Value: string);
    procedure SetparentPattern(const Value: TGsPattern);
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
  public
    property parentPattern: TGsPattern read FparentPattern write SetparentPattern;
    property ssBase: integer read FssBase write SetssBase;
    property thrPos: string read FthrPos write SetthrPos;
    property catPos: string read FcatPos write SetcatPos;
    property hash: string read Fhash write Sethash;
    property thrHand: string read FthrHand write SetthrHand;
    property catHand: string read FcatHand write SetcatHand;
    property thrPosCoord: double read getThrPosCoord;
    property catPosCoord: double read getCatPosCoord;
    property thrModfier: string read FthrModfier write SetthrModfier;
    property catModifier: string read FcatModifier write SetcatModifier;
    function getNext: TSs;
    constructor Create(aPattern: TGsPattern);
    destructor Destroy();
  end;

  TDataPattern = record
    aPattern: TGsPattern;
  end;

  PDataPattern = ^TDataPattern;

  TForm1 = class(TForm)
    edtSs: TEdit;
    lblPeriodLength: TLabel;
    Button1: TButton;
    mmoResult: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    edtRepetition: TEdit;
    btnProcess: TButton;
    vlePos: TValueListEditor;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    vstPattern: TVirtualStringTree;
    WebBrowser1: TWebBrowser;
    memoUrl: TMemo;
    testCascade: TButton;
    testCascadeInverse: TButton;
    testHalfShower: TButton;
    procedure Button1Click(Sender: TObject);
    procedure btnProcessClick(Sender: TObject);
    procedure vstPatternGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure FormCreate(Sender: TObject);
    procedure vstPatternGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure vstPatternCreateEditor(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure vstPatternEditing(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure testTrick(Sender: TObject);
  private
    { Déclarations privées }
    nbCol: integer;
    fGsWebServer: TGsWebServer;
    function generateUrl():string;
  public
    { Déclarations publiques }
    function getPeriod(aSs: string): double;
    function lengthSs(aSs: string): integer;
    procedure initVst(aPattern: TGsPattern);
    procedure loadPattern(aPattern: TGsPattern);
  end;

var
  Form1: TForm1;
  aPattern: TGsPattern;

implementation

{$R *.dfm}

procedure TForm1.btnProcessClick(Sender: TObject);
var
  url: string;
begin
  url := generateUrl();
  mmoResult.Text := aPattern.getHandsParams;
  memoUrl.Text := url;
  WebBrowser1.Stop;
  WebBrowser1.Navigate(url);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  lblPeriodLength.Caption := FormatFloat('0.00', getPeriod(edtSs.text));
  if round(getPeriod(edtSs.text)) = getPeriod(edtSs.text) then
  begin
    nbCol := lengthSs(edtSs.text)*StrToInt(edtRepetition.Text);
  end;

  aPattern.aSs := edtSs.text;
  aPattern.init;
  initVst(aPattern);
end;

procedure TForm1.testTrick(Sender: TObject);
begin
  if Sender = testCascade then
    aPattern.testCascade
  else if Sender = testCascadeInverse then
    aPattern.testCascadeInverse
  else if Sender = testHalfShower then
    aPattern.testHalfShower;
  loadPattern(aPattern);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  aPattern := TGsPattern.create;
  aPattern.ValuesEditor := vlePos;
  fGsWebServer := TGsWebServer.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  fGsWebServer.Free;
end;

function TForm1.getPeriod(aSs: string): double;
var
  I: Integer;
begin
  result := 0;
  for I := 1 to length(aSs) do
  begin
    result := result + StrToInt(aSs[I]);
  end;
  result := result/length(aSs);
end;


procedure TForm1.initVst(aPattern: TGsPattern);
var
  aCol: TVirtualTreeColumn;
  i: integer;
  pNode: PVirtualNode;
  pData: PDataPattern;
begin
  vstPattern.Header.Columns.Clear;
  vstPattern.Clear;
  for i := 0 to aPattern.lengthSs-1 +1 do
  begin
    aCol := vstPattern.Header.Columns.Add;
    aCol.Text := 'name';
    aCol.Width := 100;
  end;

  for i := 0 to NUM_INFO-1 do
  begin
    pNode := vstPattern.AddChild(nil);
    pData := vstPattern.GetNodeData(pNode);
    pData.aPattern := aPattern;
  end;
end;

function TForm1.lengthSs(aSs: string): integer;
begin
  result := length(aSs);
end;

procedure TForm1.loadPattern(aPattern: TGsPattern);
begin
  edtSs.Text := aPattern.aSs;
  edtRepetition.Text := '1';
  initVst(aPattern);
end;

function TForm1.generateUrl(): string;
var
  params, paramsHands: string;
  url: string;
begin
  url := 'http://localhost:888/jlab';
  if TSs(aPattern.listSs.Objects[0]).thrHand = 'l' then
    params := '?pattern=L' + aPattern.aSs
  else
    params := '?pattern=R' + aPattern.aSs;
  paramsHands := ';hands=' + aPattern.getHandsParams;
  result := url + params + paramsHands;
end;

procedure TForm1.vstPatternCreateEditor(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
begin
  EditLink := TVstPatternEditLink.Create;
end;

procedure TForm1.vstPatternEditing(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; var Allowed: Boolean);
begin
  // la premiere colonne est pour les titres
  if Column > 0 then
    Allowed := true;
end;

procedure TForm1.vstPatternGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := sizeof(TDataPattern);
end;

procedure TForm1.vstPatternGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  pPattern: PDataPattern;
  aSs: TSs;
begin
  pPattern:= vstPattern.GetNodeData(Node);
  if Column = 0 then
  begin
     begin
      case Node.Index of
        0: CellText := 'ssTime';
        1: CellText := 'thrHand';
        2: CellText := 'catHand';
        3: CellText := 'thrPos';
        4: CellText := 'catPos';
        5: CellText := 'thrModifier';
        6: CellText := 'catModifier';
      end;
    end;
  end
  else if (Column > 0) and (Column <= pPattern.aPattern.lengthSs-1+1)  then
  begin
    aSs := TSs(pPattern.aPattern.listSs.Objects[Column-1]);
    if aSs <> nil then
    begin
      case Node.Index of
        0: CellText := IntToStr(aSs.ssBase);
        1: CellText := aSs.thrHand;
        2: CellText := aSs.catHand;
        3: CellText := aSs.thrPos;
        4: CellText := aSs.catPos;
        5: CellText := aSs.thrModfier;
        6: CellText := aSs.catModifier;
      end;
    end;
  end;
end;

{ TGs }

procedure TGsPattern.addSs(tmpSs: TSs);
begin
  tmpSs.hash := IntToStr(listSs.count);
  listSs.AddObject(tmpSs.hash, tmpSs);
end;

procedure TGsPattern.clear;
var
  i: integer;
  aGsSs:TSs;
begin
  aSs := '';
  for i := 0 to listSs.Count-1 do
  begin
    aGsSs := TSs(listSs.Objects[i]);
    FreeAndNil(aGsSs);
  end;
  listSs.Clear;
end;

constructor TGsPattern.create;
begin
  listSs := TStringList.Create;
end;

destructor TGsPattern.destroy;
begin
  clear;
  listSs.Free;
end;

function TGsPattern.getHandsParams: string;
var
  i: integer;
  aSsThr, aSsCat: TSs;
  strThr, strCat: string;
begin
  result := '';
  i := 0;
  while i < listSs.Count do
  begin
    aSsThr := TSs(listSs.Objects[i]);
    aSsCat := self.getSsInNextNumBeatsFor(aSsThr, 1);
    strThr := FloatToStr(aSsThr.thrPosCoord);
    strCat := FloatToStr(aSsCat.CatPosCoord);
    result := result + Format('(%s)(%s).', [strThr, strCat]);
    inc(i);
  end;
end;

function TGsPattern.getSsInNextNumBeatsFor(tRefSs: TSs; numBeat: integer): TSs;
var
  i, idx: integer;
  tmpSs: TSs;
begin
  idx := listSs.IndexOf(tRefSs.hash);
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

procedure TGsPattern.init;
var
  aSs: TSs;
  i: integer;
begin
  Clear;
  for i := 1 to lengthSs do
  begin
    aSs := TSs.Create(self);
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

procedure TGsPattern.testCascade;
var
  aGsSs: TSs;
begin
  clear;
  aSs := '33';
  aGsSs := TSs.Create(self);
  aGsSs.thrHand := 'l';
  aGsSs.ssBase := 3;
  aGsSs.thrPos := 'c';
  aGsSs.catPos := 'r';
  aGsSs.thrModfier := 'inside';
  addSs(aGsSs);
  aGsSs := TSs.Create(self);
  aGsSs.thrHand := 'r';
  aGsSs.ssBase := 3;
  aGsSs.thrPos := 'c';
  aGsSs.catPos := 'l';
  aGsSs.thrModfier := 'inside';
  addSs(aGsSs);
end;

function TGsPattern.lengthSs: integer;
begin
  result := length(aSs);
end;

procedure TGsPattern.SetaSs(const Value: string);
begin
  FaSs := Value;
end;

procedure TGsPattern.SetlistSs(const Value: TStringList);
begin
  FlistSs := Value;
end;

procedure TGsPattern.SetValuesEditor(const Value: TValueListEditor);
begin
  FValuesEditor := Value;
end;

procedure TGsPattern.testCascadeInverse;
var
  aGsSs: Tss;
begin
  clear;
  aSs := '33';
  aGsSs := TSs.Create(self);
  aGsSs.thrHand := 'l';
  aGsSs.ssBase := 3;
  aGsSs.thrPos := 'l';
  aGsSs.catPos := 'c';
  addSs(aGsSs);

  aGsSs := TSs.Create(self);
  aGsSs.thrHand := 'r';
  aGsSs.ssBase := 3;
  aGsSs.thrPos := 'r';
  aGsSs.catPos := 'c';
  self.addSs(aGsSs);
end;

procedure TGsPattern.testHalfShower;
var
  aGsSs: TSs;
begin
  clear;
  aSs := '53';
  aGsSs := TSs.Create(self);
  aGsSs.ssBase := 5;
  aGsSs.thrHand := 'l';
  aGsSs.thrPos := 'l';
  aGsSs.catPos := 'r';
  aGsSs.thrModfier := 'outside';
  self.addSs(aGsSs);

  aGsSs := TSs.Create(self);
  aGsSs.ssBase := 3;
  aGsSs.thrHand := 'r';
  aGsSs.thrPos := 'r';
  aGsSs.catPos := 'l';
  aGsSs.thrModfier := 'inside';
  self.addSs(aGsSs);
end;

{ TSs }

constructor TSs.Create(aPattern: TGsPattern);
begin
  parentPattern := aPattern;
end;

destructor TSs.Destroy;
begin

end;

function TSs.getCatPosCoord: double;
begin
  result := StrToFloat(parentPattern.ValuesEditor.Values[catPos]);
end;

function TSs.getNext: TSs;
var
  idx: integer;
begin
  result := nil;
  parentPattern.listSs.Find(self.hash, idx);//.lis
  if idx <> -1 then
  begin
    inc(idx);
    if idx > parentPattern.listSs.Count-1 then
      idx := 0;
    result := TSs(parentPattern.listSs.Objects[idx]);
  end;
end;

function TSs.getThrPosCoord: double;
begin
  result := StrToFloat(parentPattern.ValuesEditor.Values[thrPos]);
  if thrModfier = 'inside' then
    result := result - 10
  else if thrModfier = 'outside' then
    result := result + 10;
end;

procedure TSs.SetcatHand(const Value: string);
begin
  FcatHand := Value;
end;

procedure TSs.SetcatModifier(const Value: string);
begin
  FcatModifier := Value;
end;

procedure TSs.SetcatPos(const Value: string);
begin
  FcatPos := Value;
end;

procedure TSs.SetcatPosCoord(const Value: string);
begin

end;

procedure TSs.Sethash(const Value: string);
begin
  Fhash := Value;
end;

procedure TSs.SetparentPattern(const Value: TGsPattern);
begin
  FparentPattern := Value;
end;

procedure TSs.SetssBase(const Value: integer);
begin
  FssBase := Value;
end;

procedure TSs.SetthrHand(const Value: string);
begin
  FthrHand := Value;
end;

procedure TSs.SetthrModfier(const Value: string);
begin
  FthrModfier := Value;
end;

procedure TSs.SetthrPos(const Value: string);
begin
  FthrPos := Value;
end;

procedure TSs.SetthrPosCoord(const Value: string);
begin

end;

{ TVstPatternEditLink }

function TVstPatternEditLink.BeginEdit: Boolean;
begin
  Result := True;
  FEdit.Show;
  FEdit.SetFocus;
end;

function TVstPatternEditLink.CancelEdit: Boolean;
begin

end;

destructor TVstPatternEditLink.Destroy;
begin

  inherited;
end;

procedure TVstPatternEditLink.EditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

end;

function TVstPatternEditLink.EndEdit: Boolean;
var
  data: PDataPattern;
  iLine: integer;
  aSs: TSs;
begin
  Result := true;
  data := FTree.GetNodeData(FNode);
  iLine := FNode.index;

  aSs := TSs(data.aPattern.listSs.objects[FColumn-1]);
  case iLine of
    1 : aSs.thrHand := TComboBox(FEdit).text;
    2 : aSs.catHand := TComboBox(FEdit).text;
    3 : aSs.thrPos := TComboBox(FEdit).text;
    4 : aSs.catPos := TComboBox(FEdit).text;
  end;
  FEdit.Hide;
  FTree.SetFocus;
end;

function TVstPatternEditLink.GetBounds: TRect;
begin
  Result := FEdit.BoundsRect;
end;

function TVstPatternEditLink.PrepareEdit(Tree: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex): Boolean;
var
  data: PDataPattern;
  i, iLine: integer;
  aSs: TSs;
begin
  Result := True;
  FTree := Tree as TVirtualStringTree;
  FNode := Node;
  FColumn := Column;

  FEdit.Free;
  FEdit := nil;
  data := FTree.GetNodeData(Node);
  iLine := Node.index;

  aSs := TSs(data.aPattern.listSs.objects[FColumn-1]);
  FEdit := TComboBox.Create(nil);
  with FEdit as TComboBox do
  begin
    Ctl3D := false;
    ParentCtl3D := false;
    Visible := False;
    Parent := Tree;
    Text := 'test';
    OnKeyDown := EditKeyDown;
    Color     := clInfoBk;
    case iLine of
      // Pos
      1, 2: begin
        if aPattern.ValuesEditor.Strings.Count > 0 then
        begin
          for i := 1 to aPattern.ValuesEditor.Strings.Count do
          begin
            AddItem(aPattern.ValuesEditor.keys[I], nil);
          end;
          Text := aPattern.ValuesEditor.keys[1];
        end;
      end;
      // Modifier
      5, 6: begin
        AddItem('inside', nil);
        AddItem('outside', nil);
        AddItem('column', nil);
      end;
    end;
    case iLine of
       1 : text := aSs.thrPos;
       2 : text := aSs.catPos;
       5 : text := aSs.thrModfier;
       6 : text := aSs.catModifier;
    end
  end

end;

procedure TVstPatternEditLink.ProcessMessage(var Message: TMessage);
begin
  FEdit.WindowProc(Message);
end;

procedure TVstPatternEditLink.SetBounds(R: TRect);
var
  Dummy: Integer;
begin
  FTree.Header.Columns.GetColumnBounds(FColumn, Dummy, R.Right);
  FEdit.BoundsRect := R;
end;

end.

