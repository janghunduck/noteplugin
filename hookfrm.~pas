unit hookfrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, NppForms, stringworkerplugin, StdCtrls, NppPlugin;

type
  THookDlg = class(TNppForm)
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    PluginDlg : THelloWorldPlugin;
    FWindowHandle: HWND;
    

    procedure WndProc(var Msg: TMessage); override;
    procedure HookMsg(var msg : TMessage);
  public
    constructor create( Dlg: THelloWorldPlugin );
  end;

  function MouseHookProc(nCode,wParam,lParam:Integer) : Integer; stdcall;
  //LRESULT CALLBACK KeyboardProc(int nCode, WPARAM wParam, LPARAM lParam)
  function KeyboardProc(ncode: integer; wparam: integer; lparam: integer): integer; stdcall;
  function myHookProc(code : Integer; wParam, lParam : LongInt) : LongInt; stdcall;

const
  WM_MOUSEHOOKMSG: DWORD = WM_USER+200;
var
  HookDlg: THookDlg;
  keyboardHook : HHook;
  AMouseHook, hook : HHook;
  nppfile : string;
  
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
  showmessage(inttostr(ThreadId));

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
  HookDlg.Caption := IntToStr(X) + ' : ' + IntToStr(Y);
  result := CallNextHookEx(Hook, Code, wParam, lParam);
end;


procedure THookDlg.Button2Click(Sender: TObject);
begin
  AMouseHook := SetWindowsHookEx(WH_MOUSE,MouseHookProc,hInstance,GetCurrentThreadID);
  if AMouseHook = 0 then
    showmessage('hook fail...')
  else begin
    memo1.Lines.Add('ok');
  end;
end;

function MouseHookProc(nCode,wParam,lParam:Integer) : Integer; stdcall;
var
  iResult : integer;
begin
  
  if nCode < 0 then begin
    HookDlg.Memo1.Lines.Add('fail xxxxx');
    Result := CallNextHookEx(AMouseHook,nCode,wParam,lParam);
  end else
    if (Wparam = wm_RButtonUp) then
    begin
      //HookDlg.Memo1.Lines.Add(npp.getCurrentPathFileA);   // sendmessage
      Result := 1;
    end else if Wparam = WM_LBUTTONUP then begin    // 씨팔 좈카, 이거네 왜 이름을 업으로 했냐 짜가냐
      HookDlg.Memo1.Lines.Add('WM_LBUTTONUP');
      HookDlg.Memo1.Lines.Add(npp.getCurrentPathFileA);   // sendmessage
      UnHookWindowsHookEx(AMouseHook);
    end else if Wparam = wm_LButtonDown then begin
      //HookDlg.Memo1.Lines.Add('Left button down');
      //HookDlg.Memo1.Lines.Add(nppfile);   // sendmessage
      //HookDlg.Memo1.Lines.Add(npp.getCurrentPathFileA);   // sendmessage
     // UnHookWindowsHookEx(AMouseHook);
    end else if wparam = WM_NCLBUTTONDOWN then
    begin
      HookDlg.Memo1.Lines.Add('wparam = WM_NCLBUTTONDOWN');
    end else begin
      //HookDlg.Memo1.Lines.Add('0');
      Result := 0
    end;

end;

procedure THookDlg.WndProc(var Msg: TMessage);
begin
  inherited;
   {
  if Msg.WParam = wm_RButtonup then
  begin
    showmessage('');
  end;

  FWindowHandle := npp.NppData.NppHandle;
  
  if Msg.Msg = WM_MOUSEHOOKMSG then
  begin
     showmessage('a');
     try
       HookMsg(Msg);
     except
       Application.HandleException(Self);
     end
  end else begin
    //showmessage('b');
    //Msg.Result := DefWindowProc(FWindowHandle, Msg.Msg, Msg.WParam, Msg.LParam);
    
  end;

  //Hook:=SetWindowsHookEx(WH_MOUSE,@MouseHookProc,HInstance,0);
  //Hook:=SetWindowsHookEx(WH_MOUSE, @MouseHookProc, npp.NppData.NppHandle, self.handle);
  Hook:=SetWindowsHookEx(WH_MOUSE, @MouseHookProc, hInstance, GetCurrentThreadID);
  }
  AMouseHook:=SetWindowsHookEx(WH_MOUSE, MouseHookProc, hInstance, GetCurrentThreadID);
  
  if AMouseHook = 0 then
  begin

  end else begin

  end;
end;

procedure THookDlg.HookMsg(var msg: TMessage);
begin
  //showmessage('');
end;

procedure THookDlg.FormCreate(Sender: TObject);
begin
  //FWindowHandle := Classes.AllocateHWnd(WndProc);
end;







end.
