import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import QtQml.Models 2.12

Column {
    property var username: usernameField.text

    spacing: 30

    DelegateModel {
        id: userWrapper

        model: userModel
        delegate: ItemDelegate {
            id: userEntry

            height: inputHeight
            width: parent.width
            highlighted: userList.currentIndex == index

            contentItem: Text {
                renderType: Text.NativeRendering
                font.family: config.Font
                font.pointSize: config.GeneralFontSize
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: highlighted ? config.PopupHighlightedTextColor : config.PopupHighlightColor
                text: name
            }

            background: Rectangle {
                id: userEntryBg

                color: highlighted ? config.PopupHighlightColor : config.PopupBgColor
                radius: config.CornerRadius
            }

            states: [
                State {
                    name: "hovered"
                    when: userEntry.hovered
                    PropertyChanges {
                        target: userEntryBg
                        color: highlighted ? Qt.darker(config.PopupHighlightColor, 1.2) : Qt.darker(config.PopupBgColor, 1.2)
                    }
                }
            ]

            transitions: Transition {
                PropertyAnimation {
                    property: "color"
                    duration: 150
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    userList.currentIndex = index
                    usernameField.text = userWrapper.items.get(index).model.name
                    userPicture.source = userWrapper.items.get(index).model.icon
                    userPopup.close()
                }
            }
        }
    }

    Popup {
        id: userPopup

        width: inputWidth
        padding: 15

        background: Rectangle {
            radius: config.CornerRadius * 1.4
            color: config.PopupBgColor
        }

        contentItem: ListView {
            id: userList

            implicitHeight: contentHeight
            spacing: 8
            model: userWrapper
            currentIndex: userModel.lastIndex
            clip: true
        }

        enter: Transition {
            ParallelAnimation {
                NumberAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 400
                    easing.type: Easing.OutExpo
                }
                NumberAnimation {
                    property: "y"
                    from: (inputWidth / 3) - userPopup.padding - (inputHeight * userList.count * 0.5) - (userList.spacing * (userList.count - 1) * 0.5) + (inputWidth * 0.1)
                    to: (inputWidth / 3) - userPopup.padding - (inputHeight * userList.count * 0.5) - (userList.spacing * (userList.count - 1) * 0.5)
                    duration: 500
                    easing.type: Easing.OutExpo
                }
            }
        }

        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 300
                easing.type: Easing.OutExpo
            }
        }
    }

    Item {
        width: inputWidth
        implicitHeight: pictureBorder.height

        Rectangle {
            id: pictureBorder

            anchors.centerIn: userPicture
            height: inputWidth / 2 + (border.width * 2)
            width: inputWidth / 2 + (border.width * 2)
            radius: height / 2
            border.width: config.UserPictureBorderWidth
            border.color: config.UserPictureBorderColor
            color: config.UserPictureColor

            MouseArea {
                id: roundMouseArea

                anchors.fill: parent
                hoverEnabled: true

                onClicked: userPopup.open()
                onHoveredChanged: {
                    if (containsMouse) {
                        pictureBorder.state = "hovered"
                    } else {
                        pictureBorder.state = "unhovered"
                    }
                }
                onPressedChanged: {
                    if (containsPress) {
                        pictureBorder.state = "pressed"
                    } else if (containsMouse) {
                        pictureBorder.state = "hovered"
                    } else {
                        pictureBorder.state = "unhovered"
                    }
                }
            }

            states: [
                State {
                    name: "pressed"
                    PropertyChanges {
                        target: pictureBorder
                        border.color: Qt.darker(config.UserPictureBorderColor, 1.2)
                        color: Qt.darker(config.UserPictureColor, 1.2)
                    }
                },
                State {
                    name: "hovered"
                    PropertyChanges {
                        target: pictureBorder
                        border.color: Qt.darker(config.UserPictureBorderColor, 1.4)
                        color: Qt.darker(config.UserPictureColor, 1.4)
                    }
                },
                State {
                    name: "unhovered"
                    PropertyChanges {
                        target: pictureBorder
                        border.color: config.UserPictureBorderColor
                        color: config.UserPictureColor
                    }
                }
            ]

            transitions: Transition {
                PropertyAnimation {
                    properties: "border.color, color"
                    duration: 150
                }
            }
        }

        Image {
            id: userPicture
            source: ""

            height: inputWidth / 2
            width: inputWidth / 2
            anchors.horizontalCenter: parent.horizontalCenter

            fillMode: Image.PreserveAspectCrop
            layer.enabled: false
            layer.effect: OpacityMask {
                maskSource: mask
            }

            Rectangle {
                id: mask

                anchors.fill: parent
                radius: inputWidth / 3
                visible: false
            }
        }

        Popup {
            id: incorrectPopup

            height: incorrectText.paintedHeight * 2
            width: inputWidth
            y: (pictureBorder.height - height) / 2
            onOpened: incorrectTimer.start()

            background: Rectangle {
                radius: config.CornerRadius
                color: config.PopupBgColor
            }

            contentItem: Text {
                id: incorrectText

                renderType: Text.NativeRendering
                font.family: config.Font
                font.pointSize: config.GeneralFontSize
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: config.PopupHighlightColor

                text: "Incorrect username\nor password!"
            }

            enter: Transition {
                ParallelAnimation {
                    NumberAnimation {
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 400
                        easing.type: Easing.OutExpo
                    }
                    NumberAnimation {
                        property: "x"
                        from: incorrectPopup.x - (inputWidth * 0.1)
                        to: incorrectPopup.x
                        duration: 500
                        easing.type: Easing.OutElastic
                    }
                }
            }

            exit: Transition {
                NumberAnimation {
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 300
                    easing.type: Easing.OutExpo
                }
            }

            Timer {
                id: incorrectTimer

                interval: 3000
                onTriggered: incorrectPopup.close()
            }
        }
    }

    UserFieldPanel {
        id: usernameField

        height: inputHeight
        width: inputWidth
    }

    Component.onCompleted: userPicture.source = userWrapper.items.get(userList.currentIndex).model.icon

    Connections {
        target: sddm
        function onLoginSucceeded() {}
        function onLoginFailed() {
            incorrectPopup.open()
        }
    }
}
