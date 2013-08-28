import bb.cascades 1.0

Container {
    Container {        
        layout: DockLayout {}
        background: Color.Black
        
        ImageView {
            imageSource: "asset:///application-cover.png"
            scalingMethod: ScalingMethod.AspectFit
        }
    }
}