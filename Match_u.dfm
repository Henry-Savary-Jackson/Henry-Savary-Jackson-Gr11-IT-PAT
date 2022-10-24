object frmMatch: TfrmMatch
  Left = 0
  Top = 0
  Caption = 'Edit Match'
  ClientHeight = 293
  ClientWidth = 351
  Color = clInactiveCaption
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Agency FB'
  Font.Style = [fsBold]
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 18
  object lblTeams: TLabel
    Left = 176
    Top = 27
    Width = 13
    Height = 18
    Caption = 'vs'
  end
  object lblSupervisor: TLabel
    Left = 43
    Top = 195
    Width = 61
    Height = 18
    Caption = 'Supervisor:'
  end
  object lblDate: TLabel
    Left = 48
    Top = 157
    Width = 26
    Height = 18
    Caption = 'Date:'
  end
  object lblLocation: TLabel
    Left = 43
    Top = 107
    Width = 45
    Height = 18
    Caption = 'Location:'
  end
  object lblScoreOne: TLabel
    Left = 48
    Top = 62
    Width = 34
    Height = 18
    Caption = 'Score:'
  end
  object lblScoreTwo: TLabel
    Left = 206
    Top = 62
    Width = 34
    Height = 18
    Caption = 'Score:'
  end
  object btnBack: TButton
    Left = 8
    Top = 8
    Width = 57
    Height = 37
    Caption = 'Back'
    TabOrder = 0
    OnClick = btnBackClick
  end
  object cmbSupervisor: TComboBox
    Left = 136
    Top = 192
    Width = 145
    Height = 26
    TabOrder = 1
    Text = 'Supervisor'
  end
  object dtpDate: TDateTimePicker
    Left = 109
    Top = 157
    Width = 186
    Height = 26
    Date = 44825.000000000000000000
    Time = 0.339736481480940700
    TabOrder = 2
  end
  object edtLocation: TEdit
    Left = 109
    Top = 104
    Width = 159
    Height = 26
    TabOrder = 3
  end
  object btnSaveDetails: TButton
    Left = 116
    Top = 229
    Width = 133
    Height = 25
    Caption = 'Save match details only'
    TabOrder = 4
    OnClick = btnSaveDetailsClick
  end
  object sedTeamOneScore: TSpinEdit
    Left = 98
    Top = 59
    Width = 39
    Height = 28
    MaxValue = 16
    MinValue = 0
    TabOrder = 5
    Value = 0
  end
  object sedTeamTwoScore: TSpinEdit
    Left = 256
    Top = 59
    Width = 39
    Height = 28
    MaxValue = 16
    MinValue = 0
    TabOrder = 6
    Value = 0
  end
  object btnSaveResults: TButton
    Left = 116
    Top = 260
    Width = 133
    Height = 25
    Caption = 'Finalise match'
    TabOrder = 7
    OnClick = btnSaveResultsClick
  end
end
