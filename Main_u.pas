unit Main_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  DMUnit_u,
  Vcl.StdCtrls;

type
  TfrmMain = class(TForm)
    lblWelcome: TLabel;
    btnSignOut: TButton;
    btnTournament: TButton;
    btnTeams: TButton;
    btnSupervisors: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnSupervisorsClick(Sender: TObject);
    procedure btnTeamsClick(Sender: TObject);
    procedure btnTournamentClick(Sender: TObject);
    procedure btnSignOutClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    sID, sUsername: string;
    iUser, iRound: integer;
    bBegin: boolean;
    dDate : TDate;
    bTournEnd : boolean;

    // 0 = organiser
    // 1 = supervisor
  end;

var
  frmMain: TfrmMain;
  fTournament: TextFile;

implementation

uses
  Login_u,
  Supervisors_u,
  Teams_u,
  Tournament_u,
  Match_u;

{$R *.dfm}

procedure TfrmMain.btnSignOutClick(Sender: TObject);
begin
  //naviguate to login screen
  frmLogin.Show;
  frmMain.Hide;
end;

procedure TfrmMain.btnSupervisorsClick(Sender: TObject);
begin
  //naviguate to supervisors screen
  frmSupervisors.sID := sID;
  frmSupervisors.Show;
  frmMain.Hide;
end;

procedure TfrmMain.btnTeamsClick(Sender: TObject);
begin
  //naviguate to teams screen
  frmTeams.sID := sID;
  frmTeams.Show;
  frmMain.Hide;
end;

procedure TfrmMain.btnTournamentClick(Sender: TObject);
begin
  //pass along program data
  frmTournament.iUser := iUser;
  frmTournament.sID := sID;
  frmTournament.iRound := iRound;
  frmTournament.bBegin := bBegin;
  frmTournament.sUsername := sUsername;
  frmTournament.dDate := dDate;
  frmTournament.bTournEnd := bTournEnd;

  //naviguate to tournament screen
  frmTournament.Show;
  frmMain.Hide;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  with DataModule1 do
  begin
    //open tables
    OrganiserTB.Open;
    SupervisorTB.Open;

  end;

  // welcome user
  lblWelcome.Caption := 'Welcome ' + sUsername;

  case iUser of

    0:
      begin
        //only allow access to teams screen before tournament has commenced
        btnTeams.Enabled := not bBegin;

        //only allow access to supervisors screen if tournament has not ended
        btnSupervisors.Enabled := not bTournEnd;
      end;
    1:
      begin
        //disallow supervisors from accessing teams and supervisors screen
        btnTeams.Enabled := false;
        btnSupervisors.Enabled := false;
      end;

  end;

end;

end.
