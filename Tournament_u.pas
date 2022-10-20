unit Tournament_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, DMUnit_u,
  Utils_u, Math;

type
  TfrmTournament = class(TForm)
    lstAllocations: TListBox;
    cmbRound: TComboBox;
    redTeams: TRichEdit;
    btnBack: TButton;
    btnBeginTournament: TButton;
    btnNextRnd: TButton;
    chbLoserBracket: TCheckBox;
    procedure lstAllocationsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBackClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure UpdateListBox();
    procedure cmbRoundChange(Sender: TObject);
    procedure btnBeginTournamentClick(Sender: TObject);
    procedure MakeFixtures(arr: TArray<string>; LB: boolean);
    procedure SaveTournament();
    procedure btnNextRndClick(Sender: TObject);
    function CalcByes(iTeams: integer): integer;
    function MakeMatch(sTeamOne, sTeamTwo: string; dDate: TDate;
      LB: boolean): string;
    procedure MakeAlloc(sTeam: string; sMatchID: string);
    procedure chbLoserBracketClick(Sender: TObject);
    procedure ComboBoxUpdate();
  private
    { Private declarations }
  public
    { Public declarations }
    sID, sUsername: string;
    iUser, iRound: integer;
    bBegin: boolean;
    dDate: TDate;
  end;

var
  frmTournament: TfrmTournament;
  // these dynamic arrays allow for all the relevant data
  // to be retrieved once a user accesses frmMatch
  // by storing the MatchIDs and AllocIDs in parallel.
  arrMatchID, arrAllocID, arrWB, arrLB: TArray<string>;
  util: Utils;
  fTournament: TextFile;

const
  fileName = 'Tournament.txt';

implementation

uses
  Match_u,
  Main_u;

{$R *.dfm}

procedure TfrmTournament.btnBackClick(Sender: TObject);
begin
  frmMain.sID := sID;
  frmMain.sUsername := sUsername;
  frmMain.iUser := iUser;
  frmMain.bBegin := bBegin;
  frmMain.iRound := iRound;
  frmMain.Show;
  frmTournament.Hide;
end;

procedure TfrmTournament.ComboBoxUpdate();
var
  I: integer;
begin
  cmbRound.Items.Clear;
  for I := 1 to iRound do
  begin
    cmbRound.Items.Add(intToStr(I));
  end;
end;

procedure TfrmTournament.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TfrmTournament.FormShow(Sender: TObject);
var
  I: integer;
