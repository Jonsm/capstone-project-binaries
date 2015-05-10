Shader "Custom/buildingshader" {
	Properties {
		_RColor1 ("Color", Color) = (1,0,0,1)
		_RColor2 ("Color", Color) = (0,1,0,1)
		_RColor3 ("Color", Color) = (0,0,1,1)
		_RainbowPeriod ("Rainbow Period", Float) = 1
		_RainbowBrightness ("Rainbow Brightness", Float) = 1
		_VOffset ("Vertical offset", Float) = 1
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma vertex vert
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float4 color : COLOR;
		};

		struct vertexStruct {
			float4 vertex : SV_POSITION;
			float3 normal : NORMAL;
			float4 texcoord : TEXCOORD0;
			float4 color : COLOR;
		};

		half _Glossiness;
		half _Metallic;
		half _VOffset;
		fixed4 _Color;
		half _RainbowPeriod;
		half _RainbowBrightness;
		
		float4 _RColor1;
		float4 _RColor2;
		float4 _RColor3;

		void vert (inout vertexStruct v) {
			//rainbow effect
			float x = v.vertex.y / _RainbowPeriod + _VOffset;
			float r = clamp(cos(x), 0, 1) + clamp(-1 * sin(x), 0, 1);
			float g = clamp(sin(x), 0, 1);
			float b = clamp(-1 * cos(x), 0, 1);
			v.color = r * _RainbowBrightness * _RColor1 +
					  g * _RainbowBrightness * _RColor2 +
					  b * _RainbowBrightness * _RColor3;
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			//fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = (IN.uv_MainTex.x) * (IN.color).xyz;
			o.Metallic = IN.uv_MainTex.y;
			o.Smoothness = _Glossiness;
			o.Alpha = 1;
		}
		ENDCG
	}
	FallBack "Diffuse"
}