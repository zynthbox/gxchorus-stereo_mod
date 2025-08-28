/* -*- coding: utf-8 -*-
******************************************************************************
ZYNTHIAN PROJECT: Zynthian Qt GUI

Main Class and Program for Zynthian GUI

Copyright (C) 2021 Marco Martin <mart@kde.org>

******************************************************************************

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License as
published by the Free Software Foundation; either version 2 of
the License, or any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

For a full copy of the GNU General Public License see the LICENSE.txt file.

******************************************************************************
*/

import QtQuick 2.10
import QtQml 2.15
import QtQuick.Layouts 1.4
import QtQuick.Controls 2.2 as QQC2
import org.kde.kirigami 2.4 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore
import "." as Here
import Zynthian 1.0 as Zynthian
import QtGraphicalEffects 1.15

Item {
    id: root
    property bool debugMode: false
    property int knobSize: 120

    QQC2.Control {
        enabled: zynqtgui.curlayerEngineId != null
        height: parent.height*0.9
        width: parent.width* 0.7
        anchors.centerIn: parent
        padding: 10
        background: Item {

            Image {
                id: _imgBg
                visible: false
                source: "pedal.png"
                anchors.fill: parent
            }
            DropShadow {
                anchors.fill: _imgBg
                horizontalOffset: 3
                verticalOffset: 3
                radius: 8.0
                samples: 17
                color: "#80000000"
                source: _imgBg
            }

        }
        contentItem: Item {

            QQC2.Switch {
                anchors.bottom: parent.bottom
                x: 200
                anchors.bottomMargin: 20
                text: qsTr("Bypass")
                checked: zynqtgui.control.selectedEngineBypassController ? zynqtgui.control.selectedEngineBypassController.value === zynqtgui.control.selectedEngineBypassController.value_default : false

                onToggled: {
                    if (zynqtgui.control.selectedEngineBypassController.value === zynqtgui.control.selectedEngineBypassController.value0) {
                        zynqtgui.control.selectedEngineBypassController.value = zynqtgui.control.selectedEngineBypassController.max_value;
                    } else {
                        zynqtgui.control.selectedEngineBypassController.value = zynqtgui.control.selectedEngineBypassController.value0;
                    }
                }
            }


            Item {
                implicitHeight: 28
                implicitWidth: height
                anchors.centerIn: parent

                layer.enabled: true
                layer.effect:  DropShadow {
                    horizontalOffset: 3
                    verticalOffset: 3
                    radius: 8.0
                    samples: 17
                    color: "#80000000"
                }

                Rectangle {
                    id: rect
                    color: "#b1b1b1"
                    anchors.fill: parent
                    radius: width/2
                    border.color: "#333"
                    opacity: 0.8
                }


                Rectangle {
                    id: _rect2
                    anchors.fill: parent
                    anchors.margins: 6
                    color: zynqtgui.sketchpad.isMetronomeRunning  ? "red":"white"
                    radius: width/2

                }
                RectangularGlow {
                    id: effect
                    visible: zynqtgui.sketchpad.isMetronomeRunning
                    anchors.fill: _rect2
                    glowRadius: 10
                    spread: 0.2
                    color:  "white"
                    cornerRadius: _rect2.radius + glowRadius
                }



                InnerShadow {
                    anchors.fill: _rect2
                    radius: 8.0
                    samples: 16
                    horizontalOffset: -3
                    verticalOffset: 3
                    color: "#b0000000"
                    source: _rect2
                }


            }

            GridLayout {

                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10

                rows: 2
                columns: 2

                Item {
                    Layout.preferredHeight: knobSize
                    Layout.preferredWidth: knobSize
                    Here.DialControl {
                        anchors.fill: parent

                        controller {
                            symbol: "level"
                        }
                    }
                }


                Item {
                    Layout.preferredHeight: knobSize
                    Layout.preferredWidth: knobSize
                    Here.DialControl {
                        anchors.fill: parent

                        controller {
                            symbol: "delay"
                        }
                    }
                }

                Item {
                    Layout.preferredHeight: knobSize
                    Layout.preferredWidth: knobSize
                    Here.DialControl {
                        anchors.fill: parent

                        controller {
                            symbol: "depth"
                        }
                    }
                }

                Item {
                    Layout.preferredHeight: knobSize
                    Layout.preferredWidth: knobSize
                    Here.DialControl {
                        anchors.fill: parent

                        controller {
                            symbol: "freq"
                        }
                    }
                }
            }

        }
    }
}


