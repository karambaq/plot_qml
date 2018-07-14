import QtQuick 2.0
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.2
 
ApplicationWindow {
    id: main_window
    visible: true
    width: 640
	height: 500
    title: qsTr("Function plot")
    Material.theme: Material.Dark

    property var points: null
    onPointsChanged: canv.requestPaint()

    GridLayout {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 9

        columns: 4
        rows: 10
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
            height: 40
            Layout.fillWidth: true
            text: qsTr("Build plot")
            onClicked: plot.upd(left_bound.text, right_bound.text, func.currentText)
        }

        Canvas {
            id: canv
			height: main_window.height
			Layout.columnSpan: 4
            Layout.fillWidth: true
            onPaint: {
    			var ctx = getContext("2d");
                ctx.fillStyle = 'whitesmoke'
    			ctx.fillRect(0, 0, width, height);
    				
    			// draws coordinates
    		    ctx.lineWidth = 1;
    		    ctx.strokeStyle = "black"
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
    			ctx.strokeStyle = "black"

    			var length = Math.abs(right_bound.text - left_bound.text) * 2

                if (points !== null){
    				for (var p in points){
    				    ctx.fillStyle = '#63FD8E'
    				    ctx.fillRect((points[p][0] * width / length + width / 2), -(points[p][1] * height / 2) + height / 2, 2, 2);
    				}
    				
    				ctx.fillStyle = "black"
    				for(var i = left_bound.text * 1.0; i <= right_bound.text * 1.0; i += 1)
    				{
    				    ctx.fillRect((i * width / length + width / 2) - 0.5, height / 2 - 7.5, 1, 15)
    				    ctx.font = "9px Times";
    		    	    ctx.strokeText(i, (i * width / length + width / 2) - 10, height / 2 + 20);
    				}

    				for(var i = -0.5; i < 1; i += 0.5)
    				{
    				    if (i != 0) {
    				    ctx.fillRect(width / 2 - 7.5, (i * height / 2 + height / 2) - 0.5, 15, 1)
    				    ctx.font = "9px Times";
    		    	    ctx.strokeText(i, width / 2 - 20, (i * height / 2 + height / 2) - 0.5 - 7.5);
    				    }
    				}
    		    }
            }
        }

        Connections {
            target: plot
        	onUpdCanv: points = upd
        }
    }
}
