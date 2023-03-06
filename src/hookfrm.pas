unit hookfrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, NppForms, stringworkerplugin, StdCtrls, NppPlugin, AppEvnts,
  cefvcl;

type
  THookDlg = class(TNppForm)
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    ApplicationEvents1: TApplicationEvents;
    ChromiumDevTools1: TChromiumDevTools;
    Chromium1: TChromium;
    Button3: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ApplicationEvents1Message(var Msg: tagMSG;
      var Handled: Boolean);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    PluginDlg : THelloWorldPlugin;
    FWindowHandle: HWND;
    chrom: TChromium;

    procedure WndProc(var Msg: TMessage); override;
    procedure HookMsg(var msg : TMessage);
  public
    constructor create( Dlg: THelloWorldPlugin );
  end;

  function MouseHookProc(Code,wParam,lParam:Integer) : Integer; stdcall;
  function KeyboardProc(ncode: integer; wparam: integer; lparam: integer): integer; stdcall;
  function myHookProc(code : Integer; wParam, lParam : LongInt) : LongInt; stdcall;
  function MyShellHook(Code : Integer; wParam : WPARAM; lParam : LPARAM): LongInt; stdcall;
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

  AMouseHook := SetWindowsHookEx(WH_MOUSE,myHookProc,hInstance,GetCurrentThreadID);
  if AMouseHook = 0 then
    showmessage('hook fail...')
  else
    memo1.Lines.Add('ok');
end;

function myHookProc(code : Integer; wParam, lParam : LongInt) : LongInt; stdcall;
var
  X, Y : Integer;
begin
  X := PMouseHookStruct(lParam).pt.X;
  Y := PMouseHookStruct(lParam).pt.Y;
  HookDlg.Caption := inttostr(code) + ' = ' +IntToStr(X) + ' : ' + IntToStr(Y);
  result := CallNextHookEx(Hook, Code, wParam, lParam);
end;


procedure THookDlg.Button2Click(Sender: TObject);
begin
  AMouseHook := SetWindowsHookEx(WH_MOUSE, MouseHookProc,hInstance,GetCurrentThreadID);

  if AMouseHook = 0 then
    //UnHookWindowsHookEx(AMouseHook)
    //AMouseHook := SetWindowsHookEx(WH_MOUSE, MouseHookProc,hInstance,GetCurrentThreadID)
  else begin
    memo1.Lines.Add(inttostr(AMouseHook));
    //UnHookWindowsHookEx(AMouseHook);
    //AMouseHook := 0;
  end;
end;


procedure THookDlg.WndProc(var Msg: TMessage);
begin

  
  case Msg.Msg of
    WM_DESTROY: begin
      log.WriteLog('THookDlg.WndProc .... WM_DESTROY');
      UnHookWindowsHookEx(AMouseHook);
    end;

    WM_CREATE: begin
      log.WriteLog('THookDlg.WndProc .... WM_CREATE');
      
    end;
  end;
  //AMouseHook := SetWindowsHookEx(WH_MOUSE, MouseHookProc,hInstance,GetCurrentThreadID);
  {
  AMouseHook := SetWindowsHookEx(WH_MOUSE, MouseHookProc,hInstance,GetCurrentThreadID);

  if AMouseHook = 0 then
    //UnHookWindowsHookEx(AMouseHook)
    //AMouseHook := SetWindowsHookEx(WH_MOUSE, MouseHookProc,hInstance,GetCurrentThreadID)
  else begin
    //memo1.Lines.Add(inttostr(AMouseHook));
    //UnHookWindowsHookEx(AMouseHook);
    //AMouseHook := 0;
  end;
  }
  inherited WndProc(Msg);
end;

function MouseHookProc(Code,wParam,lParam:Integer) : Integer; stdcall;
var
  iResult : integer;
begin

  if Wparam = WM_LBUTTONUP then begin
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
  //try
  {
  chrom:= TChromium.Create(nil);
  chrom.Parent := self;
  chrom.Align := alClient;
  chrom.DefaultUrl := 'about:blank';
  chrom.hide;
  }
end;

procedure THookDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //  UnHookWindowsHookEx(AMouseHook);

end;



procedure THookDlg.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
begin
   memo1.Lines.Add(pchar(msg.lParam));
   if msg.wParam = WM_LBUTTONUP then begin
      memo1.Lines.Add('sssssss');
   end;
end;




end.
