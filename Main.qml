 /*! Simple is a simple sddm-theme optimized for 1920x1080 displays.
     Smaller displays work as well, but you may not be statisfied by the looks.
     Copyright (C) 2018  Anton Fehsenmayr

     This program is free software: you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
     the Free Software Foundation, either version 3 of the License, or
     (at your option) any later version.

     This program is distributed in the hope that it will be useful,
     but WITHOUT ANY WARRANTY; without even the implied warranty of
     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
     GNU General Public License for more details.

     You should have received a copy of the GNU General Public License
     along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    id: container
    width: 3840
    height: 2160
    color: "black"

    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property int sessionIndex: session.index

    Connections {
        target: sddm

	onLoginFailed: {
	    username.text = ""
	    password.text = ""
	    username.focus = true
	}
    }

    Background {
        anchors.fill: parent
	source: config.background
	fillMode: Image.PreserveAspectCrop
	onStatusChanged: {
	    if(status == Image.Error && source != config.defaultBackground){
	    	      source = config.defaultBackground
	    }
	}
    }

    Clock {
        id: clock
	anchors.left: parent.horizontalCenter;
	anchors.right: parent.horizontalCenter;
	anchors.bottom: parent.verticalCenter;
	anchors.bottomMargin: 20

	color: "white"

    }

    Rectangle {
        id: actions
	anchors.fill: parent
	color: "transparent"

	Column {
	    id: settings
	    anchors.right: parent.right
	    anchors.top: parent.top
	    anchors.rightMargin: 10
	    anchors.topMargin: 10
	    spacing: 18

	    ImageButton {
	        id: shutdown
		source: "system-shutdown.png"
		
		onClicked: sddm.powerOff()

		KeyNavigation.backtab: password; KeyNavigation.tab: reboot;
	    }

	    ImageButton {
	    	id: reboot
		source: "view-refresh.png"
		
		onClicked: sddm.reboot()

		KeyNavigation.backtab: shutdown; KeyNavigation.tab: username;
	    }
	}
    }

    Rectangle {
    	id: loginfield
	anchors.fill: parent
	anchors.topMargin: parent.height / 2
	anchors.bottomMargin: parent.height / 3
	anchors.leftMargin: 32 * parent.width / 80
	anchors.rightMargin: 32 * parent.width / 80
	border.color: "white"
	border.width: 2
	radius: 2
	color: "transparent"

	Column {
	    id: login
	    anchors.centerIn: parent
	    width: 2 * parent.width / 3
	    spacing: 5
	    
	    Text {
	    	color: "white"
		text: "username:"
		font.pixelSize: 18
	    }
	    
	    TextBox {
	        id: username
		focus: true
	    	width: parent.width
	    	height: 30
		color: "white"
	    	text: ""
		radius: 2
	    	font.pixelSize: 18

	    	KeyNavigation.backtab: ; KeyNavigation.tab: password;
	    }

	    Text {
	        color: "white"
		text: "password:"
		font.pixelSize: 18
	    }

	    PasswordBox {
	        id: password
	    	width: parent.width
	    	height: 30
		text: ""
		radius: 2
	    	font.pixelSize: 18

	    	KeyNavigation.backtab: name; KeyNavigation.tab: ;

		Keys.onPressed: {
		    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter){
		        sddm.login(username.text, password.text, sessionIndex)
			event.accepted = true
		    }
		}
	    }
	}
    }
}