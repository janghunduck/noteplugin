object HookDlg: THookDlg
  Left = 1637
  Top = 387
  Width = 601
  Height = 624
  Caption = 'HookDlg'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 312
    Top = 24
    Width = 113
    Height = 25
    Caption = 'WM_MOUSE'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 48
    Top = 184
    Width = 353
    Height = 169
    ImeName = 'Microsoft Office IME 2007'
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object Button2: TButton
    Left = 312
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 2
    OnClick = Button2Click
  end
  object ChromiumDevTools1: TChromiumDevTools
    Left = 80
    Top = 432
    Width = 100
    Height = 41
  end
  object Chromium1: TChromium
    Left = 288
    Top = 440
    Width = 100
    Height = 41
    DefaultUrl = 'about:blank'
    TabOrder = 4
  end
  object Button3: TButton
    Left = 352
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 5
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 448
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Button4'
    TabOrder = 6
    OnClick = Button4Click
  end
  object ApplicationEvents1: TApplicationEvents
    OnMessage = ApplicationEvents1Message
    Left = 160
    Top = 40
  end
end
