object jsfuncdlg: Tjsfuncdlg
  Left = 1449
  Top = 774
  Width = 471
  Height = 499
  BorderStyle = bsSizeToolWin
  Caption = 'javascript function call'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 463
    Height = 41
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 0
    object edttarget: TEdit
      Left = 7
      Top = 8
      Width = 370
      Height = 21
      ImeName = 'Microsoft Office IME 2007'
      TabOrder = 0
      Text = 'file:///D:\flowjs\backend\flowjs.html'
    end
  end
  object Groupbox: TGroupBox
    Left = 0
    Top = 41
    Width = 463
    Height = 40
    Align = alTop
    TabOrder = 1
    object cbnew: TCheckBox
      Left = 16
      Top = 14
      Width = 153
      Height = 17
      Caption = 'Return New Notepad++'
      TabOrder = 0
    end
    object cbthis: TCheckBox
      Left = 160
      Top = 14
      Width = 153
      Height = 17
      Caption = 'Return this Notepad++'
      TabOrder = 1
    end
    object cbmemo: TCheckBox
      Left = 304
      Top = 14
      Width = 97
      Height = 17
      Caption = 'Return memo'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 81
    Width = 463
    Height = 41
    Align = alTop
    TabOrder = 2
    object runbtn: TButton
      Left = 377
      Top = 8
      Width = 75
      Height = 25
      Caption = 'run'
      TabOrder = 0
      OnClick = runbtnClick
    end
    object edtfunc: TEdit
      Left = 7
      Top = 8
      Width = 361
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ImeName = 'Microsoft Office IME 2007'
      ParentFont = False
      TabOrder = 1
    end
  end
  object Memo: TMemo
    Left = 0
    Top = 122
    Width = 463
    Height = 350
    Align = alClient
    ImeName = 'Microsoft Office IME 2007'
    TabOrder = 3
  end
  object MainMenu: TMainMenu
    Left = 408
    Top = 184
  end
end
