object consoleforms: Tconsoleforms
  Left = 1195
  Top = 462
  Width = 663
  Height = 823
  Caption = 'chrom for javascript '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Splitter1: TSplitter
    Left = 0
    Top = 717
    Width = 647
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    Beveled = True
  end
  object devtools: TChromiumDevTools
    Left = 0
    Top = 49
    Width = 647
    Height = 668
    Align = alClient
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 647
    Height = 49
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 1
    object targetedt: TEdit
      Left = 16
      Top = 8
      Width = 617
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ImeName = 'Microsoft Office IME 2007'
      ParentFont = False
      TabOrder = 0
      Text = 'file:///D:\flowjs\backend\flowjs.html'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 720
    Width = 647
    Height = 64
    Align = alBottom
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -12
    Font.Name = 'Arial Black'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object runbtn: TButton
      Left = 18
      Top = 10
      Width = 95
      Height = 25
      Hint = 'Rub'
      Caption = 'Run'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clTeal
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = runbtnClick
    end
    object slectedrunbtn: TButton
      Left = 122
      Top = 10
      Width = 199
      Height = 25
      Hint = 'selected text run'
      Caption = 'Selected Run'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clTeal
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = slectedrunbtnClick
    end
    object btnclose: TButton
      Left = 562
      Top = 12
      Width = 75
      Height = 25
      Caption = 'Close'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial Black'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Visible = False
      OnClick = btncloseClick
    end
  end
end
