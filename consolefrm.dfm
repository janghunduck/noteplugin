object consoleforms: Tconsoleforms
  Left = 367
  Top = 788
  Width = 657
  Height = 532
  BorderStyle = bsSizeToolWin
  Caption = 'consolefrm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 528
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 8
    Top = 32
    Width = 393
    Height = 177
    Caption = 'Panel1'
    TabOrder = 1
  end
  object Button2: TButton
    Left = 528
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 2
    OnClick = Button2Click
  end
  object devtools: TChromiumDevTools
    Left = 0
    Top = 231
    Width = 649
    Height = 274
    Align = alBottom
  end
end
