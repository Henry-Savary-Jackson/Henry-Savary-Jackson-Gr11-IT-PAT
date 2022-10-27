unit Help_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TfrmHelp = class(TForm)
    btnBack: TButton;
    redHelp: TRichEdit;
    procedure btnBackClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmHelp: TfrmHelp;

implementation
uses
Login_u;

{$R *.dfm}

procedure TfrmHelp.btnBackClick(Sender: TObject);
begin
//Naviguate  back to login screen
frmLogin.Show;
frmHelp.Hide;
end;

procedure TfrmHelp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//terminate application
Application.Terminate;
end;

end.
