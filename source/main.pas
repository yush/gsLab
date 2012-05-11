unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ValEdit, SHDocVw,
  ComCtrls, VirtualTrees, SynCommons, strUtils, GsWebServer, SQLite3, SQLite3Commons,
  Grids, OleCtrls, GsData;

const
  colWidth = 60;
  edtHeight = 50;
  NUM_INFO = 7; //ssTime, thrHand, catHand, thrPos, catPos, thrModifier, catModifier

type

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
    Panel1: TPanel;
    Panel2: TPanel;
    lstPattern: TListView;
    btnSave: TButton;
    btnLoad: TButton;
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
    procedure btnLoadClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Déclarations privées }
    nbCol: integer;
    fGsWebServer: TGsWebServer;
    fGsDatabase: TSQLRest;
    fGsModel: TSQLModel;
    function generateUrl():string;
  public
    { Déclarations publiques }
    function getPeriod(aSs: string): double;
    function lengthSs(aSs: string): integer;
    procedure initVst(aPattern: TSQLGsPattern);
    procedure loadPattern(aPattern: TSQLGsPattern);
  end;

var
  Form1: TForm1;
  aPattern: TSQLGsPattern;

implementation

{$R *.dfm}

procedure TForm1.btnLoadClick(Sender: TObject);
begin
  lstPattern.AddItem(aPattern.aSs, aPattern);
end;

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

procedure TForm1.btnSaveClick(Sender: TObject);
begin
  fGsDatabase.Add(aPattern, true);
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
  aPattern := TSQLGsPattern.create;
  aPattern.ValuesEditor := vlePos;
  fGsWebServer := TGsWebServer.Create;
  fGsModel := TSQLModel.Create([TSQLGsPattern]);
  fGsDatabase := TSQLRestServerDB.Create(fGsModel, ChangeFileExt(paramstr(0),'.db3'));
  TSQLRestServerDB(fGsDatabase).CreateMissingTables(0);

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


procedure TForm1.initVst(aPattern: TSQLGsPattern);
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

procedure TForm1.loadPattern(aPattern: TSQLGsPattern);
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

