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

    readonly property bool deprecatedPropertiesAreHidden: dialog && dialog.hasOwnProperty("deprecatedOptionsAreHidden") && dialog.deprecatedOptionsAreHidden

    LatteComponents.SubHeader {
        text: i18n("Colors")
    }

    ColumnLayout {
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            spacing: 2

            readonly property int colors: indicator.configuration.colors

            readonly property int buttonsCount: 2
            readonly property int buttonSize: (dialog.optionsWidth - (spacing * buttonsCount-1)) / buttonsCount

            ExclusiveGroup {
                id: colorsGroup
                onCurrentChanged: {
                    if (current.checked) {
                        indicator.configuration.colors = current.colors;
                    }
                }
            }

            PlasmaComponents.Button {
                Layout.minimumWidth: parent.buttonSize
                Layout.maximumWidth: Layout.minimumWidth

                text: i18nc("pale colors","Pale")
                checked: parent.colors === colors
                checkable: true
                exclusiveGroup: colorsGroup
                tooltip: i18n("Use pale colors for glow and background")

                readonly property int colors: 0 /*Pale*/
            }

            PlasmaComponents.Button {
                Layout.minimumWidth: parent.buttonSize
                Layout.maximumWidth: Layout.minimumWidth

                text: i18nc("bright colors","Bright")
                checked: parent.colors === colors
                checkable: true
                exclusiveGroup: colorsGroup
                tooltip: i18n("Use bright colors for glow and background")

                readonly property int colors: 1 /*Bright*/
            }
        }
    }

    LatteComponents.SubHeader {
        text: i18n("Background")
    }

    ColumnLayout {
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            spacing: units.smallSpacing
            visible: deprecatedPropertiesAreHidden

            PlasmaComponents.Label {
                text: i18n("Length")
                horizontalAlignment: Text.AlignLeft
            }

            LatteComponents.Slider {
                id: lengthIntMarginSlider
                Layout.fillWidth: true

                value: Math.round(indicator.configuration.lengthPadding * 100)
                from: 5
                to: maxMargin
                stepSize: 1
                wheelEnabled: false

                readonly property int maxMargin: 80

                onPressedChanged: {
                    if (!pressed) {
                        indicator.configuration.lengthPadding = value / 100;
                    }
                }
            }

            PlasmaComponents.Label {
                text: i18nc("number in percentage, e.g. 85 %","%0 %").arg(currentValue)
                horizontalAlignment: Text.AlignRight
                Layout.minimumWidth: theme.mSize(theme.defaultFont).width * 4
                Layout.maximumWidth: theme.mSize(theme.defaultFont).width * 4

                readonly property int currentValue: lengthIntMarginSlider.value
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 2

            PlasmaComponents.Label {
                Layout.minimumWidth: implicitWidth
                horizontalAlignment: Text.AlignLeft
                Layout.rightMargin: units.smallSpacing
                text: i18n("Glow")
            }

            LatteComponents.Slider {
                id: glowOpacitySlider
                Layout.fillWidth: true

                leftPadding: 0
                value: indicator.configuration.glowOpacity * 100
                from: 0
                to: 100
                stepSize: 5
                wheelEnabled: false

                function updateGlowOpacity() {
                    if (!pressed) {
                        indicator.configuration.glowOpacity = value/100;
                    }
                }

                onPressedChanged: {
                    updateGlowOpacity();
                }

                Component.onCompleted: {
                    valueChanged.connect(updateGlowOpacity);
                }

                Component.onDestruction: {
                    valueChanged.disconnect(updateGlowOpacity);
                }
            }

            PlasmaComponents.Label {
                text: i18nc("number in percentage, e.g. 85 %","%0 %").arg(glowOpacitySlider.value)
                horizontalAlignment: Text.AlignRight
                Layout.minimumWidth: theme.mSize(theme.defaultFont).width * 4
                Layout.maximumWidth: theme.mSize(theme.defaultFont).width * 4
            }
        }

        LatteComponents.CheckBoxesColumn {
            Layout.topMargin: 7
            Layout.fillWidth: true

            LatteComponents.CheckBox {
                Layout.maximumWidth: dialog.optionsWidth
                text: i18n("Reverse glow position")
                checked: indicator.configuration.glowReversed

                onClicked: {
                    indicator.configuration.glowReversed = !indicator.configuration.glowReversed;
                }
            }

            LatteComponents.CheckBoxesColumn {
                LatteComponents.CheckBox {
                    Layout.maximumWidth: dialog.optionsWidth
                    text: i18n("Glassy look for square applets")
                    checked: indicator.configuration.glassySquareApplets

                    onClicked: {
                        indicator.configuration.glassySquareApplets = !indicator.configuration.glassySquareApplets;
                    }
                }
            }

            LatteComponents.CheckBox {
                Layout.maximumWidth: dialog.optionsWidth
                text: i18n("Colored look for launchers")
                checked: indicator.configuration.colorsForLaunchers
                visible: indicator.latteTasksArePresent

                onClicked: {
                    indicator.configuration.colorsForLaunchers = !indicator.configuration.colorsForLaunchers;
                }
            }

            LatteComponents.CheckBox {
                Layout.maximumWidth: dialog.optionsWidth
                text: i18n("Colored look for minimized windows")
                checked: indicator.configuration.colorsForMinimized
                visible: indicator.latteTasksArePresent

                onClicked: {
                    indicator.configuration.colorsForMinimized = !indicator.configuration.colorsForMinimized;
                }
            }
        }
    }

    LatteComponents.SubHeader {
        text: i18nc("indicators shapes style","Shapes Style")
    }

    ColumnLayout {
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            spacing: 2

            readonly property int style: indicator.configuration.style

            readonly property int buttonsCount: 3
            readonly property int buttonSize: (dialog.optionsWidth - (spacing * buttonsCount-1)) / buttonsCount

            ExclusiveGroup {
                id: styleGroup
                onCurrentChanged: {
                    if (current.checked) {
                        indicator.configuration.style = current.style;
                    }
                }
            }

            PlasmaComponents.Button {
                Layout.minimumWidth: parent.buttonSize
                Layout.maximumWidth: Layout.minimumWidth

                text: i18nc("triangle indicators","Triangle")
                checked: parent.style === style
                checkable: true
                exclusiveGroup: styleGroup
                tooltip: i18n("Show triangles for item states")

                readonly property int style: 0 /*Triangle*/
            }

            PlasmaComponents.Button {
                Layout.minimumWidth: parent.buttonSize
                Layout.maximumWidth: Layout.minimumWidth

                text: i18nc("dot indicators", "Dot")
                checked: parent.style === style
                checkable: true
                exclusiveGroup: styleGroup
                tooltip: i18n("Show dots for item states")

                readonly property int style: 1 /*Dot*/
            }

            PlasmaComponents.Button {
                Layout.minimumWidth: parent.buttonSize
                Layout.maximumWidth: Layout.minimumWidth

                text: i18nc("rectangle indicators", "Rectangle")
                checked: parent.style === style
                checkable: true
                exclusiveGroup: styleGroup
                tooltip: i18n("Show rectangles for item states")

                readonly property int style: 2 /*Rectangle*/
            }
        }

        LatteComponents.CheckBoxesColumn {
            Layout.topMargin: 7
            Layout.fillWidth: true
            visible: indicator.latteTasksArePresent

            LatteComponents.CheckBoxesColumn {
                LatteComponents.CheckBox {
                    Layout.maximumWidth: dialog.optionsWidth
                    text: i18n("Fill for minimized windows")
                    checked: indicator.configuration.fillShapesForMinimized

                    onClicked: {
                        indicator.configuration.fillShapesForMinimized = !indicator.configuration.fillShapesForMinimized;
                    }
                }
            }

            LatteComponents.CheckBox {
                id: shapesBorder
                Layout.maximumWidth: dialog.optionsWidth
                text: i18n("Draw border")
                checked: indicator.configuration.drawShapesBorder

                onClicked: {
                    indicator.configuration.drawShapesBorder = !indicator.configuration.drawShapesBorder;
                }
            }

            LatteComponents.CheckBox {
                id: shapesPlacement
                Layout.maximumWidth: dialog.optionsWidth
                text: i18n("Place at foreground above item icon")
                checked: indicator.configuration.shapesAtForeground

                onClicked: {
                    indicator.configuration.shapesAtForeground = !indicator.configuration.shapesAtForeground;
                }
            }
        }
    }

    LatteComponents.SubHeader {
        text: i18n("Options")
        visible: deprecatedPropertiesAreHidden
    }

    LatteComponents.CheckBoxesColumn {
        Layout.topMargin: 1.5 * units.smallSpacing
        visible: deprecatedPropertiesAreHidden

        LatteComponents.CheckBox {
            Layout.maximumWidth: dialog.optionsWidth
            text: i18n("Show indicators for applets")
            checked: indicator.configuration.enabledForApplets
            tooltip: i18n("Indicators are shown for applets")

            onClicked: {
                indicator.configuration.enabledForApplets = !indicator.configuration.enabledForApplets;
            }
        }
    }
}
