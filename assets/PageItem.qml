import bb.cascades 1.0

Page {
    property alias itemPageTitle: titlebar.title
    titleBar: TitleBar {
        id: titlebar
    }
    Container {
        ListView {
            id: listView
            dataModel: qt_dbobject.itemDataModel
            listItemComponents: [
                ListItemComponent {
                    type: "item"

                    Picker {
                        function updateEnergy(qty, hrs, months){
                            console.log(ListItemData.value * qty * hrs * months / 12 / 1000)
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
                                type: "item1"

                                content: Label {
                                    text: pickerItemData.text
                                    verticalAlignment: VerticalAlignment.Center
                                    horizontalAlignment: HorizontalAlignment.Center
                                }
                            },
                            PickerItemComponent {
                                type: "item2"

                                content: Label {
                                    text: pickerItemData.text
                                    verticalAlignment: VerticalAlignment.Center
                                    horizontalAlignment: HorizontalAlignment.Center
                                }

                            },
                            PickerItemComponent {
                                type: "item3"

                                content: Label {
                                    text: pickerItemData.text
                                    verticalAlignment: VerticalAlignment.Center
                                    horizontalAlignment: HorizontalAlignment.Center
                                }
                            }
                        ]

                        onSelectedValueChanged: {
                            var index0 = picker.selectedIndex(0);
                            var index1 = picker.selectedIndex(1);
                            var index2 = picker.selectedIndex(2);
                            updateEnergy(dataModel.data([0,index0]).value,dataModel.data([1,index1]).value,dataModel.data([2,index2]).value)
                            console.log("Selection: " + index0 + ", " + index1 + ", " + index2);
                        }
                    }

                }
            ]
        }
    }
}