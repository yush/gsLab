unit GSWebServer;

interface

uses Windows, Messages, SysUtils, Variants, Classes, SynCrtSock, SynCommons, generics.Collections,
  StrUtils;
type

TGSWebServer = class
  private
    fServer: THttpApiServer;
  public
    procedure parseUrlParams(aUrl: string; aDic: TDictionary<string, string>);
    function Process( const InURL, InMethod, InHeaders, InContent, InContentType: TSockData;
      out OutContent, OutContentType, OutCustomHeader: TSockData): cardinal;
    constructor Create;
    destructor Destroy; override;
end;

implementation


constructor TGSWebServer.Create;
begin
  fServer := THttpApiServer.Create(false);
  fServer.AddUrl('jlab','888',false,'+');
  fServer.OnRequest := Process;
end;

destructor TGSWebServer.Destroy;
begin
  fServer.Terminate;
  fServer.Free;
  inherited;
end;

procedure TGSWebServer.parseUrlParams(aUrl: string; aDic: TDictionary<string, string>);
var
  aStrList: TStringList;
  i: integer;
  value, key: string;
  posEqual: integer;
begin
  aStrList := TStringList.Create;
  aStrList.Delimiter := ';';
  aStrList.DelimitedText := aUrl;
  for i := 0 to aStrList.Count-1 do
  begin
    posEqual := System.Pos('=', aStrList.Strings[I]);
    key := leftStr(aStrList.Strings[i], posEqual-1);
    value := MidStr(aStrList.Strings[i], posEqual+1, Length(aStrList.Strings[i]));
    aDic.add(key, value);
  end;
end;

function TGSWebServer.Process(
      const InURL, InMethod, InHeaders, InContent, InContentType: TSockData;
      out OutContent, OutContentType, OutCustomHeader: TSockData): cardinal;
var
  W: TTextWriter;
  aDic: TDictionary<string, string>;
  params: string;
  i: integer;
  Enum: TDictionary<string, string>.TPairEnumerator;
begin
  W := TTextWriter.CreateOwnedStream;
  if InUrl = '/jlab/JugglingLab.jar' then
  begin
    // http.sys will send the specified file from kernel mode
    OutContent := StringToUTF8('../JugglingLab/bin/JugglingLab.jar');
    OutContentType := HTTP_RESP_STATICFILE;
    result := 200;
  end
  else if StartsStr('/jlab', InUrl) then
  begin
    aDic := TDictionary<string,string>.Create;
    params := MidStr(InUrl, Pos('?', InUrl)+1, Length(InUrl)); // split
    if params <> '' then
    begin
      parseUrlParams(params , aDic);
    end;

    W.AddString('<html><head></head>');
    W.AddString('<body>');
    W.AddString('<applet archive="/jlab/JugglingLab.jar" code="JugglingLab" width="600" height="500">');
    W.AddString('<param name="config" value="entry=none;view=edit">');
    W.AddString('<param name="notation" value="siteswap">');
    if params <> '' then
    begin
      W.Add('<param name="animprefs" value="%">', [StringToUTF8(params)] );
      W.Add('<param name="pattern" value="%">',  [StringToUTF8(params)]);
    end;

    (*
    Enum := aDic.GetEnumerator;
    while Enum.MoveNext do
      W.Add('<param name="%" value="%">',  [StringToUTF8( Enum.Current.Key ), StringToUtf8(Enum.Current.Value)]);
      *)
    W.AddString('Java not available');
    W.AddString('</applet>');
    W.AddString('</body>');
    W.AddString('</html>');
    OutContent := W.Text;
    OutContentType := HTML_CONTENT_TYPE;
    result := 200;
    aDic.Free;
  end;
end;

end.
