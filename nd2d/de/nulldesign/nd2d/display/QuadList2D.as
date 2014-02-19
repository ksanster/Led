package de.nulldesign.nd2d.display {

    /**
     * ...
     * @author Mike Almond
     */

    import flash.geom.Vector3D;

    public class QuadList2D extends Node2D {

        static public const EDGE_TOP	:String = "edgeTop"; // 1,2
        static public const EDGE_RIGHT	:String = "edgeRight"; // 2,3
        static public const EDGE_BOTTOM	:String = "edgeBottom"; // 3,4
        static public const EDGE_LEFT	:String = "edgeLeft"; // 4,1

        protected var quadList	:Vector.<Quad2D>;
        protected var index	:int = -1;
        protected var maxQuads	:uint = 0;
        protected var cyclic	:Boolean;

        /**
         * Construct a QuadList (a pool-ish Quad container)
         * @param maxQuads Max Quads the list can hold
         * @param cyclic If true, the list wlil recycle previous quads when the end of the list is reached
         */
        public function QuadList2D(maxQuads:uint=0, cyclic:Boolean=true) {
            super();
            this.maxQuads = maxQuads;
            this.cyclic = cyclic;
            quadList = new Vector.<Quad2D>();
        }

        /**
         * Pre-populate the quad list with identical quads, optionally copied from an <code>origin</code> Quad2D
         * @param startVisible Make the created quad visible immediately
         * @param origin An optinal Quad2D object to make copies from
         */
        public function fillListWithQuads(startVisible:Boolean = false, origin:Quad2D=null):void {
            if (maxQuads == 0) {
                throw new RangeError("maxQuads is zero, set to a positive integer before filling the list.");
            } else {
                var n:int = maxQuads;
                quadList = new Vector.<Quad2D>(n, true);
                while (--n > -1) {
                    quadList[n] = addChild( origin ? origin.copy() : new Quad2D(1, 1)) as Quad2D;
                    quadList[n].visible = startVisible;
                }
                index = -1;
            }
        }

        /**
         * If the list is not full, or is cyclic, this will add the provided Quad2D to the list
         * If the list is full, and not cyclic, a RangeError is thrown
         * @throws RangeError
         * @param quad - The Quad2D to add to the list
         */
        public function addQuad(quad:Quad2D):void {
            if (maxQuads == 0 || quadList.length < maxQuads) {
                index = quadList.length;
                quadList.fixed = false;
                quadList.push(addChild(quad) as Quad2D);
                quadList.fixed = true;
            } else if (cyclic) {
                index++;
                if(index == quadList.length) index = 0;
                quadList[index].copyPropertiesOf(quad); // don't set or create a new quad, just copy properties into next quad
            } else {
                throw new RangeError("Quad list is full, and not cyclic");
            }
        }

        /**
         * Extrude from the last (most recently added or extruded) quad
         * @param vA - Vertex A
         * @param vB - Vertex B
         * @param edge - Face of quad to extrude from, QuadList2D.EDGE_
         * @param isOffset - set false to set absolute vertex positions, defaults to true (offset position values)
         */
        public function extrudeFromLastQuad(vA:Vector3D, vB:Vector3D, edge:String = QuadList2D.EDGE_TOP, isOffset:Boolean = true):void {
            extrudeFromQuadAt(index, vA, vB, edge, isOffset);
        }

        /**
         * Extrude a new Quad2D from the quad at <code>idx</code>
         * @throws RangeError, ReferenceError
         * @param idx - Index of quad to extrude from
         * @param vA - Vertex A
         * @param vB - Vertex B
         * @param edge - Face of quad to extrude from, QuadList2D.EDGE_
         * @param isOffset - set false to set absolute vertex positions, defaults to true (offset position values)
         */
        public function extrudeFromQuadAt(idx:uint, vA:Vector3D, vB:Vector3D, edge:String = QuadList2D.EDGE_TOP, isOffset:Boolean = true):void {

            const sourceQuad:Quad2D = quadList[idx];
            if (!sourceQuad) {
                throw new RangeError("Index out of range, no Quad2D exists at " + idx + "");
                return;
            }

            if (cyclic && (index + 1 == maxQuads)) {
                index = 0;
            } else if (index < quadList.length - 1) {
                index++;
            } else {
                addQuad(sourceQuad.copy() as Quad2D);
            }

            switch(edge) {

                case QuadList2D.EDGE_TOP:
                    quadList[index].setVertexPositions( //v0=v0+, v1=v1+, v2=v1, v3=v0
                            isOffset ? sourceQuad.getVertex(0).add(vA) : vA,
                            isOffset ? sourceQuad.getVertex(1).add(vB) : vB,
                            sourceQuad.getVertex(1),
                            sourceQuad.getVertex(0));
                    break;

                case QuadList2D.EDGE_RIGHT:
                    quadList[index].setVertexPositions( //v0=v1, v1=v1+, v2=v2+, v3=v2
                            sourceQuad.getVertex(1),
                            isOffset ? sourceQuad.getVertex(1).add(vA) : vA,
                            isOffset ? sourceQuad.getVertex(2).add(vB) : vB,
                            sourceQuad.getVertex(2));
                    break;

                case QuadList2D.EDGE_BOTTOM:
                    quadList[index].setVertexPositions( //v0=v3, v1=v2, v2=v2+, v3=v3+
                            sourceQuad.getVertex(3),
                            sourceQuad.getVertex(2),
                            isOffset ? sourceQuad.getVertex(2).add(vA) : vA,
                            isOffset ? sourceQuad.getVertex(3).add(vB) : vB);
                    break;

                case QuadList2D.EDGE_LEFT:
                    quadList[index].setVertexPositions( //v0=v0+, v1=v0, v2=v3, v3=v3+
                            isOffset ? sourceQuad.getVertex(0).add(vB) : vB,
                            sourceQuad.getVertex(0),
                            sourceQuad.getVertex(3),
                            isOffset ? sourceQuad.getVertex(3).add(vA) : vA);
                    break;

                default:
                    throw new ReferenceError("Unexpected edge type '" + edge + "'");
                    return;
            }

            quadList[index].visible = true;
        }


        /**
         * clean up
         */
        override public function dispose():void {
            if (quadList) {
                quadList.fixed = false;
                quadList.length = 0;
                quadList = null;
            }
            super.dispose();
        }
    }
}