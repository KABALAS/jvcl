{ Insert famous MPL header here... }

unit JvAppRegistryStore;

interface

uses
  Classes, Windows,
  JvAppStore;

type
  TJvAppRegistryStore = class(TJvCustomAppStore)
  private
    FRegHKEY: HKEY;
  protected
    function GetApplicationRoot: string;
    procedure SetApplicationRoot(Value: string);
    { Split the specified path into an absolute path and a value name (the last item in the path
      string). Just a helper for all the storage methods. }
    procedure SplitKeyPath(const Path: string; out Key, ValueName: string);
    procedure CreateKey(Key: string);
  public
    constructor Create(AOwner: TComponent); override;
    function ValueStored(const Path: string): Boolean; override;
    procedure DeleteValue(const Path: string); override;
    function ReadInteger(const Path: string; Default: Integer = 0): Integer; override;
    procedure WriteInteger(const Path: string; Value: Integer); override;
    function ReadFloat(const Path: string; Default: Extended = 0): Extended; override;
    procedure WriteFloat(const Path: string; Value: Extended); override;
    function ReadString(const Path: string; Default: string = ''): string; override;
    procedure WriteString(const Path: string; Value: string); override;
    function ReadBinary(const Path: string; var Buf; BufSize: Integer): Integer; override;
    procedure WriteBinary(const Path: string; const Buf; BufSize: Integer); override;
  published
    { Application specific root. Determines in which of the main registry keys (Local Machine,
      Current User, etc) the data will be stored. Optionally a sub key may be added to this key
      (eg. 'HKEY_LOCAL_MACHINE\Software\Project JEDI'). The sub key is internally stored in the
      AppRoot property.}
    property ApplicationRoot: string read GetApplicationRoot write SetApplicationRoot;
  end;

implementation

uses
  SysUtils,
  JclRegistry, JclResources, JclStrings;

const
  HKEY_Names: array[HKEY_CLASSES_ROOT .. HKEY_DYN_DATA] of string = (
    'HKEY_CLASSES_ROOT',
    'HKEY_CURRENT_USER',
    'HKEY_LOCAL_MACHINE',
    'HKEY_USERS',
    'HKEY_PERFORMANCE_DATA',
    'HKEY_CURRENT_CONFIG',
    'HKEY_DYN_DATA'
  );

//===TJvAppRegistryStore============================================================================

function TJvAppRegistryStore.GetApplicationRoot: string;
begin
  Result := HKEY_Names[FRegHKEY];
  if GetAppRoot <> '' then
    Result := Result + '\' + GetAppRoot;
end;

procedure TJvAppRegistryStore.SetApplicationRoot(Value: string);
var
  SL: TStrings;
  I: DWORD;
