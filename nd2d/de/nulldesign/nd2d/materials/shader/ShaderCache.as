package de.nulldesign.nd2d.materials.shader {

    import flash.display3D.Context3D;
    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;

    public class ShaderCache {

        private static var instance:ShaderCache;

        private var cacheObj:Dictionary = new Dictionary(true);

        public function ShaderCache() {
        }

        public static function getInstance():ShaderCache {
            if(!instance) {
                instance = new ShaderCache();
            }
            return instance;
        }

        public function getShader(context:Context3D, materialClass:Object, vertexShaderString:String, fragmentShaderString:String, numFloatsPerVertex:uint, textureOptions:uint, miscOptions:uint = 0):Shader2D {

            var shaderName:String = getQualifiedClassName(materialClass);

            if(!cacheObj[context]) {
                cacheObj[context] = {};
            }

            var currentCacheContainer:Object = cacheObj[context];

            if(currentCacheContainer[shaderName] && currentCacheContainer[shaderName][textureOptions + miscOptions]) {
                return currentCacheContainer[shaderName][textureOptions + miscOptions];
            } else {
                var shader:Shader2D = new Shader2D(context, vertexShaderString, fragmentShaderString, numFloatsPerVertex, textureOptions);

                if(!currentCacheContainer[shaderName]) {
                    currentCacheContainer[shaderName] = {};
                }

                currentCacheContainer[shaderName][textureOptions + miscOptions] = shader;
                return shader;
            }
        }

        public function handleDeviceLoss():void {
            cacheObj = new Dictionary(true);
        }
    }
}