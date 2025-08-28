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

import QtQuick 2.15
import QtQuick.Layouts 1.4
import QtQuick.Controls 2.15 as QQC2
import org.kde.kirigami 2.4 as Kirigami
import Zynthian 1.0 as Zynthian
import "." as Here
import QtGraphicalEffects 1.15

Zynthian.AbstractController {
    id: root

    // property alias valueLabel: valueLabel.text
    property alias value: dial.value
    property alias from: dial.from
    property alias to: dial.to
    property alias stepSize: dial.stepSize
    property alias snapMode: dial.snapMode
    property alias dial: dial

    implicitWidth: 20
    implicitHeight: 20

    property color highlightColor : "#5765f2"
    property color backgroundColor: "#fafafa"
    property color foregroundColor: "#333"
    property color alternativeColor :  "#16171C"


    padding: 5

    background: null
    title: ""

    contentItem:  Item {



        ColumnLayout {
            anchors.fill: parent
            spacing: 2

            QQC2.Label {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: root.controller.ctrl ? root.controller.ctrl.title : ""
                font.capitalization: Font.AllUppercase
                font.weight: Font.Black
                font.family: "Hack"
                font.pointSize: 14
            }

            QQC2.Dial {
                id: dial
                Layout.fillHeight: true
                Layout.preferredWidth: height
                Layout.alignment: Qt.AlignHCenter
                inputMode: QQC2.Dial.Vertical
                stepSize: root.controller.ctrl ? (root.controller.ctrl.step_size === 0 ? 1 : root.controller.ctrl.step_size) : 0
                from: root.controller.ctrl ? root.controller.ctrl.value0 : 0
                to: root.controller.ctrl ? root.controller.ctrl.max_value : 0

                property bool shouldClick: false
                property var mostRecentClickTime: 0
                onMoved: {
                    shouldClick = false;
                    if (root.controller && root.controller.ctrl) {
                        root.controller.ctrl.value = value;
                    }
                }
                onPressedChanged: {
                    if (pressed) {
                        shouldClick = true;
                    } else {
                        shouldClick = false;
                        let thisClickTime = Date.now();
                        if (thisClickTime - mostRecentClickTime < 300) {
                            if (root.controller && root.controller.ctrl) {
                                root.controller.ctrl.value = root.controller.ctrl.value_default;
                            }
                            root.doubleClicked();
                        } else {
                            root.clicked();
                        }
                        mostRecentClickTime = thisClickTime;
                    }
                    root.pressedChanged(pressed);
                }

                handle: Rectangle {
                    id: handleItem
                    x: dial.background.x + dial.background.width / 2 - width / 2
                    y: dial.background.y + dial.background.height / 2 - height / 2
                    width: 8
                    height: dial.background.height* 0.12
                    color: dial.pressed ? root.highlightColor : root.foregroundColor
                    border.color: Qt.darker(root.alternativeColor, 2)
                    radius: 8
                    antialiasing: true
                    opacity: dial.enabled ? 1 : 0.3
                    transform: [
                        Translate {
                            y: -Math.min(dial.background.width, dial.background.height) * 0.35 + handleItem.height / 2
                        },
                        Rotation {
                            angle: dial.angle
                            origin.x: handleItem.width / 2
                            origin.y: handleItem.height / 2
                        }
                    ]
                }

                background: Item {
                    // color: "white"
                    // radius: height/2
                    // border.color: "black"

                    Image {
                        id: _dialBg
                        visible: false
                        anchors.fill: parent
                        source: "background.png" }

                    DropShadow {
                        anchors.fill: _dialBg
                        horizontalOffset: 3
                        verticalOffset: 3
                        radius: 8.0
                        samples: 17
                        color: "#80000000"
                        source: _dialBg
                    }
                }
            }

            // QQC2.Label {
            //     visible: !_label1.visible
            //     Layout.fillWidth: true
            //     horizontalAlignment: Text.AlignHCenter
            //     font.capitalization: Font.AllUppercase
            //     font.weight: Font.DemiBold
            //     font.family: "Hack"
            //     font.pointSize: 9
            //     fontSizeMode: Text.Fit
            //     minimumPointSize: 6
            //     wrapMode: Text.NoWrap

            //     font.letterSpacing: 2
            //     color: root.foregroundColor
            //     padding: 4

            //     text: {
            //         if (!root.controller.ctrl) {
            //             return "";
            //         }
            //         // Heuristic: convert the values from 0-127 to 0-100
            //         if (root.controller.ctrl.value0 === 0 && root.controller.ctrl.max_value === 127) {
            //             return Math.round(100 * (value / 127));
            //         }
            //         return root.controller.ctrl.value_print.trim();
            //     }

            //     background: Rectangle {

            //         border.width: 2
            //         border.color: root.backgroundColor
            //         color: root.alternativeColor
            //         radius: 4

            //         Rectangle {
            //             anchors.fill: parent
            //             anchors.margins: 1

            //             visible: false
            //             id: _recLabel2
            //             color:  dial.pressed ? root.highlightColor : root.alternativeColor
            //             border.color: Qt.darker(color, 2)
            //             radius: 4

            //         }

            //         InnerShadow {
            //             anchors.fill: _recLabel2
            //             radius: 8.0
            //             samples: 16
            //             horizontalOffset: -3
            //             verticalOffset: 1
            //             color: "#b0000000"
            //             source: _recLabel2
            //         }
            //     }
            // }
        }

        Binding {
            target: dial
            property: "value"
            value: root.controller.ctrl ? root.controller.ctrl.value : 0
        }
    }

}
