import bb.cascades 1.0
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
                        nav.push(pageLocation);
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
        }
    ]
}
