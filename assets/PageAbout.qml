import bb.cascades 1.0

Page {
    
    Container {
        Header {
            title: qsTr("About")
            subtitle: "Energy Report"

        }
        TextArea {
            editable: false
            focusHighlightEnabled: false
            input.masking: TextInputMasking.Default
            enabled: false
            textStyle.fontSize: FontSize.Small
            textStyle.color: Color.Black
            text: qsTr("Thank you for downloading Energy Report, a project by a computer science engineer and a designer.  Our goal ")

        }

    }
}
