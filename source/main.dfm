object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 530
  ClientWidth = 1044
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1044
    Height = 530
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      DesignSize = (
        1036
        502)
      object lblPeriodLength: TLabel
        Left = 8
        Top = 86
        Width = 73
        Height = 13
        Caption = 'lblPeriodLength'
      end
      object Label1: TLabel
        Left = 8
        Top = 27
        Width = 42
        Height = 13
        Caption = 'siteswap'
      end
      object Label2: TLabel
        Left = 8
        Top = 62
        Width = 46
        Height = 13
        Caption = 'repetition'
      end
      object edtSs: TEdit
        Left = 88
        Top = 24
        Width = 120
        Height = 21
        TabOrder = 0
        Text = '423'
      end
      object Button1: TButton
        Left = 9
        Top = 153
        Width = 75
        Height = 25
        Caption = 'init grid'
        TabOrder = 1
        OnClick = Button1Click
      end
      object mmoResult: TMemo
        Left = 9
        Top = 105
        Width = 200
        Height = 28
        Lines.Strings = (
          'mmoResult')
        TabOrder = 2
      end
      object edtRepetition: TEdit
        Left = 88
        Top = 59
        Width = 121
        Height = 21
        TabOrder = 3
        Text = '1'
      end
      object btnProcess: TButton
        Left = 134
        Top = 153
        Width = 75
        Height = 25
        Caption = 'btnProcess'
        TabOrder = 4
        OnClick = btnProcessClick
      end
      object vlePos: TValueListEditor
        Left = 269
        Top = 24
        Width = 124
        Height = 126
        KeyOptions = [keyEdit, keyAdd, keyDelete, keyUnique]
        Strings.Strings = (
          'r=32'
          'l=32'
          'c=0')
        TabOrder = 5
        ColWidths = (
          36
          82)
      end
      object vstPattern: TVirtualStringTree
        Left = 9
        Top = 304
        Width = 384
        Height = 145
        Header.AutoSizeIndex = -1
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        TabOrder = 6
        TreeOptions.SelectionOptions = [toExtendedFocus]
        OnCreateEditor = vstPatternCreateEditor
        OnEditing = vstPatternEditing
        OnGetText = vstPatternGetText
        OnGetNodeDataSize = vstPatternGetNodeDataSize
        Columns = <
          item
            Position = 0
          end>
      end
      object WebBrowser1: TWebBrowser
        Left = 424
        Top = 0
        Width = 1054
        Height = 489
        Anchors = [akTop, akRight, akBottom]
        TabOrder = 7
        ExplicitHeight = 457
        ControlData = {
          4C000000EF6C00008A3200000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126209000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
      object memoUrl: TMemo
        Left = 9
        Top = 257
        Width = 384
        Height = 24
        Lines.Strings = (
          'mmoResult')
        TabOrder = 8
      end
      object testCascade: TButton
        Left = 269
        Top = 160
        Width = 108
        Height = 25
        Caption = 'testCascade'
        TabOrder = 9
        OnClick = testTrick
      end
      object testCascadeInverse: TButton
        Left = 269
        Top = 189
        Width = 108
        Height = 25
        Caption = 'testCascadeInverse'
        TabOrder = 10
        OnClick = testTrick
      end
      object testHalfShower: TButton
        Left = 269
        Top = 220
        Width = 108
        Height = 25
        Caption = 'testHalfShower'
        TabOrder = 11
        OnClick = testTrick
      end
    end
  end
end
