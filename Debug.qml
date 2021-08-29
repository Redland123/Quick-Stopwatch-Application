import QtQuick

Rectangle {
    Globals {id: globals}

    anchors.fill: parent

    color: "transparent"
    border.color: "red"
    border.width: 1

    visible: globals.debug
}