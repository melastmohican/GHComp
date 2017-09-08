unit TitleReg;

{$MODE Delphi}

interface
uses Classes, GraphPropEdits, Graphics, PropEdits, Title;

procedure Register;

implementation

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(TFont),TTitle,'',TFontProperty);
  RegisterPropertyEditor(TypeInfo(TColor),TTitle,'',TColorProperty);
  RegisterComponents('GHComp', [TTitle]);
end;


end.
