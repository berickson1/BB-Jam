import bb.cascades 1.0

Page {
    titleBar: TitleBar {
        title : "About"
    }
    Container {
        ScrollView {
            Container {
                  TextArea {
		            editable: false
		            focusHighlightEnabled: false
		            input.masking: TextInputMasking.Default
		            enabled: false
		            textStyle.fontSize: FontSize.Small
                    text: qsTr("Thank you for downloading Energy Report. Our goal was to make this application as simple as possible while handling a lot of data.\r\n\r\nThis application was developed by a computer engineer (programmer) and architectural technologist (designer).  We hope to bring a better understanding to the population about their energy use, and make them aware about just how much input (coal, oil, etc.) is required just for their use.  We are planning for further social integration, templates, costing, savings, and more in the pro iteration of the application so please stay tuned!\r\n\r\nThis app is for personal enjoyment and is provided as-is with no guarantee of accuracy.")
                }
                    TextArea {
                        editable: false
                        focusHighlightEnabled: false
                        input.masking: TextInputMasking.Default
                        enabled: false
                        textStyle.fontSize: FontSize.Small
                        text: qsTr("-BE + PM")
                    }
              }
        }
    }
}
