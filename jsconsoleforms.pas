unit jsconsoleforms;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, NppDockingForms, StdCtrls, NppPlugin, cefvcl, ExtCtrls, ComCtrls,
  ceflib,ceffilescheme, Menus;

type
  Tjsconsoledlg = class(TNppDockingForm)
    ConsolePanel: TPanel;  // D:\flowjs\dcef3-master\src
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    testmenu: TMenuItem;
    N11: TMenuItem;
    ChromiumDevTools1: TChromiumDevTools;
    Chromium1: TChromium;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormHide(Sender: TObject);
    procedure FormFloat(Sender: TObject);
    procedure FormDock(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure N11Click(Sender: TObject);
  private

  public

  end;

var
  jsconsoledlg: Tjsconsoledlg;

implementation

{$R *.dfm}

{
 var
  frame: ICefFrame;
  source: ustring;
begin
  if Chromium.Browser = nil then
   showmessage('Not created');

  frame := Chromium.Browser.MainFrame;
  source := '<html>erg</html>';
  frame.LoadString(source, '');

end;
}

procedure Tjsconsoledlg.FormCreate(Sender: TObject);
var
  frame: ICefFrame;
  source: ustring;
begin
  self.NppDefaultDockingMask := DWS_DF_FLOATING; // whats the default docking position
  self.KeyPreview := true; // special hack for input forms
  self.OnFloat := self.FormFloat;
  self.OnDock := self.FormDock;


  //DevTools.ShowDevTools(Chrom.Browser);

  inherited;
end;

procedure Tjsconsoledlg.Button1Click(Sender: TObject);
begin
  inherited;
  self.UpdateDisplayInfo('test');
end;

procedure Tjsconsoledlg.Button2Click(Sender: TObject);
begin
  inherited;
  self.Hide;
end;

// special hack for input forms
// This is the best possible hack I could came up for
// memo boxes that don't process enter keys for reasons
// too complicated... Has something to do with Dialog Messages
// I sends a Ctrl+Enter in place of Enter
procedure Tjsconsoledlg.FormKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  //if (Key = #13) and (self.Memo1.Focused) then self.Memo1.Perform(WM_CHAR, 10, 0);
end;

// Docking code calls this when the form is hidden by either "x" or self.Hide
procedure Tjsconsoledlg.FormHide(Sender: TObject);
begin
  inherited;
  SendMessage(self.Npp.NppData.NppHandle, NPPM_SETMENUITEMCHECK, self.CmdID, 0);
end;

procedure Tjsconsoledlg.FormDock(Sender: TObject);
begin
  SendMessage(self.Npp.NppData.NppHandle, NPPM_SETMENUITEMCHECK, self.CmdID, 1);
end;

procedure Tjsconsoledlg.FormFloat(Sender: TObject);
begin
  SendMessage(self.Npp.NppData.NppHandle, NPPM_SETMENUITEMCHECK, self.CmdID, 1);
end;

procedure Tjsconsoledlg.FormShow(Sender: TObject);
begin
  inherited;
  SendMessage(self.Npp.NppData.NppHandle, NPPM_SETMENUITEMCHECK, self.CmdID, 1);
end;

procedure Tjsconsoledlg.N11Click(Sender: TObject);
begin
  inherited;
  //
  //chrom.Load('file:///D:\flowjs\backend\test\test.html');
end;

end.
