package de.nulldesign.nd2d.display {

    /**
     * ...
     * @author Mike Almond - https://github.com/mikedotalmond
     */

    import flash.geom.Point;
    import flash.geom.Vector3D;

    public class QuadLine2D extends QuadList2D {

        private const LastPosTemp	:Point = new Point();
        private const PosTemp	:Point = new Point();

        private const V0_temp	:Vector3D = new Vector3D();
        private const V1_temp	:Vector3D = new Vector3D();
        private const V2_temp	:Vector3D = new Vector3D();
        private const V3_temp	:Vector3D = new Vector3D();
        private const HalfPi	:Number = Math.PI / 2;

        protected var lineX	:Number = 0;
        protected var lineY	:Number = 0;
        protected var drawnSinceMove	:Boolean = false;

        protected var thickness	:Number = 1;
        protected var endThickScale	:Number = 1;

        protected var lineColor	:uint = 0x000000;
        protected var lineAlpha	:Number = 1;
        protected var endColor	:uint = NaN;
        protected var endAlpha	:Number = NaN;
        protected var horizontalGradient:Boolean = false;

        public function QuadLine2D(maxQuads:uint=512) {
            super(maxQuads, false);
            fillListWithQuads();
            index = 0;
        }

        public function clear():void {
            index = 0;
            var n:int = quadList.length;
            while (--n > -1) quadList[n].visible = false;
        }

        public function lineStyle(thickness:Number = 1, color:uint = 0x000000, alpha:Number = 1, endThickScale:Number=1, endColor:uint=NaN, endAlpha:Number=NaN, horizontalGradient:Boolean=false):void {
            this.thickness = thickness;
            this.endThickScale	= endThickScale;
            this.lineColor = color;
            this.lineAlpha = alpha;
            this.endColor = endColor;
            this.endAlpha = endAlpha;
            this.horizontalGradient = horizontalGradient;
        }

        /**
         * Position the 'pen' for drawing
         * @param x
         * @param y
         */
        public function moveTo(x:Number, y:Number):void {
            drawnSinceMove = false;
            LastPosTemp.setTo(lineX = x, lineY = y);
        }

        /**
         *
         * @param px
         * @param py
         */
        public function lineTo(px:Number, py:Number):void {

            const theta	:Number = Math.atan2(py - lineY, px - lineX) + Math.PI / 2;
            const sinThetaThick	:Number = (Math.sin(theta) * thickness) / 2.0;
            const cosThetaThick	:Number = (Math.cos(theta) * thickness) / 2.0;

            V2_temp.x = px + cosThetaThick * endThickScale;
            V2_temp.y = py + sinThetaThick * endThickScale;
            V3_temp.x = px - cosThetaThick * endThickScale;
            V3_temp.y = py - sinThetaThick * endThickScale;

            if (drawnSinceMove) {
                const prevQuad:Quad2D = quadList[int(index == 0 ? quadList[quadList.length - 1] : index - 1)];
                quadList[index].setVertexPositions(prevQuad.getVertex(3), prevQuad.getVertex(2), V2_temp, V3_temp);
            } else {
// start edge
                V0_temp.x = lineX - cosThetaThick;
                V0_temp.y = lineY - sinThetaThick;
                V1_temp.x = lineX + cosThetaThick;
                V1_temp.y = lineY + sinThetaThick;
                quadList[index].setVertexPositions(V0_temp, V1_temp, V2_temp, V3_temp);
            }

            if(!isNaN(endColor) && !isNaN(endAlpha)) quadList[index].linearGradient(lineColor, endColor, lineAlpha, endAlpha, horizontalGradient);
            else quadList[index].flatColor(lineColor, lineAlpha);

            drawnSinceMove = true;

//
            if (++index == quadList.length) {
                index = 0;
//trace("::lineTo - QuadList exhausted. The last quad will be recycled until clear()ed");
            }

            lineX = px;
            lineY = py;
        }

        /**
         * funciton signature based on the Graphics::cubicCurveTo API
         * (but don't expect it to draw like-for-like curves when compared to Graphics::cubicCurveTo)
         * @param controlX1
         * @param controlY1
         * @param controlX2
         * @param controlY2
         * @param anchorX
         * @param anchorY
         * @param segments - number of segments to split the curve into for drawing... adjust depending on the length/scale of your curve.
         */
        public function cubicCurveTo(controlX1:Number, controlY1:Number, controlX2:Number, controlY2:Number, anchorX:Number, anchorY:Number, segments:uint = 64):void {
            drawBezierSegment(new BezierSegment(lineX, lineY, controlX1, controlY1, controlX2, controlY2, anchorX, anchorY), segments);
        }

        /**
         *
         * @param bez
         * @param subdivisions
         */
        private function drawBezierSegment(bez:BezierSegment, subdivisions:uint = 64):void {
            const inc	:Number = 1.0 / subdivisions;
            const lastPos	:Point = LastPosTemp;
            const pos	:Point = PosTemp;

            var theta	:Number;
            var sinThetaThick	:Number;
            var cosThetaThick	:Number;
            var prevQuad	:Quad2D;
            var quad	:Quad2D = quadList[index];
            var firstPass	:Boolean = !drawnSinceMove;
            var i	:int = 0;
            while (++i < subdivisions + 1) {
                bez.interpolateTo(i * inc, pos);
                theta = Math.atan2(pos.y - lastPos.y, pos.x - lastPos.x) + HalfPi;
                sinThetaThick = (Math.sin(theta) * thickness) / 2.0;
                cosThetaThick = (Math.cos(theta) * thickness) / 2.0;
                lastPos.setTo(pos.x, pos.y);

// end
                V2_temp.x = pos.x + cosThetaThick;
                V2_temp.y = pos.y + sinThetaThick;
                V3_temp.x = pos.x - cosThetaThick;
                V3_temp.y = pos.y - sinThetaThick;

                quad = quadList[index];
                if (firstPass) { // start
                    firstPass = false;
                    quad.setVertexPositions(V3_temp, V2_temp, V2_temp, V3_temp);
                } else {
                    prevQuad = quadList[int(index == 0 ? quadList[quadList.length - 1] : index - 1)];
                    quad.setVertexPositions(prevQuad.getVertex(3), prevQuad.getVertex(2), V2_temp, V3_temp);

                    if(!isNaN(endColor) && !isNaN(endAlpha)) quadList[index].linearGradient(lineColor, endColor, lineAlpha, endAlpha, horizontalGradient);
                    else quadList[index].flatColor(lineColor, lineAlpha);
                }

                if (++index == quadList.length) {
                    index--;
                    trace("::cubicCurveTo - QuadList exhausted. Last quad will be recycled until clear()ed");
                }
            }

            lineX = bez.anchorX;
            lineY = bez.anchorY;
            LastPosTemp.setTo(bez.anchorX, bez.anchorY);
            drawnSinceMove = true;
        }

        /**
         *
         * @param points
         * @param subdivisionsPerSegment
         */
        public function curveThroughPoints(points:Vector.<Point>, subdivisionsPerSegment:uint = 64):void {
            const s	:Vector.<BezierSegment> = BezierSpline.build(points);
            const n	:int = s.length;
            var i	:int = -1;
            while (++i < n) drawBezierSegment(s[i], subdivisionsPerSegment)
        }
    }
}


