/*
*  Copyright 2019  Michail Vourlakos <mvourlakos@gmail.com>
*
*  This file is part of Latte-Dock
*
*  Latte-Dock is free software; you can redistribute it and/or
*  modify it under the terms of the GNU General Public License as
*  published by the Free Software Foundation; either version 2 of
*  the License, or (at your option) any later version.
*
*  Latte-Dock is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.plasmoid 2.0

import org.kde.latte 0.2 as Latte
import org.kde.latte.components 1.0 as LatteComponents

ColumnLayout {
    Layout.fillWidth: true

    LatteComponents.SubHeader {
        text: i18nc("indicators style","Style")
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 2

        readonly property int style: indicator.configuration.style

        ExclusiveGroup {
            id: styleGroup
            onCurrentChanged: {
                if (current.checked) {
                    indicator.configuration.style = current.style;
                }
            }
        }

        PlasmaComponents.Button {
            Layout.fillWidth: true

            text: i18nc("triangle indicators","Triangles")
            checked: parent.style === style
            checkable: true
            exclusiveGroup: styleGroup
            tooltip: i18n("Show triangles for item states")

            readonly property int style: 0 /*Triangles*/
        }

        PlasmaComponents.Button {
            Layout.fillWidth: true

            text: i18nc("dot indicators", "Dots")
            checked: parent.style === style
            checkable: true
            exclusiveGroup: styleGroup
            tooltip: i18n("Show dots for item states")

            readonly property int style: 1 /*Dots*/
        }
    }

    ColumnLayout {
        spacing: 0
        visible: indicator.latteTasksArePresent

        LatteComponents.SubHeader {
            text: i18nc("indicator tasks options","Tasks")
        }

        PlasmaComponents.CheckBox {
            id: minimizedColors
            text: i18n("Draw colored background for minimized windows")
            checked: indicator.configuration.colorsForMinimized

            onClicked: {
                indicator.configuration.colorsForMinimized = !indicator.configuration.colorsForMinimized;
            }
        }
    }
}
