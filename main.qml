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
    Material.background: "#3B3B60"
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
				ctx.strokeStyle = 'grey'
    		    ctx.lineWidth = 1;
	    		ctx.beginPath()
	    		ctx.moveTo(0, height / 2)
	    		ctx.lineTo(width, height / 2)
	    		ctx.closePath()
				ctx.stroke()                   
				ctx.strokeStyle = 'grey'

    			var length = Math.abs(right_bound.text - left_bound.text) * 2

				warning.text = ""
				if (scaleFactor <= 0) {
				    warning.text = "Too far"
				}
				if (func.currentText == 'sqrt' && left_bound.text < 0){
				    warning.text = "Left bound must be >= 0"
			    }
                if (points !== null && scaleFactor > 0){
					var left_b = left_bound.text * 1.0
					var right_b = right_bound.text * 1.0
					var old_range = right_b - left_b
					// formula:
					// new_value = ((old_value - left_b) * new_range / width) + new_min
					// our new_min is 0
    				for (var p in points){
    				    ctx.fillStyle = Material.accent
						var x = (points[p][0] - left_b) * width / old_range
						ctx.fillRect(x, -(points[p][1]) * scaleFactor * height / 2 + height / 2, 2, 2);
    				}
    				
    				ctx.fillStyle = "grey"
    				for(var i = left_b; i <= right_b; i += 1)
    				{
						var x = (i - left_b) * width / old_range
						if (i == 0) {
							var y_line = x
			    		    ctx.strokeStyle = "grey"
			    		    ctx.beginPath()
			    		    ctx.moveTo(x, 0)
			    		    ctx.lineTo(x, height)
			    		    ctx.closePath()
			    			ctx.stroke()                   
						}
    				    ctx.fillRect(x - 0.5, height / 2 - 7.5, 1, 15)
    				    ctx.font = "11px 'Exo 2'";
    		    	    ctx.strokeText(i, x - 0.5, height / 2 + 20);
    				}

    				for(var i = -1; i <= 1; i += 0.5)
    				{
    				    if (i != 0) {
							if (y_line != 0) {
    						    ctx.fillRect(y_line - 7.5, (i * height / 2 * scaleFactor + height / 2) - 0.5, 15, 1)
    						    ctx.font = "11px 'Exo 2'";
    		 		   	    	ctx.strokeText(-i, y_line - 25, (i * height / 2 * scaleFactor + height / 2) - 0.5 - 7.5);
							}
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
