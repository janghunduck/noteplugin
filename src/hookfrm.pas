unit hookfrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  NppForms,
  StdCtrls,
  NppPlugin, AppEvnts,
  stringworkerplugin,
  cefvcl;

type
  THookDlg = class(TNppForm)
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    ListBox1: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Edit1: TEdit;
    Chromium1: TChromium;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
  private
    PluginDlg : THelloWorldPlugin;
    FWindowHandle: HWND;
    chrom: TChromium;
    pt: TPoint;
    procedure WndProc(var Msg: TMessage); override;
    procedure HookMsg(var msg : TMessage);
    function recttostring(r : Trect): string;
  public
    constructor create( Dlg: THelloWorldPlugin );

  end;

  function MouseHookProc(Code,wParam,lParam:Integer) : Integer; stdcall;
  function KeyboardProc(ncode: integer; wparam: integer; lparam: integer): integer; stdcall;
  function myHookProc(code : Integer; wParam, lParam : LongInt) : LongInt; stdcall;
  function MyShellHook(Code : Integer; wParam : WPARAM; lParam : LPARAM): LongInt; stdcall;
  function GetTitle(WinHandle: HWND): String;
  function enumcall(awin, lparam: longint): Boolean; stdcall;
  
const
  WM_MOUSEHOOKMSG: DWORD = WM_USER+200;
var
  HookDlg: THookDlg;
  keyboardHook : HHook;
  AMouseHook, hook : HHook;
  nppfile : string;
  HShellHook: HHook;
implementation

{$R *.dfm}

{ THookDlg }

constructor THookDlg.create(Dlg: THelloWorldPlugin);
begin
  inherited Create(Dlg);
  PluginDlg := Dlg;
end;

function KeyboardProc(ncode: integer; wparam: integer; lparam: integer): integer; stdcall;
begin
//    if (wParam == WM_KEYDOWN && nCode == HC_ACTION)
//    {
//        Beep(440, 440);
 //       return 0;
 //   }
 //   return CallNextHookEx(keyboardHook, nCode, wParam, lParam);
 //   }
  if (wparam = WM_KEYDOWN) and (ncode = HC_ACTION) then
  begin
    result := 0;
  end;
  result := CallNextHookEx(keyboardHook, nCode, wParam, lParam);
end;

procedure THookDlg.Button1Click(Sender: TObject);
var
  hWindow : THandle;
  hChild : Thandle;
  ProcessId, ThreadId: Longint;
  c_hWindow : THandle;
  c_hChild : THandle;
begin
  hWindow :=  FindWindow('Notepad++', nil);
  c_hWindow := npp.NppData.NppHandle;
  showmessage(inttostr(hWindow) + ' , ' + inttostr(c_hWindow) +' , '+ inttostr(HInstance));

  if (hWindow <> c_hWindow) then exit;

  c_hChild := self.Handle;
  ThreadId := GetWindowThreadProcessId(hWindow, @ProcessId);
  showmessage(inttostr(ThreadId) + ' | ' + inttostr(GetCurrentThreadID));

  hook := SetWindowsHookEx(WH_MOUSE,myHookProc,hInstance,GetCurrentThreadID);
end;

function myHookProc(code : Integer; wParam, lParam : LongInt) : LongInt; stdcall;
var
  X, Y : Integer;
  handle,ch: THandle;
  pStr, pCaption, pClass : pchar;
   TitleLn : integer;
  cap: string;
