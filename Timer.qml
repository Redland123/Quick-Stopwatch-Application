import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: timerBody

    width: 300
    height: 350
    radius: width*0.1

    //Signals
    signal beingDeleted()
 
    Style {id: colors}
    Globals {id: globals}

    property var editButtonStatus: false

    property var seconds: 0
    property var minutes: 0
    property var hours: 0

    color: colors.secondaryBackGroundColor 

    //Runs when timer is created
    Component.onCompleted: Layout.alignment = Qt.AlignHCenter

    //Getters
    function getTimerName(){
        if (timerName) return timerName.text
        else return "null"
    }

    function getTimerValue(){
        return timerDisplayText.text
    }

    //Setters
    function setTimerName(newName){
        if (newName) timerName.text = newName
        else timerName.text = ""
    }

    function setTimerValue(newValue){
        if (newValue){
            timerDisplayText.text = newValue

            var x = newValue.split(":")

            hours = Number(x[0])
            minutes = Number(x[1])
            seconds = Number(x[2])
        }
        else timerName.text = "00:00:00"
    }

    //Toggles
    function toggleEditButton() {
        if (editButtonStatus) editButtonStatus = false
        else editButtonStatus = true
    }

    Timer {
        id: mainTimer

        interval: 1000
        running: false
        repeat: true

        onTriggered: {
            seconds++

            var newDisplayTime = ""

            if (Math.floor(seconds / 60)){
                seconds -= 60
                minutes++
            }

            if (Math.floor(minutes / 60)){
                minutes -= 60
                hours++
            }

            getString(hours.toString(), ":")
            getString(minutes.toString(), ":")
            getString(seconds.toString(), "")

            timerDisplayText.text = newDisplayTime

            function getString(currentValue, suffix){
                var i = currentValue
                var x = suffix

                if (i.length == 1) newDisplayTime += "0" + i + x
                else newDisplayTime += i + x
            }
        }
    }    

    RoundButton {
        id: deleteButton

        visible: editButtonStatus

        width: 17
        height: 17

        anchors.right: parent.right
        anchors.top: parent.top

        anchors.topMargin: 20
        anchors.rightMargin: 20

        onClicked: {
            timerBody.destroy()
            beingDeleted()
        }

        background: Rectangle {
            radius: deleteButton.radius

            color: {
                if (parent.down) colors.altAccentColor
                else if (parent.hovered) "Maroon"
                else "#e60000"
            }
        }
    }

    TextField {
        id: timerName

        font.pixelSize: 20
        placeholderText: "   Name"
        color: colors.foreGroundColor

        anchors.topMargin: 5

        anchors.horizontalCenter: timerBody.horizontalCenter
        anchors.top: timerBody.top

        horizontalAlignment: TextInput.AlignHCenter 
        maximumLength: parent.width

        background: Rectangle { 
            height: 2

            anchors.bottom: parent.bottom
            anchors.bottomMargin: 7

            color: {
                if (parent.hovered) colors.accentColor
                else colors.altAccentColor
            }
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
            visible: false

            text: "Time Coppied"
            color: colors.foreGroundColor
            font.pixelSize: 15

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: timerDisplayText.top
            anchors.bottomMargin: 10

            Timer {
                id: copyNotificationTimer

                interval: 500
                running: false
                repeat: false

                onTriggered: parent.visible = false
            }
        }

        Text {
            id: timerDisplayText
            text: "00:00:00"

            visible: true
            font.pixelSize: 35

            anchors.horizontalCenter: circle.horizontalCenter
            anchors.verticalCenter: circle.verticalCenter

            color: {
                if (textMouseArea.containsMouse) colors.altAccentColor
                else colors.foreGroundColor
            }

            TextField {
                id: textFieldCopy
                visible: false
            }

            MouseArea {
                id: textMouseArea
                hoverEnabled: true

                anchors.fill: parent

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
        //Control button layout
        width: 100
        height: 50

        color: "transparent"

        anchors.topMargin: 10
        anchors.bottomMargin: 10
        anchors.top: circle.bottom 
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        RoundButton {
            id: resetButton

            height: parent.height
            width: parent.height

            anchors.right: parent.right

            Image {
                id: resetIcon

                anchors.centerIn: parent
                anchors.fill: parent
                anchors.margins: 7

                source: {
                    if (seconds || minutes || hours) "./icons/reset.png"
                    else "./icons/reset50.png"
                }
            }

            onClicked: {
                mainTimer.stop()

                seconds = 0
                minutes = 0
                hours = 0

                startPauseButton.buttonChecked = false
                timerDisplayText.text = "00:00:00"
            }

            background: Rectangle {
                    radius: parent.width*0.5

                    color: {
                        if (parent.hovered && (seconds || minutes || hours)) colors.accentColor
                        else colors.altAccentColor
                    }
            }    
        }

        RoundButton {
            id: startPauseButton

            property var buttonChecked: false

            height: parent.height
            width: parent.height

            anchors.left: parent.left

            Image {
                id: icon2
                anchors.centerIn: parent
                anchors.fill: parent
                anchors.margins: 7

                source: {
                    if (startPauseButton.buttonChecked == true) "./icons/pause.png" 
                    else "./icons/start.png" 
                }
            }

            background: Rectangle {
                    radius: parent.width*0.5

                    color: {
                        if (parent.hovered) colors.accentColor
                        else colors.altAccentColor
                    }
            }

            onClicked: {
                if (buttonChecked){
                    buttonChecked = false
                    mainTimer.running = false
                }
                else {
                    buttonChecked = true
                    mainTimer.running = true 
                }            
            }
        }
    }
}