unit jsconsoleforms;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  NppPlugin,
  NppPluginForms,
  cefvcl,
  ceflib, Vcl.Buttons, Vcl.Menus;

const
  CEFMSG_FUNCTION_CALL = 'CEFMSG_FUNCTION_CALL';      // 현재 열린문서에서 함수를 호출
  jsloadfile = 'file:///D:/git/noteplugin/_x64/src/js/funccall.html';
  CEFMSG_FUNCTION_CALL_NA = 'CEFMSG_FUNCTION_CALL_NA';      // 현재 열린문서에서 함수를 호출

type
  Tconsoleforms = class(TNppPluginForm)
    Panel1: TPanel;
    targetedt: TEdit;
    PanelRun: TPanel;
    btnrun: TButton;
    btnselectedrun: TButton;
    btnclose: TButton;
    DevTools: TChromiumDevTools;
    btnfunccall: TButton;
    edtfunc: TEdit;
    PopupFuncMenu: TPopupMenu;
    BitBtnfunclist: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnrunClick(Sender: TObject);
    procedure btnselectedrunClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnfunccallClick(Sender: TObject);
    procedure btncloseClick(Sender: TObject);
    procedure BitBtnfunclistClick(Sender: TObject);
  private
    chrom: TChromium;
    pt: TPoint;


    procedure WndProc(var Msg: TMessage); override;
    procedure ChromLoad();
    procedure OnRenderMsgReceived(Sender: TObject; const browser: ICefBrowser; sourceProcess: TCefProcessId;
                                    const message: ICefProcessMessage; out Result: Boolean);
  public
    { Public declarations }
  end;

  TCustomRenderProcessHandler = class(TCefRenderProcessHandlerOwn)
     protected
       function OnProcessMessageReceived(const browser: ICefBrowser;sourceProcess: TCefProcessId; const message: ICefProcessMessage): Boolean; override;
  end;

  function MouseHookProc(Code,wParam,lParam:Integer) : Integer; stdcall;

var
  consoleforms: Tconsoleforms;
  MouseHook : HHook;

implementation

{$R *.dfm}

uses stringworkerplugin, jsfunction;


function MouseHookProc(Code,wParam,lParam:Integer) : Integer; stdcall;
var
  X, Y : Integer;
  handle : THandle;
  clsname : string;
begin
  //X := PMouseHookStruct(lParam).pt.X;
  //Y := PMouseHookStruct(lParam).pt.Y;
  //consoleforms.pt := point(X,Y);
  //consoleforms.Caption := inttostr(consoleforms.pt.x) + ',' + inttostr(consoleforms.pt.y);
  if Wparam = WM_LBUTTONUP then begin
     consoleforms.targetedt.text := npp.getCurrentPathFileA;   // sendmessage
     {
     consoleforms.ChromLoad;
     // 포커스를 에디터에 돌려줘야 한다.
      }
     {
     handle := WindowFromPoint(consoledlg.pt);
     SetLength(clsname, 255);
     GetClassName(handle, PChar(clsname), 255);
     //consoledlg.Caption := consoledlg.Caption + ' [' + trim(clsname) + ']';
     //consoledlg.Caption := consoledlg.Caption + ' [' + PChar(clsname) + ']';

     if (PChar(clsname) = 'SysTabControl32') then
       //consoledlg.targetedt.text := npp.getCurrentPathFileA   // sendmessage
     else if (PChar(clsname) = 'Scintilla') then
     begin
       ScreenToClient(handle, consoledlg.pt);
       consoledlg.Caption :=  inttostr(consoledlg.pt.x) + ', ' + inttostr(consoledlg.pt.y);
       // linebar 영역
       // 책갈피 영역
       if (consoledlg.pt.x > 28) and (consoledlg.pt.x < 45) then
       begin
         consoledlg.Caption := inttostr(npp.getCurrlineNumberA) + ' 책갈피 영역입니다.';

       end;
     end;
     }
  end;

  result := CallNextHookEx(MouseHook, Code, wParam, lParam);
end;

procedure Tconsoleforms.Button1Click(Sender: TObject);
begin
  Npp.test;
