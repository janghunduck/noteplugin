unit stringworkerplugin;

interface

uses
  SysUtils,
  Classes,
  Controls,
  ExtCtrls,
  Forms,
  Dialogs,
  Windows,
  messages,
  NppPlugin, SciSupport, AboutForms, jsconsoleforms,

  ceflib,
  ceffilescheme,
  logger;

type
  position = integer;
  THelloWorldPlugin = class(TNppPlugin)
  public

    function sendScintilla(hCurrScintilla: THandle; msg: LongWord; wParam:integer; lParam:integer): integer; overload;
    function sendScintilla(hCurrScintilla: THandle; msg: LongWord): integer; overload;
    function sendScintilla(hCurrScintilla: THandle; msg: LongWord; wParam:integer):Integer; overload;
    function sendScintilla(msg: LongWord):Integer; overload;

    function getCurScintilla(): Thandle;
    function getSelectedText(): string;
    function getAllText(): string;
    function getAllTextA(): string;
    function getLineCount(): integer;
    function getCurLinePos(): integer;
    function getColPos(): position;
    function getCurrlineNumber(): integer;
    function getCurrlineNumberA(): integer;
    function getLineLength(): integer;
    procedure gotoline(linenumber: integer);
    function getCurrentFile(): string;
    function getCurrentPathFile(): AnsiString;
    function getCurrentPathFileA(): PWChar;
    procedure getCurrentPathFilep(returnstr: pwidechar);
    function setToolbardata():string;
    procedure getSelectAll;
    function getmarker(): integer;
    procedure markerdefine(markernumber: integer);
    function markeradd(markernumber: integer): integer;


    constructor Create;
    destructor Destroy; override;
    procedure BeforeDestruction; override;
    // -------------------------------------------------------------------
    procedure FuncHelloWorld;
    procedure FuncHelloWorldDocking;
    procedure FuncAbout;
    procedure DoNppnToolbarModification; override;

    procedure FuncDoubleQuotToSingle;
    procedure FuncConbineQQPlusCR;
    procedure SlashComment;
    procedure SlashCommentRemove;
    procedure FuncTest;

    procedure JsConsoleDock;
    procedure JsConsole;
    procedure JsWinConsole;
    procedure funcname;
    procedure JsFunctionCall;
    procedure JsPlugins;
    procedure Hook;


  end;

procedure _FuncHelloWorld; cdecl;
procedure _FuncHelloWorldDocking; cdecl;
procedure _FuncAbout; cdecl;
procedure _FuncConbineQQPlusCR; cdecl;
procedure _SlashComment; cdecl;
procedure _SlashCommentRemove; cdecl;

procedure _FuncDoubleQuotToSingle; cdecl;
procedure _FuncTest; cdecl;

procedure _JsConsoleDock; cdecl;
procedure _JsConsole; cdecl;
procedure _JsWinConsole; cdecl;
procedure _getCurrentPathFile; cdecl;
procedure _testfuncname;cdecl;
procedure _JsFunctionCall; cdecl;
procedure _JsPlugins; cdecl;
procedure _Hook; cdecl;

procedure RegisterSchemes(const registrar: ICefSchemeRegistrar); stdcall;
function CefWndProc(Wnd: HWND; message: UINT; wParam: Integer; lParam: Integer): Integer; stdcall;


var
  Npp: THelloWorldPlugin;

implementation

uses cefconsole, kefreeutil, consolefrm, jsfuncfrm, hookfrm;
{ THelloWorldPlugin }


//SendMessage(hwnd, wm_CopyData, Form1.Handle, Integer (@DataStruct));
// inline LRESULT sendScintilla(HWND& hCurrScintilla, UINT Msg, WPARAM wParam, LPARAM lParam)
//inline LRESULT sendScintilla(sptr_t  hCurrScintilla, unsigned int Msg, uptr_t wParam, sptr_t lParam)
{
	//	uptr_t wParam;
	return ::SendMessage(hCurrScintilla, Msg, wParam, lParam);
}


function THelloWorldPlugin.sendScintilla(hCurrScintilla: THandle; msg: LongWord; wParam:integer; lParam:integer): integer;
begin
  result :=  SendMessage(hCurrScintilla, Msg, wParam, lParam);
