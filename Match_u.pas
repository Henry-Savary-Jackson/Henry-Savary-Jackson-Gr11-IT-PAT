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
    btnFinalise: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBackClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnFinaliseClick(Sender: TObject);
    procedure saveMatch();
    procedure saveAllocs();
  private
    { Private declarations }
  public
    { Public declarations }
    matchID, sUsername, sID: string;
    arrAllocID: TArray<string>;
    iUser, iTournRound, iMatchRound: integer;
    bBeforeEditable, bFinished: boolean;
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
  frmTournament.iRound := iTournRound;
  frmTournament.sUsername := sUsername;
  frmTournament.bBegin := bBegin;
  frmTournament.iUser := iUser;
  frmTournament.sID := sID;
  frmTournament.dDate := dDate;
  frmMatch.Hide;
  frmTournament.Show;
end;

procedure TfrmMatch.btnFinaliseClick(Sender: TObject);
begin
  // Update record in Database
  saveAllocs;
  saveMatch;
  showMessage('Match finalised!');
  // Naviguate back to main screen
  btnBack.Click;

end;

procedure TfrmMatch.btnSaveClick(Sender: TObject);
begin
  // Update record in Database
  saveMatch;
  showMessage('Changes saved!');
  // naviguate back to tournament screen
  btnBack.Click;

end;

procedure TfrmMatch.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TfrmMatch.FormShow(Sender: TObject);
var
  I: integer;
  sSupervisorID: string;
  bOnDay: boolean;
begin

  with DataModule1 do
  begin
    MatchTB.Open;
    MatchAllocTB.Open;
    SupervisorTB.Open;
    TeamTB.Open;

    util.GoToRecord(MatchAllocTB, 'AllocID', arrAllocID[0]);
    sTeamOne := MatchAllocTB['TeamName'];
    sedTeamOneScore.Value := MatchAllocTB['Score'];

    util.GoToRecord(MatchAllocTB, 'AllocID', arrAllocID[1]);

    sTeamTwo := MatchAllocTB['TeamName'];
    sedTeamTwoScore.Value := MatchAllocTB['Score'];
    lblTeams.Caption := sTeamOne + ' vs ' + sTeamTwo;

    util.GoToRecord(MatchTB, 'MatchID', matchID);

    edtLocation.Text := MatchTB['Location'];
    dtpDate.Date := MatchTB['MatchDate'];

    iMatchRound := MatchTB['Round'];

    // only allows the match to be editable on the day of the match
    bBeforeEditable := dDate <= MatchTB['MatchDate'];
    bFinished := MatchTB['Finished'];

    // retrieves the match's supervisor's ID.
    // If this ID is the same as the user's ID,then they can edit the match.
    // Otherwise, they won't be able to.
    if not(MatchTB['SupervisorID'] = Null) then
    begin

      sSupervisorID := MatchTB['SupervisorID'];
      if iUser = 1 then
        bBeforeEditable := sSupervisorID = sID;

    end
    else
    begin
      sSupervisorID := '000';
      bBeforeEditable := (iUser = 0);
    end;
    bOnDay := (sID = sSupervisorID) and (dDate = MatchTB['MatchDate']);

    // Disables/Enables the components based on whether the match is
    // editable by the current user.
    dtpDate.Enabled := bBeforeEditable and (not bFinished);
    edtLocation.Enabled := bBeforeEditable and (not bFinished);

    sedTeamOneScore.Enabled := bOnDay and (not bFinished);

    sedTeamTwoScore.Enabled := bOnDay and (not bFinished);

    cmbSupervisor.Enabled := bBeforeEditable and (not bFinished);

    btnSave.Enabled := bBeforeEditable and (not bFinished);
    btnFinalise.Enabled := bOnDay and (not bFinished);

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

procedure TfrmMatch.saveAllocs;
var
  iScoreOne, iScoreTwo: integer;
  bDraw: boolean;
