unit jsfunction;

{ --------------------------------------------------
 내부적으로만 사용되는 chrome
----------------------------------------------------}
interface

uses
  vcl.Controls,
  cefvcl,
  ceflib,
  jsconsoleforms;


type
  TjsFunctionCall = class
  private
    m_owner : Tconsoleforms;
    m_chrom: TChromium;
    m_devtools : TChromiumDevTools;
    m_msgname : string;
    m_result : string;

    procedure OnRenderMsgReceived(Sender: TObject; const browser: ICefBrowser; sourceProcess: TCefProcessId;
                                    const message: ICefProcessMessage; out Result: Boolean);
  public
    procedure functionCall(msgname,functionname: string);
    function getResult(): string;
    constructor create(owner: Tconsoleforms; loadfilename:string);
  end;

  TjsRenderProcessHandler = class(TCefRenderProcessHandlerOwn)
     protected
       function OnProcessMessageReceived(const browser: ICefBrowser;sourceProcess: TCefProcessId; const message: ICefProcessMessage): Boolean; override;
  end;

var
  jsCefRenderProcessHandler: ICefRenderProcessHandler = nil;

implementation

{ TFunctionCall }

constructor TjsFunctionCall.create(owner: Tconsoleforms; loadfilename:string);
begin
  m_owner := owner;
  m_chrom:= TChromium.Create(nil);
  m_chrom.Parent := m_owner;
  m_chrom.Align := alNone;
  m_chrom.DefaultUrl := 'about:blank';
  m_chrom.hide;
  m_chrom.OnProcessMessageReceived := OnRenderMsgReceived;

  m_chrom.Load(loadfilename);

  m_devtools := TChromiumDevTools.Create(nil);
  m_devtools.Visible := false;
  m_devtools.ShowDevTools(m_chrom.Browser);

  //
end;

{

PCefPoint -> x,y

procedure TCustomChromium.ShowDevTools(inspectElementAt: PCefPoint);
var
  info: TCefWindowInfo;
  settings: TCefBrowserSettings;
begin
  if (FBrowser = nil) then Exit;

  FillChar(info, SizeOf(info), 0);
  info.style := WS_OVERLAPPEDWINDOW or WS_CLIPCHILDREN or WS_CLIPSIBLINGS or WS_VISIBLE;
  info.parent_window := FBrowser.Host.WindowHandle;
  info.x := Integer(CW_USEDEFAULT);
  info.y := Integer(CW_USEDEFAULT);
  info.width := Integer(CW_USEDEFAULT);
  info.height := Integer(CW_USEDEFAULT);
  info.window_name := CefString('DevTools');

  FillChar(settings, SizeOf(settings), 0);
  settings.size := SizeOf(settings);
  FBrowser.Host.ShowDevTools(@info, TCefClientOwn.Create as ICefClient, @settings, inspectElementAt);
end;
}

procedure TjsFunctionCall.functionCall(msgname,functionname: string);
var
  cefmsg: ICefProcessMessage;
  isRecived: boolean;
begin
  m_msgname := msgname;
  cefmsg := TCefProcessMessageRef.New(m_msgname);
  cefmsg.ArgumentList.SetString(0, functionname);
  isRecived := m_chrom.browser.SendProcessMessage(PID_RENDERER,cefmsg);
end;

function TjsFunctionCall.getResult: string;
begin
  if m_result <> '' then
    result := self.m_result;
end;

procedure TjsFunctionCall.OnRenderMsgReceived(Sender: TObject;
  const browser: ICefBrowser; sourceProcess: TCefProcessId;
  const message: ICefProcessMessage; out Result: Boolean);
begin
  if (message.Name = m_msgname) then
  begin
    m_result := message.ArgumentList.GetString(0);
  end;

  Result := True;
end;

{ TjsRenderProcessHandler }

function TjsRenderProcessHandler.OnProcessMessageReceived(
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
    if jsfunc = nil then context.Exit;

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
    msg := TCefProcessMessageRef.New(message.Name);
    msg.ArgumentList.SetString(0, retval.GetStringValue);
    isRecived := browser.SendProcessMessage(PID_BROWSER, msg);

  end;
end;



initialization
  jsCefRenderProcessHandler := TjsRenderProcessHandler.Create;


end.