end;

function THelloWorldPlugin.sendScintilla(hCurrScintilla: THandle; msg: LongWord): integer;
begin
  result :=  SendMessage(hCurrScintilla, Msg, 0, 0);
end;

function THelloWorldPlugin.getCurScintilla(): Thandle;
var
  which: integer;
begin
  //which := -1;
  //sendScintilla(self.NppData.NppHandle,NPPM_GETCURRENTSCINTILLA, 0, which);
  //Showmessage('whitch=' +inttostr(which));
  result :=  self.NppData.ScintillaMainHandle;
{
int which = -1;
	sendScintilla(nppData._nppHandle, NPPM_GETCURRENTSCINTILLA, 0, (LPARAM)& which);
	if (which == -1)
		return NULL;
	return (which == 0) ? nppData._scintillaMainHandle : nppData._scintillaSecondHandle;
}
end;

function THelloWorldPlugin.sendScintilla(msg: LongWord):Integer;
begin
  result := sendScintilla(getCurScintilla(), Msg);
end;

function THelloWorldPlugin.sendScintilla(hCurrScintilla: THandle; msg: LongWord; wParam:integer):Integer;
begin
  result := sendScintilla(getCurScintilla(), Msg, wParam);
end;

constructor THelloWorldPlugin.Create;
var
  sk: TShortcutKey;
  i: Integer;
begin
  inherited;

  self.PluginName := 'String &Worker';
  i := 0;
  {
  sk.IsCtrl := true; sk.IsAlt := true; sk.IsShift := false;
  sk.Key := #118; // CTRL ALT SHIFT F7
  self.AddFuncItem('Replace Hello World', _FuncHelloWorld, sk);

  self.AddFuncItem('Docking Test', _FuncHelloWorldDocking);

  self.AddFuncItem('-', _FuncHelloWorld);
   }
  self.AddFuncItem('Chrom Developer Tools', _JsConsole);
  self.AddFuncItem('Javascript Function call', _JsFunctionCall);
  //self.AddFuncItem('Javascript Plugins', _JsPlugins);
  //self.AddFuncItem('js winapi 생성', _JsWinConsole);
  //self.AddFuncItem('js object dock ', _JsConsoleDock);
  self.AddFuncItem('- ', nil);
  self.AddFuncItem('DoubleQuot to Quot', _FuncDoubleQuotToSingle);
  self.AddFuncItem('DoubleQuot plus CR string', _FuncConbineQQPlusCR);
  self.AddFuncItem('Slash Comment ', _SlashComment);
  self.AddFuncItem('UnSlash Comment ', _SlashCommentRemove);

  self.AddFuncItem('- ', nil);
  self.AddFuncItem('all test : Replace Hello World', _FuncHelloWorld);
  self.AddFuncItem('About', _FuncAbout);
  self.AddFuncItem('- ', nil);
  AddFuncItem('Hook Test', _Hook);

  { js 파일을 읽고 함수 이름을 파싱한다.
    for문으로 동적으로 메뉴를 구성한다.}
  self.AddFuncItem('js_as_testfuncname', _testfuncname);    // as.js 안의 textcount parameter는 구조화된 배열을 넘긴다. [1. 모든텍스트 , 파일명 등]


end;

procedure _testfuncname;cdecl;
begin
  
end;

procedure THelloWorldPlugin.funcname;
var
  i: integer;
  item : _TFuncItem;
begin
   for i:=0 to Length(self.AFuncArray)-1 do
   begin
     item := AFuncArray[i];
     //item.ItemName
     //
   end;
end;

procedure _FuncHelloWorld; cdecl;
begin
  Npp.FuncHelloWorld;
end;
procedure _FuncAbout; cdecl;
begin
  Npp.FuncAbout;
end;
procedure _FuncHelloWorldDocking; cdecl;
begin
  Npp.FuncHelloWorldDocking;
end;

//SCI_GETSELTEXT(<unused>, char *text) → position
function THelloWorldPlugin.getSelectedText(): string;
var
  hCurrScintilla: THandle;
  length: integer;
  buf : string;
