object frmTournament: TfrmTournament
  Left = 0
  Top = 0
  Caption = 'Tournament'
  ClientHeight = 573
  ClientWidth = 344
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
  object lblRound: TLabel
    Left = 30
    Top = 60
    Width = 35
    Height = 18
    Caption = 'Round:'
  end
  object lstAllocations: TListBox
    Left = 8
    Top = 105
    Width = 323
    Height = 214
    ItemHeight = 18
    TabOrder = 0
    OnClick = lstAllocationsClick
  end
  object cmbRound: TComboBox
    Left = 71
    Top = 57
    Width = 145
    Height = 26
    TabOrder = 1
    Text = 'Round'
    OnChange = cmbRoundChange
  end
  object redTeams: TRichEdit
    Left = 8
    Top = 356
    Width = 326
    Height = 209
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Agency FB'
    Font.Style = [fsBold]
    Lines.Strings = (
      'Winners'#39' Bracket:'
      ''
      'Losers'#39' Bracket:')
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
    Zoom = 100
  end
  object btnBack: TButton
    Left = 8
    Top = 8
    Width = 57
    Height = 37
    Caption = 'Back'
    TabOrder = 3
    OnClick = btnBackClick
  end
  object btnBeginTournament: TButton
    Left = 128
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Begin'
    TabOrder = 4
    OnClick = btnBeginTournamentClick
  end
  object btnNextRnd: TButton
    Left = 128
    Top = 325
    Width = 75
    Height = 25
    Caption = 'Next Round'
    TabOrder = 5
    OnClick = btnNextRndClick
  end
  object chbLoserBracket: TCheckBox
    Left = 239
    Top = 60
    Width = 97
    Height = 17
    Caption = 'Losers'#39' Bracket'
    TabOrder = 6
    OnClick = chbLoserBracketClick
  end
end