begin
  ComboBoxUpdate();
  // open tables
  with DataModule1 do
  begin
    MatchTB.Open;
    MatchAllocTB.Open;
    TeamTB.Open;

    // add rounds to the combo box
    // update list box
    UpdateListBox();
    redTeams.Lines.Clear;
    redTeams.Lines.Add('Winners'' bracket:');
    // populate wb and lb
    TeamTB.Filter := 'NumLost = 0';
    TeamTB.Filtered := true;
    TeamTB.First;
    I := 0;
    while not TeamTB.Eof do
    begin
      I := I + 1;
      setLength(arrWB, I);
      arrWB[I - 1] := TeamTB['TeamName'];
      redTeams.Lines.Add(TeamTB['TeamName']);
      TeamTB.Next;
    end;
    TeamTB.Filter := 'NumLost = 1';
    TeamTB.First;
    I := 0;
    redTeams.Lines.Add(#13 + 'Losers'' bracket:');
    while not TeamTB.Eof do
    begin
      I := I + 1;
      setLength(arrLB, I);
      arrLB[I - 1] := TeamTB['TeamName'];
      redTeams.Lines.Add(TeamTB['TeamName']);
      TeamTB.Next;
    end;
    TeamTB.Filtered := false;

    // Only allows the next round to be started if all matches are over
    MatchTB.Filter := 'Finished = False';
    MatchTB.Filtered := true;
    btnNextRnd.Enabled := (iUser = 0) and bBegin and (MatchTB.RecordCount = 0);
    btnBeginTournament.Enabled := not bBegin;
    MatchTB.Filtered := false;

  end;

end;

procedure TfrmTournament.lstAllocationsClick(Sender: TObject);
var
  Index: integer;
begin
  case lstAllocations.ItemIndex of
    - 1:
    else
    begin
      with DataModule1 do
      begin
        // passes selected MatchID and associated AllocIDs to Match Screen
        index := lstAllocations.ItemIndex;
        frmMatch.matchID := arrMatchID[index];
        setLength(frmMatch.arrAllocID, 2);
        frmMatch.arrAllocID[0] := arrAllocID[index * 2];
        frmMatch.arrAllocID[1] := arrAllocID[(index * 2) + 1];
        frmMatch.iUser := iUser;
        frmMatch.sID := sID;
        frmMatch.dDate := dDate;
        frmMatch.bBegin := bBegin;

        frmMatch.Show;
        frmTournament.Hide;

      end;
    end;
  end;
end;

function TfrmTournament.MakeMatch(sTeamOne, sTeamTwo: string; dDate: TDate;
  LB: boolean): string;
var
  sMatchID: string;
begin
  //
  with DataModule1 do
  begin
    Repeat
    begin
      sMatchID := UpCase(sTeamOne[1]) + UpCase(sTeamTwo[1]) +
        intToStr(random(10));
    end
    until not util.isInTable(MatchTB, 'MatchID', sMatchID);

    MatchTB.Last;
    MatchTB.insert;
    MatchTB['MatchID'] := sMatchID;
    MatchTB.Edit;
    MatchTB['Location'] := 'Idk';
    MatchTB.Edit;
    MatchTB['MatchDate'] := dDate;
    MatchTB.Edit;
    MatchTB['LosersBracket'] := LB;
    MatchTB.Edit;
    MatchTB['Round'] := iRound;
    MatchTB.Edit;
    MatchTB['Finished'] := false;

    MatchTB.Edit;
    MatchTB.Post;
    MatchTB.Refresh;

    Result := sMatchID;
  end;

end;

procedure TfrmTournament.MakeAlloc(sTeam: string; sMatchID: string);
var
  sAllocID: string;
begin

  with DataModule1 do
  begin
    repeat
      sAllocID := UpCase(sTeam[1]) + intToStr(random(10)) +
        intToStr(random(10));
    until not util.isInTable(MatchAllocTB, 'AllocID', sAllocID);

    MatchAllocTB.Last;
    MatchAllocTB.insert;

    MatchAllocTB['AllocID'] := sAllocID;
    MatchAllocTB.Edit;
    MatchAllocTB['TeamName'] := sTeam;
    MatchAllocTB.Edit;
    MatchAllocTB['Won'] := false;
    MatchAllocTB.Edit;
    MatchAllocTB['Score'] := 0;
    MatchAllocTB.Edit;
    MatchAllocTB['MatchID'] := sMatchID;

    MatchAllocTB.Edit;
    MatchAllocTB.Post;
    MatchAllocTB.Refresh;

  end;
end;

// calculates the amount of byes based on the size of the teams in a round
function TfrmTournament.CalcByes(iTeams: integer): integer;
var
  iPower, iHighestPower, iPrevPower, distHigh, distLow: integer;
begin
  iPower := 1;
  while iTeams > trunc(power(2, iPower)) do
  begin
    iPower := iPower + 1;
  end;
  if iTeams = trunc(power(2, iPower)) then
  begin
    Result := 0;
  end
  else
  begin
    iHighestPower := trunc(power(2, iPower));
    iPrevPower := trunc(power(2, iPower - 1));
    distHigh := abs(iTeams - iHighestPower);
    distLow := abs(iTeams - iPrevPower);

    if distHigh <= distLow then
    begin
      Result := distHigh
    end
    else
    begin
      Result := distLow;
    end;

  end;
end;

procedure TfrmTournament.chbLoserBracketClick(Sender: TObject);
var
  bLB: boolean;
begin

  bLB := chbLoserBracket.Checked;
  UpdateListBox();
end;

procedure TfrmTournament.MakeFixtures(arr: TArray<string>; LB: boolean);
var
  arrTeams, arrByes: TArray<string>;
  arrMatchTeams: array [0 .. 1] of string;
  sMatchID: string;
  I, iIndex, J, iByes, iTeams: integer;
begin
  with DataModule1 do
  begin
    // calculate byes for next round

    iByes := CalcByes(length(arr));
    // copy array of teams
    arrTeams := copy(arr, 0, length(arr));
    // number of teams that will play in this round
    iTeams := length(arr) - iByes;

    setLength(arrByes, 0);

    if length(arrTeams) = 1 then
    begin
      Exit;
    end;

    if not(iRound = 1) then
    begin
      // Problem must distinguish byes in LB and Wb

      MatchAllocTB.Filter := 'MatchID = ' + QuotedStr('000');
      MatchAllocTB.Filtered := true;
      MatchAllocTB.First;
      // get Byes from previous round nad remove them from arrTeams
      I := 0;

      showMessage('Num byes: ' + intToStr(length(arrByes)));
      showMessage(intToStr(MatchAllocTB.RecordCount));

      while not MatchAllocTB.Eof do
      begin
        // showMessage('Byes');
        util.GoToRecord(MatchTB, 'MatchID', MatchAllocTB['MatchID']);
        if MatchTB['LosersBracket'] = LB then
        begin
          setLength(arrByes, length(arrByes) + 1);
          arrByes[I] := MatchAllocTB['TeamName'];
          Delete(arrTeams, util.SearchList(arrTeams, arrByes[I]), 1);
          showMessage('Bye in bracket');
          I := I + 1;
        end;

        MatchAllocTB.Next;
      end;
      MatchAllocTB.Filtered := false;
      MatchAllocTB.First;

      showMessage('Num byes: ' + intToStr(length(arrByes)));
      // make sure each bye from the previous round gets a match
      for I := 0 to length(arrByes) - 1 do
      begin
        arrMatchTeams[0] := arrByes[I];
        iIndex := random(length(arrTeams));
        arrMatchTeams[1] := arrTeams[iIndex];
        Delete(arrTeams, iIndex, 1);
        dDate := dDate + 4;
        sMatchID := MakeMatch(arrMatchTeams[0], arrMatchTeams[1], dDate, LB);
        MatchAllocTB.Filter := 'MatchID = ' + QuotedStr('000');
        MatchAllocTB.Filtered := true;
        // go to the bye's allocation record, and give it its new match foreign key
        util.GoToRecord(MatchAllocTB, 'TeamName', arrMatchTeams[0]);
        MatchAllocTB.Edit;
        MatchAllocTB['MatchID'] := sMatchID;
        MatchAllocTB.Filtered := false;
        // showMessage('Woop2');
        MakeAlloc(arrMatchTeams[1], sMatchID);
        // showMessage('Woop3');

      end; // for I
      // showMessage('woop5') ;
    end; // else

    // Once done allocating the next round's byes
    // create matches with the remaining teams until there aren't enough for a match
    while length(arrTeams) >= 2 do
    begin
      for J := 0 to 1 do
      begin
        iIndex := random(length(arrTeams));
        arrMatchTeams[J] := arrTeams[iIndex];
        Delete(arrTeams, iIndex, 1);
      end; // for
      dDate := dDate + 4;
      sMatchID := MakeMatch(arrMatchTeams[0], arrMatchTeams[1], dDate, LB);
      for J := 0 to 1 do
      begin
        MakeAlloc(arrMatchTeams[J], sMatchID);
      end;

    end;

    if not(iByes = 0) then
    begin
      showMessage('Next round byes');
      setLength(arrByes, iByes);
      for I := 0 to iByes - 1 do
      begin
        iIndex := random(length(arrTeams));
        arrByes[I] := arrTeams[iIndex];
        Delete(arrTeams, iIndex, 1);
        // make allocation
        // find a way to allow null
        MakeAlloc(arrByes[I], '000');
      end; // for I
    end;

    // Update DB
    MatchAllocTB.Edit;
    MatchAllocTB.Post;
    MatchAllocTB.Refresh;
    MatchAllocTB.First;

    MatchTB.Edit;
    MatchTB.Post;
    MatchTB.Refresh;
    MatchTB.First;

  end; // Datamodule

end;

procedure TfrmTournament.btnBeginTournamentClick(Sender: TObject);
begin
  iRound := 1;
  MakeFixtures(arrWB, false);

  btnBeginTournament.Enabled := false;

  bBegin := true;

  showMessage('Fixtures made!');

  ComboBoxUpdate();
  SaveTournament();
  UpdateListBox();

end;

procedure TfrmTournament.btnNextRndClick(Sender: TObject);
var
arrFinalTeams : TArray<string> ;
remainingTeams : integer;
begin

  with DataModule1 do
  begin

    TeamTB.Filter := 'NumLost < 2';
    TeamTB.Filtered := true;

    remainingTeams := TeamTB.RecordCount;

    TeamTB.Filtered := false;

    if remainingTeams > 2 then
    begin
      // most of tournament
      iRound := iRound + 1;

      MakeFixtures(arrWB, false);
      MakeFixtures(arrLB, true);
      showMessage('Fixtures made!');
    end
    else if remainingTeams = 2 then
    begin
      // final match
      TeamTB.First;
      SetLength(arrFinalTeams, 2);
      arrFinalTeams[0] := TeamTB['TeamName'];
      TeamTB.Next;
      arrFinalTeams[1] :=  TeamTB['TeamName'];

      iRound := iRound + 1;

      MakeFixtures(arrFinalTeams,false);
      showMessage('Fixtures made!');

    end
    else
    begin
      // end of tournament


    end;

    ComboBoxUpdate();
    SaveTournament();
    UpdateListBox();

    btnNextRnd.Enabled := false;

  end;

end;

procedure TfrmTournament.cmbRoundChange(Sender: TObject);
begin
  UpdateListBox();
end;

procedure TfrmTournament.UpdateListBox();
var
  I: integer;
  sItem: string;
  dDate: TDateTIme;
begin

  if not(cmbRound.ItemIndex = -1) then
  begin
    with DataModule1 do
    begin
      // check textfile
      if not(cmbRound.ItemIndex = -1) then
        iRound := strToInt(cmbRound.Items[cmbRound.ItemIndex]);

      lstAllocations.Items.Clear;

      // query for matchID that are in the selected round
      setLength(arrMatchID, 0);
      setLength(arrAllocID, 0);

      if chbLoserBracket.Checked then
      begin
        MatchTB.Filter := 'LosersBracket = True'
      end
      else
      begin
        MatchTB.Filter := 'LosersBracket = False'
      end;
      MatchTB.Filtered := true;

      MatchTB.First;
      I := 0;
      while not MatchTB.Eof do
      begin

        if MatchTB['Round'] = iRound then
        begin
          setLength(arrMatchID, length(arrMatchID) + 1);
          arrMatchID[I] := MatchTB['MatchID'];

          dDate := MatchTB['MatchDate'];

          // Loops through the two allocations related to a match record
          // in order to create a list box item
          // This also makes it possible for the list box item to give relevant
          // data to frmMatch
          setLength(arrAllocID, length(arrMatchID) * 2);
          MatchAllocTB.First;

          sItem := '';

          util.GoToRecord(MatchAllocTB, 'MatchID', arrMatchID[I]);
          arrAllocID[(2 * I)] := MatchAllocTB['AllocID'];
          sItem := sItem + MatchAllocTB['TeamName'] + ' vs ';
          util.GoToNextRecord(MatchAllocTB, 'MatchID', arrMatchID[I]);
          arrAllocID[(2 * I) + 1] := MatchAllocTB['AllocID'];
          sItem := sItem + MatchAllocTB['TeamName'] + ' on ' + DateToStr(dDate);

          lstAllocations.Items.Add(sItem);

          I := I + 1;
        end;
        MatchTB.Next;
      end;
      MatchTB.First;
      MatchAllocTB.First;
      MatchTB.Filtered := false;

    end;

  end;

end;

// Save the state of the tournament to a text file
procedure TfrmTournament.SaveTournament();
begin
  AssignFile(fTournament, fileName);

  ReWrite(fTournament);
  if bBegin then
  begin
    Writeln(fTournament, 'Begun: T');
  end
  else
  begin
    Writeln(fTournament, 'Begun: F');
  end;

  Writeln(fTournament, 'CurrentRound: ' + intToStr(iRound));

  CloseFile(fTournament);

end;

end.