end;

procedure Tconsoleforms.ChromLoad;
begin
  targetedt.Text := 'file:///' + Npp.getCurrentPathFileA;
  chrom.Load(targetedt.Text);
  devtools.ShowDevTools(chrom.Browser);
end;

procedure Tconsoleforms.FormCreate(Sender: TObject);
begin
  chrom:= TChromium.Create(nil);
  chrom.Parent := self;
  chrom.Align := alClient;    // alNone ?
  chrom.DefaultUrl := 'about:blank';
  chrom.hide;

  chrom.OnProcessMessageReceived := OnRenderMsgReceived;

  { NodePad++ hook start }
  MouseHook := SetWindowsHookEx(WH_MOUSE, @MouseHookProc, hInstance, GetCurrentThreadID);
end;

procedure Tconsoleforms.FormShow(Sender: TObject);
begin
  ChromLoad;
end;

procedure Tconsoleforms.OnRenderMsgReceived(Sender: TObject;
  const browser: ICefBrowser; sourceProcess: TCefProcessId;
  const message: ICefProcessMessage; out Result: Boolean);
var
  resultstr: string;
begin
  if (message.Name = CEFMSG_FUNCTION_CALL) then
  begin

    //chrom.Browser.MainFrame.ExecuteJavaScript('console.log("aaa \n aaaa");', '', 0);

    resultstr := 'console.log("' +
                 message.ArgumentList.GetString(0) +
                 '");';
    chrom.Browser.MainFrame.ExecuteJavaScript(resultstr, 'notepad++', 0);
  end;

  Result := True;
end;

procedure Tconsoleforms.BitBtnfunclistClick(Sender: TObject);
const
  funcname = 'functionlist';
var
  jsfunc : TjsFunctionCall;
  sResult : string;
begin
  // 1.
  // function func_list 를 로드 시키기 위해 jsparser.html 를 chrom에 로드시켜야 한다.
  // 끝나고는 OnRenderMsgReceived 에서 다시 targetedt.Text를 로드해 주어야 한다.
  // chrom.Load(jsparser.html);
  // devtools.ShowDevTools(chrom.Browser);

  // jsparser.js 로딩, function list를 받는다.
  // function 리스트를 popup menu 에 동적 할당한다.
  jsfunc := TjsFunctionCall.create(self, jsloadfile);
  jsfunc.functionCall(CEFMSG_FUNCTION_CALL_NA, funcname);
  sResult := jsfunc.getResult;

  // 2.
  // 기냥 pascal 로 파싱하는 걸로,

end;

procedure Tconsoleforms.btncloseClick(Sender: TObject);
begin
  close;
end;

procedure Tconsoleforms.btnfunccallClick(Sender: TObject);
var
  cefmsg: ICefProcessMessage;
  funcPos: PChar;
  funcparams  : TStringlist;
  funcname : string;
  token: string;
  i : integer;
  isRecived: boolean;

  procedure AddOne;
  begin
    token := token + funcPos^;
    Inc(funcPos);
  end;
