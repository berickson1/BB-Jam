import bb.cascades 1.0
Page {
    property bool newReport
    property string name
    property int id
    Container {
        ListView {
            id: listView
            dataModel: dbobject.dataModel()
            listItemComponents: [
                ListItemComponent {
                    type: "header"

                    Header {
                        title: ListItemData.title
                    }

                },
                ListItemComponent {
                    type: "item"

                    StandardListItem {
                        title: ListItemData.name
                        imageSource: "asset:///images/" + ListItemData.image
                    }
                }
            ]
            onTriggered: {

                if (indexPath.length > 1) {
                    var chosenItem = dataModel.data(indexPath);
                    var contentpage = itemPageDefinition.createObject();
                    
                    contentpage.listView.rootIndexPath = indexPath;
                    contentpage.itemPageTitle = chosenItem.name
                    
                    nav.push(contentpage);
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
}

