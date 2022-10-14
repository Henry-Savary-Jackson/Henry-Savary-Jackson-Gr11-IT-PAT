object frmSignUp: TfrmSignUp
  Left = 0
  Top = 0
  Caption = 'Sign up'
  ClientHeight = 404
  ClientWidth = 354
  Color = clInactiveCaption
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
  object lblUsername: TLabel
    Left = 62
    Top = 147
    Width = 54
    Height = 17
    Caption = 'Username:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Agency FB'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblPassword: TLabel
    Left = 62
    Top = 192
    Width = 54
    Height = 17
    Caption = 'Password:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Agency FB'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Image1: TImage
    Left = 136
    Top = 8
    Width = 65
    Height = 65
  end
  object lblAppTitle: TLabel
    Left = 19
    Top = 79
    Width = 367
    Height = 12
    Alignment = taCenter
    Caption = 'Cape Town Soccer Tournament Planner'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Engravers MT'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblOrganiser: TLabel
    Left = 42
    Top = 280
    Width = 80
    Height = 17
    Caption = 'Your organiser:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Agency FB'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblSignIn: TLabel
    Left = 62
    Top = 368
    Width = 133
    Height = 17
    Caption = 'Already have an account? '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Agency FB'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object edtUsername: TEdit
    Left = 168
    Top = 144
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object edtPassword: TEdit
    Left = 168
    Top = 192
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object cmbUser: TComboBox
    Left = 96
    Top = 240
    Width = 145
    Height = 21
    TabOrder = 2
    Text = 'Your role'
    OnChange = cmbUserChange
    Items.Strings = (
      'Organiser'
      'Supervisor')
  end
  object btnSignUp: TButton
    Left = 152
    Top = 320
    Width = 75
    Height = 25
    Caption = 'Sign Up'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Agency FB'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = btnSignUpClick
  end
  object cmbOrganiser: TComboBox
    Left = 144
    Top = 280
    Width = 145
    Height = 21
    TabOrder = 4
  end
  object btnSignIn: TButton
    Left = 196
    Top = 362
    Width = 75
    Height = 25
    Caption = 'Sign In'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Agency FB'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = btnSignInClick
  end
end
