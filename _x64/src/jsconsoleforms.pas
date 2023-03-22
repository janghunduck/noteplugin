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
  cefvcl;

type
  Tconsoleforms = class(TNppPluginForm)
    Panel1: TPanel;
    targetedt: TEdit;
    Panel2: TPanel;
    runbtn: TButton;
    selectedrunbtn: TButton;
    btnclose: TButton;
    DevTools: TChromiumDevTools;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure runbtnClick(Sender: TObject);
    procedure selectedrunbtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private

    chrom: TChromium;
    pt: TPoint;
    procedure WndProc(var Msg: TMessage); override;
    procedure ChromLoad();
  public
    { Public declarations }
  end;

  function MouseHookProc(Code,wParam,lParam:Integer) : Integer; stdcall;

var
  consoleforms: Tconsoleforms;
  MouseHook : HHook;

implementation

{$R *.dfm}

uses stringworkerplugin;


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
     // ��Ŀ���� �����Ϳ� ������� �Ѵ�.
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
       // linebar ����
       // å���� ����
       if (consoledlg.pt.x > 28) and (consoledlg.pt.x < 45) then
       begin
         consoledlg.Caption := inttostr(npp.getCurrlineNumberA) + ' å���� �����Դϴ�.';

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
  chrom.Align := alClient;
  chrom.DefaultUrl := 'about:blank';
  chrom.hide;

  { NodePad++ hook start }
  MouseHook := SetWindowsHookEx(WH_MOUSE, @MouseHookProc, hInstance, GetCurrentThreadID);
end;

procedure Tconsoleforms.FormShow(Sender: TObject);
begin
  ChromLoad;
end;

procedure Tconsoleforms.runbtnClick(Sender: TObject);
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
    chrom.Browser.MainFrame.ExecuteJavaScript(Npp.getAllTextutf8, 'about:blank', 0);
  end;

end;

procedure Tconsoleforms.selectedrunbtnClick(Sender: TObject);
var
  seltext : string;
begin
  seltext := Npp.getSelectedText;
  //showmessage(seltext);
  chrom.Browser.MainFrame.ExecuteJavaScript(seltext, 'about:blank', 0);
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

end.