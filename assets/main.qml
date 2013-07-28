import bb.cascades 1.0
NavigationPane {
    id: nav
    Page {
        Container {
            ListView {
                dataModel: XmlDataModel {
                    source: "data.xml"
                }
                onTriggered: {

                    if (indexPath.length > 1) {
                        var chosenItem = dataModel.data(indexPath);
                        var contentpage = itemPageDefinition.createObject();

                        contentpage.itemPageTitle = chosenItem.name
                        nav.push(contentpage);
                    }
                }
            }

        }

    }
    attachedObjects: [
        ComponentDefinition {
            id: itemPageDefinition
            source: "ItemPage.qml"
        }
    ]
    onPopTransitionEnded: {
        page.destroy();
    }
}
