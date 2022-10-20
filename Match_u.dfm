object frmMatch: TfrmMatch
  Left = 0
  Top = 0
  Caption = 'Edit Match'
  ClientHeight = 293
  ClientWidth = 351
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblTeams: TLabel
    Left = 168
    Top = 32
    Width = 11
    Height = 13
    Caption = 'vs'
  end
  object lblSupervisor: TLabel
    Left = 43
    Top = 195
    Width = 55
    Height = 13
    Caption = 'Supervisor:'
  end
  object lblDate: TLabel
    Left = 48
    Top = 168
    Width = 27
    Height = 13
    Caption = 'Date:'
  end
  object lblLocation: TLabel
    Left = 43
    Top = 107
    Width = 44
    Height = 13
    Caption = 'Location:'
  end
  object lblScoreOne: TLabel
    Left = 48
    Top = 62
    Width = 31
    Height = 13
    Caption = 'Score:'
  end
  object lblScoreTwo: TLabel
    Left = 206
    Top = 62
    Width = 31
    Height = 13
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
    Height = 21
    TabOrder = 1
    Text = 'Supervisor'
  end
  object dtpDate: TDateTimePicker
    Left = 109
    Top = 157
    Width = 186
    Height = 21
    Date = 44825.000000000000000000
    Time = 0.339736481480940700
    TabOrder = 2
  end
  object edtLocation: TEdit
    Left = 109
    Top = 104
    Width = 159
    Height = 21
    TabOrder = 3
  end
  object btnSave: TButton
    Left = 136
    Top = 227
    Width = 81
    Height = 25
    Caption = 'Save Changes'
    TabOrder = 4
    OnClick = btnSaveClick
  end
  object sedTeamOneScore: TSpinEdit
    Left = 98
    Top = 59
    Width = 39
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 5
    Value = 0
  end
  object sedTeamTwoScore: TSpinEdit
    Left = 256
    Top = 59
    Width = 39
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 6
    Value = 0
  end
  object btnFinalise: TButton
    Left = 136
    Top = 260
    Width = 81
    Height = 25
    Caption = 'Finalise'
    TabOrder = 7
    OnClick = btnFinaliseClick
  end
end
