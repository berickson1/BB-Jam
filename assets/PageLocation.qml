import bb.cascades 1.0
Page {
    objectName: locationPage
    property bool newReport
    property string name
    property int id
    function refresh(){
    //Bad idea, but it works...for now
    for(var i = 0; i < listViewLocation.dataModel.childCount([]); i++){
    	listViewLocation.select([i],true)

    }
    listViewLocation.clearSelection()
    }
    titleBar: TitleBar {
        id: titlebar
        title: name;
    }
    Container {
        ListView {
            id: listViewLocation
            dataModel: qt_dbobject.locationDataModel
            function getEnergyUsageByLocationID_ReportID(locationID){
            	return qt_dbobject.getEnergyUsageByLocationID_ReportID(locationID, id)
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
                        description: ListItem.view.getEnergyUsageByLocationID_ReportID(ListItemData.id)
                        imageSource: "asset:///" + ListItemData.image
                        ListItem.onSelectionChanged: { 
                        	setDescription(ListItem.view.getEnergyUsageByLocationID_ReportID(ListItemData.id))
                        }
                    }
                }
            ]
            onTriggered: {
                var chosenItem = dataModel.data(indexPath);
                qt_dbobject.readItemsByLocationID_ReportID(chosenItem.id, id)
                var pageItems = pageItemsDefinition.createObject();
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
            onTriggered: {
                savedToast.show()
            }
        },
        /*ActionItem {
            title: "Search"
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/search.png"
        },*/
        ActionItem {
            title: "Results"
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/pie.png"
            onTriggered: {
                var pageResults = pageResultsDefinition.createObject();
                pageResults.id = id;
                pageResults.name = name;
            	nav.push(pageResults);
            }

        },
        ActionItem {
            title: "Share"
            ActionBar.placement: ActionBarPlacement.InOverflow
            imageSource: "asset:///images/share.png"
            onTriggered: {
                _app.inviteUserToDownloadViaBBM();
            }
        },
        /*ActionItem {
            title: "Settings"
            ActionBar.placement: ActionBarPlacement.InOverflow
            imageSource: "asset:///images/settings.png"
        },*/
        ActionItem {
            title: "Save As"
            ActionBar.placement: ActionBarPlacement.InOverflow
            imageSource: "asset:///images/saveas.png"
            onTriggered: {
                promptSaveAs.show()
            }
        },
        /*ActionItem {
            title: "Edit"
            ActionBar.placement: ActionBarPlacement.InOverflow
            imageSource: "asset:///images/edit.png"
        },
        ActionItem {
            title: "Copy"
            ActionBar.placement: ActionBarPlacement.InOverflow
            imageSource: "asset:///images/copy.png"
        },*/
        DeleteActionItem {
            title: "Delete"
            ActionBar.placement: ActionBarPlacement.InOverflow
            imageSource: "asset:///images/delete.png"
            onTriggered: {
                promptDelete.show();
            }
        }
        
    ]
    
}