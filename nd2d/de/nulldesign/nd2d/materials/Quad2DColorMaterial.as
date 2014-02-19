package de.nulldesign.nd2d.materials {

    import de.nulldesign.nd2d.geom.Face;
    import de.nulldesign.nd2d.geom.UV;
    import de.nulldesign.nd2d.geom.Vertex;
    import de.nulldesign.nd2d.materials.shader.ShaderCache;
    import de.nulldesign.nd2d.utils.ColorUtil;
    import flash.geom.Vector3D;

    import flash.display3D.Context3D;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Context3DVertexBufferFormat;

    public class Quad2DColorMaterial extends AMaterial {

        private const VERTEX_SHADER:String =
                "m44 op, va0, vc0 \n" + // vertex * clipspace
                        "mov v0, va1 \n"; // copy color

        private const FRAGMENT_SHADER:String =
                "mov oc, v0 \n"; // mult with colorOffset

        private const FRAGMENT_SHADER_NO_TINT_ALPHA:String = "tex oc, v0, fs0 <TEXTURE_SAMPLING_OPTIONS>\n";

        public function Quad2DColorMaterial() {
            drawCalls = 1;
        }

        override protected function prepareForRender(context:Context3D):void {
            super.prepareForRender(context);

            clipSpaceMatrix.identity();
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
                shaderData = ShaderCache.getInstance().getShader(context, this, VERTEX_SHADER, FRAGMENT_SHADER, 6,0, 1000);// texture.textureOptions, nodeTinted ? 0 : 1000);
            }
        }

        public function modifyColorInBuffer(bufferIdx:uint, r:Number, g:Number, b:Number, a:Number):void {

            if(!mVertexBuffer || mVertexBuffer.length == 0) return;
            const idx:uint = bufferIdx * shaderData.numFloatsPerVertex;

            mVertexBuffer[idx + 2] = r;
            mVertexBuffer[idx + 3] = g;
            mVertexBuffer[idx + 4] = b;
            mVertexBuffer[idx + 5] = a;

            needUploadVertexBuffer = true;
        }

        /**
         * Update vertex positions in the mVertexBuffer
         * @param v1
         * @param v2
         * @param v3
         * @param v4
         */
        public function setVertexPositions(v1:Vector3D, v2:Vector3D, v3:Vector3D, v4:Vector3D):void {

            if (!mVertexBuffer || mVertexBuffer.length == 0) return;

            const idx	:uint = shaderData.numFloatsPerVertex;
            const idx2	:uint = idx << 1;

            mVertexBuffer[0]	= v1.x;
            mVertexBuffer[1]	= v1.y;

            mVertexBuffer[idx]	= v2.x;
            mVertexBuffer[uint(idx + 1)]	= v2.y;

            mVertexBuffer[idx2]	= v3.x;
            mVertexBuffer[uint(idx2 + 1)]	= v3.y;

            mVertexBuffer[uint(idx2 + idx)]	= v4.x;
            mVertexBuffer[uint(idx2 + idx + 1)]	= v4.y;

            needUploadVertexBuffer = true;
        }
    }
}