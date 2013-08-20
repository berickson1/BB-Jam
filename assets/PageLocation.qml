import bb.cascades 1.0
Page {
    property bool newReport
    property string name
    property int id
    titleBar: TitleBar {
        id: titlebar
        title: name;
    }
    Container {
        ListView {
            id: listView
            dataModel: XmlDataModel {
                id: listModel
                source: "data.xml"
            }
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
                        imageSource: "asset:///" + ListItemData.image
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
    actions: [
        ActionItem {
            title: "Save"
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/save.png"

        },
        ActionItem {
            title: "Search"
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/search.png"
        },
        ActionItem {
                    title: "Results"
                    ActionBar.placement: ActionBarPlacement.OnBar
                    imageSource: "asset:///images/pie.png"

        },
        ActionItem {
            title: "Share"
            ActionBar.placement: ActionBarPlacement.InOverflow
            imageSource: "asset:///images/share.png"

        },
        ActionItem {
            title: "Settings"
            ActionBar.placement: ActionBarPlacement.InOverflow
            imageSource: "asset:///images/settings.png"
        },
        ActionItem {
                    title: "Save As"
                    ActionBar.placement: ActionBarPlacement.InOverflow
                    imageSource: "asset:///images/saveas.png"
        },
        ActionItem {
            title: "Edit"
            ActionBar.placement: ActionBarPlacement.InOverflow
            imageSource: "asset:///images/edit.png"
        },
        ActionItem {
            title: "Copy"
            ActionBar.placement: ActionBarPlacement.InOverflow
            imageSource: "asset:///images/copy.png"
        },
        ActionItem {
            title: "Delete"
            ActionBar.placement: ActionBarPlacement.InOverflow
            imageSource: "asset:///images/delete.png"
        }
        
    ]
    
}