begin
  buf := #0;
  hCurrScintilla := getCurScintilla();
  length := sendScintilla(hCurrScintilla, SCI_GETSELTEXT);
  if length = 0 then
  begin
    result := '';
    exit;
  end;
  setlength(buf, length);
  sendScintilla(hCurrScintilla, SCI_GETSELTEXT, 0, LPARAM(PChar(buf)));
  result := PChar(buf);
end;


function THelloWorldPlugin.getAllText(): string;
var
  hCurrScintilla: THandle;
  bufLength: integer;
begin
  hCurrScintilla := getCurScintilla();
  bufLength := sendScintilla(hCurrScintilla, SCI_GETTEXT);
  setlength(result, bufLength);
  
  //SCI_GETTEXT(position length, char *text) → position
  sendScintilla(hCurrScintilla, SCI_GETTEXT, 0, LPARAM(PChar(result)));
end;

//SCI_GETLINECOUNT → line
function THelloWorldPlugin.getLineCount(): integer;
begin
  Result := sendScintilla(SCI_GETLINECOUNT);
end;

//SCI_GETCURRENTPOS → position
function THelloWorldPlugin.getCurLinePos(): integer;
begin
  Result := sendScintilla(SCI_GETCURRENTPOS);     // Position of the cursor in the entire buffer

end;

//SCI_GETCOLUMN(position pos) → position
function THelloWorldPlugin.getColPos(): position;
begin
  result := SendMessage(self.NppData.ScintillaMainHandle, SCI_GETCOLUMN, 0, 0);
end;

//SCI_LINEFROMPOSITION(position pos) → line
function THelloWorldPlugin.getCurrlineNumber(): integer;
var
  position : integer;
begin
  position := getCurLinePos();
  Result := SendMessage(self.NppData.ScintillaMainHandle, SCI_LINEFROMPOSITION, position, 0) + 1;  // real line
end;

//SCI_LINEFROMPOSITION(position pos) → line
function THelloWorldPlugin.getCurrlineNumberA(): integer;
var
  position : integer;
begin
  position := getCurLinePos();
  Result := SendMessage(self.NppData.ScintillaMainHandle, SCI_LINEFROMPOSITION, position, 0);     // for  SCI_LINELENGTH
end;

//SCI_LINELENGTH(line line) → position
function THelloWorldPlugin.getLineLength(): integer;
var
  linenumber: integer;
begin
  linenumber := getCurrlineNumberA();
  result := SendMessage(self.NppData.ScintillaMainHandle, SCI_LINELENGTH, linenumber, 0);
end;

//SCI_SELECTALL
procedure THelloWorldPlugin.getSelectAll();
begin
  SendMessage(self.NppData.ScintillaMainHandle, SCI_SELECTALL, 0, 0);
end;

//SCI_GOTOLINE(line line)
procedure THelloWorldPlugin.gotoline(linenumber: integer);
begin
  SendMessage(self.NppData.ScintillaMainHandle, SCI_GOTOLINE, WPARAM(PChar(linenumber)), 0);
end;

//SCI_MARKERGET(line line) → int
function THelloWorldPlugin.getmarker(): integer;
var
  linenumber: integer;
begin
  linenumber := getCurrlineNumberA();
  result :=  SendMessage(self.NppData.ScintillaMainHandle, SCI_MARKERGET, linenumber, 0);
end;

//SCI_MARKERDEFINE(int markerNumber, int markerSymbol)     // markernumber 0-31
procedure THelloWorldPlugin.markerdefine(markernumber: integer);
begin
  SendMessage(self.NppData.ScintillaMainHandle, SCI_MARKERDEFINE, markernumber, lparam(Pchar('@')));
  markeradd(markernumber);
end;

//SCI_MARKERADD(line line, int markerNumber) → int
function THelloWorldPlugin.markeradd(markernumber: integer): integer;
var
  linenumber: integer;
begin
  linenumber := getCurrlineNumber();
  result := SendMessage(self.NppData.ScintillaMainHandle, SCI_MARKERADD, linenumber, markernumber);
end;