import flash.geom.Point;

internal class BezierSegment {

    public var startX	:Number;
    public var startY	:Number;
    public var controlX1:Number;
    public var controlY1:Number;
    public var controlX2:Number;
    public var controlY2:Number;
    public var anchorX	:Number;
    public var anchorY	:Number;

    /**
     * Helper for getting values at positions along the defined bezier curve segment
     * @param startX
     * @param startY
     * @param controlX1
     * @param controlY1
     * @param controlX2
     * @param controlY2
     * @param anchorX
     * @param anchorY
     */
    public function BezierSegment(startX:Number=0, startY:Number=0, controlX1:Number=0, controlY1:Number=0, controlX2:Number=0, controlY2:Number=0, anchorX:Number=0, anchorY:Number=0){
        this.startX = startX; //a
        this.startY	= startY;
        this.controlX1	= controlX1; //b
        this.controlY1	= controlY1;
        this.controlX2	= controlX2; //c
        this.controlY2	= controlY2;
        this.anchorX	= anchorX; //d
        this.anchorY	= anchorY;
    }

    /**
     *
     * @param percent
     * @param dest
     */
    public function interpolateTo(percent:Number, dest:Point):void {
        const oneMinusPercent	:Number = 1.0 - percent;
        const aX	:Number = startX;
        const aY	:Number = startY;
        dest.x = ((((percent * percent) * (anchorX - aX)) + ((3 * oneMinusPercent) * ((percent * (controlX2 - aX)) + (oneMinusPercent * (controlX1 - aX))))) * percent) + aX;
        dest.y = ((((percent * percent) * (anchorY - aY)) + ((3 * oneMinusPercent) * ((percent * (controlY2 - aY)) + (oneMinusPercent * (controlY1 - aY))))) * percent) + aY;
    }
}

