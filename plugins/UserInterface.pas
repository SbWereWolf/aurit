unit UserInterface;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Data.DB,
  FIBDataSet, pFIBDataSet, FIBDatabase, pFIBDatabase, Vcl.Grids, Vcl.DBGrids,
  FIBQuery, pFIBQuery, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.ValEdit, Vcl.Menus,
  System.Actions, Vcl.ActnList, FIBDBLoginDlg,
  IOUtils,
  RemainsRecord,
  XMLIntf,
  XmlDoc;

type

  TRemainsArray = array of TRemains;

  TPluginForm = class(TForm)
    DB: TpFIBDatabase;
    trans: TpFIBTransaction;
    PageControl: TPageControl;
    qSelect: TpFIBDataSet;
    StatusBar: TStatusBar;
    Timer1: TTimer;
    TabQueries: TTabSheet;
    Splitter1: TSplitter;
    PanelTop: TPanel;
    Label1: TLabel;
    LabelBusy: TLabel;
    ReportPeriodBegin: TDateTimePicker;
    ReportPeriodEnd: TDateTimePicker;
    doReporting: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CloseTimerTimer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure doReportingClick(Sender: TObject);
  private
    fmPlugins: TForm;
    { Private declarations }
    procedure ConnectDb;
    function GetDate(var control: TDateTimePicker): string;
    function ExtractData(recordsNumbers: integer): TRemainsArray;
    function addNextNode(current: TRemains; rootNode: IXMLNode; index: integer)
      : IXMLNode;
    function setupXmlHandler(): IXMLDocument;
  public
    { Public declarations }
    procedure OnAppRestore(Sender: TObject);
  end;

var
  PluginForm: TPluginForm;

  TS_databasePath: string;
  TS_gdsLibrary: string;

  QueryText: string;
  WorkingPath: string;

const
  QueryTextSource = 'current_remains_report.sql';
  OutputFile = 'current_remains_report.xml';
  ShortDateFormat = 'dd.MM.yyyy';

implementation

{$R *.dfm}


