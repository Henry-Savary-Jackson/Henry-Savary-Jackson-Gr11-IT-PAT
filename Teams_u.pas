unit Teams_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, DMUnit_u, Utils_u;

type
  TfrmTeams = class(TForm)
    btnBack: TButton;
    lstTeams: TListBox;
    btnAddTeam: TButton;
    btnDelTeam: TButton;
    btnFileTeam: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBackClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnFileTeamClick(Sender: TObject);
    procedure lstTeamsClick(Sender: TObject);
    procedure btnAddTeamClick(Sender: TObject);
    function insertTeamInfo(team: string; club: string) : integer;
    procedure btnDelTeamClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    sID: string;
  end;

var
  frmTeams: TfrmTeams;
  fSupersvisorNames: TextFile;

implementation

uses
  Main_u;

{$R *.dfm}

procedure TfrmTeams.btnAddTeamClick(Sender: TObject);
var
  sTeamName, sClubName: string;
begin

  //Input
  sTeamName := InputBox('Team name', 'Enter team''s name', '');

  sClubName := InputBox('Club name', 'Enter name of this team''s club', '');

  with DataModule1 do
  begin
  //insets the team into DB.
  //If the data is invalid, various error codes are returned to
  //be used to display a user friendly message;
   case insertTeamInfo(sTeamName, sClubName) of
     11: showMessage('Please enter a name for the team.');
     12: showMessage('Team''s name cannot be more than 30 characters.');
     13: showMessage('Team already exists.');
     21: showMessage('Please enter a name for the Club.');
     22: showMessage('Club''s name cannot be more than 30 characters.');
     23: showMessage('Club already exists.');
   end;

    //Post to DB file
    TeamTB.Edit;
    TeamTB.Post;
    TeamTB.Refresh;
  end

end;

procedure TfrmTeams.btnBackClick(Sender: TObject);
begin
  frmTeams.Hide;
  frmMain.Show;
end;

procedure TfrmTeams.btnDelTeamClick(Sender: TObject);
var
  sName, sLine: string;
begin

  sLine := lstTeams.Items[lstTeams.ItemIndex];
  sName := copy(sLine, 1, pos(' from ', sLine) - 1);

  lstTeams.Items.Delete(lstTeams.ItemIndex);

  with DataModule1 do
  begin

    util.goToRecord(TeamTB, 'TeamName', sName);
    TeamTB.Delete;

  end;

  btnDelTeam.Enabled := false;

  // TODO : make sure delete doesn't interfere with match allocations
  //it won't as you can't remove teams after beginning

end;

procedure TfrmTeams.btnFileTeamClick(Sender: TObject);
var
  fileChooser: TOpenDialog;
  sPath, sLine, sTeamName, sClubName: string;
  fTeams: TextFile;
  iPos: integer;
begin
  fileChooser := TOpenDialog.Create(self);

  fileChooser.Filter := 'Text files|*.txt';

  fileChooser.FilterIndex := 1;

  if fileChooser.Execute then
  begin
    sPath := fileChooser.FileName;
  end
  else
  begin
    showMessage('Please choose a text file');
    Exit;
  end;

  fileChooser.Free;

  AssignFile(fTeams, sPath);

  Reset(fTeams);

  with DataModule1 do
  begin

    while not Eof(fTeams) do
    begin
      Readln(fTeams, sLine);
      iPos := pos('-', sLine);
      sTeamName := copy(sLine, 1, iPos - 1);
      Delete(sLine, 1, iPos);
      sClubName := sLine;

      insertTeamInfo(sTeamName, sClubName);

    end;

    TeamTB.Edit;
    TeamTB.Post;
    TeamTB.Refresh;

  end;

end;

procedure TfrmTeams.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TfrmTeams.FormShow(Sender: TObject);
begin
  with DataModule1 do
  begin
    TeamTB.Open;

    TeamTB.First;

    lstTeams.Items.Clear;

    while not TeamTB.Eof do
    begin
      lstTeams.Items.Add(TeamTB['TeamName'] + ' from ' + TeamTB['ClubName']);
      TeamTB.Next;
    end;

  end;
  btnDelTeam.Enabled := false;

end;

procedure TfrmTeams.lstTeamsClick(Sender: TObject);
begin
  case lstTeams.ItemIndex of
    - 1:
      begin
        btnDelTeam.Enabled := false;
      end
  else
    begin
      btnDelTeam.Enabled := true;
    end;

  end;
end;

function TfrmTeams.insertTeamInfo(team: string; club: string): integer;
begin
  Result := 0;
  with DataModule1 do
  begin

    if team = '' then
    begin
      result := 11;
      Exit;
    end
    else if length(team) > 30 then
    begin
      result := 12;
      Exit;
    end
    else if util.isInTable(TeamTB, 'TeamName', team) then
    begin
      result := 13;
      Exit;
    end;

    if club = '' then
    begin
      result := 21;
      Exit;
    end
    else if length(club) > 30 then
    begin
      result := 22;
      Exit;
    end
    else if util.isInTable(TeamTB, 'ClubName', club) then
    begin
      result := 23;
      Exit;
    end;

    TeamTB.Last;
    TeamTB.Insert;

    TeamTB['TeamName'] := team;

    TeamTB['NumWon'] := 0;

    TeamTB['NumLost'] := 0;

    TeamTB['TournamentPosition'] := 0;

    TeamTB['ClubName'] := club;

    lstTeams.Items.Add(team + ' from ' + club);

  end;

end;

end.