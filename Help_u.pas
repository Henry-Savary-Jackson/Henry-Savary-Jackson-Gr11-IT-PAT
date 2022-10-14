unit Help_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TfrmHelp = class(TForm)
    btnBack: TButton;
    RichEdit1: TRichEdit;
    procedure btnBackClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmHelp: TfrmHelp;

implementation
uses
Main_u;

{$R *.dfm}

procedure TfrmHelp.btnBackClick(Sender: TObject);
begin
frmMain.Show;
frmHelp.Hide;
end;

end.