/**
 * Draw a Smooth Curve through a Set of 2D Points with Bezier Primitives
 * --
 * Calculate piecewise Bezier curve control points to make it a spline
 * http://www.codeproject.com/Articles/31859/Draw-a-Smooth-Curve-through-a-Set-of-2D-Points-wit
 */

import flash.geom.Point;

internal class BezierSpline {

    public static function build(knots:Vector.<Point>):Vector.<BezierSegment> {

        knots.fixed = true;

        var i	:int;
        const n	:int = knots.length - 1;

        if (n < 2) { // need more than 2 points for a curve...
            return null;
        }

// Calculate first Bezier control points
// Right hand side vector
        const rhs:Vector.<Number> = new Vector.<Number>(n, true);


// X
// Set right hand side x values
        for (i = 1; i < n - 1; ++i)	rhs[i]	= 4 * knots[i].x + 2 * knots[int(i + 1)].x;
        rhs[0] = knots[0].x + 2 * knots[1].x;
        rhs[int(n - 1)]	= (8 * knots[int(n - 1)].x + knots[n].x) / 2.0;

// Get first control points x-values
        const x:Vector.<Number> = getFirstControlPoints(rhs);


// Y
// Set right hand side y values
        for (i = 1; i < n - 1; ++i)	rhs[i]	= 4 * knots[i].y + 2 * knots[int(i + 1)].y;

        rhs[0] = knots[0].y + 2 * knots[1].y;
        rhs[int(n - 1)] = (8 * knots[int(n - 1)].y + knots[n].y) / 2.0;

// Get first control points y-values
        const y:Vector.<Number> = getFirstControlPoints(rhs);


// Fill output
        var spline	:Vector.<BezierSegment> = new Vector.<BezierSegment>(n, true);
        var k1	:Point;
        i = -1;
        while (++i < n) {
            k1 = knots[int(i + 1)];
            spline[i] = new BezierSegment(knots[i].x, knots[i].y, x[i], y[i], 0, 0, k1.x, k1.y);

// Second control point
            if (i < n - 1) {
                spline[i].controlX2 = 2 * k1.x - x[int(i + 1)];
                spline[i].controlY2	= 2 * k1.y - y[int(i + 1)];
            } else {
                spline[i].controlX2 = (knots[n].x + x[int(n - 1)]) / 2;
                spline[i].controlY2 = (knots[n].y + y[int(n - 1)]) / 2;
            }
        }

        return spline;
    }

    private static function getFirstControlPoints(rhs:Vector.<Number>):Vector.<Number> {

        const n	:int = rhs.length;
        const out	:Vector.<Number> = new Vector.<Number>(n, true);
        const tmp	:Vector.<Number> = new Vector.<Number>(n, true);
        var b	:Number = 2.0;
        var i	:int;

        i = 0;
        out[0] = rhs[0] / b;

        while (++i < n) { // Decomposition and forward substitution.
            tmp[i] = 1.0 / b;
            b = (i < n - 1 ? 4.0 : 3.5) - tmp[i];
            out[i] = (rhs[i] - out[int(i - 1)]) / b;
        }

        i = 0;
        while (++i < n) { // Backsubstitution.
            out[int(n - i - 1)] -= tmp[n - i] * out[int(n - i)];
        }

        return out;
    }
}

