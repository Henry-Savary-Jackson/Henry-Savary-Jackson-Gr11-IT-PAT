unit Supervisors_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, DMUnit_u;

type
  TfrmSupervisors = class(TForm)
    btnBack: TButton;
    lstSupervisors: TListBox;
    btnAddSupervisor: TButton;
    btnDelSupervisors: TButton;
    btnFileSupervisors: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBackClick(Sender: TObject);
    procedure btnAddSupervisorClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnFileSupervisorsClick(Sender: TObject);
    procedure saveToFile();
    procedure btnDelSupervisorsClick(Sender: TObject);
    procedure lstSupervisorsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    sID: string;
  end;

var
  frmSupervisors: TfrmSupervisors;
  fSupervisors: TextFile;

const
  fileName = 'Supervisors.txt';

implementation

uses
  Main_u;

{$R *.dfm}

procedure TfrmSupervisors.btnAddSupervisorClick(Sender: TObject);
var
  sSupervisorName: string;
begin
  sSupervisorName := inputBox('Supervisor Name', 'Enter their username:', '');

  // checks wheter supervisor is already listBox
  if not lstSupervisors.Items.IndexOf(sSupervisorName) = -1 then
  begin
    showMessage('Username already exists');
    Exit;
  end;

  // add supervisor username to listbox items
  lstSupervisors.Items.Add(sSupervisorName);

  // save new supervisor to file
  saveToFile();

end;

procedure TfrmSupervisors.btnBackClick(Sender: TObject);
begin
  // navigate back to main screen
  frmMain.Show;
  frmSupervisors.Hide;
end;

procedure TfrmSupervisors.btnDelSupervisorsClick(Sender: TObject);
begin
  // delete supervisor from list box
  lstSupervisors.Items.Delete(lstSupervisors.ItemIndex);

  // delete supervisor from file
  saveToFile();
end;

// Add supervisors through a textfile
procedure TfrmSupervisors.btnFileSupervisorsClick(Sender: TObject);
var
  fileChooser: TOpenDialog;
  sPath, sLine: string;
  fInput: TextFile;
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
    sPath := fileChooser.fileName;
  end // if
  else
  begin
    showMessage('Please choose a text file');
    Exit;
  end; // else

  // free file chooser
  fileChooser.Free;

  // read from textfile
  AssignFile(fInput, sPath);

  Reset(fInput);

  while not Eof(fInput) do
  begin
    // read supervisor name
    Readln(fInput, sLine);

    if not(lstSupervisors.Items.IndexOf(sLine) = -1) or (sLine = '') then
    begin
      // if Supervisor already added, or  supervisorname is empty, skip to next line
      Continue;
    end; // if

    // add to list box
    lstSupervisors.Items.Add(sLine);
  end; // while

  CloseFile(fInput);

  // saves newly added username to supervisors file.
  saveToFile();

  // user-friendly message
  showMessage('Succesfully saved new supervisor names.');

end;

procedure TfrmSupervisors.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // saves supervisors to file when closing application
  saveToFile();
  Application.Terminate;
end;

procedure TfrmSupervisors.FormShow(Sender: TObject);
var
  sLine: string;
begin
  // open table
  DataModule1.SupervisorTB.Open;

  // disable delete button
  btnDelSupervisors.Enabled := false;

  //reads from Supervisor.txt file
  if FileExists(fileName) then
  begin
    AssignFile(fSupervisors, fileName);

    Reset(fSupervisors);

    //clear list box
    lstSupervisors.Items.Clear;

    while not Eof(fSupervisors) do
    begin
      //read supervisor name
      Readln(fSupervisors, sLine);

      //add to list box
      lstSupervisors.Items.Add(sLine);
    end; // while not eof

    CloseFile(fSupervisors);

  end;

end;

procedure TfrmSupervisors.lstSupervisorsClick(Sender: TObject);
begin
//only enables delete button if a supervisor is clicked on
  case lstSupervisors.ItemIndex of
    - 1:
      begin
        btnDelSupervisors.Enabled := false;
      end
  else
    begin
      btnDelSupervisors.Enabled := true;
    end;
  end;
end;

// this procedure transfers the names in the listbox to the Supervisors.txt file
procedure TfrmSupervisors.saveToFile();
var
  I: integer;
begin;
  //create of repopulate supervisors text file
  AssignFile(fSupervisors, fileName);

  Rewrite(fSupervisors);

  //add all supervisors
  for I := 0 to lstSupervisors.Items.Count - 1 do
  begin
    Writeln(fSupervisors, lstSupervisors.Items[I]);
  end;

  CloseFile(fSupervisors);
end;

end.
