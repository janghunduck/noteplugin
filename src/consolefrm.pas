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
    btnclose: TButton;
    procedure runbtnClick(Sender: TObject);
    procedure slectedrunbtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btncloseClick(Sender: TObject);
  private
    procedure WndProc(var Msg: TMessage); override;
  protected

  public
    chrom: TChromium;
    PluginDlg : THelloWorldPlugin;
    pt: TPoint;

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
  MouseHook : HHook;

implementation

{$R *.dfm}

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

function MouseHookProc(Code,wParam,lParam:Integer) : Integer; stdcall;
var
  X, Y : Integer;
  handle : THandle;
  clsname : string;
begin
  X := PMouseHookStruct(lParam).pt.X;
  Y := PMouseHookStruct(lParam).pt.Y;
  consoledlg.pt := point(X,Y);
  
  if Wparam = WM_LBUTTONUP then begin
     consoledlg.targetedt.text := npp.getCurrentPathFileA;   // sendmessage

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
       // linebar ???? 
       // ?????? ????
       if (consoledlg.pt.x > 28) and (consoledlg.pt.x < 45) then
       begin
         consoledlg.Caption := inttostr(npp.getCurrlineNumberA) + ' ?????? ??????????.';
       
       end;
     end;
     }
  end;

  result := CallNextHookEx(MouseHook, Code, wParam, lParam);
end;

procedure Tconsoleforms.FormCreate(Sender: TObject);
begin
  chrom:= TChromium.Create(nil);
  chrom.Parent := self;
  chrom.Align := alClient;
  chrom.DefaultUrl := 'about:blank';
  chrom.hide;

  { NodePad++ hook start }
  MouseHook := SetWindowsHookEx(WH_MOUSE, MouseHookProc, hInstance, GetCurrentThreadID);
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
      //FreeAndnil(chrom);
      //FreeAndnil(devtools);
      //CefShutDown;
      UnHookWindowsHookEx(MouseHook);

    end;

    WM_CREATE: begin
      //log.WriteLog('THookDlg.WndProc .... WM_CREATE');
      
    end;
  end;
  
  inherited WndProc(Msg);
end;



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


procedure Tconsoleforms.btncloseClick(Sender: TObject);
begin
  //
  self.Close;

end;

end.
