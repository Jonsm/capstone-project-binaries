Shader "Custom/Skybox Shader" {
   Properties {
      _Cube ("Environment Map", Cube) = "white" {}
      _colorTop ("colorTop" , Color) = (0,0,0,0) 
      _colorBottom("colorBottom", Color) = (0,0,0,0)
      _skyBoxSize("skyBoxSize", Float) = 10
   }
 
   SubShader {
      Tags { "Queue"="Background"  }
 
      Pass {
         ZWrite Off 
         Cull Off 
 
         CGPROGRAM
         #pragma vertex vert
         #pragma fragment frag
 
         // User-specified uniforms
         samplerCUBE _Cube;
         float4 _colorBottom;
         float4 _colorTop;
         float _skyBoxSize;
 
         struct vertexInput {
            float4 vertex : POSITION;
            float4 col : TEXCOORD0;
         };
 
         struct vertexOutput {
            float4 vertex : SV_POSITION;
            float4 col : TEXCOORD0;
         };
 
        vertexOutput vert(float4 vertexPos : POSITION) 
            // vertex shader 
         {
            vertexOutput output; // we don't need to type 'struct' here
 
            output.vertex =  mul(UNITY_MATRIX_MVP, vertexPos);
            output.col = lerp(_colorTop,_colorBottom,(vertexPos.y + _skyBoxSize/2)/_skyBoxSize);
               // Here the vertex shader writes output data
               // to the output structure. We add 0.5 to the 
               // x, y, and z coordinates, because the 
               // coordinates of the cube are between -0.5 and
               // 0.5 but we need them between 0.0 and 1.0. 
            return output;
         }
 
         fixed4 frag (vertexOutput input) : COLOR
         {
            return input.col;
         }
         ENDCG 
      }
   }
} 	

