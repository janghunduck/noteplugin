unit consolefrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  NppPlugin,
  NppForms,
  stringworkerplugin,
  cefvcl;

type
  Tconsoleforms = class(TNppForm)
    devtools: TChromiumDevTools;
    Panel1: TPanel;
    targetedt: TEdit;
    Panel2: TPanel;
    runbtn: TButton;
    slectedrunbtn: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure runbtnClick(Sender: TObject);
    procedure slectedrunbtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure WndProc(var Msg: TMessage); override;
  protected

  public
    chrom: TChromium;
    PluginDlg : THelloWorldPlugin;
    currentfile: string;
    currentpathfile: string;
    NpHandle : THandle;
    DefaultCloseAction: TCloseAction;
    //procedure devtoolshow;
    constructor create( Dlg: THelloWorldPlugin );
 

  end;
  function MouseHookProc(Code,wParam,lParam:Integer) : Integer; stdcall;

var
  consoledlg: Tconsoleforms;
  Ahook : HHook;

implementation

{$R *.dfm}


{
procedure Tconsoleforms.devtoolshow;
var
  info: TCefWindowInfo;
  rect: TRect;
  settings: TCefBrowserSettings;
  icef : ICefClient;
  browser: ICefBrowser;
  inspectElementAt : PCefPoint;
begin
  browser := chrom.Browser;
  if browser = nil then Exit;

  icef := TCefClientOwn.Create as ICefClient;
  
  FillChar(info, SizeOf(info), 0);

  info.parent_window := Handle;
  info.style := WS_CHILD or WS_VISIBLE or WS_CLIPCHILDREN or WS_CLIPSIBLINGS or WS_TABSTOP;
  Rect := GetClientRect;
  info.x := rect.left;
  info.y := rect.top;
  info.Width := rect.right - rect.left;
  info.Height := rect.bottom - rect.top;
  info.window_name := CefString('DevTools');

  //inspectElementAt^.x := rect.left;
  //inspectElementAt^.y := rect.top;


  FillChar(settings, SizeOf(settings), 0);
  settings.size := SizeOf(settings);

  Browser.Host.ShowDevTools(@info, icef, @settings, nil);
end;
}

{
procedure Tconsoleforms.Button3Click(Sender: TObject);
var
 i: integer;
 browser : icefbrowser;
begin
 chrom.Browser.MainFrame.ExecuteJavaScript('alert(''test'');', 'about:blank', 0);
 chrom.Browser.MainFrame.ExecuteJavaScript('console.log("test");', 'about:blank', 0);
end;
}

{
procedure Tconsoleforms.Button4Click(Sender: TObject);
var
  chromdev: TChromiumDevTools;
  tabs: TList;
  icef: ICefClient;
  icefdisplay : ICefDisplayHandler;
  icefrequest : ICefRequestHandler;
begin
  showmessage(inttostr(devtools.Handle));
  showmessage(inttostr(devtools.hndl));

  icef := TCefClientOwn.Create as ICefClient;
  icefdisplay := icef.GetDisplayHandler;



  icef.GetLifeSpanHandler;
  icef.GetLoadHandler;
  icefrequest := icef.GetRequestHandler;
  
  //Browser.Host.ShowDevTools(@info, TCefClientOwn.Create as ICefClient, @settings, inspectElementAt);
end;
}

procedure Tconsoleforms.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  log.WriteLog('Tconsoleforms.FormClose');
  //FreeAndnil(chrom);
  //FreeAndnil(devtools);
  //CefShutDown;
  //UnHookWindowsHookEx(AHook);
  //inherited;

end;


procedure Tconsoleforms.runbtnClick(Sender: TObject);
var
  filename : string;
begin
  filename := PluginDlg.getCurrentPathFileA;
  if fileexists(filename) then
  begin
    targetedt.Text := 'file:///' + filename;
    chrom.Load(targetedt.Text);
    devtools.ShowDevTools(chrom.Browser);
  end else
    chrom.Browser.MainFrame.ExecuteJavaScript(THelloWorldPlugin(Npp).getAllTextA, 'about:blank', 0);

end;

// 선택 영역 실행
procedure Tconsoleforms.slectedrunbtnClick(Sender: TObject);
var
  seltext : string;
begin
  seltext := THelloWorldPlugin(Npp).getSelectedText;
  chrom.Browser.MainFrame.ExecuteJavaScript(seltext, 'about:blank', 0);
end;


constructor Tconsoleforms.create(Dlg: THelloWorldPlugin);
begin
  inherited Create(Dlg);
  PluginDlg := Dlg;
end;

procedure Tconsoleforms.FormCreate(Sender: TObject);
begin
  chrom:= TChromium.Create(nil);
  chrom.Parent := self;
  chrom.Align := alClient;
  chrom.DefaultUrl := 'about:blank';
  chrom.hide;

  { NodePad++ hook start }
  AHook := SetWindowsHookEx(WH_MOUSE, MouseHookProc, hInstance, GetCurrentThreadID);
end;


procedure Tconsoleforms.FormShow(Sender: TObject);
begin
  targetedt.Text := 'file:///' + PluginDlg.getCurrentPathFileA;
  chrom.Load(targetedt.Text);
  devtools.ShowDevTools(chrom.Browser);
end;


procedure Tconsoleforms.WndProc(var Msg: TMessage);
begin

  case Msg.Msg of
    WM_DESTROY: begin
      log.WriteLog('THookDlg.WndProc .... WM_DESTROY Hook end');
      UnHookWindowsHookEx(AHook);
    end;

    WM_CREATE: begin
      //log.WriteLog('THookDlg.WndProc .... WM_CREATE');
      
    end;
  end;
  
  inherited WndProc(Msg);
end;

function MouseHookProc(Code,wParam,lParam:Integer) : Integer; stdcall;
begin
  if Wparam = WM_LBUTTONUP then begin
     consoledlg.targetedt.text := npp.getCurrentPathFileA;   // sendmessage
  end;

  result := CallNextHookEx(AHook, Code, wParam, lParam);
end;


end.
