import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.settings

Rectangle {
    id: menuLayout
    visible: true

    height: 50
    width: 1000

    color: "transparent"

    Item {    
        height: 40
        width: 200

        anchors.rightMargin: 10
        anchors.right: parent.right
        anchors.top: parent.top

        RoundButton {
            id: editButton
            property var oldWidth: 40

            width: 40
            height: parent.height

            anchors.left: parent.left

            Text {
                id: textField
                text: "Edit"
                color: colors.foreGroundColor

                font.pixelSize: 15

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            background: Rectangle {
                radius: 5

                color: {
                    if (parent.down) colors.foreGroundColor
                    else if (parent.hovered) colors.accentColor
                    else colors.altAccentColor
                }
            }

            onClicked: {
                appWindow.editButtonToggleSignal()

                if (textField.text == "Edit"){
                    textField.text = "Done"
                    newTimerButton.visible = false
                    anchors.left = undefined
                    anchors.right = parent.right
                }
                else {
                    textField.text = "Edit"
                    anchors.left = parent.left
                    anchors.right = undefined
                    width = oldWidth
                    newTimerButton.visible = true
                }
            }
        }

        RoundButton {
            id: newTimerButton

            width: 150
            height: parent.height

            anchors.right: parent.right

            Text {
                text: "Add New Stopwatch"
                color: colors.foreGroundColor

                font.pixelSize: 15

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            background: Rectangle {
                radius: 5

                color: {
                    if (parent.down) {
                        colors.foreGroundColor
                    } else if (parent.hovered) {
                        colors.accentColor
                    } else {
                        colors.altAccentColor
                    }
                }
            }
            onClicked: createNewTimer()
        }
    }
} 