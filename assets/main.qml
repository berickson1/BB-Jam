import bb.cascades 1.0
import bb.system 1.0
NavigationPane {
    property variant qt_dbobject
    id: nav
    Menu.definition: MenuDefinition {
        actions: [
            ActionItem {
                title: "Help"
                imageSource: "asset:///images/help.png"
                onTriggered: {
                    var pageHelp = pageHelpDefinition.createObject();
                    nav.push(pageHelp);
                }
            },
            ActionItem {
                title: "About"
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
            id: mainPage
            visible: _app.getValueFor("mainTipsDone", "false")
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
            onCreationCompleted: {
                if (mainPage.visible == false) {
                    mainTips.open();
                
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
        SystemPrompt {
            id: promptShare
            title: qsTr("Share Results")
            modality: SystemUiModality.Application
            inputField.inputMode: SystemUiInputMode.Default
            inputField.defaultText: "Using Energy Report, I discovered that I use " + qt_dbobject.getEnergyUsageActiveReport().toFixed(2) + " kWh a year!"
            onFinished: {
                if (result == SystemUiResult.ConfirmButtonSelection) {
                    console.log("Update BBM Status: " + inputFieldTextEntry());
                    qt_dbobject.sendBBMUpdate(inputFieldTextEntry())
                } else {
                    console.log("Share canceled!");
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
        },
        Sheet {
            id: mainTips
            peekEnabled: false
            Page {
                Container {
                    Container {
                        Header {
                            title: "Walkthrough"
                        }

                        Label {
                            text: "Welcome!\r\n\r\nThese helpful tips will help to guide you through the app on first run.  After clicking \"Continue\", you can either create a new report, or view & edit a sample report!"
                            multiline: true
                        }
                    }
                    Button {
                        horizontalAlignment: HorizontalAlignment.Center
                        text: "Continue"
                        onClicked: {
                            mainPage.visible = true;
                            mainTips.close();
                            _app.saveValueFor("mainTipsDone", mainPage.visible);
                        }

                    }
                }

            }
        }
    ]
    onCreationCompleted: {
        qt_dbobject = dbobject;
    }
    onPopTransitionEnded: {
        page.destroy();
        if (page.newReport != null) {
            savedToast.show();
        }
    }
    onTopChanged: {
        if (page.newReport != null) {
            page.refresh();
        }
    }
}
