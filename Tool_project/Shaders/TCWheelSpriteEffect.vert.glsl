attribute vec3 kzPosition;
attribute vec2 kzTextureCoordinate0;

uniform highp mat4 kzProjectionCameraWorldMatrix;

uniform mediump vec2 TextureTiling;
uniform mediump vec2 TextureOffset;

varying vec2 vTexCoord;

void main()
{
    precision mediump float;
    vTexCoord = kzTextureCoordinate0 * TextureTiling + TextureOffset;
    gl_Position = kzProjectionCameraWorldMatrix * vec4(kzPosition.xyz, 1.0);
}