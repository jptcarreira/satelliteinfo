// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

pragma ComponentBehavior: Bound
import QtPositioning
import QtQuick
import QtQuick.Controls.Basic as QC
import QtQuick.Layouts
import SatelliteInformation

Rectangle {
    id: root

    required property SortFilterModel sortFilterModel
    required property color inViewColor
    required property color inUseColor

    readonly property int iconItemWidth: 30

    color: Theme.darkBackgroundColor

    property var satelliteSystemModel: [
        {"name": "GPS", "id": GeoSatelliteInfo.GPS},
        {"name": "GLONASS", "id": GeoSatelliteInfo.GLONASS},
        {"name": "GALILEO", "id": GeoSatelliteInfo.GALILEO},
        {"name": "BEIDOU", "id": GeoSatelliteInfo.BEIDOU},
        {"name": "QZSS", "id": GeoSatelliteInfo.QZSS}
    ]

    component RssiElement : Rectangle {
        id: rssiRoot

        required property int rssi

        implicitHeight: rssiVal.implicitHeight
        implicitWidth: rssiVal.implicitWidth + dbm.implicitWidth + rssiLayout.spacing
        color: "transparent"

        RowLayout {
            id: rssiLayout
            anchors.fill: parent
            spacing: 2
            Text {
                id: rssiVal
                text: rssiRoot.rssi >= 0 ? rssiRoot.rssi : qsTr("N/A")
                color: Theme.textSecondaryColor
                font.pixelSize: Theme.mediumFontSize
                font.weight: Theme.fontDefaultWeight
            }
            Text{
                id: dbm
                visible: rssiRoot.rssi >= 0
                text: qsTr("dBm")
                color: Theme.textGrayColor
                font.pixelSize: Theme.mediumFontSize
                font.weight: Theme.fontDefaultWeight

            }
        }
    }

    component StatusElement : Rectangle {
        id: statusRoot

        required property bool inUse

        implicitHeight: statusText.implicitHeight
        implicitWidth: statusText.implicitWidth + statusIcon.implicitWidth + statusLayout.spacing
        color: "transparent"

        RowLayout {
            id: statusLayout
            anchors.fill: parent
            spacing: Theme.defaultSpacing
            Rectangle {
                id: statusIcon
                implicitHeight: statusText.font.pixelSize
                implicitWidth: implicitHeight
                radius: height / 2
                color: statusRoot.inUse ? root.inUseColor : root.inViewColor
            }
            Text {
                id: statusText
                text: statusRoot.inUse ? qsTr("In Use") : qsTr("In View")
                color: Theme.textSecondaryColor
                font.pixelSize: Theme.smallFontSize
                font.weight: Theme.fontLightWeight
            }
        }
    }

    component DegreesElement : Rectangle {
        id: degreesRoot

        required property int degrees

        implicitHeight: degreesVal.implicitHeight
        implicitWidth: degreesVal.implicitWidth + dbm.implicitWidth + rssiLayout.spacing
        color: "transparent"

        RowLayout {
            id: rssiLayout
            anchors.fill: parent
            spacing: 2
            Text {
                id: degreesVal
                text: degreesRoot.degrees
                color: Theme.textSecondaryColor
                font.pixelSize: Theme.mediumFontSize
                font.weight: Theme.fontDefaultWeight
            }
            Text{
                id: dbm
                visible: degreesRoot.degrees >= 0
                text: qsTr("°")
                color: Theme.textGrayColor
                font.pixelSize: Theme.mediumFontSize
                font.weight: Theme.fontDefaultWeight

            }
        }
    }



    RssiElement {
        id: hiddenRssiElement
        rssi: 999
        visible: false
    }
    StatusElement {
        id: hiddenStatusElement
        inUse: false
        visible: false
    }

    DegreesElement {
        id: hiddenDegreesElement
        degrees: 360
        visible: false
    }

    component ListHeader : Rectangle {
        implicitHeight: identifierHdr.height
        color: root.color

        RowLayout {
            anchors {
                fill: parent
                leftMargin: Theme.defaultSpacing * 2
                rightMargin: Theme.defaultSpacing * 2
            }
            spacing: Theme.defaultSpacing * 2
            Text {
                id: gnssHdr
                text: qsTr("GNSS")
                color: Theme.textSecondaryColor
                font.pixelSize: Theme.mediumFontSize
                font.weight: Theme.fontDefaultWeight
                Layout.preferredWidth: root.iconItemWidth
            }
            Text {
                id: idHdr
                text: qsTr("ID")
                color: Theme.textSecondaryColor
                font.pixelSize: Theme.mediumFontSize
                font.weight: Theme.fontDefaultWeight
                Layout.preferredWidth: hiddenRssiElement.width
            }
            Text {
                id: rssiHdr
                text: qsTr("RSSI")
                color: Theme.textSecondaryColor
                font.pixelSize: Theme.mediumFontSize
                font.weight: Theme.fontDefaultWeight
                Layout.preferredWidth: hiddenRssiElement.width
                horizontalAlignment: Qt.AlignHCenter
            }
            // Item {
            //     id: blank
            //     implicitWidth: root.iconItemWidth
            // }
            Text {
                id: elevationHdr
                text: qsTr("Elev.")
                color: Theme.textSecondaryColor
                font.pixelSize: Theme.mediumFontSize
                font.weight: Theme.fontDefaultWeight
                Layout.preferredWidth: hiddenDegreesElement.width
                horizontalAlignment: Qt.AlignHCenter
            }
            Text {
                id: azimuteHdr
                text: qsTr("Azim.")
                color: Theme.textSecondaryColor
                font.pixelSize: Theme.mediumFontSize
                font.weight: Theme.fontDefaultWeight
                Layout.preferredWidth: hiddenDegreesElement.width
                horizontalAlignment: Qt.AlignHCenter
            }
            Text {
                id: statusHdr
                text: qsTr("Status")
                color: Theme.textSecondaryColor
                font.pixelSize: Theme.mediumFontSize
                font.weight: Theme.fontDefaultWeight
                Layout.preferredWidth: hiddenStatusElement.width
            }
        }
        Rectangle {
            anchors.bottom: parent.bottom
            height: 1
            width: parent.width
            color: Theme.tableSeparatorColor
        }
    }

    component ListItem : Rectangle {
        id: listItem

        required property int index
        required property var modelData

        color: "transparent"

        RowLayout {
            anchors {
                fill: parent
                leftMargin: Theme.defaultSpacing * 2
                rightMargin: Theme.defaultSpacing * 2
            }
            spacing: Theme.defaultSpacing * 2

            Rectangle {
                implicitWidth: root.iconItemWidth
                color: "transparent"
                Image {
                    anchors.centerIn: parent
                    width: root.iconItemWidth
                    source: listItem.index % 2 === 0 ? "icons/Flag_of_Europe.svg"
                                                     : "icons/Flag_of_United_States.svg"
                }
            }

            Text {
                color: Theme.textMainColor
                font.pixelSize: Theme.mediumFontSize
                font.weight: Theme.fontDefaultWeight
                text: listItem.modelData.id
                Layout.preferredWidth: hiddenRssiElement.width
            }

            RssiElement {
                rssi: listItem.modelData.rssi
                Layout.preferredWidth: hiddenRssiElement.width
            }

            DegreesElement {
                degrees: listItem.modelData.elevation
                Layout.preferredWidth: hiddenDegreesElement.width
            }

            DegreesElement {
                degrees: listItem.modelData.azimuth
                Layout.preferredWidth: hiddenDegreesElement.width
            }

            // Rectangle {
            //     implicitWidth: root.iconItemWidth
            //     color: "transparent"
            //     // Image {
            //     //     anchors.centerIn: parent
            //     //     source: listItem.index % 2 === 0 ? "icons/satellite1.png"
            //     //                                      : "icons/satellite2.png"
            //     // }
            // }
            StatusElement {
                inUse: listItem.modelData.inUse
                Layout.preferredWidth: hiddenStatusElement.width
            }
        }
        Rectangle {
            anchors.bottom: parent.bottom
            height: 1
            width: parent.width
            color: Theme.tableSeparatorColor
        }
    }

    component SearchInput : QC.TextField {
        id: searchInput
        palette {
            placeholderText: Theme.grayColor
            text: Theme.textMainColor
        }
        rightPadding: padding + searchIcon.width + searchIcon.anchors.rightMargin
        font.pixelSize: Theme.smallFontSize
        font.weight: Theme.fontLightWeight
        background: Rectangle {
            border {
                width: 1
                color:Theme.searchBorderColor
            }
            color: "transparent"
            radius: 3
            Image {
                id: searchIcon
                anchors {
                    right: parent.right
                    rightMargin: Theme.defaultSpacing
                    verticalCenter: parent.verticalCenter
                }
                source: "icons/search.svg"
                sourceSize.height: searchInput.implicitHeight - searchInput.padding * 2
                fillMode: Image.PreserveAspectFit
            }
        }
    }

    component IconButton : QC.ToolButton {
        id: iconButton
        property bool selected: false
        icon.width: 0
        icon.height: 0
        icon.color: selected ? Theme.greenColor : Theme.grayColor
        background: Rectangle {
            border {
                width: 1
                color: iconButton.selected ? Theme.greenColor : Theme.searchBorderColor
            }
            color: "transparent"
            radius: 3
        }
    }

    component MenuPopup : QC.Popup {
        modal: true
        background: Rectangle {
            radius: 8
            color: Theme.backgroundColor
            border {
                width: 1
                color: Theme.separatorColor
            }
        }
    }

    component CheckElement : QC.ItemDelegate {
        id: checkElement

        readonly property int iconSize: font.pixelSize * 2

        checked: true
        padding: 0

        display: QC.AbstractButton.TextBesideIcon

        font.pixelSize: Theme.smallFontSize
        font.weight: Theme.fontLightWeight
        palette.text: checked ? Theme.greenColor : Theme.textSecondaryColor

        icon.source: checked ? "icons/checkbox.svg" : "icons/checkbox_blank.svg"
        icon.height: iconSize
        icon.width: iconSize
        icon.color: checked ? Theme.greenColor : Theme.textSecondaryColor

        LayoutMirroring.enabled: true
        LayoutMirroring.childrenInherit: true

        background: Rectangle {
            anchors.fill: parent
            color: "transparent"
        }

        onClicked: {
            checked = !checked
        }
    }

    Rectangle {
        id: sortAndFilter
        width: root.width
        height: searchField.implicitHeight + sortAndFilterLayout.anchors.margins * 2
        color: Theme.backgroundColor
        visible: false
        RowLayout {
            id: sortAndFilterLayout
            anchors {
                fill: parent
                margins: Theme.defaultSpacing * 2
            }
            spacing: Theme.defaultSpacing * 2
            SearchInput {
                id: searchField
                placeholderText: qsTr("Search")
                Layout.fillWidth: true
                onTextChanged: root.sortFilterModel.updateFilterString(text);
            }
            IconButton {
                selected: sortMenu.visible
                icon.source: "icons/sort.svg"
                rotation: 90
                Layout.preferredHeight: searchField.implicitHeight
                Layout.preferredWidth: Layout.preferredHeight
                onClicked: sortMenu.open()
            }
            IconButton {
                selected: filterMenu.visible
                icon.source: "icons/filter.svg"
                Layout.preferredHeight: searchField.implicitHeight
                Layout.preferredWidth: Layout.preferredHeight
                onClicked: filterMenu.open()
            }
        }
    }

    Rectangle {
        id: separator
        anchors.top: sortAndFilter.bottom
        color: Theme.separatorColor
        height: 1
        width: root.width
    }

    ListView {
        id: satellitesView
        anchors {
            top: separator.bottom
            bottom: root.bottom
        }
        width: root.width
        clip: true
        model: root.sortFilterModel
        header: ListHeader {
            height: 30
            width: root.width
            z: 2 // to show on top of the items
        }
        headerPositioning: ListView.OverlayHeader
        delegate: ListItem {
            height: 50
            width: root.width
        }
    }

    MenuPopup {
        id: sortMenu
        x: root.width - sortMenu.width - Theme.defaultSpacing
        y: satellitesView.y - Theme.defaultSpacing
        ColumnLayout {
            anchors.fill: parent
            spacing: Theme.defaultSpacing
            CheckElement {
                checked: false
                text: qsTr("By RSSI")
                Layout.alignment: Qt.AlignRight
                onCheckedChanged: {
                    root.sortFilterModel.updateSortRoles(Roles.RssiRole, checked)
                }
            }
            CheckElement {
                checked: false
                text: qsTr("By Identifier")
                Layout.alignment: Qt.AlignRight
                onCheckedChanged: {
                    root.sortFilterModel.updateSortRoles(Roles.SystemRole, checked)
                }
            }
            CheckElement {
                checked: false
                text: qsTr("By Status")
                Layout.alignment: Qt.AlignRight
                onCheckedChanged: {
                    root.sortFilterModel.updateSortRoles(Roles.InUseRole, checked)
                }
            }
        }
    }

    MenuPopup {
        id: filterMenu
        x: root.width - filterMenu.width - Theme.defaultSpacing
        y: satellitesView.y - Theme.defaultSpacing
        ColumnLayout {
            id: filterLayout
            anchors.fill: parent
            spacing: Theme.defaultSpacing
            Text {
                text: qsTr("Satellite Identifier")
                color: Theme.textMainColor
                font.pixelSize: Theme.mediumFontSize
                font.weight: Theme.fontDefaultWeight
                Layout.alignment: Qt.AlignRight
            }
            //! [0]
            Repeater {
                model: root.satelliteSystemModel
                delegate: CheckElement {
                    required property var modelData
                    text: modelData.name
                    Layout.alignment: Qt.AlignRight
                    onCheckedChanged: {
                        root.sortFilterModel.updateSelectedSystems(modelData.id, checked)
                    }
                }
            }
            //! [0]
            Text {
                text: qsTr("Satellite Status")
                color: Theme.textMainColor
                font.pixelSize: Theme.mediumFontSize
                font.weight: Theme.fontDefaultWeight
                Layout.alignment: Qt.AlignRight
            }
            //! [1]
            CheckElement {
                text: qsTr("In View")
                Layout.alignment: Qt.AlignRight
                onCheckedChanged: root.sortFilterModel.updateShowInView(checked)
            }
            CheckElement {
                text: qsTr("In Use")
                Layout.alignment: Qt.AlignRight
                onCheckedChanged: root.sortFilterModel.updateShowInUse(checked)
            }
            //! [1]
        }
    }
}
