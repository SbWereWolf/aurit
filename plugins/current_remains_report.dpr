library current_remains_report;

uses
  System.SysUtils,
  System.Classes,
  System.UITypes,
  System.AnsiStrings,
  Vcl.Forms,
  windows,
  UserInterface in 'UserInterface.pas' {PluginForm};

{$R *.res}
var
   Loaded : boolean = false;
   MainApplication,
   DefApp : TApplication;

// ������� �������������� �������� �������
// �� ����� ������ � ��������� ����������� ���������� � ������ IDE
// ������ ������ ������� ��������
// 1 - ������ ����������
// 2 - ������ �������
// 3 - ������ ��������
// 0 - �� �������� ��� ����������� ����������
// ��� ��������� ������� ������������ �������� 1
//
function LoadPlugin(ApplicationName : Pchar;
                    IDEVersion : Pchar):integer; stdcall;
begin
   result := 1;
end;

// ��������� ������������� ������� 
// ���������� ����� LoadPlugin ��� ������� 1 ����. 
// �������� �������� ���������� Application �
// ��������� ������� � ���� ������
// ���������: ������ �����, ����������� ��������� ������
// ������ ������ �������� ��������, ����������� ����������
// 1) ��� ������, ������������ � �������  exports
// 2) ������� ������������ ������
// 3) ��������
// 
function  InitPlugin(HostApplication : TApplication;
                     databasePath : Pchar;
                     gdsLibrary   : PChar;
                     user         : PChar;
                     password     : PChar):PChar; stdcall;
begin
   MainApplication := HostApplication;
   DefApp := Application;
   Application := HostApplication;
   TS_databasePath := StrPas(databasePath);
   TS_gdsLibrary := StrPas(gdsLibrary);
   result := 'CurrentRemainsReportPlugin'
   + #9'������ � ������� ��������'
   + #9'����� ��� ����� ����������';
end;

// �������������� �������, ������������ ������������ ����������
// ��� ���������� ������� ����� ������������ �������� �����
//
function GetLibraryName:PChar; stdcall;
begin
   Result := '������';
end;

// ����� �������
// �� ��������� ����������
// ���������� ��������� ������ 
//
function CurrentRemainsReportPlugin:boolean; stdcall;
begin
   if MainApplication = nil then
      exit;
   if PluginForm = nil then
      MainApplication.CreateForm(TPluginForm, PluginForm);

   result := PluginForm.ShowModal = mrOk;
end;

//  
// ��������� �������� ����������
// ��������� ������ ������������ ����������
//
procedure PluginDLLProc(Reason: Integer);
begin
    if not Loaded then
       exit;
   if Reason = DLL_PROCESS_DETACH then
   begin
      Application:=DefApp;
   end;
end;


exports
   LoadPlugin,
   InitPlugin,
   GetLibraryName,
   CurrentRemainsReportPlugin,
   PluginDLLProc;

begin
  DLLProc := @PluginDLLProc;
end.
