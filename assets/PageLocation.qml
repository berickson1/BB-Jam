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
            dataModel: qt_dbobject.locationDataModel
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
                var chosenItem = dataModel.data(indexPath);
                qt_dbobject.readItemsByLocationId(chosenItem.id)
                pageItems.itemPageTitle = chosenItem.name;
                nav.push(pageItems);
            }
        }

    }
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