begin
  X := PMouseHookStruct(lParam).pt.X;
  Y := PMouseHookStruct(lParam).pt.Y;
  HookDlg.pt := point(X,Y);

  // getCursorPos  현재 마우스의 위치 
  handle := WindowFromPoint(HookDlg.pt);
  HookDlg.Caption := inttostr(handle) + ' = ' +IntToStr(X) + ' : ' + IntToStr(Y);


  //HWND ChildWindowFromPoint(HWND hWndParent, POINT Point);
  ch := ChildWindowFromPointEx(handle, HookDlg.pt, CWP_SKIPDISABLED or CWP_SKIPINVISIBLE or CWP_SKIPTRANSPARENT);
  //HookDlg.Memo1.Lines.Add('parent: ' + inttostr(handle) + ' child handle -> ' + inttostr(ch));

  //GetWindowText(handle, pCaption, 255);
  //GetClassName(handle, pClass, 255);
  //HookDlg.Memo1.Lines.Add('pCaption: ' + GetTitle(handle));
  TitleLn := GetWindowTextLength(handle);
  inc(TitleLn);
  SetLength(cap, TitleLn);
  GetWindowText(handle, PChar(cap), TitleLn);
  HookDlg.Caption := HookDlg.Caption + '  | ' + cap;

  SetLength(cap, 255);
  GetClassName(handle, PChar(cap), 255);
  HookDlg.Label1.Caption := cap;

  //ClientToScreen(handle, HookDlg.pt);
  ScreenToClient(handle, HookDlg.pt);
  HookDlg.Label2.Caption  := inttostr(HookDlg.pt.x) + ', ' + inttostr(HookDlg.pt.y);

       
  result := CallNextHookEx(Hook, Code, wParam, lParam);

end;


function GetTitle(WinHandle: HWND): String;
var
  TitleLn : integer;
begin
  Result := '';
  TitleLn := GetWindowTextLength(WinHandle);
  if TitleLn > 0 then
  begin
    // GetWindowText()가 문자열의 맨 끝에 null 문자를 추가하므로 1증가 시킨다
    inc(TitleLn);
    SetLength(Result, TitleLn);
    // 명시한 윈도우 핸들의 title bar를 읽어온다
    GetWindowText(WinHandle, PChar(Result), TitleLn);
  end;
end;

procedure THookDlg.Button2Click(Sender: TObject);
begin
  AMouseHook := SetWindowsHookEx(WH_MOUSE, MouseHookProc,hInstance,GetCurrentThreadID);
end;


procedure THookDlg.WndProc(var Msg: TMessage);
begin

  
  case Msg.Msg of
    WM_DESTROY: begin
      log.WriteLog('THookDlg.WndProc .... WM_DESTROY');
      if AMouseHook <> 0 then UnHookWindowsHookEx(AMouseHook);
      UnHookWindowsHookEx(hook);
    end;

    WM_CREATE: begin
      log.WriteLog('THookDlg.WndProc .... WM_CREATE');
      
    end;
  end;

  inherited WndProc(Msg);
end;

function MouseHookProc(Code,wParam,lParam:Integer) : Integer; stdcall;
var
  iResult : integer;
begin

  if Wparam = WM_LBUTTONUP then begin
    //HookDlg.Memo1.Lines.Add('code=' + inttostr(Code));
    //HookDlg.Memo1.Lines.Add('wparam=' + inttostr(wparam));
    //HookDlg.Memo1.Lines.Add('lparam=' + inttostr(lParam));
    HookDlg.Memo1.Lines.Add(npp.getCurrentPathFileA);   // sendmessage
  end;
  //HookDlg.Memo1.Lines.Add('hook=>' + inttostr(AMouseHook));
  iResult := CallNextHookEx(AMouseHook, Code, wParam, lParam);

  result := iResult;
end;

procedure THookDlg.Button3Click(Sender: TObject);
begin
  HShellHook := SetWindowsHookEx(WH_SHELL, MyShellHook,hInstance,0);

end;

procedure THookDlg.Button4Click(Sender: TObject);
var
  iResult: integer;
begin
  UnhookWindowsHookEx(HShellHook);
end;


function MyShellHook(Code : Integer; wParam : WPARAM; lParam : LPARAM): LongInt; stdcall;
var
  Buff : array [0..255] of Char;
  s : String;
begin
  { 파일에 저장된 훅핸들을 읽어온다. }
  //if HShellHook = 0 then ReadData;

  { 윈도우의 생성과 소멸만 괴롭힌다. 자세한 내용은 도움말을 참조할 것. }
  if (code = HSHELL_WINDOWCREATED) or (code = HSHELL_WINDOWDESTROYED) then
  begin
  { 윈도우의 클래스명을 읽어온다. Code값이 위의 두개의 값일 경우, wParam은 윈도우의 핸들값이 된다. }
    GetClassName(wParam, Buff, SizeOf(Buff));

  { 클래스명이 노트패드라면 메시지박스 보여주기. }

    if Buff = 'Notepad++' then begin
      if (code = HSHELL_WINDOWCREATED) then
        S := '메모장이 실행되는구만요~!'
      else
        S := '메모장이 끝났구만요~!';
      MessageBox(0,PChar(S),'Hook Message',0);
    end;
  end;
  { 다음 훅체인 호출 }
  Result := CallNextHookEx(HShellHook, Code, wParam, lParam);
