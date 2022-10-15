unit Login_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Data.Win.ADODB, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, DMUnit_u, Utils_u;

type
  TfrmLogin = class(TForm)
    edtUsername: TEdit;
    edtPassword: TEdit;
    btnSignIn: TButton;
    btnSignUp: TButton;
    lblUsername: TLabel;
    lblPassword: TLabel;
    Image1: TImage;
    lblAppTitle: TLabel;
    lblSignUp: TLabel;
    procedure btnSignInClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSignUpClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;
  fSupervisors: TextFile;
  arrOrganiserID: array of string;

implementation

uses
  Main_u,
  SignUp_u;

{$R *.dfm}

procedure TfrmLogin.btnSignInClick(Sender: TObject);
var
  sUsername, sPassword: string;
  iUser: integer;
begin
  with DataModule1 do
  begin
    // iUser := cmbUser.ItemIndex;

    sUsername := edtUsername.Text;

    // validate Username

    if sUsername = '' then
    begin
      showMessage('Please enter your username.');
      Exit;
    end
    else
    begin
      if util.isInTable(OrganiserTB, 'OrganiserName', sUsername) then
      begin
        iUser := 0;
      end
      else if util.isInTable(SupervisorTB, 'SupervisorName', sUsername) then
      begin
        iUser := 1;
      end
      else
      begin
        showMessage('User doesn''t exist');
        Exit;
      end;

    end;

    sPassword := edtPassword.Text;

    case iUser of
      0:
        begin
          if not(OrganiserTB['Password'] = sPassword) then
          begin
            showMessage('Incorrect Password.');
            Exit;
          end;
        end;
      1:
        begin
          if not(SupervisorTB['Password'] = sPassword) then
          begin
            showMessage('Incorrect Password.');
            Exit;
          end;
        end;

    end;

    // send data over to main screen
    case iUser of
      0:
        frmMain.sID := OrganiserTB['OrganiserID'];
      1:
        frmMain.sID := SupervisorTB['SupervisorID'];
    end;
    frmMain.iUser := iUser;
    frmMain.sUsername := sUsername;

    // Naviguate to main screen
    frmLogin.Hide;
    frmMain.Show;

  end;

end;

procedure TfrmLogin.btnSignUpClick(Sender: TObject);

begin
  frmLogin.Hide;
  frmSignUp.Show;
end;

procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TfrmLogin.FormShow(Sender: TObject);
var
  I: integer;
begin
  // set up title
  lblAppTitle.Caption := 'CAPE TOWN' + #13 + ' SOCCER TOURNAMENT ' + #13 +
    'PLANNER';

  // open tables
  with DataModule1 do
  begin
    OrganiserTB.Open;
    SupervisorTB.Open;

  end;

end;

end.