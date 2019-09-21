unit UserInterface;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Data.DB,
  FIBDataSet, pFIBDataSet, FIBDatabase, pFIBDatabase, Vcl.Grids, Vcl.DBGrids,
  FIBQuery, pFIBQuery, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.ValEdit, Vcl.Menus,
  System.Actions, Vcl.ActnList,FIBDBLoginDlg,
  IOUtils;

type
  TPluginForm = class(TForm)
    db: TpFIBDatabase;
    trans: TpFIBTransaction;
    qDeparts: TpFIBDataSet;
    PageControl: TPageControl;
    TabQueries: TTabSheet;
    qTech_SUPPORT: TpFIBDataSet;
    dsDeparts: TDataSource;
    dsTech_Support: TDataSource;
    qExec: TpFIBQuery;
    qSelect: TpFIBDataSet;
    dsSelect: TDataSource;
    q1: TpFIBDataSet;
    qTech_SUPPORTID_QUERY: TFIBIntegerField;
    qTech_SUPPORTQUERY_TEXT: TFIBMemoField;
    qTech_SUPPORTQUERY_NAME: TFIBStringField;
    qTech_SUPPORTLOCAL: TFIBIntegerField;
    qTech_SUPPORTQUERY_TYPE: TFIBStringField;
    PanelTop: TPanel;
    PanelQuery: TPanel;
    PanelResult: TPanel;
    Splitter1: TSplitter;
    qMemo: TMemo;
    DBGrid: TDBGrid;
    PanelButtons: TPanel;
    btnSelect: TButton;
    btnExec: TButton;
    ParamsList: TValueListEditor;
    Splitter2: TSplitter;
    qDepartsID_DEPART: TFIBIntegerField;
    qDepartsНаименование: TFIBStringField;
    qDepartsколвосмен: TFIBIntegerField;
    cbList: TComboBox;
    LabelBusy: TLabel;
    StatusBar: TStatusBar;
    PopupMenuQuery: TPopupMenu;
    N1: TMenuItem;
    ActionList1: TActionList;
    Action1: TAction;
    PopupMenuGrid: TPopupMenu;
    N2: TMenuItem;
    Timer1: TTimer;
    ReportPeriodBegin: TDateTimePicker;
    ReportPeriodEnd: TDateTimePicker;
    Label1: TLabel;
    doReporting: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnRemainsClick(Sender: TObject);
    procedure btnExecClick(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
    procedure cbListChange(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CloseTimerTimer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure doReportingClick(Sender: TObject);
  private
    fmPlugins : TForm;
    { Private declarations }
    procedure ConnectDb;
    procedure LoadList;
    procedure SelectQuery(id : integer);
    function GetDate(var control: TDateTimePicker): string;
  public
    { Public declarations }
    procedure OnAppRestore(Sender: TObject);
  end;

var
  PluginForm: TPluginForm;

  TS_databasePath : string;
  TS_gdsLibrary   : string;

  QueryText: string;

const
  QueryTextSource = 'current_remains_report.sql';
  ShortDateFormat = 'dd.MM.yyyy';

implementation
{$R *.dfm}

procedure TPluginForm.Action1Execute(Sender: TObject);
begin
   if btnSelect.Visible then
      btnSelectClick(Sender)
   else
     if btnExec.Visible then
      btnExecClick(Sender);
end;

procedure TPluginForm.btnExecClick(Sender: TObject);
var
   i : integer;
begin
   if Application.MessageBox('Выполнить запрос?', 'Предупреждение',
         MB_YESNO) = IDYES then
   begin
      qExec.SQL.Text := qMemo.Text;
      qExec.Prepare;
      if ParamsList.Visible then
         for i := 0 to ParamsList.RowCount-1 do
         begin
            if qExec.Params.FindParam(ParamsList.Keys[i]) = nil then
               continue;
            qExec.ParamByName(ParamsList.Keys[i]).AsString := ParamsList.Values[ParamsList.Keys[i]];
         end;
      qExec.ExecQuery;
   end;
end;

procedure TPluginForm.btnRemainsClick(Sender: TObject);
var
  mindate : TDateTime;
  question,
  DateStr : string;
  qRes : integer;
begin
   q1.SQLs.SelectSQL.Text := 'select min(date_doc_vn) from doc';
   q1.Open;
   if q1.Fields[0].IsNull then
   begin
      ShowMessage('не удалось найти дату первого документа');
      exit;
   end;
   mindate := q1.Fields[0].AsDateTime;
   q1.Close;
   question := 'Выполнить расчет остатков с ' + DateToStr(mindate);
   qRes := Application.MessageBox(@question[1], 'Внимание!', MB_YESNOCANCEL);
   if qRes = ID_CANCEL then
      exit;
   if qRes = ID_NO then
   begin
      dateStr := InputBox('Расчет за период', 'дата', dateStr);
      try
         mindate := StrToDate(dateStr);
      except

      end;
   end;
   q1.SQLs.SelectSQL.Text := 'select * from CALCULATE_ALL_REMAINS(:adate)';
   q1.ParamByName('adate').AsDateTime := minDate;
   q1.Open;
   ShowMessage('Рассчитано периодов: ' + IntToStr(q1.RecordCountFromSrv));
   q1.Close;


end;

procedure TPluginForm.btnSelectClick(Sender: TObject);
var
   i : integer;
begin
   if qSelect.Active then
      qSelect.Close;

   try
      Screen.Cursor := crHourGlass;
      LabelBusy.Visible := true;
      Invalidate;
      Application.ProcessMessages;
      qSelect.SQLs.SelectSQL.Text := qMemo.Text;
      qSelect.Prepare;
      if ParamsList.Visible then
         for i := 1 to ParamsList.RowCount-1 do
         begin
            if qSelect.Params.FindParam(ParamsList.Keys[i]) = nil then
               continue;
            qSelect.ParamByName(ParamsList.Keys[i]).AsString := ParamsList.Values[ParamsList.Keys[i]];
         end;
      qSelect.Open;
      StatusBar.SimpleText := 'строк: ' + IntToStr(qSelect.RecordCountFromSrv);
   finally
      Screen.Cursor := crDefault;
      LabelBusy.Visible := false;

   end;
end;

procedure TPluginForm.cbListChange(Sender: TObject);
var
   i : integer;
begin
   i := Integer(cbList.Items.Objects[cbList.ItemIndex]);

   SelectQuery(i);
end;

procedure TPluginForm.CloseTimerTimer(Sender: TObject);
begin
   ModalResult := mrCancel;
end;

procedure TPluginForm.ConnectDb;
begin
   db.Open(true);
   trans.StartTransaction;
   qDeparts.Open;
   qTech_SUPPORT.Filtered := false;
   qTech_SUPPORT.Open;
   LoadList;
   cbListChange(cbList);
end;

procedure TPluginForm.doReportingClick(Sender: TObject);
var
  endDate: TDateTime;
  i : integer;
  mayDo : boolean;

  beginAsString : string;
  endAsString : string;

begin

  Screen.Cursor := crHourGlass;
  LabelBusy.Visible := true;
  Invalidate;
  Application.ProcessMessages;

  mayDo := Length(QueryText) <> 0;
  if( mayDo and qSelect.Active )
  then
  begin
    qSelect.Close;
  end;

  beginAsString := GetDate(ReportPeriodBegin);
  endAsString := GetDate(ReportPeriodEnd);

  if(mayDo)
  then
  begin
    try
      qSelect.SQLs.SelectSQL.Text := QueryText;
      qSelect.Prepare;
      qSelect.ParamByName('dateBegin').AsString := beginAsString;
      qSelect.ParamByName('dateEnd').AsString := endAsString;
      qSelect.Open;
      StatusBar.SimpleText := 'строк: ' + IntToStr(qSelect.RecordCountFromSrv);
    finally
    end;
  end;

  Screen.Cursor := crDefault;
  LabelBusy.Visible := false;

end;

procedure TPluginForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Timer1.Enabled := false;
   if fmPlugins<>nil then
      fmPlugins.Show;
end;

procedure TPluginForm.FormCreate(Sender: TObject);
var
  isQueryFileExists: boolean;
  queryFile : TextFile;
  directory : string;
  path : string;
begin
   fmPlugins := nil;
   db.DatabaseName := TS_databasePath;
   db.LibraryName := TS_gdsLibrary;

  directory := ExtractFilePath(GetModuleName(HInstance));
  path := directory + QueryTextSource;
  isQueryFileExists := FileExists(path);
  if(isQueryFileExists)
  then
  begin
    QueryText := IOUtils.TFile.ReadAllText(path);
  end
  else
  begin
    QueryText := '';
  end;
end;

procedure TPluginForm.FormShow(Sender: TObject);
begin
   fmPlugins := TForm(Application.FindComponent('fmPlugins'));
   if fmPlugins<>nil then
      fmPlugins.Hide;
   PageControl.ActivePageIndex := 0;
   if trans.Active then
      trans.Commit;
   db.Close;
   try
      ConnectDb;
   finally
      Timer1.Enabled := not db.Connected;
   end;
end;

procedure TPluginForm.LoadList;
begin
   cbList.Items.Clear;
   while not qTech_SUPPORT.Eof do
   begin
      cbList.Items.AddObject(qTech_SUPPORTQUERY_NAME.AsString,
            Pointer(qTech_SUPPORTID_QUERY.AsInteger));
      qTech_SUPPORT.Next;
   end;
   cbList.ItemIndex := 0;
end;

procedure TPluginForm.N2Click(Sender: TObject);
var
   col,w : integer;
begin
   col := DBGrid.SelectedField.Index;
   w:= DBGrid.Columns.Items[col].Width;
   if w > 100  then
      w:= w div 2;
   DBGrid.Columns.Items[col].Width := w;
end;

procedure TPluginForm.OnAppRestore(Sender: TObject);
begin
   BringToFront;
end;

function  TPluginForm.GetDate(var control: TDateTimePicker):string;
var
  dateValue: TDateTime;
  date : string;
begin
  dateValue := control.DateTime;
  DateTimeToString(date, ShortDateFormat, dateValue);

  Result := date;
end;

procedure TPluginForm.SelectQuery(id: integer);
var
   Params : TFIBXSQLDA;
   i,j    : integer;
begin
   qTech_SUPPORT.Filter := 'ID_QUERY = ' + IntToStr(id);
   qTech_SUPPORT.Filtered := true;

   Params := nil;
   qSelect.Close;
   qMemo.Text := qTech_SUPPORTQUERY_TEXT.AsString;
   DBGrid.Visible := true;
   if qTech_SUPPORTID_QUERY.AsInteger=0 then
   begin
      btnSelect.Visible := True;
      btnExec.Visible := True;
   end
   else
   case qTech_SUPPORTQUERY_TYPE.AsString[1] of
      'S' : begin
               btnSelect.Visible := True;
               btnExec.Visible := False;
               qSelect.SQLs.SelectSQL.Text := qTech_SUPPORTQUERY_TEXT.AsString;
               qSelect.Prepare;
               Params := qSelect.Params;
            end;
      'I', 'D' : begin
               DBGrid.Visible := false;
               btnSelect.Visible := False;
               btnExec.Visible := True;
               qExec.SQL.Text := qTech_SUPPORTQUERY_TEXT.AsString;
               qExec.Prepare;
               Params := qExec.Params;
            end;
      else begin
              btnSelect.Visible := False;
              btnExec.Visible := False;
      end;
   end;
   if Params = nil then
   begin
      ParamsList.Visible:= false;
      exit;
   end;

   ParamsList.Visible := Params.Count > 0;
   if Params.Count > 0 then
   begin
      ParamsList.Strings.Clear;
      for i := 0 to Params.Count - 1 do
      begin
         if ParamsList.FindRow(Params[i].Name, j) then
            continue;
         ParamsList.Strings.Add(Params[i].Name + '=');
         if UpperCase(Params[i].Name) = 'ID_DEPART' then
            ParamsList.Values[Params[i].Name] := qDepartsID_DEPART.AsString;
      end;

   end;
end;

procedure TPluginForm.Timer1Timer(Sender: TObject);
begin
   Close;
end;

initialization
   PluginForm := nil;

end.
