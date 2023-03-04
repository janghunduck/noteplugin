unit jsplugfrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls;

type
  Tjsplugdlg = class(TForm)
    MainMenu: TMainMenu;
    GroupBox1: TGroupBox;
    cbnew: TCheckBox;
    cbthis: TCheckBox;
    cbmemo: TCheckBox;
    Memo: TMemo;
    test1: TMenuItem;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  jsplugdlg: Tjsplugdlg;

implementation

{$R *.dfm}

end.