procedure THelloWorldPlugin.FuncHelloWorld;
var
  s: string;
  iResult : integer;
  hCurrScintilla: THandle;
  bufLength: integer;
  selectedText: string;
  selStart,selEnd:integer;
begin
  showmessage('filename = [' + self.getCurrentPathFile  + ']');
  showmessage('all text = [' + self.getAllTextA  + ']');
  showmessage('filename = [' + getCurrentFile  + ']');
  showmessage('selected text = [' + getSelectedText() + ']');
  showmessage('line count= [' + inttostr(getLineCount()) + ']');
  showmessage('line num= [' + inttostr(self.getCurrlineNumberA()) + ']');

  {
	selStart := sendScintilla(hCurrScintilla, SCI_GETSELECTIONSTART);
	selEnd := sendScintilla(hCurrScintilla, SCI_GETSELECTIONEND);
	size_t curPos = sendScintilla(hCurrScintilla, SCI_GETCURRENTPOS);
	size_t text_length = sendScintilla(hCurrScintilla, SCI_GETTEXTLENGTH);
  
	sendScintilla(hCurrScintilla, SCI_SETTARGETSTART, selStart);
	sendScintilla(hCurrScintilla, SCI_SETTARGETEND, selEnd);
	sendScintilla(hCurrScintilla, SCI_REPLACETARGET, bufLength, (LPARAM)reversedText);
	sendScintilla(hCurrScintilla, SCI_SETSEL, selStart, selStart + bufLength);
  }
  //sendScintilla(hCurrScintilla, SCI_SETSEL, 0, 48);
  //s := 'Hello World';
  //SendMessage(self.NppData.ScintillaMainHandle, SCI_REPLACESEL, 0, LPARAM(PChar(s)));
  //showmessage(s);
end;

procedure THelloWorldPlugin.FuncAbout;
var
  a: TAboutForm;
begin
  a := TAboutForm.Create(self);
  a.ShowModal;
  a.Free;
end;

procedure THelloWorldPlugin.FuncHelloWorldDocking;
begin
  if (not Assigned(jsconsoledlg)) then jsconsoledlg := Tjsconsoledlg.Create(self, 1);
  jsconsoledlg.Show;
end;

procedure THelloWorldPlugin.DoNppnToolbarModification;
var
  tb: TToolbarIcons;
begin
  tb.ToolbarIcon := 0;
  tb.ToolbarBmp := LoadImage(Hinstance, 'IDB_TB_TEST', IMAGE_BITMAP, 0, 0, (LR_DEFAULTSIZE or LR_LOADMAP3DCOLORS));
  SendMessage(self.NppData.NppHandle, NPPM_ADDTOOLBARICON, WPARAM(self.CmdIdFromDlgId(1)), LPARAM(@tb));

{
  tb.ToolbarIcon := 0;
  tb.ToolbarBmp := LoadImage(Hinstance, 'QRBITMAP', IMAGE_BITMAP, 0, 0, (LR_DEFAULTSIZE));
  Npp_Send(NPPM_ADDTOOLBARICON, WPARAM(self.CmdIdFromDlgId(0)), LPARAM(@tb));
  }
end;


procedure THelloWorldPlugin.FuncDoubleQuotToSingle;
var
  strings : Tstringlist;
  changetext: string;
