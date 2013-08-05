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
                        prompt.show()
                    }
                }
                CustomImageButton {
                    text: qsTr("Open Energy Report").toUpperCase()
                    image: "asset:///images/openReport.png"
                    onClicked: {
                        nav.push(pageLocation);
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
            id: prompt
            title: qsTr("New Energy Report Name")
            modality: SystemUiModality.Application
            inputField.inputMode: SystemUiInputMode.Default
            inputField.emptyText: qsTr("Please enter a Energy Report name...")
            onFinished:{
                if (result == SystemUiResult.ConfirmButtonSelection){
                    console.log(inputFieldTextEntry())
                    nav.push(pageLocation);
                } else {
                    console.log("Prompt Closed")
                }
            }
        }
    ]
}
