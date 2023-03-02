unit consolefrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, NppForms, cefvcl, StdCtrls, ExtCtrls, ceflib, NppPlugin, stringworkerplugin;

type
  Tconsoleforms = class(TNppForm)
    devtools: TChromiumDevTools;
    Button3: TButton;
    Button4: TButton;
    runbtn: TButton;
    slectedrunbtn: TButton;
    Panel1: TPanel;
    targetedt: TEdit;
    runtextbtn: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure runbtnClick(Sender: TObject);
    procedure slectedrunbtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure runtextbtnClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure RegisterForm();
    procedure UnregisterForm();
    procedure DoClose(var Action: TCloseAction); override;
    function WantChildKey(Child: TControl; var Message: TMessage): Boolean; override;
  public
    chrom: TChromium;
    PluginDlg : THelloWorldPlugin;
    currentfile: string;
    currentpathfile: string;
    NpHandle : THandle;
    DefaultCloseAction: TCloseAction;
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    procedure devtoolshow;
    constructor create( Dlg: THelloWorldPlugin );
    destructor Destroy; override;

  end;

var
  consoleforms: Tconsoleforms;


implementation

{$R *.dfm}


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


procedure Tconsoleforms.Button3Click(Sender: TObject);
var
 i: integer;
 browser : icefbrowser;
begin
 chrom.Browser.MainFrame.ExecuteJavaScript('alert(''test'');', 'about:blank', 0);
 chrom.Browser.MainFrame.ExecuteJavaScript('console.log("test");', 'about:blank', 0);
end;

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


procedure Tconsoleforms.CreateWindowHandle(const Params: TCreateParams);
begin
  inherited;

end;

destructor Tconsoleforms.Destroy;
begin
  if (self.HandleAllocated) then
  begin
    self.UnregisterForm();
  end;

  inherited;
end;

procedure Tconsoleforms.DoClose(var Action: TCloseAction);
begin
  if (self.DefaultCloseAction <> caNone) then Action := self.DefaultCloseAction;
  inherited;
end;

procedure Tconsoleforms.RegisterForm;
var
  r: Integer;
begin
  r:=SendMessage(self.Npp.NppData.NppHandle, NPPM_MODELESSDIALOG, MODELESSDIALOGADD, self.Handle);

end;

procedure Tconsoleforms.UnregisterForm;
var
  r: Integer;
begin

  if (not self.HandleAllocated) then exit;
  r:=SendMessage(self.Npp.NppData.NppHandle, NPPM_MODELESSDIALOG, MODELESSDIALOGREMOVE, self.Handle);

end;



procedure Tconsoleforms.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin

  //FreeAndnil(chrom);
  //FreeAndnil(devtools);
  //CefShutDown;
  inherited;

end;

function Tconsoleforms.WantChildKey(Child: TControl;
  var Message: TMessage): Boolean;
begin
  Result := Child.Perform(CN_BASE + Message.Msg, Message.WParam, Message.LParam) <> 0;
end;

procedure Tconsoleforms.runbtnClick(Sender: TObject);
begin
  targetedt.Text := 'file:///' + PluginDlg.getCurrentPathFileA;
  chrom.Load(targetedt.Text);
  devtools.ShowDevTools(chrom.Browser);
  //
end;

// 선택 영역 실행
procedure Tconsoleforms.slectedrunbtnClick(Sender: TObject);
var
  seltext : string;
begin
  seltext := THelloWorldPlugin(Npp).getSelectedText;
  chrom.Browser.MainFrame.ExecuteJavaScript(seltext, 'about:blank', 0);
end;

procedure Tconsoleforms.FormCreate(Sender: TObject);
begin
  chrom:= TChromium.Create(nil);
  chrom.Parent := self;
  chrom.Align := alClient;
  chrom.DefaultUrl := 'about:blank';
  chrom.hide;
end;

procedure Tconsoleforms.FormShow(Sender: TObject);
begin
  targetedt.Text := 'file:///' + PluginDlg.getCurrentPathFileA;
  chrom.Load(targetedt.Text);
  devtools.ShowDevTools(chrom.Browser);
end;



constructor Tconsoleforms.create(Dlg: THelloWorldPlugin);
begin
  inherited Create(Dlg);
  PluginDlg := Dlg;
end;

procedure Tconsoleforms.runtextbtnClick(Sender: TObject);
begin
  chrom.Browser.MainFrame.ExecuteJavaScript(THelloWorldPlugin(Npp).getAllTextA, 'about:blank', 0);
end;

end.
