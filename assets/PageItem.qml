import bb.cascades 1.0

Page {
    property alias itemPageTitle: titlebar.title
    titleBar: TitleBar {
        id: titlebar
    }
    Container {
        id: itemPage
        visible: _app.getValueFor("itemTipsDone", "false")

        ListView {
            id: itemListView
            dataModel: qt_dbobject.itemDataModel
            listItemComponents: [
                ListItemComponent {
                    type: "item"
                    Picker {
                        function updateEnergy(qty, hrs, months) {
                            console.log("New calculated Value: " + ListItemData.value * qty * hrs * months / 12 / 1000)
                            picker.description = parseFloat(ListItemData.value * qty * hrs * 365 * months / 12 / 1000).toFixed(2) + "kWh"
                        }
                        id: picker
                        title: ListItemData.name

                        rootIndexPath: []
                        dataModel: XmlDataModel {
                            source: "itemPicker.xml"
                        }
                        horizontalAlignment: HorizontalAlignment.Fill

                        pickerItemComponents: [
                            PickerItemComponent {
                                type: "quantity"
                                content: Container {
                                    layout: DockLayout {
                                    }
                                    Label {
                                        text: pickerItemData.text
                                        verticalAlignment: VerticalAlignment.Center
                                        horizontalAlignment: HorizontalAlignment.Center

                                        textStyle {
                                            base: SystemDefaults.TextStyles.PrimaryText
                                            fontSize: FontSize.Small
                                        }
                                    }

                                    Label {
                                        text: "quantity"
                                        verticalAlignment: VerticalAlignment.Bottom
                                        horizontalAlignment: HorizontalAlignment.Center

                                        textStyle {
                                            base: SystemDefaults.TextStyles.SmallText
                                            color: Color.Gray
                                        }
                                    }
                                }
                            },
                            PickerItemComponent {
                                type: "time"
                                content: Container {
                                    layout: DockLayout {
                                    }
                                    Label {
                                        text: pickerItemData.text
                                        verticalAlignment: VerticalAlignment.Center
                                        horizontalAlignment: HorizontalAlignment.Center

                                        textStyle {
                                            base: SystemDefaults.TextStyles.PrimaryText
                                            fontSize: FontSize.Small
                                        }
                                    }
                                    Label {
                                        text: "per day"
                                        verticalAlignment: VerticalAlignment.Bottom
                                        horizontalAlignment: HorizontalAlignment.Center

                                        textStyle {
                                            base: SystemDefaults.TextStyles.SmallText
                                            color: Color.Gray
                                        }
                                    }
                                }
                            },
                            PickerItemComponent {
                                type: "months"
                                content: Container {
                                    layout: DockLayout {
                                    }
                                    Label {
                                        text: pickerItemData.text
                                        verticalAlignment: VerticalAlignment.Center
                                        horizontalAlignment: HorizontalAlignment.Center

                                        textStyle {
                                            base: SystemDefaults.TextStyles.PrimaryText
                                            fontSize: FontSize.Small
                                        }
                                    }
                                    Label {
                                        text: "per year"
                                        verticalAlignment: VerticalAlignment.Bottom
                                        horizontalAlignment: HorizontalAlignment.Center

                                        textStyle {
                                            base: SystemDefaults.TextStyles.SmallText
                                            color: Color.Gray
                                        }
                                    }
                                }
                            }
                        ]

                        onSelectedValueChanged: {
                            var index0 = picker.selectedIndex(0);
                            var index1 = picker.selectedIndex(1);
                            var index2 = picker.selectedIndex(2);
                            ListItemData.quantityID = index0;
                            ListItemData.durationID = index1;
                            ListItemData.monthID = index2;
                            ListItemData.durationValue = dataModel.data([ 1, index1 ]).value;
                            ListItemData.monthValue = dataModel.data([ 2, index2 ]).value;
                            ListItem.view.updateItemValues(ListItemData);
                            updateEnergy(dataModel.data([ 0, index0 ]).value, dataModel.data([ 1, index1 ]).value, dataModel.data([ 2, index2 ]).value)
                            console.log("Selection: " + index0 + ", " + index1 + ", " + index2);
                        }
                        onCreationCompleted: {
                            picker.select(0, ListItemData.quantityID, ScrollAnimation.Smooth)
                            picker.select(1, ListItemData.durationID, ScrollAnimation.Smooth)
                            picker.select(2, ListItemData.monthID, ScrollAnimation.Smooth)
                            updateEnergy(dataModel.data([ 0, ListItemData.quantityID ]).value, dataModel.data([ 1, ListItemData.durationID ]).value, dataModel.data([ 2, ListItemData.monthID ]).value)
                        }
                        onExpandedChanged: {
                            console.log("New selection")
                            ListItem.view.scrollToItem(ListItem.indexPath, ScrollAnimation.None)
                            console.log("Scrolled")
                        }

                    }

                }
            ]

            function updateItemValues(listItemData) {
                //qt_dbobject.updateItemValues(listItemData)
            }
        }
        onCreationCompleted: {
            if (itemPage.visible == false) {
                itemTips.open();
            }
        }
    }
    attachedObjects: [
        Sheet {
            id: itemTips
            peekEnabled: false
            Page {
                Container {
                    Header {
                        title: "Walkthrough"
                    }
                    Label {
                        text: "Each location in your home contains multiple items.  Select an item in the list and select the appropriate values.  Once done, you can alter another item or go back.\r\n\r\nQuantity - How many of this item do you have\r\nTime - How long do you use this item per use?\r\nFrequency - How often do you use this item?"
                        multiline: true
                    }
                    Button {
                        horizontalAlignment: HorizontalAlignment.Center
                        text: "Continue"
                        onClicked: {
                            itemPage.visible = true;
                            itemTips.close();
                            _app.saveValueFor("itemTipsDone", itemPage.visible);
                        }
                    }
                }
            }
        }
    ]
}