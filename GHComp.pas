{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit GHComp;

interface

uses
  NumEdit, Title, TitleReg, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('NumEdit', @NumEdit.Register);
  RegisterUnit('TitleReg', @TitleReg.Register);
end;

initialization
  RegisterPackage('GHComp', @Register);
end.
