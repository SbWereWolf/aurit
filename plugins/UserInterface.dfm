object PluginForm: TPluginForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1105#1090' '#1086' '#1090#1077#1082#1091#1097#1080#1093' '#1086#1089#1090#1072#1090#1082#1072#1093
  ClientHeight = 547
  ClientWidth = 526
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 526
    Height = 528
    ActivePage = TabQueries
    Align = alClient
    TabOrder = 0
    object TabQueries: TTabSheet
      Caption = #1047#1072#1087#1088#1086#1089#1099
      object Splitter1: TSplitter
        Left = 0
        Top = 311
        Width = 518
        Height = 3
        Cursor = crVSplit
        Align = alBottom
        ExplicitTop = 41
        ExplicitWidth = 215
      end
      object PanelTop: TPanel
        Left = 0
        Top = 0
        Width = 518
        Height = 161
        Align = alTop
        TabOrder = 0
        DesignSize = (
          518
          161)
        object Label1: TLabel
          Left = 8
          Top = 8
          Width = 193
          Height = 13
          Caption = #1054#1090#1095#1105#1090' '#1086' '#1090#1077#1082#1091#1097#1080#1093' '#1086#1089#1090#1072#1090#1082#1072#1093' '#1079#1072' '#1087#1077#1088#1080#1086#1076
        end
        object cbList: TComboBox
          Left = 8
          Top = 112
          Width = 502
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          OnChange = cbListChange
        end
        object ReportPeriodBegin: TDateTimePicker
          Left = 8
          Top = 27
          Width = 186
          Height = 21
          Date = 43729.546092673610000000
          Time = 43729.546092673610000000
          TabOrder = 1
        end
        object ReportPeriodEnd: TDateTimePicker
          Left = 8
          Top = 54
          Width = 186
          Height = 21
          Date = 43729.546092673610000000
          Time = 43729.546092673610000000
          TabOrder = 2
        end
        object doReporting: TButton
          Left = 8
          Top = 81
          Width = 114
          Height = 25
          Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100
          TabOrder = 3
          OnClick = doReportingClick
        end
      end
      object PanelQuery: TPanel
        Left = 0
        Top = 161
        Width = 518
        Height = 150
        Align = alClient
        Constraints.MinHeight = 150
        Constraints.MinWidth = 300
        TabOrder = 1
        object qMemo: TMemo
          Left = 1
          Top = 1
          Width = 516
          Height = 113
          Align = alClient
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          PopupMenu = PopupMenuQuery
          ScrollBars = ssBoth
          TabOrder = 0
        end
        object PanelButtons: TPanel
          Left = 1
          Top = 114
          Width = 516
          Height = 35
          Align = alBottom
          TabOrder = 1
          object LabelBusy: TLabel
            Left = 160
            Top = 6
            Width = 104
            Height = 19
            Caption = #1042#1099#1087#1086#1083#1085#1077#1085#1080#1077
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -16
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            Visible = False
          end
          object btnSelect: TButton
            Left = 7
            Top = 6
            Width = 114
            Height = 25
            Caption = #1042#1099#1073#1086#1088#1082#1072
            TabOrder = 0
            OnClick = btnSelectClick
          end
          object btnExec: TButton
            Left = 434
            Top = 5
            Width = 75
            Height = 25
            Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
            TabOrder = 1
            OnClick = btnExecClick
          end
        end
      end
      object PanelResult: TPanel
        Left = 0
        Top = 314
        Width = 518
        Height = 186
        Align = alBottom
        Constraints.MinHeight = 150
        Constraints.MinWidth = 200
        TabOrder = 2
        object Splitter2: TSplitter
          Left = 177
          Top = 1
          Height = 184
          ExplicitLeft = 192
          ExplicitTop = 32
          ExplicitHeight = 100
        end
        object DBGrid: TDBGrid
          Left = 180
          Top = 1
          Width = 337
          Height = 184
          Align = alClient
          DataSource = dsSelect
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          PopupMenu = PopupMenuGrid
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
        end
        object ParamsList: TValueListEditor
          Left = 1
          Top = 1
          Width = 176
          Height = 184
          Align = alLeft
          TabOrder = 1
          ColWidths = (
            68
            102)
        end
      end
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 528
    Width = 526
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object db: TpFIBDatabase
    DBName = 'c:\db\database.gdb'
    DBParams.Strings = (
      'user_name=SYSDBA'
      'lc_ctype=WIN1251'
      'password=masterkey'
      'sql_role_name=')
    DefaultTransaction = trans
    SQLDialect = 3
    Timeout = 0
    UseLoginPrompt = True
    WaitForRestoreConnect = 0
    Left = 216
    Top = 40
  end
  object trans: TpFIBTransaction
    DefaultDatabase = db
    Left = 256
    Top = 40
  end
  object qDeparts: TpFIBDataSet
    SelectSQL.Strings = (
      
        'select c.id_client as id_depart, c.short_client as "'#1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077 +
        '",'
      'count(d.id_doc) as "'#1082#1086#1083'-'#1074#1086' '#1089#1084#1077#1085'"'
      'from client c'
      
        'left join doc d on(d.id_client_from = c.id_client and d.id_oper ' +
        '=23 and d.state_doc =10)'
      'group by 1, 2')
    Transaction = trans
    Database = db
    Left = 264
    Top = 88
    object qDepartsID_DEPART: TFIBIntegerField
      FieldName = 'ID_DEPART'
    end
    object qDepartsНаименование: TFIBStringField
      FieldName = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      Size = 30
      EmptyStrToNull = True
    end
    object qDepartsколвосмен: TFIBIntegerField
      FieldName = #1082#1086#1083'-'#1074#1086' '#1089#1084#1077#1085
    end
  end
  object qTech_SUPPORT: TpFIBDataSet
    SelectSQL.Strings = (
      'select ID_QUERY, QUERY_TEXT, QUERY_NAME,'
      '    LOCAL, QUERY_TYPE  from tech_support'
      'union'
      'select 0, '#39'select * from []'#39', '#39'('#1055#1088#1086#1080#1079#1074#1086#1083#1100#1085#1099#1081' '#1079#1072#1087#1088#1086#1089')'#39','
      ' 1, '#39'?'#39' from RDB$DATABASE ')
    Transaction = trans
    Database = db
    Left = 428
    Top = 40
    object qTech_SUPPORTID_QUERY: TFIBIntegerField
      FieldName = 'ID_QUERY'
    end
    object qTech_SUPPORTQUERY_TEXT: TFIBMemoField
      FieldName = 'QUERY_TEXT'
      BlobType = ftMemo
      Size = 8
    end
    object qTech_SUPPORTQUERY_NAME: TFIBStringField
      FieldName = 'QUERY_NAME'
      Size = 150
      EmptyStrToNull = True
    end
    object qTech_SUPPORTLOCAL: TFIBIntegerField
      FieldName = 'LOCAL'
    end
    object qTech_SUPPORTQUERY_TYPE: TFIBStringField
      FieldName = 'QUERY_TYPE'
      Size = 1
      EmptyStrToNull = True
    end
  end
  object dsDeparts: TDataSource
    DataSet = qDeparts
    Left = 212
    Top = 88
  end
  object dsTech_Support: TDataSource
    DataSet = qTech_SUPPORT
    Left = 340
    Top = 40
  end
  object qExec: TpFIBQuery
    Transaction = trans
    Database = db
    Left = 340
    Top = 168
  end
  object qSelect: TpFIBDataSet
    Transaction = trans
    Database = db
    Left = 428
    Top = 88
  end
  object dsSelect: TDataSource
    DataSet = qSelect
    Left = 340
    Top = 88
  end
  object q1: TpFIBDataSet
    Transaction = trans
    Database = db
    Left = 428
    Top = 168
  end
  object PopupMenuQuery: TPopupMenu
    Left = 228
    Top = 169
    object N1: TMenuItem
      Action = Action1
    end
  end
  object ActionList1: TActionList
    Left = 156
    Top = 169
    object Action1: TAction
      Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
      ShortCut = 120
      OnExecute = Action1Execute
    end
  end
  object PopupMenuGrid: TPopupMenu
    Left = 36
    Top = 167
    object N2: TMenuItem
      Caption = #1057#1078#1072#1090#1100' '#1082#1086#1083#1086#1085#1082#1091
      OnClick = N2Click
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 100
    Top = 169
  end
end
