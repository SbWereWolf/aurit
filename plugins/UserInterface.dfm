object PluginForm: TPluginForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1105#1090' '#1086' '#1090#1077#1082#1091#1097#1080#1093' '#1086#1089#1090#1072#1090#1082#1072#1093
  ClientHeight = 190
  ClientWidth = 311
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
    Width = 311
    Height = 171
    ActivePage = TabQueries
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 510
    ExplicitHeight = 244
    object TabQueries: TTabSheet
      Caption = #1047#1072#1087#1088#1086#1089#1099
      ExplicitWidth = 502
      ExplicitHeight = 216
      object Splitter1: TSplitter
        Left = 0
        Top = 140
        Width = 303
        Height = 3
        Cursor = crVSplit
        Align = alBottom
        ExplicitTop = 41
        ExplicitWidth = 215
      end
      object PanelTop: TPanel
        Left = 0
        Top = 0
        Width = 303
        Height = 214
        Align = alTop
        TabOrder = 0
        ExplicitWidth = 505
        object Label1: TLabel
          Left = 8
          Top = 8
          Width = 193
          Height = 13
          Caption = #1054#1090#1095#1105#1090' '#1086' '#1090#1077#1082#1091#1097#1080#1093' '#1086#1089#1090#1072#1090#1082#1072#1093' '#1079#1072' '#1087#1077#1088#1080#1086#1076
        end
        object LabelBusy: TLabel
          Left = 18
          Top = 112
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
        object ReportPeriodBegin: TDateTimePicker
          Left = 8
          Top = 27
          Width = 186
          Height = 21
          Date = 43729.546092673610000000
          Time = 43729.546092673610000000
          TabOrder = 0
        end
        object ReportPeriodEnd: TDateTimePicker
          Left = 8
          Top = 54
          Width = 186
          Height = 21
          Date = 43729.546092673610000000
          Time = 43729.546092673610000000
          TabOrder = 1
        end
        object doReporting: TButton
          Left = 8
          Top = 81
          Width = 114
          Height = 25
          Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100
          TabOrder = 2
          OnClick = doReportingClick
        end
      end
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 171
    Width = 311
    Height = 19
    Panels = <>
    SimplePanel = True
    ExplicitTop = 244
    ExplicitWidth = 510
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
  object qSelect: TpFIBDataSet
    Transaction = trans
    Database = db
    Left = 220
    Top = 88
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 252
    Top = 89
  end
end