end;


procedure THookDlg.HookMsg(var msg: TMessage);
begin
  //showmessage('');
end;

procedure THookDlg.FormCreate(Sender: TObject);
begin
  AMouseHook := SetWindowsHookEx(WH_MOUSE, MouseHookProc,hInstance,GetCurrentThreadID);
  hook := SetWindowsHookEx(WH_MOUSE,myHookProc,hInstance,GetCurrentThreadID);
end;

procedure THookDlg.Button5Click(Sender: TObject);
var
  rect: TRect;
  DC: HDC;
  handle: HWND;
begin
  try
    //DC := GetWindowDC(npp.NppData.NppHandle);
    windows.GetWindowRect(npp.NppData.NppHandle, rect);
    //Winapi.Windows.GetClientRect(npp.NppData.NppHandle, rect);

  finally
    //ReleaseDC(Handle, Canvas.Handle);
   
    memo1.Lines.Add(inttostr(rect.Left) + ',' + inttostr(rect.Top));
  end;
end;

procedure THookDlg.Button6Click(Sender: TObject);
var
  rect: TRect;
  DC: HDC;
begin
  try
    //DC := GetWindowDC(npp.NppData.NppHandle);
    windows.GetWindowRect(npp.NppData.ScintillaMainHandle, rect);
    //Winapi.Windows.GetClientRect(npp.NppData.NppHandle, rect);
  finally
    //ReleaseDC(Handle, Canvas.Handle);
    memo1.Lines.Add(inttostr(rect.Left) + ',' + inttostr(rect.Top));
  end;
end;

procedure THookDlg.Button7Click(Sender: TObject);
var
  rect: TRect;
  DC: HDC;
begin
  try
    //DC := GetWindowDC(npp.NppData.NppHandle);
    windows.GetWindowRect(npp.NppData.ScintillaSecondHandle, rect);
    //Winapi.Windows.GetClientRect(npp.NppData.NppHandle, rect);
  finally
    //ReleaseDC(Handle, Canvas.Handle);
    memo1.Lines.Add(inttostr(rect.Left) + ',' + inttostr(rect.Top));
  end;

end;

function THookDlg.recttostring(r: Trect): string;
begin


end;

procedure THookDlg.Button8Click(Sender: TObject);
begin
  //HWND FindWindow(LPCTSTR lpClassName,LPCTSTR lpWIndowName)
end;

procedure THookDlg.Button9Click(Sender: TObject);
begin
  UnHookWindowsHookEx(AMouseHook);

end;

procedure THookDlg.Button10Click(Sender: TObject);
var
  iResult: integer;
begin
  EnumWindows(@enumcall, Integer(ListBox1));
end;

// EnumWindows 를 위한 Callback function
function enumcall(awin, lparam: longint): Boolean; stdcall;
var
  buffer: String;
begin
  buffer := GetTitle(awin);
  if buffer<>'' then
    TListBox(lparam).Items.Add(buffer);
  Result := True;
end;

procedure THookDlg.Button11Click(Sender: TObject);
begin
  UnHookWindowsHookEx(Hook);
end;

procedure THookDlg.Button12Click(Sender: TObject);
var
  linenumber: integer;
  len: integer;
begin
  len := THelloWorldPlugin(Npp).getLineLength();
  memo1.Lines.Add(inttostr(len));
end;

procedure THookDlg.Button13Click(Sender: TObject);
begin
  THelloWorldPlugin(Npp).gotoline(10);
end;

procedure THookDlg.Button14Click(Sender: TObject);
var
   imark: integer;
begin
   imark := THelloWorldPlugin(Npp).getmarker;
   
   if imark = 0 then
      memo1.Lines.Add('책갈피가 없구만. =' + inttostr(imark))
   else
      memo1.Lines.Add('책갈피가 있어요. =' + inttostr(imark));
end;

procedure THookDlg.Button15Click(Sender: TObject);
begin
  THelloWorldPlugin(Npp).markerdefine(strtoint(self.Edit1.Text));   // 17 이상에서 linenumber part에 적용됨
end;

end.
