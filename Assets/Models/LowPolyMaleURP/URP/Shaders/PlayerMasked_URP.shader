// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Jims/URP/PlayerMasked"
{
	Properties
	{
		_Smoothness("_Smoothness", Range( 0 , 1)) = 0.2
		_ColourHair("_ColourHair", Color) = (0.1981132,0.1777026,0.1579299,1)
		_ColourHair2("_ColourHair2", Color) = (0.4433962,0.4011861,0.366011,1)
		_ColourSkin("_ColourSkin", Color) = (0.9568628,0.8313726,0.7098039,1)
		_ColourEyes("_ColourEyes", Color) = (0,0,0,1)
		_ColourMouth("_ColourMouth", Color) = (0.7735849,0.6679381,0.5655928,1)
		_ColourFaceHair("_ColourFaceHair", Color) = (0.1981132,0.1777026,0.1579299,1)
		_ColourUnderwearT("_ColourUnderwearT", Color) = (1,1,1,1)
		_ColourUnderwearB("_ColourUnderwearB", Color) = (0.1509434,0.1509434,0.1509434,1)
		[HideInInspector]_MaskHair("_MaskHair", 2D) = "white" {}
		[HideInInspector]_MaskHair2("_MaskHair2", 2D) = "white" {}
		[HideInInspector]_MaskSkin("_MaskSkin", 2D) = "white" {}
		[HideInInspector]_MaskEyes("_MaskEyes", 2D) = "white" {}
		[HideInInspector]_MaskMouth("_MaskMouth", 2D) = "white" {}
		[HideInInspector]_MaskFaceHair("_MaskFaceHair", 2D) = "white" {}
		[HideInInspector]_MaskUnderwearT("_MaskUnderwearT", 2D) = "white" {}
		[HideInInspector]_MaskUnderwearB("_MaskUnderwearB", 2D) = "white" {}
		[HideInInspector]_Texture("Texture", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		
		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" "Queue"="Geometry" }
		
		Cull Back
		HLSLINCLUDE
		#pragma target 3.0
		ENDHLSL

		
		Pass
		{
			Name "Forward"
			Tags { "LightMode"="UniversalForward" }
			
			Blend One Zero , One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define ASE_SRP_VERSION 999999

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile _ _SHADOWS_SOFT
			#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
			
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON

			#pragma vertex vert
			#pragma fragment frag


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			
			

			sampler2D _Texture;
			sampler2D _MaskHair;
			sampler2D _MaskHair2;
			sampler2D _MaskSkin;
			sampler2D _MaskEyes;
			sampler2D _MaskMouth;
			sampler2D _MaskFaceHair;
			sampler2D _MaskUnderwearT;
			sampler2D _MaskUnderwearB;
			CBUFFER_START( UnityPerMaterial )
			float4 _Texture_ST;
			float4 _ColourHair;
			float4 _MaskHair_ST;
			float4 _ColourHair2;
			float4 _MaskHair2_ST;
			float4 _ColourSkin;
			float4 _MaskSkin_ST;
			float4 _ColourEyes;
			float4 _MaskEyes_ST;
			float4 _ColourMouth;
			float4 _MaskMouth_ST;
			float4 _ColourFaceHair;
			float4 _MaskFaceHair_ST;
			float4 _ColourUnderwearT;
			float4 _MaskUnderwearT_ST;
			float4 _ColourUnderwearB;
			float4 _MaskUnderwearB_ST;
			float _Smoothness;
			CBUFFER_END


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord1 : TEXCOORD1;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 lightmapUVOrVertexSH : TEXCOORD0;
				half4 fogFactorAndVertexLight : TEXCOORD1;
				float4 shadowCoord : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				float4 ase_texcoord7 : TEXCOORD7;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			
			VertexOutput vert ( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				o.ase_texcoord7.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord7.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.ase_normal = v.ase_normal;

				float3 lwWNormal = TransformObjectToWorldNormal(v.ase_normal);
				float3 lwWorldPos = TransformObjectToWorld(v.vertex.xyz);
				float3 lwWTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				float3 lwWBinormal = normalize(cross(lwWNormal, lwWTangent) * v.ase_tangent.w);
				o.tSpace0 = float4(lwWTangent.x, lwWBinormal.x, lwWNormal.x, lwWorldPos.x);
				o.tSpace1 = float4(lwWTangent.y, lwWBinormal.y, lwWNormal.y, lwWorldPos.y);
				o.tSpace2 = float4(lwWTangent.z, lwWBinormal.z, lwWNormal.z, lwWorldPos.z);

				VertexPositionInputs vertexInput = GetVertexPositionInputs(v.vertex.xyz);
				
				OUTPUT_LIGHTMAP_UV( v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy );
				OUTPUT_SH(lwWNormal, o.lightmapUVOrVertexSH.xyz );

				half3 vertexLight = VertexLighting(vertexInput.positionWS, lwWNormal);
				#ifdef ASE_FOG
					half fogFactor = ComputeFogFactor( vertexInput.positionCS.z );
				#else
					half fogFactor = 0;
				#endif
				o.fogFactorAndVertexLight = half4(fogFactor, vertexLight);
				o.clipPos = vertexInput.positionCS;

				#ifdef _MAIN_LIGHT_SHADOWS
					o.shadowCoord = GetShadowCoord(vertexInput);
				#endif
				return o;
			}

			half4 frag ( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				float3 WorldSpaceNormal = normalize(float3(IN.tSpace0.z,IN.tSpace1.z,IN.tSpace2.z));
				float3 WorldSpaceTangent = float3(IN.tSpace0.x,IN.tSpace1.x,IN.tSpace2.x);
				float3 WorldSpaceBiTangent = float3(IN.tSpace0.y,IN.tSpace1.y,IN.tSpace2.y);
				float3 WorldSpacePosition = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 WorldSpaceViewDirection = _WorldSpaceCameraPos.xyz  - WorldSpacePosition;
	
				#if SHADER_HINT_NICE_QUALITY
					WorldSpaceViewDirection = SafeNormalize( WorldSpaceViewDirection );
				#endif

				float2 uv_Texture = IN.ase_texcoord7.xy * _Texture_ST.xy + _Texture_ST.zw;
				float2 uv_MaskHair = IN.ase_texcoord7.xy * _MaskHair_ST.xy + _MaskHair_ST.zw;
				float temp_output_25_0_g4 = 0.5;
				float temp_output_22_0_g4 = step( tex2D( _MaskHair, uv_MaskHair, float2( 0,0 ), float2( 0,0 ) ).r , temp_output_25_0_g4 );
				float4 lerpResult20 = lerp( tex2D( _Texture, uv_Texture, float2( 0,0 ), float2( 0,0 ) ) , _ColourHair , temp_output_22_0_g4);
				float2 uv_MaskHair2 = IN.ase_texcoord7.xy * _MaskHair2_ST.xy + _MaskHair2_ST.zw;
				float temp_output_25_0_g33 = 0.5;
				float temp_output_22_0_g33 = step( tex2D( _MaskHair2, uv_MaskHair2, float2( 0,0 ), float2( 0,0 ) ).r , temp_output_25_0_g33 );
				float4 lerpResult113 = lerp( lerpResult20 , _ColourHair2 , temp_output_22_0_g33);
				float2 uv_MaskSkin = IN.ase_texcoord7.xy * _MaskSkin_ST.xy + _MaskSkin_ST.zw;
				float temp_output_25_0_g34 = 0.5;
				float temp_output_22_0_g34 = step( tex2D( _MaskSkin, uv_MaskSkin, float2( 0,0 ), float2( 0,0 ) ).r , temp_output_25_0_g34 );
				float4 lerpResult117 = lerp( lerpResult113 , _ColourSkin , temp_output_22_0_g34);
				float2 uv_MaskEyes = IN.ase_texcoord7.xy * _MaskEyes_ST.xy + _MaskEyes_ST.zw;
				float temp_output_25_0_g35 = 0.5;
				float temp_output_22_0_g35 = step( tex2D( _MaskEyes, uv_MaskEyes, float2( 0,0 ), float2( 0,0 ) ).r , temp_output_25_0_g35 );
				float4 lerpResult121 = lerp( lerpResult117 , _ColourEyes , temp_output_22_0_g35);
				float2 uv_MaskMouth = IN.ase_texcoord7.xy * _MaskMouth_ST.xy + _MaskMouth_ST.zw;
				float temp_output_25_0_g37 = 0.5;
				float temp_output_22_0_g37 = step( tex2D( _MaskMouth, uv_MaskMouth, float2( 0,0 ), float2( 0,0 ) ).r , temp_output_25_0_g37 );
				float4 lerpResult129 = lerp( lerpResult121 , _ColourMouth , temp_output_22_0_g37);
				float2 uv_MaskFaceHair = IN.ase_texcoord7.xy * _MaskFaceHair_ST.xy + _MaskFaceHair_ST.zw;
				float temp_output_25_0_g38 = 0.5;
				float temp_output_22_0_g38 = step( tex2D( _MaskFaceHair, uv_MaskFaceHair, float2( 0,0 ), float2( 0,0 ) ).r , temp_output_25_0_g38 );
				float4 lerpResult125 = lerp( lerpResult129 , _ColourFaceHair , temp_output_22_0_g38);
				float2 uv_MaskUnderwearT = IN.ase_texcoord7.xy * _MaskUnderwearT_ST.xy + _MaskUnderwearT_ST.zw;
				float temp_output_25_0_g39 = 0.5;
				float temp_output_22_0_g39 = step( tex2D( _MaskUnderwearT, uv_MaskUnderwearT, float2( 0,0 ), float2( 0,0 ) ).r , temp_output_25_0_g39 );
				float4 lerpResult133 = lerp( lerpResult125 , _ColourUnderwearT , temp_output_22_0_g39);
				float2 uv_MaskUnderwearB = IN.ase_texcoord7.xy * _MaskUnderwearB_ST.xy + _MaskUnderwearB_ST.zw;
				float temp_output_25_0_g40 = 0.5;
				float temp_output_22_0_g40 = step( tex2D( _MaskUnderwearB, uv_MaskUnderwearB, float2( 0,0 ), float2( 0,0 ) ).r , temp_output_25_0_g40 );
				float4 lerpResult137 = lerp( lerpResult133 , _ColourUnderwearB , temp_output_22_0_g40);
				
				float3 Albedo = lerpResult137.rgb;
				float3 Normal = float3(0, 0, 1);
				float3 Emission = 0;
				float3 Specular = 0.5;
				float Metallic = _Smoothness;
				float Smoothness = _Smoothness;
				float Occlusion = 1;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;
				float3 BakedGI = 0;

				InputData inputData;
				inputData.positionWS = WorldSpacePosition;

				#ifdef _NORMALMAP
					inputData.normalWS = normalize(TransformTangentToWorld(Normal, half3x3(WorldSpaceTangent, WorldSpaceBiTangent, WorldSpaceNormal)));
				#else
					#if !SHADER_HINT_NICE_QUALITY
						inputData.normalWS = WorldSpaceNormal;
					#else
						inputData.normalWS = normalize(WorldSpaceNormal);
					#endif
				#endif

				inputData.viewDirectionWS = WorldSpaceViewDirection;
				inputData.shadowCoord = IN.shadowCoord;

				#ifdef ASE_FOG
					inputData.fogCoord = IN.fogFactorAndVertexLight.x;
				#endif

				inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;
				inputData.bakedGI = SAMPLE_GI( IN.lightmapUVOrVertexSH.xy, IN.lightmapUVOrVertexSH.xyz, inputData.normalWS );
				#ifdef _ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#endif
				half4 color = UniversalFragmentPBR(
					inputData, 
					Albedo, 
					Metallic, 
					Specular, 
					Smoothness, 
					Occlusion, 
					Emission, 
					Alpha);

				#ifdef ASE_FOG
					#ifdef TERRAIN_SPLAT_ADDPASS
						color.rgb = MixFogColor(color.rgb, half3( 0, 0, 0 ), IN.fogFactorAndVertexLight.x );
					#else
						color.rgb = MixFog(color.rgb, IN.fogFactorAndVertexLight.x);
					#endif
				#endif
				
				#if _AlphaClip
					clip(Alpha - AlphaClipThreshold);
				#endif
				
				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				return color;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }

			ZWrite On
			ZTest LEqual

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define ASE_SRP_VERSION 999999

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex ShadowPassVertex
			#pragma fragment ShadowPassFragment


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			CBUFFER_START( UnityPerMaterial )
			float4 _Texture_ST;
			float4 _ColourHair;
			float4 _MaskHair_ST;
			float4 _ColourHair2;
			float4 _MaskHair2_ST;
			float4 _ColourSkin;
			float4 _MaskSkin_ST;
			float4 _ColourEyes;
			float4 _MaskEyes_ST;
			float4 _ColourMouth;
			float4 _MaskMouth_ST;
			float4 _ColourFaceHair;
			float4 _MaskFaceHair_ST;
			float4 _ColourUnderwearT;
			float4 _MaskUnderwearT_ST;
			float4 _ColourUnderwearB;
			float4 _MaskUnderwearB_ST;
			float _Smoothness;
			CBUFFER_END


			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			
			float3 _LightDirection;

			VertexOutput ShadowPassVertex( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld(v.vertex.xyz);
				float3 normalWS = TransformObjectToWorldDir(v.ase_normal);

				float4 clipPos = TransformWorldToHClip( ApplyShadowBias( positionWS, normalWS, _LightDirection ) );

				#if UNITY_REVERSED_Z
					clipPos.z = min(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
				#else
					clipPos.z = max(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
				#endif
				o.clipPos = clipPos;

				return o;
			}

			half4 ShadowPassFragment(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );

				
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				#if _AlphaClip
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				return 0;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			ZWrite On
			ColorMask 0

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define ASE_SRP_VERSION 999999

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			

			CBUFFER_START( UnityPerMaterial )
			float4 _Texture_ST;
			float4 _ColourHair;
			float4 _MaskHair_ST;
			float4 _ColourHair2;
			float4 _MaskHair2_ST;
			float4 _ColourSkin;
			float4 _MaskSkin_ST;
			float4 _ColourEyes;
			float4 _MaskEyes_ST;
			float4 _ColourMouth;
			float4 _MaskMouth_ST;
			float4 _ColourFaceHair;
			float4 _MaskFaceHair_ST;
			float4 _ColourUnderwearT;
			float4 _MaskUnderwearT_ST;
			float4 _ColourUnderwearB;
			float4 _MaskUnderwearB_ST;
			float _Smoothness;
			CBUFFER_END


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			
			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				o.clipPos = TransformObjectToHClip(v.vertex.xyz);
				return o;
			}

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				#if _AlphaClip
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				return 0;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Meta"
			Tags { "LightMode"="Meta" }

			Cull Off

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define ASE_SRP_VERSION 999999

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			

			sampler2D _Texture;
			sampler2D _MaskHair;
			sampler2D _MaskHair2;
			sampler2D _MaskSkin;
			sampler2D _MaskEyes;
			sampler2D _MaskMouth;
			sampler2D _MaskFaceHair;
			sampler2D _MaskUnderwearT;
			sampler2D _MaskUnderwearB;
			CBUFFER_START( UnityPerMaterial )
			float4 _Texture_ST;
			float4 _ColourHair;
			float4 _MaskHair_ST;
			float4 _ColourHair2;
			float4 _MaskHair2_ST;
			float4 _ColourSkin;
			float4 _MaskSkin_ST;
			float4 _ColourEyes;
			float4 _MaskEyes_ST;
			float4 _ColourMouth;
			float4 _MaskMouth_ST;
			float4 _ColourFaceHair;
			float4 _MaskFaceHair_ST;
			float4 _ColourUnderwearT;
			float4 _MaskUnderwearT_ST;
			float4 _ColourUnderwearB;
			float4 _MaskUnderwearB_ST;
			float _Smoothness;
			CBUFFER_END


			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			
			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				o.clipPos = MetaVertexPosition( v.vertex, v.texcoord1.xy, v.texcoord1.xy, unity_LightmapST, unity_DynamicLightmapST );
				return o;
			}

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float2 uv_Texture = IN.ase_texcoord.xy * _Texture_ST.xy + _Texture_ST.zw;
				float2 uv_MaskHair = IN.ase_texcoord.xy * _MaskHair_ST.xy + _MaskHair_ST.zw;
				float temp_output_25_0_g4 = 0.5;
				float temp_output_22_0_g4 = step( tex2D( _MaskHair, uv_MaskHair, float2( 0,0 ), float2( 0,0 ) ).r , temp_output_25_0_g4 );
				float4 lerpResult20 = lerp( tex2D( _Texture, uv_Texture, float2( 0,0 ), float2( 0,0 ) ) , _ColourHair , temp_output_22_0_g4);
				float2 uv_MaskHair2 = IN.ase_texcoord.xy * _MaskHair2_ST.xy + _MaskHair2_ST.zw;
				float temp_output_25_0_g33 = 0.5;
				float temp_output_22_0_g33 = step( tex2D( _MaskHair2, uv_MaskHair2, float2( 0,0 ), float2( 0,0 ) ).r , temp_output_25_0_g33 );
				float4 lerpResult113 = lerp( lerpResult20 , _ColourHair2 , temp_output_22_0_g33);
				float2 uv_MaskSkin = IN.ase_texcoord.xy * _MaskSkin_ST.xy + _MaskSkin_ST.zw;
				float temp_output_25_0_g34 = 0.5;
				float temp_output_22_0_g34 = step( tex2D( _MaskSkin, uv_MaskSkin, float2( 0,0 ), float2( 0,0 ) ).r , temp_output_25_0_g34 );
				float4 lerpResult117 = lerp( lerpResult113 , _ColourSkin , temp_output_22_0_g34);
				float2 uv_MaskEyes = IN.ase_texcoord.xy * _MaskEyes_ST.xy + _MaskEyes_ST.zw;
				float temp_output_25_0_g35 = 0.5;
				float temp_output_22_0_g35 = step( tex2D( _MaskEyes, uv_MaskEyes, float2( 0,0 ), float2( 0,0 ) ).r , temp_output_25_0_g35 );
				float4 lerpResult121 = lerp( lerpResult117 , _ColourEyes , temp_output_22_0_g35);
				float2 uv_MaskMouth = IN.ase_texcoord.xy * _MaskMouth_ST.xy + _MaskMouth_ST.zw;
				float temp_output_25_0_g37 = 0.5;
				float temp_output_22_0_g37 = step( tex2D( _MaskMouth, uv_MaskMouth, float2( 0,0 ), float2( 0,0 ) ).r , temp_output_25_0_g37 );
				float4 lerpResult129 = lerp( lerpResult121 , _ColourMouth , temp_output_22_0_g37);
				float2 uv_MaskFaceHair = IN.ase_texcoord.xy * _MaskFaceHair_ST.xy + _MaskFaceHair_ST.zw;
				float temp_output_25_0_g38 = 0.5;
				float temp_output_22_0_g38 = step( tex2D( _MaskFaceHair, uv_MaskFaceHair, float2( 0,0 ), float2( 0,0 ) ).r , temp_output_25_0_g38 );
				float4 lerpResult125 = lerp( lerpResult129 , _ColourFaceHair , temp_output_22_0_g38);
				float2 uv_MaskUnderwearT = IN.ase_texcoord.xy * _MaskUnderwearT_ST.xy + _MaskUnderwearT_ST.zw;
				float temp_output_25_0_g39 = 0.5;
				float temp_output_22_0_g39 = step( tex2D( _MaskUnderwearT, uv_MaskUnderwearT, float2( 0,0 ), float2( 0,0 ) ).r , temp_output_25_0_g39 );
				float4 lerpResult133 = lerp( lerpResult125 , _ColourUnderwearT , temp_output_22_0_g39);
				float2 uv_MaskUnderwearB = IN.ase_texcoord.xy * _MaskUnderwearB_ST.xy + _MaskUnderwearB_ST.zw;
				float temp_output_25_0_g40 = 0.5;
				float temp_output_22_0_g40 = step( tex2D( _MaskUnderwearB, uv_MaskUnderwearB, float2( 0,0 ), float2( 0,0 ) ).r , temp_output_25_0_g40 );
				float4 lerpResult137 = lerp( lerpResult133 , _ColourUnderwearB , temp_output_22_0_g40);
				
				
				float3 Albedo = lerpResult137.rgb;
				float3 Emission = 0;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				#if _AlphaClip
					clip(Alpha - AlphaClipThreshold);
				#endif

				MetaInput metaInput = (MetaInput)0;
				metaInput.Albedo = Albedo;
				metaInput.Emission = Emission;
				
				return MetaFragment(metaInput);
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Universal2D"
			Tags { "LightMode"="Universal2D" }

			Blend One Zero , One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define ASE_SRP_VERSION 999999

			#pragma enable_d3d11_debug_symbols
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			
			

			sampler2D _Texture;
			sampler2D _MaskHair;
			sampler2D _MaskHair2;
			sampler2D _MaskSkin;
			sampler2D _MaskEyes;
			sampler2D _MaskMouth;
			sampler2D _MaskFaceHair;
			sampler2D _MaskUnderwearT;
			sampler2D _MaskUnderwearB;
			CBUFFER_START( UnityPerMaterial )
			float4 _Texture_ST;
			float4 _ColourHair;
			float4 _MaskHair_ST;
			float4 _ColourHair2;
			float4 _MaskHair2_ST;
			float4 _ColourSkin;
			float4 _MaskSkin_ST;
			float4 _ColourEyes;
			float4 _MaskEyes_ST;
			float4 _ColourMouth;
			float4 _MaskMouth_ST;
			float4 _ColourFaceHair;
			float4 _MaskFaceHair_ST;
			float4 _ColourUnderwearT;
			float4 _MaskUnderwearT_ST;
			float4 _ColourUnderwearB;
			float4 _MaskUnderwearB_ST;
			float _Smoothness;
			CBUFFER_END


			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
			};

			
			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;

				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( v.vertex.xyz );
				o.clipPos = vertexInput.positionCS;
				return o;
			}

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				float2 uv_Texture = IN.ase_texcoord.xy * _Texture_ST.xy + _Texture_ST.zw;
				float2 uv_MaskHair = IN.ase_texcoord.xy * _MaskHair_ST.xy + _MaskHair_ST.zw;
				float temp_output_25_0_g4 = 0.5;
				float temp_output_22_0_g4 = step( tex2D( _MaskHair, uv_MaskHair, float2( 0,0 ), float2( 0,0 ) ).r , temp_output_25_0_g4 );
				float4 lerpResult20 = lerp( tex2D( _Texture, uv_Texture, float2( 0,0 ), float2( 0,0 ) ) , _ColourHair , temp_output_22_0_g4);
				float2 uv_MaskHair2 = IN.ase_texcoord.xy * _MaskHair2_ST.xy + _MaskHair2_ST.zw;
				float temp_output_25_0_g33 = 0.5;
				float temp_output_22_0_g33 = step( tex2D( _MaskHair2, uv_MaskHair2, float2( 0,0 ), float2( 0,0 ) ).r , temp_output_25_0_g33 );
				float4 lerpResult113 = lerp( lerpResult20 , _ColourHair2 , temp_output_22_0_g33);
				float2 uv_MaskSkin = IN.ase_texcoord.xy * _MaskSkin_ST.xy + _MaskSkin_ST.zw;
				float temp_output_25_0_g34 = 0.5;
				float temp_output_22_0_g34 = step( tex2D( _MaskSkin, uv_MaskSkin, float2( 0,0 ), float2( 0,0 ) ).r , temp_output_25_0_g34 );
				float4 lerpResult117 = lerp( lerpResult113 , _ColourSkin , temp_output_22_0_g34);
				float2 uv_MaskEyes = IN.ase_texcoord.xy * _MaskEyes_ST.xy + _MaskEyes_ST.zw;
				float temp_output_25_0_g35 = 0.5;
				float temp_output_22_0_g35 = step( tex2D( _MaskEyes, uv_MaskEyes, float2( 0,0 ), float2( 0,0 ) ).r , temp_output_25_0_g35 );
				float4 lerpResult121 = lerp( lerpResult117 , _ColourEyes , temp_output_22_0_g35);
				float2 uv_MaskMouth = IN.ase_texcoord.xy * _MaskMouth_ST.xy + _MaskMouth_ST.zw;
				float temp_output_25_0_g37 = 0.5;
				float temp_output_22_0_g37 = step( tex2D( _MaskMouth, uv_MaskMouth, float2( 0,0 ), float2( 0,0 ) ).r , temp_output_25_0_g37 );
				float4 lerpResult129 = lerp( lerpResult121 , _ColourMouth , temp_output_22_0_g37);
				float2 uv_MaskFaceHair = IN.ase_texcoord.xy * _MaskFaceHair_ST.xy + _MaskFaceHair_ST.zw;
				float temp_output_25_0_g38 = 0.5;
				float temp_output_22_0_g38 = step( tex2D( _MaskFaceHair, uv_MaskFaceHair, float2( 0,0 ), float2( 0,0 ) ).r , temp_output_25_0_g38 );
				float4 lerpResult125 = lerp( lerpResult129 , _ColourFaceHair , temp_output_22_0_g38);
				float2 uv_MaskUnderwearT = IN.ase_texcoord.xy * _MaskUnderwearT_ST.xy + _MaskUnderwearT_ST.zw;
				float temp_output_25_0_g39 = 0.5;
				float temp_output_22_0_g39 = step( tex2D( _MaskUnderwearT, uv_MaskUnderwearT, float2( 0,0 ), float2( 0,0 ) ).r , temp_output_25_0_g39 );
				float4 lerpResult133 = lerp( lerpResult125 , _ColourUnderwearT , temp_output_22_0_g39);
				float2 uv_MaskUnderwearB = IN.ase_texcoord.xy * _MaskUnderwearB_ST.xy + _MaskUnderwearB_ST.zw;
				float temp_output_25_0_g40 = 0.5;
				float temp_output_22_0_g40 = step( tex2D( _MaskUnderwearB, uv_MaskUnderwearB, float2( 0,0 ), float2( 0,0 ) ).r , temp_output_25_0_g40 );
				float4 lerpResult137 = lerp( lerpResult133 , _ColourUnderwearB , temp_output_22_0_g40);
				
				
				float3 Albedo = lerpResult137.rgb;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				half4 color = half4( Albedo, Alpha );

				#if _AlphaClip
					clip(Alpha - AlphaClipThreshold);
				#endif

				return color;
			}
			ENDHLSL
		}
		
	}
	CustomEditor "UnityEditor.ShaderGraph.PBRMasterGUI"
	Fallback "Hidden/InternalErrorShader"
	
}
/*ASEBEGIN
Version=17400
288;6;1426;810;2795.28;1776.296;3.213297;True;False
Node;AmplifyShaderEditor.SamplerNode;17;-1758.436,-614.0737;Inherit;True;Property;_MaskHair;_MaskHair;9;1;[HideInInspector];Create;True;0;0;False;0;-1;e5172f9561b5b104eab4a54421b0143e;e5172f9561b5b104eab4a54421b0143e;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;16;-1813.321,-1018.013;Inherit;True;Property;_Texture;Texture;17;1;[HideInInspector];Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;18;-1405.638,-633.4544;Inherit;False;MaskingFunction;-1;;4;571aab6f8c08f1c4d9bd4012d2958d88;0;3;21;FLOAT;0;False;30;FLOAT;0;False;25;FLOAT;0.5;False;3;FLOAT;0;FLOAT;32;FLOAT;28
Node;AmplifyShaderEditor.SamplerNode;116;-995.924,-612.8552;Inherit;True;Property;_MaskHair2;_MaskHair2;10;1;[HideInInspector];Create;True;0;0;False;0;-1;e5172f9561b5b104eab4a54421b0143e;8cad2dd697e20bc4baff714aba94e28a;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;19;-1720.038,-806.4643;Inherit;False;Property;_ColourHair;_ColourHair;1;0;Create;True;0;0;False;0;0.1981132,0.1777026,0.1579299,1;0.1981132,0.1777026,0.1579298,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;20;-1405.457,-800.7125;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;114;-643.126,-632.2359;Inherit;False;MaskingFunction;-1;;33;571aab6f8c08f1c4d9bd4012d2958d88;0;3;21;FLOAT;0;False;30;FLOAT;0;False;25;FLOAT;0.5;False;3;FLOAT;0;FLOAT;32;FLOAT;28
Node;AmplifyShaderEditor.SamplerNode;120;-242.5731,-615.4619;Inherit;True;Property;_MaskSkin;_MaskSkin;11;1;[HideInInspector];Create;True;0;0;False;0;-1;e5172f9561b5b104eab4a54421b0143e;cd95ab72febb22d498b296987e19de61;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;115;-957.526,-805.2458;Inherit;False;Property;_ColourHair2;_ColourHair2;2;0;Create;True;0;0;False;0;0.4433962,0.4011861,0.366011,1;0.4339623,0.3926502,0.3582236,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;119;-204.175,-807.8524;Inherit;False;Property;_ColourSkin;_ColourSkin;3;0;Create;True;0;0;False;0;0.9568628,0.8313726,0.7098039,1;0.9568627,0.8313726,0.7098039,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;118;110.225,-634.8425;Inherit;False;MaskingFunction;-1;;34;571aab6f8c08f1c4d9bd4012d2958d88;0;3;21;FLOAT;0;False;30;FLOAT;0;False;25;FLOAT;0.5;False;3;FLOAT;0;FLOAT;32;FLOAT;28
Node;AmplifyShaderEditor.LerpOp;113;-642.9451,-799.494;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;124;492.3159,-609.0864;Inherit;True;Property;_MaskEyes;_MaskEyes;12;1;[HideInInspector];Create;True;0;0;False;0;-1;e5172f9561b5b104eab4a54421b0143e;ecf37ecb20c1f394c8b8df51839238cf;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;117;110.4059,-802.1006;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;132;-1802.811,-135.2858;Inherit;True;Property;_MaskMouth;_MaskMouth;13;1;[HideInInspector];Create;True;0;0;False;0;-1;e5172f9561b5b104eab4a54421b0143e;2199534a39b1f0c47b03abe481897c9b;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;123;530.7141,-801.4769;Inherit;False;Property;_ColourEyes;_ColourEyes;4;0;Create;True;0;0;False;0;0,0,0,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;122;845.1138,-628.467;Inherit;False;MaskingFunction;-1;;35;571aab6f8c08f1c4d9bd4012d2958d88;0;3;21;FLOAT;0;False;30;FLOAT;0;False;25;FLOAT;0.5;False;3;FLOAT;0;FLOAT;32;FLOAT;28
Node;AmplifyShaderEditor.FunctionNode;130;-1450.013,-154.6665;Inherit;False;MaskingFunction;-1;;37;571aab6f8c08f1c4d9bd4012d2958d88;0;3;21;FLOAT;0;False;30;FLOAT;0;False;25;FLOAT;0.5;False;3;FLOAT;0;FLOAT;32;FLOAT;28
Node;AmplifyShaderEditor.LerpOp;121;845.2947,-795.725;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;128;-1018.592,-137.9087;Inherit;True;Property;_MaskFaceHair;_MaskFaceHair;14;1;[HideInInspector];Create;True;0;0;False;0;-1;e5172f9561b5b104eab4a54421b0143e;49324f1d0cccb24478f7cb28e2c18a31;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;131;-1764.413,-327.6763;Inherit;False;Property;_ColourMouth;_ColourMouth;5;0;Create;True;0;0;False;0;0.7735849,0.6679381,0.5655928,1;0.7735849,0.6679381,0.5655928,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;126;-665.7944,-155.885;Inherit;False;MaskingFunction;-1;;38;571aab6f8c08f1c4d9bd4012d2958d88;0;3;21;FLOAT;0;False;30;FLOAT;0;False;25;FLOAT;0.5;False;3;FLOAT;0;FLOAT;32;FLOAT;28
Node;AmplifyShaderEditor.ColorNode;127;-980.1941,-330.2992;Inherit;False;Property;_ColourFaceHair;_ColourFaceHair;6;0;Create;True;0;0;False;0;0.1981132,0.1777026,0.1579299,1;0.2735848,0.2334622,0.2000267,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;136;-263.7892,-135.9993;Inherit;True;Property;_MaskUnderwearT;_MaskUnderwearT;15;1;[HideInInspector];Create;True;0;0;False;0;-1;e5172f9561b5b104eab4a54421b0143e;c9c57f721fa8bde4c900bdc1c53bb38d;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;129;-1449.832,-321.9246;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;140;471.0998,-129.6238;Inherit;True;Property;_MaskUnderwearB;_MaskUnderwearB;16;1;[HideInInspector];Create;True;0;0;False;0;-1;e5172f9561b5b104eab4a54421b0143e;f142a77d7a6b5e244b454722cb385336;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;134;89.00893,-155.3799;Inherit;False;MaskingFunction;-1;;39;571aab6f8c08f1c4d9bd4012d2958d88;0;3;21;FLOAT;0;False;30;FLOAT;0;False;25;FLOAT;0.5;False;3;FLOAT;0;FLOAT;32;FLOAT;28
Node;AmplifyShaderEditor.ColorNode;135;-225.3911,-326.9854;Inherit;False;Property;_ColourUnderwearT;_ColourUnderwearT;7;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;125;-665.6133,-323.143;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;133;89.18984,-322.6379;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;139;509.4982,-322.0143;Inherit;False;Property;_ColourUnderwearB;_ColourUnderwearB;8;0;Create;True;0;0;False;0;0.1509434,0.1509434,0.1509434,1;0.1792453,0.1792453,0.1792453,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;138;823.8979,-149.0043;Inherit;False;MaskingFunction;-1;;40;571aab6f8c08f1c4d9bd4012d2958d88;0;3;21;FLOAT;0;False;30;FLOAT;0;False;25;FLOAT;0.5;False;3;FLOAT;0;FLOAT;32;FLOAT;28
Node;AmplifyShaderEditor.RangedFloatNode;21;1473.381,-674.362;Inherit;False;Property;_Smoothness;_Smoothness;0;0;Create;True;0;0;False;0;0.2;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;137;824.0788,-316.2624;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;141;1827.771,-617.4832;Float;False;True;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;2;Jims/URP/PlayerMasked;94348b07e5e8bab40bd6c8a1e3df54cd;True;Forward;0;0;Forward;12;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;True;1;1;False;-1;0;False;-1;1;1;False;-1;0;False;-1;False;False;False;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;12;Workflow;1;Surface;0;  Blend;0;Two Sided;1;Cast Shadows;1;Receive Shadows;1;GPU Instancing;1;LOD CrossFade;1;Built-in Fog;1;Meta Pass;1;Override Baked GI;0;Vertex Position,InvertActionOnDeselection;1;0;5;True;True;True;True;True;False;;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;142;1827.771,-617.4832;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ShadowCaster;0;1;ShadowCaster;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;143;1827.771,-617.4832;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthOnly;0;2;DepthOnly;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;False;True;False;False;False;False;0;False;-1;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;144;1827.771,-617.4832;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Meta;0;3;Meta;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;True;2;False;-1;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;145;1827.771,-617.4832;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Universal2D;0;4;Universal2D;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;True;1;1;False;-1;0;False;-1;1;1;False;-1;0;False;-1;False;False;False;True;True;True;True;True;0;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=Universal2D;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
WireConnection;18;21;17;0
WireConnection;20;0;16;0
WireConnection;20;1;19;0
WireConnection;20;2;18;32
WireConnection;114;21;116;0
WireConnection;118;21;120;0
WireConnection;113;0;20;0
WireConnection;113;1;115;0
WireConnection;113;2;114;32
WireConnection;117;0;113;0
WireConnection;117;1;119;0
WireConnection;117;2;118;32
WireConnection;122;21;124;0
WireConnection;130;21;132;0
WireConnection;121;0;117;0
WireConnection;121;1;123;0
WireConnection;121;2;122;32
WireConnection;126;21;128;0
WireConnection;129;0;121;0
WireConnection;129;1;131;0
WireConnection;129;2;130;32
WireConnection;134;21;136;0
WireConnection;125;0;129;0
WireConnection;125;1;127;0
WireConnection;125;2;126;32
WireConnection;133;0;125;0
WireConnection;133;1;135;0
WireConnection;133;2;134;32
WireConnection;138;21;140;0
WireConnection;137;0;133;0
WireConnection;137;1;139;0
WireConnection;137;2;138;32
WireConnection;141;0;137;0
WireConnection;141;3;21;0
WireConnection;141;4;21;0
ASEEND*/
//CHKSM=4BAA7C76AE7A1B764260C7C06587CE08108993F1