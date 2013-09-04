import bb.cascades 1.0
Page {
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
        id: locationPage
        visible: _app.getValueFor("locationTipsDone", "false")
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
        onCreationCompleted: {
            if (locationPage.visible == false) {
                locationTips.open();

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
        /*ActionItem {
            title: "Settings"
            ActionBar.placement: ActionBarPlacement.InOverflow
            imageSource: "asset:///images/settings.png"
            },*/
        ActionItem {
            title: "Share Results"
            ActionBar.placement: ActionBarPlacement.InOverflow
            imageSource: "asset:///images/share.png"
            onTriggered: {
                promptShare.show();
            }
        },
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
    attachedObjects: [
        Sheet {
            id: locationTips
            peekEnabled: false
            Page {
                Container {
                    Header {
                        title: "Walkthrough"
                    }
                    Label {
                        text: "Great! Now that you've opened a report you can add and remove items from your household. To get started, select a location in your home.\r\n\r\nFrom this page you can also access Results by clicking on the graph icon at the bottom of the page!"
                        multiline: true
                    }
                    Button {
                        horizontalAlignment: HorizontalAlignment.Center
                        text: "Continue"
                        onClicked: {
                            locationPage.visible = true;
                            locationTips.close();
                            _app.saveValueFor("locationTipsDone", locationPage.visible);
                        }
                    }
                }
            }
        }
    ]

}