package de.nulldesign.nd2d.materials {

    import de.nulldesign.nd2d.geom.Face;
    import de.nulldesign.nd2d.geom.UV;
    import de.nulldesign.nd2d.geom.Vertex;
    import de.nulldesign.nd2d.materials.shader.ShaderCache;
    import de.nulldesign.nd2d.materials.texture.Texture2D;

    import flash.display3D.Context3D;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Context3DVertexBufferFormat;
    import flash.display3D.textures.Texture;
    import flash.geom.ColorTransform;

    /**
     * ...
     * @author Mike Almond - https://github.com/mikedotalmond
     */

    public class Polygon2DTextureMaterial extends APolygon2DMaterial {

        protected static const VERTEX_SHADER:String =
                "m44 op, va0, vc0 \n" + // vertex * clipspace
                        "mov vt0, va1 \n" + // save uv in temp register
                        "mul vt0.xy, vt0.xy, vc4.zw \n" + // mult with uv-scale
                        "add vt0.xy, vt0.xy, vc4.xy \n" + // add uv offset
                        "mov v0, vt0 \n"; // copy uv

        protected static const FRAGMENT_SHADER:String =
                "tex ft0, v0, fs0 <TEXTURE_SAMPLING_OPTIONS>\n" + // sample texture from interpolated uv coords
                        "mul ft0, ft0, fc0\n" + // mult with colorMultiplier
                        "add oc, ft0, fc1\n"; // mult with colorOffset

        protected static const offsetFactor	:Number = 1.0 / 255.0;

        public var texture	:Texture2D;
        public var colorTransform	:ColorTransform = new ColorTransform();

        /**
         * Use this property to animate a texture
         */
        public var uvOffsetX:Number = 0.0;

        /**
         * Use this property to animate a texture
         */
        public var uvOffsetY:Number = 0.0;

        /**
         * Use this property to repeat/scale a texture. Your texture has to be a power of two (256x128, etc)
         */
        public var uvScaleX:Number = 1.0;

        /**
         * Use this property to repeat/scale a texture. Your texture has to be a power of two (256x128, etc)
         */
        public var uvScaleY:Number = 1.0;


        public function Polygon2DTextureMaterial() {
            super();

            uvScaleX = 0.5;
            uvScaleY = 0.5;
            uvOffsetX = -0.5;
            uvOffsetY = -0.5;
        }

        override protected function prepareForRender(context:Context3D):void {

            super.prepareForRender(context);

            var textureObj:Texture = texture.getTexture(context);

            clipSpaceMatrix.identity();
            clipSpaceMatrix.appendTranslation(registrationOffset.x, registrationOffset.y, 0);
            clipSpaceMatrix.append(modelMatrix);
            clipSpaceMatrix.append(viewProjectionMatrix);

            context.setTextureAt(0, textureObj);
            context.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2); // vertex
            context.setVertexBufferAt(1, vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2); // uv

            context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, clipSpaceMatrix, true);

            programConstVector[0] = uvOffsetX;
            programConstVector[1] = uvOffsetY;
            programConstVector[2] = uvScaleX;
            programConstVector[3] = uvScaleY;

            context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, programConstVector);

            programConstVector[0] = colorTransform.redMultiplier;
            programConstVector[1] = colorTransform.greenMultiplier;
            programConstVector[2] = colorTransform.blueMultiplier;
            programConstVector[3] = colorTransform.alphaMultiplier;

            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, programConstVector);

            programConstVector[0] = colorTransform.redOffset * offsetFactor;
            programConstVector[1] = colorTransform.greenOffset * offsetFactor;
            programConstVector[2] = colorTransform.blueOffset * offsetFactor;
            programConstVector[3] = colorTransform.alphaOffset * offsetFactor;

            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, programConstVector);
        }

        override protected function clearAfterRender(context:Context3D):void {
            context.setTextureAt(0, null);
            context.setVertexBufferAt(0, null);
            context.setVertexBufferAt(1, null);
        }

        override protected function addVertex(context:Context3D, buffer:Vector.<Number>, v:Vertex, uv:UV, face:Face):void {
            fillBuffer(buffer, v, uv, face, VERTEX_POSITION, 2);
            fillBuffer(buffer, v, uv, face, VERTEX_UV, 2);
        }

        override protected function initProgram(context:Context3D):void {
            if(!shaderData) {
                shaderData = ShaderCache.getInstance().getShader(context, this, VERTEX_SHADER, FRAGMENT_SHADER, 4, texture.textureOptions);
            }
        }

        public function modifyVertexInBuffer(bufferIdx:uint, x:Number, y:Number):void {

            if(!mVertexBuffer || mVertexBuffer.length == 0) return;
            const idx:uint = bufferIdx * shaderData.numFloatsPerVertex;

            mVertexBuffer[idx] = x;
            mVertexBuffer[int(idx + 1)]	= y;
            needUploadVertexBuffer = true;
        }
    }
}