object frmSupervisors: TfrmSupervisors
  Left = 0
  Top = 0
  Caption = 'Enter Supervisors'
  ClientHeight = 313
  ClientWidth = 275
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
  object btnBack: TButton
    Left = 8
    Top = 8
    Width = 57
    Height = 37
    Caption = 'Back'
    TabOrder = 0
    OnClick = btnBackClick
  end
  object lstSupervisors: TListBox
    Left = 8
    Top = 51
    Width = 249
    Height = 145
    ItemHeight = 18
    TabOrder = 1
    OnClick = lstSupervisorsClick
  end
  object btnAddSupervisor: TButton
    Left = 96
    Top = 207
    Width = 89
    Height = 25
    Caption = 'Add Supervisor'
    TabOrder = 2
    OnClick = btnAddSupervisorClick
  end
  object btnDelSupervisors: TButton
    Left = 82
    Top = 238
    Width = 113
    Height = 25
    Caption = 'Remove Supervisor'
    TabOrder = 3
    OnClick = btnDelSupervisorsClick
  end
  object btnFileSupervisors: TButton
    Left = 72
    Top = 269
    Width = 139
    Height = 25
    Caption = 'Add Supervisor name file'
    TabOrder = 4
    OnClick = btnFileSupervisorsClick
  end
end
