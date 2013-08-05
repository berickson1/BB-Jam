import bb.cascades 1.0
import bb.system 1.0
NavigationPane {
    id: nav
    Page {
        Container {
            layout: DockLayout {

            }
            Container {
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                CustomImageButton {
                    text: qsTr("New Energy Report").toUpperCase()
                    image: "asset:///images/newReport.png"
                    onClicked: {
                        promptNew.show();
                    }
                }
                CustomImageButton {
                    text: qsTr("Open Energy Report").toUpperCase()
                    image: "asset:///images/openReport.png"
                    onClicked: {
                        promptOpen.clearList();
                        promptOpen.appendItem("Test 1");
                        promptOpen.appendItem("Test 2");
                        promptOpen.show();
                    }
                }
            }
        }
    }

    attachedObjects: [
        PageLocation {
            id: pageLocation
        },
        SystemPrompt{
            id: promptNew
            title: qsTr("New Energy Report Name")
            modality: SystemUiModality.Application
            inputField.inputMode: SystemUiInputMode.Default
            inputField.emptyText: qsTr("Please enter a Energy Report name...")
            onFinished:{
                if (result == SystemUiResult.ConfirmButtonSelection){
                    console.log("Report Name: " + inputFieldTextEntry());
                    pageLocation.newReport = true;
                    pageLocation.name = inputFieldTextEntry();
                    nav.push(pageLocation);
                } else {
                    console.log("Prompt Closed");
                }
            }
        },
        SystemListDialog {
            property bool created: false
            id: promptOpen
            title: qsTr("Open Energy Report")
            selectionMode: ListSelectionMode.Single
            onFinished: {
                if (result == SystemUiResult.ConfirmButtonSelection){
                    console.log("Report Name Index: " + selectedIndices)
                    pageLocation.newReport = false;
                    //TODO: Wireup name passthrough
                    pageLocation.name = "";
                    nav.push(pageLocation);
                }
                
            }
            
        }
    ]
}
