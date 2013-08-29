import bb.cascades 1.0
import bb.system 1.0
NavigationPane {
    property variant qt_dbobject
    id: nav
    Menu.definition: MenuDefinition {
        actions: [
            ActionItem {
                title: "Help"
                ActionBar.placement: ActionBarPlacement.InOverflow
                imageSource: "asset:///images/help.png"
                onTriggered: {
                    var pageHelp = pageHelpDefinition.createObject();
                    nav.push(pageHelp);
                }
            },
            ActionItem {
                title: "About"
                ActionBar.placement: ActionBarPlacement.InOverflow
                //TODO: Add image
                //imageSource: "asset:///images/about.png"
                onTriggered: {
                    var pageAbout = pageAboutDefinition.createObject();
                    nav.push(pageAbout);
                }
            }
        ]
    }
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
                        if (dbobject.outputReportItems(promptOpen) > 0) {
                            promptOpen.show();
                        } else {
                            toastNoReport.show();
                        }
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
        ComponentDefinition {
            id: pageAboutDefinition
            source: "PageAbout.qml"
        },
        ComponentDefinition {
            id: pageHelpDefinition
            source: "PageHelp.qml"
        },
        ComponentDefinition {
            id: pageResultsDefinition
            source: "PageResults.qml"
        },
        SystemPrompt {
            id: promptNew
            title: qsTr("New Energy Report Name")
            modality: SystemUiModality.Application
            inputField.inputMode: SystemUiInputMode.Default
            inputField.emptyText: qsTr("Please enter a Energy Report name...")
            onFinished: {
                if (result == SystemUiResult.ConfirmButtonSelection) {
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
        SystemPrompt {
            id: promptSaveAs
            title: qsTr("Save As")
            modality: SystemUiModality.Application
            inputField.inputMode: SystemUiInputMode.Default
            inputField.emptyText: qsTr("Please enter a Energy Report name...")
            onFinished: {
                if (result == SystemUiResult.ConfirmButtonSelection) {
                    console.log("Save As Report Name: " + inputFieldTextEntry());
                    qt_dbobject.copyReport(inputFieldTextEntry())
                    nav.pop();
                } else {
                    console.log("Prompt Closed");
                }
            }
        },
        SystemDialog {
            id: promptDelete
            title: qsTr("Delete?")
            body: qsTr("This action will permanently delete this report")
            modality: SystemUiModality.Application
            onFinished: {
                if (result == SystemUiResult.ConfirmButtonSelection) {
                    qt_dbobject.deleteReport()
                    nav.pop();
                }
            }
        },
        SystemListDialog {
            property bool created: false
            id: promptOpen
            title: qsTr("Open Energy Report")
            selectionMode: ListSelectionMode.Single
            onFinished: {
                if (result == SystemUiResult.ConfirmButtonSelection) {
                    console.log("Report Name Index: " + selectedIndices)
                    var pageLocation = pageLocationDefinition.createObject();
                    pageLocation.newReport = false;
                    pageLocation.name = dbobject.getSelectedReportName(selectedIndices[0]);
                    pageLocation.id = dbobject.getSelectedReportID(selectedIndices[0]);
                    nav.push(pageLocation);
                }

            }

        },
        SystemToast {
            id: savedToast
            body: "Changes Saved!"
        },
        SystemToast {
            id: toastNoReport
            body: "No Saved Reports!"
        }
    ]
    onCreationCompleted: {
        qt_dbobject = dbobject;
    }
    onPopTransitionEnded: {
        page.destroy();
        if (page.id) {
            savedToast.show();
        }
    }
    onTopChanged: {
        if (page.id) [ page.refresh() ]
    }
}