begin
  // 처음 에디터에 클릭하고 바로 실행하면 안됨, 해당문서가 한번은 로드 되어야 함.
  // 문서를 수정후 다시 호출하면 실시간으로 변경사항이 적용되지 않으니 저장후 문서 전체를 다시 로딩해야 한다.
  // 아니면 함수 부분의 선택한 후 선택된 함수를 parsing 해서 처리한다.
  //chrom.Load(targetedt.Text);
  // ab('10'); parsing
  if edtfunc.Text = '' then exit;

  funcPos := Pchar(edtfunc.Text + #0);
  funcparams  := TStringlist.Create;

  repeat
    case funcPos^ of
       'A'..'Z', 'a'..'z', '0'..'9', '_', '@':
         begin
           AddOne;
           while funcPos^ in ['A'..'Z', 'a'..'z', '0'..'9', '_', '@'] do AddOne;
         end;
       '(' :
         begin
           funcname := token;
           token := '';
           Inc(funcPos);
         end;
       '''', '"' :
         begin
           if token <> '' then
           begin
             funcparams.Add(token);
             token := '';
           end;
           inc(funcPos);
         end;
       ',' :
         begin
           inc(funcPos);
         end;
     else
       inc(funcPos);
     end;
  until (funcPos^ in [#0]);

  {
  showmessage('function na: ' + funcname);
  for i:=0 to funcparams.Count -1 do
  begin
    showmessage('parsms: ' + funcparams[i]);
  end;
  }
  // send renderer
  cefmsg := TCefProcessMessageRef.New(CEFMSG_FUNCTION_CALL);
  cefmsg.ArgumentList.SetString(0, funcname);                   // function name
  for i:=0 to funcparams.Count -1 do
    cefmsg.ArgumentList.SetString(i+1, funcparams.Strings[i]);  // args
  isRecived := chrom.browser.SendProcessMessage(PID_RENDERER,cefmsg);

end;

procedure Tconsoleforms.btnrunClick(Sender: TObject);
var
  filename : string;
begin
  filename := Npp.getCurrentPathFileA;
  if fileexists(filename) then
  begin
    targetedt.Text := 'file:///' + filename;
    chrom.Load(targetedt.Text);
    devtools.ShowDevTools(chrom.Browser);
  end else begin// not saved doc ex, new 1 new 2 .....
    //showmessage(Npp.getAllTextA);
    chrom.Browser.MainFrame.ExecuteJavaScript(Npp.getAllTextutf8, 'notepad++', 0);
  end;

end;

procedure Tconsoleforms.btnselectedrunClick(Sender: TObject);
var
  seltext : string;
begin
  seltext := Npp.getSelectedText;
  //showmessage(seltext);
  chrom.Browser.MainFrame.ExecuteJavaScript(seltext, 'notepad++', 0);
end;

procedure Tconsoleforms.WndProc(var Msg: TMessage);
begin

  case Msg.Msg of
    WM_DESTROY: begin
      log.WriteLog('THookDlg.WndProc .... WM_DESTROY Hook end');
      UnHookWindowsHookEx(MouseHook);
      FreeAndnil(chrom);
      //FreeAndnil(devtools);
      //CefShutDown;
    end;

    WM_CREATE: begin
      //log.WriteLog('THookDlg.WndProc .... WM_CREATE');

    end;
  end;

  inherited WndProc(Msg);
end;

{ TCustomRenderProcessHandler }

function TCustomRenderProcessHandler.OnProcessMessageReceived(
  const browser: ICefBrowser; sourceProcess: TCefProcessId;
  const message: ICefProcessMessage): Boolean;
var
  gobj, jsfunc, arg, retval : ICefv8Value;
  context: ICefv8Context;
  args : TCefv8ValueArray;
  msg: ICefProcessMessage;
  isRecived: boolean;
  i : integer;
begin

  if (message.Name = CEFMSG_FUNCTION_CALL) then
  begin
    context := browser.MainFrame.GetV8Context;
    context.Enter;
    //context.Eval()

    gobj := context.GetGlobal;
    jsfunc := gobj.GetValueByKey(message.ArgumentList.GetString(0));  // function name

    if jsfunc = nil then
    begin
      showmessage('jsfunc = nil');
      context.Exit;
    end;

    setlength(args, message.ArgumentList.GetSize-1);
    for i:=1 to message.ArgumentList.GetSize-1 do
    begin
      arg := TCefv8ValueRef.NewString(message.ArgumentList.GetString(i));
      args[i-1] := arg;
    end;
    retval := jsfunc.ExecuteFunction(nil,args);

    context.Exit;

    // retval 의 형 확인이 필요함.

    //  send browser
    if retval <> nil then
    begin
      msg := TCefProcessMessageRef.New(message.Name);
      msg.ArgumentList.SetString(0, retval.GetStringValue);
      log.WriteLog('return string : ' + retval.GetStringValue);
      isRecived := browser.SendProcessMessage(PID_BROWSER, msg);
    end else
      showmessage('function not exist!');
  end;
end;

initialization
  CefRenderProcessHandler := TCustomRenderProcessHandler.Create;


end.
