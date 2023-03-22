object consoleforms: Tconsoleforms
  Left = 671
  Top = 307
  Width = 630
  Height = 483
  BorderStyle = bsSizeToolWin
  Caption = 'chrom for javascript '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object devtools: TChromiumDevTools
    Left = 0
    Top = 41
    Width = 614
    Height = 359
    Align = alClient
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 614
    Height = 41
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 1
    object targetedt: TEdit
      Left = 24
      Top = 8
      Width = 617
      Height = 21
      ImeName = 'Microsoft Office IME 2007'
      TabOrder = 0
      Text = 'file:///D:\flowjs\backend\flowjs.html'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 400
    Width = 614
    Height = 44
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object runbtn: TButton
      Left = 18
      Top = 10
      Width = 87
      Height = 25
      Hint = 'Rub'
      Caption = 'Run'
      TabOrder = 0
      OnClick = runbtnClick
    end
    object slectedrunbtn: TButton
      Left = 114
      Top = 10
      Width = 103
      Height = 25
      Hint = 'selected text run'
      Caption = 'Selected Run'
      TabOrder = 1
      OnClick = slectedrunbtnClick
    end
    object btnclose: TButton
      Left = 538
      Top = 12
      Width = 75
      Height = 25
      Caption = 'Close'
      TabOrder = 2
      OnClick = btncloseClick
    end
  end
end
