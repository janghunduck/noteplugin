object consoleforms: Tconsoleforms
  Left = 0
  Top = 0
  Caption = 'chrom for javascript '
  ClientHeight = 380
  ClientWidth = 528
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 528
    Height = 49
    Align = alTop
    TabOrder = 0
    object targetedt: TEdit
      Left = 17
      Top = 14
      Width = 473
      Height = 21
      TabOrder = 0
      Text = 'file:///D:\flowjs\backend\flowjs.html'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 343
    Width = 528
    Height = 37
    Align = alBottom
    TabOrder = 1
    object runbtn: TButton
      Left = 16
      Top = 6
      Width = 75
      Height = 25
      Caption = 'run'
      TabOrder = 0
      OnClick = runbtnClick
    end
    object selectedrunbtn: TButton
      Left = 97
      Top = 4
      Width = 75
      Height = 25
      Caption = 'selecte run'
      TabOrder = 1
      OnClick = selectedrunbtnClick
    end
    object btnclose: TButton
      Left = 440
      Top = 4
      Width = 75
      Height = 25
      Caption = 'close'
      TabOrder = 2
    end
  end
  object DevTools: TChromiumDevTools
    Left = 0
    Top = 49
    Width = 528
    Height = 294
    Align = alClient
  end
end