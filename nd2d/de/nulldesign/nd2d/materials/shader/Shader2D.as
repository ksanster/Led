package de.nulldesign.nd2d.materials.shader {

    import com.adobe.utils.AGALMiniAssembler;

    import de.nulldesign.nd2d.materials.texture.TextureOption;

    import flash.display3D.Context3D;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Program3D;

    public class Shader2D {

        public var shader:Program3D;
        public var numFloatsPerVertex:int;

        public function Shader2D(context:Context3D, vertexShaderString:String, fragmentShaderString:String, numFloatsPerVertex:uint, textureOptions:uint) {

            var texOptions:Array = ["2d"];
            var optionMissing:Boolean = false;

            if(textureOptions & TextureOption.MIPMAP_DISABLE) {
                texOptions.push("mipnone");
            } else if(textureOptions & TextureOption.MIPMAP_NEAREST) {
                texOptions.push("mipnearest");
            } else if(textureOptions & TextureOption.MIPMAP_LINEAR) {
                texOptions.push("miplinear");
            } else {
                optionMissing = true;
            }

            if(textureOptions & TextureOption.FILTERING_LINEAR) {
                texOptions.push("linear");
            } else if(textureOptions & TextureOption.FILTERING_NEAREST) {
                texOptions.push("nearest");
            } else {
                optionMissing = true;
            }

            if(textureOptions & TextureOption.REPEAT_CLAMP) {
                texOptions.push("clamp");
            } else if(textureOptions & TextureOption.REPEAT_NORMAL) {
                texOptions.push("repeat");
            } else {
                optionMissing = true;
            }

            if(optionMissing && textureOptions > 0) {
                throw new Error("you need to specify all three texture option components. for example: myOption = MIPMAP_NEAREST | FILTERING_NEAREST | REPEAT_NORMAL;");
            }

            var pattern:RegExp = /TEXTURE_SAMPLING_OPTIONS/g;
            var finalFragmentShader:String = fragmentShaderString.replace(pattern, texOptions.join(","));

            var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
            vertexShaderAssembler.assemble(Context3DProgramType.VERTEX, vertexShaderString);

            var colorFragmentShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
            colorFragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT, finalFragmentShader);

            shader = context.createProgram();
            shader.upload(vertexShaderAssembler.agalcode, colorFragmentShaderAssembler.agalcode);
            this.numFloatsPerVertex = numFloatsPerVertex;
        }
    }
}