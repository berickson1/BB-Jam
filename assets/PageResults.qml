import bb.cascades 1.0

Page {
    property string name
    property int id
    property variant energy: qt_dbobject.getEnergyUsageByReportID(id)
    titleBar: TitleBar {
        id: titlebar
        title: name;
    }
    Container {
        topPadding: 20.0
        ScrollView {
            content: Container {
                SegmentedControl {
                    options: [
                        Option {
                            text: qsTr("Summary")
                            onSelectedChanged: {
                                if (selected) {
                                    //Show Summary Container
                                    containerSummary.visible = true;
                                } else {
                                    //Hide Summary Container
                                    containerSummary.visible = false;
                                }
                            }
                        },
                        Option {
                            text: qsTr("Graph")
                            onSelectedChanged: {
                                if (selected) {
                                    //Display Graph Container
                                    containerGraph.visible = true;
                                } else {
                                    //Hide Graph Container
                                    containerGraph.visible = false;
                                }
                            }
                        },
                        Option {
                            text: qsTr("Energy Input")
                            onSelectedChanged: {
                                if (selected) {
                                    //Display Energy Use Container
                                    containerEnergyUse.visible = true;
                                } else {
                                    //Hide Energy Use Container
                                    containerEnergyUse.visible = false;
                                }
                            }
                        }
                    ]

                }
                Container {
                    id:containerSummary
                    horizontalAlignment: HorizontalAlignment.Center
                    Header {
                        title: "Energy Usage : " + energy.toFixed(2) + " kWh"
                        subtitle: energy.toFixed(2) + " kWh"
                    }
                    StandardListItem {
                        title: "Hourly"
                        description: (energy / 365.0 / 24.0).toFixed(2) + " kWh"
                        imageSource: "hour.png"

                    }
                    StandardListItem {
                        title: "Daily"
                        description: (energy / 365.0).toFixed(2) + " kWh"
                        imageSource: "day.png"

                    }
                    StandardListItem {
                        title: "Weekly"
                        description: (energy / 52.0).toFixed(2) + " kWh"
                        imageSource: "week.png"

                    }
                    StandardListItem {
                        title: "Monthly"
                        description: (energy / 12.0).toFixed(2) + " kWh"
                        imageSource: "month.png"

                    }
                    StandardListItem {
                        title: "Yearly"
                        description: energy.toFixed(2) + " kWh"
                        imageSource: "year.png"
                    
                    }

                }
                
                Container {
                    id:containerGraph
                    visible: false
                    WebView {
                        id: webGraph
                        url: "local:///assets/web/graph.html"
                        horizontalAlignment: HorizontalAlignment.Center
                    }
                    horizontalAlignment: HorizontalAlignment.Center
                }

                Container {
                    id: containerEnergyUse
                    visible: false
                    StandardListItem {
                        title: "Coal"
                        description: (energy / 1870).toFixed(2) + " Tonnes"
                        imageSource: "coal.png"

                    }
                    StandardListItem {
                        title: "Oil"
                        description: (energy / 1628.2).toFixed(2) + " Barrels"
                        imageSource: "oil.png"
                    }
                    StandardListItem {
                        title: "Wind"
                        description: (energy / 375.0).toFixed(2) + " Turbines"
                        imageSource: "wind.png"

                    }
                    StandardListItem {
                        title: "Nuclear"
                        description: (energy / 1000000.0).toFixed(4) + " Plants (1MW)"
                        imageSource: "nuclear.png"

                    }
                    StandardListItem {
                        title: "Natural Gas"
                        description: (energy / 125.0).toFixed(2) + " Cubic Feet"
                        imageSource: "naturalGas.png"
                    }
                }
            }
        }

    }
    actions: [
        
        ActionItem {
            title: "Share Results to BBM"
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/share.png"
            onTriggered: {
                promptShare.show();
            }
        }
    ]
}
