Shader "Custom/TerrainShader" {
	Properties {
		_SinePeriod ("Sine Period", Float) = 1
		_BeatStrength ("Beat Strength", Float) = 0
		_BeatTime ("Beat Time", Float) = 1
		_BeatPeriod ("Beat Period", Float) = 1
		_Color ("Color", Color) = (1,1,1,1)
		_BeatColor ("Beat Color", Color) = (1,1,1,1)
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
		fixed4 _Color;
		fixed4 _BeatColor;
		float _BeatTime;
		float _BeatPeriod;
		float _BeatStrength;
		float _SinePeriod;
	
		void vert (inout vertexStruct o) {
			float4 worldPos = mul (_Object2World, o.vertex);
			float timeoff = exp(-2 * pow((_Time.y - _BeatTime), 2) / _BeatPeriod);
			float val = _BeatStrength * timeoff * (.5 + .5*sin(distance(_WorldSpaceCameraPos, worldPos) / 5 / _SinePeriod));
			o.color = lerp(_Color, _BeatColor, val);
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = IN.color;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}