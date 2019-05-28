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

import QtQuick 2.0
import QtGraphicalEffects 1.0

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: frontLayer
    anchors.fill: parent

    Row {
        id: upperIndicators
        spacing: 2
        readonly property bool alwaysActive: true
        readonly property bool reversed: true

        Repeater {
            model: (indicator.isTask && (indicator.isActive || indicator.hasActive))
                   || (indicator.isApplet && indicator.isActive && !indicator.isSquare) ? 1 : 0
            delegate: indicator.configuration.style === 0 /*Triangles*/ ? triangleComponent : circleComponent
        }
    }

    Grid {
        id: lowerIndicators
        rows: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? 1 : Math.min(3, indicator.windowsCount)
        columns: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? Math.min(3, indicator.windowsCount) : 1
        rowSpacing: 2
        columnSpacing: 2

        readonly property bool alwaysActive: false
        readonly property bool reversed: false

        Repeater {
            model: Math.min(3, indicator.windowsCount)
            delegate: indicator.configuration.style === 0 /*Triangles*/ ? triangleComponent : circleComponent
        }
    }

    readonly property bool fillShapesBackground: {
        if (indicator.configuration.fillShapesForMinimized) {
            return true;
        }

        if (!parent.alwaysActive && indicator.windowsMinimizedCount!==0
                && ((index < maxDrawnMinimizedWindows)
                    || (indicator.windowsCount === indicator.windowsMinimizedCount))) {
            return false;
        }

        return true;
    }

    //! Triangle Indicator Component
    Component {
        id: triangleComponent
        Canvas {
            id: canvas
            width: indicator.currentIconSize / 6
            height: width

            rotation: {
                if (!parent.reversed) {
                    if (plasmoid.location === PlasmaCore.Types.BottomEdge) {
                        return 0;
                    } else if (plasmoid.location === PlasmaCore.Types.LeftEdge) {
                        return 90;
                    } else if (plasmoid.location === PlasmaCore.Types.TopEdge) {
                        return 180;
                    } else if (plasmoid.location === PlasmaCore.Types.RightEdge) {
                        return 270;
                    }
                } else {
                    if (plasmoid.location === PlasmaCore.Types.BottomEdge) {
                        return 180;
                    } else if (plasmoid.location === PlasmaCore.Types.LeftEdge) {
                        return 270;
                    } else if (plasmoid.location === PlasmaCore.Types.TopEdge) {
                        return 0;
                    } else if (plasmoid.location === PlasmaCore.Types.RightEdge) {
                        return 90;
                    }
                }

                return 0;
            }

            readonly property int lineWidth: 2

            Connections {
                target: root
                onActiveColorChanged: canvas.requestPaint();
                onBackgroundColorChanged: canvas.requestPaint();
                onOutlineColorChanged: canvas.requestPaint();
            }

            Connections {
                target: frontLayer
                onFillShapesBackgroundChanged: requestPaint();
            }


            onPaint: {
                var ctx = getContext('2d');
                ctx.clearRect(0, 0, canvas.width, canvas.height);
                ctx.strokeStyle = root.outlineColor;
                ctx.lineWidth = lineWidth;

                ctx.beginPath();
                ctx.moveTo(0, canvas.height);
                ctx.lineTo(canvas.width/2, 0);
                ctx.lineTo(canvas.width, canvas.height);
                ctx.lineTo(0, canvas.height);
                ctx.closePath();
                ctx.stroke();

                ctx.strokeStyle = root.activeColor;
                ctx.fillStyle = fillShapesBackground ? root.activeColor : root.backgroundColor;

                ctx.beginPath();
                ctx.moveTo(lineWidth, canvas.height - lineWidth);
                ctx.lineTo(canvas.width/2, lineWidth);
                ctx.lineTo(canvas.width - lineWidth, canvas.height - lineWidth);
                ctx.lineTo(lineWidth, canvas.height - lineWidth);
                ctx.closePath();
                ctx.stroke();
                ctx.fill();
            }
        }
    }

    //! Triangle Indicator Component
    Component {
        id: circleComponent
        Rectangle {
            width: indicator.currentIconSize / 8
            height: width

            radius: indicator.configuration.style === 1 /*Dot*/ ? width/2 : 2
            border.width: 1
            border.color: root.outlineColor
            color: "transparent"

            Rectangle{
                anchors.fill: parent
                anchors.margins: parent.border.width
                border.width: 1
                border.color: root.activeColor
                radius: parent.radius
                color: fillShapesBackground ? root.activeColor : root.backgroundColor
            }
        }
    }

    //! States
    states: [
        State {
            name: "bottom"
            when: (plasmoid.location === PlasmaCore.Types.BottomEdge)

            AnchorChanges {
                target: lowerIndicators
                anchors{ top:undefined; bottom:parent.bottom; left:undefined; right:undefined;
                    horizontalCenter:parent.horizontalCenter; verticalCenter:undefined}
            }
            AnchorChanges {
                target: upperIndicators
                anchors{ top:parent.top; bottom:undefined; left:undefined; right:undefined;
                    horizontalCenter:parent.horizontalCenter; verticalCenter:undefined}
            }
        },
        State {
            name: "top"
            when: (plasmoid.location === PlasmaCore.Types.TopEdge)

            AnchorChanges {
                target: lowerIndicators
                anchors{ top:parent.top; bottom:undefined; left:undefined; right:undefined;
                    horizontalCenter:parent.horizontalCenter; verticalCenter:undefined}
            }
            AnchorChanges {
                target: upperIndicators
                anchors{ top:undefined; bottom:parent.bottom; left:undefined; right:undefined;
                    horizontalCenter:parent.horizontalCenter; verticalCenter:undefined}
            }
        },
        State {
            name: "left"
            when: (plasmoid.location === PlasmaCore.Types.LeftEdge)

            AnchorChanges {
                target: lowerIndicators
                anchors{ top:undefined; bottom:undefined; left:parent.left; right:undefined;
                    horizontalCenter:undefined; verticalCenter:parent.verticalCenter}
            }
            AnchorChanges {
                target: upperIndicators
                anchors{ top:undefined; bottom:undefined; left:undefined; right:parent.right;
                    horizontalCenter:undefined; verticalCenter:parent.verticalCenter}
            }
        },
        State {
            name: "right"
            when: (plasmoid.location === PlasmaCore.Types.RightEdge)

            AnchorChanges {
                target: lowerIndicators
                anchors{ top:undefined; bottom:undefined; left:undefined; right:parent.right;
                    horizontalCenter:undefined; verticalCenter:parent.verticalCenter}
            }
            AnchorChanges {
                target: upperIndicators
                anchors{ top:undefined; bottom:undefined; left:parent.left; right:undefined;
                    horizontalCenter:undefined; verticalCenter:parent.verticalCenter}
            }
        }
    ]
}