begin
  strings := tstringlist.create;
  strings.Text := getSelectedText();
  changetext := c_stringreplace(strings.Text, '"', '''');
  sendScintilla(getCurScintilla(), SCI_REPLACESEL, 0, LPARAM(PChar(changetext)));
end;

procedure _FuncDoubleQuotToSingle; cdecl;
begin
  Npp.FuncDoubleQuotToSingle;
end;

{
procedure THelloWorldPlugin.FuncConbineQQandCR;
var
  iResult: integer;
  buf: String;
begin
  iResult := SendMessage(Npp.NppData.ScintillaMainHandle, SCI_GETTEXTLENGTH, 0, 0);
  //showmessage(inttostr(iResult));
  SetLength(buf, iResult);
  FillChar(buf[1], iResult, 32);

  SendMessage(Npp.NppData.ScintillaMainHandle, SCI_GETTEXT, iResult, LPARAM(PChar(@buf[1])));
  //Memo1.Text:=Utf8ToAnsi(buf);
  showmessage(Utf8ToAnsi(buf));
  SetLength(buf, 0);
end;
   }

function THelloWorldPlugin.getAllTextA(): string;
var
  length: integer;
  buf: String;
begin
  length := SendMessage(Npp.NppData.ScintillaMainHandle, SCI_GETTEXTLENGTH, 0, 0);
  SetLength(buf, length);
  SendMessage(Npp.NppData.ScintillaMainHandle, SCI_GETTEXT, length, LPARAM(PChar(buf)));
  result := PChar(buf);
end;


procedure THelloWorldPlugin.FuncConbineQQPlusCR;
var
  strings : Tstringlist;
  changetext: string;
  i:integer;
  stemp: string;
begin
  strings := tstringlist.create;
  strings.Text := getSelectedText();
  for i:=0 to strings.Count-1 do
  begin
    strings[i] := '" ' + strings[i] + ' \n "  + ';
  end;
  sendScintilla(getCurScintilla(), SCI_REPLACESEL, 0, LPARAM(PChar(strings.Text)));
end;


procedure THelloWorldPlugin.SlashComment;
var
  strings : Tstringlist;
  changetext: string;
  i:integer;
  stemp: string;
begin
  strings := tstringlist.create;
  strings.Text := getSelectedText();
  for i:=0 to strings.Count-1 do
  begin
    strings[i] := '//' + strings[i];
  end;
  sendScintilla(getCurScintilla(), SCI_REPLACESEL, 0, LPARAM(PChar(strings.Text)));

end;

procedure _SlashComment; cdecl;
begin
  Npp.SlashComment;
end;

procedure THelloWorldPlugin.SlashCommentRemove;
var
  strings : Tstringlist;
  changetext: string;
  i:integer;
  stemp: string;
begin
  strings := tstringlist.create;
  strings.Text := getSelectedText();
  for i:=0 to strings.Count-1 do
  begin
    strings[i] := c_stringreplace(strings[i], '//', '');
  end;
  sendScintilla(getCurScintilla(), SCI_REPLACESEL, 0, LPARAM(PChar(strings.Text)));

end;

function THelloWorldPlugin.getCurrentFile: string;
var
  pfilename: PWideChar;
  ret: integer;
begin
  ret := SendMessage(self.NppData.NppHandle, NPPM_GETFILENAME, MAX_PATH, LPARAM(pfilename));
  result := string(pfilename);
end;

function THelloWorldPlugin.getCurrentPathFile: AnsiString;
var
  pcurrentpath: PWideChar;
  //pcurrentpath: PAnsiChar;
  ret: integer;
begin

  ret := SendMessage(NppData.NppHandle, NPPM_GETFULLCURRENTPATH, 0, LPARAM(pcurrentpath));

  result := AnsiString(pcurrentpath);
end;


function THelloWorldPlugin.getCurrentPathFileA: PWChar;
var
  s: String;
  r: Integer;
begin
  s := '';
  SetLength(s, 300);
  SendMessage(self.NppData.NppHandle, NPPM_GETFULLCURRENTPATH,0, LPARAM(PWChar(s)));
  result := PWChar(s);
end;


procedure THelloWorldPlugin.getCurrentPathFilep(returnstr: pwidechar);
begin
  SendMessage(NppData.NppHandle, NPPM_GETFULLCURRENTPATH, MAX_PATH, LPARAM(returnstr));
  
end;

procedure _getCurrentPathFile; cdecl;
begin
  Npp.getCurrentPathFile;
end;


procedure _SlashCommentRemove; cdecl;
begin
  Npp.SlashCommentRemove;
end;

procedure _FuncConbineQQPlusCR; cdecl;
begin
  Npp.FuncConbineQQPlusCR;
end;

//SCI_SETTARGETSTART, SCI_SETTARGETEND
procedure THelloWorldPlugin.FuncTest;
var
  strings : Tstringlist;
  changetext: string;
begin
  strings := tstringlist.create;
  strings.Text := getSelectedText();
  changetext := c_stringreplace(strings.Text, '', '');
  sendScintilla(getCurScintilla(), SCI_REPLACESEL, 0, LPARAM(PChar(changetext)));

end;


procedure _FuncTest; cdecl;
begin
  Npp.FuncTest;
end;




procedure THelloWorldPlugin.JsConsoleDock;
begin
  if (not Assigned(jsconsoledlg)) then
      jsconsoledlg := Tjsconsoledlg.Create(self, 1);
  jsconsoledlg.Show;
end;

procedure _JsConsoleDock;
begin
  Npp.JsConsoleDock;
end;


procedure THelloWorldPlugin.JsFunctionCall;
begin
  if (not Assigned(jsfuncdlg)) then
      jsfuncdlg := Tjsfuncdlg.Create(self);
  jsfuncdlg.Show;
end;

procedure _JsFunctionCall; cdecl;
begin
  npp.JsFunctionCall;
end;

procedure THelloWorldPlugin.JsPlugins;
begin

end;

procedure _JsPlugins;
begin
  npp.JsPlugins;
end;

procedure THelloWorldPlugin.Hook;
begin
  if (not Assigned(HookDlg)) then
      HookDlg := THookDlg.Create(self);
  HookDlg.Show;
end;

procedure _Hook;
begin
  Npp.Hook;
end;


procedure THelloWorldPlugin.JsConsole;
var
  p:Tpoint;
begin
  if (not Assigned(consoledlg)) then
      consoledlg := Tconsoleforms.Create(self);
  //consoledlg.currentfile := getCurrentFile;
  //consoledlg.currentpathfile := getCurrentPathFile;
  //Showmessage(getCurrentFile);
  {
  GetWindowRect
  p.X := 0;
  SetWindowPos(consoleforms.Handle, 0, left, value, 0 , 0, SWP_NOZORDER|SWP_NOSIZE);
  }

  consoledlg.Show;
  //setToolbardata();
end;

  {
SendMessage(hNppWnd, NPPM_DMMREGASDCKDLG, 0, (LPARAM) &data);
SendMessage(hNppWnd, NPPM_MODELESSDIALOG, (WPARAM)MODELESSDIALOGADD, (LPARAM)hDlg);
SendMessage(hNppWnd, NPPM_DMMSHOW, 0, (LPARAM) hDlg);
  }
function THelloWorldPlugin.setToolbardata: string;
var
  t : TToolbarData;
  p : ^TToolbarData;
begin
  p^.ClientHandle := consoledlg.Handle;
  p^.Mask := DWS_DF_CONT_BOTTOM; // | NppTbMsg.DWS_ICONTAB | NppTbMsg.DWS_ICONBAR;

  //SendMessage(getCurScintilla(), NPPM_DMMREGASDCKDLG, 0, LPARAM(P));
  SendMessage(getCurScintilla(), NPPM_DMMSHOW, 0, LPARAM(consoledlg.handle));

end;

procedure _JsConsole;
begin
  Npp.JsConsole;
end;

procedure RegisterSchemes(const registrar: ICefSchemeRegistrar); stdcall;
begin
  registrar.AddCustomScheme('local', True, True, False);
end;

function CefWndProc(Wnd: HWND; message: UINT; wParam: Integer; lParam: Integer): Integer; stdcall;
var
  ps: PAINTSTRUCT;
  info: TCefWindowInfo;
  rect: TRect;
  hdwp: THandle;
  x: Integer;
  strPtr: array[0..MAX_URL_LENGTH-1] of WideChar;
  strLen, urloffset: Integer;
begin
  if Wnd = editWnd then
    case message of
    WM_CHAR: ;
      {
      if (wParam = VK_RETURN) then
      begin
        // When the user hits the enter key load the URL
        FillChar(strPtr, SizeOf(strPtr), 0);
        PDWORD(@strPtr)^ := MAX_URL_LENGTH;
        strLen := SendMessageW(Wnd, EM_GETLINE, 0, Integer(@strPtr));
        if (strLen > 0) then
        begin
          strPtr[strLen] := #0;
          brows.MainFrame.LoadUrl(strPtr);
        end;
        Result := 0;
      end else
        Result := CallWindowProc(WNDPROC(editWndOldProc), Wnd, message, wParam, lParam);
    else
      Result := CallWindowProc(WNDPROC(editWndOldProc), Wnd, message, wParam, lParam);
    }
    end else
    case message of
      WM_PAINT:
        begin
          BeginPaint(Wnd, ps);
          EndPaint(Wnd, ps);
          result := 0;
        end;
      WM_CREATE:
        begin
          handl := TCustomClient.Create;
          x := 0;
          GetClientRect(Wnd, rect);

          backWnd := CreateWindowW('BUTTON', 'Back',
                                 WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON
                                 or WS_DISABLED, x, 0, BUTTON_WIDTH, URLBAR_HEIGHT,
                                 Wnd, IDC_NAV_BACK, HInstance, nil);
          Inc(x, BUTTON_WIDTH);

          forwardWnd := CreateWindowW('BUTTON', 'Forward',
                                    WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON
                                    or WS_DISABLED, x, 0, BUTTON_WIDTH,
                                    URLBAR_HEIGHT, Wnd, IDC_NAV_FORWARD,
                                    HInstance, nil);
          Inc(x, BUTTON_WIDTH);

          reloadWnd := CreateWindowW('BUTTON', 'Reload',
                                   WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON
                                   or WS_DISABLED, x, 0, BUTTON_WIDTH,
                                   URLBAR_HEIGHT, Wnd, IDC_NAV_RELOAD,
                                   HInstance, nil);
          Inc(x, BUTTON_WIDTH);

          stopWnd := CreateWindowW('BUTTON', 'Stop',
                                 WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON
                                 or WS_DISABLED, x, 0, BUTTON_WIDTH, URLBAR_HEIGHT,
                                 Wnd, IDC_NAV_STOP, HInstance, nil);
          Inc(x, BUTTON_WIDTH);

          editWnd := CreateWindowW('EDIT', nil,
                                 WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or
                                 ES_AUTOVSCROLL or ES_AUTOHSCROLL or WS_DISABLED,
                                 x, 0, rect.right - BUTTON_WIDTH * 4,
                                 URLBAR_HEIGHT, Wnd, 0, HInstance, nil);

          // Assign the edit window's WNDPROC to this function so that we can
          // capture the enter key
          editWndOldProc := TWindowProc(GetWindowLong(editWnd, GWL_WNDPROC));
          SetWindowLong(editWnd, GWL_WNDPROC, LongInt(@CefWndProc));

          FillChar(info, SizeOf(info), 0);
          Inc(rect.top, URLBAR_HEIGHT);
          info.Style := WS_CHILD or WS_VISIBLE or WS_CLIPCHILDREN or WS_CLIPSIBLINGS or WS_TABSTOP;
          info.parent_window := Wnd;
          info.x := rect.left;
          info.y := rect.top;
          info.Width := rect.right - rect.left;
          info.Height := rect.bottom - rect.top;
          FillChar(setting, sizeof(setting), 0);
          setting.size := SizeOf(setting);

          CefBrowserHostCreate(@info, handl, navigateto, @setting, nil);
          isLoading := False;
          canGoBack := False;
          canGoForward := False;
          SetTimer(Wnd, 1, 100, nil);
          result := 0;
        end;
      WM_TIMER:
        begin
          // Update the status of child windows
          EnableWindow(editWnd, True);
          EnableWindow(backWnd, canGoBack);
          EnableWindow(forwardWnd, canGoForward);
          EnableWindow(reloadWnd, not isLoading);
          EnableWindow(stopWnd, isLoading);
          Result := 0;
        end;
      WM_COMMAND:
        case LOWORD(wParam) of
          IDC_NAV_BACK:
            begin
              brows.GoBack;
              Result := 0;
            end;
          IDC_NAV_FORWARD:
            begin
              brows.GoForward;
              Result := 0;
            end;
          IDC_NAV_RELOAD:
            begin
              brows.Reload;
              Result := 0;
            end;
          IDC_NAV_STOP:
            begin
              brows.StopLoad;
              Result := 0;
            end;
        else
          result := DefWindowProc(Wnd, message, wParam, lParam);
        end;
      WM_DESTROY:
        begin
          brows := nil;
          PostQuitMessage(0);
          result := DefWindowProc(Wnd, message, wParam, lParam);
        end;
      WM_SETFOCUS:
        begin
          //if brows <> nil then
          //  PostMessage(brows.Host.WindowHandle, WM_SETFOCUS, wParam, 0);
          Result := 0;
        end;
      WM_SIZE:
        begin
          if(brows <> nil) then
          begin
            // Resize the browser window and address bar to match the new frame
            // window size
            {
            GetClientRect(Wnd, rect);
            Inc(rect.top, URLBAR_HEIGHT);
            urloffset := rect.left + BUTTON_WIDTH * 4;
            hdwp := BeginDeferWindowPos(1);
         		hdwp := DeferWindowPos(hdwp, editWnd, 0, urloffset, 0, rect.right - urloffset, URLBAR_HEIGHT, SWP_NOZORDER);
            hdwp := DeferWindowPos(hdwp, brows.Host.WindowHandle, 0, rect.left, rect.top,
              rect.right - rect.left, rect.bottom - rect.top, SWP_NOZORDER);
            EndDeferWindowPos(hdwp);
            }
          end;
          result := DefWindowProc(Wnd, message, wParam, lParam);
        end;
      WM_CLOSE:
          result := DefWindowProc(Wnd, message, wParam, lParam);
     else
       result := DefWindowProc(Wnd, message, wParam, lParam);
     end;
end;


procedure THelloWorldPlugin.JsWinConsole;
var
  Msg      : TMsg;
  wndClass : TWndClass;
begin

  CefLogSeverity := LOGSEVERITY_WARNING;

  CefOnRegisterCustomSchemes := @RegisterSchemes;
  
  CefSingleProcess := False; // multi process

  if not CefLoadLibDefault then Exit;

  showmessage(inttostr(GetCefLibHandle));

  CefRegisterSchemeHandlerFactory('local', '', TFileScheme);
try
    showmessage('-1');
    wndClass.style         := CS_HREDRAW or CS_VREDRAW;
    wndClass.lpfnWndProc   := @CefWndProc;
    wndClass.cbClsExtra    := 0;
    wndClass.cbWndExtra    := 0;
    wndClass.hInstance     := hInstance;
    wndClass.hIcon         := LoadIcon(0, IDI_APPLICATION);
    wndClass.hCursor       := LoadCursor(0, IDC_ARROW);
    wndClass.hbrBackground := 0;
    wndClass.lpszMenuName  := nil;
    wndClass.lpszClassName := 'chromium';

    RegisterClass(wndClass);
    showmessage('0');
    Window := CreateWindow(
      'chromium',             // window class name
      'Chromium browser',     // window caption
      WS_OVERLAPPEDWINDOW or WS_CLIPCHILDREN,    // window style
      Integer(CW_USEDEFAULT), // initial x position
      Integer(CW_USEDEFAULT), // initial y position
      Integer(CW_USEDEFAULT), // initial x size
      Integer(CW_USEDEFAULT), // initial y size
      0,                      // parent window handle
      0,                      // window menu handle
      hInstance,              // program instance handle
      nil);                   // creation parameters
    ShowWindow(Window, SW_SHOW);
    UpdateWindow(Window);
    showmessage('2');
    CefRunMessageLoop;    // CEF_MULTI_THREADED_MESSAGE_LOOP
     // single message loop
     {
    while(GetMessageW(msg, 0, 0, 0)) do
    begin
      TranslateMessage(msg);
      DispatchMessageW(msg);
    end;
    }
  finally
    handl := nil;
  end;
end;

procedure _JsWinConsole;
begin
  Npp.JsWinConsole;
end;


procedure THelloWorldPlugin.BeforeDestruction;
begin
  log.WriteLog('THelloWorldPlugin.BeforeDestruction');
  inherited;

end;

destructor THelloWorldPlugin.Destroy;
begin
  log.WriteLog('THelloWorldPlugin.Destroy');
  inherited;

end;

initialization
  Npp := THelloWorldPlugin.Create;
end.
