object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Main'
  ClientHeight = 498
  ClientWidth = 355
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
  object lblWelcome: TLabel
    Left = 120
    Top = 8
    Width = 102
    Height = 13
    Caption = 'Welcome (Username)'
  end
  object btnSignOut: TButton
    Left = 147
    Top = 465
    Width = 75
    Height = 25
    Caption = 'Sign Out'
    TabOrder = 0
    OnClick = btnSignOutClick
  end
  object btnHelp: TButton
    Left = 308
    Top = 8
    Width = 40
    Height = 25
    Caption = '?'
    TabOrder = 1
    OnClick = btnHelpClick
  end
  object btnTournament: TButton
    Left = 48
    Top = 48
    Width = 257
    Height = 121
    Caption = 'Tournament'
    TabOrder = 2
    OnClick = btnTournamentClick
  end
  object btnTeams: TButton
    Left = 48
    Top = 192
    Width = 257
    Height = 121
    Caption = 'Enter Teams'
    TabOrder = 3
    OnClick = btnTeamsClick
  end
  object btnSupervisors: TButton
    Left = 48
    Top = 338
    Width = 257
    Height = 121
    Caption = 'Enter Supervisors'
    TabOrder = 4
    OnClick = btnSupervisorsClick
  end
end
