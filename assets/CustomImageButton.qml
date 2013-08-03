import bb.cascades 1.0

Container {
    property alias text: label.text
    property alias textStyle: label.textStyle
    property alias image: img.imageSource
    signal clicked()

    property variant clicking
    property variant startX
    property variant startY
    property variant moveThreshold: 15
    ImageView {
        id: img
        touchPropagationMode: TouchPropagationMode.PassThrough
        horizontalAlignment: HorizontalAlignment.Center
    }
    Container {
        background: Color.DarkGreen
        topPadding: 10.0
        leftPadding: 20.0
        bottomPadding: 10.0
        rightPadding: 20.0
        verticalAlignment: VerticalAlignment.Center
        Label {
            id: label
            touchPropagationMode: TouchPropagationMode.PassThrough
            textStyle.fontSize: FontSize.Large
            textStyle.fontStyle: FontStyle.Normal
            textStyle.fontWeight: FontWeight.Normal
            textStyle.color: Color.White
            verticalAlignment: VerticalAlignment.Center
        }
    }
    onTouch: {
        if (event.isDown()) {
            clicking = true;
            startX = event.localX;
            startY = event.localY;
        } else if (event.isMove()) {
            if (Math.abs(startX - event.localX) > moveThreshold || Math.abs(startY - event.localY) > moveThreshold) {
                clicking = false;
            }
        } else if (event.isUp()) {
            if (clicking == true) {
                clicked();
            }
            clicking = false;
        }

    }
}
