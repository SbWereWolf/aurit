library techsupport;

uses
  System.SysUtils,
  System.Classes,
  System.UITypes,
  System.AnsiStrings,
  Vcl.Forms,
  windows,
  Unit1 in 'Unit1.pas' {PluginForm};

{$R *.res}
var
   Loaded : boolean = false;
   MainApplication,
   DefApp : TApplication;

// Функция первоначальной загрузки плагина
// на входе строки с названием вызывающего приложения и версии IDE
// плагин должен вернуть значения
// 1 - плагин расширение
// 2 - плагин драйвер
// 3 - плагин инъекция
// 0 - не подходит для вызывающего приложения
// для тестового задания использовать значение 1
//
function LoadPlugin(ApplicationName : Pchar;
                    IDEVersion : Pchar):integer; stdcall;
begin
   result := 1;
end;

// процедура инициализации плагина 
// вызывается после LoadPlugin для плагина 1 типа. 
// передает значение переменной Application и
// параметры доступа к базе данных
// результат: список строк, разделенных переносом строки
// каждая строка содержит значения, разделенные табуляцией
// 1) Имя метода, размещенного в разделе  exports
// 2) Краткое наименование метода
// 3) Описание
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
   result := 'TechSupport1'#9'Служба техподдержки'#9'Служебные функции для отдела сервиса';
end;

// Необязательная функция, возвращающая наименование библиотеки
// при отсутствии функции будет использовано название файла
//
function GetLibraryName:PChar; stdcall;
begin
   Result := 'Сервис';
end;

// метод плагина
// не принимает параметров
// возвращает результат работы 
//
function TechSupport1:boolean; stdcall;
begin
   if MainApplication = nil then
      exit;
   if PluginForm = nil then
      MainApplication.CreateForm(TPluginForm, PluginForm);

   result := PluginForm.ShowModal = mrOk;
end;

//  
// Процедура выгрузки библиотеки
// выполняет задачу корректнного завершения
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
   GetLibraryName
   TechSupport1,
   UnLoad;

begin
  DLLProc := @PluginDLLProc;
end.
