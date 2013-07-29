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
                        defaultImageSource: "asset:///images/newReport.png"
                        onClicked: {
                            nav.push(pageLocation)
                        }
                    }
                    Label {

                        text: qsTr("NEW ENERGY REPORT")
                        textFormat: TextFormat.Plain
                        textStyle.fontSize: FontSize.Large
                        textStyle.fontStyle: FontStyle.Normal
                        textStyle.fontWeight: FontWeight.Normal
                        textStyle.color: Color.DarkGreen
                    }
                }
                Container {
                    verticalAlignment: VerticalAlignment.Center
                    topMargin: 20.0
                    ImageButton {
                        id: btnOpenEnergyReport
                        defaultImageSource: "asset:///images/openReport.png"
                    }
                    Label {
                        text: qsTr("OPEN ENERGY REPORT")
                        textFormat: TextFormat.Plain
                        textStyle.fontSize: FontSize.Large
                        textStyle.fontStyle: FontStyle.Normal
                        textStyle.fontWeight: FontWeight.Normal
                        textStyle.color: Color.DarkGreen
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
