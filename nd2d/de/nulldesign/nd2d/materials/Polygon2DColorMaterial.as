package de.nulldesign.nd2d.materials {

    import de.nulldesign.nd2d.geom.Face;
    import de.nulldesign.nd2d.geom.UV;
    import de.nulldesign.nd2d.geom.Vertex;
    import de.nulldesign.nd2d.materials.shader.ShaderCache;

    import flash.display3D.Context3D;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Context3DVertexBufferFormat;
    import flash.geom.Vector3D;

    /**
     * ...
     * @author Mike Almond - https://github.com/mikedotalmond
     */

    public class Polygon2DColorMaterial extends APolygon2DMaterial {

        private const VERTEX_SHADER:String =
                "m44 op, va0, vc0 \n" + // vertex * clipspace
                        "mov v0, va1 \n"; // copy color

        private const FRAGMENT_SHADER:String =
                "mov oc, v0 \n"; // mult with colorOffset

        protected var _colour:uint = 0;

        public function Polygon2DColorMaterial(colour:uint) {
            super();
            this.color = colour;
        }

        override protected function generateBufferData(context:Context3D, faceList:Vector.<Face>):void {
            const isInit:Boolean = mVertexBuffer == null;
            super.generateBufferData(context, faceList);
            if (isInit) color = _colour;
        }

        override protected function prepareForRender(context:Context3D):void {
            super.prepareForRender(context);

            clipSpaceMatrix.identity();
            clipSpaceMatrix.appendTranslation(registrationOffset.x, registrationOffset.y, 0);
            clipSpaceMatrix.append(modelMatrix);
            clipSpaceMatrix.append(viewProjectionMatrix);

            context.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2); // vertex
            context.setVertexBufferAt(1, vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_4); // color
            context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, clipSpaceMatrix, true);
        }

        override protected function clearAfterRender(context:Context3D):void {
            context.setVertexBufferAt(0, null);
            context.setVertexBufferAt(1, null);
        }

        override protected function addVertex(context:Context3D, buffer:Vector.<Number>, v:Vertex, uv:UV, face:Face):void {
            fillBuffer(buffer, v, uv, face, VERTEX_POSITION, 2);
            fillBuffer(buffer, v, uv, face, VERTEX_COLOR, 4);
        }

        override protected function initProgram(context:Context3D):void {
            if(!shaderData) {
                shaderData = ShaderCache.getInstance().getShader(context, this, VERTEX_SHADER, FRAGMENT_SHADER, 6, 0);
            }
        }

        public function modifyColorInBuffer(bufferIdx:uint, r:Number, g:Number, b:Number, a:Number):void {

            if(!mVertexBuffer || mVertexBuffer.length == 0) return;
            const idx:uint = bufferIdx * shaderData.numFloatsPerVertex;
            if (idx + 5 >= mVertexBuffer.length) return;

            mVertexBuffer[idx + 2] = r;
            mVertexBuffer[idx + 3] = g;
            mVertexBuffer[idx + 4] = b;
            mVertexBuffer[idx + 5] = a;

            needUploadVertexBuffer = true;
        }

        /**
         * Update vertex positions in the mVertexBuffer
         * @param v
         */
        public function setVertexPositions(v:Vector.<Vector3D>):void {

            if (!mVertexBuffer || mVertexBuffer.length == 0) return;

            const fpv:uint = shaderData.numFloatsPerVertex;

            var i	:int = -1;
            const n	:int = v.length;
            while (++i < n) {
                mVertexBuffer[i * fpv]	= v[i].x;
                mVertexBuffer[i * fpv + 1]	= v[i].y;
            }

            needUploadVertexBuffer = true;
        }

        /**
         * set/get argb colour value
         */
        public function get color():uint { return _colour; }
        public function set color(value:uint):void {
            _colour = value;

            const a	:Number = uint((value & 0xff000000) >>> 24) / 0xff;
            const r	:Number = uint((value & 0xff0000) >>> 16) / 0xff;
            const g	:Number = uint((value & 0xff00) >>> 8) / 0xff;
            const b	:Number = uint(value & 0xff) / 0xff;

            const n	:uint = indexCount;
            var i	:int = -1;
            while (++i < n) {
                modifyColorInBuffer(i, r, g, b, a);
            }
        }

        public function randomiseVertexColors():void {
            const n	:uint = indexCount;
            var i	:int = -1;
            while (++i < n) {
                modifyColorInBuffer(i, Math.random(), Math.random(), Math.random(), 1.0);
            }
        }
    }
}