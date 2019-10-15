import QtQuick 2.12
import QtQuick.Window 2.12
import QtMultimedia 5.9
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.4

Window {
    id: root
    visible: true
    width: 640
    height: 480
    title: qsTr("xPlayer - World's Music Player")
    color: "#eee"

    Audio{
        id: player
        autoPlay: true
    }

    Column{
        id: firstRow
        width: root.width/2
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 5
        Image {
            id: image
            width: 250
            height: 250
            anchors.horizontalCenter: parent.horizontalCenter
            source: "images/music-default.png"
        }
        TextArea{
            id:songName
            font.family: "Montserrat"
            font.weight: Font.DemiBold
            anchors.horizontalCenter: parent.horizontalCenter
            readOnly: true
            font.pixelSize: 14
            text: {
                if(player.hasAudio === false)
                    return "Browse song"
                else if(player.metaData.title === undefined && player.hasAudio === true)
                    return player.source
                else
                    return player.metaData.title
            }
            color: "#494949"
        }
        ProgressBar{
            id: control
            background: Rectangle {
                implicitWidth: width
                implicitHeight: 6
                color: "#e6e6e6"
                radius: width/2
                border.color: "#ddd"
            }

            contentItem: Rectangle {
                anchors.left: control.left
                anchors.verticalCenter: control.verticalCenter
                width: control.visualPosition * control.width
                height: control.height
                radius: width/2
                color: {
                    player.hasAudio === true? "#FB3741": "#e6e6e6"
                }

                z:101
            }
            width: parent.width
            from: 0
            to: player.duration
            value: player.position
        }
    }

    Row{
        id: controlsRow
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        spacing: 10
        bottomPadding: 15
        Button{
            id: openBtn
            text: "Browse"
            font.family: "Montserrat"
            font.weight: Font.DemiBold
            font.pixelSize: 11
            anchors.bottom: playPauseBtn.bottom
            onClicked: fileDialog.open()
        }

        Button{
            id: playPauseBtn
            text: {
                if(player.playbackState === 1)
                    return "Pause"
                else
                    return "Play"
            }
            font.family: "Montserrat"
            font.weight: Font.DemiBold
            font.pixelSize: 11
            onClicked: {
                if(player.playbackState === 1){
                    player.pause()
                }else
                    player.play()
            }
        }

        Button{
            text: "New window"
            font.family: "Montserrat"
            font.weight: Font.DemiBold
            font.pixelSize: 11
            anchors.bottom: openBtn.bottom
            onClicked: {
                winld.active = true
            }
        }
        Loader {
            id: winld
            active: false
            sourceComponent: Window {
                width: 640
                height: 480
                visible: true

                ListModel {
                    id: songModel
                    ListElement {
                        name: "Bill Smith"
                        number: "555 3264"
                    }
                }

                ListView {
                    width: parent.width
                    implicitHeight: 200
                    model: songModel

                    delegate: Text {
                        text: {
                            for(var i=0; i<songModel.count; i++)
                                console.log(songModel.get(i).name)
                        }
                    }

                    Button{
                        width: parent.width
                        height: 50
                        anchors.bottom: parent.bottom
                        onClicked: {
                            songModel.append({"name": "asdasdasd"})
                        }
                    }
                }
            }
        }
        FileDialog{
            id: fileDialog
            folder: shortcuts.home
            nameFilters: "*.mp3"
            onAccepted: {
                player.source = this.fileUrl
            }
        }
    }
}
