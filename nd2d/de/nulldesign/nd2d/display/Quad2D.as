package de.nulldesign.nd2d.display {

    import de.nulldesign.nd2d.geom.Face;
    import de.nulldesign.nd2d.geom.Vertex;
    import de.nulldesign.nd2d.materials.BlendModePresets;
    import de.nulldesign.nd2d.materials.Quad2DColorMaterial;
    import de.nulldesign.nd2d.utils.TextureHelper;
    import flash.geom.Vector3D;

    import flash.display3D.Context3D;

    /**
     * A quad can have four custom colors (in ARGB format. eg. 0xFF990022) for each corner. The colors will be interpolated between the corners.
     */
    public class Quad2D extends Node2D {

        public var faceList:Vector.<Face>;
        public var material:Quad2DColorMaterial;

        public function get topLeftColor():uint {
            return faceList[0].v1.color;
        }

        public function set topLeftColor(value:uint):void {
            var v:Vertex = faceList[0].v1;
            v.color = value;
            material.modifyColorInBuffer(0, v.r, v.g, v.b, v.a);
        }

        public function get topRightColor():uint {
            return faceList[0].v2.color;
        }

        public function set topRightColor(value:uint):void {
            var v:Vertex = faceList[0].v2;
            v.color = value;
            material.modifyColorInBuffer(1, v.r, v.g, v.b, v.a);
        }

        public function get bottomRightColor():uint {
            return faceList[0].v3.color;
        }

        public function set bottomRightColor(value:uint):void {
            var v:Vertex = faceList[0].v3;
            v.color = value;
            material.modifyColorInBuffer(2, v.r, v.g, v.b, v.a);
        }

        public function get bottomLeftColor():uint {
            return faceList[1].v3.color;
        }

        public function set bottomLeftColor(value:uint):void {
            var v:Vertex = faceList[1].v3;
            v.color = value;
            material.modifyColorInBuffer(3, v.r, v.g, v.b, v.a);
        }

        public function Quad2D(pWidth:Number, pHeight:Number) {

            _width = pWidth;
            _height = pHeight;

            faceList = TextureHelper.generateQuadFromDimensions(pWidth, pHeight);
            material = new Quad2DColorMaterial();

            topLeftColor = 0xFFFF0000;
            topRightColor = 0xFF00FF00;
            bottomRightColor = 0xFF0000FF;
            bottomLeftColor = 0xFFFFFF00;

            blendMode = BlendModePresets.NORMAL_NO_PREMULTIPLIED_ALPHA;
        }

        /**
         * Set quad vertex positions (x,y)
         *
         * Quad
         * v1 v2
         * v4 v3
         *
         * Faces
         * v1,v2,v3
         * v1,v3,v4
         *
         * @param v1
         * @param v2
         * @param v3
         * @param v4
         */
        public function setVertexPositions(v1:Vector3D, v2:Vector3D, v3:Vector3D, v4:Vector3D):void {
// top left (face 1+2)
            if(v1){
                faceList[0].v1.x = faceList[1].v1.x = v1.x;
                faceList[0].v1.y = faceList[1].v1.y = v1.y;
            }
// top right (face 1)
            if (v2) {
                faceList[0].v2.x = v2.x;
                faceList[0].v2.y = v2.y;
            }
// bottom right (face 1+2)
            if (v3) {
                faceList[0].v3.x = faceList[1].v2.x = v3.x;
                faceList[0].v3.y = faceList[1].v2.y = v3.y;
            }
// bottom left (face 2
            if (v4) {
                faceList[1].v3.x = v4.x;
                faceList[1].v3.y = v4.y;
            }

            material.setVertexPositions(v1, v2, v3, v4);
        }

        public function getVertex(index:uint):Vertex {
            switch(index) {
                case 0: return faceList[0].v1; break;
                case 1: return faceList[0].v2; break;
                case 2: return faceList[0].v3; break;
                case 3: return faceList[1].v3; break;
                default: throw new RangeError("I'm a quad! I only have 4 vertices.");
            }
        }

        public function copy():Node2D {
            var q:Quad2D = new Quad2D(_width, _height);
            q.material	= new Quad2DColorMaterial();
            q.copyPropertiesOf(this);
            return q;
        }

        public function copyPropertiesOf(source:Quad2D):void {

            topLeftColor = source.topLeftColor;
            topRightColor = source.topRightColor;
            bottomRightColor = source.bottomRightColor;
            bottomLeftColor = source.bottomLeftColor;
            blendMode = source.blendMode;
            rotation = source.rotation;
            position = source.position;
            alpha = source.alpha;
            visible = source.visible;
            vx = source.vx;
            vy	= source.vy;

            setVertexPositions(source.getVertex(0), source.getVertex(1), source.getVertex(2), source.getVertex(3));

        }

        override public function get numTris():uint {
            return faceList.length;
        }

        override public function get drawCalls():uint {
            return material.drawCalls;
        }

        override public function handleDeviceLoss():void {
            super.handleDeviceLoss();
            if(material) material.handleDeviceLoss();
        }

        override protected function draw(context:Context3D, camera:Camera2D):void {
            material.blendMode = blendMode;
            material.modelMatrix = worldModelMatrix;
            material.nodeTinted = material.nodeTinted;
            material.viewProjectionMatrix = camera.getViewProjectionMatrix(false);
            material.render(context, faceList, 0, 2);
        }

        override public function set alpha(value:Number):void {
            if (value < 0) value = 0;

            var a:uint = uint(Math.round(value * 0xff)) << 24;
            topLeftColor = (topLeftColor & 0x00ffffff) | a;
            topRightColor = (topRightColor & 0x00ffffff) | a;
            bottomRightColor = (bottomRightColor & 0x00ffffff) | a;
            bottomLeftColor = (bottomLeftColor & 0x00ffffff) | a;

            _alpha = value;
            invalidateColors = true;
            visible = _alpha > 0.0;
        }

        override public function dispose():void {
            if(material) {
                material.dispose();
                material = null;
            }
            super.dispose();
        }

        public function flatColor(value:uint, alpha:Number = 1):void {
            topLeftColor = bottomLeftColor = topRightColor = bottomRightColor = (value & 0x00ffffff) | (uint(Math.round(alpha * 0xff)) << 24);
            _alpha = alpha;
            visible = _alpha > 0.0;
            invalidateColors = true;
        }

        public function linearGradient(start:uint, end:uint, startAlpha:Number = 1.0, endAlpha:Number = 1.0, horizontal:Boolean = false):void {

            start = (start	& 0x00ffffff) | (uint(Math.round(startAlpha * _alpha * 0xff)) << 24);
            end = (end & 0x00ffffff) | (uint(Math.round(endAlpha * _alpha * 0xff)) << 24);

            if (horizontal) {
                bottomLeftColor = start;
                topRightColor	= end;
            } else {
                topRightColor	= start;
                bottomLeftColor = end;
            }

            topLeftColor	= start;
            bottomRightColor	= end;

            _alpha = (startAlpha + endAlpha) / 2;
            visible = _alpha > 0.0;
            invalidateColors = true;
        }
    }
}