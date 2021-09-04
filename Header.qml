import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.settings

Rectangle {
    id: toolBar
    visible: true
    anchors.top: parent.top

    width: parent.width            
    height: 35
    color: colors.secondaryBackGroundColor

        Item {
            anchors.fill: parent
            
            DragHandler {
                grabPermissions: TapHandler.CanTakeOverFromAnything
                onActiveChanged: if (active) { appWindow.startSystemMove(); }
            }

            TapHandler {
                onTapped: if (tapCount === 2) toggleMaximized()
                gesturePolicy: TapHandler.DragThreshold
            }

            RowLayout {
                id: buttonGroup

                height: 17
                width: 100

                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right

                RoundButton {
                    Layout.fillHeight: true
                    Layout.preferredWidth: height

                    background: Rectangle {
                        radius: parent.height

                        color: {
                            if (parent.down) "#b39700"
                            else if (parent.hovered) "#ffe34d"
                            else "Goldenrod"
                        }

                    }

                    onClicked: appWindow.showMinimized();
                }

                RoundButton {
                    Layout.fillHeight: true
                    Layout.preferredWidth: height

                    background: Rectangle {
                        radius: parent.height
                        color: {
                            if (parent.down) "#003400"
                            else if (parent.hovered) "#00cd00"
                            else "Green"
                        }
                    }
                    onClicked: appWindow.toggleMaximized()
                }

                RoundButton {
                    Layout.fillHeight: true
                    Layout.preferredWidth: height

                    background: Rectangle {
                        radius: parent.height
                        color: {
                            if (parent.down) "#b30000"
                            else if (parent.hovered) "#ff4d4d"
                            else "#e60000"
                        }
                    }
                    onClicked: appWindow.close()
                }
            }
        }

    /*
    background: Rectangle {
        color: colors.secondaryBackGroundColor
    }
    */



    DragHandler {
        grabPermissions: TapHandler.CanTakeOverFromAnything
        onActiveChanged: if (active) { appWindow.startSystemMove(); }
    }
}