begin
  SL := TStringList.Create;
  try
    StrToStrings(Value, '\', SL, False);
    if SL.Count > 0 then
    begin
      I := HKEY_DYN_DATA;
      while (I >= HKEY_CLASSES_ROOT) and not AnsiSameText(HKEY_Names[I], SL[0]) do
        Dec(I);
      if I >= HKEY_CLASSES_ROOT then
      begin
        FRegHKEY := I;
        SL.Delete(0);
        SetAppRoot(StringsToStr(SL, '\', False));
      end
      else
        raise Exception.CreateFmt('''%s'' is not a valid registry location', [SL[0]]);
    end
    else
      raise Exception.Create('You need to specify a location.');
  finally
    SL.Free;
  end;
end;

procedure TJvAppRegistryStore.SplitKeyPath(const Path: string; out Key, ValueName: string);
var
  AbsPath: string;
  IValueName: Integer;
begin
  AbsPath := GetAbsPath(Path);
  IValueName := LastDelimiter('\', AbsPath);
  Key := StrLeft(AbsPath, IValueName - 1);
  ValueName := StrRestOf(AbsPath, IValueName + 1);
end;

procedure TJvAppRegistryStore.CreateKey(Key: string);
var
  ResKey: HKEY;
begin
  if not RegKeyExists(FRegHKEY, Key) then
  begin
    if Windows.RegCreateKey(FRegHKEY, PChar(Key), ResKey) = ERROR_SUCCESS then
      RegCloseKey(ResKey)
    else
      raise Exception.CreateFmt('Unable to create key ''%s''', [Key]);
  end;
end;

function TJvAppRegistryStore.ValueStored(const Path: string): Boolean;
var
  SubKey: string;
  ValueName: string;
  TmpKey: HKEY;
begin
  SplitKeyPath(Path, SubKey, ValueName);
  Result := RegKeyExists(FRegHKEY, SubKey);
  if Result then
  begin
    if RegOpenKey(FRegHKEY, PChar(SubKey), TmpKey) = ERROR_SUCCESS then
    try
      Result := RegQueryValueEx(TmpKey, PChar(ValueName), nil, nil, nil, nil) = ERROR_SUCCESS;
    finally
      RegCloseKey(TmpKey);
    end
    else
      raise EJclRegistryError.CreateResRecFmt(@RsUnableToOpenKeyRead, [SubKey]);
    if not Result then
    begin
      SubKey := SubKey + '\' + ValueName;
      ValueName := 'Count';
      Result := RegKeyExists(FRegHKEY, SubKey);
      if Result then
      begin
        if RegOpenKey(FRegHKEY, PChar(SubKey), TmpKey) = ERROR_SUCCESS then
        try
          Result := RegQueryValueEx(TmpKey, PChar(ValueName), nil, nil, nil, nil) = ERROR_SUCCESS;
        finally
          RegCloseKey(TmpKey);
        end
        else
          raise EJclRegistryError.CreateResRecFmt(@RsUnableToOpenKeyRead, [SubKey]);
      end;
    end;
  end;
end;

procedure TJvAppRegistryStore.DeleteValue(const Path: string);
var
  SubKey: string;
  ValueName: string;
begin
  SplitKeyPath(Path, SubKey, ValueName);
  RegDeleteEntry(FRegHKEY, SubKey, ValueName);
end;

function TJvAppRegistryStore.ReadInteger(const Path: string; Default: Integer = 0): Integer;
var
  SubKey: string;
  ValueName: string;
begin
  SplitKeyPath(Path, SubKey, ValueName);
  Result := RegReadIntegerDef(FRegHKEY, SubKey, ValueName, Default);
end;

procedure TJvAppRegistryStore.WriteInteger(const Path: string; Value: Integer);
var
  SubKey: string;
  ValueName: string;
begin
  SplitKeyPath(Path, SubKey, ValueName);
  CreateKey(SubKey);
  RegWriteInteger(FRegHKEY, SubKey, ValueName, Value);
end;

function TJvAppRegistryStore.ReadFloat(const Path: string; Default: Extended = 0): Extended;
var
  SubKey: string;
  ValueName: string;
begin
  SplitKeyPath(Path, SubKey, ValueName);
  Result := Default;
  RegReadBinary(FRegHKEY, SubKey, ValueName, Result, SizeOf(Result));
end;

procedure TJvAppRegistryStore.WriteFloat(const Path: string; Value: Extended);
var
  SubKey: string;
  ValueName: string;
begin
  SplitKeyPath(Path, SubKey, ValueName);
  CreateKey(SubKey);
  RegWriteBinary(FRegHKEY, SubKey, ValueName, Value, SizeOf(Value));
end;

function TJvAppRegistryStore.ReadString(const Path: string; Default: string = ''): string;
var
  SubKey: string;
  ValueName: string;
begin
  SplitKeyPath(Path, SubKey, ValueName);
  Result := RegReadStringDef(FRegHKEY, SubKey, ValueName, Default);
end;

procedure TJvAppRegistryStore.WriteString(const Path: string; Value: string);
var
  SubKey: string;
  ValueName: string;
begin
  SplitKeyPath(Path, SubKey, ValueName);
  CreateKey(SubKey);
  RegWriteString(FRegHKEY, SubKey, ValueName, Value);
end;

function TJvAppRegistryStore.ReadBinary(const Path: string; var Buf; BufSize: Integer): Integer;
var
  SubKey: string;
  ValueName: string;
begin
  SplitKeyPath(Path, SubKey, ValueName);
  Result := RegReadBinary(FRegHKEY, SubKey, ValueName, Buf, BufSize);
end;

procedure TJvAppRegistryStore.WriteBinary(const Path: string; const Buf; BufSize: Integer);
var
  SubKey: string;
  ValueName: string;
  TmpBuf: Byte;
begin
  TmpBuf := Byte(Buf);
  SplitKeyPath(Path, SubKey, ValueName);
  CreateKey(SubKey);
  RegWriteBinary(FRegHKEY, SubKey, ValueName, TmpBuf, BufSize);
end;

constructor TJvAppRegistryStore.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRegHKEY := HKEY_CURRENT_USER;
end;

end.
