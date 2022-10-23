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
    function insertTeamInfo(team: string; club: string): integer;
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

  // Obtain team name via editbox
  sTeamName := InputBox('Team name', 'Enter team''s name', '');

  // Obtain club name via editbox
  sClubName := InputBox('Club name', 'Enter name of this team''s club', '');

  with DataModule1 do
  begin

    // inserts the team's information into DB.

    // handle error codes to display user-friendly messages
    case insertTeamInfo(sTeamName, sClubName) of
      11:
        begin
          showMessage('Please enter a name for the team.');
          Exit;
        end;
      12:
        begin
          showMessage('Team''s name cannot be more than 30 characters.');
          Exit;
        end;
      13:
        begin
          showMessage('Team already exists.');
          Exit;
        end;
      21:
        begin
          showMessage('Please enter a name for the Club.');
          Exit;
        end;
      22:
        begin
          showMessage('Club''s name cannot be more than 30 characters.');
          Exit;
        end;
      23:
        begin
          showMessage('Club already exists.');
          Exit;
        end;
      31:
        begin
          showMessage('There can be no more than 12 teams.');
          Exit;
        end;
    end;

  end

end;

procedure TfrmTeams.btnBackClick(Sender: TObject);
begin
  // Naviguate to main screen
  frmTeams.Hide;
  frmMain.Show;
end;

procedure TfrmTeams.btnDelTeamClick(Sender: TObject);
var
  sName, sLine: string;
begin

  // obtain name of the team for deletion
  sLine := lstTeams.Items[lstTeams.ItemIndex];
  sName := copy(sLine, 1, pos(' from ', sLine) - 1);

  // delete item from listbox
  lstTeams.Items.Delete(lstTeams.ItemIndex);

  with DataModule1 do
  begin

    // go to team's record in Db and delete record
    util.GoToRecord(TeamTB, 'TeamName', sName);
    TeamTB.Delete;

  end; // with datamodule 1

  // disable button of deletion
  btnDelTeam.Enabled := false;

end;

// Add teams through a textfile
procedure TfrmTeams.btnFileTeamClick(Sender: TObject);
var
  fileChooser: TOpenDialog;
  sPath, sLine, sTeamName, sClubName: string;
  fTeams: TextFile;
  iPos, insertResult: integer;
begin

  // create file chooser
  fileChooser := TOpenDialog.Create(self);

  // only allow text file to be chosen
  fileChooser.Filter := 'Text files|*.txt';
  fileChooser.FilterIndex := 1;

  // show file chooser
  if fileChooser.Execute then
  begin
    // optain path to file
    sPath := fileChooser.FileName;
  end // if
  else
  begin
    showMessage('Please choose a text file');
    Exit;
  end; // else

  // free file chooser
  fileChooser.Free;

  // read from textfile
  AssignFile(fTeams, sPath);

  Reset(fTeams);

  with DataModule1 do
  begin

    while not Eof(fTeams) do
    begin

      // Read line
      // - is the delimiter between team and club name
      Readln(fTeams, sLine);
      iPos := pos('-', sLine);
      sTeamName := copy(sLine, 1, iPos - 1);
      Delete(sLine, 1, iPos);
      sClubName := sLine;

      // insert new record
      // if the limit of teams has been reached, cease to read from text file
      insertResult := insertTeamInfo(sTeamName, sClubName);

      if insertResult = 31 then
      begin
        Break;
      end;

    end; // while not eof

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
    // open table
    TeamTB.Open;

    TeamTB.First;

    // display all teams on listbox
    lstTeams.Items.Clear;

    while not TeamTB.Eof do
    begin
      lstTeams.Items.Add(TeamTB['TeamName'] + ' from ' + TeamTB['ClubName']);
      TeamTB.Next;
    end;

  end;
  // disable delete button
  btnDelTeam.Enabled := false;

end;

procedure TfrmTeams.lstTeamsClick(Sender: TObject);
begin
  // only enables delete button if a team is clicked on
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

// function to insert a team into DB
// return codes to indicate whether operation was successful or not
// If not, code specifies what problem occurred
function TfrmTeams.insertTeamInfo(team: string; club: string): integer;
begin
  // default success code
  Result := 0;
  with DataModule1 do
  begin

    if team = '' then
    begin
      // code for empty team name
      Result := 11;
      Exit;
    end
    else if length(team) > 30 then
    begin
      // code for overly long team name
      Result := 12;
      Exit;
    end
    else if util.isInTable(TeamTB, 'TeamName', team) then
    begin
      // code for attempting to add an already existing team
      Result := 13;
      Exit;
    end;

    if club = '' then
    begin
      // code for empty club name
      Result := 21;
      Exit;
    end
    else if length(club) > 30 then
    begin
      // code for overly long club name
      Result := 22;
      Exit;
    end
    else if util.isInTable(TeamTB, 'ClubName', club) then
    begin
      // code for adding club that already exists
      Result := 23;
      Exit;
    end
    else if TeamTB.RecordCount = 12 then
    begin
      // code for going past the limit of allowed teams
      Result := 31;
      Exit;
    end;

    // insert data into a new record
    TeamTB.Last;
    TeamTB.Insert;

    TeamTB['TeamName'] := team;

    TeamTB['NumWon'] := 0;

    TeamTB['NumLost'] := 0;

    TeamTB['TournamentPosition'] := 0;

    TeamTB['ClubName'] := club;

    util.UpdateTB(TeamTB);

    lstTeams.Items.Add(team + ' from ' + club);

  end;

end;

end.
