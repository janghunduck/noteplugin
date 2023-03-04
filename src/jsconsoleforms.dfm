inherited jsconsoledlg: Tjsconsoledlg
  Left = 1097
  Top = 740
  Width = 825
  Height = 461
  BorderStyle = bsSizeToolWin
  Caption = 'jsconsoledlg'
  Menu = MainMenu1
  OnCreate = FormCreate
  OnHide = FormHide
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ConsolePanel: TPanel
    Left = 0
    Top = 0
    Width = 817
    Height = 396
    Align = alClient
    Caption = 'ConsolePanel'
    TabOrder = 0
    object ChromiumDevTools1: TChromiumDevTools
      Left = 416
      Top = 88
      Width = 225
      Height = 257
    end
    object Chromium1: TChromium
      Left = 112
      Top = 128
      Width = 273
      Height = 185
      DefaultUrl = 'about:blank'
      TabOrder = 1
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 396
    Width = 817
    Height = 19
    Panels = <>
  end
  object MainMenu1: TMainMenu
    Left = 160
    Top = 32
    object testmenu: TMenuItem
      Caption = 'test'
      object N11: TMenuItem
        Caption = '1'
        OnClick = N11Click
      end
    end
  end
end
