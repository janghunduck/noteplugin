unit stringworkerplugin;

interface

uses
  Dialogs, NppPlugin, SysUtils, Windows, Classes, SciSupport, AboutForms, HelloWorldDockingForms,
  kefreeutil;

type
  THelloWorldPlugin = class(TNppPlugin)
  private
    function sendScintilla(hCurrScintilla: THandle; msg: LongWord; wParam:integer; lParam:integer): integer; overload;
    function sendScintilla(hCurrScintilla: THandle; msg: LongWord): integer; overload;
    function sendScintilla(hCurrScintilla: THandle; msg: LongWord; wParam:integer):Integer; overload;
    function sendScintilla(msg: LongWord):Integer; overload;

    function getCurScintilla(): Thandle;
    function getSelectedText(): string;
    function getLineCount(): integer;
    function getLineLength(linenumber: integer): integer;
  public
    constructor Create;
    procedure FuncHelloWorld;
    procedure FuncHelloWorldDocking;
    procedure FuncAbout;
    procedure DoNppnToolbarModification; override;

    procedure FuncDoubleQuotToSingle;
    procedure FuncConbineQQPlusCR;
    procedure SlashComment;
    procedure SlashCommentRemove;
    procedure FuncTest;


  end;

procedure _FuncHelloWorld; cdecl;
procedure _FuncHelloWorldDocking; cdecl;
procedure _FuncAbout; cdecl;
procedure _FuncConbineQQPlusCR; cdecl;
procedure _SlashComment; cdecl;
procedure _SlashCommentRemove; cdecl;

procedure _FuncDoubleQuotToSingle; cdecl;
procedure _FuncTest; cdecl;


var
  Npp: THelloWorldPlugin;

implementation

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
  self.AddFuncItem('QQ to Quot', _FuncDoubleQuotToSingle);
  self.AddFuncItem('Conbination QQuot and CR', _FuncConbineQQPlusCR);
  self.AddFuncItem('// Comment ', _SlashComment);
  self.AddFuncItem('Comment Revmove ', _SlashCommentRemove);


  self.AddFuncItem('all test : Replace Hello World', _FuncHelloWorld);
  self.AddFuncItem('About', _FuncAbout);
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

function THelloWorldPlugin.getSelectedText(): string;
var
  hCurrScintilla: THandle;
  bufLength: integer;
  
begin
  hCurrScintilla := getCurScintilla();
  bufLength := sendScintilla(hCurrScintilla, SCI_GETSELTEXT);
  setlength(result, bufLength);
  sendScintilla(hCurrScintilla, SCI_GETSELTEXT, 0, LPARAM(PChar(result)));
  //if result = nil then result := '';
end;

function THelloWorldPlugin.getLineCount(): integer;
begin
  Result := sendScintilla(SCI_GETLINECOUNT);
end;

function THelloWorldPlugin.getLineLength(linenumber: integer): integer;
begin
  result := sendScintilla(SCI_LINELENGTH, WPARAM(PChar(linenumber)));
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
  showmessage('selected text = [' + getSelectedText() + ']');
  showmessage('line count= [' + inttostr(getLineCount()) + ']');
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
  //s := 'Hello World';
  //SendMessage(self.NppData.ScintillaMainHandle, SCI_REPLACESEL, 0, LPARAM(PChar(s)));
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
  if (not Assigned(HelloWorldDockingForm)) then HelloWorldDockingForm := THelloWorldDockingForm.Create(self, 1);
  HelloWorldDockingForm.Show;
end;

procedure THelloWorldPlugin.DoNppnToolbarModification;
var
  tb: TToolbarIcons;
begin
  tb.ToolbarIcon := 0;
  tb.ToolbarBmp := LoadImage(Hinstance, 'IDB_TB_TEST', IMAGE_BITMAP, 0, 0, (LR_DEFAULTSIZE or LR_LOADMAP3DCOLORS));
  SendMessage(self.NppData.NppHandle, NPPM_ADDTOOLBARICON, WPARAM(self.CmdIdFromDlgId(1)), LPARAM(@tb));
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




initialization
  Npp := THelloWorldPlugin.Create;
end.
