object frmTeams: TfrmTeams
  Left = 0
  Top = 0
  Caption = 'Enter Teams'
  ClientHeight = 303
  ClientWidth = 266
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
  object lstTeams: TListBox
    Left = 9
    Top = 51
    Width = 249
    Height = 145
    ItemHeight = 18
    TabOrder = 1
    OnClick = lstTeamsClick
  end
  object btnAddTeam: TButton
    Left = 88
    Top = 208
    Width = 89
    Height = 25
    Caption = 'Add Team'
    TabOrder = 2
    OnClick = btnAddTeamClick
  end
  object btnDelTeam: TButton
    Left = 80
    Top = 239
    Width = 113
    Height = 25
    Caption = 'Remove Team'
    TabOrder = 3
    OnClick = btnDelTeamClick
  end
  object btnFileTeam: TButton
    Left = 62
    Top = 270
    Width = 139
    Height = 25
    Caption = 'Add Team name file'
    TabOrder = 4
    OnClick = btnFileTeamClick
  end
end
