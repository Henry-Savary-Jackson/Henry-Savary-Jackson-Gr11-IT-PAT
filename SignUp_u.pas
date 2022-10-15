unit SignUp_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Utils_u,
  DMUnit_u;

type
  TfrmSignUp = class(TForm)
    lblUsername: TLabel;
    lblPassword: TLabel;
    Image1: TImage;
    lblAppTitle: TLabel;
    lblOrganiser: TLabel;
    edtUsername: TEdit;
    edtPassword: TEdit;
    cmbUser: TComboBox;
    btnSignUp: TButton;
    cmbOrganiser: TComboBox;
    lblSignIn: TLabel;
    btnSignIn: TButton;
    procedure btnSignUpClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSignInClick(Sender: TObject);
    procedure cmbUserChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSignUp: TfrmSignUp;
  fSupervisors: TextFile;
  arrOrganiserID: array of string;

const
  fileName = 'Supervisors.txt';

implementation

uses
  Main_u,
  Login_u;

{$R *.dfm}

procedure TfrmSignUp.btnSignInClick(Sender: TObject);
begin
  frmSignUp.Hide;
  frmLogin.Show;
end;

procedure TfrmSignUp.btnSignUpClick(Sender: TObject);
var
  sUsername, sID, sPassword, sLine: string;
  iUser: integer;
  bRegistered: boolean;
begin
  //Input
  iUser := cmbUser.ItemIndex;

  sUsername := edtUsername.Text;

  // validate username length
  if sUsername = '' then
  begin
    showMessage('Please enter your username.');
    Exit;
  end
  else if Length(sUsername) > 30 then
  begin
    showMessage('Username shouldn''t be longer than 30 characters.')
  end
  else if iUser = 1 then
  begin
    // verify , given a user is supervisor, that they are in the regitered supervisors
    // text file.
    if not FileExists(fileName) then
    begin
      showMessage('Error: cannot find list of supervisors.');
      Exit;
    end;

    AssignFile(fSupervisors, fileName);

    Reset(fSupervisors);
    bRegistered := false;

    while not Eof(fSupervisors) do
    begin
      Readln(fSupervisors, sLine);
      if sLine = sUsername then
      begin
        bRegistered := true;
        Break;
      end;
    end;

    if not bRegistered then
    begin
      showMessage('You are not registered as a supervisor.');
      Exit;
    end;

  end;
  // validate against already existing username

  case iUser of
    0:
      if util.isInTable(DataModule1.OrganiserTB, 'OrganiserName', sUsername)
      then
      begin
        showMessage('Username already in use.');
        Exit;
      end;
    1:
      if util.isInTable(DataModule1.SupervisorTB, 'SupervisorName', sUsername)
      then
      begin
        showMessage('Username already in use.');
        Exit;
      end;

  else
    begin
      showMessage('Please select your role.');
      Exit;
    end;

    DataModule1.OrganiserTB.First;
    DataModule1.SupervisorTB.First;

  end;

  sPassword := edtPassword.Text;

  // validate password
  if sPassword = '' then
  begin
    showMessage('Please enter a password.');
    Exit;
  end
  // Ensure that password is the correct length
  else if Length(sPassword) < 8 then
  begin
    showMessage('Your password must be at least 8 characters long.');
    Exit;
  end
  else if Length(sPassword) > 15 then
  begin
    showMessage('Your password cannot be over 15 characters.');
    Exit;
  end
  else if not util.containsSpecialChar(sPassword) then
  begin
    // check whether password has at least one special character
    showMessage('Your password must contain atleast one special character.');
    Exit;

  end
  else if not util.containsDigit(sPassword) then
  begin
    showMessage('Your password must contain atleast one digit');
    Exit;
  end;

  with DataModule1 do
  begin

    case iUser of
      0:
        begin
          // set ADOTable to insert

          // generate unique ID

          sID := UpCase(sUsername[1]) + intToStr(random(10));
          // Ensure generated ID is not already in table
          while util.isInTable(OrganiserTB, 'OrganiserID', sID) do
          begin
            sID := UpCase(sUsername[1]) + intToStr(random(10));
          end;

          // insert record
          // set ADOTable to insert
          OrganiserTB.Last;
          OrganiserTB.Insert;
          // insert record
          OrganiserTB['OrganiserID'] := sID;
          // add username and password
          OrganiserTB['OrganiserName'] := sUsername;
          OrganiserTB['Password'] := sPassword;

          OrganiserTB.Post;
          OrganiserTB.Refresh;

        end;
      1:
        begin

          // generate unique ID

          sID := UpCase(sUsername[1]) + intToStr(random(10)) +
            intToStr(random(10));

          // Ensure generated ID is not already in table
          while util.isInTable(SupervisorTB, 'SupervisorID', sID) do
          begin
            sID := UpCase(sUsername[1]) + intToStr(random(10)) +
              intToStr(random(10));
          end;

          // set ADOTable to insert
          SupervisorTB.Last;
          SupervisorTB.Insert;

          // insert record
          SupervisorTB['SupervisorID'] := sID;

          // add username and password
          SupervisorTB['SupervisorName'] := sUsername;
          SupervisorTB['Password'] := sPassword;

          // insert user's Organiser
          if cmbOrganiser.ItemIndex = -1 then
          begin
            showMessage('Please select your organiser.');
            Exit;
          end;
          SupervisorTB['OrganiserID'] := arrOrganiserID[cmbOrganiser.ItemIndex];

          SupervisorTB.Post;
          SupervisorTB.Refresh;
        end;

    end;

  end;

  // send data to main screen
  frmMain.iUser := iUser;
  frmMain.sUsername := sUsername;
  frmMain.sID := sID;

  // open main screen
  frmSignUp.Hide;
  frmMain.Show;
  // TODO: chekc this works and fix
end;

procedure TfrmSignUp.cmbUserChange(Sender: TObject);
begin
//hides/shows combo box for their organiser based on whether user is a supervisor
//or not
  if cmbUser.ItemIndex = 1 then
  begin
    lblOrganiser.Show;
    cmbOrganiser.Show;
  end
  else
  begin
    lblOrganiser.Hide;
    cmbOrganiser.Hide;
  end;
end;

procedure TfrmSignUp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TfrmSignUp.FormShow(Sender: TObject);
var
  I: integer;
begin
  // set up title
  lblAppTitle.Caption := 'CAPE TOWN' + #13 + ' SOCCER TOURNAMENT ' + #13 +
    'PLANNER';

  // add user organiser combo box
  if not(cmbUser.ItemIndex = 1) then
  begin
    lblOrganiser.Hide;
    cmbOrganiser.Hide;
  end;
  // open tables
  with DataModule1 do
  begin
    OrganiserTB.Open;
    SupervisorTB.Open;

    // add all organisers to organiser combo box
    OrganiserTB.First;
    // sets length of array to number of records
    cmbOrganiser.Items.Clear;
    SetLength(arrOrganiserID, OrganiserTB.RecordCount);
    I := 0;
    while not OrganiserTB.Eof do
    begin
      cmbOrganiser.Items.Add(OrganiserTB['OrganiserName']);
      arrOrganiserID[I] := OrganiserTB['OrganiserID'];;
      I := I + 1;
      OrganiserTB.Next;
    end;

  end;
end;

end.