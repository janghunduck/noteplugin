unit jsconsolemsgfrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  NppPlugin,
  NppForms,
  stringworkerplugin,
  cefvcl,
  ceflib;

type
  Tconsolemsgdlg = class(TNppForm)
    Panel1: TPanel;
    targetedt: TEdit;
    Panel2: TPanel;
    runbtn: TButton;
    slectedrunbtn: TButton;
    btnclose: TButton;
    Memo: TMemo;
    procedure runbtnClick(Sender: TObject);
    procedure slectedrunbtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btncloseClick(Sender: TObject);
  private
    procedure WndProc(var Msg: TMessage); override;
    procedure consolemsg(Sender: TObject;
                         const browser: ICefBrowser; const message, source: ustring;
                         line: Integer; out Result: Boolean);
  protected

  public
    chrom: TChromium;
    PluginDlg : THelloWorldPlugin;
    pt: TPoint;

    NpHandle : THandle;
    constructor create( Dlg: THelloWorldPlugin );
 

  end;
  function MouseHookProc(Code,wParam,lParam:Integer) : Integer; stdcall;

var
  consolemsgdlg: Tconsolemsgdlg;
  CMouseHook : HHook;

implementation

{$R *.dfm}

procedure Tconsolemsgdlg.runbtnClick(Sender: TObject);
var
  filename : string;
begin
  filename := PluginDlg.getCurrentPathFileA;

  if fileexists(filename) then
  begin
    targetedt.Text := 'file:///' + filename;
    chrom.Load(targetedt.Text);


    //devtools.ShowDevTools(chrom.Browser);
  end else
    chrom.Browser.MainFrame.ExecuteJavaScript(THelloWorldPlugin(Npp).getAllTextA, 'about:blank', 0);

end;

procedure Tconsolemsgdlg.slectedrunbtnClick(Sender: TObject);
var
  seltext : string;
begin
  seltext := THelloWorldPlugin(Npp).getSelectedText;
  chrom.Browser.MainFrame.ExecuteJavaScript(seltext, 'about:blank', 0);
end;


constructor Tconsolemsgdlg.create(Dlg: THelloWorldPlugin);
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
  consolemsgdlg.pt := point(X,Y);
  
  if Wparam = WM_LBUTTONUP then begin
     consolemsgdlg.targetedt.text := 'file:///' + npp.getCurrentPathFileA;   // sendmessage

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

  result := CallNextHookEx(CMouseHook, Code, wParam, lParam);
end;

procedure Tconsolemsgdlg.FormCreate(Sender: TObject);
begin
  chrom:= TChromium.Create(nil);
  chrom.Parent := self;
  chrom.Align := alClient;
  chrom.DefaultUrl := 'about:blank';
  chrom.hide;

  { NodePad++ hook start }
  CMouseHook := SetWindowsHookEx(WH_MOUSE, MouseHookProc, hInstance, GetCurrentThreadID);
end;


procedure Tconsolemsgdlg.FormShow(Sender: TObject);
begin
  targetedt.Text := 'file:///' + PluginDlg.getCurrentPathFileA;
  chrom.Load(targetedt.Text);
  chrom.OnConsoleMessage := ConsoleMsg;
  //chrom.OnConsoleMessage := ConsoleMsg;
  //devtools.ShowDevTools(chrom.Browser);


end;


procedure Tconsolemsgdlg.WndProc(var Msg: TMessage);
begin

  case Msg.Msg of
    WM_DESTROY: begin
      log.WriteLog('THookDlg.WndProc .... WM_DESTROY Hook end');
      //FreeAndnil(chrom);
      //FreeAndnil(devtools);
      //CefShutDown;
      UnHookWindowsHookEx(CMouseHook);

    end;

    WM_CREATE: begin
      //log.WriteLog('THookDlg.WndProc .... WM_CREATE');
      
    end;
  end;
  
  inherited WndProc(Msg);
end;



procedure Tconsolemsgdlg.btncloseClick(Sender: TObject);
begin
  //
  self.Close;

end;

procedure Tconsolemsgdlg.consolemsg(Sender: TObject;
  const browser: ICefBrowser; const message, source: ustring; line: Integer; out Result: Boolean);
begin
  memo.Lines.Add('>' + message + ', source='  + source);
end;

end.
