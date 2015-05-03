Shader "Custom/MarchingCubesShader" {
	Properties {
		_Color ("Color", Color) = (1.0,1.0,1.0,1.0)
		_MainTex ("Diffuse Texture", 2D) = "white" {}
		_Bump("Normal Texture", 2D) = "bump"{}
		_BumpDepth("Bump Depth", Range(-3.0,3.0)) = 1
		_SpecColor("Specular Color", Color) = (1.0,1.0,1.0,1.0)
		_Shininess("Shininess",float) = 10
		_RimColor("RimColor",Color) = (1.0,1.0,1.0,1.0)
		_RimPower("Rim Power", Range(0.1,10.0)) = 3.0
	}
	SubShader {
		Pass{
		Tags { "LightMode"="ForwardBase" }
		//LOD 200
		
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _BumpTex;
		uniform float4 _BumpTex_ST;
		uniform sampler2D _BumpDepth;
		uniform float4 _BumpDepth_ST;
		uniform float4 _Color;
		uniform float4 _SpecColor;
		uniform float4 _RimColor;
		uniform float _Shininess;
		uniform float _RimPower;
		
		uniform float4 _LightColor0;
		

		struct vertexInput {
			float4 vertex :POSITION;
			float3 normal : NORMAL;
			float4 texcoord:TEXCOORD0;
			float4 tangent :TANGENT;
			
		};
		
		struct vertexOutput{
			float4 pos : SV_POSITION;
			float4 tex : TEXCOORD0;
			float4 posWorld :TEXCOORD1;
			float3 normalWorld :TEXCOORD2;
			float3 tangentWorld: TEXCOORD3;
			float3 binormalWorld : TEXCOORD4;	
		
		};
		
		vertexOutput vert(vertexInput v){
			vertexOutput o;
			//Gets/normalizes the normal tangent and biNormal
			o.normalWorld = normalize(mul(float4(v.normal,0.0), _World2Object).xyz);
			o.tangentWorld = normalize(mul(_Object2World,v.tangent).xyz);
			o.binormalWorld = normalize(cross(o.normalWorld,o.tangentWorld *v.tangent.w));
			//gets the position and the position in the world
			o.posWorld = mul(_Object2World,v.vertex);
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.tex = v.texcoord;
			
			return o;
		}
		float4 frag(vertexOutput i):COLOR
		{
			
			float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz- i.posWorld.xyz);
			float3 lightDirection;
			float atten;
			
			if(_WorldSpaceLightPos0.w == 0.0){
				atten = 1.0;
				lightDirection = normalize (_WorldSpaceLightPos0.xyz);
			}else{
				float3 fragmentToLightSource = _WorldSpaceLightPos0.xyz-i.posWorld.xyz;
				float distance = length(fragmentToLightSource);
				atten = 1.0/distance;
				lightDirection = normalize(fragmentToLightSource);
			}
			//Texture Maps
			float4 tex = tex2D(_MainTex, i.tex.xy * _MainTex_ST.xy + _MainTex_ST.zw);
			float4 texN = tex2D(_BumpTex, i.tex.xy * _BumpTex_ST.xy + _BumpTex_ST.zw);
			
			//unpack Normal shit
			//float3 localCoords = float3(2.0* texN.ag-float2(1.0,1.0),0.0);
			//localCoords.z = 1.0-.5 * dot(localCoords,localCoords);
			
			//normal transpose Metrics
			//float3x3 local2Worldtranspose = float3x3(i.tangentWorld, i.binormalWorld,i.normalWorld);
			
			//Calculate normal direction
			//float3 normalDirection = normalize(mul(localCoords,local2Worldtranspose));
			 
			//Edit the color based on the normal direction
			float4 col = {0.0,0.0,0.0,1.0};
			col.y = i.normalWorld.y;
			
			float3 diffuseReflection = atten * _LightColor0.xyz * saturate(dot(i.normalWorld,lightDirection));
			//float3 specularReflection = diffuseReflection *_SpecColor.xyz *pow(saturate(dot(reflect(-lightDirection,i.normalWorld),viewDirection)),_Shininess);
			float3 lightFinal = UNITY_LIGHTMODEL_AMBIENT.xyz + diffuseReflection;
			
			//float3 diffuseReflection = atten * _LightColor0.xyz * saturate(dot(normalDirection,lightDirection));
			//float3 specularReflection = diffuseReflection *_SpecColor.xyz *pow(saturate(dot(reflect(-lightDirection,normalDirection),viewDirection)),_Shininess);
			//float3 lightFinal = UNITY_LIGHTMODEL_AMBIENT.xyz + diffuseReflection+specularReflection;
			return float4(tex.xyz * lightFinal * col.xyz,1.0);
		}
					
		ENDCG
		}	
	}
	
}