procedure TPluginForm.CloseTimerTimer(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TPluginForm.ConnectDb;
begin
  DB.Open(true);
  trans.StartTransaction;
end;

procedure TPluginForm.doReportingClick(Sender: TObject);
var
  recordsNumbers: integer;
  mayDo: boolean;

  beginAsString: string;
  endAsString: string;
  hasData: boolean;
  remains: TRemainsArray;

  xml: IXMLDocument;
  rootNode: IXMLNode;
  index: integer;

  current: TRemains;
  filename: string;

begin

  Screen.Cursor := crHourGlass;
  LabelBusy.Visible := true;
  Invalidate;
  Application.ProcessMessages;

  mayDo := Length(QueryText) <> 0;
  if (mayDo and qSelect.Active) then
  begin
    qSelect.Close;
  end;

  beginAsString := GetDate(ReportPeriodBegin);
  endAsString := GetDate(ReportPeriodEnd);

  hasData := false;
  if (mayDo) then
  begin
    try
      qSelect.SQLs.SelectSQL.Text := QueryText;
      qSelect.Prepare;
      qSelect.ParamByName('dateBegin').AsString := beginAsString;
      qSelect.ParamByName('dateEnd').AsString := endAsString;
      qSelect.Open;

      recordsNumbers := qSelect.RecordCountFromSrv;
      StatusBar.SimpleText := 'строк: ' + IntToStr(recordsNumbers);
      hasData := recordsNumbers > 0;
    except
      StatusBar.SimpleText := 'СБОЙ выполнения запроса';
    end;
  end;

  if (hasData) then
  begin
    remains := ExtractData(recordsNumbers);
    xml := setupXmlHandler();
    rootNode := xml.AddChild('ReportData');

    for index := 1 to recordsNumbers do
    begin
      current := remains[index - 1];
      addNextNode(current, rootNode, index);
    end;

    filename := WorkingPath + OutputFile;
    xml.SaveToFile(WorkingPath + OutputFile);
    StatusBar.SimpleText := 'Данные отчёта выгружены в ' + filename;

  end;

  qSelect.Close;

  Screen.Cursor := crDefault;
  LabelBusy.Visible := false;

end;

procedure TPluginForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled := false;
  if fmPlugins <> nil then
    fmPlugins.Show;
end;

procedure TPluginForm.FormCreate(Sender: TObject);
var
  isQueryFileExists: boolean;
  queryFile: TextFile;
  directory: string;
  path: string;
begin
  fmPlugins := nil;
  DB.DatabaseName := TS_databasePath;
  DB.LibraryName := TS_gdsLibrary;

  directory := ExtractFilePath(GetModuleName(HInstance));
  WorkingPath := directory;

  path := WorkingPath + QueryTextSource;
  isQueryFileExists := FileExists(path);
  if (isQueryFileExists) then
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
  if fmPlugins <> nil then
    fmPlugins.Hide;
  PageControl.ActivePageIndex := 0;
  if trans.Active then
    trans.Commit;
  DB.Close;
  try
    ConnectDb;
  finally
    Timer1.Enabled := not DB.Connected;
  end;
end;

procedure TPluginForm.OnAppRestore(Sender: TObject);
begin
  BringToFront;
end;

function TPluginForm.setupXmlHandler(): IXMLDocument;
var
  xml: IXMLDocument;
begin
  xml := NewXMLDocument;
  xml.Encoding := 'utf-8';
  xml.Options := [doNodeAutoIndent];

  Result := xml;
end;

function TPluginForm.addNextNode(current: TRemains; rootNode: IXMLNode;
  index: integer): IXMLNode;
var
  CurNode: IXMLNode;
begin
  CurNode := rootNode.AddChild('DataRecord');

  CurNode.Attributes['recordIndex'] := IntToStr(index);
  CurNode.Attributes['period'] := current.period;
  CurNode.Attributes['moKod'] := current.moKod;
  CurNode.Attributes['moTitle'] := current.moTitle;
  CurNode.Attributes['remedyTitle'] := current.remedyTitle;
  CurNode.Attributes['tradeTitle'] := current.tradeTitle;
  CurNode.Attributes['packTitle'] := current.packTitle;
  CurNode.Attributes['amountInPack'] := current.amountInPack;
  CurNode.Attributes['manufacturer'] := current.manufacturer;
  CurNode.Attributes['priceLimit'] := current.priceLimit;
  CurNode.Attributes['packsPurchased'] := current.packsPurchased;
  CurNode.Attributes['price'] := current.price;
  CurNode.Attributes['cost'] := current.cost;
  CurNode.Attributes['supplier'] := current.supplier;
  CurNode.Attributes['packsUsed'] := current.packsUsed;
  CurNode.Attributes['registrationNumber'] := current.registrationNumber;
  CurNode.Attributes['invoiceNumber'] := current.invoiceNumber;
  CurNode.Attributes['invoiceDate'] := current.invoiceDate;
  CurNode.Attributes['moneySource'] := current.moneySource;
  CurNode.Attributes['serviceCondition'] := current.serviceCondition;

  Result := CurNode;
end;

function TPluginForm.ExtractData(recordsNumbers: integer): TRemainsArray;
var
  index: integer;
  current: TRemains;
  remains: TRemainsArray;
begin
  begin
    SetLength(remains, recordsNumbers);
    index := 0;
    qSelect.First;
    while (not qSelect.Eof) and (index < recordsNumbers) do
    begin

      current.period := qSelect.FieldByName('dat').AsString;
      current.moKod := qSelect.FieldByName('kod_mo').AsString;
      current.moTitle := qSelect.FieldByName('name_mo').AsString;
      current.remedyTitle := qSelect.FieldByName('name_prep').AsString;
      current.tradeTitle := qSelect.FieldByName('torg_name_ls').AsString;
      current.packTitle := qSelect.FieldByName('med_form_o').AsString + ';' +
        qSelect.FieldByName('med_doz').AsString;
      current.amountInPack := qSelect.FieldByName('kol_v_upak').AsString;
      current.manufacturer := qSelect.FieldByName('name_provider').AsString;
      current.priceLimit := qSelect.FieldByName('cena_opt_nds').AsString;
      current.packsPurchased := qSelect.FieldByName('prihod').AsString;
      current.price := qSelect.FieldByName('cena_gr').AsString;
      current.cost := qSelect.FieldByName('suma').AsString;
      current.supplier := qSelect.FieldByName('name_firm').AsString;
      current.packsUsed := qSelect.FieldByName('rashod').AsString;
      current.registrationNumber :=
        qSelect.FieldByName('nom_reg_udost').AsString;
      current.invoiceNumber := qSelect.FieldByName('num').AsString;
      current.invoiceDate := qSelect.FieldByName('dat').AsString;
      current.moneySource := qSelect.FieldByName('ist_finans').AsString;
      current.serviceCondition := qSelect.FieldByName('usl_ok_med_pom')
        .AsString;
      current.contractNumber := qSelect.FieldByName('num').AsString;

      remains[index] := current;
      index := index + 1;
      qSelect.Next;
    end;
  end;

  Result := remains;
end;

function TPluginForm.GetDate(var control: TDateTimePicker): string;
var
  dateValue: TDateTime;
  date: string;
begin
  dateValue := control.DateTime;
  DateTimeToString(date, ShortDateFormat, dateValue);

  Result := date;
end;

procedure TPluginForm.Timer1Timer(Sender: TObject);
begin
  Close;
end;

initialization

PluginForm := nil;

end.
