unit AllocSuper_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmAllocSuper = class(TForm)
    btnBack: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAllocSuper: TfrmAllocSuper;

implementation

{$R *.dfm}

procedure TfrmAllocSuper.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Application.Terminate;
end;

end.
