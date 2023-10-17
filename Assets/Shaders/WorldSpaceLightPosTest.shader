Shader "Hidden/WorldSpaceLightPosTest"
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

            sampler2D _MainTex;

            float4 frag (v2f i) : SV_Target
            {
                float3 viewDir = normalize(i.viewVector);
                bool isDirectionalLight = _WorldSpaceLightPos0.w == 0;
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                if (!isDirectionalLight) lightDir = normalize(lightDir - _WorldSpaceCameraPos);
                return dot(viewDir, lightDir);
            }
            ENDCG
        }
    }
}
