unit Utils_u;

interface

// This is a class meant for containing functions/methods used throughout
// the applications.
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Data.Win.ADODB, DMUnit_u, Vcl.Dialogs;

type
  Utils = class

  public
    { public declarations }
    function isInTable(table: TADOTable; field: string; val: Variant): boolean;
    function ContainsSpecialChar(str: string): boolean;
    function ContainsDigit(str: string): boolean;
    function GoToRecord(table: TADOTable; pk: string; val: Variant): integer;
    procedure GoToRecordAfter(table: TADOTable; field: string; val: Variant;
      iOccurences: integer);
    procedure GoToNextRecord(table: TADOTable; field: string; val: Variant);
    procedure UpdateTB(table: TADOTable);
    function SearchList(arr: TArray<string>; e: string): integer;

  end;

var
  util: Utils;

const
  specialChars = '!@#$%^&*()=+{}[]:;",.<>?/\|';
  digits = '0123456789';

implementation

{$J+}

// this function loops in an ado table to check whether a record whose field has
// a particular value exists
function Utils.isInTable(table: TADOTable; field: string; val: Variant)
  : boolean;
begin
  Result := false;

  with DataModule1 do
  begin
    table.First;

    while not table.Eof do
    begin
      if table[field] = val then
      begin
        Result := true;
        Exit;
      end; //if
      table.Next;

    end; //while not table eof
    table.First;

  end; // with DataModule1

end;

// goes to first record with a specified value,
// situated after wherever the table's pointer is located
procedure Utils.GoToNextRecord(table: TADOTable; field: string; val: Variant);
begin
  with DataModule1 do
  begin
    while not table.Eof do
    begin
      table.Next;
      if table[field] = val then
      begin
        Exit;
      end; //if

    end; //while not table eof
    ShowMessage('Could not find record.');

  end; // with DataModule 1
end;

//return the index of a specified value within a list using linear search
function Utils.SearchList(arr: TArray<string>; e: string): integer;
var
  I: integer;
begin
  for I := 0 to length(arr) - 1 do
  begin
    if arr[I] = e then
    begin
      Result := I;
      Exit;
    end;//if
  
  end; //for I
    
  Result := -1;
end;

procedure Utils.UpdateTB(table: TADOTable);
begin
//  Utility procedure to ensure a given table is up to date
table.Edit;
table.Post;
table.Refresh;
table.First;
end;

// this function checks whether a given string has atleast one special character
function Utils.ContainsSpecialChar(str: string): boolean;
var
  I: integer;
begin
  Result := false;
  for I := 1 to length(specialChars) do
  begin
    if not(pos(specialChars[I], str) = 0) then
    begin
      Result := true;
      Exit;
    end; //of
  end; //for I

end;

  // sets the pointer of a given table to next record with a specified value in a field
  // after a given amount of occurrences beforehand
procedure Utils.GoToRecordAfter(table: TADOTable; field: string; val: Variant;
  iOccurences: integer);
var
  I: integer;
begin
  with DataModule1 do
  begin
    table.First;
    I := 0;
    while (I < iOccurences) do
    begin
      if table.Eof then
      begin
        ShowMessage('Could not find record.');
        Exit;
      end; //if

      if table[field] = val then
      begin
        I := I + 1;
      end; //if
      table.Next;

    end; // while i < occurrence

    while not table.Eof do
    begin
      if table[field] = val then
      begin
        Exit;
      end;
      table.Next;
    end; //with not table eof
    ShowMessage('Could not find record.');

  end;
end;

// Sets pointer to record with specified primary key value
function Utils.GoToRecord(table: TADOTable; pk: string; val: Variant): integer;
begin
  with DataModule1 do
  begin
    table.First;
    Result := 0;
    while not table.Eof do
    begin
      if table[pk] = val then
      begin
        Result := 1;
        Exit;
      end;
      table.Next;

    end;

  end;
end;

// check wheter a string contains at least one digit
function Utils.ContainsDigit(str: string): boolean;
var
  I: integer;
begin
  Result := false;
  for I := 1 to length(digits) do
  begin
    if not(pos(digits[I], str) = 0) then
    begin
      Result := true;
      Exit;
    end; // if

  end; // for I

end;

end.
