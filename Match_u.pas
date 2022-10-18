unit Match_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, DMUnit_u,
  Vcl.Samples.Spin;

type
  TfrmMatch = class(TForm)
    btnBack: TButton;
    lblTeams: TLabel;
    cmbSupervisor: TComboBox;
    lblSupervisor: TLabel;
    lblDate: TLabel;
    dtpDate: TDateTimePicker;
    edtLocation: TEdit;
    lblLocation: TLabel;
    btnSave: TButton;
    lblScoreOne: TLabel;
    sedTeamOneScore: TSpinEdit;
    sedTeamTwoScore: TSpinEdit;
    lblScoreTwo: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBackClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    matchID, sUsername, sID: string;
    arrAllocID: TArray<string>;
    iUser, iRound: integer;
    editable: boolean;
    dDate: tDate;
    bBegin: boolean

    end;

  var
    frmMatch: TfrmMatch;
    sTeamOne, sTeamTwo: string;
    arrSupervisorID: TArray<string>;

implementation

uses
  Tournament_u;

{$R *.dfm}

procedure TfrmMatch.btnBackClick(Sender: TObject);
begin
  frmTournament.iRound := iRound;
  frmTournament.sUsername := sUsername;
  frmTournament.bBegin := bBegin;
  frmTournament.iUser := iUser;
  frmTournament.sID := sID;
  frmTournament.dDate := dDate;
  frmMatch.Hide;
  frmTournament.Show;
end;

procedure TfrmMatch.btnSaveClick(Sender: TObject);
var
  sLocation: string;
  iScoreOne, iScoreTwo, iSupervisorIndex: integer;
  bDraw: boolean;
begin
  // Update record in Database
  with DataModule1 do
  begin
    // Input
    iScoreOne := sedTeamOneScore.Value;
    iScoreTwo := sedTeamTwoScore.Value;

    iSupervisorIndex := cmbSupervisor.ItemIndex;

    sLocation := edtLocation.Text;

    // Input validation
    if length(sLocation) = 0 then
    begin
      showMessage('Please enter a location.');
      Exit;
    end;

    if (iSupervisorIndex = -1) and (iUser = 0) then
    begin
      showMessage('Please select a supervisor.');
      Exit;
    end;

    util.goToRecord(MatchTB, 'MatchID', matchID);
    MatchTB.Edit;

    bDraw := (iScoreOne = iScoreTwo) and (dDate = MatchTB['MatchDate']);

    if bDraw then
    begin
      dtpDate.Date := dtpDate.Date + 4;
    end;

    // Edit MatchTB

    if iUser = 0 then
      MatchTB['SupervisorID'] := arrSupervisorID[iSupervisorIndex];

    MatchTB['Location'] := sLocation;

    MatchTB['MatchDate'] := dtpDate.Date;

    // Update DB
    MatchTB.Edit;
    MatchTB.Post;
    MatchTB.Refresh;
    MatchTB.First;

    if not bDraw then
    begin

      // Edit MatchAllocTB

      util.goToRecord(MatchAllocTB, 'AllocID', arrAllocID[0]);
      MatchAllocTB.Edit;
      MatchAllocTB['Score'] := iScoreOne;
      util.goToRecord(MatchAllocTB, 'AllocID', arrAllocID[1]);
      MatchAllocTB.Edit;
      MatchAllocTB['Score'] := iScoreTwo;
      util.goToRecord(MatchAllocTB, 'AllocID', arrAllocID[0]);

      if iScoreOne > iScoreTwo then
      begin
        MatchAllocTB.Edit;
        MatchAllocTB['Won'] := true;
        // next
        util.goToRecord(MatchAllocTB, 'AllocID', arrAllocID[1]);
        MatchAllocTB.Edit;
        MatchAllocTB['Won'] := false;

        util.goToRecord(TeamTB, 'TeamName', sTeamOne);
        TeamTB.Edit;
        TeamTB['NumWon'] := TeamTB['NumWon'] + 1;
        util.goToRecord(TeamTB, 'TeamName', sTeamTwo);
        TeamTB.Edit;
        TeamTB['NumLost'] := TeamTB['NumLost'] + 1;
      end
      else if iScoreOne < iScoreTwo then
      begin
        util.goToRecord(MatchAllocTB, 'AllocID', arrAllocID[1]);
        MatchAllocTB.Edit;
        MatchAllocTB['Won'] := true;
        util.goToRecord(MatchAllocTB, 'AllocID', arrAllocID[0]);
        MatchAllocTB.Edit;
        MatchAllocTB['Won'] := false;

        util.goToRecord(TeamTB, 'TeamName', sTeamTwo);
        TeamTB.Edit;
        TeamTB['NumWon'] := TeamTB['NumWon'] + 1;
        util.goToRecord(TeamTB, 'TeamName', sTeamOne);
        TeamTB.Edit;
        TeamTB['NumLost'] := TeamTB['NumLost'] + 1;
      end;

      // Update DB
      MatchAllocTB.Edit;
      MatchAllocTB.Post;
      MatchAllocTB.Refresh;
      MatchAllocTB.First;

      showMessage('Changes saved!');
    end // if bDraw
    else
    begin
      showMessage
        ('A draw has occurred. A rematch is scheduled before the round ends');
    end;

    // naviguate back to tournament screen
    btnBack.Click;

  end;
