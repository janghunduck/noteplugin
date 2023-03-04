unit KeFreeUtil;

{ -------------------rule---------------------- }
{ mommy, mom = memory }

{ s   = string,
  p   = pinter,
  a,b = integer
  b   = boolean
  m   = message
  f   = file or filename }
  
{ @:  = memory related method }
{ s:  = string related method }
{ f:  = file operation}
{ tv: = tree view }

interface


uses 
     classes,
     Windows,
     Graphics,
     SysUtils,
     dialogs,
     Controls,
     ShlObj,
     ActiveX,

     Variants,
     Messages,
     StdCtrls,
     Forms,
     Math,
     Tlhelp32,
     ShellApi,
     DB,
     filectrl,
     psAPI,
     comctrls; { Ttreeview }


type
  Tarraystr = array of string;
  
{ mmomy related function }
{ ====================}
function c_strtopchar(s:string):pchar;              {@ }
function c_pointertopchar(p:pointer):pchar;         {@ }
function c_strtomommy_v1(s:string):pchar;           {@ memory allocation by fillchar}
function c_strtomommy_v2(s:string):pchar;           {@ memory allocation by getmem }

procedure c_delete(var s1:string; a,b:integer);        { s1의 a번째 부터 b개를 삭제한다. '12345678' 이면 a=3, b=4, => 1278}
procedure c_insert(var s1:string; const s2:string; a:integer);
                                                       { s1의 a 번째부터 s2를 삽입한다. }
procedure c_fillchar(var p; a:integer; b:byte=0);      {@ p(buffer) 를 초기화 해서 공간을 확보한다. }
                                                       { c_fillchar(p1, sizeof(p2),0); }
procedure c_getmem(var p:pointer; a:integer);          {@ p 를 a 사이즈 만큼 초기화해 할당한다. new 보다 낳다? }
                                                       { GetMem(recPointer, 3 * SizeOf(TRecord));}
procedure c_new(var p:pointer);                        {@ New is used when the storage is requirement is fixed in size. }
                                                       { new(recPointer) }
procedure c_reallocmem(var p:pointer; a:integer);      {@ changes the storage size of an existing block of storage.}
                                                       { 이미 할당된 메모리를 변경 하고자 할때 사용함. }
                                                       { ReallocMem(recPointer, 3 * SizeOf(TRecord)); }
//allocmem
procedure c_setlength(s:string; a:integer);            {@ changes the size of a string, single dimensional dynamic array, }
                                                       { or multidimensional dynamic }
procedure c_dispose(var p:pointer);                    {@ new 에 의해 할당된 메모리를 제거한다.  }
procedure c_freemem(var p:pointer);                    {@ getmem 에 의해 할당된 메모리를 제거한다. }
procedure c_move(var p1; const p2; a:integer);         {@ a=copycount, c_move(dest[3], source[5], 4); p1,p2는 memory pointer 이다. }
function c_length(s:string):integer;
function c_stringofchar(c:char; a:integer):string;     { setlength(s, 10); StringOfChar('-', Length(s));}
procedure c_fastcopy(p1,p2:pchar;a:integer);           { p1의 a길이를 p2에 복사한다. }
function c_momcopy(p:pointer;a:integer):pointer;       { pointer 를 복사한다. memory duplicate }
function c_streamtomemory(s:Tstream):Tmemorystream;
function c_stringtomemory(s:string): Tmemorystream;

{ file and dir operation }
{ ====================}
procedure c_chdir(const s:string);                     { c_chdir('c:\aaa'); 변경되고 나면 현재 디렉이 변경되는가? }
//porcedure c_getdir(d:byte; var s:string);
procedure c_mkdir(const s:string);                     {f: makes a new directory in the current directory }
                                                       { c_mkdir('aaa'); }
                                                       { If the directory already exists, an EInOutError exception is thrown }

function c_getcurrentdir:string;                       {f: C:\Program Files\Borland\Delphi7\Projects }
function c_setcurrentdir(const s:string):boolean;      {f: sets the current directory to Dir, returning True if successful. }
                                                       { c_setcurrentdir('C:\Program Files'); }
                                                       {f: If the directory does not exist, then getLAstError }
function c_removedir(const s:string):boolean;          {f: c_removedir('aaa'); removes a directory Dir from the current directory }
function c_forceDirectories(const s:string):boolean;   { c_forceDirectories('c:\aaa\bbb'); aaa,bbb 한방에 2개의 디렉을 만든다. }
function c_createdir(const s:string):boolean;          {f: c_createdir('aaa'); creates a new directory Dir in the current directory }
                                                       {  If the create succeeded, the True is returned, }
                                                       {  otherwise the error can be obtained using GetLastError.}

procedure c_mkdir_eg;                                  {f: c_mkdir testing procedure. It's sample code }
procedure c_rmdir(const s:string);                    (*f: You can avoid such an exception by preventing IO errors
                                                         using the {$IOChecks Off} compiler directive.*)
procedure c_assignfile(var h:textfile; const f:string);{f:  AssignFile(myFile, 'Test.txt'); }
procedure c_closefile(var h:textfile);
procedure c_reset(var h:textfile);
function c_fileexists(const f:string):boolean;
function c_filecreate(const f:string):integer;
function c_deletefile(const f:string):boolean;
function c_renamefile(const f1,f2:string):boolean;

function c_loadfile_v1(const f:string):string;            { 파일을 열고(Tfilestream) string으로 받는다. }
function c_loadfile_v2(const f:string):Tstringlist;       { Tstringlist.loadfromfile }
function c_loadfile_v3(const f:string):Tfilestream;       { Tfilestream }
function c_loadfile_v4(const f:string):Pchar;             { filestream -> memory -> pchar }
function c_loadfile_api(const f:string):ansistring;


procedure c_savefile_v1(const f:string; s:string);        { s 를 저장장한다. }
procedure c_savefile_v3(const f:string; s:Tstream);       { c_loadfile_v3로 읽어옴, stream 를 저장한다. }
function c_savefile_api(const Content: ansistring; const FileName: TFileName;FlushOnDisk: boolean=false): boolean;

  
function c_filecopy_v1(f1, f2: string): boolean;          { stream copy }
function c_filecopy_v2(f1, f2: string): boolean;          { law copy }

function c_appdir: string;                                { 현재 프로그램 exe 가 있는 Dir }
function c_DirectoryExists(s: string): boolean;

{ string operlation }
{ ====================}
function c_comparestr(s1,s2:string):boolean;           { two string equal is true, case sensitive }
function c_comparetext(s1,s2:string):boolean;          { two string equal is true, ignoring case }
function c_ansicomparestr(s1,s2:string):boolean;       { two string equal is true, case sensitive and supported multi-byte }
                                                       { e.g) c_ansicomparestr('나와','나와'); }
                                                       { alpabet => 1byte(8bit), korea lang => 2byte }
function c_extractext(const s:string):string;  { wrong => test neede . 이 없을때 }
function c_changefileext(const s1,s2:string):string;   { c_changefileext('aaa.txt', '.old');  => aaa.old }
function c_extractfileext(const s:string):string;      { c_extractfileext('c:\aaa\test.txt'); => .txt  }
function c_extractfiledir(const s:string):string;      { c_extractfiledir('c:\aaa\test.txt'); => c:\aaa }
function c_extractfilepath(const s:string):string;     { c_extractfilepath('c:\aaa\test.txt'); => c:\aaa\ }
function c_extractfilename(const s:string):string;     { c_extractfilename('c:\aaa\test.txt'); => test.txt }
function c_extractfiledrive(const s:string):string;    { c_extractfilename('c:\aaa\test.txt'); => c: }
function c_extractpurefname(s: String): String;        { = GetPureFileName c:\xxx\abc.txt => abc }

