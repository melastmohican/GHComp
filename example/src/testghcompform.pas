unit TestGHCompForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, NumEdit,
  Title;

type

  { TTestGHCompForm }

  TTestGHCompForm = class(TForm)
    NumEdit1: TNumEdit;
    Title2: TTitle;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  TGHCForm: TTestGHCompForm;

implementation

{$R *.lfm}

end.

