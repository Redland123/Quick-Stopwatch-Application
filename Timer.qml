import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: timerBody

    signal beingDeleted()
    Component.onDestruction: beingDeleted()

    property var source: parent

    property var iconFile: "../icons"
    property var editButtonStatus: false

    property var seconds: 0
    property var minuntes: 0
    property var hours: 0

    Style {id: colors}
    Globals {id: globals}

    width: 300
    height: 350
    radius: width*0.1

    color: colors.secondaryBackGroundColor 

    function toggleEditButton() {
        if (editButtonStatus)
            editButtonStatus = false
        else 
            editButtonStatus = true
    }

    Timer {
        id: timer
        interval: 1000
        running: false
        repeat: true
        onTriggered: {

            seconds++
            
            if (Math.floor(seconds / 60)){
                seconds -= 60
                minuntes++
            }

            if (Math.floor(minuntes / 60)){
                minuntes -= 60
                hours++
            }

            var newDisplayTime = ""

            getString(hours.toString(), ":")
            getString(minuntes.toString(), ":")
            getString(seconds.toString(), "")

            function getString(currentValue, suffix){
                var i = currentValue
                var x = suffix

                if (i.length == 1){
                    newDisplayTime += "0" + i + x
                }
                else {
                    newDisplayTime += i + x
                }
            }

            timerDisplayText.text = newDisplayTime
        }
    }    

    RoundButton {
        id: deleteButton

        visible: editButtonStatus

        width: 20
        height: 20

        anchors.right: parent.right
        anchors.top: parent.top

        anchors.topMargin: 20
        anchors.rightMargin: 20

        onClicked: {
            //TODO: Figure out how to disconnect signal on destruction
            timerBody.destroy()
        }

        background: Rectangle {
                color: {
                    if (parent.down) {
                        colors.altAccentColor
                    } else if (parent.hovered) {
                        "Maroon"
                    } else {
                        "Red"
                    }
                }
                radius: deleteButton.radius
        }

    }

    TextField {
        id: timerTextField
        anchors.topMargin: 5

        anchors.horizontalCenter: timerBody.horizontalCenter
        anchors.top: timerBody.top

        font.pixelSize: 20

        horizontalAlignment: TextInput.AlignHCenter 
        maximumLength: parent.width

        //Cant center so I had to do this:
        placeholderText: "  Timer Name"

        color: colors.foreGroundColor

        background: Rectangle { 
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 7

            color: {
                if (parent.hovered){
                    colors.accentColor
                } else {
                    colors.altAccentColor
                }
            }

            height: 2

            }
    }

    Rectangle {
        id: circle

        property var mar: 30 

        border.width: 15
        radius: width*0.5

        anchors.left: parent.left
        anchors.leftMargin: mar
        anchors.top: parent.top
        anchors.topMargin: mar + 20
        anchors.horizontalCenter: parent.horizontalCenter

        width: parent.width
        height: width

        color: 'transparent'
        border.color: colors.accentColor

        Text {
            id: copyNotification
            text: "Time Coppied"

            color: colors.foreGroundColor

            visible: false

            Timer {
                id: copyNotificationTimer
                interval: 500

                running: false
                repeat: false

                onTriggered: {
                    parent.visible = false

                    //parent.opacity = parent.opacity - 0.02 / parent.opacity
                    //console.log(parent.opacity)

                    /*
                    if (parent.opacity <= 0){
                        parent.visible = false
                        parent.opacity = 1
                        stop() 
                    }
                    */
                }
            }

            font.pixelSize: 15

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: timerDisplayText.top
            anchors.bottomMargin: 10
        }


        Text {
            id: timerDisplayText
            text: "00:00:00"

            visible: true
            font.pixelSize: 35

            color: {
                if (textMouseArea.containsMouse)
                    colors.altAccentColor
                else
                    colors.foreGroundColor
            }

            anchors.horizontalCenter: circle.horizontalCenter
            anchors.verticalCenter: circle.verticalCenter

            TextField {
                id: textFieldCopy
                visible: false
            }

            MouseArea {
                id: textMouseArea
                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    textFieldCopy.text = parent.text
                    textFieldCopy.selectAll()
                    textFieldCopy.copy()
                    copyNotificationTimer.start()
                    copyNotification.visible = true
                }
            }

        }
    }

    Rectangle {
        width: 100
        height: 50

        color: "transparent"

        anchors.topMargin: 10
        anchors.bottomMargin: 10
        anchors.top: circle.bottom 
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        RoundButton {
            id: restButton
            anchors.right: parent.right
            height: parent.height
            width: parent.height

            Image {
                id: icon
                anchors.centerIn: parent
                anchors.fill: parent
                anchors.margins: 7

                source: {
                    if (seconds || minuntes || hours)
                        "./icons/reset.png"
                    else
                        "./icons/reset50.png"
                }

            }

            onClicked: {
                timer.stop()
                seconds = 0
                minuntes = 0
                hours = 0

                startPauseButton.buttonChecked = false

                timerDisplayText.text = "00:00:00"
            }

            background: Rectangle {
                    color: {
                        if (parent.down){
                            colors.accentColor
                        } else {
                            colors.altAccentColor
                        }
                    }

                    radius: parent.width*0.5
            }
            
        }
        RoundButton {
            id: startPauseButton

            property var buttonChecked: false

            anchors.left: parent.left
            height: parent.height
            width: parent.height

            Image {
                id: icon2
                anchors.centerIn: parent
                anchors.fill: parent
                anchors.margins: 7
                source: {
                    if (startPauseButton.buttonChecked == true)
                        "./icons/pause.png" 
                    else
                        "./icons/start.png" 
                }
            }

            onClicked: {
                if (buttonChecked == true){
                    buttonChecked = false
                    timer.running = false
                }
                else {
                    buttonChecked = true
                    timer.running = true 
                }
            
            }

            background: Rectangle {
                    color: {
                        if (parent.hovered){
                            colors.accentColor
                        } else {
                            colors.altAccentColor
                        }
                    }

                    radius: parent.width*0.5
            }
        }
    }
}