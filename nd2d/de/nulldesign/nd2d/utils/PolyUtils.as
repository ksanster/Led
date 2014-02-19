package de.nulldesign.nd2d.utils {

    import flash.geom.Vector3D;
    import de.nulldesign.nd2d.geom.Vertex;

    final public class PolyUtils {

        /**
         * Expects convex polygons without holes - so run some polygon decomposition first if you're working with complex polygons
         * @param polygonVertices - the edge contour of a regular convex polygon
         * @return Triangle vertices [u0,v0,w0,...,uN,vN,wN]
         */
        public static function triangulateConvexPolygon(polygonContour:Vector.<Vertex>):Vector.<Vertex> {
            return Triangulate.process(polygonContour);
        }

        /**
         *
         * @param pointCloud
         * @return
         */
        public static function convexHull(pointCloud:Vector.<Vertex>):Vector.<Vertex> {
            pointCloud.fixed = true;
            pointCloud.sort(sortVector3DByX); // minX -> maxX

            const n	:uint = pointCloud.length;
            const twoPi	:Number = Math.PI * 2;

            var point	:Vector3D = pointCloud[0];
            var hull	:Vector.<Vertex> = new Vector.<Vertex>();
            var angle	:Number = Math.PI / 2;
            var bestAngle	:Number;
            var bestIndex	:int;
            var i	:int = -1;
            var testAngle	:Number = 0;
            var testPoint	:Vertex;

            var firstPass	:Boolean = true;

            while (firstPass || !point.equals(hull[0])) {

                firstPass = false;
                hull.push(point);

                bestAngle = Number.MAX_VALUE;

                i = -1;
                while(++i < n) {
                    testPoint = pointCloud[i];
                    if (testPoint.equals(point)) {
                        continue;
                    } else {
                        testAngle = Math.atan2(testPoint.y - point.y, testPoint.x - point.x) - angle;
                        while (testAngle < 0) testAngle += twoPi;
                        if (testAngle < bestAngle){
                            bestAngle = testAngle;
                            bestIndex = i;
                        }
                    }
                }

                point = pointCloud[bestIndex];
                angle += bestAngle;
            }

            return hull;
        }


        public static function reposition(poly:Vector.<Vertex>, offset:Vector3D):void {
            poly.forEach(
                    function(item:Vector3D, index:int, vector:Vector.<Vertex>):void {
                        item.x += offset.x;
                        item.y += offset.y;
                    }
            );
        }

        /**
         * http://en.wikipedia.org/wiki/Centroid#Centroid_of_polygon
         * @param points
         * @return
         */
        public static function getCentroid(poly:Vector.<Vertex>):Vector3D {
            const A	:Number = 1.0 / (6 * Triangulate.area(poly));

            var x	:Number = 0;
            var y	:Number = 0;

            const n	:int = poly.length - 1;
            var i	:int = -1;
            var b	:Number;

            while (++i < n) {
                b =	(poly[i].x * poly[uint(i + 1)].y - poly[uint(i + 1)].x * poly[i].y);
                x += (poly[i].x + poly[uint(i + 1)].x) * b;
                y += (poly[i].y + poly[uint(i + 1)].y) * b;
            }

            return new Vector3D(A * x, A * y);
        }


        public static function sortVector3DByX(a:Vector3D, b:Vector3D):int {
            return (a.x == b.x) ? 0 : (a.x < b.x ? -1 : 1);
        }

        public static function sortVector3DByY(a:Vector3D, b:Vector3D):int {
            return (a.y == b.y) ? 0 : (a.y < b.y ? -1 : 1);
        }
    }
}



/**
 This code is a quick port of code written in C++ which was submitted to
 flipcode.com by John W. Ratcliff // July 22, 2000
 See original code and more information here:
 http://www.flipcode.com/archives/Efficient_Polygon_Triangulation.shtml

 ported to actionscript by Zevan Rosser
 www.actionsnippet.com
 */

import flash.geom.Vector3D;
import de.nulldesign.nd2d.geom.Vertex;

internal final class Triangulate {

    internal static const EPSILON:Number = 0.0000000001;

