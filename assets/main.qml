import bb.cascades 1.0
import bb.system 1.0
NavigationPane {
    property variant qt_dbobject    
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
                        dbobject.outputReportItems(promptOpen);
                        promptOpen.show();
                    }
                }
            }
        }
    }

    attachedObjects: [
        ComponentDefinition {
            id: pageLocationDefinition
            source: "PageLocation.qml"
        },
        ComponentDefinition {
            id: pageItemsDefinition
            source: "PageItem.qml"
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
                    var pageLocation = pageLocationDefinition.createObject();
                    pageLocation.newReport = true;
                    pageLocation.name = inputFieldTextEntry();
                    pageLocation.id = dbobject.createReport(inputFieldTextEntry());
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
                    var pageLocation = pageLocationDefinition.createObject();
                    pageLocation.newReport = false;
                    pageLocation.name = dbobject.getSelectedReportName(selectedIndices[0]);
                    pageLocation.id = dbobject.getSelectedReportID(selectedIndices[0]);
                    nav.push(pageLocation);
                }
                
            }
            
        }
    ]
    onCreationCompleted: {
        qt_dbobject = dbobject;
    }
    onPopTransitionEnded: {
        page.destroy();
    }
}
