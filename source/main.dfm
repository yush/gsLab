object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 536
  ClientWidth = 1119
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
    Width = 1119
    Height = 536
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      object Panel1: TPanel
        Left = 209
        Top = 0
        Width = 902
        Height = 508
        Align = alClient
        Caption = 'Panel1'
        Color = clMenu
        ParentBackground = False
        TabOrder = 0
        object Label2: TLabel
          Left = 8
          Top = 62
          Width = 46
          Height = 13
          Caption = 'repetition'
        end
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
        object vstPattern: TVirtualStringTree
          Left = 6
          Top = 346
          Width = 347
          Height = 145
          Header.AutoSizeIndex = -1
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          TabOrder = 0
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
          Left = 376
          Top = 1
          Width = 525
          Height = 506
          Align = alRight
          TabOrder = 1
          ControlData = {
            4C000000433600004C3400000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126209000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
        object btnProcess: TButton
          Left = 134
          Top = 153
          Width = 75
          Height = 25
          Caption = 'btnProcess'
          TabOrder = 2
          OnClick = btnProcessClick
        end
        object vlePos: TValueListEditor
          Left = 229
          Top = 24
          Width = 124
          Height = 126
          KeyOptions = [keyEdit, keyAdd, keyDelete, keyUnique]
          Strings.Strings = (
            'r=32'
            'l=32'
            'c=0')
          TabOrder = 3
          ColWidths = (
            36
            82)
        end
        object testCascadeInverse: TButton
          Left = 120
          Top = 242
          Width = 108
          Height = 25
          Caption = 'testCascadeInverse'
          TabOrder = 4
          OnClick = testTrick
        end
        object testHalfShower: TButton
          Left = 234
          Top = 242
          Width = 108
          Height = 25
          Caption = 'testHalfShower'
          TabOrder = 5
          OnClick = testTrick
        end
        object memoUrl: TMemo
          Left = 6
          Top = 273
          Width = 347
          Height = 56
          Lines.Strings = (
            'mmoResult')
          TabOrder = 6
        end
        object edtSs: TEdit
          Left = 88
          Top = 24
          Width = 120
          Height = 21
          TabOrder = 7
          Text = '423'
        end
        object edtRepetition: TEdit
          Left = 88
          Top = 59
          Width = 121
          Height = 21
          TabOrder = 8
          Text = '1'
        end
        object testCascade: TButton
          Left = 6
          Top = 242
          Width = 108
          Height = 25
          Caption = 'testCascade'
          TabOrder = 9
          OnClick = testTrick
        end
        object Button1: TButton
          Left = 9
          Top = 153
          Width = 75
          Height = 25
          Caption = 'init grid'
          TabOrder = 10
          OnClick = Button1Click
        end
        object mmoResult: TMemo
          Left = 9
          Top = 105
          Width = 200
          Height = 28
          Lines.Strings = (
            'mmoResult')
          TabOrder = 11
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 209
        Height = 508
        Align = alLeft
        Caption = 'Panel2'
        Color = clMenu
        ParentBackground = False
        TabOrder = 1
        object lstPattern: TListView
          Left = 1
          Top = 1
          Width = 207
          Height = 344
          Align = alTop
          Columns = <
            item
              AutoSize = True
              Caption = 'Tricks'
            end>
          GridLines = True
          Groups = <
            item
              GroupID = 0
              State = [lgsNormal]
              HeaderAlign = taLeftJustify
              FooterAlign = taLeftJustify
              TitleImage = -1
            end>
          TabOrder = 0
          ViewStyle = vsReport
          OnClick = lstPatternClick
        end
        object btnSave: TButton
          Left = 118
          Top = 399
          Width = 75
          Height = 25
          Caption = 'Save'
          TabOrder = 1
          OnClick = btnSaveClick
        end
        object btnLoad: TButton
          Left = 118
          Top = 368
          Width = 75
          Height = 25
          Caption = 'Load'
          TabOrder = 2
          OnClick = btnLoadClick
        end
        object btnAdd: TButton
          Left = 118
          Top = 430
          Width = 75
          Height = 25
          Caption = 'Add'
          TabOrder = 3
          OnClick = btnAddClick
        end
      end
    end
  end
end
