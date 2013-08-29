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
                    text: qsTr("After choosing a new energy report, the user will be required to fill in the appropriate information regarding the report.  Please enter the name of the project.")
                
                }
                Divider {}
                TextArea {
                    editable: false
                    focusHighlightEnabled: false
                    enabled: false
                    textStyle.fontSize: FontSize.Small
                    
                    text: qsTr("Select a location from the list. From here, the user is able to select products associated with the location. Select the item, and fill in the appropriate information. Select the number of items (quantity), for how long the user will use the item (per day), and finally how often the user will use the item over the course of a year. Please note a few acronyms that may be helpful to remember: FF – Frost Free, MD – Manual Defrost, SC – Self Cleaning")
                }
                Divider {}
                TextArea {
                    editable: false
                    focusHighlightEnabled: false
                    enabled: false
                    textStyle.fontSize: FontSize.Small
                    
                    text: qsTr("As the user is completing the report, they may click on the Save button to save their progress.  Please note that by selecting the back button this will also automatically save their progress. After the user has completed the entries, the user shall select “Report” in the action menu to see the results of their input.  The user will be able to see their results in three different ways.  First is the yearly, monthly, weekly, daily, and hourly use of electricity in their household. The second is the required amount of electrical generation by type of production (Solar, Wind, Nuclear, Coal, Oil, and Natural Gas). Finally, the user will be able to see a graph of their use based on the locations.")
                }
                Header {
                    title: "Open Energy Report"
                }
                TextArea {
                    editable: false
                    focusHighlightEnabled: false
                    enabled: false
                    textStyle.fontSize: FontSize.Small
                    
                    text: qsTr("After the user selects Open Energy Report, the list of reports will be presented, and the user shall select the appropriate report. Once this has loaded, the use is identical to New Energy Report. Please see New Energy Report. If the user would like to copy the copy, and save it as a different report, they shall select “Save As” in the overflow menu; a prompt will follow allowing them to enter the name of the copied report. If the user wishes to delete the report, they may do so by selecting the overflow menu and selecting delete. ")
                }
            }

       }
    }
}
