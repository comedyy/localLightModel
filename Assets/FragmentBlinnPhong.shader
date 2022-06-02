Shader "Unlit/FragmentBlinnPhong"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Embient ("Color", Color) = (0.1, 0.1, 0.1, 1)
        _DiffuseColor ("DiffuseColor", Color) = (0.1, 0.1, 0.1, 1)
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
                fixed3 lightDir:TEXCOORD0;
                fixed3 viewDir:TEXCOORD1;
                fixed3 normal:TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Embient;
            float4 _DiffuseColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.a = UnityObjectToClipPos(v.vertex);
                float3 lightDir = normalize(ObjSpaceLightDir(v.vertex));
                float3 viewDir = normalize(ObjSpaceViewDir(v.vertex));

                o.lightDir = lightDir;
                o.viewDir = viewDir;
                o.normal = v.normal;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 diffuse = _DiffuseColor * dot(i.normal, i.lightDir);
                float3 h = normalize(i.viewDir + i.lightDir);
                float specular = pow(dot(h, i.normal), 200);

                return diffuse + _Embient + specular; 
            }
            ENDCG
        }
    }
}
