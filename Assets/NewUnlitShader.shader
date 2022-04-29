Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                fixed3 normal : NORMAL;
            };

            struct v2f
            {
                float4 a : SV_POSITION;
                fixed3 luminance:TEXCOORD0;
                fixed3 bb:TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.a = UnityObjectToClipPos(v.vertex);
                float3 lightDir = normalize(ObjSpaceLightDir(v.vertex));
                float luminance = dot(v.normal, lightDir);
                o.luminance = luminance;
                float3 reflectDir = 2 * dot(lightDir, v.normal) * v.normal - lightDir;
                float3 viewDir = normalize(ObjSpaceViewDir(v.vertex));
                float x = pow(dot(reflectDir, viewDir), 3);
                o.bb = x;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return float4(i.luminance + i.bb, 1);
            }
            ENDCG
        }
    }
}
