import bb.cascades 1.0

Page {
    titleBar: TitleBar {
        title : "Help"
    }
    Container {
        ScrollView {
            Container {
                TextArea {
                    editable: false
                    focusHighlightEnabled: false
                    enabled: false
                    textStyle.fontSize: FontSize.Small
                    text: qsTr("Thank you for downloading Energy Report. Our goal was to make this application as simple as possible while handling a lot of data.")
                }
                
                Header {
                    title: "Introduction"
                }
                TextArea {
                    editable: false
                    focusHighlightEnabled: false
                    enabled: false
                    textStyle.fontSize: FontSize.Small
                    
                    text: qsTr("The initial screen welcomes the user with two options; New Energy Report, and Open Energy Report. Please choose appropriately. ")
                }
                Header {
                    title: "New Energy Report"
                }
                TextArea {
                    editable: false
                    focusHighlightEnabled: false
                    enabled: false
                    textStyle.fontSize: FontSize.Small
                    text: qsTr("After choosing a new energy report, the user will be required to fill in the appropriate information regarding the report.  Please enter the name of the project, select the household type, age of house, number of adults and children living in the house, country, and postal code/zip code. Once complete, click the “Continue” button to move on. ")
                
                }
                Divider {}
                TextArea {
                    editable: false
                    focusHighlightEnabled: false
                    enabled: false
                    textStyle.fontSize: FontSize.Small
                    
                    text: qsTr("Select a location from the list. From here, the user is able to select products associated with the location. Select the item, and fill in the appropriate information. Select the number of items (quantity), for how long the user will use the item (per day), and finally how often the user will use the item over the course of a year. ")
                }
                Header {
                    title: "Open Energy Report"
                }
                TextArea {
                    editable: false
                    focusHighlightEnabled: false
                    enabled: false
                    textStyle.fontSize: FontSize.Small
                    
                    text: qsTr("After choosing a new energy report, the user will be required to fill in the appropriate information regarding the report.  Please enter the name of the project, select the household type, age of house, number of adults and children living in the house, country, and postal code/zip code. Once complete, click the “Continue” button to move on. ")
                }
                Divider {
                }
            }

       }
    }
}
