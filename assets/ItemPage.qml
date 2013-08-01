import bb.cascades 1.0

Page {
    property alias itemPageTitle: titlebar.title
    property alias listView: listView
    titleBar: TitleBar {
        id: titlebar
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
                    type: "object"
                    
                    Picker {
                        id: picker
                        title: ListItemData.name
                        
                        rootIndexPath: []
                        dataModel: XmlDataModel { source: "itemPicker.xml" }
                        
                        pickerItemComponents: [
                            PickerItemComponent {
                                type: "item1"
                                
                                content: Container {
                                    Label {
                                        text: pickerItemData.text
                                        verticalAlignment: VerticalAlignment.Center
                                        horizontalAlignment: HorizontalAlignment.Center
                                    }
                                }
                            },
                            PickerItemComponent {
                                type: "item2"
                                
                                content: Container {
                                    Label {
                                        text: pickerItemData.text
                                        verticalAlignment: VerticalAlignment.Center
                                        horizontalAlignment: HorizontalAlignment.Center
                                    }
                                }
                            },
                            PickerItemComponent {
                                type: "item3"
                                
                                content: Container {
                                    Label {
                                        text: pickerItemData.text
                                        verticalAlignment: VerticalAlignment.Center
                                        horizontalAlignment: HorizontalAlignment.Center
                                    }
                                }
                            }
                        ]
                        
                        onSelectedValueChanged: {
                            var index0 = picker.selectedIndex(0);
                            var index1 = picker.selectedIndex(1);
                            var index2 = picker.selectedIndex(2);
                            console.log("Selection: " + index0 + ", " + index1 + ", " + index2);
                        }
                    }
                
                }
            ]
        }
    }
}