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

                Container {
                    verticalAlignment: VerticalAlignment.Center
                    bottomPadding: 20.0
                    ImageButton {
                        id: btnNewEnergyReport
                        defaultImageSource: "asset:///images/newReport.jpg"
                        onClicked: {
                            nav.push(pageLocation)
                        }
                    }
                    Label {
                        text: qsTr("New Energy Report")
                    }
                }
                Container {
                    verticalAlignment: VerticalAlignment.Center
                    topMargin: 20.0
                    ImageButton {
                        id: btnOpenEnergyReport
                        defaultImageSource: "asset:///images/openReport.jpg"
                    }
                    Label {
                        text: qsTr("Open Energy Report")
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
