package de.nulldesign.nd2d.geom {

    /**
     * ...
     * @author Mike Almond - https://github.com/mikedotalmond
     */

    import de.nulldesign.nd2d.utils.PolyUtils;
    import flash.display.Shape;

    import flash.geom.Rectangle;
    import flash.geom.Vector3D;

//    import nape.geom.Vec2;
//    import nape.geom.Vec2List;
//    import nape.phys.Body;
//    import nape.shape.ShapeList;

    public final class PolygonData {

        public var alignedAboutCentroid	:Boolean;
        public var triangleMeshHasCentralVertex	:Boolean;
        public var bounds	:Rectangle;
        public var triangleVertices	:Vector.<Vertex>;
        public var polygonVertices	:Vector.<Vertex>;

        /**
         *
         * @param vertices List of Vector3Ds describing a convex polygon, or if constructHull==true, a point cloud to be formed into a convex polygon
         * @param constructHull Set true for most cases - //NOTE: is the option needed?
         */
        public function PolygonData(vertices:Vector.<Vertex>, constructHull:Boolean = true, useBoundsForCentroid:Boolean = false) {
            if (vertices == null) return;
            if (vertices.length < 3) {
                throw new RangeError("Too few vertices, that's no polygon!");
                return;
            }

            this.polygonVertices = constructHull ? PolyUtils.convexHull(vertices) : vertices;
            init(useBoundsForCentroid);
        }

        private function init(useBoundsForCentroid:Boolean):void {

            var t:Vector.<Vertex> = polygonVertices.concat();

            t.fixed = true;
            const n:uint = t.length;

            t.sort(PolyUtils.sortVector3DByY);
            const minY	:Number = t[0].y
            const maxY	:Number = t[uint(n - 1)].y;

            t.sort(PolyUtils.sortVector3DByX);
            const minX	:Number = t[0].x
            const maxX	:Number = t[uint(n - 1)].x;

            const dx	:Number = maxX - minX; // width
            const dy	:Number = maxY - minY; // height
            const hdx	:Number = dx / 2;
            const hdy	:Number = dy / 2;

            bounds = new Rectangle(minX, minY, dx, dy); // rect encompassing the original path bonuds
// get centre-of-mass (centroid)
            const cnt:Vector3D = useBoundsForCentroid ? new Vector3D(bounds.x + (bounds.width / 2), bounds.y + (bounds.height / 2)) : PolyUtils.getCentroid(polygonVertices);
            polygonVertices.map(function(item:Vertex, index:int, vector:Vector.<Vertex>):void {
                item.x -= cnt.x;
                item.y -= cnt.y;
            });

            t = polygonVertices.concat();
            t.fixed = true;
// triangulate
            triangleVertices = PolyUtils.triangulateConvexPolygon(t);
        }
/*
        static public function fromNapeBodyShapes(shapes:ShapeList, width:int, height:int):PolygonData {

            var shapeIndex	:int = -1;
            const numShapes	:int = shapes.length;

            var verts	:Vector.<Vertex>	= new Vector.<Vertex>();
            var triangles	:Vector.<Vertex>	= new Vector.<Vertex>();

            var polyWorldVerts	:Vec2List;
            var vCount	:int;
            var vIndex	:int;

            var polygonData:PolygonData = new PolygonData(null);
            polygonData.bounds = new Rectangle(0, 0, width, height);
            polygonData.alignedAboutCentroid = true;
            polygonData.triangleMeshHasCentralVertex = false;
            polygonData.polygonVertices = null;
            verts.fixed = false;
            while (++shapeIndex < numShapes) {
                polyWorldVerts	= shapes.at(shapeIndex).castPolygon.worldVerts;
                vCount	= polyWorldVerts.length;

                if (vCount > 2) {
                    vIndex = -1;
                    while (++vIndex < vCount) {
                        verts.push(new Vertex(polyWorldVerts.at(vIndex).x, polyWorldVerts.at(vIndex).y));
                    }
                    triangles = triangles.concat(PolyUtils.triangulateConvexPolygon(verts));
                    verts.fixed = false;
                }

                verts.length = 0;
            }

            triangles.fixed = true;
            polygonData.triangleVertices = triangles;

            return polygonData;
        }
    */
    }
}