end;

procedure TfrmMatch.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TfrmMatch.FormShow(Sender: TObject);
var
  I: integer;
  sSupervisorID: string;

begin

  with DataModule1 do
  begin
    MatchTB.Open;
    MatchAllocTB.Open;
    SupervisorTB.Open;
    TeamTB.Open;

    util.goToRecord(MatchAllocTB, 'AllocID', arrAllocID[0]);
    sTeamOne := MatchAllocTB['TeamName'];
    sedTeamOneScore.Value := MatchAllocTB['Score'];

    util.goToRecord(MatchAllocTB, 'AllocID', arrAllocID[1]);

    sTeamTwo := MatchAllocTB['TeamName'];
    sedTeamTwoScore.Value := MatchAllocTB['Score'];
    lblTeams.Caption := sTeamOne + ' vs ' + sTeamTwo;

    util.goToRecord(MatchTB, 'MatchID', matchID);

    edtLocation.Text := MatchTB['Location'];
    dtpDate.Date := MatchTB['MatchDate'];

    // only allows the match to be editable on the day of the match
    editable := dDate <= MatchTB['MatchDate'];

    // retrieves the match's supervisor's ID.
    // If this ID is the same as the user's ID,then they can edit the match.
    // Otherwise, they won't be able to.
    if not(MatchTB['SupervisorID'] = Null) then
    begin

      sSupervisorID := MatchTB['SupervisorID'];
      if iUser = 1 then
        editable := sSupervisorID = sID;

    end
    else
    begin
      sSupervisorID := '000';
      editable := (iUser = 0);
    end;

    // Disables/Enables the components based on whether the match is
    // editable by the current user.
    dtpDate.Enabled := editable;
    edtLocation.Enabled := editable;
    sedTeamOneScore.Enabled := (sID = sSupervisorID) and
      (dDate = MatchTB['MatchDate']);
    sedTeamTwoScore.Enabled := (sID = sSupervisorID) and
      (dDate = MatchTB['MatchDate']);
    cmbSupervisor.Enabled := editable;
    btnSave.Enabled := editable;

    // user permissions on different components
    case iUser of
      0:
        begin
          sedTeamOneScore.Enabled := false;
          sedTeamTwoScore.Enabled := false;
        end;
      1:
        begin
          cmbSupervisor.Enabled := false;
        end;
    end;

    // Populate cmbSupervisors with supervisors under an organiser's watch
    SupervisorTB.First;
    cmbSupervisor.Items.Clear;
    SetLength(arrSupervisorID, 0);
    cmbSupervisor.Text := 'Supervisor';
    I := 0;
    while not SupervisorTB.Eof do
    begin

      if iUser = 0 then
      begin

        if (SupervisorTB['OrganiserID'] = sID) or
          (SupervisorTB['SupervisorID'] = sSupervisorID) then
        begin

          cmbSupervisor.Items.Add(SupervisorTB['SupervisorName']);

          SetLength(arrSupervisorID, length(arrSupervisorID) + 1);
          arrSupervisorID[I] := SupervisorTB['SupervisorID'];

          if SupervisorTB['SupervisorID'] = sSupervisorID then
          begin
            cmbSupervisor.ItemIndex := I;
          end; // if

          I := I + 1;

        end;
        // if supervisor

      end // if
      else if SupervisorTB['SupervisorID'] = sSupervisorID then
      begin

        cmbSupervisor.Text := SupervisorTB['SupervisorName'];

      end; // else

      SupervisorTB.Next;

    end; // while  not eof

  end; // open datamodule

end;

end.
