Shader "Hidden/FluidRendererShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 viewVector : TEXCOORD1;
            };

            v2f vert(appdata v)
            {
                v2f output;
                output.pos = UnityObjectToClipPos(v.vertex);
                output.uv = v.uv;
			    // Camera space matches OpenGL convention where cam forward is -z. In unity forward is positive z.
				// (https://docs.unity3d.com/ScriptReference/Camera-cameraToWorldMatrix.html)
                float3 viewVector = mul(unity_CameraInvProjection, float4(v.uv.xy * 2 - 1, 0, -1));
                output.viewVector = mul(unity_CameraToWorld, float4(viewVector, 0));
                return output;
            }
            
            
            // Returns (dstToBox, dstInsideBox). If ray misses box, dstInsideBox will be zero.
            float2 rayBoxDst(float3 boundsMin, float3 boundsMax, float3 rayOrigin, float3 rayDir)
            {
                float3 t0 = (boundsMin - rayOrigin) / rayDir;
                float3 t1 = (boundsMax - rayOrigin) / rayDir;
                float3 tmin = min(t0, t1);
                float3 tmax = max(t0, t1);
                
                float dstA = max(max(tmin.x, tmin.y), tmin.z);
                float dstB = min(tmax.x, min(tmax.y, tmax.z));
                
                            // CASE 1: ray intersects box from outside (0 <= dstA <= dstB)
                            // dstA is dst to nearest intersection, dstB is dst to far intersection
                
                            // CASE 2: ray intersects box from inside (dstA < 0 < dstB)
                            // dstA is the dst to intersection behind ray origin, dstB is dst to forward intersection
                
                            // CASE 3: ray misses box (dstA > dstB)
                
                float dstToBox = max(0, dstA);
                float dstInsideBox = max(0, dstB - dstToBox);
                return float2(dstToBox, dstInsideBox);
            }
            
            // Fluid Properties
            float3 ColorReflection;
            float DensityMultiplier;
            
            float sampleDensity(float3 worldPos) {
                return 1 * DensityMultiplier;
            }
            
            // Renderer Properties
            int inScatteringSteps;
            
            float3 calculateLight(float3 originalCol, float3 rayOrigin, float3 rayDir, float dstToFluid, float dstInsideFluid) {
                if (dstInsideFluid <= 0) return originalCol;
                
                float dstTravelled = 0;
                float stepSize = dstInsideFluid / inScatteringSteps;
                
                float3 transmittance = 1;
                float3 inScatteredLight = 0;
                for (int i = 0; i < inScatteringSteps; i++) {
                    dstTravelled += stepSize;
                    float3 samplePoint = rayOrigin + rayDir * (dstToFluid + dstTravelled);
                    float densityAlongStep = sampleDensity(samplePoint) * stepSize;
                    
                    transmittance *= exp(-densityAlongStep) * pow(ColorReflection, densityAlongStep);
                }
                
                return inScatteredLight + originalCol * transmittance;
            }

            
            sampler2D _MainTex;
            sampler2D _CameraDepthTexture;
            
            // Container Properties
            float3 BoundsMin;
            float3 BoundsMax;

            float4 frag (v2f i) : SV_Target
            {
                float4 col = tex2D(_MainTex, i.uv);
                float3 rayOrigin = _WorldSpaceCameraPos;
                float3 rayDir = normalize(i.viewVector);
                
                float nonLinearDepth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv);
                float depth = LinearEyeDepth(nonLinearDepth) * length(i.viewVector);
                
                float2 rayBoxInfo = rayBoxDst(BoundsMin, BoundsMax, rayOrigin, rayDir);
                
                float dstLimit = min(depth - rayBoxInfo.x, rayBoxInfo.y);
                
                return float4(calculateLight(col.rgb, rayOrigin, rayDir, rayBoxInfo.x, dstLimit), 1);
            }
            ENDCG
        }
    }
}
