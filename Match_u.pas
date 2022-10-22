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
    btnSaveDetails: TButton;
    lblScoreOne: TLabel;
    sedTeamOneScore: TSpinEdit;
    sedTeamTwoScore: TSpinEdit;
    lblScoreTwo: TLabel;
    btnSaveResults: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBackClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSaveDetailsClick(Sender: TObject);
    procedure btnSaveResultsClick(Sender: TObject);
    procedure saveMatch();
    procedure saveAllocs();
    procedure setWinner(sWinnerAllocID, sLoserAllocID: string);
  private
    { Private declarations }
  public
    { Public declarations }
    matchID, sUsername, sID: string;
    arrAllocID: TArray<string>;
    iUser, iTournRound, iMatchRound: integer;
    bBeforeEditable, bFinished, bBegin, bLB: boolean;
    dDate: tDate;
    bTournEnd: boolean;

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
  // pass along program data
  frmTournament.iRound := iTournRound;
  frmTournament.sUsername := sUsername;
  frmTournament.bBegin := bBegin;
  frmTournament.iUser := iUser;
  frmTournament.sID := sID;
  frmTournament.dDate := dDate;

  // naviguate back to tournament screen
  frmMatch.Hide;
  frmTournament.Show;
end;

procedure TfrmMatch.btnSaveResultsClick(Sender: TObject);
begin
  // Update record in Database
  saveAllocs;
  saveMatch;
  showMessage('Match finalised!');
  // Naviguate back to tournament screen
  btnBack.Click;

end;

procedure TfrmMatch.btnSaveDetailsClick(Sender: TObject);
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
    // open tables
    MatchTB.Open;
    MatchAllocTB.Open;
    SupervisorTB.Open;
    TeamTB.Open;

    // obtain team one's name from DB
    util.GoToRecord(MatchAllocTB, 'AllocID', arrAllocID[0]);
    sTeamOne := MatchAllocTB['TeamName'];
    sedTeamOneScore.Value := MatchAllocTB['Score'];

    // obtain team two's name from DB
    util.GoToRecord(MatchAllocTB, 'AllocID', arrAllocID[1]);
    sTeamTwo := MatchAllocTB['TeamName'];
    sedTeamTwoScore.Value := MatchAllocTB['Score'];

    // display match's teams
    lblTeams.Caption := sTeamOne + ' vs ' + sTeamTwo;

    util.GoToRecord(MatchTB, 'MatchID', matchID);

    // obtain match;s location from DB
    edtLocation.Text := MatchTB['Location'];

    // obtain match's date from DB
    dtpDate.Date := MatchTB['MatchDate'];

    // obtain match's round from Db
    iMatchRound := MatchTB['Round'];

    // obtain whether match is in loser's bracket from
    bLB := MatchTB['LosersBracket'];

    // obtain whether match is finished from DB
    bFinished := MatchTB['Finished'];
    // if the match is finished, neither results nor detail can be changed by anyone

    // only allows the match details to be editable on the day of the match or before
    bBeforeEditable := dDate <= MatchTB['MatchDate'];

    // Otherwise, they won't be able to.
    if not(MatchTB['SupervisorID'] = Null) then
    begin

     // retrieves the match's supervisor's ID.
      sSupervisorID := MatchTB['SupervisorID'];
      if iUser = 1 then
      begin
        // If this ID is the same as the user's ID,then only they can edit the match
        // as long as the current is before or equal to the match date
        bBeforeEditable := (dDate <= MatchTB['MatchDate']) and
          (sSupervisorID = sID);

      end; // if

    end // if not null
    else
    begin
      //if there is no supervisor yet
      // supervisrID is null
      sSupervisorID := 'NIL';
      if iUser = 1 then
      begin
        // if the match has no supervisor
        //only an organiser can edit the match details
        bBeforeEditable := false;
      end;
    end; // else

    // checks whether the user is the match's supervisor entering results on the day of the match
    bOnDay := (sID = sSupervisorID) and (dDate = MatchTB['MatchDate']);

    // Disables/Enables the components based on whether the match is
    // editable by the current user at the current time
    dtpDate.Enabled := bBeforeEditable and (not bFinished);
    edtLocation.Enabled := bBeforeEditable and (not bFinished);

    //score can only be edited on the day by the match's supervisor
    sedTeamOneScore.Enabled := bOnDay and (not bFinished);
    sedTeamTwoScore.Enabled := bOnDay and (not bFinished);

    cmbSupervisor.Enabled := (iUser = 0) and bBeforeEditable and
      (not bFinished);

    //match details can be saved by the match's supervisor or an organiser
    btnSaveDetails.Enabled := bBeforeEditable and (not bFinished);

    // match results are only editable by the match's supervisor
    btnSaveResults.Enabled := bOnDay and (not bFinished);

    //TODO: check if this is necessary
    case iUser of
      0:
        begin
          sedTeamOneScore.Enabled := false;
          sedTeamTwoScore.Enabled := false;
        end; //case 0
      1:
        begin
          cmbSupervisor.Enabled := false;
        end;  //case 1
    end;  //switch case

    // Populate cmbSupervisors with the match's supervisor
    // and the supervisors under an organiser's watch
    SupervisorTB.First;
    cmbSupervisor.Items.Clear;
    SetLength(arrSupervisorID, 0);
    cmbSupervisor.Text := 'Supervisor';
    I := 0;
    while not SupervisorTB.Eof do
    begin

      if iUser = 0 then
      begin
       //TODO : check whether this mess even works lol and could be cleaner
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

        end; // if match supervisor or superviso

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

    //obtain teams' score
    iScoreOne := sedTeamOneScore.Value;
    iScoreTwo := sedTeamTwoScore.Value;

    //determine whether a draw has ocurred or not
    bDraw := (iScoreOne = iScoreTwo);

    if bDraw then
    begin

      //if a draw has occurred, the scores are reset,
      // and the date is set to be 4 days after the latest match in this round
      MatchTB.Filter := 'Round = ' + intToStr(iMatchRound);
      MatchTB.Filtered := true;
      MatchTB.Sort := 'Round DESC';
      MatchTB.First;
      dtpDate.Date := MatchTB['MatchDate'] + 4;
      MatchTB.Sort := '';
      MatchTB.Filtered := false;
    end; //if

    // Edit MatchAllocTB

    // Edit score on match alloc record
    util.GoToRecord(MatchAllocTB, 'AllocID', arrAllocID[0]);
    MatchAllocTB.Edit;
    if not bDraw then
    begin
      MatchAllocTB['Score'] := iScoreOne;
    end  // if
    else
    begin
      MatchAllocTB['Score'] := 0;
    end; //else

    // Edit Score on match alloc record
    util.GoToRecord(MatchAllocTB, 'AllocID', arrAllocID[1]);
    MatchAllocTB.Edit;
    if not bDraw then
    begin
      MatchAllocTB['Score'] := iScoreTwo;
    end // if
    else
    begin
      MatchAllocTB['Score'] := 0;
    end; // else

    if not bDraw then
    begin
      // If there wasn't a draw, decide winner and loser

      if iScoreOne > iScoreTwo then
      begin
        setWinner(arrAllocID[0], arrAllocID[1]);

      end //if
      else if iScoreOne < iScoreTwo then
      begin
        setWinner(arrAllocID[1], arrAllocID[0]);

      end; //else

      // set this Match to be finished
      bFinished := true;

    end // if bDraw
    else
    begin
      //user-friendly message
      showMessage
        ('A draw has occurred. A rematch is scheduled before the round ends');
    end;

    // Update DB
    util.UpdateTB(MatchAllocTB);

    util.UpdateTB(MatchTB);

    util.UpdateTB(TeamTB);

  end;  // with Datamodule1