begin
  //
  with DataModule1 do
  begin

    iScoreOne := sedTeamOneScore.Value;
    iScoreTwo := sedTeamTwoScore.Value;

    bDraw := (iScoreOne = iScoreTwo);

    if bDraw then
    begin
      MatchTB.Filter := 'Round = ' + intToStr(iMatchRound);
      MatchTB.Filtered := true;
      MatchTB.Sort := 'Round DESC';
      MatchTB.First;
      dtpDate.Date := MatchTB['MatchDate'] + 4;
      MatchTB.Sort := '';
      MatchTB.Filtered := false;
    end;

    // Edit MatchAllocTB

    util.GoToRecord(MatchAllocTB, 'AllocID', arrAllocID[0]);
    MatchAllocTB.Edit;
    if not bDraw then
    begin
      MatchAllocTB['Score'] := iScoreOne;
    end
    else
    begin
      MatchAllocTB['Score'] := 0;
    end;

    util.GoToRecord(MatchAllocTB, 'AllocID', arrAllocID[1]);
    MatchAllocTB.Edit;
    if not bDraw then
    begin
      MatchAllocTB['Score'] := iScoreTwo;
    end
    else
    begin
      MatchAllocTB['Score'] := 0;
    end;
    util.GoToRecord(MatchAllocTB, 'AllocID', arrAllocID[0]);

    if not bDraw then
    begin

      if iScoreOne > iScoreTwo then
      begin
        MatchAllocTB.Edit;
        MatchAllocTB['Won'] := true;
        // next
        util.GoToRecord(MatchAllocTB, 'AllocID', arrAllocID[1]);
        MatchAllocTB.Edit;
        MatchAllocTB['Won'] := false;

        util.GoToRecord(TeamTB, 'TeamName', sTeamOne);
        TeamTB.Edit;
        TeamTB['NumWon'] := TeamTB['NumWon'] + 1;
        util.GoToRecord(TeamTB, 'TeamName', sTeamTwo);
        TeamTB.Edit;
        TeamTB['NumLost'] := TeamTB['NumLost'] + 1;
      end
      else if iScoreOne < iScoreTwo then
      begin
        util.GoToRecord(MatchAllocTB, 'AllocID', arrAllocID[1]);
        MatchAllocTB.Edit;
        MatchAllocTB['Won'] := true;
        util.GoToRecord(MatchAllocTB, 'AllocID', arrAllocID[0]);
        MatchAllocTB.Edit;
        MatchAllocTB['Won'] := false;

        util.GoToRecord(TeamTB, 'TeamName', sTeamTwo);
        TeamTB.Edit;
        TeamTB['NumWon'] := TeamTB['NumWon'] + 1;
        util.GoToRecord(TeamTB, 'TeamName', sTeamOne);
        TeamTB.Edit;
        TeamTB['NumLost'] := TeamTB['NumLost'] + 1;
      end;

      bFinished := true;
    end // if bDraw
    else
    begin

      showMessage
        ('A draw has occurred. A rematch is scheduled before the round ends');
    end;

    // Update DB
    util.UpdateTB(MatchAllocTB);

    util.UpdateTB(MatchTB);

  end;
end;

procedure TfrmMatch.saveMatch;
var
  sLocation: string;
  iSupervisorIndex: integer;
begin
  //

  with DataModule1 do
  begin
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

    util.GoToRecord(MatchTB, 'MatchID', matchID);
    MatchTB.Edit;

    if iUser = 0 then
      MatchTB['SupervisorID'] := arrSupervisorID[iSupervisorIndex];

    MatchTB.Edit;
    MatchTB['Location'] := sLocation;
    MatchTB.Edit;
    MatchTB['MatchDate'] := dtpDate.Date;
    MatchTB.Edit;
    MatchTB['Finished'] := bFinished;

    // Update DB
    MatchTB.Edit;
    MatchTB.Post;
    MatchTB.Refresh;
    MatchTB.First;

  end;

end;

end.
