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

	onLoginSucceeded: {
	    errorMessage.color = "green"
	    errorMessage.text = "loginSucceeded"
	}

	onLoginFailed: {
	    username.text = ""
	    password.text = ""
	    username.focus = true
	    errorMessage.color = "red"
	    errorMessage.text = "loginFalied"
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
	anchors.bottomMargin: 980
	anchors.leftMargin: 1850
	color: "transparent"

	Column {
	    id: settings
	    anchors.centerIn: parent
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
    	id: feld
	anchors.fill: parent
	anchors.topMargin: 550
	anchors.bottomMargin: 350
	anchors.leftMargin: 750
	anchors.rightMargin: 750

	border.color: "white"
	border.width: 2
	radius: 2
	color: "transparent"

	Column {
	    id: mainfield
	    anchors.centerIn: parent
	    width: parent.width / 2
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