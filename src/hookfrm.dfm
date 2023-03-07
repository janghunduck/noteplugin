object HookDlg: THookDlg
  Left = 1637
  Top = 387
  Width = 766
  Height = 624
  Caption = 'HookDlg'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 136
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 16
    Top = 168
    Width = 32
    Height = 13
    Caption = 'Label2'
  end
  object Button1: TButton
    Left = 584
    Top = 280
    Width = 73
    Height = 25
    Caption = 'Point hook'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 758
    Height = 113
    Align = alTop
    ImeName = 'Microsoft Office IME 2007'
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object Button2: TButton
    Left = 584
    Top = 312
    Width = 75
    Height = 25
    Caption = 'amousehook'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 584
    Top = 248
    Width = 75
    Height = 25
    Caption = 'shell hook'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 672
    Top = 248
    Width = 75
    Height = 25
    Caption = 'unhook'
    TabOrder = 4
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 8
    Top = 248
    Width = 131
    Height = 25
    Caption = 'getClientRect'
    TabOrder = 5
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 8
    Top = 280
    Width = 129
    Height = 25
    Caption = 'Button6'
    TabOrder = 6
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 8
    Top = 312
    Width = 129
    Height = 25
    Caption = 'Button7'
    TabOrder = 7
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 8
    Top = 344
    Width = 75
    Height = 25
    Caption = 'Button8'
    TabOrder = 8
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 672
    Top = 312
    Width = 75
    Height = 25
    Caption = 'unhook'
    TabOrder = 9
    OnClick = Button9Click
  end
  object Button10: TButton
    Left = 264
    Top = 136
    Width = 145
    Height = 25
    Caption = 'npp all frm'
    TabOrder = 10
    OnClick = Button10Click
  end
  object ListBox1: TListBox
    Left = 296
    Top = 352
    Width = 401
    Height = 233
    ImeName = 'Microsoft Office IME 2007'
    ItemHeight = 13
    TabOrder = 11
  end
  object Button11: TButton
    Left = 672
    Top = 280
    Width = 75
    Height = 25
    Caption = 'unhook'
    TabOrder = 12
    OnClick = Button11Click
  end
  object Button12: TButton
    Left = 264
    Top = 176
    Width = 145
    Height = 25
    Caption = 'liennumber, len'
    TabOrder = 13
    OnClick = Button12Click
  end
  object Button13: TButton
    Left = 264
    Top = 216
    Width = 145
    Height = 25
    Caption = 'gotoline'
    TabOrder = 14
    OnClick = Button13Click
  end
  object Button14: TButton
    Left = 264
    Top = 248
    Width = 145
    Height = 25
    Caption = #52293#44040#54588' '#54869#51064
    TabOrder = 15
    OnClick = Button14Click
  end
  object Button15: TButton
    Left = 272
    Top = 280
    Width = 75
    Height = 25
    Caption = 'marker add '
    TabOrder = 16
    OnClick = Button15Click
  end
  object Edit1: TEdit
    Left = 360
    Top = 280
    Width = 121
    Height = 21
    ImeName = 'Microsoft Office IME 2007'
    TabOrder = 17
  end
end