    /**
     * Expects convex polygons without holes - so run some polygon decomposition first if you're working with complex polygons
     * @param polygonVertices - the edge contour of a regular convex polygon
     * @return Triangle vertices [u0,v0,w0,...,uN,vN,wN]
     */
    internal static function process(polygonVertices:Vector.<Vertex>):Vector.<Vertex> {
        polygonVertices.fixed = true;
        const n:int = polygonVertices.length
        if ( n < 3 ) return null;

        var result	:Vector.<Vertex>	=	new Vector.<Vertex>();
        const vertexIndices	:Vector.<int> =	new Vector.<int>(n, true);

        var m:int, u:int, v:int, w:int, s:int, t:int;

        /* we want a counter-clockwise polygon in verts */
        if ( 0.0 < area(polygonVertices) ){
            for (v = 0; v < n; v++) vertexIndices[v] = v;
        } else {
            for (v = 0; v < n; v++) vertexIndices[v] = (n - 1) - v;
        }

        var nv	:int = n;
        /* remove nv-2 vertsertices, creating 1 triangle every time */
        var count	:int = 2 * nv; /* error detection */

        for (m = 0, v = nv - 1; nv > 2; ) {
            /* if we loop, it is probably a non-simple polygon */
            if (0 >= (count--)){
//** Triangulate: ERROR - probable bad polygon!
                trace("bad poly :(");
                return null;
            }

            /* three consecutive vertices in current polygon, <u,v,w> */
            u = v; if (nv <= u) u = 0; /* previous */
            v = u + 1; if (nv <= v) v = 0;	/* new v */
            w = v + 1; if (nv <= w) w = 0; /* next */

            if ( snip(polygonVertices,u,v,w,nv,vertexIndices)){
                /* output Triangle */
                result.push( polygonVertices[vertexIndices[u]] );
                result.push( polygonVertices[vertexIndices[v]] );
                result.push( polygonVertices[vertexIndices[w]] );

                m++;

                /* remove v from remaining polygon */
                for (s = v, t = v + 1; t < nv; s++, t++) vertexIndices[s] = vertexIndices[t]; nv--;

                /* reset error detection counter */
                count = 2 * nv;
            }
        }

//trace("Built " + (result.length / 3) + " triangles from the input polygon(" + n + ")");
        result.fixed = true;
        return result;
    }

// calculate area of the contour polygon
    internal static function area(polygonVertices:Vector.<Vertex>):Number {
        const n	:int = polygonVertices.length;
        var a	:Number	= 0.0;

        for (var p:int = n - 1, q:int = 0; q < n; p = q++) {
            a += polygonVertices[p].x * polygonVertices[q].y - polygonVertices[q].x * polygonVertices[p].y;
        }

        return a * 0.5;
    }

// see if p is inside triangle abc
    private static function insideTriangle(	ax:Number, ay:Number, bx:Number, by:Number, cx:Number, cy:Number, px:Number, py:Number):Boolean {

        const aX:Number = cx - bx; const aY:Number = cy - by;
        const bX:Number = ax - cx; const bY:Number = ay - cy;
        const cX:Number = bx - ax; const cY:Number = by - ay;
        const apx:Number= px -ax; const apy:Number= py - ay;
        const bpx:Number= px - bx; const bpy:Number= py - by;
        const cpx:Number= px - cx; const cpy:Number= py - cy;

        const aCROSSbp:Number = aX*bpy - aY*bpx;
        const cCROSSap:Number = cX*apy - cY*apx;
        const bCROSScp:Number = bX*cpy - bY*cpx;

        return ((aCROSSbp >= 0.0) && (bCROSScp >= 0.0) && (cCROSSap >= 0.0));
    }

    private static function snip(polygonVertices:Vector.<Vertex>, u:int, v:int, w:int, n:int, vertIndices:Vector.<int>):Boolean {

        var p:int;
        var px:Number, py:Number;

        const ax:Number = polygonVertices[vertIndices[u]].x;
        const ay:Number = polygonVertices[vertIndices[u]].y;

        const bx:Number = polygonVertices[vertIndices[v]].x;
        const by:Number = polygonVertices[vertIndices[v]].y;

        const cx:Number = polygonVertices[vertIndices[w]].x;
        const cy:Number = polygonVertices[vertIndices[w]].y;

        if (EPSILON > (((bx-ax)*(cy-ay)) - ((by-ay)*(cx-ax))) ) return false;

        for (p = 0; p < n; p++) {
            if( (p == u) || (p == v) || (p == w) ) continue;
            px = polygonVertices[vertIndices[p]].x
            py = polygonVertices[vertIndices[p]].y
            if (insideTriangle(ax,ay,bx,by,cx,cy,px,py)) return false;
        }

        return true;
    }
}