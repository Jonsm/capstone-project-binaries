 
Shader "SkyShade"
{
    Properties
    {
        _Color ("1st Color", Color) = (1,1,1,1)
        _Color1 ("2st Color", Color) = (0,0,1,1)
        _Pos ("1st color Pos", Range(0, 1)) = 0
        _Pow ("Pow", Float) = 1
    }
 
    SubShader
    {
      Pass
      {
         CGPROGRAM
 
         #pragma vertex vert
         #pragma fragment frag
 
         fixed4 _Color;
         fixed4 _Color1;
         fixed _Pos;
         half _Pow;
 
         struct v2f
         {
            float4 pos : SV_POSITION;
            fixed3 objSPos : TEXCOORD0;
         };
 
         v2f vert(float4 vertexPos : POSITION)
         {
            v2f o;
            o.pos = mul(UNITY_MATRIX_MVP, vertexPos);
            o.objSPos = vertexPos.xyz;
 
            return o;
         }
 
         fixed4 frag(v2f IN) : COLOR
         {
            IN.objSPos = normalize(IN.objSPos);
            fixed ang = dot(fixed3(0.0, 1.0, 0.0), IN.objSPos);
            ang -= _Pos;
            ang = pow(ang, _Pow);
            return lerp(_Color, _Color1, ang);
         }
 
         ENDCG
      }
   }
}

