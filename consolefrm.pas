unit consolefrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, NppForms, cefvcl, StdCtrls, ExtCtrls, ceflib, NppPlugin;

type
  Tconsoleforms = class(TNppForm)
    Button1: TButton;
    Panel1: TPanel;
    Button2: TButton;
    devtools: TChromiumDevTools;
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  protected
    procedure RegisterForm();
    procedure UnregisterForm();
    procedure DoClose(var Action: TCloseAction); override;
    function WantChildKey(Child: TControl; var Message: TMessage): Boolean; override;
  public
    chrom: TChromium;
    NpHandle : THandle;
    Npp: TNppPlugin;
    DefaultCloseAction: TCloseAction;
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    destructor Destroy; override;
  end;

var
  consoleforms: Tconsoleforms;


implementation

{$R *.dfm}

procedure Tconsoleforms.Button2Click(Sender: TObject);
begin
  chrom:= TChromium.Create(nil);
  chrom.Parent := panel1;
  chrom.Align := alClient;
  chrom.DefaultUrl := 'about:blank';
  chrom.hide;
  chrom.Load('file:///D:\flowjs\backend\test\test.html');


  devtools.ShowDevTools(chrom.Browser);
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

  FreeAndnil(chrom);
  FreeAndnil(devtools);
  CefShutDown;
  
  inherited;

end;

function Tconsoleforms.WantChildKey(Child: TControl;
  var Message: TMessage): Boolean;
begin
  Result := Child.Perform(CN_BASE + Message.Msg, Message.WParam, Message.LParam) <> 0;
end;

end.
