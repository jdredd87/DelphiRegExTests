object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Delphi RegEx Testing'
  ClientHeight = 600
  ClientWidth = 666
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 18
  object lblRegEx: TLabel
    Left = 8
    Top = 16
    Width = 92
    Height = 18
    Caption = 'RegEx String'
  end
  object lblDataStr: TLabel
    Left = 21
    Top = 48
    Width = 79
    Height = 18
    Caption = 'Data String'
  end
  object lblLoops: TLabel
    Left = 19
    Top = 82
    Width = 81
    Height = 18
    Caption = 'Loop Count'
  end
  object mDelphiTRegEx: TMemo
    Left = 18
    Top = 143
    Width = 297
    Height = 100
    ReadOnly = True
    TabOrder = 0
  end
  object btnPCRE: TButton
    Left = 18
    Top = 112
    Width = 297
    Height = 25
    Caption = 'Delphi TRegEx ( PCRE )'
    TabOrder = 1
    OnClick = btnPCREClick
  end
  object btnRegexpr: TButton
    Left = 360
    Top = 112
    Width = 297
    Height = 25
    Caption = 'TRegExpr ( Pascal )'
    TabOrder = 2
    OnClick = btnRegexprClick
  end
  object mTRegExpr: TMemo
    Left = 361
    Top = 143
    Width = 297
    Height = 100
    ReadOnly = True
    TabOrder = 3
  end
  object mTJclRegEx: TMemo
    Left = 18
    Top = 311
    Width = 297
    Height = 100
    ReadOnly = True
    TabOrder = 4
  end
  object btnJedi: TButton
    Left = 18
    Top = 280
    Width = 297
    Height = 25
    Caption = 'TJclRegEx ( PCRE )'
    TabOrder = 5
    OnClick = btnJediClick
  end
  object btnDotNetPCRE: TButton
    Left = 360
    Top = 280
    Width = 297
    Height = 25
    Caption = '.NET TRegEx ( PCRE )'
    TabOrder = 6
    OnClick = btnDotNetPCREClick
  end
  object mDotNetTRegEx: TMemo
    Left = 361
    Top = 311
    Width = 297
    Height = 100
    ReadOnly = True
    TabOrder = 7
  end
  object btnRegExBuddy: TButton
    Left = 18
    Top = 448
    Width = 297
    Height = 25
    Caption = 'TPerlRegEx ( PCRE )'
    TabOrder = 8
    OnClick = btnRegExBuddyClick
  end
  object mTPerlRegEx: TMemo
    Left = 18
    Top = 479
    Width = 297
    Height = 100
    ReadOnly = True
    TabOrder = 9
  end
  object edRegEx: TEdit
    Left = 106
    Top = 8
    Width = 551
    Height = 26
    ReadOnly = True
    TabOrder = 10
  end
  object edDataStr: TEdit
    Left = 106
    Top = 40
    Width = 551
    Height = 26
    ReadOnly = True
    TabOrder = 11
  end
  object spLoops: TSpinEdit
    Left = 106
    Top = 72
    Width = 159
    Height = 28
    MaxValue = 0
    MinValue = 0
    TabOrder = 12
    Value = 0
  end
end
