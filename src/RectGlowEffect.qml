/*
 Copyright (c) 2008-2024, Benoit AUTHEMAN All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the author or Destrat.io nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL AUTHOR BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

//-----------------------------------------------------------------------------
// This file is a part of the QuickQanava software library.
//
// \file	RectGlowEffect.qml
// \author	benoit@destrat.io
// \date	2018 03 23
//-----------------------------------------------------------------------------

import QtQuick
import QtQuick.Effects

import QuickQanava          2.0 as Qan
import "qrc:/QuickQanava" as Qan

/*! \brief Node or group background glow effect with transparent mask for node content.
 */
Item {
    id: glowEffect

    // PUBLIC /////////////////////////////////////////////////////////////////
    property var    style: undefined

    // PRIVATE ////////////////////////////////////////////////////////////////
    // Default settings for rect radius, shadow margin is the _maximum_ shadow radius (+vertical or horizontal offset).
    readonly property real   glowRadius:     style ? style.effectRadius : 3.
    readonly property color  glowColor:      style ? style.effectColor : Qt.rgba(0.7, 0.7, 0.7, 0.7)
    readonly property real   borderWidth:    style ? style.borderWidth : 1.
    readonly property real   borderWidth2:   borderWidth / 2.
    readonly property real   backRadius:     style ? style.backRadius : 4.

    Rectangle {         // Hidden item used to generate shadow
        id: border
        anchors.fill: parent
        anchors.margins: 1
        radius: backRadius
        color: glowColor
        clip: true
        visible: false
    }

    MultiEffect {
        source: border
        visible: glowEffect.visible
        anchors.centerIn: parent
        width: border.width + (glowRadius * 2)
        height: border.height + (glowRadius * 2)
        blurEnabled: glowEffect.visible &&
                     glowEffect.style !== undefined ? style.effectEnabled : false
        blurMax: 30
        blur: 1.
        colorization: 1.0
        colorizationColor: glowColor

        maskEnabled: true && glowEffect.visible
        maskThresholdMin: 0.29      // Should be just below border.color
        maskSpreadAtMin: 1.0
        maskSource: ShaderEffectSource {
            live: true
            width: border.width
            height: border.height
            smooth: false
            sourceItem: Rectangle {
                x: 1
                y: 1
                width: border.width - 2
                height: border.height - 2
                border.width: 1
                border.color: Qt.rgba(1, 1, 1, 0.3)
                color: Qt.rgba(0, 0, 0, 0)
                radius: backRadius
            }
        }
    }
}  // Item: glowEffect
