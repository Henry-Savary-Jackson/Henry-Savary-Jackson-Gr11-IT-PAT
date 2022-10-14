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
  lstSupervisors.Items.Delete(lstSupervisors.ItemIndex);
  saveToFile();
end;

procedure TfrmSupervisors.btnFileSupervisorsClick(Sender: TObject);
var
  fileChooser: TOpenDialog;
  sPath, sLine: string;
  fInput: TextFile;
begin
  fileChooser := TOpenDialog.Create(self);

  fileChooser.Filter := 'Text files|*.txt';

  fileChooser.FilterIndex := 1;

  if fileChooser.Execute then
  begin
    sPath := fileChooser.fileName;
  end
  else
  begin
    showMessage('Please choose a text file');
    Exit;
  end;

  fileChooser.Free;

  AssignFile(fInput, sPath);

  Reset(fInput);

  while not Eof(fInput) do
  begin
    Readln(fInput, sLine);

    if not(lstSupervisors.Items.IndexOf(sLine) = -1) or (sLine = '') then
    begin
      Continue;
    end;

    lstSupervisors.Items.Add(sLine);
  end;

  CloseFile(fInput);

  // saves newly added username to supervisors file.
  saveToFile();

  showMessage('Succesfully saved new supervisor names.');

end;

procedure TfrmSupervisors.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  saveToFile();
  Application.Terminate;
end;

procedure TfrmSupervisors.FormShow(Sender: TObject);
var
  sLine: string;
begin
  DataModule1.SupervisorTB.Open;
  btnDelSupervisors.Enabled := false;

  if FileExists(fileName) then
  begin
    AssignFile(fSupervisors, fileName);

    Reset(fSupervisors);

    lstSupervisors.Items.Clear;
    while not Eof(fSupervisors) do
    begin
      Readln(fSupervisors, sLine);
      lstSupervisors.Items.Add(sLine);
    end;

    CloseFile(fSupervisors);

  end;

end;

procedure TfrmSupervisors.lstSupervisorsClick(Sender: TObject);
begin
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
  AssignFile(fSupervisors, fileName);

  Rewrite(fSupervisors);

  for I := 0 to lstSupervisors.Items.Count - 1 do
  begin
    Writeln(fSupervisors, lstSupervisors.Items[I]);
  end;

  CloseFile(fSupervisors);
end;

end.
