import QtQuick 2.0
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.2
 
ApplicationWindow {
    id: main_window
    visible: true
    width: 900
	height: 700
    Material.theme: Material.Dark
	Material.background: "#333351"
    Material.accent: "#65B486"
    Material.foreground: "#efefef"

    property var points: null
    onPointsChanged: canv.requestPaint()

    GridLayout {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 9

        columns: 4
        rows: 3
        rowSpacing: 10
        columnSpacing: 10


        TextField {
            id: left_bound
			Layout.fillWidth: true
			placeholderText: 'Left bound'
        }


        TextField {
            id: right_bound
			Layout.fillWidth: true
			placeholderText: 'Right bound'
        }

    	ComboBox {
    	    id: func
    	    model: ['cos', 'sin', 'x^2', 'tan', 'sqrt']
    	}

        Button {
			highlighted: true
            Layout.fillWidth: true
            text: qsTr("Build plot")
		    //Material.foreground: Material.
			onClicked:{ 
				canv.scaleFactor = 1
		        plot.upd(left_bound.text, right_bound.text, func.currentText)
		    }
        }

        Canvas {
            id: canv
			height: main_window.height - 80
			Layout.columnSpan: 4
            Layout.fillWidth: true
		    property real scaleFactor: 1
		    MouseArea {
                anchors.fill: parent
                onWheel: {
				    if (parent.scaleFactor >= 0) {
				        parent.scaleFactor += 0.2 * wheel.angleDelta.y / 120;
					    parent.requestPaint()
				    } else {
				        parent.scaleFactor = 0
					    parent.requestPaint()
					}

                }
            }
            onPaint: {
    			var ctx = getContext("2d");
                ctx.fillStyle = Material.background
    			ctx.fillRect(0, 0, width, height);
    				
    			// draws coordinates
    		    ctx.lineWidth = 1;
    		    ctx.strokeStyle = "grey"
    		    ctx.beginPath()
    		    ctx.moveTo(width / 2, 0)
    		    ctx.lineTo((width / 2), height)
    		    ctx.closePath()
    			ctx.stroke()                   
    		    ctx.beginPath()
    		    ctx.moveTo(0, height / 2)
    		    ctx.lineTo(width, height / 2)
    		    ctx.closePath()
    			ctx.stroke()                   
    			ctx.strokeStyle = 'grey'

    			var length = Math.abs(right_bound.text - left_bound.text) * 2

				warning.text = ""
				if (scaleFactor <= 0){
				    warning.text = "Too far"
				}
				if (func.currentText == 'sqrt' && left_bound.text < 0){
				    warning.text = "Left bound must be >= 0"
			    }
                if (points !== null && scaleFactor > 0){
    				for (var p in points){
    				    ctx.fillStyle = Material.accent
    				    ctx.fillRect((points[p][0] * width / 22 * scaleFactor + width / 2), -(points[p][1] * height / 2) * scaleFactor + height / 2, 2, 2);
    				}
    				
    				ctx.fillStyle = "grey"
    				for(var i = left_bound.text * 1.0; i <= right_bound.text * 1.0; i += 1)
    				{
    				    ctx.fillRect((i * width / 22 * scaleFactor + width / 2) - 0.5, height / 2 - 7.5, 1, 15)
    				    ctx.font = "11px 'Exo 2'";
    		    	    ctx.strokeText(i, (i * width / 22 * scaleFactor + width / 2) - 10, height / 2 + 20);
    				}

    				for(var i = -1; i <= 1; i += 0.5)
    				{
    				    if (i != 0) {
    				    ctx.fillRect(width / 2 - 7.5, (i * height / 2 * scaleFactor + height / 2) - 0.5, 15, 1)
    				    ctx.font = "11px 'Exo 2'";
    		    	    ctx.strokeText(-i, width / 2 - 25, (i * height / 2 * scaleFactor + height / 2) - 0.5 - 7.5);
    				    }
    				}
    		    }
            }
        }
    }

    Connections {
        target: plot
        onUpdCanv: points = upd
    }

    Text {
		id: warning
		color: "#F48FB1"
        text: qsTr("x:")
		x: 15
		y: main_window.height - 40
    }
}
