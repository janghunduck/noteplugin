object jsplugdlg: Tjsplugdlg
  Left = 863
  Top = 786
  Width = 498
  Height = 501
  BorderStyle = bsSizeToolWin
  Caption = 'javascript plugins'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 490
    Height = 56
    Align = alTop
    TabOrder = 0
    object cbnew: TCheckBox
      Left = 16
      Top = 24
      Width = 153
      Height = 17
      Caption = 'Return New Notepad++'
      TabOrder = 0
    end
    object cbthis: TCheckBox
      Left = 160
      Top = 24
      Width = 153
      Height = 17
      Caption = 'Return this Notepad++'
      TabOrder = 1
    end
    object cbmemo: TCheckBox
      Left = 296
      Top = 24
      Width = 97
      Height = 17
      Caption = 'Return memo'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
  end
  object Memo: TMemo
    Left = 0
    Top = 56
    Width = 490
    Height = 399
    Align = alClient
    ImeName = 'Microsoft Office IME 2007'
    TabOrder = 1
  end
  object MainMenu: TMainMenu
    Left = 48
    Top = 64
    object test1: TMenuItem
      Caption = 'test'
    end
  end
end