end;

//this proceudre saves the match's details to the DB
procedure TfrmMatch.saveMatch;
var
  sLocation: string;
  iSupervisorIndex: integer;
begin
  //

  with DataModule1 do
  begin
    //obtain supervisor from combo box
    iSupervisorIndex := cmbSupervisor.ItemIndex;

    //obtain location from edit box
    sLocation := edtLocation.Text;

    // validate against an emty location
    if length(sLocation) = 0 then
    begin
      showMessage('Please enter a location.');
      Exit;
    end;

    // a supervisor must be selected
    if (iSupervisorIndex = -1) and (iUser = 0) then
    begin
      showMessage('Please select a supervisor.');
      Exit;
    end;

    //edit match record
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
    util.UpdateTB(MatchTB);

  end;

end;

//this procedure is given the winner and loser of a match
// and changes their MatchAlloc records accordingly
procedure TfrmMatch.setWinner(sWinnerAllocID, sLoserAllocID: string);
var
  iNumTeams: integer;
  sWinnerTeam, sLoserTeam: string;
begin
  //
  with DataModule1 do
  begin

    //set filter to show remaining teams
    TeamTB.Filter := 'NumLost < 2';
    TeamTB.Filtered := true;
    //obtains number of teams left
    iNumTeams := TeamTB.RecordCount;
    TeamTB.Filtered := false;

    // Edit winner's alloc record
    util.GoToRecord(MatchAllocTB, 'AllocID', sWinnerAllocID);
    sWinnerTeam := MatchAllocTB['TeamName'];
    MatchAllocTB.Edit;
    MatchAllocTB['Won'] := true;

    // Edit loser's alloc record
    util.GoToRecord(MatchAllocTB, 'AllocID', sLoserAllocID);
    sLoserTeam := MatchAllocTB['TeamName'];
    MatchAllocTB.Edit;
    MatchAllocTB['Won'] := false;

    // Change Numwon
    util.GoToRecord(TeamTB, 'TeamName', sWinnerTeam);
    TeamTB.Edit;
    TeamTB['NumWon'] := TeamTB['NumWon'] + 1;

    // Change NumLost
    util.GoToRecord(TeamTB, 'TeamName', sLoserTeam);
    TeamTB.Edit;
    TeamTB['NumLost'] := TeamTB['NumLost'] + 1;

    // Determine 1st, 2nd and 3rd place based on number of teams left
    case iNumTeams of
      2:
        begin  //1st and 2nd place only determinable by final match
          util.GoToRecord(TeamTB, 'TeamName', sWinnerTeam);
          TeamTB.Edit;
          TeamTB['TournamentPosition'] := 1;
          util.GoToRecord(TeamTB, 'TeamName', sLoserTeam);
          TeamTB.Edit;
          TeamTB['TournamentPosition'] := 2;
        end; //case 2
      3:
        begin
          if bLB then
          begin  //3rd place only is last round in loser's bracket
            util.GoToRecord(TeamTB, 'TeamName', sLoserTeam);
            TeamTB.Edit;
            TeamTB['TournamentPosition'] := 3;
          end;
        end;  // case 3

    end; //switch case

  end; //with DataModule1
end;

end.