function c_lastdelimiter(const s1,s2:string):integer;  { c_lastdelimiter('c:\aaa\xxx.xls','.'); }
function c_stringreplace(const s1,s2,s3:string; f:treplaceflags = [rfReplaceAll, rfIgnoreCase]):string;
function c_copy_v1(s:string; a,b:integer):string;      { =strKCopy, c_copy_v1('c:\aaa\test.txt', 0, 3); => c:\a } { c_stringreplace(str, #10#13, #32);  str의 linefeed를 공백으로 처리  }
function c_splitstring(const s1, s2: string): Tstringlist;

//function c_copy_v2(o:array; a,b:integer):array;
//function c_concat(const s1 [,s2,s3 ...]:string):string;  (* c_concat('aaa','bbb'); 는 'aaa'+'bbb' 와 같다. *)

//setstring
//stuffstring
//wraptext
//dupestring

//function c_ord(a:ordinal):Integer;                                 { Ord('A') => 65(십진수), char(65) => A}

function c_slash(s:string):string;

{ Math }
{ ====================}
function c_min(a,b:integer):integer; assembler;
function c_max(a,b:integer):integer; assembler;


{ Dialog }
{ ====================}
function c_selectdir_v1(const s1,s2:string; out dir:string):boolean;  { s1 = dialog title, s2 = start location, s3 = return dir }
                                                                      { This displays a Windows browser dialog }
                                                                      { if c_selectdir_v1('title', 'c:\', returndir) then ...}
function c_selectdir_v2(var s:string):boolean;                        { s = 현재 디렉을 지정하고, 지정된 s에 다시 return 된다. }
                                                                      { c_selectdir_v2('c:\');  이렇게하면 안되고, s는 변수로 들어가야함.}

{ for cing editor }
{ ====================}
function c_zerotolastchar(const s1,s2:string):string;                 { s1=in source, s2=last char  }
                                                                      { c_zerotolastchar('c:\aaa\2018.01\test.txt','.');  }
                                                                      { => c:\aaa\2018.01\test }
function c_rangestr(const s1,s2,s3:string):string; overload;          { = ExtractRangeStr }
function c_rangestr(const s1:string; a,b:integer):string; overload;
function c_charcount_v1(const s1,s2:string):integer;                  { c_charcount('c:\aaa\aaa\\','\') => 검증필요 }
function c_charcount_v2(const s1,s2:string):integer;
procedure c_bintohex(Buffer,Text:PChar;BufSize: Integer); assembler;  { ECXMLTokenizer, 2진수를 16진수로 }
function c_hexTobin(Text, Buffer: PChar; BufSize: Integer): Integer; assembler;
                                                                      { ECXMLTokenizer, 16진수를 2진수로 }
function c_widetoutf8(const WS: WideString): UTF8String;              { Widestring 를 utf8(8bit) 로, 잘 작동됨}
function c_ansitowide(const S: AnsiString): WideString;
function c_utf8Towide(const US: UTF8String): WideString;
function c_widetoansi(const WS: WideString): AnsiString;
function c_utf8toansi(const S: UTF8String): AnsiString;
function c_ansitoutf8(const S: AnsiString): UTF8String;


{ windows & system api & graphic api }
{ ===================================}
procedure c_movecontrol(h:Thandle);                                   { 판넬등을 폼 이동하듯이 이동하게 할때 OnMouseDown에서 호출 }
                                                                      { c_movecontrol(panel.handle); }
function c_getenv(const s1:string; var s2:string):boolean;            { c:\>set 값들을 가져옴, }
                                                                      { c:\>path 를 가져오기 위해 c_getenv('path', val) }
procedure c_assert(b:boolean; s:string); overload;                    { Assert( val > 9, 'val is error'); }
procedure c_assert(b:boolean); overload;                              { unit 이름과 라인넘버를 보여준다. }
{no test}//function c_enumProcesses: TProcessList;
procedure ScreenShot(Bild: TBitMap); overload;                        // 전체화면 캡쳐, ScreenShot(Image1.Picture.BitMap);
procedure ScreenShotActiveWindow(Bild: TBitMap);                      // 활성창만 캡쳐, sleep(750);ScreenShotActiveWindow(Image1.Picture.BitMap);
procedure ScreenShot(x: Integer;                                      // 전체화면 캡쳐, ScreenShot(0,0,Screen.Width, Screen.Height, Image1.Picture.Bitmap);
                     y: Integer; //(x, y) = Left-top coordinate
                 Width: Integer;
                Height: Integer; //(Width-Height) = Bottom-Right coordinate
                    bm: TBitMap); overload; //Destination
procedure ScreenShot(hWindow: HWND; bm: TBitmap); overload;           // 윈도우 캡쳐, ScreenShot(GetForeGroundWindow, Image1.Picture.Bitmap);
function ProcessMemByte: Cardinal;                                    //  프로세스의 메모리 바이트 수
//SetWindowPos(Form1.handle, HWND_TOPMOST, Form1.Left, Form1.Top, Form1.Width, Form1.Height,0); //alwaysontop


{ VCL Relation }
{ ====================}
{no test}function c_tvroot(tv:Ttreeview): Ttreenode;     { TreeView 의 최상위 노드를 얻는다. }
{no test}function c_tvrootstr(tv:Ttreeview): string;     { TreeView 의 최상위 노드의 텍스트를 얻는다. }
{no test}function c_tvmoveupstr(tv:Ttreeview;stepsep:string;level:integer=0): string;
                                                { TreeView 의 현재 Node에서 단계적으로 상위로 이동하면서
                                                  현재 노드의 디렉토리명 추가하면서 디렉토리를 구성한다.
                                                  level = 상위 몇 레벨까지 구성할 것인가, default는 0(root)
                                                  stepsep = root\aaa\bb\ 상위레벨로 올라갈때 구분자를 추가해 줌.
                                                }
{no test}//function c_tvrootcount(tv:Ttreeview):integer;   { 최상위 Root의 개수 }








function Sort(List: TStringList): TStringList;
function IsNumber(Str: String): boolean;
function CopyLength(str:string; I:integer):string;

function ExtractDirs(dir: string): TStringList;

function ExtractLastChar(Str: String): String;
function ExtractNextOneChar(Str, Delim: String): String;
function ExtractZeroToDelimStr(Src, sDelim: String): String;  { 정확하지 안음, c:\aaa\2018.01\aaa.txt   . 가 두개가 있어서 정확하지 않음 }
function ExtractRangeStr(const Src, S, E: String): String;  overload;
function ExtractRangeStr(const Src:string; a, b: integer): String;  overload;
function ExtractLastRangeStr(const Src, S, E: String): String;
function ExtractTupleRangeText(const Src, S, E: string): string;
function ExtractDirDelim(sFileName: String): TStringList;
function ExtractCharToLast(Src, S: String): String;
function ChangeChar(Src, ChgChar: String; ChangedIndex:integer): String;
function ExtractOneByIndex(Src: String; Index:integer): integer;
function ExtractEmptytoZeroStr(S: String): String;
function ChangeStringsToString(Strings: TStringList): String;
function ExtractLastDir(Filename:string):string;
function ExtractLastDirA(Filename:string):string;
function DeleteLastChar(S:string): string;
function Slash(Str:string):string;
function SlashNot(str:string):string;
function ExtractLastOneDirDelete(Src:string):string;  { 전체 Dir에서 마지막 Dir를 없앤다 }
function ExtractLastChangeDir(Path, Newdir: string): string;

function AdvSelectDirectory(const Caption: string; const Root: WideString; 
 var Directory: string; EditBox: Boolean = False; ShowFiles: Boolean = False; 
 AllowCreateDirs: Boolean = True): Boolean;
 

function SplitString(const AIn, ADelim: string): TStringList; overload;
function SplitString(const AIn, ADelim: string; var AOut: array of string): integer; overload;
function LastStr(sTarget, Ch: String): String;
function ExtractLastStr(sTarget, Ch: String): String;
function ExtractLeftStringOfLastChar(S, ch: String): String;
function ExtratExt(sTarget, Ch: String): String; overload;
function ExtratExt(sFileName:String): String; overload;
function GetDriver(Dir:string):string;
procedure RenameDir(DirFrom, DirTo: string);
function CopyDir(const fromDir, toDir: string): Boolean;
function DelDir(dir: string): Boolean;
function MoveDir(const fromDir, toDir: string): Boolean;

function CheckDot(str: String) : boolean;
function StrKCopy(str: String; a1: Integer; a2: Integer): String;
function GetPathStr(Str, sDelimiter: String): String;
function ReplaceStr(const S, Srch, Replace: string): string;

function CheckStringEmpty(Str, Msg: String):boolean;
function CheckEqualText(Str1, Str2, Msg: String): boolean;
function CheckBooleanMsg(Bool: boolean; Msg: String): boolean;


procedure CopyStreamFile (SourceName, TargetName: String);


function ChangeExtension( pathfname: String; changeExt: String): String;
function GetDirNames( path: String): TStringList;
function GetFullDirNames( Path: String ): TStringList;
function c_pathanddir(path: String; out count:integer): Tarraystr;                    { }
function GetFullFileNames(Path: String; Wild: String): TStringList;
{-------------------------------------------------------------------}
{ Search in Only Each Dir. }
{ Files := KefreeUtil.GetAllFiles('C:\Erlang\Source\src', '*.erl'); }
{ 하위디렉토리는 배제 }
{-------------------------------------------------------------------}
function GetAllFiles(Path: String; Wild: String): TStringList;
function GetAllPureFiles(Dir: String; Wild: String): TStringList;
procedure GetAllDirs(Path: STRING; out OutStrings: TStringList);

function GetFileRead(path,Wild: String): TStrings;
procedure GetFiles(Path:string; const FileSpec: string; Files: TStrings);  { 하위 디렉토리 포함해서 검색 }

function c_GetFileSize(FileName: String): Cardinal;
function aHasAttrib(fileAttrib, testAttrib: Integer): Boolean;
function aFileInfo(filename: String): TSearchRec;
function aGetDirNames(path: String): TStringList;
function aGetFileNames(path: String; attrib: Integer): TStringList;

function SaveAndOpenFile(path: String; open: boolean): TFileStream;
//function StreamToMemory(AStream: TStream): TMemoryStream;
//function StringToMemory(Str:string): TMemoryStream;

function GetExtension(s: String): String;
function GetPureFileName(sFullPathFile: String): String;           { c:\xxx\abc.txt => abc }
function GetShortFileName(sFullPathFile: String): String;          { c:\xxx\abc.txt => abc.txt }

{unit JclFileUtils;}
{
function jGetFileInformation(const FileName: string): TSearchRec;
function jGetFileLastWrite(const FileName: string): TFileTime;
function jGetFileLastAccess(const FileName: string): TFileTime;
function jGetFileCreation(const FileName: string): TFileTime;
}

{unit rxFileUtil;}
function RxFileDateTime(const FileName: string): TDateTime;
function RxGetFileSize(const FileName: string): Longint;

function GetFileLastWrite(const FileName: string): TFileTime;
function SameFileTime(t1, t2: TFileTime): boolean;

function ExpandFileName(const FileName: string): string;            { c:\xxx\abc.txt => c:\xxx\abc.txt 결과가 같음.}
function ExtractFileName(const FileName: string): string;           { c:\xxx\abc.txt => abc.txt }
function ChangeFileExt(const FileName, Extension: string): string;
function ExtractFilePath(const FileName: string): string;
function ExtractFileDrive(const FileName: string): string;
function ExtractFileDir(const FileName: string): string;            { c:\aaa\bb.ext => c:\aaa }
function ExtractFileDirS(const FileName: string): string;           { c:\aaa\bb.ext => c:\aaa\  }


procedure FindFilesDelphiLand(FilesList: TStringList; StartDir, FileMask: string);
procedure FileSearch2(const PathName, FileName : string; const InDir : boolean);  { 하위디렉토리를 포함하기 위해 InDir에 True를 준다.}
procedure GetSearchedFileList(sPath : String;
                              slFileList : TStringList;
                              sWildStr : string;
                              bSchSubFolder : Bool);

function ExtractZeroToLastDelimStr(Src, sLastDelim: String): String;
function GetRootDir(): String;

function PutSpace(str:string; loop:Integer; flag: boolean=false): string;
function BackSpace(str:string; loop:Integer; flag: boolean=false): string;


{ Window API Relations }
procedure KillProcess(hWindowHandle: HWND);
function KillTask(ExeFileName: string): Integer;
function GetWinHandle(hInstance: HWND; WinTitle: string): HWND;


{ Hex, Digit, Bin Relation Rotines }
function DigitToBin(Value: Char): Integer;  { Creates a selection structure from given Index and Digit parameters }

{ Unicode String Rotine }
function AsciiToInt(S: string; Digits: Integer): Int64;
function BCDToInt(Value: Cardinal): Cardinal;
function IntToAscii(Value: Int64; Digits: Integer): string;
function IntToBCD(Value: Cardinal): Cardinal;

{ Operator Rotine }
function OperatorStrings(strings1, strings2:Tstringlist): Tstringlist;


{ Cing Edit Util }
function Max(x, y: integer): integer;
function Min(x, y: integer): integer;
function MinMaxi(x, mi, ma: integer): integer;
procedure SwapInt(var l, r: integer);


Function StrToFieldType(FieldType : String): TFieldType;
Function FieldTypeToStr(FieldType : TFieldType): String;

{}
procedure ParseURL(URL: String; var HostName, FileName: String);

implementation

const
    NullDate: TDateTime = {-693594} 0;  {In rxLib}
    
    
    
    
{
function c_enumProcesses: TProcessList;
var
  Current: PSystemProcesses;
  SystemProcesses : PSystemProcesses;
  dwSize: DWORD;
  nts: NTSTATUS;
begin
  Result := TProcessList.Create;

  dwSize := 200000;
  SystemProcesses := AllocMem(dwSize);

  nts := NtQuerySystemInformation(SystemProcessesAndThreadsInformation,
      SystemProcesses, dwSize, @dwSize);

  while nts = STATUS_INFO_LENGTH_MISMATCH do
  begin
    ReAllocMem(SystemProcesses, dwSize);
    nts := NtQuerySystemInformation(SystemProcessesAndThreadsInformation,
      SystemProcesses, dwSize, @dwSize);
  end;

  if nts = STATUS_SUCCESS then
  begin
    Current := SystemProcesses;
    while True do
    begin
      Result.Add(TProcess.Create(Current^));
      if Current^.NextEntryDelta = 0 then
        Break;

      Current := PSYSTEM_PROCESSES(DWORD_PTR(Current) + Current^.NextEntryDelta);
    end;
  end;

  FreeMem(SystemProcesses);
end;
    
function c_tvrootcount(tv:Ttreeview):integer;
var
  i:integer;
begin
  result:=0;
  for i:=0 to tv.Items.Count-1 do
  begin
    if(tv.Items.Item[i].Level=0)then
      Inc(Result);
  end;
end;
}

  procedure ParseURL(URL: String; var HostName, FileName: String);

    procedure ReplaceChar(c1, c2: Char; var St: String);
    var
      p: Integer;
    begin
      while True do
       begin
        p := Pos(c1, St);
        if p = 0 then Break
        else St[p] := c2;
       end;
    end;

  var
    i: Integer;
  begin
    if Pos('https://', LowerCase(URL)) <> 0 then System.Delete(URL, 1, 8);
    if Pos('http://', LowerCase(URL)) <> 0 then System.Delete(URL, 1, 7);

    i := Pos('/', URL);
    HostName := Copy(URL, 1, i);
    FileName := Copy(URL, i, Length(URL) - i + 1);

    if (Length(HostName) > 0) and (HostName[Length(HostName)] = '/') then
      SetLength(HostName, Length(HostName) - 1);
  end;
  

function c_DirectoryExists(s: string): boolean;
begin
  result := DirectoryExists(s);
end;

function c_appdir: String;
begin
  Result := ExtractFilePath(Application.ExeName);
end;


function c_ansitoutf8(const S: AnsiString): UTF8String;
begin
  Result:=c_WideToUTF8(c_AnsiToWide(S));
end;

function c_utf8toansi(const S: UTF8String): AnsiString;
begin
  Result:=c_WideToAnsi(c_UTF8ToWide(S));
end;

function c_widetoansi(const WS: WideString): AnsiString;
var
  len: integer;
  s: AnsiString;
begin
  Result:='';
  if (Length(WS) = 0) then
    exit;
  len:=WideCharToMultiByte(CP_ACP, 0, PWideChar(WS), -1, nil, 0, nil, nil);
  SetLength(s, len);
  WideCharToMultiByte(CP_ACP, 0, PWideChar(WS), -1, PChar(s), len, nil, nil);
  Result:=s;
end;

function c_utf8towide(const US: UTF8String): WideString;
var
  len: integer;
  ws: WideString;
begin
  Result:='';
  if (Length(US) = 0) then
    exit;
  len:=MultiByteToWideChar(CP_UTF8, 0, PChar(US), -1, nil, 0);
  SetLength(ws, len);
  MultiByteToWideChar(CP_UTF8, 0, PChar(US), -1, PWideChar(ws), len);
  Result:=ws;
end;


function c_ansitowide(const S: AnsiString): WideString;
var
  len: integer;
  ws: WideString;
begin
  Result:='';
  if (Length(S) = 0) then
    exit;
  len:=MultiByteToWideChar(CP_ACP, 0, PChar(s), -1, nil, 0);
  SetLength(ws, len);
  MultiByteToWideChar(CP_ACP, 0, PChar(s), -1, PWideChar(ws), len);
  Result:=ws;
end;


function c_widetoutf8(const WS: WideString): UTF8String;
var
  len: integer;
  us: UTF8String;
begin
  Result:='';
  if (Length(WS) = 0) then
    exit;
  len:=WideCharToMultiByte(CP_UTF8, 0, PWideChar(WS), -1, nil, 0, nil, nil);
  SetLength(us, len);
  WideCharToMultiByte(CP_UTF8, 0, PWideChar(WS), -1, PChar(us), len, nil, nil);
  Result:=us;
end;


function ProcessMemByte: Cardinal;
var
  pmc: PPROCESS_MEMORY_COUNTERS;
  cb: Integer;
begin
  cb := SizeOf(_PROCESS_MEMORY_COUNTERS);
  GetMem(pmc, cb);
  pmc^.cb := cb;
  if GetProcessMemoryInfo(GetCurrentProcess(), pmc, cb) then
    result := pmc^.WorkingSetSize
  else ShowMessage('Unable to get process info');
  FreeMem(pmc);
end;



procedure ScreenShot(hWindow: HWND; bm: TBitmap);
var
  Left, Top, Width, Height: Word;
  R: TRect;
  dc: HDC;
  lpPal: PLOGPALETTE;
begin
  {Check if valid window handle}
  if not IsWindow(hWindow) then Exit;
  {Retrieves the rectangular coordinates of the specified window}
  GetWindowRect(hWindow, R);
  Left := R.Left;
  Top := R.Top;
  Width := R.Right - R.Left;
  Height := R.Bottom - R.Top;
  bm.Width  := Width;
  bm.Height := Height;
  {get the screen dc}
  dc := GetDc(0);
  if (dc = 0) then
  begin
    Exit;
  end;
  {do we have a palette device?}
  if (GetDeviceCaps(dc, RASTERCAPS) and
    RC_PALETTE = RC_PALETTE) then
  begin
    {allocate memory for a logical palette}
    GetMem(lpPal,
      SizeOf(TLOGPALETTE) +
    (255 * SizeOf(TPALETTEENTRY)));
    {zero it out to be neat}
    FillChar(lpPal^,
      SizeOf(TLOGPALETTE) +
    (255 * SizeOf(TPALETTEENTRY)),
      #0);
    {fill in the palette version}
    lpPal^.palVersion := $300;
    {grab the system palette entries}
    lpPal^.palNumEntries :=
      GetSystemPaletteEntries(dc,
      0,
      256,
      lpPal^.palPalEntry);
    if (lpPal^.PalNumEntries <> 0) then
    begin
      {create the palette}
      bm.Palette := CreatePalette(lpPal^);
    end;
    FreeMem(lpPal, SizeOf(TLOGPALETTE) +
    (255 * SizeOf(TPALETTEENTRY)));
  end;
  {copy from the screen to the bitmap}
  BitBlt(bm.Canvas.Handle,
    0,
    0,
    Width,
    Height,
    Dc,
    Left,
    Top,
    SRCCOPY);
  {release the screen dc}
  ReleaseDc(0, dc);
end;




procedure ScreenShot(x: Integer;
  y: Integer; //(x, y) = Left-top coordinate
  Width: Integer;
  Height: Integer; //(Width-Height) = Bottom-Right coordinate
  bm: TBitMap); //Destination
var
  dc: HDC;
  lpPal: PLOGPALETTE;
begin
  {test width and height}
  if ((Width = 0) or
    (Height = 0)) then
    Exit;
  bm.Width  := Width;
  bm.Height := Height;
  {get the screen dc}
  dc := GetDc(0);
  if (dc = 0) then
    Exit;
  {do we have a palette device?}
  if (GetDeviceCaps(dc, RASTERCAPS) and
    RC_PALETTE = RC_PALETTE) then
  begin
    {allocate memory for a logical palette}
    GetMem(lpPal,
      SizeOf(TLOGPALETTE) +
    (255 * SizeOf(TPALETTEENTRY)));
    {zero it out to be neat}
    FillChar(lpPal^,
      SizeOf(TLOGPALETTE) +
    (255 * SizeOf(TPALETTEENTRY)),
      #0);
    {fill in the palette version}
    lpPal^.palVersion := $300;
    {grab the system palette entries}
    lpPal^.palNumEntries :=
      GetSystemPaletteEntries(dc,
      0,
      256,
      lpPal^.palPalEntry);
    if (lpPal^.PalNumEntries <> 0) then
      {create the palette}
      bm.Palette := CreatePalette(lpPal^);
    FreeMem(lpPal, SizeOf(TLOGPALETTE) +
    (255 * SizeOf(TPALETTEENTRY)));
  end;
  {copy from the screen to the bitmap}
  BitBlt(bm.Canvas.Handle,
    0,
    0,
    Width,
    Height,
    Dc,
    x,
    y,
    SRCCOPY);
  {release the screen dc}
  ReleaseDc(0, dc);
end;

procedure ScreenShotActiveWindow(Bild: TBitMap);
var
  c: TCanvas;
  r, t: TRect;
  h: THandle;
begin
  c := TCanvas.Create;
  c.Handle := GetWindowDC(GetDesktopWindow);
  h := GetForeGroundWindow;
  if h <> 0 then
    GetWindowRect(h, t);
  try
    r := Rect(0, 0, t.Right - t.Left, t.Bottom - t.Top);
    Bild.Width  := t.Right - t.Left;
    Bild.Height := t.Bottom - t.Top;
    Bild.Canvas.CopyRect(r, c, t);
  finally
    ReleaseDC(0, c.Handle);
    c.Free;
  end;
end;

procedure ScreenShot(Bild: TBitMap);
var
  c: TCanvas;
  r: TRect;
begin
  c := TCanvas.Create;
  c.Handle := GetWindowDC(GetDesktopWindow);
  try
    r := Rect(0, 0, Screen.Width, Screen.Height);
    Bild.Width := Screen.Width;
    Bild.Height := Screen.Height;
    Bild.Canvas.CopyRect(r, c, r);
  finally
    ReleaseDC(0, c.Handle);
    c.Free;
  end;
end;

function c_extractpurefname(s: String): String;
var
  i, j: integer;
begin
  i := LastDelimiter( '\', s );
  j := LastDelimiter( '.', s );

  result := copy(s, i + 1, j-i-1);
end;


function c_splitstring(const s1, s2: string): Tstringlist;
var
  CurLine, te: string;
  p2: integer;
begin
  Result := TStringList.Create;
  if s1 <> '' then begin
    CurLine := s1;
    repeat
      p2 := Pos(s2, CurLine);
      if p2 = 0 then
        p2 := Length(CurLine) + 1;
      te := System.Copy(CurLine, 1, p2 - 1);
      System.Delete(CurLine, 1, p2);
      Result.Add(trim(te));
    until CurLine = '';
  end;
end;

function c_tvroot(tv: Ttreeview): Ttreenode;
var
  node: TTreeNode;
begin
  c_assert(tv <> nil);
  node := tv.Selected;
  if node.level = 0 then
  begin
    result := node;
    exit;
  end;

  while node.parent <> nil do
    if node.parent = nil then
    begin
      result := node;
      break;
    end;
    node := node.parent;
end;

function c_tvrootstr(tv: Ttreeview): string;
begin
  result := c_tvroot(tv).Text;
end;

function c_tvmoveupstr(tv: Ttreeview; stepsep:string; level:integer): string;
var
  node: TTreeNode;
begin
  node := tv.Selected;
  result := '';
  if node.level = 0 then
  begin
    result := node.text + stepsep;
    exit;
  end;
  
  while node.parent <> nil do
    node := node.parent;
    if node.level <> level then
      result := result + node.text + stepsep;
end;

    
function c_hexTobin(Text, Buffer: PChar; BufSize: Integer): Integer; assembler;
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        MOV     ESI,EAX
        MOV     EDI,EDX
        MOV     EBX,EDX
        MOV     EDX,0
        JMP     @@1
@@0:    DB       0, 1, 2, 3, 4, 5, 6, 7, 8, 9,-1,-1,-1,-1,-1,-1
        DB      -1,10,11,12,13,14,15,-1,-1,-1,-1,-1,-1,-1,-1,-1
        DB      -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
        DB      -1,10,11,12,13,14,15
@@1:    LODSW
        CMP     AL,'0'
        JB      @@2
        CMP     AL,'f'
        JA      @@2
        MOV     DL,AL
        MOV     AL,@@0.Byte[EDX-'0']
        CMP     AL,-1
        JE      @@2
        SHL     AL,4
        CMP     AH,'0'
        JB      @@2
        CMP     AH,'f'
        JA      @@2
        MOV     DL,AH
        MOV     AH,@@0.Byte[EDX-'0']
        CMP     AH,-1
        JE      @@2
        OR      AL,AH
        STOSB
        DEC     ECX
        JNE     @@1
@@2:    MOV     EAX,EDI
        SUB     EAX,EBX
        POP     EBX
        POP     EDI
        POP     ESI
end;
    
procedure c_bintohex(Buffer,Text:PChar;BufSize: Integer); assembler;
asm
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,EAX
        MOV     EDI,EDX
        MOV     EDX,0
        JMP     @@1
@@0:    DB      '0123456789ABCDEF'
@@1:    LODSB
        MOV     DL,AL
        AND     DL,0FH
        MOV     AH,@@0.Byte[EDX]
        MOV     DL,AL
        SHR     DL,4
        MOV     AL,@@0.Byte[EDX]
        STOSW
        DEC     ECX
        JNE     @@1
        POP     EDI
        POP     ESI
end;


function c_slash(s:string):string;
begin
  Result := IncludeTrailingBackslash(s);
end;

    
function c_filecopy_v2(f1, f2: string): boolean;
var
  tf1, tf2: TextFile;
  Ch: Char;
begin
  AssignFile(tf1, f1);
  Reset(tf1);

  AssignFile(tf2, f2);
  Rewrite(tf2);
  while not Eof(tf1) do
  begin
    Read(tf1, Ch);
    Write(tf2, Ch);
  end;
  CloseFile(tf2);
  CloseFile(tf1);
end;
    
function c_filecopy_v1(f1, f2: string): boolean;
// Copies source to target; overwrites target.
// Caches entire file content in memory.
// Returns true if succeeded; false if failed.
var
  MemBuffer: TMemoryStream;
begin
  result := false;
  MemBuffer := TMemoryStream.Create;
  try
    MemBuffer.LoadFromFile(f1);
    MemBuffer.SaveToFile(f2);
    result := true
  except
    //swallow exception; function result is false by default
  end;
  // Clean up
  MemBuffer.Free
end;


function c_stringtomemory(s:string): Tmemorystream;
begin
  Result:= TMemoryStream.Create;
  Result.Write(Pointer(s)^, Length(s));
  Result.Position := 0;
end;

procedure c_savefile_v3(const f:string; s:Tstream);
var
  fs: TFileStream;
begin
  fs := TFileStream.Create(f, fmOpenWrite + fmShareDenyWrite);
  try
    fs.CopyFrom(s, 0);
  finally
    FreeAndNil(fs);
  end;
end;

function c_savefile_api(const Content: ansistring; const FileName: TFileName;FlushOnDisk: boolean=false): boolean;
var H: THandle;
    L: integer;
begin
  result := false;
  H := FileCreate(FileName);
  if H <0 then
    exit;
  if pointer(Content)<>nil then
    L := FileWrite(H,pointer(Content)^,length(Content)) else
    L := 0;
  result := (L=length(Content));
{$ifdef MSWINDOWS}
  if FlushOnDisk then
    FlushFileBuffers(H);
{$endif}
  FileClose(H);
end;


function c_streamtomemory(s:Tstream):Tmemorystream;
begin
  Result := TMemoryStream.Create;
  Result.LoadFromStream(s);
  FreeAndNil(s);
  Result.SetSize(Result.Size + 1);
  PChar(Result.Memory)[Result.Size - 1] := #0;
end;

function c_loadfile_v4(const f:string):Pchar;
var
  s: Tstream;
  sm: Tmemorystream;
begin
  s := c_loadfile_v3(f);
  sm := c_streamtomemory(s);
  result := sm.Memory;
end;

function c_loadfile_api(const f:string):ansistring;
type
  PtrInt = ^integer;
var H: THandle;
    sz: Cardinal;
begin
  result := '';
  if f='' then
    exit;
  H := FileOpen(f,fmOpenRead or fmShareDenyNone);
  if H >=0 then begin
{$ifdef LINUX}
    sz := FileSeek(H,0,soFromEnd);
    FileSeek(H,0,soFromBeginning);
{$else}
    sz := windows.GetFileSize(H,nil);
{$endif}
    SetLength(result,sz);
    if FileRead(H,pointer(Result)^,sz)<>sz then
      result := '';
    FileClose(H);
  end;
end;
    
function c_loadfile_v3(const f:string):Tfilestream;
begin
  if f <> '' then
    Result := TFileStream.Create(f, fmOpenRead)
  else
    Result := nil;
end;
    
function c_loadfile_v2(const f:string):Tstringlist;
begin
  result := Tstringlist.create;
  result.loadfromfile(f);
end;
    
    
procedure c_assert(b:boolean; s:string);
begin
  assert(b,s);
end;

procedure c_assert(b:boolean);
begin
  assert(b);
end;
    
procedure c_movecontrol(h:Thandle);
begin
  ReleaseCapture;
  SendMessage( h, WM_SYSCOMMAND, $F012, 0 );
end;

function c_extractext(const s:string):string;
begin
  Result:=Copy(s,LastDelimiter('.', s)+1, Length(s));
  if Result = '' then raise exception.create('Extension Error');
end;

function c_min(a,b:integer):integer; assembler;
asm
  mov  ecx,edx
  //
  sub  eax,edx
  cdq  // fills EDX
  and  eax,edx
  add  eax,ecx
end;

function c_max(a,b:integer):integer; assembler;
asm
  mov  ecx,edx
  //
  sub  eax,edx
  cdq  // fills EDX
  not  edx
  and  eax,edx
  add  eax,ecx
end;

    
function c_getenv(const s1:string; var s2:string):boolean;
var
  Buffer: array[0..1023] of char;
  Len: integer;
begin
  Len:=GetEnvironmentVariable(PChar(s1),Buffer,SizeOf(Buffer)-4);
  if (Len>0) then begin
    if (Len<SizeOf(Buffer)-4) then begin
      SetString(s2,Buffer,Len);
      Result:=True;
    end else begin
      SetString(s2,PChar(nil),Len+8);
      Len:=GetEnvironmentVariable(PChar(s1),Pointer(s2),Len+1);
      SetLength(s2,Len);
      Result:=True;
    end;
  end else
    Result:=False;
end;
    
procedure c_savefile_v1(const f:string; s:string);
var
    bnHidden: Boolean;
    fs: Tfilestream;
    attr: integer;
begin
  bnHidden:=False;
  if (SysUtils.Win32Platform=VER_PLATFORM_WIN32_NT) then begin
    attr:=FileGetAttr(f);
    if (attr+1<>0){attr<>-1} and ((attr and faHidden)<>0) then begin
      // WinNT denies writes to hidden files?! Why?
      bnHidden:=True;
      FileSetAttr(f,attr and not faHidden);
    end;
  end;
  fs:=nil;
  try
    fs:=TFileStream.Create(f,fmCreate);
    if (length(s)>0) then
      fs.WriteBuffer(Pointer(s)^,Length(s));
  finally
    fs.Free;
    // Restore hidden attr on NT:
    if bnHidden then
      FileSetAttr(f,FileGetAttr(f) or faHidden);
  end;
end;


function c_loadfile_v1(const f:string):string;
var
  fs: Tfilestream;
  sz: integer;
begin
  result := '';
  if c_fileexists(f) then
    fs:= Tfilestream.create(f,fmOpenRead or fmShareDenyNone);
    try
      sz := fs.size;
      setstring(result,PChar(nil),sz);
      if (sz>0) then
        fs.Readbuffer(Pointer(result)^,sz);
    finally
      fs.free;
    end;
end;

function c_momcopy(p:pointer;a:integer):pointer;
begin
  result:=allocmem(a);
  //c_fastcopy(Result,src,size);
  c_move(p^,result^,a);
end;

procedure c_fastcopy(p1,p2:pchar;a:integer);
  procedure asm_fastcopy(p2,p1:pchar;a:integer); { p2=EAX, p1=EDX, a=ECX }
  asm 
    push edi
    mov  edi,eax
    xchg edx,esi // save ESI to EDX, load src->ESI...
    test ecx,ecx
    jbe  @done // old version of this function was also safe agains len<0 !
    mov  eax,ecx
    shr  ecx,2
    rep  movsd
    mov  ecx,eax
    and  ecx,3
    rep  movsb
  @done:
    mov  esi,edx // restore ESI...
    pop  edi
  end;
begin
  asm_fastcopy(p1,p2,a);
end;

function c_strtopchar(s:string):pchar;
begin
  result := Pchar(s + #0);
end;

function c_strtomommy_v1(s:string):pchar;
var
  p:pchar;
begin
  p := c_strtopchar(s);
  FillChar(result, sizeof(p),0);     // 메모리 공간 확보
  move(p, result, sizeof(p)); // 데이터를 이동
end;

function c_strtomommy_v2(s:string):pchar;
var
  p:pchar;
begin
  p := c_strtopchar(s);
  GetMem(result, sizeof(p));
  move(p, result, sizeof(p));
end;

function c_pointertopchar(p:pointer):pchar;
begin
  result := pchar(p);
end;

function c_comparestr(s1,s2:string):boolean;
begin
  result := false;
  if sysutils.comparestr(s1, s2) = 0 then
    result := true;
end;

function c_comparetext(s1,s2:string):boolean;
begin
  result := false;
  if sysutils.comparetext(s1, s2) = 0 then
    result := true;
end;

function c_ansicomparestr(s1,s2:string):boolean;
begin
  result := false;
  if sysutils.ansicomparestr(s1, s2) = 0 then
    result := true;
end;

function c_changefileext(const s1,s2:string):string;
begin
  result := sysutils.changefileext(s1,s2);
end;

function c_extractfileext(const s:string):string;
begin
  result := sysutils.extractfileext(s);
end;

function c_extractfiledir(const s:string):string;
begin
  result := sysutils.extractfiledir(s);
end;

function c_extractfilename(const s:string):string;
begin
  result := sysutils.extractfilename(s);
end;

function c_extractfilepath(const s:string):string;
begin
  result := sysutils.extractfilepath(s);
end;

function c_extractfiledrive(const s:string):string;
begin
  result := sysutils.extractfiledrive(s);
end;

function c_createdir(const s:string):boolean;
begin
  result := sysutils.createdir(s);
end;


function c_getcurrentdir:string;
begin
  result := sysutils.getcurrentdir;
end;

procedure c_chdir(const s:string);
begin
  system.chdir(s);
end;

function c_setcurrentdir(const s:string):boolean;
begin
  result := sysutils.setcurrentdir(s);
end;

function c_selectdir_v1(const s1,s2:string; out dir:string):boolean;
begin
  result := filectrl.selectdirectory(s1,s2,dir);
end;

function c_selectdir_v2(var s:string):boolean;
var
  options : TSelectDirOpts;
begin
  result := filectrl.selectdirectory(s,options,0);  // 0 = help 버튼을 숨김.
end;

procedure c_mkdir(const s:string);
begin
  system.mkdir(s);
end;

procedure c_mkdir_eg;
var
  error : Integer;
begin
  // Try to create a new subdirectory in the current directory
  // Switch off I/O error checking
  {$IOChecks off}
  c_mkdir('TempDirectory');

  // Did the directory get created OK?
  error := IOResult;
  if error = 0
  then ShowMessage('Directory created OK')
  else ShowMessageFmt('Directory creation failed with error %d',[error]);

  // Delete the directory to tidy up
  c_rmdir('TempDirectory');
  {$IOChecks on}
end;

procedure c_rmdir(const s:string);
begin
  system.rmdir(s);
end;

function c_removedir(const s:string):boolean;
begin
  result := sysutils.removedir(s);
end;

function c_forceDirectories(const s:string):boolean;
begin
  result := sysutils.forceDirectories(s);
end;

function c_zerotolastchar(const s1,s2:string):string;
var
  a:integer;
begin
  a := c_lastdelimiter(s1, s2);
  result := c_copy_v1(s1, 0, a-1);
end;

function c_lastdelimiter(const s1,s2:string):integer;
begin
  result := sysutils.lastdelimiter(s2, s1);
end;

function c_copy_v1(s:string; a,b:integer):string;
begin
  result := system.copy(s,a,b);
end;

function c_stringreplace(const s1,s2,s3:string; f:treplaceflags):string;
begin
  result := sysutils.stringreplace(s1,s2,s3, f);
end;


procedure c_delete(var s1:string; a,b:integer);
begin
  system.delete(s1, a,b);
end;

procedure c_insert(var s1:string; const s2:string; a:integer);
begin
  system.insert(s2,s1,a);
end;

procedure c_move(var p1; const p2; a:integer);
begin
  move(p2,p1,a);
end;

procedure c_fillchar(var p; a:integer; b:byte=0);
begin
  system.fillchar(p,a,b);
end;

procedure c_getmem(var p:pointer; a:integer);
begin
  system.getmem(p,a);
end;

procedure c_new(var p:pointer);
begin
  system.new(p);
end;

procedure c_reallocmem(var p:pointer; a:integer);
begin
  system.reallocmem(p,a);
end;

procedure c_dispose(var p:pointer);
begin
  system.dispose(p);
end;

procedure c_freemem(var p:pointer);
begin
  system.freemem(p);
end;

procedure c_setlength(s:string; a:integer);
begin
  system.setlength(s,a);
end;

function c_length(s:string):integer;
begin
  result := system.length(s);
end;

function c_stringofchar(c:char; a:integer):string;
begin
  result := system.stringofchar(c,a);
end;

function c_fileexists(const f:string):boolean;
begin
  result := sysutils.fileexists(f);
end;

function c_filecreate(const f:string):integer;
begin
  result := sysutils.filecreate(f);
  if result = -1 then
    raise Exception.create('kefreeutil: File already exists');
end;

procedure c_assignfile(var h:TextFile; const f:string);
begin
  system.assignfile(h,f);
end;

procedure c_closefile(var h:textfile);
begin
  system.closefile(h);
end;

function c_deletefile(const f:string):boolean;
begin
  result := sysutils.deletefile(f);
end;

function c_renamefile(const f1,f2:string):boolean;
begin
  result := sysutils.renamefile(f1,f2);
end;

procedure c_reset(var h:textfile);
begin
  system.reset(h);
end;

function c_rangestr(const s1,s2,s3:string):string;
var
  a,b: integer;
  s: String;
begin
  if (c_charcount_v1(s1,s2) <> 1) and (c_charcount_v1(s1,s3) <> 1) then
    Exception.create('Incorrect range specification.');
  s := trim(s1);
  a := Pos(s2, s)+1;
  if s2 = s3 then
    b:= c_lastdelimiter(s1, s3)-a
  else
    b := Pos(s3, s)-a;
  Result := Copy(s, a, b);
end;

function c_charcount_v1(const s1,s2:string):integer;
var
  i:integer;
begin
  result := 0;
  for i:=1 to length(s1) do
    if s1[i] = s2 then
      result := result + 1;
end;

function c_charcount_v2(const s1,s2:string):integer;
var
  c1,c2:Pchar;
begin
  result := 0;
  c1:=c_strtopchar(s1);
  c2:=c_strtopchar(s2);
  
  while c1^ <> #0 do
  begin
    if c1^ = c2^ then
      result := result +1;
    inc(c1);
  end;
end;

function c_rangestr(const s1:string; a,b:integer):string;
begin
  Result := Copy(trim(s1), a, (b-a));
end;
































function Max(x, y: integer): integer;
begin
  if x > y then Result := x else Result := y;
end;

function Min(x, y: integer): integer;
begin
  if x < y then Result := x else Result := y;
end;

function MinMaxi(x, mi, ma: integer): integer;
begin
  if (x < mi) then Result := mi
    else if (x > ma) then Result := ma else Result := x;
end;

procedure SwapInt(var l, r: integer);
var tmp: integer;
begin
  tmp := r;
  r := l;
  l := tmp;
end;

function ExtractDirs(dir: string): TStringList;
var
  Pch: Pchar;
  S: string;
begin
  s:= '';
  Result := TStringList.create;

  Pch := PChar(dir + #0);

  while Pch^ <> #0 do
  begin
    case Pch^ of
      //'0'..'9': inc(Pch);
      '\': begin
              //writeln(Pch^);
              Result.Add(s);  //D:\Neural\_tdbfdemo136 (1)\demo\data\DBASE3+.dbf
              s:= '';
              inc(Pch);
           end;

      #0: begin  // 마지막에 타지 않음 ???
            Result.Add(s);
            exit;
          end;
     ':': begin
            s:= '';
            inc(Pch)
          end;
      else begin
        s := s+ Pch^;//string(Pch);
        inc(Pch);
      end;
    end;
  end; // while
  Result.Add(s);
end;


function ExtractLastOneDirDelete(Src:string):string;
var
  I:integer;
begin
   I := LastDelimiter('\', Src);
   Result := Copy(Src, 0, I-1);
end;

function ExtractLastChangeDir(Path, Newdir: string): string;
var
  str: string;
begin
  str := SlashNot(Path);
  str := ExtractLastOneDirDelete(str);

  Result := Slash(str) + Newdir;
end;

// aa{c:\sss.aa.erl}  => aa   {c:\sss.aa.erl}  :공백을 포함한 포맷으로 변경한다.
function PutSpace(str:string; loop:Integer; flag: boolean): string;
var
  i:integer;
  tail: string;
begin
  if flag then
  begin
    i:=pos('{', str);
    Result := copy(str, 0, i-1);
    tail := copy(str, i, length(str)-i+1);
    for loop:=1 to loop do
      Result := Result + ' ';
    Result := Result + tail;
    
  end else
    Result := str;
end;

// PutSpace를 복원시킨다.
function BackSpace(str:string; loop:Integer; flag: boolean=false): string;
var
  i:integer;
  front,tail: string;
begin
  if flag then
  begin
    i:=pos('{', str);
    front := copy(str, 0, i-1);
    tail := copy(str, i, length(str)-i+1);

    Result := Trim(front) + tail;
  end else
    Result := str;
end;

function Sort(List: TStringList): TStringList;
var
  I: Integer;
begin
  Result := TStringList.Create;
  
  Result.Sorted := True;
  Result.Duplicates := dupIgnore;
  for I:=0 to List.Count-1 do
    Result.Add(List[I]);
end;

function ChangeStringsToString(Strings: TStringList): String;
var
  I:Integer;
  Tmp: String;
begin
  Result := '';
  for I:=0 to Strings.Count-1 do
  begin
    Tmp :=  Strings[I];
    Result := Result + Tmp;
  end;
end;

function ExtractEmptytoZeroStr(S: String): String;
begin
  if S = '' then Result := '0'
  else Result := S;
end;

function IsNumber(Str: String): boolean;
var
  Pch: Pchar;
begin
  Result := True;
  Pch := PChar(Str + #0);
  while Pch^ <> #0 do
  begin
    case Pch^ of
      '0'..'9': inc(Pch);
      #0: exit
      else begin
        inc(Pch);
        Result := false;
      end;
    end;
  end;
end;

function CopyLength(str:string; I:integer):string;
begin
  Result := Copy(str, I, Length(str));
end;

function DeleteLastChar(S:string): string;
begin
  Result := Copy(S, 0, Length(S)-1);
end;

{ 마지막에 슬래쉬가 없으면 추가한다. }
function Slash(Str:string):string;
begin
  Result := IncludeTrailingBackslash(Str);
end;

function SlashNot(str:string):string;
begin
  Result := ExcludeTrailingBackslash(Str);
end;

function ExtractLastDir(Filename:string):string;
var
  Dir: String;
begin
  if Pos('\', Filename) <= 0 then Exit;
  if Pos('.', Filename) > 0 then
  begin
     Dir := ExtractLastStr(Filename, '\');
     if ExtractLastChar(Dir) <> '\' then Result := ExtractCharToLast(Dir, '\')
     else Result := ExtractCharToLast(DeleteLastChar('\'), '\');
  end else
  begin
     //ShowMessage(ExtractLastChar(Dir));
     
     if ExtractLastChar(Dir) <> '\' then Result := ExtractCharToLast(Dir, '\')
     else Result := ExtractCharToLast(DeleteLastChar('\'), '\');
  end;
end;

function ExtractLastDirA(Filename:string):string;
var
  Strings : TStringList;
  I:Integer;
begin
  Strings := SplitString(SlashNot(Filename), '\');
  //if Pos('.', Filename) > 0 then
  //  Result := Strings[Strings.Count-2]
  //else
    Result := Strings[Strings.Count-1];
end;

function GetRootDir(): String;
begin
  Result := ExtractFilePath(Application.ExeName);
end;


procedure GetSearchedFileList(sPath : String;
                              slFileList : TStringList;
                              sWildStr : string;
                              bSchSubFolder : Bool);
var
  sTempPath : String;
  SchRec : TSearchRec;
  iSchRec : integer;
begin
  if sPath[length(sPath)] <> '\' then sPath := sPath + '\';

  // 와일드 카드 설정
  if (sWildStr = '') or (bSchSubFolder = true) then
    sTempPath := sPath + '*.*'
  else
    sTempPath := sPath + sWildStr;

  iSchRec := FindFirst(sTempPath, faAnyFile or faDirectory, SchRec);
  while (iSchRec = 0) do
  begin
    if not ((SchRec.Name = '.') or (SchRec.Name = '..')) then // '.', '..' 폴더는 제외
    begin
      if (SchRec.Attr and faDirectory) = 0 then // 폴더가 아닌 것
      begin
        if (bSchSubFolder = true) and ((sWildStr <> '') or (sWildStr <> '*.*')) then   // 와일드카드를 설정하고 서브폴더 밑도 검색할 경우
        begin
          if ExtractFileExt(SchRec.Name) = ExtractFileExt(sWildStr) then // 수동 필터링 : *.확장자만 지원 / '?'는 지원안함
            slFileList.add(sPath + SchRec.Name);
        end else  // 일반적인 경우 : 서브폴더 밑 검색안함
          slFileList.add(sPath + SchRec.Name);
      end
      // 폴더인 경우
      else
      begin
        // 폴더 안에 파일도 검색하는 경우
        if bSchSubFolder = true then
        begin
          // 파일 검색 함수 : 재귀호출
          GetSearchedFileList(sPath + SchRec.Name + '\',
                              slFileList, sWildStr, bSchSubFolder);
        end;
      end;
    end;
    iSchRec := FindNext(SchRec);
  end;
  FindClose(SchRec);
end;


procedure FileSearch2(const PathName, FileName : string; const InDir : boolean);
var Rec  : TSearchRec;
    Path : string;
begin
Path := Slash(PathName);
if FindFirst(Path + FileName, faAnyFile - faDirectory, Rec) = 0 then
 try
   repeat
     //ListBox1.Items.Add(Path + Rec.Name);
   until FindNext(Rec) <> 0;
 finally
   FindClose(Rec);
 end;

If not InDir then Exit;

if FindFirst(Path + '*.*', faDirectory, Rec) = 0 then
 try
   repeat
    if ((Rec.Attr and faDirectory) <> 0)  and (Rec.Name<>'.') and (Rec.Name<>'..') then
     FileSearch2(Path + Rec.Name, FileName, True);
   until FindNext(Rec) <> 0;
 finally
   FindClose(Rec);
 end;
end; //procedure FileSearch


procedure FindFilesDelphiLand(FilesList: TStringList; StartDir, FileMask: string);
var
  SR: TSearchRec;
  DirList: TStringList;
  IsFound: Boolean;
  i: integer;
begin
  if StartDir[length(StartDir)] <> '\' then
    StartDir := StartDir + '\';

  { Build a list of the files in directory StartDir
     (not the directories!)                         }

  IsFound :=
    FindFirst(StartDir+FileMask, faAnyFile-faDirectory, SR) = 0;
  while IsFound do begin
    FilesList.Add(StartDir + SR.Name);
    IsFound := FindNext(SR) = 0;
  end;
  FindClose(SR);

  // Build a list of subdirectories
  DirList := TStringList.Create;
  IsFound := FindFirst(StartDir+'*.*', faAnyFile, SR) = 0;
  while IsFound do begin
    if ((SR.Attr and faDirectory) <> 0) and
         (SR.Name[1] <> '.') then
      DirList.Add(StartDir + SR.Name);
    IsFound := FindNext(SR) = 0;
  end;
  FindClose(SR);

  // Scan the list of subdirectories
  for i := 0 to DirList.Count - 1 do
    FindFilesDelphiLand(FilesList, DirList[i], FileMask);

  DirList.Free;
end;


function ExtractLastChar(Str: String): String;
var
  TmpStr : String;
begin
  TmpStr := Str;
  Result := Copy(TmpStr, Length(TmpStr), 1);
end;

function ExtractNextOneChar(Str, Delim: String): String;
var
  TmpStr: String;
  I: integer;
begin
  TmpStr := Str;
  I := Pos(Delim, TmpStr);
  Result := Copy(TmpStr, I+1, 1);
end;

function ExtractZeroToDelimStr(Src, sDelim: String): String;
  var
    a: integer;
    TmpStr: String;
begin
    TmpStr := Src;
    a:= Pos(sDelim, TmpStr);
    Result := Copy(TmpStr, 0, a-1);
end;

function ExtractCharToLast(Src, S: String): String;
var
  I : Integer;
begin
  I := LastDelimiter(S, Src);
  Result := Copy(Src, I+1, Length(Src)-I);
end;

function ChangeChar(Src, ChgChar: String; ChangedIndex:integer): String;
var
  L: Integer;
  I: Integer;
  Tmp: String;
begin
  L := Length(Src);
  Tmp := '';
  for I:=0 to L-1 do
  begin
    if I = ChangedIndex then
    begin
      Tmp := Tmp + ChgChar;
    end else
      Tmp := Tmp + Src[I+1];
  end;
  Result := Tmp;
end;

function ExtractOneByIndex(Src: String; Index:integer): integer;
var
  L: Integer;
  P: PChar;
begin
  L :=Length(Src);
  P := PChar(Src);

  case index of
    0: if L>Index then Result := strtoint(P^) else Result := -1;
    1: begin
         if L>Index then begin
           inc(P);
           Result := strtoint(P^);
         end else Result := -1;
       end;
    2: begin
         if L>Index then begin
           inc(P); inc(P);
           Result := strtoint(P^);
         end else Result := -1;
       end;
    3: begin
         if L>Index then begin
           inc(P); inc(P); inc(P);
           Result := strtoint(P^);
         end else Result := -1;
       end;
    4: begin
         if L>Index then begin
           inc(P); inc(P); inc(P); inc(P);
           Result := strtoint(P^);
         end else Result :=-1;
       end;
  end;

end;

function ExtractZeroToLastDelimStr(Src, sLastDelim: String): String;
var
  I: integer;
  TmpStr: String;
begin
  if ExtractLastChar(Src) = sLastDelim then
    Src := DeleteLastChar(Src);
  TmpStr := Src;
  I := LastDelimiter(sLastDelim, Src);
  Result := Copy(TmpStr, 0, I-1);
end;

function ExtractRangeStr(const Src, S, E: String): String;
var
  a,b, c: integer;
  TmpStr: String;
begin
  TmpStr := Src;
  TmpStr := Trim(TmpStr);
  a := Pos(S, TmpStr)+1;
  b := Pos(E, TmpStr);
  c := b-a;
  Result := Copy(TmpStr, a, c);
end;

function ExtractRangeStr(const Src:string; a, b: integer): String;
var
  c: integer;
  TmpStr: String;
begin
  TmpStr := Src;
  TmpStr := Trim(TmpStr);
  c := b-a;
  Result := Copy(TmpStr, a, c);
end;


// test 'aaa(ddd)(dfdfd)'
function ExtractLastRangeStr(const Src, S, E: String): String;
var
    a,b, c: integer;
    TmpStr: String;
begin
    TmpStr := Src;
    TmpStr := Trim(TmpStr);
    b := LastDelimiter(E, TmpStr);
    TmpStr := Copy(TmpStr, 0, b-1);
    a := LastDelimiter(S, TmpStr);
    Result := Copy(TmpStr, a+1, Length(TmpStr)-a);
end;

{ Get Erlang Tuple Range Text. }
function ExtractTupleRangeText(const Src, S, E: string): string;
var
  TmpStr: string;
  IStart, IEnd: integer;
begin
  TmpStr := Src;
  TmpStr := Trim(TmpStr);
  IStart := Pos(S, Tmpstr);
  IEnd   := LastDelimiter(E, Tmpstr);
  Result := Copy(Tmpstr,IStart+1, IEnd-IStart-1);
end;

function ExtractDirDelim(sFileName: String): TStringList;
var
  Tmp: TStringList;
  I : integer;
  S : String;
begin
  // C:\Erlang\Source
  Result := TStringList.Create;
  Tmp := SplitString(sFileName, '\');
  for I:=0 to Tmp.Count-1 do
  begin
    if I=0 then begin
      S := Tmp[I]+ '\' + Tmp[I+1];
      Result.Add(S);
    end else if I=1 then
      Continue
    //else if I= Tmp.Count-1 then
    //  Continue
    else begin
      S := S + '\' + Tmp[I];
      Result.Add(S);
    end;

  end;

end;    

function AdvSelectDirectory(const Caption: string; const Root: WideString; 
 var Directory: string; EditBox: Boolean = False; ShowFiles: Boolean = False; 
 AllowCreateDirs: Boolean = True): Boolean; 
 // callback function that is called when the dialog has been initialized 
 //or a new directory has been selected 

 function SelectDirCB(Wnd: HWND; uMsg: UINT; lParam, lpData: lParam): Integer; 
   stdcall; 
 var 
   PathName: array[0..MAX_PATH] of Char; 
 begin 
   case uMsg of 
     BFFM_INITIALIZED: SendMessage(Wnd, BFFM_SETSELECTION, Ord(True), Integer(lpData)); 
     // include the following comment into your code if you want to react on the 
     //event that is called when a new directory has been selected 
     // binde den folgenden Kommentar in deinen Code ein, wenn du auf das Ereignis 
     //reagieren willst, das aufgerufen wird, wenn ein neues Verzeichnis selektiert wurde 
     {BFFM_SELCHANGED: 
     begin 
       SHGetPathFromIDList(PItemIDList(lParam), @PathName); 
       // the directory "PathName" has been selected 
       // das Verzeichnis "PathName" wurde selektiert 
     end;} 
   end; 
   Result := 0; 
 end; 
var 
 WindowList: Pointer; 
 BrowseInfo: TBrowseInfo; 
 Buffer: PChar; 
 RootItemIDList, ItemIDList: PItemIDList; 
 ShellMalloc: IMalloc; 
 IDesktopFolder: IShellFolder; 
 Eaten, Flags: LongWord; 
const 
 // necessary for some of the additional expansions 
 // notwendig f&uuml;r einige der zus&auml;tzlichen Erweiterungen 
 BIF_USENEWUI = $0040; 
 BIF_NOCREATEDIRS = $0200; 
begin 
 Result := False; 
 if not DirectoryExists(Directory) then 
   Directory := ''; 
 FillChar(BrowseInfo, SizeOf(BrowseInfo), 0); 
 if (ShGetMalloc(ShellMalloc) = S_OK) and (ShellMalloc <> nil) then 
 begin 
   Buffer := ShellMalloc.Alloc(MAX_PATH); 
   try 
     RootItemIDList := nil; 
     if Root <> '' then 
     begin 
       SHGetDesktopFolder(IDesktopFolder); 
       IDesktopFolder.ParseDisplayName(Application.Handle, nil, 
         POleStr(Root), Eaten, RootItemIDList, Flags); 
     end; 
     OleInitialize(nil); 
     with BrowseInfo do 
     begin 
       hwndOwner := Application.Handle; 
       pidlRoot := RootItemIDList; 
       pszDisplayName := Buffer; 
       lpszTitle := PChar(Caption); 
       // defines how the dialog will appear: 
       // legt fest, wie der Dialog erscheint: 
       ulFlags := BIF_RETURNONLYFSDIRS or BIF_USENEWUI or 
         BIF_EDITBOX * Ord(EditBox) or BIF_BROWSEINCLUDEFILES * Ord(ShowFiles) or 
         BIF_NOCREATEDIRS * Ord(not AllowCreateDirs); 
       lpfn    := @SelectDirCB; 
       if Directory <> '' then 
         lParam := Integer(PChar(Directory)); 
     end; 
     WindowList := DisableTaskWindows(0); 
     try 
       ItemIDList := ShBrowseForFolder(BrowseInfo); 
     finally 
       EnableTaskWindows(WindowList); 
     end; 
     Result := ItemIDList <> nil; 
     if Result then 
     begin 
       ShGetPathFromIDList(ItemIDList, Buffer); 
       ShellMalloc.Free(ItemIDList); 
       Directory := Buffer; 
     end; 
   finally 
     ShellMalloc.Free(Buffer); 
   end; 
 end; 
end; 


function SplitString(const AIn, ADelim: string; var AOut: array of string): integer;
var
  CurLine, te: string;
  p2: integer;
begin
  Result := 0;
  if AIn <> '' then begin
    CurLine := AIn;
    repeat
      p2 := Pos(ADelim, CurLine);
      if p2 = 0 then
        p2 := Length(CurLine) + 1;
      te := System.Copy(CurLine, 1, p2 - 1);
      System.Delete(CurLine, 1, p2);
      AOut[Result] := te;
      Inc(Result);
      if Result >= High(AOut) then
        Break;
    until CurLine = '';
  end;
end;

function SplitString(const AIn, ADelim: string): TStringList;
var
  CurLine, te: string;
  p2: integer;
begin
  Result := TStringList.Create;
  if AIn <> '' then begin
    CurLine := AIn;
    repeat
      p2 := Pos(ADelim, CurLine);
      if p2 = 0 then
        p2 := Length(CurLine) + 1;
      te := System.Copy(CurLine, 1, p2 - 1);
      System.Delete(CurLine, 1, p2);
      Result.Add(trim(te));
    until CurLine = '';
  end;
end;



function LastStr(sTarget, Ch: String): String;
begin
    result := copy(sTarget, LastDelimiter(Ch, sTarget) + 1, Length(sTarget));
end;

function ExtractLastStr(sTarget, Ch: String): String;
begin
  Result := LastStr(sTarget, Ch);
end;

function ExtractLeftStringOfLastChar(S, ch: String): String;
begin
  Result := Copy(S, 0, LastDelimiter(Ch, S));
end;

function ExtratExt(sTarget, Ch: String): String;
begin
    result := copy(sTarget, LastDelimiter(Ch, sTarget) + 1, Length(sTarget));
end;

function ExtratExt(sFileName:String): String;
begin
  Result := Copy(sFileName, LastDelimiter('.', sFileName) + 1, Length(sFileName));
end;

function GetDriver(Dir:string):string;
begin
  Result := Copy(Dir, 0, 1);
end;

procedure RenameDir(DirFrom, DirTo: string);
var
  shellinfo: TSHFileOpStruct;
begin
  with shellinfo do
  begin
    Wnd    := 0;
    wFunc  := FO_RENAME;
    pFrom  := PChar(DirFrom);
    pTo    := PChar(DirTo);
    fFlags := FOF_FILESONLY or FOF_ALLOWUNDO or
              FOF_SILENT or FOF_NOCONFIRMATION;
  end;
  SHFileOperation(shellinfo);
end;

function CopyDir(const fromDir, toDir: string): Boolean;
var
  fos: TSHFileOpStruct;
begin
  ZeroMemory(@fos, SizeOf(fos));
  with fos do
  begin
    wFunc  := FO_COPY;
    fFlags := FOF_FILESONLY;
    pFrom  := PChar(fromDir + #0);
    pTo    := PChar(toDir)
  end;
  Result := (0 = ShFileOperation(fos));
end;


function MoveDir(const fromDir, toDir: string): Boolean;
var
  fos: TSHFileOpStruct;
begin
  ZeroMemory(@fos, SizeOf(fos));
  with fos do
  begin
    wFunc  := FO_MOVE;
    fFlags := FOF_FILESONLY;
    pFrom  := PChar(fromDir + #0);
    pTo    := PChar(toDir)
  end;
  Result := (0 = ShFileOperation(fos));
end;

function DelDir(dir: string): Boolean;
var
  fos: TSHFileOpStruct;
begin
  ZeroMemory(@fos, SizeOf(fos));
  with fos do
  begin
    wFunc  := FO_DELETE;
    fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
    pFrom  := PChar(dir + #0);
  end;
  Result := (0 = ShFileOperation(fos));
end;



function getPathStr(Str, sDelimiter: String): String;
var
     iPos : integer;
begin
     iPos := LastDelimiter(sDelimiter, Str);
     result := copy(Str, 0, iPos);
end;


function StrKCopy(str: String; a1: Integer; a2: Integer): String;
begin
  result := copy(str, a1, a2);
end;

function checkDot(str: String) : boolean;
begin
  Result := False;
  if LastDelimiter(str, '.') > 0 then
      Result := True;
end;


function ReplaceStr(const S, Srch, Replace: string): string;
var
  I: Integer;
  Source: string;
begin
  Source := S;
  Result := '';
  repeat
    I := Pos(Srch, Source);
    if I>0 then
    begin
      Result := Result + Copy(Source, 1, I - 1) + Replace;
      Source := Copy(Source, I + Length(Srch), MaxInt);
    end
    else
      Result := Result + Source;
  until I<= 0;
end;

function CheckStringEmpty(Str, Msg: String):boolean;
begin
  Result := False;
  if Str = '' then begin
    ShowMessage(Msg);
    Result := True;
  end;
end;

function CheckEqualText(Str1, Str2, Msg: String): boolean;
begin
  Result := False;
  if Str1 = Str2 then begin
    ShowMessage(Msg);
    Result := True;
  end;
end;

function CheckBooleanMsg(Bool: boolean; Msg: String): boolean;
begin
  Result := False;
  if Bool = True then
  begin
    ShowMessage(Msg);
    Result := True;
  end;
end;

function ExpandFileName(const FileName: string): string;
var
  FName: PChar;
  Buffer: array[0..MAX_PATH - 1] of Char;
begin
  SetString(Result, Buffer, GetFullPathName(PChar(FileName), SizeOf(Buffer),
    Buffer, FName));
end;



function ExtractFileName(const FileName: string): string;
var
  I: Integer;
begin
  I := LastDelimiter(PathDelim + DriveDelim, FileName);
  Result := Copy(FileName, I + 1, MaxInt);
end;

function ChangeFileExt(const FileName, Extension: string): string;
var
  I: Integer;
begin
  I := LastDelimiter('.' + PathDelim + DriveDelim,Filename);
  if (I = 0) or (FileName[I] <> '.') then I := MaxInt;
  Result := Copy(FileName, 1, I - 1) + Extension;
end;

function ExtractFilePath(const FileName: string): string;
var
  I: Integer;
begin
  I := LastDelimiter(PathDelim + DriveDelim, FileName);
  Result := Copy(FileName, 1, I);
end;

function ExtractFileDir(const FileName: string): string;
var
  I: Integer;
begin
  I := LastDelimiter(PathDelim + DriveDelim, Filename);
  if (I > 1) and (FileName[I] = PathDelim) and
    (not IsDelimiter( PathDelim + DriveDelim, FileName, I-1)) then Dec(I);
  Result := Copy(FileName, 1, I);
end;

function ExtractFileDirS(const FileName: string): string;
begin
  result := Slash(ExtractFileDir(Filename));
end;

function ExtractFileDrive(const FileName: string): string;
var
  I, J: Integer;
begin
  if (Length(FileName) >= 2) and (FileName[2] = DriveDelim) then
    Result := Copy(FileName, 1, 2)
  else if (Length(FileName) >= 2) and (FileName[1] = PathDelim) and
    (FileName[2] = PathDelim) then
  begin
    J := 0;
    I := 3;
    While (I < Length(FileName)) and (J < 2) do
    begin
      if FileName[I] = PathDelim then Inc(J);
      if J < 2 then Inc(I);
    end;
    if FileName[I] = PathDelim then Dec(I);
    Result := Copy(FileName, 1, I);
  end else Result := '';
end;

function getShortFileName(sFullPathFile: String): String;
begin
   result := getPureFileName(sFullPathFile) + '.' + getExtension(sFullPathFile);
end;

procedure CopyStreamFile (SourceName, TargetName: String);
var
  Stream1, Stream2: TFileStream;
begin
  Stream1 := TFileStream.Create (SourceName, fmOpenRead);
  try
    Stream2 := TFileStream.Create (TargetName, fmOpenWrite or fmCreate);
    try
      Stream2.CopyFrom (Stream1, Stream1.Size);
    finally
      Stream2.Free;
    end
  finally
    Stream1.Free;
  end
end;
    
function SaveAndOpenFile(path: String; open: boolean): TFileStream;
var
  fs : TFileStream;
begin
  try
    fs     := TFileStream.Create ( path ,fmCreate or fmShareExclusive );
    fs.Free;
    if open then
      fs := TFileStream.Create ( path ,fmOpenWrite or fmShareDenyWrite );
    except
      on E : Exception do
      begin
        fs := NIL;
        ShowMessage ( 'Can''t create new log file: ' + path );
        path := '';
      end;
   end;
end;

{
function StreamToMemory(AStream: TStream): TMemoryStream;
begin
  Result := TMemoryStream.Create;
  Result.LoadFromStream(AStream);
  FreeAndNil(AStream);
  Result.SetSize(Result.Size + 1);
  PChar(Result.Memory)[Result.Size - 1] := #0;
end;

function StringToMemory(Str:string): TMemoryStream;
begin
  Result:= TMemoryStream.Create;
  Result.Write(Pointer(Str)^, Length(Str));
  Result.Position := 0;
end;
}
function getExtension( s: String): String;
var
  i : integer;
begin
  i := LastDelimiter( '.', s );

  result := copy(s, i + 1, Length(s));
end;

function changeExtension( pathfname: String; changeExt: String): String;
var
  i: integer;
begin
  i := LastDelimiter( '.', pathfname );
  result := copy(pathfname, 0, i) + changeExt ;
end;


function GetPureFileName(sFullPathFile: String): String;
var
  i, j: integer;
begin
  i := LastDelimiter( '\', sFullPathFile );
  j := LastDelimiter( '.', sFullPathFile );

  result := copy(sFullPathFile, i + 1, j-i-1);
end;

function GetDirNames( Path: String ): TStringList;
var
  SR : TSearchRec;
begin
  Result := TStringList.Create;
  Path := Slash(Path);
  if FindFirst(Path+'*.*', faAnyFile, SR)=0 then
  begin
      repeat
        if  (SR.Attr AND faDirectory = faDirectory) AND (SR.Name <> '.') AND (SR.Name <> '..') then
        begin
          Result.add(SR.Name);
        end;

      until FindNext(SR) <> 0;
      FindClose(SR);
  end;
end;

function GetFullDirNames(Path: String): TStringList;
var
  SR : TSearchRec;
begin
  Result := TStringList.Create;
  Path := Slash(Path);
  if FindFirst(Path+'*.*', faAnyFile, SR)=0 then
  begin
      repeat
        if  (SR.Attr AND faDirectory = faDirectory) AND (SR.Name <> '.') AND (SR.Name <> '..') then
        begin
          Result.add(Path + SR.Name);
        end;

      until FindNext(SR) <> 0;
      FindClose(SR);
  end;
end;

function c_pathanddir(path: String; out count:integer): Tarraystr;
var
  SR : TSearchRec;
begin
  Path := Slash(Path);
  count := 0;
  if FindFirst(Path+'*.*', faAnyFile, SR)=0 then
  begin
      repeat
        if  (SR.Attr AND faDirectory = faDirectory) AND (SR.Name <> '.') AND (SR.Name <> '..') then
        begin
          setlength(result, count +1);
          result[count] := path + sr.name;
          inc(count);
        end;

      until FindNext(SR) <> 0;
      FindClose(SR);
  end;
end;


function GetFullFileNames(Path: String; Wild: String): TStringList;
var
  SR : TSearchRec;
begin
  Result := TStringList.Create;
  if FindFirst(Slash(Path)+Wild, faAnyFile, SR)=0 then
  begin
      repeat
        if  (SR.Attr AND faDirectory = faDirectory) AND (SR.Name <> '.') AND (SR.Name <> '..') then
        begin
          Result.add(Slash(Path) + SR.Name);
        end;

      until FindNext(SR) <> 0;
      FindClose(SR);
  end;
end;


procedure GetAllDirs(Path: STRING; out OutStrings: TStringList);
VAR
    ReturnCode : INTEGER;
    SR : TSearchRec;
BEGIN
  Path := Slash(Path);
  ReturnCode := SysUtils.FindFirst(Path+'*.*', faAnyFile, SR);

  TRY
    WHILE ReturnCode = 0 DO
    BEGIN
      //IF (SR.Attr AND faDirectory <> faDirectory) AND (SR.Name <> '.') AND (SR.Name <> '..') THEN
      //begin
      //    GetAllDirs(Path, OutStrings);
      //end;
      IF (SR.Attr AND faDirectory = faDirectory) AND (SR.Name <> '.') AND (SR.Name <> '..') THEN
      begin
         OutStrings.Add(Sr.Name)
      end;

      ReturnCode := SysUtils.FindNext(SR);
    END;
  FINALLY
    SysUtils.FindClose(SR);
  END
END;


{-------------------------------------------------------------------}
{ Search in Only Each Dir. }
{ Files := KefreeUtil.GetAllFiles('C:\Erlang\Source\src', '*.erl'); }
{ 하위디렉토리는 배제 }
{-------------------------------------------------------------------}
function GetAllFiles(Path: String; Wild: String): TStringList;
var
  ReturnCode : integer;
  SR : TSearchRec;
begin
  Result := TStringList.create;
  Path := Slash(Path);
  ReturnCode := SysUtils.FindFirst(Path+Wild, faAnyFile, SR);
  try
    while ReturnCode = 0 do
    begin
      if (SR.Attr and faDirectory <> faDirectory) and (SR.Name <> '.') and (SR.Name <> '..') then
      begin
         if Pos(ExtratExt(Wild), SR.Name)>0 then Result.Add(Sr.Name);
         if ((Wild = '*.*') or (Wild = '.*') or (Wild='*')) then Result.Add(Sr.Name);
      end;
      ReturnCode := SysUtils.FindNext(SR);
    end;
  finally
    SysUtils.FindClose(SR);
  end;
end;


function GetAllPureFiles(Dir: String; Wild: String): TStringList;
var
  SR : TSearchRec;
  I : Integer;
begin
  Dir := Slash(Dir);
  Result := Tstringlist.Create;
  try
    if FindFirst(Dir + Wild, faAnyFile, SR)=0 then
    begin
      repeat
        if ((SR.Attr and faAnyFile) = SR.Attr) and (SR.Name <> '.') and (SR.Name <> '..') then
        begin
          I := LastDelimiter( '.', SR.Name );
          Result.add(copy(SR.Name, 0, I-1));
        end;
      until FindNext(SR) <> 0;
    end;
  finally
    SysUtils.FindClose(SR);
  end;
end;

function GetFileRead(path,Wild: String): TStrings;
var
  SR : TSearchRec;
  F : TextFile;
  sLine, sfLine : String;
begin
  path := Slash(path);
  Result := TStringList.create;
  try
    if FindFirst(Path + Wild, faAnyFile, SR)=0 then
    begin
      repeat
        if (SR.Attr and faAnyFile) = SR.Attr then
        begin
                AssignFile(F, Path + SR.Name);
                Reset(F);
                sLine := ''; sfLine := '';

                while Not Eof(F) do begin
                  Readln(F,sLine);
                  sfLine := sfLine + sLine + #13;
                end;
                
                Result.Add(sfLine);
                Close(F);
        end;
      until FindNext(SR) <> 0;
    end;
  finally
    FindClose(SR);
  end;
end;

{ All search in SubDirectory. }
procedure GetFiles(Path: STRING; CONST FileSpec: STRING; Files: TStrings);
var
  ReturnCode : INTEGER;
  SR : TSearchRec;
  Srname: string;
begin
  if files = nil then files := Tstringlist.create;
  Path := Slash(Path);

  ReturnCode := SysUtils.FindFirst(Path+'*.*', faAnyFile, SR);
  try
    while ReturnCode = 0 do
    begin
      IF (SR.Attr AND faDirectory <> faDirectory) AND (SR.Name <> '.') AND (SR.Name <> '..') THEN
      begin
         SRname := ExtratExt(UpperCase(SR.Name));
         //if Pos(ExtratExt(Uppercase(FileSpec)), ExtratExt(SRname))>0 then Files.Add(Path + SR.Name);
         if ExtratExt(Uppercase(FileSpec)) = ExtratExt(Uppercase(SRname)) then Files.Add(Path + SR.Name);
         if ((FileSpec = '*.*') or (FileSpec = '.*') or (FileSpec='*')) then Files.Add(Path + SR.Name);
      end;
      
      IF (SR.Attr AND faDirectory = faDirectory) AND (SR.Name <> '.') AND (SR.Name <> '..') THEN
         GetFiles(Path + SR.Name, FileSpec, Files);

      ReturnCode := SysUtils.FindNext(SR);
    end;
  finally
    SysUtils.FindClose(SR);
  end;
end;


function c_GetFileSize(FileName: String): Cardinal;
var
  f: File;
begin
  AssignFile(f, FileName);
  Reset(f, 1);
  Result := FileSize(f);
  CloseFile(f);
end;

{ HasAttrib() tests whether or not a file (with attributes fileAttrib) has the
  testAttrib attribute bit set. }
function aHasAttrib(fileAttrib, testAttrib: Integer): Boolean;
begin

  Result := (fileAttrib and testAttrib) <> 0;

end;


function aFileInfo(filename: String): TSearchRec;
var
  s: TSearchRec;
begin

  if not FileExists(filename) then
    raise Exception.Create('File not found: ' + filename);
  FindFirst(filename, faAnyFile, s);
  Result := s;
  FindClose(s);

end;

{ GetDirNames() retrieves the names of all subdirectories in a given path. }
function aGetDirNames(path: String): TStringList;
var
  i: Integer;
begin

  Result := aGetFileNames(path + '*.*', faDirectory);
  i := 0;
  while i < Result.Count do
  begin
    if (not aHasAttrib(FileGetAttr(Result[i]), faDirectory))
      or (Result[i][1] = '.') then Result.Delete(i)
    else INC(i);
  end;

end;

{ GetFileNames() enumerates all files within the given path and with the given
  attributes. The attributes must be a combination of the following:
    -> faReadOnly, faHidden, faSysFile, faVolumeID, faDirectory, faArchive, faAnyFile.
  To find only normal files, pass 0 as the attrib parameter. REMEMBER TO ADD WILDCARDS
  TO THE PATH, OR YOU WON'T FIND ANYTHING!!! }
function aGetFileNames(path: String; attrib: Integer): TStringList;
var
  srec: TSearchRec;
begin

  Result := TStringList.Create;
  FillChar(srec, SizeOf(srec), 0);
  if FindFirst(path, attrib, srec) = 0 then
  begin
    Result.Add(srec.Name);
    while FindNext(srec) = 0 do Result.Add(srec.Name);
    FindClose(srec);
  end;

end;

{
function jGetFileInformation(const FileName: string): TSearchRec;
begin
  if FindFirst(FileName, faAnyFile, Result) = 0 then
    SysUtils.FindClose(Result)
  else
    RaiseLastOSError;
end;

function jGetFileLastWrite(const FileName: string): TFileTime;
begin
  Result := GetFileInformation(FileName).FindData.ftLastWriteTime;
end;

function jGetFileLastAccess(const FileName: string): TFileTime;
begin
  Result := GetFileInformation(FileName).FindData.ftLastAccessTime;
end;

function jGetFileCreation(const FileName: string): TFileTime;
begin
  Result := GetFileInformation(FileName).FindData.ftCreationTime;
end;

}


function RxFileDateTime(const FileName: string): System.TDateTime;
var
  Age: Longint;
begin
  Age := FileAge(FileName);
  if Age = -1 then
    Result := NullDate
  else
    Result := FileDateToDateTime(Age);
end;


function RxGetFileSize(const FileName: string): Longint;
var
  SearchRec: TSearchRec;
begin
  if FindFirst(ExpandFileName(FileName), faAnyFile, SearchRec) = 0 then
    Result := SearchRec.Size
  else Result := -1;
  FindClose(SearchRec);
end;


function GetFileLastWrite(const FileName: string): TFileTime;
var
  r: TSearchRec;
begin
  if FindFirst(FileName, faAnyFile, r) = 0 then begin
    SysUtils.FindClose(r);
    Result := r.FindData.ftLastWriteTime;
  end else begin
    Result.dwLowDateTime := 0;
    Result.dwHighDateTime := 0;
  end;
end;

function SameFileTime(t1, t2: TFileTime): boolean;
begin
  Result := (t1.dwHighDateTime = t2.dwHighDateTime) and (t1.dwLowDateTime = t2.dwLowDateTime);
end;

procedure KillProcess(hWindowHandle: HWND);
var
  hprocessID: INTEGER;
  processHandle: THandle;
  DWResult: DWORD;
begin
  SendMessageTimeout(hWindowHandle, WM_CLOSE, 0, 0,
    SMTO_ABORTIFHUNG or SMTO_NORMAL, 5000, DWResult);

  if isWindow(hWindowHandle) then
  begin
    //PostMessage(hWindowHandle, WM_QUIT, 0, 0);

    { Get the process identifier for the window}
    GetWindowThreadProcessID(hWindowHandle, @hprocessID);
    if hprocessID <> 0 then
    begin
      { Get the process handle }
      processHandle := OpenProcess(PROCESS_TERMINATE or PROCESS_QUERY_INFORMATION,False, hprocessID);
      if processHandle <> 0 then
      begin
        { Terminate the process }
        //TerminateProcess 함수만 사용하면 특정바이러스프로그램(nXX32) 에서 의심파일로 체크되어 삭제시킴.
        TerminateProcess(processHandle, 0);
        CloseHandle(ProcessHandle);
      end else
        ShowMessage('processHandle is 0!');
    end else
      ShowMessage('hprocessID is 0');
  end else
    ShowMessage('Not Window!');
end;



function KillTask(ExeFileName: string): Integer;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
      Result := Integer(TerminateProcess(
                        OpenProcess(PROCESS_TERMINATE,
                                    BOOL(0),
                                    FProcessEntry32.th32ProcessID),
                                    0));
     ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

// ProcessID 로 윈도우 핸들을 얻음.
// 한 프로세스 안에서 동작??
function GetWinHandle(hInstance: HWND; WinTitle: string): HWND;
  function ProcIDFromWnd(val: HWND): HWND;
  var
    idProc: HWND;
  begin
    GetWindowThreadProcessId(val, @idProc);
    Result := idProc;
  end;
var
  TmpHWND: HWND;
begin
  TmpHWND := FindWindow(nil, PAnsiChar(WinTitle));
  //TmpHWND := FindWindow(nil, nil);   // 최상위 윈도우 핸들 찾기   
  while TmpHWND <> 0 do
  begin
    if GetParent(TmpHWND) = 0 then  // 최상위 핸들인지 체크, 버튼 등도 핸들을 가질 수 있으므로 무시하기 위해   
    begin                           // 최상위 핸들을 리턴한다.
      if hInstance = ProcIDFromWnd(TmpHWND) then
      begin
        ShowMessage(inttostr(TmpHWND));
        Result := TmpHWND;
      end;
    end;
    TmpHWND := GetWindow(TmpHWND, GW_HWNDNEXT);  // 다음 윈도우 핸들 찾기
  end;
  
end;

function DigitToBin(Value: Char): Integer;
begin
  if ((Value >= 'a') and (Value <= 'f')) then Result := Ord(Value) - Ord('a') + 10
  else if ((Value >= 'A') and (Value <= 'F')) then Result := Ord(Value) - Ord('A') + 10
  else if ((Value >= '0') and (Value <= '9')) then Result := Ord(Value) - Ord('0')
  else Result := -1;
end;


function AsciiToInt(S: string; Digits: Integer): Int64;
var
  I: Integer;
begin
  Result := 0;
  I := Min(Length(S), Digits);
  while I > 0 do
  begin
    Result := Result shl 8;
    Result := Ord(S[I]) + Result;
    Dec(I);
  end;
end;

function BCDToInt(Value: Cardinal): Cardinal;
var
  Exp: Cardinal;
begin
  Result := 0;
  Exp := 1;
  while Value > 0 do
  begin
    Result := Result + Min(Value and 15, 9) * Exp;
    Value := Value shr 4;
    Exp := Exp * 10;
  end;
end;

function IntToAscii(Value: Int64; Digits: Integer): string;
var
  I: Integer;
begin
  Result := '';
  I := 0;
  while I < Digits do
  begin
    Result := Result + Chr(Value and $FF);
    Value := Value shr 8;
    Inc(I);
  end;
end;

function IntToBCD(Value: Cardinal): Cardinal;
var
  Exp: Cardinal;
begin
  Result := 0;
  Exp := 1;
  while (Value > 0) and (Exp > 0) do
  begin
    Result := Result + Value mod 10 * Exp;
    Value := Value div 10;
    Exp := Exp * 16;
  end;
end;

function OperatorStrings(strings1, strings2:Tstringlist): Tstringlist;
var
  I: integer;
begin
  for I:=0 to strings2.Count-1 do
    strings1.Add(strings2[I]);
  Result := strings1;
end;


Function StrToFieldType(FieldType : String): TFieldType;
Begin
  Result      := ftUnknown;
  If FieldType = 'Unknown'     Then Begin Result := ftUnknown;     Exit; End;
  If FieldType = 'String'      Then Begin Result := ftString;      Exit; End;
  If FieldType = 'Smallint'    Then Begin Result := ftSmallint;    Exit; End;
  If FieldType = 'Integer'     Then Begin Result := ftInteger;     Exit; End;
  If FieldType = 'Word'        Then Begin Result := ftWord;        Exit; End;
  If FieldType = 'Boolean'     Then Begin Result := ftBoolean;     Exit; End;
  If FieldType = 'Float'       Then Begin Result := ftFloat;       Exit; End;
  If FieldType = 'Currency'    Then Begin Result := ftCurrency;    Exit; End;
  If FieldType = 'BCD'         Then Begin Result := ftBCD;         Exit; End;
  If FieldType = 'Date'        Then Begin Result := ftDate;        Exit; End;
  If FieldType = 'Time'        Then Begin Result := ftTime;        Exit; End;
  If FieldType = 'DateTime'    Then Begin Result := ftDateTime;    Exit; End;
  If FieldType = 'Bytes'       Then Begin Result := ftBytes;       Exit; End;
  If FieldType = 'VarBytes'    Then Begin Result := ftVarBytes;    Exit; End;
  If FieldType = 'AutoInc'     Then Begin Result := ftAutoInc;     Exit; End;
  If FieldType = 'Blob'        Then Begin Result := ftBlob;        Exit; End;
  If FieldType = 'Memo'        Then Begin Result := ftMemo;        Exit; End;
  If FieldType = 'Graphic'     Then Begin Result := ftGraphic;     Exit; End;
  If FieldType = 'FmtMemo'     Then Begin Result := ftFmtMemo;     Exit; End;
  If FieldType = 'ParadoxOle'  Then Begin Result := ftParadoxOle;  Exit; End;
  If FieldType = 'DBaseOle'    Then Begin Result := ftDBaseOle;    Exit; End;
  If FieldType = 'TypedBinary' Then Begin Result := ftTypedBinary; Exit; End;
  If FieldType = 'Cursor'      Then Begin Result := ftCursor;      Exit; End;
  If FieldType = 'FixedChar'   Then Begin Result := ftFixedChar;   Exit; End;
  If FieldType = 'WideString'  Then Begin Result := ftWideString;  Exit; End;
  If FieldType = 'LargeInt'    Then Begin Result := ftLargeInt;    Exit; End;
  If FieldType = 'ADT'         Then Begin Result := ftADT;         Exit; End;
  If FieldType = 'Array'       Then Begin Result := ftArray;       Exit; End;
  If FieldType = 'Reference'   Then Begin Result := ftReference;   Exit; End;
  If FieldType = 'DataSet'     Then Begin Result := ftDataSet;     Exit; End;
End;

Function FieldTypeToStr(FieldType : TFieldType): String;
Begin
  Result := 'Unknown';
  If FieldType = ftUnknown     Then Begin Result := 'Unknown';     Exit; End;
  If FieldType = ftString      Then Begin Result := 'String';      Exit; End;
  If FieldType = ftSmallint    Then Begin Result := 'Smallint';    Exit; End;
  If FieldType = ftInteger     Then Begin Result := 'Integer';     Exit; End;
  If FieldType = ftWord        Then Begin Result := 'Word';        Exit; End;
  If FieldType = ftBoolean     Then Begin Result := 'Boolean';     Exit; End;
  If FieldType = ftFloat       Then Begin Result := 'Float';       Exit; End;
  If FieldType = ftCurrency    Then Begin Result := 'Currency';    Exit; End;
  If FieldType = ftBCD         Then Begin Result := 'BCD';         Exit; End;
  If FieldType = ftDate        Then Begin Result := 'Date';        Exit; End;
  If FieldType = ftTime        Then Begin Result := 'Time';        Exit; End;
  If FieldType = ftDateTime    Then Begin Result := 'DateTime';    Exit; End;
  If FieldType = ftBytes       Then Begin Result := 'Bytes';       Exit; End;
  If FieldType = ftVarBytes    Then Begin Result := 'VarBytes';    Exit; End;
  If FieldType = ftAutoInc     Then Begin Result := 'AutoInc';     Exit; End;
  If FieldType = ftBlob        Then Begin Result := 'Blob';        Exit; End;
  If FieldType = ftMemo        Then Begin Result := 'Memo';        Exit; End;
  If FieldType = ftGraphic     Then Begin Result := 'Graphic';     Exit; End;
  If FieldType = ftFmtMemo     Then Begin Result := 'FmtMemo';     Exit; End;
  If FieldType = ftParadoxOle  Then Begin Result := 'ParadoxOle';  Exit; End;
  If FieldType = ftDBaseOle    Then Begin Result := 'DBaseOle';    Exit; End;
  If FieldType = ftTypedBinary Then Begin Result := 'TypedBinary'; Exit; End;
  If FieldType = ftCursor      Then Begin Result := 'Cursor';      Exit; End;
  If FieldType = ftFixedChar   Then Begin Result := 'FixedChar';   Exit; End;
  If FieldType = ftWideString  Then Begin Result := 'WideString';  Exit; End;
  If FieldType = ftLargeInt    Then Begin Result := 'LargeInt';    Exit; End;
  If FieldType = ftADT         Then Begin Result := 'ADT';         Exit; End;
  If FieldType = ftArray       Then Begin Result := 'Array';       Exit; End;
  If FieldType = ftReference   Then Begin Result := 'Reference';   Exit; End;
  If FieldType = ftDataSet     Then Begin Result := 'DataSet';     Exit; End;
End;

end.
