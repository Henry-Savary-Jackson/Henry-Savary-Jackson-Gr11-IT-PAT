unit DMUnit_u;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TDataModule1 = class(TDataModule)
    DSTeamTB: TDataSource;
    ADOConnection1: TADOConnection;
    TeamTB: TADOTable;
    MatchTB: TADOTable;
    MatchAllocTB: TADOTable;
    OrganiserTB: TADOTable;
    SupervisorTB: TADOTable;
    DSMatchTB: TDataSource;
    DSMatchAllocTB: TDataSource;
    DSOrganiserTB: TDataSource;
    DSSupervisorTB: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin

ADOConnection1.Close;

ADOConnection1.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+ExtractFilePath(ParamStr(0))+'TournamentDB.mdb'+';Persist Security Info=False' ;

ADOConnection1.LoginPrompt := FALSE;

ADOConnection1.Open;

TeamTB.Connection := ADOConnection1;
TeamTB.TableName := 'TeamTB' ;

MatchTB.Connection := ADOConnection1;
MatchTB.TableName := 'MatchTB' ;

MatchAllocTB.Connection := ADOConnection1;
MatchAllocTB.TableName := 'MatchAllocTB' ;

OrganiserTB.Connection := ADOConnection1;
OrganiserTB.TableName := 'OrganiserTB' ;

SupervisorTB.Connection := ADOConnection1;
SupervisorTB.TableName := 'SupervisorTB' ;

DSTeamTB.DataSet := TeamTB;
DSMatchTB.DataSet := MatchTB;
DSMatchAllocTB.DataSet := MatchAllocTB;
DSOrganiserTB.DataSet := OrganiserTB;
DSSupervisorTB.DataSet := SupervisorTB;

//leave this line of code commented
//ADOQuery1.Connection := ADOConnection1;
end;

end.
