object consoleforms: Tconsoleforms
  Left = 1314
  Top = 631
  Width = 630
  Height = 509
  BorderStyle = bsSizeToolWin
  Caption = 'chrom for javascript '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object devtools: TChromiumDevTools
    Left = 0
    Top = 41
    Width = 622
    Height = 397
    Align = alClient
  end
  object Button3: TButton
    Left = 448
    Top = 368
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 1
    Visible = False
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 536
    Top = 368
    Width = 75
    Height = 25
    Caption = 'dev test'
    TabOrder = 2
    Visible = False
    OnClick = Button4Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 622
    Height = 41
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 3
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
    Top = 438
    Width = 622
    Height = 44
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    object runtextbtn: TButton
      Left = 488
      Top = 10
      Width = 89
      Height = 25
      Hint = 'all script'
      Caption = 'all script'
      TabOrder = 0
      Visible = False
      OnClick = runtextbtnClick
    end
    object runbtn: TButton
      Left = 18
      Top = 10
      Width = 87
      Height = 25
      Hint = 'Rub'
      Caption = 'Run'
      TabOrder = 1
      OnClick = runbtnClick
    end
    object slectedrunbtn: TButton
      Left = 114
      Top = 10
      Width = 103
      Height = 25
      Hint = 'selected text run'
      Caption = 'Selected Run'
      TabOrder = 2
      OnClick = slectedrunbtnClick
    end
  end
end