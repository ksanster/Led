package de.nulldesign.nd2d.materials {

    import de.nulldesign.nd2d.geom.Face;
    import flash.display3D.Context3D;
    import flash.geom.Vector3D;

    /**
     * ...
     * @author Mike Almond - https://github.com/mikedotalmond
     */

    public class APolygon2DMaterial extends AMaterial {

        public var registrationOffset	:Vector3D;

        public function APolygon2DMaterial() {
            registrationOffset = new Vector3D();
            drawCalls = 1;
        }

        public function get asColorMaterial():Polygon2DColorMaterial { return this as Polygon2DColorMaterial; }
        public function get asTextureMaterial():Polygon2DTextureMaterial { return this as Polygon2DTextureMaterial; }

    }
}